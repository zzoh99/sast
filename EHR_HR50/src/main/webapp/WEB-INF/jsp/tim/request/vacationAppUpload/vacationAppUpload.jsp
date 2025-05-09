<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";
var searchFlag = "";
	$(function() {

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"상태",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"반영\n여부",		Type:"CheckBox",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"applyYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"근무지",			Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"locationCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"소속",			Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"사번",			Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"성명",			Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"직급",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"급여유형",		Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"payTypeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"근태종류",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"gntCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"신청일",			Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"applYmd",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"시작일",			Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"종료일",			Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"총일수",			Type:"Float",		Hidden:0,	Width:60,	Align:"Right",	ColMerge:0,	SaveName:"dayCnt",		KeyField:0,	Format:"",PointCount:2,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"적용일수",		Type:"Float",		Hidden:0,	Width:60,	Align:"Right",	ColMerge:0,	SaveName:"closeCnt",	KeyField:0,	Format:"",PointCount:2,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"비고",			Type:"Text",		Hidden:0,	Width:180,	Align:"Left",	ColMerge:0,	SaveName:"bigo",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2000}
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		// 근태신청여부가 Y 인것만 나오도록 처리
		var gntCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getCpnGntCdList&applYn=Y",false).codeList, "전체");
		sheet1.SetColProperty("gntCd", 		{ComboText:"|"+gntCd[0], ComboCode:"|"+gntCd[1]} );

		//사업장코드 관리자권한만 전체사업장 보이도록, 그외는 권한사업장만.
		var url     = "queryId=getBusinessPlaceCdList";
		var allFlag = true;
		if ("${ssnSearchType}" != "A"){
			url    += "&searchChkPlace=Y&sabun=${ssnSabun}&grpCd=${ssnGrpCd}";
			allFlag = false;
		}
		var bizPlaceCdList = "";
		if(allFlag) {
			bizPlaceCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, ("${ssnLocaleCd}" != "en_US" ? "전체" : "All"));	//사업장
		} else {
			bizPlaceCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, "");	//사업장
		}
		$("#searchBizPlaceCd").html(bizPlaceCdList[2]);

		//근무지 관리자권한만 전체근무지 보이도록, 그외는 권한근무지만.
		url     = "queryId=getLocationCdListAuth";
		allFlag = true;
		if ("${ssnSearchType}" != "A"){
			url    += "&searchChkPlace=Y&sabun=${ssnSabun}&grpCd=${ssnGrpCd}";
			allFlag = false;
		}
		var locationCdList = "";
		if(allFlag) {
			locationCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, ("${ssnLocaleCd}" != "en_US" ? "전체" : "All"));	//사업장
		} else {
			locationCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, "");	//사업장
		}
		$("#searchLocationCd").html(locationCdList[2]);
		sheet1.SetColProperty("locationCd", {ComboText:"|"+locationCdList[0], ComboCode:"|"+locationCdList[1]});
		$("#searchGntCd").html(gntCd[2]);
		$("#fromSdate").datepicker2({startdate:"toSdate"});
		$("#toSdate").datepicker2({enddate:"fromSdate"});
		$("#fromSdate").val("${curSysYyyyMMHyphen}-01") ;
		$("#toSdate").val('<%= DateUtil.getLastDateOfMonthString(DateUtil.getCurrentTime("yyyy-MM-dd"))%>') ;
        $("#searchSbNm, #fromSdate, #toSdate").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
        $("#searchBizPlaceCd").bind("change",function(event){
			doAction1("Search");
		});
        
      //Autocomplete
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue){
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow, "sabun",		rv["sabun"]);
						sheet1.SetCellValue(gPRow, "name",		rv["name"]);
						sheet1.SetCellValue(gPRow, "orgNm",		rv["orgNm"]);
						sheet1.SetCellValue(gPRow, "workTypeNm",rv["workTypeNm"]);
						sheet1.SetCellValue(gPRow, "payTypeNm",	rv["payTypeNm"]);
						sheet1.SetCellValue(gPRow, "jikgubNm",	rv["jikgubNm"]);
						sheet1.SetCellValue(gPRow, "locationCd",rv["locationCd"]);
					}
				}
			]
		});

		$(window).smartresize(sheetResize); sheetInit();
		
		// 저장 시 분할 저장 설정 (대량업로드 대비)
		IBS_setChunkedOnSave("sheet1", {chunkSize : 25});	
		
		doAction1("Search") ;
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			searchFlag = "search";
			sheet1.DoSearch( "${ctx}/VacationAppUpload.do?cmd=getVacationAppUploadList",$("#sheet1Form").serialize() );
			break;
		case "Insert":
			var newRow = sheet1.DataInsert(0);
			sheet1.SetCellValue(newRow, "gntCd", "YC") ;//기본은 연차로 세팅
			sheet1.SetCellValue(newRow, "applYmd", "${curSysYyyyMMdd}") ;//기본은 현재일자로 세팅
			break;
		case "Save":
			if(!dupChk(sheet1,"sabun|gntCd|applYmd|sdate", true, true)){break;}
			
			for(var i = 1; i < sheet1.LastRow()+1; i++) {
				if(sheet1.GetCellValue(i,"sStatus") == "U" || sheet1.GetCellValue(i,"sStatus") == "I"){
					if((sheet1.GetCellValue(i,"sdate") != sheet1.GetCellValue(i,"edate")) && 
							(sheet1.GetCellValue(i,"gntCd") == "15" || sheet1.GetCellValue(i,"gntCd") == "16")){
						alert("반차는 하루단위로 신청 가능합니다.");
						return;
					}		
				}
			}
			
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/VacationAppUpload.do?cmd=saveVacationAppUpload" ,$("#sheet1Form").serialize());
			break;
		case "CreateSearch":
			//대상자생성
			//근태종류/사업장/시작일자/종료일자 필수
			if ($("#searchGntCd").val() == ""){
				alert("<msg:txt mid='2017083000986' mdef='근태를 선택하십시오.'/>");
				return;
			}
			if ($("#searchBizPlaceCd").val() == ""){
				alert("<msg:txt mid='2017082900922' mdef='사업장을 선택하십시오.'/>");
				return;
			}

			searchFlag = "cre";
			sheet1.DoSearch( "${ctx}/VacationAppUpload.do?cmd=getVacationAppUploadListCre",$("#sheet1Form").serialize() );
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param);
			break;
		case "Copy":
			sheet1.DataCopy();
			break;
		case "DownTemplate":
			// 양식다운로드
			//sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"4|6|7|8|9|11"});
			sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"sabun|gntCd|applYmd|sdate|edate|bigo"});

			break;
		case "LoadExcel":
			var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params);
			break;
		}
	}

	function sheet1_OnLoadExcel() {

		for(var i = 1; i < sheet1.LastRow()+1; i++) {
			if(sheet1.GetCellValue(i,"applYmd") == "") {
				sheet1.SetCellValue(i, "applYmd", "${curSysYyyyMMdd}") ;//없으면 현재일자로 세팅
			}
			if(sheet1.GetCellValue(i,"sdate") != "" && sheet1.GetCellValue(i,"edate") != "") {
				sheet1.SetCellValue(i, "dayCnt", getDaysBetween(sheet1.GetCellValue(i,"sdate"), sheet1.GetCellValue(i,"edate"))) ;//총일수세팅
			}
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}


	function sheet1_OnRowSearchEnd(Row) {

        if (sheet1.GetCellValue(Row,"applyYn") == "Y") {
        	sheet1.SetRowEditable(Row,0);
        } else {
        	sheet1.SetRowEditable(Row,1);
        }
        if (searchFlag == "cre"){
			if(sheet1.GetCellValue(Row,"sdate") != "" && sheet1.GetCellValue(Row,"edate") != "") {
				sheet1.SetCellValue(Row, "dayCnt", getDaysBetween(sheet1.GetCellValue(Row,"sdate"), sheet1.GetCellValue(Row,"edate"))) ;//총일수세팅
			}
        	sheet1.SetCellValue(Row, "sStatus", 'I');
        }
	}


	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			if (Code > 0){
				doAction1("Search");
			}
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function sheet1_OnChange(Row, Col, Value) {
		try{
			if(sheet1.GetCellValue(Row,"sdate") != "" && sheet1.GetCellValue(Row,"edate") != "") {
				if(sheet1.GetCellValue(Row,"sdate") > sheet1.GetCellValue(Row,"edate")) {
					alert("<msg:txt mid='109513' mdef='시작일은 종료일보다 작거나 같아야합니다.'/>");
					sheet1.SetCellValue(Row,"edate","",0);
					return;
				}
				const dayCnt = getDaysBetween(sheet1.GetCellValue(Row,"sdate"), sheet1.GetCellValue(Row,"edate"));
				sheet1.SetCellValue(Row, "dayCnt", dayCnt);
				const searchSabun = sheet1.GetCellValue(Row, "sabun");
				const searchGntCd = sheet1.GetCellValue(Row, "gntCd");
				const searchSdate = sheet1.GetCellValue(Row, "sdate");
				const searchEdate = sheet1.GetCellValue(Row, "edate");
				const closeCnt = getCloseCnt(searchSabun, searchGntCd, searchSdate, searchEdate, dayCnt);
				sheet1.SetCellValue(Row, "closeCnt", closeCnt);
			}
		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}

	function getCloseCnt(searchSabun, searchGntCd, searchSdate, searchEdate, dayCnt) {
		var params = "searchSabun="+searchSabun+"&searchGntCd="+searchGntCd+"&searchSdate="+searchSdate+"&searchEdate="+searchEdate+"&dayCnt="+dayCnt;
		var data = ajaxCall("/VacationAppUpload.do?cmd=getVacationAppUploadCloseCnt", params, false);
		if (data && data.Result) {
			return data.Result.closeCnt;
		} else {
			if (data.Message) {
				alert(data.Message);
			} else {
				alert("적용일수 조회에 실패하였습니다. 담당자에게 문의 바랍니다.");
			}
			return null;
		}
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			if(sheet1.GetCellEditable(Row,Col) == true) {
				if(sheet1.ColSaveName(Col) == "name" && KeyCode == 46) {
	                sheet1.SetCellValue(Row, "sabun",	"" );
	                sheet1.SetCellValue(Row, "name",	"" );
				}
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	function callProc(searchSabun, searchApplYmd, searchGntCd) {

		var params = "searchSabun="+searchSabun+"&searchApplYmd="+searchApplYmd+"&searchGntCd="+searchGntCd ;
		var ajaxCallCmd = "prcP_TIM_CREW_CREATE" ;

    	var data = ajaxCall("/VacationAppUpload.do?cmd="+ajaxCallCmd,params,false);

    	if(data.Result.Code == null) {
    		msg = true ;
    	} else {
	    	msg = "Error : "+data.Result.Message;
    	}

    	return msg ;
	}

	function callProcList() {
		var applyCnt = 0 ;
		for( var i = 1, j = 0; i < sheet1.LastRow()+1; i++ ) {
			if( sheet1.GetCellValue(i, "applyYn") == "Y" && sheet1.GetCellValue(i, "sStatus") == "U" ) {
				applyCnt++ ;
				var msg = callProc( sheet1.GetCellValue(i, "sabun"), sheet1.GetCellValue(i, "applYmd"), sheet1.GetCellValue(i, "gntCd") ) ;
				if(msg != true) {
					alert( sheet1.GetCellValue(i, "sabun")+ " >> " + msg ) ;
					return ;
				}
			}
		}
		if(applyCnt == 0) {
			alert("<msg:txt mid='alertVacationAppUpload3' mdef='반영대상을 선택하여 주십시오.'/>") ;
		} else {
			alert("<msg:txt mid='alertVacationAppUpload4' mdef='반영이 완료 되었습니다.'/>") ;
			doAction1('Search');
		}
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<th><tit:txt mid='103963' mdef='근태명'/></th>
			<td>
				<select id="searchGntCd" name="searchGntCd" onChange="doAction1('Search')"></select>
			</td>
			<th><tit:txt mid='104000' mdef='반영여부'/></th>
			<td>
				<select id="searchApplyYn" name="searchApplyYn" onChange="doAction1('Search')">
					<option value=""><tit:txt mid='103895' mdef='전체'/></option>
					<option value="Y"><tit:txt mid='112839' mdef='반영'/></option>
					<option value="N"><tit:txt mid='2017083000988' mdef='미반영'/></option>
				</select>
			</td>
			<th><tit:txt mid='104281' mdef='근무지'/></th>
			<td>
				<select id="searchLocationCd" name="searchLocationCd"> </select>
			</td>
			<th><tit:txt mid='114399' mdef='사업장'/></th>
			<td>
				<select id="searchBizPlaceCd" name="searchBizPlaceCd"> </select>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='104279' mdef='소속'/></th>
			<td>
				<input type="text" id="searchOrgNm" name="searchOrgNm" class="text w150" />
			</td>
			<th><tit:txt mid='104330' mdef='사번/성명'/></th>
			<td>
				<input id="searchSbNm" name="searchSbNm" type="text" class="text"/>
			</td>
			<th><tit:txt mid='113464' mdef='시작일자'/></th>
			<td colspan="2">  <input type="text" id="fromSdate" name="fromSdate" class="date2" /> ~
			<input type="text" id="toSdate" name="toSdate" class="date2" /> </td>
			<td>
				<btn:a href="javascript:doAction1('Search');" css="btn dark" mid="search" mdef="조회"/>
			</td>
		</tr>
		</table>
		</div>
	</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt">휴가일괄업로드</li>
			<li class="btn">
				<!--<btn:a href="javascript:doAction1('CreateSearch');" css="basic authA" mid="userCre" mdef="대상자생성"/> -->
				<btn:a href="javascript:doAction1('DownTemplate')" 	css="btn outline_gray authR" mid="down2ExcelV1" mdef="양식다운로드"/>
				<btn:a href="javascript:doAction1('LoadExcel')" 	css="btn outline_gray authR" mid="upload" mdef="업로드"/>
				<btn:a href="javascript:callProcList()" 			css="btn filled authA" mid="appliedV6" mdef="반영"/>
				<btn:a href="javascript:doAction1('Insert');" 		css="btn outline_gray authA" mid="insert" mdef="입력"/>
				<btn:a href="javascript:doAction1('Copy');" 		css="btn outline_gray authA" mid="copy" mdef="복사"/>
				<btn:a href="javascript:doAction1('Save');" 		css="btn filled authA" mid="save" mdef="저장"/>
				<btn:a href="javascript:doAction1('Down2Excel');" 	css="btn outline_gray authR" mid="download" mdef="다운로드"/>
			</li>
		</ul>
		</div>
	</div>

	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>