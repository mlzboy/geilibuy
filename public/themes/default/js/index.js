
function DelayLoadImg(outbox,num) 
{
    $.ajax({
        type: "POST",
        url: "/for_index.php",
        data: "target_box="+outbox+"&nums="+num,
        success: function(html) {
          result = eval('('+html+')');
		      var target_box ="#"+outbox;
          var target_box_item =$(target_box).find('.switch_item').eq(0);
			    target_box_item.after(result.content);
        }
    })
    return 1;
}

function submit_vote()
{
  var vote_id    = '';
  var vote_type  = '';
  var group = document.getElementsByName('option_id');
  var option_ids = '';
  for(var i = 0; i< group.length; i++)
  {
    if(group[i].checked)
    {
      if (option_ids == '')
      {
        option_ids = group[i].value;
      }else
      {
        option_ids += (","+group[i].value);
      }
    }
  }
  if(option_ids == '')
  {
    alert('请选择投票项目后再提交');
    return;
  }
  vote_id   = document.getElementById('vote_id').value;
  vote_type = document.getElementById('vote_type').value;
  $.ajax({
    type: "GET",
    url: "/vote",
    data: "vote="+vote_id+"&type="+vote_type+"&options="+option_ids+"&" + Math.random(),
    success: function(msg)
    {
      var re = eval("(" + msg + ")");
      if(re.error != 1)
      {
        //$(".vote")[0].innerHTML = re.content;//lexus 20101127
      }
      alert(re.message);
    }
  });
}


/* 团购倒计时 */
function IndexgetTuanGouCountDown(A)
{
    $.ajax({
		type: "GET",
		url:  "tuan/check",
		data: "t_act=get_countdown&t_c="+A+"&is_index=1&m=" + Math.random(),
		success: function(msg){
		    IndextuangouCountDown(msg);
		}
	});
}

/* 团购倒计时响应 */
function IndextuangouCountDown(msg){
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
      
      //拆分小时分秒
      if(String(hour).length > 1)
      {
        h1 = String(hour).substring(0,1);
        h2 = String(hour).substring(1,2);
      }else
      {
        h1 = '0';
        h2 = String(hour).substring(0,1);
      }
      
      if(String(minute).length > 1)
      {
        m1 = String(minute).substring(0,1);
        m2 = String(minute).substring(1,2);
      }else
      {
        m1 = '0';
        m2 = String(minute).substring(0,1);
      }

      if(String(second).length > 1)
      {
        s1 = String(second).substring(0,1);
        s2 = String(second).substring(1,2);
      }else
      {
        s1 = '0';
        s2 = String(second).substring(0,1);
      }
      

      if('will' == status){
        document.getElementById("update_time").innerHTML="距开始还剩：<b>" + hour + "</b> 小时&nbsp;&nbsp;<b>" + minute + "</b> 分钟&nbsp;&nbsp;<b>" + second+"</b> 秒";
      }
      else{
        //document.getElementById("update_time2").innerHTML="<b>" + hour + "</b> 小时&nbsp;&nbsp;<b>" + minute + "</b> 分钟&nbsp;&nbsp;<b>" + second+"</b> 秒";
        document.getElementById("update_time").innerHTML="<font class=\"overtime\"><b style=\"border-right:none;\">"+h1+"</b></font><font class=\"overtime\"><b>"+h2+"</b></font><strong>:</strong><font class=\"overtime\"><b style=\"border-right:none;\">"+m1+"</b></font><font class=\"overtime\"><b>"+m2+"</b></font><strong>:</strong><font class=\"overtime\"><b style=\"border-right:none;\">"+s1+"</b></font><font class=\"overtime\"><b>"+s2+"</b></font>";
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
    //alert(re.content.tuangou_user);
    //$("#tuangou_user").html(re.content.tuangou_user);//当前团购人数
    
    var tempTime=re.content.time.split(":");
    var day=tempTime[0];
    var hour=tempTime[1];
    var minute=tempTime[2];
    var second=tempTime[3];
}






