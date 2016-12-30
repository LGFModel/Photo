//
//  GFLooksPhotoController.m
//  本地相册浏览器
//
//  Created by 李国峰 on 2016/12/30.
//  Copyright © 2016年 李国峰. All rights reserved.
//

#import "GFLooksPhotoController.h"
#import <Photos/Photos.h>
#import "GFPhotoCollectionViewCell.h"



#define sheight [[UIScreen mainScreen] bounds].size.height
#define sWidth [[UIScreen mainScreen] bounds].size.width

@interface GFLooksPhotoController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,weak)UIImageView *imageView ;
@property (nonatomic,weak)UICollectionView *collection;
@end

@implementation GFLooksPhotoController


- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.view.backgroundColor = [UIColor colorWithRed:246.0/255 green:246.0/255 blue:246.0/255 alpha:1.0];

    self.title = @"浏览";
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collection  =[[UICollectionView alloc]initWithFrame:CGRectMake(0,60,sWidth,sheight-60) collectionViewLayout:flowLayout];
    collection.showsVerticalScrollIndicator = YES;
    collection.showsHorizontalScrollIndicator = YES;
    collection.pagingEnabled = YES;
    
    collection.backgroundColor = [UIColor blackColor];
    collection.delegate = self;
    collection.dataSource = self;
    [collection registerClass:[GFPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"PhotoCellId"];
    [self.view addSubview:collection];
    collection.contentOffset = CGPointMake(sWidth*self.contentOfSetInt, 0);
    self.collection = collection;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloaddate) name:@"reloadData" object:nil];
}
-(void)reloaddate{
    [self.collection reloadData];
}
- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.array.count;
}


//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(sWidth,sheight-70);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1.0/375*sWidth, 0.0/375*sWidth, 0.0/375*sWidth, 1.0/375*sWidth);
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GFPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCellId" forIndexPath:indexPath];
    [cell array:self.array and:indexPath.row];
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
