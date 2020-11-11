//
//  RefreshFooter.swift
//  XJRefreshTest
//
//  Created by rxj on 2016/11/14.
//  Copyright © 2016年 renxiaojian. All rights reserved.
//

import UIKit

fileprivate let contentOffsetKey = "contentOffset"
fileprivate let contentSizeKey = "contentSize"
private let timeInterval = 0.25 //动画时间

class RefreshFooter: ReFreshBasicView {
    
    var pullUpToMoreText = "上拉加载更多"
    var releaseToMoreText = "松开加载更多"
    var loadingMoreText = "正在加载更多..."
    var notMoreText = "没有更多了"
    
    /// 是否启用到底部自动加载更多
    var automaticallyRefresh: Bool = false {
        didSet{
            scrollView?.contentInset.bottom = refreshHeight
            arrowImgView.isHidden = true
            activityIndicator.hidesWhenStopped = false
            activityIndicator.isHidden = false
        }
    }
    /// 没有更多
    var notMore: Bool = false {
        didSet{
            if notMore != oldValue {
                nomoreStatehandle()
            }
        }
    }
    
    fileprivate var state: RefreshState = .pullToRefresh {
        didSet{
            if state != oldValue {
                stateChangeHandle()
            }
        }
    }
    private  var currentOffsetY: CGFloat = 0
    override init(frame: CGRect) {
        super.init(frame: frame)
        stateLabel.text = pullUpToMoreText
        arrowImgView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
    }
    deinit {
        scrollView?.removeObserver(self, forKeyPath: contentOffsetKey)
        scrollView?.removeObserver(self, forKeyPath: contentSizeKey)
        print("deinit RefreshFooter")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview is UIScrollView {
            addObserver()
            self.isHidden = isHiddeFooter()
        }
    }
    
  
    private func addObserver() {
        scrollView?.addObserver(self, forKeyPath: contentOffsetKey, options: .new, context: nil)
        scrollView?.addObserver(self, forKeyPath: contentSizeKey, options: .new, context: nil)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == contentOffsetKey {
            guard !notMore else {
                return
            }
            scrollViewContentOffsetDidChange()
        } else if keyPath == contentSizeKey {
            frame = CGRect(x: 0, y: (scrollView?.contentSize.height)!, width: (scrollView?.frame.width)!, height: refreshHeight)
            isHidden = isHiddeFooter()
            
            
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    private func scrollViewContentOffsetDidChange() {
        let newOffsetY = (scrollView?.contentOffset.y)!
        if (scrollView?.isDragging)! {
            if state != .loading {
                let offset = offsetDifference()
                if (currentOffsetY - offset) <  refreshHeight {
                    state = .pullToRefresh
                    autoRefresh(newOffsetY)
                    
                } else {
                    state = .releaseToRefresh
                }
            }
        } else {
            
            if state == .releaseToRefresh {
                state = .loading
            }
            
        }
        currentOffsetY = newOffsetY
    }
    
    /// 是否进入加载状态
    ///
    /// - Parameter newOffsetY: newOffsetY
    private func autoRefresh(_ newOffsetY: CGFloat) {
        guard automaticallyRefresh else {
            return
        }
        if newOffsetY > currentOffsetY {
            if newOffsetY >= offsetDifference() {
                if state != .loading {
                    state = .loading
                }
            }
        }
    }
    
    /// notmore状态改变
    private func nomoreStatehandle() {
        if notMore {
            stateLabel.text = notMoreText
            arrowImgView.isHidden = true
            activityIndicator.isHidden = true
            if !automaticallyRefresh {
               scrollView?.contentInset.bottom = refreshHeight
            }
        } else {
            state = .pullToRefresh
            if automaticallyRefresh {
                stateLabel.text = loadingMoreText
                activityIndicator.isHidden = false
            } else {
                
                stateLabel.text = pullUpToMoreText
                arrowImgView.isHidden = false
               
            }
        }
    }
    
    /// 状态改变处理
    private func stateChangeHandle() {
        changeTitle()
        switch state {
        case .pullToRefresh:
            UIView.animate(withDuration: timeInterval, animations: {
                self.arrowImgView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            })
        case .releaseToRefresh:
            UIView.animate(withDuration: timeInterval, animations: {
                self.arrowImgView.transform = CGAffineTransform.identity
            })
            
        case .loading:
            refreshClosure!()
            self.isHidden = false
            arrowImgView.isHidden = true
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            if !automaticallyRefresh {
                UIView.animate(withDuration: timeInterval * 2, animations: { 
                    self.scrollView?.contentInset.bottom = self.refreshHeight
                })
                
            }
        }
    }
    
    /// 改变状态文字
    private  func changeTitle() {
        guard !automaticallyRefresh else {
            stateLabel.text = loadingMoreText
            return
        }
        switch state {
        case .pullToRefresh:
            stateLabel.text = pullUpToMoreText
        case .releaseToRefresh:
            stateLabel.text = releaseToMoreText
        case .loading:
            stateLabel.text = loadingMoreText
            
        }
    }
    
    //contentsize.hight与frame.hight的差值
    private func offsetDifference() -> CGFloat {
        let contentH = scrollView?.contentSize.height
        let frameH = scrollView?.frame.height
        let offset = contentH! - frameH! > 0 ? contentH! - frameH!: 0
        return offset
    }
    //是否隐藏footer
    fileprivate func isHiddeFooter() -> Bool {
        return (scrollView?.contentSize.height)! > (scrollView?.frame.height)! ? false: true
    }
}

extension RefreshFooter {
    
    func refresh(OfClosure closure: @escaping RefreshClosure) {
        refreshClosure = closure
    }
    
    /// 结束刷新
    func endRefresh() {
        isHidden = isHiddeFooter()
        arrowImgView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        activityIndicator.stopAnimating()
        if !notMore {
            state = .pullToRefresh
        }
        if !automaticallyRefresh {
            if !notMore {
                arrowImgView.isHidden = false
                activityIndicator.isHidden = true
                self.scrollView?.contentInset.bottom = 0
            }
            
        }
       
      
        
    }
}
