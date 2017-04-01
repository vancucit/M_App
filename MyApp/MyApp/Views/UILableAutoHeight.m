//
//  UILableAutoHeight.m
//  MyApp
//
//  Created by Cuc Nguyen on 2/24/17.
//  Copyright © 2017 Kuccu. All rights reserved.
//

#import "UILableAutoHeight.h"

@implementation UILableAutoHeight
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.numberOfLines == 0 && self.preferredMaxLayoutWidth != CGRectGetWidth(self.frame)) {
        self.preferredMaxLayoutWidth = self.frame.size.width;
        [self setNeedsUpdateConstraints];
    }
}

- (CGSize)intrinsicContentSize
{
    CGSize s = [super intrinsicContentSize];
    
    if (self.numberOfLines == 0) {
        // found out that sometimes intrinsicContentSize is 1pt too short!
        s.height += 1;
    }
    
    return s;
}
@end
