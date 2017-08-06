//
//  EntryTableCell.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/04/08.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
class EntryTableViewCell: UITableViewCell, ReactiveView {
	
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
	var entry: Entry? {
		didSet {
			self.userLabel.text = self.entry?.userName
			self.timeLabel.text = self.entry?.formatDate()
            if(entry?.imagePath != nil){
                self.profileImage.sd_setImageWithURL(NSURL(string: (entry?.imagePath)!))
            }else{
                self.profileImage.image=nil
            }
			self.contentLabel.text = self.entry?.content as? String
		}
	}
	

	func bindViewModel(viewModel: AnyObject) {
		let vm = viewModel as! ChatEntryItemViewModel
		self.entry = vm.entry
	}
}