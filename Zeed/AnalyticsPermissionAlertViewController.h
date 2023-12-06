//
//  AnalyticsPermissionAlertViewController.h
//  MuscleFuel
//
//  Created by Mohak Parmar on 19/05/21.
//  Copyright © 2021 Mohak. All rights reserved.
//

#import <UIKit/UIKit.h>

#define appDele ((AppDelegate*)[UIApplication sharedApplication].delegate)

@protocol CustomAlertDelegate <NSObject>
-(void)btnContinuePress;
@end

@interface AnalyticsPermissionAlertViewController : UIViewController
{
    __weak IBOutlet UILabel *allowMuscleFuel;
    __weak IBOutlet UILabel *lblPersonizeForYou;
    __weak IBOutlet UILabel *lblImproveExp;
    
    __weak IBOutlet UITextView *txtDescription;
    __weak IBOutlet UIButton *btnContinue;
}
- (IBAction)btnContinueClick:(id)sender;
@property (retain,nonatomic) id <CustomAlertDelegate> delegate;

@end

