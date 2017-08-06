//
//  File.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/03/13.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Himotoki
@testable import tvtwit

class EntrySpec: QuickSpec{
    override func spec(){
        describe("parse"){
            it("parse"){
                var entry:Entry?=nil
                do{
                    entry =  try decodeValue(entryJSON) as Entry
                }catch let error{
                    print("decode error:\(error)")
                }
                expect(entry).notTo(beNil())
                expect(entry?.content).to(equal("hello my friend!!"))
                expect(entry?.type).to(equal(Entry.EntryType.T))
                expect(entry?.userName).to(equal("Superman"))
                expect(entry?.date).notTo(beNil())
            }
        }
    }
}