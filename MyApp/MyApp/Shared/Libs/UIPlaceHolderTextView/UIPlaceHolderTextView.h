//
//  UIPlaceHolderTextView.h
//  PipeFish
//
//  Created by Cuc Nguyen on 12/8/14.
//  Copyright (c) 2014 CloudZilla. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView
@property (nonatomic, retain) NSString *placeholder;

@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;
@end
