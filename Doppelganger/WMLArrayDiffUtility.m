//
//  WMLArrayDiffUtility.m
//  Pods
//
//  Created by Sash Zats on 1/8/15.
//
//

#import "WMLArrayDiffUtility.h"
#import "WMLArrayDiff+Creation.h"


@interface WMLArrayDiffUtility ()

@property (nonatomic, copy) NSArray *previousArray;

@property (nonatomic, copy) NSArray *currentArray;

@property (nonatomic, copy) NSArray *diff;

@end


@implementation WMLArrayDiffUtility

+ (NSArray *)diffForCurrentArray:(NSArray *)currentArray previousArray:(NSArray *)previousArray {
    WMLArrayDiffUtility *utility = [[self alloc] initWithCurrentArray:currentArray previousArray:previousArray];
    [utility performDiff];
    return utility.diff;
}

- (instancetype)initWithCurrentArray:(NSArray *)currentArray previousArray:(NSArray *)previousArray {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.previousArray = previousArray;
    self.currentArray = currentArray;
    return self;
}

- (instancetype)init {
    return [self initWithCurrentArray:nil previousArray:nil];
}

- (void)performDiff {
    NSSet *previousSet = [NSSet setWithArray:self.previousArray];
    NSSet *currentSet = [NSSet setWithArray:self.currentArray];
    NSSet *deletedObject = ({
        NSMutableSet *set = [previousSet mutableCopy];
        [set minusSet:currentSet];
        [set copy];
    });
    NSSet *insertedObjects = ({
        NSMutableSet *set = [currentSet mutableCopy];
        [set minusSet:previousSet];
        [set copy];
    });
    
    NSArray *moveDiffs = [self _moveDiffsWithDeletedObjects:deletedObject insertedObjects:insertedObjects];
    NSArray *deletionDiffs = [self _deletionsForArray:self.previousArray deletedObjects:deletedObject];
    NSArray *insertionDiffs = [self _insertionForArray:self.currentArray insertedObjects:insertedObjects];
    
    NSMutableArray *results = [NSMutableArray array];
    [results addObjectsFromArray:deletionDiffs];
    [results addObjectsFromArray:insertionDiffs];
    [results addObjectsFromArray:moveDiffs];
    self.diff = results;
}

- (NSArray *)_deletionsForArray:(NSArray *)array deletedObjects:(NSSet *)deletedObjects {
    NSMutableArray *result = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![deletedObjects containsObject:obj]) {
            return;
        }
        [result addObject:[WMLArrayDiff arrayDiffForDeletionAtIndex:idx]];
    }];
    return [result copy];
}

- (NSArray *)_insertionForArray:(NSArray *)array insertedObjects:(NSSet *)insertedObjects {
    NSMutableArray *result = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![insertedObjects containsObject:obj]) {
            return;
        }
        [result addObject:[WMLArrayDiff arrayDiffForInsertionAtIndex:idx]];
    }];
    return [result copy];
}

- (NSArray *)_moveDiffsWithDeletedObjects:(NSSet *)deletedObjects insertedObjects:(NSSet *)insertedObjects {    
    // TODO: Improve on O(n^2)
    __block NSInteger delta = 0;
    NSMutableArray *result = [NSMutableArray array];
    [self.previousArray enumerateObjectsUsingBlock:^(id leftObj, NSUInteger leftIdx, BOOL *stop) {
        if ([deletedObjects containsObject:leftObj]) {
            delta++;
            return;
        }
        NSUInteger localDelta = delta;
        for (NSUInteger rightIdx = 0; rightIdx < self.currentArray.count; ++rightIdx) {
            id rightObj = self.currentArray[rightIdx];
            if ([insertedObjects containsObject:rightObj]) {
                localDelta--;
                continue;
            }
            if (![rightObj isEqual:leftObj]) {
                continue;
            }
            NSInteger adjustedRightIdx = rightIdx + localDelta;
            if (leftIdx != rightIdx && adjustedRightIdx != leftIdx) {
                [result addObject:[WMLArrayDiff arrayDiffForMoveFromIndex:leftIdx toIndex:rightIdx]];
            }
            return;
        }
    }];
    return [result copy];
}

@end
