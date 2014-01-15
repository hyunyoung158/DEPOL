//
//  ViewController.m
//  DEPOL
//
//  Created by SDT-1 on 2014. 1. 9..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "ViewController.h"
#import "Cell.h"
#import <sqlite3.h>

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *collectionTable;
@end

@implementation ViewController {
    sqlite3 *db;
    NSArray *data;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [data count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //cell 리턴
    Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL_ID" forIndexPath:indexPath];
//    cell.lable.text
    cell.label.text = [NSString stringWithFormat:@"%d", (int)indexPath.row];
    
    return cell;
}

- (void)openDB {
    NSString *dbFilePath = [[NSBundle mainBundle] pathForResource:@"db" ofType:@"sqlite"];
    int ret = sqlite3_open([dbFilePath UTF8String], &db);
    
    NSAssert1(SQLITE_OK == ret, @"Error: %s", sqlite3_errmsg(db));
    NSLog(@"Success");
}

- (void)selectMesseges {
    NSString *queryStr = @"SELECT * from portfolio";
    sqlite3_stmt *stmt;
    sqlite3_prepare_v2(db, [queryStr UTF8String], -1, &stmt, NULL);
    
    while (SQLITE_ROW == sqlite3_step(stmt)) {
        char *name = (char *)sqlite3_column_text(stmt, 1);
        NSString *senderString = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        NSLog(@"name: %@", senderString);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    data = @[@"A",@"B",@"C",@"D"];
    
    [self openDB];
    [self selectMesseges];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
