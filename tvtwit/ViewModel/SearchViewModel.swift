//
//  RankingViewModel.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/01/14.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

import Foundation
import ReactiveCocoa

class SearchViewModel: NSObject {
	
	dynamic var searchText = ""
	// searchResults
	dynamic var searchResults : [SearchResultsItemViewModel]
	var executeSearch: RACCommand?
	var connectionErrors: RACSignal!
	
	let title = "検索"
	
	private let service: SearchService
	
	init(service: SearchService) {
		self.service = service
		self.searchResults = []
		super.init()
		let validSearchSignal = RACObserve(self, keyPath: "searchText").mapAs {
			(text: NSString) -> AnyObject in
			return text.length > 0
		}.distinctUntilChanged()
		
		executeSearch = RACCommand(enabled: validSearchSignal) {
			(any: AnyObject!) -> RACSignal in
			return self.executeSearchSignal()
		}
		connectionErrors = executeSearch!.errors
		
	}
	
	func executeSearchSignal() -> RACSignal {
		return RACSignal.createSignal {(subscriber) -> RACDisposable! in
			self.service.searchSignal(self.searchText).startWithNext({(results: [Program]) -> () in
					self.searchResults = results.map {SearchResultsItemViewModel(program: $0)}
					subscriber.sendCompleted()
				})
			return RACDisposable()
		}
	}
}
