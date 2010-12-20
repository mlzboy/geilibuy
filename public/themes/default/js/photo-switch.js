$(document).ready(function(){
$.fn.switchboxaction = function(options) {

var defaults = {
	Time:3000,
	switchindex:'',
	onclass:'',
	SwitchTime:300,
	AutoStart:true,
	HoverAfter:false,
	SwitchMode:'Click',
	SwitchEffect:'fadeOut',
	SwitchBox:'li'
	};
var opts=$.extend(defaults,options);
var $this=$(this);
var this_bar=opts.switchindex;
var this_on=opts.onclass;
var slider=new Array();
if($this.length>0){
	$.each($this,function(){
	init(this);	
	onbar(this,this_bar);
	
	if(!opts.AutoStart)
	{Slide(this,0,this_bar);
	StopSlider(this);
	}
	if(opts.AutoStart) StartSlider(this,1,this_bar);
	onbox(this,this_bar);
	});
} 

function onbar(obj,obj_bar){	
	if(opts.SwitchMode=='Click')
	{
		$(obj_bar).find('li').click(function(){
			var ix = $(obj_bar).find('li').index($(this));			
			Slide(obj,ix,obj_bar);			
			$(this).addClass(this_on).siblings().removeClass(this_on);		
			if(opts.HoverAfter) StopSlider(obj);
		});
	}
	else if(opts.SwitchMode=='Hover')
	{
		$(obj_bar).find('li').hover(function(){											 
			
			var ix = $(obj_bar).find('li').index($(this));			
			Slide(obj,ix,obj_bar);				
			$(this).addClass(this_on).siblings().removeClass(this_on);		
			StopSlider(obj);
		}, function(){	
			var k= $(obj_bar).find('li').index($(this));			
			StartSlider(obj,k+1,obj_bar);
			if(opts.HoverAfter) StopSlider(obj);
		});
	}

} 


function onbox(obj,obj_bar){
	
	$(obj).children().hover(function(){
		StopSlider(obj);
	}, function(){
		
		var i= $(obj).find('.switch_item').index( $(obj).find('.current-li'));
		StartSlider(obj,i+1,obj_bar);
		if(opts.HoverAfter) StopSlider(obj);
	});
} 
function init(obj){	
	var listArr = $(obj).find('.switch_item');
	listArr.hide();
	listArr.eq(0).show();	
} 
function Slide(obj,index,obj_bar){
	
	StopSlider(obj);	
	var listArr = $(obj).find('.switch_item');
	var count=listArr.length;
	if(index > count-1) index = 0;	
	var prev= index - 1 == -1 ? count-1 : index - 1 ;
	var next= index + 1 < count ? index + 1 : 0;
	
	if(index < 0) index = 0;
	if(next <0 ) next = 0 ;	
	
	listArr.hide();
    
	switch( opts.SwitchEffect){
	case 'fadeOut':
	listArr.eq(index).fadeIn(300,function(){listArr.eq(prev).fadeOut(200);	});
	break;
	case 'fadeIn':	
	listArr.eq(prev).fadeIn(300,function(){listArr.eq(index).fadeOut(300);});
	break;
	case 'slideUp':
	listArr.eq(prev).css({'z-index':'999999'});
	listArr.eq(index).css({'z-index':'999998'});	
	listArr.eq(prev).show();
	break;
	case 'slideDown':
	listArr.eq(prev).css({'z-index':'999999'});
	listArr.eq(index).css({'z-index':'999998'});	
	listArr.eq(prev).show();
	listArr.eq(index).fadeIn('slow',function(){listArr.eq(prev).slideDown('slow');});	
	break;
	case 'animateTop':
	listArr.eq(prev).css({'z-index':'999999'});
	listArr.eq(index).css({'z-index':'999998'});
	listArr.eq(index).fadeIn('slow',function(){
	listArr.eq(prev).animate({marginTop:'-323px',opacity: 'show'},'slow');		
	});	
	listArr.eq(prev).css({'margin-top':'0px'});
	listArr.eq(index).css({'margin-top':'0px'});
	break;	
	case 'animateLeft':	
	listArr.eq(prev).css({'z-index':'999999'});
	listArr.eq(index).css({'z-index':'999998'});
	listArr.eq(prev).css({'margin-left':'-520px'});
	listArr.eq(index).css({'margin-left':'820px'});
	listArr.eq(index).animate({marginLeft:'0px',opacity: 'show'},function(){
	listArr.eq(prev).animate({marginLeft:'-520px',opacity: 'show'},'fast');	});	
	listArr.eq(prev).css({'margin-left':'0px'});
	listArr.eq(index).css({'margin-left':'0px'});
	break;
	case 'none':
	listArr.eq(index).hide();
	listArr.eq(next).show();
	break;
	default:
	listArr.eq(prev).fadeOut(opts.SwitchTime,function(){listArr.eq(index).fadeIn('slow');	});
	break;
	}
	$(obj).find('.switch_item').removeClass('current-li');
	$(obj).find('.switch_item').eq(index).addClass('current-li');
	$(obj_bar).find('li').eq(index).addClass(this_on).siblings().removeClass(this_on);			

++index;
index = index > count-1  ? 0 : index;
StartSlider(obj,index,obj_bar);
}
function StartSlider(obj,index,obj_bar){	
var st =setTimeout(function(){Slide(obj,index,obj_bar);},opts.Time);
var i= $this.index(obj);
slider[i]=st;
} 
function StopSlider(obj){
var i= $this.index(obj);
clearTimeout(slider[i]);
slider[i]=0;
}
}
});