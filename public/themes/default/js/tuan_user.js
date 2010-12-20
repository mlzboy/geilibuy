$(document).ready(function(){
			   
						   
	$(".prevIndex").val("0");
	//默认-1
	
	var DdSize=$(".maillist dd").size();
	//.maillist中dd的数量
	
	$(".inputs").focus(function(){		
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
	    if($(this).attr('id')!="bookinput")
    	{		
  		    CheckEmail($(this));
  		}
  		else
  		{$('#bookmailtop1').focus();
  		   $(this).parent().find(".maillist").hide(); 
  		    }    		
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
		{   $(this).parent().next().find("span").removeClass('do_tip error_tip ok_tip help_tip');
			$(this).parent().next().find("span").addClass('help_tip');
			$(this).parent().next().find("span").html("");
			return (false);
		}  
	});
	
	$("#captcha").blur(function(){
		CheckYzm($(this));
	}); 
	
	$(".inputs").blur(function(){
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
	//过滤bookinput订阅邮件input	
	//if (window.event.keyCode==13) window.event.keyCode=9;

	    //过滤回车键
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
    	{	if($(this).attr('id')!="bookinput")
    		{
    		    $(this).parent().find(".prevIndex").val(0);
        		$(this).parent().find('.maillist').find('dd').eq(0).addClass('mail_on').siblings().removeClass('mail_on');		
        		$(this).blur();
        		$(this).parent().parent().parent().next().find("input").select();
        		$(this).parent().parent().parent().next().find("input").focus();
        		checkLoginForm($('#loginForm'));
    	    }
    	}
    
	}); 	
	
	//得到焦点文本框光标在最后位置函数
	function setinputfocus(input)
	{  		
		input.blur();
		input.parent().parent().parent().next().find("input").select();
		input.parent().parent().parent().next().find("input").focus();
		 if(input.attr('id')!="bookinput")
    	{
		checkLoginForm($('#loginForm'));
	    }
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
				   url:  WEB+"usercenter/check",
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
		yzm.parent().next().find("span").removeClass('do_tip error_tip ok_tip help_tip');
		yzm.parent().next().find("span").addClass('do_tip error_tip');
		yzm.parent().next().find(".do_tip").html("不能为空");
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
	   url:  WEB+"usercenter/check",
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
    $("#captcha").parent().next().find("span").removeClass('do_tip error_tip ok_tip help_tip');
	$("#captcha").parent().next().find("span").addClass('do_tip error_tip');
	$("#captcha").parent().next().find("span").html("不能为空");
	$("#captcha").select();
	$("#captcha").focus();
    return false;
  }
  
  $.ajax({
	   type: "POST",
	   url:  WEB+"usercenter/check",
	   data: 'act=check_captcha&captcha=' + $('#captcha').val() + '&m=' + Math.random(),
	   success:function(msg){
    	    if(msg == 0)
    	    {
				$("#captcha").parent().next().find("span").removeClass('do_tip error_tip ok_tip help_tip');
				$("#captcha").parent().next().find("span").addClass('do_tip error_tip');
				$("#captcha").parent().next().find("span").html("验证码不正确");
    	        return false;
    	    }else if(msg == -1)
    	    {
    	        $("#captcha").parent().next().find("span").removeClass('do_tip error_tip ok_tip help_tip');
				$("#captcha").parent().next().find("span").addClass('do_tip error_tip');
				$("#captcha").parent().next().find("span").html("不能为空");
				$("#captcha").select();
				$("#captcha").focus();
				return false;
    	    }
    	    else
    	    {	
				$("#captcha").parent().next().find("span").removeClass('do_tip error_tip ok_tip help_tip');
				$("#captcha").parent().next().find("span").addClass('do_tip ok_tip');
				$("#captcha").parent().next().find("span").html("");
    	        document.formUser.submit();
    	    }
	   }
	  });
}