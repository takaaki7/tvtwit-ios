//
//  File.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/02/06.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate {
	private var viewModel: ChatViewModel!
	private var bindingHelper: TableViewBindingHelper!
	
	@IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var inputLayout: UIView!
    @IBOutlet weak var inputScrollView: UIScrollView!
    @IBOutlet weak var inputField: UITextField!
	@IBAction func submitPressed(sender: AnyObject) {
		if (inputField.text != nil && inputField.text! != "") {
			self.viewModel.emitEntry(Entry(content: inputField.text!))
			inputField.text = ""
            if(inputField.isFirstResponder()){
                inputField.resignFirstResponder()
            }
		}
	}
    private var blockList:[String]!
	init(viewModel: ChatViewModel) {
		self.viewModel = viewModel
        self.blockList=NSUserDefaults.standardUserDefaults().objectForKey("blocklist") as? [String] ?? [String]()
		super.init(nibName: "ChatViewController", bundle: nil)
		self.title = viewModel.program.title
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
		super.init(coder: aDecoder)
	}
    

    override func viewWillAppear(animated:Bool){
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector:#selector(keyboardWillBeShown(_:)),
                                                         name:UIKeyboardWillShowNotification,
                                                         object:nil)
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector:#selector(keyboardWillBeHidden(_:)),
                                                         name:UIKeyboardWillHideNotification,
                                                         object:nil)
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector:#selector(keyboardWillChangeFrame(_:)),
                                                         name:UIKeyboardWillChangeFrameNotification,
                                                         object:nil)
    }
    
    func keyboardWillBeShown(notification:NSNotification){
        if let userInfo = notification.userInfo {
            if let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue, animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue {
                restoreScrollViewSize()
                
                let convertedKeyboardFrame = inputScrollView.convertRect(keyboardFrame, fromView: nil)
                let offsetY: CGFloat = CGRectGetMinY(convertedKeyboardFrame)
//                if offsetY < 0 { return }
                updateScrollViewSize(convertedKeyboardFrame.height, duration: animationDuration)
            }
        }
    }
    
    func keyboardWillChangeFrame(notification:NSNotification){
        if let userInfo = notification.userInfo {
            if let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue, animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue {
                restoreScrollViewSize()
                
                let convertedKeyboardFrame = inputScrollView.convertRect(keyboardFrame, fromView: nil)
                let offsetY: CGFloat = CGRectGetMaxY(inputLayout.frame) - CGRectGetMinY(convertedKeyboardFrame)
                if offsetY < 0 { return }
                updateScrollViewSize(offsetY, duration: animationDuration)
            }
        }
    }
    
    @IBOutlet weak var scrollBottomConstraint: NSLayoutConstraint!
    //http://qiita.com/ysk_1031/items/3adb1c1bf5678e7e6f98
    func keyboardWillBeHidden(notification:NSNotification){
        restoreScrollViewSize()
    }
    func updateScrollViewSize(moveSize: CGFloat, duration: NSTimeInterval) {
//        inputScrollView.translatesAutoresizingMaskIntoConstraints=true
        
        inputScrollView.layer.zPosition=1
        UIView.beginAnimations("ResizeForKeyboard", context: nil)
        UIView.setAnimationDuration(duration)
        
        let contentInsets = UIEdgeInsetsMake(0, 0, moveSize, 0)
        UIView.commitAnimations()
    }
    
    func restoreScrollViewSize() {
        scrollBottomConstraint.constant=0
    }
    
    override func viewDidLayoutSubviews() {
        self.navigationController?.navigationBar.translucent = false
        super.viewDidLayoutSubviews()
    }
	override func viewDidLoad() {
		// titleLabel.text = self.viewModel?.program.title
		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.viewModel.viewDidLoad()
		let nib = UINib(nibName: "EntryTableViewCell", bundle: nil)
		tableView.registerNib(nib, forCellReuseIdentifier: "cell")
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 66
		viewModel.getEntryStream().on(
			next: {(entry: Entry) -> () in
				// let isBottom=isbottom?
				self.addReload(entry)
				
			}
			, failed: {(error: NetworkError) -> () in print(error)}
			
		).start()
		self.edgesForExtendedLayout=UIRectEdge.None
		viewModel.getEventStream().on(
			next: {(event: ChatEvent) -> () in
				switch (event.eventName) {
				case Hubtele.CHAT.ON_ENTRY_LOG:
					self.viewModel.addAll(event.data as! [Entry])
					self.reload()
				case Hubtele.CHAT.ON_PROGRAM_END:
					// ended
					print("end")
				default:
					print("what is this\(event)")
				}
			},
			failed: {(error: NetworkError) -> () in print(error)}).start()
        
        
        let touch = UIPanGestureRecognizer(target:self, action:#selector(scrollTouch(_:)))
        touch.delegate=self
        self.tableView.addGestureRecognizer(touch)
	}
    
    func scrollTouch(recognizer:UIPanGestureRecognizer) {
        //empty
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let entry=self.viewModel.getEntry(indexPath.row)
        let alertController = UIAlertController(title: entry.userName! as String ,message:entry.content as String, preferredStyle: UIAlertControllerStyle.ActionSheet)
        alertController.popoverPresentationController?.sourceView = tableView.cellForRowAtIndexPath(indexPath)
        alertController.popoverPresentationController?.sourceRect = CGRectMake(100.0, 30.0, 20.0, 20.0)
        // this is the center of the screen currently but it can be any point in the view
        
        let otherAction = UIAlertAction(title: "スパム報告", style: .Default) {
            action in
            self.addBlockList(entry.userName!)
            self.viewModel.reportEntry(entry)
        }
        
        let blockAction = UIAlertAction(title: "このユーザをブロック", style: .Default) {
            action in self.addBlockList(entry.userName!)
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .Cancel) {
            action in print("cancel", terminator: "")
        }
        
        // addActionした順に左から右にボタンが配置されます
        alertController.addAction(otherAction)
        alertController.addAction(blockAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func addBlockList(userName:String){
        if(!self.blockList.contains(userName)){
            self.blockList.append(userName)
                let count=self.viewModel.entries.count
            for (var i=count-1;i>=0;i--){
                if(userName == self.viewModel.entries[i].userName){
                    self.viewModel.entries.removeAtIndex(i)
                }
            }
            self.tableView.reloadData()
        }
    }
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if(inputField.isFirstResponder()){
            inputField.resignFirstResponder()
        }
        
        return false
    }
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.entries.count
	}
	
	func tableView(t: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = t.dequeueReusableCellWithIdentifier("cell") as! EntryTableViewCell
//		cell.contentView.autoresizingMask = [.FlexibleLeftMargin, .FlexibleWidth, .FlexibleRightMargin, .FlexibleTopMargin, .FlexibleHeight, .FlexibleBottomMargin]
		
		cell.entry = self.viewModel.entries[indexPath.row]
		return cell
	}
	
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSUserDefaults.standardUserDefaults().setObject(self.blockList, forKey: "blocklist")
        NSNotificationCenter.defaultCenter().removeObserver(self,name:UIKeyboardWillShowNotification,object:nil)
        NSNotificationCenter.defaultCenter().removeObserver(self,name:UIKeyboardWillHideNotification,object: nil)
    }
    
	override func viewDidDisappear(animated: Bool) {
		self.viewModel.disconnect()
	}
	
	func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
	}
	
	private func addReload(entry: Entry) {
        for i in 0 ..< blockList.count {
            if(blockList[i] == entry.userName){
                return
            }
        }
        
		dispatch_async(dispatch_get_main_queue(), {
				
				let count: NSInteger = self.viewModel.entries.count
				
				let removedOverMax=self.viewModel.addEntryTop(entry)
				if (count == 0||removedOverMax) {
					self.tableView.reloadData()
					return
				}
				let indexPath = [NSIndexPath(forRow: 0, inSection: 0)]
				self.tableView.insertRowsAtIndexPaths(indexPath, withRowAnimation: UITableViewRowAnimation.Top)

			})
	}
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    
	private func reload() {
		dispatch_async(dispatch_get_main_queue(), {
				self.tableView.reloadData()
				let count = self.viewModel.entries.count
				if (count > 0) {
					self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
				}
			})
	}
}
