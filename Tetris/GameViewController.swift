//
//  GameViewController.swift
//  Tetris
//
//  Created by junlianglee on 2017/5/15.
//  Copyright © 2017年 kila. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    var tetrisMapView = TetrisMapView.factory(type: .Main)
    var tetrisBoxView = TetrisMapView.factory(type: .Box)
    var originFrame: CGRect!
    var boxItems = [TetrisItemView?].init(repeating: nil, count: 3)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(self.tetrisMapView)
        self.view.addSubview(self.tetrisBoxView)
        
        for i in 1...3 {
            let item = self.addBoxRandomItemView(point: CGPoint.init(x: 1 + 5 * (i - 1), y: 0))
            boxItems[i-1] = item
        }
        
    }
    
    func addBoxRandomItemView(point: CGPoint)->TetrisItemView {
        let item = TetrisItemView.randomBoxItem(point: point)
        let panGest = UIPanGestureRecognizer.init(target: self, action: #selector(GameViewController.itemTouch(_:)))
        let longGest = UILongPressGestureRecognizer.init(target: self, action: #selector(GameViewController.itemTouch(_:)))
        panGest.require(toFail: longGest)
        item.addGestureRecognizer(longGest)
        item.addGestureRecognizer(panGest)
        _ = self.tetrisBoxView.addItem(shape: item, point: point)
        return item
    }
    
    func itemTouch(_ recognizer: UIGestureRecognizer) {
        if recognizer.state == .ended || recognizer.state == .cancelled {
            if let itemView = recognizer.view as? TetrisItemView {
                let itemFrame = self.tetrisMapView.convert(itemView.frame, from: self.tetrisBoxView)
                let originFrame = self.tetrisMapView.bounds.insetBy(dx: -10, dy: -10)
                
                let numX = lroundf(Float(((itemFrame.minX) / (self.tetrisMapView.blockSize.width + self.tetrisMapView.space))))
                let numY = lroundf(Float(((itemFrame.minY) / (self.tetrisMapView.blockSize.height + self.tetrisMapView.space))))
                // 判断在不在区域内，能不能放下
                if originFrame.contains(itemFrame) && self.tetrisMapView.canPlace(shape: itemView, point: CGPoint.init(x: numX, y: numY)) {
                    // 放倒tetrisMapView 设置tetrisMapView矩阵
                    self.tetrisMapView.addItem(shape: itemView, point: CGPoint.init(x: numX, y: numY))
                    // 清空tetrisBoxView矩阵
                    let originNumx = lroundf(Float(((self.originFrame.minX) / (self.tetrisBoxView.blockSize.width + self.tetrisBoxView.space))))
                    let originNumy = lroundf(Float(((self.originFrame.minY) / (self.tetrisBoxView.blockSize.height + self.tetrisBoxView.space))))
                    for blockview in itemView.subviews {
                        let bvc = blockview as! TetrisItemBlockView
                        let x = Int(bvc.tetrisPoint.x)
                        let y = Int(bvc.tetrisPoint.y)
                        self.tetrisBoxView.matrix[originNumx + x][originNumy + y].state = .Empty
                    }
                    
                    
                    // 判断能否消除
                    self.tetrisMapView.checkClean()
                    
                    // 生成新的Item
                    let newItem = self.addBoxRandomItemView(point: CGPoint.init(x: originNumx, y: originNumy))
                    
                    //维护boxItem元素
                    let index = boxItems.index(where: { (iv) -> Bool in
                        return iv == itemView
                    })
                    if let index = index {
                        boxItems[index] = newItem
                    }
                    
                    // 清空手势
                    for gest in itemView.gestureRecognizers! {
                        itemView.removeGestureRecognizer(gest)
                    }
                    // 判断能否继续游戏
                    if !self.checkGameOver(boxView: tetrisBoxView) {
                        //gameover
                        gameOver()
                    }
                } else {
                    // 放回tetrisBoxView
                    UIView.animate(withDuration: 0.2, animations: {
                        itemView.frame.origin = self.originFrame.origin
                        itemView.zoom(type: .Box)
                    })
                    
                }
            }
            return
        }
        
        if recognizer.state == .began {
            if let itemView = recognizer.view as? TetrisItemView {
                itemView.zoom(type: .Main)
                self.originFrame = itemView.frame
            }
        }
        UIView.animate(withDuration: 0.2, animations: {
            let point = recognizer.location(in: self.tetrisBoxView)
            recognizer.view?.center = point
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addItem(_ item: UIView) {
        self.view.addSubview(item)
    }
    
    // 判断能否继续游戏
    func checkGameOver(boxView: TetrisMapView) -> Bool {
        let shapeViews = boxItems
        var canPlace = false
        var i = 0
        for rowblock in self.tetrisMapView.matrix {
            var j = 0
            for block in rowblock {
                if block.state == .Empty {
                    for shapeView in shapeViews {
                        let point = TetrisPoint.init(x: i, y: j)
                        let shapeCanPlace = checkShapeCanPlace(shapeView: shapeView, at: point)
                        if shapeCanPlace {
                            canPlace = true
                            break
                        }
                    }
                }
                if canPlace {break}
                j += 1
            }
            if canPlace { break }
            i += 1
        }
        return canPlace
    }
    
    func checkShapeCanPlace(shapeView: TetrisItemView?, at point: TetrisPoint) -> Bool {
        if let shapeView = shapeView {
            let blockViews = shapeView.subviews as! [TetrisItemBlockView]
            var can = true
            for blockView in blockViews {
                if self.tetrisMapView.row <= point.x + blockView.tetrisPoint.x ||
                    self.tetrisMapView.col <= point.y + blockView.tetrisPoint.y ||
                self.tetrisMapView.matrix[point.x + blockView.tetrisPoint.x][point.y + blockView.tetrisPoint.y].state == .Placed {
                    can = false
                    break
                }
            }
            return can
        }
        else {
            return false
        }
        
    }
    
    func gameOver() {
        
    }
    
}
