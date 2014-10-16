//
//  Global.m
//  iOS-StarterKit
//
//  Created by Rakesh B on 19/05/14.
//  Copyright (c) 2014 Elevati. All rights reserved.
//

#import "Global.h"
#import "JSONKit.h"

@implementation Global

+ (Global *)defaultGlobal {
    static Global* _sharedObject = nil;
    static dispatch_once_t onePredicate;
    dispatch_once(&onePredicate,^ {
        _sharedObject = [[Global alloc]init];
    });
    return _sharedObject;
}

#pragma Public Methods

/* Get the color on basis of hex string (i.e. #FF0000) */
- (UIColor *)getUIColorObjectFromHexString:(NSString *)hexStr alpha:(CGFloat)alpha
{
    // Convert hex string to an integer
    unsigned int hexint = [self intFromHexString:hexStr];
    
    // Create color object, specifying alpha as well
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexint & 0xFF))/255
                    alpha:alpha];
    
    return color;
}

- (UIImage*)imageFitToFrame:(UIImage*)originalImage scaledToSize:(CGSize)size {
    //avoid redundant drawing
    if (CGSizeEqualToSize(originalImage.size, size))
    {
        return originalImage;
    }
    
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    //draw
    [originalImage drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    
    //capture resultant image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return image
    return image;
}

- (UIImage*)imageAfterCrop:(UIImage *)image andRect:(CGRect)rect {
    
    UIImage *sourceImage = image;
    if ([[UIScreen mainScreen]scale] == 2) {
        sourceImage = [UIImage imageWithCGImage:image.CGImage scale:2 orientation:sourceImage.imageOrientation];
    }
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = rect.size.width;
    CGFloat targetHeight = rect.size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, rect.size) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
        {
            scaleFactor = widthFactor; // scale to fit height
        }
        else
        {
            scaleFactor = heightFactor; // scale to fit width
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            if (thumbnailPoint.y < 0) {
                thumbnailPoint.y = 0;
            }
        }
        else
        {
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
                if (thumbnailPoint.x < 0) {
                    thumbnailPoint.x = 0;
                }
            }
        }
    }
    
    if ([UIScreen mainScreen].scale == 2) {
        UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0.0);
    } else {
        UIGraphicsBeginImageContext(rect.size);
    } // this will crop
    UIGraphicsBeginImageContext(rect.size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil)
    {
        NSLog(@"could not scale image");
    }
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
    
}

- (NSString *)flattenHTML:(NSString *)html {
    
    NSScanner *theScanner;
    NSString *text = nil;
    theScanner = [NSScanner scannerWithString:html];
    
    while ([theScanner isAtEnd] == NO) {
        
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        
        [theScanner scanUpToString:@">" intoString:&text] ;
        
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
    }
    
    html = [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return html;
}

- (int)checkIntValue :(NSString*)code{
    NSScanner *scanner = [NSScanner scannerWithString:code];
    int userRequestId;
    if ([scanner scanInt:&userRequestId]) {
        return userRequestId;
    } else {
        return 0;
    }
}

//Get the file names from the file path
-(NSString *)getFileName:(NSString *)filePath
{
    NSArray  *temp = [[NSArray alloc] initWithArray:[filePath componentsSeparatedByString:@"/"]];
    
    if([temp count] != 0)
        return [temp objectAtIndex:[temp count]-1];
    else
        return @"";
}

//Checks file exists at a specific location
- (BOOL) checkFileExists:(NSString *)filePath{
    
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

-(CGRect)getDynamicHeightForLabel:(CGRect)rect forString:(NSString*)strText forFont:(UIFont*)font forMaxHeight:(CGFloat)maxHeight
{
    if((![strText isEqual:[NSNull null]]) && [strText length] > 0)
    {
        //Calculate the expected size based on the font and linebreak mode of your label (Start)
        CGSize constrainedSize = CGSizeMake(rect.size.width, maxHeight);
        
        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                              font, NSFontAttributeName,
                                              nil];
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:strText attributes:attributesDictionary];
        
        CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        
        if (requiredHeight.size.width >  rect.size.width) {
            requiredHeight = CGRectMake(0, 0, rect.size.width, requiredHeight.size.height);
        }
        CGRect newFrame =  rect;
        newFrame.size.height = requiredHeight.size.height;
        return newFrame;
    }
    else
        return CGRectZero;
}

-(NSString*) convertDictionaryToJSON:(NSDictionary*) jsonDict {
   
    NSString *strArticleDetailsJSON =  [jsonDict JSONStringWithOptions:JKSerializeOptionEscapeUnicode error:nil];
    strArticleDetailsJSON = [strArticleDetailsJSON stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    
    return strArticleDetailsJSON;
}

-(NSDictionary*) convertJSONToDictionary:(NSString*) strArticleDetailsJSON {
    
    strArticleDetailsJSON = [strArticleDetailsJSON stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
    NSDictionary *deserializedData = [strArticleDetailsJSON objectFromJSONString];
    
    return deserializedData;
}

- (void)setUserDefaultValue:(NSString *)data forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getUserDefaultValue:(NSString *)key
{
    NSString *strData= [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if([strData length] == 0)
        strData = @"";
    
    return strData;
}

- (NSString*) getDatabaseStoragePath
{
    [self buildLocalCacheDirectoryLocation];
    NSString *dbDirPath = [NSString stringWithFormat:@"%@/%@",preDocumentDirectoryPath,Database_Name];
    
    return dbDirPath;
}

#pragma Private Methods

- (unsigned int)intFromHexString:(NSString *)hexStr
{
    unsigned int hexInt = 0;
    
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    
    // Scan hex value
    [scanner scanHexInt:&hexInt];
    
    return hexInt;
}

-(void) buildLocalCacheDirectoryLocation
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    preCacheDirectoryPath = [paths objectAtIndex:0];
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    preDocumentDirectoryPath = [documentPaths objectAtIndex:0];
}

@end