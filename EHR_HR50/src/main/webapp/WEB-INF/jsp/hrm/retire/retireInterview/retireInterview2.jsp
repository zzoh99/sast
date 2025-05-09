<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='112155' mdef='가발령관리'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";
	var chkSabun = ""; //1 == conv1에만 해당하는사람 / 2 == conv2에 해당하는사람 / 3 == ssnAdminYn인사람
	
	//신청서 상태
	var applStatusCd;
	
	$(function() {
		applStatusCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getApplStatusCdList&applStatusNotCd=11,"), "전체");
		$("#applStatusCd").html(applStatusCd[2]);
		//$("#applStatusCd").val("31");
		$("#applStatusCd").val("");
		
		$("#searchFrom").datepicker2({startdate:"searchTo"});
		$("#searchTo").datepicker2({enddate:"searchFrom"});
		$("#searchFrom").val(addDate("m", -1, "${curSysYyyyMMdd}", "-"));
		$("#searchTo").val(addDate("m", 1, "${curSysYyyyMMdd}", "-"));
		$("#ccrYmd").datepicker2();
		
		
		$("#insInsertBtn").show();
		$("#insSaveBtn").show();
		

        $("#searchFrom,#searchTo,#searchSabunName,#searchOrgNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
        init_sheet();
        
        doAction1("Search");
	});
	

	function init_sheet() {

		//면담차수 및 상태
		var retInterviewCd = stfConvCode( codeList("/CommonCode.do?cmd=getCommonCodeList","H90922"), "전체");

		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },			
			{Header:"세부\n내역",		Type:"Image",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"ibsImage",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"소속",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"성명",			Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },			
			{Header:"직책",			Type:"Text",		Hidden:0,	MinWidth:60,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직위",			Type:"Text",		Hidden:Number("${jwHdn}"),	MinWidth:60,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직급",			Type:"Text",		Hidden:Number("${jgHdn}"),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"퇴직\n희망일",	Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"retSchYmd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
//			{Header:"퇴직\n설문",		Type:"Image",		Hidden:Number("${retSurveyHdn}"),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"surveyImage",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"결재상태",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applStatusCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			
			//hiddenFilde
			{Header:"사번",			Type:"Text",		Hidden:1,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"면담자사번_1차",	Type:"Text",		Hidden:1,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"convSabun1Yn",KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"면담자사번_2차",	Type:"Text",		Hidden:1,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"convSabun2Yn",KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"2차면담여부",		Type:"Text",		Hidden:1,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"retInterview2Yn",KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"3차면담여부",		Type:"Text",		Hidden:1,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"retInterview3Yn",KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"신청일",			Type:"Date",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"대상자사번",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applSabun",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"신청순번",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applSeq",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"신청자사번",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applInSabun",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(true);sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		var initdata1 = {};
		initdata1.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",			Type:"${sDelTy}",	Hidden:0,	Width:45,	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"상태",			Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"면담자",			Type:"Text",		Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"adviserName",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },			
			{Header:"면담일",			Type:"Date",		Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"ccrYmd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:"차수",			Type:"Combo",		Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"retInterviewSeq",KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			
			//hiddenFilde
			{Header:"신청순번",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applSeq",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"사번",			Type:"Text",		Hidden:1,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"면담자(사번)",	Type:"Text",		Hidden:1,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"adviser",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"구분",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"ccrCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"일련번호",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"seq",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"면담내용",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"memo",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000 }
		]; IBS_InitSheet(sheet2, initdata1);sheet2.SetEditable(true);sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		sheet1.SetDataLinkMouse("ibsImage", 1);
		sheet1.SetDataLinkMouse("surveyImage", 1);
 		sheet1.SetDataLinkMouse("processNo", 1);

 		sheet1.SetImageList(0,"/common/images/icon/icon_popup.png");
 		
 		sheet1.SetColProperty("applStatusCd", 			{ComboText:applStatusCd[0], ComboCode:applStatusCd[1]} );

 		sheet2.SetColProperty("retInterviewSeq", 		{ComboText:retInterviewCd[0], ComboCode:retInterviewCd[1]} );		
		
		$("#retInterviewSeq").html(retInterviewCd[2]);
		
		$(window).smartresize(sheetResize); sheetInit();
		
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if($("#searchFrom").val() == "") {
				alert("시작일자를 입력하여 주십시오.");
				$("#searchFrom").focus();
				return;
			}
			if($("#searchTo").val() == "") {
				alert("종료일자를 입력하여 주십시오.");
				$("#searchTo").focus();
				return;
			}
			clearAllData();
			sheet1.DoSearch("${ctx}/RetireInterview.do?cmd=getRetireInterviewList", $("#sheet1Form").serialize());
			break;
		}
	}

	//--------------------------------------------------------------------------------
	//  저장 시 필수 입력 및 조건 체크
	//--------------------------------------------------------------------------------
	function checkList() {
		var ch = true;

		// 화면의 개별 입력 부분 필수값 체크
		$(".required").each(function(index){
			if($(this).val() == null || $(this).val() == ""){
				var txt = $(this).parent().prev().text();
				if(txt == "" ){
					txt = $(this).parent().prev().prev().text();
				}
				alert(txt+"은(는) 필수값입니다."); 
				$(this).focus();
				ch =  false;
				return false;
			}

			return ch;
		});

		return ch;
	}


	//Detail Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":			
			var row = sheet1.GetSelectRow();
			var sabun = sheet1.GetCellValue(row,"sabun"); 
			sheet2.DoSearch( "${ctx}/RetireInterview.do?cmd=getRetireRecodeList&sabun="+sabun, $("#detailForm").serialize());
			break;
		case "New": //새로입력
			//3차 입력시 2차 입력없이 할것인지 묻기
			if(sheet1.GetCellValue(row,"retInterview2Yn") == "N") {
				if(!confirm("2차퇴직면담이 작성되어있지 않습니다.\n3차퇴직면담을 입력 하시겠습니까?")) {
					return;
				}	
			}
			
			pGubun = "New";
			//입력값 초기화
			
			var Row = sheet2.DataInsert(0);
			//sheet2.SetCellValue(Row, "ccrYmd", "${curSysYyyyMMdd}");
			sheet2.SetCellValue(Row, "ccrCd", "90");
			sheet2.SetCellValue(Row, "retInterviewSeq", "3");
			sheet2.SelectCell(Row, "adviserName");
			sheet2.SetCellValue(Row, "applSeq", $("#schApplSeq").val() );
			
			$("#ccrYmd").val(addDate("m", 0, "${curSysYyyyMMdd}", "-"));
			$("#retInterviewSeq").val("3");
			$("#memo").val("");
			setTableData("2");
			
			break;
		case "Save":			
			if(!checkList()) return;
			
			setFormToSheet();
			
			IBS_SaveName(document.detailForm,sheet2);
			sheet2.DoSave( "${ctx}/RetireInterview.do?cmd=saveRetireInterview", $("#detailForm").serialize());			

			break;
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

	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			if( Row < sheet1.HeaderRows() ) return;
			
		    if( sheet1.ColSaveName(Col) == "ibsImage" && Row >= sheet1.HeaderRows() ) {

	    		showApplPopup("R",sheet1.GetCellValue(Row,"applSeq"),sheet1.GetCellValue(Row,"applSabun"),sheet1.GetCellValue(Row,"applInSabun"),sheet1.GetCellValue(Row,"applYmd"));
	            
		    } else if( sheet1.ColSaveName(Col) == "surveyImage" && Row >= sheet1.HeaderRows()) {
		    	//설문지
		    	if(!isPopup()) {return;}
		    	
		    	var url    = "${ctx}/RetireAppDet.do?cmd=viewRetireSurveyPopup&authPg=R";
		        var args    = new Array();
		        
				var	sabun 	= sheet1.GetCellValue(Row,"sabun");
				var	reqDate = sheet1.GetCellValue(Row,"applYmd");
				var	applSeq = sheet1.GetCellValue(Row,"applSeq");

		        args["sabun"]    = sabun;
		        args["reqDate"]  = reqDate;
		        args["applSeq"]  = applSeq;
				
		        openPopup(url, args, "820","700");

		    }
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}
	
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		$(".detilaDiv").show();
		
		if("${ssnAdminYn}" == "Y") {
			chkSabun = "3";				
		}
		if(chkSabun == "3") {
			$("#saveArea").show();
			
			$("#insInsertBtn").show();
			$("#insSaveBtn").show();
			
			//3차 상담 내역이 있을경우 입력버튼 비활성화
			
			/*
			if(sheet1.GetCellValue(NewRow,"retInterview3Yn") == "N") {
				$("#insInsertBtn").show();
				$("#insSaveBtn").show();
			} else {
				$("#insInsertBtn").hide();
				$("#insSaveBtn").show();
			}
			*/
		} else {
			//1차 상담자일경우 입력/저장불가
			$("#saveArea").hide();
		}
		var statusCd = sheet1.GetCellValue(NewRow,"applStatusCd");
		//statusCd ="99";
		if(statusCd == "99"){
			$("#saveArea").hide();
			$("#insInsertBtn").hide();
			$("#insSaveBtn").hide();	
		}
		
		
		//저장시 비교될 차수의 값
		$("#interviewSeq").val(sheet1.GetCellValue(NewRow,"retInterviewSeq"));
		$("#schApplSeq").val(sheet1.GetCellValue(NewRow,"applSeq"));
		doAction2("Search");
	}
	
	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
			
			var applStatusCd = sheet1.GetCellValue(sheet1.GetSelectRow(),"applStatusCd");
			
			if(sheet2.RowCount() > 0) {
				//자신이 등록한 것만 수정, 삭제 가능
				for(var r = sheet2.HeaderRows(); r<sheet2.RowCount()+sheet2.HeaderRows(); r++){
					if(sheet2.GetCellValue(r,"adviser") != ${ssnSabun}){
						sheet2.SetRowEditable(r, 0);
					}
					if(applStatusCd =="99"){
						sheet2.SetRowEditable(r, 0);
					}
					
				}			
			}

		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	
	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			if(Code > 0) doAction1("Search");
			
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	
	function sheet2_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		if(sheet2.RowCount() > 0) {
			if(OldRow != NewRow) {
				if(sheet2.GetCellValue(NewRow,"sStatus") != "I") {
					
					pGubun = "Old";
					
					//자신이 등록한 것만 수정, 삭제 가능
					if(sheet2.GetCellValue(NewRow,"adviser") != ${ssnSabun}){
						setTableData("1");
					} else {
						setTableData("3");
					}					
					
				}
			}
		}
	}
	
	//신청 팝업
	function showApplPopup(auth,seq,applSabun,applInSabun,applYmd) {
		if(!isPopup()) {return;}

		if(auth == "") {
			alert("권한을 입력하여 주십시오.");
			return;
		}

		pGubun = "approvalMgr";
		var p = {
				searchApplCd: '99'
			  , searchApplSeq: seq
			  , adminYn: 'N'
			  , authPg: auth
			  , searchSabun: applInSabun
			  , searchApplSabun: applSabun
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
		var approvalMgrLayer = new window.top.document.LayerModal({
			id: 'approvalMgrLayer',
			url: url,
			parameters: p,
			width: 1100,
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
        if(pGubun == "orgBasicPopup") {
        	$("#orgCd").val(rv["orgCd"]);
        	$("#orgNm").val(rv["orgNm"]);
		}
	}
	
	// 조직 팝업
	function showOrgPopup() {
		if(!isPopup()) {return;}

		pGubun = "orgBasicPopup";
        openPopup("/Popup.do?cmd=orgBasicPopup&authPg=R", "", "740","520");
	}
	
	// 초기화
	function clearCode() {
		$('#orgNm').val("");
		$('#orgCd').val("");
	}
	
	//테이블 영역에 데이터 셋팅
	function setTableData(type) {
		if(type == "1") {
			//읽기전용
			var row = sheet2.GetSelectRow();
			
			//차수,일자,내용,SEQ
			var retInterviewSeq = sheet2.GetCellValue(row,"retInterviewSeq");
			var ccrYmd 			= sheet2.GetCellValue(row,"ccrYmd");
			var seq 			= sheet2.GetCellValue(row,"seq");
			var memo 			= sheet2.GetCellValue(row,"memo");
			$("#retInterviewSeq").val(retInterviewSeq);
			$("#ccrYmd").val(formatDate(ccrYmd,"-"));
			$("#seq").val(seq);
			$("#memo").val(memo);
			
			$("#retInterviewSeq").removeClass().addClass("disabled").attr("disabled","disabled");
			$("#ccrYmd").addClass("transparent").attr("readonly","readonly").removeClass("required");
			$("#memo").removeClass().addClass("w100p text transparent readonly").attr("readonly",true);
			
			$(".ui-datepicker-trigger", detailForm).hide();
			
		} else if(type == "2") {
			//쓰기전용으로 스타일 변경
			$("#ccrYmd").removeClass("transparent").removeAttr("readonly").addClass("required");
			$("#retInterviewSeq").removeClass().addClass("disabled required").attr("disabled","disabled");
			$("#memo").removeClass().addClass("w100p text").attr("readonly",false);			
			$(".ui-datepicker-trigger").show();
		} else if(type == "3") {
			//데이터가 있으며
			var row = sheet2.GetSelectRow();
			
			//차수,일자,내용,SEQ
			var retInterviewSeq = sheet2.GetCellValue(row,"retInterviewSeq");
			var ccrYmd 			= sheet2.GetCellValue(row,"ccrYmd");
			var seq 			= sheet2.GetCellValue(row,"seq");
			var memo 			= sheet2.GetCellValue(row,"memo");
			$("#retInterviewSeq").val(retInterviewSeq);
			$("#ccrYmd").val(formatDate(ccrYmd,"-"));
			$("#seq").val(seq);
			$("#memo").val(memo);
			
			$("#ccrYmd").removeClass("transparent").removeAttr("readonly").addClass("required");
			$("#retInterviewSeq").removeClass().addClass("disabled required").attr("disabled","disabled");
			$("#memo").removeClass().addClass("w100p text").attr("readonly",false);
			$(".ui-datepicker-trigger").show();
		}
	}
		
	//조회시 전체 데이터 초기화
	function clearAllData() {
		sheet1.RemoveAll();
		sheet2.RemoveAll();
		$("#retInterviewSeq").val("");
		$("#ccrYmd").val("");
		$("#memo").val("");
		$(".detilaDiv").hide();
		
	}
	
	function setFormToSheet() {
		var row = sheet2.GetSelectRow();
		//차수가 같은경우 마지막 Row 아닐경우 새로운 Row
		if(pGubun == "Old") {
			row = sheet2.GetSelectRow();
		} else if(pGubun == "New"){			
			var sheet1Row = sheet1.GetSelectRow();
			sheet2.SetCellValue(row,"sabun",sheet1.GetCellValue(sheet1Row,"sabun"));
		}
		
		sheet2.SetCellValue(row,"ccrYmd",formatDate($("#ccrYmd").val(),""));
		sheet2.SetCellValue(row,"ccrCd",$("#ccrCd").val());
		sheet2.SetCellValue(row,"memo",$("#memo").val());
		sheet2.SetCellValue(row,"retInterviewSeq",$("#retInterviewSeq").val());
		
	}
	
	//닫기 버튼 클릭시 Sheet Resize
	function detailDivHide() {
		$('.detilaDiv').hide();
		sheetResize();
	}
</script>
</head> 
<body class="bodywrap">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
		<input id="retInterviewCd" name="retInterviewCd" type="hidden" value="3">
		<div class="sheet_search outer">
			<table>
			<tr>
				<th>퇴직희망일</th>
				<td>
					<input id="searchFrom" name="searchFrom" type="text" size="10" class="date2 w80" value=""/> ~
					<input id="searchTo" name="searchTo" type="text" size="10" class="date2 w80" value=""/>
				</td>
				<th><tit:txt mid='112999' mdef='결재상태'/></th>
				<td>
					<select id="applStatusCd" name="applStatusCd">
					</select>
				</td>
			</tr>
			<tr>
				<th>소속</th>
				<td>
					<input type="text" id="searchOrgNm" name= "searchOrgNm" />
				</td>
				<th>성명/사번</th>
				<td>
					<input type="text" id="searchSabunName" name="searchSabunName" class="text" style="ime-mode:active;"/>
				</td>
				<td>
					<a href="javascript:doAction1('Search');" class="btn dark">조회</a>
				</td>
			</tr>
			</table>
		</div>
	</form>
	
	<table style="width:100%;table-layout: fixed;">
		<colgroup>
			<col width="" />
			<col class="detilaDiv" width="560px" style="display:none;" />
		</colgroup> 
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li class="txt">퇴직면담 대상자</li>
					</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script> 
			</td>
			<td class="detilaDiv" style="padding:10px;vertical-align: top;display:none;">
				<div style="position:absolute;top:120px;right:0px;bottom:0;width:540px; height:calc(100vh - 114px);border:1px solid #e3e3e3;padding:5px;overflow-y:auto;">
					<div class="popup_title" style="padding-bottom:5px;">
					<ul>
						<li style="padding:10px;font-size:15px;">퇴직면담</li> 
						<li class="close" onclick="javascript:detailDivHide();"></li>
					</ul>
					</div>
					
					<div class="sheet_title">
					<ul>
						<li class="txt2">&nbsp;</li>
						<li class="btn" id="saveArea" style="display: none;">
							<a href="javascript:doAction2('New');" 		class="btn outline-gray" id="insInsertBtn" style="display: none;">입력</a>
							<a href="javascript:doAction2('Save');" 	class="btn filled" id="insSaveBtn" style="display: none;">저장</a>
						</li>
					</ul>
					</div>
					
					<script type="text/javascript"> createIBSheet("sheet2", "100%", "40%"); </script>
					
					<br>
					
					<div>
						<form id="detailForm" name="detailForm" >
							<input id="retInterviewCd" name="retInterviewCd" type="hidden" value="3">
							<input type="hidden" id="interviewSeq" name="interviewSeq"/>
							<input type="hidden" id="ccrCd" name="ccrCd" value="90"/>
							<input type="hidden" id="schApplSeq" name="schApplSeq"/>
							<table class="table">  
							<colgroup>
								<col width="80px" />
								<col width="" />
							</colgroup>
							<tr>
								<th>면담차수</th>
								<td>
									<select id="retInterviewSeq" name="retInterviewSeq" class="required" disabled></select>
								</td>									
							</tr>
							<tr>
								<th>면담일자</th>
								<td colspan="3"><input type="text" id="ccrYmd" name="ccrYmd" class="date2 required" ></td>
							</tr>
							<tr>
								<th>면담내용</th>
								<td>
									<textarea id="memo" name="memo" rows="10" cols="" class="w100p ${textCss}"></textarea>
								</td>
							</tr>
							</table>								
						</form>	
					</div>
				</div>
			</td>
			
			
		</tr>
	</table>		
</div>
<!-- 공통코드 레이어 팝업 -->
<%@ include file="/WEB-INF/jsp/common/include/layerPopup.jsp"%>

</body>
</html>
