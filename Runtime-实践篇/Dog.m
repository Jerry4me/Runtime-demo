//
//  Dog.m
//  Runtime-实践篇
//
//  Created by sky on 16/9/4.
//  Copyright © 2016年 sky. All rights reserved.
//

#import "Dog.h"
#import <objc/objc-runtime.h>

@implementation Dog


- (void)run
{
    NSLog(@"是狗在跑步");
}

//- (void)eat
//{
//    NSLog(@"狗吃东西");
//}

#pragma mark - 消息转发
// 第一步, 对象在收到无法解读的消息后, 首先调用其所属类的这个类方法
// 返回YES则结束消息转发, 返回NO则进入下一步
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    return NO;
}

// 第二步, 动态方法解析失败, 则调用这个方法
// 返回的对象将处理该selector, 返回nil则进入下一步
- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return nil;
}

// 第三步, 在这里返回方法的消息签名
// 返回YES则进入下一步, 返回nil则结束消息转发
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    if ([NSStringFromSelector(aSelector) isEqualToString:@"eat"]){
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    } else {
        return [super methodSignatureForSelector:aSelector];
    }
}

// 第四步, 最后一次处理该消息的机会
// 这里处理不了这个invocation就会结束消息转发
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    // 在这我们修改选择子
    [anInvocation setSelector:@selector(run)];
    // 让dog去调用该方法
    [anInvocation invokeWithTarget:self];
}

@end
