//
//  ViewController.m
//  DoppelgangerSample
//
//  Created by Sash Zats on 1/17/15.
//  Copyright (c) 2015 Wondermall. All rights reserved.
//

#import "ViewController.h"

#import "RowObject.h"
#import <Doppelganger/Doppelganger.h>

@interface ViewController () <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray *dataSource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _generateDataSource];
}

#pragma mark - Private

- (void)_generateDataSource {
    NSArray *dataSource = [RowObject listOfRowObjects];
    NSArray *diffs = [WMLArrayDiffUtility diffForCurrentArray:dataSource previousArray:self.dataSource];
    self.dataSource = dataSource;
    [self.tableView wml_applyBatchChangesForRows:diffs
                                inSection:0
                         withRowAnimation:UITableViewRowAnimationRight];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self _generateDataSource];
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    RowObject *rowObject = self.dataSource[indexPath.row];
    cell.contentView.backgroundColor = rowObject.color;
    cell.textLabel.text = rowObject.title;
    return cell;
}


@end
