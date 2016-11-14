//
//  RefreshFooter.swift
//  XJRefreshTest
//
//  Created by rxj on 2016/11/14.
//  Copyright © 2016年 renxiaojian. All rights reserved.
//

import UIKit

class RefreshFooter: UIView {

    var pullUpToMoreText = "上拉加载更多"
    var releaseToMoreText = "松开加载更多"
    var loadingMoreText = "正在加载更多..."
    weak var scrollView: UIScrollView? {
        didSet{
            scrollView?.addSubview(self)
        }
    }
    var state: RefreshState = .pullToRefresh {
        didSet{
            if state != oldValue {
                stateChangeHandle()
            }
        }
    }
    var isMore: Bool = false
    var refreshHeight: CGFloat
    private  var refreshClosure: RefreshClosure?
    
    
    var arrowImgView: UIImageView!
    var stateLabel: UILabel!
    var activityIndicator: UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        refreshHeight = frame.height
        super.init(frame: frame)
        setupUI()
    }
    deinit {
        print("deinit RefreshFooter")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview is UIScrollView {
            addObserver()
            let ishidden = (scrollView?.contentSize.height)! > (scrollView?.frame.height)! ? false: true
            self.isHidden = ishidden
        }
    }
   func addObserver() {
        scrollView?.addObserver(self, forKeyPath: contentOffsetKey, options: .new, context: nil)
        scrollView?.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == contentOffsetKey {
            scrollViewContentOffsetDidChange()
        } else if keyPath == "contentSize" {
            isMore = true
           frame = CGRect(x: 0, y: (scrollView?.contentSize.height)!, width: UIScreen.main.bounds.width, height: refreshHeight)
            let ishidden = (scrollView?.contentSize.height)! > (scrollView?.frame.height)! ? false: true
            self.isHidden = ishidden
            
            
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    func stateChangeHandle() {
        changeTitle()
        switch state {
        case .pullToRefresh:
            UIView.animate(withDuration: timeInterval, animations: { 
                self.arrowImgView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
            })
        case .releaseToRefresh:
            UIView.animate(withDuration: timeInterval, animations: {
                self.arrowImgView.transform = CGAffineTransform.identity
            })
            isMore = false
            
        case .loading:
            refreshClosure!()
            self.isHidden = false
            arrowImgView.isHidden = true
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            let contentH = scrollView?.contentSize.height
            let frameH = scrollView?.frame.height
            let offsetH = contentH! - frameH! > 0 ? contentH! - frameH!: 0
            let offset = CGPoint(x: 0, y: offsetH + refreshHeight)
            scrollView?.setContentOffset(offset, animated: true)
      
        }
    }
    
    func endRefresh() {
        
        let ishidden = (scrollView?.contentSize.height)! > (scrollView?.frame.height)! ? false: true
        self.isHidden = ishidden
        self.arrowImgView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
        arrowImgView.isHidden = false
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        state = .pullToRefresh
        if isMore == false {
            let contentH = scrollView?.contentSize.height
            let frameH = scrollView?.frame.height
            let offsetH = contentH! - frameH! > 0 ? contentH! - frameH!: 0
            let offset = CGPoint(x: 0, y: offsetH)
            scrollView?.setContentOffset(offset, animated: true)
        }
      
    }
    
    func changeTitle() {
        switch state {
        case .pullToRefresh:
            stateLabel.text = pullUpToMoreText
        case .releaseToRefresh:
            stateLabel.text = releaseToMoreText
        case .loading:
            stateLabel.text = loadingMoreText
       
        }
    }
    
    func scrollViewContentOffsetDidChange() {
        print(((scrollView?.contentOffset.y)! - ((scrollView?.contentSize.height)! - (scrollView?.frame.height)!)))
        if (scrollView?.isDragging)! {
            if state != .loading {
                let contentH = scrollView?.contentSize.height
                let frameH = scrollView?.frame.height
                let offset = contentH! - frameH! > 0 ? contentH! - frameH!: 0
                if ((scrollView?.contentOffset.y)! - offset) <  refreshHeight {
                    state = .pullToRefresh
                } else {
                    state = .releaseToRefresh
                }
            }
        } else {
            if state == .releaseToRefresh {
                state = .loading
            }
            
        }
    }
    
    func setupUI() {
        
        stateLabel = UILabel()
        stateLabel.font = UIFont.systemFont(ofSize: 14)
        stateLabel.text = pullUpToMoreText
        addSubview(stateLabel)
        
        arrowImgView = UIImageView()
        arrowImgView.image = #imageLiteral(resourceName: "arrow")
        arrowImgView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
        addSubview(arrowImgView)
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.isHidden = true
        activityIndicator.activityIndicatorViewStyle = .gray
        addSubview(activityIndicator)
        
        configConstraintForSubView()
    }
    
    func configConstraintForSubView() {
        stateLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(20)
        }
        arrowImgView.snp.makeConstraints { (make) in
            make.right.equalTo(stateLabel.snp.left).offset(-10)
            make.centerY.equalTo(stateLabel.snp.centerY)
        }
        activityIndicator.snp.makeConstraints { (make) in
            make.center.equalTo(arrowImgView)
            make.height.equalTo(40)
            make.width.equalTo(15)
        }
    }
    
    func refresh(OfClosure closure: @escaping RefreshClosure) {
        refreshClosure = closure
    }
    

}
