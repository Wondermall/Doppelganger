//
//  RowObject.h
//  DoppelgangerSample
//
//  Created by Sash Zats on 1/17/15.
//  Copyright (c) 2015 Wondermall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RowObject : NSObject

+ (instancetype)rowObjectWithColor:(UIColor *)color title:(NSString *)title;

@property (nonatomic, readonly) UIColor *color;

@property (nonatomic, copy, readonly) NSString *title;

- (instancetype)initWithColor:(UIColor *)color title:(NSString *)title NS_DESIGNATED_INITIALIZER;

@end


@interface RowObject (Generation)

+ (NSArray *)listOfRowObjects;

@end