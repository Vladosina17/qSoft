//
//  BaseTextField.swift
//  TestQsort
//
//  Created by Влад Барченков on 09.08.2021.
//

import UIKit

class BaseTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        placeholder = ""
        layer.cornerRadius = 5
        layer.masksToBounds = true
        borderStyle = .none
        isSecureTextEntry = false
        
        backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        indent(size: 10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(placeholder: String = "", isSecure: Bool = false) {
        self.init()
        self.placeholder = placeholder
        isSecureTextEntry = isSecure
    }
    
}
