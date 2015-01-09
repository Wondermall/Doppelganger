//
//  WMLArrayDiffUtility.h
//  Pods
//
//  Created by Sash Zats on 1/8/15.
//
//

#import <Foundation/Foundation.h>

@interface WMLArrayDiffUtility : NSObject

+ (NSArray *)diffForPreviousArray:(NSArray *)previousArray currentArray:(NSArray *)currentArray;

@property (nonatomic, copy, readonly) NSArray *previousArray;

@property (nonatomic, copy, readonly) NSArray *currentArray;

/**
 *  Returns an array of @c WMLArrayDiff objects ready to be wrapped into 
 *  @c NSIndexPath and fed to table or collection view.
 */
@property (nonatomic, copy, readonly) NSArray /* WMLArrayDiff */ *diff;

- (instancetype)initWithPreviousArray:(NSArray *)previousArray
                         currentArray:(NSArray *)currentArray NS_DESIGNATED_INITIALIZER;

- (void)performDiff;

@end
