//
//  ScrollPageView.m
//  L001ScrollView
//
//  Created by machenglong on 16/4/11.
//  Copyright © 2016年 dayang. All rights reserved.
//

#import "ScrollPageView.h"
#import "CommonUtils.h"

#import <MediaPlayer/MediaPlayer.h>

#define BASE_TAG 51

@interface ScrollPageView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageCtrl;
@property (nonatomic, strong) NSMutableArray *pathArray;
@property (nonatomic,readwrite) CGAffineTransform initTransformBG;
@property (nonatomic,readwrite) CGSize sizeDevice;//设备大小

@end



@implementation ScrollPageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



#pragma mark PageView显示

- (void)showPageViewWithPathArray:(NSMutableArray *)pathArray
                         curIndex:(NSInteger)index {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    _pathArray = pathArray;
    
    [window addSubview:self.backgroundView];
    
    [self changePageView:index];
    
    _pageCtrl.currentPage = index;
    
    CGRect rc = _scrollView.bounds;
    rc = CGRectMake(0, 0, 200, 300);
    
    [_scrollView scrollRectToVisible:CGRectMake((rc.size.width)*index, 0, rc.size.width, rc.size.height) animated:NO];
    
    _initTransformBG = window.transform;
}

- (UIView*)findViewWithinWindowByTag:(NSInteger)tagID{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView* tmpView = nil;
    NSArray* views = [window subviews];
    for (UIView* view in views) {
        if (nil!=view && view.tag==tagID) {
            tmpView=view;
            break;
        }
    }
    return tmpView;
}

#pragma mark- 设备旋转处理
- (void)rotateWindowWithOrientation:(UIDeviceOrientation)deviceOrientation {
    CGFloat angle=0;//M开头的宏都是和数学（Math）相关的宏定义，M_PI_4表示四分之派
    
    switch (deviceOrientation) {
        case UIDeviceOrientationPortrait:
            angle = 0 ;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            angle = M_PI_2*2;
            break;
        case UIDeviceOrientationLandscapeLeft:
            angle = M_PI_2;
            break;
        case UIDeviceOrientationLandscapeRight:
            angle = M_PI_2*3;
            break;
        default:
            break;
    }
    
    UIView* view = _backgroundView;
    if (nil!=view) {
        CGAffineTransform trans = _initTransformBG;
        CGFloat angleDest = angle;
        
        //使用CGAffineTransformMakeRotation获得一个旋转角度形变
        //但是需要注意tranform的旋转不会自动在原来的角度上进行叠加，所以下面的方法旋转一次以后再点击按钮不会旋转了
        //_imageView.transform=CGAffineTransformMakeRotation(angle);
        //利用CGAffineTransformRotate在原来的基础上产生一个新的角度(当然也可以定义一个全局变量自己累加)
        view.transform = CGAffineTransformRotate(trans, angleDest);
        [view setNeedsDisplay];
        
    }
}

- (void)deviceOrientationDidChange {
    // Update capture orientation based on device orientation (if device orientation is one that
    // should affect capture, i.e. not face up, face down, or unknown)
    UIDeviceOrientation deviceOrientation = UIDevice.currentDevice.orientation;
    
    if (deviceOrientation == UIDeviceOrientationFaceUp ||
        deviceOrientation == UIDeviceOrientationFaceDown) { //不处理平躺或向上的方向变换
        return;
    }
    
    
    [self rotateWindowWithOrientation:deviceOrientation];//旋转容器窗口
    
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGPoint center = window.center ;
    CGRect rc = [UIScreen mainScreen].bounds ;
    
//    CGRect rc2 = _backgroundView.frame;
//    
//    CGFloat sx = (rc.size.width)/(rc2.size.width);
//    CGFloat sy = (rc.size.height)/(rc2.size.height);
//    CGAffineTransform trans = _backgroundView.transform;//_initTransformBG;
//    _backgroundView.transform = CGAffineTransformScale(trans, sy, sx);
//    [_backgroundView setNeedsDisplay];
    
//    if ( UIDeviceOrientationIsPortrait( deviceOrientation )) {//竖屏
        if (nil!=_backgroundView) {
//            _backgroundView.center = center;
//            _backgroundView.frame  = rc;
//            _backgroundView.bounds = rc;
//            [_backgroundView setNeedsDisplay];
            
            //center = _backgroundView.center;
            //rc     = _backgroundView.frame ;
        }
    
        [self updateViewWithinRect:rc atCenter:center];
//    }
//    
//    if (UIDeviceOrientationIsLandscape( deviceOrientation )) {//横向
//        if (nil!=_backgroundView) {
//            _backgroundView.center = center;			
//            _backgroundView.frame  = rc;
//            _backgroundView.bounds = rc;
//            [_backgroundView setNeedsDisplay];
//        }
//        [self updateViewWithinRect:rc atCenter:center];
//    }
    
    NSUInteger curpage = self.pageCtrl.currentPage;
    //[self changePageView:curpage];
    
}

- (void)updateViewWithinRect:(CGRect)rc atCenter:(CGPoint)center {
    NSString* s1 = [NSString stringWithFormat:@"\nInput-rc:%@,center:%@", NSStringFromCGRect(rc), NSStringFromCGPoint(center) ];
    
    if (nil!=_backgroundView) {
        CGRect rc1 = _backgroundView.frame;
        rc1.size.width = rc.size.width;
        rc1.size.height = rc.size.height;
        [_backgroundView setCenter:center];
        //[_backgroundView setBounds:CGRectMake(0, 0, rc.size.width, rc.size.height)];
        [_backgroundView setFrame:rc];
        [_backgroundView setNeedsDisplay];
        
        NSString* s2 = [NSString stringWithFormat:@"View1-bounds:%@, frame:%@, center:%@",
                        NSStringFromCGRect(_backgroundView.bounds),
                        NSStringFromCGRect(_backgroundView.frame),
                        NSStringFromCGPoint(_backgroundView.center)];
        
        if (nil!=_scrollView) {
            CGRect rc2 = _scrollView.bounds;
            //rc = CGRectMake(0, 0, 200, 300);
            center = _backgroundView.center;
            
            if ( UIDeviceOrientationIsPortrait( UIDevice.currentDevice.orientation )) {//竖屏
                center = _backgroundView.center;
                rc2 = _backgroundView.frame ;
                rc2 = CGRectMake(0, 0, 200, 300);
                rc2 = CGRectMake(0, 0, _backgroundView.frame.size.width-6, _backgroundView.frame.size.height-6);
                
            }
            
            if (UIDeviceOrientationIsLandscape( UIDevice.currentDevice.orientation )) {//横向
                center = CGPointMake(_backgroundView.center.y, _backgroundView.center.x);
                rc2 = _backgroundView.frame ;
                rc2 = CGRectMake(0, 0, 300, 200);
                rc2 = CGRectMake(0, 0, _backgroundView.frame.size.height-6, _backgroundView.frame.size.width-6);
            }
            
            
            
            [_scrollView setFrame:rc2];
            [_scrollView setCenter:center];
            //[_scrollView setBounds:rc];
            
            //rc = _scrollView.frame ;
            //_scrollView.contentOffset = CGPointMake(rc1.origin.x, rc1.origin.y);
            //_scrollView.contentSize = CGSizeMake((rc.size.width) * (_pathArray.count), rc.size.height);
            //_scrollView.contentSize = CGSizeMake((rc.size.width)*(_pathArray.count), rc.size.height);
            _scrollView.contentSize = CGSizeMake((rc2.size.width)*(_pathArray.count), rc2.size.height);
            [_scrollView setNeedsDisplay];
            
            NSString* s3 = [NSString stringWithFormat:@"View2-bounds:%@, frame:%@, center:%@",
                            NSStringFromCGRect(_scrollView.bounds),
                            NSStringFromCGRect(_scrollView.frame),
                            NSStringFromCGPoint(_scrollView.center)];
            
            if (nil!=_pageCtrl) {
                
                NSInteger page = 0 ;
                for (page=0; page<[_pathArray count]; ++page) {
                    NSInteger tag = BASE_TAG + page;
                    UIImageView *pageView = (UIImageView*)[_scrollView viewWithTag:tag];
                    
                    if (pageView != nil){
                        CGFloat pageWidth = CGRectGetWidth(rc2);
                        CGFloat pageHeight = CGRectGetHeight(rc2);
                        CGRect frame = CGRectMake(pageWidth * page, 0, pageWidth, pageHeight);
                        pageView.frame = frame ;
                    }
                }
                
                center.y = rc2.size.height - _pageCtrl.frame.size.height ;
                [_pageCtrl setCenter:center];
                
                [_pageCtrl setNeedsDisplay];
                [_scrollView setNeedsDisplay];
                [_backgroundView setNeedsDisplay];
                
                NSInteger pageCurrent = _pageCtrl.currentPage ;
                
                rc = _scrollView.frame;
                [_scrollView scrollRectToVisible:CGRectMake((rc.size.width)*pageCurrent, 0, rc.size.width, rc.size.height) animated:NO];
                
                
                NSString* s4 = [NSString stringWithFormat:@"View3-bounds:%@, frame:%@, center:%@",
                                NSStringFromCGRect(_pageCtrl.bounds),
                                NSStringFromCGRect(_pageCtrl.frame),
                                NSStringFromCGPoint(_pageCtrl.center)];
                
            
                NSLog(@"\n%@\n%@\n%@\n%@",s1,s2,s3,s4);
            }
            
        }
        [self setNeedsLayout];
    }
}


#pragma mark- PageView显示

- (UIView *)backgroundView {
    if (_backgroundView == nil) {
        CGRect rc = [UIScreen mainScreen].bounds ;
        //center = CGPointMake(100, 150);
        rc = CGRectMake(0, 0, 200, 300);
        
        _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, rc.size.width, rc.size.height)];
        _backgroundView.backgroundColor = [UIColor blackColor];
        _backgroundView.layer.borderWidth = 1;
        _backgroundView.layer.borderColor = [[UIColor blueColor] CGColor];
        _backgroundView.tag = 102;
    }
    
    [_backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                 action:@selector(hidePageView:)]];
    
    [_backgroundView addSubview:self.scrollView];
    [_backgroundView addSubview:self.pageCtrl];
    
    return _backgroundView;
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        //center = CGPointMake(100, 150);
        CGRect rc1 = CGRectMake(0, 0, 200, 300);
        rc1 = _backgroundView.bounds;
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, rc1.size.width, rc1.size.height)];
        
        CGRect rc2=_scrollView.bounds;
        _scrollView.contentSize = CGSizeMake((rc2.size.width) * (_pathArray.count), rc1.size.height);
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.layer.borderWidth = 1;
        _scrollView.layer.borderColor = [[UIColor redColor] CGColor];
    }
    return _scrollView;
}

- (UIPageControl *)pageCtrl {
    if (_pageCtrl == nil) {
        CGRect rc1 = CGRectMake(0, 0, 200, 300);
        rc1 = _backgroundView.bounds;
        
        _pageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, rc1.size.height - 25, rc1.size.width, 25)];
        _pageCtrl.backgroundColor = [UIColor clearColor];
        _pageCtrl.pageIndicatorTintColor = [UIColor grayColor];
        _pageCtrl.hidesForSinglePage = YES;
        _pageCtrl.numberOfPages = _pathArray.count;
    }
    return _pageCtrl;
}

// 切换PageView时，需要判断加载左右的Page
- (void)changePageView:(NSInteger)index {
    // 左侧ImageView
    if (index >= 1)
        [self loadPageView:(index - 1)];
    
    // 当前ImageView
    [self loadPageView:index];
    
    // 右侧ImageView
    if (index < _pathArray.count - 1)
        [self loadPageView:(index + 1)];
}

#pragma mark PageView隐藏

- (void)hidePageView:(UITapGestureRecognizer*)tapGesture
{
    [_backgroundView removeGestureRecognizer:tapGesture];
    
    for (UIView *subview in _scrollView.subviews) {
        [subview removeFromSuperview];
    }
    
    [_scrollView removeFromSuperview];
    [_pageCtrl removeFromSuperview];
    [_backgroundView removeFromSuperview];
    
    _scrollView = nil;
    _pageCtrl = nil;
    _backgroundView = nil;
}

#pragma mark 加载PageView

- (BOOL)resizeScrollViewPage:(NSInteger)page{
    if (!_scrollView)
        return NO;
    
    if (_pathArray.count <= 0)
        return NO;
    
    NSInteger tag = BASE_TAG + page;
    
    UIImageView *pageView = (UIImageView*)[_scrollView viewWithTag:tag];
    
    if (pageView != nil){
        //pageView.frame = [self imageViewFrame:page]; //每次都重读区域，防止设备旋转后区域不正确。
        
        
        CGRect rc = _scrollView.frame ;
        //rc = CGRectMake(0, 0, 200, 300);
        CGFloat pageWidth = CGRectGetWidth(rc);
        CGFloat pageHeight = CGRectGetHeight(rc);
        CGRect frame = CGRectMake(pageWidth * page, 0, pageWidth, pageHeight);
        pageView.frame = frame;
        
        return YES;
    }
    else{
        return NO ;
    }
}

- (void)loadPageView:(NSInteger)page {
    NSLog(@"loadPageView, page: %ld", (long)page);
    
    if (!_scrollView)
        return;
    
    if (_pathArray.count <= 0)
        return;
    
    NSInteger tag = 51 + page;
    
    UIImageView *pageView = (UIImageView*)[_scrollView viewWithTag:tag];
    if (pageView != nil)
        return;
    
    NSString *mediaPath = [_pathArray objectAtIndex:page];
    // local image
    UIImage *image  = [CommonUtils getLocalImage:mediaPath];
    //[_scrollView addSubview:[self imageView:page image:image]];
    
    CGRect frame = _scrollView.frame;
    if(image != nil) {
        frame = [self imageViewFrame:page withImageSize:image.size];
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.contentMode = UIViewContentModeScaleAspectFit; // UIImageView适应图片尺寸
    [imageView setImage:image];
    imageView.tag = BASE_TAG + page;
    
    [_scrollView addSubview:imageView];
}

- (CGRect)imageViewFrame:(NSInteger)index withImageSize:(CGSize)imageSize {
    CGRect rc = _scrollView.frame ;
    //rc = CGRectMake(0, 0, 200, 300);
    CGFloat showImgWidth = imageSize.width;
    CGFloat showImgHeight = imageSize.height;
    CGFloat pageWidth = CGRectGetWidth(rc);
    CGFloat pageHeight = CGRectGetHeight(rc);
    
    CGRect frame;
    if ((showImgWidth / showImgHeight) > (pageWidth / pageHeight)) {
        showImgWidth = pageWidth;
        showImgHeight = showImgWidth * imageSize.height / imageSize.width;
        
        frame = CGRectMake(pageWidth * index, (pageHeight - showImgHeight)/2, showImgWidth, showImgHeight);
    }
    else
    {
        showImgHeight = pageHeight;
        showImgWidth = showImgHeight * imageSize.width / imageSize.height;
        
        frame = CGRectMake(pageWidth * index + (pageWidth - showImgWidth)/2, 0, showImgWidth, showImgHeight);
    }
    return frame;
}


#pragma mark UIScrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _scrollView) {
        CGRect rc = _scrollView.frame ;
        //rc = CGRectMake(0, 0, 200, 300);
        
        CGFloat pageWidth = CGRectGetWidth(rc);
        CGFloat pageLeft  = fabs(scrollView.contentOffset.x) ;
        NSInteger curpage = pageLeft / (pageWidth-0.1);//0.1防止浮点数精度造成误差
        
        NSLog(@"PageIndex:%ld, Left:%f, Width:%f",curpage,pageLeft,pageWidth);
        
        NSLog(@"scrollViewDidEndDecelerating, Current Page: %ld", (long)curpage);
        _pageCtrl.currentPage = curpage;
        NSString* s3 = [NSString stringWithFormat:@"UIScrollView-bounds:%@, frame:%@, center:%@",
                        NSStringFromCGRect(_scrollView.bounds),
                        NSStringFromCGRect(_scrollView.frame),
                        NSStringFromCGPoint(_scrollView.center)];
        NSLog(s3);
        
        [self changePageView:curpage];
    }
}

@end
