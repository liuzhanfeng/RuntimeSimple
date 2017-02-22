//
//  ViewController.m
//  RuntimeSimple
//
//  Created by LZF on 2017/2/22.
//  Copyright © 2017年 zf.com. All rights reserved.
//

#import "ViewController.h"
#import "People.h"
#import <objc/runtime.h>

@interface Tool :NSObject
-(NSString *)changeMethod;
@end

@implementation Tool
-(NSString *)changeMethod{
    return @"拦截了一个方法";
    
}

@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* runtime 使用 */
    
    // 1.运行时修改类的变量
    
    People *p = [[People alloc] init];
    p.name = @"张三";
    NSLog(@"People.name = %@",p.name);
    
    //改变 People.name
    unsigned int count = 0;
    Ivar *ivar = class_copyIvarList([p class], &count);
    for (int i = 0; i<count; i++) {
        Ivar var = ivar[i];
        const char *varName = ivar_getName(var);
        NSString *proname = [NSString stringWithUTF8String:varName];
        
        if ([proname isEqualToString:@"_name"]) {  //这里别忘了给属性加下划线
            object_setIvar(p, var, @"李四");
            break;
        }
    }
    NSLog(@"People.name = %@",p.name);
    
    //2.给 Class 动态添加方法
    class_addMethod([p class], @selector(guess), (IMP)guessAnswer, "v@:");
    if ([p respondsToSelector:@selector(guess)]) {
        //Method method = class_getInstanceMethod([self.xiaoMing class], @selector(guess));
        [p performSelector:@selector(guess)];
        
    } else{
        NSLog(@"Sorry,I don't know");
    }
    
    //3.交换方法
    Method m1 = class_getInstanceMethod([p class], @selector(sayName));
    Method m2 = class_getInstanceMethod([p class], @selector(saySex));
    method_exchangeImplementations(m1, m2);
    NSLog(@"sayName = %@ , saySex = %@",p.sayName,p.saySex);

    //4.拦截方法并且替换掉
    Method m11 = class_getInstanceMethod([People class], @selector(sayName));
    Method m22 = class_getInstanceMethod([Tool class], @selector(changeMethod));
    method_exchangeImplementations(m11, m22);
    NSLog(@"sayName = %@",p.sayName);

    
}

void guessAnswer(id self,SEL _cmd){
    
    NSLog(@"i am from beijing");
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
