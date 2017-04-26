//
//  global.swift
//  Tetris
//
//  Created by junlianglee on 2017/4/25.
//  Copyright © 2017年 kila. All rights reserved.
//

import Foundation
import UIKit

enum Global {
    static let mainBackgroundColor = UIColor.init(hexString: "#F9F9F9FF")
    
    static let screen = UIScreen.main.bounds
    static let left:CGFloat = 24
    static let top:CGFloat = 45
    static let rspace:CGFloat = 2
    static let cspace:CGFloat = 2
    static let row = 10
    static let col = 10
    static let width:CGFloat = (screen.width-left*2-rspace*(CGFloat(row)-1))/CGFloat(row)
    static let height:CGFloat = width
}


