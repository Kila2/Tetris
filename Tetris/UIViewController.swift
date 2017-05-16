//
//  UIViewController.swift
//  Tetris
//
//  Created by junlianglee on 2017/5/10.
//  Copyright © 2017年 kila. All rights reserved.
//

import UIKit

private let swizzling: (UIViewController.Type) -> () = { viewController in
    
    let originalSelector = #selector(viewController.didReceiveMemoryWarning)
    let swizzledSelector = #selector(viewController.proj_didReceiveMemoryWarning)
    
    let originalMethod = class_getInstanceMethod(viewController, originalSelector)
    let swizzledMethod = class_getInstanceMethod(viewController, swizzledSelector)
    
    method_exchangeImplementations(originalMethod, swizzledMethod) }

extension UIViewController {
    
    open override class func initialize() {
        // make sure this isn't a subclass
        guard self === UIViewController.self else { return }
        swizzling(self)
    }
    
    // MARK: - Method Swizzling
    
    func proj_didReceiveMemoryWarning() {
        self.proj_didReceiveMemoryWarning()
        
        let viewControllerName = NSStringFromClass(type(of: self))
        print("didReceiveMemoryWarning: \(viewControllerName)")
    }
}
