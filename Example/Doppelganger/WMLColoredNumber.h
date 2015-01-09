//
//  WMLColoredNumber.h
//  Doppelganger
//
//  Created by Sash Zats on 1/8/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMLColoredNumber : NSObject

@property (nonatomic, readonly) NSInteger number;

@property (nonatomic, copy, readonly) NSString *displayString;

@property (nonatomic, readonly) UIColor *color;

- (instancetype)initWithNumber:(NSInteger)number;

@end
