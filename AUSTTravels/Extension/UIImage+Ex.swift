//
//  UIImage+Ex.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 7/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import UIKit

extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: image!.cgImage!)
    }
}
