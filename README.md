@[TOC](iOS组件化)
# 组件化的原因

 - 模块间解耦 
 - 模块重用 
 - 提高团队协作开发效率 
 - 单元测试

当项目App处于起步阶段、各个需求模块趋于成熟稳定的过程中，组件化也许并没有那么迫切，甚至考虑组件化的架构可能会影响开发效率和需求迭代。而当项目迭代到一定时期之后，便会出现一些相对独立的业务功能模块，而团队的规模也会随着项目迭代逐渐增长，这便是中小型应用考虑组件化的时机了。

为了更好的分工协作，团队会安排团队成员各自维护一个相对独立的业务组件。这个时候我们引入组件化方案，一是为了解除组件之间相互引用的代码硬依赖，二是为了规范组件之间的通信接口； 让各个组件对外都提供一个黑盒服务，而组件工程本身可以独立开发测试，减少沟通和维护成本，提高效率。

进一步发展，当团队涉及到转型或者有了新的立项之后，一个团队会开始维护多个项目App，而多个项目App的需求模块往往存在一定的交叉，而这个时候组件化给我们的帮助会更大，我只需要将之前的多个业务组件模块在新的主App中进行组装即可快速迭代出下一个全新App。

# 现在流行的组件化方案
## 方案一、url-block （基于 URL Router）
通过在启动时（load方法中）注册组件提供的服务，把调用组件使用的url和组件提供的服务block对应起来，保存到内存中。在使用组件的服务时，通过url找到对应的block，然后通过block回调获取服务。

url-block的架构图如下：
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/a00d1172a4c733dc2af6f25f2ba7ee50.png)

**代码说明**

首先要在 `+ (void)load `中进行注册

```objectivec
[LYXRouter registerURLPattern:@"lyx://foo/bar" toHandler:^(NSDictionary *routerParameters) {
        // create view controller
    	// push view controllerstringWithFormat:@"routerParameters:%@", routerParameters]];
    }];
   ```

然后调用的时候传入url:

```objectivec
    [MGJRouter openURL:@"lyx://foo/bar"];
```

代码内部会通过传入的url，拿到对应的block，然后进行调用。 
之后block中的回调内部 就会执行 跳转页面的代码了。

使用url-block的方案的确可以组建间的解耦，但是还是存在其它明显的问题，比如：

 - 需要在内存中维护url-block的表，组件多了可能会有内存问题
 - url的参数传递受到限制，只能传递常规的字符串参数，无法传递非常规参数，如UIImage、NSData等类型
 - 没有区分本地调用和远程调用的情况，尤其是远程调用，会因为url参数受限，导致一些功能受限
 - 组件本身依赖了中间件，且分散注册使的耦合较多


## 方案二、protocol
是通过`protocol`定义服务接口，组件通过实现该接口来提供接口定义的服务，具体实现就是把`protocol`和`class`做一个映射，同时在内存中保存一张映射表，使用的时候，就通过`protocol`找到对应的`class`来获取需要的服务。

protocol - class 架构图如下：
![请添加图片描述](https://i-blog.csdnimg.cn/blog_migrate/dc4aa9ac7db2f824d2aa494e708561d4.webp?x-image-process=image/format,png)

### 调用方式解读
**注册：**

```objectivec
[ModuleManager registerClass:ClassA forProtocol:ProtocolA]

```

**调用：**

```java
[ModuleManager classForProtocol:ProtocolA]
```

具体流程可参考如下：
**创建中间件**
1、创建 组件化的中间件manager，中间件 提供注册机制的方法，通过字典存储 procotol-class 
2、中间件manager 提供 通过协议获取class的方法

```objectivec
- (void)registServiceProvide:(id)provide forProcotol:(Protocol *)procotol;

- (id)serviceProvideForProcotol:(Protocol *)procotol;
```

**业务侧提供协议 + 遵循协议的类**
1、提供协议，协议中提供 需要的方法

```objectivec
@protocol ProductDetailServiceProcotol <NSObject>
- (UIViewController *)productDetailViewControllerWithProductId:(NSString *)productId;

@end
```
2、创建类，类遵循协议，实现协议方法，方法内部提供想要的 代码
3、创建的类中的`+ (void)load`方法，内部 调用 中间件 注册protocol-calss

```objectivec
@interface ProductDetailServiceProvide ()<ProductDetailServiceProcotol>

@end

@implementation ProductDetailServiceProvide

//load 方法会在加载类的时候就被调用，也就是 ios 应用启动的时候，就会加载所有的类，就会调用每个类的 + load 方法
+ (void)load
{
    [[ProcotolManager sharedManger] registServiceProvide:[[self alloc] init] forProcotol:@protocol(ProductDetailServiceProcotol)];
}

#pragma mark - ProductDetailServiceProcotol

- (UIViewController *)productDetailViewControllerWithProductId:(NSString *)productId
{
    ProcotolProductDetailViewController *detailVC = [[ProcotolProductDetailViewController alloc] init];
    detailVC.productId = productId;
    return detailVC;
}

@end
```
**调用**
通过协议找到类，然后调用协议 方法「即：最终走的是 协议找到的那个class的方法」
```objectivec
id<ProductOrderServiceProcotol> servicePrivide = [[ProcotolManager sharedManger] serviceProvideForProcotol:@protocol(ProductOrderServiceProcotol)];
    UIViewController *orderVC = [servicePrivide productOrderWithProductId:self.productId];
    [self.navigationController pushViewController:orderVC animated:YES];
```

> 这种方案确实解决了方案一中无法传递非常规参数的问题，使得组件间的调用更为方便，但是它依然没有解决组件依赖中间件的问题、内存中维护映射表的问题、组件的分散调用的问题。

## 方案三、target-action 
**重点词：** `分类` `runtime`
该方案 中间件是通过runtime来调用组件的服务，是真正意义上的解耦，也是该方案最核心的地方。具体实施过程是给组件封装一层target对象来对外提供服务，不会对原来组件造成入侵；然后，通过实现中间件的category来提供服务给调用者，这样使用者只需要依赖中间件，而组件则不需要依赖中间件。

### 调用方式解读
**创建中间件**
中间件内部实现是通过runtime 拿到类和方法，进行调用的

```objectivec
@interface SYMediator : NSObject
+(instancetype)shareInstance;

- (id)performTargetName:(NSString *)targetName actionName:(NSString *)actionName param:(NSDictionary *)dicParam;
@end

```

**创建中间件的分类**
分类中 的方法 调用 中间件的` performTarget... ` 方法，来实现最终的方法调用。

```objectivec

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


```

**创建target**


组件封装一层target对象来对外提供服务

```objectivec
@implementation BookTarget
- (UIViewController *)bookVCWithParam:(NSDictionary *)dicParm
{
    BookViewController *bookVC = [[BookViewController alloc] init];
    bookVC.bookName = dicParm[@"bookName"];
    bookVC.bookId = dicParm[@"bookid"];
    return bookVC;
}
@end

```

**调用**

```objectivec
NSDictionary *dicParm = @{@"bookName" : @"降龙十八掌",@"bookid" : @"sy0001"};
    //第一种方式（有category）
    UIViewController *bookVC = [[SYMediator shareInstance] bookViewControllerWithDicParam:dicParm];
    [self.navigationController pushViewController:bookVC animated:YES];
```
