//
//  Scene.h
//  GrimoniumAlpha
//
//  Created by Michael Forrest on 26 Jan.
//  Copyright 2009 Grimaceworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Skeleton.h"
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
-(Bone*) findBone: (NSString *) boneName;
-(void) animateBone: (NSString *) boneName value:(CGFloat) value;
-(void) setBoneTempo: (NSString *) boneName value:(CGFloat) value time:(CGFloat) time;
@end
