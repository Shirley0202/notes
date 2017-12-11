
#import "MCDownloadReceipt.h"
#import <CommonCrypto/CommonDigest.h>

extern NSString * cacheFolder();

// 获取一个文件的大小
static unsigned long long fileSizeForPath(NSString *path) {
    
    signed long long fileSize = 0;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSError *error = nil;
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:path error:&error];
        if (!error && fileDict) {
            fileSize = [fileDict fileSize];
        }
    }
    return fileSize;
}
// 获取MD5值
static NSString * getMD5String(NSString *str) {
    
    if (str == nil) return nil;
    
    const char *cstring = str.UTF8String;
    unsigned char bytes[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cstring, (CC_LONG)strlen(cstring), bytes);
    
    NSMutableString *md5String = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [md5String appendFormat:@"%02x", bytes[i]];
    }
    return md5String;
}

@interface MCDownloadReceipt()

@property (nonatomic, assign) MCDownloadState state;

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, copy) NSString *filename;
@property (nonatomic, copy) NSString *truename;
@property (nonatomic, strong) NSProgress *progress;

@property (assign, nonatomic) long long totalBytesWritten;

@end

@implementation MCDownloadReceipt

- (NSString *)filePath {
    if (_filePath == nil) {
        NSString *path = [cacheFolder() stringByAppendingPathComponent:self.filename];
        if (![path isEqualToString:_filePath] ) {
            if (_filePath && ![[NSFileManager defaultManager] fileExistsAtPath:_filePath]) {
                NSString *dir = [_filePath stringByDeletingLastPathComponent];
                [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
            }
            _filePath = path;
        }
    }
    return _filePath;
}


//自定义文件的存储路径
- (void)setCustomFilePathBlock:(nullable MCDownloaderReceiptCustomFilePathBlock)customFilePathBlock {
    _customFilePathBlock = customFilePathBlock;
    if (_customFilePathBlock) {
        NSString *path = customFilePathBlock(self);
        if (path && ![path isEqualToString:_filePath] ) {
            _filePath = path;
            if (_filePath && ![[NSFileManager defaultManager] fileExistsAtPath:_filePath]) {
                NSString *dir = [_filePath stringByDeletingLastPathComponent];
                [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
            }
        }
    }
}

- (NSString *)filename {
    if (_filename == nil) {
        NSString *pathExtension = self.url.pathExtension;
        if (pathExtension.length) {
            _filename = [NSString stringWithFormat:@"%@.%@", getMD5String(self.url), pathExtension];
        } else {
            _filename = getMD5String(self.url);
        }
    }
    return _filename;
}

- (NSString *)truename {
    if (_truename == nil) {
        _truename = self.url.lastPathComponent;
    }
    return _truename;
}

- (NSProgress *)progress {
    if (_progress == nil) {
        _progress = [[NSProgress alloc] initWithParent:nil userInfo:nil];
    }
    @try {
        _progress.totalUnitCount = self.totalBytesExpectedToWrite;
        _progress.completedUnitCount = self.totalBytesWritten;
    } @catch (NSException *exception) {
        
    }
    return _progress;
}

- (long long)totalBytesWritten {
    
    return fileSizeForPath(self.filePath);
}


- (instancetype)initWithURL:(NSString *)url {
    if (self = [self init]) {
        
        self.url = url;
    }
    return self;
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.url forKey:NSStringFromSelector(@selector(url))];
    [aCoder encodeObject:self.filePath forKey:NSStringFromSelector(@selector(filePath))];
    [aCoder encodeObject:@(self.state) forKey:NSStringFromSelector(@selector(state))];
    [aCoder encodeObject:self.filename forKey:NSStringFromSelector(@selector(filename))];
    [aCoder encodeObject:@(self.totalBytesWritten) forKey:NSStringFromSelector(@selector(totalBytesWritten))];
    [aCoder encodeObject:@(self.totalBytesExpectedToWrite) forKey:NSStringFromSelector(@selector(totalBytesExpectedToWrite))];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.url = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(url))];
        self.filePath = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(filePath))];
        self.state = [[aDecoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(state))] unsignedIntegerValue];
        self.filename = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(filename))];
        self.totalBytesWritten = [[aDecoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(totalBytesWritten))] unsignedIntegerValue];
        self.totalBytesExpectedToWrite = [[aDecoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(totalBytesExpectedToWrite))] unsignedIntegerValue];
        
    }
    return self;
}

// 创建一个  receipt downloadOperationCancelToken这个是一个
- (instancetype)initWithURLString:(NSString *)URLString
     downloadOperationCancelToken:(id)downloadOperationCancelToken
          downloaderProgressBlock:(MCDownloaderProgressBlock)downloaderProgressBlock
         downloaderCompletedBlock:(MCDownloaderCompletedBlock)downloaderCompletedBlock {
    
    if (self = [self init]) {
        
        self.url = URLString;
        //
        self.totalBytesExpectedToWrite = 0;
        // 两个回调
        self.downloaderProgressBlock = downloaderProgressBlock;
        self.downloaderCompletedBlock = downloaderCompletedBlock;
    }
    return self;
}










#pragma mark - 下面的都是一些set方法

- (void)setTotalBytesExpectedToWrite:(long long)totalBytesExpectedToWrite {
    _totalBytesExpectedToWrite = totalBytesExpectedToWrite;
}

- (void)setState:(MCDownloadState)state {
    _state = state;
}



- (void)setDownloaderProgressBlock:(MCDownloaderProgressBlock)downloaderProgressBlock {
    _downloaderProgressBlock = downloaderProgressBlock;
}

- (void)setDownloaderCompletedBlock:(MCDownloaderCompletedBlock)downloaderCompletedBlock {
    _downloaderCompletedBlock = downloaderCompletedBlock;
}

- (void)setSpeed:(NSString *)speed {
    _speed = speed;
}



@end
