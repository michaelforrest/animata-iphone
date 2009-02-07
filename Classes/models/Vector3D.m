//
//  Vector3D.m
//  GrimoniumAlpha
//
//  Created by Michael Forrest on 27 Jan.
//  Copyright 2009 Grimaceworks. All rights reserved.
//

#import "Vector3D.h"


@implementation Vector3D
@synthesize x,y,z;
-(id) initWithX: (CGFloat) anX y:(CGFloat)aY z:(CGFloat) aZ{
	self = [super init];
	self.x = anX;
	self.y = aY;
	self.z = aZ;
	return self;
}
-(void) moveTo: (CGPoint) p{
	self.x = p.x;
	self.y = p.y;
}
@end
