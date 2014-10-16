//
//  Global.h
//  iOS-StarterKit
//
//  Created by Rakesh B on 19/05/14.
//  Copyright (c) 2014 Elevati. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"

@class Config;

@interface Global : NSObject
{
    NSString *preCacheDirectoryPath;
    NSString *preDocumentDirectoryPath;
}

+ (Global*) defaultGlobal;

/* Get the color on basis of hex string (i.e. #FF0000) */
- (UIColor *) getUIColorObjectFromHexString:(NSString *)hexStr alpha:(CGFloat)alpha;
- (NSString*) getFileName:(NSString *)filePath;

/* Methods for Image Operations */
- (UIImage*) imageFitToFrame:(UIImage*)originalImage scaledToSize:(CGSize)size;
- (UIImage*) imageAfterCrop:(UIImage*)image andRect:(CGRect)rect;

/* Get the height from text and its lable properties like font */
- (CGRect) getDynamicHeightForLabel:(CGRect)rect forString:(NSString*)strText forFont:(UIFont*)font forMaxHeight:(CGFloat)maxHeight;

/* Converting Dictionary to JSON and vice versa */
- (NSString*) convertDictionaryToJSON:(NSDictionary*) jsonDict;
- (NSDictionary*) convertJSONToDictionary:(NSString*) strArticleDetailsJSON;

/* For storing and retrieving the values from defaults*/
- (void) setUserDefaultValue:(NSString *)data forKey:(NSString *)key;
- (NSString *) getUserDefaultValue:(NSString *)key;

/* Methods for file operations */
- (BOOL) checkFileExists:(NSString *)filePath;

/* Remove html tags from string */
- (NSString*) flattenHTML:(NSString *)html;

- (NSString*) getDatabaseStoragePath;

@end
