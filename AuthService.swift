//
//  AuthService.swift
//  SushiOrder
//
//  Created by ПавелК on 24.04.2022.
//

import Foundation
import FirebaseAuth

final class AuthService {
    
    static let shared = AuthService()
    let auth = Auth.auth()
    var currentUser : User? {
        return auth.currentUser
    }
    
    private init () {}
    
    // MARK: - LogIn
    func logIn (email : String?, password : String?, completion : @escaping (Result <User, Error>) -> Void) {
        guard let email = email, let password = password else { return }
        auth.signIn(withEmail: email, password: password) { result, error in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
    }
    
    // MARK: - SignOut
    func signOut () {
        try! auth.signOut()
    }
    
    // MARK: - Registration
    func registration (email : String?, password : String?, confirm : String?, completion : @escaping (Result<User, Error>) -> ()) {
        guard let email = email, let password = password, let confirm = confirm else { return }
        
        guard password == confirm else { return }
        auth.createUser(withEmail: email, password: password) { result, error in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
    }
}
