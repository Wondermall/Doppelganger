//
//  WMLColoredNumber.m
//  Doppelganger
//
//  Created by Sash Zats on 1/8/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

#import "WMLColoredNumber.h"

@interface WMLColoredNumber ()

@property (nonatomic) NSInteger number;

@property (nonatomic, copy) NSString *displayString;

@property (nonatomic) UIColor *color;

@end

@implementation WMLColoredNumber

- (instancetype)initWithNumber:(NSInteger)number {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.number = number;
    self.displayString = [self _stringFromNumber:number];
    self.color = [self _colorForIndex:number];
    
    return self;
}

- (instancetype)init {
    return [self initWithNumber:NSNotFound];
}

#pragma mark - Private

- (NSString *)_stringFromNumber:(NSInteger)number {
    static NSNumberFormatter *numberFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.numberStyle = NSNumberFormatterSpellOutStyle;
    });

    NSString *string = [numberFormatter stringFromNumber:@(number)];
    string = [NSString stringWithFormat:@"%@%@", [string substringToIndex:1].capitalizedString, [string substringFromIndex:1]];
    return string;
}

- (UIColor *)_colorForIndex:(NSInteger)index {
    static NSArray *palette;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        palette = @[
            [UIColor colorWithRed:0.725 green:0.212 blue:0.169 alpha:1.000],
            [UIColor colorWithRed:0.231 green:0.694 blue:0.353 alpha:1.000],
            [UIColor colorWithRed:0.925 green:0.624 blue:0.071 alpha:1.000],
            [UIColor colorWithRed:0.243 green:0.490 blue:0.733 alpha:1.000],
            [UIColor colorWithRed:0.553 green:0.208 blue:0.690 alpha:1.000],
            [UIColor colorWithRed:0.204 green:0.635 blue:0.518 alpha:1.000],
            [UIColor colorWithRed:0.243 green:0.745 blue:0.600 alpha:1.000],
            [UIColor colorWithRed:0.588 green:0.290 blue:0.714 alpha:1.000],
            [UIColor colorWithRed:0.922 green:0.784 blue:0.027 alpha:1.000],
            [UIColor colorWithRed:0.212 green:0.635 blue:0.322 alpha:1.000],
            [UIColor colorWithRed:0.875 green:0.282 blue:0.235 alpha:1.000],
        ];
    });
    return palette[index % palette.count];
}

#pragma mark - NSObject

- (BOOL)isEqualToColoredNumber:(WMLColoredNumber *)otherNumber {
    return self.number == otherNumber.number;
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[WMLColoredNumber class]]) {
        return [self isEqualToColoredNumber:object];
    }
    return [super isEqual:object];
}

- (NSUInteger)hash {
    return self.number;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p> {number=%td}", [self class], self, self.number];
}

@end
