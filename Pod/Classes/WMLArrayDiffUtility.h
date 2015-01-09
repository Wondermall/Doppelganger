//
//  WMLArrayDiffUtility.h
//  Pods
//
//  Created by Sash Zats on 1/8/15.
//
//

#import <Foundation/Foundation.h>

@interface WMLArrayDiffUtility : NSObject

+ (NSArray *)diffForCurrentArray:(NSArray *)currentArray previousArray:(NSArray *)previousArray;

@property (nonatomic, copy, readonly) NSArray *previousArray;

@property (nonatomic, copy, readonly) NSArray *currentArray;

/**
 *  Returns an array of @c WMLArrayDiff objects ready to be wrapped into 
 *  @c NSIndexPath and fed to table or collection view.
 */
@property (nonatomic, copy, readonly) NSArray /* WMLArrayDiff */ *diff;

- (instancetype)initWithCurrentArray:(NSArray *)currentArray previousArray:(NSArray *)previousArray;

- (void)performDiff;

@end
