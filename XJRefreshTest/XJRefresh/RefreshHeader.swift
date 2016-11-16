//
//  RefreshHeader.swift
//  XJRefreshTest
//
//  Created by rxj on 2016/11/13.
//  Copyright © 2016年 renxiaojian. All rights reserved.
//

import UIKit

fileprivate let contentOffsetKey = "contentOffset"
fileprivate let contentSizeKey = "contentSize"
private let timeInterval = 0.25 //动画时间

class RefreshHeader: ReFreshBasicView {
    
    var pullDownToRefreshText = "下拉刷新"
    var releaseToRefreshText = "松开刷新"
    var loadingText = "正在加载..."
    
    fileprivate var state: RefreshState = .pullToRefresh {
        didSet{
            if oldValue != state {
                handleState()
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        stateLabel.text = pullDownToRefreshText
        
    }
    
    deinit {
        print("RefreshHeader deinit")
        
    }
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview is UIScrollView {
            addoberver()
        }
    }
    //添加oberver
    private func addoberver() {
        scrollView?.addObserver(self, forKeyPath: contentOffsetKey, options: .new, context: nil)
        scrollView?.addObserver(self, forKeyPath: contentSizeKey, options: .new, context: nil)
        
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == contentOffsetKey {
            scrollViewContentOffsetDidChange()
        } else if keyPath == contentSizeKey {
            self.frame = CGRect(x: self.frame.minX, y: self.frame.minY, width: self.scrollView!.frame.width, height: refreshHeight)
            
        }
        else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func scrollViewContentOffsetDidChange() {
        if (scrollView?.isDragging)! {
            if state != .loading {
                if (scrollView?.contentOffset.y)! > -refreshHeight {
                    state = .pullToRefresh
                } else {
                    state = .releaseToRefresh
                }
            }
        }
        else {
            if state == .releaseToRefresh {
                state = .loading
            }
        }
    }
    //改变title
    private func updateTitle() {
        switch state {
        case .pullToRefresh:
            stateLabel.text = pullDownToRefreshText
        case .releaseToRefresh:
            stateLabel.text = releaseToRefreshText
        case .loading:
            stateLabel.text = loadingText
            
        }
    }
    //状态改变的处理
    private  func handleState() {
        updateTitle()
        switch state {
        case .pullToRefresh:
            UIView.animate(withDuration: timeInterval, animations: {
                self.arrowImgView.transform = CGAffineTransform(rotationAngle: 0)
            })
            
        case .releaseToRefresh:
            UIView.animate(withDuration: timeInterval, animations: {
                self.arrowImgView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
            })
            
        case .loading:
            refreshClosure!()
            UIView.animate(withDuration: timeInterval * 2, animations: {
                self.scrollView?.contentInset.top = self.refreshHeight
                
            })
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            arrowImgView.isHidden = true
            
        }
    }
    
}
extension RefreshHeader {
    func refresh(OfClosure closure: @escaping RefreshClosure) {
        refreshClosure = closure
    }
    
    func endRefresh() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        arrowImgView.isHidden = false
        arrowImgView.transform = CGAffineTransform(rotationAngle: 0)
        state = .pullToRefresh
        UIView.animate(withDuration: timeInterval * 2, animations: {
            self.scrollView?.contentInset.top = 0
            if let footer: RefreshFooter = self.scrollView?.refreshFooter {
                footer.notMore = false
                if !footer.automaticallyRefresh {
                    self.scrollView?.contentInset.bottom = 0
                    
                }
            }
        })
        
        
        
    }
    func beginRefresh() {
        if state == .loading {
            return
        }
        state = .loading
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: timeInterval * 2, animations: {
                self.scrollView?.contentInset.top = self.refreshHeight
                
            })
        }
        
    }
}




