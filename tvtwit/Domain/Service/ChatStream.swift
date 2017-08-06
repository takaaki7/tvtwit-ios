//
//  ChatStream.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/03/06.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

import Foundation
import ReactiveCocoa
protocol ChatStream {
    func connect()
    func emitInit(programId:String)
    func report(id:String)
    func emitEntry(post:Entry)
    func emitReconnected(programId:String)
    func getEventStream()->SignalProducer<ChatEvent,NetworkError>
    func getEntryStream()->SignalProducer<Entry,NetworkError>
    func disconnect()
}