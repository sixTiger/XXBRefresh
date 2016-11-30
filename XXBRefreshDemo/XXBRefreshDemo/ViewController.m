//
//  ViewController.m
//  XXBRefreshDemo
//
//  Created by xiaobing on 16/4/15.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import "ViewController.h"
#import "XXBRefresh.h"
#import "XXBRefreshHeaderPicView.h"
#import "XXBLibs.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic , strong) UITableView           *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property(nonatomic , strong) NSMutableArray        *dataSouceArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self _initData];
    [self _creatTableView];
}

- (UIImage *)captureScrollView:(UIScrollView *)scrollView {
    CGPoint savedContentOffset = scrollView.contentOffset;
    CGRect savedFrame = scrollView.frame;
    //设置控件显示的区域大小
    scrollView.frame = CGRectMake( 0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
    //设置截屏大小(截屏区域的大小必须要跟视图控件的大小一样)
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, YES, 0.0);
    [[scrollView layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    scrollView.contentOffset = savedContentOffset;
    scrollView.frame = savedFrame;
    return viewImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_initData {
    _dataSouceArray = [NSMutableArray array];
    for (int i = 0; i < 20; i++) {
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
    _tableView.autoresizingMask = (1 << 6) - 1;
//    _tableView.contentInset = UIEdgeInsetsMake(150, 0, 150, 0);
    [_tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [_tableView addFooterWithTarget:self action:@selector(footerRefresh)];
//    XXBAutoRefreshFooterUIView *footer = [[XXBAutoRefreshFooterUIView alloc] initWithFrame:CGRectMake(0, 0, 100, 80)];
//    footer.triggerAutoRefreshMarginBottom  = 1;
//    _tableView.footer = footer;
    
    
//    XXBRefreshHeaderPicView *refreshHeaderPicView = [[XXBRefreshHeaderPicView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
//    _tableView.header = refreshHeaderPicView;
    [self.view bringSubviewToFront:self.imageView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.backgroundColor = [UIColor myRandomColor];
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
        NSInteger count = self.dataSouceArray.count;
        if(count >= 50) {
            [self.tableView footerEndRefreshing];
            self.tableView.footer = nil;
        } else {
            for (NSInteger i = count; i < count + 5; i++) {
                [_dataSouceArray addObject:[NSString stringWithFormat:@"cell >>> %@",@(_dataSouceArray.count)]];
                [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:count inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
            }
        }
        [self.tableView footerEndRefreshing];
    });
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.imageView.image = [self captureScrollView:self.tableView];
}


@end
