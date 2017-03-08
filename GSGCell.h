//
//  GSGCell.h
//  GSGPrototypeCell
//
//  Created by Mark Canwell on 08/03/2017.
//  Copyright © 2017 GSG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSGCell : UIView

#pragma mark - SHAPE DRAWING PROPERTIES
// MAIN PATHS
@property (strong, nonatomic) UIBezierPath *path;                       //the path created through the array of points
@property (strong, nonatomic) NSMutableArray *arrayOfMasterControlPointsForPath;     //the array of Points for the path
@property (strong, nonatomic) UILabel *cellTitle;                       //a unit Label

@property (nonatomic) CGRect boundingBox;                               //A variable CGRect bounding the path
@property (nonatomic) CGPoint centreInCell;                             //centre point of Cell
@property (nonatomic) CGPoint shapeOriginPointInView;                   //A coordinate for origin  point of shape in rect




@end
