//
//  PagingDataModel.swift
//  TestQsort
//
//  Created by Влад Барченков on 16.08.2021.
//

import Foundation
import ObjectMapper

struct PagingData: Codable {
    var cursors: CursorData
    var next: String?
}


struct PagingData2: Mappable {
    var cursors: CursorData2?
    var next: String?
    
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        cursors <- map["cursors"]
        next <- map["next"]
    }
}
