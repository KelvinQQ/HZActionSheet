//
//  ViewController.m
//  HZActionSheet
//
//  Created by History on 15/5/30.
//  Copyright (c) 2015年 History. All rights reserved.
//

#import "ViewController.h"
#import "HZActionSheet.h"


typedef NS_ENUM(NSInteger, HZActionSheetTag) {
    HZActionSheetTagNormal = 1000,
    HZActionSheetTagMultiLine,
    HZActionSheetTagRed,
    HZActionSheetTagNoTitle,
};

@interface ViewController () <HZActionSheetDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)normalSheetAction:(id)sender
{
    HZActionSheet *sheet = [[HZActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonIndexSet:nil otherButtonTitles:@[@"相册", @"相机"]];
    sheet.tag = HZActionSheetTagNormal;
    [sheet showInView:self.view];
}
- (IBAction)multiLineSheetAction:(id)sender
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger index = 0; index < 20; ++ index) {
        [array addObject:[NSString stringWithFormat:@"标题%@", @(index)]];
    }
    
    HZActionSheet *sheet = [[HZActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonIndexSet:nil otherButtonTitles:array];
    sheet.tag = HZActionSheetTagMultiLine;
    [sheet showInView:self.view];
}
- (IBAction)redSheetAction:(id)sender
{
    HZActionSheet *sheet = [[HZActionSheet alloc] initWithTitle:@"你确定要注销?" delegate:self cancelButtonTitle:@"取消" destructiveButtonIndexSet:[NSIndexSet indexSetWithIndex:0] otherButtonTitles:@[@"注销"]];
    sheet.tag = HZActionSheetTagRed;
    [sheet showInView:self.view];
}
- (IBAction)noTitleSheetAction:(id)sender
{
    HZActionSheet *sheet = [[HZActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonIndexSet:nil otherButtonTitles:@[@"相册", @"相机"]];
    sheet.tag = HZActionSheetTagRed;
    [sheet showInView:self.view];
}


#pragma mark - ActionSheet Delegate
- (void)actionSheet:(HZActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"你点击了 %@", @(buttonIndex));
}
@end
