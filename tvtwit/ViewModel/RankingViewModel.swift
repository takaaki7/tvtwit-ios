//
//  RankingViewModel.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/02/06.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

import Foundation
import ReactiveCocoa
class RankingViewModel: NSObject {
	dynamic var ranking: [RankingResultsItemViewModel]
	var errorMessage: AnyProperty<String?> {return AnyProperty(_errorMessage)}
	private let _errorMessage = MutableProperty<String?>(nil)
	let title = "ランキング"
	private let COUNT_PER_PAGE = 20
	private let service: ProgramService
	var loadMore: RACCommand?
	init(service: ProgramService) {
		self.service = service
		self.ranking = []
		super.init()
		
        loadMore = RACCommand(){
			(any: AnyObject!) -> RACSignal in
            print("loadMore")
			return RACSignal.createSignal({(subscriber) -> RACDisposable! in
					service.getRanking(any as! NSInteger, count: self.COUNT_PER_PAGE)
						.on(next: {
							(results: [Program]) -> () in
                            let count=self.ranking.count
							self.ranking.appendContentsOf(results.enumerate().map {RankingResultsItemViewModel(program: $0.1, rank: $0.0+count+1)})
                            subscriber.sendCompleted()
                        })
                        .on(failed: {error-> ()in
							self._errorMessage.value = error.description
						})
						.start()
					return nil
				})
		}
	}
}
