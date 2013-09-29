//
//  AOTrayView.m
//
//  Created by Andy on 2/6/12.
//  Copyright (c) 2012 Andy Obusek. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//  of the Software, and to permit persons to whom the Software is furnished to do
//  so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "AOTrayView.h"
#import <QuartzCore/CAAnimation.h>

@interface AOTrayView () {
    UIDynamicAnimator *animator;
    UIGravityBehavior *gravityBehavior;
    UICollisionBehavior *collisionBehavior;
}

@property (nonatomic, retain) UILabel *counterLabel;
@property (nonatomic, retain) UIScrollView *trayContents;
@property (nonatomic, retain) NSString *singleItemLabel;
@property (nonatomic, retain) NSString *multiItemLabel;
@property (nonatomic, retain) NSMutableDictionary *items;
@property (nonatomic, retain) NSMutableDictionary *itemSnaps;
@property (nonatomic, retain) NSMutableArray *itemViews;
@property (nonatomic, retain) UIView *transparentOverlay;
@property (nonatomic, retain) UIButton *doneButton;
@property (nonatomic, retain) UIView *pressedButtonView;
@property (nonatomic, retain) UIImageView *unselectedIconImage1;
@property (nonatomic, retain) UIImageView *unselectedIconImage2;
@property (nonatomic, retain) UIImageView *unselectedIconImage3;
@property (nonatomic, retain) UIImageView *unselectedIconImage4;

@end

@implementation AOTrayView

@synthesize trayHeight,
            overlayHeight,
            counterLabel,
            trayContents,
            multiItemLabel,
            singleItemLabel,
            items,
            itemSnaps,
            itemViews,
            transparentOverlay,
            doneButton, 
            pressedButtonView,
            animatingImageView,
            alwaysShow,
            unselectedIconImage1,
            unselectedIconImage2,
            unselectedIconImage3,
            unselectedIconImage4;

- (id)initWithFrame:(CGRect)frame {
    self = [self initWithFrame:frame andSingleItemLabel:@"" andMultiItemLabel:@""];
    return self;
}


- (id)initWithFrame:(CGRect)frame andSingleItemLabel:(NSString *)pSingleItemLabel andMultiItemLabel:(NSString *)pMultiItemLabel {
    self = [super initWithFrame:frame];
    if (self) {
        animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        self.singleItemLabel = pSingleItemLabel;
        self.multiItemLabel = pMultiItemLabel;

        if (! hideNumbers) {
            self.transparentOverlay = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, overlayHeight)] autorelease];
            self.transparentOverlay.backgroundColor = [UIColor grayColor];
            self.transparentOverlay.alpha = 0.5;
            self.transparentOverlay.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
            self.counterLabel = [[[UILabel alloc] initWithFrame:self.transparentOverlay.frame] autorelease];
            self.counterLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
            self.counterLabel.text = @"look at me";
            [transparentOverlay addSubview:self.counterLabel];
            [self addSubview:transparentOverlay];
        }
        
        self.trayContents = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, overlayHeight-headerHeight, frame.size.width, frame.size.height)] autorelease];
        self.trayContents.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        self.trayContents.backgroundColor = [UIColor clearColor];

        /*
         TODO - add API for specifying a UIImageView for a background image
        UIImageView *gradient = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        gradient.image = [UIImage imageNamed:@"deci_nav_footer.png"];
        gradient.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:gradient];
         */
        
        [self addSubview:trayContents];
        hideTrayContents = YES;
        self.items = [[[NSMutableDictionary alloc] initWithCapacity:1] autorelease];
        self.itemSnaps = [[[NSMutableDictionary alloc] initWithCapacity:1] autorelease];
        self.itemViews = [[[NSMutableArray alloc] initWithCapacity:1] autorelease];
        headerHeight = 0;
    }
    return self;
}

- (IBAction) doneReleased:(id) sender  {
    self.pressedButtonView.hidden = NO;
}

- (IBAction) doneTouch:(id) sender  {
    self.pressedButtonView.hidden = YES;
}

/**
 For some configurations, like the "Where" screen in deci, we can add a button to the tray view to help prompt an action
 */
- (void)configureDoneButton:(id)controller {
    if (!self.doneButton)
        self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.doneButton.frame = CGRectMake(220, 0, 100, trayHeight);
    //[self.doneButton setBackgroundImage:[UIImage imageNamed:@"a0.png"] forState:UIControlStateNormal];
    [self.doneButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    self.doneButton.titleLabel.textColor = [UIColor whiteColor];
    self.doneButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [self.doneButton addTarget:controller action:@selector(done) forControlEvents:UIControlEventTouchUpInside];

    self.pressedButtonView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, trayHeight)] autorelease];
    self.pressedButtonView.hidden = YES;
    self.pressedButtonView.backgroundColor = [UIColor blackColor];
    self.pressedButtonView.alpha = 0.65;
    [self.doneButton addSubview:self.pressedButtonView];
}

- (id)initWithFrame:(CGRect)frame andHideNumbers:(BOOL) pAndHideNumbers withController:(id) controller {
    hideNumbers = YES;
    headerHeight = 15;

    self = [self initWithFrame:frame andSingleItemLabel:@"" andMultiItemLabel:@""];
    self.trayContents.backgroundColor = [UIColor clearColor];
    [self.transparentOverlay removeFromSuperview];
    [self configureDoneButton:controller];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(225, 20, 90, trayHeight-5)];
    [imageView setImage:[UIImage imageNamed:@"powered-by-google-on-non-white.png"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;

    /*
     TODO for the "static" view of the tray in which it always shows, refactor out an API to show default images
     
    //UIView *placeHolder = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    self.unselectedIconImage1 = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)] autorelease];
    //placeHolder.backgroundColor = [UIColor colorWithRed:0.988 green:0.721 blue:0.075 alpha:1.0];
    self.unselectedIconImage1.image = [UIImage imageNamed:@"deci_icon_where_check.png"];
    [self.trayContents addSubview:self.unselectedIconImage1];
    self.unselectedIconImage2 = [[[UIImageView alloc] initWithFrame:CGRectMake(65, 10, 40, 40)] autorelease];
    //placeHolder.backgroundColor = [UIColor colorWithRed:0.973 green:0.612 blue:0.118 alpha:1.0];
    self.unselectedIconImage2.image = [UIImage imageNamed:@"deci_icon_where_check_2.png"];
    [self.trayContents addSubview:self.unselectedIconImage2];
    self.unselectedIconImage3 = [[[UIImageView alloc] initWithFrame:CGRectMake(120, 10, 40, 40)] autorelease];
    //placeHolder.backgroundColor = [UIColor colorWithRed:0.957 green:0.502 blue:0.125 alpha:1.0];
    self.unselectedIconImage3.image = [UIImage imageNamed:@"deci_icon_where_check_2.png"];
    [self.trayContents addSubview:self.unselectedIconImage3];
    self.unselectedIconImage4 = [[[UIImageView alloc] initWithFrame:CGRectMake(175, 10, 40, 40)] autorelease];
    //placeHolder.backgroundColor = [UIColor colorWithRed:0.945 green:0.4 blue:0.137 alpha:1.0];
    self.unselectedIconImage4.image = [UIImage imageNamed:@"deci_icon_where_check_2.png"];
    [self.trayContents addSubview:self.unselectedIconImage4];
     
     */
    
    
    self.animatingImageView = imageView;
    [imageView release];
    
    [self addSubview:imageView];
    
    return self;
}

- (void) add:(NSDictionary *)toAdd adjacentViewToResize:(UIView *) adjacentViewToResize {
    [self add:toAdd adjacentViewToResize:adjacentViewToResize withTextLabel:nil];
}

- (void) add:(NSDictionary *)toAdd adjacentViewToResize:(UIView *) adjacentViewToResize withTextLabel:(NSString *)textLabel {
    NSMutableDictionary *newToAdd = [NSMutableDictionary dictionaryWithDictionary:toAdd];
    [self.items setObject:newToAdd forKey:[toAdd objectForKey:@"id"]];
    [self.trayContents setContentOffset:CGPointMake(0, 0) animated:YES];
    
    /*
     TODO for the "static" view of the tray in which it always shows, refactor out an API to show default images
     
    if ([[self.items allKeys] count] == 1) {
        self.unselectedIconImage2.image = [UIImage imageNamed:@"deci_icon_where_check.png"];
        self.unselectedIconImage3.image = [UIImage imageNamed:@"deci_icon_where_check_2.png"];
        self.unselectedIconImage4.image = [UIImage imageNamed:@"deci_icon_where_check_2.png"];
    } else if ([[self.items allKeys] count] == 2) {
        self.unselectedIconImage3.image = [UIImage imageNamed:@"deci_icon_where_check.png"];
        self.unselectedIconImage4.image = [UIImage imageNamed:@"deci_icon_where_check_2.png"];
    } else if ([[self.items allKeys] count] == 3) {
        self.unselectedIconImage4.image = [UIImage imageNamed:@"deci_icon_where_check.png"];
    }
     */
    
    if ([[self.items allKeys] count] == 1 && !self.alwaysShow) {
        self.counterLabel.text = self.singleItemLabel;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.15];
        
        hideTrayContents = NO;
        self.frame = CGRectMake(0, self.frame.origin.y-trayHeight-overlayHeight, self.frame.size.width, trayHeight);
        adjacentViewToResize.frame = CGRectMake(adjacentViewToResize.frame.origin.x, 
                                                adjacentViewToResize.frame.origin.y, 
                                                adjacentViewToResize.frame.size.width, 
                                                adjacentViewToResize.frame.size.height - trayHeight-  overlayHeight + headerHeight );
        
        [UIView commitAnimations];
    } else {
        self.counterLabel.text = [NSString stringWithFormat:@"%d %@", [[self.items allKeys] count], self.multiItemLabel];
    }
    UIView *view = [toAdd objectForKey:@"view"];
    view.frame = CGRectMake(0, self.frame.size.height, view.frame.size.width, view.frame.size.height);
    if (textLabel != nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(1, 40, 53, 15)];
        label.font = [UIFont systemFontOfSize:10];
        label.text = textLabel;
        [view addSubview:label];
        [label release];
    }
    
    for (int counter=0;counter < [self.itemViews count];counter++) {
        UIView *viewToMove = (UIView *) [[self.itemViews objectAtIndex:counter] objectForKey:@"view"];
        CGPoint newPoint = CGPointMake(viewToMove.center.x+trayHeight, viewToMove.center.y);
        
        id b = [self.itemSnaps objectForKey:[[self.itemViews objectAtIndex:counter] objectForKey:@"id"]];
        [animator removeBehavior:b];
        
        UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:viewToMove snapToPoint:newPoint];
        [animator addBehavior:snap];
        [self.itemSnaps setObject:snap forKey:[[self.itemViews objectAtIndex:counter] objectForKey:@"id"]];
    }
    
    [newToAdd setObject:view forKey:@"view"];
    [self.itemViews insertObject:newToAdd atIndex:0];
    self.trayContents.contentSize = CGSizeMake(trayHeight * [[self.items allKeys] count], trayHeight);
    [self.trayContents addSubview:view];
    
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:view snapToPoint:CGPointMake(view.frame.size.width / 2 + 5, view.frame.size.height / 2 + 5 + overlayHeight)];
    [animator addBehavior:snap];
    [self.itemSnaps setObject:snap forKey:[newToAdd objectForKey:@"id"]];
}

- (void) remove:(NSDictionary *)toRemove adjacentViewToResize:(UIView *) adjacentViewToResize {
    [self.items removeObjectForKey:[toRemove objectForKey:@"id"]];
    
    if ([[self.items allKeys] count] == 0) {
        self.unselectedIconImage1.image = [UIImage imageNamed:@"deci_icon_where_check.png"];
        self.unselectedIconImage2.image = [UIImage imageNamed:@"deci_icon_where_check_2.png"];
        self.unselectedIconImage3.image = [UIImage imageNamed:@"deci_icon_where_check_2.png"];
        self.unselectedIconImage4.image = [UIImage imageNamed:@"deci_icon_where_check_2.png"];
    } else if ([[self.items allKeys] count] == 1) {
        self.unselectedIconImage2.image = [UIImage imageNamed:@"deci_icon_where_check.png"];
        self.unselectedIconImage3.image = [UIImage imageNamed:@"deci_icon_where_check_2.png"];
        self.unselectedIconImage4.image = [UIImage imageNamed:@"deci_icon_where_check_2.png"];
    } else if ([[self.items allKeys] count] == 2) {
        self.unselectedIconImage3.image = [UIImage imageNamed:@"deci_icon_where_check.png"];
        self.unselectedIconImage4.image = [UIImage imageNamed:@"deci_icon_where_check_2.png"];
    } else if ([[self.items allKeys] count] == 3) {
        self.unselectedIconImage4.image = [UIImage imageNamed:@"deci_icon_where_check.png"];
    }

    
    int indexOfRemovedView = -1;
    for (int counter=0;(counter < [self.itemViews count]) && indexOfRemovedView < 0;counter++) {
        NSDictionary *toFind = [self.itemViews objectAtIndex:counter];
        if ([[toFind objectForKey:@"id"] isEqual:[toRemove objectForKey:@"id"]]) {
            indexOfRemovedView = counter;
            [(UIView *) [toFind objectForKey:@"view"] removeFromSuperview];
            [self.itemViews removeObjectAtIndex:counter];
        }
    }
    if ([[self.items allKeys] count] == 0 && !self.alwaysShow) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.15];
        
        self.frame = CGRectMake(0, self.frame.origin.y+ trayHeight+overlayHeight, self.frame.size.width, trayHeight);
        adjacentViewToResize.frame = CGRectMake(adjacentViewToResize.frame.origin.x, 
                                                 adjacentViewToResize.frame.origin.y, 
                                                 adjacentViewToResize.frame.size.width, 
                                                 adjacentViewToResize.frame.size.height + trayHeight+overlayHeight);
        
        [UIView commitAnimations];
        
        hideTrayContents = YES;
    } else {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.15];
        
        for (int counter=indexOfRemovedView;counter < [self.itemViews count];counter++) {
            UIView *viewToMove = (UIView *) [[self.itemViews objectAtIndex:counter] objectForKey:@"view"];
            viewToMove.frame = CGRectMake(viewToMove.frame.origin.x-trayHeight, viewToMove.frame.origin.y, viewToMove.frame.size.width, viewToMove.frame.size.height);
        }
        
        
        [UIView commitAnimations];

        
        if ([[self.items allKeys] count] == 1) {
            self.counterLabel.text = self.singleItemLabel;
        } else {
        self.counterLabel.text = [NSString stringWithFormat:@"%d %@", [[self.items allKeys] count], self.multiItemLabel];
        }
    }
    self.trayContents.contentSize = CGSizeMake(trayHeight * [[self.items allKeys] count], trayHeight);
}

- (void) dealloc {
    [counterLabel release];
    [trayContents release];
    [multiItemLabel release];
    [singleItemLabel release];
    [items release];
    [itemViews release];
    [doneButton release];
    [pressedButtonView release];
    [animatingImageView release];
    [unselectedIconImage1 release];
    [unselectedIconImage2 release];
    [unselectedIconImage3 release];
    [unselectedIconImage4 release];
    [transparentOverlay release];
    
    [super dealloc];
}

@end
