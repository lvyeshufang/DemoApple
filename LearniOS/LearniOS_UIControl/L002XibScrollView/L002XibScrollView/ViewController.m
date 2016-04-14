//
//  ViewController.m
//  L002XibScrollView
//
//  Created by machenglong on 16/4/12.
//  Copyright © 2016年 dayang. All rights reserved.
//

#import "ViewController.h"
#import "ScrollPageViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initButtonWithFrame:CGRectMake(200, 50, 80, 40) withTitle:@"普通视图" withEvent:@selector(btnLoadClicked:)];
    //[self initButtonWithFrame:CGRectMake(200, 100, 80, 40) withTitle:@"全屏" withEvent:@selector(btnFullScreenClicked:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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

- (void)btnExitClicked:(id)sender{
    UIView* view = [self findViewByTag:101];
    if (nil!=view) {
        [view removeFromSuperview];
    }
}

- (void)btnLoadClicked:(id)sender{
    //[self loadViewTemplate];
   
    NSMutableArray *images = nil;
    if (images == nil) {
        images = [[NSMutableArray alloc] initWithCapacity:0];
    }
    else{
        [images removeAllObjects];
    }

    [images addObject:[[NSBundle mainBundle] pathForResource:@"1" ofType:@"jpg"]];
    [images addObject:[[NSBundle mainBundle] pathForResource:@"2" ofType:@"jpg"]];
    [images addObject:[[NSBundle mainBundle] pathForResource:@"3" ofType:@"jpg"]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        ScrollPageViewController *vc = [[ScrollPageViewController alloc] init];
        CGRect rc = CGRectMake(0, 0, 200, 300);
        [vc showPageViewWithPathArray:images curIndex:0 withInRect:rc];
        [self presentViewController:vc animated:YES completion:nil];
    });

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

@end
