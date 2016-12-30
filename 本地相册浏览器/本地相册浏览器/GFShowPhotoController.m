//
//  GFShowPhotoController.m
//  本地相册浏览器
//
//  Created by 李国峰 on 2016/12/30.
//  Copyright © 2016年 李国峰. All rights reserved.
//

#import "GFShowPhotoController.h"
#import "GFPhotoCollectionViewCell.h"
#import "GFLooksPhotoController.h"
#define sheight [[UIScreen mainScreen] bounds].size.height
#define sWidth [[UIScreen mainScreen] bounds].size.width

@interface GFShowPhotoController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,weak)UICollectionView *collection;
@property (nonatomic,assign)NSIndexPath *indePath;
@end


@implementation GFShowPhotoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //返回按钮
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sWidth, 64.0/667*sheight)];
//    view.backgroundColor = [UIColor blackColor];
//    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(10.0/375*[[UIScreen mainScreen] bounds].size.width, 22.0/667*[[UIScreen mainScreen] bounds].size.height, 40.0/667*[[UIScreen mainScreen] bounds].size.height, 40.0/667*[[UIScreen mainScreen] bounds].size.height)];
//    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100.0/375*[[UIScreen mainScreen] bounds].size.width, 22.0/667*[[UIScreen mainScreen] bounds].size.height, 175.0/375*[[UIScreen mainScreen] bounds].size.width, 40.0/667*[[UIScreen mainScreen] bounds].size.height)];
//    
//    titleLabel.text = @"查看图片";
//    titleLabel.textColor = [UIColor whiteColor];
//    titleLabel.font = [UIFont systemFontOfSize:18.0/667*[[UIScreen mainScreen] bounds].size.height];
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    [view addSubview:titleLabel];
//    [self.view addSubview:view];
    
    self.title = @"图片浏览";
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    
    UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    UICollectionView *collection  =[[UICollectionView alloc]initWithFrame:CGRectMake(0,60,sWidth,sheight-60) collectionViewLayout:flowLayout];
    collection.backgroundColor = [UIColor colorWithRed:225.0/255 green:225.0/255 blue:225.0/255 alpha:1.0];
    collection.delegate = self;
    collection.dataSource = self;
    self.collection = collection;
    [collection registerClass:[GFPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"mycellid"];
    [self.view addSubview:collection];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloaddate) name:@"reloadData" object:nil];
    
    
}

-(void)reloaddate{
    [self.collection reloadData];
}

- (void)back{
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


/**
 *  内存警告
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assetArray.count;
}


//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((sWidth-4)/3.0, 164.0/667*sheight);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1.0/375*sWidth, 1.0/375*sWidth, 1.0/375*sWidth, 1.0/375*sWidth);
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.indePath = indexPath;
    GFPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mycellid" forIndexPath:indexPath];
    [cell array:self.assetArray and:indexPath.row];
    return cell;
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GFLooksPhotoController *lookPhotoController = [[GFLooksPhotoController alloc]init];
    lookPhotoController.contentOfSetInt = indexPath.row;
    lookPhotoController.array = self.assetArray;
    [self.navigationController pushViewController:lookPhotoController animated:YES];
}

@end

