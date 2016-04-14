//
//  CommonUtils.m
//  TestTaskXMLData
//
//  Created by machenglong on 15/10/30.
//  Copyright © 2015年 dayang. All rights reserved.
//

#import "CommonUtils.h"


@implementation CommonUtils

static NSDateFormatter *_formatDate = nil;


#pragma mark 日期相关

// 获取当前日期
+ (NSString *)getCurrentDate
{
    if (_formatDate == nil)
        _formatDate = [[NSDateFormatter alloc] init];
    
    [_formatDate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *date = [_formatDate stringFromDate:[NSDate date]];
    return date;
}

//  根据指定格式获取当前日期
+ (NSString *)getCurrentDateWithFormat:(NSString *)dateFormat
{
    if (_formatDate == nil)
        _formatDate = [[NSDateFormatter alloc] init];
    
    [_formatDate setDateFormat:dateFormat];
    NSString *date = [_formatDate stringFromDate:[NSDate date]];
    return date;
}

#pragma mark GUID

// 生成GUID
+ (NSString *)genGuid
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref = CFUUIDCreateString(NULL, uuid_ref);
    
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    
    CFRelease(uuid_string_ref);
    return uuid;
}

#pragma mark 文件信息

// 获取文件名，文件路径可以为Asset路径，App沙盒路径或http路径
+ (NSString *)getFileName:(NSString *)filePath {
    NSString *fileName = @"";
    if ([filePath hasPrefix:@"assets-library"]) {
        fileName = [CommonUtils assetGetFileName:filePath];
    }
    else {
        fileName = [[filePath componentsSeparatedByString:@"/"] lastObject];
    }
    return fileName;
}

// 根据Asset URL获取文件名
//
// Asset URL路径为：
// movie: assets-library://asset/asset.MOV?id=65F9A84E-6B77-4230-85EE-E9A43B52862B@ext=MOV
// png: assets-library://asset/asset.JPG?id=65F9CC40-6B77-E230-8AEE-E9A43B52862B@ext=JPG
// 返回格式为：id.ext
+ (NSString *)assetGetFileName:(NSString *)assetURL {
    NSString *temp = [[assetURL componentsSeparatedByString:@"id="] lastObject];
    NSString *title = [[temp componentsSeparatedByString:@"&ext="] objectAtIndex:0];
    NSString *ext = [[temp componentsSeparatedByString:@"&ext="] lastObject];
    
    NSString *fileName = [NSString stringWithFormat:@"%@.%@", title, ext];
    return fileName;
}

//根据文件名将媒体保存到document/media文件夹中
+ (NSString *)mediaSavedPath:(NSString *) fileName {
    //获取Documents文件夹目录
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    //获取文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //指定新建文件夹路径
    NSString *mediaDocPath = [documentPath stringByAppendingPathComponent:@"media"];
    BOOL dirExist = [fileManager fileExistsAtPath:mediaDocPath];
    if(!dirExist) {
        //创建media文件夹
        [fileManager createDirectoryAtPath:mediaDocPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //返回保存媒体的路径（媒体保存在media文件夹下）
    NSString * mediaPath = [mediaDocPath stringByAppendingPathComponent:fileName];
    return mediaPath;
}

// 获取单个文件的大小（单位KB）
+ (float) fileSizeAtPath:(NSString*)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:filePath]) {
        return [[fileManager attributesOfItemAtPath:filePath error:nil] fileSize] / (1024.0);
    }
    return 0;
}

#pragma mark 文件存储

// 将选取的图片保存到目录文件夹下
+ (BOOL)saveImage:(UIImage *)image docPath:(NSString *)docPath {
    if ((image == nil) || (docPath == nil) || [docPath isEqualToString:@""]) {
        return NO;
    }
    
    @try {
        NSData *imageData = nil;
        //获取文件扩展名
        NSString *extention = [docPath pathExtension];
        if ([extention caseInsensitiveCompare:@"png"] == NSOrderedSame) {
            //返回PNG格式的图片数据
            imageData = UIImagePNGRepresentation(image);
        }else{
            //返回JPG格式的图片数据，第二个参数为压缩系数：1:压缩最少，0:压缩最多（文件最小）
            imageData = UIImageJPEGRepresentation(image, 0);
        }
        if (imageData == nil || [imageData length] <= 0) {
            return NO;
        }
        //将图片写入指定路径
        [imageData writeToFile:docPath atomically:YES];
        return  YES;
    }
    @catch (NSException *exception) {
        NSLog(@"保存图片失败");
    }
    
    return NO;
    
}

// 从ALAsset资产读取数据写文件
+ (BOOL)writeDataToPath:(NSString*)filePath andAsset:(ALAsset*)asset
{
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    if (!handle) {
        return NO;
    }
    static const NSUInteger BufferSize = 1024*1024;
    ALAssetRepresentation *rep = [asset defaultRepresentation];
    uint8_t *buffer = calloc(BufferSize, sizeof(*buffer));
    NSUInteger offset = 0, bytesRead = 0;
    do {
        @try {
            bytesRead = [rep getBytes:buffer fromOffset:offset length:BufferSize error:nil];
            [handle writeData:[NSData dataWithBytesNoCopy:buffer length:bytesRead freeWhenDone:NO]];
            offset += bytesRead;
        } @catch (NSException *exception) {
            free(buffer);
            return NO;
        }
    } while (bytesRead > 0);
    free(buffer);
    return YES;
}

#pragma mark 文件读取

// 从文件路径读取图片Image（App沙盒路径）
+ (UIImage *)getLocalImage:(NSString *)localPath {
    UIImage *image = nil;

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:localPath]) {
        image = [UIImage imageWithData:[fileManager contentsAtPath:localPath]];
    }

    return image;
}

// 获取视频截图（资产路径）
// 注：http视频不存在时，需要很长时间才能返回image为nil
+ (UIImage *)assetGetThumImage:(NSString *)assetPath {
    
    NSURL *assetURL = nil;
    if([assetPath hasPrefix:@"http://"]) {
        assetURL = [NSURL URLWithString:assetPath];
    } else if([assetPath hasPrefix:@"assets-library"]) {
        assetURL = [NSURL URLWithString:assetPath];
    } else if([assetPath hasPrefix:@"file:///"]) {
        assetURL = [NSURL URLWithString:assetPath];
    } else {
        assetURL = [NSURL URLWithString:[NSString stringWithFormat:@"file:///private%@", assetPath]];
    }
    
    UIImage *img = nil;
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:assetURL options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    img = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    
    return img;
}

#pragma mark JSONString与NSDictionary间转换

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典或数组
 * @param jsonString JSON格式的字符串
 * @return 返回字典或数据
 */
+ (id)toArrayOrDictionary:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = nil;
    id object = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return object;
}

/*!
 * @brief 把字典或数组转换成格式化的JSON格式的字符串
 * @param obejct 字典或数组
 * @return 返回JSON字符串
 */
+ (NSString*)toJson:(id)object {
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

//16进制颜色(html颜色值)字符串转为UIColor
+ (UIColor *)hexStringToColor:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 charactersif ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appearsif ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

// 保持原来的长宽比，生成一个缩略图
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height < oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = 0;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = 0;
        }
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, rect.size.width, rect.size.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

@end
