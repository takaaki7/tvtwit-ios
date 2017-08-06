//
//  ChatService.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/05/06.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

import Foundation
import ReactiveCocoa
protocol TimeshiftService{
    func timeshift(programId:String,startIndex:Int,count:Int)->SignalProducer<[Entry?],NetworkError>
    func report(entryId:String)->SignalProducer<String,NetworkError>
}