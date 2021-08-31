//
//  FeedModel.swift
//  TestQsort
//
//  Created by Влад Барченков on 16.08.2021.
//

import Foundation
import ObjectMapper

struct Feed: Mappable {
    
    var data: [MediaData]?
    var paging: PagingData?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        data <- map["data"]
        paging <- map["paging"]
    }
}
