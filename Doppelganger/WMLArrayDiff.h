//
//  WMLArrayDiff.h
//  Pods
//
//  Created by Sash Zats on 1/8/15.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WMLArrayDiffType) {
    WMLArrayDiffTypeMove,
    WMLArrayDiffTypeInsert,
    WMLArrayDiffTypeDelete
};

@interface WMLArrayDiff : NSObject

@property (nonatomic, readonly) WMLArrayDiffType type;

@property (nonatomic, readonly) NSUInteger previousIndex;

@property (nonatomic, readonly) NSUInteger currentIndex;

@end
