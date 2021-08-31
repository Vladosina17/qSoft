//
//  InstagramTestUser.swift
//  TestQsort
//
//  Created by Влад Барченков on 16.08.2021.
//

import Foundation
import ObjectMapper

struct InstagramTestUser: Mappable  {
    
    var access_token: String?
    var user_id: Int?
    
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        access_token <- map["access_token"]
        user_id <- map["user_id"]
    }
    
}
