//
//  CustomLabel.swift
//  FlightInfo
//
//  Created by Vladimir Gusev on 27.07.2022.
//

import UIKit

final class CustomLabel: UILabel {
    init(text: String, color: UIColor, size: CGFloat, alignment: NSTextAlignment = .left) {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        self.text = text
        textColor = color
        font = UIFont(name: "Helvetica Neue Condensed Bold", size: size)
        textAlignment = alignment
        lineBreakMode = .byTruncatingTail
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
