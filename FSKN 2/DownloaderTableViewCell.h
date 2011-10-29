//
//  DownloaderTableViewCell.h
//  Downloader
//
//  Created by Дмитрий Куртеев on 23.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloaderTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UIImageView *coverView;

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;

@property (nonatomic, retain) IBOutlet UIButton *downloadButton;
@property (nonatomic, retain) IBOutlet UIImageView *readButton;

@property (nonatomic, retain) IBOutlet UIProgressView *progressView;

@end
