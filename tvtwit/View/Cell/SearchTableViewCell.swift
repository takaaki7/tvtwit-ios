//
//  SearchTableViewCell.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/02/01.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

import Foundation
import UIKit

let SearchCellId = "searchCellId"
let SearchCellHeight: CGFloat = 110.0

class SearchTableViewCell: UITableViewCell, ReactiveView {
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var entryCountLabel: UILabel!
	
	var program: Program! {
		didSet {
			self.titleLabel.text = self.program.title
			self.timeLabel.text = self.program.startAndEndFormat()
			self.entryCountLabel.text = "\(self.program.entryCount)"
		}
	}
	
	func bindViewModel(viewModel: AnyObject) {
		let vm = viewModel as! SearchResultsItemViewModel
		self.program = vm.program
	}
}