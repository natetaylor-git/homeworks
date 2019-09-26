//
//  Homework1.m
//  hw
//
//  Created by nate.taylor_macbook on 26/09/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

#import "Homework1.h"


/**
 Class for completing tasks of the first homework
 */
@implementation Homework1

- (instancetype)init
{
    self = [super init];
    if (self) {
        numbers = [NSMutableArray arrayWithObjects: @(3), @(6), @(32), @(24), @(81), nil];
    }
    return self;
}

/**
 Method for array sort and filtration (task 1)
 */
-(void)processNumArray
{
    NSMutableArray *copyNumbers = [NSMutableArray arrayWithArray:numbers];
    [self myQuickSortWithLeft:0 andRight:(int)numbers.count-1];
//    [self builtInSort:YES];
    [self filterGreater20];
    [self filterMulOf3];
    [numbers addObjectsFromArray:copyNumbers];
    [self builtInSort:NO];
    [self printNumArray];
}

-(void)builtInSort:(BOOL)asc
{
    NSSortDescriptor *desc = [[NSSortDescriptor alloc] initWithKey:nil ascending:asc];
    [numbers sortUsingDescriptors:[NSArray arrayWithObject:desc]];
}

-(void)myQuickSortWithLeft:(int)l andRight:(int)r
{
    //NSLog(@"l=%d r=%d",l,r);
    if (l<r)
    {
        NSNumber *separator = numbers[(l+r)/2];
        //NSLog(@"sep = %@", separator);
        int i = l;
        int j = r;
        while (i<=j)
        {
            while ([numbers[i] compare:separator] == NSOrderedAscending)
            {
                i++;
            }
            while ([numbers[j] compare:separator] == NSOrderedDescending)
            {
                j--;
            }
            if (i<=j)
            {
                NSNumber *temp = numbers[i];
                [numbers replaceObjectAtIndex:i withObject:numbers[j]];
                [numbers replaceObjectAtIndex:j withObject:temp];
                i++;
                j--;
            }
        }
        [self myQuickSortWithLeft:l andRight:j];
        [self myQuickSortWithLeft:i andRight:r];
    }
}

-(void)filterGreater20
{
    for(int i=0; i<numbers.count; i++)
    {
        if ([numbers[i] intValue] <= 20)
        {
            [numbers removeObjectAtIndex:i];
            i--;
        }
    }
}

-(void)filterMulOf3
{
    for(int i=0; i<numbers.count; i++)
    {
        if ([numbers[i] intValue] % 3 != 0)
        {
            [numbers removeObjectAtIndex:i];
            i--;
        }
    }
}

-(void)processStrArray
{
    
}

-(void)printNumArray
{
    for(NSObject *object in numbers)
    {
        NSLog(@"%@", object);
    }
}

@end
