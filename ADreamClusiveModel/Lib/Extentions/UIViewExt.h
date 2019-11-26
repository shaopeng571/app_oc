/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>

CGPoint CGRectGetCenter(CGRect rect);
CGRect  CGRectMoveToCenter(CGRect rect, CGPoint center);

@interface UIView (ViewFrameGeometry)

@property CGPoint origin;
@property CGSize size;

@property (readonly) CGPoint bottomLeft;
@property (readonly) CGPoint bottomRight;
@property (readonly) CGPoint topRight;

/// 高
@property CGFloat height;

/// 宽
@property CGFloat width;

/// Y坐标
@property CGFloat top;

/// X坐标
@property CGFloat left;

/// 底部 Y坐标+高度
@property CGFloat bottom;

/// 右侧 X坐标+宽度
@property CGFloat right;

// 水平中心位置
@property CGFloat centerX;

// 竖直方向中心位置
@property CGFloat centerY;

- (void) moveBy: (CGPoint) delta;

- (void) scaleBy: (CGFloat) scaleFactor;

- (void) fitInSize: (CGSize) aSize;

@end
