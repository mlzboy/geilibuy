#coding:utf-8
require 'digest/md5'
require 'cgi'
module TenpayLib

  def concat_url(dict)
     list=[]
    dict.each do |k,v|
      list<<%Q{#{k}=#{v}}
    end
    url=list.join("&")
  end

  def gen_sign2(dict)
    url=concat_url(dict)
    sign=Digest::MD5.hexdigest(url)
  end

  #desc是标题中文<=16,总金额，用户ip,银行错码，附加信息
  def gen_url(desc,sn,total_fee,bank_type=0,ip="",return_url=nil,attach=nil,purchaser_id=nil,charset="utf-8")
    dict={}
    dict["cmdno"]="1"
    dict["date"]=Time.now.strftime("%Y%m%d")
    dict["bargainor_id"]="1208746801"#商家id
    dict["transaction_id"]=dict["bargainor_id"]+dict["date"]+sn[-10,10]
    dict["sp_billno"]=sn
    dict["total_fee"]=(total_fee*100).to_i.to_s
    dict["fee_type"]="1"
    dict["return_url"]=return_url || "http://www.15-1688.com/tenpay/respond"
    dict["attach"]=attach||""
    dict["spbill_create_ip"]=ip
    a=dict.clone
    dict["key"]="127a657d140c4b6dae6499bbcb09b2cb"#密钥
    a["sign"]=gen_sign2(dict)
    puts a["sign"]
    a["desc"]=CGI.escape(desc)
    a["purchaser_id"]=purchaser_id||""
    a["cs"]=charset
    a["bank_type"]=bank_type.to_s
    params=concat_url(a)
    puts params
    r="http://service.tenpay.com/cgi-bin/v3.0/payservice.cgi?#{params}"
    puts r
    r
  end

end
include TenpayLib


TenpayLib::gen_url("小额","123456789012331",20.2,0,"127.0.0.1")

