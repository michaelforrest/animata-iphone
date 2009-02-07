//
//  Texture.m
//  GrimoniumAlpha
//
//  Created by Michael Forrest on 26 Jan.
//  Copyright 2009 Grimaceworks. All rights reserved.
//

#import "Texture.h"



@implementation Texture
@synthesize location, position,scale;


-(void) addAttributes:(NSDictionary *)attributeDict {
	self.location = [attributeDict objectForKey:@"location"];
	CGFloat x = [[attributeDict objectForKey:@"x"] floatValue];
	self.position = CGPointMake(x,	[[attributeDict objectForKey:@"y"] floatValue]);
	
}

// returns a pointer to the texture stored by opengl
-(GLuint)getTextureImage: (EAGLView*) canvas{
	if(image == 0) {
		image = [canvas loadImageFile:self.location];
			}
	return image;
}

@end
