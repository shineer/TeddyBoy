<div class="section" id="validate">
## 1.0.0.1 获取验证码 /user/validate ##

 HTTP请求方式:

    POST

 引用对象:


 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)

 传入参数:
    	
    	{
			"mobileNo":手机号
		}

 返回:

		{
			"token":用户token，之后所有的请求接口都要传入token,
			"userId":用户id
		}

<div class="section" id="register">
## 1.0.0.2 注册 /user/register ##

 HTTP请求方式:

    POST

 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)

 传入参数:
    	
    	{
			"mobileNo":用户名（手机号）,
			"password":密码（MD5加密后）,
			"validate":短信验证码,
			"thirdPartyId":第三方登录id,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"status":等于1时表示成功,
			"msg":提示信息,
		}
<div class="section" id="establishInfo">
## 1.0.0.3 创建资料 /user/establishInfo ##

 HTTP请求方式:

    注意采用multipart/form-data编码方式；

 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)

 传入参数:
    	
    	{
			"nickName":用户昵称,
			"sex":性别,
			"fid":渠道号,
			"phoneType":手机型号,
			"width":头像宽度,
			"height":头像高度,
			"file":图片源,#  #
		}

 返回:

		{
			"status":等于1时表示成功,
			"nickName":用户昵称
		}
<div class="section" id="perfectInfo">
## 1.0.0.4 完善资料 /user/perfectInfo ##

 HTTP请求方式:

    POST

 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)

 传入参数:
    	
    	{
			"provinceId":省份id,
			"cityId":城市id,
			"birthday":生日（例如：1980-01-01）,
			"eductionId"：学历id,
			"purposeId":交友目的,
			"sex":用户性别,
			"longitude":经度，
			"latitude":维度，
			"platformInfo":{平台信息对象}
			
		}

 返回:

		{
			"status":等于1时表示成功
		}
<div class="section" id="login">
## 1.0.0.5 登录 /user/login ##

 HTTP请求方式:

    POST

 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)

 传入参数:
    	
    	{
			"mobileNo":用户名（手机号）,
			"password":密码（MD5加密后）,
			"longitude":经度,
			"latitude":维度,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"userId":用户id,
			"useStatus":用户状态
			"token":用户token，之后所有的请求接口都要传入token,
			"useStatus":用户状态（-2：封设备，-1：封账号 0：注册中，1：注册完成）,
			"regStep":用户注册步骤（"validate(以获取获取验证码)","register(注完成)","addUserInfo（完成设置资料第一步）","perfectInfo（完成设置资料第二步）"）
			"userInfo":{用户信息对象}
		}
<div class="section" id="uploadIcon">
## 1.0.0.6 上传头像 /user/uploadIcon ##

 HTTP请求方式:

    POST
**注意**

    注意采用multipart/form-data编码方式；
	

 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)

 传入参数:
    	
    	{
			"file":图片源,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"icon_url":用户头像url
		}
<div class="section" id="login">
## 1.0.0.7 用户简单信息 /user/simpleInfo ##

 HTTP请求方式:

    POST

 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)

 传入参数:
    	
    	{
			"userId":用户id
		}

 返回:

		{
			"picUrl":用户头像url,
			"nickname":用户昵称
		}

<div class="section" id="bgLogin">
## 1.0.0.8 二次登录 /user/bgLogin ##

 HTTP请求方式:

    POST

 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)

 传入参数:
    	
    	{
			"longitude":经度,
			"latitude":维度,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"userId":用户id,
			"useStatus":用户状态
			"token":用户token，之后所有的请求接口都要传入token,
			"useStatus":用户状态（-2：封设备，-1：封账号 0：注册中，1：注册完成）,
			"regStep":用户注册步骤（"validate(以获取获取验证码)","register(注完成)","addUserInfo（完成设置资料第一步）","perfectInfo（完成设置资料第二步）"）
			"userInfo":{用户信息对象}
		}

<div class="section" id="idverify">
## 1.0.0.9 身份证验证 /user/idverify ##

 HTTP请求方式:

    POST

 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)

 传入参数:
    	
    	{
			"idNum":身份证号,
			"name":姓名,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"status":状态 1为成功
		}

<div class="section" id="registerV2">
## 1.0.0.10 注册V2 /user/registerV2 ##

 HTTP请求方式:

    POST

 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)

 传入参数:
    	
    	{
			"nickName":昵称,
			"provinceId":省份,
			"cityId":城市,
			"thirdPartyId":第三方登录,
			"password":密码,
			"sex":性别,
			"birthday":生日，
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"userId":用户ID，
			"regStep":注册步骤，
			"token":生成的token
		}



<div class="section" id="step0">
## 1.0.0.11 注册前数据提供 /user/step0 ##

 HTTP请求方式:

    POST

 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)

 传入参数:
    	
    	{
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"provinceId":省份ID,
			"cityId":城市ID,
			"password":生成的随机密码,
			"nickName":随机昵称
		}

<div class="section" id="bandPhone">
## 1.0.0.12 绑定手机号 /user/bandPhone ##

 HTTP请求方式:

    POST

 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)

 传入参数:
    	
    	{
			"platformInfo":{平台信息对象}
			"isBand":默认0 获取验证码 1直接绑定 2先解绑当前手机再绑定到当前用户,
			"mobileNo":手机号,
			"validate":验证码(在绑定时传递 默认空)
		}

 返回:

		{
			status:
				-1 验证失败
				-2 此手机号已绑定
				0 操作失败
				1 成功
		}


<div class="section" id="updateUserTerm">
## 2.0.0.1 修改征友条件 /recommend/updateUserTerm ##

 HTTP请求方式:

    POST

 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)

 传入参数:
    	
    	{
			"minAge":最小年龄,
			"maxAge":最大年龄,
			"provinceId":省份id,
			"cityId":城市id,
			"educationId":学历id，
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"status":等于1时表示成功
		}
<div class="section" id="sendNotes">
## 2.0.0.2 发送纯文本动态 /recommend/sendNotes ##

 HTTP请求方式:

    POST

 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)

 传入参数:
    	
    	{
			"notesContent":动态内容,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"notesId":生成的动态id
		}
<div class="section" id="sendPhotoNotes">
## 2.0.0.3 发送带图片动态 /recommend/sendPhotoNotes ##

 HTTP请求方式:

    POST
**注意**

    注意采用multipart/form-data编码方式；

 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)

 传入参数:
    	
    	{
			"notesContent":动态内容,
			"file1":图片源1(可传多张照片)
			...
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"notesId":生成的动态id
		}
<div class="section" id="recommend">
## 2.0.0.4 推荐首页接口/recommend/recommend ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)
 
 [3.0 首页推荐用户展示对象 recommendUserView](./Object.html#recommendUserView)
 
 [1.2 首页精选用户对象 recommendNotesView](./Object.html#recommendNotesView)
 

 传入参数:
    	
    	{
			"width":动态照片宽度,
			"height":动态照片高度,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"userList":[12个用户
                "recommendUserView":{首页推荐用户展示对象},
				"recommendUserView":{首页推荐用户展示对象}
				...
			]
			"notesList":[100个用户
                "recommendNotesView":{动态对象},
				"recommendNotesView":{动态对象}
				...
			]
		}

<div class="section" id="getUserTerm">
## 2.0.0.5 获取用户征友条件 /recommend/getUserTerm] ##

 HTTP请求方式:

    POST

 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)

 [3.5  修改标签对象 userTerm](./Object.html#userTerm)	

 传入参数:
    	
    	{
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"userTerm":征友条件
		}
<div class="section" id="sendMsg">
## 3.0.0.1 发送普通私信 /msg/sendMsg ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)



 传入参数:
    	
    	{
			"receiveId":收信人id,
			"message":发信内容,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"msgId":私信id
		}
<div class="section" id="sayHi">
## 3.0.0.2 发送普通招呼 /msg/sayHi ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)



 传入参数:
    	
    	{
			"receiveId":收信人id,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"msgId":私信id
		}
<div class="section" id="isCanSayHi">
## 3.0.0.3 能否打招呼接口/msg/isCanSayHi ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)



 传入参数:
    	
    	{
			"receiveId":收信人id,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"isCanSayHi":true能打招呼，false不能打招呼
		}
<div class="section" id="getMsgInbox">
## 3.0.0.4 获取信件列表 /msg/getMsgInbox ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)
 
 [1.3 信箱列表对象 messageInboxView](./Object.html#messageInboxView)

 传入参数:
    	
    	{
			"page":页码数,
			"size":获取信件数量,
			"wide":用户头像宽度,
			"high":用户头像高度，
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"pageSize":返回信件数量,
			"pageNum":当前页码数,
			"listMsgBox":[
				"messageInboxView":{信箱列表对象}
				"messageInboxView":{信箱列表对象}
				...
			]
		}

<div class="section" id="getMsg">
## 3.0.0.5 获取信件详细 /msg/getMsg ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)
 
 [1.4 信箱列表对象 messageView](./Object.html#messageView)

 传入参数:
    	
    	{
			"receiveId":对方用户id,
			"isAll":是否取全部信件 0:取全部信，1：取未读信,
			"msgInboxId":信箱关系列表
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"unreadCount":返回对方未读信数量,
			"msgList":[
				"messageView":{信件对象}
				"messageView":{信件对象}
				...
			]
		}
<div class="section" id="deleteMsgInbox">
## 3.0.0.6 删除信件关系 /msg/deleteMsgInbox ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)
 
 传入参数:
    	
    	{
			"msgInboxId":信件关系id,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"status":1是删除成功,
		}
<div class="section" id="deleteMsg">
## 3.0.0.7 删除单条信件 /msg/deleteMsg ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)
 
 传入参数:
    	
    	{
			"msgId":信件id,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"status":1是删除成功,
		}
<div class="section" id="deleteAllMsg">
## 3.0.0.8 删除所有信 /msg/deleteAllMsg ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)
 
 传入参数:
    	
    	{
			"receiveId":收信人id,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"status":1是删除成功,
		}
<div class="section" id="getPraiseList">
## 3.0.0.9 获取为我点赞列表 /msg/getPraiseList ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)

 [2.1 点赞列表展示对象 userPraiseView](./Object.html#userPraiseView)
 
 传入参数:
    	
    	{
			"isRead":true:只取未读，false：取全部,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"praiseViewList":[
				userPraiseView:{点赞列表展示对象},
				userPraiseView:{点赞列表展示对象},
				...
	
			]
		}
<div class="section" id="getVisitorList">
## 3.0.0.10 获取最近访客列表 /msg/getVisitorList ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)

 [3.2 最近访客信箱展示对象 visitorMsgView](./Object.html#visitorMsgView)
 
 传入参数:
    	
    	{
			"height":照片高度,
			"width":照片宽度,
			"page":页码
			"size":获取个数,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"visitorViewList":[
				visitorMsgView:{最近访客信箱展示对象},
				visitorMsgView:{最近访客信箱展示对象},
				...
	
			]
		}
<div class="section" id="getCollectList">
## 3.0.0.11 获取喜欢我的列表 /msg/getCollectList ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)

 [2.1 点赞列表展示对象 collectMsgView](./Object.html#collectMsgView)
 
 传入参数:
    	
    	{
			"isRead":true:只取未读，false：取全部,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"collectMsgViewList":[
				collectMsgView:{喜欢我信箱展示对象},
				collectMsgView:{喜欢我信箱展示对象},
				...
	
			]
		}

<div class="section" id="getSystemMsg">
## 3.0.0.12 获取系统消息 /msg/getSystemMsg ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)
 
 [1.4 信箱列表对象 messageView](./Object.html#messageView)

 传入参数:
    	
    	{
			"receiveId":对方用户id,
			"isAll":是否取全部信件 0:取全部信，1：取未读信,
			"msgInboxId":信箱关系列表
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"unreadCount":返回对方未读信数量,
			"msgList":[
				"messageView":{信件对象}
				"messageView":{信件对象}
				...
			]
		}

<div class="section" id="getCollectNum">
## 3.0.0.13 获取喜欢我的、我喜欢的个数 /msg/getCollectNum ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)
 
 传入参数:
    	
    	{
			"myFav":0:我喜欢的，1：喜欢我的
		}

 返回:

		{
			"total":总数
		}
<div class="section" id="getScoreUserList">
## 4.0.0.1 获取评分用户接口 /score/getScoreUserList ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)

 [3.1 评分用户展示对象 scoreUserView](./Object.html#scoreUserView)
 
 传入参数:
    	
    	{
			"height":照片高度,
			"width":照片宽度
			"size":获取个数
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"userList":[
						"scoreUserView":{评分用户展示对象}，
						"scoreUserView":{评分用户展示对象}，
						...
					 ]
		}
<div class="section" id="score">
## 4.0.0.2 打分接口 /score/score ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)

 传入参数:
    	
    	{
			"scoreUserId":被打分用户id,
			"score":分数
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"status":0:失败，1：成功
		}
<div class="section" id="getScore">
## 4.0.0.3 获取我的打分记录接口 /score/getScore ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)

 [1.5 评分列表展示对象 scoreView](./Object.html#scoreView)

 传入参数:
    	
    	{
			"page":页码数,
			"size":个数,
			"width":照片宽度,
			"height":照片高度
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"scoreViewList":[
				"scoreView":{评分列表展示对象}
			]
		}
<div class="section" id="getByScore">
## 4.0.0.4 给我打分列表 /score/getByScore ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)

 [1.5 评分列表展示对象 scoreView](./Object.html#scoreView)

 传入参数:
    	
    	{
			"page":页码数,
			"size":个数,
			"width":照片宽度,
			"height":照片高度
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"scoreViewList":[
				"scoreView":{评分列表展示对象}
			]
		}
<div class="section" id="sendTopic">
## 5.0.0.1 发布话题接口 /bbs/sendTopic ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)


 传入参数:
    	
    	{
			"themeId":主题id,
			"content":话题内容,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"status":1发送成功
		}
<div class="section" id="sendPhotoTopic">
## 5.0.0.2 发布带图片话题 /bbs/sendPhotoTopic ##

 HTTP请求方式:

    POST
**注意**

    注意采用multipart/form-data编码方式；


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)


 传入参数:
    	
    	{
			"themeId":主题id,
			"content":话题内容,
			"file1":图片源1(可传多张照片)
			...,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"status":1发送成功
		}
<div class="section" id="sendComment">
## 5.0.0.3 发布评论 /bbs/sendComment ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)


 传入参数:
    	
    	{
			"receiveUserId":被评论人id(如果是回复评论，该条评论人id),
			"commentContent":评论内容,
			"topicId":话题id,
			"isReplay":是否是回复评论 0:是 1:不是,
			"themeId":主题id,
			"topicContent":帖子内容
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"status":1发送成功
		}
<div class="section" id="getBbsUserRemind">
## 5.0.0.4 获取话题提醒接口 /bbs/getBbsUserRemind ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)

 [1.6 平台信息对象 bbsUserRemindView](./Object.html#bbsUserRemindView)

 传入参数:
    	
    	{
			"isRead":0:已读，1：未读，-1全部,
			"width":图片宽度,
			"height":图片高度,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"remindViewList":[
				"bbsUserRemindView":{话题提醒展示对象},
				"bbsUserRemindView":{话题提醒展示对象},
				...	
			]
		}

<div class="section" id="getBbsTopicList">
## 5.0.0.5 获取话题列表接口 /bbs/getBbsTopicList ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)

 [1.9 话题展示对象 bbsTopicView](./Object.html#bbsTopicBoxView)

 传入参数:
    	
    	{
			"themeId":主题id(如果是话题首页推荐为recommend),
			"page":页码数,
			"size":获取数量,
			"width":图片宽度,
			"height":图片高度,
			"platformInfo":{平台信息对象}
		}

 返回:
	话题列表和置顶话题列表，客户端去重
		{
			"bbsTopicViewList":[
				"bbsTopicView":{话题展示对象},
				"bbsTopicView":{话题展示对象},
				...	
			],
			"bbsTopTopicViewList":[
				"bbsTopicView":{话题展示对象},
				"bbsTopicView":{话题展示对象},
				...	
			]
		}
<div class="section" id="getBbsTopic">
## 5.0.0.6 获取话题详细接口 /bbs/getBbsTopic ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)

 [1.9 话题展示对象 bbsTopicView](./Object.html#bbsTopicView)

 传入参数:
    	
    	{
			"topicId":主题id(如果是话题首页推荐为recommend),
			"width":图片宽度,
			"height":图片高度,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"bbsTopicView":{话题展示对象}
		}
<div class="section" id="getBbsTheme">
## 5.0.0.7 获取话题主题列表 /bbs/getBbsTheme ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)
 
 [1.7 平台信息对象 bbsTheme](./Object.html#bbsTheme)


 传入参数:
    	
    	{
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"themeList":[
				"bbsTheme":{话题主题展示对象},
				"bbsTheme":{话题主题展示对象},
				...
			]
		}

<div class="section" id="getBbsCommentList">
## 5.0.0.8 获取话题评论列表 /bbs/getBbsCommentList ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)
 
 [1.7 话题评论展示对象 bbsCommentView](./Object.html#bbsCommentView)


 传入参数:
    	
    	{
			"topicId":话题id,
			"page":页码数,
			"size":获取个数,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"bbsCommentViewList":[
				"bbsCommentView":{话题评论展示对象},
				"bbsCommentView":{话题评论展示对象},
				...
			]
		}
<div class="section" id="delUserRemind">
## 5.0.0.9 删除一条话题提醒记录 /bbs/delUserRemind ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)
 

 传入参数:
    	
    	{
			"remindId":提醒id,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"status":1 成功，-1失败
		}
<div class="section" id="delTopicComment">
## 5.0.0.10 删除话题评论 /bbs/delTopicComment ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)
 

 传入参数:
    	
    	{
			"commentId":评论id,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"status":1 成功，-1失败
		}
<div class="section" id="delTopic">
## 5.0.0.11 删除话题 /bbs/delTopic ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)
 

 传入参数:
    	
    	{
			"topicId":话题id,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"status":1 成功，-1失败
		}

<div class="section" id="delAllUserRemind">
## 5.0.0.12 删除所有话题提醒 /bbs/delAllUserRemind ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)
 

 传入参数:
    	
    	{
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"status":1 成功，-1失败
		}

<div class="section" id="getMeTopicList">
## 5.0.0.13 我的话题列表 /bbs/getMeTopicList ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)

 [1.9 话题展示对象 bbsTopicView](./Object.html#bbsTopicView)

 传入参数:
    	
    	{
			"width":图片宽度,
			"height":图片高度,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"bbsTopicViewList":[
				bbsTopicView:{话题展示对象},
				bbsTopicView:{话题展示对象},
				...
			]
		}

<div class="section" id="collect">
## 6.0.0.1 喜欢接口 /space/collect ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)


 传入参数:
    	
    	{
			"collectUserId":喜欢用户id,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"status":1 成功，-1失败
		}

<div class="section" id="cancelCollect">
## 6.0.0.2 取消喜欢接口 /space/cancelCollect ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)


 传入参数:
    	
    	{
			"collectId":喜欢id主键,
			"collectUserId":喜欢人的用户id,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"status":1 成功，-1失败
		}


<div class="section" id="getCollectMe">
## 6.0.0.3  我的空间收藏我的列表 /space/getCollectMe ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)
 
 [3.3  喜欢用户的展示对象 collectView](./Object.html#collectView)

 传入参数:
    	
    	{
			"page":页码,
			"size":数量,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"userViewList":[
				"collectView":喜欢用户的展示对象,
				"collectView":喜欢用户的展示对象,
				"collectView":喜欢用户的展示对象,
				...
			]
		}

<div class="section" id="getMeCollect">
## 6.0.0.4  我的空间我收藏列表接口 /space/getMeCollect ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)
 
 [3.3  喜欢用户的展示对象 collectView](./Object.html#collectView)

 传入参数:
    	
    	{
			"page":页码,
			"size":数量,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"userViewList":[
				"collectView":喜欢用户的展示对象,
				"collectView":喜欢用户的展示对象,
				"collectView":喜欢用户的展示对象,
				...
			]
		}

<div class="section" id="getMeNotesList">
## 6.0.0.5  获取用户动态列表 /space/getMeNotesList ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)
 [2.3 动态展示对象 userNotesView](./Object.html#userNotesView)

 传入参数:
    	
    	{
			"page":页码,
			"size":数量,
			"width":动态图片宽度,
			"height":动态图片高度,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"userNotesViewList":[
				"userNotesView":动态展示对象,
				"userNotesView":动态展示对象,
				"userNotesView":动态展示对象,
				...
			]
		}
<div class="section" id="getUserNotesList">
## 6.0.0.6  获取用户动态列表 /space/getUserNotesList ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)
 [2.3 动态展示对象 userNotesView](./Object.html#userNotesView)

 传入参数:
    	
    	{
			"page":页码,
			"size":数量,
			"width":动态图片宽度,
			"size":动态图片高度,
			"lookUserId":查看用户id
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"userNotesViewList":[
				"userNotesView":动态展示对象,
				"userNotesView":动态展示对象,
				"userNotesView":动态展示对象,
				...
			]
		}

<div class="section" id="getMeUserInfo">
## 6.0.0.7 获取我的用户资料 /space/getMeUserInfo ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)
 [1.1 用户对象 userView](./Object.html#userView)

 传入参数:
    	
    	{
			"smallWidth":小图宽度,
			"smallHeight":小图高度,
			"bigWidth":大图宽度,
			"bigHeight":大图高度,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"userView":用户对象,
			"notesCount":动态数量,
			"userQACount":用户回答QA问答数量
		}

<div class="section" id="getUserInfo">
## 6.0.0.8 获取对方用户资料 /space/getUserInfo ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)
 [1.1 用户对象 userView](./Object.html#userView)

 传入参数:
    	
    	{
			"smallWidth":小图宽度,
			"smallHeight":小图高度,
			"bigWidth":大图宽度,
			"bigHeight":大图高度,
			"lookUserId":查看用户id
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"userView":用户对象,
			"notesCount":动态数量
			"userQACount":用户回答QA问答数量
			"userStatus":用户状态
		}

<div class="section" id="getUserTagList">
## 6.0.0.9 获取用户标签列表 /space/getUserTagList ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)
 
 [2.8 用户标签展示对象 userTagView](./Object.html#userTagView)

 传入参数:
    	
    	{
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"userTagViewList":[
				"userTagView":用户标签展示对象,
				"userTagView":用户标签展示对象,
				...

			]
		}

<div class="section" id="notesPraise">
## 6.0.0.10 动态点赞 /space/notesPraise ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)

 传入参数:
    	
    	{
			"byPraiseUserId":被赞用户id,
			"notesId":动态id,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"status":1 成功，-1失败
		}

<div class="section" id="photoPraise">
## 6.0.0.11 图片点赞接口 /space/photoPraise ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)

 传入参数:
    	
    	{
			"byPraiseUserId":被赞用户id,
			"notesId":动态id,
			"photoId":图片id,
			"isIcon":是否头像点赞 0：是，1：不是,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"status":1 成功，-1失败
		}

<div class="section" id="updateUserInfo">
## 6.0.0.12 修改用户资料 /space/updateUserInfo ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)

 传入参数:
    	
    	{
			"nickName":被赞用户id,
			"provinceId":所在省份,
			"cityId":所在城市,
			"birthday":生日,
			"eductionId":学历id,
			"purposeId":交友目的,
			"homeTownPID":故乡省份id,
			"homeTownCID":故乡城市id,
			"industryId":行业Id,
			"incomeId":收入Id,
			"figureId":体型id,
			"height":身高,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"status":1 成功，-1失败,
		}
<div class="section" id="updateUserTag">
## 6.0.0.13 修改用户表是是否显示接口 /space/updateUserTag ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)

 [3.4  修改标签对象 userTag](./Object.html#userTag)

 传入参数:
    	
    	{
			"userTagList":[
				userTag:{修改标签对象},
				userTag:{修改标签对象},
				userTag:{修改标签对象},
				...
			],
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"status":1 成功，-1失败,
		}

<div class="section" id="delPhoto">
## 6.0.0.14 删除照片 /space/delPhoto ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)

 传入参数:
    	
    	{
			"photoId":图片id,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"status":1 成功，-1失败,
		}

<div class="section" id="delPhoto">
## 6.0.0.15 修改用户签名 /space/updateUserSign ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)

 传入参数:
    	
    	{
			"sign":个性签名,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"status":1 成功，-1失败,
		}

<div class="section" id="delUserNotes">
## 6.0.0.16 删除用户动态 /space/delUserNotes ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)

 传入参数:
    	
    	{
			"notesId":动态id,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"status":1 成功，-1失败,
		}

<div class="section" id="isPhotoPraise">
## 6.0.0.17 动态照片是否点过赞 /space/isPhotoPraise ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)

 传入参数:
    	
    	{
			"photoId":照片id,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"isPraise":0 可以点赞，1 不能点赞,
		}


<div class="section" id="getRandomQuestion">
## 7.0.0.1 获取一道随记问题 /qa/getRandomQuestion ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)
 
[2.6  QA问题展示对象 qaView](./Object.html#qaView)

 传入参数:
    	
    	{
			"lastQuestionId":上一道问题id（默认为0）,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"qaView":QA问题展示对象,
		}
<div class="section" id="getMeQAList">
## 7.0.0.2 获取我回答的QA问题列表 /qa/getMeQAList ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)
 
 [2.7 用户QA问答列表对象 userQAView](./Object.html#userQAView)

 传入参数:
    	
    	{
			"page":页码,
			"size":获取数量
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			
			"userQAViewList":[
				"userQAView":用户QA问答列表对象,
				"userQAView":用户QA问答列表对象,	
				"userQAView":用户QA问答列表对象,
				...
			]
		}

<div class="section" id="answer">
## 7.0.0.3 获取我回答的QA问题列表 /qa/answer ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)

 传入参数:
    	
    	{
			"questionId":问题id,
			"answerId":选择答案id,
			"tagId":所属标签,
			"isCorrect":是否是正确答案 0：是1：不是,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"status":1 成功，-1失败,
		}

<div class="section" id="getUserQuestion">
## 7.0.0.4 获取对方用户回答过并且我没有回答过的QA问答 /qa/getUserQuestion ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)
 
 [2.6  QA问题展示对象 qaView](./Object.html#qaView)

 传入参数:
    	
    	{
			"lookUserId":查看用户id,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"qaView":QA问题展示对象
		}
<div class="section" id="getCommonQA">
## 7.0.0.5 获取共同回答过的QA问答 /qa/getCommonQA ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)
 
 [2.5 对方空间共同回答QA问题展示对象 commonQAView](./Object.html#commonQAView)

 传入参数:
    	
    	{
			"lookUserId":查看用户id,
			"questionId":问题id,
			"width":头像宽度,
			"height":头像高度,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"commonQAView":对方空间共同回答QA问题展示对象
		}

<div class="section" id="getCommonQAList">
## 7.0.0.7 获取共同回答过的QA问答列表 /qa/getCommonQAList ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)
 
 [2.5 对方空间共同回答QA问题展示对象 commonQAView](./Object.html#commonQAView)

 传入参数:
    	
    	{
			"lookUserId":查看用户id,
			"width":头像宽度,
			"height":头像高度,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"commonQAList":[
				"commonQAView":对方空间共同回答QA问题展示对象,
				"commonQAView":对方空间共同回答QA问题展示对象,
				"commonQAView":对方空间共同回答QA问题展示对象,
				...
			]
			
			
		}

<div class="section" id="getQAById">
## 7.0.0.8 通过QAId获取QA问答 /qa/getQAById ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)
 
 [2.5 对方空间共同回答QA问题展示对象 commonQAView](./Object.html#commonQAView)

 [2.6  QA问题展示对象 qaView](./Object.html#qaView)

 传入参数:
    	
    	{
			"lookUserId":查看用户id,
			"questionId":问题id,
			"width":头像宽度,
			"height":头像高度,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"type":1:没有回答；2：回答过,
			"qaView":{QA问题展示对象(当type=1时返回)},
			"commonQAView":{对方空间共同回答QA问题展示对象(当type=2时返回)}
			
		}

-----------------------------------------------

<div class="section" id="backPasswordValidate">
## 8.0.0.1 找回密码时获取验证码 /user/backPasswordValidate ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)
 

 传入参数:
    	
    	{
			"mobileNo":手机号,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"status":1:成功；-1：失败
		}


<div class="section" id="resetPassword">
## 8.0.0.2 重置密码接口/user/resetPassword ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)
 

 传入参数:
    	
    	{
			"mobileNo":手机号,
			"password":密码,
			"validate":验证码,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"status":1:成功
		}

<div class="section" id="updatePassword">
## 8.0.0.3 修改密码接口/space/updatePassword ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)
 

 传入参数:
    	
    	{
			"oldPassword":旧密码,
			"newPassword":新密码,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"status":1:成功，-1：失败
		}

<div class="section" id="reportContent">
## 8.0.0.4 修改密码接口/report/reportContent ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)
 

 传入参数:
    	
    	{
			"contentId":内容id,
			"reportContent":举报内容,
			"contentType":内容类型 ：1 动态，2 话题,
			"reportType":举报类型,
			"reportUserId":被举报人id,
			"reportNickName":被举报人昵称,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"status":1:成功，-1：失败
		}



<div class="section" id="reportUser">
## 8.0.0.5 举报用户接口/report/reportUser ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)
 

 传入参数:
    	
    	{
			"reportType":举报类型,
			"reportUserId":被举报人id,
			"reportNickName":被举报人昵称,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"status":1:成功，-1：失败
		}

<div class="section" id="sendGift">
## 8.0.0.6 发送礼物接口/msg/sendGift ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)
 

 传入参数:
    	
    	{
			"giftId":礼物id,
			"receiveUserId":接受礼物用户id,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"status":1:成功，-1：失败
		}


<div class="section" id="delBlackList">
## 8.0.0.7 移除黑名单 /space/delBlackList ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)
 

 传入参数:
    	
    	{
			"blackUserId":取消拉黑用户id,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"status":1:成功，-1：失败
		}


<div class="section" id="getGiftList">
## 8.0.0.8 获取礼物列表 /space/getGiftList ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)

 [3.6  修改标签对象 gift](./Object.html#gift)
 

 传入参数:
    	
    	{
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"giftList":[
				"gift":礼物对象,
				"gift":礼物对象,
				"gift":礼物对象,
				...
			]
		}

<div class="section" id="getMedalList">
## 8.0.0.9 获取用户勋章状态 /space/getMedalList ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)

 

 传入参数:
    	
    	{
			"platformInfo":{平台信息对象},
			"seeUserId":要查看的用户ID（可选，缺失为看自己）
		}

 返回:

		{
			"qaCount":回答QA数量,
			"lookUserCount":看对方空间的次数,
			"scoreUserCount":打脸次数,
			"sendNotesCount":发动态次数,
			"sendTopicCount":发话题次数,
        	"sendCommentCount":发评论次数,
			"likeUserCount":喜欢人次数,
			"isIdentityCard":是否实名认证,
			"infoLevel":资料完整进度,
			"msgToNum":妙笔生花
		}

<div class="section" id="getUserReceiveGiftList">
## 8.0.0.10 获取用户收礼物列表 /space/getUserReceiveGiftList ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)

 [3.8  收礼物列表展示对象 userReceiveGiftView](./Object.html#userReceiveGiftView)

 

 传入参数:
    	
    	{
			"width":显示用户头像宽度,
			"height":显示用户头像高度,
			"platformInfo":{平台信息对象}
			"seeUserId":要查看的用户ID（可选，缺失为看自己）
		}

 返回:

		{
			"userReceiveGiftViewList":[
				"userReceiveGiftView":收礼物列表展示对象,
				"userReceiveGiftView":收礼物列表展示对象,
				"userReceiveGiftView":收礼物列表展示对象,
				...
			]
		}

<div class="section" id="getUserSendGiftList">
## 8.0.0.11 查询用户发礼物列表 /space/getUserSendGiftList ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)

 [3.7  用户发礼物展示对象 userSendGiftView](./Object.html#userSendGiftView)

 

 传入参数:
    	
    	{
			"width":显示用户头像宽度,
			"height":显示用户头像高度,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"userSendGiftViewList":[
				"userSendGiftView":收礼物列表展示对象,
				"userSendGiftView":收礼物列表展示对象,
				"userSendGiftView":收礼物列表展示对象,
				...
			]
		}

<div class="section" id="saveBlackList">
## 8.0.0.12 加入黑名单接口 /space/saveBlackList ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)


 

 传入参数:
    	
    	{
			"blackUserId":拉黑用户id,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"status":1:成功，-1：失败
		}


<div class="section" id="thirdPartyLogin">
## 8.0.0.13 第三方登录接口 /user/thirdPartyLogin ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)


 

 传入参数:
    	
    	{
			"thirdPartyId":第三方登录id,
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"userId":用户id,
			"token":用户token，之后所有的请求接口都要传入token,
			"useStatus":用户状态（-2：封设备，-1：封账号 0：注册中，1：注册完成）,
			"regStep":用户注册步骤（"validate(以获取获取验证码)","register(注完成)","addUserInfo（完成设置资料第一步）","perfectInfo（完成设置资料第二步）"）
		}

<div class="section" id="getUserBlackList">
## 8.0.0.14 获取用户黑名单列表 /space/getUserBlackList ##

 HTTP请求方式:

    POST


 引用对象:

 [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)

 [3.9  用户给黑名单展示对象 userBlackListView](./Object.html#userBlackListView)

 

 传入参数:
    	
    	{
			"platformInfo":{平台信息对象}
		}

 返回:

		{
			"userBlackListView":[
				"userBlackListView":用户给黑名单展示对象,
				"userBlackListView":用户给黑名单展示对象,
				"userBlackListView":用户给黑名单展示对象,
				...
			]
		}