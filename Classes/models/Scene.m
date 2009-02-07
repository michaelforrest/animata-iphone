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
		return;
	}
	
}

@end
