//
//  ProcotolManagerTool.h
//  SYModule
//
//  Created by Shen Yuan on 2017/11/25.
//  Copyright © 2017年 Shen Yuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProcotolManagerTool : NSObject
+ (instancetype)shareInstance;

- (void)registerProtocol:(Protocol *)protocl forClass:(id)provide;

- (id)classForProtol:(Protocol *)protocol;

@end
