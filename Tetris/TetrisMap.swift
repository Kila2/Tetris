//
//  TetrisMapView.swift
//  Tetris
//
//  Created by junlianglee on 2017/4/28.
//  Copyright © 2017年 kila. All rights reserved.
//

import UIKit

enum TetrisMapState: Int {
    case Unknow = -1
    case Empty = 0
    case Placed = 1
}

enum TetrisMapType {
    case Main
    case Box
    
    var rect: CGRect {
        switch self {
        case .Main:
            let left: CGFloat = 24
            let top: CGFloat = 45
            let rect = CGRect.init(x: left, y: top, width: width, height: height)
            return rect
            
        case .Box:
            let left: CGFloat = 24
            let top: CGFloat = TetrisMapType.Main.rect.height + 45 + 20
            let rect = CGRect.init(x: left, y: top, width: width, height: height)
            return rect
            
        }
    }
    
    var width: CGFloat {
        let left: CGFloat = 24
        return (Global.screen.width - left * 2)
    }
    
    var blockSize: CGSize {
        let w = (CGFloat(width) + space) / CGFloat(row) - space
        return CGSize.init(width: w, height: w)
    }
    
    var height: CGFloat {
        switch self {
        case .Main:
            return self.width
        case .Box:
            return (self.blockSize.width + self.space) * CGFloat(self.col) - self.space
        }
    }
    
    var row: Int {
        switch self {
        case .Main:
            return 10
        case .Box:
            return 16
        }
    }
    
    var col: Int {
        switch self {
        case .Main:
            return 10
        case .Box:
            return 4
        }
    }
    
    var space: CGFloat {
        return 2
    }
}

extension TetrisMapView {
    static func factory(type: TetrisMapType) -> TetrisMapView {
        var tetrisMapView: TetrisMapView!
        switch type {
        case .Main:
            tetrisMapView = TetrisMapView.init(row: type.row, col: type.col, space: type.space, blockSize: type.blockSize, frame: type.rect)
            break
        case .Box:
            tetrisMapView = TetrisMapView.init(row: type.row, col: type.col, space: type.space, blockSize: type.blockSize, frame: type.rect)
            break
        }
        return tetrisMapView
    }
}

struct TetrisMapBlock {
    var state: TetrisMapState!
    weak var view: UIView?
}

class TetrisMapView: UIView {
    let col: Int!
    let row: Int!
    let space: CGFloat!
    var blockSize: CGSize!
    var lastAddPositionX: Set<Int> = Set<Int>()
    var lastAddPositionY: Set<Int> = Set<Int>()
    var matrix: Array<Array<TetrisMapBlock>>!
    private var items = [TetrisItemView]()
    
    var itemViews:[TetrisItemView] {
        return items
    }
    
    init(row: Int, col: Int, space: CGFloat, blockSize: CGSize, frame: CGRect) {
        self.col = col
        self.row = row
        self.space = space
        self.blockSize = blockSize
        
        super.init(frame: frame)
        
        let colArray = Array<TetrisMapBlock>.init(repeating: TetrisMapBlock.init(state: .Empty, view: nil), count: col)
        self.matrix = Array<Array<TetrisMapBlock>>.init(repeating: colArray, count: row)
        _ = drawMap()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addSubview(_ view: UIView) {
        assert(false, "addSubView can not be call")
//        super.addSubview(view)
    }
    private func addSubview_(_ view: UIView) {
        super.addSubview(view)
    }
    
    func drawMap() -> [[UIView]] {
        self.backgroundColor = Global.mainBackgroundColor
        
        let color = UIColor.white
        var views: [[UIView]] = []
        
        for i in 0..<self.row {
            views.append([])
            for j in 0..<self.col {
                let view = UIView.init(frame: CGRect.init(x: blockSize.width * CGFloat(i) + space * (CGFloat(i) - 1), y: blockSize.width * CGFloat(j) + space * (CGFloat(j) - 1), width: blockSize.width, height: blockSize.height))
                view.backgroundColor = color
                view.cornerRadius(4, borderWidth: 2, backgroundColor: .white, borderColor: .black)
                // view.layer.shouldRasterize = true
                views[i].append(view)
                self.addSubview_(view)
            }
        }
        return views
    }
    
    func getX(_ x: Int) -> CGFloat {
        return CGFloat(x) * (self.blockSize.width + self.space)
    }
    
    func getY(_ y: Int) -> CGFloat {
        return CGFloat(y) * (self.blockSize.width + self.space)
    }
    
    func canPlace(shape: TetrisItemView, point: CGPoint) -> Bool {
        let positionx = Int(point.x)
        let positiony = Int(point.y)
        for blockview in shape.subviews {
            let blockview = blockview as! TetrisItemBlockView
            let x = Int(blockview.tetrisPoint.x)
            let y = Int(blockview.tetrisPoint.y)
            if positionx + x < self.row && positiony + y < self.col && self.matrix[positionx + x][positiony + y].state == .Empty {
                continue
            } else {
                return false
            }
        }
        return true
    }
    
    func addItem(shape: TetrisItemView, point: TetrisPoint) {
        
        let positionx = Int(point.x)
        let positiony = Int(point.y)
        
        shape.frame.origin.x = self.getX(positionx)
        shape.frame.origin.y = self.getY(positiony)
        shape.point = point
        self.addSubview_(shape)
        self.items.append(shape)
        
        lastAddPositionX.removeAll()
        lastAddPositionY.removeAll()
        
        for view in shape.subviews {
            if let block = view as? TetrisItemBlockView {
                let x = Int(block.tetrisPoint.x)
                let y = Int(block.tetrisPoint.y)
                self.matrix[positionx + x][positiony + y].state = .Placed
                self.matrix[positionx + x][positiony + y].view = view
                lastAddPositionX.insert(positionx + x)
                lastAddPositionY.insert(positiony + y)
            }
        }
    }
    
    // 判断能否消除
    func checkClean() {
        // 判断y轴
        var cleanLine = true
        for x in self.lastAddPositionX {
            cleanLine = true
            for i in 0..<self.matrix.count {
                if self.matrix[x][i].state == .Empty {
                    cleanLine = false
                    break
                }
            }
            if cleanLine {
                // 移除view 清空tetrisMapView矩阵
                print("remove")
                let time = DispatchTime.now()
            
                for i in 0..<self.matrix.count {
                    
                    DispatchQueue.main.asyncAfter(deadline: time + DispatchTimeInterval.milliseconds(50*i), execute: {
                        let sv = self.matrix[x][i].view?.superview
                        if let blockView = self.matrix[x][i].view {
                            blockView.removeFromSuperview()
                            self.matrix[x][i].view = nil
                            GameViewController.scoreValueChanged(value: 10)
                        }
                        self.matrix[x][i].state = .Empty
                        if sv?.subviews.count == 0 {
                            sv?.removeFromSuperview()
                            let index = self.items.index(where: { (iv) -> Bool in
                                iv == sv
                            })!
                            self.items.remove(at: index)
                        }
                    })
                }
            }
        }
        // 判断x轴
        
        for y in self.lastAddPositionY {
            cleanLine = true
            for i in 0..<self.matrix[0].count {
                if self.matrix[i][y].state == .Empty {
                    cleanLine = false
                    break
                }
            }
            if cleanLine {
                // 移除view 清空tetrisMapView矩阵
                print("remove")
                let time = DispatchTime.now()
                
                for i in 0..<self.matrix[0].count {
                    DispatchQueue.main.asyncAfter(deadline: time + DispatchTimeInterval.milliseconds(50*i), execute: {
                        let sv = self.matrix[i][y].view?.superview
                        if let blockView = self.matrix[i][y].view {
                            blockView.removeFromSuperview()
                            self.matrix[i][y].view = nil
                            GameViewController.scoreValueChanged(value: 10)
                        }
                        self.matrix[i][y].state = .Empty
                        if sv?.subviews.count == 0 {
                            sv?.removeFromSuperview()
                            let index = self.items.index(where: { (iv) -> Bool in
                                iv == sv
                            })!
                            self.items.remove(at: index)
                        }
                    })
                }
                
            }
        }
    }
    

    func remove(_ itemView:TetrisItemView) {
        itemView.removeFromSuperview()
        // 清空item手势
        for gest in itemView.gestureRecognizers! {
            itemView.removeGestureRecognizer(gest)
        }
        // 清空tetrisBoxView矩阵
//        let originNumx = lroundf(Float(((self.originFrame.minX) / (self.tetrisBoxView.blockSize.width + self.tetrisBoxView.space))))
//        let originNumy = lroundf(Float(((self.originFrame.minY) / (self.tetrisBoxView.blockSize.height + self.tetrisBoxView.space))))
        for blockview in itemView.subviews {
            let bvc = blockview as! TetrisItemBlockView
            let x = bvc.tetrisPoint.x
            let y = bvc.tetrisPoint.y
            assert(itemView.point != nil, "itemview.point is nil")
            self.matrix[itemView.point!.x + x][itemView.point!.y + y].state = .Empty
        }

        let index = self.items.index(where: { (iv) -> Bool in
            iv == itemView
        })
        
        assert(index != nil, "removed index is null")
        self.items.remove(at: index!)
        
    }
    
    func clean() {
        for subview in items {
            subview.removeFromSuperview()
        }
        self.items.removeAll()
        let colArray = Array<TetrisMapBlock>.init(repeating: TetrisMapBlock.init(state: .Empty, view: nil), count: col)
        self.matrix = Array<Array<TetrisMapBlock>>.init(repeating: colArray, count: row)
    }
    
}
