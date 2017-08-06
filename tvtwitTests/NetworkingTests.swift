//
//  NetworkingTests.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/02/01.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import tvtwit

class NetworkingSpec: QuickSpec {
	override func spec() {
		var network: NetworkingImpl!
		beforeEach {
			network = NetworkingImpl()
		}
		
		
		
		describe("JSON") {
			it("eventually gets JSON data as specified with parameters.") {
				var json: [String: AnyObject]? = nil
				let url = "https://httpbin.org/get"
				network.requestJSON(url, parameters: ["a": "b", "x": "y"])
					.on(next: {json = $0 as? [String: AnyObject]})
					.start()
				
				expect(json).toEventuallyNot(beNil(), timeout: 5)
				expect((json?["args"] as? [String: AnyObject])?["a"] as? String)
                    .toEventually(equal("b"), timeout: 5)
				expect((json?["args"] as? [String: AnyObject])?["x"] as? String)
					.toEventually(equal("y"), timeout: 5)
			}
            
            it("eventually gets an error if the network has a problem.") {
                var error: NetworkError? = nil
                let url = "https://not.existing.server.comm/get"
                
                network.requestJSON(url,parameters:["a":"b","x":"y"])
                    .on(failed:{error=$0})
                .start()
                
                expect(error).toEventually(equal(NetworkError.NotReachedServer),timeout:5)
            }
		}
	}
}