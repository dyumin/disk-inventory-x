//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "NSObject.h"

@interface NTFolderSearcher : NSObject
{
    int _requestCountPerIteration;
    struct FSCatalogInfo *_catalogInfoArray;
    struct FSRef *_refArray;
    struct HFSUniStr255 *_nameArray;
}

- (id)init;
- (void)dealloc;
- (long)searchFolder:(struct FSRef *)arg1 withString:(id)arg2 matches:(id)arg3 directories:(id)arg4;

@end

