$(document).ready(function(){

var totle_select=0;
var totle_price=0;
var totle_select_max=$('#totle_select_max').attr('value');
var select_status='off';
var domain = "http://www.geilibuy.com/themes/default/";
//初始化移除按钮为隐藏状态
$('.name_a').hide();
$('.del_a').hide();
//选择/取消商品按钮事件
$('#zaixuan').html(totle_select_max);
$('.xuan').toggle(function(){
//选择操作函数
	if(totle_select>=totle_select_max)
	
	{	 
	//alert("您最多只能选择3件优惠特价商品,谢谢!");
	//totle_select=3; 
	//if(totle_select>=4)
	//{
	//$(this).parent().find('li').eq(4).click();
	//}
	//$(this).parent().find('li').eq(4).click();
	// return(false);
	}
	else
  {//选中css样式改变操作
    //$(this).parent().addClass('free_select_goodslist_ul_selected');
    $(this).parent().find('li').eq(0).children("span").addClass('show_duihao');
    //$(this).parent().find('li').eq(1).addClass('free_select_goodslist_ul_name_selected');
    //$(this).parent().find('li').eq(2).addClass('free_select_goodslist_ul_price_selected');
    $(this).children("a").addClass('btn_on');

    // 得到选择商品的名称,链接,图片,价格,和所在ul的id
    var goods_ids="";
    var goods_imgs="";
    var goods_names="";
    var goods_prices="";
    var goods_boxids="";
	var goods_href="";
    goods_imgs=$(this).parent().find('li').eq(0).find('a').eq(0).html();
    goods_names=$(this).parent().find('li').eq(2).find('a').eq(0).html();
    goods_prices=$(this).parent().find('li').eq(3).find('span').eq(0).html();
    goods_boxids=$(this).parent().attr('id');	
    goods_ids=$(this).parent().find('li').eq(2).find('a').eq(0).attr('goodsid');
	goods_href=$(this).parent().find('li').eq(0).find('a').eq(0).attr('href');
    //遍历顶部购物板块,哪个为空,把所选商品放入其中操作
    $('#selected_box').find('ul').each(function(index) { 
    //判断selected_box是否为空变量,用的这个对象的title值,=kong,means空,=bukong,means不空,此控制变量有待改进!
      var boxin="";
      if ($(this).attr('status')=="empty")
      {
        //alert(this.status); 
        //this.status="full";
        //alert(this.status); 
        boxin='#'+this.id;
        $(boxin).find('li').eq(1).find('a').eq(0).html(goods_imgs);
		 $(boxin).find('li').eq(1).find('a').eq(0).css("cursor","pointer");
		$(boxin).find('li').eq(1).find('a').eq(0).attr("href",goods_href);
        $(boxin).find('li').eq(0).find('a').eq(0).html(goods_names);
		$(boxin).find('li').eq(0).find('a').eq(0).attr("href",goods_href);
        $(boxin).find('li').eq(0).find('a').eq(0).attr('goodsid',goods_ids)
        //alert(this.id+'此商品id为:'+$(boxin).find('li').eq(0).find('a').eq(1).attr('goodsid'));
		$(boxin).find('li').eq(1).find('span').eq(0).html('编号:'+goods_ids);
		$(boxin).find('li').eq(1).find('span').eq(1).html('1件');
        $(boxin).find('li').eq(1).find('span').eq(2).html('原价:<font>'+goods_prices+'</font>');
        $(boxin).find('li').eq(1).find('span').eq(3).html(goods_boxids).hide();
        this.status="full";
        $(boxin).hide();
        $(boxin).fadeIn('slow');
		$('#selected_box').find('ul').eq(index).find('.name_a').eq(0).show();
        $('#selected_box').find('ul').eq(index).find('.del_a').eq(0).show();
        return false; 
      }
     });
    //选择商品数加一
    totle_select++;
	//alert('共选了'+totle_select+'件，还能选'+(totle_select_max-totle_select)+'件');
	//$('#yixuan').empty();
	//$('#zaixuan').empty();
	$('#yixuan').html(totle_select);   
	$('#zaixuan').html(totle_select_max-totle_select);
    var amount=parseInt($(this).parent().attr('amount'));
    amount=amount+1;
    $(this).parent().attr('amount',amount);
    //当选择>=3时,让未选择的商品的选择按钮显示为已完成选	
    if(totle_select>=totle_select_max)
    {
      $('.list').find('ul').each(function(index) { 	
      //$('.list').find('ul').eq(index).find('li').eq(4).addClass('dis_select');
		  if ($('.list').find('ul').eq(index).find('li').eq(4).children("a").hasClass("btn_on") ) 
		  {
		  $('.list').find('ul').eq(index).find('li').eq(4).children("a").addClass('btn_ok');
		  }
      });
    }
    $(this).parent().attr('status','off');
    //上部总价++
    totle_price=totle_price+parseFloat(goods_prices); 
    //$('#total_price').html(parseFloat(totle_price).toFixed(2));
    //判断总价是否大于59,来决定购物按钮的可有与否
    if(totle_select>=totle_select_max)
    {
       $('.buy_btn').addClass('buy_btn_on');
    }
    if(totle_select<totle_select_max)
    {
       $('.buy_btn').removeClass('buy_btn_on');
    }
	}
	$(this).click();
	},function(){
});

//上部移除商品按钮绑定事件
$('.del_a').toggle(function(){
  //判断所点击的框是否是已经移除为空,不空执行如下操作,空,不执行任何操作
  //alert($(this).parent().parent().find('li').eq(0).find('a').eq(0).html());
  if($(this).parent().parent().find('li').eq(0).find('a').eq(0).html()!='特价商品名')
  {
    //商品总数减一
    totle_select--;	
	$('#yixuan').html(totle_select);   
	$('#zaixuan').html(totle_select_max-totle_select);
    //清除原加载内容
    $(this).parent().parent().find('li').eq(0).find('a').eq(0).attr("href"," ");
	$(this).parent().parent().find('li').eq(0).find('a').eq(0).attr('goodsid','')
	$(this).parent().parent().find('li').eq(0).find('a').eq(0).html('');
	 $(this).parent().parent().find('li').eq(0).find('a').eq(0).hide();
    $(this).parent().parent().find('li').eq(1).find('a').eq(0).html($(this).parent().parent().find('li').eq(1).find('a').eq(0).attr('num'));
	$(this).parent().parent().find('li').eq(1).find('a').eq(0).attr("href","");
	$(this).parent().parent().find('li').eq(1).find('a').eq(0).css("cursor","default");
    $(this).parent().parent().find('li').eq(1).find('span').eq(0).html('');
    $(this).parent().parent().find('li').eq(1).find('span').eq(1).html('请从左侧选')
    $(this).parent().parent().find('li').eq(1).find('span').eq(2).html('');
    
    //得到下部选择/取消商品按钮对象
    var freegoodslist_box_ul='#'+$(this).parent().parent().find('li').eq(1).find('span').eq(3).text();
    //设置选择状态为on,即选中状态
    select_status='on';
    $(freegoodslist_box_ul).attr('status','on');
    var amount=parseInt($(freegoodslist_box_ul).attr('amount'));
    amount=amount-1;
    $(freegoodslist_box_ul).attr('amount',amount);
    
    //改变下部商品框为非选择状态
	
	 
	  $('.list').find('ul').each(function(index) { 	
      //$('.list').find('ul').eq(index).find('li').eq(4).addClass('dis_select');
		  if ($('.list').find('ul').eq(index).find('li').eq(4).children("a").hasClass("btn_ok")&&$('.list').find('ul').eq(index).find('li').eq(4).children("a").hasClass("btn_on") ) 
		  {
		  $('.list').find('ul').eq(index).find('li').eq(4).children("a").removeClass('btn_ok');
		  }
      });
	
	
    if (amount==0)
    {
	   // $('#'+$(this).parent().find('li').eq(0).find('span').eq(1).text()).removeClass('free_select_goodslist_ul_selected');
		$('#'+$(this).parent().parent().find('li').eq(1).find('span').eq(3).text()).find('li').eq(0).children("span").removeClass('show_duihao');
	   // $('#'+$(this).parent().find('li').eq(0).find('span').eq(1).text()).find('li').eq(1).removeClass('free_select_goodslist_ul_name_selected');
	   // $('#'+$(this).parent().find('li').eq(0).find('span').eq(1).text()).find('li').eq(4).children("a").html('<img src="' + domain + 'imgs/free_select/free_select_goods_select_btn.gif" width="16" height="16">选择该商品');
		$('#'+$(this).parent().parent().find('li').eq(1).find('span').eq(3).text()).find('li').eq(4).find('a').eq(0).removeClass('btn_on');

    }

    //设置框标记状态为空
    $(this).parent().parent().attr('status','empty');
    
    //同上
    totle_price=totle_price-parseFloat($('#'+$(this).parent().parent().find('li').eq(1).find('span').eq(3).text()).find('li').eq(1).find('font').eq(0).html()); 
    //$('#total_price').html(parseFloat(totle_price).toFixed(2));
                              
    //模拟点击了下部按钮,是上下按钮状态保持同步
    //$(freegoodslist_box_ul).find('li').eq(4).click();
    
    if(totle_select<totle_select_max)
    {
       $('.buy_btn').removeClass('buy_btn_on');
       
    }
    if(totle_select>=totle_select_max)
    {
      $('.buy_btn').addClass('buy_btn_on');
       
    }
    //模拟点击了下部按钮,这行他的第二次点击空操作,是上下按钮状态保持同步.
    //当取消后总数<=3时,遍历那些未选的显示为选择该商品按钮
    if(totle_select<=totle_select_max)
    {
      $('.list').find('ul').each(function(index) { 
        //$('.list').find('ul').eq(index).find('li').eq(4).removeClass('dis_select');
        $('.list').find('ul').eq(index).find('li').eq(4).children("a").removeClass('buy_btn_on');
      });
    }
    $(this).click();
    $(this).hide();
  }
  else
  {
     alert('您还没有选择,无法进行此操作!');
  }
  },function(){	
  //第二次操作设置为空	
});

//点商品图按钮绑定事件
$('.free_select_goodslist_ul_img').toggle(function(){
  //判断所点击的框是否是已经移除为空,不空执行如下操作,空,不执行任何操作
  $(this).parent().find('li').eq(4).click();
  $(this).click();
},function(){
  //第二次操作设置为空
});

//点商品名称绑定时间
$('.free_select_goodslist_ul_name').toggle(function(){
  //判断所点击的框是否是已经移除为空,不空执行如下操作,空,不执行任何操作
  $(this).parent().find('li').eq(4).click();
  $(this).click();
},function(){
  //第二次操作设置为空
});

//点商品名称绑定时间
$('.free_select_goods_img_box').toggle(function(){
  //判断所点击的框是否是已经移除为空,不空执行如下操作,空,不执行任何操作
  //alert(this.id+'此商品id为:'+$(this).parent().find('li').eq(0).find('a').eq(1).attr('goodsid'));
  $(this).click();
},function(){
  //第二次操作设置为空
});


$('.buy_btn').click(function(){
  //判断所点击的框是否是已经移除为空,不空执行如下操作,空,不执行任何操作
  if (totle_select==totle_select_max)
  {
    //购买操作 以下数组便是提交购物车所需的数据数组
    var selected_goods_id=new Array();
    var selected_goods_name=new Array();
    //遍历选好的商品,取得商品的id值
    $('#selected_box').find('ul').each(function(index) 
    {
      //以防万一,只遍历那些不为空的ul
      if(this.status!="empty")
      {
        //取得商品的id值,和名称
        selected_goods_id[index]=$('#selected_box').find('ul').eq(index).find('li').eq(0).find('a').eq(0).attr('goodsid');
        selected_goods_name[index]=$('#selected_box').find('ul').eq(index).find('li').eq(0).find('a').eq(0).html();
		//alert(selected_goods_id[index]+selected_goods_name[index]);
      }
    });
    //在这里请定义提交购物车函数
    //参数分别为var selected_goods_id=new Array();var selected_goods_name=new Array();
//    alert("请在这里编辑提交购物车具体操作函数");
//    alert(selected_goods_id.length);
    var goods_id = selected_goods_id.join(',');
    var id = $('#buy').attr('act_id');
    var act_name = $('#act_name').text();
    //alert(id);
    $.ajax({
      type: "GET",
      url:  "/shopping/check?step=check_packaging_goods&" + Math.random(),
      data: 'id=' + id + '&goods_id=' + goods_id+ '&packaging_type=4',
      success:function(msg){

        var re = eval("(" + msg + ")");
          if (0 == re.err_msg)
          {
            //inTooCartAction(re.result, act_name, 1);
            inTooCartAction(goods_id, act_name, 1,"0",id);
          }
          else if (1 == re.err_msg)
          {
            alert(re.content);
          }
      }
    })

  }
});
});


function inTooCartAction(goodsId, goodsName, isRefesh, parentId,suite_id) {
    var goods = new Object();
    var spec_arr = new Array();
    var fittings_arr = new Array();
    var select = "";
    var p = parentId == "" ? false: true;
    var number = 1;
    var refresh = 0;
    if (isRefesh) {
        refresh = 1;
    }
    goods = '{"spec": "","select": "' + select + '", "goods_id":"' + goodsId + '", "number": "' + number + '","parent": "0","suite_id":"'+suite_id+'"}';
    $.ajax({
        type: "POST",
        url: "/shopping/check?step=add_to_cart4suite",
        data: "goods=" + goods,
        success: GoodsInsertToCartResponse,
        complete: function(XMLHttpRequest, status) {
            result = eval("(" + XMLHttpRequest.responseText + ")");
            if (!result.error) {
                if (refresh == 1) {
                    //windowMessage(goodsName)
                    //location.reload()
                    //$(".pop_inf").text(goodsName);
					$('#cat_pop').fadeIn();	
                } else {
                    //windowMessage(goodsName)
                    window.location="/shopping/cart";
                }
            } else {
                if (result.error == 2) {
                    if (confirm(result.message)) {
                        location.href = "user.php?act=add_booking&id=" + result.goods_id
                    }
                } else {
                    if (result.error == 6) {
                        if (confirm(result.message)) {
                            location.href = "goods.php?id=" + result.goods_id
                        }
                    } else {
                        alert(result.message)
                    }
                }
            }
        }
    })
}

function choseinxChangeAction(A) {
  if (A)
  {
    document.location.href = "choseinx.php?id=" + A;
  }
}
