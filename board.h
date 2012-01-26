//
//  board.h
//  matt
//
//  Created by Guest Account on 1/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>



@interface board : NSMatrix {

@private
    NSArray* backingStore;
    int numRows;
    int numCols;
}

// values is a linear array in row major order

-(IBAction)start: (id) sender;
-(IBAction)reset: (id) sender;
-(IBAction)next: (id) sender;
-(IBAction)fillNeighbors:sender;
-(int)liveNeighbors;
-(void)updateLiveNeighbors;
-(void)calcNextLife;

@end


