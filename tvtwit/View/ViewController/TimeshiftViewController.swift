//
//  TimeshiftViewController.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/05/08.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//


import Foundation
import UIKit
import ReactiveCocoa
class TimeshiftViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	let ENTRY_NUM_PER_PAGE = 65
	let MAX_COUNT = 300
	private var service: TimeshiftService!
	private var bindingHelper: TableViewBindingHelper!
	private var program: Program!
	private var loading: Bool = false
	private var currentPage = 0
	private var currentTime = 0
	private var entries = [Entry?]()
	var userScrolling = false
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var currentTimeLabel: UILabel!
    
    var padHeight:CGFloat!
    var blockList:[String]!
	@IBOutlet weak var totalTimeLabel: UILabel!
	init(timeshiftService: TimeshiftService, program: Program) {
		self.service = timeshiftService
		self.program = program
        userNameLabelHeight = NSString(string: "あ").boundingRectWithSize(CGSize(width:30,height:30),options:options ,attributes:optionDict2,context:nil).height
        padHeight = labelY+userNameLabelHeight+12//yobunn ni toru
        self.blockList = NSUserDefaults.standardUserDefaults().objectForKey("blocklist") as? [String] ?? [String]()
		super.init(nibName: "TimeshiftViewController", bundle: nil)
		
		dateFormatter.timeZone = NSTimeZone(name: "GMT")
		dateFormatter.dateFormat = "HH:mm:ss"
		self.title = program.title
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
		super.init(coder: aDecoder)
	}
	
	override func viewDidLayoutSubviews() {
		self.navigationController?.navigationBar.translucent = false
		super.viewDidLayoutSubviews()
	}
	
	var timer: RACDisposable?
	
    override func shouldAutorotate() -> Bool {
        return false
    }
    var userNameLabelHeight:CGFloat!
	override func viewDidLoad() {
		// titleLabel.text = self.viewModel?.program.title
		self.tableView.delegate = self
		self.tableView.dataSource = self
		
		let formatter = NSDateFormatter()
		formatter.timeZone = NSTimeZone(name: "GMT")
		formatter.dateFormat = "HH:mm:ss"
		let duration = formatter.stringFromDate(NSDate(timeIntervalSinceReferenceDate: program.endAt.timeIntervalSinceDate(program.startAt)))
		self.totalTimeLabel.text = duration
      	tableView.transform = CGAffineTransformMakeRotation(-CGFloat(M_PI)) ;
		let nib = UINib(nibName: "EntryTableViewCell", bundle: nil)
		tableView.registerNib(nib, forCellReuseIdentifier: "cell")
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 66
		timer = RACSignal.interval(1.0, onScheduler: RACScheduler.mainThreadScheduler()).subscribeNext {(obj) -> Void in
           if (!self.userScrolling && !self.loading) {
				self.setCurrentTime(self.currentTime + 1)
				
				let visibles = self.tableView.indexPathsForVisibleRows
				if (visibles?.last?.row != nil) {
					let start = (visibles?.last?.row)! + 1
                    let startOffsetDate=self.program.startAt.dateByAddingTimeInterval(NSTimeInterval(self.currentTime))
					for i in start..<self.entries.count {
                        if(i>start+10){
                                self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow:i,inSection:0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
                            
                                    return
                        }
						if (startOffsetDate.isLessThanDate(self.entries[i]?.date ?? self.program.endAt)) {
							if (i - 1 > start) {
                                print("goscroll")
                                
								self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
                                
							}
                            break
						}
					}
				}
			}
		}
		loadMore()
	}
	
	
	override func viewDidDisappear(animated: Bool) {
        NSUserDefaults.standardUserDefaults().setObject(self.blockList, forKey: "blocklist")
		timer?.dispose()
	}
	
    let labelY:CGFloat=6+2
    let padWidth:CGFloat=8+48+8+14
    
    let minHeight:CGFloat=8+48+8
    let options: NSStringDrawingOptions =  [.UsesLineFragmentOrigin , .UsesFontLeading]
    let optionDict=[NSFontAttributeName: UIFont.systemFontOfSize(15.0)]
    let optionDict2=[NSFontAttributeName: UIFont.systemFontOfSize(13.0)]
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        let entry=entries[indexPath.row]
        if(entry != nil){
        let a=(entry!.content.boundingRectWithSize(CGSize(width: tableView.frame.width - padWidth,height: 150), options: options, attributes: optionDict, context: nil).height)+padHeight
        return max(a,minHeight)
        }
        return minHeight
    }
	
	
	func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return minHeight
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return entries.count
	}
	
	
	func tableView(t: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = t.dequeueReusableCellWithIdentifier("cell") as! EntryTableViewCell
		// cell.contentView.autoresizingMask = [.FlexibleLeftMargin, .FlexibleWidth, .FlexibleRightMargin, .FlexibleTopMargin, .FlexibleHeight, .FlexibleBottomMargin]
		if (!loading && indexPath.row > self.entries.count - 20 ) {
			loadMore()
		}
		cell.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
		
		cell.entry = entries[indexPath.row]
		
		return cell
	}
	
	func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {

		let lastValid = self.entries.count - MAX_COUNT
		if (indexPath.row < lastValid) {
//            cell.frame.size.height=0
			tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: lastValid + 1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
		}
	}
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let entry=self.entries[indexPath.row]!
        var alertController = UIAlertController(title: entry.content as String ,message:"この投稿をスパム報告する" , preferredStyle: UIAlertControllerStyle.ActionSheet)
        alertController.popoverPresentationController?.sourceView = tableView.cellForRowAtIndexPath(indexPath)
        alertController.popoverPresentationController?.sourceRect = CGRectMake(100.0, 30.0, 20.0, 20.0)
        // this is the center of the screen currently but it can be any point in the view
        
        let otherAction = UIAlertAction(title: "報告", style: .Default) {
            action in
            self.addBlockList(entry.userName!)
            self.service.report(entry.id!)
        }
        
        let blockAction = UIAlertAction(title: "このユーザをブロック", style: .Default) {
            action in self.addBlockList(entry.userName!)
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .Cancel) {
            action in print("cancel", terminator: "")
        }
        
        alertController.addAction(otherAction)
        alertController.addAction(blockAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
	
	func loadMore() {
		let firstLoad = (currentPage == 0)
		loading = true
		if (firstLoad) {
			service.timeshift(program.id, startIndex: calculateStartIndex(), count: ENTRY_NUM_PER_PAGE)
				.startWithNext {(data) -> () in
                    
                    var paths = [NSIndexPath]()
                    for i in 0..<data.count {
                        var blocked=false
                        for j in 0..<self.blockList.count {
                            if(self.blockList[j] == data[i]?.userName){
                                blocked=true
                            }
                        }
                        if !blocked {
                            self.entries.append(data[i])
                            paths.append(NSIndexPath(forRow: self.entries.count-1, inSection: 0))
                        }
                    }
				let offsetFromBottom = self.tableView.contentSize.height - self.tableView.contentOffset.y
				dispatch_async(dispatch_get_main_queue(), {
						self.tableView.insertRowsAtIndexPaths(paths, withRowAnimation: UITableViewRowAnimation.None)
						if (firstLoad) {
							if (data.count > 0) {
								self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: (0), inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
							}
						} else {
							self.tableView.layoutIfNeeded()
							dispatch_async(dispatch_get_main_queue(), {
									self.tableView.setContentOffset(CGPoint(x: 0, y: self.tableView.contentSize.height - offsetFromBottom), animated: false)
								})
						}
						
						self.loading = false
					})
			}
		} else {
			service.timeshift(program.id, startIndex: calculateStartIndex(), count: ENTRY_NUM_PER_PAGE)
				.startWithNext {(data) -> () in

                let currentLast=self.tableView.indexPathsForVisibleRows!.last!.row
                    var paths = [NSIndexPath]()
                    for i in 0..<data.count {
                        var blocked=false
                        for j in 0..<self.blockList.count {
                            if(self.blockList[j] == data[i]?.userName){
                                blocked=true
                            }
                        }
                        if !blocked {
                            self.entries.append(data[i])
                            paths.append(NSIndexPath(forRow: self.entries.count-1, inSection: 0))
                        }
                    }
				let lastValid = self.entries.count - self.MAX_COUNT
				if (lastValid > 0) {
					print("remove olds")
					self.entries.replaceRange(0..<lastValid, with: (0..<lastValid).map {_ in nil})
//						self.entries[i]=Entry(content: "")
				}
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.updateCurrentTime()
                        self.tableView.insertRowsAtIndexPaths(paths, withRowAnimation: UITableViewRowAnimation.None)
                        
					 self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow:currentLast,inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
                        if(data.count>0){
                        self.loading = false
                        }
					})
			}
		}
	}
	
    
    func addBlockList(userName:String){
        if(!self.blockList.contains(userName)){
            self.blockList.append(userName)
            let count=self.entries.count
            for (var i=count-1;i>=0;i--){
                if(userName == self.entries[i]!.userName!){
                    self.entries.removeAtIndex(i)
                }
            }
            self.tableView.reloadData()
        }
    }
    
	private func calculateStartIndex() -> Int {
		let ret = currentPage * ENTRY_NUM_PER_PAGE
		currentPage++
		return ret
	}
	
	let dateFormatter = NSDateFormatter()
	private func setCurrentTime(currentTime: Int) {
		self.currentTime = currentTime
		
		self.currentTimeLabel.text = dateFormatter.stringFromDate(NSDate(timeIntervalSince1970: NSTimeInterval(currentTime)))
	}
	
	func scrollViewWillBeginDragging(scrollView: UIScrollView) {
		userScrolling = true
	}
	func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		if (!decelerate) {
			userScrolling = false
			updateCurrentTime()
		}
	}
	
	func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
		userScrolling = false
		updateCurrentTime()
	}
	
	private func updateCurrentTime() {
		let visibles = self.tableView.indexPathsForVisibleRows
        if(visibles != nil && visibles?.last != nil){
		let bottom = self.entries[(visibles?.last?.row)!]
		if (bottom != nil) {
			setCurrentTime(Int((bottom!.date?.timeIntervalSinceDate(self.program.startAt))!))
		}
        }
	}
	
	func scrollViewDidScroll(scrollView: UIScrollView) {
	}
	func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {}
	
}
