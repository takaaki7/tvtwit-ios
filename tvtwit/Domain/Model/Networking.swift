//
//  Networking.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/02/01.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

import Foundation
import ReactiveCocoa

public protocol Networking {
    func requestJSON(url:String, parameters: [String: AnyObject]?) -> SignalProducer<AnyObject, NetworkError>
    func requestPost(url:String,parameters:[String:AnyObject]?)->SignalProducer<AnyObject,NetworkError>
}