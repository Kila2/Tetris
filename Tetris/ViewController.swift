//
//  ViewController.swift
//  Tetris
//
//  Created by junlianglee on 2017/4/25.
//  Copyright © 2017年 kila. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var tetrisMapView = TetrisMapView.factory(type: .Main)
    var tetrisBoxView = TetrisMapView.factory(type: .Box)
    var originPoint:CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(tetrisMapView)
        self.view.addSubview(tetrisBoxView)
        
        for shape in TetrisItemEnum.allValues {
            let S = TetrisItemView.makeTetrisItem(main: shape)
            tetrisMapView.addItem(shape: S, position: (0,0))
            let ss = S.clone()
            tetrisMapView.addItem(shape: ss, position: (2,2))
            
            let S2 = TetrisItemView.makeTetrisItem(box: shape)
            
            let panGest = UIPanGestureRecognizer.init(target: self, action: #selector(ViewController.itemTouch(_:)))
            S2.addGestureRecognizer(panGest)
            tetrisBoxView.addItem(shape: S2, position: (5,0))
            
            
            tetrisBoxView.addItem(shape: S2.clone(), position: (3,3))
        }
        
        //        tetrisMapView.addItem(shape: TetrisItemView.makeTetrisItem(shape: .I), rowcol: (0,2))
        //
        //        let items = [Item.I,Item.J,Item.L,Item.O,Item.S,Item.Z,Item.T]
        //        for item in items {
        //            let v = item
        
        //            self.addSubview(item)
        //        }
        //        drawBox()
    }
    
    
    func itemTouch(_ recognizer:UIPanGestureRecognizer) {
        
        if recognizer.state == .ended || recognizer.state == .cancelled {
            if let itemView = recognizer.view as? TetrisItemView {
                var canPlace = true
                if canPlace {
                    let itemFrame = tetrisMapView.convert(itemView.frame, from: tetrisBoxView)
                    if tetrisMapView.frame.contains(itemFrame) {
                        let numX = Int(((itemFrame.minX)/(self.tetrisMapView.blockSize.width + tetrisMapView.space)))
                        let x = CGFloat(numX)*(self.tetrisMapView.blockSize.width + tetrisMapView.space)
                        let numY = Int(((itemFrame.minY)/(self.tetrisMapView.blockSize.height + tetrisMapView.space)))
                        let y = CGFloat(numY)*(self.tetrisMapView.blockSize.height + tetrisMapView.space)
                        let point = CGPoint.init(x: x, y: y)
                        recognizer.view?.frame.origin = point
                        
                        tetrisMapView.addSubview(itemView)
                        
                        for gest in itemView.gestureRecognizers! {
                            itemView.removeGestureRecognizer(gest)
                        }
                    }
                    else {
                        UIView.animate(withDuration: 0.2, animations: { 
                            itemView.frame.origin = self.originPoint
                            itemView.zoom(type: .Box)
                        })
                        
                    }
                }
                else {
                    UIView.animate(withDuration: 0.2, animations: {
                        itemView.frame.origin = self.originPoint
                        itemView.zoom(type: .Box)
                    })
                }
                
            }
            return
        }
        
        if recognizer.state == .began {
            
            if let itemView = recognizer.view as? TetrisItemView {
                itemView.zoom(type: .Main)
                originPoint = itemView.frame.origin
            }
            
            
            //            if let ov = recognizer.view, let lv = self.view.subviews.last, ov != lv{
            //                self.view.bringSubview(toFront: ov)
            //            }
        }
        let point=recognizer.location(in: self.tetrisBoxView)
        recognizer.view?.center = point
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func addItem(_ item:UIView) {
        self.view.addSubview(item)
    }
    
    
    
}

