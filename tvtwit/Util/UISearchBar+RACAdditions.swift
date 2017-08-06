//
//  UISearchBar+RACAdditions.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/02/03.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
extension UISearchBar:UISearchBarDelegate {
	func rac_textSignal() -> RACSignal {
		self.delegate = self;
        var signal:RACSignal? = objc_getAssociatedObject(self, __FUNCTION__) as? RACSignal
		if (signal != nil) {
			return signal!
		}
		
        signal = self.rac_signalForSelector("searchBar:textDidChange:", fromProtocol: UISearchBarDelegate.self).mapAs {(tuple:RACTuple) -> NSString in
			return tuple.second as! NSString
		}
        return signal!
	}
	func rac_pressSearchSignal() -> RACSignal {
		self.delegate = self
        var signal:RACSignal? = objc_getAssociatedObject(self, __FUNCTION__) as? RACSignal
        if (signal != nil) {
            return signal!
        }
		
        signal = self.rac_signalForSelector("searchBarSearchButtonClicked:", fromProtocol: UISearchBarDelegate.self).map {tuple in
			return tuple.second
		}
		objc_setAssociatedObject(self,__FUNCTION__, signal, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		return signal!
	}
}
