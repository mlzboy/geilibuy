
/******************************************************************/
function updatecart(id,rec_id,obj){
  var forenum = obj.attributes['objNum'].value;
  var num = obj.value||forenum;
  if(isNaN(num)){alert('数字格式输入有误，请重新输入。');obj.focus();obj.select();obj.style.background = "red";return;}
  var singletotal = 'title_singletotal_' + id;
  if(forenum == num || num == '0'){obj.value = forenum;return;};
  obj.style.background = "white";
  $.ajax({
     type: "POST",
     url: "interface/flow_update_cart.php",
     data: 'goods_id=' + id + '&goods_number=' + num + '&step=sum_price&rec_id=' + rec_id + "&m=" + Math.random(),
     success:function(msg){
      var ResponseText = msg.split('_');
      if(ResponseText[0] == '00'){
        window.location.reload();
      }
      else if (ResponseText[0]=='-2')
      {
        alert('数字格式输入有误，请重新输入。');
        obj.style.background = "white";
        obj.focus();obj.select();
      }
      // 20101105E 孟伟 【限购活动】需求文档   add by tylergong 2010-11-08
	  else if (ResponseText[0]=='-3')
	  {
		alert('限购商品，每次限购 '+ResponseText[1]+' 件，给别人留点吧。');
		obj.style.background = "white";
		obj.value = forenum;
		obj.focus();obj.select();
	  }
      else{
        alert('数量超出库存，请重新填写。');
        obj.style.background = "white";
        obj.value = forenum;
        obj.focus();obj.select();
      }

     }
  });

}

     
     






/******************region.js*******************************/

var region = new Object();

region.isAdmin = false;

region.loadRegions = function(parent, type, target)
{
$.ajax({
     type: "GET",
     url: region.getFileName(),
     data: 'type=' + type + '&target=' + target + '&parent='+parent + "&m=" + Math.random(),
     success:region.response
  });
}

/* *
 * 载入指定的国家下所有的省份
 *
 * @country integer     国家的编号
 * @selName string      列表框的名称
 */
region.loadProvinces = function(country, selName)
{
  var objName = (typeof selName == "undefined") ? "selProvinces" : selName;

  region.loadRegions(country, 1, objName);
}

/* *
 * 载入指定的省份下所有的城市
 *
 * @province    integer 省份的编号
 * @selName     string  列表框的名称
 */
region.loadCities = function(province, selName)
{
  var objName = (typeof selName == "undefined") ? "selCities" : selName;

  region.loadRegions(province, 2, objName);
}

/* *
 * 载入指定的城市下的区 / 县
 *
 * @city    integer     城市的编号
 * @selName string      列表框的名称
 */
region.loadDistricts = function(city, selName)
{
  var objName = (typeof selName == "undefined") ? "selDistricts" : selName;

  region.loadRegions(city, 3, objName);
}

/* *
 * 处理下拉列表改变的函数
 *
 * @obj     object  下拉列表
 * @type    integer 类型
 * @selName string  目标列表框的名称
 */
region.changed = function(obj, type, selName)
{
  var parent = obj.options[obj.selectedIndex].value;

  region.loadRegions(parent, type, selName);
}

region.response = function(result, text_result)
{
  result = $.evalJSON(result);
  var sel = document.getElementById(result.target);
  sel.length = 1;
  sel.selectedIndex = 0;
  sel.style.display = (result.regions.length == 0 && ! region.isAdmin && result.type + 0 == 3) ? "none" : '';

  if (document.all)
  {
    sel.fireEvent("onchange");
  }
  else
  {
    var evt = document.createEvent("HTMLEvents");
    evt.initEvent('change', true, true);
    sel.dispatchEvent(evt);
  }

  if (result.regions)
  {
    for (i = 0; i < result.regions.length; i ++ )
    {
      var opt = document.createElement("OPTION");
      opt.value = result.regions[i].region_id;
      opt.text  = result.regions[i].region_name;

      sel.options.add(opt);
    }
  }
}

region.getFileName = function()
{
  if (region.isAdmin)
  {
    return "../region.php";
  }
  else
  {
    return "region.php";
  }
}
/**********************Tools**********************************/
/* *
 * 检查收货地址信息表单中填写的内容
 */
var consignee_not_null = "收货人姓名不能为空！";
var country_not_null = "请您选择收货人所在国家！";
var province_not_null = "请您选择收货人所在省份！";
var city_not_null = "请您选择收货人所在城市！";
var district_not_null = "请您选择收货人所在区域！";
var invalid_email = "您输入的邮件地址不是一个合法的邮件地址。";
var address_not_null = "详细地址不能为空！";
var tele_not_null = "电话不能为空！";
var shipping_not_null = "请您选择配送方式！";
var payment_not_null = "请您选择支付方式！";
var goodsattr_style = "1";
var tele_invaild = "电话号码不有效的号码";
var zip_not_num = "邮政编码只能填写数字";
var zip_not_null = "邮政编码不能为空";
var mobile_invaild = "手机号码不是合法号码";
var tele_both_null = "电话和手机号至少填写一项！";
var moblie_isbind = "必须验证手机才能领奖";

function checkConsignee(frm,msgBoxAlert,defaultEmail,isLottery)
{
  var msg = new Array();
  var err = false;

  if ( !isEmail(frm.elements['email'].value))
  {
  if($(".email_table_notice")){
    //$(".email_table_notice").text(invalid_email).css({"color":"#cc3333"});return false;
  }else{
      alert(invalid_email);return false;
  }
  }else{
    if($(".email_table_notice")){
      $(".email_table_notice").text('');
    }
  }

  if($(".email_table_notice")){
    if (!isEmail(frm.elements['email'].value) && frm.elements['email'].value != ''){
          $(".email_table_notice").text(invalid_email).css({"color":"#cc3333"});return false;
    }
  }

  if (frm.elements['consignee'].value == '')
  {
    $(".consignee_table_notice").text(consignee_not_null);return false;
  }else{
     $(".consignee_table_notice").text('');
  }

  if (frm.elements['country'] && frm.elements['country'].value == 0)
  {
  $(".country_table_notice").text(country_not_null);return false;
  }else{
   $(".country_table_notice").text('');
  }

  if (frm.elements['province'] && frm.elements['province'].value == 0 && frm.elements['province'].length > 1)
  {
  $(".country_table_notice").text(province_not_null);return false;
  }else{
    $(".country_table_notice").text('');
  }

  if (frm.elements['city'] && frm.elements['city'].value == 0 && frm.elements['city'].length > 1)
  {
  $(".country_table_notice").text(city_not_null);return false;
  }else{
    $(".country_table_notice").text('');
  }

  if (frm.elements['district'] && frm.elements['district'].length > 1)
  {
    if (frm.elements['district'].value == 0)
    {
    $(".country_table_notice").text(district_not_null);return false;
    }else{
      $(".country_table_notice").text('');
  }
  }

  if (frm.elements['address'] && frm.elements['address'].value == '')
  {
    $(".address_table_notice").text(address_not_null);return false;
  }else{
    $(".address_table_notice").text('');
  }

  if (frm.elements['zipcode'] && frm.elements['zipcode'].value == '')
  {
    if(isLottery){
      //$(".zipcode_table_notice").text(zip_not_null);return false;
    }
  } else if (frm.elements['zipcode'] && frm.elements['zipcode'].value.length > 0 && (!Tools.isNumber(frm.elements['zipcode'].value)))
  {
    $(".zipcode_table_notice").text(zip_not_num);return false;
  }else{
     $(".zipcode_table_notice").text('');
  }


  if(Tools.isEmpty(frm.elements['tel'].value) && Tools.isEmpty(frm.elements['mobile'].value)){
     if(isLottery){
      document.getElementById('tip_mobile').style.display = "none";
     }
        $(".tel_table_notice").text(tele_both_null);return false;
  }else{
      if(!Tools.isEmpty(frm.elements['tel'].value))
      if (Tools.isEmpty(frm.elements['tel'].value))
    {
        $(".tel_table_notice").text(tele_not_null);return false;
    }
    else
    {
    if (!Tools.isTel(frm.elements['tel'].value))
    {
        $(".tel_table_notice").text(tele_invaild);return false;
    }
    }
      if(!Tools.isEmpty(frm.elements['mobile'].value))
    if (frm.elements['mobile'] && frm.elements['mobile'].value.length > 0 && (!Tools.isTel(frm.elements['mobile'].value)))
    {
         if(isLottery){
      document.getElementById('tip_mobile').style.display = "none";
     }
     $(".tel_table_notice").text(mobile_invaild);return false;
    }
  }
  $(".tel_table_notice").text('');


  if($(".email_table_notice") && defaultEmail){
     if(frm.elements['email'].value.replace(/[ ]/g,"") == ''){
      //frm.elements['email'].value = 'guestorder@geilibuy.com';
   }
  }

  if(msgBoxAlert)alert("地址修改已保存");
  if(isLottery){
  // add by tlergong 2010-05-19  领奖必须是通过验证的手机
  if(frm.elements['moblie_bind'].value == ''){
    document.getElementById('tip_mobile').style.display = "none";
    $(".tel_table_notice").text(moblie_isbind);
    return false;
  }
  
    $('#submitAddress')[0].disabled = true;
  }
  return true;
}
/***************************************************/

/* $Id : shopping_flow.js 4865 2007-01-31 14:04:10Z paulgao $ */

var selectedShipping = null;
var selectedPayment  = null;
var selectedPack     = null;
var selectedCard     = null;
var selectedSurplus  = '';
var selectedBonus    = 0;
var selectedIntegral = 0;
var selectedOOS      = null;
var alertedSurplus   = false;

var groupBuyShipping = null;
var groupBuyPayment  = null;

/* *
 * 改变配送方式
 */
function selectShipping(obj,boundstep)
{
  $('#payment_edit_btn').click()
  if (selectedShipping == obj)
  {
    return;
  }
  else
  {
    selectedShipping = obj;
  }

  var supportCod = parseInt(obj.attributes['supportCod'].value) + 0;
  var v = obj.value;var s = '';

  $(".shipping_radio_input").each(function(){
   $(this)[0].disabled = false;
  });

  $('#reset_shipping_name').text($('#shipping_name_' + v).text());
  $(".sradio").each(function(){
    if(v == '15'){
      if($(this)[0].value == '1'){
        $(this).click();
        $(this)[0].checked = true;
        $(this)[0].disabled = false;
      }else{
        $(this)[0].checked = false;
        $(this)[0].disabled = true;
      }
    }else{
      if($(this)[0].value == '1'){
        $(this)[0].checked = false;
        $(this)[0].disabled = true;
      }else{
         $(this)[0].disabled = false;
      }
    }
    if($(this)[0].checked) s = $(this)[0].value;
  });

  var theForm = obj.form;

  if (obj.attributes['insure'].value + 0 == 0)
  {
    document.getElementById('ECS_NEEDINSURE').checked = false;
    document.getElementById('ECS_NEEDINSURE').disabled = true;
  }
  else
  {
    document.getElementById('ECS_NEEDINSURE').checked = false;
    document.getElementById('ECS_NEEDINSURE').disabled = false;
  }
  var now = new Date();

    $.ajax({
     type: "GET",
     url: "flow.php?step=select_shipping",
     cache: false,
     data: 'shipping=' + obj.value + "&m=" + Math.random(),
     success:function(result){
        result = $.evalJSON(result);
        if (result.need_insure)
        {
        try
        {
          document.getElementById('ECS_NEEDINSURE').checked = true;
        }
        catch (ex)
        {
          alert(ex.message);
        }
        }

        try
        {
        if (document.getElementById('yunfei') != undefined)
        {
//          //document.getElementById('ECS_CODFEE').innerHTML = result.cod_fee;
//          document.getElementById('yunfei').innerHTML = result.new_info.yunfei;

                                  refresh_checkout(result.new_info);
        }
        }
        catch (ex)
        {
        alert(ex.message);
        }

       $(".shipping_radio").each(function(){
           if($(this).attr('obidXml') == v){
               $(this).css("background","#e7efca");
           }else{
              $(this).css("background","white");
           }
        });

       $(".payment_radio").each(function(){
           if($(this).attr('obidXml') == s){
               $(this).css("background","#e7efca");
             $(this).find('img').each(function(){
                $(this)[0].src = $(this).attr('onXml');
             });
           }else{
              $(this).css("background","white");
             $(this).find('img').each(function(){
                $(this)[0].src = $(this).attr('xml');
             });
           }
        });

        orderSelectedResponse(result);
        if(boundstep)stepBonus();
     }
  });
}


/**
 *
 */
function orderShippingSelectedResponse(result)
{
  result = $.evalJSON(result);
  if (result.need_insure)
  {
    try
    {
      document.getElementById('ECS_NEEDINSURE').checked = true;
    }
    catch (ex)
    {
      alert(ex.message);
    }
  }

  try
  {
    if (document.getElementById('ECS_CODFEE') != undefined)
    {
      document.getElementById('ECS_CODFEE').innerHTML = result.cod_fee;
    }
  }
  catch (ex)
  {
    alert(ex.message);
  }

  orderSelectedResponse(result);
}

function checkOutShipping(pid){
    $("#click_"+pid).click();
    $(".shipping_radio_input").each(function(){
        $(this)[0].disabled = false;
      });
}

/* *
 * 改变支付方式
 */
function selectPayment(obj,flage,boundstep)
{
  if (selectedPayment == obj)
  {
    return;
  }
  else
  {
    selectedPayment = obj;
  }

  var v = obj.value;var s = '';

  $('#transway_edit_btn').click()

  $(".shipping_radio_input").each(function(){
     if(v == '1'){
      if($(this)[0].value == '15'){
        $(this)[0].checked = true;
        $(this)[0].disabled = false;
        $(this).click();
        checkOutShipping('15');
      }else{
        $(this)[0].checked = false;
        $(this)[0].disabled = true;
      }
     }else{
      if($(this)[0].value == '15'){
        $(this)[0].checked = false;
        $(this)[0].disabled = true;
      }else{
        $(this)[0].disabled = false;
      }
     }
     if (v == '8')
     {
      $('#wht1').show();
      $('#wht2').show();
     }
     else
    {
      $('#wht1').hide();
      $('#wht2').hide();
    }
     if($(this)[0].checked)s = $(this)[0].value;
  });

  $(".sradio").each(function(){
   $(this)[0].disabled = false;
  });

  if(v == '1'){
  $(".shipping_radio_input").each(function(){

      if($(this)[0].value == '15'){
        $(this)[0].checked = true;
        $(this)[0].disabled = false;
      }else{
        $(this)[0].checked = false;
        $(this)[0].disabled = true;
      }

  });
}
    $.ajax({
     type: "GET",
     url: "flow.php?step=select_payment",
     cache: false,
     data: 'payment=' + obj.value + "&m=" + Math.random(),
     success:function (result){
           result = $.evalJSON(result);
         if (result.error)
      {
      alert(result.error);
      location.href = './';
      }

      try
      {
      var layer = document.getElementById("ECS_ORDERTOTAL");

      layer.innerHTML = (typeof result == "object") ? result.content : result;

      if (result.payment != undefined)
      {
        var surplusObj = document.forms['theForm'].elements['surplus'];
        if (surplusObj != undefined)
        {
        surplusObj.disabled = result.pay_code == 'balance';
        }
      }

       $(".payment_radio").each(function(){
           if($(this).attr('obidXml') == v){
               $(this).css("background","#e7efca");
             $(this).find('img').each(function(){
                $(this)[0].src = $(this).attr('onXml');
             });
           }else{
              $(this).css("background","white");
             $(this).find('img').each(function(){
                $(this)[0].src = $(this).attr('xml');
             });
           }
        });

        $(".shipping_radio").each(function(){
           if($(this).attr('obidXml') == s){
               $(this).css("background","#e7efca");
           }else{
              $(this).css("background","white");
           }
        });
        if(boundstep)stepBonus();
      }
      catch (ex) { }
      refresh_checkout(result.new_info);
     }
  });
}

function changeVoucherAction(obj){
  if(obj=='1')
  {
    $("#ineed_inv").show();  
  }else
  {
    $("#ineed_inv").hide();  
  }
}

function checkVipCardAction(){
   if($('#vip_card')[0].value==''){
      alert('请输入打折卡密码!');
    return;
   }
   var message = new Array('','请先登录!','已经是特殊用户！','更新红包失败!','更新打折卡失败!','更新用户失败!','该密码对应打折卡已被其他用户绑定，请检查。','打折卡密码不正确，请检查。','打折卡密码非法!','非法验证！');
   $.ajax({
     type: "GET",
     url: "user.php",
     data: 'act=validate_vip&card=' + $('#vip_card')[0].value +"&vip=" + $('#vip_hash')[0].value + "&m=" + Math.random(),
     success:function (response){
         var index = isNaN(parseInt(response))? 0 : parseInt(response);
      if(index){
         alert(message[index]);
         $('#vip_card').focus();
         $('#vip_card').select();
         if(index == 1){
             window.location = "user.php?act=login";
         }
      }else{
         alert(response);
         window.location.reload();
      }
     }
   });
}

/* *
 * 选定了配送保价
 */
function selectInsure(needInsure)
{
  needInsure = needInsure ? 1 : 0;

  Ajax.call('flow.php?step=select_insure', 'insure=' + needInsure, orderSelectedResponse, 'GET', 'JSON');
}

/* *
 * 回调函数
 */
function orderSelectedResponse(result)
{
  var obj = {};
  obj = eval("'"+result+"'");
  if (result.error)
  {
    alert(result.error);
    location.href = './';
  }

  try
  {
    var layer = document.getElementById("ECS_ORDERTOTAL");

    layer.innerHTML = (typeof result == "object") ? result.content : result;

    if (result.payment != undefined)
    {
      var surplusObj = document.forms['theForm'].elements['surplus'];
      if (surplusObj != undefined)
      {
        surplusObj.disabled = result.pay_code == 'balance';
      }
    }
  }
  catch (ex) { }
}

/* *
 * 改变余额
 */
function changeSurplus(val)
{
  if (selectedSurplus == val)
  {
    return;
  }
  else
  {
    selectedSurplus = val;
  }

  Ajax.call('flow.php?step=change_surplus', 'surplus=' + val, changeSurplusResponse, 'GET', 'JSON');
}

/* *
 * 改变余额回调函数
 */
function changeSurplusResponse(obj)
{
  if (obj.error)
  {
    try
    {
      document.getElementById("ECS_SURPLUS_NOTICE").innerHTML = obj.error;
      document.getElementById('ECS_SURPLUS').value = '0';
      document.getElementById('ECS_SURPLUS').focus();
    }
    catch (ex) { }
  }
  else
  {
    try
    {
      document.getElementById("ECS_SURPLUS_NOTICE").innerHTML = '';
    }
    catch (ex) { }
    orderSelectedResponse(obj.content);
  }
}

/* *
 * 改变积分
 */
function changeIntegral(val)
{
  if (selectedIntegral == val)
  {
    return;
  }
  else
  {
    selectedIntegral = val;
  }

  Ajax.call('flow.php?step=change_integral', 'points=' + val, changeIntegralResponse, 'GET', 'JSON');
}

/* *
 * 改变积分回调函数
 */
function changeIntegralResponse(obj)
{
  if (obj.error)
  {
    try
    {
      document.getElementById('ECS_INTEGRAL_NOTICE').innerHTML = obj.error;
      document.getElementById('ECS_INTEGRAL').value = '0';
      document.getElementById('ECS_INTEGRAL').focus();
    }
    catch (ex) { }
  }
  else
  {
    try
    {
      document.getElementById('ECS_INTEGRAL_NOTICE').innerHTML = '';
    }
    catch (ex) { }
    orderSelectedResponse(obj.content);
  }
}

/* *
 * 是否选择用户账户支付
 */
function changeMoneyAccount(val)
{
	$.ajax({
		   type:"GET",
		   url:"flow.php?step=change_moneyaccount",
		   cache:false,
		   data:'is_select=' + val + "&m=" + Math.random(),
		   success:function(response){
				obj = $.evalJSON(response);
				if (obj.error){
					alert(obj.error);
					$('#ECS_BONUS')[0].value = '0';
				}
				else
				{
					var result = obj;
					$('#availablemoney').text(result.new_info['moneypay']);
					$('#accountmoney').text(result.new_info['usemoney']);
					refresh_checkout(result.new_info);
				}
		   }
	});
}





/* *
 * 改变红包
 */
function changeBonus(val,type)
{
  $("#total_card_notice").hide();
   selectedBonus = val;
  $.ajax({
     type: "GET",
     url: "flow.php?step=change_bonus",
     cache: false,
     data: 'bonus=' + val + "&m=" + Math.random(),
     success:function (response){
      obj = $.evalJSON(response);
        if (obj.error){
        alert(obj.error);
        $('#ECS_BONUS')[0].value = '0';
        }
        else
        {
        var result = obj;
        if (result.error){
          alert(result.error);
          location.href = './';
          }else{
            if(!type){
                document.getElementById('total_card_notice').innerHTML = '';
            }
            
          document.cookie = "bonusSn=";
          refresh_checkout(result.new_info);
//          alert(result.new_info.yunfei);
//          $("#ECS_ORDERTOTAL").html(result.content);
          }
        }
     }
   });
}



/* *
 * 改变红包的回调函数
 */
function changeBonusResponse(obj)
{
  if (obj.error)
  {
    alert(obj.error);

    try
    {
      document.getElementById('ECS_BONUS').value = '0';
    }
    catch (ex) { }
  }
  else
  {
    orderSelectedResponse(obj.content);
  }
}

/**
 * 验证红包序列号
 * @param string bonusSn 红包序列号
 */
function stepBonus()
{
  var bonusSn = $.cookie("stepbounds");
  if(bonusSn){
       $.ajax({
         type: "GET",
         url: "flow_new.php?step=validate_bonus",
         data: 'bonus_sn=' + bonusSn + "&m=" + Math.random(),
         success:function(result){
          var __jsonData = eval('('+result+')') ;
          if(__jsonData.error == ''){
            orderSelectedResponse(__jsonData);
          }
         }
       });
  }
}

/**
 * 验证红包序列号
 * @param string bonusSn 红包序列号
 */
function validateBonus(bonusSn)
{
  if(bonusSn){
//       $.cookie("stepbounds",bonusSn);
       $.ajax({
         type: "GET",
         url: "flow_new.php?step=validate_bonus",
         data: 'bonus_sn=' + bonusSn + "&m=" + Math.random(),
         success:validateBonusResponse
       });
  }
}

function validateBonusResponse(result)
{
  var __jsonData = eval('('+result+')') ;
  if(__jsonData.error == ''){
    orderSelectedResponse(__jsonData);
      $("#total_card_notice").text(__jsonData.show);
      refresh_checkout(__jsonData.new_info);
  }else{
    $("#total_card_notice").text(__jsonData.error);
    refresh_checkout(__jsonData.new_info);
  }
}

function addBonus(bonusSn){
  if (bonusSn == '')
  {
    $("#total_card_notice").show();
    $("#total_card_notice").text('请输入优惠券！')
  }
    if(bonusSn){
      $.ajax({
         type: "POST",
         url: "user.php?act=ajax_act_add_bonus",
         data: 'bonus_sn=' + bonusSn + "&m=" + Math.random(),
         success:addBonusResponse
       });
  }
}

function addBonusResponse(result)
{
    document.getElementById('bonus_sn').value = '';
  var __jsonData = eval('('+result+')') ;
  var textdiv = $("#total_card_notice");
  if(__jsonData.show == 'true'){
     if(textdiv.length){
          textdiv.text(__jsonData.error);
          var bonusSelect=document.getElementById('ECS_BONUS');
            //添加一个OPTION选项
            if(navigator.appName.indexOf("Microsoft") != -1) {
                bonusSelect.add(new Option(__jsonData.txt,__jsonData.bounds,false,true));
      }else{
          bonusSelect.options.add(new Option(__jsonData.txt,__jsonData.bounds,false,true));
      }
      changeBonus(__jsonData.bounds,1);
     }else{
    alert(__jsonData.error);
     }
     //window.navigate(window.location.href + "&setbonus=" + __jsonData.bounds)
  }else{
     if(textdiv.length){
          textdiv.text(__jsonData.error);
     }else{
    alert(__jsonData.error);
     }
  }
   $("#total_card_notice").show();
}

/* *
 * 返回格式化价格 **.**
 */
function formatPrice(A){
    var B = String(A);
    if(B.indexOf('.') == -1){
        B = B+'.00';
    }else{
        var C =B.substring(B.indexOf('.')).length;
        if(C == 2)
        {
            B = B+'0';
        }
    }
    return B;

}

/********************************************************************
* 函数名:
* getCookie
*
* 参数:
* c_name  - Cookie名称
*
* 返回值:
* Cookie内容
*
* 说明:
********************************************************************/
function getCookie(name)
{
        var ck   = document.cookie;
        var exp1 = new RegExp(name + "=.*?(?=;|$)");
        var mch  = ck.match(exp1);
        return mch? mch[0].substring(name.length+1) : null;
}

function resetBonusAction(b){
  if(b){
     var f = $("#ECS_BONUS")[0];
     for(var i = 0 ; i < f.length ; i ++){
        if(f.options[i].value == b){
           f.options[i].selected=true;
           changeBonus(b);
         }
     }
   }
}
/* *
 * 改变发票的方式
 */
function changeNeedInv()
{
  var obj        = document.getElementById('ECS_NEEDINV');
  var objType    = document.getElementById('ECS_INVTYPE');
  var objPayee   = document.getElementById('ECS_INVPAYEE');
  var objContent = document.getElementById('ECS_INVCONTENT');
  var needInv    = obj.checked ? 1 : 0;
  var invType    = obj.checked ? (objType != undefined ? objType.value : '') : '';
  var invPayee   = obj.checked ? objPayee.value : '';
  var invContent = obj.checked ? objContent.value : '';
  objType.disabled = objPayee.disabled = objContent.disabled = ! obj.checked;
  if(objType != null)
  {
    objType.disabled = ! obj.checked;
  }

  if(needInv){
  $('ineed_inv').style.display = '';
  }else{
    $('ineed_inv').style.display = 'none';
  }
}

/* *
 * 改变发票的方式
 */
function groupBuyChangeNeedInv()
{
  var obj        = document.getElementById('ECS_NEEDINV');
  var objPayee   = document.getElementById('ECS_INVPAYEE');
  var objContent = document.getElementById('ECS_INVCONTENT');
  var needInv    = obj.checked ? 1 : 0;
  var invPayee   = obj.checked ? objPayee.value : '';
  var invContent = obj.checked ? objContent.value : '';
  objPayee.disabled = objContent.disabled = ! obj.checked;

  Ajax.call('group_buy.php?act=change_needinv', 'need_idv=' + needInv + '&amp;payee=' + invPayee + '&amp;content=' + invContent, null, 'GET');
}

/* *
 * 改变缺货处理时的处理方式
 */
function changeOOS(obj)
{
  if (selectedOOS == obj)
  {
    return;
  }
  else
  {
    selectedOOS = obj;
  }

  Ajax.call('flow.php?step=change_oos', 'oos=' + obj.value, null, 'GET');
}

// 关闭弹出层窗口 20101105E 孟伟 【限购活动】需求文档   add by tylergong 2010-11-08
$(".close").live("click", function(){
	$("#popbg").fadeOut();
	$(".pop_out").fadeOut();
	});	
	

// 20101105E 孟伟 【限购活动】需求文档   add by tylergong 2010-11-08  start	
function checkLimitBuy(frm)
{
  // 检查用户是否购买了限购商品。进行限购商品逻辑
  var limitbuy_tel = document.getElementById("limitbuy_tel").value;
  if (limitbuy_tel != '')
  {
	 $.ajax({
         type: "POST",
         url: "flow.php?step=check_limitbuy",
         data: "quwanid=" + $.cookie("quwanID") + "&limitbuytel=" + limitbuy_tel + "&m=" + Math.random(),
		 async: false,// 限制ajax调用等待结果才执行下个函数
         success:function(msg)
		 {
			 var ResponseText = msg.split('_');
			 if(ResponseText[0] < 0)
			 {
				 // 在对应区域提示用户错误信息
				$("#tel_pop").show();
				$("#limit_show").html(ResponseText[1]);
				
				 // 定位至描点
				var pos = $("#limit_top").offset().top;
    			$("html,body").animate({scrollTop: pos}, 10);
				error = 0;
			 }
			 else
			 {
				error = 1;
			 }
		 }
       });
  } 
	if(error == 0)
	{
		return false; //　错误 结束执行
	}
	else
	{
		 checkOrderForm(frm); //确认订单其他逻辑判断
	}
}
// 20101105E 孟伟 【限购活动】需求文档   add by tylergong 2010-11-08   end
	

/* *
 * 检查提交的订单表单
 */
function checkOrderForm(frm)
{
  var paymentSelected = false;
  var shippingSelected = false;
  var flow_no_payment = "您必须选定一个支付方式。";
  var flow_no_shipping = "您必须选定一个配送方式。";
 
 
 
  // 检查是否选择了支付配送方式
  for (i = 0; i < frm.elements.length; i ++ )
  {
    if (frm.elements[i].name == 'shipping' && frm.elements[i].checked)
    {
      shippingSelected = true;
    }

    if (frm.elements[i].name == 'payment' && frm.elements[i].checked)
    {
      paymentSelected = true;
    }
  }

  if ( ! shippingSelected)
  {
    alert(flow_no_shipping);
    return false;
  }

  if ( ! paymentSelected)
  {
    alert(flow_no_payment);
    return false;
  }
  

  // 检查用户输入的余额
  if (document.getElementById("ECS_SURPLUS"))
  {
    var surplus = document.getElementById("ECS_SURPLUS").value;
    var error   = Tools.trim(Ajax.call('flow.php?step=check_surplus', 'surplus=' + surplus, null, 'GET', 'TEXT', false));

    if (error)
    {
      try
      {
        document.getElementById("ECS_SURPLUS_NOTICE").innerHTML = error;
      }
      catch (ex)
      {
      }
      return false;
    }
  }

  // 检查用户输入的积分
  if (document.getElementById("ECS_INTEGRAL"))
  {
    var integral = document.getElementById("ECS_INTEGRAL").value;
    var error    = Tools.trim(Ajax.call('flow.php?step=check_integral', 'integral=' + integral, null, 'GET', 'TEXT', false));

    if (error)
    {
      return false;
      try
      {
        document.getElementById("ECS_INTEGRAL_NOTICE").innerHTML = error;
      }
      catch (ex)
      {
      }
    }
  }
  $('#submitOrder')[0].disabled = true;
  return true;
}

/**付款及配送选择**/
$(document).ready(function(){
 
  $(".packaging_c").click(function(){
    $(".free_" + $(this).attr('ttt')).toggle();
  })
});

/**支付图片**/
click_payment_pic = function (id)
{
  $('#' + id).click();
}
/**
*改变订单相关信息
*/
refresh_checkout = function(new_info)
{
  for( var key in new_info)
  {
	if(new_info['youhuiquanjianmian']){  
		if ('-0.00元' == new_info['youhuiquanjianmian'] || '' == new_info['youhuiquanjianmian']){
		  new_info['youhuiquanjianmian'] = '';
		  $("#change_bonus_discount").hide();
		}else{
		  $("#change_bonus_discount").show();
		}
	}else{
		$("#change_bonus_discount").hide();
	}
    
	if (new_info['bank_saving_money'])
    {
      $("#flow_info_orderlist_discount_line2").show();
      $("#bank_saving_info").html(new_info['bank_saving_money_info']);
    }
    else
    {
      $("#flow_info_orderlist_discount_line2").hide();
    }

//    if (new_info['orderlist_discount'])
//    {
//      $("#flow_info_orderlist_discount_line").show();
//    }
//    else
//    {
//      $("#flow_info_orderlist_discount_line").hide();
//    }
	
	if(new_info['moneypay']){
		$("#change_money_discount").show();	
		$('#availablemoney').text(new_info['moneypay']);
		$('#accountmoney').text(new_info['usemoney']);
		if(new_info['moneypay'] == '-0.00元' ||　'' == new_info['moneypay'])
		{
			 $("#change_money_discount").hide();
		}
	}else{
		$("#change_money_discount").hide();
	}
	if(!new_info['youhuiquanjianmian']){
        $("#ECS_BONUS").val('0');
	}
	
    $("#" + key).html(new_info[key]);
  }
}

function checkConsignee_newflow(i,msgBoxAlert,defaultEmail,isLottery)
{
  var consignee_not_null = '<span class="input_tip" id="table_notice">收货人姓名不能为空！</span>';
  var address_not_null = '<span class="input_tip" id="table_notice">详细地址不能为空！</span>';
//  var country_not_null = '<span class="input_tip" id="table_notice">请您选择收货人所在国家！</span>';
  var province_not_null = '<span class="input_tip" id="table_notice">请您选择收货人所在省份！</span>';
  var city_not_null = '<span class="input_tip" id="table_notice">请您选择收货人所在城市！</span>';
  var district_not_null = '<span class="input_tip" id="table_notice">请您选择收货人所在区域！</span>';
  var tele_invaild = '<span class="input_tip" id="table_notice">电话号码不有效的号码</span>'
  var mobile_invaild = '<span class="input_tip" id="table_notice">手机号码不是合法号码</span>'
  var tele_both_null = '<span class="input_tip" id="table_notice">电话和手机号至少填写一项！</span>';
  var msg = new Array();
  var err = false;
  var n = i.name;
  switch (n)
  {
  case 'consignee':
    if (i.value == '')
    {
      $(".consignee_table_notice").html(consignee_not_null);return false;
    }
    else
    {
       $(".consignee_table_notice").text('');
    }
  break;
  case 'address':
    if (i && i.value == '')
    {
      $(".address_table_notice").html(address_not_null);return false;
    }
    else
    {
      $(".address_table_notice").text('');
    }

    if ($("#selProvinces_new").val() == '' || $("#selProvinces_new").val() == 0)
    {
      $(".country_table_notice").html(province_not_null);return false;
    }else{
       $(".consignee_table_notice").text('');
    }

    if ($("#selCities_new").val() == '' || $("#selCities_new").val() == 0)
    {
    $(".country_table_notice").html(city_not_null);return false;
    }else{
      $(".country_table_notice").text('');
    }

    if ($("#selDistricts_new").val() == '' || $("#selDistricts_new").val() == 0)
    {
    $(".country_table_notice").html(district_not_null);return false;
    }else{
      $(".country_table_notice").text('');
    }
  break;

  case 'mobile':
  case 'tel':
    if(Tools.isEmpty($("#mobile_new").val()) && Tools.isEmpty($("#tel_new").val()))
    {
      $(".tel_table_notice").html(tele_both_null);return false;
    }
    else
    {
      if (Tools.isEmpty($("#tel_new").val()) && !Tools.isEmpty($("#mobile_new").val()))
      {
        if(!Tools.isTel($("#mobile_new").val()))
        {
          $(".tel_table_notice").html(mobile_invaild);return false;
        }
      }
      else
      {
        if (!Tools.isTel($("#tel_new").val()))
        {
            $(".tel_table_notice").html(tele_invaild);return false;
        }
      }
    }
    $(".tel_table_notice").text('');
  break;
  }
  return true;
}