//
//  FormatDate.swift
//  TestQsort
//
//  Created by Влад Барченков on 24.08.2021.
//

import Foundation


class FormatDate {
    
    static func dateFormater(stringDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let date = dateFormatter.date(from: stringDate) else { return "" }
        dateFormatter.dateFormat = "dd MMMM yyyy"
        let timeStemp = dateFormatter.string(from: date)
        return timeStemp
    }
    
}
