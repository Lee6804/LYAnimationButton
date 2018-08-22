//
//  LYAnimationBtn.h
//  LYAnimationButton
//
//  Created by Lee on 2018/8/22.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LYAnimationBtnClickBlock)(void);

@interface LYAnimationBtn : UIButton

@property(nonatomic,copy)LYAnimationBtnClickBlock btnClickBlock;

+ (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;

- (void)dismissView;
- (void)failAction;

@end
