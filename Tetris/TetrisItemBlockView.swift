//
//  TetrisItemBlockView.swift
//  Tetris
//
//  Created by junlianglee on 2017/5/19.
//  Copyright © 2017年 kila. All rights reserved.
//

import UIKit

struct TetrisPoint {
    var x: Int
    var y: Int
}

extension UIImage {
    
    /// 将当前图片缩放到指定宽度
    ///
    /// - parameter width: 指定宽度
    ///
    /// - returns: UIImage，如果本身比指定的宽度小，直接返回
//    func scaleImageToWidth(width: CGFloat) -> UIImage {
//        
//        // 1. 判断宽度，如果小于指定宽度直接返回当前图像
//        if size.width < width {
//            return self
//        }
//        
//        // 2. 计算等比例缩放的高度
//        let height = width * size.height / size.width
//        
//        // 3. 图像的上下文
//        let s = CGSize(width: width, height: height)
//        // 提示：一旦开启上下文，所有的绘图都在当前上下文中
//        UIGraphicsBeginImageContext(s)
//        
//        // 在制定区域中缩放绘制完整图像
//        draw(in: CGRect(origin: CGPoint.zero, size: s))
//        
//        // 4. 获取绘制结果
//        let result = UIGraphicsGetImageFromCurrentImageContext()
//        
//        // 5. 关闭上下文
//        UIGraphicsEndImageContext()
//        
//        // 6. 返回结果
//        return result!
//    }
    
    static func colorSizeImage(color:UIColor, size:CGSize = CGSize(width: 10, height: 10)) -> UIImage {
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()!
        color.setFill()
        context.fill(CGRect.init(origin: CGPoint.zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}


class TetrisItemBlockView: UIView {
    var tetrisPoint: TetrisPoint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func removeFromSuperview() {
        
//        removeAnimate()
//        self.backgroundColor = .white
        super.removeFromSuperview()
    }
    
    func removeAnimate() {
        let rect = CGRect(x: 0.0, y: 0, width: self.bounds.width,
                          height: self.bounds.height)
        let emitter = CAEmitterLayer()
        emitter.frame = rect
        self.layer.addSublayer(emitter)
        emitter.emitterShape = kCAEmitterLayerRectangle
        emitter.emitterMode = kCAEmitterLayerPoints
        //kCAEmitterLayerPoint
        //kCAEmitterLayerLine
        //kCAEmitterLayerRectangle
        emitter.emitterPosition = CGPoint.init(x: 0, y: 0)
        emitter.emitterSize = CGSize.init(width: self.bounds.width, height: self.bounds.height)
        
        let emitterCell = CAEmitterCell()
        let image = UIImage.colorSizeImage(color: self.backgroundColor!)
        
        emitterCell.contents = image.cgImage
        emitterCell.birthRate = 50  //每秒产生120个粒子
        emitterCell.lifetime = 3    //存活1秒
//        emitterCell.lifetimeRange = 3.0 //存活时间浮动范围
        emitter.emitterCells = [emitterCell]  //这里可以设置多种粒子 我们以一种为粒子
//        emitterCell.yAcceleration = 9  //给Y方向一个加速度
//        emitterCell.xAcceleration = -9 //x方向一个加速度
        emitterCell.velocity = 0 //初始速度
//        emitterCell.emissionLongitude = CGFloat(-Double.pi) //向左
//        emitterCell.velocityRange = 200.0   //随机速度 -200+20 --- 200+20
//        emitterCell.emissionRange = CGFloat(Double.pi/2) //随机方向 -pi/2 --- pi/2
//        //emitterCell.color = UIColor(red: 0.9, green: 1.0, blue: 1.0,
//        //   alpha: 1.0).CGColor //指定颜色
//        emitterCell.redRange = 0.3
//        emitterCell.greenRange = 0.3
//        emitterCell.blueRange = 0.3  //三个随机颜色
//        emitterCell.scale = 0.8
//        emitterCell.scaleRange = 0.8  //0 - 1.6
//        emitterCell.scaleSpeed = -0.15  //逐渐变小
//        emitterCell.alphaRange = 0.75   //随机透明度
//        emitterCell.alphaSpeed = -0.15  //逐渐消失
    }
}
