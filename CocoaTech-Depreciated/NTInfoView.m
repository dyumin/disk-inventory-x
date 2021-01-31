//
//  NTInfoView.m
//  Path Finder
//
//  Created by Steve Gehrman on Sat Jul 12 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import "NTInfoView.h"
#import "NTTitledInfoPair.h"
#import "AppsForItem.h"
#import "NSURL-Extensions.h"
#import "NTLocalizedString.h"

#pragma warning "ID3 support removed"
//#import "NTID3Helper.h"

@interface NTInfoView (Private)
- (void)createInfoView;
- (void)updateInfoView;
- (NSArray*)infoPairs;
- (NSArray*)longInfoPairs;
- (void)resetForNewItem;
- (NSArray*)sizePairs;

// adopted from CocoaTechFile (NTFileDesc-NTUtilities.m)
+ (NSString*) permissionStringForURL: (NSURL*) URL;
+ (NSString*)permissionOctalStringForModeBits:(UInt16)modeBits;
@end

@implementation NTInfoView

- (id)initWithFrame:(NSRect)frame longFormat:(BOOL)longFormat;
{
    self = [super initWithFrame:frame];
    
    _longFormat = longFormat;
    
    [self setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];

    [self createInfoView];
    
    /*
	 _calcSizeThread = [[NTThreadWorkerController alloc] init];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sizeCalcNotification:)
                                                 name:[_calcSizeThread notificationName]
                                               object:nil];
    */
    return self;
}

- (id)initWithFrame:(NSRect)frame;
{
    self = [self initWithFrame:frame longFormat:NO];
    
    return self;
}

- (void)dealloc;
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [_URL release];
    [_titledInfoView release];
    [_calculatedFolderNumItems release];
    
    [super dealloc];
}

- (NSURL*) URL
{
    return _URL;
}

- (void)setURL:(NSURL*)url;
{    
    [self resetForNewItem];

    _URL = [url retain];

    [self updateInfoView];
}

@end

// ===============================================================================

@implementation NTInfoView (Private)

- (void)resetForNewItem;
{
    //[_calcSizeThread halt];
    
    [_URL autorelease];
    _URL = nil;
    
    [_calculatedFolderNumItems release];
    _calculatedFolderNumItems = nil;
}

- (void)createInfoView;
{
    NSRect contentRect;
    NSScrollView* scrollView;
    
    scrollView = [[[NSScrollView alloc] initWithFrame:[self bounds]] autorelease];
    
    [scrollView setAutohidesScrollers:YES];
    [scrollView setHasHorizontalScroller:NO];
    [scrollView setHasVerticalScroller:YES];
    [scrollView setAutoresizesSubviews:YES];
    [scrollView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    [scrollView setBorderType:NSNoBorder];
    [scrollView setScrollsDynamically:YES];
    [scrollView setDrawsBackground:YES];
    [[scrollView contentView] setCopiesOnScroll:YES];
    
    // set small scrollbars
    if ([scrollView verticalScroller])
        [[scrollView verticalScroller] setControlSize:NSSmallControlSize];
    if ([scrollView horizontalScroller])
        [[scrollView horizontalScroller] setControlSize:NSSmallControlSize];
    
    contentRect = [scrollView bounds];
    contentRect.size = [scrollView contentSize];
    
    _titledInfoView = [[NTTitledInfoView alloc] initWithFrame:contentRect];
    
    // longFormat is used in the GetInfo window, keep the extra space in that case
    if (!_longFormat)
        [_titledInfoView setHorizontalOffset:0];  // don't waste any horizontal space
    
    // add the document view to the scroller
    [scrollView setDocumentView:_titledInfoView];
    
    [self addSubview:scrollView];
}

- (void)updateInfoView;
{
    NSArray* array;
    
    if (_longFormat)
        array = [self longInfoPairs];
    else
        array = [self infoPairs];
    
    [_titledInfoView setWithArray:array];
}

- (NSArray*)infoPairs;
{
    NSMutableArray* infoPairs = [NSMutableArray arrayWithCapacity:15];
    
    if (_URL && [_URL stillExists])
    {
        [infoPairs addObject:[NTTitledInfoPair infoPair:[NTLocalizedString localize:@"Name:" table:@"preview"] info:[_URL cachedDisplayName]]];
        
        NSString *kindName = [_URL getCachedStringValue: NSURLLocalizedTypeDescriptionKey];
        [infoPairs addObject:[NTTitledInfoPair infoPair:[NTLocalizedString localize:@"Kind:" table:@"preview"] info:kindName]];
        
        if ([_URL isVolume] && ![_URL isLocalVolume])
        {
            NSURL *networkURL = nil;
            [_URL getResourceValue: &networkURL forKey: NSURLVolumeURLForRemountingKey error: nil];
            if ( networkURL != nil )
                [infoPairs addObject:[NTTitledInfoPair infoPair:[NTLocalizedString localize:@"URL:"] info: [networkURL absoluteString]]];
        }

        [infoPairs addObjectsFromArray:[self sizePairs]];
        
        {
            NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
            [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
            [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
            [dateFormatter setLocale:[NSLocale currentLocale]];
            
            [infoPairs addObject:[NTTitledInfoPair infoPair: [NTLocalizedString localize:@"Modified:" table:@"preview"]
                                                       info: [dateFormatter stringFromDate:[_URL cachedModificationDate]]]];
            [infoPairs addObject:[NTTitledInfoPair infoPair: [NTLocalizedString localize:@"Created:" table:@"preview"]
                                                       info: [dateFormatter stringFromDate:[_URL cachedCreationDate]]]];
        }
        
        NSDictionary<NSFileAttributeKey, id> *attribs = [[NSFileManager defaultManager] attributesOfItemAtPath:[_URL path] error:nil];
        
        if ( attribs != nil )
        {
            [infoPairs addObject:[NTTitledInfoPair infoPair:[NTLocalizedString localize:@"Owner:" table:@"preview"] info:[attribs fileOwnerAccountName]]];
            [infoPairs addObject:[NTTitledInfoPair infoPair:[NTLocalizedString localize:@"Group:" table:@"preview"] info:[attribs  fileGroupOwnerAccountName]]];
        }
        
        [infoPairs addObject:[NTTitledInfoPair infoPair:[NTLocalizedString localize:@"Permission:" table:@"preview"] info:[NTInfoView permissionStringForURL: _URL]]];

        {
            NSBundle *bundle = [NSBundle bundleWithURL:_URL];
            if (bundle)
            {
                NSString *version = nil;
                
                struct
                { NSDictionary *dict; NSString *key; } bundleVersionInfos
                []=
                {
                    { [bundle localizedInfoDictionary], @"CFBundleGetInfoString" },
                    { [bundle infoDictionary],          @"CFBundleGetInfoString" },
                    { [bundle localizedInfoDictionary], @"CFBundleShortVersionString" },
                    { [bundle infoDictionary],          @"CFBundleShortVersionString" },

                };
                
                for ( int i = 0;
                     i < sizeof(bundleVersionInfos)/sizeof(bundleVersionInfos[0])
                    && (version == nil || [version length] == 0);
                    i++)
                {
                    version = [bundleVersionInfos[i].dict objectForKey:bundleVersionInfos[i].key];
                }
                
                if (version && [version length])
                    [infoPairs addObject:[NTTitledInfoPair infoPair:[NTLocalizedString localize:@"Version:" table:@"preview"] info:version]];
            }
        }
        
        [infoPairs addObject:[NTTitledInfoPair infoPair:[NTLocalizedString localize:@"Path:" table:@"preview"] info:[_URL path]]];
        
        // if alias or symbolic link - resolved:
        NSURL *resolvedURL = nil; //needed below
        if ([_URL cachedIsAliasOrSymbolicLink] )
        {
            NSString *resolvedPath = [[NSFileManager defaultManager] destinationOfSymbolicLinkAtPath:[_URL path] error:nil];
            
            if (resolvedPath)
            {
                resolvedURL = [NSURL fileURLWithPath:resolvedPath];
                
                [infoPairs addObject:[NTTitledInfoPair infoPair:[NTLocalizedString localize:@"Resolved:" table:@"preview"] info:resolvedPath]];
            }
        }
 
        // application to open the file
        {
            NSURL *url = (resolvedURL != nil ? resolvedURL : _URL);

            NSURL *appURL = [[AppsForItem appsForItemURL:url] defaultAppURL];

            // if _URL is an application, LSCopyDefaultApplicationURLForURL(..) returns the app URL, so sort that out
            if (appURL != nil && ![appURL isEqualToURL: _URL])
            {
                    [infoPairs addObject:[NTTitledInfoPair infoPair:[NTLocalizedString localize:@"Application:" table:@"preview"] info:[appURL displayName]]];
            }
        }
#pragma warning "ID3 support disabled"
/*
        if ([typeID isMP3])
        {
            NTID3Helper* helper = [NTID3Helper helperWithPath:[_desc path]];
            [infoPairs addObject:[NTTitledInfoPair infoPair:[NTLocalizedString localize:@"MP3:" table:@"preview"] info:[helper infoString]]];
        }
*/

        /*
        [infoPairs addObject:[NTTitledInfoPair infoPair:[NTLocalizedString localize:@"Format:" table:@"preview"] info:[_URL cachedVolumeFormatName]]];
        [infoPairs addObject:[NTTitledInfoPair infoPair:[NTLocalizedString localize:@"Mount Point:" table:@"preview"] info:[[volume mountPoint] path]]];
        [infoPairs addObject:[NTTitledInfoPair infoPair:[NTLocalizedString localize:@"Device:" table:@"preview"] info:[volume mountDevice]]];
 */   }
    return infoPairs;
}


- (NSArray*)longInfoPairs;
{
    NSMutableArray* infoPairs = [NSMutableArray arrayWithCapacity:15];
    
    if (_URL && [_URL stillExists])
     {
         [infoPairs addObject:[NTTitledInfoPair infoPair:[NTLocalizedString localize:@"Name:" table:@"preview"] info:[_URL cachedDisplayName]]];
         
         NSString *kindName = [_URL getCachedStringValue: NSURLLocalizedTypeDescriptionKey];
         [infoPairs addObject:[NTTitledInfoPair infoPair:[NTLocalizedString localize:@"Kind:" table:@"preview"] info:kindName]];
         
         if ([_URL isVolume] && ![_URL isLocalVolume])
         {
             NSURL *networkURL = nil;
             [_URL getResourceValue: &networkURL forKey: NSURLVolumeURLForRemountingKey error: nil];
             if ( networkURL != nil )
                 [infoPairs addObject:[NTTitledInfoPair infoPair:[NTLocalizedString localize:@"URL:"] info: [networkURL absoluteString]]];
         }

        
        [infoPairs addObjectsFromArray:[self sizePairs]];
        
#pragma warning "to be reimplemented using NSURL & co"
/*
        [infoPairs addObject:[NTTitledInfoPair infoPair:[NTLocalizedString localize:@"Modified:" table:@"preview"] info:[[_desc modificationDate] dateString:kLongDate relative:NO]]];
        [infoPairs addObject:[NTTitledInfoPair infoPair:[NTLocalizedString localize:@"Created:" table:@"preview"] info:[[_desc creationDate] dateString:kLongDate relative:NO]]];
        [infoPairs addObject:[NTTitledInfoPair infoPair:[NTLocalizedString localize:@"Path:" table:@"preview"] info:[_desc path]]];
        
         // if alias or symbolic link - resolved:
        if ([_desc isAlias])
        {
            NTFileDesc* resolved = [_desc descResolveIfAlias];
            
            if (resolved)
                [infoPairs addObject:[NTTitledInfoPair infoPair:[NTLocalizedString localize:@"Resolved:" table:@"preview"] info:[resolved path]]];
        }
        
        // version
        {
            NSString* version = [_desc infoString];
            
            if (!version || ![version length])
                version = [_desc versionString];
            
            if (version && [version length])
                [infoPairs addObject:[NTTitledInfoPair infoPair:[NTLocalizedString localize:@"Version:" table:@"preview"] info:version]];
        }
        
        // make sure the item is resolved (match the pref)
        if ([descPref application] != nil)
        {  
            NTFileDesc* appDesc = [descPref application];
            
            if ([appDesc isValid])
                [infoPairs addObject:[NTTitledInfoPair infoPair:[NTLocalizedString localize:@"Application:" table:@"preview"] info:[appDesc displayName]]];
        }
*/
#pragma warning "ID3 support removed"
        // mp3
       /*
       if ([typeID isMP3])
        {
            NTID3Helper* helper = [NTID3Helper helperWithPath:[_desc path]];
            [infoPairs addObject:[NTTitledInfoPair infoPair:[NTLocalizedString localize:@"MP3:" table:@"preview"] info:[helper infoString]]];
        }
        */

#pragma warning "to be reimplemented using NSURL & co"
/*
         NTVolume *volume = [_desc volume];
         
        [infoPairs addObject:[NTTitledInfoPair infoPair:[NTLocalizedString localize:@"Volume:" table:@"preview"] info:[[volume mountPoint] displayName]]];
        [infoPairs addObject:[NTTitledInfoPair infoPair:[NTLocalizedString localize:@"Capacity:" table:@"preview"] info:[[NTSizeFormatter sharedInstance] fileSize:[volume totalBytes]]]];
        [infoPairs addObject:[NTTitledInfoPair infoPair:[NTLocalizedString localize:@"Free:" table:@"preview"] info:[[NTSizeFormatter sharedInstance] fileSize:[volume freeBytes]]]];
        [infoPairs addObject:[NTTitledInfoPair infoPair:[NTLocalizedString localize:@"Format:" table:@"preview"] info:[volume fileSystemName]]];
        [infoPairs addObject:[NTTitledInfoPair infoPair:[NTLocalizedString localize:@"Mount Point:" table:@"preview"] info:[[volume mountPoint] path]]];
        [infoPairs addObject:[NTTitledInfoPair infoPair:[NTLocalizedString localize:@"Device:" table:@"preview"] info:[volume mountDevice]]];
 */
    }
    
    return infoPairs;
}

- (NSArray*)sizePairs
{
    NSMutableArray* infoPairs = [NSMutableArray arrayWithCapacity:2];

    #pragma warning "to be reimplemented using NSURL & co"
    /*

    if ([_desc isFile])
    {
        UInt64 dataSize = 0, rsrcSize = 0;
        NSMutableString* sizeResult;
        NSNumberFormatter* numFormatter = [[[NSNumberFormatter alloc] init] autorelease];
        
        [numFormatter setFormat:@"#,##0"];
        
        dataSize = [_desc dataForkSize];
        rsrcSize = [_desc rsrcForkSize];
        
        sizeResult = [NSMutableString stringWithString:[[NTSizeFormatter sharedInstance] fileSize:[_desc size]]];;
        
        if (dataSize)
        {
            [sizeResult appendString:@"\n"];
            [sizeResult appendString:[NTLocalizedString localize:@"data:" table:@"preview"]];
            [sizeResult appendString:[numFormatter stringForObjectValue:[NSNumber numberWithUnsignedLongLong:dataSize]]];
            [sizeResult appendString:[NTLocalizedString localize:@" bytes" table:@"preview"]];
        }
        
        if (rsrcSize)
        {
            [sizeResult appendString:@"\n"];
            [sizeResult appendString:[NTLocalizedString localize:@"rsrc:" table:@"preview"]];
            [sizeResult appendString:[numFormatter stringForObjectValue:[NSNumber numberWithUnsignedLongLong:rsrcSize]]];
            [sizeResult appendString:[NTLocalizedString localize:@" bytes" table:@"preview"]];
        }
        
        [infoPairs addObject:[NTTitledInfoPair infoPair:[NTLocalizedString localize:@"Size:" table:@"preview"] info:sizeResult]];
    }
    else if ([_desc isVolume])
    {
        [infoPairs addObject:[NTTitledInfoPair infoPair:[NTLocalizedString localize:@"Capacity:" table:@"preview"] info:[[NTSizeFormatter sharedInstance] fileSize:[NTFileDesc volumeTotalBytes:_desc]]]];
        [infoPairs addObject:[NTTitledInfoPair infoPair:[NTLocalizedString localize:@"Free:" table:@"preview"] info:[[NTSizeFormatter sharedInstance] fileSize:[NTFileDesc volumeFreeBytes:_desc]]]];
    }
    else // is folder
    {
		[self setFolderSizeInfo: [NSNumber numberWithUnsignedLongLong:[_desc size]]
				   totalValence: [NSNumber numberWithUnsignedLongLong:[_desc valence]]];
    }
    */
    return infoPairs;
}

- (void)setFolderSizeInfo:(NSNumber*)size totalValence:(NSNumber*)totalValence;
{
    // this is nil for volumes
    if (totalValence)
    {
        NSNumberFormatter* formatter = [[[NSNumberFormatter alloc] init] autorelease];
        
        [formatter setPositiveFormat:@"#,###"];
        [formatter setAllowsFloats:NO];
        [formatter setAttributedStringForZero:[[[NSAttributedString alloc] initWithString:@"0"] autorelease]];
        
        _calculatedFolderNumItems = [[[formatter stringForObjectValue:totalValence] stringByAppendingString:[NTLocalizedString localize:@" items" table:@"preview"]] retain];
    }
}


#import <sys/stat.h>

+ (NSString*) permissionStringForURL: (NSURL*) URL
{
    NSString* perm = @"";

    // get mode bits
    // [NSFileManager attributesOfItemAtPath:error:] provides the permission bits ([NSFileAttributes filePosixPermissions]),
    // but not the complete mode bits; so use the carbon functions instead ...
    
    FSRef ref;
    if ( FSPathMakeRef([URL fileSystemRepresentation], &ref, nil) != noErr )
        return perm;
    
    FSCatalogInfo catalogInfo;
    if ( FSGetCatalogInfo(&ref, kFSCatInfoPermissions, &catalogInfo, NULL, NULL, NULL) != noErr )
        return perm;
    
    UInt16 modeBits = catalogInfo.permissions.mode;
    UInt16 permBits = (modeBits & ACCESSPERMS);
    
    if (S_ISDIR(modeBits))
        perm = [perm stringByAppendingString:@"d"];
    else if (S_ISCHR(modeBits))
        perm = [perm stringByAppendingString:@"c"];
    else if (S_ISBLK(modeBits))
        perm = [perm stringByAppendingString:@"b"];
    else if (S_ISLNK(modeBits))
        perm = [perm stringByAppendingString:@"l"];
    else if (S_ISSOCK(modeBits))
        perm = [perm stringByAppendingString:@"s"];
    else if (S_ISWHT(modeBits))
        perm = [perm stringByAppendingString:@"w"];
    else if (S_ISREG(modeBits))
        perm = [perm stringByAppendingString:@"-"];
    else
        perm = [perm stringByAppendingString:@" "];  // what is it?
    
    // Owner
    perm = [perm stringByAppendingString:(permBits & S_IRUSR) ? @"r" : @"-"];
    perm = [perm stringByAppendingString:(permBits & S_IWUSR) ? @"w" : @"-"];
    
    if (permBits & S_IXUSR)
    {
        if ((S_ISUID & modeBits) || (S_ISGID & modeBits))
            perm = [perm stringByAppendingString:@"s"];
        else
            perm = [perm stringByAppendingString:@"x"];
    }
    else
    {
        if ((S_ISUID & modeBits) || (S_ISGID & modeBits))
            perm = [perm stringByAppendingString:@"S"];
        else
            perm = [perm stringByAppendingString:@"-"];
    }
    
    // Group
    perm = [perm stringByAppendingString:(permBits & S_IRGRP) ? @"r" : @"-"];
    perm = [perm stringByAppendingString:(permBits & S_IWGRP) ? @"w" : @"-"];
    
    if (permBits & S_IXGRP)
    {
        if ((S_ISUID & modeBits) || (S_ISGID & modeBits))
            perm = [perm stringByAppendingString:@"s"];
        else
            perm = [perm stringByAppendingString:@"x"];
    }
    else
    {
        if ((S_ISUID & modeBits) || (S_ISGID & modeBits))
            perm = [perm stringByAppendingString:@"S"];
        else
            perm = [perm stringByAppendingString:@"-"];
    }
    
    // Others
    perm = [perm stringByAppendingString:(permBits & S_IROTH) ? @"r" : @"-"];
    perm = [perm stringByAppendingString:(permBits & S_IWOTH) ? @"w" : @"-"];
    
    if (permBits & S_IXOTH)
    {
        if ((S_ISUID & modeBits) || (S_ISGID & modeBits))
            perm = [perm stringByAppendingString:@"s"];
        else
        {
            // check sticky bit
            if (S_ISVTX & modeBits)
                perm = [perm stringByAppendingString:@"t"];
            else
                perm = [perm stringByAppendingString:@"x"];
        }
    }
    else
    {
        if ((S_ISUID & modeBits) || (S_ISGID & modeBits))
            perm = [perm stringByAppendingString:@"S"];
        else
        {
            // check sticky bit
            if (S_ISVTX & modeBits)
                perm = [perm stringByAppendingString:@"T"];
            else
                perm = [perm stringByAppendingString:@"-"];
        }
    }
    
    if (YES/*includeOctal*/)
    {
        perm = [perm stringByAppendingString:@" ("];
        perm = [perm stringByAppendingString:[self permissionOctalStringForModeBits:modeBits]];
        perm = [perm stringByAppendingString:@")"];
    }
    
    return perm;
}

+ (NSString*)permissionOctalStringForModeBits:(UInt16)modeBits;
{
    int chmodNum;
    UInt32 permBits = (modeBits & ACCESSPERMS);
    
    // add - chmod 755
    chmodNum = 100 * ((permBits & S_IRWXU) >> 6);  // octets
    chmodNum += 10 * ((permBits & S_IRWXG) >> 3);
    chmodNum += 1 * (permBits & S_IRWXO);
    
    char buff[20];
    snprintf(buff, 20, "%03d", chmodNum);
    
    return [NSString stringWithCString:buff encoding:NSASCIIStringEncoding];
}

@end
