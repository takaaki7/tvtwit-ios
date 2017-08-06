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
class ProgramServiceStub: ProgramService {
    private let network: Networking
    init(network: Networking) {
        self.network = network
    }
    init(){
        self.network=NetworkingImpl()
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
        
        
        //		return RACSignal.createSignal({
        //				(subscriber: RACSubscriber!) -> RACDisposable! in
        //
        //				subscriber.sendNext([
        //						Program(id: "010101", station: "01", title: "testbangumi", startAt: NSDate(), endAt: NSDate(), entryCount: 50),
        //						Program(id: "010102", station: "01", title: "testbangumi2", startAt: NSDate(), endAt: NSDate(), entryCount: 50),
        //						Program(id: "010103", station: "01", title: "testbangumi3", startAt: NSDate(), endAt: NSDate(), entryCount: 50),
        //
        //					])
        //				subscriber.sendCompleted()
        //				return nil
        //			})
        
    }
    
    func getTable() -> SignalProducer<[(String, ProgramInfo)],NetworkError> {
        print("prosei getTable")
        return SignalProducer.empty
//        return RACSignal.createSignal({
//            (subscriber: RACSubscriber!) -> RACDisposable! in
//            print("proserviceIMpl getTable")
//            subscriber.sendNext([
//                ProgramInfo(name: "NHK", program: Program(id: "010101", station: "01", title: "testbangumi", startAt: NSDate(), endAt: NSDate(), entryCount: 50)),
//                ProgramInfo(name: "NHKETV", program: Program(id: "020101", station: "02", title: "testbangumi2", startAt: NSDate(), endAt: NSDate(), entryCount: 50)),
//                ProgramInfo(name: "NTV", program: Program(id: "040101", station: "04", title: "testbangumi3", startAt: NSDate(), endAt: NSDate(), entryCount: 50)),
//                ProgramInfo(name: "TV朝日", program: Program(id: "050101", station: "05", title: "testbangumi4あsdフィアsdフォイウイウイウイウイウイウイウイウイウイウイ雨", startAt: NSDate(), endAt: NSDate(), entryCount: 50)),
//                ProgramInfo(name: "TBS", program: Program(id: "060101", station: "06", title: "testbangumi5", startAt: NSDate(), endAt: NSDate(), entryCount: 50)),
//                ProgramInfo(name: "テレビ東京", program: Program(id: "070101", station: "07", title: "testbangumi6", startAt: NSDate(), endAt: NSDate(), entryCount: 50)),
//                ProgramInfo(name: "フジテレビ", program: Program(id: "080101", station: "08", title: "testbangumi67", startAt: NSDate(), endAt: NSDate(), entryCount: 50)),
//                ProgramInfo(name: "TOKYO MX1", program: Program(id: "090101", station: "09", title: "testbangumi7", startAt: NSDate(), endAt: NSDate(), entryCount: 50)),
//                
//                ])
//            subscriber.sendCompleted()
//            return nil
//        })
    }
}