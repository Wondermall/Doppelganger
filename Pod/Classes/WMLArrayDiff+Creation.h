//
//  WMLArrayDiff+Creation.h
//  Pods
//
//  Created by Sash Zats on 1/8/15.
//
//

#import "WMLArrayDiff.h"

@interface WMLArrayDiff (Creation)

+ (instancetype)arrayDiffForDeletionAtIndex:(NSUInteger)index;

+ (instancetype)arrayDiffForInsertionAtIndex:(NSUInteger)index;

+ (instancetype)arrayDiffForMoveFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

@end
