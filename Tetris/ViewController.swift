//
//  ViewController.swift
//  Tetris
//
//  Created by junlianglee on 2017/4/25.
//  Copyright © 2017年 kila. All rights reserved.
//

import UIKit

class ItemView:UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        for view in self.subviews {
            if point.x > view.frame.minX && point.x < view.frame.maxX
            && point.y > view.frame.minY && point.y < view.frame.maxY {
                return view
            }
        }
        return nil
    }
}
enum Item {
    static var S = makeS()
    static var Z = makeZ()
    static var L = makeL()
    static var J = makeJ()
    static var I = makeI()
    static var O = makeO()
    static var T = makeT()
    
    static func makeS() -> UIView {
        let color = UIColor.init(hexString: "#FD9E20FF")
        let rowcol = [(1,0),(2,0),(0,1),(1,1)]
        return makeSquare(rowcol,color,bgsize: (3,2))
    }
    
    static func makeZ() -> UIView {
        let color = UIColor.init(hexString: "#FECE30FF")
        let rowcol = [(0,0),(1,0),(1,1),(2,1)]
        return makeSquare(rowcol,color, bgsize: (3,2))
    }
    
    static func makeL() -> UIView {
        let color = UIColor.init(hexString: "#56C2F0FF")
        let rowcol = [(0,0),(0,1),(0,2),(1,2)]
        return makeSquare(rowcol,color, bgsize: (2,3))
    }
    
    static func makeJ() -> UIView {
        let color = UIColor.init(hexString: "#28C35BFF")
        let rowcol = [(1,0),(1,1),(1,2),(0,2)]
        return makeSquare(rowcol,color, bgsize: (2,3))
    }
    
    static func makeI() -> UIView {
        let color = UIColor.init(hexString: "#FA6464FF")
        let rowcol = [(0,0),(0,1),(0,2),(0,3)]
        return makeSquare(rowcol,color, bgsize: (1,4))
    }
    
    static func makeO() -> UIView {
        let color = UIColor.init(hexString: "#22BFADFF")
        let rowcol = [(0,0),(0,1),(1,0),(1,1)]
        return makeSquare(rowcol,color, bgsize: (2,2))
    }
    
    static func makeT() -> UIView {
        let color = UIColor.init(hexString: "#FC80C3FF")
        let rowcol = [(0,0),(1,0),(2,0),(1,1)]
        return makeSquare(rowcol,color, bgsize: (3,2))
    }

    static func makeSquare(_ rowcol:[(Int,Int)] , _ color:UIColor?,bgsize:(row:CGFloat,col:CGFloat)) -> UIView {
        let rspace:CGFloat = Global.rspace
        let cspace:CGFloat = Global.cspace
        let width:CGFloat = Global.width
        let height:CGFloat = Global.height
        
        let bgrect = CGRect.init(x: 0, y: 0, width: width*bgsize.row, height: height*bgsize.col)
        let bgview = ItemView.init(frame: bgrect)
        for (i,j) in rowcol  {
            let rect = CGRect.init(x: width*CGFloat(i)+rspace*(CGFloat(i)-1), y: height*CGFloat(j)+cspace*(CGFloat(j)-1), width: width, height: height);
            let view = UIView.init(frame: rect)
            view.backgroundColor = color
            bgview.addSubview(view)
        }
        return bgview
    }

    
}
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        drawMap()
        drawBox()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func drawMap() {
        self.view.backgroundColor = Global.mainBackgroundColor
        _ = mainarea()
        
        let items = [Item.I,Item.J,Item.L,Item.O,Item.S,Item.Z,Item.T]
        for item in items {
            let v = item
            let panGest = UIPanGestureRecognizer.init(target: self, action: #selector(ViewController.itemTouch))
            v.addGestureRecognizer(panGest)
            self.view.addSubview(item)
        }
        
    }
    
    func drawBox() {
        let width:CGFloat = Global.width
        let height:CGFloat = 122
        
    }
    
    func mainarea() -> [[UIView]] {
    
        let left:CGFloat = Global.left
        let top:CGFloat = Global.top
        let rspace:CGFloat = Global.rspace
        let cspace:CGFloat = Global.cspace
        let row = Global.row
        let col = Global.col
        let width:CGFloat = Global.width
        let height:CGFloat = Global.height
    
        let color = UIColor.init(hexString: "#2C7AABFF")
        var views:[[UIView]] = []
    
        for i in 0..<row {
            views.append([])
            for j in 0..<col {
                let view = UIView.init(frame: CGRect.init(x: left+width*CGFloat(i)+rspace*(CGFloat(i)-1), y: top+height*CGFloat(j)+cspace*(CGFloat(j)-1), width: width, height: height))
                view.backgroundColor = color
                views[i].append(view)
                self.view.addSubview(view)
            }
        }
    
        return views
    }
    
    func addItem(_ item:UIView) {
        self.view.addSubview(item)
    }
    
    func itemTouch(_ recognizer:UIPanGestureRecognizer) {
        
        if recognizer.state == .ended || recognizer.state == .cancelled {
            let view = recognizer.view!
            let numX = Int(((view.frame.minX - Global.left)/(Global.width + Global.rspace)))
            let x = CGFloat(numX)*(Global.width + Global.rspace) + Global.left
            let numY = Int(((view.frame.minY - Global.top)/(Global.height + Global.cspace)))
            let y = CGFloat(numY)*(Global.height + Global.cspace) + Global.top
            let point = CGPoint.init(x: x, y: y)
            recognizer.view?.frame.origin = point
            for gest in view.gestureRecognizers! {
                view.removeGestureRecognizer(gest)
            }
            return
        }
        
        if let ov = recognizer.view, let lv = self.view.subviews.last, ov != lv{
            self.view.bringSubview(toFront: ov)
        }
        let point=recognizer.location(in: self.view)
        recognizer.view?.center = point
    }
    
}

