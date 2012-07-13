//
//  CTDownloadProgressButton.h
//  connector
//
//  Created by Oliver Letterer on 04.07.12.
//  Copyright 2012 ebf. All rights reserved.
//



/**
 @abstract  <#abstract comment#>
 */
@interface CTDownloadProgressButton : UIControl

/**
 @abstract The color of the progress indicator.
 */
@property (nonatomic, strong) UIColor *progressColor;

/**
 @abstract Color of inner stop button at the top.
 */
@property (nonatomic, strong) UIColor *topInnerButtonColor;

/**
 @abstract Color of inner stop button at the bottom.
 */
@property (nonatomic, strong) UIColor *bottomInnerButtonColor;

/**
 @abstract Color of the stop button.
 */
@property (nonatomic, strong) UIColor *stopButtonColor;

/**
 @abstract Progress between 0.0f and 1.0f.
 */
@property (nonatomic, assign) CGFloat progress;

@end
