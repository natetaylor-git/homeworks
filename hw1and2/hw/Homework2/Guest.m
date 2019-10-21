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

@interface Guest ()

@property NSInteger money;
@property NSInteger numOfDishesCheck;
@property BOOL mood;

-(NSMutableArray *)createOrder : (NSDictionary *) menu;
-(void)readyToOrder:(NSMutableArray *) order;

@end

@implementation Guest

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = @"Alexey";
        NSInteger luckChance = 10;
        if (arc4random_uniform((uint32_t)luckChance))
        {
            self.mood = YES;
        }
        [self addObserver:self forKeyPath:@"numOfDishesCheck" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"numOfDishesCheck"]) {
        NSInteger newValue = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        if (newValue == 0)
        {
            NSLog(@"[%@] I ate all food", self.name);
            [self payTip];
        }
    }
}

-(void)visitRestaurant:(Waiter *) waiterAsDelegate
{
    self.delegate = waiterAsDelegate;
    [self.delegate serveGuest:self];

    NSLog(@"[%@] Hi there! Boss is inda restaurant!", self.name);
    NSDictionary *menu = [self.delegate giveMenu];
    
    NSMutableArray *order = [self createOrder:menu];
    [self readyToOrder:order];
}

-(void)readyToOrder:(NSMutableArray *) order
{
    [self printOrder:order];
    self.numOfDishesCheck = order.count;
    [self.delegate sendOrderToKitchen:order];
}

-(NSMutableArray *)createOrder : (NSDictionary *) menu
{
    uint32_t menuLength = (uint32_t)[menu allKeys].count;
    uint32_t numItemsInOrder = 1+arc4random_uniform(menuLength);
    
    NSMutableArray *order = [NSMutableArray arrayWithArray:[menu allKeys]];

    for (NSInteger i=0; i<menuLength-numItemsInOrder; i++)
    {
        NSInteger indxItemToRemove = arc4random_uniform((uint32_t)order.count);
        [order removeObjectAtIndex:indxItemToRemove];
    }
    
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

-(void)getDish:(NSString *)dish
{
    NSLog(@"[%@] %@ is so yummy!", self.name, dish);
    self.numOfDishesCheck --;
}

-(void)payTip
{
    if (self.mood)
    {
        NSLog(@"[%@] U are breathtaking! Take a tip, please.", self.name);
        uint32_t tipValue = 11+arc4random_uniform(90);
        [self.delegate getTip:(NSInteger)tipValue];
    }
    else
    {
        NSLog(@"[%@] It's not my day.. maybe I will thank him next time", self.name);
    }
}

@end
