//
//  SearchResultItemView.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/01/15.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

import Foundation

import ReactiveCocoa

class SearchResultTableViewCell: UITableViewCell, ReactiveView {
	
	@IBOutlet weak var titleLabel: UILabel!
	func bindViewModel(viewModel: AnyObject) {
		let result = viewModel as! SearchResultsItemViewModel
		titleLabel.text = result.program.title
		self.clipsToBounds = true
		
	}
}