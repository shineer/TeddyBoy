//
//  ConsoleLogImplement.c
//  FetionUtil
//
//  Created by Born on 14-1-22.
//  Copyright (c) 2014年 FetionUtil. All rights reserved.
//

#include "ConsoleLogInterface.h"
#import <TargetConditionals.h>
#import <Foundation/Foundation.h>
#import "Log.h"

#ifndef RELEASE_APP
#import "ConsoleViewController.h"
#endif

//declare
NS_INLINE void initConsoleLogSystem(int);
NS_INLINE void shutdownConsoleLogSystem(void);
NS_INLINE NSString* _getDataTime(void);

int  getLogListSize();
bool GetConsoleLogEnable(ConsoleLogEnum type);
char* GetConsoleLogName(ConsoleLogEnum type);
void SetConsoleLogEnable(ConsoleLogEnum type,bool flag);



/////////////////////////////////////////////
// Function Implement
/////////////////////////////////////////////


__unused void initConsoleLogSystem()
{
    
}


__unused void shutdownConsoleLogSystem(void)
{
    
}

int getLogListSize()
{
    return sizeof(configList)/sizeof(struct ConsoleLogConfig);
}


char* GetConsoleLogName(ConsoleLogEnum type)
{
    if ((int)type < 0 || type >= getLogListSize()) {
        return "";
    }
    return configList[type].name;
}

bool GetConsoleLogEnable(ConsoleLogEnum type)
{
    if ((int)type < 0 || type >= getLogListSize()) {
        return false;
    }
    return configList[type].openFlag;
}


void SetConsoleLogEnable(ConsoleLogEnum type,bool flag)
{
    if ((int)type < 0 || type >= getLogListSize()) {
        return;
    }
    configList[type].openFlag = flag;
}





__unused NS_INLINE  NSString* _getDataTime()
{
	NSDate* date = [NSDate date];
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
	NSString* timeStr = [formatter stringFromDate:date];
	[formatter release];
	return timeStr;
}


/**
 *	@brief	获得控制台日志视图logvc
 *
 *	@param 	 	N/A
 *
 *	@return	UINavigationController*指针
 */
id getConsoleLogVC()
{
#ifdef RELEASE_APP//发布AppStore
    return NULL;
#else
    return [ConsoleViewController shareSingleton];
#endif
}

/**
 *	@brief	显示真机上日志界面
 *
 *	@param 	 vc	UIViewController*对象
 */
void ShowConsoleLogView(id vc)
{
#ifndef RELEASE_APP//发布AppStore
//#if (TARGET_IPHONE_SIMULATOR==0)//模拟器不使用手机控制台log
//#ifndef CLOSE_CONSOLE_LOG//关闭宏时不使用手机控制台log
    if ([vc isKindOfClass:[UIViewController class]])
    {
        UIViewController* pvc = vc;
        
        [pvc presentViewController:[ConsoleViewController shareSingleton] animated:YES completion:^{
            
            //
        }];
        
        //[pvc presentModalViewController:[ConsoleViewController shareSingleton] animated:YES];
    }
//#endif
//#endif
#endif
}

/**
 *	@brief	控制台log方法
 *
 *	@param 	type 	模块类型
 *	@param 	filePath 	文件
 *	@param 	functionName 	函数名
 *	@param 	line 	行号
 *	@param 	NSString*format 	OC风格输出格式
 *	@param 	..."] 	参数
 *  @return N/A
 */
void ConsoleLogEx(ConsoleLogEnum type ,const char * filePath, const char* functionName, int line,  NSString*format,...)
{
#ifdef RELEASE_APP//发布AppStore
    return;
#endif
    
    int index = (int)type;
    if(index < 0 || index >= getLogListSize())
    return;
    
    if (false == configList[type].openFlag)
    return;
    
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	va_list arg;
	va_start(arg, format);
	NSString *str = [[NSString alloc] initWithFormat:format arguments: arg];
	va_end(arg);
	
	char* fileName = strrchr(filePath, '/');
	fileName++;
    

#ifdef DEBUG//真机联调
//    printf("%s\n", [msg UTF8String]);
#endif
    
#ifndef RELEASE_APP//非发布AppStore
    NSString* curThreadName = [[NSThread currentThread] name];
    //                                         [模块］线程 文件:行号 函数:内容

    NSString* msg = [NSString stringWithFormat:@"[%s] %@ %s:%d %s :%@", configList[type].name, curThreadName, fileName,line, functionName,str];
    __model_writeLog(msg.UTF8String);
#endif
    
//#if (TARGET_IPHONE_SIMULATOR==0)//模拟器不使用手机控制台log
#ifndef RELEASE_APP//关闭宏时不使用手机控制台log
    if ([[ConsoleViewController shareSingleton].viewControllers count]) {
        ConsoleViewController* consoleVc = [[ConsoleViewController shareSingleton].viewControllers objectAtIndex:0];
        [consoleVc appendMsg:msg];
        [consoleVc appendMsg:@"\n"];
    }
#endif
//#endif
	
	[str release];
	
	[pool release];
}



void vNSLog(const char * filePath, const char* functionName, int line, NSString *format, ...)
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	va_list arg;
    printf(">>%s,%s,%d\n",filePath,functionName,line);
	va_start(arg, format);
    NSLogv(format,arg);
	va_end(arg);

    [pool release];

}
