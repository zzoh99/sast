<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!-- <%@ page import="com.hr.common.util.DateUtil" %> -->
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {
		
		initPage();

		$(sheet1).sheetAutocomplete({
			Columns: [{ ColSaveName : "name" }]
		});

		//$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	// 기본 화면설정
	function initPage() {
		
		searchTitleList();

		// 계약서 유형
   		var contTypeList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&note1=B","Z00001"), "");
   		$("#searchContType").html(contTypeList[2]);

		$("#searchSabunNameAlias, #searchStdSymd, #searchStdEymd").bind("keyup", function(event) {
			if(event.keyCode == '13') {
				doAction1("Search");
			}
		});

		$("#searchContType,#searchAgreeYn").bind("change", function(event) {
			doAction1("Search");
		});

		$("#searchStdSymd, #searchStdEymd").datepicker2({onReturn:function(){
			doAction1("Search");
		}
		});
		
		$("#searchStdSymd").val("${curSysYear}-01-01");
		$("#searchStdEymd").val("${curSysYear}-12-31");
	}

	/*SETTING HEADER LIST*/
	function searchTitleList() {
		//var titleList = ajaxCall("${ctx}/GetDataList.do?cmd=getEmpContractCreHeaderList", $("#srchFrm").serialize(), false);
		var titleList = ajaxCall("${ctx}/EmpContractCre.do?cmd=getEmpContractCreHeaderList", $("#srchFrm").serialize(), false);
		if (titleList != null && titleList.DATA != null) {

			sheet1.Reset();

			//IBsheet1 init
			var initdata = {};
			initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22};
			initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

			var v = 0;
			initdata.Cols = [];
			initdata.Cols[v++] = {Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" };
			initdata.Cols[v++] = {Header:"삭제",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0};
			initdata.Cols[v++] = {Header:"상태",			Type:"${sSttTy}", 	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0};
			
			initdata.Cols[v++] = {Header:"세부\n내역", 	Type:"Image",   	Hidden:0,   Width:40,  Align:"Center",   ColMerge:0, SaveName:"detail",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0 };
			initdata.Cols[v++] = {Header:"소속",			Type:"Text",   		Hidden:0,   Width:60,  Align:"Center",   ColMerge:0, SaveName:"orgNm",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0 };
			initdata.Cols[v++] = {Header:"사번",			Type:"Text",        Hidden:0,   Width:60,  Align:"Center",   ColMerge:0, SaveName:"sabun",  KeyField:1, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0 };			
			initdata.Cols[v++] = {Header:"성명",			Type:"Text",   		Hidden:0,   Width:60,  Align:"Center",   ColMerge:0, SaveName:"name",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1 };
			initdata.Cols[v++] = {Header:"직위",			Type:"Text",   		Hidden:Number("${jwHdn}"),   Width:60,  Align:"Center",   ColMerge:0, SaveName:"jikweeNm",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0 };
			initdata.Cols[v++] = {Header:"직급",			Type:"Text",   		Hidden:Number("${jgHdn}"),   Width:60,  Align:"Center",   ColMerge:0, SaveName:"jikgubNm",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0 };
			initdata.Cols[v++] = {Header:"직책",			Type:"Text",   		Hidden:0,   Width:60,  Align:"Center",   ColMerge:0, SaveName:"jikchakNm",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0 };
			initdata.Cols[v++] = {Header:"호칭",			Type:"Text",   		Hidden:Number("${aliasHdn}"),   Width:60,  Align:"Center",   ColMerge:0, SaveName:"alias",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0 };
			initdata.Cols[v++] = {Header:"기준일자",		Type:"Date",   		Hidden:0,   Width:100,	Align:"Center",  ColMerge:0, SaveName:"stdDate",  KeyField:1, Format:"Ymd",  PointCount:0,   UpdateEdit:0,   InsertEdit:1 };
			initdata.Cols[v++] = {Header:"동의일자",		Type:"Text",   		Hidden:0,   Width:120,	Align:"Center",  ColMerge:0, SaveName:"agreeDate",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0 };
			
			initdata.Cols[v++] = {Header:"동의여부",		Type:"Combo",  		Hidden:0,   Width:60,	Align:"Center",  ColMerge:0, SaveName:"agreeYn",   KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1 };
			initdata.Cols[v++] = {Header:"변경사유",		Type:"Text",  		Hidden:0,   Width:200,	Align:"Center",  ColMerge:0, SaveName:"updateReason", KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:0 };
			
			initdata.Cols[v++] = {Header:"동의시간",		Type:"Text",   		Hidden:1,   Width:60,  Align:"Center",   ColMerge:0, SaveName:"agreeDate",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0 };
			initdata.Cols[v++] = {Header:"전자동의서 유형",	Type:"Combo",  		Hidden:0,   Width:140,	Align:"Left",    ColMerge:0, SaveName:"contType",  KeyField:1, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1 };
			initdata.Cols[v++] = {Header:"선택",			Type:"DummyCheck",	Hidden:0,  Width:60,   Align:"Center",   ColMerge:0,   SaveName:"chk",      KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1  };
			initdata.Cols[v++] = {Header:"RD경로",		Type:"Text",  		Hidden:1,   Width:100,	Align:"Right",   ColMerge:0, SaveName:"rdMrd",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0 };
			initdata.Cols[v++] = {Header:"이메일",		Type:"Text",  		Hidden:1,   Width:100,	Align:"Center",  ColMerge:0, SaveName:"mailId",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0 };

			var i = 0;
			for(; i<titleList.DATA.length; i++) {
				var vType	= "Text";
				var vWidth	= 60;
				var vAlign	= "Center";
				var vFormat	= "";
				if (titleList.DATA[i].type		!= "") vType	= titleList.DATA[i].type;
				if (titleList.DATA[i].width		!= "") vWidth	= titleList.DATA[i].width;
				if (titleList.DATA[i].align		!= "") vAlign	= titleList.DATA[i].align;
				if (titleList.DATA[i].format	!= "") vFormat	= titleList.DATA[i].format;

				initdata.Cols[v++] = {Header:titleList.DATA[i].eleNm,	Type:vType,	Hidden:0,	Width:vWidth,	Align:vAlign,	ColMerge:1,	SaveName:titleList.DATA[i].eleSaveNm,	KeyField:0,	Format:vFormat,	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 };
			}

			IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);
			sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
	  		sheet1.SetDataLinkMouse("detail", 1);

			sheet1.SetUseDefaultTime(0);

			/* 콤보값 설정 */
			// 계약서 유형
	   		var contTypeList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&note1=B","Z00001"), "");
	   		sheet1.SetColProperty("contType", {ComboText:"|"+contTypeList[0], ComboCode:"|"+contTypeList[1]} );
	   		sheet1.SetColProperty("agreeYn",  {ComboText:"|Y|N", ComboCode:"|Y|N"} );
	   		
	   		$(window).smartresize(sheetResize); sheetInit();
		}
	}

	/* IB시트 함수 */
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			searchTitleList();

			sheet1.DoSearch( "${ctx}/EmpContractCre.do?cmd=getEmpContractCreList", $("#srchFrm").serialize() );
			break;
		case "Save":
			//중복 체크 (변수 : "컬럼명|컬럼명")
        	if(!dupChk(sheet1,"", true, true)){break;}
        	IBS_SaveName(document.srchFrm,sheet1);
        	sheet1.DoSave( "${ctx}/EmpContractCre.do?cmd=saveEmpContractCre", $("#srchFrm").serialize());
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			sheet1.SelectCell(row, "name");
			sheet1.SetCellValue(row, "stdDate", <%=DateUtil.getCurrentTime("yyyyMMdd")%>);
			sheet1.SetCellValue(row, "agreeYn", "N");
			sheet1.SetCellValue(row, "contType", $("#searchContType").val());
			break;
		case "Copy":
			var row = sheet1.DataCopy();
			sheet1.SetCellValue(row, "stdDate", "");
			sheet1.SetCellValue(row, "agreeDate", "");
        	//sheet1.SetCellValue( Row, "PK컬럼", "" );
			break;
		case "Clear":
			sheet1.RemoveAll();
			break;
		case "Down2Excel":
			//var downcol = makeHiddenSkipCol(sheet1);
			var jwHdn = "${jwHdn}";
			var jgHdn = "${jgHdn}";
			
			var downcol = "sNo|orgNm|sabun|name";
			if(jwHdn == "0") {
				downcol += "|jikweeNm";
			}
			if(jgHdn == "0") {
				downcol += "|jikgubNm";
			}
			downcol += "|jikchakNm|stdDate|agreeDate|agreeYn|contType";
			
			//var titleList = ajaxCall("${ctx}/GetDataList.do?cmd=getEmpContractCreHeaderList", $("#srchFrm").serialize(), false);
			var titleList = ajaxCall("${ctx}/EmpContractCre.do?cmd=getEmpContractCreHeaderList", $("#srchFrm").serialize(), false);
			if (titleList != null && titleList.DATA != null) {

				var i = 0 ;
				for(; i<titleList.DATA.length; i++) {
					downcol += "|" + titleList.DATA[i].eleSaveNm;
				}
			}
			
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
		case "DownTemplate":

			var downcol = "sabun|stdDate|agreeDate|agreeYn|contType";

			//var titleList = ajaxCall("${ctx}/GetDataList.do?cmd=getEmpContractCreHeaderList", $("#srchFrm").serialize(), false);
			var titleList = ajaxCall("${ctx}/EmpContractCre.do?cmd=getEmpContractCreHeaderList", $("#srchFrm").serialize(), false);
			if (titleList != null && titleList.DATA != null) {

				var i = 0 ;
				for(; i<titleList.DATA.length; i++) {
					downcol += "|" + titleList.DATA[i].eleSaveNm;
				}
			}
			sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:downcol});
			break;
		case "LoadExcel":
			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet1.LoadExcel(params);
			break;
		}
	}

	// 조회 후 이벤트
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != "") alert(Msg);

			//작업

			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 이벤트
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != "") alert(Msg);

			//작업

			doAction1("Search");
		}catch(ex){
			alert("OnSaveEnd Event Error : " + ex);
		}
	}
	
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		if( sheet1.ColSaveName(Col) == "detail"  && Row >= sheet1.HeaderRows() ) {
	    	/*계약서 RD팝업*/
	    	rdPopup(Row) ;
	    }
	}
	
	// 변경사유 변경 시 동의여부 활성화
	// 추후 실시간 감지를 위해 keyDown 대체 필요
	function sheet1_OnChange(Row, Col, Value, OldValue) {
		try {
			var sSaveName = sheet1.ColSaveName(Col);
			
			if( sSaveName == "updateReason" ) {
				sheet1.SetCellEditable(Row,"agreeYn", true);
			}
		} catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}
	
	// 팝업 리턴 함수
	function getReturnValue(returnValue) {
        var rv = $.parseJSON('{' + returnValue+ '}');

        if(pGubun == "sheetAutocomplete") {
        	sheet1.SetCellValue(gPRow, "sabun", rv["sabun"]);
        	sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"]);
        	sheet1.SetCellValue(gPRow, "jikchakNm", rv["jikchakNm"]);
        	sheet1.SetCellValue(gPRow, "jikgubNm", rv["jikgubNm"]);
        	sheet1.SetCellValue(gPRow, "jikweeNm", rv["jikweeNm"]);
        	sheet1.SetCellValue(gPRow, "name", rv["name"]);
        	sheet1.SetCellValue(gPRow, "alias", rv["empAlias"]);
        }
    }
	
	/**
	 * 출력 window open event
	 * 레포트 공통에 맞춘 개발 코드 템플릿
	 * by JSG
	 */
	function rdPopup(Row){
		if(!isPopup()) {return;}

  		var w 		= 840;
		var h 		= 1000;
		var url 	= "${ctx}/RdPopup.do";
		var args 	= new Array();
		// args의 Y/N 구분자는 없으면 N과 같음
		
		args["rdTitle"] = "전자동의서" ;//rd Popup제목
		args["rdMrd"] = sheet1.GetCellValue(Row, "rdMrd");//( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명
// 		args["rdMrd"] = "cpn/personalPay/SalaryContract.mrd";//( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명
		//args["rdParam"] = "[${ssnEnterCd}] ["+sheet1.GetCellValue(Row, "sabun")+"] ["+sheet1.GetCellValue(Row, "contType")+"] ["+sheet1.GetCellValue(Row, "stdDate")+"] [${baseURL}]" ; //rd파라매터
		args["rdParam"] = "[${ssnEnterCd}] [(('"+sheet1.GetCellValue(Row, "sabun")+"','"+sheet1.GetCellValue(Row, "contType")+"','"+sheet1.GetCellValue(Row, "stdDate")+"'))] [${baseURL}]" ; //rd파라매터
		args["rdParamGubun"] = "rp" ;//파라매터구분(rp/rv)
		args["rdToolBarYn"] = "Y" ;//툴바여부
		args["rdZoomRatio"] = "100" ;//확대축소비율

		args["rdSaveYn"] 	= "Y" ;//기능컨트롤_저장
		args["rdPrintYn"] 	= "Y" ;//기능컨트롤_인쇄
		args["rdExcelYn"] 	= "Y" ;//기능컨트롤_엑셀
		args["rdWordYn"] 	= "Y" ;//기능컨트롤_워드
		args["rdPptYn"] 	= "Y" ;//기능컨트롤_파워포인트
		args["rdHwpYn"] 	= "Y" ;//기능컨트롤_한글
		args["rdPdfYn"] 	= "Y" ;//기능컨트롤_PDF

		gPRow = "";
		pGubun = "rdPopup";
		var rv = openPopup(url,args,w,h);//알디출력을 위한 팝업창

		/*
		if(rv!=null){
			//return code is empty
		}
		*/
	}
	
	function rdPopup2(){
		
		if(!isPopup()) {return;}

		if(sheet1.CheckedRows("chk") == 0) {
			alert("<msg:txt mid='110453' mdef='출력할 데이터를 선택하여 주십시오.'/>");
			return;
		}
		
		var sRow = sheet1.FindCheckedRow("chk"); 
		var arrRow1 = [];
		var arrRow2 = [];
		var arrRow3 = [];
		var searchRdMrd = "";
		//args["rdParam"] = "[${ssnEnterCd}] [(('"+sheet1.GetCellValue(Row, "sabun")+"','"+sheet1.GetCellValue(Row, "contType")+"','"+sheet1.GetCellValue(Row, "stdDate")+"'))] [${baseURL}]" ; //rd파라매터
		$(sRow.split("|")).each(function(index,value){
			arrRow1[index] = sheet1.GetCellValue(value,"sabun");
			arrRow2[index] = sheet1.GetCellValue(value,"contType");
			arrRow3[index] = sheet1.GetCellValue(value,"stdDate");
			searchRdMrd    = sheet1.GetCellValue(value, "rdMrd");
		});
		
		var searchTarget = "(";
		for(var i=0; i<arrRow1.length; i++) {
	        if(i != 0) searchTarget += ",";
	        searchTarget += "('"+arrRow1[i]+"'"; 
	        searchTarget += ",'"+arrRow2[i]+"'"; 
	        searchTarget += ",'"+arrRow3[i]+"')"; 
	    } 
		searchTarget += ")";
		
  		var w 		= 840;
		var h 		= 1000;
		var url 	= "${ctx}/RdPopup.do";
		var args 	= new Array();
		// args의 Y/N 구분자는 없으면 N과 같음
		
		
		args["rdTitle"] = "전자동의서" ;//rd Popup제목
		args["rdMrd"] = searchRdMrd;//( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명
		args["rdParam"] = "[${ssnEnterCd}] ["+searchTarget+"] [${baseURL}]"  ; //rd파라매터
		args["rdParamGubun"] = "rp" ;//파라매터구분(rp/rv)
		args["rdToolBarYn"] = "Y" ;//툴바여부
		args["rdZoomRatio"] = "100" ;//확대축소비율
		
		args["rdSaveYn"] 	= "Y" ;//기능컨트롤_저장
		args["rdPrintYn"] 	= "Y" ;//기능컨트롤_인쇄
		args["rdExcelYn"] 	= "Y" ;//기능컨트롤_엑셀
		args["rdWordYn"] 	= "Y" ;//기능컨트롤_워드
		args["rdPptYn"] 	= "Y" ;//기능컨트롤_파워포인트
		args["rdHwpYn"] 	= "Y" ;//기능컨트롤_한글
		args["rdPdfYn"] 	= "Y" ;//기능컨트롤_PDF
		

		gPRow = "";
		pGubun = "rdPopup2";
		var rv = openPopup(url,args,w,h);//알디출력을 위한 팝업창
		
		/*
		if(rv!=null){
			//return code is empty
		}
		*/
		
	}
	
	/**
	* 메일발송
	*/
	function sendMail(){
		var sabuns = "";

		var sRow = sheet1.FindCheckedRow("chk");
		if( sRow == "" ){
			alert("대상을 선택 해주세요.");
			return;
		}

		var names = "";
		var mailIds = "";
		var arrRow = sRow.split("|");
		for(var i=0; i<arrRow.length ; i++){
			if (sheet1.GetCellValue(arrRow[i], "mailId") != "" ){
				names    += sheet1.GetCellValue(arrRow[i], "name") + "|";
				mailIds  += sheet1.GetCellValue(arrRow[i], "mailId") + "|";
			}
		}
		names    = names.substr(0, names.length - 1);
		mailIds  = mailIds.substr(0, mailIds.length - 1);

		fnSendMailPop(names, mailIds);

		return;
	}

	/**
	 * Mail 발송 팝업 창 호출
	 */
	function fnSendMailPop(names,mailIds){
		if(!isPopup()) {return;}

		var args 	= new Array();

		args["saveType"] = "insert";
		args["names"] = names;
		args["mailIds"] = mailIds;
		args["sender"] = "${ssnName}";
		args["bizCd"] = "99999";
		args["authPg"] = "${authPg}";

		var url = "${ctx}/SendPopup.do?cmd=viewMailMgrPopup";
		openPopup(url, args, "900","700", function (rv){

		});
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >

	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<th>기간</th>
			<td>
				<input id="searchStdSymd" name="searchStdSymd" size="10" type="text" class="date2" value="" /> ~
				<input id="searchStdEymd" name="searchStdEymd" size="10" type="text" class="date2" value="" />
			</td>
			<th>전자동의서 유형</th>
			<td>
				<select id="searchContType" name="searchContType" class="box"></select>
			</td>
			<th>사번/성명 </th>
			<td>
				 <input id="searchSabunNameAlias" name="searchSabunNameAlias" type="text" class="text" />
			</td>
			<th>동의여부</th>
			<td>
				<select id="searchAgreeYn" name="searchAgreeYn" class="box">
					<option value="">전체</option>
					<option value="Y">Y</option>
					<option value="N">N</option>
				</select>
			</td>
			<td>
				<btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='search' mdef="조회"/>
			</td>
		</tr>
		</table>
		</div>
	</div>

	</form>

	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<tr>
		<td>
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt">전자동의서 배포</li>
					<li class="btn">
						<btn:a href="javascript:rdPopup2()" 				css="basic authA" mid='rdpopup' mdef="일괄출력"/>
						<btn:a href="javascript:doAction1('Insert')" 		css="basic authA" mid='insert' mdef="입력"/>
						<btn:a href="javascript:doAction1('Copy')" 			css="basic authA" mid='copy' mdef="복사"/>
						<btn:a href="javascript:doAction1('Save')" 			css="basic authA" mid='save' mdef="저장"/>
						<btn:a href="javascript:doAction1('DownTemplate')" 	css="basic authR" mid='down2ExcelV1' mdef="양식다운로드"/>
						<btn:a href="javascript:doAction1('LoadExcel')" 	css="basic authR" mid='upload' mdef="업로드"/>
						<btn:a href="javascript:sendMail();" 				css="pink authA" mid='mail' mdef="메일발송"/>
						<btn:a href="javascript:doAction1('Down2Excel')" 	css="basic authR" mid='download' mdef="다운로드"/>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
		</td>
	</tr>
	</table>
</div>

</body>
</html>
