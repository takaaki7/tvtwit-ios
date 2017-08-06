//
//  RankingTableView.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/01/01.
//  Copyright (c) 2016年 NakamaTakaaki. All rights reserved.
//

import UIKit
import ReactiveCocoa
class RankingTableViewController: UITableViewController {
	private var viewModel: RankingViewModel!
	private var bindingHelper: TableViewBindingHelper!
	@IBOutlet var rankingTable: UITableView!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        self.viewModel = RankingViewModel(service: ProgramServiceImpl())
		bindingHelper = TableViewBindingHelper(tableView: rankingTable, sourceSignal: RACObserve(viewModel, keyPath: "ranking"), nibName: "RankingTableViewCell",
			selectionCommand: RACCommand() {
				(any: AnyObject!) -> RACSignal! in
				let vm = any as! RankingResultsItemViewModel
				self.goChatScene(vm.program)
				return RACSignal.empty()
			},
			loadMoreCommand: self.viewModel.loadMore
		)
		viewModel.errorMessage.producer.on(next: {errorMessage in
				if let errorMessage = errorMessage {
					self.displayErrorMessage(errorMessage)
				}
			}).start()
		title = self.viewModel.title
	}
    
    
    override func viewDidAppear(animated: Bool) {
        self.tabBarItem.title="ランキング"
        self.tabBarController?.navigationItem.title="先週の人気ランキング"
    }
	
	private func displayErrorMessage(errorMessage: String) {
		let alert = UIAlertController(title: "error", message: errorMessage, preferredStyle: .Alert)
		alert.addAction(UIAlertAction(title: "確認", style: .Default) {_ in
				alert.dismissViewControllerAnimated(true, completion: nil)
			})
		self.presentViewController(alert, animated: true, completion: nil)
    }
		override func didReceiveMemoryWarning() {
			super.didReceiveMemoryWarning()
			// Dispose of any resources that can be recreated.
		}
		
	}