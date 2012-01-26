//
//  cell.m
//  matt
//
//  Created by Guest Account on 1/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cell.h"


@implementation cell

+ (id)makeWithX: (int)col WithY: (int)row
{
    x = col;
    y = row;
    life = 0;
    nextLife = 0;
    liveNeighbors = 0;
    numNeighbors = 0;
}

-(void)changeLife: (int) new
{
    life = new;
}

-(void)changeNextLife: (int) new
{
    nextLife = new;
}

-(int)getLife
{
    return life;
}

-(int)getNextLife
{
    return nextLife;
}

-(int)getLiveNeighbors
{
    return liveNeighbors;
}

-(void)addNeighbor: (cell*) new
{
	[neighbors addObject:new];
}

-(id)getNeighbor: (int) index
{
    return [neighbors objectAtIndex: index];
}

-(void)addLiveNeighbors
{
	++liveNeighbors;
}

-(void)resetCell
{
    life = 0;
    nextLife = 0;
    liveNeighbors = 0;
    numNeighbors = 0;
}
-(void)resetLiveNeighbors
{
	liveNeighbors = 0;
}

-(void) instantiateNeighbors
{
	neighbors = [[NSMutableArray alloc] init];
	[neighbors retain];
}

@end
