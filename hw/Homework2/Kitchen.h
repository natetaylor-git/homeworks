//
//  Kitchen.h
//  hw
//
//  Created by nate.taylor_macbook on 29/09/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WaiterProtocol.h"

/**
 class for kitchen object that cooks dishes for guest
 */
@interface Kitchen : NSObject

/**
 used by kitchen to receive order and send cooked dishes
 */
@property (nonatomic, weak) id <WaiterProtocol> delegate;

/**
 called by Waiter to send order to Kitchen

 @param order order from guest with NSString names of dishes from menu
 */
-(void)receiveOrder:(NSMutableArray *)order;

@end

