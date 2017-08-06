//
//  Program.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/01/02.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

import Foundation
import Himotoki
var dateMDHMFormatter: NSDateFormatter {    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "M月d日 HH:mm"
    dateFormatter.timeZone = NSTimeZone(name: "JP")
    return dateFormatter
}
var dateHMFormatter: NSDateFormatter {    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    dateFormatter.timeZone = NSTimeZone(name: "JP")
    return dateFormatter
}
final public class Program : Decodable {
    
    let id: String
	let title: String
	let startAt: NSDate
	let endAt: NSDate
	let entryCount: NSInteger
	let station: String
    init(id:String,station:String,title: String, startAt: NSDate, endAt: NSDate, entryCount: NSInteger) {
        self.id = id
		self.title = title
		self.startAt = startAt
		self.endAt = endAt
		self.entryCount = entryCount
        self.station = station
	}
	
	public static func decode(e: Extractor) throws -> Program {
        return try Program(id: e <| "id",
            station: e <| "station",
            title: e <| "title",
            startAt: e <| "start_at",
            endAt: e <| "end_at",
            entryCount: e <| "entryCount")
	}
    
    public func startAndEndFormat() -> String {
        return "\(dateMDHMFormatter.stringFromDate(self.startAt))~\(dateHMFormatter.stringFromDate(self.endAt))"
    }
    
    public func startAndEndFormatExcludeDay() -> String {
        return "\(dateHMFormatter.stringFromDate(self.startAt))~\(dateHMFormatter.stringFromDate(self.endAt))"
    }
}