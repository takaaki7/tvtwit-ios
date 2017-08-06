//
//  NSDate+Extensions.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/01/28.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

import Foundation
import Himotoki
extension NSDate : Decodable {
	public static func decode(e: Extractor) throws -> Self {
        return instantiateNSDateHelper(e)
		
	}
    private class func instantiateNSDateHelper<T>(e: Extractor) -> T
    {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ja_JP")
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
        return formatter.dateFromString(e.rawValue as! String) as! T
    }
	convenience init(dateString: String) {
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
		dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
		let d = dateFormatter.dateFromString(dateString)!
		self.init(timeInterval: 0, sinceDate: d)
	}
	
	func isGreaterThanDate(dateToCompare: NSDate) -> Bool {
		// Declare Variables
		var isGreater = false
		
		// Compare Values
		if self.compare(dateToCompare) == NSComparisonResult.OrderedDescending {
			isGreater = true
		}
		
		// Return Result
		return isGreater
	}
	
	func isLessThanDate(dateToCompare: NSDate) -> Bool {
		// Declare Variables
		var isLess = false
		
		// Compare Values
		if self.compare(dateToCompare) == NSComparisonResult.OrderedAscending {
			isLess = true
		}
		
		// Return Result
		return isLess
	}
	
	func equalToDate(dateToCompare: NSDate) -> Bool {
		// Declare Variables
		var isEqualTo = false
		
		// Compare Values
		if self.compare(dateToCompare) == NSComparisonResult.OrderedSame {
			isEqualTo = true
		}
		
		// Return Result
		return isEqualTo
	}
	
	func addDays(daysToAdd: Int) -> NSDate {
		let secondsInDays: NSTimeInterval = Double(daysToAdd) * 60 * 60 * 24
		let dateWithDaysAdded: NSDate = self.dateByAddingTimeInterval(secondsInDays)
		
		// Return Result
		return dateWithDaysAdded
	}
	
	func addHours(hoursToAdd: Int) -> NSDate {
		let secondsInHours: NSTimeInterval = Double(hoursToAdd) * 60 * 60
		let dateWithHoursAdded: NSDate = self.dateByAddingTimeInterval(secondsInHours)
		
		// Return Result
		return dateWithHoursAdded
	}
	
}

/*

 extension Bool: Decodable {
 public static func decode(e: Extractor) throws -> Bool {
 return try castOrFail(e)
 }
 }

 internal func castOrFail<T>(e: Extractor) throws -> T {
 let rawValue = e.rawValue

 guard let result = rawValue as? T else {
 throw typeMismatch("\(T.self)", actual: rawValue, keyPath: nil)
 }

 return result
 }
 */