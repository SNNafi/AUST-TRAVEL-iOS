//
//  Int+Ex.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 30/11/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import SwiftUI

extension CGFloat {
    func dWidth() -> CGFloat {
        let scaleFactor = Float(UIScreen.main.bounds.width) / Float(iphone12miniWidth)
        return CGFloat(Float(self) * scaleFactor)
    }
    func dHeight () -> CGFloat {
        let scaleFactor = Float(UIScreen.main.bounds.height) / Float(iphone12miniHeight)
        return CGFloat(Float(self) * scaleFactor)
    }
}

extension Double {
    func dWidth() -> CGFloat {
        let scaleFactor = Float(UIScreen.main.bounds.width) / Float(iphone12miniWidth)
        return CGFloat(Float(self) * scaleFactor)
    }
    func dHeight () -> CGFloat {
        let scaleFactor = Float(UIScreen.main.bounds.height) / Float(iphone12miniHeight)
        return CGFloat(Float(self) * scaleFactor)
    }
}

extension Int {
    func dWidth() -> CGFloat {
        let scaleFactor = Float(UIScreen.main.bounds.width) / Float(iphone12miniWidth)
        return CGFloat(Float(self) * scaleFactor)
    }
    func dHeight () -> CGFloat {
        let scaleFactor = Float(UIScreen.main.bounds.height) / Float(iphone12miniHeight)
        return CGFloat(Float(self) * scaleFactor)
    }
}
