//
//  log.h
//  myLog
//
//  Created by wFeng on 13-8-14.
//  Copyright (c) 2013年 vsignsoft. All rights reserved.
//

#ifndef LOG_LOG_h
#define LOG_LOG_h

#include "LoggerManager.h"

#warning 提交APPStore时，要将此行代码打开，关闭Log
//#define RELEASE_APP  //开启时，将关闭所有相关log，仅限发布APPStore时开启.

#ifndef RELEASE_APP
#define CLOSE_CONSOLE_LOG //开启时，将关闭真机界面log
#define TraceDBExecution//开启时，将打印数据库操作相关日志
#endif


#ifndef RELEASE_APP
#define FTPERFORMANCETEST //性能测试开关
#endif


/****************************************************************************
 *
 * Description: 分级日志方法，日志将会写入文件.   文件路径:(document/log/)
 *              日志共分4级:Debug用于调试,Info用于信息输出,Warn用于警告,Error用于错误
 *
 * Use-case:    使用c语言格式化输出，而不是oc格式化输出(即不使用@"")
 *              DebugLog("state:%d",5);//正确
 *              DebugLog(@"state:%d",5);//错误
 *
 * Modification Log:
 *   DATE       AUTHOR           DESCRIPTION
 *---------------------------------------------------------------------------
 * 2011-09-21   wangf        Initial Release
 ****************************************************************************/


#define NSLog(...)

#ifdef DEBUG//真机联调

#define DebugLog(format, ...)	__writeLog(__FILE__, __LINE__, __FUNCTION__, LogLevel_Debug, format, ##__VA_ARGS__);
#define InfoLog(format, ...)	__writeLog(__FILE__, __LINE__, __FUNCTION__, LogLevel_Info, format, ##__VA_ARGS__);
#define WarnLog(format, ...)	__writeLog(__FILE__, __LINE__, __FUNCTION__, LogLevel_Warn, format, ##__VA_ARGS__);
#define ErrorLog(format, ...)	__writeLog(__FILE__, __LINE__, __FUNCTION__, LogLevel_Error, format, ##__VA_ARGS__);

#else

#ifdef RELEASE_APP//发布AppStore

    #define DebugLog(format, ...)
    #define InfoLog(format, ...)
    #define WarnLog(format, ...)
    #define ErrorLog(format, ...)   __writeLog(__FILE__, __LINE__, __FUNCTION__, LogLevel_Error, format, ##__VA_ARGS__);

#else//打包测试

    #define DebugLog(format, ...)	__writeLog(__FILE__, __LINE__, __FUNCTION__, LogLevel_Debug, format, ##__VA_ARGS__);
    #define InfoLog(format, ...)    __writeLog(__FILE__, __LINE__, __FUNCTION__, LogLevel_Info, format, ##__VA_ARGS__);
    #define WarnLog(format, ...)
    #define ErrorLog(format, ...)	__writeLog(__FILE__, __LINE__, __FUNCTION__, LogLevel_Error, format, ##__VA_ARGS__);

#endif

#endif


#include "ConsoleLogInterface.h"


/****************************************************************************
 *
 * Description: 分模块日志方法，会在XCode控制台显示. 如果CLOSE_CONSOLE_LOG宏未被定义，
                则日志将在手机屏幕的log界面显示,如果该宏定义了,则关闭手机屏幕的log界面功能.
 *
 *
 * Use-case:    使用oc语言格式化输出;(使用@"")
 *              LOGIN_LOG(@"state:%d",5);//正确
 *              LOGIN_LOG("state:%d",5);//错误
 *
 * Modification Log:
 *   DATE       AUTHOR           DESCRIPTION
 *---------------------------------------------------------------------------
 * 2014-01-17   shijia        Initial Release
 ****************************************************************************/

#ifdef RELEASE_APP//发布AppStore

    //DDlog
    #define DD_LOG(...)

    //CoreLog
    #define CORE_LOG(...)

    //LogicLog
    #define LOGIC_LOG(...)

    //UILog
    #define UI_LOG(...)

#else//打包测试

    //DDlog
    #define DD_LOG(...) ConsoleLogEx(DD_LOG,__FILE__,__FUNCTION__,__LINE__,__VA_ARGS__)

    //CoreLog
    #define CORE_LOG(...) ConsoleLogEx(CORE_LOG,__FILE__,__FUNCTION__,__LINE__,__VA_ARGS__)

    //LogicLog
    #define LOGIC_LOG(...) ConsoleLogEx(LOGIC_LOG,__FILE__,__FUNCTION__,__LINE__,__VA_ARGS__)

    //UILog
    #define UI_LOG(...) ConsoleLogEx(UI_LOG,__FILE__,__FUNCTION__,__LINE__,__VA_ARGS__)

#endif


#include "Debug_ios.h"

//////////////////////////////////////////////////////////////////////////
//代码中使用以下相关［断言宏］及［跟踪宏］, 使用C格式，非OC格式.
//////////////////////////////////////////////////////////////////////////
#define LOG_ASSERT(e)        __LOG_ASSERT(e,#e)       /**< 断言,e为判断表格式*/
#define LOG_ASSERT_EX(e,des) __LOG_ASSERT(e,des)      /**< 断言,e为判断表格式,des为相应描述,C字符串*/
#define LOG_VERIFY(e,des)    __LOG_ASSERT(e,des)      /**< 验证,等同断言*/
#define LOG_TODO(des)        __LOG_TODO(des);         /**< TODO断言*/
#define LOG_TODO_EX(des)     __LOG_TODO_EX(des);      /**< TODO断言,带描述*/


/**< 函数跟踪，结束时会打印出函数调用时间*/
#define LOG_BEGIN()  __LOG_FUNC_TRACE_BEGIN() /**< 函数跟踪开始*/
#define LOG_END()    __LOG_FUNC_TRACE_END()   /**< 函数跟踪结束*/

#define LOG_BEGIN_EX(i)  __LOG_FUNC_TRACE_BEGIN_EX(i) /**< 函数跟踪开始*/
#define LOG_END_EX(i)    __LOG_FUNC_TRACE_END_EX(i)   /**< 函数跟踪结束*/

#define LOG_DISCARD_API                      /**< 已经弃用或过期的api申明*/
//////////////////////////////////////////////////////////////////////////


struct ConsoleLogConfig
{
    char name[20];  /**< log名称*/
    bool openFlag;  /**< log开关标志*/
};

/**
 *  @brief 修改此结构体第2个整数值，可以控制日志的打印.
 */
static struct ConsoleLogConfig configList[] = {
    {"dd_log",1},
    {"core_log",1},
    {"logic_log",1},
    {"ui_log",1},
};

#endif // LOG_LOG_h


