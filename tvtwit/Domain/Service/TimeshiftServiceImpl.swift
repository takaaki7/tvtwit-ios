//
//  ChatServiceImpl.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/05/06.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Himotoki
class TimeshiftServiceImpl: TimeshiftService {
	private let network: Networking
	init(network: Networking) {
		self.network = network
	}
	
	init() {
		self.network = NetworkingImpl()
	}
	
	func timeshift(programId: String, startIndex: Int, count: Int) -> SignalProducer < [Entry?], NetworkError > {
		return SignalProducer({observer, disposable in
				self.network.requestJSON(Hubtele.API_TIMESHIFT, parameters: [Hubtele.KEY.PROGRAM: programId, Hubtele.KEY.START_INDEX: startIndex, Hubtele.KEY.COUNT: count])
					.start({
						(event: Event<AnyObject, NetworkError>) -> () in
						switch event {
						case .Next(let json):
							if let response = (try? decodeArray(json)) as[Entry]? {
								observer.sendNext(response.flatMap({$0}))
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
						}})
			})
	}
    
    func report(entryId:String)->SignalProducer<String,NetworkError>{
        return SignalProducer({observer,disposable in
            self.network.requestPost(Hubtele.API_REPORT,parameters:["entryId":entryId])
                .start({
                    (event:Event<AnyObject,NetworkError>)-> () in
                    switch event{
                        case .Next(let json):
                            observer.sendNext(json as! String)
                        observer.sendCompleted()
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
}