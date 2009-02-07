//
//  Node.m
//  GrimoniumAlpha
//
//  Created by Michael Forrest on 26 Jan.
//  Copyright 2009 Grimaceworks. All rights reserved.
//

#import "Node.h"

@implementation Node

@synthesize parent, parser, type;

-(void) giveParserFocus:(NSXMLParser *)aParser parent:(NSObject *)aParent type:(NSString*)aType{
	NSLog(@"Stepping into %@ => %@", aType, self);
	self.type = aType;
	self.parent = aParent;
	self.parser = aParser;
	[aParser setDelegate:self];
}

// END
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
																				namespaceURI:(NSString *)namespaceURI 
																				qualifiedName:(NSString *)qName {
	
	if([elementName isEqualToString:self.type]){
			NSLog(@"Stepping out of %@ to %@",  self,self.parent );
			[self.parser setDelegate:self.parent];
		
	}
}

@end
