//
//  UIColor+ext.swift
//  FlightInfo
//
//  Created by Vladimir Gusev on 27.07.2022.
//

import UIKit

extension UIColor {
    static var statusLabelColor: UIColor = .init(hex: "DA4C06")
    static var goldLabelColor: UIColor = .init(hex: "FED692")
    
    convenience init(hex: String) {
            var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

            if cString.hasPrefix("#") {
                cString.remove(at: cString.startIndex)
            }

            if cString.count != 6 {
                self.init(white: 0, alpha: 1.0)
                return
            }

            var rgbValue: UInt64 = 0
            Scanner(string: cString).scanHexInt64(&rgbValue)

            self.init(displayP3Red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                      alpha: CGFloat(1.0))
        }
}
