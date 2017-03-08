//
//  ViewController.m
//  GSGPrototypeCell
//
//  Created by Mark Canwell on 08/03/2017.
//  Copyright © 2017 GSG. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //initialise a shape
    [self createCellCentredOnSuperViewCoordinate:CGPointMake(self.view.center.x, self.view.center.y)];

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)createCellCentredOnSuperViewCoordinate : (CGPoint) superViewCoordinate {
    
    self.myCell = [[GSGCell alloc]init];
    self.myCell.frame = self.myCell.boundingBox;
    self.myCell.center = superViewCoordinate;
    self.myCell.cellTitle.hidden = NO;

    [self.view addSubview:self.myCell];

    
}





@end
