//
//  UISearchBar+RACAdditions.h
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/02/03.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

#ifndef UISearchBar_RACAdditions_h
#define UISearchBar_RACAdditions_h


#endif /* UISearchBar_RACAdditions_h */
#import <UIKit/UIKit.h>
#import "ReactiveCocoa.h"
@interface UISearchBar (RACAdditions) <UISearchBarDelegate>
- (RACSignal *)rac_textSignal;
- (RACSignal *)rac_pressSearchSignal;
@end