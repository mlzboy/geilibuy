$(document).ready(function(){
			   
						   
	$(".prevIndex").val("0");
	//默认-1
	
	var DdSize=$(".maillist dd").size();
	//.maillist中dd的数量
	
	$(".do_input").focus(function(){		
  		$(this).addClass("on_input");
	}); 
	$(".uemail").focus(function(){		
  		$(this).parent().find('.maillist').find('dd:first').attr("id","dd_0").attr("index",'0').addClass('mail_on');
		$('.do_tip').empty();
		$('.do_tip').removeClass("do_tip error_tip");
		if($(this).val() =="")
		{		
			//$(this).parent().parent().next().find("span").show();
			$(this).parent().parent().next().find("span").removeClass();
			$(this).parent().parent().next().find("span").addClass('help_tip');
			if($(this).attr('id')=="login_user")
			{
				$(this).parent().parent().next().find("span").html("");
			}
			else
			{
				$(this).parent().parent().next().find("span").html("请使用有效邮箱");
			}
			return (false);
		}
		
	}); 
	 
	 $(".uemail").blur(function(){		
  		CheckEmail($(this));		
	}); 	
	
	$("#nick").focus(function(){
	    $(this).select();	
		if($(this).val() =="")
		{   $(this).parent().next().find("span").removeClass('do_tip error_tip ok_tip help_tip');
			$(this).parent().next().find("span").addClass('help_tip');
			$(this).parent().next().find("span").html("字母,数字下划线或汉字");
			return (false);
		}  
	}); 
	 $("#nick").blur(function(){		
  		CheckNick($(this));
	}); 
	 
	$("#password,#confirm_password,#login_psword").focus(function(){
		if($(this).val() =="")
		{   $(this).parent().next().find("span").removeClass('do_tip error_tip ok_tip help_tip');
			$(this).parent().next().find("span").addClass('help_tip');
			if($(this).attr('id')=="login_psword")
			{
				$(this).parent().next().find("span").html("");
			}
			else
			{
				$(this).parent().next().find("span").html("不能少于6位字符");
			}
			
			
			
			return (false);
		}  
	}); 
	$("#password,#login_psword").focus(function(){
		$(this).select();									  	
		
	}); 	
	$("#password,#login_psword,#nick").select(function(){							  	
		$('.maillist').hide();
	});
	
	
	
	$("#password,#confirm_password,#login_psword").blur(function(){
		CheckPassword($(this));
	});
	
	$("#confirm_password").focus(function(){
		if($(this).val() =="")
		{   $(this).parent().next().find("span").removeClass('do_tip error_tip ok_tip help_tip');
			$(this).parent().next().find("span").addClass('help_tip');
			$(this).parent().next().find("span").html("请再次输入密码");
			return (false);
		}  
	}); 
	$("#confirm_password").blur(function(){
		ComparePassword($(this).parent().parent().prev().find("input"),$(this));
	}); 
	
	
	$("#captcha").focus(function(){
		if($(this).val() =="")
		{   $(this).parent().parent().next().find("span").removeClass('do_tip error_tip ok_tip help_tip');
			$(this).parent().parent().next().find("span").addClass('help_tip');
			$(this).parent().parent().next().find("span").html("");
			return (false);
		}  
	});
	
	$("#captcha").blur(function(){
		CheckYzm($(this));
	}); 
	
	$(".do_input").blur(function(){
  		$(this).removeClass("on_input");
	}); 
	
	$(".maillist").hover(function(){
  		
	}, function(){			
		$(this).hide();	
	});
	
	$(".uemail").mousedown(function(){
  		$(this).parent().find('.maillist').hide();
	});
	
	//email的keyup事件操作						
	$(".uemail").keyup(function(event){	
	//过滤回车键	
	//if (window.event.keyCode==13) window.event.keyCode=9;
	if((event.keyCode !=13))
	{
  		$(this).parent().find('.maillist').show();		
		$(this).parent().find('.maillist').find('dd').eq(0).html($(this).val());
		//
		var mtxt="";
		mtxt=$(this).val().split("@");
		var mailregu=$(this).val(); 		 
		var mailre=new RegExp(mailregu);
		var sort=1;			
		$(this).parent().find('.maillist').find('dd').not(':first').each(function(index) { 
			$(this).html(mtxt[0]+"@"+$(this).attr('addr'));					
			if($(this).text().search(mailre)!=-1)
			{
				$(this).show();	
				$(this).attr("id","dd_"+sort).attr("index",sort);	
				sort++;
			}     
			else     
			{   
				$(this).hide();
				$(this).attr("id","").attr("index","");	
			} 
		DdSize=sort;
		});	
		if($(this).parent().find(".prevIndex").val()>sort)
		{
			$(this).parent().find(".prevIndex").val(0);		
		}	
	}
	else
	{	
		$(this).parent().find(".prevIndex").val(0);
		$(this).parent().find('.maillist').find('dd').eq(0).addClass('mail_on').siblings().removeClass('mail_on');		
		$(this).blur();
		$(this).parent().parent().parent().next().find("input").select();
		$(this).parent().parent().parent().next().find("input").focus();
		checkLoginForm($('#loginForm'));
	}
	}); 	
	
	//得到焦点文本框光标在最后位置函数
	function setinputfocus(input)
	{  		
		input.blur();
		input.parent().parent().parent().next().find("input").select();
		input.parent().parent().parent().next().find("input").focus();
		checkLoginForm($('#loginForm'));
	}
	//回车相应函数
	function clickDd(currIndex,isme) {
		var prevIndex=isme.parent().find(".prevIndex").val();
		isme.parent().find('.maillist').find("#dd_0").remove("mail_on");
		if(currIndex>-1) {
			isme.parent().find('.maillist').find("#dd_"+currIndex).addClass("mail_on").siblings().removeClass('mail_on');
		}
		isme.parent().find('.maillist').find("#dd_"+prevIndex).removeClass("mail_on");
		isme.parent().find(".prevIndex").val(currIndex);
	}
	
	$(".maillist dd").mouseover(function () {
		//鼠标滑过
		$(this).addClass("mail_on");
		$(this).parent().parent().parent().find('.uemail').val($(this).html());
	}).mouseout(function () {
		//鼠标滑出
		$(this).removeClass("mail_on");
	}).click(function () {
		//鼠标单击		
		var prevIndex=parseInt($(this).parent().find(".prevIndex").val());			
		$(this).parent().parent().parent().find('.maillist').hide();
		var emailinput=$(this).parent().parent().parent().find('.uemail').eq(0);		
		setinputfocus(emailinput);	
	});	
	
	//email输入框绑定键盘上下回车键事件
	$(".uemail").bind('keydown','up',function (evt) {
		//↑
		//alert($(this).attr('id'));
		var prevIndex=parseInt($(this).parent().find(".prevIndex").val());
		if(prevIndex==-1||prevIndex==0) {
			clickDd(DdSize-1,$(this));
		}else if(prevIndex>0) {
			clickDd(prevIndex-1,$(this));
		}
		return false;
	}).bind('keydown','down',function (evt) {
		//↓
		var prevIndex=parseInt($(this).parent().find(".prevIndex").val());
		if(prevIndex==-1||prevIndex==(DdSize-1)) {
			clickDd(0,$(this));
		}else if(prevIndex<(DdSize-1)) {
			clickDd(prevIndex+1,$(this));
		}
		return false;
	}).bind('keydown','return',function (evt) {
		//↙
		var prevIndex=parseInt($(this).parent().find(".prevIndex").val());
		$(this).focus();
		$(this).val($(this).parent().find('.maillist').find("#dd_"+prevIndex).html());
		$(this).parent().find('.maillist').hide();
		return false;
	});
	//clickDd(0);	
	$('#loginForm').keydown(function(event){
		if((event.keyCode ==13))
		{
			checkLoginForm($('#loginForm'));
		}
	});
	$('#formUser').keydown(function(event){
		if((event.keyCode ==13))
		{			
			checkSignupForm();
		}		
	});
	
	$("#combin_reg").click(function(){
     $(this).attr('checked',true); 
     $("#combin_band").attr('checked',false); 	
     $("#combin1").addClass('combin_on')
     $("#combin1").find('.tablebox').slideDown(200);
     $("#combin2").removeClass('combin_on')
     $("#combin2").find('.tablebox').slideUp(200);
     
    });
    $("#combin_band").click(function(){
     $(this).attr('checked',true); 
     $("#combin_reg").attr('checked',false); 								 
     $("#combin1").removeClass('combin_on')
     $("#combin1").find('.tablebox').slideUp(200);
     $("#combin2").addClass('combin_on')
     $("#combin2").find('.tablebox').slideDown(200);
    });
	
});	

function CheckEmail(Email)
{	//Email.parent().parent().next().find(".do_tip").remove();
	Email.parent().parent().next().find("span").removeClass('error_tip ok_tip help_tip').addClass('do_tip');
	if(Email.val() =="")
	{		
		//Email.parent().parent().next().find(".do_tip").show();
		Email.parent().parent().next().find(".do_tip").addClass('error_tip');
	    Email.parent().parent().next().find(".do_tip").html("不能为空");
	    return (false);
	}    
	var filter=/^\s*([A-Za-z0-9_-]+(\.\w+)*@(\w+\.)+\w{2,3})\s*$/;
    if (!filter.test(Email.val())) 
	{ 
		Email.parent().parent().next().find(".do_tip").addClass('error_tip');
     	Email.parent().parent().next().find(".do_tip").html("格式有误");
       	return (false); 
   	}
	else
	{	
		if($(Email).attr('id')=="login_user")
			{
				Email.parent().parent().next().find(".do_tip").addClass('help_tip');
				Email.parent().parent().next().find(".do_tip").html("");
			}
			else
			{	Email.parent().parent().next().find("span").removeClass();	
				Email.parent().parent().next().find("span").addClass('help_tip');
				Email.parent().parent().next().find("span").html("邮件验证中...");		
				$.ajax({
				   type: "GET",
				   url: "/usercenter/check",
				   data: 'act=check_email&email=' + Email.val() + "&m=" + Math.random(),
				   success:function(msg){
				   if ( msg == 'ok' ){
					   Email.parent().parent().next().find("span").removeClass('help_tip');
					   Email.parent().parent().next().find("span").addClass('do_tip');
					  Email.parent().parent().next().find("span").addClass('ok_tip');
					  Email.parent().parent().next().find("span").html("");
					}
					else
					{
						Email.parent().parent().next().find("span").removeClass('help_tip');
					Email.parent().parent().next().find("span").addClass('do_tip');
					  Email.parent().parent().next().find("span").addClass('error_tip');
					　Email.parent().parent().next().find("span").html("已被注册");
					}
				   }
				  });
			}
			return (false);
		
	    
	}
}
function CheckNick(Nick)
{
	
	var filter=/^[\u4e00-\u9fa5a-zA-Z0-9_]+$/;
    if(Nick.val().length>0)
	{
		if (!filter.test(Nick.val())) 
		{ 
			Nick.parent().next().find("span").removeClass('error_tip ok_tip help_tip').addClass('do_tip');
			Nick.parent().next().find(".do_tip").addClass('error_tip');
			Nick.parent().next().find(".do_tip").html("有非法字符");
			return (false); 
		}
		
		Nick.parent().next().find("span").removeClass('error_tip ok_tip help_tip');
	 	Nick.parent().next().find("span").addClass('do_tip ok_tip');
        Nick.parent().next().find(".do_tip").html("");
	}
	else
	{
		Nick.parent().next().find("span").removeClass('error_tip ok_tip help_tip');
	 	Nick.parent().next().find("span").addClass('do_tip help_tip');
        Nick.parent().next().find(".do_tip").html("");
		
    }
}


function CheckPassword(password)
{	
	if(password.val().length>0)
	{
		if(password.attr('id')!="login_psword")			
			{
				if(password.val().length<6)
				{	password.parent().next().find("span").removeClass('do_tip error_tip ok_tip help_tip');
					password.parent().next().find("span").addClass('do_tip error_tip');
					password.parent().next().find(".do_tip").html("密码太短");
					return false;
				}
			}		
			
	}
	else
	{
		password.parent().next().find("span").removeClass('do_tip error_tip ok_tip help_tip');
		password.parent().next().find("span").addClass('do_tip error_tip');
		password.parent().next().find(".do_tip").html("不能为空");
		return false;
	}
	if(password.attr('id')!="login_psword")			
	{
		password.parent().next().find("span").removeClass('error_tip ok_tip help_tip');
		password.parent().next().find("span").addClass('do_tip ok_tip');
		password.parent().next().find(".do_tip").html("");
		return false;
	}	
}

function ComparePassword(password1,password2)
{	
	if(password2.val().length>0)
	{
		if (password1.val()!=password2.val())
		{
			password2.parent().next().find("span").removeClass('do_tip error_tip ok_tip help_tip');
			password2.parent().next().find("span").addClass('do_tip error_tip');
			password2.parent().next().find(".do_tip").html("确认有误");
			return false;
		} 
		else
		{
			password2.parent().next().find("span").removeClass('error_tip ok_tip help_tip');
			password2.parent().next().find("span").addClass('do_tip ok_tip');
			password2.parent().next().find(".do_tip").html("");	
		}
	}
	else
	{
		password2.parent().next().find("span").removeClass('do_tip error_tip ok_tip help_tip');
		password2.parent().next().find("span").addClass('do_tip error_tip');
		password2.parent().next().find(".do_tip").html("不能为空");
		return false;
	}
	
}
function CheckYzm(yzm)
{	
	if(yzm.val().length==0)
	{
		yzm.parent().parent().next().find("span").removeClass('do_tip error_tip ok_tip help_tip');
		yzm.parent().parent().next().find("span").addClass('do_tip error_tip');
		yzm.parent().parent().next().find(".do_tip").html("不能为空");
		return false;
	}
		/*yzm.parent().parent().next().find("span").removeClass('error_tip ok_tip help_tip');
	 	yzm.parent().parent().next().find("span").addClass('do_tip ok_tip');
        yzm.parent().parent().next().find(".do_tip").html("");*/
}
function checkLoginForm(thisform) 
{	
	
	if($('#login_user').val() =="")
	{		
		$('#login_user').parent().parent().next().find("span").removeClass('error_tip ok_tip help_tip').addClass('do_tip');
		$('#login_user').parent().parent().next().find("span").addClass('error_tip');
	    $('#login_user').parent().parent().next().find("span").html("不能为空");
        return false;
	}    
	var filter=/^\s*([A-Za-z0-9_-]+(\.\w+)*@(\w+\.)+\w{2,3})\s*$/;
    if (!filter.test($('#login_user').val())) 
	{ 	$('#login_user').parent().parent().next().find("span").removeClass('error_tip ok_tip help_tip').addClass('do_tip');
		$('#login_user').parent().parent().next().find("span").addClass('error_tip');
     	$('#login_user').parent().parent().next().find("span").html("格式有误");
        return false; 
   	}
		$('#login_user').parent().parent().next().find("span").removeClass('error_tip ok_tip help_tip do_tip');
		$('#login_user').parent().parent().next().find("span").addClass('help_tip');
     	$('#login_user').parent().parent().next().find("span").html("");
	
	if($('#login_psword').val().length<=0)	
	{
		$('#login_psword').parent().next().find("span").removeClass('do_tip error_tip ok_tip help_tip');
		$('#login_psword').parent().next().find("span").addClass('do_tip error_tip');
		$('#login_psword').parent().next().find("span").html("不能为空");
		return false;
	}
	
		$('#login_psword').parent().next().find("span").removeClass('error_tip ok_tip help_tip do_tip');
		$('#login_psword').parent().next().find("span").addClass('help_tip');
		$('#login_psword').parent().next().find("span").html("");
		
	var remember = '';
	if($('#remember').checked){remember = $('#remember').value;}
	
	$.ajax({
	   type: "POST",
	   url: "/usercenter/check",
	   data: 'act=check_login_info&username=' + $('#login_user').val() + '&password=' + $('#login_psword').val() + '&m=' + Math.random(),
	   success:function(msg){
    	    if(msg == 0)
    	    {
    	        //alert('用户名或密码错误');
				thisform.find('input:button').eq(0).parent().find("span").eq(0).removeClass('error_tip ok_tip help_tip').addClass('do_tip');
				thisform.find('input:button').eq(0).parent().find("span").eq(0).addClass('error_tip');
    			thisform.find('input:button').eq(0).parent().find("span").eq(0).html("Email或密码错误！");
    	    }
    	    else
    	    {
				thisform.find('input:button').eq(0).parent().find("span").eq(0).removeClass('error_tip ok_tip help_tip do_tip');
				thisform.find('input:button').eq(0).parent().find("span").eq(0).addClass('help_tip');
    			thisform.find('input:button').eq(0).parent().find("span").eq(0).html("");
    	        document.loginForm.submit();
    	    }
	   }
	  });
}
function checkSignupForm() {
  
	if($('#email').val() =="")
	{		
		$('#email').parent().parent().next().find("span").removeClass('error_tip ok_tip help_tip').addClass('do_tip');
		$('#email').parent().parent().next().find("span").addClass('error_tip');
	    $('#email').parent().parent().next().find("span").html("不能为空");
		$('#email').select();
		$('#email').focus();
        return false;
	}    
	var filter=/^\s*([A-Za-z0-9_-]+(\.\w+)*@(\w+\.)+\w{2,3})\s*$/;
    if (!filter.test($('#email').val())) 
	{ 
		$('#email').parent().parent().next().find("span").removeClass('error_tip ok_tip help_tip').addClass('do_tip');
		$('#email').parent().parent().next().find("span").addClass('error_tip');
     	$('#email').parent().parent().next().find("span").html("格式有误");
        return false; 
   	}

    if($('#email').parent().parent().next().find("span").eq(0).text()=="已被注册"){
     //$('#email').focus();
	 //$('#email').select();
     return false;
  }

	if($('#password').val().length>0)
	{
		
		if($('#password').val().length<6)
		{	$('#password').parent().next().find("span").removeClass('do_tip error_tip ok_tip help_tip');
			$('#password').parent().next().find("span").addClass('do_tip error_tip');
			$('#password').parent().next().find("span").html("密码太短");
			return false;
		}		
		else
		{
			$('#password').parent().next().find("span").removeClass('do_tip error_tip ok_tip help_tip');
			$('#password').parent().next().find("span").addClass('do_tip ok_tip');
			$('#password').parent().next().find("span").html("");
		}
	}
	else
	{
		$('#password').parent().next().find("span").removeClass('do_tip error_tip ok_tip help_tip');
		$('#password').parent().next().find("span").addClass('do_tip error_tip');
		$('#password').parent().next().find("span").html("不能为空");
		$('#password').select();
		$('#password').focus();
		return false;
	}
  
  if ($('#password').val() != $('#confirm_password').val()) {
		$('#confirm_password').parent().next().find("span").removeClass('do_tip error_tip ok_tip help_tip');
		$('#confirm_password').parent().next().find("span").addClass('do_tip error_tip');
		$('#confirm_password').parent().next().find("span").html("确认有误");
		return false;
  }   
  else
  {
		$('#conform_password').parent().next().find("span").removeClass('do_tip error_tip ok_tip help_tip');
		$('#conform_password').parent().next().find("span").addClass('do_tip ok_tip');
		$('#conform_password').parent().next().find("span").html(""); 
	}
  var agreement = $("#agreement_input");
  var agreementV = '';
  if(agreement.length)
  {
       if(!agreement[0].checked){
        $("#agreement_input").parent().next().find("span").removeClass('do_tip error_tip ok_tip help_tip');
		$("#agreement_input").parent().next().find("span").addClass('do_tip error_tip');
		$("#agreement_input").parent().next().find("span").html("需同意协议");
       return false;
     }else{
        agreementV = agreement[0].value;	
		$("#agreement_input").parent().next().find("span").removeClass('do_tip error_tip ok_tip help_tip');
		$("#agreement_input").parent().next().find("span").addClass('do_tip ok_tip');
		$("#agreement_input").parent().next().find("span").html("");
     }
  }
  if ($("#captcha").val() == '' )
  {
    $("#captcha").parent().parent().next().find("span").removeClass('do_tip error_tip ok_tip help_tip');
	$("#captcha").parent().parent().next().find("span").addClass('do_tip error_tip');
	$("#captcha").parent().parent().next().find("span").html("不能为空");
	$("#captcha").select();
	$("#captcha").focus();
    return false;
  }
  
  $.ajax({
	   type: "POST",
	   url: "/usercenter/check",
	   data: 'act=check_captcha&captcha=' + $('#captcha').val() + '&m=' + Math.random(),
	   success:function(msg){
    	    if(msg == 0)
    	    {
				$("#captcha").parent().parent().next().find("span").removeClass('do_tip error_tip ok_tip help_tip');
				$("#captcha").parent().parent().next().find("span").addClass('do_tip error_tip');
				$("#captcha").parent().parent().next().find("span").html("验证码不正确");
    	        return false;
    	    }else if(msg == -1)
    	    {
    	        $("#captcha").parent().parent().next().find("span").removeClass('do_tip error_tip ok_tip help_tip');
				$("#captcha").parent().parent().next().find("span").addClass('do_tip error_tip');
				$("#captcha").parent().parent().next().find("span").html("不能为空");
				$("#captcha").select();
				$("#captcha").focus();
				return false;
    	    }
    	    else
    	    {	
				$("#captcha").parent().parent().next().find("span").removeClass('do_tip error_tip ok_tip help_tip');
				$("#captcha").parent().parent().next().find("span").addClass('do_tip ok_tip');
				$("#captcha").parent().parent().next().find("span").html("");
    	        document.formUser.submit();
    	    }
	   }
	  });
}



function stepUserCenterAction(step){
      $("#left_box").find('a').each(function(){
	      var flag = $(this).attr('objFlag');
		  if(step == flag){
			   $("#left_box").find('li').removeClass('left_ul_on');
			   $(this).parent().addClass('left_ul_on');
		  }
	  });
}
/*********************************/
var process_request = "正在处理您的请求...";
var username_empty = " 用户名不能为空。";
var username_shorter = "  用户名长度不能少于 3 个字符。";
var username_invalid = "  用户名只能是由字母数字以及下划线组成。";
var password_empty = "  登录密码不能为空。";
var password_shorter = "密码不能少于6个字";
var confirm_password_invalid = "两次输入密码不同";
var email_empty = "  Email 为空";
var email_invalid = "  Email 不是合法的地址";
var agreement = "  您没有接受协议";
var msn_invalid = "  msn地址不是一个有效的邮件地址";
var qq_invalid = "  QQ号码不是一个有效的号码";
var home_phone_invalid = "  家庭电话不是一个有效号码";
var office_phone_invalid = "  办公电话不是一个有效号码";
var mobile_phone_invalid = "  手机号码不是一个有效号码";
var msg_un_blank = "  用户名不能为空";
var msg_un_length = "  用户名最长不得超过7个汉字";
var msg_un_format = "  用户名含有非法字符";
var msg_un_registered = "  用户名已经存在,请重新输入";
var msg_can_rg = "  可以注册";
var msg_can_rg_password = "  密码可以使用";
var msg_email_blank = "  邮件地址不能为空";
var msg_email_registered = "  邮箱已存在";
var msg_email_format = "  邮件地址不合法";
var username_exist = "用户名 %s 已经存在";
var booking_amount_empty = "请输入您要订购的玩物数量！";
var booking_amount_error = "您输入的订购数量格式不正确！";
var describe_empty = "请输入您的订购描述信息！";
var contact_username_empty = "请输入联系人姓名！";
var email_empty = "请输入联系人的电子邮件地址！";
var email_error = "您输入的电子邮件地址格式不正确！";
var contact_phone_empty = "请输入联系人的电话！";
var user_name_empty = "请输入您的用户名！";
var email_address_empty = "请输入您的电子邮件地址！";
var email_address_error = "您输入的电子邮件地址格式不正确！";
var new_password_empty = "请输入您的新密码！";
var confirm_password_empty = "请输入您的确认密码！";
var both_password_error = "您两次输入的密码不一致！";
var bonus_sn_empty = "请输入您要添加的红包号码！";
var bonus_sn_error = "您输入的红包号码格式不正确！";
var email_empty = "请输入您的电子邮件地址！";
var email_error = "您输入的电子邮件地址格式不正确！";
var old_password_empty = "请输入您的原密码！";
var new_password_empty = "请输入您的新密码！";
var confirm_password_empty = "请输入您的确认密码！";
var both_password_error = "您现两次输入的密码不一致！";
var user_name_empty = "请输入您的用户名！";
var email_address_empty = "请输入您的电子邮件地址！";
var email_address_error = "您输入的电子邮件地址格式不正确！";
var new_password_empty = "请输入您的新密码！";
var confirm_password_empty = "请输入您的确认密码！";
var both_password_error = "您两次输入的密码不一致！";
var old_password_empty = "请输入您的原密码！";
var new_password_empty = "请输入您的新密码！";
var confirm_password_empty = "请输入您的确认密码！";
var both_password_error = "您现两次输入的密码不一致！";
var old_password_empty = "请输入您的原密码！";
var new_password_empty = "请输入您的新密码！";
var confirm_password_empty = "请输入您的确认密码！";
var both_password_error = "您现两次输入的密码不一致！";

function check_password( password )
{

    if ( password.length < 6 )
    {
	    $('#password_notice span').text(password_shorter).css({"color":"#cc3333"});
	    $('#password').css("background","white");
    }
    else
    {
	    $('#password_notice span').text(msg_can_rg_password).css({"color":"#999999"});
		$('#password').css("background","white");
    }
}

function check_conform_password( conform_password )
{
	 var frm      = document.forms['formUser'];
     var password = frm.elements['password'].value;

    if ( conform_password.length < 6 )
    {
	    $('#conform_password_notice span').text(password_shorter).css({"color":"#cc3333"});
		$('#conform_password').css("background","white");
        return false;
    }
    if ( conform_password != password )
    {
	    $('#conform_password_notice span').text(confirm_password_invalid).css({"color":"#cc3333"});
		$('#conform_password').css("background","white");
    }
    else
    {
	    $('#conform_password_notice span').text(msg_can_rg_password).css({"color":"#999999"});
		$('#conform_password').css("background","white");
    }
}

function is_registered( username )
{
    var submit_disabled = false;
    if ( username == '' )
    {
        document.getElementById('username_notice').innerHTML = msg_un_blank;
        var submit_disabled = true;
    }

    if ( !chkstr( username ) )
    {
        document.getElementById('username_notice').innerHTML = msg_un_format;
        var submit_disabled = true;
    }
    if ( username.length < 3 )
    {
        document.getElementById('username_notice').innerHTML = username_shorter;
        var submit_disabled = true;
    }
    if ( username.length > 14 )
    {
        document.getElementById('username_notice').innerHTML = msg_un_length;
        var submit_disabled = true;
    }
    if ( submit_disabled )
    {
        return false;
    }
    Ajax.call( '/usercenter/check?act=is_registered', 'username=' + username, registed_callback , 'GET', 'TEXT', true, true );
}



function registed_callback(result)
{
  if ( result == "true" )
  {
    document.getElementById('username_notice').innerHTML = msg_can_rg;
   // document.forms['formUser'].elements['Submit'].disabled = '';
  }
  else
  {
    document.getElementById('username_notice').innerHTML = msg_un_registered;
   // document.forms['formUser'].elements['Submit'].disabled = 'disabled';
  }
}

function checkEmail(email)
{
  var submit_disabled = false;

  if (email == '')
  {
    $('#email_notice span').text(msg_email_blank).css({"color":"#cc3333"});
    submit_disabled = true;
  }
  else if (!Tools.isEmail(email))
  {
	$('#email_notice span').text(msg_email_format).css({"color":"#cc3333"});
    submit_disabled = true;
  }

  if( submit_disabled)
  {
     $('#email').css("background","white");
    return false;
  }

   $.ajax({
		   type: "GET",
		   url: "/usercenter/check",
		   data: 'act=check_email&email=' + email,
		   success:check_email_callback
   });
 // Ajax.call( '/usercenter/check?act=check_email', 'email=' + email, check_email_callback , 'GET', 'TEXT', true, true );
}

function check_email_callback(response)
{
   var result = response;
  if ( result == 'ok' )
  {
	$('#email_notice span').text(msg_can_rg).css({"color":"#999999"});
    $('#email').css("background","white");
  }
  else
  {
	$('#email_notice span').text(msg_email_registered).css({"color":"#cc3333"});
    $('#email').css("background","white");
  }
}

/* *
 * 处理注册用户
 */
function register()
{
  var frm  = document.forms['formUser'];
  var username  = Tools.trim(frm.elements['email'].value);
  var email  = frm.elements['email'].value;
  var password  = Tools.trim(frm.elements['password'].value);
  var confirm_password = Tools.trim(frm.elements['confirm_password'].value);
  var checked_agreement = frm.elements['agreement'].checked;
  var msn = frm.elements['other[msn]'] ? Tools.trim(frm.elements['other[msn]'].value) : '';
  var qq = frm.elements['other[qq]'] ? Tools.trim(frm.elements['other[qq]'].value) : '';
  var home_phone = frm.elements['other[home_phone]'] ? Tools.trim(frm.elements['other[home_phone]'].value) : '';
  var office_phone = frm.elements['other[office_phone]'] ? Tools.trim(frm.elements['other[office_phone]'].value) : '';
  var mobile_phone = frm.elements['other[mobile_phone]'] ? Tools.trim(frm.elements['other[mobile_phone]'].value) : '';

  if (email.length == 0)
  {
    $('#email_notice span').text(email_empty).css({"color":"#cc3333"});return false;
  }
  else
  {
    if ( ! (Tools.isEmail(email)))
    {
       $('#email_notice span').text(email_invalid).css({"color":"#cc3333"});return false;
    }else{
		 if($('#email_notice span').text()==msg_email_registered)return false;
	}
  }
  if (password.length == 0)
  {
    $('#password_notice span').text(password_empty).css({"color":"#cc3333"});return false;
  }
  else if (password.length < 6)
  {
    $('#password_notice span').text(password_shorter).css({"color":"#cc3333"});return false;
  }
  if (confirm_password != password )
  {
    $('#conform_password_notice span').text(confirm_password_invalid).css({"color":"#cc3333"});return false;
  }
  if(checked_agreement != true)
  {
   $('#agree_help span').text(agreement).css({"color":"#cc3333"});return false;
  }

  if (msn.length > 0 && (!Tools.isEmail(msn)))
  {
    $('#email_notice span').text(msn_invalid).css({"color":"#cc3333"});return false;
  }

  if (qq.length > 0 && (!Tools.isNumber(qq)))
  {
    $('#email_notice span').text(qq_invalid).css({"color":"#cc3333"});return false;
  }
  var strTemp =frm.elements['nick_name'] ? Tools.trim(frm.elements['nick_name'].value) : '';
  if(strTemp != ''){
	  var sum = 0;
	  for(var i = 0 ; i < strTemp.length ; i++){
	   if ((strTemp.charCodeAt(i)>=0) && (strTemp.charCodeAt(i)<=255)){sum=sum+1;}else{sum=sum+2;}
	  }

	  if(sum >20){
		$("#reg_nick_name_notice").text("昵称超过10个中文字符!").css("color","#cc3333");
		var returns = fucCheckChar(strTemp);
		frm.elements['nick_name'].value = returns['str'];
	  }else{
		$("#reg_nick_name_notice").text("");
	  }

	  if($("#reg_nick_name_notice").text() !=''){
		  return false;
	  }
  }
  if (office_phone.length>0)
  {
    var reg = /^[\d|\-|\s]+$/;
    if (!reg.test(office_phone))
    {
      $('#email_notice span').text(office_phone_invalid).css({"color":"#cc3333"});return false;
    }
  }
  if (home_phone.length>0)
  {
    var reg = /^[\d|\-|\s]+$/;

    if (!reg.test(home_phone))
    {
	  $('#email_notice span').text(home_phone_invalid).css({"color":"#cc3333"});return false;
    }
  }
  if (mobile_phone.length>0)
  {
    var reg = /^[\d|\-|\s]+$/;
    if (!reg.test(mobile_phone))
    {
	  $('#email_notice span').text(mobile_phone_invalid).css({"color":"#cc3333"});return false;
    }
  }
  return true;
}
/* *
 * 会员登录
 */
function userLogin()
{
  var frm      = document.forms['formLogin'];
  var username = frm.elements['username'].value;
  var password = frm.elements['password'].value;
  var msg = '';

  if (username.length == 0)
  {
    msg += username_empty + '\n';
	$("#error_notice").text(username_empty);
	return false;
  }

  if (password.length == 0)
  {
    msg += password_empty + '\n';
	$("#error_notice").text(password_empty);
  }

  if (msg.length > 0)
  {
    return false;
  }
  else
  {
    return true;
  }
}

/* *
 * 处理会员提交的缺货登记
 */
function addBooking()
{
  var frm  = document.forms['formBooking'];
  var goods_id = frm.elements['id'].value;
  var rec_id  = frm.elements['rec_id'].value;
//  var number  = frm.elements['number'].value;
//  var desc  = frm.elements['desc'].value;
  var linkman  = frm.elements['linkman'].value;
  var email  = frm.elements['email'].value;
//  var tel  = frm.elements['tel'].value;
  var msg = "";

//  if (number.length == 0)
//  {
//    msg += booking_amount_empty + '\n';
//  }
//  else
//  {
//    var reg = /^[0-9]+/;
//    if ( ! reg.test(number))
//    {
//      msg += booking_amount_error + '\n';
//    }
//  }

//  if (desc.length == 0)
//  {
//    msg += describe_empty + '\n';
//  }

  if (linkman.length == 0)
  {
    msg += contact_username_empty + '\n';
  }

  if (email.length == 0)
  {
    msg += email_empty + '\n';
  }
  else
  {
    if ( ! (Tools.isEmail(email)))
    {
      msg += email_error + '\n';
    }
  }

//  if (tel.length == 0)
//  {
//    msg += contact_phone_empty + '\n';
//  }

  if (msg.length > 0)
  {
    alert(msg);
    return false;
  }

  return true;
}

function checkBoxAction(e){
var flag = false;
if(e.checked){flag = true;}
$('div > input').each(function(){
	if($(this)[0].name == "colect_goods_list"){
	    $(this)[0].checked = flag;
	}
});
mathPriceAction(e);
}

function mathPriceAction(item){
var total_num = 0;
var total_price = 0;
var flag = true;
$('div > input').each(function(){
	if($(this)[0].name == "colect_goods_list"){
	    if(!$(this)[0].checked){
		    flag = false;
		}else{
		    var price = $('#THIS_PRICE_'+$(this)[0].value).text();
			price =  parseFloat(price.replace(' ',price.replace('元','')));
			total_price+=price;total_num++;
		}
	}
});
$('#colect_goods_list_all')[0].checked = flag;
$('#GOODS_MONEY_COUNT').text(total_price.toFixed(2) + "元");
$('#GOODS_NUM').text(total_num);
}


function allBuyDeletAction(flag){
var toys_id = '';
var step_var = '';
$('div > input').each(function(){
	if($(this)[0].name == "colect_goods_list"){
	    if($(this)[0].checked){
			if(flag){
				toys_id += $(this)[0].value + ',';
			}else{
				toys_id += $(this).attr('dXml') + ',';
			}
		}
	}
});

if(!toys_id){alert("没有选中任何玩物!");return;}
if(flag){
	step_var = 'add_to_cart_arr';
}else{
	step_var = 'delet_to_cart_arr';
}

$.ajax({
	   type: "POST",
	   url: "/shopping/check",
	   data: 'step=' + step_var + "&goods_id_arr=" + toys_id,
	   success:function (response) {
			if(response){
				var rt = response.split(',');
				if(rt[0]=='true'){
				    location.href = rt[1];
				}
			}
		}
});

}


/* *
 * 会员找回密码时，对输入作处理
 */
function submitPwdInfo()
{
  var frm = document.forms['getPassword'];
  //var user_name = frm.elements['user_name'].value;
  var user_name = frm.elements['email'].value;
  var email     = frm.elements['email'].value;

  var errorMsg = '';
  if (user_name.length == 0)
  {
    //errorMsg += user_name_empty + '\n';
  }

  if (email.length == 0)
  {
    errorMsg += email_address_empty + '\n';
  }
  else
  {
    if ( ! (Tools.isEmail(email)))
    {
      errorMsg += email_address_error + '\n';
    }
  }

  if (errorMsg.length > 0)
  {
    alert(errorMsg);
    return false;
  }

  return true;
}

/* *
 * 修改会员信息
 */
function userCenterInfoEditAction()
{
  var frm = document.forms['formEdit'];
  var email = frm.elements['email'].value;
  var msg = '';
  var reg = null;var sum = 0;
  var strTemp = $("#info_input")[0].value;

  for(var i = 0 ; i < strTemp.length ; i++){
   if ((strTemp.charCodeAt(i)>=0) && (strTemp.charCodeAt(i)<=255)){sum=sum+1;}else{sum=sum+2;}
  }

  if(sum >20){
    $("#userinfo_value > span").eq(1).text("昵称超过10个中文字符!").css("color","#cc3333");
	var returns = fucCheckChar(strTemp);
	$("#info_input")[0].value = returns['str'];
  }else{
    $("#userinfo_value > span").eq(1).text("");
  }

  if($("#userinfo_value > span").eq(1).text() !=''){
      return false;
  }

  if (email.length == 0)
  {
    msg += email_empty + '\n';
  }
  else
  {
    if ( ! (Tools.isEmail(email)))
    {
      msg += email_error + '\n';
    }
  }

  if (msg.length > 0)
  {
    alert(msg);
    return false;
  }
  else
  {
    return true;
  }
}


/* *
 *  处理用户添加一个红包
 */
function addBonus()
{
  var frm      = document.forms['addBouns'];
  var bonus_sn = frm.elements['bonus_sn'].value;

  if (bonus_sn.length == 0)
  {
	$("#global_insert_input > span:last").text(bonus_sn_empty).css({"color":"#cc3333"});
    return false;
  }
  else
  {
	/*
    var reg = /^[0-9]{10}$/;
    if ( ! reg.test(bonus_sn))
    {
	  $("#global_insert_input > span:last").text(bonus_sn_error).css({"color":"#cc3333"});
      return false;
    }
	*/
  }

  return true;
}

/* 会员修改密码 */
function editPassword()
{
  var frm              = document.forms['formPassword'];
  var old_password     = $F('old_password');
  var new_password     = $F('new_password');
  var confirm_password = $F('comfirm_password');

  var msg = '';
  var reg = null;

  if (old_password.length == 0)
  {
	$("span.resset_pass_notice").eq(0).text(old_password_empty).css({"color":"#cc3333"});return false;
  }

  if (new_password.length == 0)
  {
	$("span.resset_pass_notice").eq(1).text(new_password_empty).css({"color":"#cc3333"});return false;
  }

  if (confirm_password.length == 0)
  {
	$("span.resset_pass_notice").eq(2).text(confirm_password_empty).css({"color":"#cc3333"});return false;
  }

  if (new_password.length > 5 && confirm_password.length > 5)
  {
    if (new_password != confirm_password)
    {
		$("span.resset_pass_notice").eq(2).text(both_password_error).css({"color":"#cc3333"});return false;
    }
  }else{
	 if(new_password.length < 6){
		$("span.resset_pass_notice").eq(1).text(password_shorter).css({"color":"#cc3333"});return false;
	 }else if(confirm_password.length < 6){
	    $("span.resset_pass_notice").eq(2).text(password_shorter).css({"color":"#cc3333"});return false;
	 }
  }
    return true;
}

function userCheckVipCardAction(){
   if($F('vip_card')==''){
      $("#vipcard_notice").text('请输入打折卡密码!').css("color","#cc3333");
	  return;
   }
   var message = new Array('','请先登录!','已经是特殊用户！','更新红包失败!','更新打折卡失败!','更新用户失败!','该密码对应打折卡已被其他用户绑定，请检查。','打折卡密码不正确，请检查。','打折卡密码非法!','非法验证！');

   $.ajax({
	   type: "GET",
	   url: "/usercenter/check",
	   data: 'act=validate_vip&card=' + $F('vip_card') + "&vip=" + $F('vip_hash'),
	   success:function (response) {
		   var index = isNaN(parseInt(response))? 0 : parseInt(response);
		   if(index){
			    $("#vipcard_notice").text(message[index]).css("color","#cc3333");
			   $('#vip_card')[0].focus();
			   $('#vip_card')[0].select();
			   if(index == 1){
			       window.location = "/usercenter/check?act=login";
			   }
			}else{
			   $("#vipcard_notice").text(response).css("color","#cc3333");
			   window.location.reload();
			}
		}
   });
}

function returnMaxLength(e){
	var arr = {};
    arr = fucCheckChar(e.value);
	//e.value = arr['str'];
	if(arr['flag']){
		$("#userinfo_value > span").eq(1).text("");
		$("#reg_nick_name_notice").text("");
	}else{
		$("#userinfo_value > span").eq(1).text("昵称超过10个中文字符!").css("color","#cc3333");
		$("#reg_nick_name_notice").text("昵称超过10个中文字符!").css("color","#cc3333");
	}
}

function fucCheckChar(strTemp)
{
	var sum=0;var str = '';var arr = {};
	for(var i = 0 ; i < strTemp.length ; i++){    if ((strTemp.charCodeAt(i)>=0) && (strTemp.charCodeAt(i)<=255)){sum=sum+1;}else{sum=sum+2;}if(sum >20){if(str == ''){str = strTemp.substring(0,i);arr['flag'] = false;}}}
	if(str == ''){ str = strTemp ;arr['flag'] = true;}arr['str'] = str;return arr;
}

function setDefaultChars(id,chars){
    var obj = $("#"+id);
	var str = chars;
	if(obj.length){
	       obj[0].value = str;
		   obj.css("color","#666666");
           obj.focus(function(){
			   var testChar = obj[0].value.replace(/(^\s*)|(\s*$)/g, "");
		      if(testChar == ''|| testChar == str){
						obj[0].value = '';
				}
		   });
           obj.blur(function(){
			   var testChar = obj[0].value.replace(/(^\s*)|(\s*$)/g, "");
		        if(testChar == ''){
				   obj[0].value = str;
			    }
		   });
	}
}

function checkSubmitForm(){
   var flag = true;
   $(".order_sn_select #order_sn").each(function(){
	 if($(this)[0].value == '' ||$(this)[0].value == chars){
		  alert("验证码不能为空!");
          flag = false;
	 }
   });
   return flag;
}


function exchangeBonus(I, J, T) {
    M = ('cj' == T) ? "抽奖" : "兑奖";
    if(confirm("本次" + M + "将扣掉您" + J + "积分，是否继续？")){
        $.ajax({
            type: "GET",
            url: "/usercenter/check?act=exchange_Bonus",
            cache: false,
            data: 'lottery_id=' + I + "&m="+ Math.random(),
            success:function(msg){
    //            result = $.evalJSON(result);
                if('cj' == T) {
					if ('1' == msg) {
						alert("恭喜您抽奖成功，优惠券已充入您的账户！");
					}
					if ('0' == msg) {
						alert("抱歉，未获得奖品，再试试吧！");
					}
					if ('-1' == msg) {
						alert("抱歉，您的积分不足！");
					}
					if('' == msg){
						alert('其他错误!');
					}
                }

                if('dj' == T) {
					if ('1' == msg) {
						alert("兑换成功！");
					}
					if('0' == msg) {
						alert("兑换失败！");
					}
					if('-1' == msg) {
						alert("兑换失败！您的积分不足！");
					}
					if('' == msg){
						alert('其他错误!');
					}
				}
                window.location.reload();
            }
        });
    }else {

    }
}


function issatisfiedshow(id)
  {
    $('#is_satisfied_box_modify'+id)[0].style.display = 'none';
    $('#is_satisfied_box'+id)[0].style.display = 'inline-block';
  }

/* 客服回复满意度调查 */
function issatisfied(relpyid,e,num)
{
    if(relpyid == ''){
        return false;
    }
    var str;
    if(e == '0'){
        str = '不满意';
    }else if(e == '1'){
        str = '满意'
    }

    $.ajax({
    type: "GET",
    url: "/usercenter/check?act=manyi",
    data: "id=" + relpyid + "&value=" + e + "&m="+ Math.random(),
    success: function(result){
        if( '0' == result){
            //alert('操作成功');
            $('#is_satisfied_box'+num)[0].style.display = 'none';
            $('#is_satisfied_box_modify'+num)[0].style.display = 'inline-block';
            $('#is_satisfied_box_modify'+num)[0].innerHTML = '<span><font>'+ str +'</font></span><span class="user_ifok_btn"><a href="javascript:issatisfiedshow('+num+');">修改</a></span>';
        }else if('1' == result) {
            alert('操作失败');
        }else if('2' == result) {
            alert('非法操作');
        }
      }
    });
}


/*服务评价提交窗口*/
function orderServiceOp(N,G,O,P) {
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
    E.style.textAlign = "";
    E.style.lineHeight = "";
    E.style.zIndex = "10001";
    if (N == 0) {
        strHtml ='<div class="ucenter_pop_box" style="border:2px solid #ff0000; background-color:#fff; padding:14px;"><table width="100%" border="0" cellpadding="0" cellspacing="0"><tr><td colspan="3" style="border-bottom:1px dashed #cccccc; padding-bottom:8px;"><div style="float:left;"><strong>服务评价</strong>(收货后请评价，这有助于我们改善服务质量)</div><div style="float:right;"><a href="javascript:doOk();" class="close" style="color:#999;"">关闭</a></div></td></tr><tr><td align="right" style="padding-top:10px;">快递包装：</td><td colspan="2" style="padding-top:10px;"><input type="radio" name="packing" id="radio" value="1" />很差 <input type="radio" name="packing" id="radio2" value="2" />差 <input type="radio" name="packing" id="radio3" value="3" />一般 <input type="radio" name="packing" id="radio4" value="4" />满意 <input type="radio" name="packing" id="radio5" value="5" checked />很满意</td></tr><tr><td align="right">送货服务：</td><td colspan="2"><input type="radio" name="shipping" id="radio6" value="1" />很差 <input type="radio" name="shipping" id="radio7" value="2" />差 <input type="radio" name="shipping" id="radio8" value="3" />一般 <input type="radio" name="shipping" id="radio9" value="4" />满意 <input type="radio" name="shipping" id="radio10" value="5" checked />很满意</td></tr><tr><td align="right" valign="top" style="padding-top:5px;">评论：</td><td colspan="2" valign="top" style="padding-top:5px;"><textarea name="textarea" id="textarea" onkeyup="lentxt(0,200,\'#textarea\');" onclick="lentxt(1,200,\'#textarea\');" style="font-size:12px;">评论不能超过200个字</textarea></td></tr><tr><td>&nbsp;</td><td colspan="2"><div>*发表评论将获得<font>'+O+'积分</font>，您的评分有助于我们改善服务质量。</div></td></tr><tr><td>&nbsp;<input type="hidden" id="s_order_id" value="'+G+'" /></td><td colspan="2"><input type="button" id="orderServiceSubmit" onclick="orderServiceSubmit('+P+');" style="background:url(/themes/default/imgs/ucenter/ucenter_pop_btn1.gif) no-repeat center ;zIndex:10002;width:102px;height:31px;border:none;" /></td></tr></table></div>'
    }else if (N == 1){
        strHtml ='<div class="ucenter_pop_box" style="border:2px solid #ff0000; background-color:#fff; padding:14px;"><table width="440" border="0" cellpadding="0" cellspacing="0"><tr><td colspan="2" style="border-bottom:1px dashed #cccccc; padding-bottom:8px;"><div style="float:right;"><a href="javascript:doOk();" class="close" style="color:#999;">关闭</a></div><div><strong>服务评价成功</strong></div></td></tr><tr><td colspan="2" align="center" valign="middle" style="padding-top:30px;"><img style="vertical-align:middle; margin-right:5px;" src="/themes/default/imgs/ucenter/ucenter_pop_btn3.gif" width="25" height="25" /><strong>您对服务的评价已提交，得到'+O+'积分。</strong></td></tr><tr><td width="290" align="right"  style="padding-top:10px;"><a href="/usercenter/check?act=bought_goods"><img style=" margin-right:10px;" src="/themes/default/imgs/ucenter/ucenter_pop_btn2.gif" width="132" height="30" /></a></td><td width="150" align="left"  style="padding-top:10px;"><a style="color:#0066cc; text-decoration:underline;" href="javascript:doOk();">关闭</a></td></tr><tr><td height="50" colspan="2" align="center"><div>*对每一件商品发表评论将获得<font>'+G+'积分</font>。</div></td></tr><tr></tr></table></div>'
    }

    $("select").each(function() {
        $(this)[0].disabled = true
    });
    E.innerHTML = strHtml
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
        return true
    };
    document.body.oncontextmenu = function() {
        return true
    }

}

/* 服务评价提交 */
function orderServiceSubmit(P)
{
    var packing_rank;
    var shipping_rank;
    $('#orderServiceSubmit')[0].disabled = true;

    var group = document.getElementsByName('packing');
    for(var i = 0; i< group.length; i++)
    {
       if(group[i].checked)
       {
          packing_rank = group[i].value;
       }
    }

    var group1 = document.getElementsByName('shipping');
    for(var i = 0; i< group1.length; i++)
    {
       if(group1[i].checked)
       {
          shipping_rank = group1[i].value;
       }
    }
    var s_content = $('#textarea')[0].value;
    if(s_content == '评论不能超过200个字')
    {
        s_content = '';
    }
    var order_id = $('#s_order_id')[0].value;
    //alert(order_id+s_content+shipping_rank+packing_rank);


    $.ajax({
            type: "POST",
            url: "/usercenter/check?act=add_service_comment",
            cache: false,
            data: 'order_id=' + order_id + '&packing_rank=' + packing_rank +'&shipping_rank=' + shipping_rank +'&content=' + s_content +"&m="+ Math.random(),
            success:function(result){
                result = eval('('+result+')');
                var integral = result.content; //取得积分值
                if(P == 0){
                  $('#s_'+order_id)[0].style.color ='#999999';
                  $('#s_'+order_id)[0].innerHTML = '您已对服务做出评价';
                }else if (P == 1){
                  //$('#s_'+order_id)[0].innerHTML = '<span style="color:#ff0000">已完成</span>';
                  $('#s_'+order_id)[0].innerHTML = '&nbsp;';
                }
                doOk();
                orderServiceOp(1,integral[1],integral[0],0);
            }
        });

}

/* 忽略欢迎页提示：最近购入商品和未服务评价订单 */
/*A 参数：0服务评价 1最近购入的商品 */
function ignoreAttention(A)
{
    if(A == 0){
       var op = 'order';
       var DIV= '#RECENT_ORDER';
       var DIV2= '#RECENT_GOODS';
    }else if(A == 1){
       var op = 'goods';
       var DIV= '#RECENT_GOODS';
       var DIV2= '#RECENT_ORDER';
    }
    
    $.ajax({
            type: "POST",
            url: "/usercenter/check?act=ignore",
            cache: false,
            data: 'op=' + op +"&m="+ Math.random(),
            success:function(result){
                result = eval('('+result+')');
                if(result.error == 0){
                  $(DIV)[0].style.display ='none';
                  if((!$(DIV2)[0]) || ($(DIV2)[0] && ($(DIV2)[0].style.display == 'none'))){
                    $('#msg_a')[0].style.display ='none';//通用头部的提示图标隐藏
                  }
                  
                }else if (result.error == 1){
                  alert(result.message);
                }
            }
        });
    
}

/*
 *	ajax 检测
 *	add by tylergong 2010-06-09
 */
function userCheckMoneyCardAction()
{
	if($('#money_card').val() == "" ){
		$('#cztipbox').show();
		$('#cztip').html("请输入充值卡密码");
		$('#cztip').show();
		return;
	}
	if($('#money_card').val().length < 10){
		$('#cztipbox').show();
		$('#cztip').html("请输入10位密码");
		$('#cztip').show();
		return;
	}
	var reg = /^[A-Za-z0-9]{10}$/;
	if(!reg.test($('#money_card').val())){
		$('#cztipbox').show();
		$('#cztip').html("请输入格式正确的密码");
		$('#cztip').show();
		return;
	}
	$.ajax({
		type: "POST",			
        url: "/usercenter/check?act=money_cardcheck",
        cache: false,
        data: 'cardpwd=' + $('#money_card').val() +"&cardhash="+ $('#money_card_hash').val(),
		success:function(result){
			result = eval('('+result+')');
			if(result.msg > 0){
				window.location.href = "/usercenter/check?act=money_account&mod=ok&price="+result.money;
			}else if(result.msg == -1){
				$('#cztipbox').show();
				$('#cztip').html("充值密码错误，您今天还有("+ result.error_re+")次尝试机会");
				$('#cztip').show();
			}else if(result.msg == -2){
				$('#cztipbox').show();
				$('#cztip').html("充值卡已经被使用");
				$('#cztip').show();
			}else if(result.msg == -3){
				$('#cztipbox').show();
				$('#cztip').html("充值卡已过期");
				$('#cztip').show();
			}else if(result.msg == -4){
				$('#cztipbox').show();
				$('#cztip').html("充值失败，请稍后重试");
				$('#cztip').show();
			}else if(result.msg == -5){
				$('#cztipbox').show();
				$('#cztip').html("您已经连续5次输入充值密码错误，您的充值功能已被关闭，如果需要帮助，请拨打电话400-88-16016与客服联系");
				$('#cztip').show();
			}else{
				$('#cztipbox').show();
				$('#cztip').html("充值失败，请稍后重试");
				$('#cztip').show();
			}
		}
	});
}
