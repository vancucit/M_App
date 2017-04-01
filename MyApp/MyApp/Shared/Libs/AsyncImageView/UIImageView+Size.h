//
//  UIImageView+Size.h
//  PipeFish
//
//  Created by Cuc Nguyen on 2/9/15.
//  Copyright (c) 2015 CloudZilla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface UIImageView(Size)
- (CGSize)imageScale;
CGSize CGSizeAspectFit(CGSize aspectRatio, CGSize boundingSize);
CGSize CGSizeAspectFill(CGSize aspectRatio, CGSize minimumSize);

@end
