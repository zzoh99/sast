<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>

<link rel="stylesheet" href="/common/plugin/calendar/css/style.css" />
<script src="${ctx}/common/plugin/calendar/js/custom_calendar.js" type="text/javascript" charset="utf-8"></script>

<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
   			{Header:"No|No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:1,	SaveName:"sNo" },
//   			{Header:"삭제|삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:1,	SaveName:"sDelete",	Sort:0 },
//   			{Header:"상태|상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:1,	SaveName:"sStatus",	Sort:0 },

   	        {Header:"삭제|삭제",				Type:"${sDelTy}",	Hidden:Number("0"),	Width:"${sDelWdt}",	Align:"Center",	ColMerge:1,	SaveName:"sDelete", Sort:0 },
   	        {Header:"상태|상태",				Type:"${sSttTy}",	Hidden:Number("0"),	Width:"${sSttWdt}",	Align:"Center",	ColMerge:1,	SaveName:"sStatus", Sort:0 },
   	        {Header:"세부\n내역|세부\n내역",		Type:"Image",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"detail",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
   	        {Header:"신청일자|신청일자",			Type:"Date",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"applYmd",		KeyField:0,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
   	        {Header:"회의실|회의실",				Type:"Text",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:1,	SaveName:"meetRoomNm",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   	        {Header:"예약일시|시작",				Type:"Text",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:1,	SaveName:"fromFullTime",KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:16 },
   	        {Header:"예약일시|종료",				Type:"Text",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:1,	SaveName:"toFullTime",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:16 },
   	        {Header:"처리상태|처리상태",			Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"applStatusCd",KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
   	        {Header:"처리완료일|처리완료일",			Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"agreeYmd",	KeyField:0,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
   	        {Header:"신청자|사번",				Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applInSabun",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 },
			{Header:"대상자|사번",				Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"sabun",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 },
   	        {Header:"신청서순번|신청서순번",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"applSeq",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 }
		];
 		IBS_InitSheet(sheet1, initdata);
 		sheet1.SetEditable(true);
 		sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		sheet1.SetEditableColorDiff(0); //기본색상 출력
		
 		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
 		sheet1.SetDataLinkMouse("detail", 1);
 		sheet1.SetMergeSheet( msHeaderOnly);

 		//  처리상태
 		var applStatusCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R10010"), "");
		sheet1.SetColProperty("applStatusCd", {ComboText:"|"+applStatusCd[0], ComboCode:"|"+applStatusCd[1]} );

		$(window).smartresize(sheetResize); sheetInit();
		setEmpPage();

		var meetRoomCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getMeetRoomCdList&useYn=Y", false).codeList, "전체");
	
		// 달력 생성 및 그려주는 함수.
		drawCalendar({
			selectorId : "calendar_pop",
			useSelect : true,
			selectHtml : meetRoomCd[2],
			selMonScheDataUrl: "/MeetRoomApp.do?cmd=getMeetRoomSchedule",
			selDayScheDataUrl: "/MeetRoomApp.do?cmd=getMeetRoomScheduleDetail",
			scheduleDetailData : { tmp1:"회의실명", tmp2:"신청자", tmp3:"예약일시", tmp4:"신청상태" },
			setCalHeightFn : function() {
				setCalendarHeight();
			},
			scheItemClass : { "1" : "meet_room" }
		});
		
		// height 주석처리
		//$(".sheet_main").css("height", $(".wrapper").height() - $(".wrapper").find("table.default.outer").outerHeight(true));
		$(window).resize(function() {
			//$(".sheet_main").css("height", $(".wrapper").height() - $(".wrapper").find("table.default.outer").outerHeight(true));
		});
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			// 조회 대상 사원 번호 셋팅
			sheet1.DoSearch( "${ctx}/MeetRoomApp.do?cmd=getMeetRoomAppList", $("#sheet1Form").serialize() ); break;
        case "Save":        // 중복체크
       		// 해당 화면에는 저장기능 없이 삭제 기능만 존재 한다.
       		// 신규행 입력 및 저장읜 팝업을 통하여 이루어진다.
       		IBS_SaveName(document.sheet1Form,sheet1);
        	sheet1.DoSave( "${ctx}/MeetRoomApp.do?cmd=deleteMeetRoomApp", $("#sheet1Form").serialize()); break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			var d = new Date();
			var fName = "excel_" + d.getTime() + ".xlsx";
			sheet1.Down2Excel($.extend(param, { FileName:fName, SheetDesign:1, Merge:1 }));
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		
		try {
			if (Msg != "") {
				alert(Msg);
			}

			for (var i = sheet1.HeaderRows() ; i < sheet1.HeaderRows() + sheet1.RowCount() ; i++) {
				if (sheet1.GetCellValue(i,"applStatusCd") == "11" || sheet1.GetCellValue(i,"applStatusCd") == "23" || sheet1.GetCellValue(i,"applStatusCd") == "33") {
					sheet1.SetRowEditable(i,1);
				} else {
					sheet1.SetRowEditable(i,0);
				}
			}
			// 달력 다시 그려주기.
			//setCalendarDay();
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } doAction1("Search"); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

    function setEmpPage() {
    	$("#searchApplSabun").val($("#searchUserId").val());
    	doAction1("Search");
    }


	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
		    if( sheet1.ColSaveName(Col) == "detail" ) {

		    	var auth = "R";
		    	if(sheet1.GetCellValue(Row, "applStatusCd") == "11") {
		    		//신청 팝업
		    		auth = "A";
		    	} else {
		    		//결재팝업
		    		auth = "R";
		    	}

	    		showApplPopup(auth,sheet1.GetCellValue(Row,"applSeq"),sheet1.GetCellValue(Row,"applInSabun"),sheet1.GetCellValue(Row,"applYmd"), Row);

		    }
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}

	function sheet1_OnBeforeCheck(Row, Col) {
		try{
			sheet1.SetAllowCheck(true);
			if(sheet1.ColSaveName(Col) == "sDelete") {
				if(sheet1.GetCellValue(Row, "applStatusCd") != "11" && sheet1.GetCellValue(Row, "applStatusCd") != "23" && sheet1.GetCellValue(Row, "applStatusCd") != "33") {
					alert("임시저장 또는 반려일 경우만 삭제할 수 있습니다.");
					sheet1.SetAllowCheck(false);
					return;
				}
			}
		}catch(ex){
			alert("OnBeforeCheck Event Error : " + ex);
		}
	}


	//신청 팝업
	function showApplPopup(auth,seq,searchSabun,applYmd, Row) {
		if(!isPopup()) {return;}

		if(auth == "") {
			alert("<msg:txt mid='110262' mdef='권한을 입력하여 주십시오.'/>");
			return;
		}
		
		var p = {
				searchApplCd: '290'
			  , searchApplSeq: seq
			  , adminYn: 'N'
			  , authPg: auth
			  , searchSabun: searchSabun
			  , searchApplSabun: $('#searchUserId').val()
			  , searchApplYmd: applYmd 
		}
		var url = "";
		var initFunc = '';
		if(auth == "A") {
			url     = "/ApprovalMgr.do?cmd=viewApprovalMgrLayer";
			initFunc = 'initLayer';
		} else {
			url ="/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
			initFunc = 'initResultLayer';
		}

		var args = new Array(5);
		if(Row != ""){
			args["applStatusCd"] = sheet1.GetCellValue(Row, "applStatusCd");
		}else{
			args["applStatusCd"] = "11";
		}

		gPRow = "";
		pGubun = "viewApprovalMgr";
		var approvalMgrLayer = new window.top.document.LayerModal({
			id: 'approvalMgrLayer',
			url: url,
			parameters: p,
			width: 800,
			height: 815,
			title: '회의실예약',
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
	function getReturnValue(rv) {
		//var rv = $.parseJSON('{' + returnValue+ '}');

        if(pGubun == "viewApprovalMgr"){
        	doAction1("Search");
        }
	}

	function setBtnFold() {
		$("#calTd").toggle("fold");
		sheetResize();
	}

	// 달력 높이 지정 함수
	function setCalendarHeight() {
		var sel = $("#calendar_pop");
		var calHeight = sel.closest(".wrapper").height();
		sel.closest(".wrapper").children().each(function(idx, obj) {
			if(!$(this).is("table.sheet_main") && $(this).prop("tagName") != "SCRIPT") {
				//console.log($(this).prop("tagName"));
				calHeight -= $(this).outerHeight(true);
			}
		});
		calHeight -= sel.parent().find("div.outer").outerHeight(true);
		sel.css("height", calHeight-37);
		sel.find("li.schedule").css("height", calHeight - sel.find("li.calendar").height() - 110);
	}

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<!-- include 기본정보 page TODO -->
	<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>

	<form id="sheet1Form" name="sheet1Form" >
		<input type="hidden" id="searchApplSabun" name="searchApplSabun" value=""/>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td style="width:360px;" id="calTd" class="valignT">
				<div class="outer">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">
								회의실 신청 현황
							</li>
						</ul>
					</div>
				</div>
				<!-- 달력 시작 -->
				<div class="calendar_pop" id="calendar_pop">
				</div>
				<!-- 달력 종료 -->
			</td>
			<td>
				<div class="outer">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">
								회의실신청
							</li>
							<li class="btn">
								<btn:a href="javascript:showApplPopup('A','','${ssnSabun}','${curSysYyyyMMdd}');" css="button authR" mid='applButton' mdef="신청"/>
								<btn:a href="javascript:doAction1('Search')" 	css="basic authA" mid='search' mdef="조회"/>
								<btn:a href="javascript:doAction1('Save')" 	css="basic authA" mid='save' mdef="저장"/>
								<btn:a href="javascript:doAction1('Down2Excel')" 	css="basic authR" mid='down2excel' mdef="다운로드"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>