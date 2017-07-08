//
//  UICollectionView+WCQCollectionViewPlaceholder.h
//  WCQTableViewPlaceholder
//
//  Created by wcq on 2017/7/3.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (WCQCollectionViewPlaceholder)

/**
 Showing the loadingState style placeholder view when the collectionView is loading data
 */
- (void)wcq_setLoadingState;
/**
 Showing the anormalNetwork style placeholder view after the collectionView loaded fail
 */
- (void)wcq_setAnormalNetwork;

@end
