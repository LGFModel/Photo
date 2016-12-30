//
//  GFPhotoCollectionViewCell.h
//  本地相册浏览器
//
//  Created by 李国峰 on 2016/12/30.
//  Copyright © 2016年 李国峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GFPhotoCollectionViewCell : UICollectionViewCell
@property (nonatomic, assign) int contentOfSetInt;

- (void)array:(NSArray *)array and:(int )row;

- (void)localPhotoArray:(NSArray *)array and:(int )row;
@end
