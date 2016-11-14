//
//  RefreshHeader.swift
//  XJRefreshTest
//
//  Created by rxj on 2016/11/13.
//  Copyright © 2016年 renxiaojian. All rights reserved.
//

import UIKit

enum RefreshState {
    case pullToRefresh      //下拉刷新（闲置状态）
    case releaseToRefresh   //松开即可刷新
    case loading            //正在刷新
}

let contentOffsetKey = "contentOffset"
let timeInterval = 0.25

class RefreshHeader: UIView {
    
    var pullDownToRefreshText = "下拉刷新"
    var releaseToRefreshText = "松开刷新"
    var loadingText = "正在加载..."
    
    weak var scrollView: UIScrollView? {
        didSet{
            scrollView?.addSubview(self)
        }
    }
    private var state: RefreshState = .pullToRefresh {
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
        super.init(frame: frame)
        setupUI()
        
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
    
    private func setupUI() {
        
        stateLabel = UILabel()
        stateLabel.font = UIFont.systemFont(ofSize: 14)
        stateLabel.text = pullDownToRefreshText
        addSubview(stateLabel)
        
        arrowImgView = UIImageView()
        arrowImgView.image = #imageLiteral(resourceName: "arrow")
        addSubview(arrowImgView)
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.isHidden = true
        activityIndicator.activityIndicatorViewStyle = .gray
        addSubview(activityIndicator)
        
        addConstraintForSubView()
    }
    
    //添加oberver
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
        state = .pullToRefresh
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
            let offset = CGPoint(x: 0, y: -refreshHeight)
            scrollView?.setContentOffset(offset, animated: true)
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            arrowImgView.isHidden = true
            
        }
    }
    
}


