/* 中奖用户点数翻倍增加倒计时 */
function winnerMulti(){
    function CountDown() {
      if(second>=1)
      {
        second=(second-1>9)?(second-1):"0"+(second-1);
      }
      else
      {
        second="59";
        if(minute>=1)
        {
          minute=(minute-1>9)?(minute-1):"0"+(minute-1);
        }
        else
        {
          minute="59";
          if(hour>=1)
          {
            hour=(hour-1>9)?(hour-1):"0"+(hour-1);
          }
          else
          {
            hour="23";
            if(day >=1)
            {
                day = (day-1>9)?(day-1):"0"+(day-1);
            }else
            {
                /*minute="0";
                hour="0";
                day="0";*/
            }
          }
        }
      }

    if('will' == status)
    {
      document.getElementById("update_time2").innerHTML="距开始还剩：<font color=#cd2a25 >" + hour + "</font>小时<font color=#cd2a25 >" + minute + "</font>分<font color=#cd2a25 >" + second+"</font>秒";
    }
    else
    {

      document.getElementById("update_time2").innerHTML="剩余：<font color=#666666 >" + day + "</font> 天&nbsp;<font color=#666666 >" + hour + "</font> 小时&nbsp;<font color=#666666 >" + minute + "</font> 分&nbsp;<font color=#666666 >" + second+"</font> 秒";
    }

      if(day==0&&hour==0&&minute==0&&second==0)
      {
        document.getElementById ("winner_multi").style .display ="none";
      }
      else
      setTimeout  (CountDown,1000);
    }



    var start_time = $("#start_time").html();
    var status = $("#status2").html();
    if('now' == status)
    {
      setTimeout(CountDown,1000);
    }
    else if('will' == status)
    {
//      $("#update_time2").html("活动还未开始");
      setTimeout(CountDown,1000);
    }
    else if('end' == status)
    {
      $("#update_time2").html("活动已经结束");
    }
    var tempTime=document.getElementById("endtime2").innerHTML.split(":");
    var day=tempTime[0];
    var hour=tempTime[1];
    var minute=tempTime[2];
    var second=tempTime[3];
}

/* 抽奖概率翻倍活动倒计时 */
function lotteryActivity(){
    function CountDown() {
      if(second>=1)
      {
        second=(second-1>9)?(second-1):"0"+(second-1);
      }
      else
      {
        second="59";
        if(minute>=1)
        {
          minute=(minute-1>9)?(minute-1):"0"+(minute-1);
        }
        else
        {
          minute="59";
          if(hour>=1)
          {
            hour=(hour-1>9)?(hour-1):"0"+(hour-1);
          }
          else
          {
            hour="23";
            if(day >=1)
            {
                day = (day-1>9)?(day-1):"0"+(day-1);
            }else
            {
                /*minute="0";
                hour="0";
                day="0";*/
            }
          }
        }
      }

    if('will' == status)
    {
      document.getElementById("update_time").innerHTML="距开始还剩：<font color=#cd2a25 >" + hour + "</font>小时<font color=#cd2a25 >" + minute + "</font>分<font color=#cd2a25 >" + second+"</font>秒";
    }
    else
    {

      document.getElementById("update_time").innerHTML="剩余：<font color=#666666 >" + day + "</font> 天&nbsp;<font color=#666666 >" + hour + "</font> 小时&nbsp;<font color=#666666 >" + minute + "</font> 分&nbsp;<font color=#666666 >" + second+"</font> 秒";
    }

      if(day==0&&hour==0&&minute==0&&second==0)
      {
        document.getElementById ("activity").style .display ="none";
      }
      else
      setTimeout  (CountDown,1000);
    }



    var start_time = $("#start_time").html();
    var status = $("#status").html();
    if('now' == status)
    {
      setTimeout(CountDown,1000);
    }
    else if('will' == status)
    {
//      $("#update_time").html("活动还未开始");
      setTimeout(CountDown,1000);
    }
    else if('end' == status)
    {
      $("#update_time").html("活动已经结束");
    }
    var tempTime=document.getElementById("endtime").innerHTML.split(":");
    var day=tempTime[0];
    var hour=tempTime[1];
    var minute=tempTime[2];
    var second=tempTime[3];
}

function checkuserstatus(N,J,K){
    if(N == 1){
        lotteryWindowMessageWait(J,1);
    }else{
        var G ='';
        if(N == -1){
            G = '很抱歉，你的幸运点不足~';
        }else if(N == -2){
           var G = new Array('注册邮箱被验证后，才可以参加本次活动',K);
        }else if(N == -3){
            G = '很抱歉，只有登录的用户才可以参加本次活动';
        }
        lotteryWindowMessage(G,N);
    }
}

function lotteryResponse(result)
{

    result = eval('('+result+')');
    lotteryWindowMessage(result,result.error);


}
function sendHashMail(url)
{
    $.ajax({
            type: "GET",
            url: "user.php?act=send_hash_mail",
            cache: false,
            data: "&m="+ Math.random(),
            success:function(msg){
                result = $.evalJSON(msg);
                if(result.error == 0){
                    //发送成功，不弹提示框 fuxing 20100316
                    //G = new Array(result,url);
                    //lotteryWindowMessage(G,-4);
                }else{
                    alert(result.message);
                    location.href = 'lottery.php?act=list';
                }
                }
           });
}

function resendHashMail()
{
    $("#resend")[0].style.display = "none";
    $("#resenddone")[0].style.display = "block";
}
/*获取中奖列表*/
//id  扩展参数（暂无）
//page  页码
//ext 扩展参数（暂无）
function getxmaswinner(id,page, ext)
{

  var pager = $int(page);

  $.ajax({
    type: "GET",
    url: "lottery_winner.php",
    data: "page=" + pager + "&act="+ ext +"&" + Math.random(),
    success: function(msg)
    {
      var re = eval("(" + msg + ")");
      if (re.count != "0")
      {
        $("#xmas_winner")[0].innerHTML = re.content;
      }else
      {
        $("#xmas_winner")[0].innerHTML = '<div style="padding-bottom:20px;text-align:center;">暂时还没有人中奖哦~~快去抽奖吧！</div>';
      }
    }
  })
}

/*抽奖弹窗提示*/
function lotteryWindowMessage(G,N) {
    var A = window.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop || 0;
    var D = 0;
    D = Math.min(document.body.clientHeight, document.documentElement.clientHeight);
    if (D == 0) {
        D = Math.max(document.body.clientHeight, document.documentElement.clientHeight)
    }
    var B = document.documentElement.clientWidth || document.body.clientWidth;
    var F = Math.max(document.body.scrollHeight, document.documentElement.scrollHeight);
    var C = (100+A + (D - 300) / 2) + "px";
    var I = (B - 200) / 2 + "px";
    var J = document.createElement("DIV");
    J.id = "shield";
    J.style.position = "absolute";
    J.style.left = "0px";
    J.style.top = "0px";
    J.style.width = "100%";
    J.style.height = ((document.documentElement.clientHeight > document.documentElement.scrollHeight) ? document.documentElement.clientHeight: document.documentElement.scrollHeight) + "px";
    J.style.background = "#333";
    J.style.textAlign = "center";
    J.style.zIndex = "10000";
    J.style.filter = "alpha(opacity=0)";
    J.style.opacity = 0;
    var E = document.createElement("DIV");
    E.id = "alertFram";
    E.style.position = "absolute";
    E.style.left = I;
    E.style.top = C;
    if (G) {
        E.style.marginLeft = "-90px"
    } else {
        E.style.marginLeft = "-90px"
    }
    E.style.width = "";
    E.style.height = "";
    E.style.background = "";
    E.style.textAlign = "left";
    E.style.lineHeight = "150px";
    E.style.zIndex = "10001";
    if (N == 1) {
        if(G.content['type'] == 1){
            strHtml = '<div id="pop_box"><div id="pop_title"><div id="pop_title_txt">很可惜</div><div id="pop_tilte_close"><a href="javascript:doOk();">关闭</a></div></div><div id="pop_body"><div id="pop_body_txt_line"><font color="#000000">'+G.message+'</font></div><div id="pop_body_goods_line" style="line-height:18px;"><font style="font-size:14px; color:#ff0000;">'+G.content['info']+'</font></div><div id="pop_body_btn_line"><table width="100%" border="0" align="center"><tr><td align="center"><a href="/lottery">继续抽奖</a></td><td align="center"><a href="'+G.content['url']+'" target="_blank">购买这个奖品</a></td></tr></table></div></div></div>'
        }else if (G.content['type'] == 2){
            strHtml = '<div id="pop_box"><div id="pop_title"><div id="pop_title_txt">很可惜</div><div id="pop_tilte_close"><a href="javascript:doOk();">关闭</a></div></div><div id="pop_body"><div id="pop_body_txt_line"><font color="#000000">'+G.message+'</font></div><div id="pop_body_goods_line" style="line-height:18px;"><font style="font-size:14px; color:#ff0000;">'+G.content['info']+'</font></div><div id="pop_body_btn_line"><table width="100%" border="0" align="center"><tr><td align="center"><a href="/lottery">继续抽奖</a></td><td align="center"><a href="/share">去获取更多幸运点</a></td></tr></table></div></div></div>'
        }
    } else if (N == 2){
        strHtml = '<div id="pop_box"><div id="pop_title"><div id="pop_title_txt">很可惜</div><div id="pop_tilte_close"><a href="javascript:doOk();">关闭</a></div></div><div id="pop_body"><div id="pop_body_txt_line"><font color="#000000">'+G.message+'</font></div><div id="pop_body_goods_line" style="line-height:18px;"><font style="font-size:14px; color:#ff0000;">'+ G.content +'</font></div><div id="pop_body_btn_line"><table width="100%" border="0" align="center"><tr><td align="center"><a href="/share">去获取更多幸运点</a></td><td align="center"><a href="javascript:doOk();">关闭</a></td></tr></table></div></div></div>'
    }else if (N == 0){
        if (G.content['type'] == '1'){
            strHtml = '<div id="pop_box"><div id="pop_title"><div id="pop_title_txt">恭喜你</div><div id="pop_tilte_close"><a href="javascript:doOk();">关闭</a></div></div><div id="pop_body"><div id="pop_body_txt_line"><font color="#FF0000">'+G.message+'</font></div><div id="pop_body_goods_line" style="line-height:18px;"><table width="70%" border="0" align="center" cellpadding="0" cellspacing="0"><tr><td width="31%" rowspan="2" align="center" valign="top"><a href="'+G.content['url']+'" target="_blank"><img src="'+G.content['img_require']+'" width="50" height="50" /></a></td><td width="69%" height="30" align="left" valign="top"><a href="'+G.content['url']+'" target="_blank">'+G.content['goods_name']+'</a></td></tr><tr><td height="30" align="left" valign="top"><font color="#FF0000">价值￥'+G.content['goods_price']+'元</font></td></tr></table></div><div id="pop_body_btn_line"><table width="100%" border="0" align="center"><tr> <td align="center"><a href="lottery.php?act=fetch_rewards&m='+Math.random()+'">快去领取奖品</a></td><td align="center"><a href="lottery.php?act=list">继续抽奖</a></td></tr></table></div></div></div>'
        }else if (G.content['type'] == '2'){
            strHtml = '<div id="pop_box"><div id="pop_title"><div id="pop_title_txt">恭喜你</div><div id="pop_tilte_close"><a href="javascript:doOk();">关闭</a></div></div><div id="pop_body"><div id="pop_body_txt_line"><font color="#FF0000">'+G.message+'</font></div><div id="pop_body_goods_line" style="line-height:18px;"><table width="70%" border="0" align="center" cellpadding="0" cellspacing="0"><tr><td width="100%" height="30" align="center" valign="bottom"><font color="#cc0000">￥'+G.content['type_money']+'元现金券已经冲入你的账户</font></td></tr><tr><td width="100%" align="center" valign="center">有效期至：'+G.content['end_date']+'</td></tr></table></div><div id="pop_body_btn_line"><table width="100%" border="0" align="center"><tr> <td align="center"><a href="/usercenter/coupons">查看账户</a></td><td align="center"><a href="/lottery">继续抽奖</a></td></tr></table></div></div></div>'
        }

    }else if (N == -4){
        strHtml = '<div id="pop_box"><div id="pop_title"><div id="pop_title_txt">验证邮件发送成功</div><div id="pop_tilte_close"><a href="javascript:doOk();">关闭</a></div></div><div id="pop_body"><div id="pop_body_txt_line"><font color="#000000">'+G[0].message+'</font></div><div id="pop_body_btn_line"><table width="100%" border="0" align="center"><tr><td align="center"><a href="'+G[1]+'">去'+G[0].content+'</a></td><td align="center"><a href="javascript:doOk();">关闭</a></td></tr></table></div></div></div>'
    }
    else if (N == -3){
        strHtml = '<div id="pop_box"><div id="pop_title"><div id="pop_title_txt">提示</div><div id="pop_tilte_close"><a href="javascript:doOk();">关闭</a></div></div><div id="pop_body"><div id="pop_body_txt_line"><font color="#000000">'+G+'</font></div><div id="pop_body_btn_line"><table width="100%" border="0" align="center"><tr><td align="center"><a href="/usercenter/login?back_url=/lottery">登录</a></td><td align="center"><a href="javascript:doOk();">关闭</a></td></tr></table></div></div></div>'
    }
    else if (N == -2){
        strHtml = '<div id="pop_box"><div id="pop_title"><div id="pop_title_txt">提示</div><div id="pop_tilte_close"><a href="javascript:doOk();">关闭</a></div></div><div id="pop_body"><div id="pop_body_txt_line"><font color="#000000">'+G[0]+'</font></div><div id="pop_body_btn_line"><table width="100%" border="0" align="center"><tr><td align="center"><a href="'+G[1]+'">去验证邮箱</a></td><td align="center"><a href="javascript:doOk();">关闭</a></td></tr></table></div></div></div>'
    }else if (N == -1){
        strHtml = '<div id="pop_box"><div id="pop_title"><div id="pop_title_txt">已经没有抽奖机会</div><div id="pop_tilte_close"><a href="javascript:doOk();">关闭</a></div></div><div id="pop_body"><div id="pop_body_txt_line"><font color="#000000">很抱歉，你的幸运点不足~</font></div><div id="pop_body_btn_line"><table width="100%" border="0" align="center"><tr><td align="center"><a href="/share">去获取更多幸运点</a></td><td align="center"><a href="javascript:doOk();">关闭</a></td></tr></table></div></div></div>'
    }
    $("select").each(function() {
        $(this)[0].disabled = true
    });
    E.innerHTML = strHtml;
    document.body.appendChild(E);
    document.body.appendChild(J);
    this.setOpacity = function(M, L) {
        M.style.filter = "alpha(opacity=50)"
    };
    var H = 0;
    this.doAlpha = function() {
        if (++H > 30) {
            clearInterval(K);
            return 0
        }
        setOpacity(J, H)
    };
    var K = setInterval("doAlpha()", 1);
    this.doOk = function() {
        $("select").each(function() {
            $(this)[0].disabled = false
        });
        document.body.removeChild(E);
        document.body.removeChild(J);
        document.body.onselectstart = function() {
            return true
        };
        document.body.oncontextmenu = function() {
            return true
        }
        if (N == 0 || N == 1 || N == 2){
            window.location.reload();
        }
    };
    document.body.onselectstart = function() {
        return false
    };
    document.body.oncontextmenu = function() {
        return false
    }
}

/*抽奖等待弹窗提示*/
function lotteryWindowMessageWait(G,N) {
    var A = window.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop || 0;
    var D = 0;
    D = Math.min(document.body.clientHeight, document.documentElement.clientHeight);
    if (D == 0) {
        D = Math.max(document.body.clientHeight, document.documentElement.clientHeight)
    }
    var B = document.documentElement.clientWidth || document.body.clientWidth;
    var F = Math.max(document.body.scrollHeight, document.documentElement.scrollHeight);
    var C = (100+A + (D - 300) / 2) + "px";
    var I = (B - 200) / 2 + "px";
    var J = document.createElement("DIV");
    J.id = "shield";
    J.style.position = "absolute";
    J.style.left = "0px";
    J.style.top = "0px";
    J.style.width = "100%";
    J.style.height = ((document.documentElement.clientHeight > document.documentElement.scrollHeight) ? document.documentElement.clientHeight: document.documentElement.scrollHeight) + "px";
    J.style.background = "#333";
    J.style.textAlign = "center";
    J.style.zIndex = "10000";
    J.style.filter = "alpha(opacity=0)";
    J.style.opacity = 0;
    var E = document.createElement("DIV");
    E.id = "alertFram";
    E.style.position = "absolute";
    E.style.left = I;
    E.style.top = C;
    if (G) {
        E.style.marginLeft = "-90px"
    } else {
        E.style.marginLeft = "-90px"
    }
    E.style.width = "";
    E.style.height = "";
    E.style.background = "";
    E.style.textAlign = "left";
    E.style.lineHeight = "150px";
    E.style.zIndex = "10001";
    strHtml = '<div id="pop_box"><div id="pop_title"><div id="pop_title_txt">正在抽奖...</div><div id="pop_tilte_close"><a href="javascript:doOk();">关闭</a></div></div><div id="pop_body"><div id="pop_body_txt_line"><font color="#000000">正在抽奖，请稍后...</font></div><div id="pop_body_btn_line"><table width="100%" border="0" align="center"><tr><td align="center"><a href="javascript:doOk();">关闭</a></td></tr></table></div></div></div>'
    $("select").each(function() {
        $(this)[0].disabled = true
    });
    E.innerHTML = strHtml
    if (N == 1) {
        $.ajax({
            type: "GET",
            url: "/usercenter/check?act=do_lottery",
            cache: false,
            data: 'lottery_id=' + G + "&m="+ Math.random(),
            success:function(result){
                doOk();
                lotteryResponse(result);
                }
        });
    }
    document.body.appendChild(E);
    document.body.appendChild(J);

    this.setOpacity = function(M, L) {
        M.style.filter = "alpha(opacity=50)"
    };
    var H = 0;
    this.doAlpha = function() {
        if (++H > 30) {
            clearInterval(K);
            return 0
        }
        setOpacity(J, H)
    };
    var K = setInterval("doAlpha()", 1);
    this.doOk = function() {
        $("select").each(function() {
            $(this)[0].disabled = false
        });
        document.body.removeChild(E);
        document.body.removeChild(J);
        document.body.onselectstart = function() {
            return true
        };
        document.body.oncontextmenu = function() {
            return true
        }
    };
    document.body.onselectstart = function() {
        return false
    };
    document.body.oncontextmenu = function() {
        return false
    }

}

function checkischeat(A,B,C,D)
{
    $.ajax({
        type: "POST",
        url: "/user.php?act=check_cheat",
        data: "num="+A+"&id="+B+"&newid="+C+"&col="+D,
        success: function(msg) {
            //result = $.evalJSON(msg);
            //document.write(result.content);
            //alert(result.content);
        }
    })
}

/*
*	检测手机号码是否符合要求 
*		若符合发送验证短信
*/
function checkmobilenumber(A,B)
{
	$.ajax({
			type: "POST",
			url: "lottery.php?act=checkmobilenumber",
			data: 'mobilenum='+A+'&sendstep='+B,
			beforeSend:function(){
				if(B == 1){
					document.getElementById('tip_mobile').style.display = "block";
			   		document.getElementById('tip_mobile').innerHTML = "正在发送，请稍候......";
			   		document.getElementById('sub_chk_mobile').disabled = true;
				}else{
					document.getElementById('tip_yzm_step').style.display = "block";		// 发送提示区域 显示
					document.getElementById('tip_yzm_step').innerHTML = "正在发送，请稍候......";
				}
		   	},
			success:function(msg){
				$(".tel_table_notice").text('');
				document.getElementById('sub_chk_mobile').disabled = false;
		   		if(msg==1){
					// 请输入需要验证的手机号
					document.getElementById('tip_mobile').style.display = "block";
					document.getElementById('tip_mobile').innerHTML = "请填写您的手机号码！";
				}else if(msg==2){;
					// 手机号码不合法
					document.getElementById('tip_mobile').style.display = "block";
					document.getElementById('tip_mobile').innerHTML = "手机号码格式不正确，请重新填写！";
				}else if(msg==3){
					// 手机号码已被占用
					document.getElementById('tip_mobile').style.display = "block";
					document.getElementById('tip_mobile').innerHTML = "手机号码已经被占用，请重新填写！";
				}else if(msg==4){
					// 正确 发送短信					
					document.getElementById('mobile_new').disabled= true;					// 手机输入框变为 不可写
					document.getElementById('tip_mobile').style.display = "none"; 			// 提示信息 隐藏
					document.getElementById('tip_mobile_submit').style.display = "none"; 	// 获取验证码按钮 隐藏
					document.getElementById('tip_mobile_back').style.display = "block"; 	// 修改链接 显示
					
					document.getElementById('tip_ymz').style.display = "";					// 验证码输入部分 显示
					document.getElementById('tip_ymz_submit').style.display = "";			// 验证码提交部分 显示
					document.getElementById('sub_yzm').disabled = false;					// 验证码提交按钮 可用
					document.getElementById('tip_yzm_step').style.display = "block";		// 发送提示区域 显示
					document.getElementById('tip_yzm_step').innerHTML = "验证码已发送至你手机，如果长时间未收到？请点击<a style=color:#0066cc;cursor:pointer onClick=checkmobilenumber(document.getElementById('mobile_new').value,2)>[重发验证码]";		// 验证码发送提示 显示

				}else{
					document.getElementById('mobile_new').disabled= false;					// 手机输入框变为 可写
//					document.getElementById('tip_mobile').style.display = "none"; 			// 提示信息 隐藏
					document.getElementById('tip_mobile_submit').style.display = "block"; 	// 获取验证码按钮 隐藏
					document.getElementById('tip_mobile_back').style.display = "none"; 		// 修改链接 隐藏
//					
					document.getElementById('tip_ymz').style.display = "none";				// 验证码输入部分 隐藏
					document.getElementById('mobileyzm').value= "";							// 验证码输入框 清空
					document.getElementById('tip_ymz_submit').style.display = "none";		// 验证码提交部分 隐藏
//					document.getElementById('tip_yzm_step').innerHTML = "";					// 验证码发送提示 清空
//					document.getElementById('tip_yzm_step').style.display = "none";			// 发送提示区域 隐藏

					document.getElementById('tip_mobile').style.display = "block";			
			   		document.getElementById('tip_mobile').innerHTML = "发送失败，请重试......";
				}
		   }
	})
}

/*
*	用户选择修改手机
*/
function updatemobilenumber()
{

	document.getElementById('mobile_new').disabled= false;					// 手机输入框变为 可写
	document.getElementById('tip_mobile').style.display = "none"; 			// 提示信息 隐藏
	document.getElementById('tip_mobile_submit').style.display = "block"; 	// 获取验证码按钮 隐藏
	document.getElementById('tip_mobile_back').style.display = "none"; 		// 修改链接 隐藏

	document.getElementById('tip_ymz').style.display = "none";				// 验证码输入部分 隐藏
	document.getElementById('mobileyzm').value= "";							// 验证码输入框 清空
	document.getElementById('tip_ymz_submit').style.display = "none";		// 验证码提交部分 隐藏
	document.getElementById('tip_yzm_step').innerHTML = "";					// 验证码发送提示 清空
	document.getElementById('tip_yzm_step').style.display = "none";			// 发送提示区域 隐藏

}

/*
*	用户根据收到的验证码 验证手机的真实性
*/
function checkmobilevalidity(A,B)
{
	$.ajax({
			type: "POST",
		   	url: "lottery.php?act=checkmobilevalidity",
		  	data: 'mobilenum='+A+'&mobileyzm='+B,
			beforeSend:function(){
			   document.getElementById('sub_yzm').disabled = true;
			   document.getElementById('tip_yzm_step').innerHTML = "正在检测验证码，请稍候......";
		   	},
		   	success:function(msg){
					document.getElementById('sub_yzm').disabled = false;
					if(msg == 1){
						// 为填验证码
						document.getElementById('tip_yzm_step').style.display = "block";
						document.getElementById('tip_yzm_step').innerHTML = "请填写验证码！";
					}else if(msg == 2){
						// 验证码格式不正确
						document.getElementById('tip_yzm_step').style.display = "block";
						document.getElementById('tip_yzm_step').innerHTML = "请输入4位数字验证码！";
					}else if(msg == 3){
						// 验证正确
						document.getElementById('mobile_new').disabled= true;
						document.getElementById('tip_mobile').style.display = "none";
						document.getElementById('tip_mobile_ok').style.display = "block";
						document.getElementById('tip_mobile_back').style.display = "none";
						document.getElementById('tip_ymz').style.display = "none";
						document.getElementById('tip_ymz_submit').style.display = "none";
						document.getElementById('moblie_bind').value = A;
						document.getElementById('tip_tishi').style.display = "none";
						document.getElementById('tip_tishi1').style.display = "block";
						document.getElementById('chose_button').style.display = "block";
						setHeadFlowNum();//导航栏查看购物车
					}else if(msg == 4){
						// 验证失败
						document.getElementById('tip_yzm_step').style.display = "block";
						document.getElementById('tip_yzm_step').innerHTML = "验证码不正确！";
						
					}else if(msg == 5){
						// 手机已被绑定
						document.getElementById('mobile_new').disabled= false;
						document.getElementById('tip_mobile_submit').style.display = "block";
						//document.getElementById('tip_ymz_send').style.display = "none";
						document.getElementById('tip_mobile_back').style.display = "none";
						document.getElementById('tip_ymz').style.display = "none";
						document.getElementById('tip_ymz_submit').style.display = "none";
						//document.getElementById('mobileyzm').innerHTML = "";
						//document.getElementById('tip_yzm_step').innerHTML = "";
						document.getElementById('tip_mobile').style.display = "block";
						document.getElementById('tip_mobile').innerHTML = "手机号码已经被占用，请重新填写！";
					}
	   		}
	})
}
