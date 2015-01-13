//
//  UIKit+Doppelganger.h
//  Pods
//
//  Created by Sash Zats on 1/13/15.
//
//

#import <UIKit/UIKit.h>

@interface UICollectionView (Doppelganger)

- (void)wml_applyBatchChanges:(NSArray *)changes inSection:(NSUInteger)section completion:(void (^)(BOOL finished))completion;

@end

@interface UITableView (Doppelganger)

- (void)wml_applyBatchChanges:(NSArray *)changes inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;

@end
