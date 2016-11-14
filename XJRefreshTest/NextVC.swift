//
//  NextVC.swift
//  XJRefreshTest
//
//  Created by rxj on 2016/11/13.
//  Copyright © 2016年 renxiaojian. All rights reserved.
//

import UIKit

class NextVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var list = [Int]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0...6 {
            list.append(i)
        }
        
        addrefresh()
        tableView.refreshHeader?.beginRefresh()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        print("NextV Cdeinit")


    }
    
    func addrefresh() {
        tableView.addHeaderRefresh { [unowned self] in
           
            self.perform(#selector(self.stopRefresh), with: self, afterDelay: 2)
        }
        tableView.addFooterRefresh { [unowned self] in
            for i in 0...2 {
                self.list.append(i)
            }
            self.perform(#selector(self.footerstop), with: self, afterDelay: 2)
        }
    }
    
    func stopRefresh() {
        var tmpList = [Int]()
        for i in 0...6 {
            tmpList.append(i)
        }
        self.list = tmpList
        tableView.reloadData()
        tableView.refreshHeader?.endRefresh()
    }
    func footerstop() {
        tableView.reloadData()
        tableView.refreshFooter?.endRefresh()
    }
    


}

extension NextVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        cell?.textLabel?.text = "\(indexPath.section)-\(list[indexPath.row])"
        return cell!
    }
}
