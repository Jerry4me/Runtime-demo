//
//  Person.m
//  Runtime-实践篇
//
//  Created by sky on 16/9/3.
//  Copyright © 2016年 sky. All rights reserved.
//

#import "Person.h"
#import <objc/objc-runtime.h>
#import "Dog.h"

@implementation Person

- (void)study
{
    NSLog(@"study");
}

- (void)eat:(NSString *)food
{
    NSLog(@"eat %@", food);
}

//- (void)run
//{
//    NSLog(@"是人在跑步");
//}


// 用来实现noIMPMethod方法实现的函数
void otherFunction(id self, SEL cmd)
{
    NSLog(@"动态处理了noIMPMethod方法的实现");
}

#pragma mark - 消息转发的四个方法
// 第一步, 对象在收到无法解读的消息后, 首先调用其所属类的这个类方法
// 返回YES则结束消息转发, 返回NO则进入下一步
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    // 如果是noIMPMethod方法
    if([NSStringFromSelector(sel) isEqualToString:@"noIMPMethod"]){
        // 动态添加方法实现
        class_addMethod([self class], sel, (IMP)otherFunction, "v@:");
        return YES;
    } else if ([NSStringFromSelector(sel) isEqualToString:@"run"]){
        return NO; // 不处理
    } else {
        return [super resolveInstanceMethod:sel];
    }
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
    if ([NSStringFromSelector(aSelector) isEqualToString:@"run"]){
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    } else {
        return [super methodSignatureForSelector:aSelector];
    }
}

// 第四步, 最后一次处理该消息的机会
// 这里处理不了这个invocation就会结束消息转发
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    // 在这我们修改调用该方法的对象
    Dog *dog = [[Dog alloc] init];
    // 让dog去调用该方法
    [anInvocation invokeWithTarget:dog];
}

@end
