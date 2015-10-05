//
//  UIImageExtension.swift
//  trackto
//
//  Created by Andrew Platkin on 9/27/15.
//  Copyright © 2015 Andrew Platkin. All rights reserved.
//

import Foundation
import UIKit

extension UIImage
{
    func tint(color: UIColor, blendMode: CGBlendMode) -> UIImage
    {
        let drawRect = CGRectMake(0.0, 0.0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context = UIGraphicsGetCurrentContext()
        CGContextClipToMask(context, drawRect, CGImage)
        color.setFill()
        UIRectFill(drawRect)
        drawInRect(drawRect, blendMode: blendMode, alpha: 1.0)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage
    }
}