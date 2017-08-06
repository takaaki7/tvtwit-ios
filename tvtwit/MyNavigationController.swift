//
//  MyNavigationController.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/06/01.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

import Foundation
import UIKit
class MyNavigationController:UINavigationController{
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }

}