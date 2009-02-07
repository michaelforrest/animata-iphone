//
//  Node.h
//  GrimoniumAlpha
//
//  Created by Michael Forrest on 26 Jan.
//  Copyright 2009 Grimaceworks. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Node : NSObject {
	NSString *type;
	NSObject *parent;
	NSXMLParser *parser;
}
-(void) giveParserFocus:(NSXMLParser *)parser parent:(NSObject *)parent type:(NSString*) aType;

@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSObject *parent;
@property (nonatomic, retain) NSXMLParser *parser;

@end
