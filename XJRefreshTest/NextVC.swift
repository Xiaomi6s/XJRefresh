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
    override func viewDidLoad() {
        super.viewDidLoad()
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
    }
    
    func stopRefresh() {
        tableView.refreshHeader?.endRefresh()
    }
    


}

extension NextVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        cell?.textLabel?.text = "\(indexPath.section)-\(indexPath.row)"
        return cell!
    }
}
