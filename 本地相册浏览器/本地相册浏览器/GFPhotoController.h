//
//  GFPhotoController.h
//  本地相册浏览器
//
//  Created by 李国峰 on 2016/12/16.
//  Copyright © 2016年 李国峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GFPhotoController : UIViewController

@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *leftTitle;

/** 添加拍摄按钮 */
- (void)addShootBtn:(UIButton *)shootBtn Image:(UIImage *)image title:(NSString *)title color:(UIColor *)color frame:(CGRect)rect;

/** 添加返回按钮 */
- (void)addBackBtn:(UIButton *)backBtn Image:(UIImage *)image title:(NSString *)title color:(UIColor *)color frame:(CGRect)rect;

/** 添加旋转按钮 */
- (void)addRotating:(UIButton *)rotaBtn Image:(UIImage *)image title:(NSString *)title color:(UIColor *)color frame:(CGRect)rect;

/** 添加展示图片按钮 */
- (void)addShowPhoto:(UIButton *)showBtn Image:(UIImage *)image title:(NSString *)title color:(UIColor *)color frame:(CGRect)rect userInteractionEnabled:(BOOL)userInteractionEnabled;

@end
