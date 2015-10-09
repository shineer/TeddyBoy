//
//  Debug_ios.h
//  FetionUtil
//
//  Created by Born on 14-2-27.
//  Copyright (c) 2014年 FetionUtil. All rights reserved.
//


#ifndef __DEBUG_IOS__
#define __DEBUG_IOS__
//////////////////////////////////////////////////////////////////////////
#ifdef __cplusplus
extern "C"{
#endif
//////////////////////////////////////////////////////////////////////////
//
#if defined(__APPLE__)
#  define LOG_PLATFORM_IOS
	
#if defined(__cplusplus)
#  define LOG_API
#else
#  define LOG_API
#endif
	
#if !defined(LOG_INLINE)
#if defined(__GNUC__)
#define LOG_INLINE static __inline__ __attribute__((always_inline))
#elif defined(__MWERKS__) || defined(__cplusplus)
#define LOG_INLINE static inline
#elif defined(_MSC_VER)
#define LOG_INLINE static __inline
#elif TARGET_OS_WIN32
#define LOG_INLINE static __inline__
#endif
#endif
    
#define LOG_PRETTY_FUNCTION_NAME __PRETTY_FUNCTION__
    
#endif
//////////////////////////////////////////////////////////////////////////
    
    
typedef struct log_func_tracer
{
    bool  dumpTracking;
    const char * m_funcname;
    u_int32_t m_BeginTime;
#ifdef LOG_PLATFORM_WIN32
    unsigned int m_BeginThreadTime;
#endif
}log_func_tracer;

LOG_API void log_func_tracer_begin(log_func_tracer* ft,const char * funcname);
LOG_API void log_func_tracer_end(log_func_tracer* ft);
    
LOG_API void log_func_tracer_time_begin(log_func_tracer* ft, const char * desc);
LOG_API void log_func_tracer_time(log_func_tracer* ft, const char * format,...);
LOG_API void log_func_tracer_time_end(log_func_tracer* ft);
    
LOG_API void __log_assert_va(int idx,const char *filename,int linenumber,const char * exp,...);
LOG_API void __log_assert(int idx,const char *filename,int linenumber,const char * exp);



#ifdef DEBUG
#//assert
#   if defined(assert)
#       undef assert
#       define assert(e)
#   endif
#
#//NSParameterAssert
#   if defined(NSParameterAssert)
#       undef NSParameterAssert
#       define NSParameterAssert(e)        __LOG_ASSERT(e,#e)
#   endif
#
#//NSAssert
#   if defined(NSAssert)
#       undef NSAssert
#   define NSAssert(condition, desc, ...)	{if(!(condition)) {__log_assert_va(0,LOG_PRETTY_FUNCTION_NAME, __LINE__, [desc UTF8String], ##__VA_ARGS__);}}
#   endif
#
#	if defined(LOG_PLATFORM_SYMBIAN)
#		define __LOG_ASSERT(e,des)       {if(!(e)) {__log_assert(0,__FILE__, __LINE__, #des);assert(0);exit(-1);}}
#	else
#		define __LOG_ASSERT(e,des)       {if(!(e)) {__log_assert(0,LOG_PRETTY_FUNCTION_NAME, __LINE__, #des);}}
#	endif
#
#	define __LOG_VERIFY(e,des)   __LOG_ASSERT(e,des)
#	define __LOG_TODO(des)       __log_assert(0,LOG_PRETTY_FUNCTION_NAME, __LINE__, "TODO: you must implement this function!!!"#des)
#	define __LOG_TODO_EX(des)    __log_assert(0,LOG_PRETTY_FUNCTION_NAME, __LINE__, "TODO:"#des)
#
#	define __LOG_FUNC_TRACE_BEGIN()	log_func_tracer _log_func_tracer_obj5ytfqt5w545u6hga;log_func_tracer_begin(&_log_func_tracer_obj5ytfqt5w545u6hga,LOG_PRETTY_FUNCTION_NAME)
#	define __LOG_FUNC_TRACE_END()    log_func_tracer_end(&_log_func_tracer_obj5ytfqt5w545u6hga)
#
#	define __LOG_FUNC_TRACE_BEGIN_EX(i)	log_func_tracer _log_func_tracer_obj5ytfqt5w545u6hga_##i;log_func_tracer_begin(&_log_func_tracer_obj5ytfqt5w545u6hga_##i,LOG_PRETTY_FUNCTION_NAME)
#	define __LOG_FUNC_TRACE_END_EX(i)    log_func_tracer_end(&_log_func_tracer_obj5ytfqt5w545u6hga_##i)
#
#else
#
#//assert
#   if defined(assert)
#       undef assert
#       define assert(e)
#   endif
#
#//NSParameterAssert
#   if defined(NSParameterAssert)
#       undef NSParameterAssert
#       define NSParameterAssert(e)
#   endif
#
#
#//NSAssert
#   if defined(NSAssert)
#       undef NSAssert
#       define NSAssert(condition, desc, ...)
#   endif
#
#	define __LOG_ASSERT(e,des)  	((void)0)
#	define __LOG_VERIFY(e,des)  	(e)
#	define __LOG_TODO(des)
#   define __LOG_TODO_EX(des)
#	define __LOG_FUNC_TRACE_BEGIN()
#	define __LOG_FUNC_TRACE_END()
#	define __LOG_FUNC_TRACE_BEGIN_EX(i)
#	define __LOG_FUNC_TRACE_END_EX(i)
#endif


    

    

    
//////////////////////////////////////////////////////////////////////////
#ifdef __cplusplus
}
#endif
//////////////////////////////////////////////////////////////////////////

#endif