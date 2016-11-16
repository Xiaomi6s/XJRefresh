//
//  ReFreshBasicView.swift
//  XJRefreshTest
//
//  Created by rxj on 2016/11/15.
//  Copyright © 2016年 renxiaojian. All rights reserved.
//

import UIKit

enum RefreshState {
    case pullToRefresh      //上下拉刷新（闲置状态）
    case releaseToRefresh   //松开即可刷新
    case loading            //正在刷新
}


class ReFreshBasicView: UIView {
    
    
    weak var scrollView: UIScrollView? {
        didSet{
            scrollView?.addSubview(self)
        }
    }
    var refreshClosure: RefreshClosure?
    var refreshHeight: CGFloat
    var stateLabel: UILabel!
    var arrowImgView: UIImageView!
    var activityIndicator: UIActivityIndicatorView!
    override init(frame: CGRect) {
        refreshHeight = frame.height
        super.init(frame: frame)
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        stateLabel = UILabel()
        stateLabel.font = UIFont.systemFont(ofSize: 14)
        addSubview(stateLabel)
        
        arrowImgView = UIImageView()
        arrowImgView.image = #imageLiteral(resourceName: "arrow")
        addSubview(arrowImgView)
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.isHidden = true
        activityIndicator.activityIndicatorViewStyle = .gray
        addSubview(activityIndicator)
        
        configConstraintForSubView()
    }
    //配置约束
    private func configConstraintForSubView() {
        stateLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(20)
           
        }
        arrowImgView.snp.makeConstraints { (make) in
            make.right.equalTo(stateLabel.snp.left).offset(-10)
            make.centerY.equalTo(stateLabel.snp.centerY)
            make.height.equalTo(40)
            make.width.equalTo(15)
        }
        activityIndicator.snp.makeConstraints { (make) in
            make.center.equalTo(arrowImgView)
            make.height.width.equalTo(20)
           
        }
    }
    
}
