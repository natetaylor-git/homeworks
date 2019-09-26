//
//  Homework1.h
//  hw
//
//  Created by nate.taylor_macbook on 26/09/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Homework1 : NSObject
{
    NSMutableArray *numbers;
    NSArray *strings;
}

-(void)processNumArray;
-(void)processStrArray;

-(void)myQuickSortWithLeft:(int)l andRight:(int)r;
-(void)builtInSort:(BOOL)asc;
-(void)filterGreater20;
-(void)filterMulOf3;

-(void)printArray:(id)arr;
-(void)printDictionary:(NSMutableDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
