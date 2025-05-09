<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='114502' mdef='직무 리스트 조회'/></title>

<script type="text/javascript">
	var jobTypeDisp = 0;
	$(function() {
		var modal = window.top.document.LayerModalUtility.getModal('jobPopupLayer');
		createIBSheet3(document.getElementById('jobPopupSheet-wrap'), "jobPopupSheet", "100%", "100%", "${ssnLocaleCd}");
		if( modal != undefined ) {
			$("#searchJobType").val(modal.parameters.searchJobType);
			$("#searchJobNm").val(modal.parameters.searchJobNm);
			
			if (modal.parameters.searchJobType == "10050") { // 직무
				jobTypeDisp = 1;
			}

		}


		//배열 선언
		var initdata = {};
		//SetConfig
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:6, DataRowMerge:0, AutoFitColWidth:'init|search|resize|rowtransaction'};
		//HeaderMode
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		//InitColumns + Header Title
		initdata.Cols = [
				{Header:"<sht:txt mid='sNo' mdef='No'/>",         Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },

				{Header:"<sht:txt mid='dbItemDesc' mdef='세부\n내역'/>",	Type:"Image",     Hidden:0,  Width:50,   Align:"Center",  	ColMerge:0,   SaveName:"detail", 		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10,	Cursor:"Pointer" },
				{Header:"<sht:txt mid='jobCdV1' mdef='직무코드'/>",		Type:"Text",      Hidden:0,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"jobCd",         KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
	            {Header:"<sht:txt mid='jobNmV2' mdef='직무명'/>",			Type:"Text",      Hidden:0,  Width:250,  Align:"Left",    	ColMerge:0,   SaveName:"jobNm",         KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	            {Header:"<sht:txt mid='jobEngNm' mdef='직무명(영문)'/>", 	Type:"Text",      Hidden:1,  Width:0,  	 Align:"Left",    	ColMerge:0,   SaveName:"jobEngNm",    	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	            {Header:"<sht:txt mid='jobType' mdef='직무형태'/>",		Type:"Combo",     Hidden:jobTypeDisp,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"jobType",       KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
	            {Header:"<sht:txt mid='memoV12' mdef='개요'/>",			Type:"Text",      Hidden:1,  Width:0,  	 Align:"Left",    	ColMerge:0,   SaveName:"memo",          KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4000 },
	            {Header:"<sht:txt mid='jobDefine' mdef='직무정의'/>",		Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    	ColMerge:0,   SaveName:"jobDefine",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4000 },
	            {Header:"<sht:txt mid='eduSYmd' mdef='시작일'/>",			Type:"Date",      Hidden:0,  Width:100,  Align:"Center",  	ColMerge:0,   SaveName:"sdate",         KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
	            {Header:"<sht:txt mid='eYmdV1' mdef='종료일'/>", 		Type:"Date",      Hidden:0,  Width:100,  Align:"Center",  	ColMerge:0,   SaveName:"edate",         KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
	            {Header:"<sht:txt mid='jikgubReq' mdef='직급요건'/>",  		Type:"Combo",     Hidden:1,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"jikgubReq",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
	            {Header:"<sht:txt mid='academyReq' mdef='학력요건'/>", 		Type:"Combo",     Hidden:1,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"academyReq",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
	            {Header:"<sht:txt mid='majorReq' mdef='전공요건'/>", 		Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    	ColMerge:0,   SaveName:"majorReq",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	            {Header:"<sht:txt mid='careerReq' mdef='경력요건'/>",  		Type:"Combo",     Hidden:1,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"careerReq",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
	            {Header:"<sht:txt mid='otherJobReq' mdef='경력요건(타직무)'/>", Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    	ColMerge:0,   SaveName:"otherJobReq",  	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	            {Header:"<sht:txt mid='armyMemo' mdef='비고'/>",  			Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    	ColMerge:0,   SaveName:"note",          KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4000 },
	            {Header:"<sht:txt mid='agreeSeq' mdef='순서'/>", 			Type:"Int",  	  Hidden:1,  Width:30,   Align:"Center",  	ColMerge:0,   SaveName:"seq",     		KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:3 }
		];
		IBS_InitSheet(jobPopupSheet, initdata);jobPopupSheet.SetVisible(true);jobPopupSheet.SetCountPosition(4);jobPopupSheet.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

		var jobType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W30010"), "");	//직무형태
		var jikgubReq 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W30019"), "");	//직급요건
		var academyReq 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W30018"), "");	//학력요건
		var careerReq 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W30020"), "");	//경력요건


		jobPopupSheet.SetColProperty("jobType", 			{ComboText:jobType[0], ComboCode:jobType[1]} );	//직무형태
		jobPopupSheet.SetColProperty("jikgubReq", 			{ComboText:"|"+jikgubReq[0], ComboCode:"|"+jikgubReq[1]} );	//직급요건
		jobPopupSheet.SetColProperty("academyReq", 		{ComboText:"|"+academyReq[0], ComboCode:"|"+academyReq[1]} );	//학력요건
		jobPopupSheet.SetColProperty("careerReq", 			{ComboText:"|"+careerReq[0], ComboCode:"|"+careerReq[1]} );	//경력요건

	    $(window).smartresize(sheetResize); sheetInit();

		var sheetHeigth = $(".modal_body").height() - $("#mySheetForm").height() -  $(".sheet_title").height() -2;
		jobPopupSheet.SetSheetHeight(sheetHeigth);

	    $("#searchSdate").datepicker2();

	    doActionJob("Search");

	    $(".close").click(function() {
			closeCommonLayer('jobPopupLayer');
	    });


        $("#searchSdate,#searchJobNm").bind("keyup",function(event){
            if( event.keyCode == 13){ doActionJob("Search"); $(this).focus(); }
        });

	});

	/*Sheet Action*/
	function doActionJob(sAction) {
		switch (sAction) {
		case "Search": 		//조회
			jobPopupSheet.DoSearch( "${ctx}/Popup.do?cmd=getJobPopupList", $("#mySheetForm").serialize() );
			break;
		}
    }

	// 	조회 후 에러 메시지
	function jobPopupSheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") alert(Msg);
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function jobPopupSheet_OnDblClick(Row, Col){
		var rv = new Array(6);
		rv["jobCd"] 		= jobPopupSheet.GetCellValue(Row, "jobCd");
		rv["jobNm"]			= jobPopupSheet.GetCellValue(Row, "jobNm");

		rv["jobEngNm"]		= jobPopupSheet.GetCellValue(Row, "jobEngNm");

		rv["jobType"]		= jobPopupSheet.GetCellValue(Row, "jobType");
		rv["sdate"]			= jobPopupSheet.GetCellValue(Row, "sdate");
		rv["edate"]			= jobPopupSheet.GetCellValue(Row, "edate");

		var rtnModal = window.top.document.LayerModalUtility.getModal('jobPopupLayer');
		rtnModal.fire("jobPopupTrigger", rv).hide();

	}

	function jobPopupSheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
		    if(Row > 0 && jobPopupSheet.ColSaveName(Col) == "detail"){
		    	jobMgrPopup(Row);
		    }
	  	}catch(ex){alert("OnClick Event Error : " + ex);}
	}

	/**
	 * 직무기술서 팝업
	 */
	function jobMgrPopup(Row){
		if(!isPopup()) {return;}

		var w 		= 940;
		var h 		= 720;
		var url = "/Popup.do?cmd=viewJobMgrLayer&authPg=R";
		var p = {
			jobCd : jobPopupSheet.GetCellValue(Row, "jobCd")
		};

		// openPopup(url,args,w,h);
		var jobMgrLayer = new window.top.document.LayerModal({
			id: 'jobMgrLayer',
			url: url,
			parameters: p,
			width: w,
			height: h,
			title: '직무기술서',
			trigger: [
				{
					name: 'jobMgrLayerTrigger',
					callback: function(rv) {
					}
				}
			]
		});

		jobMgrLayer.show();
	}
</script>


</head>
<body class="bodywrap">

	<div class="wrapper modal_layer">
        <div class="modal_body">
		<form id="mySheetForm" name="mySheetForm" tabindex="1">
			<input type="hidden" id="searchJobType" name ="searchJobType" value="" />
			<div class="sheet_search outer">
				<div>
				<table>
				<tr>
					<th><tit:txt mid='104352' mdef='기준일자'/></th>
                       <td> 
                            <input type="text" id="searchSdate" name="searchSdate" class="date2" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>"/>
                       </td>
                       <th><tit:txt mid='112031' mdef='직무명'/></th>
					   <td>  <input id="searchJobNm" name ="searchJobNm" type="text" class="text" /> </td>
                       <td>
						<a href="javascript:doActionJob('Search')" id="btnSearch" class="button"><tit:txt mid='104081' mdef='조회'/></a>
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
						<li id="txt" class="txt"><tit:txt mid='114502' mdef='직무 리스트 조회'/></li>
					</ul>
					</div>
				</div>
				<div id="jobPopupSheet-wrap"></div>
				</td>
			</tr>
		</table>
	</div>
	<div class="modal_footer">
		<a href="javascript:closeCommonLayer('jobPopupLayer');" class="btn outline_gray close"><tit:txt mid='104157' mdef='닫기'/></a>
	</div>
</div>
</body>
</html>



