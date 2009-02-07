//
//  SceneView.m
//  GrimoniumAlpha
//
//  Created by Michael Forrest on 27 Jan.
//  Copyright 2009 Grimaceworks. All rights reserved.
//

#import "SceneView.h"

@implementation SceneView

@synthesize scene,rootView;
@synthesize debug;
- (id)initWithCoder:(NSCoder*)coder {
	self = [super initWithCoder:coder];
	
	triggers = [[NSMutableArray alloc] initWithObjects: 
							[[SoundTrigger alloc] initWithSound:@"gabbakick"  rect:CGRectMake(100, 270, 130, 90) on:1.0f], 
							[[SoundTrigger alloc] initWithSound:@"spanner" rect:CGRectMake(0, 200, 100, 100) on:0.0f],
							[[SoundTrigger alloc] initWithSound:@"chinahat" rect:CGRectMake(250, 200, 150, 150) on:1.0f],
							nil];
	[self setMultipleTouchEnabled: YES];
	
	return self;
}
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[super willRotateToInterfaceOrientation:toInterfaceOrientation  duration:duration];
	
	[self setCameraToPortrait:(toInterfaceOrientation == UIInterfaceOrientationPortrait)];
	
}

-	(void)drawView{	
	[scene.root simulate];
	[self startDrawing];
	[self translate: dragOffset];
	glPushMatrix();
	
	[rootView draw: self];
	glPopMatrix();
	[self renderBuffer];
	
}
-(void) startInteraction{
	glTranslatef(-435, -300, 0);
	dragOffset = [[Vector3D alloc] initWithX:0	y:-0 z:0];
}
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self triggerTouches: touches];
}
-(void) triggerTouches:(NSSet *) touches{
	for(UITouch * touch in touches){
		for(SoundTrigger * trigger in triggers){
			//	[touch set
			if( CGRectContainsPoint(trigger.rect, [touch locationInView:self])){
				[trigger play];
			}
		}
	}	
	
}
// also gets triggered when another touch is added...
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	//[self triggerTouches: touches];
}
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	for(SoundTrigger * trigger in triggers){
		[trigger relax];
	}
}
@end
				
@implementation SoundTrigger
@synthesize sound, rect, touch;
-(id) initWithSound:(NSString *) soundFile rect:(CGRect) aRect on:(CGFloat) down{
	self = [super init];
	boneName = soundFile;
	self.sound = [[SoundEffect alloc] initWithContentsOfFile:[[NSBundle mainBundle]  pathForResource:soundFile ofType:@"aif"]];
	self.rect = aRect;
	downValue = down;
	return self;
}
-(void) play{
	[sound play];
	[Skeleton animateBone:boneName value: downValue];
}
-(void) relax{
	[Skeleton animateBone:boneName value: 1.0f - downValue];
}
@end