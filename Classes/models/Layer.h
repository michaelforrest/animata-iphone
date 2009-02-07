//
//  Layer.h
//  GrimoniumAlpha
//
//  Created by Michael Forrest on 26 Jan.
//  Copyright 2009 Grimaceworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "Node.h"
#import "Texture.h"
#import "Mesh.h"
#import "Skeleton.h"
#import "Vector3D.h"

@interface Layer : Node {

	NSMutableArray * layers;
	NSString * name;
	Texture * texture;	
	Mesh * mesh;
	Skeleton * skeleton;
	
	Vector3D * position;
	
	CGFloat alpha;
	CGFloat scale;
	
}

@property (nonatomic, retain) NSString *name; 
@property (nonatomic, retain) Texture *texture;
@property (nonatomic, retain) Mesh * mesh;
@property (nonatomic, retain) Skeleton * skeleton;
@property (nonatomic, retain) NSMutableArray *layers;

@property (nonatomic, retain) Vector3D * position;

@property (nonatomic) CGFloat alpha;
@property (nonatomic) CGFloat scale;

-(void)addAttributes:(NSDictionary *)attributeDict;
-(void) simulate;
-(void) grabBones:(NSMutableArray*)allBones;


// private..
-(void) addTexture: (NSDictionary*)attributeDict;
-(void) addLayer: (NSDictionary*)attributeDict;
-(void) addMesh: (NSDictionary*)attributeDict;
-(void) addSkeleton: (NSDictionary*)attributeDict;

@end
