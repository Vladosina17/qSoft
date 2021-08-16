//
//  FeedModel.swift
//  TestQsort
//
//  Created by Влад Барченков on 16.08.2021.
//

import Foundation

struct Feed: Codable {
    var data: [MediaData]
    var paging: PagingData
}
