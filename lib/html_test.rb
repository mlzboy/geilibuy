#coding:utf-8
(1..10).each do |a|
  c="ABCDDDDDDDDDDDDDDDDDDDDDDDDDDDDDd"
b=<<HTML
  <table width="930" border="0" cellpadding="0" cellspacing="0" class="cart_item" id="cart_item"> 
          <tr class="goods_tr">
      <td width="78" align="#{c}" valign="middle" class="goods_td"><a href="http://www.geilibuy.com/goods-2049.html" target="_blank"><img src="/images/200909/1253759547803956597-55.jpg" width="55" height="55" alt="风靡台湾快乐牛奶杯灯-浪漫礼物"/></a></td>
      <td width="265" valign="middle" class="goods_td"><a href="http://www.geilibuy.com/goods-2049.html" target="_blank">风靡台湾快乐牛奶杯灯-浪漫礼物</a></td>
      <td width="72" valign="middle" class="goods_td">9.00元</td>
      <td width="84" valign="middle" class="goods_td">
                            <span class=""></span>
                  
      </td>
      <td width="130" valign="middle" class="goods_td">
                <span class="num_down" onclick="addorminus('minus','2049','1335109')"></span>
        <input objNum="2" name="" type="text" size="4" maxlength="4" class="num_input" value="2" onblur="updatecart(2049,1335109,this);this.value=this.value.replace(/[^0-9]/g,'');if(this.value=='')this.value='1'" id='num_input_2049_1335109' class="goods_num_input"/>
        <span class="num_up" onclick="addorminus('add','2049','1335109')"></span>
                </td>
      <td width="112" valign="middle" class="goods_td"><font><span></span></font></td>
      <td width="118" valign="middle" class="goods_td"><strong>18.00元</strong></td>
      <td valign="middle" class="goods_td"><a class="item_opt" href="javascript:if (confirm('您确实要把该商品移出购物车吗？')) location.href='flow.php?step=drop_goods&amp;id=1335109';">删除</a></td>
    </tr>
                    <tr class="goods_tr">
      <td width="78" align="left" valign="middle" class="goods_td"><a href="http://www.geilibuy.com/goods-10714.html" target="_blank"><img src="/images/201009/1285552989231885965-55.JPG" width="55" height="55" alt="炭之语竹炭除臭鞋塞一对"/></a></td>
      <td width="265" valign="middle" class="goods_td"><a href="http://www.geilibuy.com/goods-10714.html" target="_blank">炭之语竹炭除臭鞋塞一对</a></td>
      <td width="72" valign="middle" class="goods_td">9.00元</td>
      <td width="84" valign="middle" class="goods_td">
                            <span class=""></span>
                  
      </td>
      <td width="130" valign="middle" class="goods_td">
                <span class="num_down" onclick="addorminus('minus','10714','1335123')"></span>
        <input objNum="1" name="" type="text" size="4" maxlength="4" class="num_input" value="1" onblur="updatecart(10714,1335123,this);this.value=this.value.replace(/[^0-9]/g,'');if(this.value=='')this.value='1'" id='num_input_10714_1335123' class="goods_num_input"/>
        <span class="num_up" onclick="addorminus('add','10714','1335123')"></span>
                </td>
      <td width="112" valign="middle" class="goods_td"><font><span></span></font></td>
      <td width="118" valign="middle" class="goods_td"><strong>9.00元</strong></td>
      <td valign="middle" class="goods_td"><a class="item_opt" href="javascript:if (confirm('您确实要把该商品移出购物车吗？')) location.href='flow.php?step=drop_goods&amp;id=1335123';">删除</a></td>
    </tr>
              
      </table>
  <table width="930" border="0" cellpadding="0" cellspacing="0" class="cart_sum">
    <tr>
      <td width="335"><a class="item_opt" href="http://www.geilibuy.com/">&lt;&lt;继续购物</a>&nbsp;&nbsp;&nbsp;&nbsp;<a class="item_opt" href="http://www.geilibuy.com/flow.php?step=clear" onclick="if(confirm('你确定要清空购物车？')){return true;}else{return false;}">清空购物车</a></td>
      <td width="595" height="50" align="right" valign="middle">花费积分：<font>0</font>合计：<strong>27.00元</strong></td>
    </tr>
  </table>
HTML
#puts b

end
#haha

def haha
  puts dd
end