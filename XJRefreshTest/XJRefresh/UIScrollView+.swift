//
//  UIScrollView+.swift
//  XJRefreshTest
//
//  Created by rxj on 2016/11/13.
//  Copyright © 2016年 renxiaojian. All rights reserved.
//

import Foundation
import UIKit

fileprivate let contentOffsetKey = "contentOffset"
fileprivate let contentSizeKey = "contentSize"

var  RefreshHeaderKey: Void?
var  RefreshFooterKey: Void?
typealias RefreshClosure = () ->Void


extension UIScrollView {
    var refreshHeader: RefreshHeader? {
        set{
            objc_setAssociatedObject(self, &RefreshHeaderKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            return objc_getAssociatedObject(self, &RefreshHeaderKey) as? RefreshHeader
        }
    }
    
     var refreshFooter: RefreshFooter? {
        set{
           objc_setAssociatedObject(self, &RefreshFooterKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            return objc_getAssociatedObject(self, &RefreshFooterKey) as? RefreshFooter
        }
    }
    
    func addHeaderRefresh(_ closure: @escaping RefreshClosure) {
        refreshHeader = RefreshHeader(frame: CGRect(x: 0, y: -60, width: UIScreen.main.bounds.width, height: 60))
        refreshHeader?.scrollView = self
        refreshHeader?.refresh(OfClosure: closure)
    }
    func addFooterRefresh(_ closure: @escaping RefreshClosure) {
        refreshFooter = RefreshFooter(frame: CGRect(x: 0, y: frame.height, width: UIScreen.main.bounds.width, height: 60))
        refreshFooter?.scrollView = self
        refreshFooter?.refresh(OfClosure: closure)
    }
}
