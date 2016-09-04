//
//  Person.h
//  Runtime-实践篇
//
//  Created by sky on 16/9/3.
//  Copyright © 2016年 sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject
{
    NSString *_name;
    NSUInteger _age;
}

/** 地址 */
@property (nonatomic, strong) NSString *address;

/** 体重 */
@property (nonatomic, assign) CGFloat weight;

- (void)study;

- (void)eat:(NSString *)food;

// 只有声明没有实现的方法
- (void)noIMPMethod;

// 人的跑步方法
//- (void)run;

@end
