//
//  StorageService.swift
//  SushiOrder
//
//  Created by ПавелК on 30.05.2022.
//

import Foundation
import FirebaseStorage
import UIKit

class StorageService {
    
    static let shared = StorageService()
    let storageRef = Storage.storage().reference()
    private var avatarsRef : StorageReference {
        return storageRef.child("avatars")
    }
    
    private init () {}
    
    // MARK: Download picture from DB
    func downloadGoodsPic (title : String, completion : @escaping (Result < Data, Error >) -> Void) {
        let fileRef = storageRef.child("Goods/\(title)")
        fileRef.getData(maxSize: 4 * 1024 * 1024) { data, error in
            guard let data = data else {
                completion(.failure(error!))
                return
            }
            completion(.success(data))
        }
    }
    
    // MARK: Download avatarImage from DB
    func downloadPhoto (url : String, completion : @escaping (Result < Data, Error >) -> Void) {
        let fileRef = storageRef.child("avatars/\(AuthService.shared.currentUser!.uid)")
        fileRef.getData(maxSize: 3 * 1024 * 1024) { data, error in
            guard let data = data else {
                completion(.failure(error!))
                return
            }
            completion(.success(data))
        }
    }
    // MARK: Upload picture with Admin Interface from device to DB
    func uploadGoodsPic (photo : UIImage, goodsId : String, completion : @escaping (Result < URL, Error >) -> Void) {
        guard let imageData = photo.jpegData(compressionQuality: 0.4) else { return }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        let goodsRef = storageRef.child("Goods")
        
        goodsRef.child(goodsId).putData(imageData,metadata: metadata) { metadata, error in
            guard let _ = metadata else {
                completion(.failure(error!))
                return
            }
            goodsRef.child(goodsId).downloadURL { url, error in
                guard let url = url else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(url))
            }
        }
    }
    
    
    // MARK: Upload picture with Admin Interface from device to DB
    func uploadPhoto (photo : UIImage, completion : @escaping (Result < URL, Error >) -> Void) {
        guard let imageData = photo.jpegData(compressionQuality: 0.4) else { return }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        guard let user = AuthService.shared.currentUser else { return }
        avatarsRef.child(user.uid).putData(imageData,metadata: metadata) { metadata, error in
            guard let _ = metadata else {
                guard let error = error else { return }
                return completion(.failure(error))
            }
            self.avatarsRef.child(user.uid).downloadURL { url, error in
                guard let url = url else {
                    return completion(.failure(error!))
                }
                completion(.success(url))
            }
        }
    }
}
