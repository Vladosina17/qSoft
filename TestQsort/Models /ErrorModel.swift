//
//  ErrorModel.swift
//  TestQsort
//
//  Created by Влад Барченков on 25.08.2021.
//

import Foundation


struct ErrorModel: Codable {
    var error: Errror
}

struct Errror: Codable {
    var message: String
    var type: String
    var code: Int
    var fbtrace_id: String
}
