//
//  ScrollPageViewController.h
//  L002XibScrollView
//
//  Created by machenglong on 16/4/12.
//  Copyright © 2016年 dayang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollPageViewController : UIViewController

- (void)showPageViewWithPathArray:(NSMutableArray *)pathArray
                         curIndex:(NSInteger)index
                       withInRect:(CGRect)rect;

@end
