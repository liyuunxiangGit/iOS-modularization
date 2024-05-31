//
//  BookTarget.m
//  SYModule
//
//  Created by Shen Yuan on 2017/11/25.
//  Copyright © 2017年 Shen Yuan. All rights reserved.
//

#import "BookTarget.h"
#import "BookViewController.h"

@implementation BookTarget
- (UIViewController *)bookVCWithParam:(NSDictionary *)dicParm
{
    BookViewController *bookVC = [[BookViewController alloc] init];
    bookVC.bookName = dicParm[@"bookName"];
    bookVC.bookId = dicParm[@"bookid"];
    return bookVC;
}
@end
