//
//  BezierPathView.m
//  DropIt
//
//  Created by Dishant Kapadiya on 8/26/16.
//  Copyright © 2016 Dishant Kapadiya. All rights reserved.
//

#import "BezierPathView.h"

@implementation BezierPathView


-(void)setPath:(UIBezierPath *)path
{
    _path = path;
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    [self.path stroke];
}

@end
