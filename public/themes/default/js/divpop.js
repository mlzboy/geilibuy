function popdiv(popdiv,width,height,alpha){
	
	var A = window.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop || 0; 
	var D = 0;
	D = Math.min(document.body.clientHeight, document.documentElement.clientHeight);
	if (D == 0) {
	D = Math.max(document.body.clientHeight, document.documentElement.clientHeight)
	} 
	var topheight = (A + (D - 300) / 2)-50 + "px"; 	
	//$("#popbg").css({height:$(document).height(),filter:"alpha(opacity="+alpha+")",opacity:alpha})
	//$("#popbg").fadeIn();
	$(popdiv).removeClass();
	$(popdiv).attr("class","pop_out ");
	$(popdiv).css({left:(($(document).width())/2-(parseInt(width)/2))+"px",top:topheight});
	$(popdiv).fadeIn();
}