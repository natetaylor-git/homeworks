//
//  Homework1.m
//  hw
//
//  Created by nate.taylor_macbook on 26/09/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

#import "Homework1.h"

@interface Homework1()

/**
 Array of numbers given for the first task (see init method)
 */
@property NSMutableArray *numbers;

/**
 Array of strings given for the second task (see init method)
 */
@property NSArray *strings;

@end

@implementation Homework1

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.numbers = [NSMutableArray arrayWithObjects: @(3), @(6), @(32), @(24), @(81), nil];
        self.strings = [NSArray arrayWithObjects: @"cataclism", @"catepillar", @"cat", @"teapot", @"truncate", nil];
    }
    return self;
}

-(void)processNumArray
{
    NSMutableArray *copyNumbers = [NSMutableArray arrayWithArray:self.numbers];
    [self myQuickSortWithLeft:0 andRight:(int)self.numbers.count-1];
//    [self builtInSort:YES];
    [self filterGreater20];
    [self filterMulOf3];
    [self.numbers addObjectsFromArray:copyNumbers];
    [self builtInSort:NO];
    [self printArray:self.numbers];
}

-(void)processStrArray
{
    NSString *word = @"cat";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", word];
    NSArray *filteredStrings = [self.strings filteredArrayUsingPredicate:predicate];
    
    [self printArray:filteredStrings];
    
    NSMutableDictionary *wordsAndLetters = [NSMutableDictionary new];
    for (NSString *str in filteredStrings)
    {
        //old version
        //[wordsAndLetters setObject:[NSNumber numberWithInteger:[str length]] forKey: str];
        wordsAndLetters[str] = @(str.length);
    }
    
    //[self printDictionary:wordsAndLetters];
}

-(void)builtInSort:(BOOL)asc
{
    NSSortDescriptor *desc = [[NSSortDescriptor alloc] initWithKey:nil ascending:asc];
    [self.numbers sortUsingDescriptors:[NSArray arrayWithObject:desc]];
}

-(void)myQuickSortWithLeft:(int)l andRight:(int)r
{
    //NSLog(@"l=%d r=%d",l,r);
    if (l<r)
    {
        NSNumber *separator = self.numbers[(l+r)/2];
        //NSLog(@"sep = %@", separator);
        int i = l;
        int j = r;
        while (i<=j)
        {
            while ([self.numbers[i] compare:separator] == NSOrderedAscending)
            {
                i++;
            }
            while ([self.numbers[j] compare:separator] == NSOrderedDescending)
            {
                j--;
            }
            if (i<=j)
            {
                NSNumber *temp = self.numbers[i];
                [self.numbers replaceObjectAtIndex:i withObject:self.numbers[j]];
                [self.numbers replaceObjectAtIndex:j withObject:temp];
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
    for(int i=0; i<self.numbers.count; i++)
    {
        if ([self.numbers[i] intValue] <= 20)
        {
            [self.numbers removeObjectAtIndex:i];
            i--;
        }
    }
}

-(void)filterMulOf3
{
    for(int i=0; i<self.numbers.count; i++)
    {
        if ([self.numbers[i] intValue] % 3 != 0)
        {
            [self.numbers removeObjectAtIndex:i];
            i--;
        }
    }
}

-(void)printArray:(id)arr
{
    for(NSObject *object in arr)
    {
        NSLog(@"%@", object);
    }
}

-(void)printDictionary:(NSMutableDictionary *)dict
{
    for(NSString *key in [dict allKeys]) {
        NSLog(@"%@ %@",key, [dict objectForKey:key]);
    }
}

@end
