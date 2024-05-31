//
//  SYMediator.h
//  SYModule
//
//  Created by Shen Yuan on 2017/11/25.
//  Copyright © 2017年 Shen Yuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYMediator : NSObject
+(instancetype)shareInstance;

- (id)performTargetName:(NSString *)targetName actionName:(NSString *)actionName param:(NSDictionary *)dicParam;
@end
