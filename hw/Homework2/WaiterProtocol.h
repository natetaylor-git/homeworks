//
//  WaiterProtocol.h
//  hw
//
//  Created by nate.taylor_macbook on 29/09/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

@protocol WaiterProtocol <NSObject>

-(void)serveGuest:(id) newGuest;
-(NSDictionary *)giveMenu;
-(void)sendOrderToKitchen: (NSMutableArray *)order;
-(void)deliverToGuest:(NSString*)dish;
-(void)getTip:(NSInteger)someMoney;

@optional
-(void)knowAbout:(NSString *)something;
//-(void)sendOrderToKitchen;
//-(void)sendOrderToGuest;
//
//@optional
//-(void)increaseTip;

@end
