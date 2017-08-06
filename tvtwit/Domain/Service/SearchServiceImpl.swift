//
//  SearchServiceImpl.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/01/15.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Himotoki
class SearchServiceImpl: SearchService {
    private let network: Networking
    init(network: Networking) {
        self.network = network
    }
    init() {
        self.network = NetworkingImpl()
    }
    func searchSignal(searchText: String) -> SignalProducer < [Program], NetworkError > {
        return SignalProducer({observer, disposable in
            self.network.requestJSON(
                Hubtele.API_SEARCH, parameters: [Hubtele.KEY.TITLE:searchText])
                .start({
                    (event: Event<AnyObject, NetworkError>) -> () in
                    switch event {
                    case .Next(let json):
                        if let table = (try? decodeArray(json)) as [Program]? {
                            observer.sendNext(table)
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