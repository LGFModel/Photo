//
//  ViewController.m
//  本地相册浏览器
//
//  Created by 李国峰 on 2016/12/16.
//  Copyright © 2016年 李国峰. All rights reserved.
//

#import "ViewController.h"
#import "GFPhotoController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"相册图片浏览器";
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(200, 200, 100, 50)];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"相机" forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)btnClick{
    
    GFPhotoController *photoVC = [[GFPhotoController alloc]init];
    photoVC.title = @"查看图片";
    photoVC.leftTitle = @"返回";
    
    [photoVC addRotating:[UIButton new] Image:nil title:@"旋转" color:[UIColor grayColor] frame:CGRectMake(0, 600, 125, 50)];
    [photoVC addShootBtn:[UIButton new] Image:nil title:@"拍摄" color:[UIColor grayColor] frame:CGRectMake(125, 600, 125, 50)];
    [photoVC addBackBtn:[UIButton new] Image:nil title:@"返回" color:[UIColor grayColor] frame:CGRectMake(250, 600, 125, 50)];
    // 展示图片这个
    [photoVC addShowPhoto:[UIButton new] Image:nil title:nil color:nil frame:CGRectMake(10, 74, 90, 120) userInteractionEnabled:NO];

    [self.navigationController pushViewController:photoVC animated:YES];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
