//var WEB = 'http://www.geilibuy.com/';
var WEB = '/';

//给力团javascript文件
$(document).ready(function(){
    
$('#bookinput').focus(function(){
  if($(this).val()=="输入Email，订阅每日团购信息")
  {$(this).val('');}
}); 
$('#bookinput').blur(function(){
  return false;
});    
//城市列表弹出操作
$(".city").click(function(){

	if($('.citylist').hasClass('on'))
	{
	$('.citylist').removeClass('on');
	$('#popbtn').html('▼');
	$('.citylist').hide(); 
	$('#list_off').hide(); 
	}
	else
	{
	$('#popbtn').html('▲');
	$('.citylist').addClass('on');
	$('.citylist').show();
	$('#list_off').show(); 	
	
	}	
	//window.event.cancelBubble=true;
	return false; 
}); 

$("body").click(function(){
	if($('.citylist').hasClass('on'))
	{
	$('.citylist').removeClass('on');
	$('#popbtn').html('▼');
	$('.citylist').hide(); 
	$('#list_off').hide(); 
	}	
}); 

//城市列表项悬浮操作
$('.citylist').find('.cityoff').hover(function(){											  
	$(this).addClass('cityon');			  
}, function(){	
 if(!$(this).hasClass('city_on'))
	 {
	$(this).removeClass('cityon');	}
});	


//导航栏下提示框关闭操作
$('.navtip_dl').find('dt').click(function(){
	 $('.navtip').removeClass('navtip_on');
	 $('.navtip_dl').hide();
});	

//弹出对话框关闭操作
$('.pop_dl>dt>span').click(function(){
	$("#popbg").fadeOut();								
	 $('.pop_dl').fadeOut();		 
});
$('#PayClose').click(function(){
	$("#popbg").fadeOut();								
	 $('.pop_dl').fadeOut();		 
});

//订单付款弹出对话框关闭操作
$('.pop_dl>dt>div').click(function(){
	$("#popbg").fadeOut();								
	$('.pop_dl').fadeOut();
	window.location.reload();	 
});
$('#CheckClose').click(function(){
    $("#popbg").fadeOut();								
    $('.pop_dl').fadeOut();
	location.reload();		 
});


//我的给力团菜单栏弹出操作
$('#mypop').hover(function(){											  
	$('.mytuan').addClass('mytuan_on');
	$('#my_pop,#my_popin').show();												  
}, function(){											  
	$('#my_pop,#my_popin').hide(); 
	$('.mytuan').removeClass('mytuan_on');
});
//msn/qq分享点击操作
$('.im').live("click", function(){
	if(!$('.share').hasClass('share_on'))							   
	{$('.share').addClass('share_on');}
	else
	{$('.share').removeClass('share_on');}
});


// 订阅对话框弹出操作 （通用头部 和 团购结束页面）
$('#bookmailtop1, #bookmailtop2').click(function(){

    var cmt = new Object;
    
    if($(this).attr('id') == 'bookmailtop1')
    {
      cmt.email         = $('#theFormTop1').find('#bookinput').val();
      //cmt.city_id         = $('#theFormTop1').find('#t_book_city_id').val();
    }else
    {
      cmt.email         = $('#theFormTop2').find('#bookinput').val();
      //cmt.city_id         = $('#theFormTop2').find('#t_book_city_id').val();
    }

	var filter=/^\s*([A-Za-z0-9_-]+(\.\w+)*@(\w+\.)+\w{2,3})\s*$/;
	if (cmt.email == '')
	{
	  alert('请输入您的Email地址');
	  return false;
	}
    if (!filter.test(cmt.email) || cmt.email == '') 
	{
      alert('邮件地址格式错误，请检查。');
	  return false;
	}
	

    //alert($.toJSON(cmt));

	$.ajax({
					type: "POST",
					url: WEB+"tuan/check",
					data: 't_act=subscript&cmt='+ $.toJSON(cmt),
					success: function(A) {
						var re = eval("(" + A + ")");
                        if(re.error == 1){
                           alert(re.message);
					   }else{
					    popdiv("#pol_dl_mail","400","auto",0.2);
					  }
					}
				});	
		
});

//订阅对话框弹出操作 （邮件订阅页面）
$('#bookmail').click(function(){
  var cmt = new Object;
	var frm = document.theForm;


	cmt.email         = frm.elements['t_book_email'].value;
	
  
	var filter=/^\s*([A-Za-z0-9_-]+(\.\w+)*@(\w+\.)+\w{2,3})\s*$/;
  if (!filter.test(cmt.email) || cmt.email == '') 
	{
	  $("#MetionDivEmail").addClass('navtip_on');
    $(".navtip_dl").show();
    $("#MetionDivEmail>dl>dd").html('邮件地址格式错误，请检查。');
	  return false;
	}
	
	
    //alert($.toJSON(cmt));

	$.ajax({
					type: "POST",
					url:  WEB+"tuan/check",
					data: 't_act=subscript&cmt='+ $.toJSON(cmt),
					success: function(A) {
						var re = eval("(" + A + ")");
                        if(re.error == 1){
					    alert(re.message);
					  }else{
					    popdiv("#pol_dl_mail","400","auto",0.2);
					  }
					}
				});	
		
});

});

// 复制文本框分享链接内容
function copy1(copy){
	if (window.clipboardData)
	{
		window.clipboardData.setData("Text", copy);
	}
	else if (window.netscape)
	{
		netscape.security.PrivilegeManager.enablePrivilege('UniversalXPConnect');
		var clip = Components.classes['@mozilla.org/widget/clipboard;1'].createInstance(Components.interfaces.nsIClipboard);
		if (!clip) return;
		var trans = Components.classes['@mozilla.org/widget/transferable;1'].createInstance(Components.interfaces.nsITransferable);
		if (!trans) return;
		trans.addDataFlavor('text/unicode');
		var str = new Object();
		var len = new Object();
		var str = Components.classes["@mozilla.org/supports-string;1"].createInstance(Components.interfaces.nsISupportsString);
		var copytext=copy;
		str.data=copytext;
		trans.setTransferData("text/unicode",str,copytext.length*2);
		var clipid=Components.interfaces.nsIClipboard;
		if (!clip) return false;
		clip.setData(trans,null,clipid.kGlobalClipboard);
	}
	//$("#urldoc").html("已将您的专用邀请链接复制到剪切板：");
	alert("复制成功，您可以粘贴到MSN或QQ中发给好友。");
	return false;
}
function copy2(copy){
	if (window.clipboardData)
	{
		window.clipboardData.setData("Text", copy);
	}
	else if (window.netscape)
	{
		netscape.security.PrivilegeManager.enablePrivilege('UniversalXPConnect');
		var clip = Components.classes['@mozilla.org/widget/clipboard;1'].createInstance(Components.interfaces.nsIClipboard);
		if (!clip) return;
		var trans = Components.classes['@mozilla.org/widget/transferable;1'].createInstance(Components.interfaces.nsITransferable);
		if (!trans) return;
		trans.addDataFlavor('text/unicode');
		var str = new Object();
		var len = new Object();
		var str = Components.classes["@mozilla.org/supports-string;1"].createInstance(Components.interfaces.nsISupportsString);
		var copytext=copy;
		str.data=copytext;
		trans.setTransferData("text/unicode",str,copytext.length*2);
		var clipid=Components.interfaces.nsIClipboard;
		if (!clip) return false;
		clip.setData(trans,null,clipid.kGlobalClipboard);
	}
	//$("#urldoc2").html("已将您的专用邀请链接复制到剪切板：");
	alert("复制成功，您可以粘贴到MSN或QQ中发给好友。");
	return false;
}   

// 检查密码
function tuan_editPassword()
{
	var oldpwd     = $('#oldpwd').val();
	var newpwd     = $('#newpwd').val();
	var newpwd2    = $('#newpwd2').val();
	if(oldpwd.length != 0 || newpwd.length != 0 || newpwd2.length != 0)
	{
		if(oldpwd.length != 0)
		{	
			$('#tishi').css({'color':""})
			$('#tishi').html("");
			
			if(newpwd.length == 0)
			{
				$('#tishi1').css({'color':"#cb3e00"})
				$('#tishi1').html("新密码不能为空");
				return false;
			}
			else
			{
				if(newpwd.length < 6)
				{
					$('#tishi1').css({'color':"#cb3e00"})
					$('#tishi1').html("密码不能少于6个字");
					return false;
				}
			}
			
			if(newpwd2.length == 0)
			{
				$('#tishi1').css({'color':""})
				$('#tishi1').html("最少6个字符");
				$('#tishi2').css({'color':"#cb3e00"})
				$('#tishi2').html("确认密码不能为空");
				return false;
			}
			else
			{
				if(newpwd2.length < 6)
				{
					$('#tishi1').css({'color':""})
					$('#tishi1').html("最少6个字符");
					$('#tishi2').css({'color':"#cb3e00"})
					$('#tishi2').html("密码不能少于6个字");
					return false;
				}
			}
			
			if(oldpwd == newpwd)
			{
				$('#tishi1').css({'color':"#cb3e00"})
				$('#tishi1').html("新密码不能和旧密码一致");
				$('#tishi2').css({'color':""})
				$('#tishi2').html("输入与上面相同的密码");
				return false;
			}
			
			if(newpwd.length >5 && newpwd2.length > 5 )
			{
				if(newpwd != newpwd2)
				{
					$('#tishi1').css({'color':""})
					$('#tishi1').html("最少6个字符");
					$('#tishi2').css({'color':"#cb3e00"})
					$('#tishi2').html("二次输入密码不匹配");
					return false;
				}
			}
		}
		else if(oldpwd.length == 0 || (newpwd.length != 0 && newpwd2.length != 0))
		{
			$('#tishi').css({'color':"#cb3e00"})
			$('#tishi').html("请输入旧密码");
			return false;
		}
	
		
	}
	return true;
}

/* 控制#textarea字符长度 */
//A 类型
//B 字符长度
//C 控制元素的id
function lentxt(A,B,C)
{
  var s_content = $(C)[0].value;

  if(A == 1 && (s_content == '咨询不能超过'+B+'个字' || s_content == '评论不能超过'+B+'个字' || s_content == '字数上限'+B)){
    $(C)[0].value = '';
    return  false;
  }

  var s_num = s_content.replace(/[\r\n]/g, '').length;

  if(s_num > B)
  {
    $(C)[0].value = s_content.substring(0,B);
    return  false;
  }
  else
  {
    return  true;
  }
}


//  提交咨询、评论
function tuan_add_comment()
{
	if($.trim($('#content').val()) == "" || $.trim($("#content").val()) == '咨询不能超过200个字')
	{
		alert("请输入咨询内容");
		return false;
	}
	$.ajax({
		type: "POST",
		url: "/tuan/qa",
		data: "t_id=" + $('#tuan_id').val() + "&t_content=" + $('#content').val() + "&t_cmt_type=" + $('#cmt_type').val() + "&" + Math.random(),
		success: function(msg){
			var re = eval("(" + msg + ")");
			if (re.error > "0"){
				$("#submit_comment_ok").css("display","block");
				$("#comment_content").css("display","none");
			}
			else
			{
				alert("提交失败");
			}
		}
	})

}
// ajax 获取咨询问题列表
function tuan_getCommentList(page,actid,isall)
{
	$.ajax({
		type: "POST",
		url:  WEB+"tuan/index_action.php?t_act=tuan_comment_ajax",
		data: "act_id=" + actid + "&isall="+ isall +"&page=" + page + "&" + Math.random(),
		success: function(msg){
			var re = eval("(" + msg + ")");
			$("#comment_list").html(re.content);
		}
	})
	
}

// ajax 获取首页咨询问题列表
function tuan_getDealsCommentList(page,actid,isall)
{
	$.ajax({
		type: "POST",
		url:  WEB+"tuan/index_action.php?t_act=deals_comment_ajax",
		data: "act_id=" + actid + "&isall="+ isall +"&page=" + page + "&" + Math.random(),
		success: function(msg){
			var re = eval("(" + msg + ")");
			//alert(re.content.htmlstr);
			$("#CommentList").after(re.content.htmlstr);
			$("#CommentCount").html(re.content.count);
			if(re.content.num > 0)
			{
			    $("#ORDER_METION")[0].style.display= '';
			    $("#ORDER_NUM").html(re.content.num);
			}
			
			if(re.content.unpayedorder != '')
			{
			    $("#UNPAYED_ORDER_METION")[0].style.display= '';
			    $("#unpayedorder").attr('href',re.content.unpayedorder);
			    
			}
			
			$(".newsbar").html(re.content.gonggao);
		}
	})
	
}

// ajax 获取订单列表
function tuan_getOrderList(page)
{
	$.ajax({
		type: "POST",
		url:  WEB+"tuan/index_action.php?t_act=tuan_orderlist_ajax",
		data: "page=" + page + "&" + Math.random(),
		success: function(msg){
			var re = eval("(" + msg + ")");
			$("#order_list").html(re.content);
		}
	})
	
}
// ajax 获取现金账户列表
function tuan_getMoneyAccountList(page)
{
	$.ajax({
		type: "POST",
		url:  WEB+"tuan/index_action.php?t_act=tuan_moneyaccountlist_ajax",
		data: "page=" + page + "&" + Math.random(),
		success: function(msg){
			var re = eval("(" + msg + ")");
			$("#moneyaccount_list").html(re.content);
		}
	})
	
}
// ajax 获取团购邀请人列表
function tuan_getInvitesList(page)
{
	$.ajax({
		type: "POST",
		url:  WEB+"tuan/index_action.php?t_act=tuan_inviteslist_ajax",
		data: "page=" + page + "&" + Math.random(),
		success: function(msg){
			var re = eval("(" + msg + ")");
			$("#share_list").html(re.content);
		}
	})
	
}
// ajax 获取团购积分列表
function tuan_getPointsList(page)
{
	$.ajax({
		type: "POST",
		url:  WEB+"tuan/index_action.php?t_act=tuan_pointslist_ajax",
		data: "page=" + page + "&" + Math.random(),
		success: function(msg){
			var re = eval("(" + msg + ")");
			$("#points_list").html(re.content);
		}
	})
	
}

/* ajax检测用户登录状态 */
function setTuanHeadUserStatus() {

    $.ajax({
        type: "POST",
        url:  WEB+"usercenter/check",
        data: "act=check_login&m=" + Math.random(),
        success: function(A) {
            var re = eval("(" + A + ")");
            var U = $("#nav_user").find('li');
            if(re.error == 1){
              $("#nav_user").find('li').eq(1).html('欢迎您，'+re.content.nickname+'！');
              U[1].style.display = '';
              U[2].style.display = '';
              U[3].style.display = '';
              U[0].style.display = '';
            }else{
                
//              U[3].style.display = 'none';
              //$("#nav_user").find('li').eq(1).html('');
              $("#nav_user").find('li').eq(2).html('');
//              $("#nav_user").find('li').eq(3).html('');
              U[5].style.display = '';
              U[4].style.display = '';
              
              U[1].style.display = '';
              U[2].style.display = '';
              U[0].style.display = '';
              
            }
        }
    })
}

/* 团购倒计时 */
function getTuanGouCountDown(A)
{
    $.ajax({
		type: "GET",
		url:  WEB+"tuan/check",
		data: "t_act=get_countdown&t_c="+A+"&m=" + Math.random(),
		success: function(msg){
		    tuangouCountDown(msg);
		}
	});
}

/* 团购倒计时响应 */
function tuangouCountDown(msg){
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

      if('will' == status){
        document.getElementById("update_time").innerHTML="距开始还剩：<b>" + hour + "</b> 小时&nbsp;&nbsp;<b>" + minute + "</b> 分钟&nbsp;&nbsp;<b>" + second+"</b> 秒";
      }
      else{
        document.getElementById("update_time").innerHTML="<b>" + hour + "</b> 小时&nbsp;&nbsp;<b>" + minute + "</b> 分钟&nbsp;&nbsp;<b>" + second+"</b> 秒";
      }
      
      /* 结束后刷新页面 */
      if(day==0&&hour==0&&minute==0&&second==0){
        window.location.reload();
      }
      else{
        setTimeout  (CountDown,1000);
      }
    }

    if(msg == 1)
    {
        return false;
    }
    var re = eval("(" + msg + ")");
    var status = 'now';
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

    $("#tuangou_user").html(re.content.tuangou_user);//当前团购人数
    $("#buyer_needed").html(re.content.buyer_needed);//还差几人成团
    $("#d_status").html(re.content.htmlstr);//团购人数状态
    if(re.content.format_buyer_minimum_time != null){
        $("#chengtuan_time").html(re.content.format_buyer_minimum_time+'达到最低团购人数<strong>'+re.content.buyer_minimum+'</strong>人');//成团时间
    }
    var tempTime=re.content.time.split(":");
    var day=tempTime[0];
    var hour=tempTime[1];
    var minute=tempTime[2];
    var second=tempTime[3];
}

/* 订阅团购信息 */
function Subscrpit(){
    var email = $('#subscript_email').val();
    var filter=/^\s*([A-Za-z0-9_-]+(\.\w+)*@(\w+\.)+\w{2,3})\s*$/;
    if (!filter.test(email)) 
    {
        alert('格式不正确');
        return false;
    }
    alert(email);
    
    $.ajax({
		type: 'GET',
		url:  'tuangou.php?act=subscript',
		data: 'email='+email+'&m=' + Math.random(),
		success: function(msg){
		    alert(msg);
		    //tuangouCountDown(msg);
		}
	});
}

// 动态获取 邀请链接
function getTuanShareUrl()
{
	$.ajax({
		   type: "POST",
		   url: WEB+"tuan/index_action.php?t_act=create_shareurl_ajax",
		   success: function(msg){
			   var re = eval("(" + msg + ")");
			   $("#tuanshare").html(re.content);
		   }
	});
}

/******************region.js*******************************/
/***********（fuxing copy于购物车的flow.js）***************/
var region = new Object();

region.isAdmin = false;

region.loadRegions = function(parent, type, target)
{
$.ajax({
     type: "GET",
     url: region.getFileName(),
     data: 'type=' + type + '&target=' + target + '&parent='+parent + "&m=" + Math.random(),
     success:region.response
  });
}

/* *
 * 载入指定的国家下所有的省份
 *
 * @country integer     国家的编号
 * @selName string      列表框的名称
 */
region.loadProvinces = function(country, selName)
{
  var objName = (typeof selName == "undefined") ? "selProvinces" : selName;

  region.loadRegions(country, 1, objName);
}

/* *
 * 载入指定的省份下所有的城市
 *
 * @province    integer 省份的编号
 * @selName     string  列表框的名称
 */
region.loadCities = function(province, selName)
{
  var objName = (typeof selName == "undefined") ? "selCities" : selName;

  region.loadRegions(province, 2, objName);
}

/* *
 * 载入指定的城市下的区 / 县
 *
 * @city    integer     城市的编号
 * @selName string      列表框的名称
 */
region.loadDistricts = function(city, selName)
{
  var objName = (typeof selName == "undefined") ? "selDistricts" : selName;

  region.loadRegions(city, 3, objName);
}

/* *
 * 处理下拉列表改变的函数
 *
 * @obj     object  下拉列表
 * @type    integer 类型
 * @selName string  目标列表框的名称
 */
region.changed = function(obj, type, selName)
{
  var parent = obj.options[obj.selectedIndex].value;

  region.loadRegions(parent, type, selName);
}

region.response = function(result, text_result)
{
  result = $.evalJSON(result);
  var sel = document.getElementById(result.target);
  sel.length = 1;
  sel.selectedIndex = 0;
  sel.style.display = (result.regions.length == 0 && ! region.isAdmin && result.type + 0 == 3) ? "none" : '';

  if (document.all)
  {
    sel.fireEvent("onchange");
  }
  else
  {
    var evt = document.createEvent("HTMLEvents");
    evt.initEvent('change', true, true);
    sel.dispatchEvent(evt);
  }

  if (result.regions)
  {
    for (i = 0; i < result.regions.length; i ++ )
    {
      var opt = document.createElement("OPTION");
      opt.value = result.regions[i].region_id;
      opt.text  = result.regions[i].region_name;

      sel.options.add(opt);
    }
  }
}

region.getFileName = function()
{
  if (region.isAdmin)
  {
    return "../region";
  }
  else
  {
    return WEB+"shopping/region";
  }
}
/* *
 * 检查收货地址信息表单中填写的内容
 */
var consignee_not_null = "收货人姓名不能为空！";
var country_not_null = "请您选择收货人所在国家！";
var province_not_null = "请您选择收货人所在省份！";
var city_not_null = "请您选择收货人所在城市！";
var district_not_null = "请您选择收货人所在区域！";
var invalid_email = "您输入的邮件地址不是一个合法的邮件地址。";
var address_not_null = "详细地址不能为空！";
var tele_not_null = "手机不能为空！";
var shipping_not_null = "请您选择配送方式！";
var payment_not_null = "请您选择支付方式！";
var goodsattr_style = "1";
var tele_invaild = "手机号码不有效的号码";
var zip_not_num = "邮政编码只能填写数字";
var zip_not_null = "邮政编码不能为空";
var mobile_invaild = "手机号码不是合法号码";
var tele_both_null = "请填写手机号码！";
var moblie_isbind = "必须验证手机才能领奖";

function tuan_checkConsignee(frm,msgBoxAlert,defaultEmail,isLottery)
{
  var msg = new Array();
  var err = false;

  if ( !isEmail(frm.elements['email'].value))
  {
  if($(".email_table_notice")){
    //$(".email_table_notice").text(invalid_email).css({"color":"#cc3333"});return false;
  }else{
      alert(invalid_email);return false;
  }
  }else{
    if($(".email_table_notice")){
      $(".email_table_notice").text('');
    }
  }

  if($(".email_table_notice")){
    if (!isEmail(frm.elements['email'].value) && frm.elements['email'].value != ''){
          $(".email_table_notice").text(invalid_email).css({"color":"#cc3333"});return false;
    }
  }
  
  if (frm.elements['consignee'].value == '')
  {
    $(".consignee_table_notice").text(consignee_not_null);return false;
  }else{
     $(".consignee_table_notice").text('');
  }

  if (frm.elements['country'] && frm.elements['country'].value == 0)
  {
  $(".country_table_notice").text(country_not_null);return false;
  }else{
   $(".country_table_notice").text('');
  }

  if (frm.elements['province'] && frm.elements['province'].value == 0 && frm.elements['province'].length > 1)
  {
  $(".country_table_notice").text(province_not_null);return false;
  }else{
    $(".country_table_notice").text('');
  }

  if (frm.elements['city'] && frm.elements['city'].value == 0 && frm.elements['city'].length > 1)
  {
  $(".country_table_notice").text(city_not_null);return false;
  }else{
    $(".country_table_notice").text('');
  }

  if (frm.elements['district'] && frm.elements['district'].length > 1)
  {
    if (frm.elements['district'].value == 0)
    {
    $(".country_table_notice").text(district_not_null);return false;
    }else{
      $(".country_table_notice").text('');
  }
  }

  if (frm.elements['address'] && frm.elements['address'].value == '')
  {
    $(".address_table_notice").text(address_not_null);return false;
  }else{
    $(".address_table_notice").text('');
  }
  
  
  
  if (frm.elements['zipcode'] && frm.elements['zipcode'].value == '')
  {
    if(isLottery){
      //$(".zipcode_table_notice").text(zip_not_null);return false;
    }
  } else if (frm.elements['zipcode'] && frm.elements['zipcode'].value.length > 0 && (!Tools.isNumber(frm.elements['zipcode'].value)))
  {
    $(".zipcode_table_notice").text(zip_not_num);return false;
  }else{
     $(".zipcode_table_notice").text('');
  }


  if(Tools.isEmpty(frm.elements['tel'].value) && Tools.isEmpty(frm.elements['mobile'].value)){
     if(isLottery){
      document.getElementById('tip_mobile').style.display = "none";
     }
        $(".tel_table_notice").text(tele_both_null);return false;
  }else{
      if(!Tools.isEmpty(frm.elements['tel'].value))
      if (Tools.isEmpty(frm.elements['tel'].value))
    {
        $(".tel_table_notice").text(tele_not_null);return false;
    }
    else
    {
    if (!Tools.isTel(frm.elements['tel'].value))
    {
        $(".tel_table_notice").text(tele_invaild);return false;
    }
    }
      if(!Tools.isEmpty(frm.elements['mobile'].value))
    if (frm.elements['mobile'] && frm.elements['mobile'].value.length > 0 && (!Tools.isTel(frm.elements['mobile'].value)))
    {
         if(isLottery){
      document.getElementById('tip_mobile').style.display = "none";
     }
     $(".tel_table_notice").text(mobile_invaild);return false;
    }
  }
  $(".tel_table_notice").text('');


  if($(".email_table_notice") && defaultEmail){
     if(frm.elements['email'].value.replace(/[ ]/g,"") == ''){
      //frm.elements['email'].value = 'guestorder@geilibuy.com';
   }
  }

  if(msgBoxAlert)alert("地址修改已保存");
  if(isLottery){
  // add by tlergong 2010-05-19  领奖必须是通过验证的手机
  if(frm.elements['moblie_bind'].value == ''){
    document.getElementById('tip_mobile').style.display = "none";
    $(".tel_table_notice").text(moblie_isbind);
    return false;
  }
  
    $('#submitAddress')[0].disabled = true;
  }
  return true;
}