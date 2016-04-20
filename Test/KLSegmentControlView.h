//
//  KLSegmentControlView.h
//  Test
//
//  Created by xiangkai yin on 15/12/29.
//  Copyright © 2015年 kuailao_2. All rights reserved.
//

#import <UIKit/UIKit.h>
#define DEFAULT_CORNERREDIUS 5.f

@class ViewColorRedius;
typedef void(^ButtonOnClickBlock)(NSInteger tag, NSString * title);

@interface KLSegmentControlView : UIView

@property (nonatomic, strong) NSArray *titles;                      //标题数组
@property (nonatomic, strong) UIColor *titlesCustomeColor;          //标题的常规颜色
@property (nonatomic, strong) UIColor *titlesHeightLightColor;      //标题高亮颜色
@property (nonatomic, strong) UIColor *backgroundHeightLightColor;  //高亮时的颜色
@property (nonatomic, strong) UIFont *titlesFont;                   //标题的字号
@property (nonatomic, assign) CGFloat duration;                     //运动时间

@property (nonatomic, strong) ViewColorRedius * heightColoreView;

@property (nonatomic, strong) UIView * heightLightView;
@property (nonatomic, strong) UIView * heightTopView;
@property (nonatomic ,assign) BOOL isLine;

/**
 *  点击按钮的回调
 
 *
 *  @param block 点击按钮的Block
 */
-(void) setButtonOnClickBlock: (ButtonOnClickBlock) block;

/**
 *  设置view指定的圆角
 *
 *  @param Corners 指定的方位
 *  @param view    view
 *  @param radius  圆角的大小
 */
- (void)changeLayerCorners:(UIRectCorner)Corners withView:(UIView *)view withRadius:(CGFloat)radius;

@end


@interface ViewColorRedius : UIView

@property (nonatomic ,assign) BOOL isLine;//是否线

@property (nonatomic ,assign) UIColor *lightColor;//显示颜色

@property (nonatomic,assign)CGFloat num; //圆角的大小

@property (nonatomic,assign)int page;//当前页

@property (nonatomic,assign)CGFloat countPage;//总页数

@property (nonatomic)CGFloat progress;//当前滚动的值

@end