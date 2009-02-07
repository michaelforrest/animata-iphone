//
//  LayerView.h
//  GrimoniumAlpha
//
//  Created by Michael Forrest on 27 Jan.
//  Copyright 2009 Grimaceworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Layer.h"
#import "EAGLView.h"
#import "MeshView.h"

@interface LayerView : NSObject {
	Layer*layer;
	MeshView * meshView;
	NSMutableArray * layers;
	
}
@property(nonatomic,retain) Layer *layer;
@property(nonatomic,retain) MeshView * meshView;
@property(nonatomic,retain) NSMutableArray *layers;

-(id) initWithLayer:(Layer *) aLayer;

-(void) addChildLayers;

-(void) draw:(EAGLView*)canvas;

@end
