<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='112882' mdef='노조관리'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function() {

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"소속",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"사번",			Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"성명",			Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"직위",			Type:"Text",   	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직책",			Type:"Text",   	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },

			{Header:"가입일",			Type:"Date",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"sdate",			KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"탈퇴일",			Type:"Date",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"edate",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"노조직책",		Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"nojoJikchakCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"임명일",			Type:"Date",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"appointYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"임기만료일",		Type:"Date",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"expYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"노조비\n공제여부",	Type:"CheckBox",Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"payDeductYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1,	TrueValue:"Y", FalseValue:"N"},
			{Header:"비고",			Type:"Text",   	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"memo",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000 },
			{Header:"첨부파일",		Type:"Html",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"btnFile",			KeyField:0,	Format:"",		Edit:0 },

			{Header:"Hidden",	Hidden:1, SaveName:"fileSeq" }

		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var userCd1 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&note1=생산노조","H90011"), "<tit:txt mid='103895' mdef='전체'/>");
		sheet1.SetColProperty("nojoJikchakCd", 		{ComboText:"|"+userCd1[0], ComboCode:"|"+userCd1[1]} );

		//사업장코드 관리자권한만 전체사업장 보이도록, 그외는 권한사업장만.
		var url     = "queryId=getBusinessPlaceCdList";
		var allFlag = true;
		if ("${ssnSearchType}" != "A"){
			url    += "&searchChkPlace=Y&sabun=${ssnSabun}&grpCd=${ssnGrpCd}";
			allFlag = false;
		}
		var businessPlaceCd = "";
		if(allFlag) {
			businessPlaceCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, ("${ssnLocaleCd}" != "en_US" ? "전체" : "All"));	//사업장
		} else {
			businessPlaceCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, "");	//사업장
		}
		$("#searchBizPlaceCd").html(businessPlaceCd[2]);
		$("#searchBizPlaceCd").bind("change",function(event) {
			doAction1("Search");
		});

		// 재직상태
 		var statusCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10010"), "");
 		select2MultiChoose(statusCd[2], "AA", "searchStatusCd", "<tit:txt mid='103895' mdef='전체'/>");

		$("#searchSdate").datepicker2();
		$("#searchEdate").datepicker2();

// 		$("#searchSdate").datepicker2({startdate:"toSdate"});
// 		$("#toSdate").datepicker2({enddate:"searchSdate"});

//		$("#searchSdate").val("${curSysYyyyMMHyphen}-01") ;
//		$("#searchEdate").val("${curSysYyyyMMHyphen}-31") ;

        $("#searchSaNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");

		// 이름 입력 시 자동완성
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue){
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow, "orgNm",	rv["orgNm"]);
						sheet1.SetCellValue(gPRow, "sabun",	rv["sabun"]);
						sheet1.SetCellValue(gPRow, "name",	rv["name"]);
						sheet1.SetCellValue(gPRow, "jikweeNm",	rv["jikweeNm"]);
						sheet1.SetCellValue(gPRow, "jikchakNm",	rv["jikchakNm"]);
					}
				}
			]
		});	
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			$("#multiStatusCd").val(getMultiSelect($("#searchStatusCd").val()));
			var sXml = sheet1.GetSearchData("${ctx}/ProductionUnionMgr.do?cmd=getProductionUnionMgrList", $("#sheet1Form").serialize() );
			sXml = replaceAll(sXml,"shtcolEdit", "Edit");
			sheet1.LoadSearchData(sXml);
        	break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			sheet1.SetCellValue(row, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
			sheet1.SetCellValue(row, "payDeductYn", 'Y');
			break;
		case "Save":
			if(!dupChk(sheet1,"sabun|sdate", true, true)){break;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/ProductionUnionMgr.do?cmd=saveProductionUnionMgr" ,$("#sheet1Form").serialize());
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
		case "Copy":
			var row = sheet1.DataCopy();
			break;
		case "DownTemplate":
			// 양식다운로드
			sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"4|8|9|10|11|12|13|14"});
			break;
		case "LoadExcel":
			// 업로드
			var params = {};
			sheet1.LoadExcel(params);
			break;
		}
	}

	function sheet1_OnLoadExcel() {
		sheet1.SetRangeValue("20", sheet1.HeaderRows(), 15, sheet1.LastRow(), 15);
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

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			doAction1("Search") ;
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function sheet1_OnChange(Row, Col, Value) {
		try{
		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}

	var gPRow = "";
    var pGubun = "";
	// 팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
			if(sheet1.ColSaveName(Col) == "name" || sheet1.ColSaveName(Col) == "adviser") {
				if(!isPopup()) {return;}

				pGubun = "name";

				gPRow = Row;
	            openPopup("/Popup.do?cmd=employeePopup&authPg=${authPg}", "", "840","520");

			}
		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}

	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

		if(pGubun == "fileMgr") {
			if(rv["fileCheck"] == "exist"){
				sheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
				sheet1.SetCellValue(gPRow, "fileSeq", rv["fileSeq"]);
			}else{
				sheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
				sheet1.SetCellValue(gPRow, "fileSeq", "");
			}
		}else if( pGubun == "name" ){
            sheet1.SetCellValue(gPRow, "sabun",		rv["sabun"] );
            sheet1.SetCellValue(gPRow, "name",		rv["name"] );
            sheet1.SetCellValue(gPRow, "alias",		rv["alias"] );
            sheet1.SetCellValue(gPRow, "orgNm",		rv["orgNm"] );
            sheet1.SetCellValue(gPRow, "jikweeNm",	rv["jikweeNm"] );
            sheet1.SetCellValue(gPRow, "jikchakNm",	rv["jikchakNm"] );
        }
	}

	//파일 신청 시작
	function sheet1_OnClick(Row, Col, Value) {
		try{
			gPRow = Row;
			if(sheet1.ColSaveName(Col) == "btnFile"	&& Row >= sheet1.HeaderRows()){
				var param = [];
				param["fileSeq"] = sheet1.GetCellValue(Row,"fileSeq");
				if(sheet1.GetCellValue(Row,"btnFile") != ""){
					pGubun = "fileMgr";
					if(!isPopup()) {return;}

					var authPgTemp="${authPg}";
					openPopup("/fileuploadJFileUpload.do?cmd=fileMgrPopup&authPg="+authPgTemp+"&uploadType=ccr", param, "740","620");
				}

			}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}
	//파일 신청 끝
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
	<input type="hidden" id="multiStatusCd" name="multiStatusCd" value="" />

	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<th><tit:txt mid='112528' mdef='가입일자'/></th>
			<td>
				<!--
				<input type="text" id="searchSdate" name="searchSdate" class="date2" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),-365)%>" /> ~
				<input type="text" id="searchEdate" name="searchEdate" class="date2" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>"/>
				-->
				<input type="text" id="searchSdate" name="searchSdate" class="date2" value="" /> ~
				<input type="text" id="searchEdate" name="searchEdate" class="date2" value=""/>
			</td>
			<th>사업장</th>
			<td>
				<select id="searchBizPlaceCd" name="searchBizPlaceCd"> </select>
			</td>
			<th><tit:txt mid='104472' mdef='재직상태'/></th>
			<td>
				<select id="searchStatusCd" name="searchStatusCd" multiple></select>
			</td>
			<th><tit:txt mid='104330' mdef='사번/성명'/></th>
			<td>
				<input id="searchSaNm" name="searchSaNm" type="text" class="text"/>
			</td>
			<td><btn:a href="javascript:doAction1('Search');" css="button" mid='110697' mdef="조회"/></td>
		</tr>
		</table>
		</div>
	</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='112882' mdef='생산노조관리'/></li>
			<li class="btn">
				<btn:a href="javascript:doAction1('DownTemplate')" 	css="basic authR" mid='110702' mdef="양식다운로드"/>
				<btn:a href="javascript:doAction1('LoadExcel')" 	css="basic authR" mid='110703' mdef="업로드"/>
				<btn:a href="javascript:doAction1('Insert');" 		css="basic authA" mid='110700' mdef="입력"/>
				<btn:a href="javascript:doAction1('Copy');" 		css="basic authA" mid='110696' mdef="복사"/>
				<btn:a href="javascript:doAction1('Save');" 		css="basic authA" mid='110708' mdef="저장"/>
				<a href="javascript:doAction1('Down2Excel');" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
