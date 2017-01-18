//
//  IQDropDownTextField.m
//
//  Created by Iftekhar on 19/10/13.
//  Copyright (c) 2013 Canopus. All rights reserved.
//

#import "IQDropDownTextField.h"

@interface IQDropDownTextField ()<UIPickerViewDelegate, UIPickerViewDataSource>

@end

@implementation IQDropDownTextField
{
    UIPickerView *pickerView;
    UIDatePicker *datePicker;
    UIDatePicker *timePicker;
}

- (CGRect)caretRectForPosition:(UITextPosition *)position
{
    return CGRectZero;
}

-(void)initialize
{
    [self setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [self setBorderStyle:UITextBorderStyleRoundedRect];
    
    _dropDownDateFormatter = [[NSDateFormatter alloc] init];
    [_dropDownDateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [_dropDownDateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    _dropDownTimeFormatter = [[NSDateFormatter alloc] init];
    [_dropDownTimeFormatter setDateStyle:NSDateFormatterNoStyle];
    [_dropDownTimeFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    pickerView = [[UIPickerView alloc] init];
    [pickerView setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:0.5]];
    [pickerView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
    [pickerView setShowsSelectionIndicator:YES];
    [pickerView setDelegate:self];
    [pickerView setDataSource:self];

    datePicker = [[UIDatePicker alloc] init];
    [datePicker setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:0.5]];
    [datePicker setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    
    timePicker = [[UIDatePicker alloc] init];
    [timePicker setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:0.5]];
    [timePicker setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
    [timePicker setDatePickerMode:UIDatePickerModeTime];
    [timePicker addTarget:self action:@selector(timeChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self setDropDownMode:IQDropDownModeTextPicker];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initialize];
    }
    return self;
}

-(void)setDropDownMode:(IQDropDownMode)dropDownMode
{
    _dropDownMode = dropDownMode;
    
    switch (_dropDownMode)
    {
        case IQDropDownModeTextPicker:
            self.inputView = pickerView;
            break;
            
        case IQDropDownModeDatePicker:
            self.inputView = datePicker;
            break;
        case IQDropDownModeTimePicker:
            self.inputView = timePicker;
            break;
            
        default:
            break;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _itemList.count;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *labelText = [[UILabel alloc] init];
    labelText.font = [UIFont boldSystemFontOfSize:20.0];
    labelText.backgroundColor = [UIColor clearColor];
    [labelText setTextAlignment:NSTextAlignmentCenter];
    [labelText setText:[_itemList objectAtIndex:row]];
    return labelText;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self setSelectedItem:[_itemList objectAtIndex:row]];
}

-(void)dateChanged:(UIDatePicker*)dPicker
{
    [self setSelectedItem:[_dropDownDateFormatter stringFromDate:dPicker.date]];
}
-(void)timeChanged:(UIDatePicker*)tPicker
{
    [self setSelectedItem:[_dropDownTimeFormatter stringFromDate:tPicker.date]];
}
-(void)setItemList:(NSArray *)itemList
{
    _itemList = itemList;
    
    [pickerView reloadAllComponents];
}

- (void)setDate:(NSDate *)date animated:(BOOL)animated
{
    [self setSelectedItem:[_dropDownDateFormatter stringFromDate:date]];
}

-(NSDate *)date
{
    switch (_dropDownMode)
    {
        case IQDropDownModeTextPicker:
            return nil;
            break;
            
        case IQDropDownModeDatePicker:
            return datePicker.date;
            break;
        case IQDropDownModeTimePicker:
            return timePicker.date;
            break;
    }
}

-(void)setSelectedItem:(NSString *)selectedItem
{
    if (selectedItem == nil)
    {
        _selectedItem = nil;
        self.text = @"";
    }
    
    switch (_dropDownMode)
    {
        case IQDropDownModeTextPicker:
            if ([_itemList containsObject:selectedItem])
            {
                _selectedItem = selectedItem;
                self.text = selectedItem;
                [pickerView selectRow:[_itemList indexOfObject:selectedItem] inComponent:0 animated:YES];
            }
            break;
            
        case IQDropDownModeDatePicker:
        {
            NSDate *date = [_dropDownDateFormatter dateFromString:selectedItem];
            if (date)
            {
                _selectedItem = selectedItem;
                self.text = selectedItem;
                [datePicker setDate:date animated:YES];
            }
            else
            {
                NSLog(@"Invalid date or date format:%@",selectedItem);
            }
            break;
        }
        case IQDropDownModeTimePicker:
        {
            
            NSDate *date = [_dropDownTimeFormatter dateFromString:selectedItem];
            if (date)
            {
                _selectedItem = selectedItem;
                    self.text = selectedItem;
            [timePicker setDate:date animated:YES];
            }
            else
            {
                NSLog(@"Invalid time or time format:%@",selectedItem);
            }
            break;
        }
    }
}

-(void)setDatePickerMode:(UIDatePickerMode)datePickerMode
{
    if (_dropDownMode == IQDropDownModeDatePicker)
    {
        _datePickerMode = datePickerMode;
        [datePicker setDatePickerMode:datePickerMode];
        
//        switch (datePickerMode) {
//            case UIDatePickerModeCountDownTimer:
//                [dropDownDateFormatter setDateStyle:NSDateFormatterNoStyle];
//                [dropDownDateFormatter setTimeStyle:NSDateFormatterNoStyle];
//                break;
//            case UIDatePickerModeDate:
//                [dropDownDateFormatter setDateStyle:NSDateFormatterShortStyle];
//                [dropDownDateFormatter setTimeStyle:NSDateFormatterNoStyle];
//                break;
//            case UIDatePickerModeTime:
//                [dropDownDateFormatter setDateStyle:NSDateFormatterNoStyle];
//                [dropDownDateFormatter setTimeStyle:NSDateFormatterShortStyle];
//                break;
//            case UIDatePickerModeDateAndTime:
//                [dropDownDateFormatter setDateStyle:NSDateFormatterShortStyle];
//                [dropDownDateFormatter setTimeStyle:NSDateFormatterShortStyle];
//                break;
//        }
    }
}

- (void)setDatePickerMaximumDate:(NSDate*)date
{
    if (_dropDownMode == IQDropDownModeDatePicker)
        datePicker.maximumDate = date;
}

@end
