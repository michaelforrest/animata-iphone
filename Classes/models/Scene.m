//
//  Scene.m
//  GrimoniumAlpha
//
//  Created by Michael Forrest on 26 Jan.
//  Copyright 2009 Grimaceworks. All rights reserved.
//

#import "Scene.h"
#import "Layer.h"

@implementation Scene

@synthesize parser;
@synthesize root;

-(Scene*) initWithXMLParser:(NSXMLParser*) xmlParser {
	[super init];
	self.parser = xmlParser;
	allBones = [[NSMutableArray alloc] init];
	
	return self;
}

-(void) parseXML{
	[self.parser setDelegate:self];
	
	BOOL success = [parser parse];
	
	if(success)
		NSLog(@"no errors");
	else{
		NSLog(@"error");
		NSLog([[parser parserError] description]);
	}		
}

/**
 START ELEMENT
 */
 - (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
																			namespaceURI:(NSString *)namespaceURI 
																			qualifiedName:(NSString *)qualifiedName
																			attributes:(NSDictionary *)attributeDict {
	
	if([elementName isEqualToString:@"layer"]) {
		Layer* layer = [[Layer alloc] init];
		[layer addAttributes:attributeDict];
		self.root = layer;
		[layer giveParserFocus:self.parser parent:self type:@"layer" ];
		[layer release];

	}
}
/**
 END ELEMENT
 */
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
	namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName {
	
	if([elementName isEqualToString:@"animata"]) {
		[self.root grabBones: allBones];
		return;
	}
	
}
-(Bone*) findBone: (NSString *) boneName {
	for(Bone * aBone in allBones){
		if([aBone.name isEqual: boneName]){
			return aBone;
		}
	}
	return nil;
}

-(void) animateBone: (NSString *) boneName value:(CGFloat) value{
	for(Bone * aBone in allBones){
		if([aBone.name isEqual: boneName]){
			aBone.tempo = 0;
			[aBone animateScale:value];
		}
	}
}

@end
