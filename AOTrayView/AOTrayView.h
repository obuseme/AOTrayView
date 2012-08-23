//
//  AOTrayView.h
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

#import <UIKit/UIKit.h>

@interface AOTrayView : UIView {
    BOOL hideTrayContents;
    BOOL hideNumbers;
    float headerHeight;
}

@property BOOL alwaysShow;
@property (nonatomic, retain) UILabel *counterLabel;
@property (nonatomic, retain) UIScrollView *trayContents;
@property (nonatomic, retain) NSString *singleItemLabel;
@property (nonatomic, retain) NSString *multiItemLabel;
@property (nonatomic, retain) NSMutableDictionary *items;
@property (nonatomic, retain) NSMutableArray *itemViews;
@property (nonatomic, retain) UIView *transparentOverlay;
@property (nonatomic, retain) UIButton *doneButton;
@property (nonatomic, retain) UIView *pressedButtonView;
@property (nonatomic, retain) UIImageView *animatingImageView;
@property (nonatomic, retain) UIImageView *unselectedIconImage1;
@property (nonatomic, retain) UIImageView *unselectedIconImage2;
@property (nonatomic, retain) UIImageView *unselectedIconImage3;
@property (nonatomic, retain) UIImageView *unselectedIconImage4;

- (id)initWithFrame:(CGRect)frame andHideNumbers:(BOOL) pAndHideNumbers withController:(id) controller;
- (id)initWithFrame:(CGRect)frame andSingleItemLabel:(NSString *)pSingleItemLabel andMultiItemLabel:(NSString *)pMultiItemLabel;
- (void) add:(NSDictionary *)toAdd adjacentViewToResize:(UIView *) adjacentViewToResize;
- (void) add:(NSDictionary *)toAdd adjacentViewToResize:(UIView *) adjacentViewToResize withTextLabel:(NSString *)textLabel;
- (void) remove:(NSDictionary *)toRemove adjacentViewToResize:(UIView *) adjacentViewToResize;

@end
