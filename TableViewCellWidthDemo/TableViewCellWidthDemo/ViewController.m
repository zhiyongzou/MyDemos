//
//  ViewController.m
//  TableViewCellWidthDemo
//
//  Created by zzyong on 2019/11/15.
//  Copyright © 2019 zzyong. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCellInit.h"
#import "TableViewCellDequeue.h"

@interface ViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTableView];
    // Do any additional setup after loading the view.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = CGRectMake(20, 0, self.view.frame.size.width - 40, self.view.frame.size.height);
}

- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.allowsSelection = NO;
    tableView.scrollsToTop = NO;
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.alwaysBounceVertical = YES;
    tableView.backgroundColor = [UIColor clearColor];
    [tableView registerClass:[TableViewCellDequeue class] forCellReuseIdentifier:@"TableViewCellDequeue"];
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCellDequeue" forIndexPath:indexPath];
        NSLog(@"TableViewCellDequeue frame: %@", NSStringFromCGRect(cell.frame));
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCellInit"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableViewCellInit"];
        }
        NSLog(@"TableViewCellInit frame: %@", NSStringFromCGRect(cell.frame));
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

@end
