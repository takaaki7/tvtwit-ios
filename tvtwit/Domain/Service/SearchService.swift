//
//  SearchService.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/01/15.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

import Foundation
import ReactiveCocoa
protocol SearchService {
	func searchSignal(searchText: String) -> SignalProducer < [Program], NetworkError >
}