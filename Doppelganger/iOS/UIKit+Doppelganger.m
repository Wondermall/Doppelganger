//
//  UIKit+Doppelganger.m
//  Pods
//
//  Created by Sash Zats on 1/13/15.
//
//

#import "UIKit+Doppelganger.h"

#import "WMLArrayDiff.h"


static NSString *const WMLArrayDiffSourceIndexPathKey = @"WMLArrayDiffSourceIndexPathKey";
static NSString *const WMLArrayDiffDestinationIndexPathKey = @"WMLArrayDiffDestinationIndexPathKey";


@implementation UICollectionView (Doppelganger)

- (void)wml_applyBatchChanges:(NSArray *)changes inSection:(NSUInteger)section completion:(void (^)(BOOL))completion {
    NSMutableArray *insertion = [NSMutableArray array];
    NSMutableArray *deletion = [NSMutableArray array];
    NSMutableArray *moving = [NSMutableArray array];
    
    for (WMLArrayDiff *diff in changes) {
        switch (diff.type) {
            case WMLArrayDiffTypeDelete:
                [deletion addObject:[NSIndexPath indexPathForItem:diff.previousIndex inSection:section]];
                break;
            
            case WMLArrayDiffTypeInsert:
                [insertion addObject:[NSIndexPath indexPathForItem:diff.currentIndex inSection:section]];
                break;

            case WMLArrayDiffTypeMove:
                [moving addObject:diff];
                break;
        }
    }
    
    [self performBatchUpdates:^{
        [self insertItemsAtIndexPaths:insertion];
        [self deleteItemsAtIndexPaths:deletion];
        for (WMLArrayDiff *diff in moving) {
            [self moveItemAtIndexPath:[NSIndexPath indexPathForItem:diff.previousIndex inSection:section]
                          toIndexPath:[NSIndexPath indexPathForItem:diff.currentIndex inSection:section]];
        }
    } completion:completion];
}

@end

@implementation UITableView (Doppelganger)

- (void)wml_applyBatchChanges:(NSArray *)changes inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation {
    NSMutableArray *insertion = [NSMutableArray array];
    NSMutableArray *deletion = [NSMutableArray array];
    NSMutableArray *moving = [NSMutableArray array];
    
    for (WMLArrayDiff *diff in changes) {
        switch (diff.type) {
            case WMLArrayDiffTypeDelete:
                [deletion addObject:[NSIndexPath indexPathForItem:diff.previousIndex inSection:section]];
                break;
                
            case WMLArrayDiffTypeInsert:
                [insertion addObject:[NSIndexPath indexPathForItem:diff.currentIndex inSection:section]];
                break;
                
            case WMLArrayDiffTypeMove:
                [moving addObject:diff];
                break;
        }
    }
    
    [self beginUpdates];
    [self deleteRowsAtIndexPaths:deletion withRowAnimation:animation];
    [self insertRowsAtIndexPaths:insertion withRowAnimation:animation];
        for (WMLArrayDiff *diff in moving) {
            [self moveRowAtIndexPath:[NSIndexPath indexPathForItem:diff.previousIndex inSection:section]
                         toIndexPath:[NSIndexPath indexPathForItem:diff.currentIndex inSection:section]];
        }
    [self endUpdates];
}

@end
