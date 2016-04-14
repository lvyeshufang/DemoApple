//
//  CommonUtils.h
//  TestTaskXMLData
//
//  Created by machenglong on 15/10/30.
//  Copyright © 2015年 dayang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIkit.h>

@interface CommonUtils : NSObject

+ (NSString *)getCurrentDate;
+ (NSString *)getCurrentDateWithFormat:(NSString *)dateFormat;
+ (NSString *)genGuid;

// 获取文件名，文件路径可以为Asset路径，App沙盒路径或http路径
+ (NSString *)getFileName:(NSString *)filePath;
// 根据Asset URL获取文件名
+ (NSString *)assetGetFileName:(NSString *)assetURL;
// 根据文件名将媒体保存到document/media文件夹中
+ (NSString *)mediaSavedPath:(NSString *) fileName;
// 获取单个文件的大小（单位KB）
+ (float) fileSizeAtPath:(NSString*)filePath;

// 将选取的图片保存到目录文件夹下
+ (BOOL)saveImage:(UIImage *)image docPath:(NSString *)docPath;
// 从ALAsset资产对象读取数据写文件
+ (BOOL)writeDataToPath:(NSString*)filePath andAsset:(ALAsset*)asset;

// 从文件路径读取图片Image（App沙盒路径）
+ (UIImage *)getLocalImage:(NSString *)localPath;
// 获取视频截图（资产路径）
+ (UIImage *)assetGetThumImage:(NSString *)assetPath;

// 把格式化的JSON格式的字符串转换成字典或数组
+ (id)toArrayOrDictionary:(NSString *)jsonString;
// 把字典或数组转换成格式化的JSON格式的字符串
+ (NSString*)toJson:(id)object;

//16进制颜色(html颜色值)字符串转为UIColor
+ (UIColor *)hexStringToColor:(NSString *)stringToConvert;

// 保持原来的长宽比，生成一个缩略图
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;

@end
