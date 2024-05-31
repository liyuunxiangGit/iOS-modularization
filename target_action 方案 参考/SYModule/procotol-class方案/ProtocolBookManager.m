//
//  ProtocolBookManager.m
//  SYModule
//
//  Created by Shen Yuan on 2017/11/25.
//  Copyright © 2017年 Shen Yuan. All rights reserved.
//

#import "ProtocolBookManager.h"
#import "ProcotolManagerTool.h"
#import "ProtocolBookProtocol.h"
#import "ProtocolBookViewController.h"

@interface ProtocolBookManager ()<ProtocolBookProtocol>

@end

@implementation ProtocolBookManager


+ (void)load {
    [[ProcotolManagerTool shareInstance] registerProtocol:@protocol(ProtocolBookProtocol) forClass:[[self alloc] init]];
}


- (UIViewController *)bookVCWithParam:(NSDictionary *)dicParm
{
    ProtocolBookViewController *bookVC = [[ProtocolBookViewController alloc] init];
    bookVC.bookName = dicParm[@"bookName"];
    bookVC.bookId = dicParm[@"bookid"];
    return bookVC;
}

@end
