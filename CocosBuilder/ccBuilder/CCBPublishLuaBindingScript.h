//
//  CCBPublishLuaBindingScript.h
//  CocosBuilder
//
//  Created by zhengle on 14-11-20.
//
//

#import <Foundation/Foundation.h>

@interface CCBPublishLuaBindingScript : NSObject

+ (NSString*) exportString:(NSDictionary*) doc ccbiName:(NSString*)name;
+ (void) fillFuncs:(NSDictionary*) node funcNames:(NSMutableArray*) funcNames;

@end
