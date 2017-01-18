@interface NSDictionary (extras)

- (NSString *)joinUsingPairsSeparator:(NSString *)pairsSeparator kvSeparator:(NSString *)kvSeparator kvTransformationSelector:(SEL)kvTransformationSelector;

@end
