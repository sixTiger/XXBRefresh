//
//  ViewController.m
//  XXBRefreshDemo
//
//  Created by xiaobing on 16/4/15.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import "ViewController.h"
#import "XXBRefresh.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic , strong) UITableView           *tableView;
@property(nonatomic , strong) NSMutableArray        *dataSouceArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self _initData];
    [self _creatTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_initData {
    _dataSouceArray = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        [_dataSouceArray addObject:[NSString stringWithFormat:@"cell >>> %@",@(_dataSouceArray.count)]];
    }
}

- (void) _creatTableView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.rowHeight = 80;
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.contentInset = UIEdgeInsetsMake(150, 0, 0, 0);
    [_tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [_tableView addFooterWithTarget:self action:@selector(footerRefresh)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = self.dataSouceArray[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSouceArray.count;
}

- (void)headerRefresh {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView headerEndRefreshing];
    });
    NSLog(@"下拉刷新了");
}
- (void)footerRefresh {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView footerEndRefreshing];
    });
    NSLog(@"上拉加载更多了");
}
@end
