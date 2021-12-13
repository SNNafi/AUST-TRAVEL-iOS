//
//  Color+Ex.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 24/10/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import SwiftUI

extension Color {
    
    init(hex: String) {
        self.init(UIColor(hex: hex))
    }
    
    static let green = Color(hex: "#2ABA7E")
    static let greenLight = Color(hex: "#00FF94")
    static let white = Color(hex: "#FFFFFF")
    static let black = Color(hex: "#000000")
    static let yellow = Color(hex: "#FFD856")
    static let yellowLight = Color(hex: "#FCE8A7")
    static let orange = Color(hex: "#E9896B")
    static let ash = Color(hex: "#F0F0F0")
    static let redAsh = Color(hex: "#E9896B")
    static let deepAsh = Color(hex: "#C4C4C4")
    static let lightAsh = Color(hex: "#F0F0F0")
}

extension UIColor {
    /// For converting Hex-based colors
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        let length = hexSanitized.count
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        if length == 6 {
            red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            blue = CGFloat(rgb & 0x0000FF) / 255.0
            
        } else if length == 8 {
            red = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            green = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            blue = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            alpha = CGFloat(rgb & 0x000000FF) / 255.0
        }
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
}
