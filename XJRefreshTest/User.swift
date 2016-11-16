//
//  User.swift
//  XJRefreshTest
//
//  Created by rxj on 2016/11/15.
//  Copyright © 2016年 renxiaojian. All rights reserved.
//

import Foundation

struct UserInfo {
    var name: String?
    var icon: String?
    var introduction: String?
    init(name: String?, icon: String?, introduction: String?) {
        self.name = name
        self.icon = icon
        self.introduction = introduction
    }
    init() {
        self.init(name: "[unnamed]", icon: nil, introduction: nil)
    }
}
