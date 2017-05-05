//
//  UIView.swift
//  Tetris
//
//  Created by junlianglee on 2017/4/28.
//  Copyright © 2017年 kila. All rights reserved.
//

import UIKit

extension UIView {
    func cornerRadius(_ radius:CGFloat) {
        let maskPath = UIBezierPath.init(roundedRect: self.bounds, cornerRadius: radius)
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
        self.layer.backgroundColor = self.backgroundColor?.cgColor
        
        let borderLayer = CAShapeLayer()
        borderLayer.path = maskLayer.path // Reuse the Bezier path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor.gray.cgColor
        borderLayer.lineWidth = 1
        borderLayer.frame = self.bounds
        self.layer.addSublayer(borderLayer)
    }
    
        
}
