//
//  Program.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/01/15.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Himotoki
@testable import tvtwit

class ProgramSpec: QuickSpec {
	override func spec() {
		it("parse JSON data to create a new instance") {
			let program: Program? = try? decodeValue(programJSON)
			expect(program).notTo(beNil())
			expect(program!.title) == "テスト用の面白い番組"
			expect(program!.id) == "010123456"
			expect(program!.startAt) != nil
		}
		
		it("startAndEndFormat is correct format") {
			let program: Program? = try? decodeValue(programJSON)
            expect(program!.startAndEndFormat()).to(equal("2月7日 08:01~10:02"))
		}
        it("double month"){
            let program:Program? = try? decodeValue(programJSON2)
            expect(program!.startAndEndFormat()).to(equal("12月17日 08:11~10:02"))
        }
        

	}
	
}