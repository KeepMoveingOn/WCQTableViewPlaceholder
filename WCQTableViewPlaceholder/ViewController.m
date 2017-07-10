//
//  ViewController.m
//  WCQTableViewPlaceholder
//
//  Created by wcq on 2017/7/2.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ViewController.h"
#import "WCQTableViewPlaceholderDelegate.h"
#import "UITableView+WCQTableViewPlaceholder.h"
#import "MJRefresh.h"
#import "AFNetworking.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, WCQTableViewPlaceholderDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Refresh Methods
- (void)reloadData {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"http://baike.baidu.com/api/openapi/BaikeLemmaCardApi?scope=103&format=json&appid=379020&bk_key=hello&bk_length=600"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    [self.tableView wcq_setLoadingState];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            [self.tableView.mj_header endRefreshing];
            [self.tableView wcq_setAnormalNetwork];
        } else {
            NSLog(@"%@ %@", response, responseObject);
            [self.tableView.mj_header endRefreshing];
            self.dataArray = [NSMutableArray arrayWithArray:@[@"1", @"2", @"3"]];
            [self.tableView reloadData];
        }
    }];
    [dataTask resume];
}

- (void)loadData {
    
    [self.tableView wcq_setLoadingState];
    [self.dataArray removeAllObjects];
    [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:3.0];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0
                                           green:arc4random()%256/255.0
                                            blue:arc4random()%256/255.0
                                           alpha:1];
    return cell;
}

#pragma mark - UITableViewDelegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
}

#pragma mark - WCQTableViewPlaceholderDelegate Methods
- (UIView *)wcq_tableViewPlaceholderInLoadingState {
    
    UIImageView *placeholderView = [UIImageView new];
    placeholderView.contentMode = UIViewContentModeScaleAspectFill;
    placeholderView.image = [UIImage imageNamed:@"loading"];
    return placeholderView;
}

- (UIView *)wcq_tableViewPlaceholderInAnormalNetState {
    
    UIImageView *placeholderView = [UIImageView new];
    placeholderView.contentMode = UIViewContentModeScaleAspectFill;
    placeholderView.image = [UIImage imageNamed:@"anormal"];
    return placeholderView;
}

//- (UIView *)wcq_tableViewPlaceholderInEmptyDatasourceState {
//    
//    UIImageView *placeholderView = [UIImageView new];
//    placeholderView.contentMode = UIViewContentModeScaleAspectFill;
//    placeholderView.image = [UIImage imageNamed:@"emptyData"];
//    return placeholderView;
//}

- (BOOL)wcq_enableScroll {
    
    return YES;
}

#pragma mark - Getter Methods
- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadData)];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

@end
