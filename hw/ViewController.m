//
//  ViewController.m
//  hw
//
//  Created by nate.taylor_macbook on 26/09/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

#import "ViewController.h"
#import "Homework1.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    Homework1 *task = [Homework1 new];
    [task processNumArray];
}


@end
