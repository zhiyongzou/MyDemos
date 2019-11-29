//
//  ViewController.m
//  JsonPatchDemo
//
//  Created by zzyong on 2019/11/5.
//  Copyright © 2019 zzyong. All rights reserved.
//

#import "ViewController.h"
#import "JPCommonTypes.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSDictionary *> *testList;
@property (weak, nonatomic) IBOutlet UISwitch *aspectSwitch;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;;
}

#pragma mark - Action

- (IBAction)didClickSwitch:(UISwitch *)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:kDisableAspect];
    
    UIApplication *app = [UIApplication sharedApplication];
    if ([app respondsToSelector:@selector(suspend)]) {
        [app performSelector:@selector(suspend)];
    }
    exit(0);
}

#pragma mark - Private

- (void)setupSubviews
{
    self.aspectSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:kDisableAspect];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    [self.view addSubview:_tableView];
}

- (NSArray<NSDictionary *> *)testList
{
    if (_testList == nil) {
        _testList = @[
                      
            @{@"name":@"- (void)NilException", @"sel":@"-arrayAddNilException"},
            @{@"name":@"+ (void)NilException", @"sel":@"+arrayAddNilException"},
            @{@"name":@"NSArray NSRangeException", @"sel":@"outOfBounceException"}
        ];
    }
    
    return _testList;
}

#pragma mark - UITableView

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.testList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *testInfo = [self.testList objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.textColor  = [UIColor blackColor];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = testInfo[@"name"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSDictionary *testInfo = [self.testList objectAtIndex:indexPath.row];
    NSString *selName = testInfo[@"sel"];
    
    if ([selName isEqualToString:@"-arrayAddNilException"]) {
        
        [self arrayAddNilException:nil];
        
    } else if ([selName isEqualToString:@"+arrayAddNilException"]) {
        
        [ViewController arrayAddNilException:nil];
        
    } else if ([selName isEqualToString:@"outOfBounceException"]) {
        
        [self outOfBoundsException:self.testList.count];
    }
}

#pragma mark - Test

- (void)arrayAddNilException:(id)nilObject
{
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:1];
    [tempArray addObject:nilObject];
}

+ (void)arrayAddNilException:(id)nilObject
{
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:1];
    [tempArray addObject:nilObject];
}

- (void)outOfBoundsException:(NSUInteger)index
{
    [self.testList objectAtIndex:index];
}

@end
