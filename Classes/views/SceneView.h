//
//  SceneView.h
//  GrimoniumAlpha
//
//  Created by Michael Forrest on 27 Jan.
//  Copyright 2009 Grimaceworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EAGLView.h"
#import "Scene.h"
#import "LayerView.h"
#import "Vector3D.h"
#import "SoundEffect.h"
#import "Skeleton.h"

@interface SceneView : EAGLView {
	Scene * scene;
	LayerView * rootView;
	Vector3D * dragOffset;
  IBOutlet UILabel * debug;

	NSMutableArray * triggers;
}
@property (nonatomic,retain) Scene * scene;
@property (nonatomic,retain) LayerView * rootView;
@property (nonatomic,retain) IBOutlet UILabel * debug;
-(void) startInteraction;
-(void) triggerTouches:(NSSet *) touches;
@end

@interface SoundTrigger	: NSObject
{
	SoundEffect * sound;
	CGRect rect;
	UITouch * touch;
	NSString * boneName;
	CGFloat downValue;
}
-(id) initWithSound:(NSString *) soundFile rect:(CGRect) aRect on:(CGFloat) down;
-(void) play;
-(void) relax;


@property (nonatomic, retain) SoundEffect * sound;
@property (nonatomic, retain) UITouch * touch;;
@property (nonatomic) CGRect rect;

@end

