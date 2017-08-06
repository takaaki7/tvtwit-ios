//
//  TableViewBindingHelper.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/01/15.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

import Foundation

import ReactiveCocoa
import UIKit

@objc protocol ReactiveView {
	func bindViewModel(viewModel: AnyObject)
}

class TableViewBindingHelper: NSObject, UITableViewDataSource, UITableViewDelegate {
	var delegate: UITableViewDelegate?
	
	private let tableView: UITableView
	private let templateCell: UITableViewCell
	private let selectionCommand: RACCommand?
	private let loadMoreCommand: RACCommand?
	private var data: [AnyObject]
	private var lastLoadMoreCount = 0
	init(tableView: UITableView, sourceSignal: RACSignal, nibName: String, selectionCommand: RACCommand? = nil, loadMoreCommand: RACCommand? = nil) {
		self.tableView = tableView
		self.data = []
		self.selectionCommand = selectionCommand
		self.loadMoreCommand = loadMoreCommand
		let nib = UINib(nibName: nibName, bundle: nil)
		
		templateCell = nib.instantiateWithOwner(nil, options: nil) [0] as! UITableViewCell
		tableView.registerNib(nib, forCellReuseIdentifier: templateCell.reuseIdentifier!)
		
		super.init()
		
		sourceSignal.subscribeNext {
			(d: AnyObject!) -> () in
			self.data = d as! [AnyObject]
			dispatch_async(dispatch_get_main_queue(), {
					
					self.tableView.reloadData()
				}) 
		}
		
		tableView.dataSource = self
		tableView.delegate = self
		self.loadMoreCommand?.execute(0)
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return data.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let item: AnyObject = data[indexPath.row]
		let cell = tableView.dequeueReusableCellWithIdentifier(templateCell.reuseIdentifier!)
		if let reactiveView = cell as? ReactiveView {
			reactiveView.bindViewModel(item)
		}
		return cell!
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return templateCell.frame.size.height
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		selectionCommand?.execute(data[indexPath.row])
	}
	
	func scrollViewDidScroll(scrollView: UIScrollView) {
		if (self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.bounds.size.height) &&
			data.count > lastLoadMoreCount) {
			
			loadMoreCommand?.execute(data.count)
			lastLoadMoreCount = data.count
		}
		if self.delegate?.respondsToSelector(Selector("scrollViewDidScroll:")) == true {
			self.delegate?.scrollViewDidScroll?(scrollView) ;
		}
	}
}