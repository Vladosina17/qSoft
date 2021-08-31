//
//  InstagramMediaModel.swift
//  TestQsort
//
//  Created by Влад Барченков on 16.08.2021.
//

import Foundation
import ObjectMapper

struct InstagramMedia: Codable {
    var id: String
    var media_type: MediaType
    var media_url: String
    var username: String
    var timestamp: String
    var caption: String?
}

struct InstagramMedia2: Mappable {
    
    var id: String?
    var media_url: String?
    var username: String?
    var timestamp: String?
    var caption: String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        media_url <- map["media_url"]
        username <- map["username"]
        timestamp <- map["timestamp"]
        caption <- map["caption"]
    }
    
    
}
