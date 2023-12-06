//
//  AGChatViewController.h
//  AGChatView
//
//  Created by Ashish Gogna on 09/04/16.
//  Copyright © 2016 Ashish Gogna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+animatedGIF.h"

@interface AGChatViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

//IBOutlets
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

- (UIView*)createMessageWithText: (NSString*)text Image: (NSString*)strUrl DateTime: (NSString*)dateTimeString isReceived: (BOOL)isReceived isVideo: (BOOL)IsVideoBool type:(NSString *)type;
@end
