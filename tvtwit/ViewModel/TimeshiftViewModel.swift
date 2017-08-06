 //
//  TimeshiftViewModel.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/05/08.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

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
 class TimeshiftViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private var viewModel: ChatViewModel!
    private var bindingHelper: TableViewBindingHelper!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputField: UITextField!
    @IBAction func submitPressed(sender: AnyObject) {
        if (inputField.text != nil && inputField.text! != "") {
            self.viewModel.emitEntry(Entry(content: inputField.text!))
            inputField.text = ""
        }
    }
    
    init(viewModel: ChatViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "ChatViewController", bundle: nil)
        print("chatViewController init")
        //        RACSignal.createSignal { (subscriber:RACSubscriber!) -> RACDisposable! in
        //            subscriber.sendCompleted()
        //            return nil
        //        }.delay(NSTimeInterval(2.0))
        //        .subscribeCompleted { () -> Void in
        //            print("yea")
        //            self.dismissViewControllerAnimated(true, completion: nil)
        //        }
        self.title = "chatchat"
    }
    //    convenience required init(coder aDecoder: NSCoder)
    //    {
    //        //set some defaults for leftVC, rightVC, and gap
    //        self.init(leftVC, rightVC, gap)
    //    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
        tableView.estimatedRowHeight = 132
        viewModel.getEntryStream().on(
            next: {(entry: Entry) -> () in
                // let isBottom=isbottom?
                print("entry:\(entry.content)")
                self.addReload(entry)
                
            }
            , failed: {(error: NetworkError) -> () in print(error)}
            
            ).start()
        
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
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count: \(viewModel.entries.count)")
        return viewModel.entries.count
    }
    
    func tableView(t: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = t.dequeueReusableCellWithIdentifier("cell") as! EntryTableViewCell
        //		cell.contentView.autoresizingMask = [.FlexibleLeftMargin, .FlexibleWidth, .FlexibleRightMargin, .FlexibleTopMargin, .FlexibleHeight, .FlexibleBottomMargin]
        
        cell.entry = self.viewModel.entries[indexPath.row]
        return cell
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.viewModel.disconnect()
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        print("scrollViewDidEndScrollingAnimation")
    }
    
    private func addReload(entry: Entry) {
        dispatch_async(dispatch_get_main_queue(), {
            print("add")
            print("add bottom:\(self.tableView.indexPathsForVisibleRows?.last?.row) and count is\(self.viewModel.entries.count)")
            
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
    
    private func reload() {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            let count = self.viewModel.entries.count
            print("reload()")
            if (count > 0) {
                self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: self.viewModel.entries.count - 1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
            }
        })
    }
 }