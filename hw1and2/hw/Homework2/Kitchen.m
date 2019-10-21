//
//  Kitchen.m
//  hw
//
//  Created by nate.taylor_macbook on 29/09/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

#import "Kitchen.h"

@interface Kitchen ()

@property NSDictionary *cookbook;

-(void)startCooking: (NSString *)dish;
-(void)finishedCooking:(NSString *)dish;

@end

@implementation Kitchen

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cookbook = @{
                          @"Noodles" : @[@"chicken bouillon", @"champignon", @"parsley"],
                          @"Steak" : @[@"beef", @"salt", @"pepper"],
                          @"Apple Juice" : @[@"apples",@"sugar"],
                          };
    }
    return self;
}

-(void)receiveOrder:(NSArray *)order
{
    for(NSString *menuItem in order)
    {
        if ([[self.cookbook allKeys] containsObject:menuItem])
        {
            [self startCooking:menuItem];
            [self finishedCooking:menuItem];
        }
    }
}

-(void)startCooking:(NSString *)dish
{
    NSLog(@">>> attention! cooking process <<<");
    for(NSString *ingredient in self.cookbook[dish])
    {
        NSLog(@"preparing %@", ingredient);
    }
    [self.delegate knowAbout:[dish stringByAppendingString:@" is ready!"]];
}

-(void)finishedCooking:(NSString *)dish
{
    [self.delegate deliverToGuest:dish];
}
@end
