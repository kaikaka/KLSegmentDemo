//
//  KLSegmentControlView.m
//  Test
//
//  Created by xiangkai yin on 15/12/29.
//  Copyright © 2015年 kuailao_2. All rights reserved.
//

#import "KLSegmentControlView.h"

#define DEFAULT_TITLES_FONT 20.0f
#define DEFAULT_DURATION 3.0f
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

@interface KLSegmentControlView()

@property (nonatomic, assign) CGFloat viewWidth;                    //组件的宽度
@property (nonatomic, assign) CGFloat viewHeight;                   //组件的高度
@property (nonatomic, assign) CGFloat labelWidth;                   //Label的宽度

@property (nonatomic, strong) NSMutableArray * labelMutableArray;
@property (nonatomic, strong) ButtonOnClickBlock buttonBlock;
@end

@implementation KLSegmentControlView

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    _viewWidth = frame.size.width;
    _viewHeight = frame.size.height;
    _duration = DEFAULT_DURATION;
    _isLine = NO;
  }
  return self;
}

- (void)setIsLine:(BOOL)isLine {
  _isLine = isLine;
  if (!isLine) {
    self.layer.borderWidth = 1.;
    self.layer.borderColor = [UIColor orangeColor].CGColor;
    self.layer.cornerRadius = DEFAULT_CORNERREDIUS;
  }
}

- (void)layoutSubviews{
	[super layoutSubviews];
	[self customeData];
	[self createBottomLabels];
	[self createTopLables];
	[self createTopButtons];
}

-(void) setButtonOnClickBlock: (ButtonOnClickBlock) block {
  if (block) {
    _buttonBlock = block;
  }
}

/**
 *  提供默认值
 */
- (void)customeData {
  if (_titles == nil) {
    _titles = @[@"Test0", @"Test2"];
  }
  
  if (_titlesCustomeColor == nil) {
    _titlesCustomeColor = [UIColor grayColor];
  }
  
  if (_titlesHeightLightColor == nil) {
    _titlesHeightLightColor = [UIColor orangeColor];
  }
  
  if (_backgroundHeightLightColor == nil) {
    _backgroundHeightLightColor = [UIColor clearColor];
  }
  
  if (_titlesFont == nil) {
    _titlesFont = [UIFont systemFontOfSize:DEFAULT_TITLES_FONT];
  }
  
  if (_labelMutableArray == nil) {
    _labelMutableArray = [[NSMutableArray alloc] initWithCapacity:_titles.count];
  }
  _labelWidth = _viewWidth / _titles.count;
  
}

/**
 *  计算当前高亮的Frame
 *
 *  @param index 当前点击按钮的Index
 *
 *  @return 返回当前点击按钮的Frame
 */
- (CGRect) countCurrentRectWithIndex: (NSInteger) index {
  return  CGRectMake(_labelWidth * index, 0, _labelWidth, _viewHeight);
}

/**
 *  根据索引创建Label
 *
 *  @param index     创建的第几个Index
 *  @param textColor Label字体颜色
 *
 *  @return 返回创建好的label
 */
- (UILabel *) createLabelWithTitlesIndex: (NSInteger) index
                               textColor: (UIColor *) textColor {
  CGRect currentLabelFrame = [self countCurrentRectWithIndex:index];
  UILabel *tempLabel = [[UILabel alloc] initWithFrame:currentLabelFrame];
  tempLabel.textColor = textColor;
  tempLabel.text = _titles[index];
  tempLabel.font = _titlesFont;
  tempLabel.minimumScaleFactor = 0.1f;
  
  if (_isLine == NO) {
    tempLabel.layer.borderWidth = .5;
    tempLabel.layer.borderColor = [UIColor orangeColor].CGColor;
    if (index == 0) {
      [self changeLayerCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft withView:tempLabel withRadius:DEFAULT_CORNERREDIUS];
    } else if (index == _titles.count -1 ){
      [self changeLayerCorners:UIRectCornerTopRight | UIRectCornerBottomRight withView:tempLabel withRadius:DEFAULT_CORNERREDIUS];
    }
  }
  
  tempLabel.textAlignment = NSTextAlignmentCenter;
  return tempLabel;
}

- (void)changeLayerCorners:(UIRectCorner)Corners withView:(UIView *)view withRadius:(CGFloat)radius {
  UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:Corners cornerRadii:CGSizeMake(radius, radius)];
  CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
  maskLayer.frame = view.bounds;
  maskLayer.path = maskPath.CGPath;
  view.layer.mask = maskLayer;
}

/**
 *  创建最底层的Label
 */
- (void) createBottomLabels {
  for (int i = 0; i < _titles.count; i ++) {
    UILabel *tempLabel = [self createLabelWithTitlesIndex:i textColor:_titlesCustomeColor];
    [self addSubview:tempLabel];
    [_labelMutableArray addObject:tempLabel];
  }
}

/**
 *  创建上一层高亮使用的Label
 */
- (void) createTopLables {
  CGRect heightLightViewFrame = CGRectMake(0, 0, _labelWidth, _viewHeight);
	if (_heightLightView == nil) {
		_heightLightView = [[UIView alloc] initWithFrame:heightLightViewFrame];
	}
	
  _heightLightView.clipsToBounds = YES;
	
	if (_heightColoreView == nil) {
		_heightColoreView = [[ViewColorRedius alloc] initWithFrame:heightLightViewFrame];
	}
	
	_heightColoreView.backgroundColor = [UIColor clearColor];
	_heightColoreView.countPage = _titles.count;
  
  if (!_isLine) {
    _heightColoreView.num = DEFAULT_CORNERREDIUS;
  }
	_heightColoreView.lightColor = _titlesHeightLightColor;
  _heightColoreView.isLine = _isLine;
  [_heightLightView addSubview:_heightColoreView];
	
  if (_heightTopView == nil) {
    _heightTopView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, _viewWidth, _viewHeight)];
    
    for (int i = 0; i < _titles.count; i ++) {
      UILabel *label = [self createLabelWithTitlesIndex:i textColor:_titlesHeightLightColor];
      [_heightTopView addSubview:label];
    }
		}
  [_heightLightView addSubview:_heightTopView];
  [self addSubview:_heightLightView];
}

/**
 *  创建按钮
 */
- (void) createTopButtons {
  for (int i = 0; i < _titles.count; i ++) {
    CGRect tempFrame = [self countCurrentRectWithIndex:i];
    UIButton *tempButton = [[UIButton alloc] initWithFrame:tempFrame];
    tempButton.tag = i;
    [tempButton addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:tempButton];
  }
}

/**
 *  点击按钮事件
 *
 *  @param sender 点击的相应的按钮
 */
- (void)tapButton:(UIButton *) sender {
	
  
  CGRect frame = [self countCurrentRectWithIndex:sender.tag];
  CGRect changeFrame = [self countCurrentRectWithIndex:-sender.tag];
	
  [UIView animateWithDuration:_duration animations:^{
    _heightLightView.frame = frame;
    _heightTopView.frame = changeFrame;
		
//		//必须最上面 先初始化page
//		_heightColoreView.page = (int)sender.tag;
//  if(sender.tag == 0) {
//		_heightColoreView.num = 5;
//		_heightColoreView.progress = 0;
//		
//		[_heightColoreView setNeedsDisplay];
//	} else if(sender.tag == _titles.count - 1) {
//		_heightColoreView.num = 0;
//		_heightColoreView.progress = 5;
//		[_heightColoreView setNeedsDisplay];
//	} else {
//		_heightColoreView.num = 0;
//		_heightColoreView.progress = 0;
//		[_heightColoreView setNeedsDisplay];
//	}
		
		
  } completion:^(BOOL finished) {
		if (finished) {
			if (_buttonBlock && sender.tag < _titles.count) {
				_buttonBlock(sender.tag, _titles[sender.tag]);
			}
		}
  }];
}

@end

@class ViewColorRedius;

@implementation ViewColorRedius
@synthesize progress;
static CGFloat p = 0;

- (void)setProgress:(CGFloat)pro {
  progress = pro;
	NSLog(@"_countPage = %f",_countPage);
	if ((_page != 0) && (_page != (_countPage-1))) {
		progress = p;
		_num = 0;
	} else {
		_num = 5;
	}
  [self setNeedsDisplay];
}

- (void)setPage:(int)page {
	_page = page;
}

- (void)setCountPage:(CGFloat)countPage {
	_countPage = countPage;
}

- (void)setNum:(CGFloat)num {
	_num = num;
}

- (void)drawRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();
  if (_isLine) {
    CGContextSetFillColorWithColor(context, self.lightColor.CGColor);
    
    CGContextMoveToPoint(context, 0 , self.frame.size.height - 2);
    CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height - 2);
    CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height);
    CGContextAddLineToPoint(context, 0, self.frame.size.height);
    CGContextAddLineToPoint(context, 0, self.frame.size.height - 2);
    
    CGContextFillPath(context);
    
  } else {
    CGFloat x = CGRectGetWidth(self.bounds);
    CGFloat y = CGRectGetHeight(self.bounds);
    CGFloat rounding = _num;
    
    NSLog(@"progress =-- %f, rounding = %f",progress,rounding);
    CGContextSetFillColorWithColor(context, RGBA(247, 156, 51, 0.8).CGColor);
    CGContextMoveToPoint(context, rounding , 0);
    CGContextAddArcToPoint(context, 0, 0, 0, rounding, rounding - progress);
    
    CGContextAddLineToPoint(context, 0, y - rounding);
    CGContextAddArcToPoint(context, 0 , y , rounding, y,  rounding - progress);
    
    CGContextAddLineToPoint(context, x - rounding, y);
    CGContextAddArcToPoint(context, x, y, x, y - rounding, progress);
    
    CGContextAddLineToPoint(context, x, rounding);
    CGContextAddArcToPoint(context, x, 0, x - rounding, 0,progress);
    
    CGContextAddLineToPoint(context, rounding, 0);
    
    CGContextFillPath(context);
  }
}

@end
