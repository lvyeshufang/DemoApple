//
//  ViewController.m
//  L001ScrollView
//
//  Created by machenglong on 16/4/11.
//  Copyright © 2016年 dayang. All rights reserved.
//

#import "ViewController.h"
#import "ScrollPageView.h"

@interface ViewController ()

//@property(nonatomic,strong) UIButton* btnLoad ;
@property(nonatomic,strong) ScrollPageView* scrollPageView;
@property(nonatomic,strong) NSMutableArray *imageArr;

@end

@implementation ViewController

- (void)initButtonWithFrame:(CGRect)frame withTitle:(NSString*)title withEvent:(SEL)eventClicked {
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton* btnLoad = nil ;
    if (nil==btnLoad) {
        btnLoad = [UIButton buttonWithType:UIButtonTypeSystem];//[[UIButton alloc] init];
        btnLoad.frame = frame;
        btnLoad.backgroundColor = [UIColor blueColor];
        [btnLoad setTitle:title forState:UIControlStateNormal];
        btnLoad.titleLabel.font = [UIFont fontWithName:@"Arials" size:17.0];
        btnLoad.titleLabel.textAlignment = NSTextAlignmentCenter; // 字体居中
        [btnLoad addTarget:self action:eventClicked forControlEvents:UIControlEventTouchUpInside];
        [btnLoad.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
        
        [self.view addSubview:btnLoad];
    }
}

- (void)loadViewTemplate {
    UIView* view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 30, 100, 150)];
    view1.backgroundColor = [UIColor grayColor];
    view1.tag = 101;
    
    UILabel* lab1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80,40)];
    lab1.text = @"你好！";
    [view1 addSubview:lab1];
    
    UIButton* btnExit = [UIButton buttonWithType:UIButtonTypeSystem];//[[UIButton alloc] init];
    btnExit.frame = CGRectMake(0, 50, 80, 40);
    btnExit.backgroundColor = [UIColor blueColor];
    [btnExit setTitle:@"退出" forState:UIControlStateNormal];
    [btnExit addTarget:self action:@selector(btnExitClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btnExit.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    
    [view1 addSubview:btnExit];
    
    [self.view addSubview:view1];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initButtonWithFrame:CGRectMake(200, 50, 80, 40) withTitle:@"普通视图" withEvent:@selector(btnLoadClicked:)];
    [self initButtonWithFrame:CGRectMake(200, 100, 80, 40) withTitle:@"全屏" withEvent:@selector(btnFullScreenClicked:)];
    [self initButtonWithFrame:CGRectMake(200, 150, 80, 40) withTitle:@"移动" withEvent:@selector(btnMoveClicked:)];
    [self initButtonWithFrame:CGRectMake(200, 200, 80, 40) withTitle:@"缩放" withEvent:@selector(btnZoomClicked:)];
    [self initButtonWithFrame:CGRectMake(200, 250, 80, 40) withTitle:@"旋转" withEvent:@selector(btnRoateClicked:)];
    
    [self initButtonWithFrame:CGRectMake(300, 50, 80, 40) withTitle:@"滚动窗口" withEvent:@selector(btnLoadScrollPageClicked:)];
    [self initButtonWithFrame:CGRectMake(300, 100, 80, 40) withTitle:@"全屏" withEvent:@selector(btnSpageFullScreenClicked:)];
    [self initButtonWithFrame:CGRectMake(300, 150, 80, 40) withTitle:@"移动" withEvent:@selector(btnSpageMoveClicked:)];
    [self initButtonWithFrame:CGRectMake(300, 200, 80, 40) withTitle:@"缩放" withEvent:@selector(btnSpageZoomClicked:)];
    [self initButtonWithFrame:CGRectMake(300, 250, 80, 40) withTitle:@"旋转" withEvent:@selector(btnSpageRoateClicked:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnExitClicked:(id)sender{
    UIView* view = [self findViewByTag:101];
    if (nil!=view) {
        [view removeFromSuperview];
    }
}

- (void)btnLoadClicked:(id)sender{
    [self loadViewTemplate];
}


- (UIView*)findViewByTag:(NSInteger)tagID{
    UIView* tmpView = nil;
    NSArray* views = [self.view subviews];
    for (UIView* view in views) {
        if (nil!=view && view.tag==tagID) {
            tmpView=view;
            break;
        }
    }
    return tmpView;
}

- (void)btnFullScreenClicked:(id)sender{
    UIView* view = [self findViewByTag:101];
    if (nil!=view) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        CGPoint center = window.center ;
        //CGRect rc = [UIScreen mainScreen].bounds ;
        CGRect rc = [[UIScreen mainScreen] applicationFrame];
        
        view.center = center;
        view.frame  = rc;
    }
}

- (void)btnMoveClicked:(id)sender{
    UIView* view = [self findViewByTag:101];
    if (nil!=view) {
        CGPoint center =view.center;
        center.x += 5 ;
        center.y += 10 ;
        view.center = center;
    }
}

- (void)btnZoomClicked:(id)sender{
    UIView* view = [self findViewByTag:101];
    if (nil!=view) {
        CGRect frame = view.frame;
        frame.size.width *=1.1;
        frame.size.height *=1.1;
        view.frame = frame;
    }
}

- (void)btnRoateClicked:(id)sender{
    UIView* view = [self findViewByTag:101];
    if (nil!=view) {
        CGAffineTransform trans = view.transform;
        CGFloat angle = M_2_PI/36.0;
        view.transform = CGAffineTransformRotate(trans, angle);
    }
}

- (void)btnLoadScrollPageClicked:(id)sender{
    UIView* view = [self findViewWithinWindowByTag:102];
    if (nil==view) {
        _scrollPageView=nil;
        [_imageArr removeAllObjects];
    }
    
    if (nil==_scrollPageView) {
        _scrollPageView = [[ScrollPageView alloc] init];
        //dispatch_async(dispatch_get_main_queue(), ^{
            if (_imageArr == nil) {
                _imageArr = [[NSMutableArray alloc] initWithCapacity:0];
            }
        
            [_imageArr addObject:[[NSBundle mainBundle] pathForResource:@"1" ofType:@"jpg"]];
            [_imageArr addObject:[[NSBundle mainBundle] pathForResource:@"2" ofType:@"jpg"]];
            [_imageArr addObject:[[NSBundle mainBundle] pathForResource:@"3" ofType:@"jpg"]];
            
            [_scrollPageView showPageViewWithPathArray:_imageArr curIndex:0];
        //});
        
    }
    
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

- (void)btnSpageFullScreenClicked:(id)sender{
    UIView* view = [self findViewWithinWindowByTag:102];
    if (nil!=view) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        CGPoint center = window.center ;
        //CGRect rc = [UIScreen mainScreen].bounds ;
        CGRect rc = [[UIScreen mainScreen] applicationFrame];
        
        view.center = center;
        view.frame  = rc;
    }
}

- (void)btnSpageMoveClicked:(id)sender{
    UIView* view = [self findViewWithinWindowByTag:102];
    if (nil!=view) {
        CGPoint center =view.center;
        center.x += 5 ;
        center.y += 10 ;
        view.center = center;
        [view setNeedsDisplay];
    }
}

- (void)btnSpageZoomClicked:(id)sender{
    UIView* view = [self findViewWithinWindowByTag:102];
    if (nil!=view) {
//        CGRect frame = view.frame;
//        frame.size.width *=1.1;
//        frame.size.height *=1.1;
//        view.frame = frame;
//        //view.bounds = frame ;
//        
//        //[view setNeedsDisplay];
//        //[view setNeedsLayout];
//        
//        ScrollPageView* pageView = view;
//        [pageView setNeedsDisplay];
//        [pageView setNeedsLayout];
        CGAffineTransform trans = view.transform;
        view.transform = CGAffineTransformScale(trans, 1.1, 1.1);
        [view setNeedsDisplay];
    }
}

- (void)btnSpageRoateClicked:(id)sender{
    UIView* view = [self findViewWithinWindowByTag:102];
    if (nil!=view) {
        CGAffineTransform trans = view.transform;
        CGFloat angle = M_PI_2;
        view.transform = CGAffineTransformRotate(trans, angle);
        [view setNeedsDisplay];
    }
}

@end
