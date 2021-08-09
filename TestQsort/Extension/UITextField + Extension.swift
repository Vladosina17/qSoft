//
//  UITextField + Extension.swift
//  TestQsort
//
//  Created by Влад Барченков on 09.08.2021.
//

import UIKit

extension UITextField {
    func indent(size:CGFloat) {
        self.leftView = UIView(frame: CGRect(x: self.frame.minX, y: self.frame.minY, width: size, height: self.frame.height))
        self.leftViewMode = .always
    }
}
