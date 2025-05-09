var gJson = {Data: [[]]};

/*
 * IBSheet를 생성(호출 위치에서 동적 생성)
 */
function createIBSheet(sheetid, width, height, locale) {
    var div_str = "";

	var realheight = height;
	var sheetcount = 1;
	var fixed = false;

	if (!locale) locale = "";
    Grids.Locale = locale;

    //----------------------------------------------------------------------- 2020.05.26 
    // 2020.05.26 추가
    // ibsheet.cfg 파일 사용하지 않고 여기서 정의한다.
    Grids.Config = {
    	    "Cfg" : {
    	        "Down2Excel_Url" : "../jsp/Down2Excel.jsp",
    	        "LoadExcel_Url" : "../jsp/LoadExcel.jsp",
    	        "DirectLoadExcel_Url" : "../jsp/DirectLoadExcel.jsp",
    	        "Down2Text_Url" : "../jsp/Down2Text.jsp",
    	        "LoadText_Url" : "../jsp/LoadText.jsp",
    	        "Down2Pdf_Url" : "../jsp/Down2Pdf.jsp",
    	        "AutoClearHeaderCheck" : "1",
    	        "CalWeekNumber" : "0",
    	        "CheckActionKey" : "Space|Enter",
    	        "ClipPasteMode" : "1",
    	        "ComboOpenMode" : "1",
    	        "CustomScroll" : "3",
    	        "DataRowHeight" : "28", //22
    			"FocusEditMode" :  "2", //1
    			"HeaderRowHeight" : "28", //26
    	        "NextPageCall" : "80",
    	        "ReverseSortOrder" : "0",
    	        "SaveValidationMode" : "1",
    	        "SelectCellEventMode" : "1",
    	        "UseCache" : "1",
    	        "UseJsonTreeLevel" : "1",
    	        "UseJsonAttribute" : "1",
    	        "WaitTimeOut" : "300",
    	        "FilterInputPopup" : "1",
    	        "SumZeroValue" : "0",
    	        "UseCache" : "1",
    	        "UseEditMask" : "1",
    	        "UnicodeByte" : "3",
    	        "MultiCheckValue" : "1",
    	        "DeferredVScroll" : "1",
    	        "DeferredHScroll" : "1",
    	        "UseHeaderActionMenu" : "1",
                "UserAgent" : "ibsheet"
    	    }
    };

    // css theme 별사용. song hyungyu
    // jqueryScript.jsp 에 define.
    if(window._theme && window._theme != "null" && window._theme != ""){
    	Grids.Config.Cfg.CssUrl = "common/"+ _theme +"/";
    }
    //----------------------------------------------------------------------- 2020.05.26 
	if( width.indexOf("%") > -1 ) {
		sheetcount = parseInt(100 / parseInt(width));
		width = "100%";
	}

	if( height.indexOf("%") > -1 ) height = "300px"; // 시트 최소 높이
	else fixed = true;

	div_str += "<div name='IBSheet' id='DIV_" + sheetid + "' fixed='"+fixed+"' class='ibsheet' sheetcount='"+sheetcount+"' realheight='"+realheight+"' style='width:" + width + ";height:"+ height +";'>";

    //div_str += "<div id='DIV_" + sheetid + "' style='width:" + width + ";height:" + height + ";'>";
    div_str += "<script> IBSheet('<ibsheet Sync=\"1\" Data_Sync=\"0\"> </ibsheet>',\"DIV_" + sheetid + "\", \"" + sheetid + "\"); </script>"
    div_str += "</div>\n";

    //<![CDATA[
    document.write(div_str);
    //]]>

    window[sheetid+"_OnLoadData"] = function(data){
    	try{
	    	
    		headerReSetTimer();

    		//보안 체크 오류 시
	    	if( $.parseJSON(data).securityKey != undefined ){
	    		var rtnCode = $.parseJSON(data).code;
	    		moveInfoPage(rtnCode);

	    	}
    	}catch(e){}
	};

	window[sheetid].SetUserAgent("ibsheet"); //IBSheet 요청인지 헤더에서 체크 하기 위한 값
    /*window[sheetid+"_OnDropEnd"] = function(Obj, Row, ToObj, ToRow) {
        if( ToObj && ToRow > 0 ) {
            for(var i = 0; i <  window[sheetid].LastCol()+1; i++) {
                let saveName = window[sheetid].ColSaveName(i);
                if( saveName === 'sNo' || saveName === 'sStatus' || saveName === 'sDelete' ) {
                    continue;
                }

                var originValue1 = window[sheetid].GetCellValue(Row, saveName);
                var originValue2 = window[sheetid].GetCellValue(ToRow, saveName);

                window[sheetid].SetCellValue(Row, saveName, originValue2);
                window[sheetid].SetCellValue(ToRow, saveName, originValue1);
            }
        }
    };*/
}

/*
 * IBSheet를 생성 (특정 div 하위로 넣는 경우에 사용)
 */
function createIBSheet2(obj, sheetid, width, height, locale) {
    // locale 처리
    Grids.Locale = locale ? locale : "";

    // width, height 적용
    obj.style.width = width;
    obj.style.height = height;

    IBSheet('<ibsheet Sync=\"1\" Data_Sync=\"0\"> </ibsheet>', obj.id, sheetid);
}

function createTabHeightIBsheet(sheetid, width, height, locale){
	// locale 처리
    Grids.Locale = locale ? locale : "";
	var sheetHeight = $('.wrapper').height() - $('.sheet_search').height() - $('.tab_bottom').outerHeight(true) - 10;//20은 .wrapper 내부 padding의 값
	var sheetH = sheetHeight.toString()+'px'
	createIBSheet(sheetid, width, sheetH, locale);
}

/* MergeSheet 속성에 설정 값 */
var msNone            = 0, // 머지 없음
    msAll             = 1, // 전부 머지 가능
    msPrevColumnMerge = 2, // 앞 컬럼이 머지 된 경우 해당 행 안에서 머지 가능
    msFixedMerge      = 3, // 단위데이터행 구조에서의 고정 셀 병합 기능
    msBaseColumnMerge = 4, // 기준 컬럼 머지 영역 범위 내에서의 머지 기능
    msHeaderOnly      = 5; // 해더만 머지

/* BasicImeMode 속성 설정 값 */
var imeAuto = 0; // 마지막 상태를 그대로 사용
var imeHan  = 1; // 기본 상태를 한글 입력 상태로 함
var imeEng  = 2; // 기본 상태를 영문 입력 상태로 함

/* SizeMode 속성 설정 값 */
var sizeAuto         = 0; // 설정한 높이, 너비 그대로 사용
var sizeNoVScroll    = 1; // 높이를 스크롤 없이 자동 설정
var sizeNoHScroll    = 2; // 너비를 스크롤 없이 자동 설정
var sizeNoBothScroll = 3; // 높이, 너비 모두 스크롤 없이 자동 설정

/* SearchMode 속성 설정 값 */
var smGeneral       = 0, // 일반 조회
    smClientPaging  = 1, // 클라이언트 페이징 조회
    smLazyLoad      = 2, // Lazy Load 조회
    smServerPaging  = 3, // 실시간 서버 페이징 조회 (Scroll 방식)
    smServerPaging2 = 4; // 실시간 서버 페이징 조회 (Page Index 방식)

/* SumPosition 속성 설정 값 */
var posTop    = 0; // 상단 고정 위치
var posBottom = 1; // 하단 고정 위치

/* VScrollMode 속성 설정 값 */
var vsAuto   = 0; // 자동 생성
var vsFixed = 1; // 고정 생성

/*
    FormQueryString 관련 함수 정의
*/
/* FormQueryString과 FormQueryStringEnc함수에서 필수입력 체크시 메시지로 사용한다.-3.4.0.50 */
var IBS_MSG_REQUIRED = "은(는) 필수입력 항목입니다.";

/**
 * 에러메시지를 표시한다. IBS_ShowErrMsg 대신 이 함수를 사용해야 한다.
 * @param   : sMsg      - 메시지
 * @return  : 없음
 * @version : 3.4.0.50
 * @sample
 *  IBS_ShowErrMsg("에러가 발생했습니다.");
 */
function IBS_ShowErrMsg(sMsg) {
    return alert("[IBSheetInfo.js]\n" + sMsg);
}

function IBS_getName(obj) {
    if (obj.name != "") {
        return obj.name;
    } else if (obj.id != "") {
        return obj.id;
    } else {
        return "";
    }
}

function IBS_RequiredChk(obj) {
    return (obj.getAttribute("required") != null);
}

/**
 * Form오브젝트 안에 있는 컨트롤을 QueryString으로 구성한다. 이때, 한글은 인코딩하지 않는다.
 * @param   : form          - 필수,html의 Form 오브젝트 Name
 * @param   : checkRequired - 선택,필수입력 체크 여부(true,false)
 * @return  : String        - Form오브젝트 안에 Control을 QueryString으로 구성한 문자열
 *            undefined     - checkRequired인자가 true이고, 필수입력에 걸린경우 return 값
 * @version : 1.0.0.0,
 *            3.4.0.50(checkRequired 인자 추가)
 * @sample1
 *  var sCondParam=FormQueryString(document.frmSearch); //결과:"txtname=이경희&rdoYn=1&sltMoney=원화";
 * @sample2
 *  <input type="text" name="txtName" required="이름">        //필수 입력 항목이면 required="이름" 를 설정한다.
 *  var sCondParam = FormQueryString(document.mainForm, true);//필수입력까지 체크하며, 필수입력에 걸리면 리턴값은 null
 *  if (sCondParam==null) return;
 */
function FormQueryString(form, checkRequired) {
    if (typeof form != "object" || form.tagName != "FORM") {
        IBS_ShowErrMsg("FormQueryString 함수의 인자는 FORM 태그가 아닙니다.");
        return "";
    }

    if (checkRequired == null) checkRequired = false;

    var name = new Array(form.elements.length);
    var value = new Array(form.elements.length);
    var j = 0;
    var plain_text = "";

    //사용가능한 컨트롤을 배열로 생성한다.
    len = form.elements.length;
    for (i = 0; i < len; i++) {
        var prev_j = j;
        switch (form.elements[i].type) {
            case undefined:
            case "button":
            case "reset":
            case "submit":
                break;
            case "radio":
            case "checkbox":
                if (form.elements[i].checked == true) {
                    name[j] = IBS_getName(form.elements[i]);
                    value[j] = form.elements[i].value;
                    j++;
                }
                break;
            case "select-one":
                name[j] = IBS_getName(form.elements[i]);
                var ind = form.elements[i].selectedIndex;
                if (ind >= 0) {

                    value[j] = form.elements[i].options[ind].value;

                } else {
                    value[j] = "";
                }
                j++;
                break;
            case "select-multiple":
                name[j] = IBS_getName(form.elements[i]);
                var llen = form.elements[i].length;
                var increased = 0;
                for (k = 0; k < llen; k++) {
                    if (form.elements[i].options[k].selected) {
                        name[j] = IBS_getName(form.elements[i]);
                        value[j] = form.elements[i].options[k].value;

                        j++;
                        increased++;
                    }
                }
                if (increased > 0) {
                    j--;
                } else {
                    value[j] = "";
                }
                j++;
                break;
            default:
                name[j] = IBS_getName(form.elements[i]);
                value[j] = form.elements[i].value;
                j++;
        }

        if (checkRequired) {
            //html 컨트롤 태그에 required속성을 설정하면 필수입력을 확인할 수 있다.
            //<input type="text" name="txtName" required="이름">

            if (IBS_RequiredChk(form.elements[i]) && prev_j != j && value[prev_j] == "") {

                if (form.elements[i].getAttribute("required") == null ||
                    form.elements[i].getAttribute("required") == ""
                ) {
                    alert('"' + IBS_getName(form.elements[i]) + '"' + IBS_MSG_REQUIRED);
                } else {

                    alert('"' + form.elements[i].getAttribute("required") + '"' + IBS_MSG_REQUIRED);
                }
                //컨트롤이 숨겨져 있을수도 있으므로 에러 감싼다.
                try {
                    form.elements[i].focus();
                } catch (ee) {;
                }

                return;
            }
        }
    }
    //QueryString을 조합한다.
    for (i = 0; i < j; i++) {
        if (name[i] != '') plain_text += name[i] + "=" + value[i] + "&";
    }

    //마지막에 &를 없애기 위함
    if (plain_text != "") plain_text = plain_text.substr(0, plain_text.length - 1);

    return plain_text;
}

/**
 * Form오브젝트 안에 있는 컨트롤을 QueryString으로 구성한다. 이때, 한글은 인코딩한다.
 * @param   : form          - 필수,html의 Form 오브젝트 Name
 * @param   : Sheet         - 필수,IBheet의 Object id
 * @param   : checkRequired - 선택,필수입력 체크 여부(true,false)
 * @return  : String        - Form오브젝트 안에 Control을 QueryString으로 구성한 문자열
 *            undefined     - checkRequired인자가 true이고, 필수입력에 걸린경우 return 값
 * @version : 1.0.0.0,
 *            3.4.0.50(checkRequired 인자 추가)
 * @sample1
 *  var sCondParam=FormQueryStringEnc(document.frmSearch, mySheet1);
 *  원본:"txtname=이경희&rdoYn=1&sltMoney=원화";
 *  결과:"txtname=%C0%CC%B0%E6%C8%F1&rdoYn=1&sltMoney=%BF%F8%C8%AD";                //UTF16인 경우
 *  결과:"txtname=%EC%9D%B4%EA%B2%BD%ED%9D%AC&rdoYn=1&sltMoney=%EC%9B%90%ED%99%94"; //UTF8인 경우
 * @sample2
 *  <input type="text" name="txtName" required="이름">                    //필수 입력 항목이면 required="이름" 를 설정한다.
 *  var sCondParam = FormQueryStringEnc(document.mainForm, mySheet, true);//필수입력까지 체크하며, 필수입력에 걸리면 리턴값은 null
 *  if (sCondParam==null) return;
 */
function FormQueryStringEnc(form, checkRequired) {
    if (typeof form != "object" || form.tagName != "FORM") {
        IBS_ShowErrMsg("FormQueryStringEnc 함수의 form 인자는 FORM 태그가 아닙니다.");
        return "";
    }


    if (checkRequired == null) checkRequired = false;

    var name = new Array(form.elements.length);
    var value = new Array(form.elements.length);
    var j = 0;
    var plain_text = "";

    //사용가능한 컨트롤을 배열로 생성한다.
    len = form.elements.length;
    for (i = 0; i < len; i++) {
        var prev_j = j;
        switch (form.elements[i].type) {
            case "button":
            case "reset":
            case "submit":
                break;
            case "radio":
            case "checkbox":
                if (form.elements[i].checked == true) {
                    name[j] = IBS_getName(form.elements[i]);
                    value[j] = form.elements[i].value;
                    j++;
                }
                break;
            case "select-one":
                name[j] = IBS_getName(form.elements[i]);
                var ind = form.elements[i].selectedIndex;
                if (ind >= 0) {

                    value[j] = form.elements[i].options[ind].value;

                } else {
                    value[j] = "";
                }
                j++;
                break;
            case "select-multiple":
                name[j] = IBS_getName(form.elements[i]);
                var llen = form.elements[i].length;
                var increased = 0;
                for (k = 0; k < llen; k++) {
                    if (form.elements[i].options[k].selected) {
                        name[j] = IBS_getName(form.elements[i]);

                        value[j] = form.elements[i].options[k].value;

                        j++;
                        increased++;
                    }
                }
                if (increased > 0) {
                    j--;
                } else {
                    value[j] = "";
                }
                j++;
                break;
            default:

                name[j] = IBS_getName(form.elements[i]);
                value[j] = form.elements[i].value;
                j++;
        }

        if (checkRequired) {
            //html 컨트롤 태그에 required속성을 설정하면 필수입력을 확인할 수 있다.
            //<input type="text" name="txtName" required="이름">
            if (IBS_RequiredChk(form.elements[i]) && prev_j != j && value[prev_j] == "") {
                if (form.elements[i].getAttribute("required") == "") {
                    alert('"' + IBS_getName(form.elements[i]) + '"' + IBS_MSG_REQUIRED);
                } else {
                    alert('"' + form.elements[i].getAttribute("required") + '"' + IBS_MSG_REQUIRED);
                }
                //컨트롤이 숨겨져 있을수도 있으므로 에러 감싼다.
                try {
                    form.elements[i].focus();
                } catch (ee) {;
                }

                return;
            }
        }
    }

    //QueryString을 조합한다.
    for (i = 0; i < j; i++) {
        if (name[i] != '') plain_text += encodeURIComponent(name[i]) + "=" + encodeURIComponent(value[i]) + "&";
    }

    //마지막에 &를 없애기 위함
    if (plain_text != "") plain_text = plain_text.substr(0, plain_text.length - 1);

    return plain_text;
}

/*------------------------------------------------------------------------------
 * titile : IBSheet의 조회,저장시 사용되는 함수
 * paramList :
 * param1 : s_SAVENAME 객체를 담고 있는 form 객체
 * param2 : 조회해야 할 시트 객체
 * param3.. : 여러개 시트를 한번에 조회하는 경우 시트의 개수만큼 붙인다.
-------------------------------------------------------------------------------*/
function IBS_SaveName() {
    var param = arguments;
    if (param.length < 2) {
        IBS_ShowErrMsg("최하 두개의 인자가 필요합니다.");
        return;
    }

	$("#s_SAVENAME").remove();
	$("<input></input>",{id:"s_SAVENAME",name:"s_SAVENAME",type:"hidden"}).appendTo(param[0]);

    if (param.length == 2) {
        param[0].s_SAVENAME.value = IBS_ConcatSaveName(param[1]);
    } else {
        param[0].s_SAVENAME.value = "";
        for (var i = 1; i < param.length; i++) {
            param[0].s_SAVENAME.value += IBS_ConcatSaveName(param[i]) + "@@";
        }
        var tempStr = param[0].s_SAVENAME.value;
        param[0].s_SAVENAME.value = tempStr.substring(0, tempStr.length - 2);
    }
}

function IBS_ConcatSaveName(sheet) {
    var lr  = sheet.GetDataRows();
    var lc  = sheet.LastCol();
    var res = [];
    var r   = 0;
    var c   = 0;
    var cn  = "";
    var sn  = "";

    for (r = 0; r < lr; r++) {
        for (c = 0; c <= lc; c++) {
            cn = sheet.GetColName(c);
            sn = sheet.ColSaveName(r, c);

            if (cn !== sn) {
                res.push(sn);
            }
        }
    }

    //return res.join("|");
    return res.join(",");
}

/*------------------------------------------------------------------------------
 * method : GetSaveJson
 * desc : 지정한 상태에 대한 데이터를 json 형태로 반환한다.
 * param list
 * param1 : IBSheet Object
 * param2 : 상태 (I|U|D)
 * param3 : SkipCol list
-------------------------------------------------------------------------------*/
function GetSaveJson2(sheet, status, skipcols) {
    if (sheet == null) {
        alert("GetSaveJson2 함수의 첫번째 인자는 ibsheet 객체여야 합니다.");
        return;
    }

    var skipcolsArr = null;
    if (skipcols != null) {
        skipcolsArr = skipcols.split("|");
    }

    var rtnJson = {};
    if (status == null) {
        var temp = GetJsonStatus(sheet, "I", skipcolsArr);
        if (temp) rtnJson["INSERT"] = temp;
        temp = GetJsonStatus(sheet, "D", skipcolsArr);
        if (temp) rtnJson["DELETE"] = temp;
        temp = GetJsonStatus(sheet, "U", skipcolsArr);
        if (temp) rtnJson["UPDATE"] = temp;
    } else {
        switch (status) {
            case "I":
                rtnJson["INSERT"] = GetJsonStatus(sheet, "I", skipcolsArr);
                break;
            case "U":
                rtnJson["UPDATE"] = GetJsonStatus(sheet, "U", skipcolsArr);
                break;
            case "D":
                rtnJson["DELETE"] = GetJsonStatus(sheet, "D", skipcolsArr);
                break;
        }
        GetJsonStatus(sheet, status)
    }
    return rtnJson;
}

function GetJsonStatus(sheet, status, skipcolsArr) {
    var rtnJson = new Array();
    //지정한 상태 값을 갖는 행을 뽑는다.
    var rows = sheet.FindStatusRow(status);

    if (rows == "") return null;

    var rowArr = rows.split(";");

    for (var i = 0; i < rowArr.length; i++) {
        var temp = sheet.GetRowJson(rowArr[i]);
        if (skipcolsArr != null) {
            for (var c = 0; c < skipcolsArr.length; c++) {
                delete temp[skipcolsArr[c]];
            }
        }
        rtnJson.push(temp);
    }
    return rtnJson;
}

/**
    IBSheet 초기화 작업을 일괄 처리 한다.
    @method     IBS_InitSheet
    @public
    @param      {object}    sheet               대상 시트 객체
    @param      {object}    info                초기화 정보
    @param      {object}    info.Cols           컬럼 초기화 정보 객체
    @param      {object}    [info.Cfg]          시트 초기화 정보 객체
    @param      {object}    [info.Headers]      헤더 초기화 정보 객체
    @param      {object}    [info.HeaderMode]   헤더 모드 정보 객체
    @param 		number		refresh				초기화 여부
*/
function IBS_InitSheet(sheet, info, refresh) {
    var cInfo         = {},
        colsHeader    = [],
        useColsHeader = 0,
        max           = 0,
        cnt           = 0,
        dataRows      = 1;

    function appendHeaderText(last, col, header) {
        var unitHeader = header.split("|"),
            i          = 0,
            len        = 0;

        useColsHeader = 1;
        len = unitHeader.length;

        if (cnt < len) {
            cnt = len;
        }

        for (i = 0; i < len; i++) {
            if (typeof colsHeader[last + i] === "undefined") {
                colsHeader[last + i] = [];
            }

            colsHeader[last + i][col] = unitHeader[i];
        }
    };

    // 필수 입력 요소 체크
    if (!sheet || !info || !info.Cols) {
        alert("시트 초기화 정보가 올바르지 않습니다.");
        return;
    }

    cInfo = CloneArray(info);

    // DataRows 설정
    if (cInfo.Cols[0] && typeof cInfo.Cols[0].length !== "undefined") {
        dataRows = cInfo.Cols.length;
    }

    // Cfg 기본값 설정
    if (!cInfo.Cfg) {
        cInfo.Cfg = {};
    }

    // Headers 기본값 설정
    if (!cInfo.Headers) {
        cInfo.Headers = [{
            Text: "",
            Align: "Center"
        }];
    }

    // HeaderMode 기본값 설정 및 Align 처리
    if (!cInfo.HeaderMode) {
        cInfo.HeaderMode = {};
    } else {
        if (cInfo.HeaderMode.Align) {
            var header = cInfo.Headers;
            for (var i = 0, len = header.length; i < len; i++) {
                header[i].Align = cInfo.HeaderMode.Align;
            }
        }
    }

    for (var i = 0, len = cInfo.Cols.length; i < len; i++) {
        var col = cInfo.Cols[i];

        if (typeof col.Header === "undefined") {
            for (var j = 0, len2 = col.length; j < len2; j++) {
                var col2 = col[j];

                if (typeof col2.Header !== "undefined") {
                    appendHeaderText(max, j, col2.Header);
                    delete col2.Header;
                }
            }

            max += cnt;
            cnt = 0;
        } else {
            appendHeaderText(0, i, col.Header);
            delete col.Header;
        }
    }

    if (useColsHeader) {
        cInfo.Headers = [];
        for (var i = 0, len = colsHeader.length; i < len; i++) {
            var header = {};

            if (typeof colsHeader[i] === "undefined") {
                header.Text = "";
            } else {
                header.Text = colsHeader[i].join("|");
            }

            header.Align = cInfo.HeaderMode.Align || "Center";
            cInfo.Headers.push(header);
        }
    }

    sheet.SetConfig(cInfo.Cfg, refresh);
    sheet.InitHeaders(cInfo.Headers, cInfo.HeaderMode);
    sheet.InitColumns(cInfo.Cols, dataRows);
    
    //헤더 소트 시 포커스를 초기화함. 2020.02.19 jylee
    sheet.SetHighlightAfterSort(0);
	
	//헤더 필터링 기능 처리
	sheet.SetHeaderActionMenu("필터 표기|필터 미표기","_ibShowFilter|_ibHideFilter");
	
	// 지정 시트에 이벤트 추가 혹은 재설정 처리
	addOrOverrideSheetAction(sheet.id);
    
    /*
    sheet.oldDown2Excel = sheet.Down2Excel;
    sheet.Down2Excel = function(param){
    	var param = param||{};
    	//param["FileName"] = "Excel.xlsx";
    	if(typeof(param["FileName"]) == "undefined"){
    		param["FileName"] = "Excel.xlsx";
    	}
    	
    	sheet.oldDown2Excel(param);
    }
    */
    
    // 엑셀다운로드시 파일명(Default :Excel.xlsx)에 일자정보 append 공통처리 위해 Override. by hyungyu@infac 
    var fileNameChgYn = true;
    if(fileNameChgYn){
    	var originalFn = sheet.Down2Excel;
    	sheet.Down2Excel = function(param){

            /* 모바일 다운로드 허용 확인 로직 추가(24.09.26) */
            if (!isDown) {
                // 모바일 접속이며, 모바일 다운로드 미허용인 경우,
                alert('모바일 다운로드를 허용하지 않습니다.');
                return;
            }

    		// FileName 옵션이 지정하지 않은 경우만.
    		var newParam = param;
    		try {
    			if(!newParam)newParam = {};
    			if(!newParam.FileName){
    				//var sheetTitle = $(".sheet_title").eq(0).find("li.txt").eq(0).text();
    				var sheetTitle = "";
    				if($(".sheet_title").eq(0).find("li.txt").length > 0){
    					sheetTitle = $(".sheet_title").eq(0).find("li.txt")[0].childNodes[0].nodeValue;
    					//log.info(sheetTitle);
    				}
    				
    				// 여러시트가 혼재할 경우 시트 위쪽 타이틀영역 찾기.
    				var $_prevEl = $("div#DIV_"+sheet.id).prev();
    				if($_prevEl.length == 1){
    					if($_prevEl[0].tagName.toLowerCase() == "script"){
    						$_prevEl = $_prevEl.prev();
    					}
    					var _tmpTitle = sheetTitle;
    					if($_prevEl.find(".sheet_title").eq(0).find("li.txt").length > 0){
    						_tmpTitle = $_prevEl.find(".sheet_title").eq(0).find("li.txt")[0].childNodes[0].nodeValue;
    					}
    					if(_tmpTitle && _tmpTitle != ""){
    						sheetTitle = _tmpTitle;
    					}
    				}
    				
    				sheetTitle = $.trim(sheetTitle);
    				var curDate = new Date();
    				newParam.FileName = "Excel";
    				if(sheetTitle != "") newParam.FileName = sheetTitle;
    				newParam.FileName += "_" + $.datepicker.formatDate("yymmdd", curDate) + curDate.getHours() + curDate.getMinutes(); // + curDate.getSeconds();    				
    			}
    		} catch (e) {
    			// ignore error.
    			newParam = param;
    		}
    		newParam.FileName = replaceAll(newParam.FileName,'.','_')+".xlsx";
    		newParam.ExcelRowHeight = "20";  // 행 높이 (26픽셀)  2020.02.10 jylee
    		newParam.ExcelFontSize  = "9"; //폰트 Size 2020.02.10 jylee
    		newParam.CheckBoxOnValue  = "O"; //체크박스 표시 값 2020.06.09 jylee
    		newParam.CheckBoxOffValue  = " "; //체크박스 표시 값 2020.06.09 jylee
    		originalFn.call(sheet, newParam);
    	};
    }
    
    
    if(false) {
    	var dataHeader = "";
    	for(var i = 0; i < info.Cols.length; i++) {
    		if(i == 0) {
    			dataHeader = info.Cols[i].Header.replace(/\n/gi, '\\n');
    		} else {
    			dataHeader += "`"+info.Cols[i].Header.replace(/\n/gi, '\\n');
    		}
    	}

    	var dataParam = {header:""+dataHeader+"",saveName:""+IBS_ConcatSaveName(sheet)+""};
        var	dataReturn = ajaxCall("/ShtDataMg.do?cmd=saveShtDataMgr",$.param(dataParam),false);

        if(dataReturn != null && dataReturn.Result != null) {
        	alert(dataReturn.Result.Message);
        }
    }
}

/*------------------------------------------------------------------------------
* method : IBS_CopyJson2Form
* desc : json 데이터를 이름을 기준으로 폼객체에 넣는다.
* param list
* param1 : json 객체
* param2 : 대상 폼 name

json 자료 구조 :
{"폼객체명":{"객체명":"값","객체명2":"값2"}}
ex){"aFrm":{"sa_no":"12345","sa_name":"손이창","grade":"a3","married":"NO","enter_date":"2012-12-31"}}
-------------------------------------------------------------------------------*/
function IBS_CopyJson2Form(jsonobj, frmName) {
    var json,
        obj,
        stype,
        idx,
        max;

    if (typeof frmName == "object") {
        frmName = frmName.name;
    }

    json = jsonobj[frmName];

    for (j in json) {
        obj = null;

        try {
            obj = document[frmName][j];
            if (obj == null || typeof obj == "undefined") {
                obj = document.getElementById(j);
            }
            if (obj == null || typeof obj == "undefined") {
                continue;
            }
        } catch (e) {
            //alert(e.message);
        }

        stype = (obj.type);

        if (typeof stype == "undefined" && obj.length > 0) {
            stype = obj[0].type;
        }

        switch (stype) {
            case undefined:
            case "button":
            case "reset":
            case "submit":
                break;
            case "select-one":
                obj.value = json[j];
                break;
            case "radio":
                obj.checked = json[j];
                break;
            case "checkbox":
                obj.checked = json[j];
                break;
            default:
                obj.value = json[j];
                break;
        } //end of switch
    }
}

/*------------------------------------------------------------------------------
method : IBS_CopyForm2Sheet()
desc  : Form객체에 있는 내용을 시트에 복사
param list
param : json 유형

param 내부 설정값
sheet : 값을 입력 받을 ibsheet 객체 (필수)
form : copy할 폼객체 (필수)
row : ibsheet 객체의 행 (default : 현재 선택된 행)
sheetPreFiex : 맵핑할 시트의 SavaName 앞에 PreFix 문자 (default : "")
formPreFiex : 맵핑할 폼객체의 이름 혹은 id 앞에  PreFix 문자 (default : "")
useOnChange : 시트값 변경시 OnChange 이벤트 사용 유무 (default : false)
-------------------------------------------------------------------------------*/
function IBS_CopyForm2Sheet(param) {
    var sheetobj,
        formobj,
        row,
        sheetPreFix,
        frmPreFix,
        uoc,
        col,
        max,
        colSaveName,
        baseSaveName,
        frmchild,
        sType,
        sValue;

    if ((!param.sheet) || (!param.sheet.IBSheetVersion)) {
        IBS_ShowErrMsg("IBS_CopyForm2Sheet 함수의 sheet 인자가 없거나 ibsheet객체가 아닙니다.");
        return false;
    }
    if (param.form == null || typeof param.form != "object" || param.form.tagName != "FORM") {
        IBS_ShowErrMsg("IBS_CopyForm2Sheet 함수의 form 인자가 없거나 FORM 객체가 아닙니다.");
        return false;
    }

    sheetobj = param.sheet;
    formobj = param.form;
    row = param.row == null ? sheetobj.GetSelectRow() : param.row;
    sheetPreFix = param.sheetPreFix == null ? "" : param.sheetPreFix;
    frmPreFix = param.formPreFix == null ? "" : param.formPreFix;
    uoc = param.useOnChange == null ? 0 : param.useOnChange;
    if (row < 0) {
        alert("선택된 행이 존재하지 않습니다.");
        return;
    }

    //Sheet의 컬럼개수만큼 찾아서 HTML의 Form 각 Control에 값을 설정한다.
    //컬럼개수만큼 루프 실행
    for (col = 0, max = sheetobj.LastCol(); col <= max; col++) {
        //컬럼의 별명을 문자열로 가져온다.
        colSaveName = sheetobj.ColSaveName(col)
        if (colSaveName == "") {
            continue;
        }
        //PreFix가 붙지 않은 형태의 SaveName을 가져온다.
        baseSaveName = colSaveName.substring(sheetPreFix.length);

        frmchild = null;
        try {
            //폼에 있는 해당 이름의 컨트롤을 가져온다.예)"frm_CardNo"
            frmchild = formobj[frmPreFix + baseSaveName];
        } catch (e) {
            alert(e);
        }

        //폼에 해당하는 이름의 컨트롤이 없는 경우는 계속 진행한다.
        if (frmchild == null) continue;

        sType = frmchild.type;
        sValue = "";

        //radio의 경우 frmchild가 배열형태가 되므로, frmchild.type으로는 타입을 알수 없다.
        if (typeof sType == "undefined" && frmchild.length > 0) {
            sType = frmchild[0].type;
        }

        //타입별로 값을 설정한다.
        switch (sType) {
            case undefined:
            case "button":
            case "reset":
            case "submit":
                break;
            case "radio":
                for (idx = 0; idx < frmchild.length; idx++) {
                    if (frmchild[idx].checked) {
                        sValue = frmchild[idx].value;
                        break;
                    }
                }
                break;
            case "checkbox":
                sValue = (frmchild.checked) ? 1 : 0;
                break;
            default:
                sValue = frmchild.value;
        } //end of switch

        sheetobj.SetCellValue(row, sheetPreFix + baseSaveName, sValue, uoc);
    } //end of for(col)

    //정상적인 처리완료
    return true;
}

/*----------------------------------------------------------------------------
method : IBS_CopySheet2Form()
desc : 시트의 한 행을 폼객체에 복사

param list
param : json 유형

param 내부 설정값
sheet : 값을 입력 받을 ibsheet 객체 (필수)
form : copy할 폼객체 (필수)
row : ibsheet 객체의 행 (default : 현재 선택된 행)
sheetPreFiex : 맵핑할 시트의 SavaName 앞에 PreFix 문자 (default : "")
formPreFiex : 맵핑할 폼객체의 이름 혹은 id 앞에  PreFix 문자 (default : "")
-----------------------------------------------------------------------------*/
function IBS_CopySheet2Form(param) {
    var sheetobj,
        formobj,
        row,
        sheetPreFix,
        frmPreFix,
        col,
        max,
        colSaveName,
        baseSaveName,
        sheetvalue,
        frmchild,
        sType,
        sValue;

    if ((!param.sheet) || (!param.sheet.IBSheetVersion)) {
        IBS_ShowErrMsg("IBS_CopyForm2Sheet 함수의 sheet 인자가 없거나 ibsheet객체가 아닙니다.");
        return false;
    }

    if (param.form == null || typeof param.form != "object" || param.form.tagName != "FORM") {
        IBS_ShowErrMsg("IBS_CopyForm2Sheet 함수의 form 인자가 없거나 FORM 객체가 아닙니다.");
        return false;
    }
    sheetobj = param.sheet;
    formobj = param.form;
    row = param.row == null ? sheetobj.GetSelectRow() : param.row;
    sheetPreFix = param.sheetPreFix == null ? "" : param.sheetPreFix;
    frmPreFix = param.formPreFix == null ? "" : param.formPreFix;

    if (row < 0) {
        alert("선택된 행이 존재하지 않습니다.");
        return;
    }

    //Sheet의 컬럼개수만큼 찾아서 HTML의 Form 각 Control에 값을 설정한다.
    //컬럼개수만큼 루프 실행
    for (col = 0, max = sheetobj.LastCol(); col <= max; col++) {
        //컬럼의 별명을 문자열로 가져온다.
        colSaveName = sheetobj.ColSaveName(col)
        if (colSaveName == "") {
            continue;
        }
        //PreFix가 붙지 않은 형태의 SaveName을 가져온다.
        baseSaveName = colSaveName.substring(sheetPreFix.length);

        sheetvalue = sheetobj.GetCellText(row, sheetPreFix + baseSaveName);

        frmchild = null;
        try {
            //폼에 있는 해당 이름의 컨트롤을 가져온다.예)"frm_CardNo"
            frmchild = formobj[frmPreFix + baseSaveName];
        } catch (e) {

        }

        //폼에 해당하는 이름의 컨트롤이 없는 경우는 계속 진행한다.
        if (frmchild == null) {
            continue;
        }

        sType = frmchild.type;
        sValue = "";
        //radio의 경우 frmchild가 배열형태가 되므로, frmchild.type으로는 타입을 알수 없다.
        if (typeof sType == "undefined" && frmchild.length > 0) {
            sType = frmchild[0].type;
        }

        //타입별로 값을 설정한다.
        switch (sType) {
            case undefined:
            case "button":
            case "reset":
            case "submit":
                break;
            case "select-one":
                frmchild.value = sheetobj.GetCellValue(row, sheetPreFix + baseSaveName);
                break;
            case "radio":
                for (idx = 0, max = frmchild.length; idx < max; idx++) {
                    if (frmchild[idx].value == sheetvalue) {
                        frmchild[idx].checked = true;
                        break;
                    }
                }
                break;
            case "checkbox":
                frmchild.checked = (sheetobj.GetCellValue(row, sheetPreFix + baseSaveName) == 1);
                break;
            default:
                frmchild.value = sheetvalue;
                break;
        } //end of switch
    } //end of for(col)

    //정상적인 처리완료
    return true;
}
/*-----------------------------------------------------------------------------
- 지정한 컬럼의 셀값을 리턴한다.
- cols : "|"로 구분한 컬럼 saveName
- status : ""이면 전체, 값이 있으면 상태값 컬럼 
-----------------------------------------------------------------------------*/
function IBS_GetColValue(sheet, cols, status) {

    var colsArr = null;
    if( cols == null || cols == undefined || cols == "") {
    	return "";
    }else{
    	colsArr = cols.split("|");
    }
    var rows="";
    if( status == null || status == undefined || status == "") {
    	rows = sheet.FindStatusRow("R|I|U|D"); //상태값에 해당하는 행
    }else{
    	rows = sheet.FindStatusRow(status); //상태값에 해당하는 행
    }
	var rowsArr = rows.split(";");
    
    var str = "";
    for(var i = 0; i < colsArr.length ; i++) {
    	for(var j = 0; j < rowsArr.length ; j++) {
    		str = str +"&"+colsArr[i]+"="+sheet.GetCellValue(rowsArr[j], colsArr[i]);
    	}
    	
    }
    return str;
}


function IBS_setChunkedOnSave(sheetid, options) {
	window[sheetid].chunkOption = options;
}

/**
 * 지정 시트에 이벤트 추가 혹은 재설정 처리
 * DoSearch 혹은 DoSave 작업시 웹위변조, 파라미터 난도화등 Third-party 솔루션의 작업이 필요한 경우 수정하여 사용함.
 * ibsheet의 버전이 변경되는 경우 DoSearch, DoSave의 함수의 원본 script 내용을 찾아 파라미터 삽입 부분에 난독화 처리하여 override 한다.
 * 원본 script의 내용은 addOrOverrideSheetAction 함수 실행 부분을 주석 처리 후 console.log에서 함수를 toString으로 출력하여 확인한다.
 *     [ex] console.log('DoSearch', sheet1.DoSearch.toString());
 *     [ex] console.log('DoSave', sheet1.DoSave.toString());
 * @param sheetid
 * @returns
 */
function addOrOverrideSheetAction(sheetid) {
    /* 2024.07.26 수정 */
    /**
     * [Added Method] DoSearch : 파라미터 난독화 추가
     */
    window[sheetid].DoSearch = function(y,x,w){
        var A, B, C, D, E, F, G, H, I, J, K, L, M;
        A = this["SearchSync"], B = 0, G = -1, E = 0, F = {}, H = null;
        if (typeof w !== "undefined") {
            if (typeof w === "object") {
                A = this.kA(w["Sync"], this["SearchSync"]);
                B = this.fA(w["Append"], 0);
                E = this.fA(w["Fx"], 0);
                F = w["ReqHeader"] || w["reqHeader"] || {};
                G = this.wMB(w["AppendRow"]);
                H = w["CallBack"]
            } else {
                A = this.kA(w, this["SearchSync"])
            }
        }
        this.nI(B);
        if (E) {
            this["LoadFx"] = 1
        }
        this.Data.Data.Url = y;
        this.Data.Data.Timeout = this["WaitTimeOut"];
        this.Data.Data.Repeat = 0;
        this.Data.Data.Append = B;
        this.Data.Data.qP = G;
        this.Data.Data.Header = F;
        this.Data.Data.Sync = A == 2 ? 1 : 0;
        this.Data.Data.lC = "";

        if (x) {
            if (!A && this.fT) {
                x = encodeURI(x)
            }
            I = "", K = [], M = [], L = [], D = x;
            try {
                J = JSON.parse(D);
                D = J;
                I = typeof(J)
            } catch (z) {
                I = typeof(D)
            }

            //파라미터 난독화

            var params = null;
            /*
            if(A == 0) {
                params = EncParams(params);
            }
            */
            params = x;
            this.Data.Data.lC = x
        }
        this.ShowProcessDlg("Search");
        if (A == 1) {
            this.Source.Data.Sync = 0;
            C = CloneArray(this.Data.Data);
            C["method"] = "DoSearch";
            C.aCC = E;
            this.eU(C)
        } else {
            this.lE = y;
            this.wI(B, H)
        }
    };

    /**
     * [Added Method] DoSave : 파라미터 난독화 및 분할저장 프로세스 추가
     */
    window[sheetid].DoSave = function(y,x,w,v,u,t,s){
        var A, B, C, D, E, F, G, H, I, J;

        var rtnData      = null;
        var rtnDataJSON  = null;
        var isExeChunked = false;
        var chunkSize    = 150;

        // 분할 저장 여부 확인 및 설정
        if(this.chunkOption != null && this.chunkOption != undefined) {
            isExeChunked = true;
            if(this.chunkOption.chunkSize != null && this.chunkOption.chunkSize != undefined) {
                chunkSize = this.chunkOption.chunkSize;
            }
        }
        console.log("chunked options", "isExeChunked : " + isExeChunked + ", chunkSize : " + chunkSize);


        A = {}, D = {}, H = 1, G = 1, J = 0, C = 0, B = "", E = 0, I = 0, F = null;
        this["IO"] = {};
        this["Message"] = "";
        J = this.EndEdit(1);
        if (J == -1) {
            CancelEvent(window.event, 1);
            return false
        }

        if (x && typeof x === "object") {
            A = x;
            x = A["Param"];
            w = A["Col"];
            v = A["Quest"];
            u = A["UrlEncode"];
            t = A["Mode"];
            s = A["Delim"];
            D = A["ReqHeader"] || A["reqHeader"] || {};
            C = this.kA(A["Sync"], 0);
            H = A["ValidKeyField"];
            G = A["ValidFullInput"];
            E = A["ValidEditLen"];
            I = A["ValidMinLen"];
            F = A["CallBack"];
            u = A["UrlEncode"]
        }
        if (typeof w == "undefined" || w < 0) {
            w = -1
        }
        v = this.fA(v, 1);
        if (typeof x == "object" && D && D["Content-Type"] && D["Content-Type"].indexOf("application/json") > -1) {
            B = this.GetSaveJson({
                "AllSave": 0,
                "ValidKeyField": H,
                "ValidFullInput": G,
                "ValidEditLen": E,
                "ValidMinLen": I
            })
        } else {
            B = this.oEB({
                "AllSave": 0,
                "UrlEncode": this.fA(u, 1),
                "Col": w,
                "Mode": t,
                "Delim": s,
                "ValidKeyField": H,
                "ValidFullInput": G,
                "ValidEditLen": E,
                "ValidMinLen": I
            }, 1)
        }
        if (this["SaveEncodeURI"]) {
            B = encodeURI(B)
        }
        if (B == "KeyFieldError" || B == "EditLenError" || B == "MinLenError") {
            this.HideProcessDlg();
            return false
        }
        if (B.length <= 0) {
            this.ShowAlert(this.GetText("EmptySaveContent"), "U");
            this.HideProcessDlg();
            return false
        } else {
            this.Source.Upload.Params = B
        }
        this["ChgIndex"] = 1;

        // 분할하여 저장하지 않는 경우
        if( !isExeChunked ) {
            if (x) {
                this.Source.Upload.lC = x
            }
            this.Source.Upload.Timeout = this["WaitTimeOut"];
            this.Source.Upload.Repeat = 0;
            this.Source.Upload.Header = D;
            if (v) {
                if (this.ShowAlert(this.GetText("SaveConfirm"), "U", 1)) {
                    if (!C) {
                        this.ShowProcessDlg("Save")
                    }
                    this.Source.Upload.Url = y;
                    this.tX();
                    this.Save(null, C, F)
                } else {
                    return false
                }
            } else {
                if (!C) {
                    this.ShowProcessDlg("Save")
                }
                this.Source.Upload.Url = y;
                this.tX();
                this.Save(null, C, F)
            }
        } else {
            // 분할하여 저장하는 경우
            this.Source.Upload.Timeout = this["WaitTimeOut"];
            this.Source.Upload.Repeat = 0;
            this.Source.Upload.Header = D;

            if(!C){
                // 저장중 대기이미지를 표시 한다..
                this.ShowProcessDlg("Save");
                if(getBrowser() != "IE") {
                    $(".GMProcess").append('<p id="txt_progress" class="bg_white f_s13 f_gray_3 f_red f_bold">init..</p>');
                }
            }

            var isContinues = true;

            if(v){
                if(!this.ShowAlert(this.GetText("SaveConfirm"),"U",1)){
                    isContinues = false;
                }
            }

            if(isContinues) {
                var chunkParamArr = null;
                var saveJson = this.GetSaveJson();
                //console.log('DoSaveEnc_saveJson', saveJson);

                if( saveJson != null && saveJson != undefined && saveJson.data != null && saveJson.data != undefined && saveJson.data.length > 0) {
                    var chunkedQueryStr = "";
                    chunkParamArr = new Array();

                    for(var i = 0; i < saveJson.data.length; i++) {
                        //console.log('parse json', $.param(saveJson.data[i]));

                        if( chunkedQueryStr != "" ) {
                            chunkedQueryStr += "&";
                        }
                        chunkedQueryStr += $.param(saveJson.data[i]);

                        if( (i + 1) % chunkSize == 0 ) {
                            //console.log(i);
                            chunkParamArr.push(chunkedQueryStr);
                            chunkedQueryStr = "";
                        }
                    }

                    if( chunkedQueryStr != "" ) {
                        chunkParamArr.push(chunkedQueryStr);
                    }
                }

                if( chunkParamArr != null && chunkParamArr.length > 0 ) {
                    var sendParams = "";
                    var processCnt = 0;

                    // 마지막 Chunk 전까지 ajaxCall을 이용하여 저장 처리함.
                    for(var idx = 0; idx < chunkParamArr.length; idx++) {
                        //console.log('chunkParamArr', chunkParamArr[idx]);
                        sendParams = chunkParamArr[idx];
                        if(typeof x === "string") {
                            sendParams += "&" + x;
                        } else if (typeof opt === "object") {
                            sendParams += "&" + x.Param;
                        }

                        // 난독화 처리
                        //sendParams = EncParams(sendParams);

                        // 저장 실행
                        rtnData = this.GetSaveData(y, sendParams);
                        //console.log('rtnData', rtnData);
                        if( rtnData != null && rtnData != undefined && rtnData != "" ) {
                            rtnDataJSON = $.parseJSON(rtnData);
                            if( rtnDataJSON.Result.Code == -1 ) {
                                break;
                            } else {
                                processCnt += chunkSize;
                                if( processCnt > saveJson.data.length ) {
                                    processCnt = saveJson.data.length;
                                }
                                //console.log('progress', processCnt + "/" + saveJson.data.length + " Complete");
                                if(getBrowser() != "IE") {
                                    if($(".GMProcess #txt_progress").length > 0) {
                                        $(".GMProcess #txt_progress").text( processCnt + "/" + saveJson.data.length + " Complete" );
                                    }
                                }
                            }
                        }
                    }
                    this.LoadSaveData(rtnData);
                }
            } else {
                this.HideProcessDlg();
                return false;
            }
        }
        return true;
    };

    /**
     * DirectDown2Excel, 헤더 정보만 가져도오록 함
     * */
    window[sheetid].DirectDown2Excel =  function(y){
        var A;
        A="";

        // 조회 결과 제외하고 헤더정보만 넘김(조회 결과를 넘기는 경우, 데이터가 중복으로 다운로드 됨)
        y.DownRows = '';
        for(var idx=0; idx<window[sheetid].HeaderRows(); idx++){
            y.DownRows += idx+'|';
        }

        A=this.Down2Excel(y,true);
        if(y||y["DebugMode"]){return A}
    }
    /**
     * 엑셀 다운로드 실행전 처리를 위한 이벤트명 변경
     */
    window[sheetid].Down2ExcelOrigin = window[sheetid].Down2Excel;
    window[sheetid].Down2Excel = function(x,y) {
    	//alert(sheetid + "/" + window.location.href);
    	//console.log('x', x);
    	//console.log('y', y);

    	// 개인정보포함된 내용 다운로드시 사유 등록이 비활성화된 경우 다운로드 진행
    	if(!isUseDownloadReasonReg) {
    		window[sheetid].Down2ExcelOrigin(x,y);

    	} else {

    		// 개인정보항목 포함여부
    		var isContains = false;

    		//console.log('x.DownCols', x.DownCols);
    		//console.log('x.DownRows', x.DownRows);

    		// 다운로드 컬럼정보
    		var cols = x.DownCols;
    		var rows = x.DownRows;

    		// 데이터 다운로드 여부
    		var isDownData = false;
    		if( rows != undefined && rows != null ) {
    			var rowArr = null;
    			if( typeof rows == "string" && rows.indexOf("|") > -1 ) {
    				rowArr = rows.split("|");
    			} else {
    				rowArr = [parseInt(rows)];
    			}
    			//console.log('rowArr', rowArr);

    			for(var row = 0; row < rowArr.length; row++) {
    				if( (row + 1) > window[sheetid].HeaderRows() ) {
    					isDownData = true;
    					break;
    				}
    			}
    		} else {
    			isDownData = true;
    		}

    		// 데이터가 존재하는 경우 개인정보 포함 여부 체크 진행
    		if( isDownData && (window[sheetid].RowCount() > 0) && (cols != null && cols != undefined) ) {
    			var arr = cols.split("|");
    			var colIdx   = null;
    			var cellText = null;
    			var saveName = null;
    			var i,j = 0;

    			// 다운로드 대상 컬럼의 정보가 컬럼 인덱스가 아닌 SaveName으로 되어 있는 경우 컬럼 Index로 변환 처리
    			//console.log('before arr', arr);
    			for(i = 0; i < arr.length; i++) {
    				if( !isNumber(arr[i], "") ) {
    					for(j = 0; j <= window[sheetid].LastCol(); j++) {
    						if( window[sheetid].ColSaveName(0, j) == arr[i] ) {
    							arr[i] = j;
    							break;
    						}
    					}
    				}
    			}
    			//console.log('after arr', arr);

    			for(i = 0; i < arr.length; i++) {
    				saveName = window[sheetid].ColSaveName(0, arr[i]).toLowerCase();
    				for(j = 0; j < window[sheetid].HeaderRows(); j++) {
    					cellText = window[sheetid].GetCellText(j, arr[i]);
    					//console.log('COL['+i+']['+j+']', cellText + ',' + saveName);

    					if( cellText.indexOf("주민번호") > -1
    							|| cellText.indexOf("주민등록번호") > -1
    							|| cellText.indexOf("핸드폰") > -1
    							|| cellText.indexOf("휴대폰") > -1
    							|| cellText.indexOf("생년월일") > -1
    							|| saveName.indexOf("birth") > -1
    							|| saveName.indexOf("birymd") > -1
    							|| saveName.indexOf("handphone") > -1
    							|| saveName.indexOf("resno") > -1
    					) {
    						isContains = true;
    						break;
    					}
    				}
    			}
    		}

    		// 다운로드 대상 항목에 개인정보가 포함된 경우
    		if( isContains ) {
                if(!isPopup()) {return;}

                let url 	= "/DownloadReasonSta.do?cmd=viewDownloadReasonStaRegLayer&authPg=A";
                let w    = 840;
                let h    = 330;
                let prgCd = (thisUrl.indexOf("/") == 0) ? thisUrl.substring(1, thisUrl.length) : thisUrl;

                if( prgCd == null || prgCd == undefined || prgCd == "" ) {
                    prgCd = document.location.href.substring(document.location.href.lastIndexOf("/") + 1, document.location.href.length);
                }

                let args = {
                    prgCd : prgCd,
                    fileNm : x.FileName,
                    sheetId : sheetid
                };

                let layerModal = new window.top.document.LayerModal({
                    id: 'downloadReasonStaRegLayer',
                    url: url,
                    parameters: args,
                    width: w,
                    height: h,
                    title: '파일 다운로드 사유 등록',
                    trigger: [
                        {
                            name: 'downloadReasonStaRegLayerTrigger',
                            callback: function(rv) {
                                // 사유 등록 완료한 경우 다운로드 진행
                                if( rv != null && rv != undefined && rv == "OK" ) {
                                    window[sheetid].Down2ExcelOrigin(x,y);
                                }
                            }
                        }
                    ]
                });
                layerModal.show();
    		} else {
    			// 다운로드 진행
    			window[sheetid].Down2ExcelOrigin(x,y);
    		}
    	}
    };

    /* 2024.07.26 ibsheet.js 파일 버전 업 이후 아래 코드 사용 하지 않음.*/
    // /**
    //  * [Added Method] DoSearch : 파라미터 난독화 추가
    //  */
	// window[sheetid].DoSearch = function(y,x,w){
	// 	var A,B,C,D,E,F,G,H,I,J,K,L,M,N;
	// 	A=this["SearchSync"],C=0,J=-1,E=0,M={},I=null;
    //
	// 	if(typeof w!=="undefined"){
	// 		if(typeof w==="object"){
	// 			A=this.kA(w["Sync"],this["SearchSync"]);
	// 			C=this.eA(w["Append"],0);
	// 			E=this.eA(w["Fx"],0);
	// 			M=w["ReqHeader"]||w["reqHeader"]||{};
	// 			J=this.zMB(w["AppendRow"]);
	// 			I=w["CallBack"]
	// 		} else {
	// 			A=this.kA(w,this["SearchSync"]);
	// 		}
	// 	}
	//
	// 	this.aJ(C);
	//
	// 	if(E){
	// 		this["LoadFx"]=1;
	// 	}
	//
	// 	this.Data.Data.Url=y;
	// 	this.Data.Data.Timeout=this["WaitTimeOut"];
	// 	this.Data.Data.Repeat=0;
	// 	this.Data.Data.Append=C;
	// 	this.Data.Data.mP=J;
	// 	this.Data.Data.Header=M;
	// 	this.Data.Data.Sync=A==2?1:0;
	// 	this.Data.Data.yC="";
	//
	// 	if(x){
	// 		if(!A && this.nQ){
	// 			x=encodeURI(x);
	// 		}
    //
	// 		D="",G=[],H=[],N=[],B=x;
    //
	// 		try{
	// 			L=JSON.parse(B);
	// 			B=L;
	// 			D=typeof(L);
	// 		} catch(z) {
	// 			D=typeof(B);
	// 		}
	//
	// 		var params = null;
	// 		if(D=="object"){
	// 			for(K in B){
	// 				G.push(K+":"+B[K]);
	// 			}
	// 			for(i=0,len=G.length;i<len;i++){
	// 				H=G[i].split(":");
	// 				N.push(H[0]+"="+H[1]);
	// 			}
	// 			//this.Source.Data.yC=N.join("&");
	// 			params = N.join("&");
	// 		} else {
	// 			params = x;
	// 		}
    //
	// 		//파라미터 난독화
	// 		/*
	// 		if(A == 0) {
	// 			params = EncParams(params);
	// 		}
	// 		*/
	// 		this.Data.Data.yC=params;
	// 	}
    //
	// 	this.ShowProcessDlg("Search");
    //
	// 	if(A==1){
	// 		this.Source.Data.Sync=0;
	// 		F=CloneArray(this.Data.Data);
	// 		F["method"]="DoSearch";
	// 		F.gIC=E;
	// 		this.gW(F);
	// 	} else {
	// 		this.hE=y;
	// 		this.dJ(C,I);
	// 	}
	// };
    //
	// /**
	//  * [Added Method] DoSave : 파라미터 난독화 및 분할저장 프로세스 추가
	//  */
	// window[sheetid].DoSave = function(y,x,w,v,u,t,s){
	// 	var A,B,C,D,E,F,G,H,I,J;
	// 	var rtnData      = null;
	// 	var rtnDataJSON  = null;
	// 	var isExeChunked = false;
	// 	var chunkSize    = 150;
    //
	// 	// 분할 저장 여부 확인 및 설정
	// 	if(this.chunkOption != null && this.chunkOption != undefined) {
	// 		isExeChunked = true;
	// 		if(this.chunkOption.chunkSize != null && this.chunkOption.chunkSize != undefined) {
	// 			chunkSize = this.chunkOption.chunkSize;
	// 		}
	// 	}
	// 	//console.log("chunked options", "isExeChunked : " + isExeChunked + ", chunkSize : " + chunkSize);
    //
	// 	A={},I={},H=1,G=1,F=0,C=0,B="",J=0,E=0,D=null;
	// 	this["IO"]={};
	// 	this["Message"]="";
	// 	F=this.EndEdit(1);
	// 	if(F==-1){
	// 		CancelEvent(window.event,1);
	// 		return false;
	// 	}
    //
	// 	if(x&&typeof x==="object"){
	// 		A=x;
	// 		x=A["Param"];
	// 		w=A["Col"];
	// 		v=A["Quest"];
	// 		u=A["UrlEncode"];
	// 		t=A["Mode"];
	// 		s=A["Delim"];
	// 		I=A["ReqHeader"]||A["reqHeader"]||{};
	// 		C=this.kA(A["Sync"],0);
	// 		H=A["ValidKeyField"];
	// 		G=A["ValidFullInput"];
	// 		J=A["ValidEditLen"];
	// 		E=A["ValidMinLen"];
	// 		D=A["CallBack"]
	// 	}
    //
	// 	if(typeof w == "undefined" || w < 0){
	// 		w=-1;
	// 	}
    //
	// 	v=this.eA(v,1);
	// 	B=this.nJB({
	// 			"AllSave"        : 0,
	// 			"UrlEncode"      : this.eA(u,1),
	// 			"Col"            : w,
	// 			"Mode"           : t,
	// 			"Delim"          : s,
	// 			"ValidKeyField"  : H,
	// 			"ValidFullInput" : G,
	// 			"ValidEditLen"   : J,
	// 			"ValidMinLen"    : E
	// 		},1);
    //
	// 	if(this["SaveEncodeURI"]){
	// 		B=encodeURI(B);
	// 	}
    //
	// 	if(B == "KeyFieldError" || B == "EditLenError" || B == "MinLenError"){
	// 		this.HideProcessDlg();
	// 		return false;
	// 	}
    //
	// 	if(B.length <= 0){
	// 		this.ShowAlert(this.GetText("EmptySaveContent"),"U");
	// 		this.HideProcessDlg();
	// 		return false;
	// 	} else {
	// 		this.Source.Upload.Params=B;
	// 	}
    //
	// 	this["ChgIndex"]=1;
    //
	// 	// 분할하여 저장하지 않는 경우
	// 	if( !isExeChunked ) {
    //
	// 		if(x){
	// 			this.Source.Upload.yC=x;
	// 			//파라미터난독화
	// 			//this.Source.Upload.yC=EncParams(x);
	// 		}
    //
	// 		this.Source.Upload.Timeout=this["WaitTimeOut"];
	// 		this.Source.Upload.Repeat=0;
	// 		this.Source.Upload.Header=I;
    //
	// 		if(v){
	// 			if(this.ShowAlert(this.GetText("SaveConfirm"),"U",1)){
	// 				if(!C){
	// 					this.ShowProcessDlg("Save");
	// 				}
	// 				this.Source.Upload.Url=y;
	// 				this.dX();
	// 				this.Save(null,C,D);
	// 			} else {
	// 				return false;
	// 			}
	// 		} else {
	// 			if(!C){
	// 				this.ShowProcessDlg("Save");
	// 			}
	// 			this.Source.Upload.Url=y;
	// 			this.dX();
	// 			this.Save(null,C,D);
	// 		}
    //
	// 	// 분할하여 저장하는 경우
	// 	} else {
    //
	// 		this.Source.Upload.Timeout=this["WaitTimeOut"];
	// 		this.Source.Upload.Repeat=0;
	// 		this.Source.Upload.Header=I;
    //
	// 		if(!C){
	// 			// 저장중 대기이미지를 표시 한다..
	// 			this.ShowProcessDlg("Save");
	// 			if(getBrowser() != "IE") {
	// 				$(".GMProcess").append('<p id="txt_progress" class="bg_white f_s13 f_gray_3 f_red f_bold">init..</p>');
	// 			}
	// 		}
    //
	// 		var isContinues = true;
    //
	// 		if(v){
	// 			if(!this.ShowAlert(this.GetText("SaveConfirm"),"U",1)){
	// 				isContinues = false;
	// 			}
	// 		}
    //
	// 		if(isContinues) {
    //
	// 			var chunkParamArr = null;
	// 			var saveJson = this.GetSaveJson();
	// 			//console.log('DoSaveEnc_saveJson', saveJson);
    //
	// 			if( saveJson != null && saveJson != undefined && saveJson.data != null && saveJson.data != undefined && saveJson.data.length > 0) {
	// 				var chunkedQueryStr = "";
    //
	// 				chunkParamArr = new Array();
    //
	// 				for(var i = 0; i < saveJson.data.length; i++) {
	// 					//console.log('parse json', $.param(saveJson.data[i]));
    //
	// 					if( chunkedQueryStr != "" ) {
	// 						chunkedQueryStr += "&";
	// 					}
	// 					chunkedQueryStr += $.param(saveJson.data[i]);
    //
	// 					if( (i + 1) % chunkSize == 0 ) {
	// 						//console.log(i);
	// 						chunkParamArr.push(chunkedQueryStr);
	// 						chunkedQueryStr = "";
	// 					}
	// 				}
    //
	// 				if( chunkedQueryStr != "" ) {
	// 					chunkParamArr.push(chunkedQueryStr);
	// 				}
	// 			}
    //
	// 			if( chunkParamArr != null && chunkParamArr.length > 0 ) {
    //
	// 				var sendParams = "";
	// 				var processCnt = 0;
    //
	// 				// 마지막 Chunk 전까지 ajaxCall을 이용하여 저장 처리함.
	// 				for(var idx = 0; idx < chunkParamArr.length; idx++) {
	// 					//console.log('chunkParamArr', chunkParamArr[idx]);
	// 					sendParams = chunkParamArr[idx];
	// 					if(typeof x === "string") {
	// 						sendParams += "&" + x;
	// 					} else if (typeof opt === "object") {
	// 						sendParams += "&" + x.Param;
	// 					}
	// 					// 난독화 처리
	// 					//sendParams = EncParams(sendParams);
    //
	// 					// 저장 실행
	// 					rtnData = this.GetSaveData(y, sendParams);
	// 					//console.log('rtnData', rtnData);
	// 					if( rtnData != null && rtnData != undefined && rtnData != "" ) {
	// 						rtnDataJSON = $.parseJSON(rtnData);
	// 						if( rtnDataJSON.Result.Code == -1 ) {
	// 							break;
	// 						} else {
	// 							processCnt += chunkSize;
	// 							if( processCnt > saveJson.data.length ) {
	// 								processCnt = saveJson.data.length;
	// 							}
	// 							//console.log('progress', processCnt + "/" + saveJson.data.length + " Complete");
	// 							if(getBrowser() != "IE") {
	// 								if($(".GMProcess #txt_progress").length > 0) {
	// 									$(".GMProcess #txt_progress").text( processCnt + "/" + saveJson.data.length + " Complete" );
	// 								}
	// 							}
	// 						}
	// 					}
	// 				}
    //
	// 				/*
	// 				if( rtnDataJSON != null && rtnDataJSON != undefined && rtnDataJSON.Result != null && rtnDataJSON.Result != undefined ) {
	// 					alert(rtnDataJSON.Result.Message);
	// 				}
	// 				*/
    //
	// 				this.LoadSaveData(rtnData);
    //
	// 			}
	// 		} else {
	// 			this.HideProcessDlg();
	// 			return false;
	// 		}
	// 	}
	// 	return true;
	// };
    //
	// /**
	//  * 엑셀 다운로드 실행전 처리를 위한 이벤트명 변경
	//  */
	// window[sheetid].Down2ExcelOrigin = window[sheetid].Down2Excel;
	// window[sheetid].Down2Excel = function(x,y) {
	// 	//alert(sheetid + "/" + window.location.href);
	// 	//console.log('x', x);
	// 	//console.log('y', y);
	//
	// 	// 개인정보포함된 내용 다운로드시 사유 등록이 비활성화된 경우 다운로드 진행
	// 	if(!isUseDownloadReasonReg) {
	// 		window[sheetid].Down2ExcelOrigin(x,y);
	//
	// 	} else {
	//
	// 		// 개인정보항목 포함여부
	// 		var isContains = false;
	//
	// 		//console.log('x.DownCols', x.DownCols);
	// 		//console.log('x.DownRows', x.DownRows);
	//
	// 		// 다운로드 컬럼정보
	// 		var cols = x.DownCols;
	// 		var rows = x.DownRows;
	//
	// 		// 데이터 다운로드 여부
	// 		var isDownData = false;
	// 		if( rows != undefined && rows != null ) {
	// 			var rowArr = null;
	// 			if( typeof rows == "string" && rows.indexOf("|") > -1 ) {
	// 				rowArr = rows.split("|");
	// 			} else {
	// 				rowArr = [parseInt(rows)];
	// 			}
	// 			//console.log('rowArr', rowArr);
	//
	// 			for(var row = 0; row < rowArr.length; row++) {
	// 				if( (row + 1) > window[sheetid].HeaderRows() ) {
	// 					isDownData = true;
	// 					break;
	// 				}
	// 			}
	// 		} else {
	// 			isDownData = true;
	// 		}
	//
	// 		// 데이터가 존재하는 경우 개인정보 포함 여부 체크 진행
	// 		if( isDownData && (window[sheetid].RowCount() > 0) && (cols != null && cols != undefined) ) {
	// 			var arr = cols.split("|");
	// 			var colIdx   = null;
	// 			var cellText = null;
	// 			var saveName = null;
	// 			var i,j = 0;
	//
	// 			// 다운로드 대상 컬럼의 정보가 컬럼 인덱스가 아닌 SaveName으로 되어 있는 경우 컬럼 Index로 변환 처리
	// 			//console.log('before arr', arr);
	// 			for(i = 0; i < arr.length; i++) {
	// 				if( !isNumber(arr[i], "") ) {
	// 					for(j = 0; j <= window[sheetid].LastCol(); j++) {
	// 						if( window[sheetid].ColSaveName(0, j) == arr[i] ) {
	// 							arr[i] = j;
	// 							break;
	// 						}
	// 					}
	// 				}
	// 			}
	// 			//console.log('after arr', arr);
	//
	// 			for(i = 0; i < arr.length; i++) {
	// 				saveName = window[sheetid].ColSaveName(0, arr[i]).toLowerCase();
	// 				for(j = 0; j < window[sheetid].HeaderRows(); j++) {
	// 					cellText = window[sheetid].GetCellText(j, arr[i]);
	// 					//console.log('COL['+i+']['+j+']', cellText + ',' + saveName);
	//
	// 					if( cellText.indexOf("주민번호") > -1
	// 							|| cellText.indexOf("주민등록번호") > -1
	// 							|| cellText.indexOf("핸드폰") > -1
	// 							|| cellText.indexOf("휴대폰") > -1
	// 							|| cellText.indexOf("생년월일") > -1
	// 							|| saveName.indexOf("birth") > -1
	// 							|| saveName.indexOf("birymd") > -1
	// 							|| saveName.indexOf("handphone") > -1
	// 							|| saveName.indexOf("resno") > -1
	// 					) {
	// 						isContains = true;
	// 						break;
	// 					}
	// 				}
	// 			}
	// 		}
	//
	// 		// 다운로드 대상 항목에 개인정보가 포함된 경우
	// 		if( isContains ) {
    //             if(!isPopup()) {return;}
    //
    //             let url 	= "/DownloadReasonSta.do?cmd=viewDownloadReasonStaRegLayer&authPg=A";
    //             let w    = 840;
    //             let h    = 330;
    //             let prgCd = (thisUrl.indexOf("/") == 0) ? thisUrl.substring(1, thisUrl.length) : thisUrl;
    //
    //             if( prgCd == null || prgCd == undefined || prgCd == "" ) {
    //                 prgCd = document.location.href.substring(document.location.href.lastIndexOf("/") + 1, document.location.href.length);
    //             }
    //
    //             let args = {
    //                 prgCd : prgCd,
    //                 fileNm : x.FileName,
    //                 sheetId : sheetid
    //             };
    //
    //             let layerModal = new window.top.document.LayerModal({
    //                 id: 'downloadReasonStaRegLayer',
    //                 url: url,
    //                 parameters: args,
    //                 width: w,
    //                 height: h,
    //                 title: '파일 다운로드 사유 등록',
    //                 trigger: [
    //                     {
    //                         name: 'downloadReasonStaRegLayerTrigger',
    //                         callback: function(rv) {
    //                             // 사유 등록 완료한 경우 다운로드 진행
    //                             if( rv != null && rv != undefined && rv == "OK" ) {
    //                                 window[sheetid].Down2ExcelOrigin(x,y);
    //                             }
    //                         }
    //                     }
    //                 ]
    //             });
    //             layerModal.show();
	// 		} else {
	// 			// 다운로드 진행
	// 			window[sheetid].Down2ExcelOrigin(x,y);
	// 		}
	// 	}
	// };
}
