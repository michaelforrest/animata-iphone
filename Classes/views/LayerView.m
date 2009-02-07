//
//  LayerView.m
//  GrimoniumAlpha
//
//  Created by Michael Forrest on 27 Jan.
//  Copyright 2009 Grimaceworks. All rights reserved.
//

#import "LayerView.h"

@implementation LayerView
@synthesize layer,layers,meshView;
-(id) initWithLayer:(Layer *) aLayer{
	self = [super init];
	self.layer = aLayer;
	if(aLayer.mesh != nil) self.meshView = [[MeshView alloc] initWithLayer: aLayer];
	if(aLayer.layers != nil) [self addChildLayers];
	return self;
}
-(void) addChildLayers{
	self.layers = [[NSMutableArray alloc] init]; 
	for (Layer * aLayer in self.layer.layers){
		[layers addObject:[[LayerView alloc] initWithLayer:aLayer]];
	}
}

-(void) draw:(EAGLView*)canvas{
	[canvas pushMatrix];
	[canvas translate:layer.position];
	
	if (self.layer.scale < 1) 
		self.layer.scale = 1;
//
//	[canvas scale:self.layer.scale];
	[canvas pushMatrix];
	if(meshView!=nil) [meshView draw:canvas];
	for(LayerView * layerView in layers){
		[layerView draw:canvas];
	}
	
	[canvas popMatrix];
	[canvas popMatrix];
}

@end
