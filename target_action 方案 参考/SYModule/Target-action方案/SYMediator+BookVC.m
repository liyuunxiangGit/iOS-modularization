//
//  SYMediator+BookVC.m
//  SYModule
//
//  Created by Shen Yuan on 2017/11/25.
//  Copyright © 2017年 Shen Yuan. All rights reserved.
//

#import "SYMediator+BookVC.h"

static NSString *const kBookTarget = @"BookTarget";
static NSString *const kBookAction = @"bookVCWithParam";

@implementation SYMediator (BookVC)
- (UIViewController *)bookViewControllerWithDicParam:(NSDictionary *)dicParm
{
    UIViewController *vc = [self performTargetName:kBookTarget actionName:kBookAction param:dicParm];
    if ([vc isKindOfClass:[UIViewController class]]) {
        return vc;
    } else {
        return [[UIViewController alloc] init];
    }
}
@end
