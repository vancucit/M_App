//
//  UIButton+ButtonWithStreckImage.m
//  JumpCamera


#import "UIButton+ButtonWithStreckImage.h"

#define kPaddingButton 10.0

#define TEXT_MARGIN 13;
#define HEXCOLOR(rgb) RGB((double)(rgb >> 16 & 0xff), (double)(rgb >> 8 & 0xff), (double)(rgb & 0xff))

@implementation UIButton (ButtonWithStreckImage)

//+(UIButton*)buttonWithStreckImage:(NSString*)aTitle
//{
//    int numberChacracter = aTitle.length;
//    UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
//    UIImage *buttonImage = RES_NormalButton;
//    UIImage *buttonImageHilighted=RES_NormalButtonHighlighted;
//    
//    UIImage *stretchableButtonImage = [buttonImage stretchableImageWithLeftCapWidth:10 topCapHeight:0];
//    [button setBackgroundImage:stretchableButtonImage forState:UIControlStateNormal];
//    UIImage *stretchableButtonImageHilighted = [buttonImageHilighted stretchableImageWithLeftCapWidth:10 topCapHeight:0];
//    [button setBackgroundImage:stretchableButtonImageHilighted forState:UIControlStateHighlighted];
//    
//    [button setTitleColor:HTMLCOLOR(0xFFFFFF)
//                          forState:UIControlStateNormal];
//    [button setTitleColor:HTMLCOLORALPHA(0xFFFFFF,0.5)
//                          forState:UIControlStateDisabled];
//    CGFloat widthButton;//=[aTitle sizeWithFont:APP_BOLD_FONT(12) constrainedToSize:CGSizeMake(320, 460)].width+kPaddingButton*2.0;
//    
//    if (numberChacracter==2||numberChacracter==3) {
//        widthButton=buttonImage.size.width;
//    }
//    else{
//        widthButton=[aTitle sizeWithFont:APP_BOLD_FONT(12) constrainedToSize:CGSizeMake(320, 460)].width+kPaddingButton*2.0;
//    }
//   
//    button.titleLabel.font=APP_BOLD_FONT(12);
//    button.frame=CGRectMake(0, 0, widthButton, buttonImage.size.height);
//    [button setTitle:aTitle forState:UIControlStateNormal];
//
//    [button setTitleEdgeInsets:UIEdgeInsetsMake(2.0, 0, 0, 0.0)];
//    return button;
//}
+(UIButton*)buttonDecorationSelectWithStreckImage:(NSString*)aTitle
{
    
    UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *buttonImage = [UIImage imageNamed:@"btn_filtering_default.png"];
    UIImage *buttonImageHilighted=[UIImage imageNamed:@"btn_filtering_highlighted.png"];
    
    UIImage *stretchableButtonImage = [buttonImage stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    [button setBackgroundImage:stretchableButtonImage forState:UIControlStateNormal];
    UIImage *stretchableButtonImageHilighted = [buttonImageHilighted stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    [button setBackgroundImage:stretchableButtonImageHilighted forState:UIControlStateHighlighted];
    button.layer.borderColor = [UIColor grayColor].CGColor;
    button.layer.borderWidth = 1.0;
    [button setTitleColor:[UIColor blackColor]
                 forState:UIControlStateNormal];
    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    CGFloat widthButton=[aTitle sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(320, 460)].width+kPaddingButton*2.0;
    if (widthButton < buttonImage.size.width)
        widthButton = buttonImage.size.width;
//    
//    button.titleLabel.font=APP_BOLD_FONT(12);
    button.frame=CGRectMake(0, 0, widthButton, buttonImage.size.height);
    [button setTitleEdgeInsets:UIEdgeInsetsMake(1.0, 0, 0, 0.0)];
    [button setTitle:aTitle forState:UIControlStateNormal];
    
    return button;
}

//+ (UIButton* ) buttonWithStretchBackground:(UIImage*)background stretchHighlightedBackground:(UIImage*)highlighted stretchDisableBackground:(UIImage*)disablebg capWidth:(NSInteger)capWidth title:(NSString*)title
//{
//    UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
//    
//    UIImage *stretchableButtonImage = [background stretchableImageWithLeftCapWidth:capWidth topCapHeight:0];
//    [button setBackgroundImage:stretchableButtonImage forState:UIControlStateNormal];
//    
//    if(highlighted)
//    {
//        UIImage *stretchableButtonImageHilighted = [highlighted stretchableImageWithLeftCapWidth:capWidth topCapHeight:0];
//        [button setBackgroundImage:stretchableButtonImageHilighted forState:UIControlStateHighlighted];
//    }
//    
//    if(disablebg)
//    {
//        UIImage *stretchableButtonImageDisable = [disablebg stretchableImageWithLeftCapWidth:capWidth topCapHeight:0];
//        [button setBackgroundImage:stretchableButtonImageDisable forState:UIControlStateDisabled];
//    }
//    
//    CGFloat widthButton= [title sizeWithFont:APP_BOLD_FONT(12) constrainedToSize:CGSizeMake(320, 460)].width + 2.0*TEXT_MARGIN;
//    
//    button.titleLabel.font=APP_BOLD_FONT(12);
//    button.frame=CGRectMake(0, 0, widthButton, background.size.height);
//    [button setTitle:title forState:UIControlStateNormal];
//    
//    // set text color + shadow color
//    [button setTitleColor:HEXCOLOR(0xFFFFFF) forState:UIControlStateNormal];
//    [button setTitleColor:HEXCOLOR(0xFFFFFF) forState:UIControlStateDisabled];
//    [button setTitleShadowColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] forState:UIControlStateNormal];
//    button.titleLabel.shadowOffset = CGSizeMake(0, -1);
//    
//    return button;
//}
//
//+ (UIButton* ) buttonWithStretchBackground:(UIImage*)background stretchHighlightedBackground:(UIImage*)highlighted capWidth:(NSInteger)capWidth title:(NSString*)title
//{
//    return [self buttonWithStretchBackground:background stretchHighlightedBackground:highlighted stretchDisableBackground:nil capWidth:capWidth title:title];
//}
//
//+ (UIButton* ) buttonWithStretchBackground:(UIImage*)background capWidth:(NSInteger)capWidth title:(NSString*)title
//{
//    return [self buttonWithStretchBackground:background stretchHighlightedBackground:nil capWidth:capWidth title:title];
//}


@end
