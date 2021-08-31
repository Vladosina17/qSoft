//
//  InstagramUserModel.swift
//  TestQsort
//
//  Created by Влад Барченков on 16.08.2021.
//

import Foundation
import ObjectMapper

struct InstagramUser: Codable {
    var id: String
    var username: String
}


struct InstagramUser2: Mappable {
    var id: String?
    var username: String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        username <- map["username"]
    }
}
