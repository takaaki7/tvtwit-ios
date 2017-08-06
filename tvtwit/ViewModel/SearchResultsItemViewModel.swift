//
//  SearchResultsItemViewModel.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/01/15.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

import Foundation

class SearchResultsItemViewModel: NSObject {
	let program: Program
	
	init(program: Program) {
		self.program = program
		super.init()
	}
}