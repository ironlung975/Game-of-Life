//
//  cell.h
//  matt
//
//  Created by Guest Account on 1/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface cell : NSButtonCell {

	int	x;
	int	y;
	int	life;
	int	nextLife;
	int	liveNeighbors;
	int	numNeighbors;
	NSMutableArray*	neighbors;
}
+(id)makeWithX: row WithY: col;
-(void)changeLife: (int) new;
-(void)changeNextLife: (int) new;
-(int)getLife;
-(int)getNextLife;
-(int)getLiveNeighbors;
-(void)addNeighbor: (cell*) new;
-(cell*)getNeighbor: (int) index;
-(void)addLiveNeighbors;
-(void)resetCell;
-(void) resetLiveNeighbors;
-(void)instantiateNeighbors;

@end
