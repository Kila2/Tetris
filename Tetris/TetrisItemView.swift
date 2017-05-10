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
    
    var rowcol:[(row:Int,col:Int)] {
        switch self {
        case .S: return [(1,0),(2,0),(0,1),(1,1)]
        case .Z: return [(0,0),(1,0),(1,1),(2,1)]
        case .L: return [(0,0),(0,1),(0,2),(1,2)]
        case .J: return [(1,0),(1,1),(1,2),(0,2)]
        case .I: return [(0,0),(0,1),(0,2),(0,3)]
        case .O: return [(0,0),(0,1),(1,0),(1,1)]
        case .T: return [(0,0),(1,0),(2,0),(1,1)]
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
        default:
            return .white
        }
    }
    
    static let allValues = [S, Z, L, J, I, O, T]
}

extension TetrisItemView {
    
    static func randomBoxItem(point:CGPoint) -> TetrisItemView {
        let count = TetrisItemEnum.allValues.count
        let value = arc4random_uniform(UInt32(count))
        let item = TetrisItemEnum.init(rawValue: Int(value))
        let view =  makeTetrisItem(box: item!)
        view.addPosition = point
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
        
        for (i,j) in shape.rowcol  {
            let rect = CGRect.init(x: width*CGFloat(i)+space*(CGFloat(i)-1), y: height*CGFloat(j)+space*(CGFloat(j)-1), width: width, height: height);
            let view = UIView.init(frame: rect)
            view.backgroundColor = shape.color
            bgview.addSubview(view)
        }
        
        return bgview
    }
    
}

class TetrisItemView:UIView {
    var shape:TetrisItemEnum!
    var addPosition:CGPoint?
    
    func clone() -> TetrisItemView {
        let view = NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self))! as! TetrisItemView
        view.shape = self.shape
        return view
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        for view in self.subviews {
            if point.x > view.frame.minX && point.x < view.frame.maxX
                && point.y > view.frame.minY && point.y < view.frame.maxY {
                return view
            }
        }
        return nil
    }
    
    func zoom(type:TetrisMapType) {
        DispatchQueue.global().async {
            let width = type.blockSize.width * CGFloat(self.shape.backgroundSize.row)
            let height = type.blockSize.height * CGFloat(self.shape.backgroundSize.col)
            
            var arr = [(x:CGFloat,y:CGFloat)]()
            for i in 0..<self.shape.rowcol.count {
                let x = type.blockSize.width*CGFloat(self.shape.rowcol[i].row)+type.space*(CGFloat(self.shape.rowcol[i].row)-1)
                let y = type.blockSize.height*CGFloat(self.shape.rowcol[i].col)+type.space*(CGFloat(self.shape.rowcol[i].col)-1)
                arr.append((x,y))
            }
            DispatchQueue.main.async {
                for i in 0..<self.shape.rowcol.count {
                    self.subviews[i].frame.origin.x = arr[i].x
                    self.subviews[i].frame.origin.y = arr[i].y
                    self.subviews[i].frame.size = type.blockSize
                }
                self.frame.size = CGSize.init(width: width, height: height)
            }
        }
    }
}


