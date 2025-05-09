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
	Grids.BaseFileExt = "conf";

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
	Grids.BaseFileExt = "conf";

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

	//sheet.SetVisible(0) // 최인철 봉인

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

/**
 * 지정 시트에 이벤트 추가 혹은 재설정 처리
 * DoSearch 혹은 DoSave 작업시 웹위변조등 Third-party 솔루션의 작업이 필요한 경우 수정하여 사용함.
 * @param sheetid
 * @returns
 */
function addOrOverrideSheetAction(sheetid) {

	/**
	 * [Added Method] DoSearchEnc : 파라미터 난독화 후 DoSearch 메소드 실행 처리
	 */
	window[sheetid].DoSearch = function(y,x,w){
		var A,B,C,D;
		B=this["SearchSync"],A=0,C=0;
		if(typeof w!=="undefined"){
			if(typeof w==="object"){
				B=this.aB(w["Sync"],this["SearchSync"]);
				A=this.aB(w["Append"],0);
				C=this.aB(w["Fx"],0)
			}else{
				B=this.aB(w,this["SearchSync"]);
			}
		}
		this.zG(A);

		if(C){
			this["LoadFx"]=1;
		}

		this.Data.Data.Url=y;
		this.Data.Data.Timeout=this["WaitTimeOut"];
		this.Data.Data.Repeat=0;
		this.Data.Data.Append=A;

		if(x){
			//this.Data.Data.aD=x;
			//파라미터난독화
			if(B==1){
				this.Data.Data.aD=x;
			} else {
				this.Data.Data.aD=EncParams(x);
			}
		}

		this.ShowProcessDlg("Search");

		if(B==1){
			this.Source.Data.Sync=0;
			D=CloneArray(this.Data.Data);
			D["method"]="DoSearch";
			this.oQ(D);
		}else{
			this.cD=y;
			this.hG(A);
		}
	};

	/**
	 * [Added Method] DoSaveEnc : 파라미터 난독화 후 DoSave 메소드 실행 처리
	 */
	window[sheetid].DoSave = function(y,x,w,v,u,t,s){
		var A,B,C;this["IO"]={};
		this["Message"]="";
		C=this.EndEdit(1);

		if(C==-1){
			CancelEvent(window.event,1);
			return;
		}

		if(x&&typeof(x)=="object"){
			A=x;
			x=A["Param"];
			w=A["Col"];
			v=A["Quest"];
			u=A["UrlEncode"];
			t=A["Mode"];
			s=A["Delim"];
		}

		if(w==undefined||w<0){
			w=-1;
		}

		if(v!=false){
			v=true;
		}

		if(u!=false){
			u=true;
		}

		B=this.GetSaveString(false,u,w,null,t,s);

		if(this["SaveEncodeURI"]){
			B=encodeURI(B);
		}

		if(B=="KeyFieldError"){
			this.HideProcessDlg();
			return;
		}

		if(B.length<=0){
			this.ShowAlert(this.GetText("EmptySaveContent"),"U");
			this.HideProcessDlg();
			return
		}else{
			this.Source.Upload.Params=B;
		}

		this["ChgIndex"]=1;

		if(x){
			//this.Source.Upload.aD=x;
			//파라미터난독화
			this.Source.Upload.aD=EncParams(x);
		}

		this.Source.Upload.Timeout=this["WaitTimeOut"];
		this.Source.Upload.Repeat=0;

		if(v==true){
			if(this.ShowAlert(this.GetText("SaveConfirm"),"U",1)){
				this.ShowProcessDlg("Save");
				this.Source.Upload.Url=y;
				this.Save();
			}
		}else{
			this.ShowProcessDlg("Save");
			this.Source.Upload.Url=y;
			this.Save()
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