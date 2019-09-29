//
//  Homework2.m
//  hw
//
//  Created by nate.taylor_macbook on 29/09/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

#import "Homework2.h"
#import "Guest.h"
#import "Waiter.h"

@implementation Homework2

-(void)doTask
{
    Waiter *waiter1 = [Waiter new];
    Guest *guest1 = [Guest new];
    
    [guest1 visitRestaurant:waiter1];
}

@end
