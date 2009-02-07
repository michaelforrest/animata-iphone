//
//  Skeleton.h
//  GrimoniumAlpha
//
//  Created by Michael Forrest on 27 Jan.
//  Copyright 2009 Grimaceworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mesh.h"
#import "Node.h"
/************************************************
 SKELETON
 ************************************************/
// would prefer a more encapsulated way of doing this, but I suppose I 
// can justify this in the context of a relatively simple application..


@interface Skeleton : Node {
	Mesh * mesh;
	NSMutableArray *joints;
	NSMutableArray *bones;
}
@property (nonatomic, retain) Mesh * mesh;
@property	(nonatomic, retain) NSMutableArray * joints;
@property (nonatomic, retain) NSMutableArray * bones;

-(void) addJoint: (NSDictionary*)attributeDict;
-(void) addBone: (NSDictionary*)attributeDict;
-(void) simulate:(NSInteger)times;


@end

/************************************************
 JOINT
 ************************************************/

@interface Joint	: NSObject
{
	CGPoint position;
	Boolean fixed;
	NSString * name;
}
@property (nonatomic, readwrite) CGPoint position;
@property (nonatomic) Boolean fixed;
@property (nonatomic, retain) NSString * name; 

-(void) addAttributes: (NSDictionary*) attributeDict;
-(void) moveX: (CGFloat) x y:(CGFloat) y;
@end

/************************************************
 BONE
 ************************************************/

@interface Bone	: Node
{
	Mesh * mesh;
	Joint * j0;
	Joint * j1;
	CGFloat scale;
	CGFloat maxScale;
	CGFloat minScale;
	CGFloat tempo;
	CGFloat time;
	NSMutableArray * attachedVertices;
	NSString * name;
	CGFloat stiffness;
	CGFloat size;
	CGFloat radius;
	CGFloat falloff;
}
@property (nonatomic, retain) Mesh * mesh;
@property (nonatomic, retain) Joint * j0;
@property (nonatomic, retain) Joint * j1;
@property (nonatomic) CGFloat scale;
@property (nonatomic) CGFloat maxScale;
@property (nonatomic) CGFloat minScale;
@property (nonatomic) CGFloat tempo;
@property (nonatomic) CGFloat time;
@property (nonatomic, retain)  NSMutableArray * attachedVertices;
@property (nonatomic, retain) NSString * name;
@property (nonatomic) CGFloat stiffness;
@property (nonatomic) CGFloat size;
@property (nonatomic) CGFloat radius;
@property (nonatomic) CGFloat falloff;

-(void) addAttributes: (NSDictionary*) attributeDict joints:(NSMutableArray *) allJoints;
-(void) addVertex: (NSDictionary*) attributeDict vertices:(NSMutableArray *) allVertices;
-(void) simulate;
-(void) animateScale: (CGFloat) t;
-(void) translateVertices;

@end

/************************************************
 ATTACHED VERTEX
 ************************************************/

@interface AttachedVertex	: NSObject	
{
	Vertex * vertex;
	Bone * bone;
	CGFloat d;
	CGFloat w;
	CGFloat ca;
	CGFloat sa;
	CGFloat weight;
}
@property (nonatomic, retain) Vertex * vertex;
@property (nonatomic, retain) Bone * bone;
@property (nonatomic) CGFloat d;
@property (nonatomic) CGFloat w;
@property (nonatomic) CGFloat ca;
@property (nonatomic) CGFloat sa;
@property (nonatomic) CGFloat weight;
-(void) addAttributes:(NSDictionary*)attributeDict vertex:(Vertex *) aVertex bone:(Bone*)aBone;
-(void) setInitialConditions;
@end

