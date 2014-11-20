//
//  CCBPublishLuaBindingScript.m
//  CocosBuilder
//
//  Created by zhengle on 14-11-20.
//
//

#import "CCBPublishLuaBindingScript.h"

@implementation CCBPublishLuaBindingScript

+ (NSString*) exportString:(NSDictionary*) doc ccbiName:(NSString*)ccbiName
{
    NSDictionary* nodeGraph = [doc objectForKey:@"nodeGraph"];
    NSString* className = [nodeGraph objectForKey:@"customClass"];
    if ( ! className || ! className.length) {
        return nil;
    }
    
    ccbiName = [NSString stringWithFormat:@"ccb/%@.ccbi", ccbiName];
    
    // load templates
    NSString* classTemplatePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/luaTemplate/class_template.lua"];
    NSString* functionTemplatePath = [[classTemplatePath stringByDeletingLastPathComponent] stringByAppendingString:@"/function_template.lua"];

    NSString* classTemplate = [NSString stringWithContentsOfFile:classTemplatePath encoding:NSUTF8StringEncoding error:nil];
    NSString* functionTemplate = [NSString stringWithContentsOfFile:functionTemplatePath encoding:NSUTF8StringEncoding error:nil];
    
    // load functions
//    functionTemplate = [functionTemplate stringByReplacingOccurrencesOfString:@"__CLASS_NAME__" withString:className];
    
    NSMutableArray* funcNames = [NSMutableArray array];
    [CCBPublishLuaBindingScript fillFuncs:nodeGraph funcNames:funcNames];
    
    NSString* funcNameReplacement = @"";
    NSString* funcImplementReplacement = @"";
    for (NSString* funcName in funcNames) {
        // build names
        if (funcNameReplacement.length > 0)
        {
            funcNameReplacement = [funcNameReplacement stringByAppendingString:@"\n    "];
        }
        funcNameReplacement = [funcNameReplacement stringByAppendingFormat:@"\"%@\",", funcName];
        
        // build implements
        if (funcImplementReplacement.length > 0)
        {
            funcImplementReplacement = [funcImplementReplacement stringByAppendingString:@"\n\n"];
        }
        funcImplementReplacement = [funcImplementReplacement stringByAppendingString:[functionTemplate stringByReplacingOccurrencesOfString:@"__FUNC_NAME__" withString:funcName]];
    }
    
    // replace contents
    NSString* content = classTemplate;
    
    content = [content stringByReplacingOccurrencesOfString:@"__CCBI_FILE_PATH__" withString:ccbiName];
    content = [content stringByReplacingOccurrencesOfString:@"__FUNC_NAMES__" withString:funcNameReplacement];
    content = [content stringByReplacingOccurrencesOfString:@"__FUNC_IMPLEMENTS__" withString:funcImplementReplacement];
    content = [content stringByReplacingOccurrencesOfString:@"__CLASS_NAME__" withString:className];
    
    return content;
}

+ (void) fillFuncs:(NSDictionary*) node funcNames:(NSMutableArray*) funcNames
{
    NSString* className = [node objectForKey:@"baseClass"];
    NSLog(@"fillFuncs: %@", className);
    
    // push to funcNames
    NSArray* classList = [NSArray arrayWithObjects:@"CCMenuItemImage", @"CCControl", @"CCControlButton", nil];
    if ([classList containsObject:className]) {
        //check property
        for (NSDictionary* prop in [node objectForKey:@"properties"]) {
            NSString* type = [prop objectForKey:@"type"];
            if ( ! [type isEqualToString:@"Block"] && ! [type isEqualToString:@"BlockCCControl"] ) continue;
            
            NSArray* value = (NSArray*)[prop objectForKey:@"value"];
            NSString* selector = [value objectAtIndex:0];
            [funcNames addObject:selector];
        }
        return;
    }
    
    // find children
    NSArray* children = [node objectForKey:@"children"];
    if ( ! children || ! children.count) {
        return;
    }
    
    for (NSDictionary* n in children) {
        [CCBPublishLuaBindingScript fillFuncs:n funcNames:funcNames];
    }
}

@end
