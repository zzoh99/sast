<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html><html class="bodywrap"><head><title></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("${popUpStatus}");
	var arg = p.popDialogArgumentAll();
	var gPRow = "";
	var pGubun = "";

	$(function() {
		var eduStatusCdList	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L10190"), "<tit:txt mid='103895' mdef='전체'/>"); //회차상태

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",  Hidden:0,	 Width:"${sNoWdt}",		Align:"Center",	ColMerge:0,	SaveName:"sNo" },

			{Header:"<sht:txt mid='dbItemDesc' mdef='세부\n내역'/>",			Type:"Image",     Hidden:1,  Width:50,	Align:"Center",  ColMerge:1,   SaveName:"detail",          KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
			{Header:"<sht:txt mid='eduCourseNm' mdef='과정명'/>",				Type:"Text",      Hidden:0,  Width:150,	Align:"Left",    ColMerge:1,   SaveName:"eduCourseNm",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='eduEventNm' mdef='회차명'/>",				Type:"Text",      Hidden:0,  Width:150,	Align:"Left",    ColMerge:1,   SaveName:"eduEventNm",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='eduStatusCdV4' mdef='회차상태'/>",			Type:"Combo",     Hidden:0,  Width:50,	Align:"Center",  ColMerge:1,   SaveName:"eduStatusCd",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='eduSYmd' mdef='시작일'/>", 			Type:"Date",      Hidden:0,  Width:60,	Align:"Center",  ColMerge:1,   SaveName:"eduSYmd",         KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='eYmdV1' mdef='종료일'/>",				Type:"Date",      Hidden:0,  Width:60,	Align:"Center",  ColMerge:1,   SaveName:"eduEYmd",         KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },

			{Header:"<sht:txt mid='eduSeqV2' mdef='eduSeq'/>",			Type:"Text",      Hidden:1,  Width:50,  Align:"Left",    ColMerge:1,   SaveName:"eduSeq",          KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='eduCourseCd' mdef='과정코드'/>",			Type:"Text",      Hidden:1,  Width:50,  Align:"Left",    ColMerge:1,   SaveName:"eduCourseCd",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"이벤트순번",			Type:"Text",      Hidden:1,  Width:0,   Align:"Left",    ColMerge:1,   SaveName:"eduEventSeq",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='eduOrgCdV1' mdef='교육기관코드'/>",		Type:"Text",      Hidden:1,  Width:50,  Align:"Left",    ColMerge:1,   SaveName:"eduOrgCd",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='eduOrgNm' mdef='교육기관'/>",			Type:"Text",      Hidden:1,  Width:50,  Align:"Left",    ColMerge:1,   SaveName:"eduOrgNm",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='dd' mdef='일'/>",				Type:"Float",     Hidden:1,  Width:30,  Align:"Right",   ColMerge:0,   SaveName:"eduDay",          KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:3 },
			{Header:"<sht:txt mid='eduHourV1' mdef='시간'/>",				Type:"Float",     Hidden:1,  Width:30,  Align:"Right",   ColMerge:1,   SaveName:"eduHour",         KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:3 },
			{Header:"<sht:txt mid='laborApplyYnV1' mdef='고용보험적용여부'/>",		Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"laborApplyYn",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='eduBranchCd' mdef='교육구분'/>",			Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"eduBranchCd",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='eduMBranchCdV1' mdef='교육체계'/>",			Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"eduMBranchCd",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='essentialYn' mdef='필수여부'/>",			Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"mandatoryYn",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='inOutTypeV1' mdef='사내외구분'/>",			Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"inOutType",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='applSYmd' mdef='교육신청일'/>",			Type:"Date",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"applSYmd",         KeyField:0,   CalcLogic:"",   Format:"Ymd",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='applEYmd' mdef='교육마감일'/>",			Type:"Date",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"applEYmd",         KeyField:0,   CalcLogic:"",   Format:"Ymd",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='chargeSabunV1' mdef='담당자사번'/>",			Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"chargeSabun",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='chargeNameV1' mdef='담당자성명'/>",			Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"chargeName",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='orgCdV14' mdef='담당자소속'/>",			Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"orgCd",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='orgNmV19' mdef='담당자소속cd'/>",		Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"orgNm",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='telNoV3' mdef='담당자연락처'/>",		Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"telNo",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='lecturerCost' mdef='강사료'/>",				Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"lecturerCost",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='establishmentCost' mdef='시설사용료'/>",			Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"establishmentCost",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='foodCost' mdef='식비'/>",				Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"foodCost",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='transpCost' mdef='기타비용'/>",			Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"transpCost",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='laborApplyYnV1' mdef='고용보험적용여부'/>",		Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"laborApplyYn",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='maxPerson' mdef='수강인원최대'/>",		Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"maxPerson",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='minPerson' mdef='수강인원최소'/>",		Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"minPerson",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='eduBranchNm' mdef='eduBranchNm'/>",		Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"eduBranchNm",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='eduMBranchNm' mdef='eduMBranchNm'/>",		Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"eduMBranchNm",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='eduPlaceV1' mdef='eduPlace'/>",			Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"eduPlace",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='perExpenseMonV1' mdef='perExpenseMon'/>",	Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"perExpenseMon",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='laborMonV1' mdef='laborMon'/>",			Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"laborMon",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='eduSHm' mdef='eduSHm'/>",			Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"eduSHm",         KeyField:0,   CalcLogic:"",   Format:"Hm",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='eduEHm' mdef='eduEHm'/>",			Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"eduEHm",         KeyField:0,   CalcLogic:"",   Format:"Hm",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='currencyCdV1' mdef='currencyCd'/>",		Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"currencyCd",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='realExpenseMon' mdef='realExpenseMon'/>",	Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"realExpenseMon",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='eduRewardCdV1' mdef='eduRewardCd'/>",		Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:0,   SaveName:"eduRewardCd",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='eduRewardCntV1' mdef='eduRewardCnt'/>",		Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:0,   SaveName:"eduRewardCnt",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(0);sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");sheet1.SetImageList(1,"${ctx}/common/images/icon/icon_o.png");sheet1.SetImageList(2,"${ctx}/common/images/icon/icon_x.png");

		sheet1.SetDataLinkMouse("detail", 1);

		sheet1.SetColProperty("eduStatusCd", 	{ComboText:"|"+eduStatusCdList[0], ComboCode:"|"+eduStatusCdList[1]} );

		$(window).smartresize(sheetResize); sheetInit();

		$("#searchEduStatusCd").html(eduStatusCdList[2]);

		$(".close").click(function() {
			p.self.close();
		});

		if( arg != "undefined" ) {
			$("#searchApplSabun").val(arg["searchApplSabun"]);
		}

		//$("#searchEduStatusCd").val("10030");

		doAction1("Search");
	});

	/*Sheet1 Action*/
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 		//조회
			sheet1.DoSearch( "${ctx}/EduInTypePeopleMgr.do?cmd=getEduInTypePeopleMgrPopList", $("#srchFrm").serialize() );
			break;
		}
    }

	// 	조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") alert(Msg);
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value){
		try{
			if( sheet1.ColSaveName(Col) == "detail" ) {
				eduEventMgrPopup(Row) ;
			}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}

	function sheet1_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		var rv = new Array(1);

		rv["eduSeq"			]	=	sheet1.GetCellValue(Row,"eduSeq"		);
		rv["eduCourseCd"	]	=	sheet1.GetCellValue(Row,"eduCourseCd"	);
		rv["eduCourseNm"	]	=	sheet1.GetCellValue(Row,"eduCourseNm"	);
		rv["eduEventSeq"	]	=	sheet1.GetCellValue(Row,"eduEventSeq"	);
		rv["eduEventNm"		]	=	sheet1.GetCellValue(Row,"eduEventNm"	);

		p.popReturnValue(rv);
		p.window.close();
	}

	function doSearchEduCourseNm() {
		if(!isPopup()) {return;}

		gPRow = "";
		pGubun = "searchEduCoursePopup";

		openPopup("/Popup.do?cmd=eduCoursePopup&authPg=R", "", "580","520");
	}

	/**
	 * 상세내역 window open event
	 */
	function eduEventMgrPopup(Row){
		if(!isPopup()) {return;}

		//EduCourseDetail.jsp
		var w 		= 760;
		var h 		= 550;
		var url 	= "${ctx}/EduEventMgr.do?cmd=viewEduEventMgrPopup&authPg=R";
		var args 	= new Array();

		args["eduSeq"] 			= sheet1.GetCellValue(Row, "eduSeq");
		args["eduCourseCd"] 	= sheet1.GetCellValue(Row, "eduCourseCd");
		args["eduCourseNm"] 	= sheet1.GetCellValue(Row, "eduCourseNm");
		args["eduCourseSub"] 	= sheet1.GetCellValue(Row, "eduCourseSub");
		args["eduEventSeq"] 	= sheet1.GetCellValue(Row, "eduEventSeq");
		args["eduEventNm"] 		= sheet1.GetCellValue(Row, "eduEventNm");
		args["eduStatusCd"] 	= sheet1.GetCellValue(Row, "eduStatusCd");
		args["eduOrgCd"] 		= sheet1.GetCellValue(Row, "eduOrgCd");
		args["eduOrgNm"] 		= sheet1.GetCellValue(Row, "eduOrgNm");
		args["eduPlace"] 		= sheet1.GetCellValue(Row, "eduPlace");
		args["eduPlaceEtc"] 	= sheet1.GetCellValue(Row, "eduPlaceEtc");
		args["eduDay"] 			= sheet1.GetCellValue(Row, "eduDay");
		args["eduHour"] 		= sheet1.GetCellValue(Row, "eduHour");
		args["eduSYmd"] 		= sheet1.GetCellText(Row, "eduSYmd");
		args["eduSHm"] 			= sheet1.GetCellText(Row, "eduSHm");
		args["eduEYmd"] 		= sheet1.GetCellText(Row, "eduEYmd");
		args["eduEHm"] 			= sheet1.GetCellText(Row, "eduEHm");
		args["applSYmd"] 		= sheet1.GetCellText(Row, "applSYmd");
		args["applEYmd"] 		= sheet1.GetCellText(Row, "applEYmd");
		args["minPerson"] 		= sheet1.GetCellValue(Row, "minPerson");
		args["maxPerson"] 		= sheet1.GetCellValue(Row, "maxPerson");
		args["lecturerCost"] 	= sheet1.GetCellValue(Row, "lecturerCost");    /*	추가	*/
		args["establishmentCost"]= sheet1.GetCellValue(Row, "establishmentCost");	/*	추가	*/
		args["foodCost"] 		= sheet1.GetCellValue(Row, "foodCost");	/*	추가	*/
		args["transpCost"] 		= sheet1.GetCellValue(Row, "transpCost");	/*	추가	*/
		args["currencyCd"] 		= sheet1.GetCellValue(Row, "currencyCd");
		args["perExpenseMon"] 	= sheet1.GetCellValue(Row, "perExpenseMon");
		args["totExpenseMon"] 	= sheet1.GetCellValue(Row, "totExpenseMon");
		args["laborApplyYn"] 	= sheet1.GetCellValue(Row, "laborApplyYn");
		args["laborMon"] 		= sheet1.GetCellValue(Row, "laborMon");
		args["realExpenseMon"] 	= sheet1.GetCellValue(Row, "realExpenseMon");
		args["innerYn"] 		= sheet1.GetCellValue(Row, "innerYn");
		args["chargeSabun"] 	= sheet1.GetCellValue(Row, "chargeSabun");
		args["chargeName"] 		= sheet1.GetCellValue(Row, "chargeName");
		args["orgCd"] 			= sheet1.GetCellValue(Row, "orgCd");
		args["orgNm"] 			= sheet1.GetCellValue(Row, "orgNm");
		args["telNo"] 			= sheet1.GetCellValue(Row, "telNo");
		args["lecturerNm"] 		= sheet1.GetCellValue(Row, "lecturerNm");
		args["lecturerTelNo"] 	= sheet1.GetCellValue(Row, "lecturerTelNo");
		args["eduRewardCd"] 	= sheet1.GetCellValue(Row, "eduRewardCd");
		args["eduRewardCnt"] 	= sheet1.GetCellValue(Row, "eduRewardCnt");
		args["sStatus"] = sheet1.GetCellValue(Row,"sStatus");

		gPRow = "";
		pGubun = "eduEventMgrPopup";

		openPopup(url,args,w,h);
	}


	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

        if(pGubun == "searchEduCoursePopup"){
	    	$("#searchEduCourseNm").val(rv["eduCourseNm"]);
        }
	}
</script>
</head>
<body class="bodywrap">
	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li><tit:txt mid='eduAppDetPop' mdef='회차별'/></li>
				<li class="close"></li>
			</ul>
		</div>
        <div class="popup_main">
			<form id="srchFrm" name="srchFrm" >
				<input type="hidden" id="searchApplSabun" name="searchApplSabun" value=""/>
				<input type="hidden" id="checkType" name="checkType" value="Y"/>

				<div class="sheet_search outer">
					<div>
						<table>
							<tr>
								<th><tit:txt mid='104168' mdef='과정명'/></th>
								<td>
									<input type="text" id="searchEduCourseNm" name="searchEduCourseNm" class="text w150" />
									<a href="javascript:doSearchEduCourseNm();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
									<a onclick="$('#searchEduCourseNm').val('');return false;" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
								</td>
								<th>회차명 </th>
								<td>
									<input id="searchEduEventNm" name="searchEduEventNm" type="text" class="text w150" />
								</td>
								<th>회차상태 </th>
								<td>
									<select id="searchEduStatusCd" name="searchEduStatusCd"></select>
								</td>
								<td>
									<a href="javascript:doAction1('Search')" id="btnSearch" class="button"><tit:txt mid='104081' mdef='조회'/></a>
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
									<!-- <li id="txt" class="txt"></li> -->
									<li class="btn">
									</li>
								</ul>
							</div>
						</div>
						<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
					</td>
				</tr>
			</table>

			<div class="popup_button outer">
			<ul>
				<li>
					<a href="javascript:p.self.close();" class="gray large"><tit:txt mid='104157' mdef='닫기'/></a>
				</li>
			</ul>
			</div>
		</div>
	</div>
</body>
</html>
