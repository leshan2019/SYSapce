//
//  NSString+SYAES.h
//  Shining
//
//  Created by 鹏飞 季 on 2019/3/10.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SYAES)

/**< 加密方法 */
- (NSString*)sy_aci_encryptWithAES;

/**< 解密方法 */
- (NSString*)sy_aci_decryptWithAES;

@end
