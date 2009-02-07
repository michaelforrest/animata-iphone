//
//  MeshView.m
//  GrimoniumAlpha
//
//  Created by Michael Forrest on 27 Jan.
//  Copyright 2009 Grimaceworks. All rights reserved.
//

#import "MeshView.h"

@implementation MeshView
@synthesize layer;
-(id) initWithLayer:(Layer *) aLayer{
	self = [super init];
	self.layer = aLayer;
	
	vertexCount = 6;// [self.layer.mesh.faces count] * 3 * 2; // 3 vertices * 2 dimensions
	points = (CGFloat *)malloc(vertexCount * sizeof(CGFloat));
	uvPoints = (CGFloat*)malloc( vertexCount * sizeof(CGFloat));
	
	
	
	//[self updateBuffer];
	return self;
}

-(void) updateBuffer{
	// YUCK:
	for(NSInteger i = 0; i < [self.layer.mesh.faces count]; i++){
		Face * f = [self.layer.mesh.faces objectAtIndex:i]; 
		Vertex * v0 = [f.vertices objectAtIndex:0];
		Vertex * v1 = [f.vertices objectAtIndex:1];		
		Vertex * v2 = [f.vertices objectAtIndex:2];
		
		NSInteger startPoint = i * 6;
		
		points[startPoint + 0] = v0.position.x;
		points[startPoint + 1] = v0.position.y;
		points[startPoint + 2] = v1.position.x;
		points[startPoint + 3] = v1.position.y;
		points[startPoint + 4] = v2.position.x;
		points[startPoint + 5] = v2.position.y;
		
		uvPoints[startPoint + 0] = v0.uvCoordinate.x;
		uvPoints[startPoint + 1] = v0.uvCoordinate.y;
		uvPoints[startPoint + 2] = v1.uvCoordinate.x;
		uvPoints[startPoint + 3] = v1.uvCoordinate.y;
		uvPoints[startPoint + 4] = v2.uvCoordinate.x;
		uvPoints[startPoint + 5] = v2.uvCoordinate.y;
	
	}
	
}

-(void) draw:(EAGLView*)canvas{
	//[self updateBuffer];
	for(NSInteger i = 0; i < [self.layer.mesh.faces count]; i++){
		Face * f = [self.layer.mesh.faces objectAtIndex:i]; 
		
		Vertex * v0 = [f.vertices objectAtIndex:0];
		Vertex * v1 = [f.vertices objectAtIndex:1];		
		Vertex * v2 = [f.vertices objectAtIndex:2];
		
		points[0] = v0.position.x;
		points[1] = v0.position.y;
		points[2] = v1.position.x;
		points[3] = v1.position.y;
		points[4] = v2.position.x;
		points[5] = v2.position.y;
		
		uvPoints[0] = v0.uvCoordinate.x;
		uvPoints[1] = v0.uvCoordinate.y;
		uvPoints[2] = v1.uvCoordinate.x;
		uvPoints[3] = v1.uvCoordinate.y;
		uvPoints[4] = v2.uvCoordinate.x;
		uvPoints[5] = v2.uvCoordinate.y;
		
		//NSLog(@"%f,%f(%f,%f)-%f,%f(%f,%f)-%f,%f(%f,%f)",points[0],points[1],uvPoints[0],uvPoints[1],points[2],points[3],uvPoints[2],uvPoints[3],points[4],points[5],uvPoints[4],uvPoints[5]);
		
		[canvas drawTexture:[layer.texture getTextureImage:canvas] points:points uvPoints:uvPoints size:vertexCount];

		
	}
	
	
	
	
	}


@end
