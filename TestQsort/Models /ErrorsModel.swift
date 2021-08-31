//
//  ErrorModel.swift
//  TestQsort
//
//  Created by Влад Барченков on 25.08.2021.
//

import Foundation
import ObjectMapper

struct ErrorsModel: Mappable {
    var error: ErrorModel?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        error <- map["error"]
    }
}

struct ErrorModel: Mappable {
    var message: String?
    var type: String?
    var code: Int?
    var fbtrace_id: String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        message <- map["message"]
        type <- map["type"]
        code <- map["code"]
        fbtrace_id <- map["fbtrace_id"]
    }
}
