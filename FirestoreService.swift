//
//  FirestoreService.swift
//  SushiOrder
//
//  Created by ПавелК on 02.05.2022.
//

import Foundation
import FirebaseFirestore
import UIKit

final class FirestoreService {
    
    static let shared = FirestoreService()
    private let db = Firestore.firestore()
    private var usersRef : CollectionReference {
        return db.collection("User")
    }
    private var goodsRef : CollectionReference {
        return db.collection("Goods")
    }
    private var ordersRef : CollectionReference {
        return db.collection("Orders")
    }
    private init() {}
    
    // MARK: Get Position from DB
    func getPositions (by orderId : String, completion : @escaping (Result < [Position], Error >) -> ()) {
        let positionRef = ordersRef.document(orderId).collection("Positions")
        positionRef.getDocuments { qsnap, error in
            guard let qsnap = qsnap else { return }
            var positions = [Position]()
            for doc in qsnap.documents {
                guard  let position = Position(doc: doc) else {
                    guard let error = error else { return }
                    completion(.failure(error))
                    return
                }
                positions.append(position)
            }
            completion(.success(positions))
        }
    }
    // MARK: Get orders from DB
    func getOrders (by userId : String?, completion : @escaping (Result < [Order], Error >) -> ()) {
        ordersRef.getDocuments { qsnap, error in
            var orders = [Order]()
            guard let qsnap = qsnap else { return }
            for doc in qsnap.documents {
                if userId != nil {
                    if let order = Order(doc: doc), order.clientId == AuthService.shared.currentUser?.uid {
                        orders.append(order)
                    }
                } else {
                    guard let order = Order(doc: doc) else  { return }
                    orders.append(order)
                }
                completion(.success(orders))
            }
        }
    }
    // MARK: Send order from UI to DB
    func send(order : Order, completion : @escaping (Result < Order, Error >) -> Void) {
        let orderRef = ordersRef.document(order.id)
        let positionsRef : CollectionReference = orderRef.collection("Positions")
        orderRef.setData(["id": order.id,
                          "date" : order.date,
                          "clientId" : order.clientId,
                          "status" : order.status,
                          "cost": order.cost]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                for position in order.positions {
                    positionsRef.document(position.id).setData(["id" : position.id,
                                                                "title" : position.title,
                                                                "price" : position.price,
                                                                "count" : position.count]) { error in
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            completion(.success(order))
                        }
                    }
                }
            }
        }
    }
    
    // MARK: Send new goods from Admin Interface to DB
    func saveGoods (goods : Goods, completion : @escaping (Result < Goods,Error >) -> Void) {
        goodsRef.document(goods.id).setData(["id" : goods.id,
                                             "title" : goods.title,
                                             "price" : goods.price,
                                             "description" : goods.description,
                                             "imageUrl" : goods.imageTitle,
                                             "category" : goods.category]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(goods))
            }
        }
    }
    
    
    
    //MARK: - Get goods from DB to UI
    func getGoods (completion : @escaping (Result < [Goods],Error >) -> Void) -> Void {
        goodsRef.getDocuments { querySnapshot, error in
            if let qsnap = querySnapshot {
                var goods = [Goods]()
                for doc in qsnap.documents {
                    if let good = Goods(doc: doc) {
                        goods.append(good)
                    }
                }
                completion(.success(goods))
                print(goods.count)
            }
        }
    }
    
    //MARK: Save profile from UI to DB
    func saveProfile (id : String, name : String?, phone : String?, imageUrl : String?, adress : String?, completion : @escaping (Result<CustomUser, Error>) -> Void) {
        
        let phone = Int(phone ?? "0")
        let customUser = CustomUser(userName: name ?? "", imageUrl: imageUrl ?? "Not Found", id: id, phoneNumber: phone ?? 0, adress: adress ?? "")
        
        self.usersRef.document(id).setData(customUser.representation) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(customUser))
            }
        }
    }
    
    
    //MARK: Get profile from DB to UI
    func getProfile (userId : String, completion : @escaping (Result <CustomUser, Error> ) -> Void) {
        let docRef = usersRef.document(userId)
        
        docRef.getDocument { snapshot, error in
            if let snap = snapshot, snap.exists {
                guard let customUser = CustomUser(doc: snap) else {
                    guard let error = error else { return}
                    completion(.failure(error))
                    return
                }
                completion(.success(customUser))
            } else {
                guard let error = error else { return}
                completion(.failure(error))
            }
        }
    }
}






