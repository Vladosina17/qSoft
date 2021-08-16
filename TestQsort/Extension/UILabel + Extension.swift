//
//  UILabel + Extension.swift
//  TestQsort
//
//  Created by Влад Барченков on 16.08.2021.
//

import UIKit

extension UILabel {
    
    convenience init(fontSize: CGFloat, color: UIColor) {
        self.init()
        
        self.font = UIFont.systemFont(ofSize: fontSize)
        self.textColor = color
        self.textAlignment = .left
    }
}
