//
//  RankingTableViewCell.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/02/06.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

import UIKit

let RankingCellId = "rankingCellId"


class RankingTableViewCell: UITableViewCell, ReactiveView {
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var rankLabel: UILabel!
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
		let vm = viewModel as! RankingResultsItemViewModel
		self.program = vm.program
		self.rankLabel.text = "\(vm.rank)"
		if (vm.rank <= 3) {
			self.rankLabel.textColor = Objects.PRIMARY_COLOR
        }else{
            self.rankLabel.textColor = UIColor.darkTextColor()
        }
	}
	
}
