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
    //[self addSubview:self.backgroundView];
    
    [self changePageView:index];
    
    _pageCtrl.currentPage = index;
    [_scrollView scrollRectToVisible:CGRectMake((_scrollView.bounds.size.width)*index,
                                                0,
                                                _scrollView.bounds.size.width,
                                                _scrollView.bounds.size.height)
                            animated:NO];
    
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
        view.transform = CGAffineTransformRotate(trans, angleDest);
        [view setNeedsDisplay];
        
    }
    
//        if (nil!=_backgroundView) {
//            //使用CGAffineTransformMakeRotation获得一个旋转角度形变
//            //但是需要注意tranform的旋转不会自动在原来的角度上进行叠加，所以下面的方法旋转一次以后再点击按钮不会旋转了
//            //_imageView.transform=CGAffineTransformMakeRotation(angle);
//            //利用CGAffineTransformRotate在原来的基础上产生一个新的角度(当然也可以定义一个全局变量自己累加)
//            _backgroundView.transform=CGAffineTransformRotate(_initTransformBG, angle);
//        }
//    
//        if (nil!=_scrollView) {
//            //_scrollView.transform=CGAffineTransformRotate(_initTransformSC, angle);
//        }
//    
//        if (nil!=_pageCtrl) {
//            //_pageCtrl.transform=CGAffineTransformRotate(_initTransformPG, angle);
//        }
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
    
//    center = CGPointMake(100, 150);
//    rc = CGRectMake(0, 0, 200, 300);

//    if (nil!=_backgroundView) {
//        _backgroundView.center = center;
//        _backgroundView.frame  = rc;
//        _backgroundView.bounds = rc;
//        [_backgroundView setNeedsDisplay];
//        
//        
//        center = _backgroundView.center;
//        rc     = _backgroundView.frame;
//    }
//    
    
    if ( UIDeviceOrientationIsPortrait( deviceOrientation )) {//竖屏
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        CGPoint center = window.center ;
        CGRect rc = [UIScreen mainScreen].bounds ;
        
        
//        if (center.x - center.y > 0.0) { //保证竖屏时的坐标x <= y
//            center = CGPointMake(center.y, center.x);
//        }
//        
//        if (rc.size.width - rc.size.height > 0.0) { //保证竖屏时的长宽width <= height
//            rc = CGRectMake(0, 0, rc.size.height, rc.size.width);
//        }
//        
        if (nil!=_backgroundView) {
            _backgroundView.center = center;
            _backgroundView.frame  = rc;
            _backgroundView.bounds = rc;
            [_backgroundView setNeedsDisplay];
        }
        
        [self updateViewWithinRect:rc atCenter:center];
    }
    
    if (UIDeviceOrientationIsLandscape( deviceOrientation )) {//横向
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        CGPoint center = window.center ;
        CGRect rc = [UIScreen mainScreen].bounds ;
        
        
//        if (center.x - center.y < 0.0) { //保证横向时的坐标x >= y
//            center = CGPointMake(center.y, center.x);
//        }
//        
//        if (rc.size.width - rc.size.height < 0.0) { //保证横向时的长宽width >= height
//            rc = CGRectMake(0, 0, rc.size.height, rc.size.width);
//        }
//        
        if (nil!=_backgroundView) {
            _backgroundView.center = center;			
            _backgroundView.frame  = rc;
            _backgroundView.bounds = rc;
            [_backgroundView setNeedsDisplay];
        }
        [self updateViewWithinRect:rc atCenter:center];
    }
}

- (void)layoutSubviews{
    NSLog(@"called layoutSubviews");
    [super layoutSubviews];
    
}

- (void)setNeedsDisplay{
    NSLog(@"called setNeedsLayout");

    [super setNeedsLayout];
}

- (void)updateViewWithinRect:(CGRect)rc atCenter:(CGPoint)center {
    if (nil!=_backgroundView) {
        [_backgroundView setCenter:center];
        [_backgroundView setBounds:CGRectMake(0, 0, rc.size.width, rc.size.height)];
        [_backgroundView setFrame:rc];
        [_backgroundView setNeedsDisplay];
        
        if (nil!=_scrollView) {
            [_scrollView setCenter:center];
            //[_scrollView setBounds:rc];
            [_scrollView setFrame:rc];
            //_scrollView.contentOffset = CGPointMake(0, 0);
            //_scrollView.contentSize = CGSizeMake((rc.size.width) * (_pathArray.count), rc.size.height);
            _scrollView.contentSize = CGSizeMake((_scrollView.frame.size.width)*(_pathArray.count), _scrollView.frame.size.height);
            [_scrollView setNeedsDisplay];
            
            if (nil!=_pageCtrl) {
                
                NSInteger page = 0 ;
                for (page=0; page<[_pathArray count]; ++page) {
                    //[self resizeScrollViewPage:index]; //重设每个子页的大小
                    
                    NSInteger tag = BASE_TAG + page;
                    
                    UIImageView *pageView = (UIImageView*)[_scrollView viewWithTag:tag];
                    
                    if (pageView != nil){
                        //pageView.frame = [self imageViewFrame:page]; //每次都重读区域，防止设备旋转后区域不正确。
                        
                        //CGRect rc = _scrollView.frame ;
                        CGFloat pageWidth = CGRectGetWidth(rc);
                        CGFloat pageHeight = CGRectGetHeight(rc);
                        CGRect frame = CGRectMake(pageWidth * page, 0, pageWidth, pageHeight);
                        pageView.frame = frame ;
                    }
                }
                
                center.y = rc.size.height - _pageCtrl.bounds.size.height ;
                [_pageCtrl setCenter:center];
                
                [_pageCtrl setNeedsDisplay];
                [_scrollView setNeedsDisplay];
                //[_scrollView setNeedsLayout];
                [_backgroundView setNeedsDisplay];
                
                NSInteger pageCurrent = _pageCtrl.currentPage ;
                [_scrollView scrollRectToVisible:CGRectMake((rc.size.width)*pageCurrent, 0, rc.size.width, rc.size.height) animated:NO];
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
        //rc = CGRectMake(0, 0, 200, 300);
        
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
        //rc = CGRectMake(0, 0, 200, 300);
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _backgroundView.bounds.size.width, _backgroundView.bounds.size.height)];
        _scrollView.contentSize = CGSizeMake((_scrollView.bounds.size.width) * (_pathArray.count), _backgroundView.bounds.size.height);
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
        _pageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _backgroundView.bounds.size.height - 25, _backgroundView.bounds.size.width, 25)];
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
        pageView.frame = [self imageViewFrame:page]; //每次都重读区域，防止设备旋转后区域不正确。
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
    [_scrollView addSubview:[self imageView:page image:image]];
}

- (UIImageView *)imageView:(NSInteger)index image:(UIImage *)image {
    CGRect frame = _scrollView.frame;
    if(image != nil) {
        frame = [self imageViewFrame:index withImageSize:image.size];
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.contentMode = UIViewContentModeScaleAspectFit; // UIImageView适应图片尺寸
    [imageView setImage:image];
    imageView.tag = BASE_TAG + index;
    
    return imageView;
}

- (CGRect)imageViewFrame:(NSInteger)index {
    CGRect rc = _scrollView.frame ;
    CGFloat pageWidth = CGRectGetWidth(rc);
    CGFloat pageHeight = CGRectGetHeight(rc);
    CGRect frame = CGRectMake(pageWidth * index, 0, pageWidth, pageHeight);
    return frame;
}


- (CGRect)imageViewFrame:(NSInteger)index withImageSize:(CGSize)imageSize {
    
    CGFloat showImgWidth = imageSize.width;
    CGFloat showImgHeight = imageSize.height;
    CGFloat pageWidth = CGRectGetWidth(_scrollView.frame);
    CGFloat pageHeight = CGRectGetHeight(_scrollView.frame);
    
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
        CGFloat pageWidth = CGRectGetWidth(scrollView.frame);
        NSInteger curpage = fabs(scrollView.contentOffset.x) / pageWidth;
        
        NSLog(@"scrollViewDidEndDecelerating, Current Page: %ld", (long)curpage);
        _pageCtrl.currentPage = curpage;
        
        [self changePageView:curpage];
    }
}

@end
