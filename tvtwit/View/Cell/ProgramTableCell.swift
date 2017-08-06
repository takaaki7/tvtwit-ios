//
//  ProgramTableCell.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/02/11.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

import Foundation
import UIKit

class ProgramTableCell: UICollectionViewCell {
	

    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
    

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}