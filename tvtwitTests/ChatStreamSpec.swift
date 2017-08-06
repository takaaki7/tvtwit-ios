//
//  ChatStreamTest.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/03/13.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

import Foundation
import Quick
import Nimble
import ReactiveCocoa
import Himotoki
@testable import tvtwit

class ChatStreamSpec: QuickSpec {
	override func spec() {
		describe("entry_log") {
			it("receive entry_log after init") {
				var logs: [Entry]? = nil
				var info: ProgramInfo? = nil
				self.getEncouragedProgram().toRACSignal().doNextAs {(i: ProgramInfo) -> () in
					info = i
					print("info:\(info!.program.title)")
				}.subscribeNextAs {(i: ProgramInfo) -> () in
                    
                    let stream = ChatStreamImpl()
					stream.getEventStream().toRACSignal().doError({ (error) -> Void in
                        print("error \(error)")
                    }).subscribeNextAs {(event: ChatEvent) -> () in
						print("event \(event.eventName)")
						if (event.eventName == Hubtele.CHAT.Socket.EVENT_CONNECTED) {
							stream.emitInit(info!.program.id)
						}
						if (event.eventName == Hubtele.CHAT.ON_ENTRY_LOG) {
							logs = event.data as! [Entry]
							print("logs: \(logs![0].content)")
						}
					}
                }
				expect(info?.name).toEventuallyNot(beNil(), timeout: 5)
				expect(logs?.count).toEventually(beGreaterThan(3), timeout: 5)
				expect(logs?[1].content).toEventuallyNot(beNil(), timeout: 5)
			}
		}
		
	}
    
	private func getEncouragedProgram() -> SignalProducer<ProgramInfo, NetworkError> {
		return ProgramServiceImpl().getTable().map {(table) -> ProgramInfo in
			return table.map({$0.1}).maxElement {(lhs, rhs) -> Bool in
				return lhs.program.entryCount < rhs.program.entryCount
			}!
		}
	}
}