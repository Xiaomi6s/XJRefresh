//
//  RefreshHeader.swift
//  XJRefreshTest
//
//  Created by rxj on 2016/11/13.
//  Copyright © 2016年 renxiaojian. All rights reserved.
//

import UIKit

enum RefreshState {
    case pullDownToRefresh
    case releaseToRefresh
    case loading
}

let contentOffsetKey = "contentOffset"
let timeInterval = 0.25

class RefreshHeader: UIView {

    var pullDownToRefreshText = "下拉刷新"
    var releaseToRefreshText = " 松开刷新"
    var loadingText = "正在加载"
  
    weak var scrollView: UIScrollView? {
        willSet{
        }
        didSet{
            scrollView?.addSubview(self)
           
        }
    }
   private var state: RefreshState = .pullDownToRefresh {
        didSet{
            if oldValue != state {
                handleState()
            }
        }
    }
  private  var refreshClosure: RefreshClosure?
  private  var refreshHeight: CGFloat
  private  var stateLabel: UILabel!
  private  var arrowImgView: UIImageView!
  private  var activityIndicator: UIActivityIndicatorView!
    override init(frame: CGRect) {
        refreshHeight = frame.height
        stateLabel = UILabel()
        stateLabel.text = pullDownToRefreshText
        arrowImgView = UIImageView()
        arrowImgView.image = #imageLiteral(resourceName: "arrow")
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.isHidden = true
        activityIndicator.activityIndicatorViewStyle = .gray
        super.init(frame: frame)
        addSubview(stateLabel)
        addSubview(arrowImgView)
        addSubview(activityIndicator)
        addConstraintForSubView()
      
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
    
   private func addoberver() {
        scrollView?.addObserver(self, forKeyPath: contentOffsetKey, options: .new, context: nil)
    
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == contentOffsetKey {
            scrollViewContentOffsetDidChange()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refresh(OfClosure closure: @escaping RefreshClosure) {
        refreshClosure = closure
    }
    
    func endRefresh() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        arrowImgView.isHidden = false
        arrowImgView.transform = CGAffineTransform(rotationAngle: 0)
        state = .pullDownToRefresh
        scrollView?.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
    }
    func beginRefresh() {
        if state == .loading {
            return
        }
        state = .loading
        DispatchQueue.main.async {
            self.scrollView?.setContentOffset(CGPoint(x: 0, y: -self.refreshHeight), animated: true)
        }
        
    }
    
   private func scrollViewContentOffsetDidChange() {
        if (scrollView?.isDragging)! {
            if state != .loading {
                if (scrollView?.contentOffset.y)! > -refreshHeight {
                    state = .pullDownToRefresh
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
   private func afterLoading() {
         scrollView?.setContentOffset(CGPoint(x: 0, y: -refreshHeight), animated: true)
    }
    
   private func addConstraintForSubView() {
        arrowImgView.snp.makeConstraints { (make) in
            make.right.equalTo(stateLabel.snp.left).offset(-10)
            make.top.equalTo(self).offset(10)
            make.height.equalTo(40)
            make.width.equalTo(15)
        }
        stateLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(arrowImgView)
            make.centerX.equalToSuperview()
        }
        activityIndicator.snp.makeConstraints { (make) in
            make.center.equalTo(arrowImgView)
            make.width.height.equalTo(20)
        }
    }
    
   private func updateTitle() {
        switch state {
        case .pullDownToRefresh:
            stateLabel.text = pullDownToRefreshText
        case .releaseToRefresh:
             stateLabel.text = releaseToRefreshText
        case .loading:
            stateLabel.text = loadingText
            
        }
    }
  private  func handleState() {
        updateTitle()
        switch state {
        case .pullDownToRefresh:
             UIView.animate(withDuration: timeInterval, animations: {
                self.arrowImgView.transform = CGAffineTransform(rotationAngle: 0)
             })
            
        case .releaseToRefresh:
            UIView.animate(withDuration: timeInterval, animations: {
                self.arrowImgView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
            })
           
        case .loading:
             refreshClosure!()
            let offset = CGPoint(x: 0, y: -refreshHeight)
            scrollView?.setContentOffset(offset, animated: true)
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            arrowImgView.isHidden = true
            
        }
    }

}


