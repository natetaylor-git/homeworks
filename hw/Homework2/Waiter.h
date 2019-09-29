//
//  Waiter.h
//  hw
//
//  Created by nate.taylor_macbook on 29/09/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WaiterProtocol.h"


@interface Waiter : NSObject <WaiterProtocol>

@property NSDictionary *menu;

@end

