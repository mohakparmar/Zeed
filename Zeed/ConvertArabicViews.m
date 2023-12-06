//
//  ConvertArabicViews.m
//  AssistMe
//
//  Created by hemant agarwal on 03/02/20.
//  Copyright © 2020 Hemant. All rights reserved.
//

#import "ConvertArabicViews.h"

@implementation ConvertArabicViews


+ (id)SM {
    static ConvertArabicViews *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
    }
    return self;
}

- (void)tranFormingViewToArabic:(UIView *)view {
    [self trasfoamView:view];
    [self convertViewToArabic:view];
}

- (void)convertSingleViewToAr:(UIView *)view {
    [self convertViewToArabic:view];
}

- (void)convertViewToArabic:(UIView *)viewForEnglish {
    for (UIView *view in viewForEnglish.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [self trasfoamView:view];
            continue;
        }
        
        if ([view isKindOfClass:[UITextField class]]) {
            [self trasfoamView:view];
            [self setTextFieldToAr:(UITextField *)view];
            continue;
        }
        
        if ([view isKindOfClass:[UITextView class]]) {
            [self trasfoamView:view];
            [self setTextViewToAr:(UITextView *)view];
            continue;
        }

        if ([view isKindOfClass:[UILabel class]]) {
            [self trasfoamView:view];
            [self setLabelToAr:(UILabel *)view];
            continue;
        }

        if ([view isKindOfClass:[UIButton class]]) {
            [self trasfoamView:view];
            continue;
        }

        if ([view isKindOfClass:[UITableView class]] || [view isKindOfClass:[UICollectionView class]]) {
            continue;
        }
        
        if (view.subviews.count > 0) {
            [self convertViewToArabic:view];
            continue;
        } else {
            [self trasfoamView:view];
        }
    }
}

-(void)trasfoamView:(UIView *)view {
    view.transform = trnForm_Ar1;
}

-(void)setTextFieldToAr:(UITextField *)txt {
    if (txt.textAlignment != NSTextAlignmentCenter) {
        txt.textAlignment = NSTextAlignmentRight;
    } else if (txt.textAlignment == NSTextAlignmentRight) {
        txt.textAlignment = NSTextAlignmentLeft;
    }
//[Utility textPadding:txt x:0 y:0 width:10 height:10];
}

-(void)setTextViewToAr:(UITextView *)txt {
    if (txt.textAlignment != NSTextAlignmentCenter) {
        txt.textAlignment = NSTextAlignmentRight;
    } else if (txt.textAlignment == NSTextAlignmentRight) {
        txt.textAlignment = NSTextAlignmentLeft;
    }
}

-(void)setButtonToAr:(UIButton *)btn {
    if (btn.titleLabel.textAlignment == NSTextAlignmentLeft) {
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    } else if (btn.titleLabel.textAlignment == NSTextAlignmentRight) {
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
}


-(void)setLabelToAr:(UILabel *)lbl {
    if (lbl.textAlignment == NSTextAlignmentRight) {
        lbl.textAlignment = NSTextAlignmentLeft;
    } else if (lbl.textAlignment != NSTextAlignmentCenter) {
        lbl.textAlignment = NSTextAlignmentRight;
    }
}


@end
