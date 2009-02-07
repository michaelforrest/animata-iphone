//
//  Skeleton.m
//  GrimoniumAlpha
//
//  Created by Michael Forrest on 27 Jan.
//  Copyright 2009 Grimaceworks. All rights reserved.
//

#import "Skeleton.h"

/************************************************
 SKELETON
 ************************************************/
@implementation Skeleton
@synthesize joints,bones,mesh;

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
	namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qualifiedName
		attributes:(NSDictionary *)attributeDict {
	
	if([elementName isEqualToString:@"joints"]) self.joints = [[NSMutableArray alloc] init];
	else if([elementName isEqualToString:@"bones"]) self.bones = [[NSMutableArray alloc] init];
	
	else if([elementName isEqualToString:@"joint"])	[self addJoint: attributeDict];
	else if([elementName isEqualToString:@"bone"])		[self addBone: attributeDict];
	
	else NSLog(@"%@ ignoring node %@", self, elementName);
}

-(void) addJoint: (NSDictionary*)attributeDict{
	Joint * joint= [[Joint alloc] init];
	[joint addAttributes: attributeDict];
	[self.joints addObject:joint];
	[joint release];
	
}
-(void) addBone: (NSDictionary*)attributeDict{
	Bone *bone = [[Bone alloc] init];
	bone.mesh = self.mesh;
	[bone addAttributes:attributeDict	joints:self.joints];
	[bone giveParserFocus:self.parser parent:self type:@"bone"];
	[bones addObject:bone];
	if(allBones == nil) allBones = [[NSMutableArray alloc] init];
	[allBones addObject:bone];
	
}

-(void) simulate: (NSInteger) times{
	// no joint gravity simulation
	for (NSInteger i=0; i < times; i++) {	
		for(Bone *bone in self.bones){
			[bone simulate];
			[bone translateVertices];
		}
	}
}

+(void) animateBone: (NSString *) boneName value:(CGFloat) value{
	for(Bone * aBone in allBones){
		if([aBone.name isEqual: boneName]){
			[aBone animateScale:value];
		}
	}
}


@end

/************************************************
 JOINT
 ************************************************/

@implementation Joint	
@synthesize position,fixed,name;
-(void) addAttributes: (NSDictionary*) attributeDict{
	self.position = CGPointMake([[attributeDict objectForKey:@"x"] floatValue],
															[[attributeDict objectForKey:@"y"] floatValue]);
	self.fixed = [[attributeDict objectForKey:@"fixed"] isEqualToString:@"1"];
//	self.name = [[attributeDict objectForKey:@"name"] stringValue];
	//NSLog(@"bone %@ fixed? %@=> %b", name, [attributeDict objectForKey:@"fixed"], fixed);

}
-(void) moveX: (CGFloat) x y:(CGFloat) y{
	position.x += x;
	position.y += y;

}
@end

/************************************************
 BONE
 ************************************************/
@implementation Bone
@synthesize j0,j1,scale,maxScale,minScale,tempo,time,name,stiffness,size,radius,falloff,attachedVertices,mesh;

-(void) addAttributes: (NSDictionary*) attributeDict joints:(NSMutableArray *) allJoints{
	self.j0 = [allJoints objectAtIndex:[[attributeDict objectForKey:@"j0"] intValue]];
	self.j1 = [allJoints objectAtIndex:[[attributeDict objectForKey:@"j1"] intValue]];	
	self.stiffness = [[attributeDict objectForKey:@"stiffness"] floatValue];
	self.scale = [[attributeDict objectForKey:@"lm"] floatValue];
	self.maxScale = [[attributeDict objectForKey:@"lmmax"] floatValue];
	self.minScale = [[attributeDict objectForKey:@"lmmin"] floatValue];
	self.tempo = [[attributeDict objectForKey:@"tempo"] floatValue];
	self.time = 0;//[[attributeDict objectForKey:@"time"] floatValue];
	self.size = [[attributeDict objectForKey:@"size"] floatValue];
	self.radius = [[attributeDict objectForKey:@"radius"] floatValue];
	self.name =  [attributeDict objectForKey:@"name"];
	self.falloff = 1.0f;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
	namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qualifiedName
		attributes:(NSDictionary *)attributeDict {
	
	if([elementName isEqualToString:@"attached"]) self.attachedVertices = [[NSMutableArray alloc] init];
	if([elementName isEqualToString:@"vertex"]) [self addVertex:attributeDict vertices:self.mesh.vertices];
}
-(void) addVertex: (NSDictionary*) attributeDict vertices:(NSMutableArray *) allVertices{

		Vertex * vertex = [allVertices objectAtIndex:[[attributeDict objectForKey:@"id"] intValue]];
		
		AttachedVertex * attachedVertex = [[AttachedVertex alloc] init];
		[attachedVertex addAttributes:attributeDict	vertex:vertex bone:self];
		[attachedVertex setInitialConditions];
		[self.attachedVertices addObject:attachedVertex];
		
}
-(void) simulate{
	if(tempo > 0){
		//NSLog(@"simulating %@ t = %f, scale=%f", self, time, scale);
		time += tempo / 42.0f;
		[self animateScale: 0.5f + sin(time) * 0.5f];
	}
	CGFloat dx = j1.position.x - j0.position.x;
	CGFloat dy = j1.position.y - j0.position.y;
	CGFloat dCurrent = sqrt(dx*dx + dy*dy);
	
	if(dCurrent > 0){
		dx /= dCurrent;
		dy /= dCurrent;
	}

	float m = ((size * scale) - dCurrent) * stiffness;
	
	if (j0.fixed == NO )	[self.j0 moveX:-m*dx y:-m*dy]; 
	if (j1.fixed == NO )	[self.j1 moveX: m*dx y: m*dy];
	
} 

-(void) animateScale: (CGFloat) t{
	tempo = 0;
	scale = minScale + ((maxScale- minScale) * t);
}
	
-(void) translateVertices{
	float x0 = j0.position.x;
	float y0 = j0.position.y;
	float x1 = j1.position.x;
	float y1 = j1.position.y;
	
	float dx = (x1 - x0);
	float dy = (y1 - y0);
	
	float x = x0 + dx * 0.5f;
	float y = y0 + dy * 0.5f;
	
	float dCurrent = sqrt(dx*dx + dy*dy);
	if (dCurrent < FLT_EPSILON)
	{
		dCurrent = FLT_EPSILON;
	}
	if(dCurrent > 0){
		dx /= dCurrent;
		dy /= dCurrent;
	}	
	if(attachedVertices == nil) return;
	for (AttachedVertex *v in self.attachedVertices) {
		CGFloat vx = v.vertex.position.x;
		CGFloat vy = v.vertex.position.y;
		float tx = x + (dx * v.ca - dy * v.sa);
		float ty = y + (dx * v.sa + dy * v.ca);
		vx += (tx - vx) * v.weight;
		vy += (ty - vy) * v.weight;
		v.vertex.position = CGPointMake(vx,vy);//OPTIMIZE?
	}
}

@end

/************************************************
 ATTACHED VERTEX
 ************************************************/

@implementation AttachedVertex		
@synthesize vertex,bone,d,w,ca,sa,weight;
-(void) addAttributes:(NSDictionary*)attributeDict vertex:(Vertex *) aVertex bone:(Bone*)aBone{
	self.vertex = aVertex;
	self.bone = aBone;
	self.d = [[attributeDict objectForKey:@"d"] floatValue];
	self.w = [[attributeDict objectForKey:@"w"] floatValue];
	self.ca = [[attributeDict objectForKey:@"ca"] floatValue];
	self.sa = [[attributeDict objectForKey:@"sa"] floatValue];
}
-(void) setInitialConditions{
	float x0 = bone.j0.position.x;
	float y0 = bone.j0.position.y;
	float x1 = bone.j1.position.x;
	float y1 = bone.j1.position.y;
	
	float alpha = atan2(y1 - y0, x1 - x0);
	float dx = (x1 - x0);
	float dy = (y1 - y0);
	//			float dCurrent = PApplet.sqrt(dx*dx + dy*dy);
	float x = x0 + dx * 0.5f;
	float y = y0 + dy * 0.5f;
	
	float vx = vertex.position.x;
	float vy = vertex.position.y;
	float vd = sqrt((x - vx) * (x - vx) + (y - vy) * (y - vy));
	
	float vdnorm = vd / (bone.radius * bone.size * .5f);
	
	if (vdnorm >= 1)
	{
		weight = 0.1f;//BONE_MINIMAL_WEIGHT;
	}
	else
	{
		weight = pow(1.0f - vdnorm, 1.0f / bone.falloff);
	}
	
	float a = atan2(vy - y, vx - x) - alpha;
	sa = vd * (sin(a));
	ca = vd * (cos(a));
}

@end
