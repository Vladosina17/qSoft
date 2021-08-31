//
//  CursorDataModel.swift
//  TestQsort
//
//  Created by Влад Барченков on 16.08.2021.
//

import Foundation
import ObjectMapper

struct CursorData: Codable {
    var before: String
    var after: String
}


struct CursorData2: Mappable {
    var before: String?
    var after: String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        before <- map["before"]
        after <- map["after"]
    }
}
