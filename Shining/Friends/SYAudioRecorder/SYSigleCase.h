//
//  SYSigleCase.h
//  Shining
//
//  Created by letv_lzb on 2019/3/5.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#define SYSingleCaseH(name) +(instancetype)share##name;

#define SYSingleCaseM(name)  \
static id instanceMessages;\
+(instancetype)allocWithZone:(struct _NSZone *)zone\
{\
\
static dispatch_once_t onceToken;\
\
dispatch_once(&onceToken, ^{\
\
instanceMessages = [super allocWithZone:zone];\
\
});\
\
return instanceMessages;\
}\
-(id)copy\
{\
return instanceMessages;\
}\
+(instancetype)share##name\
{\
\
static dispatch_once_t onceToken;\
\
dispatch_once(&onceToken, ^{\
\
instanceMessages = [[self alloc]init];\
\
});\
\
return instanceMessages;\
}
