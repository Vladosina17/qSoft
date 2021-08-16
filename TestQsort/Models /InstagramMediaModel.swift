//
//  InstagramMediaModel.swift
//  TestQsort
//
//  Created by Влад Барченков on 16.08.2021.
//

import Foundation

struct InstagramMedia: Codable {
    var id: String
    var media_type: MediaType
    var media_url: String
    var username: String
    var timestamp: String
    var caption: String?
}
