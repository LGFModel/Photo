//
//  GFPhotoController.m
//  本地相册浏览器
//
//  Created by 李国峰 on 2016/12/16.
//  Copyright © 2016年 李国峰. All rights reserved.
//

#import "GFPhotoController.h"
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import "GFShowPhotoController.h"

#define kMainScreenWidth [UIScreen mainScreen].bounds.size.width
#define kMainScreenHeight  [UIScreen mainScreen].bounds.size.height

@interface GFPhotoController ()<UIGestureRecognizerDelegate>
@property (nonatomic,strong)NSMutableArray *assetArray;
@property (nonatomic,strong)PHFetchResult * fetchResult;

@property (nonatomic, strong) AVCaptureSession* session;//AVCaptureSession对象来执行输入设备和输出设备之间的数据传递
@property (nonatomic, strong) AVCaptureStillImageOutput* stillImageOutput;//照片输出流
@property (nonatomic, strong) AVCaptureDeviceInput* videoInput;//输入设备
@property (nonatomic, strong) AVCaptureVideoPreviewLayer* previewLayer;//预览图层
@property (nonatomic) dispatch_queue_t sessionQueue;//AVFoundation
@property(nonatomic,assign)CGFloat beginGestureScale;//记录开始的缩放比例
@property(nonatomic,assign)CGFloat effectiveScale;//最后的缩放比例
@property (nonatomic,weak)UIButton *photoBtn;


@end

@implementation GFPhotoController

-(NSMutableArray *)assetArray{
    if (!_assetArray) {
        _assetArray = [NSMutableArray array];
    }
    return _assetArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.title;
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithTitle:self.leftTitle style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    [self initAVCaptureSession];

    [self setUpGesture];
    
    [self switchCameraSegmentedControlClick];
    self.effectiveScale = self.beginGestureScale = 1.0f;
    
    self.view.backgroundColor = [UIColor clearColor];
    

    
    
}
/** 添加展示图片按钮 */
- (void)addShowPhoto:(UIButton *)showBtn Image:(UIImage *)image title:(NSString *)title color:(UIColor *)color frame:(CGRect)rect userInteractionEnabled:(BOOL)userInteractionEnabled{
    
    [self.view addSubview:showBtn];
    showBtn.userInteractionEnabled = userInteractionEnabled;
    [showBtn addTarget:self action:@selector(openPhoto) forControlEvents:UIControlEventTouchUpInside];
    [showBtn setImage:image forState:UIControlStateNormal];
    [showBtn setTitle:title forState:UIControlStateNormal];
    showBtn.backgroundColor = color;
    showBtn.frame = rect;
    self.photoBtn = showBtn;
}

/** 添加拍摄按钮 */
-(void)addShootBtn:(UIButton *)shootBtn Image:(UIImage *)image title:(NSString *)title color:(UIColor *)color frame:(CGRect)rect{

    [self.view addSubview:shootBtn];
    shootBtn.frame = rect;
    shootBtn.backgroundColor = color;
    [shootBtn setTitle:title forState:UIControlStateNormal];
    [shootBtn setImage:image forState:UIControlStateNormal];
    [shootBtn addTarget:self action:@selector(Shooting:) forControlEvents:UIControlEventTouchUpInside];

}

/** 添加返回按钮 */
-(void)addBackBtn:(UIButton *)backBtn Image:(UIImage *)image title:(NSString *)title color:(UIColor *)color frame:(CGRect)rect{
    
    [self.view addSubview:backBtn];
    backBtn.frame = rect;
    backBtn.backgroundColor = color;
    [backBtn setTitle:title forState:UIControlStateNormal];
    [backBtn setImage:image forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
}

/** 添加旋转按钮 */
-(void)addRotating:(UIButton *)rotaBtn Image:(UIImage *)image title:(NSString *)title color:(UIColor *)color frame:(CGRect)rect{
    [self.view addSubview:rotaBtn];
    rotaBtn.backgroundColor = color;
    rotaBtn.frame = rect;
    [rotaBtn setTitle:title forState:UIControlStateNormal];
    [rotaBtn setImage:image forState:UIControlStateNormal];
    [rotaBtn addTarget:self action:@selector(changeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark ------------------------ 切换前后镜头 ------------------------
- (void)changeBtnClick:(UIButton *)sender {
    NSArray *inputs = self.session.inputs;
    for ( AVCaptureDeviceInput *input in inputs ) {
        AVCaptureDevice *device = input.device;
        if ( [device hasMediaType:AVMediaTypeVideo] ) {
            AVCaptureDevicePosition position = device.position;
            AVCaptureDevice *newCamera = nil;
            AVCaptureDeviceInput *newInput = nil;
            
            if (position == AVCaptureDevicePositionFront)
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            else
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
            
            
            [self.session beginConfiguration];
            
            [self.session removeInput:input];
            [self.session addInput:newInput];
            
            [self.session commitConfiguration];
            break;
        }
    }
}


- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position )
            return device;
    return nil;
}
#pragma mark ------------------------ 切换前后镜头 ------------------------

-(void)openPhoto{
    NSLog(@"打开相册");
    PHFetchOptions * fetchOptions = [[PHFetchOptions alloc] init];
    
    PHFetchResult * fetchResult =[PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeUnknown options:fetchOptions];
    PHFetchOptions *option = [[PHFetchOptions alloc]init];
    option.includeAssetSourceTypes = PHAssetSourceTypeUserLibrary;
    fetchResult = [PHAsset fetchAssetsWithOptions:option];
    if ([fetchResult countOfAssetsWithMediaType:PHAssetMediaTypeImage]>0) {
        
        _fetchResult =fetchResult;
        
    }
    
    for (PHAsset *asset in _fetchResult) {
        [self.assetArray addObject:asset];
    }
    
    GFShowPhotoController *photo = [[GFShowPhotoController alloc]init];
    photo.assetArray = self.assetArray;
    [self.navigationController pushViewController:photo animated:YES];
}




- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    if (self.session) {
        
        [self.session startRunning];
    }
}


- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:YES];
    
    if (self.session) {
        
        [self.session stopRunning];
    }
}

#pragma mark private method
- (void)initAVCaptureSession{
    self.session = [[AVCaptureSession alloc] init];
    NSError *error;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //更改这个设置的时候必须先锁定设备，修改完后再解锁，否则崩溃
    [device lockForConfiguration:nil];
    //设置闪光灯为自动
    [device setFlashMode:AVCaptureFlashModeAuto];
    [device unlockForConfiguration];
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    //输出设置。AVVideoCodecJPEG   输出jpeg格式图片
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
    
    //初始化预览图层
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
    self.previewLayer.frame = CGRectMake(0, 0,kMainScreenWidth, kMainScreenHeight);
    self.view.layer.masksToBounds = YES;
    [self.view.layer addSublayer:self.previewLayer];


}

#pragma 创建手势
- (void)setUpGesture{
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    pinch.delegate = self;
    [self.view addGestureRecognizer:pinch];
}

#pragma mark gestureRecognizer delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ( [gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] ) {
        self.beginGestureScale = self.effectiveScale;
    }
    return YES;
}

- (AVCaptureVideoOrientation)avOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation
{
    AVCaptureVideoOrientation result = (AVCaptureVideoOrientation)deviceOrientation;
    if ( deviceOrientation == UIDeviceOrientationLandscapeLeft )
        result = AVCaptureVideoOrientationLandscapeRight;
    else if ( deviceOrientation == UIDeviceOrientationLandscapeRight )
        result = AVCaptureVideoOrientationLandscapeLeft;
    return result;
}

//缩放手势 用于调整焦距
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer{
    
    BOOL allTouchesAreOnThePreviewLayer = YES;
    NSUInteger numTouches = [recognizer numberOfTouches], i;
    for ( i = 0; i < numTouches; ++i ) {
        CGPoint location = [recognizer locationOfTouch:i inView:self.view];
        CGPoint convertedLocation = [self.previewLayer convertPoint:location fromLayer:self.previewLayer.superlayer];
        if ( ! [self.previewLayer containsPoint:convertedLocation] ) {
            allTouchesAreOnThePreviewLayer = NO;
            break;
        }
    }
    
    if ( allTouchesAreOnThePreviewLayer ) {
        self.effectiveScale = self.beginGestureScale * recognizer.scale;
        if (self.effectiveScale < 1.0){
            self.effectiveScale = 1.0;
        }
        
        NSLog(@"%f-------------->%f------------recognizerScale%f",self.effectiveScale,self.beginGestureScale,recognizer.scale);
        
        CGFloat maxScaleAndCropFactor = [[self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor];
        
        NSLog(@"%f",maxScaleAndCropFactor);
        if (self.effectiveScale > maxScaleAndCropFactor)
            self.effectiveScale = maxScaleAndCropFactor;
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:.025];
        [self.previewLayer setAffineTransform:CGAffineTransformMakeScale(self.effectiveScale, self.effectiveScale)];
        [CATransaction commit];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)Shooting:(id)sender {
    
    AVCaptureConnection *stillImageConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
    AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:curDeviceOrientation];
    
    [stillImageConnection setVideoOrientation:avcaptureOrientation];
    [stillImageConnection setVideoScaleAndCropFactor:self.effectiveScale];
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection
                                                       completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
                                                           
                                                           NSData *data = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                                                           
                                                           UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                                                           imageView.image = [[UIImage alloc] initWithData:data];
                                                           [self.view addSubview:imageView];
                                                           UIImageWriteToSavedPhotosAlbum(imageView.image, self, nil, nil);
                                                           
                                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                               
                                                               [imageView removeFromSuperview];
                                                               
                                                               [self.photoBtn setImage:imageView.image forState:UIControlStateNormal];
                                                               self.photoBtn.userInteractionEnabled = YES;
                                                           });
                                                       }];
}

- (void)switchCameraSegmentedControlClick {
    AVCaptureDevicePosition desiredPosition = AVCaptureDevicePositionFront;
    for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if ([d position] == desiredPosition) {
            [self.previewLayer.session beginConfiguration];
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:d error:nil];
            for (AVCaptureInput *oldInput in self.previewLayer.session.inputs) {
                [[self.previewLayer session] removeInput:oldInput];
            }
            [self.previewLayer.session addInput:input];
            [self.previewLayer.session commitConfiguration];
            break;
        }
    }
}

- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
