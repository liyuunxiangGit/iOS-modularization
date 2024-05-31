//
//  ProcotolManagerTool.m
//  SYModule
//
//  Created by Shen Yuan on 2017/11/25.
//  Copyright © 2017年 Shen Yuan. All rights reserved.
//

#import "ProcotolManagerTool.h"

@interface ProcotolManagerTool ()

@property (nonatomic,strong)NSMutableDictionary *protocolCache;

@end

@implementation ProcotolManagerTool

+ (instancetype)shareInstance
{
    static ProcotolManagerTool *procotolManagerTool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        procotolManagerTool = [[ProcotolManagerTool alloc] init];
    });
    return procotolManagerTool;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.protocolCache = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)registerProtocol:(Protocol *)protocl forClass:(id)provide
{
    if (!protocl || !provide) {
        return;
    }
    
    NSString *protocolName = NSStringFromProtocol(protocl);
    [self.protocolCache setObject:provide forKey:protocolName];
    
}

- (id)classForProtol:(Protocol *)protocol
{
    if (!protocol) {
        return nil;
    }
    return self.protocolCache[NSStringFromProtocol(protocol)];
}

@end
