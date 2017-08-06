//
//  ProgramService.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/02/01.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

import Foundation
import ReactiveCocoa
protocol ProgramService {
	func getRanking(startIndex: Int, count: Int) -> SignalProducer<[Program],NetworkError> 
	func getTable() -> SignalProducer<[(String, ProgramInfo)],NetworkError>
}