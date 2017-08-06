//
//  ProgramInfo.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/01/03.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

import Foundation
import Himotoki

final public class ProgramInfo: Decodable {
	let name: String
	let program: Program
	
	init(name: String, program: Program) {
		self.name = name
		self.program = program
	}
	
	public static func decode(e: Extractor) throws -> ProgramInfo {
        return try ProgramInfo(name: e <| "name",
        program: e <| "program")
	}
    
}