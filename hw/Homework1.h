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
}

-(void)printNumArray;

-(void)processNumArray;
-(void)myQuickSortWithLeft:(int)l
                  andRight:(int)r;
-(void)builtInSort:(BOOL)asc;
-(void)filterGreater20;
-(void)filterMulOf3;

-(void)processStrArray;

@end

NS_ASSUME_NONNULL_END
