//
//  ViewController.m
//  DropIt
//
//  Created by Dishant Kapadiya on 8/24/16.
//  Copyright © 2016 Dishant Kapadiya. All rights reserved.
//

#import "ViewController.h"
#import "BoxBehavior.h"
#import "BezierPathView.h"


@interface ViewController () <UIDynamicAnimatorDelegate>
@property (weak, nonatomic) IBOutlet BezierPathView *gameView;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) BoxBehavior *boxBehavior;
@property (strong, nonatomic) UIAttachmentBehavior *attachment;
@property (strong, nonatomic) UIView *fallingBox;
@end

@implementation ViewController

-(BoxBehavior *)boxBehavior
{
    if(!_boxBehavior){
        _boxBehavior = [[BoxBehavior alloc] init];
        [self.animator addBehavior:_boxBehavior];
    }
    return _boxBehavior;
}

-(UIDynamicAnimator *)animator
{
    if(!_animator){
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.gameView];
        _animator.delegate = self;
    }
    return _animator;
}

-(void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    [self removeCompletedRows];
}

- (BOOL)removeCompletedRows
{
    NSMutableArray *dropsToRemove = [[NSMutableArray alloc] init];
    
    for (CGFloat y = self.gameView.bounds.size.height-[self sizeOfBoxes].height/2; y > 0; y -= [self sizeOfBoxes].height)
    {
        BOOL rowIsComplete = YES;
        NSMutableArray *dropsFound = [[NSMutableArray alloc] init];
        for (CGFloat x = [self sizeOfBoxes].width/2; x <= self.gameView.bounds.size.width-[self sizeOfBoxes].width/2; x += [self sizeOfBoxes].width)
        {
            UIView *hitView = [self.gameView hitTest:CGPointMake(x, y) withEvent:NULL];
            if ([hitView superview] == self.gameView) {
                [dropsFound addObject:hitView];
            } else {
                rowIsComplete = NO;
                break;
            }
        }
        if (![dropsFound count]) break;
        if (rowIsComplete) [dropsToRemove addObjectsFromArray:dropsFound];
    }
    
    if ([dropsToRemove count]) {
        for (UIView *drop in dropsToRemove) {
            [self.boxBehavior removeItem:drop];
        }
        [self animateRemovingDrops:dropsToRemove];
        return YES;
    }
    
    return NO;
}

- (void)animateRemovingDrops:(NSArray *)dropsToRemove
{
    [UIView animateWithDuration:0.5 animations:^{
        for (UIView *drop in dropsToRemove) {
            int x = (arc4random()%(int)(self.gameView.bounds.size.width*5)) - (int)self.gameView.bounds.size.width*2;
            int y = self.gameView.bounds.size.height;
            drop.center = CGPointMake(x, -y);
        }
    }
                     completion:^(BOOL finished) {
                         [dropsToRemove makeObjectsPerformSelector:@selector(removeFromSuperview)];
                     }];
}

static const int numberOfBox = 7;

-(CGSize)sizeOfBoxes
{
    CGSize size = {self.view.bounds.size.width/numberOfBox, self.view.bounds.size.width/numberOfBox};
    return size;
}

- (IBAction)pan:(UIPanGestureRecognizer *)sender {
    CGPoint gestureAnchor = [sender locationInView:self.gameView];
    if(sender.state == UIGestureRecognizerStateBegan) {
        [self attachFallingBoxToAttachmentBehavior:gestureAnchor];
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        self.attachment.anchorPoint = gestureAnchor;
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        [self.animator removeBehavior:self.attachment];
        self.gameView.path = nil;
    }
}


-(void)attachFallingBoxToAttachmentBehavior:(CGPoint)location
{
    if(self.fallingBox){
        self.attachment = [[UIAttachmentBehavior alloc] initWithItem:self.fallingBox attachedToAnchor:location];
        __weak ViewController *weakSelf = self;
        self.attachment.action = ^{
            UIBezierPath *path = [[UIBezierPath alloc] init];
            [path moveToPoint:weakSelf.attachment.anchorPoint];
            [path addLineToPoint:weakSelf.fallingBox.center];
            weakSelf.gameView.path = path;
        };
        [self.animator addBehavior:self.attachment];
    }
}

- (IBAction)tap:(UITapGestureRecognizer *)sender {
    [self dropAt:[sender locationInView:self.gameView]];
}


-(void)dropAt:(CGPoint)point
{
    CGRect frame;
    frame.origin = CGPointZero;
    CGSize boxSize = [self sizeOfBoxes];
    frame.size = boxSize;
    
    //int colForBox = arc4random() % (int)(self.view.bounds.size.width/boxSize.width);
    int colForBox = (int)point.x * numberOfBox / self.view.bounds.size.width;
    //NSLog([NSString stringWithFormat:@"%d / %d = %d",(int)point.x * numberOfBox, (int)self.view.bounds.size.width, colForBox]);
    int xPosForBox = colForBox * boxSize.width;
    frame.origin.x = xPosForBox;
    
    UIView *box = [[UIView alloc] initWithFrame:frame];
    box.backgroundColor = [self randomColor];
    [self.gameView addSubview:box];
    self.fallingBox = box;
    [self.boxBehavior addItem:box];
}

-(UIColor *)randomColor
{
    switch(arc4random()%5)
    {
        case 0: return [UIColor redColor];
        case 1: return [UIColor orangeColor];
        case 2: return [UIColor yellowColor];
        case 3: return [UIColor greenColor];
        case 4: return [UIColor blueColor];
    }
    return [UIColor blackColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
