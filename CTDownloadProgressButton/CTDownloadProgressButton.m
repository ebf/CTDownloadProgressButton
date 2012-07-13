//
//  CTDownloadProgressButton.m
//  connector
//
//  Created by Oliver Letterer on 04.07.12.
//  Copyright 2012 ebf. All rights reserved.
//

#import "CTDownloadProgressButton.h"
#import <QuartzCore/QuartzCore.h>



@interface CTDownloadProgressButton () {
    
}

@property (nonatomic, assign) CGGradientRef innerProgressShadowGradient; // retained
@property (nonatomic, assign) CGGradientRef stopButtonGradient; // retained

- (void)_saveGStateForContext:(CGContextRef)context actions:(dispatch_block_t)block;
- (void)_clipToBezierPath:(UIBezierPath *)bezierPath actions:(dispatch_block_t)block;

@end



@implementation CTDownloadProgressButton
@synthesize progress = _progress, progressColor = _progressColor, topInnerButtonColor = _topInnerButtonColor, bottomInnerButtonColor = _bottomInnerButtonColor, innerProgressShadowGradient = _innerProgressShadowGradient, stopButtonColor = _stopButtonColor, stopButtonGradient = _stopButtonGradient;

#pragma mark - setters and getters

- (void)setStopButtonColor:(UIColor *)stopButtonColor
{
    if (stopButtonColor != _stopButtonColor) {
        _stopButtonColor = stopButtonColor;
        
        [self setNeedsDisplay];
    }
}

- (CGGradientRef)stopButtonGradient
{
    if (!_stopButtonGradient) {
        UIColor *endColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        UIColor *transparentColor = [UIColor colorWithWhite:0.0f alpha:0.0f];
        
        NSArray *colors = [NSArray arrayWithObjects:
                           (__bridge id)transparentColor.CGColor,
                           (__bridge id)endColor.CGColor,
                           nil];
        CGFloat locations[] = {0.0f, 1.0f};
        _stopButtonGradient = CGGradientCreateWithColors(CGColorGetColorSpace(endColor.CGColor), (__bridge CFArrayRef)colors, locations);
    }
    
    return _stopButtonGradient;
}

- (void)setStopButtonGradient:(CGGradientRef)stopButtonGradient
{
    if (stopButtonGradient != _stopButtonGradient) {
        if (_stopButtonGradient != NULL) {
            CFRelease(_stopButtonGradient), _stopButtonGradient = NULL;
        }
        
        if (stopButtonGradient) {
            _stopButtonGradient = CGGradientRetain(stopButtonGradient);
        }
        
        [self setNeedsDisplay];
    }
}

- (CGGradientRef)innerProgressShadowGradient
{
    if (!_innerProgressShadowGradient) {
        UIColor *endColor = [UIColor colorWithWhite:0.0f alpha:0.45f];
        UIColor *transparentColor = [UIColor colorWithWhite:0.0f alpha:0.0f];
        
        NSArray *colors = [NSArray arrayWithObjects:
                           (__bridge id)endColor.CGColor,
                           (__bridge id)transparentColor.CGColor,
                           nil];
        CGFloat locations[] = {0.0f, 0.35f};
        _innerProgressShadowGradient = CGGradientCreateWithColors(CGColorGetColorSpace(endColor.CGColor), (__bridge CFArrayRef)colors, locations);
    }
    
    return _innerProgressShadowGradient;
}

- (void)setInnerProgressShadowGradient:(CGGradientRef)innerProgressShadowGradient
{
    if (innerProgressShadowGradient != _innerProgressShadowGradient) {
        if (_innerProgressShadowGradient != NULL) {
            CFRelease(_innerProgressShadowGradient), _innerProgressShadowGradient = NULL;
        }
        
        if (innerProgressShadowGradient) {
            _innerProgressShadowGradient = CGGradientRetain(innerProgressShadowGradient);
        }
        
        [self setNeedsDisplay];
    }
}

- (void)setTopInnerButtonColor:(UIColor *)topInnerButtonColor
{
    if (topInnerButtonColor != _topInnerButtonColor) {
        _topInnerButtonColor = topInnerButtonColor;
        
        [self setNeedsDisplay];
    }
}

- (void)setBottomInnerButtonColor:(UIColor *)bottomInnerButtonColor
{
    if (bottomInnerButtonColor != _bottomInnerButtonColor) {
        _bottomInnerButtonColor = bottomInnerButtonColor;
        
        [self setNeedsDisplay];
    }
}

- (void)setProgressColor:(UIColor *)progressColor
{
    if (progressColor != _progressColor) {
        _progressColor = progressColor;
        
        [self setNeedsDisplay];
    }
}

- (void)setProgress:(CGFloat)progress
{
    if (progress < 0.0f) {
        progress = 0.0f;
    } else if (progress > 1.0f) {
        progress = 1.0f;
    }
    
    if (progress != _progress) {
        _progress = progress;
        
        [self setNeedsDisplay];
    }
}

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame 
{
    if (self = [super initWithFrame:frame]) {
        // Initialization code
        self.layer.needsDisplayOnBoundsChange = YES;
        self.backgroundColor = [UIColor colorWithRed:233.0f/255.0f green:234.0f/255.0f blue:236.0f/255.0f alpha:1.0f];
        
        _progressColor = [UIColor colorWithRed:121.0f/255.0f green:141.0f/255.0f blue:168.0f/255.0f alpha:1.0f];
        _topInnerButtonColor = [UIColor colorWithRed:225.0f/255.0f green:225.0f/255.0f blue:225.0f/255.0f alpha:1.0f];
        _bottomInnerButtonColor = [UIColor colorWithRed:222.0f/255.0f green:223.0f/255.0f blue:223.0f/255.0f alpha:1.0f];
        _stopButtonColor = [UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:238.0f/255.0f alpha:1.0f];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGFloat outerRadius = MIN(CGRectGetWidth(rect), CGRectGetHeight(rect)) / 2.0f;
    CGFloat innerRadius = (38.0f / 58.0f) * outerRadius;
    
    static CGFloat correctionAngle = M_PI / 2.0f;
    CGFloat startAngle = 0.0f - correctionAngle;
    CGFloat endAngle = 2.0f * M_PI * _progress - correctionAngle;
    
    // draw progress
    UIBezierPath *outerArcPath = [UIBezierPath bezierPathWithArcCenter:center
                                                                radius:outerRadius
                                                            startAngle:0.0f
                                                              endAngle:2.0f * M_PI
                                                             clockwise:YES];
    
    [self _clipToBezierPath:outerArcPath actions:^{
        // draw progress
        UIBezierPath *progressPath = [UIBezierPath bezierPath];
        [progressPath moveToPoint:center];
        [progressPath addLineToPoint:CGPointMake(center.x, 0.0f)];
        [progressPath addArcWithCenter:center radius:outerRadius startAngle:startAngle endAngle:endAngle clockwise:YES];
        [progressPath addLineToPoint:center];
        [progressPath closePath];
        
        [self _clipToBezierPath:progressPath actions:^{
            [_progressColor setFill];
            [outerArcPath fill];
        }];
        
        outerArcPath.lineWidth = 2.0f;
        [[UIColor darkGrayColor] setStroke];
        [outerArcPath strokeWithBlendMode:kCGBlendModeDarken alpha:0.25f];
        
        // draw inner progress shadow
        CGContextSetBlendMode(context, kCGBlendModeLuminosity);
        CGContextDrawRadialGradient(context, self.innerProgressShadowGradient, center, innerRadius, center, outerRadius, 0);
        
        UIBezierPath *topClipPath = [UIBezierPath bezierPathWithRect:CGRectMake(0.0f, 0.0f, CGRectGetWidth(rect), CGRectGetHeight(rect) / 2.0f + 1.0f)];
        [self _clipToBezierPath:topClipPath actions:^{
            CGContextDrawRadialGradient(context, self.innerProgressShadowGradient, CGPointMake(center.x, center.y + 1), outerRadius + 1, center, innerRadius + 2.0f, 0);
        }];
        
        if (_progress > 0.0f && _progress < 1.0f) {
            [self _clipToBezierPath:topClipPath actions:^{
                CGContextDrawLinearGradient(context, self.innerProgressShadowGradient, CGPointMake(center.x, 0.0f), CGPointMake(center.x + 5.0f, 0.0f), 0);
            }];
        }
    }];
    
    // draw inner stop button
    UIBezierPath *innerArcPath = [UIBezierPath bezierPathWithArcCenter:center
                                                                radius:innerRadius
                                                            startAngle:0.0f
                                                              endAngle:2.0f * M_PI
                                                             clockwise:YES];
    
    [self _clipToBezierPath:innerArcPath actions:^{
        [[UIColor blueColor] setFill];
        [innerArcPath fill];
        
        UIBezierPath *topSectionPath = [UIBezierPath bezierPathWithRect:CGRectMake(0.0f, 0.0f, CGRectGetWidth(rect), CGRectGetHeight(rect) / 2.0f + 1.0f)];
        topSectionPath.lineWidth = 5.0f;
        
        [self _clipToBezierPath:topSectionPath actions:^{
            [_topInnerButtonColor setFill];
            [topSectionPath fill];
            
            [[UIColor whiteColor] setStroke];
            [innerArcPath strokeWithBlendMode:kCGBlendModeLighten alpha:0.5f];
        }];
        
        UIBezierPath *bottomSectionPath = [UIBezierPath bezierPathWithRect:CGRectMake(0.0f, CGRectGetHeight(rect) / 2.0f, CGRectGetWidth(rect), CGRectGetHeight(rect) / 2.0f)];
        [self _clipToBezierPath:bottomSectionPath actions:^{
            [_bottomInnerButtonColor setFill];
            [bottomSectionPath fill];
        }];
    }];
    
    // draw stop button
    CGSize stopButtonSize = CGSizeMake((10.0f / 58.0f * CGRectGetWidth(rect)), (12.0f / 58.0f * CGRectGetHeight(rect)));
    UIBezierPath *stopButtonPath = [UIBezierPath bezierPathWithRect:CGRectMake(center.x - stopButtonSize.width / 2.0f, center.y - stopButtonSize.height / 2.0f, stopButtonSize.width, stopButtonSize.height)];
    
    [self _clipToBezierPath:stopButtonPath actions:^{
        [_stopButtonColor setFill];
        [stopButtonPath fill];
        
        CGSize innerStopButtonSize = CGSizeMake((10.0f / 58.0f * CGRectGetWidth(rect)), (10.0f / 58.0f * CGRectGetHeight(rect)));
        CGRect innerStopButtonRect = CGRectMake(center.x - innerStopButtonSize.width / 2.0f, center.y - innerStopButtonSize.height / 2.0f, innerStopButtonSize.width, innerStopButtonSize.height);
        
        UIBezierPath *innerStopButtonPath = [UIBezierPath bezierPathWithRect:innerStopButtonRect];
        
        [self _clipToBezierPath:innerStopButtonPath actions:^{
            CGPoint startCenter = CGPointMake(CGRectGetMidX(innerStopButtonRect), CGRectGetMinY(innerStopButtonRect) + CGRectGetHeight(innerStopButtonRect) * 0.7f);
            CGFloat startRadius = 0.0f;
            
            CGPoint endCenter = CGPointMake(startCenter.x, CGRectGetMaxY(innerStopButtonRect) + 3.0f);
            CGPoint anyPointOnBoundary = CGPointMake(CGRectGetMinX(innerStopButtonRect), CGRectGetMinY(innerStopButtonRect));
            CGFloat endRadius = sqrtf(powf(endCenter.x - anyPointOnBoundary.x, 2.0f) + powf(endCenter.y - anyPointOnBoundary.y, 2.0f));
            
            CGContextDrawRadialGradient(context, self.stopButtonGradient, startCenter, startRadius, endCenter, endRadius, 0);
            
            // stoke boundary
            [innerStopButtonPath strokeWithBlendMode:kCGBlendModeSaturation alpha:0.25f];
        }];
    }];
}

#pragma mark - UIControl

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self sendActionsForControlEvents:UIControlEventTouchDown];
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    UIEdgeInsets insets = UIEdgeInsetsMake(- 40.0f, - 40.0f, - 40.0f, - 40.0f);
    BOOL pointIsInside = CGRectContainsPoint(UIEdgeInsetsInsetRect(self.bounds, insets), [touch locationInView:self]);
    
    if (pointIsInside) {
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    
}

#pragma mark - Memory management

- (void)dealloc
{
    self.innerProgressShadowGradient = NULL;
}

#pragma mark - Private category implementation ()

- (void)_saveGStateForContext:(CGContextRef)context actions:(dispatch_block_t)block
{
    CGContextSaveGState(context);
    
    if (block) {
        block();
    }
    
    CGContextRestoreGState(context);
}

- (void)_clipToBezierPath:(UIBezierPath *)bezierPath actions:(dispatch_block_t)block
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self _saveGStateForContext:context actions:^{
        CGContextAddPath(context, bezierPath.CGPath);
        CGContextClip(context);
        
        if (block) {
            block();
        }
    }];
}

@end
