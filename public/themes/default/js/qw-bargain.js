function bargainResponse(result)
{

    result = eval('('+result+')');
    bargainWindowMessage(result,result.error);
}

/*讨价还价弹窗提示*/
function bargainWindowMessage(G,N) {
    if (N == 0){
        var MSG;
        if(G.content['type'] == 1){
            $("#bargain_info1").html(G.content['message']);
			$("#bargain_info2").html("优惠券将在订单发货之后充入您的账户");
        }else if(G.content['type'] == 3){
            $("#bargain_info1").html(G.content['message']);
			$("#bargain_info2").html("抽奖幸运点将在订单发货之后充入您的账户");
        }else{
            $("#bargain_info1").html(G.content['message']);
			$("#bargain_info2").html("");
        }            
    }else if (N == 1){
         $("#bargain_info1").html(G.content);
    }
	$("#bargain_btn").show();
}

/*璁ㄤ环杩樹环绛夊緟寮圭獥鎻愮ず*/
function bargainWindowMessageWait(G,P,N) {
    
    $("#bargain_info1").html("正在和老板商讨中。。。");
	$("#bargain_info2").html("");
	$("#bargain_btn").hide();
	popdiv("#pianyi_pop","369","auto",0.4);
    if (N == 1) {
        $.ajax({
            type: "POST",
            url: "flow.php?step=bargain",
            cache: false,
            data: 'amount=' + G + "&sid="+P+"&m="+ Math.random(),
            success:function(result){
                bargainResponse(result);
                }
        });
    }
   
}
