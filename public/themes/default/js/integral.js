/* 活动菜单样式控制 */
function stepUserCenterAction(step){
      $("#left_box").find('a').each(function(){
	      var flag = $(this).attr('objFlag');
		  if(step == flag){
			   $("#left_box").find('li').removeClass('left_ul_on');
			   $(this).parent().addClass('left_ul_on');
		  }
	  });
}
/* 积分兑换幸运点 */
function exchangeIntegral(A)
{
    var num = document.getElementById('exchange_integral').value;    
    if(A){
      if((Number(num) <= 0) || (Number(num) != parseInt(num)) || isNaN(num)){
        $("#exchange_integral")[0].value = '';
        return false;
      }
    }else{
    
        $.ajax({
          type: "POST",
          url:  "points.php?act=do_exchange",
          data: "num=" + num + "&m=" + Math.random(),
          success: function(msg){
            var result = eval("(" + msg + ")");
            if(result.error == 0){
              document.getElementById('exchange_integral').value = '';
              $('#INTEGRAL')[0].innerHTML = result.content['integral'];
              $('#EXCHAGE_NUM')[0].innerHTML = result.content['exchange_num'];
              $('#NUM')[0].innerHTML = result.content['num'];
              $('#NUM_DIV')[0].style.display= 'block';
            }else if(result.error == -1){
				window.location="user.php?act=login&back_act=points.php?act=exchange";
              //popdiv("#login_pop","471","auto",0.4);
              //document.getElementById('exchange_integral').value = '';
            }else{
                alert(result.message);
              document.getElementById('exchange_integral').value = '';
            }
          }
        });
    
    }
}


