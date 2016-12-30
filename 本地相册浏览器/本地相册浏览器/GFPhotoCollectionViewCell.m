//
//  GFPhotoCollectionViewCell.m
//  本地相册浏览器
//
//  Created by 李国峰 on 2016/12/30.
//  Copyright © 2016年 李国峰. All rights reserved.
//

#import "GFPhotoCollectionViewCell.h"
#import <Photos/Photos.h>

#define sheight [[UIScreen mainScreen] bounds].size.height
#define sWidth [[UIScreen mainScreen] bounds].size.width

@interface GFPhotoCollectionViewCell()
@property (nonatomic,weak)UIImageView *imageView;
@property (nonatomic,assign)UIButton *btn;
@end

@implementation GFPhotoCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        [self addSubview:imageView];
        self.imageView = imageView;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.autoresizesSubviews = YES;
        
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
    }
    return self;
}

- (void)array:(NSArray *)array and:(int )row{
    // 为cell里的imageView 添加图片
    PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
    
    [imageManager requestImageForAsset:array[row]
     
                            targetSize:CGSizeMake(320, 320)
     
                           contentMode:PHImageContentModeAspectFit
     
                               options:nil
     
                         resultHandler:^(UIImage *result, NSDictionary *info) {
                             
                             self.imageView.image = result;
                             if (result == nil) {
                                 [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadData" object:nil];
                             }
                             
                         }];
// 这个不要注释 故意写的,要不会出现卡顿现象图片一闪一闪的
    NSLog(@"%@",array);
}
- (void)localPhotoArray:(NSArray *)array and:(int )row{
    self.imageView.image = [UIImage imageNamed:array[row]];
}

@end
