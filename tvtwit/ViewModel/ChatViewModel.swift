//
//  ChatViewModel.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/02/06.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

import Foundation
import ReactiveCocoa

class ChatViewModel: NSObject {
	let MAX = 600
	let MAX_THINOUT = 100
	let program: Program!
	var chatStream: ChatStream!
	var connecting: Bool = false
	var connectedOnce: Bool = false
	var buffer: [Entry] = []
	var programIsEnd: Bool = false
	var entries: [Entry] = []
	init(program: Program) {
		self.program = program
	}
    
    func getEntry(position:NSInteger) -> Entry{
        return entries[position]
    }
	
    func reportEntry(entry:Entry){
        self.chatStream.report(entry.id!)
    }
	func addEntry(entry: Entry) {
		entries.append(entry)
	}
	
	func addEntryTop(entry: Entry) -> Bool {
		if (entries.count > MAX) {
			entries.removeRange((MAX - MAX_THINOUT)...MAX)
			return true
		}
		entries.insert(entry, atIndex: 0)
		return false
	}
	func addAll(e: [Entry]) {
		entries.appendContentsOf(e.reverse())
	}
	
	func viewDidLoad() {
		self.chatStream = ChatStreamImpl()
		self.chatStream.connect()
	}
	
	func getEntryStream() -> SignalProducer<Entry, NetworkError> {
		return self.chatStream.getEntryStream()
	}
	
	func getEventStream() -> SignalProducer<ChatEvent, NetworkError> {
		return self.chatStream.getEventStream().on(
			next: {
				(event: ChatEvent) -> () in
				switch event.eventName {
				case Hubtele.CHAT.Socket.EVENT_CONNECTED:
					self.connecting = true
					if (!self.connectedOnce) {
						self.connectedOnce = true
						self.chatStream.emitInit(self.program.id)
					} else {
						self.chatStream.emitReconnected(self.program.id)
					}
					self.buffer.forEach({(entry) -> () in
							self.chatStream.emitEntry(entry)
						})
					self.buffer.removeAll()
				case Hubtele.CHAT.Socket.EVENT_DISCONNECT:
					self.connecting = false
				case Hubtele.CHAT.Socket.EVENT_RECONNECT_ATTEMPT:
					if (self.programIsEnd) {
						self.chatStream.disconnect()
					}
				case Hubtele.CHAT.Socket.EVENT_ERROR:
					print(event.data)
				case Hubtele.CHAT.ON_PROGRAM_END:
					self.programIsEnd = true
				case Hubtele.CHAT.ON_ERROR:
					print(event.data)
				default:
					print("vm not listen\(event.eventName)")
				}
			}
		)
	}
	
	
	func emitEntry(post: Entry) {
		if (self.connecting) {
			self.chatStream.emitEntry(post)
		} else {
			buffer.append(post)
		}
	}
	
	func disconnect() {
		self.chatStream.disconnect()
	}
}