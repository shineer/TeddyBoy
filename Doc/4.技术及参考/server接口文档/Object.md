g# 对象定义 #

--------------------------------
<div class="section" id="platformInfo">
## 1.0 平台信息对象 platformInfo ##

 对象说明: 
	
	处理客户端信息、手机信息、网络信息数据封装。
	
 	{
		"platformInfo":{
				"version":版本号,
				"fid":渠道号,
				"platform":平台(3->Android),
				"product":产品号(8->宝葫芦项目),
				"phonetype":手机型号,
				"pid":手机串号,
				"w":分辨率宽,
				"h":分辨率高,
				"systemVersion":系统版本,
				"netType":联网类型(0->无网络,2->wifi,3->cmwap,4->cmnet,5->ctnet,6->ctwap,7->3gwap,8->3gnet,9->uniwap,10->uninet)
				"imsi":sim卡imsi号,
				"mobileIP":手机ip
			}
	}
<div class="section" id="userView">
## 1.1 首页精选用户对象 userView ##
 	{
		"userView":{
				"userId":用户id,
				"userIcon":用户头像,
				"nickName":昵称
				"age":用户年龄,
				"sex":用户性别
				"education":学历,
				"userGEO":用户坐标（double数组）,
				"recommend":用户推荐理由,
				"activeTime":用户的最后活跃时间,
				"userTagViewList":["userTagView":用户标签展示对象 ...],
				"nation":民族,
				"nationId":民族id
				"birthday":生日,	
				"figure":体型,
				"figureId":体型Id,
				"industry":行业,
				"industry":行业id,
				"income":收入,
				"incomeId":收入id
				"education":学历,
				"education":学历id
				"purpose":交友目的,
				"purposeId":交友目的id,	
				"mobileType":手机型号,
				"loginTime":登录时间,
				"nativePlace":{2.9 areaView:}籍贯,
				"area"{2.9 areaView}所在的城市,
				"constellation":星座,
				"photoList":[
					"imageView":{图片展示对象}，
					"imageView":{图片展示对象}，
					...
				]
				"isScore":是否评过分  0：是 1：不是,
				"isCollect":是否收藏    0：是 1：不是
				"isSayHi":是否打过招呼 0：是 1：不是,
				"level":用户级别,
				"visitorTime":访问用户空间时间,
				"height":身高,
				"sign":个性签名,
				"iconStatus":头像状态  0：审核中，1：审核通过，-1：默认头像
			}
	}
<div class="section" id="recommendNotesView">
## 1.2 首页精选用户对象 recommendNotesView ##


 
	
 	{
		"recommendNotesView":{
				"userId":用户id,
				"userIcon":用户头像,
				"age":用户年龄,
				"education":学历,
				"userGEO":用户坐标（double数组）,
				"recommend":用户推荐理由,
				"activeTime":用户的最后活跃时间,
				"notesId":动态id，
				"praiseCount":点赞数量,
				"notesType":动态类型(1：普通动态，2，参与话题，3QA问答),
				"notesPhotos":[
					"imageView":{图片展示对象}，
					"imageView":{图片展示对象}，
					...
				]，
				"publishTime":发布时间,
				"notesContent":动态内容,
				"isPraiseNotes":是否赞过动态 0赞过，1：没有赞过
				"topicID":话题id（如果notesType=2时）,
				"topicContent":话题内容（如果notesType=2时）,
				"qaId":QA问答id（如果notesType=3时）,
				"qaContent":OA问题内容（如果notesType=3时）
				
			}
	}
<div class="section" id="messageInboxView">
## 1.3 首页精选用户对象 messageInboxView ##
	
 	{
		"messageInboxView":{
				"userId":用户id,
				"msgInboxId":信件关系id,
				"receiveId":收件人id(1：管理员信2:最近访客，3：点赞列表，4：收藏列表),
				"ureadCount":未读信数量,
				"totalCount":信件总数,
				"isRead":是否已读，0：已读1：未读,
				"msgFrom":信件来源 1：普通信件，2：最近访客，3：点赞列表，4：收藏列表,
				"receiveIcon":对方用户头像，
				"content":最后发信内容,
				"skinId":发信背景,
				"online":是否在线,
				"sendTime":发信时间
			}
	}
	}
<div class="section" id="messageView">
## 1.4 用户对象 messageView ##
	
 	{
		"messageView":{
				"msgContentId":信件id,
				"sendId":发信人id,
				"receiveId":收件人id,
				"content":信件内容,
				"sendTime":发送时间,
				"userNotesView":{
 					[2.3 动态展示对象]
				},
				"photoUrl":点赞图片url,
				"msgType":消息类型,1：招呼，2：私信，3,：动态赞，4:打分点赞,5:图片点赞,6:喜欢,7:系统消息,8:动态纸条
			}
	}
<div class="section" id="scoreView">
## 1.5 评分列表展示对象 scoreView ##
	
 	{
		"scoreView":{
				"userId":用户id,
				"nickName":用户昵称,
				"cityName":城市名称,
				"score":分数,
				"scoreTime":打分时间,
				"userIcon":用户头像
			}
	}
<div class="section" id="bbsUserRemindView">
## 1.6 话题提醒展示对象 bbsUserRemindView ##
	
 	{
		"bbsUserRemindView":{
				"remindId":提醒id,
				"receiveUserId":接受提醒用户id,
				"sendUserId":发送提醒用户id,
				"sendNickName":发送用户昵称,
				"sendIcon":发送者头像
				"remindContent":提醒内容,
				"topicId":话题id，
				"topicContent":话题内容，
				"topicFirstPhoto":话题第一张图片，
				"remindTime":发送时间，
				"isRead":是否已读0：已读，1：未读
			}
	}

<div class="section" id="bbsTheme">
## 1.7 话题主题展示对象 bbsTheme ##
	
 	{
		"bbsTheme":{
				"themeId":话题主题id,
				"themeName":主题名称,
				"topicNum":话题数量,
				"commentNum":评论数量,
				"themePhoto":主题图片
				"themeDate":主题创建时间,
				"themeStatus":主题状态0：显示，-1：不显示，
				"order":位置顺序
			}
	}

<div class="section" id="bbsCommentView">
## 1.8 话题评论展示对象 bbsCommentView ##
	
 	{
		"bbsCommentView":{
				"commentId":评论id,
				"topicId":话题id,
				"content":评论内容,
				"commentStatus":评论状态 0 未审核 1 通过 2不通过 9 屏蔽,
				"sendUserId":发表评论人id
				"sendUserIcon":发表评论人头像
				"toUserId":被评论人id,
				"createTime":评论时间，
				"isReplay":是否是回复评论,
				"sendNickName":"发送人id",
				"toNickName":"被评论人id"
			}
	}


<div class="section" id="bbsTopicView">
## 1.9 话题展示对象 bbsTopicView ##
	
 	{
		"bbsTopicView":{
				"themeId":主题ID,
				"themeName":主题名称,
				"topicId":话题id,
				"nickName":用户昵称,
				"userId":用户id,
				"age":用户年龄,
				"provinceName":省份,
				"cityName":城市名称
				"userIcon":用户头像
				"content":发帖内容,
				"crateTime":话题创建时间，
				"topicStatus":话题状态0 未审核 1通过 2不通过 8屏蔽 9删除,
				"commentTotal":话题的评论数,
				"showType":0：普通，1：精华,
                "photoList":[
					"imageView":{图片展示对象}，
					"imageView":{图片展示对象}，
					...
				],
			}
	}

## 1.10 用户信息对象 userInfo ##
	
 	{
		"userInfo":{
				"userId":用户ID,
				"sex":性别,
				"fid":渠道id,
				"mobileNo":手机号,
				"tagId":表现id,
				"userIcon":头像,
				"defaultIcon":默认头像,
				"sign":个性签名,
				"signTemp":审核中的前面,
				"nickName":昵称，
				"nationId":民族,
				"height":身高,
				"weight":0：体重,
				"birthday":生日,
				"domicilePID":居住省id,
				"domicileCID":居住城市id,
				"figureID":体型id,
				"homeTownPID":家乡省份id,
				"homeTownCID":家乡城市id,
				"industryId":行业id,
				"incomeId":收入id,
				"educationId":学历id,
				"purposeId":交友目的,
				"mobileType":手机型号,
				"iconStatus":头像审核状态,
				"indexDB":“无视”,
				"msgIndexDB":“无视”,
				"updateTime":修改时间,
				"createTime":创建时间,
				"score":用户头像得分
				"userStatus":用户状态
			}
	}


<div class="section" id="imageView">
## 2.0 图片展示对象 imageView ##
	
 	{
		"bbsTopicView":{
				"photoId":图片id,
				"smallPhotoUrl":小图url,
				"bigPhotoUrl":大图url,
				"praiseCount":图片点赞数量
				"notesId":照片所属动态id
			}
	}

<div class="section" id="userPraiseView">
## 2.1 点赞列表展示对象 userPraiseView ##
	
 	{
		"userPraiseView":{
				"launchUserId":发起人id,
				"launchNickName":发起人昵称,
				"launchUserIcon":发起人头像,
				"praiseUserId":被点赞人id,
				"praiseNickName":被点赞人昵称,
				"praiseUserIcon":被点赞人头像,
				"praiseContent":点赞内容,
				"praiseType":赞类型1:动态点赞，2：照片点赞，3：招呼点赞,
				"praiseTime":点赞时间,
				"isRead":是否已读0：已读，1：未读
			}
	}

<div class="section" id="collectMsgView">
## 2.2 喜欢我信箱展示对象 collectMsgView ##
	
 	{
		"collectMsgView":{
				"userId":用户id,
				"nickName":昵称,
				"userIcon":头像,
				"content":内容,
				"isRead":是否已读0已读，1未读,
				"collectTime":时间
				"isRead":是否已读0：已读，1：未读
			}
	}
<div class="section" id="userNotesView">
## 2.3 动态展示对象 userNotesView ##
	
 	{
		"userNotesView":{
			"notesId":动态id,
			"notesContent":动态内容,
			"isPhoto":是否有头像0：有，1：没有,
			"firstPhoto"：动态第一张照片,	
			"publishTime":发布时间,
			"topicId":话题id,
			"topicContent":话题内容,
			"qaId":QA的id,
			"question":问题内容,
			"notesPhotos":[
					"imageView":{图片展示对象}，
					"imageView":{图片展示对象}，
					...
			],
			"notesType":动态类型 1：普通动态，2，参与话题，3QA问答,
			"isPraiseNotes":是否赞过动态 0赞过，1：没有赞过,
			"praiseCount":点赞数量
		}
	}

<div class="section" id="collectMsgView">
## 2.4 喜欢我信箱展示对象 collectMsgView ##
	
 	{
		"collectMsgView":{
			"userId":用户id,
			"nickName":用户昵称,
			"userIcon":用户头像,
			"content":显示文案,
			"collectTime":喜欢时间,
			"isRead":是否已读0已读，1未读
		}
	}

<div class="section" id="commonQAView">
## 2.5 对方空间共同回答QA问题展示对象 commonQAView ##
	
 	{
		"commonQAView":{
			"questionId":问题id,
			"questionContent":问题内容,
			"lookUserAnswerId":查看用户回答问题答案id
			"answerId":登录用户答案id,
			"answerContent":登录用户回答问题答案,
			"lookUserAnswerContent":查看用户回答问题答案,
			"userIcon":登录用户头像,
			"lookUserIcon":查看用户头像
		}
	}

<div class="section" id="qaView">
## 2.6  QA问题展示对象 qaView ##
	
 	{
		"qaView":{
			"questionId":问题id,
			"questionContent":问题内容,
			"tagId":问题所属标签,
			"answerList":[
				answer:{
					"answerId":答案id,
					"answerContent":答案内容,
					"questionId":问题id,
					"tagId":所属标签id,
					"isCorrect":是否正确答案0：是，1：不是
				},
				...
			
			]
		}
	}

<div class="section" id="userQAView">
## 2.7  用户QA问答列表对象 userQAView ##
	
 	{
		"userQAView":{
			"questionId":问题id,
			"questionContent":问题内容,
			"userAnswerId":用户选在答案id,
			"answerTime":回答问题时间,
			"answerList":[
				answer:{
					"answerId":答案id,
					"answerContent":答案内容,
					"questionId":问题id,
					"tagId":所属标签id,
					"isCorrect":是否正确答案0：是，1：不是
				},
				...
			
			]
		}
	}
<div class="section" id="userTagView">
## 2.8  用户标签展示对象 userTagView ##
	
 	{
		"userTagView":{
			"userTagId":用户标签主键,
			"userId":用户id,
			"tagId":标签id,
			"tagName":标签名称,
			"isShow":是否显示 0：显示，1不显示
		}
	}
<div class="section" id="areaView">
## 2.9  地区展示对象 areaView ##
	
 	{
		"areaView":{
			"provinceId":省份id,
			"provinceName":省份名称,
			"cityId":城市id,
			"cityName":城市名称
		}
	}
<div class="section" id="recommendUserView">
## 3.0  首页推荐用户展示对象 recommendUserView ##
	
 	{
		"recommendUserView":{
			"userId":用户id,
			"age":用户年龄,
			"recommend":推荐理由,
			"nickName":昵称,
			"userIcon":用户头像,
			"userGEO":用户坐标位置,
			"isCollect":是否收藏    0：是 1：不是
			"isSayHi":是否打过招呼 0：是 1：不是
			"education":学历,
			"activeTime":用户活跃时间,
		}
	}
<div class="section" id="scoreUserView">
## 3.1  评分用户展示对象 scoreUserView ##
	
 	{
		"scoreUserView":{
			"userId":用户id,
			"age":用户年龄,
			"nickName":昵称,
			"userIcon":用户头像,
			"userTagViewList":["userTagView":用户标签展示对象 ...],
			"nativePlace":{2.9 areaView:}籍贯,
			"area"{2.9 areaView}所在的城市
			
		}
	}
<div class="section" id="visitorMsgView">
## 3.2  最近访客信箱展示对象 visitorMsgView ##
	
 	{
		"visitorMsgView":{
			"userId":用户id,
			"age":用户年龄,
			"nickName":昵称,
			"userIcon":用户头像,
			"area"{2.9 areaView}所在的城市,
			"purpose":交友目的,
			"visitorTime":访问用户空间时间,
			"isRead":0:已读，1：未读
			
		}
	}

<div class="section" id="collectView">
## 3.3  喜欢用户的展示对象 collectView ##
	
 	{
		"collectView":{
			"collectId":主键id,
			"age":展示用户年龄,
			"launchUserId":发起者id,
			"collectUserId":被喜欢者id,
			"collectNickName":用户昵称,
			"collectUserIcon":用户头像,
			"provinceName":省份,
			"cityName":城市，
			"isCollect":对方是否喜欢我 0：喜欢，1未喜欢
		}
	}

<div class="section" id="userTag">
## 3.4  修改标签对象 userTag ##
	
 	{
		"userTag":{
			"userTagId":主键id,
			"userId":用户id,
			"tagId":标签id,
			"isShow":是否显示0：是，1：不是
			
		}
	}

<div class="section" id="userTerm">
## 3.5  修改标签对象 userTerm ##
	
 	{
		"userTerm":{
			"userId":用户id,
			"minAge":最小年龄,
			"maxAge":最大年龄,
			"provinceId":省份,
			"cityId":城市,
			"educationId":学历
		}
	}

<div class="section" id="gift">
## 3.6  修改标签对象 gift ##
	
 	{
		"gift":{
			"guid":礼物主键id,
			"giftName":礼物名称,
			"giftImg":礼物图片,
			"provinceId":省份,
			"isCharge":是否收费0：是，1 不是,
			"price":价格
		}
	}

<div class="section" id="userSendGiftView">
## 3.7  用户发礼物展示对象 userSendGiftView ##
	
 	{
		"userSendGiftView":{
			"giftId":礼物id,
			"giftImg":礼物图片,
			"giftName":礼物名称,
			"price":礼物价格,
			"sendUserId":发礼物用户id,
			"sendUserNickName":发礼物用户昵称,
			"sendUserIcon":发礼物用户头像
		}
	}

<div class="section" id="userReceiveGiftView">
## 3.8  收礼物列表展示对象 userReceiveGiftView ##
	
 	{
		"userReceiveGiftView":{
			"giftId":礼物id,
			"giftImg":礼物图片,
			"giftName":礼物名称,
			"price":礼物价格,
			"sendUserId":发礼物用户id,
			"sendUserNickName":发礼物用户昵称,
			"sendUserIcon":发礼物用户头像
		}
	}

<div class="section" id="userBlackListView">
## 3.9  用户给黑名单展示对象 userBlackListView ##
	
 	{
		"userBlackListView":{
			"blackUserId":拉黑用户id,
			"blackUserName":拉黑用户昵称,
			"blackUserAge":拉黑用户年龄,
			"provinceName":拉黑用户名称,
			"cityName":拉黑用户城市
		}
	}