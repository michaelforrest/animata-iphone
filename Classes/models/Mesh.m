//
//  Mesh.m
//  GrimoniumAlpha
//
//  Created by Michael Forrest on 27 Jan.
//  Copyright 2009 Grimaceworks. All rights reserved.
//

#import "Mesh.h"

@implementation Mesh
@synthesize vertices, faces;


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
																		namespaceURI:(NSString *)namespaceURI 
																		qualifiedName:(NSString *)qualifiedName
																		attributes:(NSDictionary *)attributeDict {
	if([elementName isEqualToString:@"vertices"]) self.vertices = [[NSMutableArray alloc] init];
	else if([elementName isEqualToString:@"faces"]) self.faces = [[NSMutableArray alloc] init];
	else if([elementName isEqualToString:@"vertex"])	[self addVertex: attributeDict];
	else if([elementName isEqualToString:@"face"])		[self addFace: attributeDict];
	else NSLog(@"%@ ignoring node %@", self, elementName);
}
-(void) addVertex: (NSDictionary*)attributeDict{
	Vertex * vertex= [[Vertex alloc] init];
	[vertex addAttributes: attributeDict];
	[self.vertices addObject:vertex];
	[vertex release];
	
}
-(void) addFace: (NSDictionary*)attributeDict{
	Face * face = [[Face alloc] init];
	[face addAttributes:attributeDict	vertices:self.vertices];
	[self.faces addObject:face];

	[face release];
}
@end

@implementation Vertex
@synthesize position, uvCoordinate;

-(id) initWithX:(CGFloat) x y:(CGFloat) y u:(CGFloat) u v:(CGFloat) v{
	self = [super init];
	self.position = CGPointMake(x, y);
	self.uvCoordinate = CGPointMake(u,v);
	return self;
}

-(void) addAttributes: (NSDictionary*) attributeDict{
	self.position = CGPointMake([[attributeDict objectForKey:@"x"] floatValue],
															[[attributeDict objectForKey:@"y"] floatValue]);
	
	self.uvCoordinate = CGPointMake([[attributeDict objectForKey:@"u"] floatValue],
																	[[attributeDict objectForKey:@"v"] floatValue]);

}
-(void) moveX: (CGFloat) x y:(CGFloat) y{
	self.position = CGPointMake(position.x+x, position.y+y);
}
@end

@implementation Face	
@synthesize vertices;

-(void) addAttributes: (NSDictionary*) attributeDict vertices:(NSMutableArray *) allVertices{
	@try{
	Vertex * v0 = [allVertices objectAtIndex:[[attributeDict objectForKey:@"v0"] intValue]];
	Vertex * v1 = [allVertices objectAtIndex:[[attributeDict objectForKey:@"v1"] intValue]];
	Vertex * v2 = [allVertices objectAtIndex:[[attributeDict objectForKey:@"v2"] intValue]];
	self.vertices = [[NSArray alloc] initWithObjects:v0,v1,v2,nil];
//	
//	[v0 release];
//	[v1 release];
//	[v2 release];
	}@catch( NSException *e ){
		NSLog(@"problem!");
	}

}

@end
