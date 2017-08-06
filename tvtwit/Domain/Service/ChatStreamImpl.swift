//
//  ChatStreamImpl.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/03/06.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

import Foundation
import ReactiveCocoa
import SocketIOClientSwift
import Himotoki
class ChatStreamImpl: ChatStream {
	
	let socket: SocketIOClient;
	init() {
		socket = SocketIOClient(socketURL: NSURL(string: Hubtele.HUBTELE_URL)!) ;
	}
	
	func connect() {
		socket.connect()
	}
	
	func emitInit(programId: String) {
		socket.emit(Hubtele.CHAT.INIT, programId)
	}
	func emitEntry(post: Entry) {
		socket.emit(Hubtele.CHAT.POST_UPPLOAD, ["content": post.content])
	}
    func report(id:String){
        socket.emit("report",id)
    }
	func emitReconnected(programId: String) {
		socket.emit(Hubtele.CHAT.RECONNECTED, programId)
	}
	
	let LISTEN_EVENT = [Hubtele.CHAT.Socket.EVENT_CONNECTED,
		Hubtele.CHAT.Socket.EVENT_DISCONNECT,
		Hubtele.CHAT.Socket.EVENT_RECONNECT_ATTEMPT,
		Hubtele.CHAT.Socket.EVENT_RECONNECTED,
		Hubtele.CHAT.Socket.EVENT_ERROR,
		Hubtele.CHAT.ON_PROGRAM_END,
		Hubtele.CHAT.ON_ENTRY_LOG]
	
	func getEventStream() -> SignalProducer<ChatEvent, NetworkError> {
		return SignalProducer({observer, disposable in
				self.LISTEN_EVENT.forEach {(event: String) -> () in
					self.socket.on(event) {[weak self] data, ack in
						switch event {
						case Hubtele.CHAT.ON_ENTRY_LOG:
							if let logs = (try? decodeArray(data[0])) as [Entry]? {
								observer.sendNext(ChatEvent(eventName: event, data: logs))
								observer.sendCompleted()
							} else {
								print("ChatStreamImpl fail to parse entry log.")
								observer.sendFailed(.IncorrectDataReturned)
							}
						
						default: if (data.count == 0) {
								observer.sendNext(ChatEvent(eventName: event, data: nil))
							} else {
								observer.sendNext(ChatEvent(eventName: event, data: data[0]))
							}
						}
					}
				}
				
			})
	}
	func getEntryStream() -> SignalProducer<Entry, NetworkError> {
		return SignalProducer({observer, disposable in
				self.socket.on(Hubtele.CHAT.ON_ENTRY) {[weak self] data, ack in
					if let entry = (try? decodeValue(data[0])) as Entry? {						observer.sendNext(entry)
					} else {
						observer.sendFailed(.IncorrectDataReturned)
					}
				}
			})
	}
	
	func disconnect() {
		self.socket.disconnect()
		self.socket.close()
		LISTEN_EVENT.forEach {(e) -> () in
			self.socket.off(e)
		}
	}
}