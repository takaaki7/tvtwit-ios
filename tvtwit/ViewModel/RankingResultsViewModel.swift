//
//  RankingResultsViewModel.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/02/06.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

import Foundation

class RankingResultsItemViewModel: NSObject {
	let program: Program
	let rank: NSInteger
	
	init(program: Program, rank: NSInteger) {
		self.program = program
		self.rank = rank
		super.init()
	}
}