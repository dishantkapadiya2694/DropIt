//
//  boxBehavior.h
//  DropIt
//
//  Created by Dishant Kapadiya on 8/24/16.
//  Copyright © 2016 Dishant Kapadiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoxBehavior : UIDynamicBehavior

-(void)addItem:(id <UIDynamicItem>)item;
-(void)removeItem:(id <UIDynamicItem>)item;

@end
