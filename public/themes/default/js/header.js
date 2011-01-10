/*通用头部[用户中心]hover*/
$(document).ready(function(){
    
    //用户中心弹出层事件
    $('#mypop').hover(function(){											  
    	
    	$('#my_pop').show();	
    											  
    	}, function(){											  
    	$('#my_pop').hide(); 
    	});
    
    //购物车弹出层事件
    $('.nav_cart').hover(function(){											  
    	
	
    	$('.cart_pop').show();	
    											  
    	}, function(){											  
    	$('.cart_pop').hide(); 
    	});
    
    //导航栏弹出层事件

$('.sobox,#main,#head,#global_body,#nav_cartbox,.index_a').hover(function(){											  
	$('.nav_pop').hide();
	$('.nav_a').removeClass('on');	
	}, function(){
	});

    
    //回到顶部按钮操作事件 
     var show_delay;
    var scroll_div_left=parseInt((document.body.offsetWidth-956)/2)+960;	
    $(".scroll_div").click(function (){ 	
    	document.documentElement.scrollTop=0;
    });		
    $(window).resize(function (){ 
    	scroll_div_left=parseInt((document.body.offsetWidth-956)/2)+960;
    	$(".scroll_div").css("left",scroll_div_left);
    });						   
    reshow(scroll_div_left,show_delay);
});

/* 导航搜索框 */
function checkSearchFormAction() {
	var val=$("#so_txt").val();
    if ($.trim(val) == '') {
        return false;
    } else {
	window.location="/search?keyword="+$.trim(val);
        return false;
    }
}
function search_kwords(str)
{
   $("#so_txt").val(str);
   var searchForm = $('#searchForm');
   searchForm.submit();
}

/* 导航查看购物车 */
function setHeadFlowNum() {
    $.ajax({
        type: "POST",
        url: "/shopping/check?step=ajaxcartnum",
        data: "step=ajaxcartnum",
        success: function(A) {
            var re = eval("(" + A + ")");
            $("#ECS_CARTINFO").html(re.num);
            $(".cart_pop").html(re.content);
        }
    })
}

/* 导航删除购物车中的商品 */
function dropHeadFlowNum(A,B) {
if (confirm(B)){
    $.ajax({
        type: "GET",
        url: "/shopping/check?step=drop_goods",
        data: "id=" + A,
        success: function(result) {
            setHeadFlowNum();
        }
    });
}
}
/* 导航删除购物车中的商品 */
function dropHeadFlowNum_distinguish_score(A,B) {
if (confirm(B)){
    $.ajax({
        type: "GET",
        url: "/shopping/check?step=drop_goods_distinguish_score",
        data: "id=" + A,
        success: function(result) {
            setHeadFlowNum();
        }
    });
}
}
/* 导航删除购物车中的商品 */
function dropHeadFlowNum4suite(A,B) {
if (confirm(B)){
    $.ajax({
        type: "GET",
        url: "/shopping/check?step=drop_goods4suite",
        data: "id=" + A,
        success: function(result) {
            setHeadFlowNum();
        }
    });
}
}

/* 收藏本站 */
function myAddBookmark(B, A) {
    if ((typeof window.sidebar == "object") && (typeof window.sidebar.addPanel == "function")) {
        window.sidebar.addPanel(B, A, "")
    } else {
        window.external.AddFavorite(A, B)
    }
}
/* ajax检测用户登录状态 */
function setHeadUserStatus2(back_url) {

    $.ajax({
        type: "POST",
        url: "/usercenter/check?act=check_login",
        data: "act=check_login",
        success: function(A) {
            var re = eval("(" + A + ")");
            var U = $("#head_right").find('ul');
            if(re.error == 1){
                U[1].style.display = 'block';
                U[2].style.display = 'none';
                $("#head_right").find('ul').eq(1).find('#nickname').html(re.content['nickname']);//显示用户名
                if(!re.content['have_msg']){
                $("#head_right").find('ul').eq(1).find('#msg_a').css({'display':"none"});//显示提示图标
                }
            }else{
                $("#login").html('<a href="/usercenter/login?back_url='+back_url+'">登录</a>');//显示登录
                 $("#register").html('<a href="/usercenter/register?'+Math.round(Math.random()*(100000-1))+'">注册</a>');//显示注册
                U[0].style.display = 'block';
                U[2].style.display = 'none';
            }
        }
    })
}
/* ajax检测用户登录状态 */
function setHeadUserStatus() {

    $.ajax({
        type: "POST",
        url: "/usercenter/check?act=check_login",
        data: "act=check_login",
        success: function(A) {
            var re = eval("(" + A + ")");
            var U = $("#head_right").find('ul');
            if(re.error == 1){
                U[1].style.display = 'block';
                U[2].style.display = 'none';
                $("#head_right").find('ul').eq(1).find('#nickname').html(re.content['nickname']);//显示用户名
                if(!re.content['have_msg']){
                $("#head_right").find('ul').eq(1).find('#msg_a').css({'display':"none"});//显示提示图标
                }
            }else{
                $("#login").html('<a href="/usercenter/login?'+Math.round(Math.random()*(100000-1))+'">登录</a>');//显示登录
                 $("#register").html('<a href="/usercenter/register?'+Math.round(Math.random()*(100000-1))+'">注册</a>');//显示注册
                U[0].style.display = 'block';
                U[2].style.display = 'none';
            }
        }
    })
}
/* 回到页面顶部按钮显示 */
function reshow(marign_l,show_d) {
$(".scroll_div").css("left",marign_l);
if(document.documentElement.scrollTop!=0)	
	{
	$(".scroll_div").css("display","block");
	} 	
	else
	{
	$(".scroll_div").css("display","none");  }
	if(show_d) window.clearTimeout(show_d) ;
	show_d=setTimeout("reshow()",500);
}