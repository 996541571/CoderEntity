//
//  Model.h
//  AutoCreateEntity
//
//  Created by 王家俊 on 16/10/6.
//  Copyright © 2016年 KEN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject
{
NSString *propertyName;
NSString *propertyType;
NSString *propertyDesc;
NSString *propertyIndicator;
}
@property(readwrite,copy)NSString *propertyName;
@property(readwrite,copy)NSString *propertyType;
@property(readwrite,copy)NSString *propertyDesc;
@property(readwrite,copy)NSString *propertyIndicator;
@end
