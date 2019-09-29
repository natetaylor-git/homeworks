//
//  Waiter.m
//  hw
//
//  Created by nate.taylor_macbook on 29/09/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

#import "Waiter.h"
#import "Kitchen.h"
#import "Guest.h"

@interface Waiter ()

@property (nonatomic, strong) Kitchen *kitchen;
@property (nonatomic, strong) Guest *guest;

@end

@implementation Waiter

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.menu = @{
                      @"Noodles" : @(350),
                      @"Steak" : @(575),
                      @"Apple Juice" : @(100),
                      };
        self.nameForPrint = @"Waiter";
        self.kitchen = [Kitchen new];
        self.kitchen.delegate = self;
    }
    return self;
}

-(void)serveGuest: (Guest *) newGuest
{
    self.guest = newGuest;
}

-(NSDictionary *)giveMenu
{
    NSLog(@"[%@] Your menu, please =)", self.nameForPrint);
    [self printMenu];
    NSLog(@"[%@] What would u like?", self.nameForPrint);
    return self.menu;
}

-(void)sendOrderToKitchen:(NSMutableArray *)order
{
    NSLog(@"[%@] Fine, I will take it to our kitchen, wait a little, please.. "
          "In the meantime, you could check some homeworks of your students", self.nameForPrint);
    [self.kitchen receiveOrder:order];
}

-(void)printMenu
{
    NSLog(@"=======MENU=======");
    for(NSString *key in [self.menu allKeys]) {
        NSLog(@"%@ - %@",key, [self.menu objectForKey:key]);
    }
    NSLog(@"==================");
}

-(void)deliverToGuest:(NSArray *)packOfDishes
{
    NSLog(@"sending");
    [self.guest receiveDishes:packOfDishes];
}

-(void)knowAbout:(NSString *)something
{
    NSLog(@"[Waiter] I know that %@", something);
}

@end
