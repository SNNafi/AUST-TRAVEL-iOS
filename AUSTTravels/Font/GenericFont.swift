//
//  GenericFont.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 30/11/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import UIKit
import SwiftUI

public final class GenericFont {
    
    static func loadFont(font: Font,
                         size: CGFloat) -> UIFont? {
        
        if let font = UIFont(name: font.rawValue, size: size) {
            return font }
        
        let bundle = Bundle(for: GenericFont.self)
        
        guard
            let url = bundle.url(forResource: font.rawValue,
                                 withExtension: "ttf"),
            let fontData = NSData(contentsOf: url),
            let provider = CGDataProvider(data: fontData),
            let cgFont = CGFont(provider),
            let fontName = cgFont.postScriptName as String? else {
                preconditionFailure("Unable to load font named \(font.rawValue)")
            }
        return UIFont(name: fontName, size: size)
    }
    
    static func loadDUIFont(font: Font,
                          size: Float) -> UIFont? {
        
        if let font = UIFont(name: font.rawValue, size: dynamicFontSize(size: size)) {
            return font }
        
        let bundle = Bundle(for: GenericFont.self)
        
        guard
            let url = bundle.url(forResource: font.rawValue,
                                 withExtension: "ttf"),
            let fontData = NSData(contentsOf: url),
            let provider = CGDataProvider(data: fontData),
            let cgFont = CGFont(provider),
            let fontName = cgFont.postScriptName as String? else {
                preconditionFailure("Unable to load font named \(font.rawValue)")
            }
        return UIFont(name: fontName, size: dynamicFontSize(size: size))
    }
    
    static func loadDFont(font: Font,
                         size: Float) -> SwiftUI.Font? {
        
        if let font = UIFont(name: font.rawValue, size: dynamicFontSize(size: size))  {
            return SwiftUI.Font(font) }
        
        let bundle = Bundle(for: GenericFont.self)
        
        guard
            let url = bundle.url(forResource: font.rawValue,
                                 withExtension: "ttf"),
            let fontData = NSData(contentsOf: url),
            let provider = CGDataProvider(data: fontData),
            let cgFont = CGFont(provider),
            let fontName = cgFont.postScriptName as String? else {
                preconditionFailure("Unable to load font named \(font.rawValue)")
            }
       
        return SwiftUI.Font(UIFont(name: fontName, size: dynamicFontSize(size: size))!)
    }
    
    private static func dynamicFontSize(size: Float) -> CGFloat {
        let scaleFactor = Float(UIScreen.main.bounds.height) / Float(iphone12miniHeight)
        let fontSize = CGFloat(size * scaleFactor)
        return fontSize
    }
    
    enum Font: String, CaseIterable {
        case sairaCondensedRegular = "SairaCondensed-Regular"
        case sairaCondensedMedium = "SairaCondensed-Medium"
        case sairaCondensedLight = "SairaCondensed-Light"
        case sairaCondensedSemiBold = "SairaCondensed-SemiBold"
        case sairaCondensedBold = "SairaCondensed-Bold"
        
    }
    
}


