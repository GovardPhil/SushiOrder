//
//  CustomUser.swift
//  SushiOrder
//
//  Created by ПавелК on 01.05.2022.
//

import Foundation
import FirebaseFirestore

struct CustomUser : Hashable, Decodable {
    var userName : String
    var imageUrl : String
    var id : String
    var phoneNumber : Int
    var adress : String
    var orders = [Order]()
    
    var representation : [String : Any] {
        let repr : [String : Any] = ["userName" : userName, "imageUrl" : imageUrl, "id" : id, "phoneNumber" : phoneNumber, "adress" : adress]
        return repr
    }
    
    init(userName : String, imageUrl : String, id : String, phoneNumber : Int, adress : String) {
        self.userName = userName
        self.imageUrl = imageUrl
        self.phoneNumber = phoneNumber
        self.id = id
        self.adress = adress
    }
    
    init?(doc: DocumentSnapshot ) {
        guard let data = doc.data() else { return nil }
        guard let userName = data["userName"] as? String else { return nil }
        guard let imageUrl = data["imageUrl"] as? String else { return nil }
        guard let id = data["id"] as? String else { return nil }
        guard let phoneNumber = data["phoneNumber"] as? Int else { return nil }
        guard let adress = data["adress"] as? String else { return nil }
        
        self.id = id
        self.userName = userName
        self.phoneNumber = phoneNumber
        self.imageUrl = imageUrl
        self.adress = adress
    }
}

