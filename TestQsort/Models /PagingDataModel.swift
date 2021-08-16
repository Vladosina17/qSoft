//
//  PagingDataModel.swift
//  TestQsort
//
//  Created by Влад Барченков on 16.08.2021.
//

import Foundation

struct PagingData: Codable {
    var cursors: CursorData
    var next: String?
}
