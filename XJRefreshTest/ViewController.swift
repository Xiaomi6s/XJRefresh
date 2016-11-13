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
    override func viewDidLoad() {
        super.viewDidLoad()
        addrefresh()
        table.refreshHeader?.beginRefresh()
        
        
    }
    func addrefresh() {
            table.addHeaderRefresh {
            self.perform(#selector(self.stopRefresh), with: self, afterDelay: 2)
        }
    }
    
    func stopRefresh() {
        table.refreshHeader?.endRefresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }


}
extension ViewController: UITableViewDataSource, UITableViewDelegate {
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = NextVC()
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

