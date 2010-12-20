//给力团 购物流程javascript 文件

$(document).ready(function(){
//点击提交订单操作
$('#CheckGroupBuy').click(function(){		
	
  var cmt = new Object;
	var frm = document.theForm;

	cmt.t_city           = frm.elements['t_c'].value;
	cmt.idinfo         = frm.elements['t_id'].value;
	cmt.num            = frm.elements['t_num'].value;
	if(frm.elements['new_address'])
	{
	  cmt.isNew			     = frm.elements['new_address'].value;
	  cmt.address_id		 = frm.elements['address_id'].value;
  	cmt.consignee			 = frm.elements['consignee'].value;
  	cmt.country			   = frm.elements['country'].value;
  	cmt.province			 = frm.elements['province'].value;
  	cmt.city			     = frm.elements['city'].value;
  	cmt.district			 = frm.elements['district'].value;
  	cmt.email			     = frm.elements['email'].value;
  	cmt.address			   = frm.elements['address'].value;
  	cmt.tel			       = frm.elements['tel'].value;
  	cmt.mobile			   = frm.elements['mobile'].value;
	}
	
	
	if(cmt.isNew> 0)
	{
	    if(!tuan_checkConsignee(frm,'',true))
      	{//alert('false');
      	    return false;
      	}
	}else{
	  //alert('不检测新地址');	
    }
	//alert($.toJSON(cmt));
	if(cmt.t_city == '' || cmt.idinfo == '')
	{
	  alert('操作错误');;
      return false;
	}

	$.ajax({
					type: "POST",
					url:  WEB+"tuan/check",
					data: 't_act=buy_check&cmt='+ $.toJSON(cmt),
					success: function(A) {
						var re = eval("(" + A + ")");
						if(re.error == 3)
						{
						  //alert('您只能购买N个');
  					      $("#MetionDivNum").addClass('navtip_on');
                          $(".navtip_dl").show();
                          $("#MetionDivNum>dl>dd").html('抱歉，数量有限，您最多只能购买 '+re.content.restrict_amount+' 件');
                          $('#t_num').val(parseInt(re.content.num));
					      $("#GoodsAmount").html(re.content.goods_amount);
					      $("#TotalAmount").html(re.content.total_amount);
					      $("#ShippingFee").html(re.content.shipping_fee);

					    }else if(re.error == 2)
						{
						  //alert('未登录');
						  location.href= WEB+"tuan/account/login";
					  }else if(re.error == 1){
					    //alert('结束或错误');
						  location.href= WEB+"tuan/deals/"+cmt.city+"-"+cmt.idinfo+".html";
					  }else{
					    //alert('返回订单号');
					    //location.href= WEB+"tuan/buy/check/"+re.content;
					    //lexus 20101126
					    location.href= WEB+"tuan/checkout";
					    
					  }
					}
				});
	
		
});	

//付款对话框弹出操作
$('#pay_sure').click(function(){	
    popdiv(".pop_dl","400","auto",0.2);	
		
});

$('#gotoLogin').click(function(){
    document.gotoLoginForm.submit();
});


});


/* 检测输入商品数量 */
function CheckGroupBuyNum(obj)
{
    var N = obj.value;
    

    if(!Tools.isNumber(N) ||isNaN(N))
    {      
      $("#MetionDivNum").addClass('navtip_on');
      $(".navtip_dl").show();
      $("#MetionDivNum>dl>dd").html('请输入正确的购买数量');
      return false;
    }else{
      
      if(N != parseInt(N))
      {
        $("#MetionDivNum").addClass('navtip_on');
        $(".navtip_dl").show();
        $("#MetionDivNum>dl>dd").html('请输入正确的购买数量');
        return false;
      }else{
        $("#MetionDivNum").removeClass('navtip_on');
        $(".navtip_dl").hide();
        obj.value= parseInt(N);
        
        var cmt = new Object;
      	var frm = document.theForm;
      
      	cmt.t_city         = frm.elements['t_c'].value;
      	cmt.idinfo         = frm.elements['t_id'].value;
      	cmt.num            = parseInt(N);
      	
        $.ajax({
					type: "POST",
					url:  WEB+"tuan/check",
					data: 't_act=buy_check_num&cmt='+ $.toJSON(cmt),
					success: function(A) {
						var re = eval("(" + A + ")");
						if(re.error > 0)
						{
						  //alert('结束或错误');
						  location.href= WEB+"tuan/deals/"+cmt.t_city+"-"+cmt.idinfo+".html";
					  }else{
					    if(Number(re.content.num) < Number(N)){
  					    $("#MetionDivNum").addClass('navtip_on');
                        $(".navtip_dl").show();
                        $("#MetionDivNum>dl>dd").html('抱歉，数量有限，您最多只能购买 '+re.content.restrict_amount+' 件');
					    }
					    obj.value= parseInt(re.content.num);
					    $("#GoodsAmount").html(re.content.goods_amount);
					    $("#TotalAmount").html(re.content.total_amount);
					    $("#ShippingFee").html(re.content.shipping_fee);
					    
					    
					  }
					}
				});
      }
      
    }
}