//
//  WMLArrayDiffUtilityUnitTestSpec.m
//  Wondermall
//
//  Created by Sash Zats on 1/7/15.
//  Copyright (c) 2015 Wondermall Inc. All rights reserved.
//

#import <Doppelganger/Doppelganger.h>

@interface CustomObject : NSObject
+ (instancetype)customObjectWithString:(NSString *)string;
@property (nonatomic, copy, readonly) NSString *string;
- (instancetype)initWithString:(NSString *)string NS_DESIGNATED_INITIALIZER;
- (BOOL)isEqualToCustomObject:(CustomObject *)otherObject;
@end

@interface CustomObject ()
@property (nonatomic, copy) NSString *string;
@end

@implementation CustomObject

+ (instancetype)customObjectWithString:(NSString *)string {
    return [[self alloc] initWithString:string];
}

- (instancetype)initWithString:(NSString *)string {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.string = string;
    return self;
}

- (instancetype)init {
    return [self initWithString:nil];
}

- (BOOL)isEqualToCustomObject:(CustomObject *)otherObject {
    return [self.string isEqualToString:otherObject.string];
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[CustomObject class]]) {
        return [self isEqualToCustomObject:object];
    }
    return [super isEqual:object];
}

- (NSUInteger)hash {
    return [self.string hash];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@:%p> {string=%@}", [self class], self, self.string];
}

@end


SpecBegin(WMLArrayDiffUtilityUnitTest)

describe(@"Array Diff Utility", ^{
    context(@"no changes", ^{
        it(@"should result in no diffs", ^{
            
            NSArray *left = @[ @1, @2, @3 ];
            NSArray *right = @[ @1, @2, @3 ];
            
            WMLArrayDiffUtility *utility = [[WMLArrayDiffUtility alloc] initWithPreviousArray:left currentArray:right];
            [utility performDiff];
            expect(utility.diff).to.beEmpty();
        });
    });
    
    context(@"insertion", ^{
        it(@"at the end", ^{
            NSArray *left = @[ @1, @2, @3 ];
            NSArray *right = @[ @1, @2, @3, @4, @5 ];
            
            WMLArrayDiffUtility *utility = [[WMLArrayDiffUtility alloc] initWithPreviousArray:left currentArray:right];
            [utility performDiff];
            
            expect(utility.diff).to.haveCountOf(2);
            
            // @4
            WMLArrayDiff *diff1 = utility.diff.firstObject;
            expect(diff1.type).to.equal(WMLArrayDiffTypeInsert);
            expect(diff1.currentIndex).to.equal(3);
            
            // @5
            WMLArrayDiff *diff2 = utility.diff.lastObject;
            expect(diff2.type).to.equal(WMLArrayDiffTypeInsert);
            expect(diff2.currentIndex).to.equal(4);
        });
        
        it(@"at the beginning", ^{
            NSArray *left = @[ @1, @2, @3 ];
            NSArray *right = @[ @-1, @0, @1, @2, @3 ];
            
            WMLArrayDiffUtility *utility = [[WMLArrayDiffUtility alloc] initWithPreviousArray:left currentArray:right];
            [utility performDiff];
            
            expect(utility.diff).to.haveCountOf(2);
            
            // @-1
            WMLArrayDiff *diff1 = utility.diff.firstObject;
            expect(diff1.type).to.equal(WMLArrayDiffTypeInsert);
            expect(diff1.currentIndex).to.equal(0);
            
            // @0
            WMLArrayDiff *diff2 = utility.diff.lastObject;
            expect(diff2.type).to.equal(WMLArrayDiffTypeInsert);
            expect(diff2.currentIndex).to.equal(1);
        });
        
        it(@"in the middle", ^{
            NSArray *left = @[ @1, @2, @3 ];
            NSArray *right = @[ @1, @2, @2.5, @2.7, @3 ];
            
            WMLArrayDiffUtility *utility = [[WMLArrayDiffUtility alloc] initWithPreviousArray:left currentArray:right];
            [utility performDiff];
            
            expect(utility.diff).to.haveCountOf(2);
            
            // @2.5
            WMLArrayDiff *diff1 = utility.diff.firstObject;
            expect(diff1.type).to.equal(WMLArrayDiffTypeInsert);
            expect(diff1.currentIndex).to.equal(2);
            
            // @2.7
            WMLArrayDiff *diff2 = utility.diff.lastObject;
            expect(diff2.type).to.equal(WMLArrayDiffTypeInsert);
            expect(diff2.currentIndex).to.equal(3);
        });
        
        it(@"at random position", ^{
            NSArray *left = @[ @1, @2, @3 ];
            NSArray *right = @[ @1, @"foo", @2, @"bar", @3 ];
            
            WMLArrayDiffUtility *utility = [[WMLArrayDiffUtility alloc] initWithPreviousArray:left currentArray:right];
            [utility performDiff];
            
            expect(utility.diff).to.haveCountOf(2);
            
            // @"foo"
            WMLArrayDiff *diff1 = utility.diff.firstObject;
            expect(diff1.type).to.equal(WMLArrayDiffTypeInsert);
            expect(diff1.currentIndex).to.equal(1);
            
            // @"bar"
            WMLArrayDiff *diff2 = utility.diff.lastObject;
            expect(diff2.type).to.equal(WMLArrayDiffTypeInsert);
            expect(diff2.currentIndex).to.equal(3);
        });
    });
    
    context(@"deletion", ^{
        it(@"in the beginning", ^{
            NSArray *left = @[ @1, @2, @3 ];
            NSArray *right = @[ @3 ];
            
            WMLArrayDiffUtility *utility = [[WMLArrayDiffUtility alloc] initWithPreviousArray:left currentArray:right];
            [utility performDiff];
            
            expect(utility.diff).to.haveCountOf(2);
            
            // @1
            WMLArrayDiff *diff1 = utility.diff.firstObject;
            expect(diff1.type).to.equal(WMLArrayDiffTypeDelete);
            expect(diff1.previousIndex).to.equal(0);
            
            // @3
            WMLArrayDiff *diff2 = utility.diff.lastObject;
            expect(diff2.type).to.equal(WMLArrayDiffTypeDelete);
            expect(diff2.previousIndex).to.equal(1);
        });
        
        it(@"at the end", ^{
            NSArray *left = @[ @1, @2, @3 ];
            NSArray *right = @[ @1 ];
            
            WMLArrayDiffUtility *utility = [[WMLArrayDiffUtility alloc] initWithPreviousArray:left currentArray:right];
            [utility performDiff];
            
            expect(utility.diff).to.haveCountOf(2);
            
            // @2
            WMLArrayDiff *diff1 = utility.diff.firstObject;
            expect(diff1.type).to.equal(WMLArrayDiffTypeDelete);
            expect(diff1.previousIndex).to.equal(1);

            // @3
            WMLArrayDiff *diff2 = utility.diff.lastObject;
            expect(diff2.type).to.equal(WMLArrayDiffTypeDelete);
            expect(diff2.previousIndex).to.equal(2);
        });
        
        it(@"in the middle", ^{
            NSArray *left = @[ @1, @2, @3 ];
            NSArray *right = @[ @1, @3 ];
            
            WMLArrayDiffUtility *utility = [[WMLArrayDiffUtility alloc] initWithPreviousArray:left currentArray:right];
            [utility performDiff];
            
            expect(utility.diff).to.haveCountOf(1);
            
            // @2
            WMLArrayDiff *diff1 = utility.diff.firstObject;
            expect(diff1.type).to.equal(WMLArrayDiffTypeDelete);
            expect(diff1.previousIndex).to.equal(1);
        });
    });
    
    context(@"insertion and deletion", ^{
       it(@"overlapping", ^{
           NSArray *left = @[ @1, @2, @3, @4 ];
           NSArray *right = @[ @"foo", @2, @3, @"bar" ];
           
           WMLArrayDiffUtility *utility = [[WMLArrayDiffUtility alloc] initWithPreviousArray:left currentArray:right];
           [utility performDiff];
           
           expect(utility.diff).to.haveCountOf(4); // 2 deletion + 2 insertion
           
           // @1
           WMLArrayDiff *diff1 = utility.diff[0];
           expect(diff1.type).to.equal(WMLArrayDiffTypeDelete);
           expect(diff1.previousIndex).to.equal(0);

           // @4
           WMLArrayDiff *diff2 = utility.diff[1];
           expect(diff2.type).to.equal(WMLArrayDiffTypeDelete);
           expect(diff2.previousIndex).to.equal(3);

           // @"foo"
           WMLArrayDiff *diff3 = utility.diff[2];
           expect(diff3.type).to.equal(WMLArrayDiffTypeInsert);
           expect(diff3.currentIndex).to.equal(0);

           // @"bar"
           WMLArrayDiff *diff4 = utility.diff[3];
           expect(diff4.type).to.equal(WMLArrayDiffTypeInsert);
           expect(diff4.currentIndex).to.equal(3);
        });

        it(@"not overlapping", ^{
            NSArray *left = @[ @1, @2, @3, @4 ];
            NSArray *right = @[ @2, @"foo", @3 ];
            
            WMLArrayDiffUtility *utility = [[WMLArrayDiffUtility alloc] initWithPreviousArray:left currentArray:right];
            [utility performDiff];
            
            expect(utility.diff).to.haveCountOf(3); // 2 deletion + 1 insertion
            
            // @1
            WMLArrayDiff *diff1 = utility.diff[0];
            expect(diff1.type).to.equal(WMLArrayDiffTypeDelete);
            expect(diff1.previousIndex).to.equal(0);
            
            // @4
            WMLArrayDiff *diff2 = utility.diff[1];
            expect(diff2.type).to.equal(WMLArrayDiffTypeDelete);
            expect(diff2.previousIndex).to.equal(3);
            
            // @"foo"
            WMLArrayDiff *diff3 = utility.diff[2];
            expect(diff3.type).to.equal(WMLArrayDiffTypeInsert);
            expect(diff3.currentIndex).to.equal(1);
        });
    });
    
    context(@"moving", ^{
        it(@"shuffling", ^{
            NSArray *left = @[ @1, @2, @3 ];
            NSArray *right = @[ @3, @1, @2 ];
            
            WMLArrayDiffUtility *utility = [[WMLArrayDiffUtility alloc] initWithPreviousArray:left currentArray:right];
            [utility performDiff];
            
            expect(utility.diff).to.haveCountOf(3);
            
            // @1
            WMLArrayDiff *diff1 = utility.diff[0];
            expect(diff1.type).to.equal(WMLArrayDiffTypeMove);
            expect(diff1.previousIndex).to.equal(0);
            expect(diff1.currentIndex).to.equal(1);
            
            // @2
            WMLArrayDiff *diff2 = utility.diff[1];
            expect(diff2.type).to.equal(WMLArrayDiffTypeMove);
            expect(diff2.previousIndex).to.equal(1);
            expect(diff2.currentIndex).to.equal(2);
            
            // @3
            WMLArrayDiff *diff3 = utility.diff[2];
            expect(diff3.type).to.equal(WMLArrayDiffTypeMove);
            expect(diff3.previousIndex).to.equal(2);
            expect(diff3.currentIndex).to.equal(0);
        });
    });
    
    context(@"mixed", ^{
       it(@"deletion, insertion and moving", ^{
           NSArray *left = @[ @1, @2, @3 ];
           NSArray *right = @[ @3, @2, @5 ];
           
           WMLArrayDiffUtility *utility = [[WMLArrayDiffUtility alloc] initWithPreviousArray:left currentArray:right];
           [utility performDiff];
           
           expect(utility.diff).to.haveCountOf(3); // 1 deletion + 1 insertion + 1 moving
           
           // @1
           WMLArrayDiff *diff1 = utility.diff[0];
           expect(diff1.type).to.equal(WMLArrayDiffTypeDelete);
           expect(diff1.previousIndex).to.equal(0);
           
           // @5
           WMLArrayDiff *diff2 = utility.diff[1];
           expect(diff2.type).to.equal(WMLArrayDiffTypeInsert);
           expect(diff2.currentIndex).to.equal(2);
           
           // @3
           WMLArrayDiff *diff3 = utility.diff[2];
           expect(diff3.type).to.equal(WMLArrayDiffTypeMove);
           expect(diff3.previousIndex).to.equal(2);
           expect(diff3.currentIndex).to.equal(0);
       });
    });
    
    context(@"custom object, implementing isEqual:", ^{
        it(@"deletion, insertion and moving", ^{
            
            NSArray *left = @[
                [CustomObject customObjectWithString:@"a"],
                [CustomObject customObjectWithString:@"b"],
                [CustomObject customObjectWithString:@"c"]
            ];
            
            NSArray *right = @[
                [CustomObject customObjectWithString:@"c"],
                [CustomObject customObjectWithString:@"b"],
                [CustomObject customObjectWithString:@"d"]
            ];
            
            WMLArrayDiffUtility *utility = [[WMLArrayDiffUtility alloc] initWithPreviousArray:left currentArray:right];
            [utility performDiff];

            expect(utility.diff).to.haveCountOf(3); // 1 deletion + 1 insertion + 1 moving

            // CustomObject @"a"
            WMLArrayDiff *diff1 = utility.diff[0];
            expect(diff1.type).to.equal(WMLArrayDiffTypeDelete);
            expect(diff1.previousIndex).to.equal(0);

            // CustomObject @"c"
            WMLArrayDiff *diff2 = utility.diff[1];
            expect(diff2.type).to.equal(WMLArrayDiffTypeInsert);
            expect(diff2.currentIndex).to.equal(2);

            // CustomObject @"d"
            WMLArrayDiff *diff3 = utility.diff[2];
            expect(diff3.type).to.equal(WMLArrayDiffTypeMove);
            expect(diff3.previousIndex).to.equal(2);
            expect(diff3.currentIndex).to.equal(0);
       });
    });
});

SpecEnd