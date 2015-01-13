//
//  WMLViewController.m
//  Doppelganger
//
//  Created by Sash Zats on 01/08/2015.
//  Copyright (c) 2014 Sash Zats. All rights reserved.
//

#import "WMLViewController.h"

#import "WMLColoredNumber.h"
#import <Doppelganger/Doppelganger.h>

@interface WMLViewController () <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray *dataSource;
@end

@implementation WMLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [self _randomWords];
    [self _updateDataSource];
}

#pragma mark - Private

- (void)_updateDataSource {
    NSArray *newDataSource = [self _randomWords];
    NSArray *diff = [WMLArrayDiffUtility diffForCurrentArray:newDataSource previousArray:self.dataSource];
    self.dataSource = newDataSource;
    
    // when we update table view, data source should be already updated
    [self _updateTableViewWithDiff:diff];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self _updateDataSource];
    });
}

- (void)_updateTableViewWithDiff:(NSArray *)array {
    [self.tableView wml_applyBatchChanges:array
                                inSection:0
                         withRowAnimation:UITableViewRowAnimationRight];
}

#pragma mark - Private - Data generation

- (NSArray *)_randomWords {
    static NSInteger counter = -1;
    static NSMutableArray *wordSets;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        wordSets = [NSMutableArray array];
    });
    
    counter++;
    counter %= 4; // four different sets of words
    if (counter < wordSets.count) {
        return wordSets[counter];
    }
    
    NSArray *thisSet = ({
        NSMutableArray *array = [NSMutableArray array];
        NSUInteger count = arc4random_uniform(4) + 4;
        NSArray *indeces = [self _shuffleIndecesUpToIndex:count];
        for (NSNumber *idx in indeces) {
            WMLColoredNumber *coloredNumber = [[WMLColoredNumber alloc] initWithNumber:idx.integerValue];
            [array addObject:coloredNumber];
        }
        [array copy];
    });
    
    [wordSets addObject:thisSet];
    return thisSet;
}

- (NSArray *)_shuffleIndecesUpToIndex:(NSUInteger)index {
    NSMutableArray *array = [NSMutableArray array];
    for (NSUInteger i = 0; i < index; ++i) [array addObject:@(i)];
    [array sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if (arc4random_uniform(10) > 5) {
            return NSOrderedDescending;
        }
        return NSOrderedAscending;
    }];
    return [array copy];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    WMLColoredNumber *coloredNumber = self.dataSource[indexPath.row];
    cell.textLabel.text = coloredNumber.displayString;
    cell.contentView.backgroundColor = coloredNumber.color;
    return cell;
}

@end
