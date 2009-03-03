//
//  Animator.h
//  GrimoniumAlpha
//
//  Created by Michael Forrest on 3 Mar.
//  Copyright 2009 Grimaceworks. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Animator : NSObject {
	NSTimer * engine;
	CGFloat targetValue;
	CGFloat initialValue;
	CGFloat difference;
	CGFloat frameIncrement;
	CGFloat currentValue;
	CGFloat frame;
	CGFloat animationInterval;
	NSObject * object;
	SEL selector;
}
@property (nonatomic) CGFloat currentValue;


-(id)init:(NSObject*) anObject selector:(SEL)aSelector startValue:(CGFloat) anInitialValue;
-(void)update;
-(void) set: (CGFloat) value time:(CGFloat) time;
-(void) stop;
-(CGFloat) easeOutQuad:(CGFloat) t;

@end
