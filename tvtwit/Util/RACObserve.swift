//
//  RACObserve.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/01/14.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

import Foundation
import ReactiveCocoa

func RACObserve(target: NSObject!, keyPath: String) -> RACSignal {
	return target.rac_valuesForKeyPath(keyPath, observer: target)
}