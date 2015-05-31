//
//  HZActionSheet.h
//  HZActionSheet
//
//  Created by History on 15/5/30.
//  Copyright (c) 2015年 History. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HZActionSheet;

@protocol HZActionSheetDelegate <NSObject>

@optional
- (void)actionSheet:(HZActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
@interface HZActionSheet : UIControl
@property (nonatomic, weak) id<HZActionSheetDelegate> delegate;
@property (nonatomic, assign, readonly) NSInteger cancelButtonIndex;
@property (nonatomic, strong) UIColor *titleColor;

- (instancetype)initWithTitle:(NSString *)title delegate:(id<HZActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonIndexSet:(NSIndexSet *)destructiveIndexSet otherButtonTitles:(NSArray *)otherButtonTitles;
- (void)showInView:(UIView *)superView;
@end
