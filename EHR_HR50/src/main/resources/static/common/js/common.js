/**
mySheet0 * @author isuSystem
 *
 * Common Javascript
 *
 */


/**
 * Form 전송시 input이 하나인 경우 자체 submit을 하여 오류 발생 submit을 하지 못하도록 차단
 *

$(document).ready(function() {
	$("form").each( function() {
		$(this).attr("onsubmit","return false;");
	});
});
*/

/* 엔터시 빈페이지 뜨는 현상 */
$("*").keypress(function(e) {
    e = e || event;
    var tag = e.srcElement ? e.srcElement.tagName : e.target.nodeName;

    // "INPUT" 을가져옴  TEXTARAE 아님
    if (tag != "INPUT") {
        return true;
    } else {
        if (e.keyCode == 13) {
            return false;
        }
    }
});
/* Backspace 뒤로가기 막기 2019.10.10
$(document).keydown(function(e) {
    e = e || event;
    var tag = e.srcElement ? e.srcElement.tagName : e.target.nodeName;
    if (tag != "INPUT" && tag != "TEXTAREA" && e.keyCode == 8) {
        return false;
    }
}); */

//employeeHeader 에서 사용되는 공통함수
//function setEmpPage(){}

function isObject(obj) {
	return obj != null && typeof obj == 'object';
}


function setValidate(form, msg) {
    form.validate({
        onkeyup: false,
        onclick: false,
        onfocusout: false,
        messages: msg,
        showErrors: function(errorMap, errorList) {
            if (!$.isEmptyObject(errorList)) {
                if (errorList.length > 0) {
                    alert(errorList[0].message);
                    $("#" + errorList[0].element.id).focus();
                }
            }
        }
    });
}

function groupBy(obj, key, callback) {
	  if (!isObject(obj) || !key) return obj;
	  const group = Object.keys(obj).reduce((a, c) => {
	    const item = obj[c];
	    if (a[item[key]]) a[item[key]].push(item);
	    else a[item[key]] = [item];
	    return a;
	  }, {});
	  return !callback
	    ? group
	    : Object.entries(group).reduce(
	        (a, [key, value], i, origin) =>
	          Object.assign(a, { [key]: callback(value, key, i, origin) }),
	        {},
	      );
}

/**
 * Jsp Code를 String 형태로 추출
 *
 * @param url
 * @returns
 */
function pageToHtml(url) {
    var html = $.ajax({
        url: "<c:url value='" + url + "' />",
        async: false
    }).responseText;
    return html;
}

/**
 * XSS_Replace
 *
 * @param str
 * @returns String
 */
function XSS_Replace(str) {
    return str.replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/'/g, '&#039;')
        .replace(/"/g, '&quot;');
}

/**
 * 공통 코드 조회
 *
 * @param url
 * @param grpCd
 * @param baseSYmd
 * @param baseEYmd
 * @param async
 * @returns Object
 */
function codeList(url, grpCd, baseSYmd, baseEYmd, async) {
    let params = "grpCd=" + grpCd + "&queryId=" + grpCd;
    if (baseSYmd !== undefined) {
        params += "&baseSYmd=" + baseSYmd;
    }

    if (baseEYmd !== undefined) {
        params += "&baseEYmd=" + baseEYmd;
    }

    const data = ajaxCall(url, params, false).codeList;
    if (data == 'undefine' || data == null)
        return null;
    return data.length > 0 ? data : null;
}

/**
 * 공통 코드 조회에서 조회된 데이터를 IBsheet에서 Combo형태로 쓰는 형태로 구성 [0] name: A|B|C|D|E [1] cd:
 * 1|2|3|4|5 [2] <option value="cd">name<option>
 *
 * @param obj
 * @param str
 * @returns Array
 */
function convCode(obj, str) {
    // JNS 수정 : 코드 리스트가 없을 경우 empty Data 생성후 리턴
    // modify Date : 2014-01-20
    //	if (null == obj || obj == 'undefine') return false;
    //	if (obj.length < 1) return false;
    var convArray = new Array("", "", "", "", "");
    if (null == obj || obj == 'undefine') {

        convArray[0] = "";
        convArray[1] = "";
        convArray[2] = "<option value=''>" + str + "</option>";
        return convArray;
    }
    if (obj.length < 1) {

        convArray[0] = "";
        convArray[1] = "";
        convArray[2] = "<option value=''>" + str + "</option>";
        return convArray;
    }


    if (str != "") convArray[2] += "<option value=''>" + str + "</option>";

    for (i = 0; i < obj.length; i++) {
        convArray[0] += obj[i].codeNm + "|";
        convArray[1] += obj[i].code + "|";
        convArray[2] += "<option value='" + obj[i].code + "'>" + obj[i].codeNm + "</option>";
        convArray[3] += "<option value='" + obj[i].code + "'>[" + obj[i].code + "]" + obj[i].codeNm + "</option>";
        convArray[4] += "[" + obj[i].code + "]" + obj[i].codeNm + "|";
    }
    convArray[0] = convArray[0].substr(0, convArray[0].length - 1);
    convArray[1] = convArray[1].substr(0, convArray[1].length - 1);
    convArray[4] = convArray[4].substr(0, convArray[4].length - 1);

    return convArray;
}

/**
 * 공통 코드 조회에서 조회된 데이터를 IBsheet에서 Combo형태로 쓰는 형태로 구성 [0] name: A|B|C|D|E [1] cd:
 * 1|2|3|4|5 [2] <option value="cd">name<option>
 *
 * @param obj
 * @param str
 * @returns Array
 */
function stfConvCode(obj, str, objId, idx) {

    var convArray = new Array("", "", "");

    if (null == obj || obj == 'undefine') {

        convArray[0] = "";
        convArray[1] = "";
        convArray[2] = "<option value=''>" + str + "</option>";
        return convArray;
    }
    if (obj.length < 1) {

        convArray[0] = "";
        convArray[1] = "";
        convArray[2] = "<option value=''>" + str + "</option>";
        return convArray;
    }



    if (str != "") convArray[2] += "<option value=''>" + str + "</option>";

    for (i = 0; i < obj.length; i++) {
        convArray[0] += obj[i].codeNm + "|";
        convArray[1] += obj[i].code + "|";
        convArray[2] += "<option value='" + obj[i].code + "'>" + obj[i].codeNm + "</option>";
    }
    convArray[0] = convArray[0].substr(0, convArray[0].length - 1);
    convArray[1] = convArray[1].substr(0, convArray[1].length - 1);

	// 콤보박스에 memo, note1, note2, note3, codeEngNm 추가
	if(objId) {
		if(!idx) {
			alert("콤보 박스에 반영할 Array Data Index 가 없습니다.");
			return;
		}
		$("#"+objId).html(convArray[idx]);
		addComboNote(obj, objId);
		/*setTimeout(function(){

		}, 200 );*/
	}

    return convArray;
}


/**
 * 공통 코드 조회에서 조회된 데이터를 IBsheet에서 Combo형태로 쓰는 형태로 구성 [0] name: A|B|C|D|E [1] cd:
 * 1|2|3|4|5 [2] <option value="cd">name<option> IDX의 값에 따라서 Default Selected 됨
 * 사용 안함은 -1
 *
 * @param obj
 * @param str
 * @returns Array
 */
function convCodeIdx(obj, str, idx) {
    if (null == obj || obj == 'undefine') return false;
    if (obj.length < 1) return false;

    var convArray = new Array("", "", "");

    if (str != "" && idx == 0) {
        convArray[2] += "<option value='' Selected>" + str + "</option>";
    } else if (str != "" && idx != 0) {
        convArray[2] += "<option value='' >" + str + "</option>";
    }
    for (i = 0; i < obj.length; i++) {

        if (idx != -1 && idx - 1 == i && str == "") {
            convArray[2] += "<option value='" + obj[i].code + "' Selected>" + obj[i].codeNm + "</option>";
        } else {
            convArray[2] += "<option value='" + obj[i].code + "'>" + obj[i].codeNm + "</option>";
        }

        convArray[0] += obj[i].codeNm + "|";
        convArray[1] += obj[i].code + "|";
    }
    convArray[0] = convArray[0].substr(0, convArray[0].length - 1);
    convArray[1] = convArray[1].substr(0, convArray[1].length - 1);

    return convArray;
}

function convCodeNote(obj, str,NoteNum,NoteValue) {

	var convArray = new Array("", "", "");
	if (null == obj || obj == 'undefine'){

		convArray[0] = "";
		convArray[1] = "";
		convArray[2] = "<option value=''>" + str + "</option>";
		return convArray;
	}
	if (obj.length < 1){

		convArray[0] = "";
		convArray[1] = "";
		convArray[2] = "<option value=''>" + str + "</option>";
		return convArray;
	}


	if(str != "") convArray[2] += "<option value=''>" + str + "</option>";

	for (i = 0; i < obj.length; i++) {
		if(NoteNum == 1){
		   if(obj[i].note1 == NoteValue){
		      convArray[0] += obj[i].codeNm + "|";
		      convArray[1] += obj[i].code + "|";
		      convArray[2] += "<option value='" + obj[i].code + "'>" + obj[i].codeNm + "</option>";
		   }
		}else if(NoteNum == 2){
	       if(obj[i].note2 == NoteValue){
		      convArray[0] += obj[i].codeNm + "|";
		      convArray[1] += obj[i].code + "|";
		      convArray[2] += "<option value='" + obj[i].code + "'>" + obj[i].codeNm + "</option>";
		   }
		}else if(NoteNum == 3){
	       if(obj[i].note3 == NoteValue){
		      convArray[0] += obj[i].codeNm + "|";
		      convArray[1] += obj[i].code + "|";
		      convArray[2] += "<option value='" + obj[i].code + "'>" + obj[i].codeNm + "</option>";
		   }
		}

	}
	convArray[0] = convArray[0].substr(0, convArray[0].length - 1);
	convArray[1] = convArray[1].substr(0, convArray[1].length - 1);


	return convArray;
}

/**
 * 공통 summit 호출
 *
 * @param url
 * @param params
 * @param async
 * @param procMapLinkBarInfo    //프로세스 맵 추가 2023.10.16 송은선
 * @returns Object
 */
function submitCall(formObj, target, method, action, bvprgCd,procMapLinkBarInfo) {
    var token = "";
    var map = ajaxCall("/SecurityToken.do", "prgCd=" + action, false);
    
    //프로세스 맵 추가 2023.10.16 송은선
    if($(formObj).find("#linkBarProcMapSeq").length < 1){
		let linkProcMapSeq="";
		let linkProcSeq="";
		
		if(procMapLinkBarInfo){
			linkProcMapSeq = procMapLinkBarInfo.procMapSeq;
			linkProcSeq = procMapLinkBarInfo.procSeq;
		}
		
		var procMap_hidden = $('<input type="hidden" value="' + linkProcMapSeq + '" name="linkBarProcMapSeq" id="linkBarProcMapSeq">');
		var proc_hidden = $('<input type="hidden" value="' + linkProcSeq + '" name="linkBarProcSeq" id="linkBarProcSeq">');
		$(formObj).append(procMap_hidden);
		$(formObj).append(proc_hidden);
	}
	
    if(procMapLinkBarInfo){
		$(formObj).find("#linkBarProcMapSeq").val(procMapLinkBarInfo.procMapSeq);
		$(formObj).find("#linkBarProcSeq").val(procMapLinkBarInfo.procSeq);
	}else{
		$(formObj).find("#linkBarProcMapSeq").val("");		
		$(formObj).find("#linkBarProcSeq").val("");		
	}
	
    var length = Object.keys( map ).length;
    if(length!=0){

    	if (typeof map != 'undefined') token = encodeURIComponent(map.map.token);
    }
    
    if ($(formObj).find("#token").length == 0) {
        var o_hidden = $('<input type="hidden" value="' + token + '" name="token" id="token">');
        var p_hidden = $('<input type="hidden" value="' + action + '" name="vprgCd" id="vprgCd">');
        $(formObj).append(o_hidden);

        if(typeof bvprgCd == "undefined" || bvprgCd == true) {
            $(formObj).append(p_hidden);
        }


    //console.log("action="+ action+">>token=="+ token);
    $(formObj).find("#token").val(token);
    }

    if(typeof bvprgCd == "undefined" || bvprgCd == true) {
        $(formObj).find("#vprgCd").val(action);
    }

    formObj.attr("target", target)
        .attr("method", method)
        .attr("action", action)
        .submit();
}

/**
 * RD 호출용 공통 summit
 */
function submitCallRd(formObj, target, method, action, url, data) {

    const result = ajaxTypeJson(url, data, false);

    var token = "";
    var map = ajaxCall("/SecurityToken.do", "prgCd=" + action, false);

    var length = Object.keys( map ).length;
    if(length!=0){

        if (typeof map != 'undefined') token = encodeURIComponent(map.map.token);
    }

    if ($(formObj).find("#token").length == 0) {
        var o_hidden = $('<input type="hidden" value="' + token + '" name="token" id="token">');
        var p_hidden = $('<input type="hidden" value="' + action + '" name="vprgCd" id="vprgCd">');
        $(formObj).append(o_hidden);

        if(typeof bvprgCd == "undefined" || bvprgCd == true) {
            $(formObj).append(p_hidden);
        }
        $(formObj).find("#token").val(token);
    }

    $(formObj).find("#vprgCd").val(action);

    if ($(formObj).find("#path").length) {
        $(formObj).find("#path").remove();
    }

    if ($(formObj).find("#encryptParameter").length) {
        $(formObj).find("#encryptParameter").remove();
    }

    const p = $('<input type="hidden" value="' + result.DATA.path + '" name="path" id="path">');
    const d = $('<input type="hidden" value="' + result.DATA.encryptParameter + '" name="encryptParameter" id="encryptParameter">');
    $(formObj).append(p);
    $(formObj).append(d);

    formObj.attr("target", target)
        .attr("method", method)
        .attr("action", action)
        .submit();
}


/**
 * /common/js/jquery/jquery.attr.js  에서 호출
 * -. Tab 클릭 시 토큰을 발생시켜 화면에 토큰을 같이 전송 함
 */
function catchTabSubmitCall(obj, action) {

    var target = $(obj).attr("name");
    if (typeof target == "undefined") {
        target = obj.replace(/#/gi, "").replace(/ /gi, "");
        var o_parent = $(obj).parent();
        var o_html = "<iframe id=\"" + target + "\" name=\"" + target + "\" frameborder=\"0\" class=\"tab_iframes\"></iframe>"; // src에 ${ctx}/common/hidden.jsp 가 들어가면 세션ID가 변경 되어서 세션 중복체크가 안됨
        $(obj).remove();
        $(o_parent).append(o_html);

    }

    var p_hidden = "";
    var new_form = document.createElement("form");


    if (action.indexOf("?") > -1) {
        var arr1 = action.split("?");
        var arr2 = arr1[1].split("&");

        action = arr1[0];
        //console.log("■■■■■■■■■■  arr2 : "+ arr2.length);
        for (var i = 0, len = arr2.length; i < len; i++) {
            if (arr2[i].indexOf("cmd=") > -1) {
                action += "?" + arr2[i];
            } else if (arr2[i] != "") {
                var arr3 = arr2[i].split("=");
                if (arr3.length == 2) {
                    p_hidden = $("<input type='hidden' id='" + arr3[0] + "' name='" + arr3[0] + "' value='" + arr3[1] + "' />");
                    $(new_form).append(p_hidden);
                }

            }
        }
    }

    var token = "";
    var map = ajaxCall("/SecurityToken.do", "prgCd=" + action, false);
    if (typeof map != 'undefined') token = encodeURIComponent(map.map.token);

    //console.log("■■■■■■■■■■  action : "+ action );
    //console.log("■■■■■■■■■■  target : "+ target );
    //console.log("■■■■■■■■■■  token : "+ token );

    p_hidden = $('<input type="hidden" value="' + token + '" name="token" id="token">');
    $(new_form).append(p_hidden);


    $(new_form).attr({
        "method": "post",
        "target": target,
        "action": action
    });
    $(new_form).appendTo('body');
    $(new_form).submit();

    //console.log("■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■");

}

/**
 * 
 * @param form (jquery form tag)
 * @returns
 */
function formToJson(form) {
	return form.serializeArray().reduce((a, c) => {
		a[c.name] = a[c.name] ? [ ...a[c.name], c.value ]:c.value;
		return a;
	}, {});
}

/**
 * 
 * @param obj (json)
 * @returns
 */
function queryStringToJson(obj) {
	return Object.keys(obj).reduce((a, c) => {
		if (a != '') a += '&';
		a += c + '=' + obj[c];
		return a;
	}, '');
}


function ajaxTypeHtml(url, params) {
	let obj;
	$.ajax({
        url: url,
        type: "post",
        headers: {'Content-Type': 'application/json'},
        dataType: "html",
        async: false,
        data: params,
        success: function(data) {
            obj = data;
        },
        error: function(jqXHR, ajaxSettings, thrownError) {
            ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
        }
    });
	
	return obj;
}

function ajaxTypeJson(url, params, async) {
	 var obj = new Object();
    //headerReSetTimer();
    $.ajax({
        url: url,
        type: "post",
        headers: {'Content-Type': 'application/json'},
        dataType: "json",
        async: async,
        data: JSON.stringify(params),
        success: function(data) {
            obj = data;
        },
        error: function(jqXHR, ajaxSettings, thrownError) {
            ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
        }
    });

    return obj;
}


//function ajaxJsonErrorAlert(jqXHR, textStatus, thrownError){
//	if(jqXHR.status == "905"){
//		if(opener != null){
//			self.close();
//			opener.window.top.location.replace("/Login.do");
//		}else{
//			window.top.location.replace("/Login.do");
//		}
//	}else if(jqXHR.status	==0){ 				alert("msg.ajax.status.0");
//	}else if(jqXHR.status	==404){ 			alert("msg.ajax.status.404");
//	}else if(jqXHR.status	==500){ 			alert("msg.ajax.status.500");
//	}else if(thrownError	=='parsererror'){ 	alert("msg.ajax.thrownError.parsererror");
//	}else if(thrownError	=='timeout'){ 		alert("msg.ajax.thrownError.timeout");
//	}else { 									alert("msg.ajax.status.else");
//	}
//
//	//network Error 12029 error UnKnown
//}

/**
 * 공통 ajax 호출
 *
 * @param url
 * @param params
 * @param async
 * @returns Object
 */
function ajaxCall(url, params, async) {
    var obj = new Object();
    //headerReSetTimer();
    $.ajax({
        url: url,
        type: "post",
        dataType: "json",
        async: async,
        beforeSend: function (xhr) {
            xhr.setRequestHeader("m", $("ilcs").attr("m"));
        },
        data: params,
        success: function (data) {
            obj = data;
        },
        error: function (jqXHR, ajaxSettings, thrownError) {
            ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
        }
    });

    return obj;
}

function ajaxJsonCall(url, params, async) {
    var obj = new Object();
    //headerReSetTimer();
    $.ajax({
        url: url,
        type: "post",
        dataType: "json",
        contentType : 'application/json; charset=utf-8',
        async: async,
        beforeSend: function (xhr) {
            xhr.setRequestHeader("l",$("body").attr("l"));
        },
        data: JSON.stringify(params),
        success: function(data) {
            obj = data;
        },
        error: function(jqXHR, ajaxSettings, thrownError) {
            ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
        }
    });

    return obj;
}

/**
 * 공통 ajax 호출.
 * 비동기 처리를 위해 ajaxCall 에서 beforeFn, successFn, errorFn이 추가되었다.
 *
 * @param url 서버 호출 URL
 * @param params 파라미터
 * @param async 비동기처리여부
 * @param beforeFn ajax가 서버에 요청하기 전에 실행하는 로직
 * @param successFn ajax가 서버에 요청 처리 후 로직
 * @param errorFn ajax가 서버 요청 실패 후 로직
 * @returns Object
 */
function ajaxCall2(url, params, async, beforeFn, successFn, errorFn) {
    var obj = new Object();
    $.ajax({
        url: url,
        type: "post",
        dataType: "json",
        async: async,
        data: params,
        beforeSend: function(request) {
            // ajax가 서버에 요청하기 전에 실행하는 로직
            if (typeof beforeFn === "function") {
                beforeFn();
            }
        },
        success: function(data) {
            // 서버 요청 처리 후 로직
            obj = data;
            if (typeof successFn === "function") {
                successFn(data);
            }
        },
        error: function(jqXHR, ajaxSettings, thrownError) {
            // 서버 요청 처리 시 실패할 경우 로직
            if (typeof errorFn === "function") {
                errorFn(jqXHR, ajaxSettings, thrownError);
            }
            ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
        }
    });
    return obj;
}

function ajaxCall3(url, type, params, async, beforeFn, successFn,errorFn) {
    var obj = new Object();
    $.ajax({
        url: url,
        type: type,
        contentType:'application/json',
        dataType: "json",
        async: async,
        data: params,        
        beforeSend: function(request) {
            if (typeof beforeFn != "undefined" && $.isFunction(beforeFn)) {
                beforeFn();
            }
        },
        success: function(data) {
            obj = data;
            if (obj != null) {
				if(data.status.indexOf('SUCCESS')>-1){
                	if (typeof successFn != "undefined" &&$.isFunction(successFn)) {
                    	successFn(data);
                    }
				}else{
					if (typeof errorFn != "undefined" &&$.isFunction(errorFn)) {
						errorFn();	
					}
					alert("문제가 발생하였습니다.");
				}
            }
        },
        error: function(jqXHR, ajaxSettings, thrownError) {
             if (typeof beforeFn != "undefined" && $.isFunction(errorFn)) {
                errorFn();
            }
            ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
        }
    });
    return obj;
}

function ajaxJsonErrorAlert(jqXHR, textStatus, thrownError) {
    console.log("ajaxJsonErrorAlert");
    console.log("jqXHR.status : ", jqXHR);
    console.log("textStatus : ", textStatus);
    console.log("thrownError : ", thrownError);

    if (jqXHR.status == "905") {
        if (opener != null) {
            self.close();
            opener.window.top.location.replace("/Info.do?code=905");
        } else {
            window.top.location.replace("/Info.do?code=905");
        }
    } else if (jqXHR.status == 0) {
        alert("msg.ajax.status.0");
    } else if (jqXHR.status == 404) {
        alert("msg.ajax.status.404");
    } else if (jqXHR.status == 500) {
        alert("msg.ajax.status.500");
    } else if (thrownError == 'parsererror') {
        alert("msg.ajax.thrownError.parsererror");
    } else if (thrownError == 'timeout') {
        alert("msg.ajax.thrownError.timeout");
    } else {
        // alert("msg.ajax.status.else");
        top.location.href="/";
    }
    //network Error 12029 error UnKnown
}




/**
 * ajax 호출 시 세션 끊겼을 경우 처리
 *
 * @param e
 * @param xhr
 * @param settings
 * @param exception
 */
function ajaxError(e, xhr, settings, exception) {
    switch (xhr.status) {
        case 0: // Abort
            break;
        case 401: // Unauthorized
            try {
                var rt = $.parseJSON(xhr.responseText);
                if(rt.hasOwnProperty("loginURL") && rt.loginURL != null){
                    location = rt.loginURL;
                }else{
                    location.reload();
                }
            } catch (e) {
                location.reload();
            }
            break;
        default:
            if (typeof settings.errorMessage == 'function') {
                var errorMessage = settings.errorMessage.call(settings, xhr, exception);
                if (errorMessage)
                    alert(errorMessage);
            } else if (settings.errorMessage) {
                alert(settings.errorMessage);
            }
    }
}


/**
 * 사용안함 .. ic
 */
function sheetDupCheck(sheetObj, saveName) {
    var save = sheetObj.GetSaveString({
        AllSave: 0,
        UrlEncode: 0,
        Mode: 2,
        Delim: "|"
    });
    var saveAll = sheetObj.GetSaveString(1, 0, 3, "", 2);
    var saveAllStatus = sheetObj.GetSaveString(1, 0, 3, "", 2);

    var stx, etx, addLen;

    stx = save.indexOf(saveName, 0);
    etx = save.indexOf("&", save.indexOf(saveName, 0));
    addLen = saveName.length + 1;
    var saveCut = save.substring(stx + addLen, etx);

    stx = saveAll.indexOf(saveName, 0);
    etx = saveAll.indexOf("&", saveAll.indexOf(saveName, 0));
    addLen = saveName.length + 1;
    var saveAllCut = saveAll.substring(stx + addLen, etx);

    stx = saveAll.indexOf("sStatus", 0);
    etx = saveAll.indexOf("&", saveAll.indexOf("sStatus", 0));
    addLen = "sStatus".length + 1;
    var saveAllStatus = saveAll.substring(stx + addLen, etx);

    var splitSave = saveCut.split("|");
    var splitSaveAll = saveAllCut.split("|");
    var splitSaveAllStatus = saveAllStatus.split("|");

    var sss = "";
    var cnt = 0;
    var findRow = 0;


    for (i = 0; i < splitSave.length; i++) {
        for (x = 0; x < splitSaveAll.length; x++) {
            // if(cnt > 1){
            // alert( saveName+"의 중복된 값이 존재 합니다. \n중복값:"+splitSave[i] );
            // sheetObj.SetSelectRow(findRow);
            // sheetObj.SetSelectCol(saveName);
            // return findRow;
            // }
            if ($.trim(splitSave[i]) == $.trim(splitSaveAll[x])) {
                sss += splitSaveAll[x] + "==" + splitSave[i] + "\n";
                cnt++;
                if (splitSaveAllStatus[x] == "I" || splitSaveAllStatus[x] == "U") {
                    findRow = x + 1;
                }
            }
        }
        cnt = 0;
    }

    sheetObj.SetRowBackColor(t[j], "#FF7F50");

    return findRow;
}

/**
 *
 */
function dupChk(objSheet, keyCol, delchk, firchk) {

    //var duprows = objSheet.ColValueDupRows(keyCol, delchk, true);
	var duprows = objSheet.ColValueDupRows(keyCol, false, true); //삭제컬럼은 중복체크 안하도록 수정 2020.06.02 jylee

    // var arrRow = duprows1.split(",");
    // alert(arrRow);
    // for(i=0; i<arrRow; i++){
    // objSheet.SetRowBackColor(arrRow[i],"#F4F4EE");
    // }
    var arrRow = [];
    var arrCol = duprows.split("|");


    if (arrCol[1] && arrCol[1] != "") {
        arrRow = arrCol[1].split(",");
        for (j = 0; j < arrRow.length; j++) {
            objSheet.SetRowBackColor(arrRow[j], "#FACFED");
        }

    } else {
        var j = 0;
    }

    if (j > 0) {
        alert("중복된 값이 존재 합니다.");
        return false;
    }
    return true;

}

function ajaxJson500ErrorAlert() {
    ajaxJsonGoErrorPage();
}

function ajaxJsonGoErrorPage() {
    // location.href = "<c:url value='/Info.do?code=ajaxError'/>";

    // alert("Ajax Error");
    return;
}


// 창크기를 드레그를 통해 변경하는 경우 OnResize이벤트가 과도하게 발생하는 것을 시간 간격으로
// 발생하게 끔 조절해 준다. (jquery가 필요함)
(function($, sr) {
    // debouncing function from John Hann
    // http://unscriptable.com/index.php/2009/03/20/debouncing-javascript-methods/
    var debounce = function(func, threshold, execAsap) {
        var timeout;
        return function debounced() {
            var obj = this,
                args = arguments;

            function delayed() {
                if (!execAsap)
                    func.apply(obj, args);
                timeout = null;
            };

            if (timeout) clearTimeout(timeout);
            else if (execAsap) func.apply(obj, args);

            timeout = setTimeout(delayed, threshold || 100); // 시간 설정. 얼마의 시간
            // 동안 Resize이벤트를
            // 무시할 것인지..
        };
    };
    // smartresize
    jQuery.fn[sr] = function(fn) {
        return fn ? this.bind('resize', debounce(fn)) : this.trigger(sr);
    };
})(jQuery, 'smartresize');

var globalWindowPopup = null;
var globalWindowRtnFn = null;

function isPopup() {
    if (globalWindowPopup && !globalWindowPopup.closed) {
        alert("이미 작업중이신 창이 존재합니다.");
        globalWindowPopup.focus();
        return false;
    } else {
        return true;
    }

    return true;
}

/*
 **
 * IBSheet Header Savename을 ,로 구분된 String으로 반환
 * 2013.11.26 C.B.K
 */
function sheetSaveName(initData) {
    var saveNames = "";
    for (var i = 0; i < initData.Cols.length; i++) {
        saveNames += initData.Cols[i].SaveName + ",";
    }
    return saveNames.substring(0, saveNames.length - 1);
}


//팝업 띄우는 스크립트
//window 개체를 넘기려면 arg 부분에 "window,self" 로 입력
/*
function openPopup(url,arg,width,height,rtnFn){

	if(typeof rtnFn != "undefined" && $.isFunction(rtnFn)) {
		globalWindowRtnFn = rtnFn;
	} else {
		globalWindowRtnFn = null;
	}

	var popOptions = "dialogWidth:"+width+"px; dialogHeight:"+height+"px; center: yes; resizable: yes; status: no; scroll: no;minimize:yes;maximize:yes";
	top.$('<div></div>',{
		id:"cover",
		"class":"cover"
	}).html("").appendTo('body');

	$("#cover").height(top.$(document).height());
	$("#cover").css("top",0);
	if(arg.constructor.toString().indexOf("Window") > 0 || arg.constructor.toString().indexOf("String")>0){
		var arg 	= new Array();
	}
	arg["opener"] = this;
	arg["url"] = url;

	var win = "";
	try{
		var verchk = getInternetExplorerVersion();

		if(verchk){
			throw new Error(200, "zero");
		}

		globalWindowPopup = window.showModalDialog("/Pop.do",arg,popOptions );

		//모달팝업에서 오류 시
		if(globalWindowPopup != "" && globalWindowPopup != undefined  ){
			try{
				var rtnObj = JSON.parse(globalWindowPopup);
				if( rtnObj.securityKey == "Security"){
					moveInfoPage(rtnObj.code);
				}
			}catch(je){}
		}

	}catch(e){
		//var obj_length = Object.keys(arg).length;
		var getparm = "";
		var i = 0;

		for(key in arg) {
			if([key] !="contains"){
				value = arg[key];
				if(	Object.prototype.toString.call(value)=="[object Object]" ||
					Object.prototype.toString.call(value)=="[object Window]" ||
					Object.prototype.toString.call(value)=="[object Array]"){
					getparm = getparm+ "";
				}
				else{
					getparm = getparm + ((i==0) ? "\"" : ",\"") +[key]+"\":\""+escape(value)+"\"";
					i++;
				}
			}
		}

		getparm = getparm.replace(/undefined/gi, "");

		var new_form = document.createElement("form");
		$(new_form).attr({'method': 'post'});

		var parent_element =  "<input type='hidden' id='Data' name='Data' value='" + getparm +"' />";

		$(new_form).appendTo('body');
		$(new_form).append(parent_element);

		var winHeight = document.body.clientHeight;	// 현재창의 높이
		var winWidth = document.body.clientWidth;	// 현재창의 너비

		var winX = window.screenX || window.screenLeft || 0;// 현재창의 x좌표
		var winY = window.screenY || window.screenTop || 0;	// 현재창의 y좌표

		var popX = winX + (winWidth - width)/2;
		var popY = winY + (winHeight - height)/2;
		var target = escape(url);
		target  = target.replace(/[^(a-zA-Z0-9)]/gi, "");

		globalWindowPopup = window.open("",target,"width="+width+"px,height="+height+"px,top="+popY+",left="+popX+",scrollbars=no,resizable=yes,menubar=no" );
		$(new_form).attr({"target":target,"action":"Popg.do"}).submit();
		globalWindowPopup.focus();
	}

	try{
		top.$("#cover").remove();
	}catch(e){

	}

	//top.$("#cover").remove();
	return globalWindowPopup;
}
*/

function openPopup(url, arg, width, height, rtnFn) {

	//console.log("param height : "+height);
	//console.log("window height : "+window.innerHeight );
	//console.log("window height : "+parent.window.innerHeight );

	height = $.trim(height).replace("px", "");
	
	// 2020.09.03 jylee
	// 신청서 팝업인 경우 신청서 Size를 DB에서 조회
	if( url.indexOf("ApprovalMgr.do?cmd=viewApprovalMgr") > -1  || url.indexOf("ApprovalMgrResult.do?cmd=viewApprovalMgrResult") > -1){
		var param = url.substring( url.indexOf("searchApplCd"), url.indexOf("&", url.indexOf("searchApplCd")+1) );
		
		var data = ajaxCall( "AppCodeMgr.do?cmd=getAppCodeMgrPopSize", param,false);
		if ( data != null && data.DATA != null ){ 
			if( data.DATA.popWidth != null && data.DATA.popWidth != null ){
				var popWidth = parseInt(data.DATA.popWidth);
				var popHeight = parseInt(data.DATA.popHeight);
				width = popWidth;
				height = popHeight;
			}
		}
	}
	//---------------------------------------------------------------------------
	// 2020.06.15 jylee
//	try{
//		if ( height > parent.window.innerHeight ) {
//			height = parent.window.innerHeight;
//		}
//	}catch(e){}

    if (typeof rtnFn != "undefined" && $.isFunction(rtnFn)) {
        globalWindowRtnFn = rtnFn;
    } else {
        globalWindowRtnFn = null;
    }

/*    var popOptions = "dialogWidth:" + width + "px; dialogHeight:" + height + "px; center: yes; resizable: yes; status: no; scroll: no;minimize:yes;maximize:yes";
    top.$('<div></div>', {
        id: "cover",
        "class": "cover"
    }).html("").appendTo('body');

    $("#cover").height(top.$(document).height());
    $("#cover").css("top", 0);*/
    if (arg.constructor.toString().indexOf("Window") > 0 || arg.constructor.toString().indexOf("String") > 0) {
        var arg = new Array();
    }

    arg["opener"] = this;
    arg["url"] = url;

    var win = "";
    //var obj_length = Object.keys(arg).length;
    var getparm = "";
    var i = 0;

    for (key in arg) {
        if ([key] != "contains") {
            value = arg[key];
            if (Object.prototype.toString.call(value) == "[object Object]" ||
                Object.prototype.toString.call(value) == "[object Window]" ||
                Object.prototype.toString.call(value) == "[object Array]") {
                getparm = getparm + "";
            } else {
                getparm = getparm + ((i == 0) ? "\"" : ",\"") + [key] + "\":\"" + escape(value) + "\"";
                i++;
            }
        }
    }

    getparm = getparm.replace(/undefined/gi, "");

    var new_form = document.createElement("form");
    $(new_form).attr({
        'method': 'post'
    });

    var parent_element = "<input type='hidden' id='Data' name='Data' value='" + getparm + "' />";

    $(new_form).appendTo('body');
    $(new_form).append(parent_element);


    var winHeight = document.body.clientHeight; // 현재창의 높이
    var winWidth = document.body.clientWidth; // 현재창의 너비


    var winX = window.screenX || window.screenLeft || 0; // 현재창의 x좌표
    var winY = window.screenY || window.screenTop || 0; // 현재창의 y좌표


    var popX = winX + (winWidth - width) / 2;
    var popY = winY + (winHeight - height) / 2;
    var target = escape(url);
    target = target.replace(/[^(a-zA-Z0-9)]/gi, "");

    /*
    globalWindowPopup = window.open("", target, "width=" + width + "px,height=" + height + "px,top=" + popY + ",left=" + popX + ",scrollbars=no,resizable=yes,menubar=no");
    $(new_form).attr({
        "target": target,
        "action": "Popg.do"
    }).submit();
    */

    globalWindowPopup = window.open("about:blank", "", "width=" + width + "px,height=" + height + "px,top=" + popY + ",left=" + popX + ",scrollbars=no,resizable=yes,menubar=no");
    globalWindowPopup.document.write(new_form.outerHTML);
    globalWindowPopup.document.forms[0].target = "_self";
    globalWindowPopup.document.forms[0].action = "Popg.do";
    globalWindowPopup.document.forms[0].submit();
    globalWindowPopup.focus();

    setHeaderPageObj(url, globalWindowPopup);

    try {
        top.$("#cover").remove();
    } catch (e) {

    }

    //top.$("#cover").remove();
    return globalWindowPopup;
}


//팝업 스크립트 Direct .. 사용안함 ic
function winPopup(url, arg, width, height) {

    var popOptions = "dialogWidth:" + width + "px; dialogHeight:" + height + "px; center: yes; resizable: yes; status: no; scroll: no;minimize:yes;maximize:yes";
    top.$('<div></div>', {
        id: "cover",
        "class": "cover"
    }).html("").appendTo('body');

    $("#cover").height(top.$(document).height());
    $("#cover").css("top", 0);

    var win = window.showModalDialog(url, arg, popOptions);
    top.$("#cover").remove();
    return win;
}

//프린트 팝업
function winPrintPopup(url, arg, width, height) {
    var popOptions = "dialogWidth:" + width + "px; dialogHeight:" + height + "px; dialogLeft:0px;dialogTop:00px;center:no; dialogHide:no; resizable: no; status: no; scroll: no;minimize:no;maximize:no";
    var win = window.showModalDialog(url, arg, popOptions);
    return win;
}

var timeout;
// 시트 사이즈 초기화
function sheetInit() {
    // 외부 높이 계산
    var outer_height = getOuterHeight();
    var inner_height = 0;
    var sheet_count = 1;
    var value = 0;
    $(".ibsheet").each(function() {
        if ($(this).attr("fixed") == "false") {
            // 내부 높이 계산
            inner_height = getInnerHeight($(this));
            // sheet_count 시트의 높이값 설정
            sheet_count = parseFloat(100 / parseInt($(this).attr("realHeight")));
            $(this).attr("sheet_count", sheet_count);
            value = ($(window).height() - outer_height) / sheet_count - inner_height;
            if (value < 100) value = 100;
            $(this).height(value-1); // hr50 디자인 변경되면서 높이 계산 시 1px씩 잘리는 오류 있어 수정. 2023.11.02 snow2
        }

        if ($(this).attr("id") && $(this).attr("id").indexOf("DIV_") >= 0) {
			var obj = eval($(this).attr("id").split("DIV_").join(""));
			var _w = 0;

			for( var i = 0 ; i <= obj.LastCol() ; i++ ) {
				if( !obj.GetColHidden(i) ) _w += obj.GetColWidth(i);
            }

            $(this).removeAttr("initWidth");
            $(this).attr("initWidth", _w);
        }
    });

    clearTimeout(timeout);
    addTimeOut();
    //timeout = setTimeout(addTimeOut, 50);

}

function getOuterHeight() {
    var outerHeight = 0;
    if ($(".popup_main").length > 0) outerHeight += 90;
    $(".outer").each(function() {
    	if( $(this).css("display") != "none" ){
    		var h = $(this).height();
	        h += Number($(this).css("padding-top").replace(/[^0-9]/g, ''));
	        h += Number($(this).css("padding-bottom").replace(/[^0-9]/g, ''));
	        h += Number($(this).css("margin-top").replace(/[^0-9]/g, ''));
	        h += Number($(this).css("margin-bottom").replace(/[^0-9]/g, ''));
	        h += Math.round(Number($(this).css("border-top-width").replace(/[^0-9/.]/g, '')));
	        h += Math.round(Number($(this).css("border-bottom-width").replace(/[^0-9/.]/g, '')));
	        outerHeight += h;
    	}
    });
    return parseInt(outerHeight);
}

function getInnerHeight(obj) {
    var innerHeight = 0;
    obj.parent().find(".inner").each(function() {
        innerHeight += $(this).height();
        innerHeight += Number($(this).css("padding-top").replace(/[^0-9]/g, ''));
        innerHeight += Number($(this).css("padding-bottom").replace(/[^0-9]/g, ''));
        innerHeight += Number($(this).css("margin-top").replace(/[^0-9]/g, ''));
        innerHeight += Number($(this).css("margin-bottom").replace(/[^0-9]/g, ''));
        //innerHeight += Number($(this).css("border-top-width").replace(/[^0-9]/g, ''));
        //innerHeight += Number($(this).css("border-bottom-width").replace(/[^0-9]/g, ''));
        
        // 2021.03.09 : 크로미움 기반 브라우저에서  110%로 확대시 정수가 아닌 실수값이 나옴. 따라서 소수점의 (.)이 replace에 의해 공백으로 치환되는 오류 수정
        innerHeight += Math.round(Number($(this).css("border-top-width").replace(/[^0-9/.]/g, '')));
        innerHeight += Math.round(Number($(this).css("border-bottom-width").replace(/[^0-9/.]/g, '')));

    });
    return parseInt(innerHeight);
}

function addTimeOut() {
    $(".ibsheet").each(function() {
        if ($(this).attr("id") && $(this).attr("id").indexOf("DIV_") >= 0) {
            var obj = eval($(this).attr("id").split("DIV_").join(""));

            var objID = document.getElementById("DIV_"+obj.id);
            width1 = objID.clientWidth;

            if(width1 > $(this).attr("initWidth")){
            	setSheetSize(obj);
            }
        }
    });

    // 레이어 팝업 내 IBSheet 높이 처리
    document.querySelectorAll(".GridMain").forEach(gridMain => {

        if (gridMain.closest(".modal_layer")) {

            if (gridMain.offsetHeight === 0) return; // 비활성화 상태의 IBSheet 는 패스.

            const parent = gridMain.parentElement;
            const sheetObj = eval(parent.getAttribute("data-shtid")); // IBSheet 오브젝트
            if (!sheetObj) return;

            if (parent.getAttribute("data-fixed") === "true") {
                // IBSheet 높이가 고정px 일 경우

                const sheetHeight = parseFloat(parent.getAttribute("data-realheight"));
                sheetObj.SetSheetHeight(sheetHeight);

            } else {
                // IBSheet 높이가 비율(%) 일 경우

                const realHeight = parseFloat(parent.getAttribute("data-realheight"));
                const modalBody = gridMain.closest(".modal_body");
                if (modalBody) {
                    // modal_body 가 없다면 총 높이를 구할 수 없다.

                    // outer, inner 클래스를 가진 항목들의 높이 계산
                    const outerHeight = Array.from(modalBody.querySelectorAll(".outer"))
                        .reduce((acc, cur) => acc + cur.offsetHeight + parseFloat(getComputedStyle(cur).marginTop) + parseFloat(getComputedStyle(cur).marginBottom), 0);
                    const innerHeight = Array.from(modalBody.querySelectorAll(".inner"))
                        .reduce((acc, cur) => acc + cur.offsetHeight + parseFloat(getComputedStyle(cur).marginTop) + parseFloat(getComputedStyle(cur).marginBottom), 0);

                    const computedStyleOfModalBody = getComputedStyle(modalBody);
                    const modalBodyHeight = modalBody.clientHeight
                        - parseFloat(computedStyleOfModalBody.paddingTop)
                        - parseFloat(computedStyleOfModalBody.paddingBottom); // modal_body 의 padding 높이까지 제거하여 실제 화면상 표현 가능한 높이를 구함.

                    // Tab 이 있는 구조일 경우, Tab 구역의 margin, padding 높이까지 계산한다.
                    const uiTabs = gridMain.closest(".ui-tabs");
                    let uiTabsOuterHeight = 0;
                    if (uiTabs) {
                        const computedStyleOfUiTabs = getComputedStyle(uiTabs);
                        uiTabsOuterHeight = parseFloat(computedStyleOfUiTabs.marginTop)
                            + parseFloat(computedStyleOfUiTabs.marginBottom)
                            + parseFloat(computedStyleOfUiTabs.paddingTop)
                            + parseFloat(computedStyleOfUiTabs.paddingBottom);
                    }
                    
                    // 최종 계산된 Sheet 높이
                    const sheetHeight =
                        Math.max(
                            (
                                modalBodyHeight
                                - outerHeight
                                - innerHeight
                                - uiTabsOuterHeight
                            ) * realHeight / 100
                            , 300 // 시트 최소높이 300px
                        );
                    // console.log("modalBodyHeight: " + modalBodyHeight
                    //     , ", outerHeight: " + outerHeight
                    //     , ", innerHeight: " + innerHeight
                    //     , ", uiTabsOuterHeight: " + uiTabsOuterHeight
                    //     , ", realHeight: " + realHeight
                    //     , ", sheetHeight: " + sheetHeight);

                    sheetObj.SetSheetHeight(sheetHeight);
                }

            }
        }
    })
}

// 시트 리사이즈
function sheetResize() {
    var outer_height = getOuterHeight();
    var inner_height = 0;
    var value = 0;

    $(".ibsheet").each(function() {
        inner_height = getInnerHeight($(this));
        if ($(this).attr("fixed") == "false") {
            value = parseInt(($(window).height() - outer_height) / $(this).attr("sheet_count") - inner_height);
            if (value < 100) value = 100;
            $(this).height(value-1); // hr50 디자인 변경되면서 높이 계산 시 1px씩 잘리는 오류 있어 수정. 2023.11.02 snow2
        }
    });

    clearTimeout(timeout);
    timeout = setTimeout(addTimeOut, 50);
}

/*
 * //경고창 생성 후 뿌려줌 function alert(msg, successFunction) { // 경고창 레이어 창 생성 if(
 * top.$("#dialog-alert").length == 0 ) { top.$('<div></div>',{ id:
 * 'dialog-alert', title: '확인' }).html('<p><span class="ui-icon ui-icon-info"
 * style="float: left; margin: 0 0 0 0;"></span><p class="content"></p></p>').appendTo('body'); }
 * top.$( "#dialog-alert p.content" ).html(msg); top.$( "#dialog-alert"
 * ).dialog({ modal: true, buttons: { "확인": function() { top.$( this ).dialog(
 * "close" ); if( successFunction ) successFunction.call(); top.$( this
 * ).remove(); } } }); }
 */

// 확인창 생성 후 뿌려줌
// function confirm(msg, successFunction, failFunction) {
// // 확인창 레이어 창 생성
// if( top.$("#dialog-confirm").length == 0 ) {
// top.$('<div></div>',{
// id: 'dialog-confirm',
// title: '확인'
// }).html('<p><span class="ui-icon ui-icon-info" style="float: left; margin: 0
// 0 0 0;"></span><p class="content">1</p></p>').appendTo('body');
// }
//
// top.$( "#dialog-confirm p.content" ).html(msg);
// top.$( "#dialog-confirm" ).dialog({
// resizable: false,
// modal: true,
// buttons: {
// "예": function() {
// top.$( this ).dialog( "close" );
// if( successFunction ) successFunction.call();
//
// },
// "아니요": function() {
// top.$( this ).dialog( "close" );
// if( failFunction ) failFunction.call();
// }
// }
// });
// }

// datepicker 기본설정
$.datepicker.setDefaults({
    showOn: "both",
    buttonImage: "/common/images/common/calendar.gif",
    buttonImageOnly: true,
    buttonText: "달력",
    dateFormat: "yy-mm-dd", // 날짜 포맷
    nextText: "다음", // < 버튼 Alt
    prevText: "이전", // > 버튼 Alt
    yearSuffix: "", // 연도 뒤에 나오는 글짜
    firstDay: 0, // 요일 순서
    showWeek: false, // 주를 표시
    weekHeader: "주", // 주 타이틀 텍스트
    showMonthAfterYear: true, // 연도 뒤에 달 표시
    dayNames: ["일", "월", "화", "수", "목", "금", "토"], // 요일
    dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"], // 요일
    monthNames: ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"], // 월
    monthNamesShort: ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"], // 월
    changeMonth: true, // 달 변경 가능여부
    changeYear: true, // 년도 변경 가능여부
    showButtonPanel: true,
    currentText: "오늘",
    closeText: "닫기",
    beforeShowDay: getDatePickerHoliday, // 표시되지 않을 날짜
    beforeShow: onDatePickerDateChange,
    onChangeMonthYear: onDatePickerDateChange // 날짜 변경시
});

// datepicker 휴일 처리 함수
var getDatePickerHolidays = {};

function getDatePickerHoliday(date) {
    var holiday = getDatePickerHolidays[$.datepicker.formatDate("dd", date)]; // 표시날이
    // 휴일인지
    // 체크
    if (date.getDay() == 0) return [false, 'new_sun']; // 일요일
    else if (date.getDay() == 6) return [false, 'new_sat']; // 토요일
    else if (holiday != undefined && holiday.type == 0) return [false, 'new_hol'];
    return [true, ''];
}

// datepicker 년,월 변경시 데이터 가져오기
function onDatePickerDateChange(year, month, inst) {
    getDatePickerHolidays = {};
    /*
     * var picker = this;
     * $.getJSON("/html/sample/date.html?year="+year+"&month="+month,
     * function(data) { getDatePickerHolidays = data; $(picker).datepicker(
     * "refresh" ); })
     */
    ;
}


// 시트에서 달력 열기
var _CalSheet;

function calendarOpen(sheet) {
    _CalSheet = sheet;
    if ($("#calendar").length == 0) {
        $('<div></div>', {
            id: 'calendar'
        }).appendTo('body');
        $("#calendar").css("position", "absolute");
        $("#calendar").mouseup(function(event) {
            event.stopPropagation();
        });
        $("#calendar").datepicker({
            onSelect: calendarClose
        });
    }

    $(document).mouseup(function() {
        calendarClose();
    });
    $(document).keydown(function(e) {
        if (e.keyCode == 27) calendarClose();
    });
    $(".GMVScroll>div").scroll(function() {
        calendarClose();
    });
    $(".GMHScrollMid>div").scroll(function() {
        calendarClose();
    });

    var pleft = sheet.ColLeft(sheet.GetSelectCol());
    var ptop = sheet.RowTop(sheet.GetSelectRow()) + sheet.GetRowHeight(sheet.GetSelectRow());
    var cWidth = $("#calendar").width();
    var cHeight = $("#calendar").height();
    var dWidth = $(window).width();
    var dHeight = $(window).height();

    if (dWidth < pleft + cWidth) pleft = dWidth - cWidth;
    if (dHeight < ptop + cHeight) ptop = sheet.RowTop(sheet.GetSelectRow()) - cHeight;
    if (ptop < 0) ptop = 0;

    var date = sheet.GetCellValue(sheet.GetSelectRow(), sheet.GetSelectCol());

    $("#calendar").css("top", ptop);
    $("#calendar").css("left", pleft);
    if (date.length == 8) $('#calendar').datepicker('setDate', new Date(date.substr(0, 4), parseInt(date.substr(4, 2)) - 1, date.substr(6, 2)));
    $("#calendar").show();
}


// 시트에서 달력 닫기
function calendarClose(dateText) {
    $(document).unbind("mouseup");
    $(document).unbind("keydown");
    $(".GMVScroll>div").unbind("scroll");
    $(".GMHScrollMid>div").unbind("scroll");
    if (dateText) _CalSheet.SetCellValue(_CalSheet.GetSelectRow(), _CalSheet.GetSelectCol(), dateText);
    $("#calendar").hide();
}

function fGetXY(aTag, layerYn) {
    var oTmp = aTag;
    var pt = new Point(0, 0);
    if(layerYn == 'Y') {
        pt.x = oTmp.getBoundingClientRect().x;
        pt.y = oTmp.getBoundingClientRect().y;
    } else {
        do {
            pt.x += oTmp.offsetLeft;
            pt.y += oTmp.offsetTop;
            oTmp = oTmp.offsetParent;
        } while (oTmp.tagName != "BODY");
    }
    return pt;
}


function Point(iX, iY) {
    this.x = iX;
    this.y = iY;
}

var g_event;
$(document).keypress(function(e) {
    if (typeof(e) != "undefined")
        g_event = e;
    else
        g_event = event;
    $(document).unbind("keypress");
});

//숫자(','제외) FORMAT처리
function makeNumber(obj, type) {
    if (typeof(event) == "undefined") event = g_event; // ie외 브라우저의 event 값 캐취

    if (event.keyCode == 8 || event.keyCode == 9 || event.keyCode == 13 || (event.keyCode >= 37 && event.keyCode <= 40))
        return false;

    var ls_amt1 = obj.value;
    var ls_amt2 = "";

    switch (type) {
        case "A":
            // 숫자만
            for (var i = 0; i < ls_amt1.length + 1; i++) {
                if (ls_amt1.substring(i, i + 1) >= "0" &&
                    ls_amt1.substring(i, i + 1) <= "9") {

                    ls_amt2 = ls_amt2 + ls_amt1.substring(i, i + 1);
                }
            }
            break;
        case "B":
            // 숫자(-부호 포함)
            for (var i = 0; i < ls_amt1.length + 1; i++) {
                if (ls_amt1.substring(i, i + 1) >= "0" &&
                    ls_amt1.substring(i, i + 1) <= "9" ||
                    ls_amt1.substring(i, i + 1) == "-") {

                    ls_amt2 = ls_amt2 + ls_amt1.substring(i, i + 1);
                }
            }
            break;
        case "C":
            // 숫자(소수점 포함)
            for (var i = 0; i < ls_amt1.length + 1; i++) {
                if (ls_amt1.substring(i, i + 1) >= "0" &&
                    ls_amt1.substring(i, i + 1) <= "9" ||
                    ls_amt1.substring(i, i + 1) == ".") {

                    ls_amt2 = ls_amt2 + ls_amt1.substring(i, i + 1);
                }
            }
            break;
        case "D":
            // 숫자(-부호/소수점 포함)
            for (var i = 0; i < ls_amt1.length + 1; i++) {
                if (ls_amt1.substring(i, i + 1) >= "0" &&
                    ls_amt1.substring(i, i + 1) <= "9" ||
                    ls_amt1.substring(i, i + 1) == "." ||
                    ls_amt1.substring(i, i + 1) == "-") {

                    ls_amt2 = ls_amt2 + ls_amt1.substring(i, i + 1);
                }
            }
            break;
    }

    obj.value = ls_amt2;
    return (true);
}

function addLayerClass() {
    $('.ui-autocomplete').addClass('layer-autocomplete');
}
/**
 * IBsheet의 Auto_complete
 *
 * $(Sheet오브젝트).sheetAutocomplete(paramObj);
 * pGubun = sheetAutocomplete.
 *
 * @param Columns (Object array) : 자동완성 초기화 Object. 시트내 여러 컬럼에 적용할 수 있도록 Array로 받는다.
 *
 * Columns Object
 * @param ColSaveName (String) : 자동완성을 사용할 컬럼 SaveName (Default: name)
 * @param SearchType (String) : 자동완성 검색타입. Employee:사원검색 (Default: Employee) 미구현
 * @param RenderItem (Function) : 자동완성시 출력될 박스 포맷. (Default: sheetEmpRenderItem함수)
 * @param CallbackFunc (Function) : 콜백함수. (Default: getReturnValue함수. pGubun = sheetAutocomplete. jsp상에 gPRow변수가 선언되어 있어야 함.)
 * @param DisableColumn (String) : 자동완성 비활성화 여부를 체크하는 CheckBox컬럼의 SaveName. 체크되어 있는 Row의 자동완성은 비활성화 된다.
 * @returns
 *
 * by jayk
 */
(function($) {

	var _autoCompObj = {
		Columns: [{
			ColSaveName: "name",
			SearchType: "Employee",
			RenderItem: sheetEmpRenderItem
		}]
	}

	$.fn.sheetAutocomplete = function(paramObj) {
	    this.each(function(idx, obj) {
	        var sheet = obj;
	        var cols = _autoCompObj.Columns;

	        if(paramObj != undefined){
	            for(var i in paramObj.Columns) {
	                var col = $.extend({
	                    ColSaveName: "name",
	                    SearchType: "Employee",
	                    RenderItem: sheetEmpRenderItem
	                }, paramObj.Columns[i]);
	                if(col.CallbackFunc == undefined) col.CallbackFunc = new Function( "return getReturnValue" )();

	                col.ColNumber = sheet.SaveNameCol(col.ColSaveName);

	                _autoCompObj.Columns[i] = col;
	            }
	        }
	        if(_autoCompObj.Columns[0].CallbackFunc == undefined) _autoCompObj.Columns[0].CallbackFunc = new Function( "return getReturnValue" )();
	        if(_autoCompObj.Columns[0].ColNumber == undefined)  _autoCompObj.Columns[0].ColNumber = sheet.SaveNameCol(_autoCompObj.Columns[0].ColSaveName);

	        var keywordInputId = "sheetACKeyword";

	        // Add wheel event handler for autocomplete menu
	        $(document).on('mouseenter', '.ui-autocomplete', function() {
	            $(this).css('pointer-events', 'auto');
	        });

	        // wheel 이벤트를 direct binding으로 변경하고 이벤트 전파 중지
	        $(document).on('wheel', '.ui-autocomplete', function(e) {
	            e.stopPropagation();
	            e.preventDefault();
	            
	            const delta = e.originalEvent.deltaY;
	            const scrollTop = $(this).scrollTop();
	            
	            $(this).scrollTop(scrollTop + delta);
	            return false;
	        });

	        // 터치 이벤트도 동일하게 처리
	        $(document).on('touchstart touchmove touchend', '.ui-autocomplete', function(e) {
	            e.stopPropagation();
	            e.preventDefault();
	            return false;
	        });

	        // CSS를 JavaScript로 직접 적용
	        const applyStyles = () => {
	            $('.ui-autocomplete').css({
	                'position': 'absolute',
	                'z-index': '9999',
	                'overflow-y': 'auto',
	                'overflow-x': 'hidden',
	                'pointer-events': 'auto'
	            });
	        };

	        // Mutation Observer를 사용하여 동적으로 추가되는 요소에도 스타일 적용
	        const observer = new MutationObserver((mutations) => {
	            mutations.forEach((mutation) => {
	                if (mutation.addedNodes.length) {
	                    applyStyles();
	                }
	            });
	        });

	        observer.observe(document.body, {
	            childList: true,
	            subtree: true
	        });

	        var scriptTxt = "", fnEventScript, startIdx, fnScriptPre, fnScriptPost;
	        scriptTxt += "<script>\n";
	        
	        // 이미 해당 시트에 _OnBeforeEdit 이벤트가 설정되어 있는 경우 기 선언된 함수의 내용중에 삽입 처리함.
	        if( window[sheet.id + "_OnBeforeEdit"] && window[sheet.id + "_OnBeforeEdit"] != null ) {
	            fnEventScript = window[sheet.id + "_OnBeforeEdit"].toString();
	            if( fnEventScript.indexOf("try{") > -1 ) {
	                startIdx = fnEventScript.indexOf("try{") + 4;
	            } else if(fnEventScript.indexOf("try {") > -1) {
	                startIdx = fnEventScript.indexOf("try {") + 5;
	            } else {
	                startIdx = fnEventScript.indexOf("{") + 1;
	            }
	            fnScriptPre  = fnEventScript.substring(0, startIdx);
	            fnScriptPost = fnEventScript.substring(startIdx, fnEventScript.length);
	            
	            scriptTxt += fnScriptPre + "\n";
	            for(var i in cols) {
	                scriptTxt += "\n";
	                if(cols[i].DisableColumn != undefined) scriptTxt += " if("+ sheet.id +".GetCellValue(Row, '"+ cols[i].DisableColumn +"') == 0) {\n";
	                scriptTxt += "if( Col == '" + cols[i].ColNumber + "' ) {\n";
	                scriptTxt += " autoCompleteInit('" + cols[i].ColNumber + "'," + sheet.id + ",Row,Col, '"+ keywordInputId +"', "+ cols[i].RenderItem +", "+ cols[i].CallbackFunc +");\n";
	                scriptTxt += "}\n";
	                if(cols[i].DisableColumn != undefined) scriptTxt += "}\n";
	            }
	            scriptTxt += "\n" + fnScriptPost;
	        } else {
	            scriptTxt += "function " + sheet.id + "_OnBeforeEdit(Row, Col) {\n";
	            scriptTxt += "  try{\n";
	            for(var i in cols) {
	                scriptTxt += "\n";
	                if(cols[i].DisableColumn != undefined) scriptTxt += " if("+ sheet.id +".GetCellValue(Row, '"+ cols[i].DisableColumn +"') == 0) {\n";
	                scriptTxt += "if( Col == '" + cols[i].ColNumber + "' ) {\n";
	                scriptTxt += " autoCompleteInit('" + cols[i].ColNumber + "'," + sheet.id + ",Row,Col, '"+ keywordInputId +"', "+ cols[i].RenderItem +", "+ cols[i].CallbackFunc +");\n";
	                scriptTxt += "}\n";
	                if(cols[i].DisableColumn != undefined) scriptTxt += "}\n";
	            }
	            scriptTxt += "  }catch(e){\n";
	            scriptTxt += "      alert(\"[" + sheet.id + "] OnBeforeEdit Err : \" + e.message);\n";
	            scriptTxt += "  }\n";
	            scriptTxt += "}\n";
	        }

	        // 이미 해당 시트에 _OnAfterEdit 이벤트가 설정되어 있는 경우 기 선언된 함수의 내용중에 삽입 처리함.
	        if( window[sheet.id + "_OnAfterEdit"] && window[sheet.id + "_OnAfterEdit"] != null ) {
	            fnEventScript = window[sheet.id + "_OnAfterEdit"].toString();
	            if( fnEventScript.indexOf("try{") > -1 ) {
	                startIdx = fnEventScript.indexOf("try{") + 4;
	            } else if(fnEventScript.indexOf("try {") > -1) {
	                startIdx = fnEventScript.indexOf("try {") + 5;
	            } else {
	                startIdx = fnEventScript.indexOf("{") + 1;
	            }
	            fnScriptPre  = fnEventScript.substring(0, startIdx);
	            fnScriptPost = fnEventScript.substring(startIdx, fnEventScript.length);
	            scriptTxt += fnScriptPre + "\n\n autoCompleteDestroy(" + sheet.id + ");\n" + fnScriptPost;
	        } else {
	            scriptTxt += "function " + sheet.id + "_OnAfterEdit(Row, Col) {\n";
	            scriptTxt += "  try{\n";
	            scriptTxt += "      autoCompleteDestroy(" + sheet.id + ");\n";
	            scriptTxt += "  }catch(e){\n";
	            scriptTxt += "      alert(\"[" + sheet.id + "] OnAfterEdit Err : \" + e.message);\n";
	            scriptTxt += "  }\n";
	            scriptTxt += "}\n";
	        }

	        // OnKeyUp 이벤트 처리
	        if( window[sheet.id + "_OnKeyUp"] && window[sheet.id + "_OnKeyUp"] != null ) {
	            fnEventScript = window[sheet.id + "_OnKeyUp"].toString();
	            if( fnEventScript.indexOf("try{") > -1 ) {
	                startIdx = fnEventScript.indexOf("try{") + 4;
	            } else if(fnEventScript.indexOf("try {") > -1) {
	                startIdx = fnEventScript.indexOf("try {") + 5;
	            } else {
	                startIdx = fnEventScript.indexOf("{") + 1;
	            }
	            fnScriptPre  = fnEventScript.substring(0, startIdx);
	            fnScriptPost = fnEventScript.substring(startIdx, fnEventScript.length);
	            
	            scriptTxt += fnScriptPre + "\n";
	            for(var i in cols) {
	                scriptTxt += " autoCompletePress('" + cols[i].ColNumber + "',"+ sheet.id +",Row,Col,KeyCode,'"+ keywordInputId +"');\n";
	            }
	            scriptTxt += "\n" + fnScriptPost;
	        } else {
	            scriptTxt += "function " + sheet.id + "_OnKeyUp(Row, Col, KeyCode, Shift) {\n";
	            scriptTxt += "  try{\n";
	            for(var i in cols) {
	                scriptTxt += "      autoCompletePress('" + cols[i].ColNumber + "',"+ sheet.id +",Row,Col,KeyCode,'"+ keywordInputId +"');\n";
	            }
	            scriptTxt += "  }catch(e){\n";
	                scriptTxt += "      alert(\"[" + sheet.id + "] OnKeyUp Err : \" + e.message);\n";
	            scriptTxt += "  }\n";
	            scriptTxt += "}\n";
	        }

	        scriptTxt += "\n</script>";

	        $(document).ready(function() {
	            sheet.SetEditArrowBehavior(2);
	            $("<form></form>", {
	                id: "empForm1",
	                name: "empForm1"
	            }).html('<input type="hidden" name="searchStatusCd" value="AA" /> <input type="hidden" id="searchEmpType" name="searchEmpType" value="I"/>')
	            .appendTo('body')
	            .append(scriptTxt);

	            // autocomplete 초기화
	            $("#" + keywordInputId).autocomplete({
	                minLength: 0,
	                position: { 
	                    my: "left top",
	                    at: "left bottom",
	                    collision: "flip"
	                },
	                open: function(event, ui) {
	                    const $menu = $(this).autocomplete("widget");
	                    applyStyles();

	                    // 메뉴가 열릴 때마다 이벤트 리스너 재설정
	                    $menu.off('wheel').on('wheel', function(e) {
	                        e.stopPropagation();
	                        e.preventDefault();
	                        
	                        const delta = e.originalEvent.deltaY;
	                        const scrollTop = $(this).scrollTop();
	                        
	                        $(this).scrollTop(scrollTop + delta);
	                        return false;
	                    });
	                }
	            });
	            
	            applyStyles();
	        });
	    });
	}
	
	//autocomplete 리스트 포맷 신규 - 직급, 재직/퇴사여부 추가
	var _autoCompObjNew = {
		Columns: [{
			ColSaveName: "name",
			SearchType: "Employee",
			RenderItem: sheetEmpRenderItemNew
		}]
	}

	$.fn.sheetAutocompleteNew = function(paramObj) {

		this.each(function(idx, obj) {
			var sheet = obj;
			var cols = _autoCompObjNew.Columns;

			if(paramObj != undefined){
				for(var i in paramObj.Columns) {
					var col = $.extend({
						ColSaveName: "name",
						SearchType: "Employee",
						RenderItem: sheetEmpRenderItemNew
					}, paramObj.Columns[i]);
					if(col.CallbackFunc == undefined) col.CallbackFunc = new Function( "return getReturnValue" )();

					col.ColNumber = sheet.SaveNameCol(col.ColSaveName);

					_autoCompObjNew.Columns[i] = col;
				}
			}
			if(_autoCompObjNew.Columns[0].CallbackFunc == undefined) _autoCompObjNew.Columns[0].CallbackFunc = new Function( "return getReturnValue" )();
			if(_autoCompObjNew.Columns[0].ColNumber == undefined)  _autoCompObjNew.Columns[0].ColNumber = sheet.SaveNameCol(_autoCompObjNew.Columns[0].ColSaveName);

			var keywordInputId = "sheetACKeyword";

		    var scriptTxt = "";
		    scriptTxt += "<script>";
		    scriptTxt += "function " + sheet.id + "_OnBeforeEdit(Row, Col) {";
		    scriptTxt += "	try{";
		    for(var i in cols) {
		    	if(cols[i].DisableColumn != undefined) scriptTxt += "    if("+ sheet.id +".GetCellValue(Row, '"+ cols[i].DisableColumn +"') == 0) ";
		    	scriptTxt += "      autoCompleteInit('" + cols[i].ColNumber + "'," + sheet.id + ",Row,Col, '"+ keywordInputId +"', "+ cols[i].RenderItem +", "+ cols[i].CallbackFunc +");";
		    }
		    scriptTxt += "	}catch(e){";
		    scriptTxt += "	 	alert(e.message);";
		    scriptTxt += "	}";
		    scriptTxt += "}";
		    scriptTxt += "";
		    scriptTxt += "function " + sheet.id + "_OnAfterEdit(Row, Col) {";
		    scriptTxt += "	try{";
		    scriptTxt += "		autoCompleteDestroy(" + sheet.id + ");";
		    scriptTxt += "	}catch(e){";
		    scriptTxt += "		alert(e.message);";
		    scriptTxt += "	}";
		    scriptTxt += "}";
		    scriptTxt += "";
		    scriptTxt += "function " + sheet.id + "_OnKeyUp(Row, Col, KeyCode, Shift) {";
		    scriptTxt += "	try{";
		    scriptTxt += "		if (KeyCode == 38){";
		    scriptTxt += "		" + sheet.id + ".SelectCell(Row-1, Col, { 'Edit' : 1 });";
		    scriptTxt += "		}else if (KeyCode == 40){";
		    scriptTxt += "		" + sheet.id + ".SelectCell(Row+1, Col, { 'Edit' : 1 });";
		    scriptTxt += "		}else{";
		    for(var i in cols) {
		    	scriptTxt += "      autoCompletePress('" + cols[i].ColNumber + "',"+ sheet.id +",Row,Col,KeyCode,'"+ keywordInputId +"');";
		    }
		    scriptTxt += "		}";

		    scriptTxt += "	}catch(e){";
		    scriptTxt += "		alert(e.message);";
		    scriptTxt += "	}";
		    scriptTxt += "}";
		    scriptTxt += "</script>";

		    $(document).ready(function() {
		    	sheet.SetEditArrowBehavior(2);
		        $("<form></form>", {
		            id: "empForm1",
		            name: "empForm1"
		        }).html('<input type="hidden" name="searchStatusCd" value="AA" /> <input type="hidden" id="searchEmpType" name="searchEmpType" value="I"/>').appendTo('body')
		        .append(scriptTxt);
		    });
		});
	}

    //autocomplete 레이어 팝업용 리스트 포맷
    var _autoCompObjLayer = {
        Columns: [{
            ColSaveName: "name",
            SearchType: "Employee",
            RenderItem: sheetEmpRenderItemLayer
        }]
    }

    $.fn.sheetAutocompleteLayer = function(paramObj) {

        this.each(function(idx, obj) {
            var sheet = obj;
            var cols = _autoCompObjLayer.Columns;

            if(paramObj != undefined){
                for(var i in paramObj.Columns) {
                    var col = $.extend({
                        ColSaveName: "name",
                        SearchType: "Employee",
                        RenderItem: sheetEmpRenderItemLayer
                    }, paramObj.Columns[i]);
                    if(col.CallbackFunc == undefined) col.CallbackFunc = new Function( "return getReturnValue" )();

                    col.ColNumber = sheet.SaveNameCol(col.ColSaveName);

                    _autoCompObjLayer.Columns[i] = col;
                }
            }
            if(_autoCompObjLayer.Columns[0].CallbackFunc == undefined) _autoCompObjLayer.Columns[0].CallbackFunc = new Function( "return getReturnValue" )();
            if(_autoCompObjLayer.Columns[0].ColNumber == undefined)  _autoCompObjLayer.Columns[0].ColNumber = sheet.SaveNameCol(_autoCompObjLayer.Columns[0].ColSaveName);

            var keywordInputId = "sheetACKeyword";

            var scriptTxt = "";
            scriptTxt += "<script>";
            scriptTxt += "addLayerClass();"; // z-index 조절을 위해 class 추가
            scriptTxt += "function " + sheet.id + "_OnBeforeEdit(Row, Col) {";
            scriptTxt += "	try{";
            for(var i in cols) {
                if(cols[i].DisableColumn != undefined) scriptTxt += "    if("+ sheet.id +".GetCellValue(Row, '"+ cols[i].DisableColumn +"') == 0) ";
                scriptTxt += "      autoCompleteInit('" + cols[i].ColNumber + "'," + sheet.id + ",Row,Col, '"+ keywordInputId +"', "+ cols[i].RenderItem +", "+ cols[i].CallbackFunc +", 'Y');";
            }
            scriptTxt += "	}catch(e){";
            scriptTxt += "	 	alert(e.message);";
            scriptTxt += "	}";
            scriptTxt += "}";
            scriptTxt += "";
            scriptTxt += "function " + sheet.id + "_OnAfterEdit(Row, Col) {";
            scriptTxt += "	try{";
            scriptTxt += "		autoCompleteDestroy(" + sheet.id + ");";
            scriptTxt += "	}catch(e){";
            scriptTxt += "		alert(e.message);";
            scriptTxt += "	}";
            scriptTxt += "}";
            scriptTxt += "";
            scriptTxt += "function " + sheet.id + "_OnKeyUp(Row, Col, KeyCode, Shift) {";
            scriptTxt += "	try{";
            scriptTxt += "		if (KeyCode == 38){";
            scriptTxt += "		" + sheet.id + ".SelectCell(Row-1, Col, { 'Edit' : 1 });";
            scriptTxt += "		}else if (KeyCode == 40){";
            scriptTxt += "		" + sheet.id + ".SelectCell(Row+1, Col, { 'Edit' : 1 });";
            scriptTxt += "		}else{";
            for(var i in cols) {
                scriptTxt += "      autoCompletePress('" + cols[i].ColNumber + "',"+ sheet.id +",Row,Col,KeyCode,'"+ keywordInputId +"');";
            }
            scriptTxt += "		}";

            scriptTxt += "	}catch(e){";
            scriptTxt += "		alert(e.message);";
            scriptTxt += "	}";
            scriptTxt += "}";
            scriptTxt += "</script>";

            $(document).ready(function() {
                sheet.SetEditArrowBehavior(2);
                $("<form></form>", {
                    id: "empForm1",
                    name: "empForm1"
                }).html('<input type="hidden" name="searchStatusCd" value="AA" /> <input type="hidden" id="searchEmpType" name="searchEmpType" value="I"/>').appendTo('body')
                    .append(scriptTxt);
            });
        });
    }

}(jQuery));

var intervalDestory;
// autocomplete 생성
function autoCompleteInit(opt, sheet, Row, Col, keywordInputId, renderItem, callBackFunc, layerYn) {
    if (Col != opt) return;

    //자동완성 List form
    var autocompRenderItem = renderItem;
    var callBackFunctionItem = callBackFunc;

	//console.log('autoCompleteDiv', $("#autoCompleteDiv").length, 'callBackFunc', callBackFunc.toString());

    if ($("#autoCompleteDiv").length == 0) {
        $('<div></div>', {
            id: "autoCompleteDiv"
        }).html("<input id='"+ keywordInputId +"' name='searchKeyword' type='text' />").appendTo('#empForm1');
    } else {
        $("#"+ keywordInputId).autocomplete("destroy");
    }

    $("#"+ keywordInputId).autocomplete({
        source: function(request, response) {
            $.ajax({
                url: "/Employee.do?cmd=employeeList",
                dateType: "json",
                type: "post",
                data: $("#empForm1").serialize(),
                success: function(data) {
                    response($.map(data.DATA, function(item) {
                        return {
                            label: item.empSabun + ", " + item.enterCd + ", " + item.enterNm,
                            searchNm: $("#"+ keywordInputId).val(),
                            enterNm: item.enterNm, // 회사명
                            enterCd: item.enterCd, // 회사코드
                            name: item.empName, // 사원명
                            sabun: item.empSabun, // 사번
                            empYmd: item.empYmd, // 입사일
                            orgCd: item.orgCd, // 조직코드
                            orgNm: item.orgNm, // 조직명
                            jikchakCd: item.jikchakCd, // 직책코드
                            jikchakNm: item.jikchakNm, // 직책명
                            jikgubCd: item.jikgubCd, // 직급코드
                            jikgubNm: item.jikgubNm, // 직급명
                            jikweeCd: item.jikweeCd, // PAYBAND
                            jikweeNm: item.jikweeNm, // PAYBAND
                            resNo: item.resNo, // 주민번호
                            resNoStr: item.resNoStr, // 주민번호 앞자리
                            statusCd: item.statusCd, // 재직/퇴직
                            statusNm: item.statusNm, // 재직/퇴직
                            value: item.empName,
                            callBackFunc : callBackFunctionItem
                        };
                    }));
                }
            });
        },
		autoFocus: true,
        minLength: 1,
        focus: function() {
            return false;
        },
        open: function() {
            $(this).removeClass("ui-corner-all").addClass("ui-corner-top");
        },
        close: function() {
            $(this).removeClass("ui-corner-top").addClass("ui-corner-all");
        }
    }).data("uiAutocomplete")._renderItem = autocompRenderItem;

    //autocomplete 선택되었을 때 Event Handler
    $("#autoCompleteDiv").off("autocompleteselect");
    $("#autoCompleteDiv").on("autocompleteselect", function(event, ui) {
    	var row = Row;
        sheet.SetCellText(Row, Col, ui.item.value);

        $("#autoCompleteInput").val("");
        autoCompleteDestroy(sheet);

        //상세 데이터 가져오기
        var params = "searchEnterCd="+ ui.item.enterCd
        		   + "&selectedUserId="+ ui.item.sabun 
        		   + "&searchStatusCd="+ 'AA';
        var data = ajaxCall("/Employee.do?cmd=getBaseEmployeeDetail",params,false);

        //직원을 선택시 Data Return

        var returnFunc1 = ui.item.callBackFunc;

        if(typeof returnFunc1 != "undefined") {
        	gPRow = row;
        	pGubun = "sheetAutocomplete";
        	data.map.Col = Col;
        	returnFunc1( paramMapToJson(data.map) );
        }

    });

    $(".GMVScroll>div").scroll(function() {
        destroyAutoComplete(sheet);
    });
    $(".GMHScrollMid>div").scroll(function() {
        destroyAutoComplete(sheet);
    });

    var pleft = sheet.ColLeft(sheet.GetSelectCol());
    var ptop = sheet.RowTop(sheet.GetSelectRow()) + sheet.GetRowHeight(sheet.GetSelectRow());
    //건수정보 표시줄의 높이 만큼.
    if (sheet.GetCountPosition() == 1 || sheet.GetCountPosition() == 2) ptop += 13;

    //var point = fGetXY(document.getElementById("DIV_" + sheet.id), layerYn);
    
    var point;

    if (document.getElementById("DIV_" + sheet.id)) {
        point = fGetXY(document.getElementById("DIV_" + sheet.id), layerYn);
    } else if (document.getElementById(sheet.id + "-wrap")) {
        point = fGetXY(document.getElementById(sheet.id + "-wrap"), layerYn);
    } else {
        point = new Point(0, 0); // 기본 좌표 설정
    }
    
    var left = point.x + pleft;
    var top = point.y + ptop - 17;

    //자동완성 박스 사이즈
    var cWidth = 420;
    var cHeight = 104;
    var dWidth = $(window).width();
    var dHeight = $(window).height();

    if (dWidth < left + cWidth) left = dWidth - cWidth;
    if (dHeight < top + cHeight) top = top - cHeight - 28;
    if (top < 0) top = 0;

    $("#autoCompleteDiv").css("left", left + "px");
    $("#autoCompleteDiv").css("top", top + "px");

    console.log(layerYn);
    if(layerYn == 'Y') {
        console.log($('.ui-autocomplete'));
        addLayerClass();
    }

    clearTimeout(intervalDestory);
    sheet.$beforeEditEnterBehavior = sheet.GetEditEnterBehavior();
    sheet.SetEditEnterBehavior("none");
}

//autocomplete 키보드 이벤트
function autoCompletePress(opt, sheet, Row, Col, code, keywordInputId) {
    if (Col != opt) return;

    //IBsheet에서 입력된 값을 가져와 자동완성에 넘김
    var e = jQuery.Event("keydown");
    e.keyCode = code;
    $("#"+ keywordInputId).trigger(e);

    //IBsheet input tag의 속성 - id:_editInput# class:GMEditInput
    if( $( "#_editInput"+ sheet.Index ).length != 0 ) {
//    	console.log(1, "#_editInput"+ sheet.Index, $( "#_editInput"+ sheet.Index ).val(), $(".GMEditInput").length);
    	$("#"+ keywordInputId).val($( "#_editInput"+ sheet.Index ).val());
    } else {
    	//id:_editInput# 가 없는 경우도 있다. 그럴 경우 class:GMEditInput 로 검색
//    	console.log(2, $(".GMEditInput").length, $(".GMEditInput").val());
    	$("#"+ keywordInputId).val($(".GMEditInput.IBSheetFont"+ sheet.Index).val());
    }
}

// autocomplete 제거
function autoCompleteDestroy(sheet) {
	clearTimeout(intervalDestory);
    intervalDestory = setTimeout(function() {
        destroyAutoComplete(sheet);
    }, 200);
}

//autocomplete 제거
function destroyAutoComplete(sheet) {
    $(".GMVScroll>div").unbind("scroll");
    $(".GMHScrollMid>div").unbind("scroll");

    $("#autoCompleteInput").autocomplete("destroy");
    $("#autoCompleteDiv").remove();

    //sheet.SetEditEnterBehavior("tab");
    sheet.SetEditEnterBehavior(sheet.$beforeEditEnterBehavior);
}

//autocomplete 리스트 포맷
function sheetEmpRenderItem(ul, item) {
	return $("<li />")
        .data("item.autocomplete", item)
        .append("<a class='employeeLIst'>"
            +"<div class='inner-wrap'>"
            +"<img style='height: 50px; width: 50px; border-radius: 50%;' src='EmpPhotoOut.do?enterCd="+ item.enterCd + "&searchKeyword="+item.sabun+"&t="+(new Date()).getTime()+"'>"
            +"<span class='name'>"+String(item.name).split(item.searchNm).join('<b class="f_blue f_bold">'+item.searchNm+'</b>')+"<br/>"+item.enterNm+"</span><span class='sabun'>["+String(item.sabun).split(item.searchNm).join('<b class="f_gray_3 f_bold">'+item.searchNm+'</b>')+"]<br/>"+item.orgNm+"</span><span>"+item.jikweeNm+"</span>"
            +"<span class='ml-auto status'>"+item.statusNm+"</span>"
            +"</div>"
            +"</a>").appendTo(ul);
}

//autocomplete 리스트 포맷 신규 - 직급, 재직/퇴사여부 추가
//function sheetEmpRenderItemNew(ul, item) {
//    return $("<li />")
//        .data("item.autocomplete", item)
//        .append("<a class='autocomplete' style='width:400px;'>" +
//            "<span style='width:40px;'>" + String(item.name).split(item.searchNm).join('<b>' + item.searchNm + '</b>') + "</span>" +
//            "<span style='width:90px;'>" + item.sabun + "</span>" +
//            "<span style='width:80px;'>" + item.orgNm + "</span>" +
//            "<span style='width:40px;'>" + item.jikgubNm + "</span>" +
//            "<span style='width:40px;'>" + item.statusNm + "</span>" +
//            "</a>").appendTo(ul);
//}

function sheetEmpRenderItemNew(ul, item) {
	return $("<li />")
	.data("item.autocomplete", item)
	.append("<a class='employeeLIst'>"
	+"<div class='inner-wrap'>"
	+"<span class='name'>"+String(item.name).split(item.searchNm).join('<b class="f_blue f_bold">'+item.searchNm+'</b>')+"</span><span class='sabun'>["+item.sabun+"]</span><span>"+item.jikgubNm+"</span>"
	+"<span class='ml-auto status'>"+item.statusNm+"</span>"
	+"</div>"
	+"<span>"+item.orgNm+"</span>"
	+"</a>").appendTo(ul);
}

//autocomplete 레이어팝업용 리스트 포맷
function sheetEmpRenderItemLayer(ul, item) {
    return $("<li />")
        .data("item.autocomplete", item)
        .append("<a class='employeeLIst layer'>"
            +"<div class='inner-wrap'>"
            +"<img style='height: 50px; width: 50px; border-radius: 50%;' src='EmpPhotoOut.do?enterCd="+ item.enterCd + "&searchKeyword="+item.sabun+"&t="+(new Date()).getTime()+"'>"
            +"<span class='name'>"+String(item.name).split(item.searchNm).join('<b class="f_blue f_bold">'+item.searchNm+'</b>')+"<br/>"+item.enterNm+"</span><span class='sabun'>["+String(item.sabun).split(item.searchNm).join('<b class="f_gray_3 f_bold">'+item.searchNm+'</b>')+"]<br/>"+item.orgNm+"</span><span>"+item.jikweeNm+"</span>"
            +"<span class='ml-auto status'>"+item.statusNm+"</span>"
            +"</div>"
            +"</a>").appendTo(ul);
}

/**
 * Map 형태의 변수를 Json string으로 변환
 *
 * @param args (Map) : 변환할 변수
 * @returns json string
 *
 * by jayk
 */
function paramMapToJson(args) {
	var json = "";
	var i = 0;

	for(key in args) {
		if(key != "contains"){
			if(typeof args[key] == "object") {
				alert("arguments 값이 object 입니다.");
				return;
			}

			if(typeof args[key] != 'undefined' && args[key] != null) {
				args[key] = args[key].toString().replace(/\"/gi,'\\"');
				args[key] = args[key].toString().replace(/'/gi,"\'");
				args[key] = args[key].toString().replace(/\r\n/gi,"\n");
				args[key] = args[key].toString().replace(/\n/gi,"\\n");
				args[key] = args[key].toString().replace(/\t/gi,"    ");
			}

			json = json + ((i==0) ? "\"" : ",\"") +[key]+"\":\""+args[key]+"\"";
		}
		i++;
	}

	return json;
}

/**
 * IBSheet AutoComplete 끝.
 */


function getMultiSelect(val) {
    if (val == null || val == "") return "";
    if (val.indexOf("m") == -1) return val+","; // 선택된 값이 한개일 경우 Dao에서 배열로 바뀌지 않아서 오류남 콤마 추가 2023.11.02
    //return "'" + String(val).split(",").join("','") + "'";
    return val;
}

// 인풋박스의 입력값을 byte단위로 제한하는 jquery 플러그인
// $("인풋").maxbyte(10)
(function($) {
    $.fn.extend({
        maxbyte: function(options) {
            var defaults = {
                maxbyte: options
            };
            var options = $.extend(defaults, options);
            return this.each(function() {
                var obj = $(this);

                obj.keyup(function(e) {
                    var ls_str = $(this).val();
                    var li_str_len = ls_str.length; //전체길이

                    //변수초기화
                    var li_max = options.maxbyte; //제한할 글자수 크기
                    var i = 0;
                    var li_byte = 0; //한글일경우 3, 그외글자는 1을 더함
                    var li_len = 0; // substring하기 위해 사용
                    var ls_one_char = ""; //한글자씩 검사
                    var ls_str2 = ""; //글자수를 초과하면 제한한 글자전까지만 보여줌.

                    for (i = 0; i < li_str_len; i++) {
                        ls_one_char = ls_str.charAt(i); //한글자 추출
                        if (escape(ls_one_char).length > 4) li_byte += 3; //한글이면 2를 더한다
                        else li_byte++; //한글아니면 1을 다한다

                        if (li_byte <= li_max) li_len = i + 1;
                    }

                    if (li_byte > li_max) {
                    	alert(li_max + "byte이상 입력할 수 없습니다.");
                        ls_str2 = ls_str.substr(0, li_len);
                        $(this).val(ls_str2);
                    }
                });
                // 초기에 값입력된 값을 설정한다.
                obj.keyup();
            });
        }
    });
})(jQuery);


//주민번호 7번째 자리의 규칙 ########################
//1800년대: 남자 9, 여자 0
//1900년대: 남자 1, 여자 2
//2000년대: 남자 3, 여자 4
//2100년대: 남자 5, 여자 6
//외국인 등록번호: 남자 7, 여자 8

//주민번호, 외국인 등록번호의  validation 체크 함수
function isValid_socno(socno) {

    var socnoStr = socno.toString();
    a = socnoStr.substring(0, 1);
    b = socnoStr.substring(1, 2);
    c = socnoStr.substring(2, 3);
    d = socnoStr.substring(3, 4);
    e = socnoStr.substring(4, 5);
    f = socnoStr.substring(5, 6);
    g = socnoStr.substring(6, 7);
    h = socnoStr.substring(7, 8);
    i = socnoStr.substring(8, 9);
    j = socnoStr.substring(9, 10);
    k = socnoStr.substring(10, 11);
    l = socnoStr.substring(11, 12);
    m = socnoStr.substring(12, 13);
    month = socnoStr.substring(2, 4);
    day = socnoStr.substring(4, 6);
    socnoStr1 = socnoStr.substring(0, 7);
    socnoStr2 = socnoStr.substring(7, 13);
    socnoStr3 = socnoStr.substr(7, 2);

    if (g == 5 || g == 6 || g == 7 || g == 8) {

        var sum = 0;
        /*
        		var odd = 0;
        		buf = new Array(13);
        		for (i = 0; i < 13; i++) buf[i] = parseInt(socno.charAt(i));
        */
        if (Number(socnoStr3) % 2 != 0) {
            return false;
        }

        for (var i = 0; i < 12; i++) {
            sum += Number(socnoStr.substr(i, 1)) * ((i % 8) + 2);
        }

        if ((((11 - (sum % 11)) % 10 + 2) % 10) == Number(socnoStr.substr(12, 1))) {
            return true;
        } else {
            return false;
        }
        /*
        		odd = buf[7]*10 + buf[8];

        		if (odd%2 != 0) {
        		return false;
        		}
        		if ((buf[11] != 6)&&(buf[11] != 7)&&(buf[11] != 8)&&(buf[11] != 9)) {
        		return false;
        		}

        		multipliers = [2,3,4,5,6,7,8,9,2,3,4,5];
        		for (i = 0, sum = 0; i < 12; i++) sum += (buf[i] *= multipliers[i]);


        		sum=11-(sum%11);

        		if (sum>=10) sum-=10;

        		sum += 2;

        		if (sum>=10) sum-=10;

        		if ( sum != buf[12]) {
        		return false;
        		}
        		else {
        		return true;
        		}
         */
    } else {



        // 월,일 Validation Check
        if (month <= 0 || month > 12) {
            return false;
        }
        if (day <= 0 || day > 31) {
            return false;
        }

        // 주민등록번호에 공백이 들어가도 가입이 되는 경우가 발생하지 않도록 한다.
        if (isNaN(socnoStr1) || isNaN(socnoStr2)) {
            return false;
        }

        temp = a * 2 + b * 3 + c * 4 + d * 5 + e * 6 + f * 7 + g * 8 + h * 9 + i * 2 + j * 3 + k * 4 + l * 5;
        temp = temp % 11;
        temp = 11 - temp;
        temp = temp % 10;

        if (temp == m) {
            return true;
        } else {
            return false;
        }
    }
}

function Num_Comma(obj) {
    str = obj.value;
    s = new String(str);

    s = s.replace(/\D/g, "");

    if (s.substr(0, 1) == 0) {
        s = s.substr(1);
    }

    l = s.length - 3;
    while (l > 0) {
        s = s.substr(0, l) + "," + s.substr(l);
        l -= 3;
    }

    obj.value = s;
}

function cc(obj, color) {
    obj.style.backgroundColor = color;
}

function checknum(num) {
    var s = new String(num.value);
    s = s.replace(/\D/g, "");
    var val = "-0123456789";
    var string = num.value;
    var len = string.length;
    for (i = 0; i < len; i++) {
        if (val.indexOf(string.substring(i, i + 1)) < 0) {
            num.value = s;
            return;
        }
    }
}

function openWindow(url, name, width, height) {
    var top = screen.height / 2 - height / 2 - 50;
    var left = screen.width / 2 - width / 2;
    var win = open(url, name, 'width=' + width + ',height=' + height + ',top=' + top + ',left=' + left + ',scrollbars=yes,resizable=yes,status=yes,toolbar=no,menubar=no');
}

// ****************************************************************************
// Char c가 영문자 인지 체크
// RETURN : true/false
// ***************************************************************************
function isLetterChar(c) {
    return (((c >= "a") && (c <= "z")) || ((c >= "A") && (c <= "Z")));
}

// ****************************************************************************
// Char c가 숫자 인지 체크
// RETURN : true/false
// ***************************************************************************
function isDigitChar(c) {
    return ((c >= "0") && (c <= "9"));
}
// ****************************************************************************
// Char C가 whitechar 인지 체크
// ****************************************************************************
function isWhiteChar(c) {
    return (c == ' ' || c == '\t' || c == '\n' || c == '\r');
}
// ****************************************************************************
// * char ch 가 한글인지 체크
// RETURN : true/false
// ****************************************************************************
function isKoreanChar(ch) {
    var chStr = escape(ch); // ISO-Latin-1 문자셋으로 변경
    if (chStr.length < 2)
        return false;

    // 한글 ==> %uAC00 ~ %uD7A3
    if (chStr.substring(0, 2) == '%u') {
        if (chStr.substring(2, 4) == '00')
            return false;
        else
            return true; // 한글
    } else if (chStr.substring(0, 1) == '%') {
        if (parseInt(chStr.substring(1, 3), 16) > 127)
            return true; // 한글
        else
            return false;
    } else return false;
}
// ************************************************
// str 이 공백이나 NULL 이면 TRUE 아니면 FALSE *
// ************************************************
function isEmpty(str) {
    if (str != null) {
        for (i = 0; i < str.length; i++) {
            if (!isWhiteChar(str.charAt(i)))
                return false;
        }
    }
    return ((str == null) || (str.length == 0));
}
// ****************************************************************************
// str 이 공백이나 텝 , 리턴 문자들로 실제문자가 없을경우 TRUE 아니면 FALSE *
// ****************************************************************************
function isWhitespace(str) {
    var whitespace = " \t\n\r";
    var i;
    if (isEmpty(str)) {
        return true;
    }
    for (i = 0; i < str.length; i++) {
        var chr = str.charAt(i);
        if (whitespace.indexOf(chr) == -1) {
            return false;
        }
    }
    return true;
}
// ***************************************************************************
// strnumber가 유효한 숫자타입인지 체크
// 파라메터 : strnumber(체크할 문자열)
// exceptstr(숫자이외에 허용 가능한 문자열)
// RETURN : true/false
// ****************************************************************************
function isNumber(strnumber, exceptstr) {
    var i, j;

    for (i = 0; i < strnumber.length; i++) {
        if (isDigitChar(strnumber.charAt(i)))
            continue;
        for (j = 0; j < exceptstr.length; j++) {
            if (strnumber.charAt(i) == exceptstr.charAt(j))
                break;
        }
        if (j == exceptstr.length)
            return false;
    }

    return true;
}

// ****************************************************************************
// str 이 영문,숫자 조합으로 strSize 보다 작은지 체크
// RETURN : true/false
// ***************************************************************************
function isAlphaNumeric(str, strSize) {
    var i;

    if (str.length > strSize)
        return false

    for (i = 0; i < str.length; i++) {
        var c = str.charAt(i);
        if (!(isLetterChar(c) || isDigitChar(c)))
            return false;
    }

    return true;
}
// *****************************************************************************
// * HTML TAG 제거
// *****************************************************************************
function stripHTMLtag(string) {
    var objStrip = new RegExp();
    objStrip = /[<][^>]*[>]/gi;
    return string.replace(objStrip, "");
}

// *******************************************************************
// 년월 입력시 마지막 일자
function getEndOfMonthDay(yy, mm) {
    var max_days = 0;
    if (mm == 1) {
        max_days = 31;
    } else if (mm == 2) {
        if (((yy % 4 == 0) && (yy % 100 != 0)) || (yy % 400 == 0))
            max_days = 29;
        else
            max_days = 28;
    } else if (mm == 3) max_days = 31;
    else if (mm == 4) max_days = 30;
    else if (mm == 5) max_days = 31;
    else if (mm == 6) max_days = 30;
    else if (mm == 7) max_days = 31;
    else if (mm == 8) max_days = 31;
    else if (mm == 9) max_days = 30;
    else if (mm == 10) max_days = 31;
    else if (mm == 11) max_days = 30;
    else if (mm == 12) max_days = 31;
    else return '';
    return max_days;
}
// *********************************************************************
// 날짜 유효성 검증하는 함수
function isValidDate(strDate) {
    var retVal = true;
    if (strDate.length != 10) {
    	alert("날짜 형식이 잘못 되었습니다.\n ####-##-## or ####/##/## or ####.##.##");
        return false;
    }
    var inputDate = strDate.replace(/\-/g, '').replace(/\//g, '').replace(/\./g, '');
    var yyyy = inputDate.substring(0, 4);
    var mm = inputDate.substring(4, 6);
    var dd = inputDate.substring(6, 8);
    if (isNaN(yyyy) || parseInt(yyyy) < 1000) {
    	alert("년도는 1000 이하일수 없습니다.");
        return false;
    }
    if (isNaN(mm) || parseFloat(mm) > 12 || parseFloat(mm) < 1) {
    	alert("월의 값은 1부터 12사이의 값이 어야 합니다.");
        return false;
    }
    if (isNaN(dd) || parseFloat(dd) < 1 || (parseFloat(dd) > getEndOfMonthDay(parseFloat(yyyy.substring(2, 4)), parseFloat(mm)))) {
    	alert("일자는 해당 달 범위안이 어야합니다.\n1~31 or 1~28");
        return false;
    }
    return true;
}

/**
 * 필수값 체크
 *
 * @param id: 체크할 ID속성
 * @param msg: 필수값 아닐 시 호출 msg
 * @returns boolen
 */
function nullCheck(id, msg) {

    if ($("#" + id).val() == null || $("#" + id).val() == "") {
        alert(msg);
        $("#" + id).focus();
        return false;
    }

    return true;
}

//날짜 유효성 검증하는 함수
function isValidDateComma(strDate) {
    var retVal = true;
    var inputDate = strDate.replace(/\./g, '');

    if (inputDate.length != 8) {
        alert("날짜 형식이 잘못 되었습니다.\n ####.##.##");
        return false;
    }

    var yyyy = inputDate.substring(0, 4);
    var mm = inputDate.substring(4, 6);
    var dd = inputDate.substring(6, 8);
    if (isNaN(yyyy) || parseInt(yyyy) < 1000) {
    	alert("년도는 1000 이하일수 없습니다.");
        return false;
    }
    if (isNaN(mm) || parseFloat(mm) > 12 || parseFloat(mm) < 1) {
    	alert("월의 값은 1부터 12사이의 값이 어야 합니다.");
        return false;
    }
    if (isNaN(dd) || parseFloat(dd) < 1 || (parseFloat(dd) > getEndOfMonthDay(parseFloat(yyyy.substring(2, 4)), parseFloat(mm)))) {
    	alert("일자는 해당 달 범위안이 어야합니다.\n1~31 or 1~28");
        return false;
    }
    return true;
}

//유효월 체크
function monthCheck(val) {
    var msg = getMsgLanguage({"msgid": "msg.201706290000011", "defaultMsg":"유효한 월 형태가 아닙니다.\n01~12까지 입력 가능 합니다."});
    var pattern = /[0-9]{2}/;
    if (!pattern.test(val)) {
    	alert("월은 mm로 입력해 주세요.");
        return false;
    }


    var month = parseInt(val);

    if (month < 1 || month > 12) {
        alert(msg);
        return false;
    }
    return true;
}

function chkPattern(str, type) //형식 체크
{
    switch (type) {
        case "NUM": //숫자만
            pattern = /^[0-9]+$/;
            break;

        case "PHONE": // 전화번호 (####-####-####)
            pattern = /^[0-9]{2,4}-[0-9]{3,4}-[0-9]{4}$/;
            break;

        case "MOBILE": // 휴대전화 (0##-####-####)
            pattern = /^0[0-9]{2,3}-[0-9]{3,4}-[0-9]{4}$/;
            break;

        case "ZIPCODE": // 우편번호 (###-###)
            pattern = /^[0-9]{3}-[0-9]{3}$/;
            break;

        case "EMAIL": //메일
            //pattern = /^[._a-zA-Z0-9-]+@[._a-zA-Z0-9-]+\.[a-zA-Z]+$/;
            pattern = /^[a-zA-Z0-9._-]+@([a-zA-Z0-9.-]+\.)+[a-zA-Z]{2,4}$/;
            break;

        case "DOMAIN": //영자 숫자와	.	다음도 영자
            pattern = /^[.a-zA-Z0-9-]+.[a-zA-Z]+$/;
            break;

        case "ENG": //영자만
            pattern = /^[a-zA-Z]+$/;
            break;

        case "ENGNUM": //영자와	숫자
            pattern = /^[a-zA-Z0-9]+$/;
            break;

        case "ACCOUNT": //숫자	와 '-'
            pattern = /^[0-9-]+$/;
            break;

        case "HOST": //영자	와 '-'
            pattern = /^[a-zA-Z-]+$/;
            break;
        case "ID": //첫글자는 영자 그 뒤엔 영어숫자 6이상 15자리	이하
            //pattern = /^[a-zA-Z]{1}[a-zA-Z0-9_-]{5,15}$/;
            pattern = /^[a-zA-Z]{1}[a-zA-Z0-9]{5,15}$/;
            break;

        case "ID2": //첫글자는	영자 그뒤엔	영어숫자 4이상 15자리	이하
            pattern = /^[a-zA-Z0-9._-]+$/;
            break;

        case "DATE": //	형식 : 2002-08-15
            pattern = /^[0-9]{4}-[0-9]{2}-[0-9]{2}$/;
            break;

        case "DATE2": //	형식 : 2002-08-15
            pattern = /^[0-9]{4}.[0-9]{2}.[0-9]{2}$/;
            break;

        case "JUMIN": // 주민등록번호
            //pattern = /^[0-9]{6}-[0-9]{7}$/;
            pattern = /^[0-9]{13}$/;
            break;

        case "GRADE": // 주민등록번호
            //pattern = /^[0-9]{6}-[0-9]{7}$/;
            pattern = /^[0-9]+(.[0-9])?$/;
            break;

        default:
            return false;
    }
    return pattern.test(str);
}

//날짜 일수 구하기
function getDaysBetween(startDt, endDt) {
    if (startDt == "" || endDt == "") {
        return "";
    }

    var startDt = new Date(startDt.substring(0, 4), startDt.substring(4, 6) - 1, startDt.substring(6, 8));
    var endDt = new Date(endDt.substring(0, 4), endDt.substring(4, 6) - 1, endDt.substring(6, 8));

    return Math.floor(endDt.valueOf() / (24 * 60 * 60 * 1000) - startDt.valueOf() / (24 * 60 * 60 * 1000) + 1);

}


/*=======================================================================*
 * ajax POST 한글깨짐 방지
 *=======================================================================*/
function ajaxescape(value) {
    return escape(encodeURIComponent(value)).replace(/\+/g, '%2B');
}

//Camel변환
function convCamel(str) {
    var before = str.toLowerCase();
    var after = "";
    var bs = before.split("_");

    if (bs.length < 2) {
        return bs;
    }
    for (var i = 0; i < bs.length; i++) {
        if (bs[i].length > 0) {
            if (i == 0)
                after += bs[i].toLowerCase();
            else
                after += bs[i].toLowerCase().substr(0, 1).toUpperCase() + bs[i].substr(1, bs[i].length - 1);
        }
    }
    return after;
}

/* ----------------------------------------------------------------------------
 * 특정 날짜에 대해 지정한 값만큼 가감(+-)한 날짜를 반환
 *
 * 입력 파라미터 -----
 * pInterval : "yyyy" 는 연도 가감, "m" 은 월 가감, "d" 는 일 가감
 * pAddVal  : 가감 하고자 하는 값 (정수형)
 * pYyyymmdd : 가감의 기준이 되는 날짜
 * pDelimiter : pYyyymmdd 값에 사용된 구분자를 설정 (없으면 "" 입력)
 *
 * 반환값 ----
 * yyyymmdd 또는 함수 입력시 지정된 구분자를 가지는 yyyy?mm?dd 값
 *
 * 사용예 ---
 * 2008-01-01 에 3 일 더하기 ==> addDate("d", 3, "2008-08-01", "-");
 * 20080301 에 8 개월 더하기 ==> addDate("m", 8, "20080301", "");
--------------------------------------------------------------------------- */
function addDate(pInterval, pAddVal, pYyyymmdd, pDelimiter) {
    var yyyy;
    var mm;
    var dd;
    var cDate;
    var oDate;
    var cYear, cMonth, cDay;

    if (pYyyymmdd == "") {
        return "";
    }

    if (pDelimiter != "") {
        pYyyymmdd = pYyyymmdd.replace(eval("/\\" + pDelimiter + "/g"), "");
    }

    yyyy = pYyyymmdd.substr(0, 4);
    mm = pYyyymmdd.substr(4, 2);
    dd = pYyyymmdd.substr(6, 2);

    if (pInterval == "yyyy") {
        yyyy = (yyyy * 1) + (pAddVal * 1);
    } else if (pInterval == "m") {
        mm = (mm * 1) + (pAddVal * 1);
    } else if (pInterval == "d") {
        dd = (dd * 1) + (pAddVal * 1);
    }

    cDate = new Date(yyyy, mm - 1, dd) // 12월, 31일을 초과하는 입력값에 대해 자동으로 계산된 날짜가 만들어짐.
    cYear = cDate.getFullYear();
    cMonth = cDate.getMonth() + 1;
    cDay = cDate.getDate();

    cMonth = cMonth < 10 ? "0" + cMonth : cMonth;
    cDay = cDay < 10 ? "0" + cDay : cDay;

    //if (pDelimiter != "") {
    return cYear + pDelimiter + cMonth + pDelimiter + cDay;
    //} else {
    //	return cYear + cMonth + cDay;
    //}
}

/*************************************************************************************
left padding s with c to a total of n chars
**************************************************************************************/
function lpad(s, c, n) {
    if (!s || !c || s.length >= n) {
        return s;
    }
    var max = (n - s.length) / c.length;
    for (var i = 0; i < max; i++) {
        s = c + s;
    }
    return s;
}

function in_array(needle, haystack, argStrict) {
    // http://kevin.vanzonneveld.net
    // +   original by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
    // +   improved by: vlado houba
    // +   input by: Billy
    // +   bugfixed by: Brett Zamir (http://brett-zamir.me)
    // *     example 1: in_array('van', ['Kevin', 'van', 'Zonneveld']);
    // *     returns 1: true
    // *     example 2: in_array('vlado', {0: 'Kevin', vlado: 'van', 1: 'Zonneveld'});
    // *     returns 2: false
    // *     example 3: in_array(1, ['1', '2', '3']);
    // *     returns 3: true
    // *     example 3: in_array(1, ['1', '2', '3'], false);
    // *     returns 3: true
    // *     example 4: in_array(1, ['1', '2', '3'], true);
    // *     returns 4: false

    var key = '',
        strict = !!argStrict;

    if (strict) {
        for (key in haystack) {
            if (haystack[key] === needle) {
                return true;
            }
        }
    } else {
        for (key in haystack) {
            if (haystack[key] == needle) {
                return true;
            }
        }
    }

    return false;
}

function replaceAll(sValue, param1, param2) {
    return sValue ? sValue.split(param1).join(param2):null;
}

function checkFromToDate(fromObj, toObj, fromTxt, toTxt, dateType) {
    if (dateType == "YYYYMM") {
        var fromDate = fromObj.val().replace(/\-/g, '').replace(/\//g, '');
        var toDate = toObj.val().replace(/\-/g, '').replace(/\//g, '');

        var fromYyyy = fromDate.substring(0, 4);
        var fromMm = fromDate.substring(4, 6);
        var toYyyy = toDate.substring(0, 4);
        var toMm = toDate.substring(4, 6);

        if (fromDate.length != 6) {
        	alert("{0}을 바르게 입력하십시오.");
            fromObj.focus();
            return false;
        }
        if (toDate.length != 6) {
        	alert("{0}을 바르게 입력하십시오.");
            toObj.focus();
            return false;
        }
        if (isNaN(fromYyyy) || parseInt(fromYyyy) < 1000) {
        	alert("{0}을 바르게 입력하십시오.");
            fromObj.focus();
            return false;
        }
        if (isNaN(fromMm) || parseFloat(fromMm) > 12 || parseFloat(fromMm) < 1) {
        	alert("{0}을 바르게 입력하십시오.");
            fromObj.focus();
            return false;
        }
        if (isNaN(toYyyy) || parseInt(toYyyy) < 1000) {
        	alert("{0}을 바르게 입력하십시오.");
            toObj.focus();
            return false;
        }
        if (isNaN(toMm) || parseFloat(toMm) > 12 || parseFloat(toMm) < 1) {
        	alert("{0}을 바르게 입력하십시오.");
            toObj.focus();
            return false;
        }
        if (parseInt(fromDate) > parseInt(toDate)) {
        	alert("시작년월이 종료년월보다 큽니다.");
            toObj.focus();
            return false;
        }

    } else if (dateType == "YYYYMMDD") {
        var fromDate = fromObj.val();
        var toDate = toObj.val();

        // 일자 유효성 체크
        var rtn = isValidDate(fromDate);
        if (rtn == false) {
            fromObj.focus();
            return false;
        }
        var rtn = isValidDate(toDate);
        if (rtn == false) {
            toObj.focus();
            return false;
        }

        fromDate = fromDate.replace(/\-/g, '').replace(/\//g, '');
        toDate = toDate.replace(/\-/g, '').replace(/\//g, '');

        if (parseInt(fromDate) > parseInt(toDate)) {
        	alert("시작일이 종료일보다 큽니다.");
            toObj.focus();
            return false;
        }

    }

    return true;
}

/* location.href
 * location.replace
 * location.reload
 * => IE7,8,9 에서 referer 생성 못할때 생김
 * */

function redirect(url, target) {
    if (/MSIE (\d+\.\d+);/.test(navigator.userAgent)) {
        var referLink = document.createElement('a');
        referLink.href = url;
        referLink.target = target;
        document.body.appendChild(referLink);
        referLink.click();
    } else {
        (target == "_blank") ? window.open(url, target): $(location).attr('href', url);
    }
}
/*
 * Camel Notation, Underscore
 * under2camel('abcd_efg')=>abcdEfg
 * under2camel('ABCD_EFG')=>abcdEfg
 */
var under2camel = function(str) {
    return str.toLowerCase().replace(/(\_[a-z])/g, function(arg) {
        return arg.toUpperCase().replace('_', '');
    });
};

/*
 * Camel Notation, Underscore
 * camel2under('abcdEfg')=>ABCD_EFG
 * camel2under('abcdEFg')=>ABCD_E_FG
 */
var camel2under = function(str) {
    return str.replace(/([A-Z])/g, function(arg) {
        return "_" + arg.toLowerCase();
    }).toUpperCase();
};

//소숫점 반올림 (값, 자릿수)
function numRound(n, pos) {
    var digits = Math.pow(10, pos);

    var sign = 1;
    if (n < 0) {
        sign = -1;
    }

    // 음수이면 양수처리후 반올림 한 후 다시 음수처리
    n = n * sign;
    var num = Math.round(n * digits) / digits;
    num = num * sign;

    var str = num.toFixed(20);

    str = str.replace(/0+$/, '').replace(/\.$/, '');

    return str;
}

/**
 * Progress Bar 생성 소멸
 * bln : true , bln : false
 */
function progressBar(bln, msg) {
    if (bln == true) {
        var bodyWidth = $("body").outerWidth();
        var bodyHeight = $("body").height();
        //		var objframe =$("<iframe id='popFrame' style='width:800px; height:800px; background-color:white;' onclick='popClose();'></iframe>");
        var objframe = $("<iframe id='popFrame' style='width:800px; height:800px; background-color:white;'></iframe>");

        var objDiv = $("<div />", {
            id: 'loadingDiv1',
            click: function() {
                try{ popClose(); }catch(e){}
            },
            style: "position:absolute; width:" + bodyWidth + "px; height:" + bodyHeight + "px; top:0; z-index:1500; text-align:center; vertical-align:middle; background-color:gray;opacity: 0.4;"
        });

        var objContent = $("<div />", {
            id: "loadingDiv2",
            style: "position:absolute; top:" + (bodyHeight / 2 - 50) + "px; left:" + (bodyWidth / 2 - 150) + "px; border-radius: 20px; background-color:white; width:300px; height:70px; opacity: 1.0;  z-index:1500;text-align:center; vertical-align:middle;"
        });

        //loading 이미지가 레이어 팝업 + ibsheet combo line보다 앞서도록 설정
        var img = $("<img />", {
            id: "loadingImg",
            style: "opacity: 1.0;  z-index:1501; margin-top:15px",
            src: "/common/images/common/InfLoading.gif"
        });

        objContent.append(img);
        if( msg == undefined ){
        	objContent.append("<br/><span id='loadingText'>Loading....</span>");
        }else{
        	objContent.append("<br/><span id='loadingText'>"+msg+"</span>");
        }

        //objDiv.append(objContent) ;

        $("body").append(objDiv);
        $("body").append(objContent);
    } else {
        $("#loadingText").remove();
        $("#loadingImg").remove();
        $('#loadingDiv1').remove();
        $('#loadingDiv2').remove();
    }
}

function getInternetExplorerVersion() {
    var rv = true;
    var trident = navigator.userAgent.match(/Trident\/(\d)/i);
    /*
    IE 8 = trident/4.0
    IE 9 = trident/5.0
    IE 10 = trident/6.0
     */
    if (trident != null && trident != "null" && trident != "") {
        var ie_num = (String(trident)).split(',');

        if (ie_num[1] >= 6) { //IE9부터
            rv = true;
        } else {
            rv = false; //IE8이하 에서만 모달 팝업 사용
        }
    }

    return rv;
}


//회사변경
function setCompanyWidget() {
    $("#companyWidgetMain").click(function() {
        return false;
    });
    $("#companyMgr").click(function() {
        $(document).click();
        $("#companyWidgetMain").show();
        $(document).click(function() {
            $("#companyCancel").click();
        });
        return false;
    });
    $("#companyCancel").click(function() {
        $(document).unbind("click");
        $("#companyWidgetMain").hide();
        return false;
    });
}

//회사 조회
// function createCompanyList(gLn) {
//     var companyList = ajaxCall("/chgCompanyPopup.do", "", false).list;
//     if (companyList != "") {
//         $("#companyMgr").css("display", "inline");
//         $(companyList).each(function(idx, str) {
//             var className = str.enterCd == gLn ? "on" : "";
//             $("#companyList").append("<li companyCd=" + str.enterCd + " class=" + className + "><span>&nbsp;" + str.enterNm + "</span></li>");
//         });
//
//         $("#companyList li").click(function() {
//             var user = ajaxCall("/chgCompany.do", "company=" + $(this).attr("companyCd"), false);
//             if (user.isUser != "exist") {
//             	alert("해당 사용자로  정상적으로  로그인 할수 없습니다.");
//             }
//             redirect("/Main.do", "_top");
//         });
//     } else {
//         $("#companyMgr").css("display", "none");
//     }
// }

//input 생성
function createInput(form, id) {
    $("<input></input>", {
        id: id,
        name: id,
        type: "hidden"
    }).appendTo($("#" + form));
}


//from 생성
function createForm(id) {
    $form = $("#" + id)
    if ($form.length > 0) {
        //$form.empty();
        $form.remove();
    }
    $form = $("<form><form/>").attr({
        id: id,
        name: id,
        method: 'POST'
    });
    $(document.body).append($form);
}


/*
$(function(){var s= location.href;addListener(document.body, "copy", onStartCopy);});
function onStartCopy() {try {clearSelection();}catch (e) {}}
function clearSelection() {if (document.selection && document.selection.empty) {document.selection.empty();} else if (window.getSelection) {var sel = window.getSelection();sel.removeAllRanges();}}
function addListener( element, name, observer, useCapture ) {useCapture = useCapture || false;if (element.addEventListener) {element.addEventListener(name, observer, useCapture);}else if (element.attachEvent) {element.attachEvent('on' + name, observer);}}
function removeListener( element, name, observer, useCapture ) {useCapture = useCapture || false;if (element.removeEventListener) {element.removeEventListener(name, observer, useCapture);}else if (element.detachEvent) {element.detachEvent('on' + name, observer);}}
*/

/**
 * 세션 만료 info 페이지로 이동.
 * -. 팝업이면 모든 팝업을 닫음.
 */
function moveInfoPage(code) {
    if (top.opener != null && top.opener != undefined) { //팝업 여부
        top.opener.moveInfoPage(code);
        top.close();
    } else {
        top.location.replace("/Info.do?code=" + code);
    }
}

/**
 * ex) alertTimer("급여계산 되었습니다.", 1000, globalWindowPopup, function(){globalWindowPopup.close(); doAction1("SearchPeople");});
 */
function alertTimer(pMsg, pTime, pWin, pFn) {
    var time = pTime || 100;
    var type = $.type(pFn);
    var win = window;

    if (pWin && !pWin.closed) {
        win = pWin;
    }

    setTimeout(function() {
        win.focus();
        win.alert(pMsg);
        if (type == "function") {
            pFn();
        } else if (type == "string") {
            $.globalEval(pFn);
        }
    }, pTime);
}

/**
 *  sur 찾는 함수
 */
function getMainSurl() {
    var that = window.top;
    if (that.parent) {
        if (that.parent.$("#surl").length > 0) {
            return that.parent.$("#surl").val();
        } else {
            if (that.parent.opener) {
                return that.parent.opener.getMainSurl();
            } else {
                return that.parent.getMainSurl();
            }
        }
    }
}

/* layer pop up 151217 lee hj */
function openLayerPop(id, content) {
    var oPop = $("#" + id);
    var oPopBg = oPop.find(".layerBg");
    var oPopContent = oPop.find(".layerContent");

    oPopBg.css('height', $(document).height());
    if (content != undefined) {
        oPopContent.html(content);
    }

    oPop.show();
}

function closeLayerPop(id) {
    $("#" + id).hide();
}

/**
 * 공통 코드 조회에서 조회된 데이터를 IBsheet에서 Combo형태로 쓰는 형태로 구성 [0] name: A|B|C|D|E [1] cd:
 * 1|2|3|4|5 [2] <option value="cd">name<option>
 *
 * @param obj
 * @param str
 * @returns Array
 */
function convCodeCols(obj, cols, str) {
    // JNS 수정 : 코드 리스트가 없을 경우 empty Data 생성후 리턴
    // modify Date : 2014-01-20
    //	if (null == obj || obj == 'undefine') return false;
    //	if (obj.length < 1) return false;
    var convArray = new Array("", "", "", "", "");
    var arrCol = cols.split(' ').join("").split(",");

    if (null == obj || obj == 'undefine') {

        convArray[0] = "";
        convArray[1] = "";
        convArray[2] = "<option value='' ";
        for (ii = 0; ii < arrCol.length; ii++) {
            convArray[2] += " " + arrCol[ii] + "=''";
        }
        convArray[2] += " >" + str + "</option>";
        return convArray;
    }
    if (obj.length < 1) {

        convArray[0] = "";
        convArray[1] = "";
        convArray[2] = "<option value='' ";
        for (ii = 0; ii < arrCol.length; ii++) {
            convArray[2] += " " + arrCol[ii] + "=''";
        }
        convArray[2] += " >" + str + "</option>";
        return convArray;
    }

    if (str != "") {
        convArray[2] += "<option value='' ";
        for (ii = 0; ii < arrCol.length; ii++) {
            convArray[2] += " " + arrCol[ii] + "=''";
        }
        convArray[2] += " >" + str + "</option>";
    }

    for (i = 0; i < obj.length; i++) {
        convArray[0] += obj[i].codeNm + "|";
        convArray[1] += obj[i].code + "|";

        convArray[2] += "<option value='" + obj[i].code + "' ";
        for (ii = 0; ii < arrCol.length; ii++) {
            convArray[2] += " " + arrCol[ii] + "='" + eval("obj[i]." + arrCol[ii]) + "'";
        }
        convArray[2] += " >" + obj[i].codeNm + "</option>";

        convArray[3] += "<option value='" + obj[i].code + "' ";
        for (ii = 0; ii < arrCol.length; ii++) {
            convArray[3] += " " + arrCol[ii] + "='" + eval("obj[i]." + arrCol[ii]) + "'";
        }
        convArray[3] += " >[" + obj[i].code + "]" + obj[i].codeNm + "</option>";

        convArray[4] += "[" + obj[i].code + "]" + obj[i].codeNm + "|";
    }
    convArray[0] = convArray[0].substr(0, convArray[0].length - 1);
    convArray[1] = convArray[1].substr(0, convArray[1].length - 1);
    convArray[4] = convArray[4].substr(0, convArray[4].length - 1);

    return convArray;
}

/** 20200902 추가
 * 공통 코드 조회에서 조회된 데이터를 IBsheet에서 Combo형태로 쓰는 형태
 * Combo 초기값 지정 가능(selectValue)
 *
 * @param obj
 * @param str
 * @returns Array
 */
function convCodeForSelected(obj, str, objids, idx, selectValue){
	var result  = {};
	var result2 = {};
	var initConvArray = new Array("", "", "", "","");

	if (null == obj || obj == "undefine") {
		initConvArray[0] = "";
		initConvArray[1] = "";
		initConvArray[2] = "<option value=''>" + str + "</option>";
		initConvArray[3] = "<option value=''>" + str + "</option>";
		initConvArray[4] = "";
		return {"null":initConvArray};
	}
	if (obj.length < 1) {
		initConvArray[0] = "";
		initConvArray[1] = "";
		initConvArray[2] = "<option value=''>" + str + "</option>";
		initConvArray[3] = "<option value=''>" + str + "</option>";
		initConvArray[4] = "";
		return {"null":initConvArray};
	}
	if (str != "") {
		initConvArray[0] = str+"|";
		initConvArray[1] = str+"|";
		initConvArray[2] += "<option value=''>" + str + "</option>";
		initConvArray[3] += "<option value=''>" + str + "</option>";
	}
	for(var i in obj) {
		var convArray = new Array("", "", "", "","");
		var convArray2 = [];
		convArray[0] += obj[i].codeNm + "|";
		convArray[1] += obj[i].code + "|";

		var objCode = obj[i].code;
		if(obj[i].grcodeCd == "H20120") { // 연락처의 비상연락망관계
			objCode = obj[i].codeNm;
		}

		//if(obj[i].code == selectValue) {
		if(objCode == selectValue) {
//			convArray[2] += "<option value='" + obj[i].code +"' selected>" + obj[i].codeNm	+ "</option>";
			convArray[2] += "<option value='" + objCode +"' selected>" + obj[i].codeNm	+ "</option>";
		} else {
//			convArray[2] += "<option value='" + obj[i].code + "'>" + obj[i].codeNm	+ "</option>";
			convArray[2] += "<option value='" + objCode + "'>" + obj[i].codeNm	+ "</option>";
		}

//		convArray[3] += "<option value='" + obj[i].code + "'>[" + obj[i].code	+ "]" + obj[i].codeNm + "</option>";
//		convArray[4] += "[" + obj[i].code + "]" + obj[i].codeNm + "|";

		convArray[3] += "<option value='" + objCode + "'>[" + objCode	+ "]" + obj[i].codeNm + "</option>";
		convArray[4] += "[" + objCode + "]" + obj[i].codeNm + "|";

		if(result[obj[i].grcodeCd]){
			var tmpArray = result[obj[i].grcodeCd];
			for(var ii=0 ; ii<initConvArray.length ; ii++){
				convArray[ii] = tmpArray[ii] + convArray[ii];
			}
			convArray2 = result2[obj[i].grcodeCd];
		}else{
			for(var ii=0 ; ii<initConvArray.length ; ii++){
				convArray[ii] = initConvArray[ii] + convArray[ii];
			}

		}
		convArray2.push(obj[i]);
		result[obj[i].grcodeCd]  = (convArray);
		result2[obj[i].grcodeCd] = (convArray2);
	}

	for(var cd in result){
		result[cd][0] = result[cd][0].substr(0, result[cd][0].length - 1);
		result[cd][1] = result[cd][1].substr(0, result[cd][1].length - 1);
		result[cd][4] = result[cd][4].substr(0, result[cd][4].length - 1);
	}
	if(objids){
		for(var key in objids){
			var objids2 = objids[key];
			for(var i in objids2){
				var objid = objids2[i];
				$("#"+objid).html(result[key][idx]);
				addComboNote(result2[key], objid);
			}

		}
	}
	return result;
}

/**
 * 생성된 콤보 박스에 공통코드의 memo, note1, note2, note3 , codeEngNm
 * @param obj : json data
 * @param objId : form select id
 */
function addComboNote(obj , objId) {

	if (null == obj || obj == "undefine") return;
	if($("#"+objId)) {
		var lenOpt = $("#"+objId+" option").length;
		var lenObj = obj.length;
		var i = 0;
		if(lenOpt > lenObj) { i = -1; }
		$("#"+objId).find("option").each(function(idx){
			var data = {};
			if(lenOpt > lenObj) {
				if(idx > 0) {
					if (obj[i] != null) {
						var codeEngNm = obj[i].codeEngNm;
						var memo = obj[i].memo;
						var note1 = obj[i].note1;
						var note2 = obj[i].note2;
						var note3 = obj[i].note3;

						if (obj[i]) data.codeEngNm = codeEngNm;
						if (obj[i]) data.memo = memo;
						if (obj[i]) data.note1 = note1;
						if (obj[i]) data.note2 = note2;
						if (obj[i]) data.note3 = note3;

						if (codeEngNm || memo || note1 || note2 || note3) $(this).data(data);
					}
				}
			} else {
				i = idx;
				if (obj[i] != null) {
					var codeEngNm = obj[i].codeEngNm;
					var memo = obj[i].memo;
					var note1 = obj[i].note1;
					var note2 = obj[i].note2;
					var note3 = obj[i].note3;

					if(obj[i]) data.codeEngNm = codeEngNm;
					if(obj[i]) data.memo = memo;
					if(obj[i]) data.note1 = note1;
					if(obj[i]) data.note2 = note2;
					if(obj[i]) data.note3 = note3;

					if(codeEngNm || memo || note1 || note2 || note3) $(this).data(data);
				}
			}
			i++;
			data = null;
		});
	}
}

function convCodes(obj, str, objids, idx){
	var result = {};
	var result2 = {};
	var initConvArray = new Array("", "", "", "","");


	if (null == obj || obj == "undefine") {
		initConvArray[0] = "";
		initConvArray[1] = "";
		initConvArray[2] = "<option value=''>" + str + "</option>";
		initConvArray[3] = "<option value=''>" + str + "</option>";
		initConvArray[4] = "";
		return {"null":initConvArray};
	}
	if (obj.length < 1) {
		initConvArray[0] = "";
		initConvArray[1] = "";
		initConvArray[2] = "<option value=''>" + str + "</option>";
		initConvArray[3] = "<option value=''>" + str + "</option>";
		initConvArray[4] = "";
		return {"null":initConvArray};
	}
	if (str != "") {
		initConvArray[2] += "<option value=''>" + str + "</option>";
		initConvArray[3] += "<option value=''>" + str + "</option>";
	}
	for(var i in obj){
		var convArray = new Array("", "", "", "","");
		var convArray2 = [];
		convArray[0] += obj[i].codeNm + "|";
		convArray[1] += obj[i].code + "|";
		convArray[2] += "<option value='" + obj[i].code + "'>" + obj[i].codeNm	+ "</option>";
		convArray[3] += "<option value='" + obj[i].code + "'>[" + obj[i].code	+ "]" + obj[i].codeNm + "</option>";
		convArray[4] += "[" + obj[i].code + "]" + obj[i].codeNm + "|";

		if(result[obj[i].grcodeCd]){
			var tmpArray = result[obj[i].grcodeCd];
			for(var ii=0 ; ii<initConvArray.length ; ii++){
				convArray[ii] = tmpArray[ii] + convArray[ii];
			}
			convArray2 = result2[obj[i].grcodeCd];

		}else{
			for(var ii=0 ; ii<initConvArray.length ; ii++){
				convArray[ii] = initConvArray[ii] + convArray[ii];
			}

		}
		convArray2.push(obj[i]);
		result[obj[i].grcodeCd] = (convArray);
		result2[obj[i].grcodeCd] = (convArray2);
	}

	for(var cd in result){
		result[cd][0] = result[cd][0].substr(0, result[cd][0].length - 1);
		result[cd][1] = result[cd][1].substr(0, result[cd][1].length - 1);
		result[cd][4] = result[cd][4].substr(0, result[cd][4].length - 1);
	}
	if(objids){
		for(var key in objids){
			var objids2 = objids[key];
			for(var i in objids2){
				var objid = objids2[i];
				$("#"+objid).html(result[key][idx]);
				addComboNote(result2[key], objid);
			}

		}
	}
	return result;
}


function setHeaderPageObj(key, obj) {
	var that = window.top;
	if(that.parent) {
		if (typeof that.parent.setPageObj != 'undefined') {
			that.parent.setPageObj(key, obj);
		} else {
			if(that.parent.opener) {
				that.parent.opener.setHeaderPageObj(key, obj);
			} else {
				that.parent.setHeaderPageObj(key, obj);
			}
		}
	}
}

function headerReSetTimer() {
	//headerSTimeInit();
	var that = window.top;
	if(window.parent) {
		if(typeof that.parent.resetTimer != 'undefined') {
			console.log(typeof that.parent.resetTimer);
			that.parent.resetTimer();
		} else if (typeof that.parent.headerSTimeInit != 'undefined') {
			that.parent.headerSTimeInit();
		} else {
			if(that.parent.opener) {
				that.parent.opener.headerReSetTimer();
			} else {
				that.parent.headerReSetTimer();
			}
		}
	}
}


function enablePage(isLastPopup) {
	$(".lockDiv", "body").removeClass("lockDiv");
}

function disablePage(isLastPopup) {
	var disableDiv = $("<div>").addClass("lockDiv");
	$("body").append(disableDiv);

	var topPageFocus = function(win) {
		var rtnWin = win;

		if(win.top.opener) {
			rtnWin = topPageFocus(win.top.opener);
		}

		return rtnWin;
	}

	if(isLastPopup) {
		var win = topPageFocus(window.top.opener);
		win.focus();
//		window.top.opener.focus();
	}
}

function showOverlay(delayTime, str) {
	var msg = "";
	if(typeof str != undefined && str != null ) {
		msg = "<div class='ui-widget-overlay-msg'>"+str+"</div>";
	}

	if(typeof delayTime != undefined && delayTime != null && parseInt(delayTime,10) > 0) {
		$("body").append( "<div class='ui-widget-overlay'></div>"+msg ).delay(delayTime);
	} else {
		$("body").append( "<div class='ui-widget-overlay'></div>"+msg );
	}
}

function hideOverlay(delayTime) {
	$("body .ui-widget-overlay").remove();
	$("body .ui-widget-overlay-msg").remove();
}

/*
 * selector 하위의 name과 json데이터의 키가 같으면 json 데이터를 적용
 * */
function setValueFromJson(selector,json){
	if(!selector || !json) return;
	for(var key in json){
		var ob = selector.find("[name="+key+"]");
		if(ob.size() > 0){
			var value = json[key];
			var tagName = ob.get(0).tagName.toLowerCase();
			var type = ob.attr("type");
			if(tagName == "select"){
				ob.find("option[value="+value+"]").prop("selected",true);
			}else if(tagName == "input" && (type =="checkbox"||type == "radio")){
				ob.filter(function(){
					if($(this).val()==value){
						$(this).prop("checked",true);
					}
				})
			}else{
				if(ob.hasClass("bbit-dp-input")){ //datapicker
					if(ob.attr("maxlength")==7 && value.length == 6){
						value = value.substr(0,4)+"-"+value.substr(4,2);
					}
					if(ob.attr("maxlength")==10 && value.length == 8){
						value = value.substr(0,4)+"-"+value.substr(4,2)+"-"+value.substr(6,2);
					}
				}
				ob.val(value);
			}
		}
	}

}

$.fn.extend({
	/*enterkey 입력시 fn 실행*/
	keypressEnter : function(fn){
		if($(this).on("keypress",function(evt){
			if(evt.which==13){
				fn(this);
			}
		}));
		return this;
	}
});


/*
 * Date 처리 함수
 */

/*
 * 두 기간이 몇년, 몇개월, 몇일 차이인지 계산
 *   c_sta_ymd: 시작날짜
 *   c_end_ymd: 종료날짜
 *   c_gubun: 반환받을 날짜 포맷 ex)yy-mm-dd, mm-dd, dd...
 *   c_sta_yn: 시작일도 포함할지 여부
 */

function f_sys_between_ymd(c_sta_ymd, c_end_ymd, c_gubun, c_sta_yn) {
    var v_sta_ymd, v_end_ymd;
    var v_yy, v_mm, v_dd;
    var v_yy_t, v_mm_t, v_mm_mod, v_dd_t, v_dd_y_mod, v_mdd_m_mod;
    var v_yy_pos, v_mm_pos, v_dd_pos;
    var day_value = 24*60*60*1000;
    var v_ret = c_gubun;

    if (c_sta_ymd == "" || c_end_ymd == "") {
        return "";
    }

    v_sta_ymd = makeDateFormat(c_sta_ymd);  // javascript 날짜형변수로 변환
    v_end_ymd = makeDateFormat(c_end_ymd);  // javascript 날짜형변수로 변환

    if (v_sta_ymd == "") return "";
    if (v_end_ymd == "") return "";

    if (c_sta_yn.toUpperCase() == "Y") {
        v_sta_ymd = new Date(v_sta_ymd.getFullYear(), v_sta_ymd.getMonth(), v_sta_ymd.getDate()-1);
    }

    v_yy_t      = parseInt(months_between(c_end_ymd, c_sta_ymd)/12);    // 월 기간 계산
    v_mm_t      = parseInt(months_between(c_end_ymd, c_sta_ymd));       // 년도 기간 계산
    v_mm_mod    = parseInt(months_between(c_end_ymd, c_sta_ymd))%12;    // 년도 제외한 월 기간 계산
    v_dd_t      = parseInt((v_end_ymd - v_sta_ymd)/day_value);          // 일자 기간 계산
    v_dd_y_mod  = parseInt((v_end_ymd - add_months(c_sta_ymd, v_yy_t * 12))/day_value); // 년도 제외한 일자 기간 계산
    v_dd_m_mod  = parseInt((v_end_ymd - add_months(c_sta_ymd, (v_yy_t * 12) + v_mm_mod))/day_value);    // 년월 제외한 일자기간 계산
    v_yy_pos    = c_gubun.indexOf('yy'.toLowerCase(),0);    // 년도 구분자 위치 검색
    v_mm_pos    = c_gubun.indexOf('mm'.toLowerCase(),0);    // 월 구분자 위치 검색
    v_dd_pos    = c_gubun.indexOf('dd'.toLowerCase(),0);    // 일자 구분자 위치 검색

    if (v_yy_pos > -1 && v_mm_pos > -1 && v_dd_pos > -1) {          // yy년 mm월 dd일 형태
        v_yy = v_yy_t;
        v_mm = v_mm_mod;
        v_dd = v_dd_m_mod;
    } else if (v_yy_pos > -1 && v_mm_pos > -1 && v_dd_pos == -1) {  // yy년 mm월 형태
        v_yy = v_yy_t;
        v_mm = v_mm_mod;
    } else if (v_yy_pos > -1 && v_mm_pos == -1 && v_dd_pos > 0) {  // yy년 dd일 형태
        v_yy = v_yy_t;
        v_dd = v_dd_y_mod;
    } else if (v_yy_pos > -1 && v_mm_pos == -1 && v_dd_pos == -1) {  // yy년 형태
        v_yy = v_yy_t;
    } else if (v_yy_pos == -1 && v_mm_pos > -1 && v_dd_pos > -1) {  // mm월 dd일 형태
        v_mm = v_mm_t;
        v_dd = v_dd_m_mod;
    } else if (v_yy_pos == -1 && v_mm_pos == -1 && v_dd_pos > -1) { // dd일 형태
        v_dd = v_dd_t;
    } else if (v_yy_pos == -1 && v_mm_pos > -1 && v_dd_pos == -1) { // mm월 형태
        v_mm = v_mm_t;
    }

    if (v_mm < 10)  v_mm = "0" + v_mm;
    if (v_dd < 10)  v_dd = "0" + v_dd;

    //년,월,일 해당 내용 변환
    v_ret = v_ret.replace('yy', v_yy);
    v_ret = v_ret.replace('mm', v_mm);
    v_ret = v_ret.replace('dd', v_dd);

    return v_ret;
}
/* yyyymmdd, yyyy-mm-dd, yyyy.mm.dd 를 javascript 날짜형 변수로 변환 */
function makeDateFormat(pdate) {
    var yy, mm, dd, yymmdd;
    var ar;
    if (pdate.indexOf(".") > -1) {  // yyyy-mm-dd
        ar = pdate.split(".");
        yy = ar[0];
        mm = ar[1];
        dd = ar[2];

        if (mm < 10) mm = "0" + mm;
        if (dd < 10) dd = "0" + dd;
    } else if (pdate.indexOf("-") > -1) {// yyyy.mm.dd
        ar = pdate.split("-");
        yy = ar[0];
        mm = ar[1];
        dd = ar[2];

        if (mm < 10) mm = "0" + mm;
        if (dd < 10) dd = "0" + dd;
    } else if (pdate.length == 8) {
        yy = pdate.substr(0,4);
        mm = pdate.substr(4,2);
        dd = pdate.substr(6,2);
    }

    yymmdd = yy+"/"+mm+"/"+dd;

    yymmdd = new Date(yymmdd);

    if (isNaN(yymmdd)) {
        //alert("날짜 형식이 올바르지 않습니다.");
        return false;
    }

    return yymmdd;
}
/* Javascript 날짜형 변수를 입력된 구분자로 년월일을 나누는 string으로 변환 */
function dateFormatToString(pdate, delimiter) {
	if(delimiter == undefined) delimiter = "";

	var pyear = pdate.getFullYear();
	var pmonth = lpad((pdate.getMonth() + 1).toString(), '0', 2);
	var pdate = lpad(pdate.getDate().toString(), '0', 2);

	return pyear + delimiter + pmonth + delimiter + pdate;
}

/* hhmm 형식의 시간을 hh:mm 으로 변환 */
function formatTime(time) {
    return time.slice(0, 2) + ':' + time.slice(2);
}

/*
       오라클의 개월수 더하는 함수와 동일
    ex) add_month('2008.04.04',10);
*/
function add_months(pdate, diff_m) {
    var add_m;
    var lastDay;    // 마지막 날(30,31..)
    var pyear, pmonth, pday;

    pdate = makeDateFormat(pdate); // javascript 날짜형변수로 변환
    if (pdate == "") return "";

    pyear = pdate.getFullYear();
    pmonth= pdate.getMonth() + 1;
    pday  = pdate.getDate();

    add_m = new Date(pyear, pmonth + diff_m, 1);    // 더해진 달의 첫날로 세팅

    lastDay = new Date(pyear, pmonth, 0).getDate(); // 현재월의 마지막 날짜를 가져온다.
    if (lastDay == pday) {  // 현재월의 마지막 일자라면 더해진 월도 마지막 일자로
        pday = new Date(add_m.getFullYear(), add_m.getMonth(), 0).getDate();
    }

    add_m = new Date(add_m.getFullYear(), add_m.getMonth()-1, pday);

    return add_m;
}
/*
       오라클의 개월수 차이 구하는 함수와 동일
    ex) months_between('20080404','2006-01-01');
*/
function months_between(edate, sdate) {
    var syear, smonth, sday;
    var eyear, emonth, eday;
    var diff_month = 1;

    sdate = makeDateFormat(sdate); // javascript 날짜형변수로 변환
    edate = makeDateFormat(edate); // javascript 날짜형변수로 변환

    if (sdate == "") return "";
    if (edate == "") return "";

    syear = sdate.getFullYear();
    eyear = edate.getFullYear();
    smonth= sdate.getMonth() + 1;
    emonth= edate.getMonth() + 1;
    sday  = sdate.getDate();
    eday  = edate.getDate();

    while (sdate < edate) { // 한달씩 더해서 몇개월 차이 생기는지 검사
        sdate = new Date(syear, smonth - 1 + diff_month, 0);
        diff_month++;
    }

    if (sday > eday) diff_month--;

    diff_month = diff_month - 2;

    return diff_month;
}

/**
 * 어희코드 찾기 팝업
 * @param Row
 * @param openSheet
 * @param keyLevelNm
 * @param keyIdNm
 * @param keyNm
 * @param keyText
 * @returns
 */
function lanuagePopup(Row, openSheet, keyLevel, keyId, keyNm, keyText) {
	if(!isPopup()) {return;}
	var p = { openSheet, keyLevel, keyId, keyNm, keyText };
	const url = '/DictMgr.do?cmd=viewDictLayer';
	var languageDictLayer = new window.top.document.LayerModal({
		id: 'dictLayer',
		url: url,
		parameters: p,
		width: 1000,
		height: 650,
		title : "사전검색", 
		trigger :[
			{
				name : 'dictTrigger', 
				callback : function(returnValue){
					eval(openSheet).SetCellValue(Row, keyId, returnValue['keyId']);
					var chkData = { keyLevel, languageCd: returnValue['keyId'] };
					var dtWord = ajaxCall( "/LangId.do?cmd=getLangCdTword",chkData,false);
					eval(openSheet).SetCellValue(Row, keyNm, dtWord.map.seqNumTword);
				}
			}
		]
	});
	languageDictLayer.show();
}

function select2MultiChoose(optionAllValue, optionValue, name, placeholderText){

	if ( optionAllValue != null && optionAllValue != "" ){
		$('select[name='+name+']').html(optionAllValue);
		if(optionValue != null && optionValue != "" ) {

			var selectItems=new Array();

			$.each(optionValue.split("|"), function( index, value ) {
				selectItems.push(value);
				$("select[name='"+name+"'] > option[value="+value+"]").attr("selected", "selected");
			});
			$('select[name='+name+']').select2(selectItems);

			$('select[name='+name+']').change(function(){
				var thisVal = $(this).select2("val");
				if ( thisVal == "" ){
					$(this).select2({
						placeholder: placeholderText
						, maximumSelectionSize:100
					});
				}
			});
		}else{
			$('select[name='+name+']').select2({
				placeholder: placeholderText
				, maximumSelectionSize:100
			});
		}
	}else{
		$('select[name='+name+']').select2({
			placeholder: placeholderText
			, maximumSelectionSize:100
		});
	}

}

/**
 * wrapper 내의 특정 태그가 가질 수 있는 높이 구하기
 * @param id 높이를 구하고 싶은 태그의 id
 * @returns int 태그의 높이
 */
function getDivHeight(id) {
	var wrpHeight = $(".wrapper").height();	// wrapper 크기
	var expHeight = 0;
	$(".wrapper").children().each(function(idx, obj) {
		if($(obj).attr('id') != id)
			expHeight += $(obj).outerHeight(true);
		else {
			var pd = Number($(obj).css("padding-top").replace("px", "")) + Number($(obj).css("padding-bottom").replace("px", ""));
			var mg = Number($(obj).css("margin-top").replace("px", "")) + Number($(obj).css("margin-bottom").replace("px", ""));
			expHeight += ( pd + mg );
		}
	});
	var tabHeight = wrpHeight - expHeight;
	return Number(tabHeight);
}

/**
 *	NVL함수
 */
function nvl(obj, nvlStr){

	if ( obj == null || obj == 'undefine' || obj == "" ) {
		return nvlStr;
	}else{
		return obj;
	}

}


//날짜 포맷을 적용한다..
function formatDate(strDate, saper) {
	if(strDate == "" || strDate == null) {
		return "";
	}

	if(strDate.length == 10) {
		return strDate.substring(0,4)+saper+strDate.substring(5,7)+saper+strDate.substring(8,10);
	} else if(strDate.length == 8) {
		return strDate.substring(0,4)+saper+strDate.substring(4,6)+saper+strDate.substring(6,8);
	} else if(strDate.length == 6) {
		return strDate.substring(0,4)+saper+strDate.substring(4,6);
	}
}

function makeComma(str) {
    // 값이 1보다 작은 경우, 콤마 없이 표기
    if (str < 1) return str;

    // 문자열로 변환
    let s = str.toString();

    // 소수점 있는지 확인
    let [integerPart, decimalPart] = s.split('.');

    // 정수 부분의 숫자 이외의 문자 제거
    integerPart = integerPart.replace(/\D/g, "");

    // 0으로 시작하는 경우 제거
    if (integerPart.substr(0, 1) === '0') {
        integerPart = integerPart.substr(1);
    }

    // 정수 부분에 콤마 추가
    let l = integerPart.length - 3;
    while (l > 0) {
        integerPart = integerPart.substr(0, l) + "," + integerPart.substr(l);
        l -= 3;
    }

    // 소수 부분이 있으면 다시 결합하여 반환, 없으면 정수 부분만 반환
    return decimalPart ? `${integerPart}.${decimalPart}` : integerPart;
}


//마우스 오버시 나오는 레이어
var slideshow = null;
var preObj = null;
var flipped = false;
$(function () {

	/*
	$(".off_box").css("visibility", "visible");
	$('.flip-container').on('hover', function(){
		var obj = $(this);
		if(!flipped){
			$(this).find('.back').css('transform','rotateY(0deg)');
			$(this).find('.front').css('z-index','0');
			$(this).find('.back').css('z-index','2');
			$(this).find('.front').css('transform','rotateY(180deg)');
			$(this).find('.back').css('visibility','visible');
			flipped=true;
		}else{
			$(this).find('.back').css('transform','rotateY(180deg)');
			$(this).find('.back').css('z-index','0');
			$(this).find('.front').css('z-index','2');
			$(this).find('.front').css('transform','rotateY(0deg)');
			$(this).find('.back').css('visibility','hidden');
			flipped=false;
		}
	});
	*/
	
	$('.flip-container').hover(function(){
		$(this).find('.back').css('transform','rotateY(0deg)');
		$(this).find('.front').css('z-index','0');
		$(this).find('.back').css('z-index','2');
		$(this).find('.front').css('transform','rotateY(180deg)');
		$(this).find('.back').css('visibility','visible');
	},function(){
		$(this).find('.back').css('transform','rotateY(180deg)');
		$(this).find('.back').css('z-index','0');
		$(this).find('.front').css('z-index','2');
		$(this).find('.front').css('transform','rotateY(0deg)');
		$(this).find('.back').css('visibility','hidden');
	});

});


//메인 팝업
function showPopTheme() {
	$('.pop_theme').slideToggle('fast');
}

/*function showPopAuthorityL() {
	$('.pop_authorityL').slideToggle('fast');
}

function showPopAuthority() {
	$('.pop_authority').slideToggle('fast');
}

$(document).ready(function(){
	$(".pop_theme_close").click(function(){
		$(".pop_theme").hide();
	 });
	$("#langeCancel").click(function(){
		$(".pop_authorityL").hide();
	 });
	$("#levelCancel").click(function(){
		$(".pop_authority").hide();
	});
});*/



//삭제 상태 되돌림. 임시저장 삭제 시 사용.
function initDelStatus(sheet){
	try{
		var sRow = sheet.FindStatusRow("D");
		var arr = sRow.split(";");
		for( var i=0; i< arr.length; i++ ){
			sheet.SetCellValue(arr[i], "sStatus", "R", 0);
		}
	}catch(e){}

}

//Tab 하단에 Border 추가 -- 2019.12.02
function initTabsLine(){
	var w=0, h=0, bcolor="";
	$(".ui-state-default").each(function(){
		if($(this).css("display") != "none"){
			w += $(this).width();
			h = $(this).height();
		}
	});
	$(".ui-tabs-nav-line").css("left", w-1).css("height", (h-1)+"px").show();
}


//신청팝업에서 시트행 갯수에 맞게 시트 높이 설정  2020.08.27
function resizeSheetHeight(sheet, authPg){
	if(authPg == "A") return; 
	//console.log("resizeSheetHeight");
	
	var bodyHeight = $("body").outerHeight(); 
	var sheetHeight = sheet.GetSheetHeight(); //원래시트 높이

	//console.log("bodyHeight:"+bodyHeight);
	//console.log("sheetHeight:"+sheetHeight);
	//시트행만큼 높이 조절 
	//if( sheet.RowCount() <= 10 ) { //행 10개 이상일때는 처리안함.
		//console.log("sheetHeight:"+sheetHeight);
		
		var iHeaderHeight = 0;  //헤더 높이
		for(var i = 0; i < sheet.HeaderRows() ; i++) {
			iHeaderHeight = iHeaderHeight + sheet.GetRowHeight(i);
		}
		
		var ih = iHeaderHeight +  ( sheet.RowCount()  * sheet.GetRowHeight(sheet.HeaderRows()) ) + 2;
		if( ih < 130 ) ih = 130;  //시트높이는 100이하는 안됨.
		if( sheet.FindSumRow() > -1 ) ih = ih + sheet.GetRowHeight(sheet.FindSumRow()) + 2; //합계행 여부
		//CountPosition 있으면 체크
		if( sheet.GetCountPosition() > 0 ) {
			ih = ih + sheet.GetRowHeight(sheet.HeaderRows()) +2 ;
		}
		sheet.SetSheetHeight(ih);  //시트 높이
		//console.log("SheetHeight ih:"+ih);
		
		//가로스크롤 높이 ( 시트 높이 재설정 후 가로 스크롤 여부가 판단 됨. ) 
		var iScroll = 0;
		var scrollObj = $("#DIV_"+sheet.id).find(".GMHScrollMid");
		
		var p_scrollObj = $(scrollObj).parent().parent();
		//console.log("scroll display:"+$(p_scrollObj).css("display"));
		if($(p_scrollObj).css("display") != "none"){
			iScroll = $(p_scrollObj).outerHeight() + 2;
			var hh = ih+iScroll;
			sheet.SetSheetHeight(hh);  //시트 높이
			//console.log("hh:"+hh);
		}
		//console.log("SheetHeight:"+sheet.GetSheetHeight());

		//줄어든 높이 만큼 전체 높이 수정
		bodyHeight = bodyHeight - ( sheetHeight - ih ) + iScroll + 2; // 소수점 아래 높이가 무시되어 미세하게 오차가 발생해서 1를 더해줌.

		//console.log("bodyHeight:"+bodyHeight);
		parent.$("#authorFrame").height(bodyHeight);
	//}
}

/**
 * 각종 신청서 authPg "R" 모드 읽기 모드인 경우 select, input[text] 타입 화면 출력 수정
 * - select : padding-left, margin-left 값 조정
 * - input[type] : 객체뒤에 span 태그로 밸류 출력 후 input 객체 hide 처리
 * @param formObj
 * @returns
 */
function convertReadModeForAppDet(formObj) {
	$("select", formObj).css({
		"padding-left" : "0px",
		"margin-left" : "-5px"
	});
	
	var $nextObj = null;
	var $targetObj = null;
	$("input[type=text]", formObj).each(function(){
		$targetObj = $(this);
		if( $('.added_labels_txt', $targetObj.parent()).size() == 0 ) {
			$nextObj = $(this).next();
			if( $nextObj != null && $nextObj != undefined ) {
				if( $($nextObj).hasClass("ui-datepicker-trigger") ) {
					$($nextObj).hide();
					$targetObj = $($nextObj);
				}
			}
			$targetObj.after("<span class='added_labels_txt'>" + $(this).val() + "</span>");
			$(this).hide();
		}
	});
}


//브라우저 유형
function getBrowser() {
	var userAgent = window.navigator.userAgent;
	var result    = "";
	if (userAgent.indexOf('MSIE') > -1 || userAgent.indexOf('Trident') > -1) {
		result = 'IE';
	} else if (userAgent.indexOf('Edge') > -1) {
		result = 'Edge';
	} else if (userAgent.indexOf('Firefox') > -1) {
		result = 'Firefox';
	} else if (userAgent.indexOf('Opera') > -1 || userAgent.indexOf('OPR') > -1) {
		result = 'Opera';
	} else if (userAgent.indexOf('Whale') > -1) {
		result = 'Whale';
	} else if (userAgent.indexOf('Vivaldi') > -1) {
		result = 'Vivaldi';
	} else if (userAgent.indexOf('Chrome') > -1) {
		result = 'Chrome';
	} else if (userAgent.indexOf('Safari') > -1) {
		result = 'Safari';
	}
	return result;
}

/**
 * select element에서 선택된 option에 부여된 attribute 값 취득
 * 
 * @param eleId : select element명
 * @param attrNm : select element에서 선택된 option에 부여된 attribute명
 * @returns : select element에서 선택된 option에 부여된 attribute 값
 */
function getSelectAttr(eleId, attrNm) {
	var returnVal = null;
	
	if (eleId == null || eleId == undefined || eleId == "") return null;
	if (attrNm == null || attrNm == undefined || attrNm == "") return null;
	
	var obj = $("#" + eleId);
	if (obj == null || obj == undefined) return null;
	
	var tagName = obj.prop('tagName');
	if (tagName == null || tagName == undefined || tagName == "") return null;
	
	if (tagName.toUpperCase() == "SELECT") {
		obj = $("option:selected", obj);
	}
	if (obj == null || obj == undefined) return null;
	
	returnVal = obj.attr(attrNm);
	if (returnVal == null || returnVal == undefined) return null;
	
	return returnVal;
}

$(function () {
	// DevModeUrl 표기 여부를 위한 chkDevModeUrl Checkbox 취득
	var chkDevModeUrl = getChkDevModeUrl();
	
	if (chkDevModeUrl !== null && chkDevModeUrl !== undefined) {
		// DevModeUrl 표기 컨트롤
		controlDevModeUrl(chkDevModeUrl);
	}
});

/**
 * DevModeUrl 표기 여부를 위한 chkDevModeUrl Checkbox 취득
 * 
 * @returns : DevModeUrl 표기 여부를 위한 chkDevModeUrl Checkbox
 */
function getChkDevModeUrl() {
	try{
	    var topWindow = window.top;
	    if (topWindow.$("#chkDevModeUrl").length > 0) {
	    	return topWindow.$("#chkDevModeUrl");
	    } else {
			if (topWindow.opener) {		// 팝업창인 경우 opener가 존재함
				// 팝업창인 경우 현재 함수 재귀 호출을 통하여 최초의 팝업창을 호출한 opener를 찾는다
				// 부모창이 존재하는 경우 재귀 함수 호출을 하는데 부모창에 common.js를 include하지 않은 경우 함수를 찾지 못하여 script 오류가 발생하는 현상 수정
				//return topWindow.opener.getChkDevModeUrl();
				if ($.isFunction(topWindow.opener.getChkDevModeUrl)) {
					return topWindow.opener.getChkDevModeUrl();
				} else {
					return null;
				}
			} else {
				return null;
			}
		}
	}catch(e){}
}

/**
 * DevModeUrl 표기 컨트롤
 * 
 * @param checkbox : DevModeUrl 표기 여부를 컨트롤 할 Checkbox
 */
function controlDevModeUrl(checkbox) {
	$(checkbox).change(function() {
		var chkDevModeUrl = "Y";
		
		if ($(this).is(":checked")) {
			chkDevModeUrl = "Y";
			$('#devModeUrl').show();
		} else {
			chkDevModeUrl = "N";
			$('#devModeUrl').hide();
		}
		
		// DevModeUrl 표기 여부를 컨트롤 할 Checkbox의 체크 상태 값을 세션에 저장
		ajaxCall("/SetSessionChkDevModeUrl.do", "chkDevModeUrl=" + chkDevModeUrl, false);
	});
}


/**
 * uploadMgrForm을 iframe 호출 형태로 변경.
 *  - jsp include 상태에서 uploadMgrForm이 중복으로 사용될 경우 id가 겹쳐 오류가 발생할 수 있어서 변경.
 * @param iframeId upload iframe ID
 * @param filSeq filSeq
 * @param uploadType 업로드타입
 * @param authPg 권한
 */
function initFileUploadIframe(iframeId, filSeq, uploadType, authPg) {
    if ($("form#uploadInfoForm", document.body).length > 0) {
        $("form#uploadInfoForm", document.body).remove();
    }

    const form = $("<form id='uploadInfoForm' name='uploadInfoForm' method='post'/>");
    $(document.body).append(form);
    $("<input id='fileSeq' name='fileSeq' type='hidden' value='" + filSeq + "'/>").appendTo(form);
    $("<input id='uploadType' name='uploadType' type='hidden' value='" + uploadType + "'/>").appendTo(form);
    $("<input id='authPg' name='authPg' type='hidden' value='" + authPg + "'/>").appendTo(form);

    submitCall(form, iframeId, "post", "Upload.do?cmd=uploadMgrForm");
}


/**
 * uploadMgrForm을 iframe 호출 형태로 변경.
 *  - jsp include 상태에서 uploadMgrForm이 중복으로 사용될 경우 id가 겹쳐 오류가 발생할 수 있어서 변경.
 * @param iframeId upload iframe ID
 * @param filSeq filSeq
 * @param uploadType 업로드타입
 * @param authPg 권한
 * @param fileInfo 첨부 파일에 대한 정보
 */
function initIbFileUploadIframe(iframeId, filSeq, uploadType, authPg, fileInfo) {
    if ($("form#uploadInfoForm", document.body).length > 0) {
        $("form#uploadInfoForm", document.body).remove();
    }

    const form = $("<form id='uploadInfoForm' name='uploadInfoForm' method='post'/>");
    $(document.body).append(form);
    $("<input id='fileSeq' name='fileSeq' type='hidden' value='" + filSeq + "'/>").appendTo(form);
    $("<input id='uploadType' name='uploadType' type='hidden' value='" + uploadType + "'/>").appendTo(form);
    $("<input id='authPg' name='authPg' type='hidden' value='" + authPg + "'/>").appendTo(form);
    $("<input id='fileInfo' name='fileInfo' type='hidden' value='" + fileInfo + "'/>").appendTo(form);

    submitCall(form, iframeId, "post", "Upload.do?cmd=viewIbUploadMgrIframe");
}

/**
 * fileupload iframe object return
 * @param iframeId upload iframe ID
 * @returns jquery object
 */
function getFileUploadContentWindow(iframeId) {
    const $iframeId = $("#" + iframeId);
    if ($iframeId.length === 0)
        throw "iframe ID가 '" + iframeId + "'인 iframe 태그를 찾을 수 없습니다.";

    return $iframeId.get(0).contentWindow;
}

/**
 * Xss 공격에 대비하여 치환한 HTML 특수문자열을 원본 HTML 로 변환.
 *
 * @param str 치환 대상 string
 * @returns String 원본 HTML
 */
function unescapeXss(str) {
    if (typeof str !== 'string') return str;
    return str.replace(/&amp;/g, '&')
        .replace(/&lt;/g, '<')
        .replace(/&gt;/g, '>')
        .replace(/&quot;/g, '"')
        .replace(/&#039;/g, "'")
        .replace(/&#39;/g, "'");
}


function secureRandom() {
    return (window.crypto || window.msCrypto).getRandomValues(new Uint32Array(1))[0]/4294967296;
}

/**
 * 공통 fetch 호출
 * 호출 오류 발생 시 isError: true 를 뱉어낸다.
 *
 * @param url
 * @param params
 * @returns Object
 */
async function callFetch(url, params) {
    try {
        if (url == null || url === "") {
            throw new Error("URL을 입력해주세요.");
        }

        let contentType, body;
        if (isJsonObject(params)) {
            contentType = "application/json; charset=UTF-8";
            body = JSON.stringify(params);
        } else {
            contentType = "application/x-www-form-urlencoded; charset=UTF-8";
            body = params;
        }

        headerReSetTimer();
        const response = await fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': contentType,
            },
            body: body
        });

        if (!response.ok) {
            throw new Error("조회 실패하였습니다.");
        }

        const result = await response.json();
        if (result == null) {
            throw new Error("조회 실패하였습니다.");
        }

        return result;
    } catch (error) {
        console.error(error);
        return { isError: true, errMsg: error.message };
    }
}

/**
 * JSON 객체 여부 취득
 *
 * @param obj JSON 객체 여부롤 판단할 객체
 * @returns boolean JSON 객체 여부
 */
function isJsonObject(obj) {
    try {
        let json;
        if (typeof obj === 'object') {
            json = JSON.parse(JSON.stringify(obj));
        } else {
            json = JSON.parse(obj);
        }

        return (typeof json === 'object');
    } catch (e) {
        return false;
    }
}