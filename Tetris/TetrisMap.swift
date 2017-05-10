//
//  TetrisMapView.swift
//  Tetris
//
//  Created by junlianglee on 2017/4/28.
//  Copyright © 2017年 kila. All rights reserved.
//

import UIKit

enum TetrisMapState:Int {
    case Unknow = -1
    case Empty = 0
    case Placed = 1
}

enum TetrisMapType {
    case Main
    case Box
    
    var rect:CGRect {
        switch self {
        case .Main:
            let left:CGFloat = 24
            let top:CGFloat = 45
            let rect = CGRect.init(x: left, y: top, width: width, height: height)
            return rect
            
        case .Box:
            let left:CGFloat = 24
            let top:CGFloat = TetrisMapType.Main.rect.height+45+20
            let rect = CGRect.init(x: left, y: top, width: width, height: height)
            return rect
            
        }
    }
    
    var width:CGFloat {
        let left:CGFloat = 24
        return (Global.screen.width-left*2)
    }
    
    var blockSize:CGSize {
        let w = (CGFloat(width)+space)/CGFloat(row)-space
        return CGSize.init(width: w, height: w)
    }
    
    var height:CGFloat {
        switch self {
        case .Main:
            return width
        case .Box:
            return (blockSize.width+space)*CGFloat(col)-space
        }
    }
    
    var row:Int {
        switch self {
        case .Main:
            return 10
        case .Box:
            return 16
        }
    }
    
    var col:Int {
        switch self {
        case .Main:
            return 10
        case .Box:
            return 4
        }
    }
    
    var space:CGFloat {
        return 2
    }
}

extension TetrisMapView {
    static func factory(type:TetrisMapType) -> TetrisMapView {
        var tetrisMapView:TetrisMapView!
        switch type {
        case .Main:
            tetrisMapView = TetrisMapView.init(row: type.row, col: type.col, space:type.space,blockSize:type.blockSize , frame: type.rect)
            break
        case .Box:
            tetrisMapView = TetrisMapView.init(row: type.row, col: type.col, space:type.space,blockSize:type.blockSize , frame: type.rect)
            break
        }
        return tetrisMapView
    }
}

class TetrisMapView:UIView {
    let col:Int!
    let row:Int!
    var matrix:Array<Array<TetrisMapState>>!
    let space:CGFloat!
    var blockSize:CGSize!
    
    init(row:Int, col:Int, space:CGFloat, blockSize:CGSize, frame:CGRect) {
        self.col = col
        self.row = row
        self.space = space
        self.blockSize = blockSize
        
        super.init(frame: frame)
        
        let colArray = Array<TetrisMapState>.init(repeating: .Empty, count: col)
        self.matrix = Array<Array<TetrisMapState>>.init(repeating: colArray, count: row)
        _ = drawMap()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawMap() -> [[UIView]] {
        self.backgroundColor = Global.mainBackgroundColor
        
        let color = UIColor.white
        var views:[[UIView]] = []
        
        for i in 0..<row {
            views.append([])
            for j in 0..<col {
                let view = UIView.init(frame: CGRect.init(x: blockSize.width*CGFloat(i)+space*(CGFloat(i)-1), y: blockSize.width*CGFloat(j)+space*(CGFloat(j)-1), width: blockSize.width, height: blockSize.height))
                view.backgroundColor = color
                view.cornerRadius(4, borderWidth: 2, backgroundColor: .white, borderColor: .black)
                views[i].append(view)
                self.addSubview(view)
            }
        }
        return views
    }
    
    func getX(_ x:Int)->CGFloat {
        return CGFloat(x)*(blockSize.width + space)
    }
    
    func getY(_ y:Int)->CGFloat {
        return CGFloat(y)*(blockSize.width + space)
    }
    
    
    func addItem(shape:TetrisItemView) -> Bool {
        let positionx = Int(shape.addPosition!.x)
        let positiony = Int(shape.addPosition!.y)
        var canPlace = true
        for (x,y) in shape.shape.rowcol {
            if positionx+x<self.row && positiony+y<self.col && self.matrix[positionx+x][positiony+y] == .Empty {
                continue
            }
            else {
                canPlace = false
                break
            }
        }
        
        guard canPlace else {
            return canPlace
        }
        
        DispatchQueue.main.async {
            shape.frame.origin.x = self.getX(positionx)
            shape.frame.origin.y = self.getY(positiony)
            self.addSubview(shape)

        }
        
        for (x,y) in shape.shape.rowcol {
            self.matrix[positionx+x][positiony+y] = .Placed
        }
        
        return canPlace
    }
    
}
