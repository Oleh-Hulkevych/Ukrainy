//
//  ImageManager.swift
//  Ukrainy
//
//  Created by Hulkevych on 17.11.2022.
//

import Foundation
import FirebaseStorage

// Global
let imageCache = NSCache<AnyObject, UIImage>()

final class ImageManager {

    // MARK: - Properties
    
    static let instance = ImageManager()
    private var REF_STOR = Storage.storage()
    
    // MARK: - Upload image methods
    
    func uploadProfileImage(userID: String, image: UIImage) {
        
        let path = getProfileImagePath(userID: userID)
        
        DispatchQueue.global(qos: .userInteractive).async {
            self.uploadImage(path: path, image: image) { (_) in }
        }
    }
    
    func uploadPostImage(postID: String, image: UIImage, handler: @escaping (_ success: Bool) -> ()) {
        
        let path = getPostImagePath(postID: postID)
        
        DispatchQueue.global(qos: .userInteractive).async {
            self.uploadImage(path: path, image: image) { (success) in
                DispatchQueue.main.async {
                    handler(success)
                }
            }
        }
    }
    
    // MARK: - Download image methods
    
    func downloadProfileImage(userID: String, handler: @escaping (_ image: UIImage?) -> ()) {
        
        let path = getProfileImagePath(userID: userID)
        
        DispatchQueue.global(qos: .userInteractive).async {
            self.downloadImage(path: path) { (returnedImage) in
                DispatchQueue.main.async {
                    handler(returnedImage)
                }
            }
        }
    }
    
    func downloadPostImage(postID: String, handler: @escaping (_ image: UIImage?) -> ()) {
        
        let path = getPostImagePath(postID: postID)
        
        DispatchQueue.global(qos: .userInteractive).async {
            self.downloadImage(path: path) { (returnedImage) in
                DispatchQueue.main.async {
                    handler(returnedImage)
                }
            }
        }
    }
    
    // MARK: - Private methods
    
    private func getProfileImagePath(userID: String) -> StorageReference {
        let userPath = "users/\(userID)/profile"
        let storagePath = REF_STOR.reference(withPath: userPath)
        return storagePath
    }
    
    private func getPostImagePath(postID: String) -> StorageReference {
        let postPath = "posts/\(postID)/1"
        let storagePath = REF_STOR.reference(withPath: postPath)
        return storagePath
    }
    
    private func uploadImage(path: StorageReference, image: UIImage, handler: @escaping (_ success: Bool) -> ()) {
        
        var compression: CGFloat = 1.0
        let maxFileSize: Int = 1024 * 1024
        let maxCompression: CGFloat = 0.05

        guard var originalData = image.jpegData(compressionQuality: compression) else {
            print("📕: Error getting image data!")
            handler(false)
            return
        }

        while (originalData.count > maxFileSize) && (compression > maxCompression) {
            compression -= 0.05
            if let compressedData = image.jpegData(compressionQuality: compression) {
                originalData = compressedData
            }
            print(compression)
        }

        guard let finalData = image.jpegData(compressionQuality: compression) else {
            print("📕: Error getting data from image!")
            handler(false)
            return
        }

        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        path.putData(finalData, metadata: metadata) { (_, error) in
            
            if let error = error {
                print("📕: Error uploading image! Description: \(error.localizedDescription)")
                handler(false)
                return
            } else {
                print("📗: Success uploading image!")
                handler(true)
                return
            }
        }
    }

    private func downloadImage(path: StorageReference, handler: @escaping (_ image: UIImage?) -> ()) {
        
        if let cachedImage = imageCache.object(forKey: path) {
            print("📗: Image found in cache!")
            handler(cachedImage)
            return
        } else {
            path.getData(maxSize: 27 * 1024 * 1024) { (returnedImageData, error) in
                
                if let data = returnedImageData, let image = UIImage(data: data) {
                    imageCache.setObject(image, forKey: path)
                    handler(image)
                    return
                } else {
                    print("📕: Error getting data from path for image: \(error?.localizedDescription ?? "")")
                    handler(nil)
                    return
                }
            }
        }
    }
}
