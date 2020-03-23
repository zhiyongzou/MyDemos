//
//  ViewController.m
//  YYLabelFadeBug
//
//  Created by zzyong on 2020/3/11.
//  Copyright © 2020 zzyong. All rights reserved.
//

#import "ViewController.h"
#import "YYLabelCell.h"
#import <YYText.h>

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSAttributedString *> *richContents;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupRichContents];
    [self setupTableView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;
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
    
    [tableView registerClass:[YYLabelCell class] forCellReuseIdentifier:@"YYLabelCell"];
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)setupRichContents
{
    NSMutableArray<NSAttributedString *> *temp = [NSMutableArray arrayWithCapacity:100];
    UIFont *font = [UIFont systemFontOfSize:15];
    
    for (int idx = 0; idx < 30; idx ++) {
        NSString *text = [NSString stringWithFormat:@"   我是字符串--%@", @(idx)];
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : font}];
        
        if (idx == 5) {
            
            [content appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"    " attributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : font}]];
            
            UIImage *image = [UIImage imageNamed:@"img1"];
            [content appendAttributedString:[NSMutableAttributedString yy_attachmentStringWithContent:image
                                                                                          contentMode:UIViewContentModeCenter
                                                                                       attachmentSize:image.size
                                                                                          alignToFont:font
                                                                                            alignment:YYTextVerticalAlignmentCenter]];
        }
        
        YYTextHighlight *highlight = [[YYTextHighlight alloc] init];
        YYTextBorder *border = [YYTextBorder borderWithFillColor:[UIColor lightGrayColor] cornerRadius:0];
        [highlight setBackgroundBorder:border];
        [content yy_setTextHighlight:highlight range:NSMakeRange(0, content.length)];
        
        [temp addObject:content];
    }
    
    self.richContents = [temp copy];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.richContents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YYLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YYLabelCell" forIndexPath:indexPath];
    cell.richContent = self.richContents[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

@end
