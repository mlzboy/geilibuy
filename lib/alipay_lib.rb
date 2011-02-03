#coding:utf-8
require 'digest/md5'
require 'cgi'
module AlipayLib
  def concat_url(dict)
     list=[]
    dict.each do |k,v|
      list<<%Q{#{k}=#{CGI.escape(v)}}
    end
    url=list.join("&")
  end

  def gen_sign(dict,key)
    Digest::MD5.hexdigest((dict.sort.collect{|s|s[0]+"="+s[1]}).join("&")+key)
  end

  def gen_url(subject,sn,total_fee,show_url,paymethod="bankPay",body=nil,return_url=nil,notify_url=nil,it_b_pay=nil,defaultbank="",charset='utf-8')
    dict={}
    dict["service"]="create_direct_pay_by_user"
    dict["payment_type"]="1"
    dict["partner"]="2088502816133364"#partner_id
    dict["seller_email"]="hi@geilibuy.com"
    dict["return_url"]=return_url || "http://www.geilibuy.com/alipay/respond"
    dict["notify_url"]=notify_url || "http://www.geilibuy.com/alipay/notify"
    dict["_input_charset"]="utf-8"
    dict["show_url"]=show_url
    dict["out_trade_no"]=sn
    dict["subject"]=subject
    dict["body"]=body||""
    dict["total_fee"]=total_fee.to_s
    dict["paymethod"]=paymethod
    dict["defaultbank"]=defaultbank
    dict["anti_phishing_key"]=""
    dict["exter_invoke_ip"]=""
    dict["buyer_email"]=""
    dict["extra_common_param"]=""
    dict["royalty_type"]=""
    dict["royalty_parameters"]=""
    dict["it_b_pay"]=it_b_pay||""#此项功能需要申请开通
    dict=dict.select{|k,v| !v.nil? and v.strip!=""}
    dict["sign"]=gen_sign(dict,"tjph0tdhyjq2g41ebyuirc011dvpd7pc")#密钥
    dict["sign_type"]="MD5"
    puts dict["sign"]
    params=concat_url(dict)
    r="https://www.alipay.com/cooperate/gateway.do?"+params
    puts r
    puts "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF"
    r
  end

end
include AlipayLib
#gen_url("大家好","20101203111212",20.2,"directPay")
gen_url("大家","20101204121215","20.2","")

