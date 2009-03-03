//
//  Animator.m
//  GrimoniumAlpha
//
//  Created by Michael Forrest on 3 Mar.
//  Copyright 2009 Grimaceworks. All rights reserved.
//

#import "Animator.h"


@implementation Animator
@synthesize currentValue;

-(id)init:(NSObject*) anObject selector:(SEL)aSelector startValue:(CGFloat) anInitialValue{
	self = [super init];
	object = anObject;
	selector = aSelector;
	initialValue = anInitialValue;
	animationInterval = 1.0/60.0; // TODO fix this cos it'll go weird when the framerate is being changed elsewhere
	return self;
}
-(void) set: (CGFloat) value time:(CGFloat) time{
	[self stop];
	engine = [NSTimer scheduledTimerWithTimeInterval:animationInterval target:self selector:@selector(update) userInfo:nil repeats:YES];
	targetValue = value;
	initialValue = currentValue;
	difference = value - initialValue;
	frameIncrement = animationInterval / time;
	frame = 0;
	frame += frameIncrement; 
}
-(void) update{
	if (frame >= 1 || frame == 0) return;
	frame += frameIncrement;
	self.currentValue = initialValue + (difference * [self easeOutQuad: frame]);
	[object performSelector:selector];
	
	if (frame >= 1) [self stop];
}
-(void) stop{
	engine = nil;	
}
-(CGFloat) easeOutQuad:(CGFloat) t {
	return -1.0 * (t /= 1.0) * (t - 2.0);
}


@end
