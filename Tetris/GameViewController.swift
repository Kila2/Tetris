//
//  GameViewController.swift
//  Tetris
//
//  Created by junlianglee on 2017/5/15.
//  Copyright © 2017年 kila. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    var gameScore: Int = 0
    var tetrisMapView = TetrisMapView.factory(type: .Main)
    var tetrisBoxView = TetrisMapView.factory(type: .Box)
    var originFrame: CGRect!
    
    weak var scoreLabel:UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(self.tetrisMapView)
        self.view.addSubview(self.tetrisBoxView)
        
        self.addNewBoxItems()
        //        let btn = UIButton.init()
        //        btn.addTarget(self, action: #selector(GameViewController.checkGameOver), for: .touchDown)
        //        btn.setTitle("gameover?", for: .normal)
        //        btn.setTitleColor(UIColor.blue, for: .normal)
        //        btn.sizeToFit()
        //        self.view.addSubview(btn)
        //        btn.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        //        btn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        //        btn.translatesAutoresizingMaskIntoConstraints = false
        let scoreLabel = UILabel.init()
        scoreLabel.text = "分数:\(self.gameScore)"
        self.view.addSubview(scoreLabel)
        scoreLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        scoreLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        self.scoreLabel = scoreLabel
        
        // 添加observer
        self.addObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // self.gameOver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func addObserver() {
        let notify = Notification.Name.init(rawValue: "Restart")
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.restartGame), name: notify, object: nil)
        
        let scoreNotify = Notification.Name.init("ScoreAdded")
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.gameScoreValueChanged(notification:)), name: scoreNotify, object: nil)
        
    }
    
    func addBoxRandomItemView(point: TetrisPoint) {
        let item = TetrisItemView.randomBoxItem(point: point)
        let panGest = UIPanGestureRecognizer.init(target: self, action: #selector(GameViewController.itemTouch(_:)))
        let longGest = UILongPressGestureRecognizer.init(target: self, action: #selector(GameViewController.itemTouch(_:)))
        panGest.require(toFail: longGest)
        item.addGestureRecognizer(longGest)
        item.addGestureRecognizer(panGest)
        _ = self.tetrisBoxView.addItem(shape: item, point: point)
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
                    
                    // 从box移除item
                    self.tetrisBoxView.remove(itemView)
                    
                    // 生成新的Item
                    self.addBoxRandomItemView(point: itemView.point!)
                    
                    // item添加到map更新itempoint
                    self.tetrisMapView.addItem(shape: itemView, point: TetrisPoint.init(x: numX, y: numY))
                    
                    // 判断能否消除
                    self.tetrisMapView.checkClean()
                    
                    // 判断能否继续游戏
                    if !self.checkGameOver() {
                        // gameover
                        self.gameOver()
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
    
    func addNewBoxItems() {
        for i in 1...3 {
            self.addBoxRandomItemView(point: TetrisPoint.init(x: 1 + 5 * (i - 1), y: 0))
        }
    }
    
    // 判断能否继续游戏
    func checkGameOver() -> Bool {
        let shapeViews = self.tetrisBoxView.itemViews
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
                if canPlace { break }
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
        } else {
            return false
        }
        
    }
    
    func gameOver() {
        let gameOverVC = GameOverViewController.init(nibName: "GameOverViewController", bundle: nil)
        gameOverVC.modalPresentationStyle = .overCurrentContext
        self.present(gameOverVC, animated: true) {
            gameOverVC.view.alpha = 0.8
        }
    }
    
    // MARK: -- Observer
    static func scoreValueChanged(value: Int) {
        let notify = Notification.Name.init("ScoreAdded")
        NotificationCenter.default.post(name: notify, object: nil, userInfo: ["score": value])
    }
    
    func gameScoreValueChanged(notification: Notification) {
        if let score = notification.userInfo?["score"] as? Int {
            self.gameScore += score
            self.scoreLabel.text = "分数:\(self.gameScore)"
        }
    }
    
    static func restart() {
        let notify = Notification.init(name: .init(rawValue: "Restart"))
        NotificationCenter.default.post(notify)
    }
    
    func restartGame() {
        self.tetrisMapView.clean()
        self.tetrisBoxView.clean()
        self.gameScore = 0
        self.addNewBoxItems()
    }
    
}
