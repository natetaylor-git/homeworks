//
//  ViewController.m
//  hw
//
//  Created by nate.taylor_macbook on 26/09/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

#import "ViewController.h"
#import "Homework1.h"
#import "Homework2/Homework2.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    Homework1 *taskHW1 = [Homework1 new];
//    NSLog(@"---First Task---");
//    [taskHW1 processNumArray];
//    NSLog(@"---Second Task---");
//    [taskHW1 processStrArray];
    
    Homework2 *taskHW2 = [Homework2 new];
    [taskHW2 doTask];
}


@end
