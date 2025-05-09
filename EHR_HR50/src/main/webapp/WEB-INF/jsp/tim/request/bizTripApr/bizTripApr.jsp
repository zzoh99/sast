<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">

	var pGubun = "";

	$(function() {

		$("#searchFrom").datepicker2({startdate:"searchTo"});
		$("#searchTo").datepicker2({enddate:"searchFrom"});

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata.Cols = [

			{Header:"No",						Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
// 			{Header:"삭제",						Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
// 			{Header:"상태",						Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"세부\n내역",					Type:"Image",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"ibsImage",	KeyField:0,				Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"신청일자",					Type:"Date",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"applYmd",		KeyField:0,				Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:"결재상태",					Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applStatusCd",KeyField:0,				Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:"결재완료일",					Type:"Date",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"agreeYmd",	KeyField:0,				Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:"출장구분",					Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"btripCd",		KeyField:0,				Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"출장명",						Type:"Text",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"btripNm",		KeyField:0,				Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 },
			{Header:"출장지역",					Type:"Text",		Hidden:0,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"btripLoc",	KeyField:0,				Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 },
			{Header:"출장기간",					Type:"Text",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"btripDate",	KeyField:0,				Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 },
			{Header:"출장자",						Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"member",		KeyField:0,				Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"신청자",						Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"applNm",		KeyField:0,				Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },

			{Header:"신청서순번(THRI103)",			Type:"Int",			Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applSeq",		KeyField:0,				Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"사번",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,				Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"성명",						Type:"PopupEdit",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,				Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"신청자사번",					Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applSabun",	KeyField:0,				Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 }

			]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetImageList(0,"/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("ibsImage", 1);

       //  결재상태
       	var applStatusCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R10010"), "전체");
		sheet1.SetColProperty("applStatusCd", 	{ComboText:"|"+applStatusCd[0], ComboCode:"|"+applStatusCd[1]} );

		var searchApplStatusCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAprStatusList",false).codeList, "전체");
		$("#searchApplStatusCd").html(searchApplStatusCd[2]);

		// 출장구분
		var btripCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","T80001"), "전체");
		sheet1.SetColProperty("btripCd", 	{ComboText:"|"+btripCd[0], ComboCode:"|"+btripCd[1]} );
		$("#searchBtripCd").html(btripCd[2]);

		$(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/BizTripApr.do?cmd=getBizTripAprList", $("#sheetForm").serialize() ); break;

		case "Save":
			IBS_SaveName(document.sheetForm,sheet1);
			sheet1.DoSave( "${ctx}/BizTripApr.do?cmd=saveBizTripApr", $("#sheetForm").serialize()); break;

        case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheet1.Down2Excel(param); break;
		}
	}
	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {

			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();

		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

//  소속 팝입
    function orgSearchPopup(){
        try{
        	if(!isPopup()) {return;}

			var args    = new Array();

			pGubun = "searchOrgBasicPopup";

			openPopup("/Popup.do?cmd=orgBasicPopup", args, "740","520");
        }catch(ex){
        	alert("Open Popup Event Error : " + ex);
        }
    }


//  사원 팝입
    function employeePopup(){
        try{
        	if(!isPopup()) {return;}

			var args    = new Array();

			pGubun = "searchEmployeePopup";

			openPopup("/Popup.do?cmd=employeePopup", args, "740","520");
        }catch(ex){
        	alert("Open Popup Event Error : " + ex);
        }
    }

	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
		    if( sheet1.ColSaveName(Col) == "ibsImage" && Row >= sheet1.HeaderRows()) {

		    	var searchSabun = sheet1.GetCellValue(Row,"applSabun");
	    		var applSeq = sheet1.GetCellValue(Row,"applSeq");
	    		var applSabun = sheet1.GetCellValue(Row,"applSabun");
	    		var applYmd = sheet1.GetCellValue(Row,"applYmd");

	    		showApplPopup("R",applSeq,searchSabun,applSabun,applYmd, Row);


		    }
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}

	//승인 팝업
	function showApplPopup(auth,seq,sabun,applSabun,applYmd, Row) {
		if(!isPopup()) {return;}

		if(auth == "") {
			alert("<msg:txt mid='110262' mdef='권한을 입력하여 주십시오.'/>");
			return;
		}
		
		var p = {
				searchApplCd: '123'
			  , searchApplSeq: seq
			  , adminYn: 'Y'
			  , authPg: auth
			  , searchSabun: applSabun
			  , searchApplSabun: sabun
			  , searchApplYmd: applYmd 
			};

		var url = "";
		var initFunc = '';
		if(auth == "A") {
			url = "/ApprovalMgr.do?cmd=viewApprovalMgrLayer";
			initFunc = 'initLayer';
		} else {
			url = "/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
			initFunc = 'initResultLayer';
		}

		pGubun = "viewApprovalMgr";
		var approvalMgrLayer = new window.top.document.LayerModal({
			id: 'approvalMgrLayer',
			url: url,
			parameters: p,
			width: 800,
			height: 815,
			title: '근태신청',
			trigger: [
				{
					name: 'approvalMgrLayerTrigger',
					callback: function(rv) {
						getReturnValue(rv);
					}
				}
			]
		});
		approvalMgrLayer.show();
		//window.top.openLayer(url, p, 800, 815, initFunc, getReturnValue);
	}


	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');
        if(pGubun == "searchOrgBasicPopup"){
			$("#searchOrgCd").val(rv["orgCd"]);
			$("#searchOrgNm").val(rv["orgNm"]);
        } else if(pGubun == "searchEmployeePopup"){
			$("#searchName").val(rv["name"]);
			$("#searchSabun").val(rv["sabun"]);
        } else if(pGubun == "viewApprovalMgr"){
    		doAction1("Search");
        }
	}

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
	<!-- 조회조건 -->
	<input type="hidden" id="searchOrgCd" name="searchOrgCd" value =""/>
	<input type="hidden" id="searchSabun" name="searchSabun" value="" />

	<!-- 조회조건 -->
		<div class="sheet_search outer">
			<div>

				<table>
					<tr>
						<th>신청일자</th>
						<td>
							<input type="text" id="searchFrom" name="searchFrom" class="date2" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),-10)%>"> ~
							<input type="text" id="searchTo" name="searchTo" class="date2" value="<%=DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"), +10)%>">
						</td>
						<th>출장구분</th>
						<td>
							<select id="searchBtripCd" name ="searchBtripCd" onChange="javascript:doAction1('Search')" class="box"></select>
						</td>
						<th>결재상태</th>
						<td>
							<select id="searchApplStatusCd" name ="searchApplStatusCd" onChange="javascript:doAction1('Search')" class="box"></select>
						</td>
					</tr>
					<tr>
						<th>소속 </th>
						<td>
							<input id="searchOrgNm" name ="searchOrgNm" type="text" class="text" readOnly />
							<a onclick="javascript:orgSearchPopup();"  class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
							<a onclick="$('#searchOrgCd,#searchOrgNm').val('');"  class="button7"><img src="/common/images/icon/icon_undo.png"/></a>
						</td>
						<th>성명 </th>
						<td>
							<input id="searchName" name ="searchName" type="text" class="text" readOnly />
							<a onclick="javascript:employeePopup();"  class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
							<a onclick="$('#searchSabun,#searchName').val('');"  class="button7"><img src="/common/images/icon/icon_undo.png"/></a>
						</td>
						<td> <btn:a href="javascript:doAction1('Search')" id="btnSearch" css="btn dark" mid='search' mdef="조회"/>  </td>
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
							<li id="txt" class="txt">출장내신서승인</li>
							<li class="btn">
								<a href="javascript:doAction1('Down2Excel')"	class="btn outline_gray"><tit:txt mid='download' mdef='다운로드'/></a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "kr"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>