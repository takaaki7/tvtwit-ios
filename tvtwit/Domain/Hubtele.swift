//
//  Hubtele.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/02/11.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

import Foundation

internal struct Hubtele {
	internal static let HUBTELE_URL: String =
		"http://" + (NSBundle.mainBundle().objectForInfoDictionaryKey("HUBTELE_HOST") as! String)
	internal static let API_URL = HUBTELE_URL + "/api";
	internal static let API_SEARCH = API_URL + "/search"
	internal static let API_PROGRAM_TABLE = API_URL + "/program_table"
	internal static let API_RANKING = API_URL + "/ranking_weekly"
    internal static let API_TIMESHIFT = API_URL + "/v2/timeshift"
    internal static let API_REPORT=API_URL+"/report"
    
    internal struct KEY {
		internal static let START_INDEX = "startIndex"
        internal static let TITLE="title"
		internal static let COUNT = "count"
        internal static let PROGRAM="program"
	}
	internal struct CHAT {
		internal static let ON_ENTRY = "entry_uploaded"
		internal static let ON_ENTRY_LOG = "entry_log"
		internal static let ON_ERROR = "chat_error"
		internal static let ON_PROGRAM_END = "endProgram"
		internal static let RECONNECTED = "reconnected"
		internal static let POST_UPPLOAD = "post_upload"
		internal static let INIT = "init"
		
        internal struct Socket{
		internal static let EVENT_CONNECTED = "connect"
		internal static let EVENT_RECONNECT_ATTEMPT = "reconnectAttempt"
		internal static let EVENT_RECONNECTED = "reconnect"
		internal static let EVENT_ERROR = "error"
		internal static let EVENT_DISCONNECT = "disconnect"
        }
	}
}