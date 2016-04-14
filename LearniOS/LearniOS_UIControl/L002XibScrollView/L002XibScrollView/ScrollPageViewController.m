//
//  ScrollPageViewController.m
//  L002XibScrollView
//
//  Created by machenglong on 16/4/12.
//  Copyright © 2016年 dayang. All rights reserved.
//

#import "ScrollPageViewController.h"
#import "CommonUtils.h"

@interface ScrollPageViewController ()  <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *pageView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageIndex;
@property (nonatomic, strong) NSMutableArray *pathArray;
@property (nonatomic,readwrite) CGAffineTransform initTransformBG;

@end

@implementation ScrollPageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    _pageIndex.backgroundColor = [UIColor clearColor];
    _pageIndex.pageIndicatorTintColor = [UIColor grayColor];
    _pageIndex.hidesForSinglePage = YES;
    _pageIndex.numberOfPages = _pathArray.count;
    _pageIndex.currentPage = 0;
    //[_pageIndex bringSubviewToFront:self.view];
    //[self.view bringSubviewToFront:_pageIndex];
    
    _pageView.backgroundColor = [UIColor blackColor];
    _pageView.pagingEnabled = YES;
    _pageView.showsHorizontalScrollIndicator = YES;
    _pageView.showsVerticalScrollIndicator = NO;
    _pageView.delegate = self;
    
    self.view.backgroundColor = [UIColor greenColor];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidePageView:)]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self viewAutoResize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark- 设备旋转处理
- (void)deviceOrientationDidChange {
    // Update capture orientation based on device orientation (if device orientation is one that
    // should affect capture, i.e. not face up, face down, or unknown)
    UIDeviceOrientation deviceOrientation = UIDevice.currentDevice.orientation;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGPoint center = window.center ;
    CGRect rc = [UIScreen mainScreen].bounds ;
    [self resetValidateRect:&rc withCenter:&center];
    
    [self viewAutoResize];
    
    NSUInteger curpage = _pageIndex.currentPage;
    [self changePageView:curpage];
    rc = _pageView.frame;
    [_pageView scrollRectToVisible:CGRectMake((rc.size.width)*curpage, 0, rc.size.width, rc.size.height) animated:NO];
    
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
    
    UIView* view =  self.view;//[self findViewWithinWindowByTag:102];
    if (nil!=view) {
        CGAffineTransform trans = _initTransformBG;// view.transform;
        CGFloat angleDest = angle;// M_PI_2;
        view.transform = CGAffineTransformRotate(trans, angleDest);
        [view setNeedsDisplay];
    }
    
    
}

- (void)showPageViewWithPathArray:(NSMutableArray *)pathArray
                         curIndex:(NSInteger)index
                       withInRect:(CGRect)rect{
    if (_pathArray == nil) {
        _pathArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    else{
        [_pathArray removeAllObjects];
    }
    _pathArray = pathArray;
    
    _pageIndex.numberOfPages = _pathArray.count;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGPoint center = window.center ;
    CGRect rc = [UIScreen mainScreen].bounds ;
    
    [self resetValidateRect:&rc withCenter:&center];
    
    rc = rect;
    
    self.view.frame  = rc;
    self.view.bounds = rc ;
    self.view.center = center;
    [self.view setNeedsDisplay];
    
    
    rc = _pageView.frame;
    _pageView.contentSize = CGSizeMake((rc.size.width) * (_pathArray.count), rc.size.height);
    
    [self changePageView:index];
    [self viewAutoResize];
    
    rc = _pageView.frame;
    [_pageView scrollRectToVisible:CGRectMake((rc.size.width)*index, 0, rc.size.width, rc.size.height) animated:NO];
    [_pageView setNeedsDisplay];
    
    _initTransformBG = window.transform;
    
}

- (void)resetValidateRect:(CGRect*)rc withCenter:(CGPoint*)center{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    *center = window.center ;
    *rc = [UIScreen mainScreen].bounds ;
    
    //*rc = CGRectMake(0, 0, 200, 300);
    //*center = CGPointMake(100, 150);
    
}

- (void)viewAutoResize{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGPoint center = window.center ;
    CGRect rc = [UIScreen mainScreen].bounds ;
    
    [self resetValidateRect:&rc withCenter:&center];
    
    self.view.frame  = rc;
    self.view.bounds = rc ;
    [self.view setNeedsDisplay];
    
    rc = self.view.frame;
    
    _pageView.center = center ;
    _pageView.frame = rc ;
    
    rc = _pageView.frame;
    _pageView.contentSize = CGSizeMake((rc.size.width) * (_pathArray.count), rc.size.height);
    
    [self.pageView setNeedsDisplay];
}

- (UIImageView *)imageView:(NSInteger)index image:(UIImage *)image {
    CGRect frame = _pageView.frame;
    if(image != nil) {
        frame = [self imageViewFrame:index withImageSize:image.size];
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.contentMode = UIViewContentModeScaleAspectFit; // UIImageView适应图片尺寸
    [imageView setImage:image];
    imageView.tag = 51 + index;
    
    return imageView;
}

- (CGRect)imageViewFrame:(NSInteger)index {
    CGRect rc = _pageView.frame ;
    CGFloat pageWidth = CGRectGetWidth(rc);
    CGFloat pageHeight = CGRectGetHeight(rc);
    CGRect frame = CGRectMake(pageWidth * index, 0, pageWidth, pageHeight);
    return frame;
}


- (CGRect)imageViewFrame:(NSInteger)index withImageSize:(CGSize)imageSize {
    
    CGFloat showImgWidth = imageSize.width;
    CGFloat showImgHeight = imageSize.height;
    CGFloat pageWidth = CGRectGetWidth(_pageView.frame);
    CGFloat pageHeight = CGRectGetHeight(_pageView.frame);
    
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
    if (scrollView == _pageView) {
        CGFloat pageWidth = CGRectGetWidth(scrollView.frame);
        NSInteger curpage = fabs(scrollView.contentOffset.x) / pageWidth;
        
        NSLog(@"scrollViewDidEndDecelerating, Current Page: %ld", (long)curpage);
        _pageIndex.currentPage = curpage;
        
        [self changePageView:curpage];
    }
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
    [self.view removeGestureRecognizer:tapGesture];
    
    for (UIView *subview in _pageView.subviews) {
        [subview removeFromSuperview];
    }
    
    [_pageView removeFromSuperview];
    [_pageIndex removeFromSuperview];
    
    _pageView = nil;
    _pageIndex = nil;
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark 加载PageView

- (BOOL)resizeScrollViewPage:(NSInteger)page{
    if (!_pageView)
        return NO;
    
    if (_pathArray.count <= 0)
        return NO;
    
    NSInteger tag = 51 + page;
    
    UIImageView *pageView = (UIImageView*)[_pageView viewWithTag:tag];
    
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
    
    if (!_pageView)
        return;
    
    if (_pathArray.count <= 0)
        return;
    
    NSInteger tag = 51 + page;
    
    UIImageView *pageView = (UIImageView*)[_pageView viewWithTag:tag];
    if (pageView != nil){
        [self resizeScrollViewPage:page];
        return;
    }
    
    NSString *mediaPath = [_pathArray objectAtIndex:page];

    UIImage *image  = [CommonUtils getLocalImage:mediaPath];
    [_pageView addSubview:[self imageView:page image:image]];
}


@end
