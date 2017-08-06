//
//  RAC.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/01/14.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

import Foundation
import ReactiveCocoa

struct RAC {
	var target : NSObject!
	var keyPath : String!
	var nilValue : AnyObject!
	
	init(_ target: NSObject!, _ keyPath: String, nilValue: AnyObject? = nil) {
		self.target = target
		self.keyPath = keyPath
		self.nilValue = nilValue
	}
	
	func assignSignal(signal : RACSignal) {
		signal.setKeyPath(self.keyPath, onObject: self.target, nilValue: self.nilValue)
	}
}

infix operator ~> {}
func ~> (signal: RACSignal, rac: RAC) {
	rac.assignSignal(signal)
}