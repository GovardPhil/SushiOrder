//
//  Goods.swift
//  SushiOrder
//
//  Created by ПавелК on 03.02.2022.
//

import Foundation
import FirebaseFirestore

struct Goods {
    
    let id : String
    let title : String
    let price : Int
    let description : String
    let imageTitle : String
    var category : String
    
    init? (doc : QueryDocumentSnapshot) {
        
        let data = doc.data()
        
        guard let id = data["id"] as? String else { return nil }
        guard let title = data["title"] as? String else { return nil }
        guard let price = data["price"] as? Int else { return nil }
        guard let description = data["description"] as? String else { return nil }
        guard let imageTitle = data["imageUrl"] as? String else { return nil }
        guard let category = data["category"] as? String else { return nil }
        
        self.id = id
        self.category = category
        self.title = title
        self.price = price
        self.description = description
        self.imageTitle = imageTitle
    }
    
    init (id: String,
          title: String,
          price: Int,
          description: String,
          imageTitle: String,
          category : String) {
        
        self.id = id
        self.title = title
        self.price = price
        self.description = description
        self.imageTitle = imageTitle
        self.category = category
    }
}


