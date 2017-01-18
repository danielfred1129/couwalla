/*
 *  DPKLog.h
 *  
 *  Created by Deepanshu Kumar on 28-05-2010.
 *	*****************************************************
 */


// Enable debug (NSLog)
#define DEBUG 1

#if DEBUG
	#define NSLog_ENABLED
#else
	
#endif


#ifdef NSLog_ENABLED

#ifndef __OPTIMIZE__ // __OPTIMIZE__ is not enables, it means that the active config is Debug, so let //NSLog enabled

#define NSLog(...) NSLog(__VA_ARGS__)

#else //__OPTIMIZE__ is defined, so disable //NSLog

#define NSLog(...) {}

#endif // __OPTIMIZE__

#else NSLog_ENABLED is not defined, so disable //NSLog

#define NSLog(...) {}

#endif // //NSLog_ENABLED
 