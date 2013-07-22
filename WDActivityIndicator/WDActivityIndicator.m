//
//  UploadProgressView.m
//  Weddine
//
//  Created by Guilherme Moura on 24/02/2013.
//  Copyright (c) 2013 Reefactor, Inc. All rights reserved.
//

#import "WDActivityIndicator.h"

@interface WDActivityIndicator ()

@property (nonatomic) BOOL animating;
@property (nonatomic) CGFloat angle;
@property (strong, nonatomic) UIImageView *activityImageView;

@end

@implementation WDActivityIndicator


+(id)defaultWDActivityIndicator{
    WDActivityIndicator * i = [[WDActivityIndicator alloc] init];
    [i setHidesWhenStopped:YES];
    [i setNativeIndicatorStyle:WDActivityIndicatorViewStyleGray];
    [i setIndicatorStyle:WDActivityIndicatorStyleSegmentLarge];
    
    if (kCustomIndicator) {
        [i setNativeIndicatorStyle:WDActivityIndicatorViewStyleCustom];
    }
    [i startAnimating];
    return i;

}

- (id)init {
	return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame {
	CGRect fixedFrame = {frame.origin, {21, 21}};
	self = [super initWithFrame:fixedFrame];
	if (self) {
		[self setupView];
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self setupView];
	}
	
	return self;
}

- (void)startAnimating {
	self.animating = YES;
	self.hidden = NO;
}

- (void)stopAnimating {
	self.animating = NO;
	
	self.hidden = self.hidesWhenStopped;
	
	// reset to default position
	self.angle = 0.0f;
	CGAffineTransform transform = CGAffineTransformMakeRotation(0.0f);
	self.activityImageView.transform = transform;
}

- (void)setIndicatorStyle:(WDActivityIndicatorStyle)indicatorStyle {
	_indicatorStyle = indicatorStyle;
	
	NSMutableString *imageName = [NSMutableString stringWithString:@"WDActivityIndicator.bundle/"];
	
	switch (indicatorStyle) {
		case WDActivityIndicatorStyleGradient:
			[imageName appendString:@"activity_gradient"];
			break;
		
		case WDActivityIndicatorStyleSegment:
			[imageName appendString:@"activity_segment"];
			break;
			
		case WDActivityIndicatorStyleSegmentLarge:
			[imageName appendString:@"activity_segment_full"];
			break;
		
		default:
			break;
	}
	
	// Set the style conforming native UIActivityIndicatorView constants.
	switch (self.nativeIndicatorStyle) {
		case WDActivityIndicatorViewStyleGray:
			[imageName appendString:@"_gray"];
			break;
			
		case WDActivityIndicatorViewStyleWhite:
			[imageName appendString:@"_white"];
			break;
			
		case WDActivityIndicatorViewStyleWhiteLarge:
			// TODO: Create large white images
			[imageName appendString:@"_white"];
			break;
		case WDActivityIndicatorViewStyleCustom:
			// TODO: Create large white images
			[imageName appendString:@"_custom"];
            imageName = [NSMutableString stringWithString:[imageName stringByReplacingOccurrencesOfString:@"WDActivityIndicator.bundle/" withString:@""]];
			break;
		default:
			break;
	}
	//NSLog(@"imageName: %@", imageName);
	UIImage *indicatorImage = [UIImage imageNamed:imageName];
	
	if (!self.activityImageView) {
		self.activityImageView = [[UIImageView alloc] initWithImage:indicatorImage];
        self.activityImageView.tag = 101;
	}
	
	[self.activityImageView setImage:indicatorImage];
    if (self.nativeIndicatorStyle == WDActivityIndicatorViewStyleCustom) {
        [self.activityImageView setSize:indicatorImage.size];
        if ([EBHelper isRetina]) {
            [self.activityImageView setSize:ccs(indicatorImage.size.width/2, indicatorImage.size.height/2)];
        }
        [self.activityImageView setCenter:ccp(self.width/2, self.height/2)];
    }
    
}

- (void)setNativeIndicatorStyle:(WDActivityIndicatorViewStyle)nativeIndicatorStyle {
	_nativeIndicatorStyle = nativeIndicatorStyle;
	
	[self setIndicatorStyle:self.indicatorStyle];
}

#pragma mark - Private Methods

- (void)setupView {
	// Default Value is to start animated and to hide when stopped
	self.animating = YES;
	self.hidesWhenStopped = YES;
	self.nativeIndicatorStyle = UIActivityIndicatorViewStyleGray;
	
	// Configure the parent view
	[self setBackgroundColor:[UIColor clearColor]];
	
	[self setIndicatorStyle:WDActivityIndicatorStyleGradient];
	
	self.angle = 0.0f;
	
	NSTimer *timer = [NSTimer timerWithTimeInterval:0.02 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
	[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
		
	[self addSubview:self.activityImageView];
}

- (void)handleTimer:(NSTimer *)timer {
	if (self.animating)
		self.angle += 0.13f;
	
	if (self.angle > 6.283)
		self.angle = 0.0f;

	CGAffineTransform transform = CGAffineTransformMakeRotation(self.angle);
	self.activityImageView.transform = transform;
}

@end
