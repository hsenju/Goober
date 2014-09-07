//
//  HSTableViewCell.m
//  Goober
//
//  Created by Hikari Senju on 9/6/14.
//  Copyright (c) 2014 Hikari Senju. All rights reserved.
//

#import "HSTableViewCell.h"

@implementation HSTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib
{}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void) updateCell: (NSString *)number address:(NSString *)address name:(NSString*)name{
    self.numberLabel.text = number;
    self.addressLabel.text = address;
    self.nameLabel.text = name;
}

@end
