//
//  EAGLView.m
//  GrimoniumAlpha
//
//  Created by Michael Forrest on 25 Jan.
//  Copyright Grimaceworks 2009. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>

#import "EAGLView.h"


#define USE_DEPTH_BUFFER 0

// A class extension to declare private methods
@interface EAGLView ()

@property (nonatomic, retain) EAGLContext *context;
@property (nonatomic, assign) NSTimer *animationTimer;


- (BOOL) createFramebuffer;
- (void) destroyFramebuffer;

@end

@implementation EAGLView

@synthesize context, animationTimer, animationInterval;

// You must implement this method
+ (Class)layerClass {
    return [CAEAGLLayer class];
}


//The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id)initWithCoder:(NSCoder*)coder {
    
    if ((self = [super initWithCoder:coder])) {
        // Get the layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        eaglLayer.opaque = YES;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:YES], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
        
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        
        if (!context || ![EAGLContext setCurrentContext:context]|| ![self createFramebuffer]) {
            [self release];
            return nil;
        }
        
        animationInterval = 1.0 / 30.0;
    }
	[self setupView];
	[self drawView];
	return self;
}

-(void) setupView{
	// Sets up matrices and transforms for OpenGL ES
	glViewport(0, 0, backingWidth, backingHeight);

	[self setCameraToPortrait: YES];
	glClearColor(1.0f, 1.0f,1.0f, 1.0f);
	
// Enable use of the texture(s?)
	glEnable(GL_TEXTURE_2D);
	// Set a blending function to use
	glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
	// Enable blending
	glEnable(GL_BLEND);
	

	
}	
-(void) setCameraToPortrait:(Boolean) portrait {
	viewportWidth = 800.0f;
	
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();	
	
	
	// 3:2 aspect ratio!
	if(portrait){
		glOrthof(-viewportWidth/2, viewportWidth/2, viewportWidth * 0.75, -viewportWidth * 0.75,  -0.0f, 10.0f);	
	}else{
		glOrthof(viewportWidth * 0.75, -viewportWidth * 0.75, -viewportWidth/2, viewportWidth/2,   -0.0f, 10.0f);	
	}
	glMatrixMode(GL_MODELVIEW);
	
}
// override this 
-	(void)drawView{
	[self startDrawing];
	
	// Sets up an array of values to use as the sprite vertices.
	NSMutableArray * vertices =	[[NSMutableArray alloc] initWithObjects:
															[[Vertex alloc] initWithX:15.0f y:4.0f u:0 v:0],
															[[Vertex alloc] initWithX: 764.5f y:-17.5f u:1.0 v:0],
															[[Vertex alloc] initWithX:-748.5f y:569.5f u:0 v:1.0],
															[[Vertex alloc] initWithX: 15.5f y:536.5f u:1.0 v:1.0],nil];
	int floatCount = 4 * 2;
	float * spriteVertices = (float *)malloc( floatCount * sizeof(float));
	float * spriteTexcoords = (float *)malloc( floatCount * sizeof(float));
	
	for(NSInteger i = 0; i < [vertices count]; i++){
		Vertex * v = [vertices objectAtIndex:i];
		spriteVertices[i*2] = v.position.x;
		spriteVertices[i*2 + 1] = v.position.y;
		spriteTexcoords[i*2] = v.uvCoordinate.x;
		spriteTexcoords[i*2 + 1] = v.uvCoordinate.y;
	}
	
	// draw code
	glRotatef(1.0f, 0.0, 1.0f, 0.0f);	
	
	[self drawTexture:imageTexture points:spriteVertices uvPoints:spriteTexcoords size:4];
	
	[self renderBuffer];
}

-(void)pushMatrix{
	glPushMatrix();
}
-(void)popMatrix{
	glPopMatrix();
}
-(void)translate:(Vector3D *)position{
	glTranslatef(position.x, position.y, position.z);
}

-(void)scale:(CGFloat)amount{
	glScalef(amount, amount, 1.0);
}

/*********
 THIS IS THE BIT THAT DOES IT
****/
-(void) startDrawing{
	// Make sure that you are drawing to the current context
	[EAGLContext setCurrentContext:context];
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	

	glMatrixMode(GL_MODELVIEW);
	
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	
}

-(void)drawTexture:(GLuint)texture points:(CGFloat[]) points uvPoints:(CGFloat[]) uvPoints size:(NSInteger) size{
	glVertexPointer(2, GL_FLOAT, 0,  points);
	glTexCoordPointer(2, GL_FLOAT, 0,  uvPoints);
	
	glBindTexture(GL_TEXTURE_2D,  texture);	
	
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
						 //GL_LINES,GL_TRIANGLE_FAN
	glDrawArrays(GL_TRIANGLES, 0, size); 

	
	GLenum err = glGetError();
	if (err != GL_NO_ERROR)
		NSLog(@"Error drawing texture. glError: %i", err);
	
	
	
}
-(void)renderBuffer{
	//NSLog(@"rendering the buffer");
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	[context presentRenderbuffer:GL_RENDERBUFFER_OES];
	GLenum err = glGetError();
	if (err != GL_NO_ERROR)
		NSLog(@"Error in frame. glError: 0x%04X", err);
	
}

/*** END OF BIT THAT DOES IT *****/

-(GLuint) loadImageFile:(NSString *)name
{
	// LOAD IMAGE
	UIImage *image = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:name]];
	if (image == nil)		NSLog(@"Failed to load %@", name);
	
	// TURN IT INTO CGImageRef and data
	CGImageRef cgImage = [image CGImage];
	int width = CGImageGetWidth(cgImage);
	int height = CGImageGetHeight(cgImage);
	
	void *data = malloc(width * height * 4);
	CGContextRef cgContext = CGBitmapContextCreate(data, width, height, 8, width * 4, CGImageGetColorSpace(cgImage), kCGImageAlphaPremultipliedLast );
	CGContextDrawImage(cgContext, CGRectMake(0.0f, 0.0f, width, height), cgImage);
	
	GLuint textureName;
	
	glGenTextures(1, &textureName);
	glBindTexture(GL_TEXTURE_2D, textureName);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);
	
	GLenum err = glGetError();
	if (err != GL_NO_ERROR)	
		NSLog(@"Error uploading texture. glError: 0x%04X", err);
	else 
		NSLog(@"Texture loaded for image %@ into slot %i", name, textureName);
	
	CGContextRelease(cgContext);	
	free(data);
	
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	
	// Enable use of the texture(s?)
	glEnable(GL_TEXTURE_2D);
	// Set a blending function to use
	glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
	// Enable blending
	glEnable(GL_BLEND);
	
	//glHint (GL_POINT_SMOOTH_HINT, GL_NICEST);
	
	
	//glEnable(GL_NORMALIZE);
	
	return textureName;
}
	
- (void)layoutSubviews {
    [EAGLContext setCurrentContext:context];
		//only need to redo the frame buffer if view size changes
    //[self destroyFramebuffer];
		//[self createFramebuffer];
    [self drawView];
}


- (BOOL)createFramebuffer {
    
    glGenFramebuffersOES(1, &viewFramebuffer);
    glGenRenderbuffersOES(1, &viewRenderbuffer);
    
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
    
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
    
    if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
        NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }
    
    return YES;
}


- (void)destroyFramebuffer {
     glDeleteFramebuffersOES(1, &viewFramebuffer);
    viewFramebuffer = 0;
    glDeleteRenderbuffersOES(1, &viewRenderbuffer);
    viewRenderbuffer = 0;
}


- (void)startAnimation {
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:animationInterval target:self selector:@selector(drawView) userInfo:nil repeats:YES];
}
- (void)stopAnimation {
    self.animationTimer = nil;
}


- (void)setAnimationTimer:(NSTimer *)newTimer {
    [animationTimer invalidate];
    animationTimer = newTimer;
}


- (void)setAnimationInterval:(NSTimeInterval)interval {
    animationInterval = interval;
    if (animationTimer) {
        [self stopAnimation];
        [self startAnimation];
    }
}

//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
//	UITouch * touch = [touches anyObject];
//	zoomLevel += [touch locationInView:self].y - [touch previousLocationInView:self].y;
//	glRotatef([touch locationInView:self].x - [touch previousLocationInView:self].x,0,1,0);
//	
//}

- (void)dealloc {
    
    [self stopAnimation];
    
    if ([EAGLContext currentContext] == context) {
        [EAGLContext setCurrentContext:nil];
    }
    
    [context release];  
    [super dealloc];
}

@end
