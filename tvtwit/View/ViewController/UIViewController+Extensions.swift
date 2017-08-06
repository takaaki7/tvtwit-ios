//
//  UIViewController+Extensions.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/02/11.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
	func goChatScene(program: Program) {
        if(program.endAt.isGreaterThanDate(NSDate())){
        let chatVM=ChatViewModel(program:program)
        let chatVC = ChatViewController(viewModel: chatVM)
        self.navigationController?.pushViewController(chatVC, animated: true)
        }else{
            let timeshiftVC=TimeshiftViewController(timeshiftService: TimeshiftServiceImpl(),program:program)
            self.navigationController?.pushViewController(timeshiftVC, animated: true)
        }
	}
}