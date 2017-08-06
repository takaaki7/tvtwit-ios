//
//  MyUITabBar.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/05/29.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

import Foundation
import UIKit

class MyUITabBar : UITabBar{
    override func sizeThatFits(size: CGSize) -> CGSize {
        var sizeThatFits=super.sizeThatFits(size)
        sizeThatFits.height=40
        return sizeThatFits
    }
}