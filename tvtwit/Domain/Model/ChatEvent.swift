//
//  ChatEvent.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/03/13.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

import Foundation

class ChatEvent {
	let eventName: String
	let data: Any?
	init(eventName: String, data: Any?) {
		self.eventName = eventName
		self.data = data
	}
}