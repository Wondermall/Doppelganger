//
//  WMLArrayDiff.m
//  Pods
//
//  Created by Sash Zats on 1/8/15.
//
//

#import "WMLArrayDiff.h"
#import "WMLArrayDiff+Creation.h"


@interface WMLArrayDiff ()

@property (nonatomic) WMLArrayDiffType type;

@property (nonatomic) NSUInteger previousIndex;

@property (nonatomic) NSUInteger currentIndex;

@end


@implementation WMLArrayDiff

+ (instancetype)arrayDiffForDeletionAtIndex:(NSUInteger)index {
    WMLArrayDiff *instance = [WMLArrayDiff new];
    instance.type = WMLArrayDiffTypeDelete;
    instance.previousIndex = index;
    return instance;
}

+ (instancetype)arrayDiffForInsertionAtIndex:(NSUInteger)index {
    WMLArrayDiff *instance = [WMLArrayDiff new];
    instance.type = WMLArrayDiffTypeInsert;
    instance.currentIndex = index;
    return instance;
}

+ (instancetype)arrayDiffForMoveFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    WMLArrayDiff *instance = [WMLArrayDiff new];
    instance.type = WMLArrayDiffTypeMove;
    instance.previousIndex = fromIndex;
    instance.currentIndex = toIndex;
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.previousIndex = NSNotFound;
    self.currentIndex = NSNotFound;
    return self;
}

- (NSString *)description {
    switch (self.type) {
        case WMLArrayDiffTypeMove:
            return [NSString stringWithFormat:@"<%@: %p> {type=move; from=%tu; to=%tu}", [self class], self, self.previousIndex, self.currentIndex];
        case WMLArrayDiffTypeInsert:
            return [NSString stringWithFormat:@"<%@: %p> {type=insertion; to=%tu}", [self class], self, self.currentIndex];
        case WMLArrayDiffTypeDelete:
            return [NSString stringWithFormat:@"<%@: %p> {type=deletion; from=%tu}", [self class], self, self.previousIndex];
    }
}

@end
