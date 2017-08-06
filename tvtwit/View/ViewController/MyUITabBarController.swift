//
//  MyUITabBarController.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/05/28.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

import Foundation
import UIKit

class MyTabBarController : UITabBarController {
	
	override func viewWillLayoutSubviews() {
		var tabFrame = self.tabBar.frame
		let height = 30 as CGFloat
		tabFrame.size.height = height
		tabFrame.origin.y = self.view.frame.size.height - height
		self.tabBar.frame = tabFrame
	}
    
}