//
//  ViewController.swift
//  XJRefreshTest
//
//  Created by rxj on 2016/11/13.
//  Copyright © 2016年 renxiaojian. All rights reserved.
//

import UIKit
import SnapKit
class ViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    var users = [UserInfo]()
    var i = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        table.estimatedRowHeight = 50
        table.rowHeight = UITableViewAutomaticDimension
        table.separatorStyle = .none
        addrefresh()
        table.refreshHeader?.beginRefresh()
        table.register(UINib(nibName: "TestCell", bundle: nil), forCellReuseIdentifier: "TestCell")
        
        
    }
    
    func loadData() {
        users.removeAll()
        var user1 = UserInfo()
        user1.name = "张小凡"
        user1.introduction = "张小凡,诛仙中的灵魂人物。在后草庙村长大，从小资质平庸，但有一手好厨艺，他的性格坚毅，为人重情重义。他一生多灾多难，总是在仇恨、恩情、爱情中挣扎，与三个女子有着情感纠葛。他同修佛、道、魔。即使在最困难的时候也没有丢掉他的善良。少年时期天音寺的普智大师传授大梵般若，随后又进入青云门下成为大竹峰首座田不易的弟子并意外获得法宝“烧火棍”，因一番遭遇他入了魔教成为鬼王（张鲁一饰）的得力助手鬼厉。最后他用诛.."
        var user2 = UserInfo()
        user2.name = "陆雪琪"
        user2.introduction = "陆雪琪，诛仙中最冷艳的女子。从小天资聪慧，拜在小竹峰水月大师门下，极受恩师宠爱。她喜爱穿着白衣，手中法宝是天琊神剑她的性子较为清冷，不喜言辞，她是正道青云门下弟子中修为名列前茅，她的剑舞无人能敌。因在七脉会武中与张小凡相识，并在之后的历练中两人互相生情，之后张小凡入魔道，她一直徘徊在正义与爱情边缘，为了正义与张小凡刀戈相见。最后张小凡回归正道与她一起隐居，携手到老。"
        var user3 = UserInfo()
        user3.name = "碧瑶"
        user3.introduction = "碧瑶，诛仙中鬼王之女，貌美如花，穿着绿衣，个性直率善良，爱憎分明，她的法宝是合欢铃，喜欢张小凡，在张小凡遇难时，用自己的身躯挡下诛仙主剑救了张小凡，自己却只留一魄，随后一直沉睡，不曾醒过。"
        var user4 = UserInfo()
        user4.name = "曾书书"
        user4.introduction = "曾书书，诛仙中青云门风回峰首座曾叔常的儿子，他风流倜傥，生性洒脱，喜爱收集异宝，喜欢美好的事物，同时也喜欢美女。与张小凡一见如故并结为好友，即使在张小凡入魔道之后还是一如既往的对待他。"
        var user5 = UserInfo()
        user5.name = "林惊羽"
        user5.introduction = "林惊羽，诛仙中青云门龙首峰首座苍松道人的弟子，从小天资过人，聪明伶俐，与张小凡是同村伙伴，他们一起遭遇屠村惨祸，他刻苦修炼，修为很高，他的法宝是斩龙剑。"
        var user6 = UserInfo()
        user6.name = "田灵儿"
        user6.introduction = "田灵儿，诛仙中青云门大竹峰田不易的女儿，张小凡的师姐，她聪明可爱，善良单纯，张小凡的曾经的暗恋对象，可是她一直把张小凡当做弟弟。她钦慕的对象是龙首峰的弟子齐昊，她勇敢追逐自己的爱情，最后与齐昊在一起。"
        users.append(user1)
        users.append(user2)
        users.append(user3)
        users.append(user4)
        users.append(user5)
        users.append(user6)
    }
    func loadMore() {
        if self.i < 6 {
           users.append(contentsOf: users[0...5]) 
        } else {
            table.refreshFooter?.notMore = true
        }
        
    }
    
    func addrefresh() {
            table.addHeaderRefresh { [unowned self] in
             self.i = 0
            self.perform(#selector(self.stopRefresh), with: self, afterDelay: 2)
        }
       
        table.addFooterRefresh { [unowned self] in
            self.i += 1
             self.perform(#selector(self.footerstop), with: self, afterDelay: 2)
        }
         table.refreshFooter?.automaticallyRefresh = true
    }
    
    func stopRefresh() {
        self.loadData()
       table.reloadData()
        table.refreshHeader?.endRefresh()
       
    }
    func footerstop() {
        self.loadMore()
        table.reloadData()
         table.refreshFooter?.endRefresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }


}
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "TestCell") as! TestCell
        cell.conffigContent(users[indexPath.row])
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = NextVC()
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

