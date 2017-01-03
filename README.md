# Photo
###本地相册浏览器

**本地相册浏览器点击跳转控制器后点击拍照得到的影像会在左上角展示出来,点击展示的图片就会进入到本地图片浏览.**
项目进行了初步封装后续会进一步封装
```
/** 添加拍摄按钮 */
- (void)addShootBtn:(UIButton *)shootBtn Image:(UIImage *)image title:(NSString *)title color:(UIColor *)color frame:(CGRect)rect;

/** 添加返回按钮 */
- (void)addBackBtn:(UIButton *)backBtn Image:(UIImage *)image title:(NSString *)title color:(UIColor *)color frame:(CGRect)rect;

/** 添加旋转按钮 */
- (void)addRotating:(UIButton *)rotaBtn Image:(UIImage *)image title:(NSString *)title color:(UIColor *)color frame:(CGRect)rect;

/** 添加展示图片按钮 */
- (void)addShowPhoto:(UIButton *)showBtn Image:(UIImage *)image title:(NSString *)title color:(UIColor *)color frame:(CGRect)rect userInteractionEnabled:(BOOL)userInteractionEnabled;
```
使用时直接自己添加自己需要的按钮即可,解决了CollectionView卡顿问题以及cell 刷新闪现问题
例如:
```
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
```
注:连接Xcode运行程序后,由于NSLog打印引起的性能问题会导滑动图片致卡顿,解决方法拔掉数据线就OK
-图片一直上传不成功,放到我的简书里面可以看到效果
<a href = "http://www.jianshu.com/writer#/notebooks/3107466/notes/8058119">[记住你姓李]
