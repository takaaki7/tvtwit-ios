//
//  NetworkingImpl.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/02/01.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

import Foundation
import Alamofire
import ReactiveCocoa

public final class NetworkingImpl: Networking {
	private let queue = dispatch_queue_create("Hubtele.Network.Queue", DISPATCH_QUEUE_SERIAL)
	
	public init() {}
	
	public func requestJSON(url: String, parameters: [String: AnyObject]?) -> SignalProducer<AnyObject, NetworkError> {
		print("requestJSON paramcount:\(parameters?.count) \(url)")

        return SignalProducer {observer, disposable in
			let serializer = Alamofire.Request.JSONResponseSerializer()
			Alamofire.request(.GET, url, parameters: parameters)
				.response(queue: self.queue, responseSerializer: serializer) {
				response in
				switch response.result {
				case .Success(let value):
                    print("requestJSON success")
					observer.sendNext(value)
					observer.sendCompleted()
				case .Failure(let error):
                    print("requestJSON filure\(error)")
					observer.sendFailed(NetworkError(error: error))
				}
			}
		}
	}
    
    public func requestPost(url: String,parameters:[String:AnyObject]?) -> SignalProducer<AnyObject,NetworkError>{
        return SignalProducer{observer, disposable in
            let serializer = Alamofire.Request.JSONResponseSerializer()
            Alamofire.request(.POST, url, parameters: parameters)
                .response(queue: self.queue, responseSerializer: serializer) {
                    response in
                    switch response.result {
                    case .Success(let value):
                        print("requestJSON success")
                        observer.sendNext(value)
                        observer.sendCompleted()
                    case .Failure(let error):
                        print("requestJSON filure\(error)")
                        observer.sendFailed(NetworkError(error: error))
                    }
            }
        }
    }
}