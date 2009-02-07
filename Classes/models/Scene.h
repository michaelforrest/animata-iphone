//
//  Scene.h
//  GrimoniumAlpha
//
//  Created by Michael Forrest on 26 Jan.
//  Copyright 2009 Grimaceworks. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Layer;

@interface Scene : NSObject {
	
	NSXMLParser * parser;
	Layer *root;
	NSMutableArray * allBones;
}


@property (nonatomic,retain) NSXMLParser * parser;
@property (nonatomic, retain) Layer *root;

-(Scene*) initWithXMLParser:(NSXMLParser*) xmlParser;
-(void) parseXML;
-(void) animateBone: (NSString *) boneName value:(CGFloat) value;
@end
