//
//  boxBehavior.m
//  DropIt
//
//  Created by Dishant Kapadiya on 8/24/16.
//  Copyright © 2016 Dishant Kapadiya. All rights reserved.
//

#import "BoxBehavior.h"

@interface BoxBehavior()
@property (strong, nonatomic) UIGravityBehavior *gravity;
@property (strong, nonatomic) UICollisionBehavior *collision;
@property (strong, nonatomic) UIDynamicItemBehavior *animationProperties;
@end


@implementation BoxBehavior

-(instancetype)init
{
    self = [super init];
    [self addChildBehavior:self.gravity];
    [self addChildBehavior:self.collision];
    [self addChildBehavior:self.animationProperties];
    return self;
}

-(UIDynamicItemBehavior *)animationProperties
{
    if(!_animationProperties)
    {
        _animationProperties = [[UIDynamicItemBehavior alloc] init];
        _animationProperties.allowsRotation = NO;
    }
    return _animationProperties;
}

-(UIGravityBehavior *)gravity
{
    if(!_gravity)
    {
        _gravity = [[UIGravityBehavior alloc] init];
        _gravity.magnitude = 1.0;
    }
    return _gravity;
}

-(UICollisionBehavior *)collision
{
    if(!_collision)
    {
        _collision = [[UICollisionBehavior alloc] init];
        _collision.translatesReferenceBoundsIntoBoundary = YES;
    }
    return _collision;
}

-(void)addItem:(id<UIDynamicItem>)item
{
    [self.gravity addItem:item];
    [self.collision addItem:item];
    [self.animationProperties addItem:item];
}

-(void)removeItem:(id<UIDynamicItem>)item
{
    [self.gravity removeItem:item];
    [self.collision removeItem:item];
    [self.animationProperties removeItem:item];
}

@end
