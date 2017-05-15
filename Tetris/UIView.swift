//
//  UIView.swift
//  Tetris
//
//  Created by junlianglee on 2017/4/28.
//  Copyright © 2017年 kila. All rights reserved.
//

import UIKit

extension UIView {
    private func kt_addCorner(radius: CGFloat,
                      borderWidth: CGFloat,
                      backgroundColor: UIColor,
                      borderColor: UIColor) {
        let image = kt_drawRectWithRoundedCorner(radius: radius,
                                                 borderWidth: borderWidth,
                                                 backgroundColor: backgroundColor,
                                                 borderColor: borderColor)
        
        let imageView = UIImageView(image: image)
        self.insertSubview(imageView, at: 0)
    }
    
    
    private func kt_drawRectWithRoundedCorner(radius: CGFloat,
                                      borderWidth: CGFloat,
                                      backgroundColor: UIColor,
                                      borderColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.setAlpha(1)
        context?.setFillColor(backgroundColor.cgColor)
        context?.fill(self.bounds)
        let maskPath = UIBezierPath.init(roundedRect: self.bounds.insetBy(dx: 1, dy: 1), cornerRadius: radius)
        context?.setStrokeColor(borderColor.cgColor)
        maskPath.stroke()
        maskPath.lineWidth = borderWidth
        context?.addPath(maskPath.cgPath)
        context?.drawPath(using: .fillStroke)
        let output = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return output!
    }
    
    
    func cornerRadius(_ radius:CGFloat,borderWidth:CGFloat = 0,backgroundColor:UIColor = .clear ,borderColor:UIColor = .clear) {
        kt_addCorner(radius: radius, borderWidth: borderWidth, backgroundColor: backgroundColor, borderColor: borderColor)
    }
        
}
