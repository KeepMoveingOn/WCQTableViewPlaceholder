//
//  UITableView+WCQTableViewPlaceholder.h
//  WCQTableViewPlaceholder
//
//  Created by wcq on 2017/7/2.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (WCQTableViewPlaceholder)

/**
 Showing the loadingState style placeholder view when the tableView is loading data
 */
- (void)wcq_setLoadingState;
/**
 Showing the anormalNetwork style placeholder view after the tableView loaded fail
 */
- (void)wcq_setAnormalNetwork;

@end
