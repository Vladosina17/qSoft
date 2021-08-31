//
//  FeedModel.swift
//  TestQsort
//
//  Created by Влад Барченков on 16.08.2021.
//

import Foundation
import ObjectMapper

struct Feed: Codable {
    var data: [MediaData]
    var paging: PagingData
}


struct Feed2: Mappable {
    
    var data: [MediaData2]?
    var paging: PagingData2?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        data <- map["data"]
        paging <- map["paging"]
    }
}
