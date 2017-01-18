@implementation NSDictionary (extras)

- (NSString *)joinUsingPairsSeparator:(NSString *)pairsSeparator kvSeparator:(NSString *)kvSeparator kvTransformationSelector:(SEL)kvTransformationSelector
{
	//int i = 1;
	//int count = [self count];
	
	NSMutableString *result = [NSMutableString string];
    [result appendString:@""];
    /*
	for (id key in self)
	{
		NSString *string;
		
		if (i < count)
		{
			string = [NSString stringWithFormat:@"%@%@%@%@", [key performSelector:kvTransformationSelector], kvSeparator, [[self objectForKey:key] performSelector:kvTransformationSelector], pairsSeparator];
		}
		else
		{
			string = [NSString stringWithFormat:@"%@%@%@", [key performSelector:kvTransformationSelector], kvSeparator, [[self objectForKey:key] performSelector:kvTransformationSelector]];
		}
		[result appendString:string];
		
		i ++;
	}
     */
	return result;
}



@end
