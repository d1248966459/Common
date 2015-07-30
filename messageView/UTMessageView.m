//
//  UTMessageView.m
//  MobileUU
//
//  Created by dcj on 15/7/29.
//  Copyright (c) 2015年 Shanghai Pecker Network Technology. All rights reserved.
//

#import "UTMessageView.h"

#define  UTINWIDTH  [[UIScreen mainScreen] bounds].size.width
#define  UTINHEIGHT [[UIScreen mainScreen] bounds].size.height


@interface UTMessageView ()

@property (nonatomic, assign) BOOL    removeFromSuperViewOnHide;
@property (nonatomic, strong) UIView  *messageview;
@property (nonatomic, strong) UIImage *logoImage;
@property (nonatomic, assign) id<MessageViewReloadDataDelegate> messageReloadDelegate;
@end

@implementation UTMessageView

- (void)dealloc{
    self.text = nil;
    self.messageview = nil;
    self.logoImage = nil;
    self.LogoLable = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.messageview = [[UIView alloc] init];
        [_messageview setBackgroundColor:[UIColor clearColor]];
        
        [_messageview setFrame:self.bounds];
        [_messageview setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        [self addSubview:_messageview];
        
        self.logoImage = [UIImage imageNamed:nil];
        self.logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _logoImage.size.width, _logoImage.size.height)];
        self.logoImgView.hidden = YES;
        [_logoImgView setImage:_logoImage];
        [_messageview addSubview:_logoImgView];
        
        _LogoLable = [[UILabel alloc] init];
        [_messageview addSubview:_LogoLable];
        self.logoLableText = @"\U0000e610";
        
        
        self.msLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, UTINWIDTH, 50)] ;
        _msLabel.font = [UIFont boldSystemFontOfSize:17.0f];
        _msLabel.backgroundColor = [UIColor clearColor];
        _msLabel.textColor = COLOR_08;
        _msLabel.numberOfLines = 2;
        _msLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.messageview addSubview:_msLabel];
        [self addTapGesture];
    }
    return self;
}

-(void)addTapGesture{
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(messageViewTap:)];
    [self addGestureRecognizer:tapGesture];
}
-(void)messageViewTap:(UITapGestureRecognizer *)tap{

    if ([self.messageReloadDelegate respondsToSelector:@selector(reloadData)]) {
        [self.messageReloadDelegate reloadData];
    }else{
        if (self.retryBlock) {
            self.retryBlock();
        }
    }
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self updateMessageFrameByViewFrame:self.bounds];
}

-(void)updateMessageFrameByViewFrame:(CGRect)frame
{
    CGFloat top;
    UIImage* image = self.logoImage;
    if (image) {
        top = frame.size.height / 2 - image.size.height;
    }else{
        top = frame.size.height/2 - _LogoLable.height;
    }
    
    [_logoImgView setHidden:(top < 0)];
    if(top < 0)
    {
        _msLabel.centerY = frame.size.height / 2;
    }
    else
    {
        _logoImgView.bottom = frame.size.height / 2;
        _LogoLable.centerY = self.centerY - 30;
        _msLabel.top = _logoImgView.bottom + 5;
    }
    
    _logoImgView.centerX = _msLabel.centerX = frame.size.width / 2;
    _LogoLable.centerX = _msLabel.centerX = frame.size.width/2;
}

- (void)setLogoImage:(UIImage *)logoImage
{
    _logoImage = logoImage;
    _logoImgView.image = logoImage;
    [_logoImgView sizeToFit];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void)setLogoLableText:(NSString *)logoLableText{
    _logoLableText = logoLableText;
    _LogoLable.text = logoLableText;
    [self setLogoLable];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void)setLogoLable{
    
    UIFont *iconfont =[UIFont fontWithName:@"iconfont" size:60];
    _LogoLable.font=iconfont;
    _LogoLable.textAlignment = NSTextAlignmentCenter;
    _LogoLable.text =self.logoLableText;
    _LogoLable.textColor = COLOR_08;
    CGSize titleLabelsize = [_LogoLable.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, 20) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:iconfont} context:nil].size;
    _LogoLable.frame = CGRectMake(0, 0, UTINWIDTH, titleLabelsize.height);
}

-(void)setText:(NSString *)aText
{
    _msLabel.text = aText;
    _msLabel.width = self.width;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - class method


+ (UTMessageView *)showMSGAddedTo:(UIView *)view text:(NSString*)text animated:(BOOL)animated reloadDelegate:(id<MessageViewReloadDataDelegate>)reLoadDelegate{
    [self hideMSGForView:view animated:NO];
    UTMessageView *msgView = [[UTMessageView alloc] initWithFrame:view.bounds];
    msgView.text =text;
    msgView.messageReloadDelegate = reLoadDelegate;
    [view addSubview:msgView];
    [msgView show:animated];
    return msgView;
}
+ (UTMessageView *)showMSGAddedTo:(UIView *)view
                             text:(NSString*)text
                          xOffset:(float)xoffset
                          yOffset:(float)yoffset
                         animated:(BOOL)animated
                   reloadDelegate:(id<MessageViewReloadDataDelegate>)reLoadDelegate{
    [self hideMSGForView:view animated:NO];

    UTMessageView *msgView = [[UTMessageView alloc] initWithFrame:view.bounds];
    msgView.text = text;
    msgView.left += xoffset;
    msgView.top += yoffset;
    msgView.messageReloadDelegate = reLoadDelegate;
    [view addSubview:msgView];
    [msgView show:animated];
    return msgView;
}


+ (void)hideMSGForView:(UIView *)view animated:(BOOL)animated {
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[UTMessageView class]]) {
            UTMessageView *msgView  = (id)subView;
            msgView.removeFromSuperViewOnHide = YES;
            [msgView hide:YES];
        }
    }
}

+(UTMessageView *)showLoadFaildMSGAddedTo:(UIView *)view
                                 animated:(BOOL)animated
                           reloadDelegate:(id<MessageViewReloadDataDelegate>)reLoadDelegate
{
    [self hideMSGForView:view animated:NO];

    UTMessageView * msgView = [[UTMessageView alloc] initWithFrame:view.bounds];
    msgView.text = @"加载失败\n请点击屏幕重试";
    [view addSubview:msgView];
    msgView.messageReloadDelegate = reLoadDelegate;
    [msgView show:animated];
    return msgView;
}

+ (UTMessageView *)showNoConnectMsgAddedTo:(UIView *)view
                                  withText:(NSString*)emptyText
                                  animated:(BOOL)animated
                            reloadDelegate:(id<MessageViewReloadDataDelegate>)reLoadDelegate
{
    [self hideMSGForView:view animated:NO];

    UTMessageView *msgView = [[UTMessageView alloc] initWithFrame:view.bounds];
    msgView.text = @"加载失败\n请点击屏幕重试";
    msgView.messageReloadDelegate = reLoadDelegate;
    [view addSubview:msgView];
    [msgView show:animated];
    return msgView;
}


#pragma mark - function
- (void)show:(BOOL)animated
{
    self.alpha = 0.0f;
    if (animated) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.30];
    }
    
    self.alpha = 1.0f;
    
    if (animated) {
        [UIView commitAnimations];
    }
}

- (void)hide:(BOOL)animated
{
    if (animated) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.30];
    }
    
    self.alpha = 0.0f;
    
    if (animated) {
        [UIView commitAnimations];
    }
    
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.40];
}



@end
