//
//  UIScrollView+.swift
//  XJRefreshTest
//
//  Created by rxj on 2016/11/13.
//  Copyright © 2016年 renxiaojian. All rights reserved.
//

import Foundation
import UIKit


var  RefreshHeaderKey: Void?
typealias RefreshClosure = () ->Void


extension UIScrollView {
   weak var refreshHeader: RefreshHeader? {
        
        set{
            objc_setAssociatedObject(self, &RefreshHeaderKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            return objc_getAssociatedObject(self, &RefreshHeaderKey) as? RefreshHeader
        }

    }
    func addHeaderRefresh(_ closure: @escaping RefreshClosure) {
        refreshHeader = RefreshHeader(frame: CGRect(x: 0, y: -60, width: UIScreen.main.bounds.width, height: 60))
        refreshHeader?.scrollView = self
        refreshHeader?.refresh(OfClosure: closure)
    }
    
    open override class func initialize() {
    
        //保证只能执行一次
        DispatchQueue.once(token: "initialize", closure: {
            let method1 = class_getInstanceMethod(self, #selector(xjdeaclloc))
            let method2 = class_getInstanceMethod(self, NSSelectorFromString("dealloc"))
            method_exchangeImplementations(method1, method2)
        })
      
    }
    func xjdeaclloc() {
        if self.refreshHeader != nil {
            self.removeObserver(self.refreshHeader!, forKeyPath: contentOffsetKey) // 移除观察者
            self.refreshHeader?.removeFromSuperview()
            self.refreshHeader = nil //保证refreshHeader正常释放
        }
        xjdeaclloc()
    }
}

extension DispatchQueue {
     private static var _onceTracker = [String]()
    class func once(token: String, closure: () -> Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        closure()
    }
}
