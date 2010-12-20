try {
    document.domain = "geilibuy.com"
} catch(e) {}
jQuery.extend({
    evalJSON: function(strJson) {
        return eval("(" + strJson + ")")
    }
});
jQuery.extend({
    toJSON: function(A) {
        var D = typeof A;
        if ("object" == D) {
            if (Array == A.constructor) {
                D = "array"
            } else {
                if (RegExp == A.constructor) {
                    D = "regexp"
                } else {
                    D = "object"
                }
            }
        }
        switch (D) {
        case "undefined":
        case "unknown":
            return;
            break;
        case "function":
        case "boolean":
        case "regexp":
            return A.toString();
            break;
        case "number":
            return isFinite(A) ? A.toString() : "null";
            break;
        case "string":
            return '"' + A.replace(/(\\|\")/g, "\\$1").replace(/\n|\r|\t/g,
            function() {
                var G = arguments[0];
                return (G == "\n") ? "\\n": (G == "\r") ? "\\r": (G == "\t") ? "\\t": ""
            }) + '"';
            break;
        case "object":
            if (A === null) {
                return "null"
            }
            var C = [];
            for (var F in A) {
                var E = jQuery.toJSON(A[F]);
                if (E !== undefined) {
                    C.push(jQuery.toJSON(F) + ":" + E)
                }
            }
            return "{" + C.join(",") + "}";
            break;
        case "array":
            var C = [];
            for (var B = 0; B < A.length; B++) {
                var E = jQuery.toJSON(A[B]);
                if (E !== undefined) {
                    C.push(E)
                }
            }
            return "[" + C.join(",") + "]";
            break
        }
    }
});
var Browser = new Object();
Browser.isMozilla = (typeof document.implementation != "undefined") && (typeof document.implementation.createDocument != "undefined") && (typeof HTMLDocument != "undefined");
Browser.isIE = window.ActiveXObject ? true: false;
Browser.isFirefox = (navigator.userAgent.toLowerCase().indexOf("firefox") != -1);
Browser.isSafari = (navigator.userAgent.toLowerCase().indexOf("safari") != -1);
Browser.isOpera = (navigator.userAgent.toLowerCase().indexOf("opera") != -1);
var Tools = new Object();
Tools.htmlEncode = function(A) {
    return A.replace(/&/g, "&amp;").replace(/"/g, "&quot;").replace(/</g, "&lt;").replace(/>/g, "&gt;")
};
Tools.trim = function(A) {
    if (typeof(A) == "string") {
        return A.replace(/^\s*|\s*$/g, "")
    } else {
        return A
    }
};
Tools.isEmpty = function(A) {
    switch (typeof(A)) {
    case "string":
        return Tools.trim(A).length == 0 ? true: false;
        break;
    case "number":
        return A == 0;
        break;
    case "object":
        return A == null;
        break;
    case "array":
        return A.length == 0;
        break;
    default:
        return true
    }
};
Tools.isNumber = function(B) {
    var A = /^[\d|\.|,]+$/;
    return A.test(B)
};
Tools.isInt = function(B) {
    if (B == "") {
        return false
    }
    var A = /\D+/;
    return ! A.test(B)
};
Tools.isEmail = function(A) {
    var B = /^\s*([A-Za-z0-9_-]+(\.\w+)*@(\w+\.)+\w{2,3})\s*$/;
    return B.test(A)
};
Tools.isTel = function(A) {
    var B = /^[\d|\-|\s|\_]+$/;
    return B.test(A)
};
Tools.fixEvent = function(B) {
    var A = (typeof B == "undefined") ? window.event: B;
    return A
};
Tools.srcElement = function(A) {
    if (typeof A == "undefined") {
        A = window.event
    }
    var B = document.all ? A.srcElement: A.target;
    return B
};
Tools.isTime = function(B) {
    var A = /^\d{4}-\d{2}-\d{2}\s\d{2}:\d{2}$/;
    return A.test(B)
};
Tools.stringLength = function(A) {
    return A.replace(/[^\x00-\xff]/gi, "xx").length
};
function rowindex(A) {
    if (Browser.isIE) {
        return A.rowIndex
    } else {
        table = A.parentNode.parentNode;
        for (i = 0; i < table.rows.length; i++) {
            if (table.rows[i] == A) {
                return i
            }
        }
    }
}
function getPosition(C) {
    var B = C.offsetTop;
    var A = C.offsetLeft;
    while (C = C.offsetParent) {
        B += C.offsetTop;
        A += C.offsetLeft
    }
    var D = {
        top: B,
        left: A
    };
    return D
}
function cleanWhitespace(B) {
    var B = B;
    for (var A = 0; A < B.childNodes.length; A++) {
        var C = B.childNodes[A];
        if (C.nodeType == 3 && !/\S/.test(C.nodeValue)) {
            B.removeChild(C)
        }
    }
}
function isEmail(B) {
    res = /^[0-9a-zA-Z_\-\.]+@[0-9a-zA-Z_\-]+(\.[0-9a-zA-Z_\-]+)*$/;
    var A = new RegExp(res);
    return ! (B.match(A) == null)
}
function $int(A, B) {
    A = isNaN(parseInt(A)) ? 1 : parseInt(A);
    A = A <= 0 ? 1 : A;
    if (B) {
        A = A > B.length ? 0 : A - 1
    }
    return A
}
function setActiveMenu(A) {
    A = A.substring(0, 4);
    $(".menu_li").each(function() {
        if ($(this).attr("nXml") == $int(A)) {
            $(this).find("a").each(function() {
                $(this).css("color", "#cc3333")
            })
        }
    })
}

function setActiveCatogry(C, B, A) {
    if (B == "" || B == null) {
        B = "lev3"
    }
    if (A == "" || A == null) {
        A = "h2"
    }
    var D = $("." + B);
    D.each(function(G) {
        var F = $(this).attr("cXml");
        var E = $(this).find(A).css("color");
        if (C != "") {
            if (F == C) {
                $(this).find(A).each(function() {
                    $(this).css("color", "#cc6600")
                })
            } else {
                D[G].onmouseover = function() {
                    $(this).find(A).each(function() {
                        $(this).css("color", "#cc6600")
                    })
                };
                D[G].onmouseout = function() {
                    $(this).find(A).each(function() {
                        $(this).css("color", E)
                    })
                }
            }
        } else {
            D[G].onmouseover = function() {
                $(this).find(A).each(function() {
                    $(this).css("color", "#cc6600")
                })
            };
            D[G].onmouseout = function() {
                $(this).find(A).each(function() {
                    $(this).css("color", E)
                })
            }
        }
    })
}
function setActiveScroll(A) {
    $(A).find("ul:first").animate({
        marginTop: "-25px"
    },
    500,
    function() {
        $(this).css({
            marginTop: "0px"
        }).find("li:first").appendTo(this)
    })
}
function killErrors() {
    return true
}

$(document).ready(function() {
    var A = $("#top_flow").css("color");
    $("#top_flow").mouseover(function() {
        $(this).find("a").each(function() {
            $(this).css("color", "#cc6600")
        })
    });
    $("#top_user").mouseover(function() {
        $(this).find("a").each(function() {
            $(this).css("color", "#cc6600")
        })
    });
    $("#top_flow").mouseout(function() {
        $(this).find("a").each(function() {
            $(this).css("color", A)
        })
    });
    $("#top_user").mouseout(function() {
        $(this).find("a").each(function() {
            $(this).css("color", A)
        })
    });
    $("#topflow_pic").click(function() {
        document.location.href = $("#top_flow").find("a")[0].href
    });
    $("#topuser_pic").click(function() {
        document.location.href = $("#top_user").find("a")[0].href
    });
    $("#topflow_pic").mouseover(function() {
        $("#top_flow").find("a").each(function() {
            $(this).css("color", "#cc6600")
        })
    });
    $("#topuser_pic").mouseout(function() {
        $("#top_user").find("a").each(function() {
            $(this).css("color", A)
        })
    });
    $("#topuser_pic").mouseover(function() {
        $("#top_user").find("a").each(function() {
            $(this).css("color", "#cc6600")
        })
    });
    $("#topflow_pic").mouseout(function() {
        $("#top_flow").find("a").each(function() {
            $(this).css("color", A)
        })
    });
    $("#inputKeyWords").focus(function() {
        var B = $("#inputKeyWords")[0].value;
        $("#inputKeyWords").select();
        $("#inputKeyWords").blur(function() {
            if ($("#inputKeyWords")[0].value.replace(/ /g, "") == "") {}
        })
    })
});
function topChangeAction(C, A, B) {
    if (C != "") {
        if (A == "" || A == null) {
            A = ".hot_show_li"
        }
        if (B == "" || B == null) {
            B = ".hot_onshow_li"
        }
        C = $int(C);
        $(A).each(function(D, E) {
            if ((D + 1) == C) {
                $(this).css("display", "none")
            }
        });
        $(B).each(function(D, E) {
            if ((D + 1) == C) {
                $(this).css("display", "block")
            }
        })
    }
    $(A).each(function() {
        $(this).mouseover(function() {
            var D = $(this).attr("tXml");
            $(A).each(function() {
                if (D != $(this).attr("tXml")) {
                    $(this).css("display", "block")
                } else {
                    $(this).css("display", "none")
                }
            });
            $(B).each(function() {
                if (D == $(this).attr("tXml")) {
                    $(this).css("display", "block")
                } else {
                    $(this).css("display", "none")
                }
            })
        })
    })
}
function setColorAction(B, A, C) {
    if (A == "" || A == null) {
        A = "a"
    }
    if (C == "" || C == null) {
        C = "#0066cc"
    }
    $("div").each(function() {
        var F = $(this).attr("colorXml");
        if (F == B) {
            var D = $(this);
            var E = "#666666";
            D.find(A).each(function() {
                if ($(this).css("color")) {
                    E = $(this).css("color")
                }
            });
            D.mouseover(function() {
                $(this).find(A).each(function() {
                    $(this).css("color", C);
                    $(this).css({
                        "text-decoration": "underline",
                        color: C
                    })
                })
            });
            D.mouseout(function() {
                $(this).find(A).each(function() {
                    $(this).css("color", E);
                    $(this).css({
                        "text-decoration": "none",
                        color: E
                    })
                })
            })
        }
    })
}
function windowMessage(G) {
    
    if (G != "flow_done") {
        strHtml = '<div id="pay_message"><div id="pay_message_flag"><div id="pay_message_close"><a href="javascript:doOk();">关闭</a></div></div><div id="pay_message_title">'+G+'</div><div id="pay_message_msg">被成功加入了购物车 </div><div id="pay_message_flownum">您的购物车内现有<span id="message_num">0</span>件商品</div><div id="pay_message_btn"><div id="pay_message_go"><a href="javascript:doOk();"><img src="/themes/default/imgs/global/goback.gif"/></a></div><div id="pay_message_buy"><a href="flow.php"><img src="/themes/default/imgs/global/btncart.gif"/></a></div><div id="clear"></div></div></div>'
    } else {        
    	popdiv("#payok_pop","359","auto",0.4);
	}
    
	
}
function setSearchAicon(C, A) {
    C = C.toLowerCase();
    A = A.toLowerCase();
    var B = "";
    var D = "";
    var E = "";
    var F = "";
    var G = "";
	var H = "";
//alert(C);    
//if (C =="goods_id"){
//    if (A == "desc") {
//        B = "asc"
//    } else {
//        B = "desc"
//    }
//}
    D = "goods_price";
    E = "goods_price_up";
    F = "goods_price_down";
    G = "goods_id";
	H = "unreal_sales";
	
    $("#" + H).click(function() { 
        $("#"+ G).find('a').eq(0).removeClass('sort');
        $("#"+ E).find('a').eq(0).removeClass('sort');
        $("#"+ F).find('a').eq(0).removeClass('sort');
        $("#"+ H).find('a').eq(0).addClass('sort');
        $("#page_list_sort")[0].value = H;
        $("#page_list_order")[0].value = "desc";
        $("#page_list_sort_form").submit()
    });
	
    $("#" + G).click(function() {
        $("#"+ G).find('a').eq(0).addClass('sort');
        $("#"+ E).find('a').eq(0).removeClass('sort');
        $("#"+ F).find('a').eq(0).removeClass('sort');
		$("#"+ H).find('a').eq(0).removeClass('sort');
        $("#page_list_sort")[0].value = G;
        $("#page_list_order")[0].value = 'desc';
        $("#page_list_sort_form").submit()
    });
    
    $("#" + E).click(function() {
        $("#"+ G).find('a').eq(0).removeClass('sort');
        $("#"+ E).find('a').eq(0).addClass('sort');
        $("#"+ F).find('a').eq(0).removeClass('sort');
		$("#"+ H).find('a').eq(0).removeClass('sort');
        $("#page_list_sort")[0].value = D;
        $("#page_list_order")[0].value = "asc";
        $("#page_list_sort_form").submit()
    });
    
    $("#" + F).click(function() {
        $("#"+ G).find('a').eq(0).removeClass('sort');
        $("#"+ E).find('a').eq(0).removeClass('sort');
        $("#"+ F).find('a').eq(0).addClass('sort');
		$("#"+ H).find('a').eq(0).removeClass('sort');
        $("#page_list_sort")[0].value = D;
        $("#page_list_order")[0].value = "desc";
        $("#page_list_sort_form").submit()
    });
	
}

function setGoodsListAction() {
    $("div").each(function() {
        var C = $(this).attr("gCXml");
        if (C) {
            var B = $(this).find("h1").css("color");
            var A = $(this).find("img").eq(0).css("border-color");
            $(this).mouseover(function() {
                $(this).find("h1").css("color", "#cc6600");
                $(this).find("img").eq(0).css("border-color", "#cc6600")
            });
            $(this).mouseout(function() {
                $(this).find("h1").css("color", B);
                $(this).find("img").eq(0).css("border-color", A)
            })
        }
    })
}
function insertToCartAction(goodsId, goodsName, isRefesh, parentId) {
    var goods = new Object();
    var spec_arr = new Array();
    var fittings_arr = new Array();
    var select = "";
    var p = parentId == "" ? false: true;
    var number = 1;
    var refresh = 0;
    if (isRefesh) {
        refresh = 1
    }
    if ($("#goods_type_select")) {
        select = $("#goods_type_select").value
    }
    goods = '{"spec": "","select": "' + select + '", "goods_id":"' + goodsId + '", "number": "' + number + '","parent": "0" }';
    $.ajax({
        type: "POST",
        url: "/shopping/check?step=add_to_cart",
        data: "goods=" + goods,
        success: GoodsInsertToCartResponse,
        complete: function(XMLHttpRequest, status) {
            result = eval("(" + XMLHttpRequest.responseText + ")");
            if (!result.error) {
                if (refresh == 1) {
                    location.reload()
                } else {
                    windowMessage(goodsName)
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
function GoodsInsertToCartResponse(A) {
    if (A.error > 0) {} else {
       setHeadFlowNum();
    }
}
function collectGoodsAction(A) {
    $.ajax({
        type: "GET",
        url: "/usercenter/check?act=collect",
        cache: false,
        data: "id=" + A + "&backurl=/product/" + A,
        success: function(C) {
            C = $.evalJSON(C);
            alert(C.message);
            if (C.error == "1") {
                var B = encodeURIComponent("/product/" + A);
                location.href = "http://www.geilibuy.com/user.php?action=collect&id=" + A + "&back_url=" + B
            }
        }
    })
}

function payEndAction(A, B, C) {
    if (B == "hzly" || B == "bocomm" || B == "kuaiqian" || B == "yunwang" || B == "cmb" || B == "icbc" || B == "abc" || B == "ccb" || B == "bcom" || B == "sdb" || B == "gdb" || B == "citic" || B == "hxb" || B == "cib" || B == "ceb" || B == "tenpay" || B == "soopay") {
        $("#" + C)[0].submit()
    } else {
        window.open(A)
    }
    windowMessage("flow_done")
}
function $F(A) {
    if ($("#" + A)) {
        return $("#" + A)[0].value
    }
    return null
};

/* 控制#textarea字符长度 */
//A 类型
//B 字符长度
//C 控制元素的id
function lentxt(A,B,C)
{
  var s_content = $(C)[0].value;

  if(A == 1 && (s_content == '评论不能超过'+B+'个字' || s_content == '字数上限'+B)){
    $(C)[0].value = '';
    return  false;
  }

  var s_num = s_content.replace(/[\r\n]/g, '').length;

  if(s_num > B)
  {
    $(C)[0].value = s_content.substring(0,B);
    return  false;
  }
  else
  {
    return  true;
  }
}

//  加入购物车 函数
function inTooCartAction(goodsId, goodsName, isRefesh, parentId, isIntegral,position) {	
    var goods = new Object();
    var spec_arr = new Array();
    var fittings_arr = new Array();
    var select = "";
    var p = parentId == "" ? false: true;
    var number = 1;
    var refresh = 0;
    if (isRefesh) {
        refresh = 1
    }
    if ($("#goods_type_select")) {
        select = $("#goods_type_select").value
    }
    goods = '{"spec": "","select": "' + select + '", "goods_id":"' + goodsId + '", "number": "' + number + '","parent": "0", "isIntegral": "' + isIntegral + '" }';
    $.ajax({
        type: "POST",
        url: "/shopping/check?step=add_to_cart",
        data: "goods=" + goods,
        success: function(){
				setHeadFlowNum();
		},
        complete: function(XMLHttpRequest, status) {
            result = eval("(" + XMLHttpRequest.responseText + ")");
            if (!result.error) {
                if (refresh == 1) {
                    //windowMessage(goodsName)
					//location.reload()
					//$(".pop_inf").text(goodsName);
					//popdiv("#cat_pop","369","auto",0.4);
				//　alert(position.attr('class'));	
					position.parent().parent().find('.pop_out').remove();
					$("#cat_pop").clone().appendTo(position.parent().parent()); 
					$('.list').find('.pop_out').hide();
					position.parent().parent().find('.pop_out').fadeIn();
					
                } else {
                    //windowMessage(goodsName)
                    window.location="flow.php";
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