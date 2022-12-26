//
//  TextFieldWithPadding.swift
//  eTVShow
//
//  Created by Aldair Carrillo on 23/12/22.
//

import UIKit

class TextFieldWithPadding: UITextField {
    var textPadding = UIEdgeInsets(
        top: 10,
        left: 20,
        bottom: 10,
        right: 20
    )
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    func configure() {
        backgroundColor = .white
        borderStyle = .roundedRect
        textColor = UIColor(named: "text")
        tintColor = UIColor(named: "placeholder")
        autocapitalizationType = .none
    }
}

