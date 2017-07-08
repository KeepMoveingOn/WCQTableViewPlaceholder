//
//  WCQCollectionViewPlaceholderDelegate.h
//  WCQTableViewPlaceholder
//
//  Created by wcq on 2017/7/3.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WCQCollectionViewPlaceholderDelegate <NSObject>

@required
/**
 The placeholder view Which is showing in loading state
 
 @return Your custom placeholder view
 */
- (UIView *)wcq_collectionViewPlaceholderInLoadingState;
/**
 The placeholder view Which is showing in anormal network state
 
 @return Your custom placeholder view
 */
- (UIView *)wcq_collectionViewPlaceholderInAnormalNetState;
/**
 The placeholder view Which is showing When there is not any rows in your each section
 
 @return Your custom placeholder view
 */
- (UIView *)wcq_collectionViewPlaceholderInEmptyDatasourceState;

@optional
/**
 Wether the tableView can scroll When the palceholder view is showing
 
 @return It returns NO by default
 */
- (BOOL)wcq_enableScroll;

@end
