//
//  ProgramServiceImpl.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/02/02.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Himotoki
class ProgramServiceImpl: ProgramService {
	private let network: Networking
	init(network: Networking) {
		self.network = network
	}
	init() {
		self.network = NetworkingImpl()
	}
	func getRanking(startIndex: Int, count: Int) -> SignalProducer < [Program], NetworkError > {
		return SignalProducer({observer, disposable in
				self.network.requestJSON(
					Hubtele.API_RANKING,
					parameters: [Hubtele.KEY.START_INDEX: startIndex, Hubtele.KEY.COUNT: count])
					.start({
						(event: Event<AnyObject, NetworkError>) -> () in
						switch event {
						case .Next(let json):
							print("nextnext")
							if let response = (try? decodeArray(json)) as [Program]? {
								observer.sendNext(response)
								print("next\(response.count)")
								observer.sendCompleted()
							} else {
								observer.sendFailed(.IncorrectDataReturned)
							}
						case .Failed(let error):
							observer.sendFailed(error)
						case .Completed:
							break
						case .Interrupted:
							observer.sendInterrupted()
						}
					})
			})
		
		
	}
	
	func getTable() -> SignalProducer < [(String, ProgramInfo)], NetworkError > {
		print("prosei getTable")
		return SignalProducer({observer, disposable in
				self.network.requestJSON(
					Hubtele.API_PROGRAM_TABLE, parameters: nil)
					.start({
						(event: Event<AnyObject, NetworkError>) -> () in
						switch event {
						case .Next(let json):
							if let table = (try? decodeDictionary(json)) as [String: ProgramInfo]? {
                                observer.sendNext(table.sort({(l: (String, ProgramInfo), r: (String, ProgramInfo)) -> Bool in
                                    Int(l.0) < Int(r.0)
                                }))
							} else {
								print("prosei faile:\(json)")
								observer.sendFailed(.IncorrectDataReturned)
							}
						case .Failed(let error):
							print("prosei faile\(error)")
							observer.sendFailed(error)
						case .Completed:
							print("prosei gettable completed)")
							break
						case .Interrupted:
							observer.sendInterrupted()
						}
					})})
	}
}