//
//  TestCell.swift
//  XJRefreshTest
//
//  Created by rxj on 2016/11/15.
//  Copyright © 2016年 renxiaojian. All rights reserved.
//

import UIKit

class TestCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    }
    
    func conffigContent(_ userinfo: UserInfo) {
        titleLabel.text = userinfo.name
        contentLabel.text = userinfo.introduction
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
