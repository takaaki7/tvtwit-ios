//
//  UtilSpec.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/02/06.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import tvtwit

class UtilSpec:QuickSpec{
    override func spec(){
        it("dateUtil format constructor"){
            let d=NSDate(dateString: "2016/02/06 20:01:22")
            let calendar = NSCalendar.currentCalendar()
            let comp = calendar.components([.Year,.Month,.Day,.Hour,.Minute,.Second],fromDate:d)
            expect(comp.year).to(equal(2016))
            expect(comp.month).to(equal(2))
            expect(comp.day).to(equal(6))
            expect(comp.hour).to(equal(20))
            expect(comp.minute).to(equal(1))
            expect(comp.second).to(equal(22))
        }
    }
}