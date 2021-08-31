//
//  MediaDataModel.swift
//  TestQsort
//
//  Created by Влад Барченков on 16.08.2021.
//

import Foundation
import ObjectMapper

struct MediaData: Codable {

    var id: String
    var caption: String?
    var media_type: String
    var media_url: String
    var timestamp: String

}

struct MediaData2: Mappable {

    var id: String?
    var caption: String?
    var media_type: String?
    var media_url: String?
    var timestamp: String?

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        id <- map["id"]
        caption <- map["id"]
        media_type <- map["id"]
        media_url <- map["id"]
        timestamp <- map["id"]

    }
}
