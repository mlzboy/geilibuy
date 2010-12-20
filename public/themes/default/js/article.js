function stepUserCenterAction(step){
      $("#about_left_box").find('a').each(function(){
	      var flag = $(this).attr('objFlag');
		  if(step == flag){
			   $("#about_left_box").find('li').removeClass('about_left_list_selected');
			   $(this).parent().addClass('about_left_list_selected');
		  }
	  });

	   $("#help_left_box").find('a').each(function(){
	      var flag = $(this).attr('objFlag');
		  if(step == flag){
			   $("#help_left_box").find('li').removeClass('help_left_list_selected');
			   $(this).parent().addClass('help_left_list_selected');
			   $(this).parent('div').addClass('help_left_title_selected');
		  }
	  });
}

var msg_title_empty = "标题不能为空!";
var msg_content_empty = "留言不能为空!";
var msg_content_limit = "留言限制在1024字以内!";
/* *
 * 对会员的留言输入作处理
 */
function submitMsg()
{
    
  var frm         = document.forms['formMsg'];
  //var msg_title   = frm.elements['msg_title'].value;
  var msg_content = frm.elements['msg_content'].value;
  var msg_captcha = frm.elements['captcha'].value;
  var msg_type = frm.elements['msg_type'].value;
  var msg = '';
  if (msg_content.length == 0)
  {
	msg += msg_content_empty + '\n'
  }

  if (msg_content.length > 1024)
  {
	msg += msg_content_limit + '\n';
  }
  
  if (msg.length > 0)
  {
	alert(msg);
	return false;
  }
  
  $.ajax({
        type: "POST",
        url: "/usercenter/check?act=act_add_message_nologin",
        cache: false,
        data: 'captcha=' + msg_captcha +'&msg_content=' + msg_content +'&msg_type=' + msg_type +'&m='+ Math.random(),
        success:function(result){
            result = eval('('+result+')');
            if(result.error == 1){
                alert(result.message);
                //$('#captcha_notice_span')[0].innerHTML =result.message;
            }else{
                $('#submitMsg')[0].disabled = true;
                alert(result.message);
                location.href='/advice';
            }
        }
    });
   return false;

/*
  if (msg_title.length == 0)
  {
	msg += msg_title_empty + '\n';
 }
  if (msg_content.length == 0)
  {
	msg += msg_content_empty + '\n'
  }

  if (msg_content.length > 10)
  {
	msg += msg_content_limit + '\n';
  }
  
  if (msg.length > 0)
  {
	alert(msg);
	return false;
  }
  else
  {
	return true;
  }*/

}



