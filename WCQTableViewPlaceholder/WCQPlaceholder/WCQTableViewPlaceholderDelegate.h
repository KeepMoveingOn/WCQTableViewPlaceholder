//
//  WCQTableViewPlaceholderDelegate.h
//  WCQTableViewPlaceholder
//
//  Created by wcq on 2017/7/2.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol WCQTableViewPlaceholderDelegate <NSObject>

@required
/**
 The placeholder view Which is showing in loading state

 @return Your custom placeholder view
 */
- (UIView *)wcq_tableViewPlaceholderInLoadingState;
/**
 The placeholder view Which is showing in anormal network state

 @return Your custom placeholder view
 */
- (UIView *)wcq_tableViewPlaceholderInAnormalNetState;
/**
 The placeholder view Which is showing When there is not any rows in your each section

 @return Your custom placeholder view
 */
- (UIView *)wcq_tableViewPlaceholderInEmptyDatasourceState;

@optional
/**
 Wether the tableView can scroll When the palceholder view is showing

 @return It returns NO by default
 */
- (BOOL)wcq_enableScroll;

@end
