/*
 *  DebugLog.h
 *  DebugLog
 *
 *  Created by Karl Kraft on 3/22/09.
 *  Copyright 2009 Karl Kraft. All rights reserved.
 *
 */

#ifdef DEBUG_PRINT

#define DebugLog(args...) _DebugLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,args);

#else

#define DebugLog(x...)

#endif

void _DebugLog(const char *file, int lineNumber, const char *funcName, NSString *format,...);


#ifdef DEBUG_TRACE

#define DebugStartTrace() _DebugTrace("start\0", __PRETTY_FUNCTION__);
#define DebugEndTrace() _DebugTrace("end\0", __PRETTY_FUNCTION__);

#else

#define DebugStartTrace()
#define DebugEndTrace()

#endif

void _DebugTrace(const char* s, const char* funcName);

void DebugRect(CGRect r);
