//
//  FirstViewController.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/01/01.
//  Copyright (c) 2016年 NakamaTakaaki. All rights reserved.
//

import UIKit

class ProgramTableViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	var datas: [ProgramInfo] = []
	var service: ProgramService!
    var refreshControl:UIRefreshControl!
	@IBOutlet weak var collectionView: UICollectionView!
	override func viewDidLoad() {
		self.service = ProgramServiceImpl()
		super.viewDidLoad()
        loadData()
        refreshControl=UIRefreshControl()
        refreshControl.addTarget(self, action: "loadData", forControlEvents: .ValueChanged)
        collectionView.addSubview(refreshControl)
        collectionView.alwaysBounceVertical=true
		collectionView.dataSource = self
		collectionView.delegate = self

		collectionView.scrollEnabled = true
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
    
    func loadData(){
        service.getTable().startWithNext({
            (table: [(String, ProgramInfo)]) -> () in
            self.datas = table.map({$0.1})
            self.reload()
        })
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
	
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		
		return 1
	}
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		return datas.count
	}
	
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		let vm = datas[indexPath.row]
		self.goChatScene(vm.program)
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = self.collectionView!.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) as! ProgramTableCell
		let data = datas[indexPath.row]
		cell.stationNameLabel.text = data.name
		cell.titleLabel.text = data.program.title
		cell.timeLabel.text = data.program.startAndEndFormatExcludeDay()
		cell.countLabel.text = "\(data.program.entryCount)"
		return cell
	}
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(2 - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(2))
        return CGSize(width: size, height: 190)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tabBarItem.title="放送中"
        self.tabBarController?.navigationItem.title="放送中の番組"
        if(NSUserDefaults.standardUserDefaults().objectForKey("agreedTerm") == nil){
            let alertController = UIAlertController(title: "利用規約" as String ,message:"利用規約に同意の上ご利用ください。" as String, preferredStyle: UIAlertControllerStyle.Alert)
            // this is the center of the screen currently but it can be any point in the view
            
            let otherAction = UIAlertAction(title: "利用規約", style: .Default) {
                action in      self.navigationController?.pushViewController(MyWebViewController(url:"http://hubtele.net/term?mob_app=true",title:"利用規約"),animated:true)
            }
            
            let blockAction = UIAlertAction(title: "同意する", style: .Default) {
                action in NSUserDefaults.standardUserDefaults().setObject("a", forKey:"agreedTerm")
            }
            
            alertController.addAction(otherAction)
            alertController.addAction(blockAction)
            
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    private func reload(){
        dispatch_async(dispatch_get_main_queue(), {
            self.collectionView.reloadData()
            self.refreshControl.endRefreshing()
        })
    }
}

