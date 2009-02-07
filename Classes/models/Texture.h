//
//  Texture.h
//  GrimoniumAlpha
//
//  Created by Michael Forrest on 26 Jan.
//  Copyright 2009 Grimaceworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EAGLView.h"
#import "Node.h"


@interface Texture : Node {
	NSString *location;
	CGPoint position;
	CGFloat * scale;
	GLuint  image;
}
@property (nonatomic, retain) NSString * location;
@property (nonatomic) CGPoint position;
@property (nonatomic) CGFloat * scale;

-(void) addAttributes:(NSDictionary *)attributeDict;
-(GLuint)getTextureImage: (EAGLView*) canvas;

@end
