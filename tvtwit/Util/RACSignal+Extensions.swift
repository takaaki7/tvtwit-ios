//
//  RACSignal+Extensions.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/01/15.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

import Foundation
import ReactiveCocoa
extension RACSignal {
	func subscribeNextAs<T>(nextClosure: (T) -> ()) -> () {
		self.subscribeNext {
			(next: AnyObject!) -> () in
			let nextAsT = next! as! T
			nextClosure(nextAsT)
			
		}
	}
	
	func mapAs<T: Any, U: AnyObject>(mapClosure: (T) -> U) -> RACSignal {
		return self.map {
			(next: AnyObject!) -> AnyObject! in
			let nextAsT = next as! T
			return mapClosure(nextAsT)
		}
	}
	
	func filterAs<T: AnyObject>(filterClosure: (T) -> Bool) -> RACSignal {
		return self.filter {
			(next: AnyObject!) -> Bool in
			let nextAsT = next as! T
			return filterClosure(nextAsT)
		}
	}
	
	func doNextAs<T: Any>(nextClosure: (T) -> ()) -> RACSignal {
		return self.doNext {
			(next: AnyObject!) -> () in
			let nextAsT = next as! T
			nextClosure(nextAsT)
		}
	}
}

class RACSignalEx {
	class func combineLatestAs<T, U, R: AnyObject>(signals: [RACSignal], reduce: (T, U) -> R) -> RACSignal {
		return RACSignal.combineLatest(signals).mapAs {
			(tuple: RACTuple) -> R in
			return reduce(tuple.first as! T, tuple.second as! U)
		}
	}
}