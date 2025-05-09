var gJson = {DATA:[[]]};
var callBackExcelParam = null;
var callBackExcelSheet = null;
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
	Grids.BaseFileExt = "txt";

	if( width.indexOf("%") > -1 ) {
		sheetcount = parseInt(100 / parseInt(width));
		width = "100%";
	}


	if( height.indexOf("%") > -1 ) height = "300px"; // 시트 최소 높이
	else fixed = true;

	//div_str += "<div id='DIV_" + sheetid + "' fixed='"+fixed+"' class='ibsheet' sheetcount='"+sheetcount+"' realheight='"+realheight+"' style='width:" + width + ";height:"+ height +";'>";
	div_str += "<div name='IBSheet' id='DIV_" + sheetid + "' fixed='"+fixed+"' class='ibsheet' sheetcount='"+sheetcount+"' realheight='"+realheight+"' style='width:" + width + ";height:"+ height +";'>";

	div_str += "<script> IBSheet('<ibsheet Sync=\"1\" Data_Sync=\"0\"> </ibsheet>',\"DIV_" + sheetid + "\", \"" + sheetid + "\"); </script>"
	div_str += "</div>\n";

	//<![CDATA[
	document.write(div_str);
//]]>

	/*************************************************************
	 * 2021.04.07 로그관리
	 * 사유 Popup open
	*************************************************************/
	window[sheetid+"_OnLoadData"] = function(data){
    	try{
    		headerReSetTimer();
    	}catch(e){}
	};

	window[sheetid].SetUserAgent("ibsheet"); //IBSheet 요청인지 헤더에서 체크 하기 위한 값
}

/*
 * IBSheet를 생성 (특정 div 하위로 넣는 경우에 사용)
 */
function createIBSheet2(obj, sheetid, width, height, locale) {
    // locale 처리
	Grids.Locale = locale?locale:"";
	Grids.BaseFileExt = "txt";

	// width, height 적용
	obj.style.width = width;
	obj.style.height = height;

	IBSheet('<ibsheet Sync=\"1\" Data_Sync=\"0\"> </ibsheet>',obj.id, sheetid);
}

/* MergeSheet 속성에 설정 값 */
var msNone            = 0;      // 머지 없음
var msAll             = 1;      // 전부 머지 가능
var msPrevColumnMerge = 2;      // 앞 컬럼이 머지 된 경우 해당 행 안에서 머지 가능
var msHeaderOnly      = 5;      // 해더만 머지

/* BasicImeMode 속성 설정 값 */
var imeAuto           = 0;      // 마지막 상태를 그대로 사용
var imeHan            = 1;      // 기본 상태를 한글 입력 상태로 함
var imeEng            = 2;      // 기본 상태를 영문 입력 상태로 함

/* SizeMode 속성 설정 값 */
var sizeAuto          = 0;      // 설정한 높이, 너비 그대로 사용
var sizeNoVScroll     = 1;      // 높이를 스크롤 없이 자동 설정
var sizeNoHScroll     = 2;      // 너비를 스크롤 없이 자동 설정
var sizeNoBothScroll  = 3;      // 높이, 너비 모두 스크롤 없이 자동 설정

/* SearchMode 속성 설정 값 */
var smGeneral         = 0;		// 일반 조회
var smClientPaging    = 1;		// 클라이언트 페이징 조회
var smLazyLoad        = 2;		// Lazy Load 조회
var smServerPaging    = 3;      // 실시간 서버 페이징 조회

/* SumPosition 속성 설정 값 */
var posTop            = 0;		// 상단 고정 위치
var posBottom         = 1;		// 하단 고정 위치

/* VScrollMode 속성 설정 값 */
var vsAuto            = 0;		// 자동 생성
var vsFixed           = 1;		// 고정 생성

/*
    FormQueryString 관련 함수 정의
*/
/* FormQueryString과 FormQueryStringEnc함수에서 필수입력 체크시 메시지로 사용한다.-3.4.0.50 */
var IBS_MSG_REQUIRED      = "은(는) 필수입력 항목입니다.";
/**
 * 에러메시지를 표시한다. IBS_ShowErrMsg 대신 이 함수를 사용해야 한다.
 * @param   : sMsg      - 메시지
 * @return  : 없음
 * @version : 3.4.0.50
 * @sample
 *  IBS_ShowErrMsg("에러가 발생했습니다.");
 */
function IBS_ShowErrMsg(sMsg){
    return alert("[IBSheetInfo.js]\n" + sMsg);
}
function IBS_getName(obj){
	if(obj.name!=""){
		return obj.name;
	}else if(obj.id!=""){
		return obj.id;
	}else{
		return "";
	}
}
function IBS_RequiredChk(obj){

	return (obj.getAttribute("required")!=null);
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

  if(checkRequired==null) checkRequired=false;

  var name = new Array(form.elements.length);
  var value = new Array(form.elements.length);
  var j = 0;
  var plain_text="";

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
          if(ind >= 0) {

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
          for( k = 0; k < llen; k++) {
            if (form.elements[i].options[k].selected) {
              name[j] = IBS_getName(form.elements[i]);
              value[j] = form.elements[i].options[k].value;

              j++;
              increased++;
            }
          }
          if(increased > 0) {
            j--;
          } else {
            value[j] = "";
          }
          j++;
          break;
        default :
          name[j] = IBS_getName(form.elements[i]);
          value[j] = form.elements[i].value;
          j++;
    }

    if (checkRequired) {
      //html 컨트롤 태그에 required속성을 설정하면 필수입력을 확인할 수 있다.
      //<input type="text" name="txtName" required="이름">

      if (  IBS_RequiredChk(form.elements[i]) &&prev_j != j && value[prev_j] == "") {

       	if (form.elements[i].getAttribute("required")==null||
       	form.elements[i].getAttribute("required")==""
       	) {
          alert('"' + IBS_getName(form.elements[i]) + '"' + IBS_MSG_REQUIRED);
        }else{

          alert('"' + form.elements[i].getAttribute("required")  + '"' + IBS_MSG_REQUIRED);
        }
        //컨트롤이 숨겨져 있을수도 있으므로 에러 감싼다.
        try{
          form.elements[i].focus();
        } catch(ee) {;}

        return;
      }
    }
  }
  //QueryString을 조합한다.
  for (i = 0; i < j; i++) {
     if (name[i] != '') plain_text += name[i]+ "=" + value[i] + "&";
  }

  //마지막에 &를 없애기 위함
  if (plain_text != "") plain_text = plain_text.substr(0, plain_text.length -1);

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


  if(checkRequired==null) checkRequired=false;

  var name = new Array(form.elements.length);
  var value = new Array(form.elements.length);
  var j = 0;
  var plain_text="";

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
          if(ind >= 0) {

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
          for( k = 0; k < llen; k++) {
            if (form.elements[i].options[k].selected) {
              name[j] = IBS_getName(form.elements[i]);

                value[j] = form.elements[i].options[k].value;

              j++;
              increased++;
            }
          }
          if(increased > 0) {
            j--;
          } else {
            value[j] = "";
          }
          j++;
          break;
        default :

            name[j] = IBS_getName(form.elements[i]);
            value[j] = form.elements[i].value;
            j++;
    }

    if (checkRequired) {
      //html 컨트롤 태그에 required속성을 설정하면 필수입력을 확인할 수 있다.
      //<input type="text" name="txtName" required="이름">
      if (IBS_RequiredChk(form.elements[i])&&prev_j != j && value[prev_j] == "") {
       	if (form.elements[i].getAttribute("required")=="") {
          alert('"' + IBS_getName(form.elements[i]) + '"' + IBS_MSG_REQUIRED);
        }else{
          alert('"' + form.elements[i].getAttribute("required")  + '"' + IBS_MSG_REQUIRED);
        }
        //컨트롤이 숨겨져 있을수도 있으므로 에러 감싼다.
        try{
          form.elements[i].focus();
        } catch(ee) {;}

        return;
      }
    }
  }

  //QueryString을 조합한다.
  for (i = 0; i < j; i++) {
    if (name[i] != '') plain_text += encodeURIComponent(name[i])+ "=" + encodeURIComponent(value[i]) + "&";
  }

  //마지막에 &를 없애기 위함
  if (plain_text != "")  plain_text = plain_text.substr(0, plain_text.length -1);

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
	if(param.length<2){
		IBS_ShowErrMsg("최하 두개의 인자가 필요합니다.");
		return;
	}

	if(param.length==2){
		param[0].s_SAVENAME.value = IBS_ConcatSaveName(param[1]);
	}else{
		param[0].s_SAVENAME.value = "";
		for(var i=1;i<param.length;i++){
			param[0].s_SAVENAME.value += IBS_ConcatSaveName(param[i])+"@@";
		}
		var tempStr = param[0].s_SAVENAME.value;
		param[0].s_SAVENAME.value = tempStr.substring(0,tempStr.length-2);
	}
}

function IBS_ConcatSaveName(sheet){
	var lc = sheet.LastCol();
	var snStr = "";
	for(var c=0;c<=lc;c++){
		snStr += "|"+sheet.GetCellProperty (0, c, "SaveName");
	}
	return snStr.substring(1);
}

/*------------------------------------------------------------------------------
 * method : GetSaveJson
 * desc : 지정한 상태에 대한 데이터를 json 형태로 반환한다.
 * param list
 * param1 : IBSheet Object
 * param2 : 상태 (I|U|D)
 * param3 : SkipCol list
-------------------------------------------------------------------------------*/
function GetSaveJson2(sheet,status,skipcols){
	if(sheet==null){
		alert("GetSaveJson2 함수의 첫번째 인자는 ibsheet 객체여야 합니다.");
		return;
	}

	var skipcolsArr = null;
	if(skipcols!=null){
		skipcolsArr = skipcols.split("|");
	}

	var rtnJson = {};
	if(status==null){
		var temp = GetJsonStatus(sheet,"I",skipcolsArr);
		if(temp) rtnJson["INSERT"] = temp;
		temp = GetJsonStatus(sheet,"D",skipcolsArr);
		if(temp) rtnJson["DELETE"] = temp;
		temp = GetJsonStatus(sheet,"U",skipcolsArr);
		if(temp) rtnJson["UPDATE"] = temp;
	}else{
		switch(status){
			case "I":
				rtnJson["INSERT"] = GetJsonStatus(sheet,"I",skipcolsArr);
				break;
			case "U":
				rtnJson["UPDATE"] = GetJsonStatus(sheet,"U",skipcolsArr);
				break;
			case "D":
				rtnJson["DELETE"] = GetJsonStatus(sheet,"D",skipcolsArr);
				break;
		}
		GetJsonStatus(sheet,status)
	}
	return rtnJson;
}

function GetJsonStatus(sheet,status,skipcolsArr){
	var rtnJson = new Array();
	//지정한 상태 값을 갖는 행을 뽑는다.
	var rows = sheet.FindStatusRow(status);

	if(rows=="")return null;

	var rowArr = rows.split(";");

	for(var i=0;i<rowArr.length;i++){
		var temp = sheet.GetRowJson(rowArr[i]);
		if(skipcolsArr!=null){
			for(var c=0;c<skipcolsArr.length;c++){
				delete temp[skipcolsArr[c]];
			}
		}
		rtnJson.push(temp);
	}
	return rtnJson;
}


/*------------------------------------------------------------------------------
 * method : IBS_InitSheet
 * desc : 시트를 초기화 한다..
 * param list
 * param1 : IBSheet Object
 * param2 : 시트 초기화 정보
-------------------------------------------------------------------------------*/
function IBS_InitSheet(sheet, info) {
	// 필수 입력 요소 체크
	if (!sheet || !info || !info.Cols) {
		alert("시트 초기화 정보가 올바르지 않습니다.");
	}

	var cInfo = CloneArray(info);

	if (!cInfo.Cfg) {
		cInfo.Cfg = {};
	}

	if (!cInfo.Headers) {
		cInfo.Headers = [
			{Text:"", Align:"Center"}
		];
	}

	if (!cInfo.HeaderMode) {
		cInfo.HeaderMode = {};
	} else {
		if (cInfo.HeaderMode.Align) {
			var header = cInifo.Headers;
			for (var i = 0, len = header.length; i < len; i++) {
				header[i].Align = cInfo.HeaderMode.Align;
			}
		}
	}

	if (cInfo.Cols[0].Header) {
		var cols = cInfo.Cols;
		var headers = new Array(cInfo.Cols[0].Header.split("|").length);

		for (var i = 0, len = cols.length; i < len; i++) {
			var col = cols[i];
			var header = col.Header.split("|");

			for (var j = 0, hlen = header.length;  j < hlen; j++) {
				if (!headers[j]) headers[j] = [];
				headers[j].push(header[j]?header[j]:"");
			}

			delete(col.Header);
		}

		cInfo.Headers = [];
		for (var i = 0, len = headers.length; i < len; i++) {
			var header = {};
			header.Text = headers[i].join("|");
			header.Align = cInfo.HeaderMode.Align?cInfo.HeaderMode.Align:"Center";
			cInfo.Headers.push(header);
		}
	}

	sheet.SetConfig(cInfo.Cfg);
	sheet.InitHeaders(cInfo.Headers, cInfo.HeaderMode);
	sheet.InitColumns(cInfo.Cols);
	sheet.SetUserAgent("ibsheet");

    // 지정 시트에 이벤트 추가 혹은 재설정 처리
    addOrOverrideSheetAction(sheet.id);

    /*************************************************************
    * 2021.04.07 로그관리
    * 사유 Popup open
    *************************************************************/
    var originalFn = sheet.Down2Excel;

    sheet.Down2Excel = function(param, flag){
        var bFlag = false;

        var oldPath = window.location.pathname;
        var newPath = "";

        newPath = oldPath.replace(/\//gi,"");
        newPath = newPath.replace(/yjungsan/gi,"");
        newPath = newPath.replace(/y_/gi,"");
        newPath = newPath.substr(0,4);

        if(newPath < "2021"){
            flag = true;
        }
        if(newPath.substr(0,1) != "2"){
            flag = true;
        }
        //최초 다운로드 버튼 클릭시 다운로드 사유 여부 조회
        //IE에서는 인코딩 문제로  logStdCd => encodeURI(logStdCd)으로 변경
        if(!flag){
            var logStdCd = "CPN_YEA_FILE_LOG_YN";
            var reasonMap = ajaxCall("../auth/beforeDownloadPopupRst.jsp?cmd=getDownReasonYn&logStdCd="+encodeURI(logStdCd), "queryId=getDownReasonYn",false).codeList;
            if(reasonMap[0].log_yn_cd == "Y"){ // 다운로드 사유
                bFlag = true;
            }
        }
        callBackExcelParam = null; // 콜백 파라미터 변수 초기화
        callBackExcelSheet = null; // 콜백 시트 객체 변수 초기화

        // 최초 다운로드 버튼 클릭 후 다운로드 사유 여부가 'Y'일 경우 팝업 오픈
        if(bFlag && !flag){
            if(!isPopup()) {return;}

            callBackExcelParam = param;      // param
            callBackExcelSheet = $(this)[0]; // 현재 다운로드할 sheet 객체 저장
            var args = new Array();
            args["type"] = 'Sheet';
            args["type2"] = 'E';//E:엑셀다운로드 , F: 파일다운로드, P: 출력물인쇄
            openPopup("../auth/beforeDownloadPopup.jsp", args, "450","280");
        }else {
            var newParam = param;
            try {
                if(!newParam)newParam = {};
                /*if(!newParam.FileName){
                    var sheetTitle = "";
                    if($(".sheet_title").eq(0).find("li.txt").length > 0){
                        sheetTitle = $(".sheet_title").eq(0).find("li.txt")[0].childNodes[0].nodeValue;
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
                }*/
            } catch (e) {
                // ignore error.
                newParam = param;
            }
            //newParam.FileName = replaceAll(newParam.FileName,'.','_')+".xlsx";
            newParam.ExcelRowHeight = "20";  // 행 높이 (26픽셀)  2020.02.10 jylee
            newParam.ExcelFontSize  = "9";   // 폰트 Size 2020.02.10 jylee
            newParam.CheckBoxOnValue  = "O"; // 체크박스 표시 값 2020.06.09 jylee
            newParam.CheckBoxOffValue  = " ";// 체크박스 표시 값 2020.06.09 jylee
            originalFn.call(sheet, newParam);
        }
    };
}
/*************************************************************
 * 2021.04.07 로그관리
 * 사유 Popup open
*************************************************************/
function callDown2Excel(returnValue){
    callBackExcelSheet.Down2Excel(callBackExcelParam, returnValue);
}

// 20250416 추가
function IBS_setChunkedOnSave(sheetid, options) {
    window[sheetid].chunkOption = options;
}
//20250416 DOM 변경 직후 비동기 연산으로 인해 진행률 렌더링이 생략되는 이슈가 있어서, 비동기 루프(async/await)로 처리 (for await 기반으로 순차 처리하면, 진행률 업데이트 후 브라우저가 DOM 그릴 기회를 가질 수 있음)
async function saveChunkedData(y,x,w,v,u,t,s) {
    try {
            this.ShowProcessDlg("Save"); // 저장중 대기이미지를 표시 한다..
            await new Promise(resolve => setTimeout(resolve, 1)); // 렌더링 시간 확보 (0.001초만 줘도 충분)

            var A, B, C, D, E, F, G, H, I, J;

            var rtnData      = null;
            var rtnDataJSON  = null;
            var isExeChunked = false; // 디폴트 분할저장 여부 false. 각 업무 화면에서 IBS_setChunkedOnSave 설정하면 true로 설정변경. 필요할 경우 화면별 설정 없이 바로 true설정해서 사용 가능.
            var chunkSize    = 150;   // 디폴트 chunkSize를 150으로 지정

            // 분할 저장 여부 확인 및 설정
            if(this.chunkOption != null && this.chunkOption != undefined) {
                isExeChunked = true;
                if(this.chunkOption.chunkSize != null && this.chunkOption.chunkSize != undefined) {
                    chunkSize = this.chunkOption.chunkSize;
                }
            }
            //console.log("chunked options", "isExeChunked : " + isExeChunked + ", chunkSize : " + chunkSize);


            A = {}, I = {}, H = 1, G = 1, F = 0, C = 0, B = "", J = 0, E = 0, D = null;
            this["IO"] = {};
            this["Message"] = "";
            F = this.EndEdit(1);
            if (F == -1) {
                CancelEvent(window.event, 1);
                this.HideProcessDlg();
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
                I = A["ReqHeader"] || A["reqHeader"] || {};
                C = this.kA(A["Sync"], 0);
                H = A["ValidKeyField"];
                G = A["ValidFullInput"];
                J = A["ValidEditLen"];
                E = A["ValidMinLen"];
                D = A["CallBack"];                
            }
            if (typeof w == "undefined" || w < 0) {
                w = -1
            }
            v = this.eA(v, 1);
            B = this.nJB({ "AllSave":0
                         , "UrlEncode":this.eA(u,1)
                         , "Col":w
                         , "Mode":t
                         , "Delim":s
                         , "ValidKeyField":H
                         , "ValidFullInput":G
                         , "ValidEditLen":J
                         , "ValidMinLen":E
                         },1);

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
                    this.Source.Upload.yC = x
                }
                this.Source.Upload.Timeout = this["WaitTimeOut"];
                this.Source.Upload.Repeat = 0;
                this.Source.Upload.Header = I;
                if (v) {
                    if (this.ShowAlert(this.GetText("SaveConfirm"), "U", 1)) {
                        this.Source.Upload.Url = y;
                        this.dX();
                        this.Save(null, C, D)
                    } else {
                        this.HideProcessDlg();
                        return false
                    }
                } else {
                    this.Source.Upload.Url = y;
                    this.dX();
                    this.Save(null, C, D)
                }

            } else {
                // 분할하여 저장하는 경우
                this.Source.Upload.Timeout = this["WaitTimeOut"];
                this.Source.Upload.Repeat = 0;
                this.Source.Upload.Header = I;

                if(!C){
                    if(getBrowser() != "IE") {
                        $(".GMProcess").append('<p id="txt_progress" style="font-size:13px; color:#333; font-weight:bold;">init..</p>');
                        await new Promise(resolve => setTimeout(resolve, 1)); // 렌더링 시간 확보 (0.001초만 줘도 충분)
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


                    if (chunkParamArr != null && chunkParamArr.length > 0) {
                        let sendParams = "";
                        let processCnt = 0;

                        var rtnDataTmp    = null;
                        var rtnDataCode   = 1;
                        var rtnDataMsg    = "";
                        var rtnDataResult = "";

                        var rtnDataMsg2   = "";
                        var rtnDataMsg3   = "";
                        var rtnDataRstCnt = 0;

                        for (let idx = 0; idx < chunkParamArr.length; idx++) {
                            // 파라미터 조합
                            sendParams = chunkParamArr[idx];
                            if (typeof x === "string") {
                                sendParams += "&" + x;
                            } else if (typeof opt === "object") {
                                sendParams += "&" + x.Param;
                            }
                            
                            // 저장 실행
                            rtnDataTmp = this.GetSaveData(y, sendParams);
                            
                            if (rtnDataTmp != null && rtnDataTmp !== "") {
                                let rtnDataJSON = $.parseJSON(rtnDataTmp);
                                let nCode = parseInt(rtnDataJSON.Result.Code);

                                //yeaCalcCrePeoplePopupRst.jsp에서는 -2(사번중복) / -3(pay_action_cd소실)의 코드가 리턴되기도 함.
                                if ( (rtnDataCode < 0 || nCode < 0) && (rtnDataCode > nCode) )
                                {
                                    //반복 회차 중 오류가 발생하였다면, 우선도가 더 높은 오류 코드를 최종 리턴
                                    rtnDataCode = nCode ;
                                }

                                if (rtnDataMsg != rtnDataJSON.Result.Message) {
                                    rtnDataMsg = rtnDataMsg + rtnDataJSON.Result.Message; 
                                }
                                
                                if (rtnDataJSON.Result.Code == -1) {
                                    //20250502. 앞 회차는 정상 처리해서 트랜잭션 커밋되었을 수 있기 때문에 오류가 발생한 회차를 명시하여 메시지 표시.
                                    rtnDataMsg = "[분할저장 " + (idx+1) + "/" + (chunkParamArr.length-1) + "회차] " + rtnDataJSON.Result.Message;
                                    break;
                                } else {
                                    // 20250422. 일반적인 경우 Code, Message만 전달되므로 그 외의 경우는 try~catch로 처리                                    
                                    try { rtnDataMsg2   = rtnDataMsg2   + rtnDataJSON.Result.Msg2; } catch(e) { console.error("err Msg2", e); }
                                    try { rtnDataMsg3   = rtnDataMsg3   + rtnDataJSON.Result.Msg3; } catch(e) { console.error("err Msg3", e); }
                                    try { rtnDataRstCnt = rtnDataRstCnt + parseInt(rtnDataJSON.Result.RstCnt); } catch(e) { console.error("err RstCnt", e); }
                                    try { rtnDataResult = (rtnDataResult != "") ? rtnDataResult + "|" + rtnDataJSON.Result.Result : rtnDataJSON.Result.Result ; } catch(e) { console.error("err RstCnt", e); }
                                    
                                    processCnt += chunkSize;
                                    if (processCnt > saveJson.data.length) {
                                        processCnt = saveJson.data.length;
                                    }
                                }
                            }

                            //console.log('progress', processCnt + "/" + saveJson.data.length + " Complete");

                            // 진행률 표시
                            if (getBrowser() != "IE") {
                                if ($(".GMProcess #txt_progress").length > 0) {
                                    $(".GMProcess #txt_progress").text(processCnt + "/" + saveJson.data.length + " Save Complete...");
                                }
                            }

                            // 렌더링 시간 확보 (0.01초만 줘도 충분)
                            await new Promise(resolve => setTimeout(resolve, 10));
                        }
                        
                        /*console.log("Code",    rtnDataCode);
                        console.log("Message", rtnDataMsg);
                        console.log("Result",  rtnDataResult);
                        console.log("Msg2",    rtnDataMsg2);
                        console.log("Msg3",    rtnDataMsg3);
                        console.log("RstCnt",  rtnDataRstCnt);*/
                        
                        //오류코드가 -2 이하로 발생한 경우 리턴 값을 상세하게 처리
                        if (rtnDataCode == -2) { rtnDataMsg = rtnDataRstCnt + "^|" + rtnDataMsg2 ; }
                        else if (rtnDataCode == -3) { rtnDataMsg = rtnDataRstCnt + "^|" + rtnDataMsg3 ; }

                        //리턴값을 통합하여 재구성
                        rtnData = JSON.stringify({"Result": { "Code" : rtnDataCode, "Message" : rtnDataMsg, "Result"  : rtnDataResult }});
                                                                                        
                        /*console.log("rtnData", rtnData);*/
                        
                        this.LoadSaveData(rtnData);
                    }
                } else {
                    $(".GMProcess").html("");
                    this.HideProcessDlg();
                    return false;
                }
                
            }
            $(".GMProcess").html("");
            this.HideProcessDlg();
            return true;
    } catch (e) {
      $(".GMProcess").html("");
      this.HideProcessDlg();
      console.error("에러 발생:", e);
    }
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

    // [Added Method] DoSave : 20250416. chunkSize 처리 추가
    window[sheetid].SetSavingImage( "/yjungsan/common_jungsan/plugin/IBLeaders/Sheet/css/image/loading.gif"); //저장중 이미지를 로딩바 애니메이션 파일로 지정
    window[sheetid].SetWaitTimeOut(300);  //서버 응답을 5분간 대기한다.
    window[sheetid].DoSave = function(y,x,w,v,u,t,s){        
        // 20250416 DOM 변경 직후 비동기 연산으로 인해 진행률 렌더링이 생략되는 이슈가 있어서, 비동기 루프(async/await)로 처리 (for await 기반으로 순차 처리하면, 진행률 업데이트 후 브라우저가 DOM 그릴 기회를 가질 수 있음)
        return saveChunkedData.call(this, y,x,w,v,u,t,s); // this 유지 필요시 bind 또는 call 사용
    };
    
}