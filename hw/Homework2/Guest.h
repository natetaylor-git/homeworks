//
//  Guest.h
//  hw
//
//  Created by nate.taylor_macbook on 29/09/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WaiterProtocol.h"

@interface Guest : NSObject

@property (nonatomic, weak) id <WaiterProtocol> delegate;
@property NSString *name;

-(void)visitRestaurant: (id) waiter;
-(NSMutableArray *)createOrder : (NSDictionary *) menu;
-(void)readyToOrder:(NSMutableArray *) order;
-(void)getDish:(NSString *)dish;

@end

