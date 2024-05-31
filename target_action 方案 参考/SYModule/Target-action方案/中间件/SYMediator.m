//
//  SYMediator.m
//  SYModule
//
//  Created by Shen Yuan on 2017/11/25.
//  Copyright © 2017年 Shen Yuan. All rights reserved.
//

#import "SYMediator.h"

@implementation SYMediator
+(instancetype)shareInstance
{
    static SYMediator *mediator;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mediator = [[SYMediator alloc] init];
    });
    return mediator;
}

- (id)performTargetName:(NSString *)targetName actionName:(NSString *)actionName param:(NSDictionary *)dicParam
{
    if (!targetName || !actionName) {
        return nil;
    }
    
    Class class = NSClassFromString(targetName);
    id target = [[class alloc] init];
    
    if (!target) {
        return nil;
    }
    
    if (dicParam && ![actionName containsString:@":"]) {
        actionName = [actionName stringByAppendingString:@":"];
    }
    
    SEL action = NSSelectorFromString(actionName);
    
    if ([target respondsToSelector:action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        return [target performSelector:action withObject:dicParam];
#pragma clang diagnostic pop
    }else{
        return nil;
    }
    
}

@end
