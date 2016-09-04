//
//  main.m
//  Runtime-实践篇
//
//  Created by sky on 16/9/3.
//  Copyright © 2016年 sky. All rights reserved.
//  Github : https://github.com/Jerry4me
//  如果觉得对你有帮助的话还请给个star, 谢谢啦^_^

#import <Foundation/Foundation.h>
#import <objc/objc-runtime.h>
#import "Person.h"
#import "Person+RunningMan.h"
#import "Dog.h"

#pragma mark - methods statement
void dynamicAddingClass(const char *className);
void printAllInformation();
void addPropertyForCategory();
void dynamicAddingMethodIMP();
void dynamicChangeMethodInvoker();
void dynamicChangeMethodIMP();

#pragma mark - main

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        /** 动态添加一个类 */
//        dynamicAddingClass("GoodPerson");
        
        /** 打印一个类的所有ivar, property和method */
//        printAllInformation();
        
        /** 给分类增加属性 */
//        addPropertyForCategory();
        
        /** 动态添加方法实现 */
//        dynamicAddingMethodIMP();
        
        /** 动态更换方法调用者 */
//        dynamicChangeMethodInvoker();
        
        /** 动态更改特定方法的实现 */
//        dynamicChangeMethodIMP();
        
    }
    return 0;
}

#pragma mark - methods implementation
void dynamicAddingClass(const char *className)
{
    // 创建一个类(size_t extraBytes该参数通常指定为0, 该参数是分配给类和元类对象尾部的索引ivars的字节数。)
    Class clazz = objc_allocateClassPair([NSObject class], className, 0);
    
    // 添加ivar
    // @encode(aType) : 返回该类型的C字符串
    class_addIvar(clazz, "_name", sizeof(NSString *), log2(sizeof(NSString *)), @encode(NSString *));
    
    class_addIvar(clazz, "_age", sizeof(NSUInteger), log2(sizeof(NSUInteger)), @encode(NSUInteger));
    
    // 注册该类
    objc_registerClassPair(clazz);
    
    // 创建实例对象
    id object = [[clazz alloc] init];
    
    // 设置ivar
    [object setValue:@"Tracy" forKey:@"name"];
    
    Ivar ageIvar = class_getInstanceVariable(clazz, "_age");
    object_setIvar(object, ageIvar, @18);
    
    // 打印对象的类和内存地址
    NSLog(@"%@", object);
    
    // 打印对象的属性值
    NSLog(@"name = %@, age = %@", [object valueForKey:@"name"], object_getIvar(object, ageIvar));
    
    // 当类或者它的子类的实例还存在，则不能调用objc_disposeClassPair方法
    object = nil;
    
    // 销毁类
    objc_disposeClassPair(clazz);
   
}

void printAllInformation()
{
    Person *p = [[Person alloc] init];
    [p setValue:@"Kobe" forKey:@"name"];
    [p setValue:@18 forKey:@"age"];
//    p.address = @"广州大学城";
    p.weight = 110.0f;
    
    // 1.打印所有ivars
    unsigned int ivarCount = 0;
    // 用一个字典装ivarName和value
    NSMutableDictionary *ivarDict = [NSMutableDictionary dictionary];
    Ivar *ivarList = class_copyIvarList([p class], &ivarCount);
    for(int i = 0; i < ivarCount; i++){
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivarList[i])];
        id value = [p valueForKey:ivarName];
        
        if (value) {
            ivarDict[ivarName] = value;
        } else {
            ivarDict[ivarName] = @"值为nil";
        }
    }
    // 打印出来
    for (NSString *ivarName in ivarDict.allKeys) {
        NSLog(@"ivarName:%@, ivarValue:%@",ivarName, ivarDict[ivarName]);
    }
    
    // 2.打印所有properties
    unsigned int propertyCount = 0;
    // 用一个字典装propertyName和value
    NSMutableDictionary *propertyDict = [NSMutableDictionary dictionary];
    objc_property_t *propertyList = class_copyPropertyList([p class], &propertyCount);
    for(int j = 0; j < propertyCount; j++){
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(propertyList[j])];
        id value = [p valueForKey:propertyName];
        
        if (value) {
            propertyDict[propertyName] = value;
        } else {
            propertyDict[propertyName] = @"值为nil";
        }
    }
    // 打印出来
    for (NSString *propertyName in propertyDict.allKeys) {
        NSLog(@"propertyName:%@, propertyValue:%@",propertyName, propertyDict[propertyName]);
    }
    
    // 3.打印所有methods
    unsigned int methodCount = 0;
    // 用一个字典装methodName和arguments
    NSMutableDictionary *methodDict = [NSMutableDictionary dictionary];
    Method *methodList = class_copyMethodList([p class], &methodCount);
    for(int k = 0; k < methodCount; k++){
        SEL methodSel = method_getName(methodList[k]);
        NSString *methodName = [NSString stringWithUTF8String:sel_getName(methodSel)];
        
        unsigned int argumentNums = method_getNumberOfArguments(methodList[k]);
        
        methodDict[methodName] = @(argumentNums - 2); // -2的原因是每个方法内部都有self 和 selector 两个参数
    }
    // 打印出来
    for (NSString *methodName in methodDict.allKeys) {
        NSLog(@"methodName:%@, argumentsCount:%@", methodName, methodDict[methodName]);
    }
    
}

void addPropertyForCategory()
{
    /*
     默认分类是不能添加属性的, 可以利用runtime的set和get associatedObject为对象关联一个对象(属性)
     */
    Person *p = [[Person alloc] init];
    p.speed = 80.0f;
    
    NSLog(@"running man speed is %f km/h", p.speed);
    
    // 大家可以试试在这里打印下属性列表看看发现什么了?
//    printAllInformation();
}

void dynamicAddingMethodIMP()
{
    Person *p = [[Person alloc] init];
    
    [p noIMPMethod];
    
    /*
     这里我们调用person的一个只有方法声明没有实现的方法, 按照惯例应该是报unrecognized selector sent to instance错误, 这里动态添加方法的实现, 程序正常执行
     详细实现请看Person类的.h和.m文件
     */
}

void dynamicChangeMethodInvoker()
{
    Person *p = [[Person alloc] init];
    
    // 这里需要强转一下方法类型, 否则会报太多参数的错误
    ((void(*)(id, SEL))objc_msgSend)((id)p, @selector(run));
    /*
     这里调用person的一个run方法, 其实进入Person类的.h和.m文件你会发现根本没有这个方法, 这里我们就需要动态改变这个方法的调用者, 让Dog去run
     具体实现请看Person的.m文件, 消息转发流程
     */
}

void dynamicChangeMethodIMP()
{
    Dog *dog = [[Dog alloc] init];
    // 让狗调用eat方法
    ((void(*)(id, SEL))objc_msgSend)((id)dog, @selector(eat));
    /*
     本来dog调用的是eat方法, 我们动态修改, 让狗实际调用的是run方法
     具体实现请看Dog的.m文件
     */
}








