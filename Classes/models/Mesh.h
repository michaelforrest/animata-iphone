//
//  Mesh.h
//  GrimoniumAlpha
//
//  Created by Michael Forrest on 27 Jan.
//  Copyright 2009 Grimaceworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Node.h"

@interface Mesh : Node {
	NSMutableArray *vertices;
	NSMutableArray *faces;
}
@property	(nonatomic, retain) NSMutableArray * vertices;
@property (nonatomic, retain) NSMutableArray * faces;

-(void) addFace: (NSDictionary*)attributeDict;
-(void) addVertex: (NSDictionary*)attributeDict;

@end

@interface Vertex	: NSObject
{
	CGPoint position;
	CGPoint uvCoordinate;
}
@property (nonatomic) CGPoint position;
@property (nonatomic) CGPoint uvCoordinate;
-(id) initWithX:(CGFloat) x y:(CGFloat) y u:(CGFloat) u v:(CGFloat) v;
-(void) addAttributes: (NSDictionary*) attributeDict;
-(void) moveX: (CGFloat) x y:(CGFloat) y;
@end

@interface Face	: NSObject
{
	NSArray * vertices;
}
@property (nonatomic, retain) NSArray * vertices;

-(void) addAttributes: (NSDictionary*) attributeDict vertices:(NSMutableArray *) allVertices;

@end
