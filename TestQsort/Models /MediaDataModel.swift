//
//  MediaDataModel.swift
//  TestQsort
//
//  Created by Влад Барченков on 16.08.2021.
//

import Foundation
import ObjectMapper

struct MediaData: Mappable {

    var id: String?
    var caption: String?
    var media_type: String?
    var media_url: String?
    var timestamp: String?

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        id <- map["id"]
        caption <- map["caption"]
        media_type <- map["media_type"]
        media_url <- map["media_url"]
        timestamp <- map["timestamp"]

    }
}
