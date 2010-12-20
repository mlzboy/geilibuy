jQuery.fn.outerHTML = function(s) {
return (s)
? this.before(s).remove()
: jQuery("&lt;p&gt;").append(this.eq(0).clone()).html();
}

//给力团 用户中心javascript 文件
$(document).ready(function(){
//付款对话框弹出操作
$('#pay_sure').click(function(){	
	popdiv(".pop_dl","400","auto",0.2);
});	

//星星打分出操作
var pingarr=['很不满意','不满意','一般','满意','很满意'];

	 $('#stars').find('a').hover(function () {	
		$('#stars').removeClass();
		$('#stars').addClass('stars');
		$('#stars').addClass('stars'+$('#pingvar').val());
		$('#stars').addClass('star'+$('#stars').find('a').index(this));
		$('#pingarr').html(pingarr[$('#stars').find('a').index(this)]);		
	}, function(){	
		{
		$('#stars').removeClass();
		$('#stars').addClass('stars');
		$('#stars').addClass('stars'+$('#pingvar').val());
		$('#pingarr').html(pingarr[$('#stars').find('a').index(this)]);		
		}	
	}); 

	$('#stars').find('a').click(function () {
  $('#stars').removeClass();
	$('#stars').addClass('stars');
	$('#stars').addClass('star'+$('#stars').find('a').index(this));
	$('#stars').addClass('stars'+$('#stars').find('a').index(this));
	$('#pingvar').val($('#stars').find('a').index(this));
    });

	$('#stars').hover(function(){							   
	}, function(){
		if($('#pingvar').val()!='-1')
		{
    		if($(this).hasClass('stars'+$('#pingvar').val()))	
    		{$(this).addClass('star'+$('#pingvar').val());
    		$('#pingarr').html(pingarr[$('#pingvar').val()]);
    		}
		}
		else
		{
			$('#pingarr').html('');
		}
	});
	
//评论对话框弹出操作
$('.red').live("click", function(){
  var pingorderid = $(this).attr('recid');
  var pinggroupbuyid = $(this).attr('groupbuyid');
  var pinggoodsid = $(this).attr('goodsid');
  var pingcommentid = $(this).attr('commentid');
  var pingcontent = $(this).attr('content');
  var pingrank = $(this).attr('rank');

  $('#pingorderid').val(pingorderid);
  $('#pinggroupbuyid').val(pinggroupbuyid);
  $('#pinggoodsid').val(pinggoodsid);
  $('#pingcommentid').val(pingcommentid);
  
  if(pingrank > 0){
    pingrank = Number(pingrank) - Number(1);
    $('#pingcontent').html(pingcontent);
  }else{
    pingrank = -1;
    $('#pingcontent').html('评论不能超过200个字');
  }
    
    $('#pingvar').val(pingrank);
    $('#stars').removeClass();
    $('#stars').addClass('stars');
    $('#stars').addClass('star'+pingrank);
    $('#stars').addClass('stars'+pingrank);
    $('#pingarr').html(pingarr[pingrank]);
    
  
  
  
  
	popdiv(".pop_dl","400","auto",0.2);	
});


//提交评论点击操作
$('#pingsubmit').click(function(){

  var cmt = new Object;
  cmt.rank = $('#pingvar').val();
  cmt.content = $('#pingcontent').val();
  cmt.order_id = $('#pingorderid').val();
  cmt.groupbuy_id = $('#pinggroupbuyid').val();
  cmt.goods_id = $('#pinggoodsid').val();
  cmt.comment_id = $('#pingcommentid').val();
  
  //alert($.toJSON(cmt));

  $.ajax({
					type: "POST",
					url:  WEB+"tuan/check",
					data: 't_act=add_comment&cmt='+ $.toJSON(cmt),
					success: function(A) {
					  var re = eval("(" + A + ")");
                      if(re.error > 0){
					    alert(re.message);
					  }else{
					    
					    $('#pingclose').click();
					    ////$('#red_'+cmt.order_id).html('已评价');
					    
					    $('#red_'+cmt.order_id).outerHTML("<span style='color: #C90809;'>已评价</span>");
					    $('#red_'+cmt.order_id).attr('commentid',re.content.comment_id);
					    $('#red_'+cmt.order_id).attr('content',re.content.content);
					    re.content.rank = Number(re.content.rank) + Number(1)
					    //alert(re.content.rank);
					    $('#red_'+cmt.order_id).attr('rank',re.content.rank);
					  }
					}
				});	
  
});

//点击[配送到这个地址]操作
$('#CheckGroupBuy').click(function(){		

	var frm = document.theForm;
  if(!tuan_checkConsignee(frm,'',true))
	{
	    return false;
	}
  else{
    //alert('通过');	
    $('#CheckGroupBuy')[0].disabled = true;
    frm.elements['province'].disabled = false;
  	frm.elements['city'].disabled = false;
    frm.submit(); 
  }


});	



});

