//
//  Vector3D.h
//  GrimoniumAlpha
//
//  Created by Michael Forrest on 27 Jan.
//  Copyright 2009 Grimaceworks. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Vector3D : NSObject {
	CGFloat x;
	CGFloat y;
	CGFloat z;
}
@property(nonatomic,readwrite) CGFloat x;
@property(nonatomic,readwrite) CGFloat y;
@property(nonatomic,readwrite) CGFloat z;

-(id) initWithX: (CGFloat) anX y:(CGFloat)aY z:(CGFloat) aZ;
-(void) moveTo: (CGPoint) p;
@end
