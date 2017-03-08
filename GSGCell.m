//
//  GSGCell.m
//  GSGPrototypeCell
//
//  Created by Mark Canwell on 08/03/2017.
//  Copyright © 2017 GSG. All rights reserved.
//
#define kHalf 0.5

#import "GSGCell.h"

@implementation GSGCell


#pragma mark - View Initialisation

-(id) initWithFrame:(CGRect) unitFrame {
    
    NSLog(@"0. INIT WITH FRAME CALL");
    
    
    self = [super initWithFrame:unitFrame];
    
    if(self)
    {
        [self initialiseCellPath];
        [self createCellTitle];
        [self setUpBackgroundColor];
    }
    return self;
}



#pragma mark - CELL SET UP Functions ===================================================

-(void) initialiseCellPath {
    
    NSLog(@"0. INITIALISE UNIT SHAPE 1");
    
    // 1. initialise an array of CGPoints from Data, around passed in Central Point, set as the centre of the view - OPTIMISE CGPOINTZERO
    NSMutableArray* arrayOfPointsFromData = [[self initialiseUnitShapeWithArrayOfPointsAroundCentrePoint:CGPointZero] mutableCopy];
    
    // 2. initialise a bezier curve to be drawn:
    UIBezierPath* anOutlinePath = [self interpolateHermiteCurveFromArrayOfCGPoints:arrayOfPointsFromData closed:YES];
    
    // 3. create a rect and set it to be the box bounding the path
    self.boundingBox = anOutlinePath.bounds;
    
    // 4. create a new origin point for drawing the bounding box based on the origin of the bounding box
    self.shapeOriginPointInView = [self createNewOriginPoint:self.boundingBox];
    
    // 5. Initialise the array of CGPoints For the Path around the new Central Point
    self.arrayOfMasterControlPointsForPath = [[self initialiseUnitShapeWithArrayOfPointsAroundCentrePoint:self.shapeOriginPointInView] mutableCopy];
    
    // 6. Initialise the bezier curve to be drawn:
    self.path = [self interpolateHermiteCurveFromArrayOfCGPoints:self.arrayOfMasterControlPointsForPath closed:YES];
    
    //self.centreInCell = [self rectGetCenter:self.boundingBox];
    self.centreInCell = [self rectGetCenter:self.path.bounds];
    

    
}

-(void) createCellTitle {
    
    self.cellTitle = [[UILabel alloc]init];
    self.cellTitle.center = self.centreInCell;
    self.cellTitle.frame = self.path.bounds;
    self.cellTitle.font = [UIFont fontWithName:@"courier" size:20];
    self.cellTitle.textColor = [UIColor blackColor];
    self.cellTitle.text = @"Cell A";
    self.cellTitle.textAlignment = NSTextAlignmentCenter;
    self.cellTitle.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.cellTitle];
    
}

-(void) setUpBackgroundColor {

    self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1];
}

-(CGPoint) createNewOriginPoint:(CGRect) boundingBox {
    
    CGPoint aNewOrigin;
    
    aNewOrigin.x = -boundingBox.origin.x;
    aNewOrigin.y = -boundingBox.origin.y;
    
    return aNewOrigin;
    
}

-(UIBezierPath *)interpolateHermiteCurveFromArrayOfCGPoints:(NSArray *)pointsAsNSValues closed:(BOOL)closed {
    
    if (pointsAsNSValues.count < 2) return nil;
    
    NSInteger nCurves = (closed ? pointsAsNSValues.count : pointsAsNSValues.count-1);
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // for the number of curves
    for (NSInteger counter=0; counter < nCurves; ++counter)
    {
        NSValue *value  = pointsAsNSValues[counter];
        CGPoint currentPoint, previousPoint, nextPoint, endPt;
        [value getValue:&currentPoint];
        if (counter==0) [path moveToPoint:currentPoint];
        
        NSInteger nextcounter = (counter+1)%pointsAsNSValues.count;
        NSInteger prevcounter = (counter-1 < 0 ? pointsAsNSValues.count-1 : counter-1);
        [pointsAsNSValues[prevcounter] getValue:&previousPoint];
        [pointsAsNSValues[nextcounter] getValue:&nextPoint];
        endPt = nextPoint;
        
        CGFloat mx, my;
        if (closed || counter > 0) {
            mx = (nextPoint.x - currentPoint.x)*kHalf + (currentPoint.x - previousPoint.x)*kHalf;
            my = (nextPoint.y - currentPoint.y)*kHalf + (currentPoint.y - previousPoint.y)*kHalf;
        }
        else {
            mx = (nextPoint.x - currentPoint.x)*kHalf;
            my = (nextPoint.y - currentPoint.y)*kHalf;
        }
        CGPoint ctrlPt1;
        ctrlPt1.x = currentPoint.x + mx / 3.0;
        ctrlPt1.y = currentPoint.y + my / 3.0;
        
        [pointsAsNSValues[nextcounter] getValue:&currentPoint];
        
        nextcounter = (nextcounter+1)%pointsAsNSValues.count;
        prevcounter = counter;
        
        [pointsAsNSValues[prevcounter] getValue:&previousPoint];
        [pointsAsNSValues[nextcounter] getValue:&nextPoint];
        
        if (closed || counter < nCurves-1) {
            mx = (nextPoint.x - currentPoint.x)*kHalf + (currentPoint.x - previousPoint.x)*kHalf;
            my = (nextPoint.y - currentPoint.y)*kHalf + (currentPoint.y - previousPoint.y)*kHalf;
        }
        else {
            mx = (currentPoint.x - previousPoint.x)*kHalf;
            my = (currentPoint.y - previousPoint.y)*kHalf;
        }
        
        CGPoint ctrlPt2;
        ctrlPt2.x = currentPoint.x - mx / 3.0;
        ctrlPt2.y = currentPoint.y - my / 3.0;
        
        [path addCurveToPoint:endPt controlPoint1:ctrlPt1 controlPoint2:ctrlPt2];
    }
    
    if (closed) [path closePath];
    
    return path;
}

-(NSArray*) initialiseUnitShapeWithArrayOfPointsAroundCentrePoint: (CGPoint) p {
    
    
    NSMutableArray* arrayOfPoints = [@[]mutableCopy];
    
    
    // add the CGPoints to an array
    [arrayOfPoints addObject:[NSValue valueWithCGPoint:CGPointMake(p.x+50,  p.y-120)]];
    [arrayOfPoints addObject:[NSValue valueWithCGPoint:CGPointMake(p.x+105, p.y-35)]];
    [arrayOfPoints addObject:[NSValue valueWithCGPoint:CGPointMake(p.x+90,  p.y+40)]];
    [arrayOfPoints addObject:[NSValue valueWithCGPoint:CGPointMake(p.x+50,  p.y+90)]];
    [arrayOfPoints addObject:[NSValue valueWithCGPoint:CGPointMake(p.x-50,  p.y+85)]];
    [arrayOfPoints addObject:[NSValue valueWithCGPoint:CGPointMake(p.x-95, p.y+40)]];
    [arrayOfPoints addObject:[NSValue valueWithCGPoint:CGPointMake(p.x-90, p.y-55)]];
    [arrayOfPoints addObject:[NSValue valueWithCGPoint:CGPointMake(p.x-60,  p.y-120)]];

    return arrayOfPoints;
    
}



#pragma mark - CELL DRAW Functions ===================================================

-(void) drawPath:(UIBezierPath*) path
      WithColour:(UIColor*)color
       lineWidth:(float) width
      dashLength:(int) length
    patternCount:(int) count
    patternPhase:(int) phase {
    
    [color setStroke];
    path.lineWidth = width;
    CGFloat dashedConnectorsPattern[] = {length, length, length, length};
    [path setLineDash: dashedConnectorsPattern count: count phase: phase];
    [path stroke];
    
}

//draw array of control points
-(void) drawACircleAt:(CGPoint) aPoint
          withAColour:(UIColor*) color
            andRadius:(int) radius {
    
    //Draw a Control Point in centre of the rectangle:
    UIBezierPath *controlPoint = [UIBezierPath bezierPathWithArcCenter: aPoint
                                                                radius: radius
                                                            startAngle: 0
                                                              endAngle: M_PI *2 //360degrees in Radians
                                                             clockwise: TRUE] ;
    
    [color setFill];
    [controlPoint fill];

    
}
//draw all the control points for Debug
-(void) drawControlPoints {
    
    for (NSValue *aCGPoint in self.arrayOfMasterControlPointsForPath)
    {
        [self drawACircleAt:[aCGPoint CGPointValue] withAColour:[UIColor redColor] andRadius:3];

    }

}


-(CGPoint) rectGetCenter:(CGRect) rect {
    
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}


-(void) drawRectBoundary:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context,[UIColor redColor].CGColor);
    CGContextAddRect(context, rect);
    CGContextStrokePath(context);

    
}


- (void)drawRect:(CGRect)rect {
    
    // 1. DRAW BOUNDING BOX ===============================================
    [self drawRectBoundary:self.bounds];
    [self drawPath:self.path WithColour:[UIColor redColor] lineWidth:1.0 dashLength:1 patternCount:1 patternPhase:1];
    [self drawControlPoints];
    
}


@end
