//
//  OtherTableViewController.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/06/02.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

import Foundation
import UIKit

class OtherTableViewController:UIViewController,UITableViewDelegate,UITableViewDataSource{
        let titles=["このサービスについて","お問い合わせ","利用規約"]

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self
        tableView.dataSource=self
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tabBarItem.title="その他"
        self.tabBarController?.navigationItem.title="その他"
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.row==0){
        self.navigationController?.pushViewController(MyWebViewController(url: "http://hubtele.net/about?mob_app=true",title: "このサービスについて"), animated: true)
        }else if(indexPath.row==1){
            self.navigationController?.pushViewController(MyWebViewController(url: "http://hubtele.net/inquiry?mob_app=true",title: "お問い合わせ"), animated: true)
        }else if(indexPath.row==2){
            self.navigationController?.pushViewController(MyWebViewController(url:"http://hubtele.net/term?mob_app=true",title:"利用規約"),animated:true)
        }
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCellWithIdentifier("otherCell",forIndexPath: indexPath) as UITableViewCell
        let a=cell.contentView
        (a.viewWithTag(3) as! UILabel).text=titles[indexPath.row]
        return cell
    }
    

}
