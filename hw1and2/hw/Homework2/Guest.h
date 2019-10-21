//
//  Guest.h
//  hw
//
//  Created by nate.taylor_macbook on 29/09/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WaiterProtocol.h"

/**
 class for guest object that orders and gets cooked dishes
 uses waiter as delegate
 */
@interface Guest : NSObject

/**
 waiter object that does some operations like taking order and bringing dishes
 */
@property (nonatomic, weak) id <WaiterProtocol> delegate;

/**
 name of the guest not used by any other object but can be some day
 */
@property NSString *name;


/**
 start point for whole process, it calls methods for order creation

 @param waiterAsDelegate waiter object that will serve guest operations (will be delegate)
 */
-(void)visitRestaurant: (id) waiterAsDelegate;

/**
 guest receives cooked dish from waiter
 decreases number of eaten dishes to know when to leave restaurant, called by waiter

 @param dish name of the dish that waiter brings
 */
-(void)getDish:(NSString *)dish;

@end

