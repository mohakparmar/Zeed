//
//  AnalyticsPermissionAlertViewController.m
//  MuscleFuel
//
//  Created by Mohak Parmar on 19/05/21.
//  Copyright © 2021 Mohak. All rights reserved.
//

#import "AnalyticsPermissionAlertViewController.h"
#import <Adjust/Adjust.h>

@interface AnalyticsPermissionAlertViewController ()

@end

@implementation AnalyticsPermissionAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIFont *font = [UIFont systemFontOfSize:17];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                    forKey:NSFontAttributeName];

    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:@"To provide better experience we need permission to use future activity that other apps and website send us from this device. Click on Allow on next screen. You can change this option later in the setting app as well. \nYou can Learn more about the privacy policy of Zeed by clicking here" attributes:attrsDictionary];

    NSRange rangeForText = [string.string rangeOfString:@"here"];
    [string addAttribute: NSLinkAttributeName value:[NSURL URLWithString:@"http://google.com"] range: rangeForText];
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor blackColor],
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:19],
                                 NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle),
                                 NSBackgroundColorAttributeName : [UIColor clearColor]
                                 };
    [string addAttributes:attributes range:rangeForText];

    txtDescription.attributedText = string;
    
//    if (appDele.isForArabic) {
//        allowMuscleFuel.text = @"هل تريد السماح لمسل فيول باستخدام نشاط موقعك الإلكتروني والتطبيق؟";
//        lblPersonizeForYou.text = @"عرض مخصص لك فقط";
//        lblImproveExp.text = @"تحسين العمل الإضافي من ذوي الخبرة";
//    }

    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated {
}

-(void)viewWillLayoutSubviews {
    btnContinue.layer.cornerRadius = btnContinue.frame.size.height / 2;
    btnContinue.layer.masksToBounds = YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnContinueClick:(id)sender {
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"CustomAlertPermission"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (@available(iOS 14, *)) {
        [Adjust requestTrackingAuthorizationWithCompletionHandler:^(NSUInteger status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:true completion:nil];
                [self.delegate btnContinuePress];
            });
            switch (status) {
                case 0:
                    // ATTrackingManagerAuthorizationStatusNotDetermined case
                    break;
                case 1:
                    // ATTrackingManagerAuthorizationStatusRestricted case
                    break;
                case 2:
                    // ATTrackingManagerAuthorizationStatusDenied case
                    break;
                case 3:
                    // ATTrackingManagerAuthorizationStatusAuthorized case
                    break;
            }
        }];

    } else {
        [self dismissViewControllerAnimated:true completion:nil];
        [self.delegate btnContinuePress];
    }
}

@end
