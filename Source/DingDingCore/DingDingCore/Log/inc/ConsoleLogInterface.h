//
//  ConsoleLogInterface.h
//  Fetion
//
//  Created by born on 13-12-6.
//  Copyright (c) 2013年 xinrui.com. All rights reserved.
//


#ifndef _ConsoleLogInterface_H_
#define _ConsoleLogInterface_H_


/**
 *	@brief	log类型,按模块分
 */
enum
{
    DD_LOG=0,       /**< 通用log >**/
    CORE_LOG,       /**< 协议层log >**/
    LOGIC_LOG,      /**< 业务层log >**/
    UI_LOG,         /**< UI层log >**/
};
typedef NSInteger ConsoleLogEnum;


//#ifdef __OBJC__


#ifdef __cplusplus
extern "C"{
#endif

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
void ConsoleLogEx(ConsoleLogEnum type ,const char * filePath, const char* functionName, int line,  NSString*format,...);

/**
 *	@brief	控制台log方法
 *
 *	@param 	filePath 	文件
 *	@param 	functionName 	函数名
 *	@param 	line 	行号
 *	@param 	NSString*format 	OC风格输出格式
 *	@param 	... 	参数
 *  @return N/A
 */
void vNSLog(const char * filePath, const char* functionName, int line, NSString *format, ...);
    
/**
 *	@brief	显示真机上日志界面
 *
 *	@param  vc	UIViewController*对象
 *  @return N/A
 */
void ShowConsoleLogView(id vc);


#ifdef __cplusplus
}

#endif


#endif
//#endif
