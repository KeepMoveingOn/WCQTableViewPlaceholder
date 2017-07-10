//
//  UICollectionView+WCQCollectionViewPlaceholder.m
//  WCQTableViewPlaceholder
//
//  Created by wcq on 2017/7/3.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "UICollectionView+WCQCollectionViewPlaceholder.h"
#import "WCQCollectionViewPlaceholderDelegate.h"
#import <objc/runtime.h>

@interface UICollectionView ()

@property (nonatomic, strong) UIView *emptyDatasourcePlaceholder;
@property (nonatomic, strong) UIView *anormalNetworkPlaceholder;
@property (nonatomic, strong) UIView *loadingPlaceholder;

@end

@implementation UICollectionView (WCQCollectionViewPlaceholder)

+ (void)load {
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        SEL originalSelector = @selector(reloadData);
        SEL swizzledSelector = @selector(wcq_reloadData);
        
        Class class = [self class];
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod = class_addMethod(class,
                                            originalSelector,
                                            method_getImplementation(swizzledMethod),
                                            method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        }else {
            
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)wcq_reloadData {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self wcq_reloadData];
        [self wcq_checkDatasourceIsEmpty];
    });
}

- (void)wcq_setLoadingState {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self wcq_clearnExistPlaceholder];
        [self wcq_checkEnableToSroll];
        
        if (!self.loadingPlaceholder) {
            
            NSString *reason = @"If you want to show the placeholder view of anormal net work, please implement the wcq_collectionViewPlaceholderInLoadingState Method in your custom collectionView of collectionView delegate";
            if ([self respondsToSelector:@selector(wcq_collectionViewPlaceholderInLoadingState)]) {
                
                self.loadingPlaceholder = [self performSelector:@selector(wcq_collectionViewPlaceholderInLoadingState) withObject:nil];
            }else if ([self.delegate respondsToSelector:@selector(wcq_collectionViewPlaceholderInLoadingState)]) {
                
                self.loadingPlaceholder = [self.delegate performSelector:@selector(wcq_collectionViewPlaceholderInLoadingState) withObject:nil];
            }else {
                
                [NSException exceptionWithName:NSGenericException reason:reason userInfo:nil];
            }
            
            self.loadingPlaceholder.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
            [self addSubview:self.loadingPlaceholder];
        }else {
            
            self.loadingPlaceholder.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
            [self addSubview:self.loadingPlaceholder];
        }
    });
}

- (void)wcq_setAnormalNetwork {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self wcq_clearnExistPlaceholder];
        [self wcq_checkEnableToSroll];
        
        if (!self.anormalNetworkPlaceholder) {
            
            NSString *reason = @"If you want to show the placeholder view of anormal net work, please implement the wcq_collectionViewPlaceholderInAnormalNetState Method in your custom collectionView of collectionView delegate";
            if ([self respondsToSelector:@selector(wcq_collectionViewPlaceholderInAnormalNetState)]) {
                
                self.anormalNetworkPlaceholder = [self performSelector:@selector(wcq_collectionViewPlaceholderInAnormalNetState) withObject:nil];
            }else if ([self.delegate respondsToSelector:@selector(wcq_collectionViewPlaceholderInAnormalNetState)]) {
                
                self.anormalNetworkPlaceholder = [self.delegate performSelector:@selector(wcq_collectionViewPlaceholderInAnormalNetState) withObject:nil];
            }else {
                
                @throw [NSException exceptionWithName:NSGenericException reason:reason userInfo:nil];
            }
            
            self.anormalNetworkPlaceholder.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
            [self addSubview:self.anormalNetworkPlaceholder];
        }else {
            
            self.anormalNetworkPlaceholder.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
            [self addSubview:self.anormalNetworkPlaceholder];
        }
    });
}

- (void)wcq_checkDatasourceIsEmpty {
    
    id<UICollectionViewDataSource> dataSource = self.dataSource;
    NSInteger section = 1;
    BOOL isEmpty = YES;
    
    if ([dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
        
        section = [dataSource numberOfSectionsInCollectionView:self];
    }
    
    for (NSInteger index = 0; index < section; index++) {
        
        NSInteger rows = [dataSource collectionView:self numberOfItemsInSection:index];
        if (rows) {
            
            isEmpty = NO;
            break;
        }
    }
    
    [self wcq_clearnExistPlaceholder];
    if (isEmpty) {
        
        if (!self.emptyDatasourcePlaceholder) {
            
            NSString *reason = @"If you want to show the placeholder view of emptyDatasource, please implement the wcq_collectionViewPlaceholderInEmptyDatasourceState Method in your custom collectionView of collectionView delegate";
            if ([self respondsToSelector:@selector(wcq_collectionViewPlaceholderInEmptyDatasourceState)]) {
                
                self.emptyDatasourcePlaceholder = [self performSelector:@selector(wcq_collectionViewPlaceholderInEmptyDatasourceState) withObject:nil];
            }else if ([self.delegate respondsToSelector:@selector(wcq_collectionViewPlaceholderInEmptyDatasourceState)]) {
                
                self.emptyDatasourcePlaceholder = [self.delegate performSelector:@selector(wcq_collectionViewPlaceholderInEmptyDatasourceState) withObject:nil];
            }else {
                
                @throw [NSException exceptionWithName:NSGenericException reason:reason userInfo:nil];
            }
            
            [self wcq_checkEnableToSroll];
            self.emptyDatasourcePlaceholder.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
            [self addSubview:self.emptyDatasourcePlaceholder];
        }else {
            
            self.emptyDatasourcePlaceholder.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
            [self addSubview:self.emptyDatasourcePlaceholder];
        }
    }
}

- (void)wcq_checkEnableToSroll {
    
    if ([self respondsToSelector:@selector(wcq_enableScroll)]) {
        
        self.scrollEnabled = [self performSelector:@selector(wcq_enableScroll) withObject:nil];
    }else if ([self.delegate respondsToSelector:@selector(wcq_enableScroll)]) {
        
        self.scrollEnabled = [self.delegate performSelector:@selector(wcq_enableScroll) withObject:nil];
    }
}

- (void)wcq_clearnExistPlaceholder {
    
    [self.loadingPlaceholder removeFromSuperview];
    [self.emptyDatasourcePlaceholder removeFromSuperview];
    [self.anormalNetworkPlaceholder removeFromSuperview];
}

#pragma mark - Getter Methods
- (UIView *)emptyDatasourcePlaceholder {
    
    return objc_getAssociatedObject(self, _cmd);
}

- (UIView *)anormalNetworkPlaceholder {
    
    return objc_getAssociatedObject(self, _cmd);
}

- (UIView *)loadingPlaceholder {
    
    return objc_getAssociatedObject(self, _cmd);
}

#pragma mark - Setter Methods
- (void)setEmptyDatasourcePlaceholder:(UIView *)emptyDatasourcePlaceholder {
    
    objc_setAssociatedObject(self, @selector(emptyDatasourcePlaceholder), emptyDatasourcePlaceholder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setAnormalNetworkPlaceholder:(UIView *)anormalNetworkPlaceholder {
    
    objc_setAssociatedObject(self, @selector(anormalNetworkPlaceholder), anormalNetworkPlaceholder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setLoadingPlaceholder:(UIView *)loadingPlaceholder {
    
    objc_setAssociatedObject(self, @selector(loadingPlaceholder), loadingPlaceholder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
