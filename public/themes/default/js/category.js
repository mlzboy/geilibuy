$(document).ready(function(){
<!-- {if $static_div eq 1} -->
//get_histor();
<!-- {/if} -->
$(".goods_pic").find("img").lazyload({ effect : "fadeIn",placeholder : "/themes/default/imgs/global/grey.gif"});
})

/*
*调用历史浏览商品
*/
function get_histor()
{
  $.ajax({
    type: "GET",
    url: "goods.php",
    data: "act=get_history" + "&m=" + Math.random(),
    success: function(msg)
    {
      var re = eval("(" + msg + ")");
      if (re.err_msg == "0")
      {
        $("#history_div").show();
		$("#history_box")[0].innerHTML = re.result;
      }
      
    }
  })
}


/* 列表页的价格区间提交 */
function priceSearchAicon(type) {
    var A = $("#searchPriceMin")[0].value;
    var B = $("#searchPriceMax")[0].value;
    if(type == 1){
       if(!Tools.isNumber(A))
       {
            $("#searchPriceMin")[0].value = '';
            return false;
       }
    }else if(type == 2){
      if(!Tools.isNumber(B))
       {
          $("#searchPriceMax")[0].value = '';
            return false;
       }
    }else{
      $("#page_list_page")[0].value = 1;
      $("#page_list_price_code")[0].value = Number(-1);
      $("#page_list_price_min")[0].value = A;
      $("#page_list_price_max")[0].value = B;
      $("#page_list_sort_form").submit()
    }
   
}