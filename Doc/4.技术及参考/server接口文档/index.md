# 简介 #

- 客户端把sessionId保存在HTTP头中

- HTTP头需要设置gzip压缩

- 服务器把errorCode, errorMsg保存在HTTP头中。客户端每次请求都要检查http头中是否返回errorCode和errorMsg数据，如果有值，则弹出errorMsg消息，终止以下逻辑执行。errorCode为1，结果返回成功

- 客户端在每个json请求中，都需要传入[1.0 平台信息对象 platformInfo](./Object.html#platformInfo)和用户`token`。

## ErrorCode定义 ##
- 从token中获取用户失败： -99 返回该code时，客户端需要重新登录
- 服务器异常：-500
- 结果返回成功：1
- 结果返回失败：0
- 服务器错误：-995
- 内容包含违禁词：-994
- 平台信息错误:-993
- 用户不存在:-992
- 密码错误：-2
- 用户名或密码为空：-4
- 用户名已存在：-3
- 注册失败：-5
- 获取验证码失败：-6
- 验证码为空：-7
- 验证失败：-8
- 创建用户资料失败：-9
- 图片格式不正确：-10
- 上传文件大小超出限制：-11
- 信箱列表为空：-12
- 没有找到两人之间关系：-13
- 没有找到信件内容：-14
- 没有找到上传的文件：-15
- 发布动态失败：-16
- 发布动态不能为空：-17
- 用户征友条件不存在：-18
- 用户评分失败：-19
- 找不到对应的话题列表：-20
- 找不到对应的话题：-21
- 找不到对应的评论列表：-22
- 发布话题失败：-23
- 发布话题评论失败：-24
- 被点赞列表为null：-25
- 喜欢我的列表为null：-26
- 我喜欢的列表为null：-27
- 用户动态列表为空：-28
- 访问列表为空：-29
- 已经打过招呼：-30
- 没有找到共同回答的QA问答：-31
- 没有找到用户标签列表：-32
- 已经喜欢过了：-33
- 已经评过分了：-34
- 命中敏感词：-35
- QA问题已用完：-36
- 已经回答过：-37
- 已经赞过：-38
- 非法字符：-39
- 重置密码失败：-40
- 用户已被禁言：-41
- 用户没有回答过该QA问答：-42
- 发送礼物列表为空：-43
- 收到礼物列表为空：-44
- 黑名单列表为空：-45
- 评论为空：-46
- 没有权限删除：-47
- 名字和证件ID不能为空：-48
- 身份证验证失败：-49
- 用户密码为空：-50
- 头像拦截：-51
- 完善资料拦截：-52
- 用户发表动态次数拦截：-53
- 实名认证拦截：-54
- 操作上限拦截：-55
- 性别不能为空：-56


--------------------------------


## 接口定义 ##

- v1.0.0版本接口定义
	- [1.0.0.1 获取验证码 /user/validate](./API.html#validate)
	- [1.0.0.2 注册 /user/register](./API.html#register)
	- [1.0.0.3 创建资料 /user/establishInfo](./API.html#establishInfo)
	- [1.0.0.4 完善资料 /user/perfectInfo](./API.html#perfectInfo)
	- [1.0.0.5 登录 /user/login](./API.html#login)
	- [1.0.0.6 上传头像 /user/uploadIcon](./API.html#uploadIcon)
	- [1.0.0.7 获取用户简单信息 /user/simpleInfo](./API.html#simpleInfo)
	- [1.0.0.8 二次登录 /user/bgLogin](./API.html#bgLogin)
	- [1.0.0.9 身份证验证 /user/idverify](./API.html#idverify)
	- [1.0.0.10 注册V2 /user/registerV2](./API.html#registerV2)
	- [1.0.0.11 注册前数据提供 /user/step0](./API.html#step0)
	- [1.0.0.12 绑定手机号 /user/bandPhone](./API.html#bandPhone)


	- [2.0.0.1 修改征友条件 /recommend/updateUserTerm](./API.html#updateUserTerm)
	- [2.0.0.2 发送纯文本动态 /recommend/sendNotes](./API.html#sendNotes)
	- [2.0.0.3 发送带图片动态 /recommend/sendPhotoNotes](./API.html#sendPhotoNotes)
	- [2.0.0.4 推荐首页接口 /recommend/recommend](./API.html#recommend)
	- [2.0.0.5 获取用户征友条件 /recommend/getUserTerm](./API.html#getUserTerm)
	- [3.0.0.1 发送普通私信 /msg/sendMsg](./API.html#sendMsg)
	- [3.0.0.2 发送普通招呼 /msg/sayHi](./API.html#sayHi)
	- [3.0.0.3 能否打招呼接口/msg/isCanSayHi](./API.html#isCanSayHi)
	- [3.0.0.4 获取信件列表 /msg/getMsgInbox](./API.html#getMsgInbox)
	- [3.0.0.5 获取信件详细 /msg/getMsg](./API.html#getMsg)
	- [3.0.0.6 删除信件关系 /msg/deleteMsgInbox](./API.html#deleteMsgInbox)
	- [3.0.0.7 删除单条信件 /msg/deleteMsg](./API.html#deleteMsg)
	- [3.0.0.8 删除所有信 /msg/deleteAllMsg](./API.html#deleteAllMsg)
	- [3.0.0.9 获取为我点赞列表 /msg/getPraiseList](./API.html#getPraiseList)
	- [3.0.0.10 获取喜欢我的列表 /msg/getVisitorList](./API.html#getVisitorList)
	- [3.0.0.11 获取最近访客列表 /msg/getCollectList](./API.html#getCollectList)
	- [3.0.0.12 获取系统消息 /msg/getSystemMsg](./API.html#getSystemMsg)
	- [3.0.0.13 获取喜欢我的、我喜欢的个数 /msg/getCollectNum](./API.html#getCollectNum)
	- [4.0.0.1 获取评分用户接口 /score/getScoreUserList](./API.html#getScoreUserList)
	- [4.0.0.2 打分接口 /score/score](./API.html#score)
	- [4.0.0.3 获取我的打分记录接口 /score/getScore](./API.html#getScore)
	- [4.0.0.4 给我打分列表 /score/getByScore](./API.html#getByScore)
	- [5.0.0.1 发布话题接口 /bbs/sendTopic](./API.html#sendTopic)
	- [5.0.0.2 发布带图片话题 /bbs/sendPhotoTopic](./API.html#sendPhotoTopic)
	- [5.0.0.3 发布评论 /bbs/sendComment](./API.html#sendComment)
	- [5.0.0.4 获取话题提醒接口 /bbs/getBbsUserRemind](./API.html#getBbsUserRemind)
	- [5.0.0.5 获取话题列表接口 /bbs/getBbsTopicList](./API.html#getBbsTopicList)
	- [5.0.0.6 获取话题详细接口 /bbs/getBbsTopic](./API.html#getBbsTopic)
	- [5.0.0.7 获取话题主题列表 /bbs/getBbsTheme](./API.html#getBbsTheme)
	- [5.0.0.8 获取话题评论列表 /bbs/getBbsCommentList](./API.html#getBbsCommentList)
	- [5.0.0.9 删除一条话题提醒记录 /bbs/delUserRemind](./API.html#delUserRemind)
	- [5.0.0.10 删除话题评论 /bbs/delTopicComment](./API.html#delTopicComment)
	- [5.0.0.11 删除话题 /bbs/delTopic](./API.html#delTopic)
	- [5.0.0.12 删除所有话题提醒 /bbs/delAllUserRemind ](./API.html#delAllUserRemind)
	- [5.0.0.13 我的话题列表 /bbs/getMeTopicList ](./API.html#getMeTopicList)
	- [6.0.0.1 喜欢接口 /space/collect ](./API.html#collect)
	- [6.0.0.2 取消喜欢接口 /space/cancelCollect ](./API.html#cancelCollect)
	- [6.0.0.3  我的空间收藏我的列表 /space/getCollectMe ](./API.html#getCollectMe)
	- [6.0.0.4  我的空间我收藏列表接口 /space/getMeCollect](./API.html#getMeCollect)
	- [6.0.0.5  获取用户动态列表 /space/getMeNotesList](./API.html#getMeNotesList)
	- [6.0.0.6  获取用户动态列表 /space/getUserNotesList](./API.html#getUserNotesList)
	- [6.0.0.7 获取我的用户资料 /space/getMeUserInfo](./API.html#getMeUserInfo)
	- [6.0.0.8 获取对方用户资料 /space/getUserInfo](./API.html#getUserInfo)
	- [6.0.0.9 获取用户标签列表 /space/getUserTagList](./API.html#getUserTagList)
	- [6.0.0.10 动态点赞 /space/notesPraise](./API.html#notesPraise)
	- [6.0.0.11 图片点赞接口 /space/photoPraise](./API.html#photoPraise)
	- [6.0.0.12 修改用户资料 /space/updateUserInfo](./API.html#getMeCollect)
	- [6.0.0.13 修改用户表是是否显示接口 /space/updateUserTag](./API.html#updateUserTag)
	- [6.0.0.14 删除照片 /space/delPhoto](./API.html#delPhoto)
	- [6.0.0.15 修改用户签名 /space/updateUserSign](./API.html#updateUserSign)
	- [6.0.0.16 删除用户动态 /space/delUserNotes](./API.html#delUserNotes)
	- [6.0.0.17 动态照片是否点过赞 /space/isPhotoPraise](./API.html#isPhotoPraise)
	- [7.0.0.1 获取一道随记问题 /qa/getRandomQuestion](./API.html#getRandomQuestion)
	- [7.0.0.2 获取我回答的QA问题列表 /qa/getMeQAList](./API.html#getMeQAList)
	- [7.0.0.3 回答QA问题 /qa/answer](./API.html#answer)
	- [7.0.0.4 获取对方用户回答过并且我没有回答过的QA问答 /qa/getUserQuestion](./API.html#getUserQuestion)
	- [7.0.0.5 获取共同回答过的QA问答 /qa/getCommonQA](./API.html#getCommonQA)
	- [7.0.0.7 获取共同回答过的QA问答列表 /qa/getCommonQAList](./API.html#getCommonQAList)
	- [7.0.0.8 通过QAId获取QA问答 /qa/getQAById](./API.html#getQAById)

	----------------------------------------------
	- [8.0.0.1 找回密码时获取验证码 /user/backPasswordValidate](./API.html#backPasswordValidate)
	- [8.0.0.2 重置密码接口/user/resetPassword](./API.html#resetPassword)
	- [8.0.0.3 修改密码接口/space/updatePassword](./API.html#updatePassword)
	- [8.0.0.4 举报内容接口/report/reportContent](./API.html#reportContent)
	- [8.0.0.5 举报用户接口/report/reportUser](./API.html#reportUser)
	- [8.0.0.6 发送礼物接口/msg/sendGift](./API.html#sendGift)
	- [8.0.0.7 移除黑名单 /space/delBlackList](./API.html#delBlackList)
	- [8.0.0.8 获取礼物列表 /space/getGiftList](./API.html#getGiftList)
	- [8.0.0.9 获取用户勋章状态 /space/getMedalList](./API.html#getMedalList)
	- [8.0.0.10 获取用户收礼物列表 /space/getUserReceiveGiftList](./API.html#getUserReceiveGiftList)
	- [8.0.0.11 查询用户发礼物列表 /space/getUserSendGiftList](./API.html#getUserSendGiftList)
	- [8.0.0.12 加入黑名单接口 /space/saveBlackList](./API.html#saveBlackList)
	- [8.0.0.13 第三方登录接口 /user/thirdPartyLogin](./API.html#thirdPartyLogin)、
	- [8 8.0.0.14 获取用户黑名单列表 /space/getUserBlackList](./API.html#getUserBlackList)

- 对象定义:

	- [1.0 平台信息对象 platformInfo](./Object.html#platformInfo)
	- [1.1 精选用户对象 userView](./Object.html#userView)
	- [1.2 精选用户对象 recommendNotesView](./Object.html#recommendNotesView)
	- [1.3 信箱列表对象 messageInboxView](./Object.html#messageInboxView)
	- [1.4 信箱列表对象 messageView](./Object.html#messageView)
	- [1.5 评分列表展示对象 scoreView](./Object.html#scoreView)
	- [1.6 话题提醒展示对象 bbsUserRemindView](./Object.html#bbsUserRemindView)
	- [1.7 话题主题展示对象 bbsTheme](./Object.html#bbsTheme)
	- [1.8 话题评论展示对象 bbsCommentView](./Object.html#bbsCommentView)
	- [1.9 话题列表展示对象 bbsTopicView](./Object.html#bbsTopicView)
	- [1.10 用户信息对象 userInfo](./Object.html#userInfo)
	- [2.0 图片展示对象 imageView ](./Object.html#imageView)
	- [2.1 点赞列表展示对象 userPraiseView](./Object.html#userPraiseView)
	- [2.2 喜欢我信箱展示对象 collectMsgView](./Object.html#collectMsgView)
	- [2.3 动态展示对象 userNotesView](./Object.html#userNotesView)
	- [2.4 喜欢我信箱展示对象 collectMsgView](./Object.html#collectMsgView)
	- [2.5 对方空间共同回答QA问题展示对象 commonQAView](./Object.html#commonQAView)
	- [2.6  QA问题展示对象 qaView](./Object.html#qaView)
	- [2.8  用户标签展示对象 userTagView](./Object.html#userTagView)
	- [2.9  地区展示对象 areaView](./Object.html#areaView)
	- [3.0  首页推荐用户展示对象 recommendUserView](./Object.html#recommendUserView)
	- [3.1  评分用户展示对象 scoreUserView](./Object.html#scoreUserView)
	- [3.2  最近访客信箱展示对象 visitorMsgView](./Object.html#visitorMsgView)
	

