/*
 *  FileUtils.h
 *  iOS Helpers
 *
 *
 */
#ifndef FILE_UTILS_H
#define FILE_UTILS_H


inline static NSString* filePathInDirectory(NSString* fileName, NSSearchPathDirectory directory) {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES);
	return [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
}

inline static NSString* documentsFilePath(NSString* fileName)
{
	return filePathInDirectory(fileName, NSDocumentDirectory);
}

inline static NSString* cachesFilePath(NSString* fileName) {
    return filePathInDirectory(fileName, NSCachesDirectory);
}

inline static NSString* bundlePath(NSString* fileName) {
	return [[NSBundle mainBundle] pathForResource:[fileName stringByDeletingPathExtension] ofType:[fileName pathExtension]];
}

inline static BOOL createDirectory(NSString* dirName) {
	return [[NSFileManager defaultManager] createDirectoryAtPath:dirName withIntermediateDirectories:YES attributes:nil error:nil];
}

inline static BOOL isFileExists(NSString* fileName) {
    if ([fileName length]) {
        return [[NSFileManager defaultManager] fileExistsAtPath:[documentsFilePath(kImagePathDownload) stringByAppendingPathComponent:fileName]];
    }
    return NO;
}

inline static NSString* imageFilePath(NSString* fileName) {
	return [documentsFilePath(kImagePathDownload) stringByAppendingPathComponent:fileName];
}

inline static NSString* cardImageFilePath(NSString* fileName) {
	return [documentsFilePath(kCardImages) stringByAppendingPathComponent:fileName];
}

inline static BOOL isCardFileExists(NSString* fileName) {
	return [[NSFileManager defaultManager] fileExistsAtPath:[documentsFilePath(kCardImages) stringByAppendingPathComponent:fileName]];
}


inline static NSString* makeFileName(NSString *ID, NSString* fileName) {
    if (ID && fileName) {
        return [ID stringByAppendingString:fileName];
    }
    return @"";
}


#endif
