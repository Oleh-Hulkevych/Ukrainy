//
//  AuthService.swift
//  Ukrainy
//
//  Created by Hulkevych on 16.11.2022.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

let DB_BASE = Firestore.firestore()

class AuthService {
    
    // MARK: - Properties
    
    static let instance = AuthService()
    private var REF_USERS = DB_BASE.collection("users")
    
    // MARK: - Methods
    
    func signInUserToFirebase(credential: AuthCredential, handler: @escaping (_ providerID: String?, _ isError: Bool, _ isNewUser: Bool?, _ userID: String?) -> ()) {
        
        Auth.auth().signIn(with: credential) { (result, error) in
            
            if error != nil {
                print("📕: Error signing in to Firebase!")
                handler(nil, true, nil, nil)
                return
            }
            
            guard let providerID = result?.user.uid else {
                print("📕: Error getting provider ID!")
                handler(nil, true, nil, nil)
                return
            }
            
            self.checkIfUserExistsInDatabase(providerID: providerID) { (returnedUserID) in
                
                if let userID = returnedUserID {
                    handler(providerID, false, false, userID)
                    print("📘: The same user is back!")
                } else {
                    handler(providerID, false, true, nil)
                    print("📗: We have new user!")
                }
            }
        }
    }
    
    func signInUserToApp(userID: String, handler: @escaping (_ success: Bool) -> ()) {
        
        getUserInfo(forUserID: userID) { (returnedName, returnedBio) in
            if let name = returnedName, let bio = returnedBio {
                print("📗: Success getting user info while signing in!")
                handler(true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    UserDefaults.standard.set(userID, forKey: CurrentUserDefaults.userID)
                    UserDefaults.standard.set(bio, forKey: CurrentUserDefaults.bio)
                    UserDefaults.standard.set(name, forKey: CurrentUserDefaults.displayName)
                }
            } else {
                print("📕: Error getting user info while signing in!")
                handler(false)
            }
        }
    }
    
    func signOutUser(handler: @escaping (_ success: Bool) -> ()) {
        
        do {
            try Auth.auth().signOut()
        } catch {
            print("📕: Error - \(error.localizedDescription)")
            handler(false)
            return
        }
        
        handler(true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let defaultsDictionary = UserDefaults.standard.dictionaryRepresentation()
            defaultsDictionary.keys.forEach { (key) in
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
    }
    
    func createNewUserInDatabase(name: String, email: String, providerID: String, provider: String, profileImage: UIImage, handler: @escaping (_ userID: String?) -> ()) {

        let document = REF_USERS.document()
        let userID = document.documentID

        ImageManager.instance.uploadProfileImage(userID: userID, image: profileImage)

        let userData: [String: Any] = [
            DatabaseUserField.displayName : name,
            DatabaseUserField.email : email,
            DatabaseUserField.providerID : providerID,
            DatabaseUserField.provider : provider,
            DatabaseUserField.userID : userID,
            DatabaseUserField.bio : "",
            DatabaseUserField.dateCreated : FieldValue.serverTimestamp(),
        ]
        
        document.setData(userData) { (error) in
            
            if let error = error {
                print("📕: Error uploading data to user document. Description: \(error.localizedDescription)")
                handler(nil)
            } else {
                handler(userID)
            }
        }
    }
    
    private func checkIfUserExistsInDatabase(providerID: String, handler: @escaping (_ existingUserID: String?) -> ()) {
        
        REF_USERS.whereField(DatabaseUserField.providerID, isEqualTo: providerID).getDocuments { (querySnapshot, error) in
            
            if let snapshot = querySnapshot, snapshot.count > 0, let document = snapshot.documents.first {
                let existingUserID = document.documentID
                handler(existingUserID)
                return
            } else {
                handler(nil)
                return
            }
        }
    }
    
    // MARK: - Get user methods
    
    func getUserInfo(forUserID userID: String, handler: @escaping (_ name: String?, _ bio: String?) -> ()) {
        
        REF_USERS.document(userID).getDocument { (documentSnapshot, error) in
            if let document = documentSnapshot,
               let name = document.get(DatabaseUserField.displayName) as? String,
               let bio = document.get(DatabaseUserField.bio) as? String {
                print("📗: Success getting user info!")
                handler(name, bio)
                return
            } else {
                print("📕: Error getting user info!")
                handler(nil, nil)
                return
            }
        }
    }
    
    // MARK: - Update user methods
    
    func updateUserDisplayName(userID: String, displayName: String, handler: @escaping (_ success: Bool) -> ()) {
        
        let data: [String:Any] = [
            DatabaseUserField.displayName : displayName
        ]
        
        REF_USERS.document(userID).updateData(data) { (error) in
            if let error = error {
                print("📕: Error updating user display name. Description: \(error.localizedDescription)")
                handler(false)
                return
            } else {
                print("📗: User display name updated!")
                handler(true)
                return
            }
        }
    }
    
    func updateUserBio(userID: String, bio: String, handler: @escaping (_ success: Bool) -> ()) {
        
        let data: [String:Any] = [
            DatabaseUserField.bio : bio
        ]
        
        REF_USERS.document(userID).updateData(data) { (error) in
            if let error = error {
                print("📕: Error updating user bio. Description: \(error.localizedDescription)")
                handler(false)
                return
            } else {
                print("📗: User bio updated!")
                handler(true)
                return
            }
        }
    }
}
