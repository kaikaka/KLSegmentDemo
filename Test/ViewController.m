//
//  ViewController.m
//  Test
//
//  Created by xiangkai yin on 15/12/29.
//  Copyright © 2015年 kuailao_2. All rights reserved.
//

#import "ViewController.h"
#import "KLSegmentControlView.h"

@interface ViewController ()<UIScrollViewDelegate> {
  KLSegmentControlView *_ssssssss;
	
	ViewColorRedius *_xxxxxx;
	int _mmX ;
}

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  KLSegmentControlView *v = [[KLSegmentControlView alloc] initWithFrame:CGRectMake(30, 100, CGRectGetWidth(self.view.bounds) - 60, 30)];
  
  v.titles = @[@"Hello", @"Apple"];
  v.duration = 0.3f;
  v.titlesHeightLightColor = [UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:1];
  v.isLine = YES;
  _ssssssss = v;

  [self.view addSubview:v];
	_mmX = (int)v.titles.count;
	
  UIScrollView *scorllView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 150, CGRectGetWidth(self.view.bounds), 200)];
  scorllView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds) *_mmX, 200);
  scorllView.pagingEnabled = YES;
  scorllView.delegate = self;
  scorllView.backgroundColor = [UIColor colorWithWhite:.4 alpha:0.6];
  [self.view addSubview:scorllView];
	
	[v setButtonOnClickBlock:^(NSInteger tag, NSString *title) {
		NSLog(@"index = %ld, title = %@", (long)tag, title);
		
		scorllView.contentOffset = CGPointMake(scorllView.bounds.size.width * tag, 0);
	}];
	
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  CGFloat fb = ABS(scrollView.contentOffset.x/_mmX * ((CGRectGetWidth(self.view.bounds) - 60) / CGRectGetWidth(self.view.bounds)));
  CGFloat mn = CGRectGetWidth(_ssssssss.bounds);
  if (fb >= mn) {
//    fb = mn - (fb - mn);
  }
//  NSLog(@"%f",fb);
  CGRect rect = _ssssssss.heightLightView.frame;
  rect.origin.x =  fb;
  _ssssssss.heightLightView.frame = rect;
	
  
  rect = _ssssssss.heightTopView.frame;
  rect.origin.x = - fb;
	
  _ssssssss.heightTopView.frame = rect;
	
  CGFloat x = fb / (mn / DEFAULT_CORNERREDIUS);
  CGFloat y = DEFAULT_CORNERREDIUS - x;

	int flo = floor((scrollView.contentOffset.x - scrollView.frame.size.width/2)/scrollView.frame.size.width)+1;
	
  _ssssssss.heightColoreView.progress = DEFAULT_CORNERREDIUS - y;
	_ssssssss.heightColoreView.page = flo;
	
	rect = _xxxxxx.frame;
	rect.origin.x = fb;
	_xxxxxx.frame = rect;
//	NSLog(@"%f,flo = %d",y,flo);
	_xxxxxx.progress = 5 - y;
	_xxxxxx.page = flo;
  
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	
}

@end
