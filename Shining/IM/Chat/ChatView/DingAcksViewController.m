//
//  DingAcksViewController.m
//  Shining
//
//  Created by 鹏飞 季 on 2019/2/22.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "DingAcksViewController.h"

#import "IMDingMessageHelper.h"

@interface DingAcksViewController ()

@property (nonatomic, strong) EMMessage *message;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation DingAcksViewController

- (instancetype)initWithMessage:(EMMessage *)aMessage
{
    self = [super init];
    if (self) {
        _message = aMessage;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.title = [NSBundle sy_localizedStringForKey:@"title.readList" value:@"Read Users"];
    self.dataArray = [[NSMutableArray alloc] init];
    NSArray *array = [[IMDingMessageHelper sharedHelper] usersHasReadMessage:self.message];
    [self.dataArray addObjectsFromArray:array];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.rowHeight = 50;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    
    return cell;
}

@end
