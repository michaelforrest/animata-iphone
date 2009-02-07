//
//  EAGLView.h
//  GrimoniumAlpha
//
//  Created by Michael Forrest on 25 Jan.
//  Copyright Grimaceworks 2009. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "Vector3D.h"
#import "Mesh.h"

/*
This class wraps the CAEAGLLayer from CoreAnimation into a convenient UIView subclass.
The view content is basically an EAGL surface you render your OpenGL scene into.
Note that setting the view non-opaque will only work if the EAGL surface has an alpha channel.
*/
@interface EAGLView : UIView {

@protected
    /* The pixel dimensions of the backbuffer */
    GLint backingWidth;
    GLint backingHeight;
    
    EAGLContext *context;
    
    /* OpenGL names for the renderbuffer and framebuffers used to render to this view */
    GLuint viewRenderbuffer, viewFramebuffer;
    
    /* OpenGL name for the depth buffer that is attached to viewFramebuffer, if it exists (0 if it does not exist) */
    
    NSTimer *animationTimer;
    NSTimeInterval animationInterval;
	GLuint imageTexture;
		
	CGFloat viewportWidth;

}

@property NSTimeInterval animationInterval;

-(void)startAnimation;
-(void)stopAnimation;
-(void)setupView;
-(void)drawView;
-(void)startDrawing;
-(void)renderBuffer;
-(void) setCameraToPortrait:(Boolean) landscape;
-(void)pushMatrix;
-(void)popMatrix;
-(void)translate:(Vector3D*)position;
-(void)scale:(CGFloat)amount;

-(void)drawTexture:(GLuint)texture points:(CGFloat[]) points uvPoints:(CGFloat[]) uvPoints size:(NSInteger) size;


-(GLuint) loadImageFile:(NSString *)name;
@end
