<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<link rel="stylesheet" href="/common/plugin/calendar/css/style.css" />
<script src="${ctx}/common/plugin/calendar/js/custom_calendar.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {

		$("#searchFromYmd").datepicker2({startdate:"searchToYmd"});
		$("#searchToYmd").datepicker2({enddate:"searchFromYmd"});

		var initdata = {};
		initdata.Cfg = {FrozenCol:16,SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No|No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
//			{Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"), Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"선택|선택",			Type:"DummyCheck",	Hidden:0,	Width:55,	Align:"Center",	ColMerge:0,	SaveName:"processYn",	KeyField:0,	Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
			{Header:"세부\n내역|세부\n내역",	Type:"Image",		Hidden:0,	Width:40,   Align:"Center",	ColMerge:0,	SaveName:"detail",		KeyField:0,	Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1 },
			{Header:"신청서코드|신청서코드",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"applCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"신청서순번|신청서순번",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"applSeq",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 },

			{Header:"처리상태|처리상태",	Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"applStatusCd",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:10 },
      		{Header:"처리완료일|처리완료일",	Type:"Date",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:1,	SaveName:"agreeYmd",		KeyField:0,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:10 },
      		{Header:"신청일자|신청일자",	Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"applYmd",			KeyField:0,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			
			{Header:"신청자|소속",	Type:"Text",	Hidden:0,		Width:80,	Align:"Center",	ColMerge:1,	SaveName:"applInOrg",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50  },
			{Header:"신청자|사번",	Type:"Text",	Hidden:0,		Width:80,	Align:"Center",	ColMerge:1,	SaveName:"applInSabun",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 },
			{Header:"신청자|성명",	Type:"Text",	Hidden:0,		Width:80,	Align:"Center",	ColMerge:1,	SaveName:"applInName",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 },
			{Header:"신청자|직위",	Type:"Text",	Hidden:0, 		Width:80,	Align:"Center",	ColMerge:1,	SaveName:"applInJikweeNm",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 },
			//{Header:"신청자|호칭",	Type:"Text",	Hidden:Number("${aliasHdn}"),	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"applInAlias",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 },
			//{Header:"신청자|직책",	Type:"Text",	Hidden:0,						Width:80,	Align:"Center",	ColMerge:1,	SaveName:"applInJikchakNm",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 },
			//{Header:"신청자|직급",	Type:"Text",	Hidden:Number("${jgHdn}"), 		Width:80,	Align:"Center",	ColMerge:1,	SaveName:"applInJikgubNm",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 },
			//{Header:"신청자|직위",	Type:"Text",	Hidden:Number("${jwHdn}"), 		Width:80,	Align:"Center",	ColMerge:1,	SaveName:"applInJikweeNm",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 },
			{Header:"신청자|호칭",	Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"applInAlias",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 },
			{Header:"신청자|직책",	Type:"Text",	Hidden:1,						Width:80,	Align:"Center",	ColMerge:1,	SaveName:"applInJikchakNm",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 },
			{Header:"신청자|직급",	Type:"Text",	Hidden:1, 		Width:80,	Align:"Center",	ColMerge:1,	SaveName:"applInJikgubNm",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 },

			//{Header:"업무차량|차량번호",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"carNo",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:20 },
      		{Header:"업무차량\n(차량번호)|업무차량\n(차량번호)",		Type:"Combo",	Hidden:0,	Width:120,	Align:"Center",	ColMerge:1,	SaveName:"carNo",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"예약일시|시작",	Type:"Date",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:1,	SaveName:"fromYmd",		KeyField:0,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"예약일시|시작",	Type:"Date",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"fromTime",	KeyField:0,	CalcLogic:"",	Format:"Hm",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:5 },
			{Header:"예약일시|종료",	Type:"Date",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:1,	SaveName:"toYmd",		KeyField:0,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"예약일시|종료",	Type:"Date",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"toTime",		KeyField:0,	CalcLogic:"",	Format:"Hm",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:5 },

      		{Header:"대상자|사번",	Type:"Text",	Hidden:1,	Width:80,	Align:"Center", ColMerge:1,  SaveName:"applSabun",         KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
      		{Header:"대상자|성명",	Type:"Text",	Hidden:1,	Width:80,	Align:"Center", ColMerge:1,  SaveName:"applName",          KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
      		{Header:"대상자|호칭",	Type:"Text",	Hidden:1,	Width:80,	Align:"Center", ColMerge:1,  SaveName:"applAlias",         KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
      		{Header:"대상자|소속",	Type:"Text",	Hidden:1,	Width:80,	Align:"Center", ColMerge:1,  SaveName:"applOrg",           KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
      		{Header:"대상자|직책",	Type:"Text",	Hidden:1,	Width:80,	Align:"Center", ColMerge:1,  SaveName:"applJikchakNm",      KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
      		{Header:"대상자|직위",	Type:"Text",	Hidden:1,	Width:80,	Align:"Center", ColMerge:1,  SaveName:"applJikweeNm",      KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
      		{Header:"대상자|직급",	Type:"Text",	Hidden:1,	Width:80,	Align:"Center", ColMerge:1,  SaveName:"applJikgubNm",      KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
      		{Header:"대상자|직구분",	Type:"Text",	Hidden:1,	Width:80,	Align:"Center", ColMerge:1,  SaveName:"applJobJikgunNm",   KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
		];
		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		sheet1.SetMergeSheet( msHeaderOnly );
		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
 		sheet1.SetDataLinkMouse("detail", 1);

		// 처리상태
 		var applStatusCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R10010"), "");
		sheet1.SetColProperty("applStatusCd", {ComboText:"|"+applStatusCd[0], ComboCode:"|"+applStatusCd[1]} );

		// 조회조건
		//사업장
		var businessPlaceCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getBusinessPlaceCdList",false).codeList, "");	//소속구분항목(급여사업장)
		$("#searchBusinessPlaceCd").html(businessPlaceCd[2]);
		$("#searchBusinessPlaceCd").select2({
			placeholder: "전체"
			, maximumSelectionSize:100
		});

		//근무지
		var locationCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getLocationCdList",false).codeList, "");	//Location코드
		$("#searchLocationCd").html(locationCd[2]);
		$("#searchLocationCd").select2({
			placeholder: "<tit:txt mid='2017040700020' mdef='전체'/>"
			, maximumSelectionSize:100
		});

		//직원구분
		var empGubun = [{"code": "1", "codeNm": "일반직"}, {"code": "2", "codeNm": "생산직"}];
 		empGubun = convCode(empGubun, "전체");

		$("#searchEmpGubun").html(empGubun[2]);

		$("#searchEmpGubun").bind("change", function(e) {
			doAction1("Search");
		});
		// 처리상태
        var searchStatusCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAprStatusList",false).codeList, "전체");
		$("#searchApplStatusCd").html(searchStatusCd[2]);

		// 업무차량명
		var carNm = convCode( ajaxCall("${ctx}/CarAllocateApp.do?cmd=getCarAllocateCdList", "useYn=Y", false).DATA, "전체");
		sheet1.SetColProperty("carNo",	{ComboText:"|"+carNm[0], ComboCode:"|"+carNm[1]} );

		$("#searchOrgNm, #searchSabunName, #searchFromYmd, #searchToYmd, #searchCarNo, #searchCarNm").bind("keyup", function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		$("#searchApplStatusCd").bind("change", function(e) {
			doAction1("Search");
		});

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");

		var carAllocateCd = convCode( ajaxCall("${ctx}/CarAllocateApp.do?cmd=getCarAllocateCdList", "useYn=Y", false).DATA, "전체");

		drawCalendar({
			selectorId : "calendar_pop",
			useSelect : true,
			selectHtml : carAllocateCd[2],
			selMonScheDataUrl:"/CarAllocateApp.do?cmd=getCarAllocateSchedule",
			selDayScheDataUrl:"/CarAllocateApp.do?cmd=getCarAllocateScheduleDetail",
			scheduleDetailData : { tmp1:"차량번호", tmp2:"차량명", tmp3:"신청자", tmp4:"배차시간", tmp5:"신청상태" },
			setCalHeightFn : function() {
				setCalendarHeight();
			},
			scheItemClass : { "1" : "car_allocate" }
		});
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			$("#businessPlaceCd").val(($("#searchBusinessPlaceCd").val()==null?"":getMultiSelect($("#searchBusinessPlaceCd").val())));
			$("#locationCd").val(($("#searchLocationCd").val()==null?"":getMultiSelect($("#searchLocationCd").val())));
			sheet1.DoSearch( "${ctx}/CarAllocateApr.do?cmd=getCarAllocateAprList", $("#sheetForm").serialize() ); break;
		case "Save":
		    if(!dupChk(sheet1,"sabun|applSeq", true, true)){break;}
			IBS_SaveName(document.sheetForm,sheet1);
			sheet1.DoSave( "${ctx}/CarAllocateApr.do?cmd=saveCarAllocateApr", $("#sheetForm").serialize()); break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			var d = new Date();
			var fName = "excel_" + d.getTime() + ".xlsx";
			sheet1.Down2Excel($.extend(param, { FileName:fName, SheetDesign:1, Merge:1 })); break;
		case "Apr":
		    var mdfStts = sheet1.FindStatusRow("U|D|I");
		    if(mdfStts != ""){
		        alert("저장하지 않은 데이터가 존재합니다. \n저장을 하신 후 승인처리 바랍니다.");
		        return;
		    }

		    var lchkCnt =  0;
		    for(var r = sheet1.HeaderRows() ; r < sheet1.RowCount()+sheet1.HeaderRows() ; r++){
		        if(sheet1.GetCellValue (r, "processYn") == "1"){
		            lchkCnt++;
		            sheet1.SetCellValue(r,"applStatusCd","99");//승인
		            sheet1.SetCellValue(r,"agreeYmd","${curSysYyyyMMdd}");//처리완료일
		        }
            }

		    if(lchkCnt == 0){
		        alert("승인 처리 할 데이터를 선택 해 주세요!");
		        return;
		    }

		    if(!confirm("승인 처리 하시겠습니까?")) {
                return;
            }

		    if(sheet1.FindStatusRow("I|U") != ""){
			    if(!dupChk(sheet1,"sabun|applSeq", true, true)){break;}
			}

			IBS_SaveName(document.sheetForm,sheet1);
			//2024.02.01
			//sheet1.DoSave( "${ctx}/SaveData.do?cmd=updateApprovalStatus", $("#sheetForm").serialize(), -1, 0); break;
			break;
		case "Rej":
		    var mdfStts = sheet1.FindStatusRow("U|D|I");
		    if(mdfStts != ""){
		        alert("저장하지 않은 데이터가 존재합니다. \n저장을 하신 후 반려처리 바랍니다.");
		        return;
		    }

		    var lchkCnt =  0;
		    for(var r = sheet1.HeaderRows() ; r < sheet1.RowCount()+sheet1.HeaderRows() ; r++){
		        if(sheet1.GetCellValue (r, "processYn") == "1"){
		            lchkCnt++;
		            sheet1.SetCellValue(r,"applStatusCd","23");//반려
		            sheet1.SetCellValue(r,"agreeYmd","${curSysYyyyMMdd}");//처리완료일
		        }
            }

		    if(lchkCnt == 0){
		        alert("반려 처리 할 데이터를 선택 해 주세요!");
		        return;
		    }

		    if(!confirm("반려 처리 하시겠습니까?")) {
                return;
            }

		    if(sheet1.FindStatusRow("I|U") != ""){
			    if(!dupChk(sheet1,"sabun|applSeq", true, true)){break;}
			}

			IBS_SaveName(document.sheetForm,sheet1);
			//2024.02.01
			//sheet1.DoSave( "${ctx}/SaveData.do?cmd=updateApprovalStatus", $("#sheetForm").serialize(), -1, 0); break;
			break;
		}
	}
	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {

			if (Msg != "") {
				alert(Msg);
				return;
			}

			var firstRow = sheet1.GetDataFirstRow();
			var lastRow	 = sheet1.GetDataLastRow();
			for (i=firstRow; i<=lastRow;i++) {
				var applStatusCd = sheet1.GetCellValue(i,"applStatusCd");
				if ((applStatusCd == 99) || (applStatusCd == 23)) {// 처리완료, 결재반려 일 때
					sheet1.SetRowEditable(i, 0);
				}
			}
			// 달력 다시 그리기
			//setCalendarDay();
			sheetResize();

		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } doAction1("Search"); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
		    if( sheet1.ColSaveName(Col) == "detail" ) {
		    	var searchSabun = sheet1.GetCellValue(Row,"applSabun");
	    		var applSeq = sheet1.GetCellValue(Row,"applSeq");
	    		var applSabun = sheet1.GetCellValue(Row,"applInSabun");
	    		var applYmd = sheet1.GetCellValue(Row,"applYmd");

	    		showApplPopup("R",applSeq,searchSabun,applSabun,applYmd, Row);
		    }
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}

	// 시트 셀 변경시 발생
	function sheet1_OnChange(Row, Col, Value, OldValue) {
		try {
			if( sheet1.ColSaveName(Col) == "carNm") {
				sheet1.SetCellValue(Row, "carNo", Value);
			}
		} catch (ex) {
			alert("OnChange Event Error : " + ex);
		}
	}

	//신청 팝업
	function showApplPopup(auth,seq,sabun,applSabun,applYmd, Row) {
		if(!isPopup()) {return;}

		if(auth == "") {
			alert("권한을 입력하여 주십시오.");
			return;
		}
		const p = {
				searchApplCd: '291',
				searchApplSeq: seq,
				adminYn: 'N',
				authPg: auth,
				searchSabun: applSabun,
				searchApplSabun: sabun,
				searchApplYmd: applYmd
			};

		var url ="/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
		//var initFunc = 'initResultLayer'
		var args = new Array(5);
		if(Row != ""){
			args["applStatusCd"] = sheet1.GetCellValue(Row, "applStatusCd");
		}else{
			args["applStatusCd"] = "11";
		}

		gPRow = "";
		pGubun = "viewApprovalMgrResult";
		var approvalMgrLayer = new window.top.document.LayerModal({
			id: 'approvalMgrLayer',
			url: url,
			parameters: p,
			width: 800,
			height: 815,
			title: '업무차량배치신청',
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

        if(pGubun == "viewApprovalMgrResult"){
        	doAction1("Search");
        }
	}

	// 달력 높이 설정 함수
	function setCalendarHeight() {
		var sel = $("#calendar_pop");
		var calHeight = sel.closest(".wrapper").height();
		sel.closest(".wrapper").children().each(function(idx, obj) {
			if(!$(this).is("table.sheet_main")) {
				calHeight -= $(this).outerHeight(true);
			}
		});
		calHeight -= sel.parent().find("div.outer").outerHeight(true);
		sel.css("height", calHeight-40);
		sel.find("li.schedule").css("height", calHeight - sel.find("li.calendar").height() - 110);
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
		<!-- 조회조건 -->
		<input type="hidden" id="searchOrgCd" name="searchOrgCd" value=""/>
		<input type="hidden" id="searchSabun" name="searchSabun" value=""/>

		<!-- 조회조건 -->
		<div class="sheet_search sheet_search_s outer">
			<div>
				<table>
					<tr>
						<th>사업장</th>
						<td>
							<select id="searchBusinessPlaceCd" name="searchBusinessPlaceCd" multiple></select>
							<input type="hidden" id="businessPlaceCd" name="businessPlaceCd" value=""/>
						</td>
						<th class="hide">근무지</th>
						<td class="hide">
							<select id="searchLocationCd" name="searchLocationCd" multiple></select>
							<input type="hidden" id="locationCd" name="locationCd" value=""/>
						</td>
						<th class="hide">직원구분 </th>
						<td class="hide">
							<select id="searchEmpGubun" name="searchEmpGubun" class="box2"></select>
						</td>
						<th>소속 </th>
						<td>
							<input id="searchOrgNm" name="searchOrgNm" type="text" class="text" style="ime-mode:active;"/>
						</td>
						<th>성명/사번</th>
						<td>
							<input id="searchSabunName" name="searchSabunName" type="text" class="text" style="ime-mode:active;"/>
						</td>
						<th>처리상태</th>
						<td>
							<select id="searchApplStatusCd" name="searchApplStatusCd" onChange="javascript:doAction1('Search')" class="box"></select>
						</td>
					</tr>
					<tr>
						<th>신청일자</th>
						<td colspan="2">
							<input type="text" id="searchFromYmd" name="searchFromYmd" class="date2 required" value="<%=DateUtil.getCurrentTime("yyyy-MM")%>-01">&nbsp;~&nbsp;
							<input type="text" id="searchToYmd" name="searchToYmd" class="date2" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>">
						</td>
						<th>차량번호</th>
						<td>
							<input id="searchCarNo" name="searchCarNo" type="text" class="text" style="ime-mode:active;"/>
						</td>
						<th>차량명</th>
						<td>
							<input id="searchCarNm" name="searchCarNm" type="text" class="text" style="ime-mode:active;"/>
						</td>
						<td>
							<a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a>
						</td>

					</tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td style="width:361px;" id="calTd">
				<div class="outer">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">
								업무차량 배차신청 현황
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
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">업무차량 배차승인</li>
							<li class="btn">
								<a href="javascript:doAction1('Apr')" class="button authA">일괄승인</a>
								<a href="javascript:doAction1('Rej')" class="button authA">일괄반려</a>
								<a href="javascript:doAction1('Save')" class="basic authA">저장</a>
								<a href="javascript:doAction1('Down2Excel')" class="basic authR">다운로드</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>