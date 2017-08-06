//
//  Post.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/03/06.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

import Foundation
import Himotoki
var dateEntryFormatter: NSDateFormatter {
    let dateFormatter = NSDateFormatter()
    print("entry dateFormatter create")
    dateFormatter.dateFormat = "HH:mm:ss"
    dateFormatter.timeZone = NSTimeZone(name: "JP")
    return dateFormatter
}

class MyFormatter:NSDateFormatter{
    required init(coder aDecoder:NSCoder){
        super.init(coder:aDecoder)!
        
    }
    override init(){
        super.init()
        print("entry dateFormatter create")
        self.dateFormat = "HH:mm:ss"
        self.timeZone = NSTimeZone(name: "JP")
    }
}

class Singleton {
    class var formatter : NSDateFormatter {
        struct Static {
            static let instance = MyFormatter()
        }
        return Static.instance
    }
}

final class Entry: Decodable {
	var id: String?
	var content: NSString
	var userName: String?
	var date: NSDate?
	var imagePath: String?
	var type: EntryType?
	init(id: String, content: String, userId: String?, userName: String, replyTo: String?,
		replies: [Entry]?, date: NSDate, screenName: String?, imagePath: String?, type: EntryType) {
		self.id = id
		self.content = content
		self.userName = userName
		self.date = date
		self.imagePath = imagePath
		self.type = type
	}
    
    init(content:String){
        self.content=content
    }
	
	static func decode(e: Extractor) throws -> Entry {
		return try Entry(id: e <| "_id",
            content: e <| "content",
            userId: e <|? "userId",
            userName: e <| "userName",
            replyTo: e <|? "replyTo",
            replies: e <||? "replies",
            date: e <| "date",
            screenName: e <|? "screenName",
            imagePath: e <|? "imagePath",
            type: e <| "type"
        )
	}
    
    func formatDate() -> String{
        return "\(Singleton.formatter.stringFromDate(self.date!))"
    }
    
	internal enum EntryType : Decodable {
		case T, P, U
        static func decode(e:Extractor)throws -> EntryType{
            return fromValue(e.rawValue as! String)
        }
        static func fromValue(value: String) -> EntryType {
            if (value == "T") {
                return .T
            } else if(value=="P"){
                return .P
            }else{
                return .U
            }
        }
	}
}