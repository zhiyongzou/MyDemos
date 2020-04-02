//
//  ViewController.m
//  TypingAttributesDemo
//
//  Created by zzyong on 2020/4/2.
//  Copyright © 2020 zzyong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textView.typingAttributes = @{NSForegroundColorAttributeName : [UIColor blueColor]};
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textView endEditing:YES];
    
    NSMutableAttributedString *temp = [self.textView.attributedText mutableCopy];
    [temp appendAttributedString:[[NSAttributedString alloc] initWithString:@"@小小蓝 " attributes:@{NSForegroundColorAttributeName : [UIColor blueColor]}]];
    self.textView.attributedText = temp;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.textView.text = @"@小蓝 ";
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"%@\n", textView.text);
    
    NSLog(@"attributedText: %@", textView.attributedText);
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.textView.typingAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor]};
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES ;
}


@end
