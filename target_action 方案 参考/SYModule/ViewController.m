//
//  ViewController.m
//  SYModule
//
//  Created by Shen Yuan on 2017/11/25.
//  Copyright © 2017年 Shen Yuan. All rights reserved.
//

#import "ViewController.h"
#import "SYMediator+BookVC.h"
#import "MGJRouter.h"
#import "ProtocolBookProtocol.h"
#import "ProcotolManagerTool.h"
#import "ProtocolBookManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
#pragma mark - 协议路由

- (IBAction)procotolAction:(id)sender {
    
    // procotol-class 方案 有点绕 这个方案跟刚才两个最大的不同就是，它不是直接通过 Mediator 调用组件方法，而是通过 Mediator 拿到组件对象，再自行去调用组件方法
    NSDictionary *dicParm = @{@"bookName" : @"降龙十八掌",@"bookid" : @"sy0001"};

    //1.拿到组件对象
    id<ProtocolBookProtocol> protocolBookManager = [[ProcotolManagerTool shareInstance] classForProtol:@protocol(ProtocolBookProtocol)];
    //2.通过组件对象 再传值
    UIViewController *bookVC = [protocolBookManager bookVCWithParam:dicParm];
    [self.navigationController pushViewController:bookVC animated:YES];


    
}

#pragma mark - targetAction方案
- (IBAction)targetAction:(id)sender {
    NSDictionary *dicParm = @{@"bookName" : @"降龙十八掌",@"bookid" : @"sy0001"};
    //第一种方式（有category）
    UIViewController *bookVC = [[SYMediator shareInstance] bookViewControllerWithDicParam:dicParm];
    [self.navigationController pushViewController:bookVC animated:YES];
    
//    第二种方式 其实不对SYMediator 增加Category也是可以实现的，就是代码比较恶心而已 下面就是例子
//    UIViewController *bookVC2 = [[SYMediator shareInstance] performTargetName:@"BookTarget" actionName:@"bookVCWithParam" param:dicParm];
//    [self.navigationController pushViewController:bookVC2 animated:YES];
    
}

#pragma mark - 蘑菇街Url方案
- (IBAction)urlAction:(id)sender {
    
    NSDictionary *dicParm = @{@"bookName" : @"降龙十八掌",@"bookid" : @"sy0001"};

    UIViewController *bookVC = [MGJRouter objectForURL:@"symodule://book" withUserInfo:dicParm];
    [self.navigationController pushViewController:bookVC animated:YES];

    
}

@end
