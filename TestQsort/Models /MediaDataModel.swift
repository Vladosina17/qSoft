//
//  MediaDataModel.swift
//  TestQsort
//
//  Created by Влад Барченков on 16.08.2021.
//

import Foundation

struct MediaData: Codable {
    var id: String
    var caption: String?
    var media_type: String
    var media_url: String
    var timestamp: String
}
