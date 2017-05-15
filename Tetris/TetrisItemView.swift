//
//  TetrisItemView.swift
//  Tetris
//
//  Created by junlianglee on 2017/4/28.
//  Copyright © 2017年 kila. All rights reserved.
//

import UIKit


enum TetrisItemEnum:Int {
    
    case S
    case Z
    case L
    case J
    case I
    case O
    case T
    case I4
    case I2
    case O1
    
    var rowcol_origin:[(row:Int,col:Int)] {
        switch self {
        case .S: return [(1,0),(2,0),(0,1),(1,1)]
        case .Z: return [(0,0),(1,0),(1,1),(2,1)]
        case .L: return [(0,0),(0,1),(0,2),(1,2)]
        case .J: return [(1,0),(1,1),(1,2),(0,2)]
        case .I: return [(0,0),(0,1),(0,2),(0,3)]
        case .O: return [(0,0),(0,1),(1,0),(1,1)]
        case .T: return [(0,0),(1,0),(2,0),(1,1)]
        case .I4: return [(0,0)]
        case .I2: return [(0,0),(0,1)]
        case .O1: return [(0,0),(0,1),(0,2),(1,0),(1,1),(1,2),(2,0),(2,1),(2,2)]
        default:
            return []
        }
        
    }
    var backgroundSize:(row:Int, col:Int) {
        switch self {
        case .S: return (3,2)
        case .Z: return (3,2)
        case .L: return (2,3)
        case .J: return (2,3)
        case .I: return (1,4)
        case .O: return (2,2)
        case .T: return (3,2)
        case .I4: return (1,1)
        case .I2: return (1,2)
        case .O1: return (3,3)
        default:
            return (0,0)
        }
    }
    var color:UIColor {
        switch self {
        case .S: return UIColor.init(hexString: "#FD9E20FF")!
        case .Z: return UIColor.init(hexString: "#FECE30FF")!
        case .L: return UIColor.init(hexString: "#56C2F0FF")!
        case .J: return UIColor.init(hexString: "#28C35BFF")!
        case .I: return UIColor.init(hexString: "#FA6464FF")!
        case .O: return UIColor.init(hexString: "#22BFADFF")!
        case .T: return UIColor.init(hexString: "#FC80C3FF")!
        case .I4: return UIColor.init(hexString: "#FC30C3FF")!
        case .I2: return UIColor.init(hexString: "#DB30C3FF")!
        case .O1: return UIColor.init(hexString: "#22BF64FF")!
        default:
            return .white
        }
    }
    
    static let allValues = [S, Z, L, J, I, O, T, I4, I2, O1]
}

struct TetrisPoint {
    var x:Int
    var y:Int
}
class TetrisItemBlockView:UIView {
    var tetrisPoint:TetrisPoint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TetrisItemView {
    
    static func randomBoxItem(point:CGPoint) -> TetrisItemView {
        let direct = arc4random_uniform(4)
        let count = TetrisItemEnum.allValues.count
        let value = arc4random_uniform(UInt32(count))
        let item = TetrisItemEnum.init(rawValue: Int(value))
        let view =  makeTetrisItem(box: item!)
        //view.backgroundColor = .black
        var minx:Int = 0
        var miny:Int = 0
        
        view.subviews.enumerated().forEach { (offset: Int, element: UIView) in
            let element = element as! TetrisItemBlockView
            let x = element.tetrisPoint.x
            let y = element.tetrisPoint.y
            let angle = (CGFloat.pi/2) * CGFloat(direct)
            //坐标点相对（-1，-1）旋转
            let x0 = (x+1) * Int(cos(angle)) - (y+1) * Int(sin(angle)) - 1
            let y0 = (x+1) * Int(sin(angle)) + (y+1) * Int(cos(angle)) - 1
            element.tetrisPoint = TetrisPoint.init(x: x0, y: y0)
            minx = x0 < minx ? x0 : minx
            miny = y0 < miny ? y0 : miny
        }
        //平移
        if minx < 0 {
            let movex = Int(abs(minx))
            view.subviews.enumerated().forEach { (offset: Int, element: UIView) in
                let element = element as! TetrisItemBlockView
                let x0 = element.tetrisPoint.x + movex
                let y0 = element.tetrisPoint.y
                element.tetrisPoint = TetrisPoint.init(x: x0, y: y0)
            }
        }
        //平移
        if Int(miny) < 0 {
            let movey = abs(miny)
            view.subviews.enumerated().forEach { (offset: Int, element: UIView) in
                let element = element as! TetrisItemBlockView
                let x0 = element.tetrisPoint.x
                let y0 = element.tetrisPoint.y + movey
                element.tetrisPoint = TetrisPoint.init(x: x0, y: y0)
            }
        }
        //调整view
        view.subviews.enumerated().forEach { (offset: Int, element: UIView) in
            let element = element as! TetrisItemBlockView
            element.frame.origin.x = CGFloat(element.tetrisPoint.x) * TetrisMapType.Box.blockSize.width + CGFloat(element.tetrisPoint.x - 1) * TetrisMapType.Box.space
            element.frame.origin.y = CGFloat(element.tetrisPoint.y) * TetrisMapType.Box.blockSize.width + CGFloat(element.tetrisPoint.y - 1) * TetrisMapType.Box.space
        }
        //调整view
        if direct == 1 || direct == 3 {
            view.frame.size = CGSize.init(width: view.frame.size.height, height: view.frame.size.width)
        }
        
        return view
    }
    
    static func makeTetrisItem(main:TetrisItemEnum) -> TetrisItemView {
        return makeTetrisItem(shape:main,type: .Main)
    }
    
    static func makeTetrisItem(box:TetrisItemEnum) -> TetrisItemView {
        return makeTetrisItem(shape:box,type: .Box)
    }
    
    static func makeTetrisItem(shape:TetrisItemEnum,type:TetrisMapType) -> TetrisItemView {
        let space = type.space
        let width:CGFloat = type.blockSize.width
        let height:CGFloat = width
        
        let bgrect = CGRect.init(x: 0, y: 0, width: width*CGFloat(shape.backgroundSize.row), height: height*CGFloat(shape.backgroundSize.col))
        let bgview = TetrisItemView.init(frame: bgrect)
        
        bgview.shape = shape
        
        for (i,j) in bgview.shape.rowcol_origin  {
            let rect = CGRect.init(x: width*CGFloat(i)+space*(CGFloat(i)-1), y: height*CGFloat(j)+space*(CGFloat(j)-1), width: width, height: height);
            let view = TetrisItemBlockView.init(frame: rect)
            view.tetrisPoint = TetrisPoint.init(x: i, y: j)
            view.backgroundColor = shape.color
            bgview.addSubview(view)
        }
        
        return bgview
    }
    
}

class TetrisItemView:UIView {
    var subviewPoints:[TetrisPoint] {
        var points = [TetrisPoint]()
        for view in self.subviews {
            let blockview = view as! TetrisItemBlockView
            points.append(blockview.tetrisPoint)
        }
        return points
    }
    
    var shape:TetrisItemEnum!
    var direct:UInt32 = 0
    func clone() -> TetrisItemView {
        let view = NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self))! as! TetrisItemView
        view.shape = self.shape
        return view
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        for view in self.subviews {
            if view.frame.insetBy(dx: -5, dy: -5).contains(point) {
                return view
            }
        }
        return nil
    }
    
    func zoom(type:TetrisMapType) {
        var arr = [(x:CGFloat,y:CGFloat)]()
        var maxx = 0
        var maxy = 0
        
        for i in 0..<self.subviews.count {
            let blockview = self.subviews[i] as! TetrisItemBlockView
            let x = type.blockSize.width*CGFloat(blockview.tetrisPoint.x)+type.space*(CGFloat(blockview.tetrisPoint.x)-1)
            let y = type.blockSize.height*CGFloat(blockview.tetrisPoint.y)+type.space*(CGFloat(blockview.tetrisPoint.y)-1)
            maxx = blockview.tetrisPoint.x > maxx ? blockview.tetrisPoint.x : maxx
            maxy = blockview.tetrisPoint.y > maxy ? blockview.tetrisPoint.y : maxy
            arr.append((x,y))
        }
        for i in (0..<self.subviews.count).reversed() {
            self.subviews[i].frame.origin.x = arr[i].x
            self.subviews[i].frame.origin.y = arr[i].y
            self.subviews[i].frame.size = type.blockSize
        }
        //行数与列数
        maxy += 1
        maxx += 1
        let width = CGFloat(maxx) * type.blockSize.width + CGFloat(maxx - 1) * type.space
        let height = CGFloat(maxy) * type.blockSize.width + CGFloat(maxy - 1) * type.space
        
        self.frame.size = CGSize.init(width: width, height: height)
        
    }
    
}


