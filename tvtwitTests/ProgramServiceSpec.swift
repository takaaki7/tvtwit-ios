//
//  ProgramServiceSpec.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/03/13.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//
import Foundation
import Quick
import Nimble
@testable import Hubtele

class ProgramServiceSpec: QuickSpec {
	override func spec() {
		describe("table") {
			it("get 8 station") {
				var table: [String: ProgramInfo]? = nil
				ProgramServiceImpl().getTable().startWithNext({(t) -> () in
                    print("programServiceSpec t:\(t) size:")
						table = t
					})
                
                expect(table).toEventuallyNot(beNil(),timeout:5)
                expect(table?["01"]?.name).toEventually(contain("NHK"),timeout:5)
				expect(table?["01"]?.program.endAt).toEventuallyNot(beNil(),timeout:5)
                expect(table?["02"]?.program.startAt).toEventuallyNot(beNil(),timeout:5)
				expect(table?.count).toEventually(equal(8))
			}
		}
	}
}