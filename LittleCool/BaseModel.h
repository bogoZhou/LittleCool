//
//  BaseModel.h
//  LittleCool
//
//  Created by 周博 on 17/3/14.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
- (id)valueForUndefinedKey:(NSString *)key;
@end
