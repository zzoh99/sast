$("*").keypress(function(e) {
    e = e || event;
    var tag = e.srcElement ? e.srcElement.tagName : e.target.nodeName;
    if (tag != "INPUT") {
        return true;
    } else {
        if (e.keyCode == 13) {
            return false;
        }
    }
});

function pageToHtml(url) {
    var html = $.ajax({
        url: "<c:url value='" + url + "' />",
        async: false
    }).responseText;
    return html;
}

function XSS_Replace(str) {
    return str.replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/'/g, "&#039;").replace(/"/g, "&quot;");
}

function codeList(url, grpCd, async) {
    var data = ajaxCall(url, "grpCd=" + grpCd + "&queryId=" + grpCd, false).codeList;
    if (data == "undefine" || data == null) {
        return null;
    }
    return data.length > 0 ? data : null;
}

function stfConvCode(obj, str) {
    var convArray = new Array("", "", "");
    if (null == obj || obj == "undefine") {
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
    if (str != "") {
        convArray[2] += "<option value=''>" + str + "</option>";
    }
    for (i = 0; i < obj.length; i++) {
        convArray[0] += obj[i].code_nm + "|";
        convArray[1] += obj[i].code + "|";
        convArray[2] += "<option value='" + obj[i].code + "'>" + obj[i].code_nm + "</option>";
    }
    convArray[0] = convArray[0].substr(0, convArray[0].length - 1);
    convArray[1] = convArray[1].substr(0, convArray[1].length - 1);
    return convArray;
}

function convCodeIdx(obj, str, idx) {
    if (null == obj || obj == "undefine") {
        return false;
    }
    if (obj.length < 1) {
        return false;
    }
    var convArray = new Array("", "", "");
    if (str != "" && idx == 0) {
        convArray[2] += "<option value='' Selected>" + str + "</option>";
    } else {
        if (str != "" && idx != 0) {
            convArray[2] += "<option value='' >" + str + "</option>";
        }
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

function submitCall(formObj, target, method, action) {
    formObj.attr("target", target).attr("method", method).attr("action", action).submit();
}

function ajaxCall(url, params, async, beforeFn, successFn, errorFn) {
    var obj = new Object();
    $.ajax({
        url: url,
        type: "post",
        dataType: "json",
        async: async,
        data: params,
        beforeSend: function(request) {
            request.setRequestHeader("IBUserAgent", "ajax");
            if (typeof beforeFn != "undefined" && $.isFunction(beforeFn)) {
                beforeFn();
            }
        },
        success: function(data) {
            obj = data;
            if (obj != null && obj.Result != null) {
                alertMessage(obj.Result.Code, obj.Result.Message, "", "");
                if (typeof successFn != "undefined" && $.isFunction(successFn)) {
                    successFn(data);
                }
            }
        },
        error: function(jqXHR, ajaxSettings, thrownError) {
            alert("code:" + jqXHR.status + "\n" + "message:" + jqXHR.responseText + "\n" + "error:" + thrownError);
            if (typeof errorFn != "undefined" && $.isFunction(errorFn)) {
                errorFn();
            }
        }
    });
    return obj;
}

function alertMessage(code, msg, stcode, stmsg) {
    if (code == 1) {
        if (msg != "") {
            alert(msg);
        }
    } else {
        if (code == 905 || code == 990 || code == 991 || code == 992 || code == 993 || code == 994 || code == 995) {
            var reqPage = "";
            if (code == 905) {
                if (chkSysVersion == 1) {
                    reqPage = "/JSP/ErrorPage.jsp";
                } else {
                    alert("\uc138\uc158\uc774 \uc885\ub8cc\ub418\uc5c8\uc2b5\ub2c8\ub2e4.");
                    reqPage = "/Login.do";
                }
            } else {
                if (chkSysVersion == 1) {
                    reqPage = "/JSP/info.jsp?code=" + code;
                } else {
                    reqPage = "/Info.do?code=" + code;
                }
            }
            if (parent.parent != null && parent.parent.opener != null) {
                parent.parent.self.close();
                parent.parent.opener.top.location.href = reqPage;
            } else {
                if (parent.opener != null) {
                    parent.self.close();
                    parent.opener.top.location.href = reqPage;
                } else {
                    if (parent != null) {
                        parent.location.href = reqPage;
                    } else {
                        top.location.href = reqPage;
                    }
                }
            }
        } else {
            if (msg != "") {
                alert(msg);
            }
        }
    }
}

function dupChk(objSheet, keyCol, delchk, firchk) {
    var duprows = objSheet.ColValueDupRows(keyCol, delchk, true);
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
        alert("\uc911\ubcf5\ub41c \uac12\uc774 \uc874\uc7ac \ud569\ub2c8\ub2e4.");
        return false;
    }
    return true;
}(function($, sr) {
    var debounce = function(func, threshold, execAsap) {
        var timeout;
        return function debounced() {
            var obj = this,
                args = arguments;

            function delayed() {
                if (!execAsap) {
                    func.apply(obj, args);
                }
                timeout = null;
            }
            if (timeout) {
                clearTimeout(timeout);
            } else {
                if (execAsap) {
                    func.apply(obj, args);
                }
            }
            timeout = setTimeout(delayed, threshold || 100);
        };
    };
    jQuery.fn[sr] = function(fn) {
        return fn ? this.bind("resize", debounce(fn)) : this.trigger(sr);
    };
})(jQuery, "smartresize");
var globalWindowPopup = null;

function isPopup() {
    if (globalWindowPopup && !globalWindowPopup.closed) {
        alert("\uc774\ubbf8 \uc791\uc5c5\uc911\uc774\uc2e0 \ucc3d\uc774 \uc874\uc7ac\ud569\ub2c8\ub2e4.");
        globalWindowPopup.focus();
        return false;
    } else {
        return true;
    }
    return true;
}

function openPopup(url, arg, width, height) {
    var popOptions = "dialogWidth:" + width + "px; dialogHeight:" + height + "px; center: yes; resizable: yes; status: no; scroll: no;minimize:yes;maximize:yes";
    if (arg.constructor.toString().indexOf("Window") > 0 || arg.constructor.toString().indexOf("String") > 0) {
        var arg = new Array();
    }
    arg["opener"] = this;
    arg["url"] = url;
    try {
        var verchk = getInternetExplorerVersion();
        if (verchk) {
            throw new Error(200, "zero");
        }
        globalWindowPopup = window.showModalDialog("../../jsp_jungsan/common/popup.jsp", arg, popOptions);
    } catch (e) {
        var getparm = "";
        var i = 0;
        for (key in arg) {
            if ([key] != "contains") {
                value = arg[key];
                if (Object.prototype.toString.call(value) == "[object Object]" || Object.prototype.toString.call(value) == "[object Window]" || Object.prototype.toString.call(value) == "[object Array]") {
                    getparm = getparm + "";
                } else {
                    getparm = getparm + ((i == 0) ? '"' : ',"') + [key] + '":"' + escape(value) + '"';
                    i++;
                }
            }
        }
        getparm = getparm.replace(/undefined/gi, "");
        var new_form = document.createElement("form");
        $(new_form).attr({
            "method": "post"
        });
        var parent_element = "<input type='hidden' id='Data' name='Data' value='" + getparm + "' />";
        $(new_form).appendTo("body");
        $(new_form).append(parent_element);
        var winHeight = document.body.clientHeight;
        var winWidth = document.body.clientWidth;
        var winX = window.screenX || window.screenLeft || 0;
        var winY = window.screenY || window.screenTop || 0;
        var popX = winX + (winWidth - width) / 2;
        var popY = winY + (winHeight - height) / 2;
        var target = escape(url);
        if (target.lastIndexOf("/") > -1) {
            target = target.substring(target.lastIndexOf("/") + 1);
        }
        if (target.lastIndexOf(".jsp") > -1) {
            target = target.substring(0, target.lastIndexOf(".jsp"));
        }
        if (target.lastIndexOf(".pdf") > -1) {
            target = target.substring(0, target.lastIndexOf(".pdf"));
        }
        globalWindowPopup = window.open("", target, "width=" + width + "px,height=" + height + "px,top=" + popY + ",left=" + popX + ",scrollbars=no,resizable=yes,menubar=no");
        $(new_form).attr({
            "target": target,
            "action": "../../jsp_jungsan/common/popupg.jsp"
        }).submit();
        globalWindowPopup.focus();
    }
    return globalWindowPopup;
}

function winPopup(url, arg, width, height) {
    var popOptions = "dialogWidth:" + width + "px; dialogHeight:" + height + "px; center: yes; resizable: yes; status: no; scroll: no;minimize:yes;maximize:yes";
    top.$("<div></div>", {
        id: "cover",
        "class": "cover"
    }).html("").appendTo("body");
    $("#cover").height(top.$(document).height());
    $("#cover").css("top", 0);
    var win = window.showModalDialog(url, arg, popOptions);
    top.$("#cover").remove();
    return win;
}

function progressBar(bln) {
    if (bln == true) {
        var bodyWidth = $("body").width();
        var bodyHeight = $("body").height();
        var objframe = $("<iframe id='popFrame' style='width:800px; height:800px; background-color:white;'                      ></iframe>");
        var objDiv = $("<div />", {
            id: "loadingDiv1",
            click: function() {
                popClose();
            },
            style: "position:absolute; width:" + bodyWidth + "px; height:" + bodyHeight + "px; top:0; z-index:997; text-align:center; vertical-align:middle; background-color:gray;opacity: 0.4;"
        });
        var objContent = $("<div />", {
            id: "loadingDiv2",
            style: "position:absolute; top:" + (bodyHeight / 2 - 25) + "px; left:" + (bodyWidth / 2 - 150) + "px; background-color:white; width:300px; height:50px; opacity: 1.0;  z-index:998;text-align:center; vertical-align:middle;"
        });
        var img = $("<img />", {
            id: "loadingImg",
            style: "opacity: 1.0;  z-index:999; margin-top:5px",
            src: "../../common/images/common/InfLoading.gif"
        });
        objContent.append(img);
        objContent.append("<br/><span id='loadingText'>Loading....</span>");
        $("body").append(objDiv);
        $("body").append(objContent);
    } else {
        $("#loadingText").remove();
        $("#loadingImg").remove();
        $("#loadingDiv1").remove();
        $("#loadingDiv2").remove();
    }
}

function winPrintPopup(url, arg, width, height) {
    var popOptions = "dialogWidth:0px; dialogHeight:0px; dialogLeft:0px;dialogTop:00px;center:no; dialogHide:no; resizable: no; status: no; scroll: no;minimize:no;maximize:no";
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
            sheet_count = parseInt(100 / parseInt($(this).attr("realHeight")));
            $(this).attr("sheet_count", sheet_count);
            value = ($(window).height() - outer_height) / sheet_count - inner_height;
            if (value < 100) value = 100;
            $(this).height(value);
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
            outerHeight += $(this).height();
            outerHeight += Number($(this).css("padding-top").replace(/[^0-9]/g, ''));
            outerHeight += Number($(this).css("padding-bottom").replace(/[^0-9]/g, ''));
            outerHeight += Number($(this).css("margin-top").replace(/[^0-9]/g, ''));
            outerHeight += Number($(this).css("margin-bottom").replace(/[^0-9]/g, ''));
            //outerHeight += Number($(this).css("border-top-width").replace(/[^0-9]/g, ''));
            //outerHeight += Number($(this).css("border-bottom-width").replace(/[^0-9]/g, ''));
            
            // 2021.03.09 : 크로미움 기반 브라우저에서  110%로 확대시 정수가 아닌 실수값이 나옴. 따라서 소수점의 (.)이 replace에 의해 공백으로 치환되는 오류 수정
            outerHeight += Math.round(Number($(this).css("border-top-width").replace(/[^0-9/.]/g, '')));
            outerHeight += Math.round(Number($(this).css("border-bottom-width").replace(/[^0-9/.]/g, '')));

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
        if ($(this).attr("id")) {
            var obj = eval($(this).attr("id").split("DIV_").join(""));
            setSheetSize(obj);
        }
    });
}

function sheetResize() {
    var outer_height = getOuterHeight();
    var inner_height = 0;
    var value = 0;
    $(".ibsheet").each(function() {
        inner_height = getInnerHeight($(this));
        if ($(this).attr("fixed") == "false") {
            value = parseInt(($(window).height() - outer_height) / $(this).attr("sheet_count") - inner_height);
            if (value < 100) {
                value = 100;
            }
            $(this).height(value);
        }
    });
    clearTimeout(timeout);
    timeout = setTimeout(addTimeOut, 50);
}
$.datepicker.setDefaults({
    showOn: "both",
    buttonImage: "../../../common_jungsan/images/common/calendar.gif",
    buttonImageOnly: true,
    buttonText: "\ub2ec\ub825",
    dateFormat: "yy-mm-dd",
    nextText: "\ub2e4\uc74c",
    prevText: "\uc774\uc804",
    yearSuffix: "",
    firstDay: 0,
    showWeek: false,
    weekHeader: "\uc8fc",
    showMonthAfterYear: true,
    dayNames: ["\uc77c", "\uc6d4", "\ud654", "\uc218", "\ubaa9", "\uae08", "\ud1a0"],
    dayNamesMin: ["\uc77c", "\uc6d4", "\ud654", "\uc218", "\ubaa9", "\uae08", "\ud1a0"],
    monthNames: ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"],
    monthNamesShort: ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"],
    changeMonth: true,
    changeYear: true,
    showButtonPanel: true,
    currentText: "\uc624\ub298",
    closeText: "\ub2eb\uae30",
    beforeShowDay: getDatePickerHoliday,
    beforeShow: onDatePickerDateChange,
    onChangeMonthYear: onDatePickerDateChange
});
var getDatePickerHolidays = {};

function getDatePickerHoliday(date) {
    var holiday = getDatePickerHolidays[$.datepicker.formatDate("dd", date)];
    if (date.getDay() == 0) {
        return [false, "new_sun"];
    } else {
        if (date.getDay() == 6) {
            return [false, "new_sat"];
        } else {
            if (holiday != undefined && holiday.type == 0) {
                return [false, "new_hol"];
            }
        }
    }
    return [true, ""];
}

function onDatePickerDateChange(year, month, inst) {
    getDatePickerHolidays = {};
}
var _CalSheet;

function calendarOpen(sheet) {
    _CalSheet = sheet;
    if ($("#calendar").length == 0) {
        $("<div></div>", {
            id: "calendar"
        }).appendTo("body");
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
        if (e.keyCode == 27) {
            calendarClose();
        }
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
    if (dWidth < pleft + cWidth) {
        pleft = dWidth - cWidth;
    }
    if (dHeight < ptop + cHeight) {
        ptop = sheet.RowTop(sheet.GetSelectRow()) - cHeight;
    }
    if (ptop < 0) {
        ptop = 0;
    }
    var date = sheet.GetCellValue(sheet.GetSelectRow(), sheet.GetSelectCol());
    $("#calendar").css("top", ptop);
    $("#calendar").css("left", pleft);
    if (date.length == 8) {
        $("#calendar").datepicker("setDate", new Date(date.substr(0, 4), parseInt(date.substr(4, 2)) - 1, date.substr(6, 2)));
    }
    $("#calendar").show();
}

function calendarClose(dateText) {
    $(document).unbind("mouseup");
    $(document).unbind("keydown");
    $(".GMVScroll>div").unbind("scroll");
    $(".GMHScrollMid>div").unbind("scroll");
    if (dateText) {
        _CalSheet.SetCellValue(_CalSheet.GetSelectRow(), _CalSheet.GetSelectCol(), dateText);
    }
    $("#calendar").hide();
}

function fGetXY(aTag) {
    var oTmp = aTag;
    var pt = new Point(0, 0);
    do {
        pt.x += oTmp.offsetLeft;
        pt.y += oTmp.offsetTop;
        oTmp = oTmp.offsetParent;
    } while (oTmp.tagName != "BODY");
    return pt;
}

function Point(iX, iY) {
    this.x = iX;
    this.y = iY;
}
var g_event;
$(document).keypress(function(e) {
    if (typeof(e) != "undefined") {
        g_event = e;
    } else {
        g_event = event;
    }
    $(document).unbind("keypress");
});

function makeNumber(obj, type) {
    if (typeof(event) == "undefined") {
        event = g_event;
    }
    if (event.keyCode == 8 || event.keyCode == 9 || event.keyCode == 13 || (event.keyCode >= 37 && event.keyCode <= 40)) {
        return false;
    }
    var ls_amt1 = obj.value;
    var ls_amt2 = "";
    switch (type) {
        case "A":
            for (var i = 0; i < ls_amt1.length + 1; i++) {
                if (ls_amt1.substring(i, i + 1) >= "0" && ls_amt1.substring(i, i + 1) <= "9") {
                    ls_amt2 = ls_amt2 + ls_amt1.substring(i, i + 1);
                }
            }
            break;
        case "B":
            for (var i = 0; i < ls_amt1.length + 1; i++) {
                if (ls_amt1.substring(i, i + 1) >= "0" && ls_amt1.substring(i, i + 1) <= "9" || ls_amt1.substring(i, i + 1) == "-") {
                    ls_amt2 = ls_amt2 + ls_amt1.substring(i, i + 1);
                }
            }
            break;
        case "C":
            for (var i = 0; i < ls_amt1.length + 1; i++) {
                if (ls_amt1.substring(i, i + 1) >= "0" && ls_amt1.substring(i, i + 1) <= "9" || ls_amt1.substring(i, i + 1) == ".") {
                    ls_amt2 = ls_amt2 + ls_amt1.substring(i, i + 1);
                }
            }
            break;
        case "D":
            for (var i = 0; i < ls_amt1.length + 1; i++) {
                if (ls_amt1.substring(i, i + 1) >= "0" && ls_amt1.substring(i, i + 1) <= "9" || ls_amt1.substring(i, i + 1) == "." || ls_amt1.substring(i, i + 1) == "-") {
                    ls_amt2 = ls_amt2 + ls_amt1.substring(i, i + 1);
                }
            }
            break;
    }
    obj.value = ls_amt2;
    return (true);
}

function setSheetAutocomplete(sheet, col, sabun) {
    var scriptTxt = "";
    scriptTxt += "<script>";
    scriptTxt += "function " + sheet + "_OnBeforeEdit(Row, Col) {";
    scriptTxt += "  try{";
    scriptTxt += "      autoCompleteInit(" + col + "," + sheet + ",Row,Col);";
    scriptTxt += "  }catch(e){";
    scriptTxt += "      alert(e.message);";
    scriptTxt += "  }";
    scriptTxt += "}";
    scriptTxt += "";
    scriptTxt += "function " + sheet + "_OnAfterEdit(Row, Col) {";
    scriptTxt += "  try{";
    scriptTxt += "      autoCompleteDestroy(" + sheet + ");";
    scriptTxt += "  }catch(e){";
    scriptTxt += "      alert(e.message);";
    scriptTxt += "  }";
    scriptTxt += "}";
    scriptTxt += "";
    scriptTxt += "function " + sheet + "_OnKeyUp(Row, Col, KeyCode, Shift) {";
    scriptTxt += "  try{";
    scriptTxt += "      autoCompletePress(" + col + ",Row,Col,KeyCode);";
    scriptTxt += "  }catch(e){";
    scriptTxt += "      alert(e.message);";
    scriptTxt += "  }";
    scriptTxt += "}";
    scriptTxt += "<\/script>";
    document.write(scriptTxt);
    $(document).ready(function() {
        eval(sheet).SetEditArrowBehavior(2);
        $("<form></form>", {
            id: "empForm",
            name: "empForm"
        }).html('<input type="hidden" name="searchStatusCd" value="A" /><input type="hidden" name="searchUserId" id="searchUserId" value="' + sabun + '" />').appendTo("body");
    });
}
var intervalDestory;

function autoCompleteInit(opt, sheet, Row, Col) {
    if (Col != opt) {
        return;
    }
    if ($("#autoCompleteDiv").length == 0) {
        $("<div></div>", {
            id: "autoCompleteDiv"
        }).html("<input id='searchKeyword' name='searchKeyword' type='text' />").appendTo("#empForm");
        var inputId = "searchKeyword";
        $("#searchKeyword").autocomplete({
            source: function(request, response) {
                $.ajax({
                    url: "/Employee.do?cmd=employeeList",
                    dateType: "json",
                    type: "post",
                    data: $("#empForm").serialize(),
                    success: function(data) {
                        response($.map(data.DATA, function(item) {
                            return {
                                label: item.empSabun + ", " + item.enterCd + ", " + item.enterNm,
                                searchNm: $("#searchKeyword").val(),
                                enterNm: item.enterNm,
                                enterCd: item.enterCd,
                                empName: item.empName,
                                empSabun: item.empSabun,
                                orgNm: item.orgNm,
                                jikweeNm: item.jikweeNm,
                                resNo: item.resNo,
                                resNoStr: item.resNoStr,
                                statusNm: item.statusNm,
                                value: item.empName
                            };
                        }));
                    }
                });
            },
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
        }).data("uiAutocomplete")._renderItem = employeeRenderItem;
    }
    $("#autoCompleteDiv").off("autocompleteselect");
    $("#autoCompleteDiv").on("autocompleteselect", function(event, ui) {
        sheet.SetCellText(Row, Col, ui.item.value);
        $("#autoCompleteInput").val("");
        autoCompleteDestroy(sheet);
    });
    $(".GMVScroll>div").scroll(function() {
        destroyAutoComplete(sheet);
    });
    $(".GMHScrollMid>div").scroll(function() {
        destroyAutoComplete(sheet);
    });
    var pleft = sheet.ColLeft(sheet.GetSelectCol());
    var ptop = sheet.RowTop(sheet.GetSelectRow()) + sheet.GetRowHeight(sheet.GetSelectRow());
    if (sheet.GetCountPosition() == 1 || sheet.GetCountPosition() == 2) {
        ptop += 13;
    }
    var point = fGetXY(document.getElementById("DIV_" + sheet.id));
    var left = point.x + pleft;
    var top = point.y + ptop - 16;
    var cWidth = 520;
    var cHeight = 104;
    var dWidth = $(window).width();
    var dHeight = $(window).height();
    if (dWidth < left + cWidth) {
        left = dWidth - cWidth;
    }
    if (dHeight < top + cHeight) {
        top = top - cHeight - 28;
    }
    if (top < 0) {
        top = 0;
    }
    $("#autoCompleteDiv").css("left", left + "px");
    $("#autoCompleteDiv").css("top", top + "px");
    clearTimeout(intervalDestory);
    sheet.SetEditEnterBehavior("none");
}

function autoCompletePress(opt, Row, Col, code) {
    if (Col != opt) {
        return;
    }
    var e = jQuery.Event("keydown");
    e.keyCode = code;
    $("#searchKeyword").trigger(e);
    $("#searchKeyword").val($(".GMEditInput").val());
}

function autoCompleteDestroy(sheet) {
    clearInterval(intervalDestory);
    intervalDestory = setTimeout(function() {
        destroyAutoComplete(sheet);
    }, 200);
}

function destroyAutoComplete(sheet) {
    $(".GMVScroll>div").unbind("scroll");
    $(".GMHScrollMid>div").unbind("scroll");
    $("#autoCompleteInput").autocomplete("destroy");
    $("#autoCompleteDiv").remove();
    sheet.SetEditEnterBehavior("tab");
}

function employeeRenderItem(ul, item) {
    return $("<li />").data("item.autocomplete", item).append("<a style='display:block;width:500px'>" + "<span style='display:inline-block;width:50px;'>" + String(item.empName).split(item.searchNm).join("<b>" + item.searchNm + "</b>") + "</span>" + "<span style='display:inline-block;width:50px;'>" + item.resNoStr + "</span>" + "<span style='display:inline-block;width:100px;'>" + item.enterNm + "</span>" + "<span style='display:inline-block;width:50px;'>" + item.empSabun + "</span>" + "<span style='display:inline-block;width:120px;'>" + item.orgNm + "</span>" + "<span style='display:inline-block;width:50px;'>" + item.jikweeNm + "</span>" + "<span style='display:inline-block;width:50px;'>" + item.statusNm + "</span>" + "</a>").appendTo(ul);
}

function getMultiSelect(val) {
    if (val == null) {
        return "";
    }
    return "'" + String(val).split(",").join("','") + "'";
}(function($) {
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
                    var li_str_len = ls_str.length;
                    var li_max = options.maxbyte;
                    var i = 0;
                    var li_byte = 0;
                    var li_len = 0;
                    var ls_one_char = "";
                    var ls_str2 = "";
                    for (i = 0; i < li_str_len; i++) {
                        ls_one_char = ls_str.charAt(i);
                        if (escape(ls_one_char).length > 4) {
                            li_byte += 3;
                        } else {
                            li_byte++;
                        }
                        if (li_byte <= li_max) {
                            li_len = i + 1;
                        }
                    }
                    if (li_byte > li_max) {
                        alert(li_max + "byte\uc774\uc0c1 \uc785\ub825\ud560 \uc218 \uc5c6\uc2b5\ub2c8\ub2e4.");
                        ls_str2 = ls_str.substr(0, li_len);
                        $(this).val(ls_str2);
                    }
                });
                obj.keyup();
            });
        }
    });
})(jQuery);

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
    if (month <= 0 || month > 12) {
        return false;
    }
    if (day <= 0 || day > 31) {
        return false;
    }
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
    var win = open(url, name, "width=" + width + ",height=" + height + ",top=" + top + ",left=" + left + ",scrollbars=yes,resizable=yes,status=yes,toolbar=no,menubar=no");
}

function isLetterChar(c) {
    return (((c >= "a") && (c <= "z")) || ((c >= "A") && (c <= "Z")));
}

function isDigitChar(c) {
    return ((c >= "0") && (c <= "9"));
}

function isWhiteChar(c) {
    return (c == " " || c == "\t" || c == "\n" || c == "\r");
}

function nvl(s, d) {
    if (s == null || typeof s == "undefined" || trim_script(s) == "") {
        return d;
    }
    return s;
}

function trim_script(str) {
    return str.replace(/^\s+/g, "").replace(/\s+$/g, "");
}

function isKoreanChar(ch) {
    var chStr = escape(ch);
    if (chStr.length < 2) {
        return false;
    }
    if (chStr.substring(0, 2) == "%u") {
        if (chStr.substring(2, 4) == "00") {
            return false;
        } else {
            return true;
        }
    } else {
        if (chStr.substring(0, 1) == "%") {
            if (parseInt(chStr.substring(1, 3), 16) > 127) {
                return true;
            } else {
                return false;
            }
        } else {
            return false;
        }
    }
}

function isEmpty(str) {
    if (str != null) {
        for (i = 0; i < str.length; i++) {
            if (!isWhiteChar(str.charAt(i))) {
                return false;
            }
        }
    }
    return ((str == null) || (str.length == 0));
}

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

function isNumber(strnumber, exceptstr) {
    var i, j;
    for (i = 0; i < strnumber.length; i++) {
        if (isDigitChar(strnumber.charAt(i))) {
            continue;
        }
        for (j = 0; j < exceptstr.length; j++) {
            if (strnumber.charAt(i) == exceptstr.charAt(j)) {
                break;
            }
        }
        if (j == exceptstr.length) {
            return false;
        }
    }
    return true;
}

function isAlphaNumeric(str, strSize) {
    var i;
    if (str.length > strSize) {
        return false;
    }
    for (i = 0; i < str.length; i++) {
        var c = str.charAt(i);
        if (!(isLetterChar(c) || isDigitChar(c))) {
            return false;
        }
    }
    return true;
}

function stripHTMLtag(string) {
    var objStrip = new RegExp();
    objStrip = /[<][^>]*[>]/gi;
    return string.replace(objStrip, "");
}

function getEndOfMonthDay(yy, mm) {
    var max_days = 0;
    if (mm == 1) {
        max_days = 31;
    } else {
        if (mm == 2) {
            if (((yy % 4 == 0) && (yy % 100 != 0)) || (yy % 400 == 0)) {
                max_days = 29;
            } else {
                max_days = 28;
            }
        } else {
            if (mm == 3) {
                max_days = 31;
            } else {
                if (mm == 4) {
                    max_days = 30;
                } else {
                    if (mm == 5) {
                        max_days = 31;
                    } else {
                        if (mm == 6) {
                            max_days = 30;
                        } else {
                            if (mm == 7) {
                                max_days = 31;
                            } else {
                                if (mm == 8) {
                                    max_days = 31;
                                } else {
                                    if (mm == 9) {
                                        max_days = 30;
                                    } else {
                                        if (mm == 10) {
                                            max_days = 31;
                                        } else {
                                            if (mm == 11) {
                                                max_days = 30;
                                            } else {
                                                if (mm == 12) {
                                                    max_days = 31;
                                                } else {
                                                    return "";
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    return max_days;
}

function isValidDate(strDate) {
    var retVal = true;
    if (strDate.length != 10) {
        alert("\ub0a0\uc9dc \ud615\uc2dd\uc774 \uc798\ubabb \ub418\uc5c8\uc2b5\ub2c8\ub2e4.\n ####-##-## or ####/##/## or ####.##.##");
        return false;
    }
    var inputDate = strDate.replace(/\-/g, "").replace(/\//g, "").replace(/\./g, "");
    var yyyy = inputDate.substring(0, 4);
    var mm = inputDate.substring(4, 6);
    var dd = inputDate.substring(6, 8);
    if (isNaN(yyyy) || parseInt(yyyy) < 1000) {
        alert("\ub144\ub3c4\ub294 1000 \uc774\ud558\uc77c\uc218 \uc5c6\uc2b5\ub2c8\ub2e4.");
        return false;
    }
    if (isNaN(mm) || parseFloat(mm) > 12 || parseFloat(mm) < 1) {
        alert("\uc6d4\uc758 \uac12\uc740 1\ubd80\ud130 12\uc0ac\uc774\uc758 \uac12\uc774 \uc5b4\uc57c \ud569\ub2c8\ub2e4.");
        return false;
    }
    if (isNaN(dd) || parseFloat(dd) < 1 || (parseFloat(dd) > getEndOfMonthDay(parseFloat(yyyy.substring(2, 4)), parseFloat(mm)))) {
        alert("\uc77c\uc790\ub294 \ud574\ub2f9 \ub2ec \ubc94\uc704\uc548\uc774 \uc5b4\uc57c\ud569\ub2c8\ub2e4. \n 1~31 or 1~28");
        return false;
    }
    return true;
}

function nullCheck(id, msg) {
    if ($("#" + id).val() == null || $("#" + id).val() == "") {
        alert(msg);
        $("#" + id).focus();
        return false;
    }
    return true;
}

function isValidDateComma(strDate) {
    var retVal = true;
    var inputDate = strDate.replace(/\./g, "");
    if (inputDate.length != 8) {
        alert("\ub0a0\uc9dc \ud615\uc2dd\uc774 \uc798\ubabb \ub418\uc5c8\uc2b5\ub2c8\ub2e4.\n ####.##.##");
        return false;
    }
    var yyyy = inputDate.substring(0, 4);
    var mm = inputDate.substring(4, 6);
    var dd = inputDate.substring(6, 8);
    if (isNaN(yyyy) || parseInt(yyyy) < 1000) {
        alert("\ub144\ub3c4\ub294 1000 \uc774\ud558\uc77c\uc218 \uc5c6\uc2b5\ub2c8\ub2e4.");
        return false;
    }
    if (isNaN(mm) || parseFloat(mm) > 12 || parseFloat(mm) < 1) {
        alert("\uc6d4\uc758 \uac12\uc740 1\ubd80\ud130 12\uc0ac\uc774\uc758 \uac12\uc774 \uc5b4\uc57c \ud569\ub2c8\ub2e4.");
        return false;
    }
    if (isNaN(dd) || parseFloat(dd) < 1 || (parseFloat(dd) > getEndOfMonthDay(parseFloat(yyyy.substring(2, 4)), parseFloat(mm)))) {
        alert("\uc77c\uc790\ub294 \ud574\ub2f9 \ub2ec \ubc94\uc704\uc548\uc774 \uc5b4\uc57c\ud569\ub2c8\ub2e4. \n 1~31 or 1~28");
        return false;
    }
    return true;
}

function monthCheck(val) {
    var msg = "\uc720\ud6a8\ud55c \uc6d4 \ud615\ud0dc\uac00 \uc544\ub2d9\ub2c8\ub2e4.\n 01~12\uae4c\uc9c0 \uc785\ub825 \uac00\ub2a5 \ud569\ub2c8\ub2e4.";
    var pattern = /[0-9]{2}/;
    if (!pattern.test(val)) {
        alert("\uc6d4\uc740 mm\ub85c \uc785\ub825\ud574 \uc8fc\uc138\uc694");
        return false;
    }
    var month = parseInt(val);
    if (month < 1 || month > 12) {
        alert(msg);
        return false;
    }
    return true;
}

function chkPattern(str, type) {
    switch (type) {
        case "NUM":
            pattern = /^[0-9]+$/;
            break;
        case "PHONE":
            pattern = /^[0-9]{2,4}-[0-9]{3,4}-[0-9]{4}$/;
            break;
        case "MOBILE":
            pattern = /^0[0-9]{2,3}-[0-9]{3,4}-[0-9]{4}$/;
            break;
        case "ZIPCODE":
            pattern = /^[0-9]{3}-[0-9]{3}$/;
            break;
        case "EMAIL":
            pattern = /^[a-zA-Z0-9._-]+@([a-zA-Z0-9.-]+\.)+[a-zA-Z]{2,4}$/;
            break;
        case "DOMAIN":
            pattern = /^[.a-zA-Z0-9-]+.[a-zA-Z]+$/;
            break;
        case "ENG":
            pattern = /^[a-zA-Z]+$/;
            break;
        case "ENGNUM":
            pattern = /^[a-zA-Z0-9]+$/;
            break;
        case "ACCOUNT":
            pattern = /^[0-9-]+$/;
            break;
        case "HOST":
            pattern = /^[a-zA-Z-]+$/;
            break;
        case "ID":
            pattern = /^[a-zA-Z]{1}[a-zA-Z0-9]{5,15}$/;
            break;
        case "ID2":
            pattern = /^[a-zA-Z0-9._-]+$/;
            break;
        case "DATE":
            pattern = /^[0-9]{4}-[0-9]{2}-[0-9]{2}$/;
            break;
        case "DATE2":
            pattern = /^[0-9]{4}.[0-9]{2}.[0-9]{2}$/;
            break;
        case "JUMIN":
            pattern = /^[0-9]{13}$/;
            break;
        case "GRADE":
            pattern = /^[0-9]+(.[0-9])?$/;
            break;
        default:
            return false;
    }
    return pattern.test(str);
}

function getDaysBetween(startDt, endDt) {
    if (startDt == "" || endDt == "") {
        return "";
    }
    var startDt = new Date(startDt.substring(0, 4), startDt.substring(4, 6) - 1, startDt.substring(6, 8));
    var endDt = new Date(endDt.substring(0, 4), endDt.substring(4, 6) - 1, endDt.substring(6, 8));
    return Math.floor(endDt.valueOf() / (24 * 60 * 60 * 1000) - startDt.valueOf() / (24 * 60 * 60 * 1000) + 1);
}

function ajaxescape(value) {
    return escape(encodeURIComponent(value)).replace(/\+/g, "%2B");
}

function convCamel(str) {
    var before = str.toLowerCase();
    var after = "";
    var bs = before.split("_");
    if (bs.length < 2) {
        return bs;
    }
    for (var i = 0; i < bs.length; i++) {
        if (bs[i].length > 0) {
            if (i == 0) {
                after += bs[i].toLowerCase();
            } else {
                after += bs[i].toLowerCase().substr(0, 1).toUpperCase() + bs[i].substr(1, bs[i].length - 1);
            }
        }
    }
    return after;
}

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
    } else {
        if (pInterval == "m") {
            mm = (mm * 1) + (pAddVal * 1);
        } else {
            if (pInterval == "d") {
                dd = (dd * 1) + (pAddVal * 1);
            }
        }
    }
    cDate = new Date(yyyy, mm - 1, dd);
    cYear = cDate.getFullYear();
    cMonth = cDate.getMonth() + 1;
    cDay = cDate.getDate();
    cMonth = cMonth < 10 ? "0" + cMonth : cMonth;
    cDay = cDay < 10 ? "0" + cDay : cDay;
    return cYear + pDelimiter + cMonth + pDelimiter + cDay;
}

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
    var key = "",
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
    return sValue.split(param1).join(param2);
}

function checkFromToDate(fromObj, toObj, fromTxt, toTxt, dateType) {
    if (dateType == "YYYYMM") {
        var fromDate = fromObj.val().replace(/\-/g, "").replace(/\//g, "");
        var toDate = toObj.val().replace(/\-/g, "").replace(/\//g, "");
        var fromYyyy = fromDate.substring(0, 4);
        var fromMm = fromDate.substring(4, 6);
        var toYyyy = toDate.substring(0, 4);
        var toMm = toDate.substring(4, 6);
        if (fromDate.length != 6) {
            alert(fromTxt + "\uc744 \ubc14\ub974\uac8c \uc785\ub825\ud558\uc2ed\uc2dc\uc624.");
            fromObj.focus();
            return false;
        }
        if (toDate.length != 6) {
            alert(toTxt + "\uc744 \ubc14\ub974\uac8c \uc785\ub825\ud558\uc2ed\uc2dc\uc624.");
            toObj.focus();
            return false;
        }
        if (isNaN(fromYyyy) || parseInt(fromYyyy) < 1000) {
            alert(fromTxt + "\uc744 \ubc14\ub974\uac8c \uc785\ub825\ud558\uc2ed\uc2dc\uc624.");
            fromObj.focus();
            return false;
        }
        if (isNaN(fromMm) || parseFloat(fromMm) > 12 || parseFloat(fromMm) < 1) {
            alert(fromTxt + "\uc744 \ubc14\ub974\uac8c \uc785\ub825\ud558\uc2ed\uc2dc\uc624.");
            fromObj.focus();
            return false;
        }
        if (isNaN(toYyyy) || parseInt(toYyyy) < 1000) {
            alert(toTxt + "\uc744 \ubc14\ub974\uac8c \uc785\ub825\ud558\uc2ed\uc2dc\uc624.");
            toObj.focus();
            return false;
        }
        if (isNaN(toMm) || parseFloat(toMm) > 12 || parseFloat(toMm) < 1) {
            alert(toTxt + "\uc744 \ubc14\ub974\uac8c \uc785\ub825\ud558\uc2ed\uc2dc\uc624.");
            toObj.focus();
            return false;
        }
        if (parseInt(fromDate) > parseInt(toDate)) {
            alert("\uc2dc\uc791\ub144\uc6d4\uc774 \uc885\ub8cc\ub144\uc6d4\ubcf4\ub2e4 \ud07d\ub2c8\ub2e4.");
            toObj.focus();
            return false;
        }
    } else {
        if (dateType == "YYYYMMDD") {
            var fromDate = fromObj.val();
            var toDate = toObj.val();
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
            fromDate = fromDate.replace(/\-/g, "").replace(/\//g, "");
            toDate = toDate.replace(/\-/g, "").replace(/\//g, "");
            if (parseInt(fromDate) > parseInt(toDate)) {
                alert("\uc2dc\uc791\uc77c\uc774 \uc885\ub8cc\uc77c\ubcf4\ub2e4 \ud07d\ub2c8\ub2e4.");
                toObj.focus();
                return false;
            }
        }
    }
    return true;
}

function redirect(url, target) {
    if (/MSIE (\d+\.\d+);/.test(navigator.userAgent)) {
        var referLink = document.createElement("a");
        referLink.href = url;
        referLink.target = target;
        document.body.appendChild(referLink);
        referLink.click();
    } else {
        (target == "_blank") ? window.open(url, target): $(location).attr("href", url);
    }
}
var under2camel = function(str) {
    return str.toLowerCase().replace(/(\_[a-z])/g, function(arg) {
        return arg.toUpperCase().replace("_", "");
    });
};
var camel2under = function(str) {
    return str.replace(/([A-Z])/g, function(arg) {
        return "_" + arg.toLowerCase();
    }).toUpperCase();
};

function numRound(n, pos) {
    var digits = Math.pow(10, pos);
    var sign = 1;
    if (n < 0) {
        sign = -1;
    }
    n = n * sign;
    var num = Math.round(n * digits) / digits;
    num = num * sign;
    var str = num.toFixed(20);
    str = str.replace(/0+$/, "").replace(/\.$/, "");
    return str;
}

function checkRegNo(fRegNo, rRegNo) {
    if (fRegNo == "") {
        return false;
    }
    if (rRegNo == "") {
        return false;
    }
    resno = fRegNo + "-" + rRegNo;
    fmt = /^\d{6}-[1234]\d{6}$/;
    if (!fmt.test(resno)) {
        return false;
    }
    birthYear = (resno.charAt(7) <= "2") ? "19" : "20";
    birthYear += resno.substr(0, 2);
    birthMonth = resno.substr(2, 2) - 1;
    birthDate = resno.substr(4, 2);
    birth = new Date(birthYear, birthMonth, birthDate);
    if (birth.getYear() % 100 != resno.substr(0, 2) || birth.getMonth() != birthMonth || birth.getDate() != birthDate) {
        return false;
    }
    buf = new Array(13);
    for (i = 0; i < 6; i++) {
        buf[i] = parseInt(resno.charAt(i));
    }
    for (i = 6; i < 13; i++) {
        buf[i] = parseInt(resno.charAt(i + 1));
    }
    multipliers = [2, 3, 4, 5, 6, 7, 8, 9, 2, 3, 4, 5];
    for (i = 0, sum = 0; i < 12; i++) {
        sum += (buf[i] *= multipliers[i]);
    }
    if ((11 - (sum % 11)) % 10 != buf[12]) {
        return false;
    }
    return true;
}

function fgn_no_chksum(reg_no) {
    var sum = 0;
    var odd = 0;
    buf = new Array(13);
    for (i = 0; i < 13; i++) {
        buf[i] = parseInt(reg_no.charAt(i));
    }
    odd = buf[7] * 10 + buf[8];
    if (odd % 2 != 0) {
        return false;
    }
    if ((buf[11] != 6) && (buf[11] != 7) && (buf[11] != 8) && (buf[11] != 9)) {
        return false;
    }
    multipliers = [2, 3, 4, 5, 6, 7, 8, 9, 2, 3, 4, 5];
    for (i = 0, sum = 0; i < 12; i++) {
        sum += (buf[i] *= multipliers[i]);
    }
    sum = 11 - (sum % 11);
    if (sum >= 10) {
        sum -= 10;
    }
    sum += 2;
    if (sum >= 10) {
        sum -= 10;
    }
    if (sum != buf[12]) {
        return false;
    } else {
        return true;
    }
}

function checkBizID(bizID) {
    if (bizID == "") {
        return false;
    }
    var re = /-/g;
    var bizID = bizID.replace(re, "");
    var checkID = new Array(1, 3, 7, 1, 3, 7, 1, 3, 5, 1);
    var tmpBizID, i, chkSum = 0,
        c2, remander;
    for (i = 0; i <= 7; i++) {
        chkSum += checkID[i] * bizID.charAt(i);
    }
    c2 = "0" + (checkID[8] * bizID.charAt(8));
    c2 = c2.substring(c2.length - 2, c2.length);
    chkSum += Math.floor(c2.charAt(0)) + Math.floor(c2.charAt(1));
    remander = (10 - (chkSum % 10)) % 10;
    if (Math.floor(bizID.charAt(9)) == remander) {
        return true;
    }
    return false;
}

function isRegNo(sRegNo) {
    var re = /-/g;
    sRegNo = sRegNo.replace("-", "");
    if (sRegNo.length != 13) {
        return false;
    }
    var arr_regno = sRegNo.split("");
    var arr_wt = new Array(1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2);
    var iSum_regno = 0;
    var iCheck_digit = 0;
    for (i = 0; i < 12; i++) {
        iSum_regno += eval(arr_regno[i]) * eval(arr_wt[i]);
    }
    iCheck_digit = 10 - (iSum_regno % 10);
    iCheck_digit = iCheck_digit % 10;
    if (iCheck_digit != arr_regno[12]) {
        return false;
    }
    return true;
}

function openYeaDataExpPopup(pUrl, pW, pH, pTitle, pExpText) {
    var w = pW == "" || pW == null ? 590 : pW;
    var h = pH == "" || pH == null ? 500 : pH + 35;
    var title = $('<input name="title" type="hidden" value="' + pTitle + '">');
    var expText = $('<input name="expText" type="hidden" value="' + pExpText + '">');
    var $form = $("<form></form>");
    $form.attr("action", pUrl);
    $form.attr("method", "post");
    $form.attr("target", "yeaDataExpPopup");
    $form.appendTo("body");
    $form.append(title).append(expText);
    var top = (screen.availHeight / 2) - (w / 2);
    var left = (screen.availWidth / 2) - (h / 2);
    var Popup = window.open("", "yeaDataExpPopup", "width=" + w + ",height=" + h + ",scrollbars=yes,resizeable=no, top=" + top + ", left=" + left + "");
    Popup.focus();
    $form.submit();
}

function checkMetaChar(pVal) {
    var num = "{}[]()<>?|`~'!@#$%^&*-+=,.;:\"'\\/ ";
    var bFlag = true;
    for (var i = 0; i < pVal.length; i++) {
        if (num.indexOf(pVal.charAt(i)) != -1) {
            bFlag = false;
        }
    }
    return bFlag;
}

function getInternetExplorerVersion() {
    var rv = true;
    var trident = navigator.userAgent.match(/Trident\/(\d)/i);
    trident = trident.toString();
    if (trident.indexOf("Trident/7") >= 0) {
        rv = true;
    } else {
        rv = false;
    }
    return rv;
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
