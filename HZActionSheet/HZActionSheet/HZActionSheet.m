//
//  HZActionSheet.m
//  HZActionSheet
//
//  Created by History on 15/5/30.
//  Copyright (c) 2015年 History. All rights reserved.
//

#import "HZActionSheet.h"
#import "Masonry.h"

const CGFloat kHZCellHeight = 50.f;
const CGFloat kHZSeparatorHeight = 5.f;
const CGFloat kHZAnimationDuration = .2f;
const CGFloat kHZFontSize = 18.f;

@interface HZActionSheet () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
    UIButton *_cancleButton;
    UILabel *_titleLabel;
    
    UIView *_sheetView;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *cancleTitle;
@property (nonatomic, strong) NSArray *otherTitles;
@property (nonatomic, strong) NSIndexSet *destructiveIndexSet;
@end

@implementation HZActionSheet
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithTitle:(NSString *)title delegate:(id<HZActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonIndexSet:(NSIndexSet *)destructiveIndexSet otherButtonTitles:(NSArray *)otherButtonTitles
{
    self = [super init];
    if (self) {
        _delegate = delegate;
        _title = title;
        _cancleTitle = cancelButtonTitle;
        _destructiveIndexSet = destructiveIndexSet;
        _otherTitles = otherButtonTitles;
        
        [self setup];
    }
    return self;
}


- (void)setup
{
    _titleColor = [UIColor blackColor];
    
    [self addTarget:self action:@selector(hideActionSheet) forControlEvents:UIControlEventTouchUpInside];
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
    
    _sheetView = [[UIView alloc] init];
    _sheetView.backgroundColor = [UIColor clearColor];
    [self addSubview:_sheetView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.rowHeight = kHZCellHeight;
    
    _cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancleButton.backgroundColor = [UIColor whiteColor];
    [_cancleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:_cancleTitle
                                                                          attributes:@{
                                                                                       NSFontAttributeName: [UIFont systemFontOfSize:kHZFontSize],
                                                                                       NSForegroundColorAttributeName: _titleColor,
                                                                                       }];
    [_cancleButton setAttributedTitle:attributedTitle forState:UIControlStateNormal];
    [_cancleButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_sheetView addSubview:_cancleButton];
    
    [_cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.mas_equalTo(_sheetView).with.insets(UIEdgeInsetsZero);
        make.height.mas_equalTo(kHZCellHeight);
    }];
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height - 28;
    CGFloat totalHeight = _otherTitles.count * kHZCellHeight + kHZCellHeight + kHZSeparatorHeight +( _title.length ? kHZCellHeight : 0);
    BOOL moreThanScreen = totalHeight > screenHeight;
    CGFloat sheetHeight = moreThanScreen ? screenHeight : totalHeight;
    if (!moreThanScreen) {
        _tableView.bounces = NO;
    }
    else {
        _tableView.bounces = YES;
    }
    [_sheetView addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(_sheetView).with.insets(UIEdgeInsetsZero);
        make.bottom.mas_equalTo(_cancleButton.mas_top).mas_offset(-kHZSeparatorHeight);
        if (!moreThanScreen) {
            make.height.mas_equalTo(kHZCellHeight * _otherTitles.count);
        }
        else {
            make.height.mas_equalTo(screenHeight - kHZCellHeight * 2 + kHZSeparatorHeight);
        }
    }];
    
    if (_title.length) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 2;
        _titleLabel.text = _title;
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.backgroundColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:13.f];
        _titleLabel.userInteractionEnabled = YES;
        [_sheetView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(_sheetView).with.insets(UIEdgeInsetsZero);
            make.bottom.mas_equalTo(_tableView.mas_top);
            make.height.mas_equalTo(kHZCellHeight);
        }];
    }
    
    [_sheetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self).insets(UIEdgeInsetsZero);
        make.height.mas_equalTo(sheetHeight);
    }];
    
    _cancelButtonIndex = _otherTitles.count;
}

- (void)showInView:(UIView *)superView
{
    [superView.window addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(superView.window).with.insets(UIEdgeInsetsZero);
    }];
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"position.y";
    animation.fromValue = @(800);
    animation.duration = kHZAnimationDuration;
    [_sheetView.layer addAnimation:animation forKey:@"com.history.animation"];
}

- (void)hideActionSheet
{
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"position.y";
    animation.toValue = @(800);
    animation.duration = kHZAnimationDuration;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [_sheetView.layer addAnimation:animation forKey:@"com.history.animation"];
    
    [UIView animateKeyframesWithDuration:kHZAnimationDuration
                                   delay:kHZAnimationDuration
                                 options:UIViewKeyframeAnimationOptionCalculationModeLinear
                              animations:^{
                                  self.alpha = 0.f;
                              }
                              completion:^(BOOL finished) {
                                  [self removeFromSuperview];
                              }];
}

- (void)cancelButtonClicked
{
    [self hideActionSheet];
    
    if ([_delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
        [_delegate actionSheet:self clickedButtonAtIndex:_cancelButtonIndex];
    }
}


- (void)setTitleColor:(UIColor *)titleColor
{
    if (_titleColor != titleColor) {
        _titleColor = titleColor;
        [_tableView reloadData];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:_cancleTitle
                                                                              attributes:@{
                                                                                           NSFontAttributeName: [UIFont systemFontOfSize:kHZFontSize],
                                                                                           NSForegroundColorAttributeName: _titleColor,
                                                                                           }];
        [_cancleButton setAttributedTitle:attributedTitle forState:UIControlStateNormal];
    }
}

#pragma mark - TableView DataSource & Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _otherTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * kCellIdf = @"kCellIdf";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdf];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdf];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = _otherTitles[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:kHZFontSize];
    
    if ([_destructiveIndexSet containsIndex:indexPath.row]) {
        cell.textLabel.textColor = [UIColor redColor];
    }
    else {
        cell.textLabel.textColor = self.titleColor;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self hideActionSheet];
    
    if ([_delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
        [_delegate actionSheet:self clickedButtonAtIndex:indexPath.row];
    }
}
@end