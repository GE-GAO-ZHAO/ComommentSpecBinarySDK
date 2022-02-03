//
//  ABC.m
//  ABC
//
//  Created by 葛高召 on 2022/1/6.
//

#import "ABC.h"
#import <UsualTool/HLLClientDeciceTool.h>
@implementation ABC

+ (void)test {
    NSLog(@"hello boy, i`m a test static framework!");
    NSLog(@"hello i from UsualTool. des: %@",[HLLClientDeciceTool deviceName]);
}

@end
