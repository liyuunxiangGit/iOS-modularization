//
//  ProtocolBookProtocol.h
//  SYModule
//
//  Created by Shen Yuan on 2017/11/25.
//  Copyright © 2017年 Shen Yuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol ProtocolBookProtocol <NSObject>
- (UIViewController *)bookVCWithParam:(NSDictionary *)dicParm;
@end
