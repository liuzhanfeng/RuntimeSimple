//
//  People.h
//  RuntimeSimple
//
//  Created by LZF on 2017/2/22.
//  Copyright © 2017年 zf.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface People : NSObject<NSCoding>
@property (nonatomic , copy) NSString *name;
- (NSString *)sayName;
-(NSString *)saySex;
@end
