//
//  SearchResult.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/01/15.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

import Foundation
class SearchResults :NSObject{
	let programs: [Program]
	let searchString: String
	init(searchString: String, programs: [Program]) {
		self.searchString = searchString
		self.programs = programs
	}
}