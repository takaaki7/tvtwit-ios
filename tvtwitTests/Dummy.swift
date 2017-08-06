//
//  Dummy.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/01/15.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

import Foundation
@testable import tvtwit
//"2016-02-07T09:00:00.000Z"
let programJSON: [String:AnyObject]=[
    "id":"010123456",
    "title":"テスト用の面白い番組",
    "start_at":"2016-02-06T23:01:22.000Z",
    "end_at":"2016-02-07T01:02:30.000Z",
    "entryCount":1234,
    "station":"01"
]
let programJSON2: [String:AnyObject]=[
    "id":"010123456",
    "title":"テスト用の面白い番組",
    "start_at":"2016-12-16T23:11:22.000Z",
    "end_at":"2016-12-17T01:02:30.000Z",
    "entryCount":1234,
    "station":"01"
]

let entryJSON: [String:AnyObject]=[
    "_id" : "56e54d0d7a39874000c9b853",
    "content" : "hello my friend!!",
    "date" :"2016-03-13T11:20:24.000Z",
    "imagePath" :"http://pbs.twimg.com/profile_images/705360144373125120/L07TdIk8_normal.jpg",
    "screenName" :"Ksmt0328hndR",
    "type": "T",
    "userName" :"Superman"
]