//
//  board.m
//  matt
//
//  Created by Guest Account on 1/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "board.h"
#import "cell.h"


@implementation board

-(IBAction)start: (id) sender
{
	[[self cellAtRow:2 column:4] performClick:sender];
	[[self cellAtRow:3 column:5] performClick:sender];
	[[self cellAtRow:4 column:4] performClick:sender];
	[[self cellAtRow:4 column:5] performClick:sender];
	[[self cellAtRow:4 column:3] performClick:sender];
	
	[[self cellAtRow:2 column:4] changeLife:1];
	[[self cellAtRow:3 column:5] changeLife:1];
	[[self cellAtRow:4 column:4] changeLife:1];
	[[self cellAtRow:4 column:5] changeLife:1];
	[[self cellAtRow:4 column:3] changeLife:1];
	
	[self fillNeighbors:sender]; 
}

-(IBAction)reset: (id) sender
{	
	for(int i = 0; i < [self numberOfRows]; ++i)
	{
		for(int k = 0; k < [self numberOfColumns]; ++k)
		{
			if ([[self cellAtRow:i column:k] state] == NSOnState)
			{
				[[self cellAtRow:i column:k] performClick: sender];
			}
			[[self cellAtRow:i column:k] resetCell];
		}
	}
}

-(IBAction)next: (id) sender
{
	//sweep for user made changes
	for(int i = 0; i < [self numberOfRows]; ++i)
	{
		for(int k = 0; k < [self numberOfColumns]; ++k)
		{
			if([[self cellAtRow:i column:k] state] == NSOnState)
			{
				[[self cellAtRow:i column:k] changeLife:1];
			}
			if([[self cellAtRow:i column:k] state] == NSOffState)
			{
				[[self cellAtRow:i column:k] changeLife:0];
				[[self cellAtRow:i column:k] changeNextLife:0];
			}
		}
	}
	
	//calculate Next Life for user made changes
	[self updateLiveNeighbors];
	
	for (int i = 0; i < [self numberOfRows]; ++i)
    {
        for (int k = 0; k < [self numberOfColumns]; ++k)
        {
			if([[self cellAtRow:i column:k] getLiveNeighbors] == 3)
			{
				[[self cellAtRow:i column:k] changeNextLife: 1];
			}
			if([[self cellAtRow:i column:k] getLife] == 1)
			{
				if([[self cellAtRow:i column:k] getLiveNeighbors] == 2 || [[self cellAtRow:i column:k] getLiveNeighbors] == 3)
				{
					[[self cellAtRow:i column:k] changeNextLife: 1];
				} else {
					[[self cellAtRow:i column:k] changeNextLife: 0];
				}
			}
		}
	}
	
	[self calcNextLife];
	
	//push the corresponding buttons to show that they are alive
	for (int i = 0; i < [self numberOfRows]; ++i)
    {
        for (int k = 0; k < [self numberOfColumns]; ++k)
        {
			if([[self cellAtRow:i column:k] getLife] == 1)
			{
				if([[self cellAtRow:i column:k] state] == NSOffState)
				{
					[[self cellAtRow:i column:k] performClick:sender];
				}
			}
			if([[self cellAtRow:i column:k] getLife] == 0)
			{
				if([[self cellAtRow:i column:k] state] == NSOnState)
				{
					[[self cellAtRow:i column:k] performClick:sender];
				}
			}
		}
	}
}

-(IBAction)fillNeighbors: (id)sender
{
	for(int b = 0; b < [self numberOfRows]; ++b)
	{
		for(int a = 0; a < [self numberOfColumns]; ++a)
		{
			int x = a;
			int y = b;
			
			[[self cellAtRow:b column:a] instantiateNeighbors];
			
			if(y-1 >= 0 && y+1 < [self numberOfRows] && x-1 >=0 && x+1 < [self numberOfColumns])
			{
				for (int c = x-1; c < x+2; ++c)
				{
					for (int d = y-1; d < y+2; ++d)
					{
						if (c==x && d==y)
						{
							continue;
						}
						[[self cellAtRow:y column:x] addNeighbor:[self cellAtRow:d column:c]];
					}
				}
			}
				
			if (x == 0)
			{
				//bottom left corner
				if (y == 0)
				{
					for (int c = 0; c < x+2; ++c)
					{
						for (int d = 0; d < y+2; ++d)
						{
							if (c==x && d==y)
							{
								continue;
							}
							[[self cellAtRow:y column:x] addNeighbor:[self cellAtRow:d column:c]];
						}
					}
					for (int n = 0; n < 2; ++n)
					{
						[[self cellAtRow:y column:x] addNeighbor:[self cellAtRow:[self numberOfRows]-1 column:n]];
					}
					for (int m = 0; m < 2; ++m)
					{
						[[self cellAtRow:y column:x] addNeighbor:[self cellAtRow:m column:[self numberOfColumns]-1]];
					}
					[[self cellAtRow:y column:x] addNeighbor:[self cellAtRow:[self numberOfRows]-1 column:[self numberOfColumns]-1]];
				}
					
				//top left corner
				if (y == [self numberOfRows]-1)
				{
					for (int c = 0; c < 2; ++c)
					{
						for (int d = [self numberOfRows]-1; d > [self numberOfRows]-3; --d)
						{
							if (c==x && d==y)
							{
									continue;
							}
							[[self cellAtRow:y column:x] addNeighbor:[self cellAtRow:d column:c]];
						}
					}
					for (int n = 0; n < 2; ++n)
					{
						[[self cellAtRow:y column:x] addNeighbor:[self cellAtRow:0 column:n]];
					}
					for (int m = [self numberOfRows]-1; m > [self numberOfRows]-3; --m)
					{
						[[self cellAtRow:y column:x] addNeighbor:[self cellAtRow:m column:[self numberOfColumns]-1]];
					}
					[[self cellAtRow:y column:x] addNeighbor:[self cellAtRow:0 column:[self numberOfColumns]-1]];
				}
				
				if(y != 0 && y != [self numberOfRows]-1)
				{
					//left side case
					for (int c = 0; c < x+2; ++c)
					{
						for (int d = y-1; d < y+2; ++d)
						{
							if (c==x && d==y)
							{
								continue;
							}
							[[self cellAtRow:y column:x] addNeighbor:[self cellAtRow:d column:c]];
						}
					}
					for (int j = y-1; j < y+2; ++j)
					{
						[[self cellAtRow:y column:x] addNeighbor:[self cellAtRow:j column:[self numberOfColumns]-1]];
					}
				}
			}
				
			if (x == [self numberOfColumns]-1)
			{

				//bottom right corner
				if (y == 0)
				{
					for (int c = [self numberOfColumns]-1; c > [self numberOfColumns]-3; --c)
					{
						for (int d = 0; d < 2; ++d)
						{
							if (c==x && d==y)
							{
								continue;
							}
							[[self cellAtRow:y column:x] addNeighbor:[self cellAtRow:d column:c]];
						}
					}
					for (int n = [self numberOfColumns]-1; n > [self numberOfColumns]-3; --n)
					{
						[[self cellAtRow:y column:x] addNeighbor:[self cellAtRow:[self numberOfRows]-1 column:n]];
					}
					for (int m = 0; m < 2; ++m)
					{
						[[self cellAtRow:y column:x] addNeighbor:[self cellAtRow:m column:0]];
					}
					[[self cellAtRow:y column:x] addNeighbor:[self cellAtRow:[self numberOfRows]-1 column:0]];
				}
					
				//top right corner
				if(y == [self numberOfRows]-1)
				{
					for (int c = [self numberOfColumns]-1; c > [self numberOfColumns]-3; --c)
					{
						for (int d = [self numberOfRows]-1; d > [self numberOfRows]-3; --d)
						{
							if (c==x && d==y)
							{
								continue;
							}
							[[self cellAtRow:y column:x] addNeighbor:[self cellAtRow:d column:c]];
						}
					}
					for (int n = [self numberOfColumns]-1; n > [self numberOfColumns]-3; --n)
					{
						[[self cellAtRow:y column:x] addNeighbor:[self cellAtRow:0 column:n]];
					}
					for (int m = [self numberOfRows]-1; m > [self numberOfRows]-3; --m)
					{
						[[self cellAtRow:y column:x] addNeighbor:[self cellAtRow:m column:0]];
					}
					[[self cellAtRow:y column:x] addNeighbor:[self cellAtRow:0 column:0]];
				}
				
				if(y != 0 && y != [self numberOfRows]-1)
				{		
					//right side
					for (int c = [self numberOfColumns]-1; c > [self numberOfColumns]-3; --c)
					{
						for (int d = y-1; d < y+2; ++d)
						{
							if (c==x && d==y)
							{
								continue;
							}
							[[self cellAtRow:y column:x] addNeighbor:[self cellAtRow:d column:c]];
						}
					}
					for (int j = y-1; j < y+2; ++j)
					{
						[[self cellAtRow:y column:x] addNeighbor:[self cellAtRow:j column:0]];
					}
				}
			}
				
				
			if (y == 0 && x != 0 && x != [self numberOfColumns]-1)
			{
				//bottom side
				for (int d = 0; d < y+2; ++d)
				{
					for (int c = x-1; c < x+2; ++c)
					{
						if (c==x && d==y)
						{
							continue;
						}
						[[self cellAtRow:y column:x] addNeighbor:[self cellAtRow:d column:c]];
					}
				}
				for (int j = x-1; j < x+2; ++j)
				{
					[[self cellAtRow:y column:x] addNeighbor:[self cellAtRow:[self numberOfRows]-1 column:j]];
				}
			}
				
			if (y == [self numberOfRows]-1 && x != 0 && x != [self numberOfColumns]-1)
			{
				//top side
				for (int d = [self numberOfRows]-1; d > [self numberOfRows]-3; --d)
				{
					for (int c = x-1; c < x+2; ++c)
					{
						if (c==x && d==y)
						{
							continue;
						}
						[[self cellAtRow:y column:x] addNeighbor:[self cellAtRow:d column:c]];
					}
				}
				for (int j = x-1; j < x+2; ++j)
				{
					[[self cellAtRow:y column:x] addNeighbor:[self cellAtRow:0 column:j]];
				}
			}
		}
	}
						 
	for(int b = 0; b < [self numberOfRows]; ++b)
	{
		for(int a = 0; a < [self numberOfColumns]; ++a)
		{			
			// number of living neighbors stored in life
			for (int n; n < 8; ++n)
			{
				if([[[self cellAtRow:b column:a] getNeighbor: n] getLife] == 1)
				{
					[[self cellAtRow:b column:a] addLiveNeighbors];
				}
			}
		}
	}
}

-(void)updateLiveNeighbors
{
	for(int i = 0; i < [self numberOfColumns]; ++i)
	{
		for(int k = 0; k < [self numberOfRows]; ++k)
		{
			[[self cellAtRow:k column:i] resetLiveNeighbors];
			for(int n = 0; n < 8; ++n)
			{
				if([[[self cellAtRow:k column:i] getNeighbor: n] getLife] == 1)
				{
					[[self cellAtRow:k column:i] addLiveNeighbors];
				}
			}
		}
	}
}

-(void)calcNextLife
{
	for (int i = 0; i < [self numberOfRows]; ++i)
    {
        for (int k = 0; k < [self numberOfColumns]; ++k)
        {
			[[self cellAtRow:i column:k] changeLife: [[self cellAtRow: i column:k] getNextLife]];
		}
	}
	
	[self updateLiveNeighbors];
	
	for (int i = 0; i < [self numberOfRows]; ++i)
    {
        for (int k = 0; k < [self numberOfColumns]; ++k)
        {
            if([[self cellAtRow:i column:k] getLiveNeighbors] == 3)
            {
                [[self cellAtRow:i column:k] changeNextLife: 1];
            }
            if([[self cellAtRow:i column:k] getLife] == 1)
            {
                if([[self cellAtRow:i column:k] getLiveNeighbors] == 2 || [[self cellAtRow:i column:k] getLiveNeighbors] == 3)
                {
                    [[self cellAtRow:i column:k] changeNextLife: 1];
                } else 
				{
                    [[self cellAtRow:i column:k] changeNextLife: 0];
                }
			}
		}
	}
}
	


@end
