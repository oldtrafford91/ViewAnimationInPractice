/*
    Generated for Injection of class implementations
*/

#define INJECTION_NOIMPL
#define INJECTION_BUNDLE InjectionBundle1

#define INJECTION_ENABLED
#import "/tmp/injectionforxcode/BundleInjection.h"

#undef _instatic
#define _instatic extern

#undef _inglobal
#define _inglobal extern

#undef _inval
#define _inval( _val... ) /* = _val */

#import "BundleContents.h"

extern
#if __cplusplus
"C" {
#endif
    int injectionHook(void);
#if __cplusplus
};
#endif

@interface InjectionBundle1 : NSObject
@end
@implementation InjectionBundle1

+ (void)load {
    Class bundleInjection = NSClassFromString(@"BundleInjection");
    [bundleInjection autoLoadedNotify:0 hook:(void *)injectionHook];
}

@end

int injectionHook() {
    NSLog( @"injectionHook():" );
    [InjectionBundle1 load];
    return YES;
}

#import "/Users/trantuanhai/Documents/Github/MyGithub/ViewAnimationInPractice/ViewAnimationInPractice/ViewController.m"



