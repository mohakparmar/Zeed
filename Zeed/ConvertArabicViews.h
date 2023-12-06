//
//  ConvertArabicViews.h
//  AssistMe
//
//  Created by hemant agarwal on 03/02/20.
//  Copyright © 2020 Hemant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define trnForm_En1 (CGAffineTransformMakeScale(1.0, 1.0))
#define trnForm_Ar1 (CGAffineTransformMakeScale(-1.0, 1.0))



@interface ConvertArabicViews : NSObject

+ (id)SM;
- (void)tranFormingViewToArabic:(UIView *)view;
- (void)trasfoamView:(UIView *)view;
- (void)convertSingleViewToAr:(UIView *)view;

@end

