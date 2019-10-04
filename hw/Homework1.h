//
//  Homework1.h
//  hw
//
//  Created by nate.taylor_macbook on 26/09/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Class for completing tasks of the first homework
 */
@interface Homework1 : NSObject

/**
 Method for array sort and filtration (task 1)
 */
-(void)processNumArray;

/**
 Method for string array filtration and creation of dictionary based on letters amount (task 2)
 */
-(void)processStrArray;

/**
 Implementation of QuickSort algorithm
 
 @param l left border of array being processed
 @param r right border
 */
-(void)myQuickSortWithLeft:(int)l andRight:(int)r;

/**
 Sort method implemented with the use of NSSortDescriptor
 
 @param asc bool parameter(YES if ascending order is needed and NO for descending)
 */
-(void)builtInSort:(BOOL)asc;

/**
 Methods for filtering number array
 */
-(void)filterGreater20;
-(void)filterMulOf3;

/**
 Methods for printing collections
 
 @param arr array of numbers or strings in this homework
 */
-(void)printArray:(id)arr;
-(void)printDictionary:(NSMutableDictionary *)dict;
@end
