//
//  Layer.m
//  GrimoniumAlpha
//
//  Created by Michael Forrest on 26 Jan.
//  Copyright 2009 Grimaceworks. All rights reserved.
//

#import "Layer.h"

@implementation Layer

@synthesize layers, name,position,alpha,scale,texture,mesh,skeleton; 

-(void) addAttributes:(NSDictionary *)attributeDict {
	self.layers = [[NSMutableArray alloc] init];
	self.name = [attributeDict objectForKey:@"name"];

	self.position = [[Vector3D alloc] initWithX:[[attributeDict objectForKey:@"x"] floatValue]
																			y:[[attributeDict objectForKey:@"y"] floatValue] 
																			z:[[attributeDict objectForKey:@"z"] floatValue]];
	self.scale = [[attributeDict objectForKey:@"scale"] floatValue];

	NSLog(@"created layer %@ with scale=%f", self.name, self.scale);
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
																			namespaceURI:(NSString *)namespaceURI 
																			qualifiedName:(NSString *)qualifiedName
																			attributes:(NSDictionary *)attributeDict {
	
	if(			[elementName isEqualToString:@"layer"])		[self addLayer: attributeDict];
	else if([elementName isEqualToString:@"texture"]) [self addTexture: attributeDict];
	else if([elementName isEqualToString:@"mesh"])		[self addMesh: attributeDict];
	else if([elementName isEqualToString:@"skeleton"]) [self addSkeleton: attributeDict];
	else{		NSLog(@"%@ node was not parsed by %@", elementName, self );	}

}

-(void) addLayer: (NSDictionary*)attributeDict{
	Layer *layer = [[Layer alloc] init]; 
	[layer addAttributes:attributeDict];
	[layer giveParserFocus:self.parser parent:self type:@"layer"];
	[layers addObject:layer];
}

-(void) addTexture: (NSDictionary*)attributeDict{
	self.texture = [[Texture alloc] init];
	[self.texture addAttributes: attributeDict];
	[self.texture giveParserFocus:self.parser parent:self type:@"texture"];
}
-(void) addMesh: (NSDictionary*)attributeDict{
	Mesh * aMesh = [[Mesh alloc] init];
	self.mesh = aMesh;
	[aMesh giveParserFocus:self.parser parent:self type:@"mesh"];
}
-(void) addSkeleton: (NSDictionary*)attributeDict{
	Skeleton * aSkeleton = [[Skeleton alloc] init];
	aSkeleton.mesh = self.mesh;
	[aSkeleton giveParserFocus:self.parser parent:self type:@"skeleton"];
	self.skeleton = aSkeleton;
	[aSkeleton release];
}

-(void) simulate{
	if(skeleton != nil) [skeleton simulate:40];
	for(Layer *aLayer in self.layers){
		[aLayer simulate];
	}	
}


-(void) dealloc{
	[name release];
	[layers release];
	[super dealloc];
}

@end
