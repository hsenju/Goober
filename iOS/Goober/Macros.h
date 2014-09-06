//
//  EAGLSharegroup_Macros.h
//  Goober
//
//  Created by Hikari Senju on 9/6/14.
//  Copyright (c) 2014 Hikari Senju. All rights reserved.
//

////////////////////////////////////////////////////////////////
// Colors

#define RGBA_R(c) ((((c)>>16) & 0xff) * 1.f/255.f)
#define RGBA_G(c) ((((c)>> 8) & 0xff) * 1.f/255.f)
#define RGBA_B(c) ((((c)>> 0) & 0xff) * 1.f/255.f)
#define RGBA_A(c) ((((c)>>24) & 0xff) * 1.f/255.f)

#define UIColorWithARGB(c)	[UIColor colorWithRed:RGBA_R(c) green:RGBA_G(c) blue:RGBA_B(c) alpha:RGBA_A(c)]
#define UIColorWithRGB(c)	[UIColor colorWithRed:RGBA_R(c) green:RGBA_G(c) blue:RGBA_B(c) alpha:1.0]
#define UIColorWithRGBValues(r, g, b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]
#define UIColorWithRGBAValues(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a/255.0f]

////////////////////////////////////////////////////////////////
// Value macros

#define _SAFE_STR(s) ((s) != nil ? (s) : @"")
#define _SAFE_VALUE(s) ((s) != nil ? (s) : [NSNull null])
#define _DICT_VALUE(s) ((NSNull*)s == [NSNull null]) ? nil : s;
#define _IS_EMPTY(s) (((s) == nil) || ([(s) length] == 0))

////////////////////////////////////////////////////////////////
// Asserts

#define ASSERT_MAIN_THREAD     NSAssert([[NSThread currentThread] isMainThread], @"This method must be called on the main thread.")

////////////////////////////////////////////////////////////////
// WeakSelf

#define DEFINE_WEAK_SELF       __weak __typeof__(self) weakSelf = self

////////////////////////////////////////////////////////////////
// System version

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

////////////////////////////////////////////////////////////////
// Value macros

#define _SAFE_STRING_VALUE(s)       ((s) != nil ? (s) : @"")
#define _SAFE_BOOL_VALUE(s)         ((s) != nil ? (s) : @(NO))
#define _SAFE_NUMBER_VALUE(s)       ((s) != nil ? (s) : @(-1))
#define _SAFE_VALUE(s)              ((s) != nil ? (s) : [NSNull null])

#define _DICT_VALUE(s)              ((NSNull*)s == [NSNull null]) ? nil : s;
#define _IS_EMPTY(s)                (((s) == nil) || ([(s) length] == 0))

#define _IS_FILLED_NUMBER(s)        (((s) != nil) && ([(s) integerValue] != 0))

////////////////////////////////////////////////////////////////
// Rects

#define CGRectMakeFromX(rect, x) \
CGRectMakeIntegral(x, rect.origin.y, rect.size.width, rect.size.height)

#define MoveFrameToX(view, x) \
view.frame = CGRectIntegral(CGRectMake((x), (view).frame.origin.y, (view).frame.size.width, (view).frame.size.height))

#define MoveFrameToY(view, y) \
view.frame = CGRectIntegral(CGRectMake((view).frame.origin.x, (y), (view).frame.size.width, (view).frame.size.height))

#define MoveFrameToYSimple(view, y) \
view.frame = CGRectMake((view).frame.origin.x, (y), (view).frame.size.width, (view).frame.size.height)

#define MoveFrameToXSimple(view, x) \
view.frame = CGRectMake((x), (view).frame.origin.y, (view).frame.size.width, (view).frame.size.height)

#define CenterToX(view, x) \
view.center = CGPointMake((x), (view).center.y)

#define CenterToY(view, y) \
view.center = CGPointMake((view).center.x, (y))

#define SetWidth(view, width) \
view.frame = CGRectIntegral(CGRectMake((view).frame.origin.x, (view).frame.origin.y, (width), (view).frame.size.height))

#define SetHeight(view, height) \
view.frame = CGRectIntegral(CGRectMake((view).frame.origin.x, (view).frame.origin.y, (view).frame.size.width, (height)))

#define SetHeightSimple(view, height) \
view.frame = CGRectMake((view).frame.origin.x, (view).frame.origin.y, (view).frame.size.width, (height))

#define RightEdge(view) \
(view).frame.origin.x + (view).frame.size.width

#define LeftEdge(view) \
(view).frame.origin.x

#define WidthOfView(view) \
(view).frame.size.width

#define HeightOfView(view) \
(view).frame.size.height

#define BottomEdge(view) \
(view).frame.origin.y + (view).frame.size.height

#define CGRectMakeCentered(x, y, width, height) \
CGRectIntegral(CGRectMake((x - width / 2.0f), (y - height / 2.0f), (width), (height)))

#define CGRectMakeIntegral(x, y, width, height) \
CGRectIntegral(CGRectMake((x), (y), (width), (height)))

////////////////////////////////////////////////////////////////
// Logging

#ifdef DEBUG
#define TRC_ENTRY    DDLogWarn(@"ENTRY: %s:%d", __PRETTY_FUNCTION__, __LINE__)
#define TRC_EXIT     DDLogWarn(@"EXIT : %s:%d", __PRETTY_FUNCTION__, __LINE__)
#define TRC_INSIDE   DDLogWarn(@"INSIDE : %s:%d", __PRETTY_FUNCTION__, __LINE__)
#else
#define TRC_ENTRY
#define TRC_EXIT
#define TRC_INSIDE
#endif

#ifdef DEBUG
#define TRC_POINT(name, A)    NSLog(@"POINT %@: [%0.1f, %0.1f]", name, A.x, A.y)
#define TRC_SIZE(name, A)     NSLog(@"SIZE %@: [%0.1f, %0.1f]", name, A.width, A.height)
#define TRC_RECT(name, A)     NSLog(@"RECT %@: [%0.1f, %0.1f, %0.1f, %0.1f]", name, A.origin.x, A.origin.y, A.size.width, A.size.height)
#else
#define TRC_POINT(name, A)
#define TRC_SIZE(name, A)
#define TRC_RECT(name, A)
#endif

#ifdef DEBUG
#define TRC_STR(A)              DDLogVerbose(@"%@", A)
#define TRC_OBJ(A)              DDLogVerbose(@"%@", [A description])
#define TRC_LOG(format, ...)    DDLogVerbose(format, ## __VA_ARGS__)
#define TRC_ERR(format, ...)    DDLogVerbose(@"error: %@, %s:%d " format, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __FUNCTION__, __LINE__, ## __VA_ARGS__)
#else
#define TRC_STR(A)
#define TRC_OBJ(A)
#define TRC_LOG(format, ...)
#define TRC_ERR(format, ...)    DDLogVerbose(@"error: %@, %s:%d " format, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __FUNCTION__, __LINE__, ## __VA_ARGS__)
#endif

#ifdef DEBUG
#define TRC_DATA(A)    DDLogVerbose(@"DATA %10db: %@", [A length], [[NSString alloc] initWithData:A encoding:NSUTF8StringEncoding])
#else
#define TRC_DATA(A)
#endif