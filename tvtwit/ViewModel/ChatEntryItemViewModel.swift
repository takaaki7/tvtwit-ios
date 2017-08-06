//
//  ChatEntryItemViewModel.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/04/08.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

import Foundation
class ChatEntryItemViewModel: NSObject {
    let entry: Entry
    
    init(entry: Entry){
        self.entry=entry
        super.init()
    }
}