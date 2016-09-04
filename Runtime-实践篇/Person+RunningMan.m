//
//  Person+RunningMan.m
//  Runtime-实践篇
//
//  Created by sky on 16/9/3.
//  Copyright © 2016年 sky. All rights reserved.
//

#import "Person+RunningMan.h"
#import <objc/objc-runtime.h>

@implementation Person (RunningMan)

- (CGFloat)speed
{
    id value = objc_getAssociatedObject(self, _cmd);
    return [value doubleValue];
}

- (void)setSpeed:(CGFloat)speed
{
    objc_setAssociatedObject(self, @selector(speed), @(speed), OBJC_ASSOCIATION_ASSIGN);
}

@end
