//
//  RowObject.m
//  DoppelgangerSample
//
//  Created by Sash Zats on 1/17/15.
//  Copyright (c) 2015 Wondermall. All rights reserved.
//

#import "RowObject.h"

static inline NSComparator RandomComparator() {
    return ^NSComparisonResult(id a, id b) {
        return arc4random_uniform(100) > 50 ? NSOrderedAscending : NSOrderedDescending;
    };
}

@implementation RowObject

+ (instancetype)rowObjectWithColor:(UIColor *)color title:(NSString *)title {
    return [[self alloc] initWithColor:color title:title];
}

- (instancetype)initWithColor:(UIColor *)color title:(NSString *)title {
    self = [super init];
    if (!self) {
        return nil;
    }
    _color = color;
    _title = title;
    return self;
}

- (instancetype)init {
    return [self initWithColor:nil title:nil];
}

#pragma mark - Equality

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[RowObject class]]) {
        return [self isEqualToRowObject:object];
    }
    return [super isEqual:object];
}

- (BOOL)isEqualToRowObject:(RowObject *)object {
    return [self.title isEqualToString:object.title] && [self.color isEqual:object.color];
}

- (NSUInteger)hash {
    return [self.title hash];
}

@end


@implementation RowObject (Generation)

+ (NSArray *)listOfRowObjects {
    NSMutableArray *result = [NSMutableArray array];
    NSUInteger count = arc4random_uniform(5) + 5;
    for (NSUInteger i = 0; i < count; ++i) {
        UIColor *color = [self _colorForIndex:i];
        NSString *title = [self _titleForIndex:i];
        RowObject *rowObject = [RowObject rowObjectWithColor:color title:title];
        [result addObject:rowObject];
    }
    [result sortUsingComparator:RandomComparator()];
    return [result copy];
}

+ (NSString *)_titleForIndex:(NSUInteger)index {
    static NSNumberFormatter *numberFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        numberFormatter = [NSNumberFormatter new];
        numberFormatter.numberStyle = NSNumberFormatterSpellOutStyle;
    });
    NSArray *allLocales = ({
        NSArray *array = [NSLocale availableLocaleIdentifiers];
        array = [array sortedArrayUsingComparator:RandomComparator()];
        array;
    });
    
    NSString *localeIdentifier = allLocales[index % allLocales.count];
    
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:localeIdentifier];
    numberFormatter.locale = locale;
    return [numberFormatter stringFromNumber:@(index)];
}

+ (UIColor *)_colorForIndex:(NSUInteger)index {
    static NSArray *colors;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        colors = @[
            [UIColor colorWithRed:0.725 green:0.212 blue:0.169 alpha:1.000],
            [UIColor colorWithRed:0.231 green:0.694 blue:0.353 alpha:1.000],
            [UIColor colorWithRed:0.925 green:0.624 blue:0.071 alpha:1.000],
            [UIColor colorWithRed:0.243 green:0.490 blue:0.733 alpha:1.000],
            [UIColor colorWithRed:0.553 green:0.208 blue:0.690 alpha:1.000],
            [UIColor colorWithRed:0.204 green:0.635 blue:0.518 alpha:1.000],
            [UIColor colorWithRed:0.875 green:0.282 blue:0.235 alpha:1.000],
            [UIColor colorWithRed:0.212 green:0.635 blue:0.322 alpha:1.000],
            [UIColor colorWithRed:0.922 green:0.784 blue:0.027 alpha:1.000],
            [UIColor colorWithRed:0.294 green:0.573 blue:0.859 alpha:1.000],
            [UIColor colorWithRed:0.588 green:0.290 blue:0.714 alpha:1.000],
            [UIColor colorWithRed:0.243 green:0.745 blue:0.600 alpha:1.000]
        ];
        colors = [colors sortedArrayUsingComparator:RandomComparator()];
    });
    return colors[index % colors.count];
}

@end