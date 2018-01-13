//
//  ViewController.m
//  creditCardReplace
//
//  Created by Trevor Record on 2018-01-11.
//  Copyright © 2018 Trevor Record. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Assumptions: there are a variety of lengths that phone numbers and credit cards can appear in, for my solution I will be checking to see that a number is between 12 and 19 characters long http://validcreditcardnumbers.info/?p=9 (allowing for some shorter Diner's club cards), and a "valid" credit card using the Luhn Algorithm: https://en.wikipedia.org/wiki/Luhn_algorithm.
    //TestconvertCreditCardsOnly against a string that is a 'valid' credit card.
    NSString *ccNumber = @"378282246310005";
    //TestconvertCreditCardsOnly against a string that is an 'invalid' credit card.
    NSString *ccFalseNumber = @"555555555555555";
    //Test convertCreditCardsOnly against a string that is a 'valid' phone number.
    NSString *phoneNumber = @"16048055228";
    //Test against a string that contains a 'valid' credit card within a longer message.
    NSString *ccMessage = @"Hey if you need to pay for anything 378282246310005 is the card number to use";
    //Test against a string that contains a phone number within a longer message.
    NSString *phoneMessage = @"Dude call me at 16048055228 if you need anything";
    //Test against a string that contains a phone number, and two credit cards (one valid, one not) within a longer message.
    NSString *phoneAndCCMessage = @"Dude call me at 16048055228 if you need anything. Credit card is NOT 555555555555555, it's 378282246310005";
    //first just verify that the convertCreditCardsOnly method is working
    NSLog(@"Test 1 result: %@",[self convertCreditCardsOnly:ccNumber]);
    NSLog(@"Test 2 result: %@",[self convertCreditCardsOnly:ccFalseNumber]);
    NSLog(@"Test 3 result: %@",[self convertCreditCardsOnly:phoneNumber]);
    //Now verify that these work with cleanCCMessage
    NSLog(@"Test 4 result: %@",[self cleanCCMessage:ccNumber]);
    NSLog(@"Test 5 result: %@",[self cleanCCMessage:ccFalseNumber]);
    NSLog(@"Test 6 result: %@",[self cleanCCMessage:phoneNumber]);
    //Now try with numbers embedded within longer strings.
    NSLog(@"Test 7 result: %@",[self cleanCCMessage:ccMessage]);
    NSLog(@"Test 8 result: %@",[self cleanCCMessage:phoneMessage]);
    NSLog(@"Test 9 result: %@",[self cleanCCMessage:phoneAndCCMessage]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSString*)cleanCCMessage:(NSString*)inputMessage{
    //Method to cleanse message
    NSMutableString *outputMessage = [inputMessage mutableCopy];
    NSMutableString *strResult = [NSMutableString string];
    NSCharacterSet *numericSet = [NSCharacterSet decimalDigitCharacterSet];
    for (NSInteger i=0; i<inputMessage.length; i++) {
        bool needsCheck = NO;
        unichar c = [inputMessage characterAtIndex:i];
        if ([numericSet characterIsMember:c]) {
            [strResult appendString:[NSString stringWithFormat:@"%C",c]];
        } else {
            if([strResult length]){
                needsCheck = YES;
                //if numbers have been added to strResult, it will need to be checked for valid credit cards.
            }
        }
        if(needsCheck || (i == (inputMessage.length-1) && [strResult length])){
            //Do a replace only if necessary.
            NSString *changeCC = [self convertCreditCardsOnly:strResult];
            if(![changeCC isEqualToString:strResult]){
                outputMessage = [[[NSString stringWithString:outputMessage] stringByReplacingOccurrencesOfString:strResult withString:changeCC] mutableCopy];
            }
            [strResult setString:@""];
        }
    }
    return [NSString stringWithString:outputMessage];
}
-(NSString *)convertCreditCardsOnly:(NSString*)inputString{
    //Method to convert numbers to '-' if the string is the right length to be a credit card and is a "valid" credit card according to the Luhn Algorithm.
    if([inputString length] >= 12 && [inputString length] <= 19){
        BOOL isValid = [Luhn validateString:inputString];
        if(isValid){
            NSMutableString *replacementString = [NSMutableString string];
            for (NSInteger i=0; i<inputString.length; i++) {
                [replacementString appendString:@"-"];
            }
            return [NSString stringWithString:replacementString];
        } else {
            return inputString;
        }
    } else {
        return inputString;
    }
}
@end

