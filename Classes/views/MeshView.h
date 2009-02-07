//
//  MeshView.h
//  GrimoniumAlpha
//
//  Created by Michael Forrest on 27 Jan.
//  Copyright 2009 Grimaceworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Layer.h"
#import "Mesh.h"

@interface MeshView : NSObject {
	Layer*layer;
	NSInteger vertexCount;
	CGFloat* points;
	CGFloat* uvPoints;
}
@property(nonatomic,retain) Layer * layer;

-(id) initWithLayer:(Layer *) aLayer;
-(void) updateBuffer;
-(void) draw:(EAGLView*)canvas;

@end
