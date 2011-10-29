//
//  DownloaderTableViewCell.m
//  Downloader
//
//  Created by Дмитрий Куртеев on 23.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DownloaderTableViewCell.h"

@implementation DownloaderTableViewCell

@synthesize coverView = _coverView, titleLabel = _titleLabel, dateLabel = _dateLabel, downloadButton = _downloadButton, readButton = _readButton, progressView = _progressView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [_downloadButton release];
    [_readButton release];
    
    [_coverView release];
    
    [_titleLabel release];
    [_dateLabel release];
    
    [_progressView release];
    [super dealloc];
}

@end
