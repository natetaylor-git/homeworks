//
//  Guest.m
//  hw
//
//  Created by nate.taylor_macbook on 29/09/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

#import "Guest.h"
#import "Waiter.h"
#import "stdlib.h"

@implementation Guest

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = @"Alexey";
    }
    return self;
}

-(void)cameToRestaurant:(Waiter *) waiter
{
    self.delegate = waiter;
    [self.delegate serveGuest:self];

    NSLog(@"[%@] Hi there! Boss is inda restaurant!", self.name);
    NSDictionary *menu = [self.delegate giveMenu];
    
    NSMutableArray *order = [self createOrder:menu];
    [self readyToOrder:order];
}

-(void)readyToOrder:(NSMutableArray *) order
{
    [self printOrder:order];
    [self.delegate sendOrderToKitchen:order];
}

-(NSMutableArray *)createOrder : (NSDictionary *) menu
{
    uint32_t menuLength = (uint32_t)[menu allKeys].count;
    uint32_t numItemsInOrder = 1+arc4random_uniform(menuLength);
    
//    NSLog(@"jjj %d %d", numItemsInOrder, menuLength);
    
    NSMutableArray *order = [NSMutableArray arrayWithArray:[menu allKeys]];
    
//    NSLog(@"start %ld", order.count);
    for (NSInteger i=0; i<menuLength-numItemsInOrder; i++)
    {
        NSInteger indxItemToRemove = arc4random_uniform((uint32_t)order.count);
        [order removeObjectAtIndex:indxItemToRemove];
//        NSLog(@"%ld %ld", order.count, (long)indxItemToRemove);
    }
  
//    for(NSNumber * obj in order)
//    {
//        NSLog(@"%@", obj);
//    }
//
//    NSLog(@"OK");
    
    return order;
}

-(void)printOrder : (NSMutableArray *) order
{
    NSLog(@"[%@] I want the following:", self.name);
    for(NSString* orderItem in order)
    {
        NSLog(@"%@", orderItem);
    }
}

-(void)receiveDishes:(NSArray *)packOfDishes
{
    for(NSString* dish in packOfDishes)
    {
        NSLog(@"%@ is so yummy!", dish);
    }
}
@end
