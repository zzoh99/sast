<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head><title>사내강사료신청</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {
		
		init_sheet();
		
		setEmpPage();
	});

	//시트 초기화
	function init_sheet(){

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:7 }; // MergeSheet:7 앞 컬럼이 머지 된 경우 해당 행 안에서 머지기능 + 헤더 머지
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",					Type:"${sNoTy}",  Hidden:0,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo",		Sort:0 },
   			{Header:"<sht:txt mid='sStatusV1' mdef='상태|상태'/>",				Type:"${sSttTy}", Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

  			{Header:"applSeq",					Type:"Text",   Hidden:1, Width:80,  Align:"Center", ColMerge:0, SaveName:"applSeq"},
  			{Header:"eduSeq",					Type:"Text",   Hidden:1, Width:80,  Align:"Center", ColMerge:1, SaveName:"eduSeq"},
  			{Header:"eduEventSeq",				Type:"Text",   Hidden:1, Width:80,  Align:"Center", ColMerge:1, SaveName:"eduEventSeq"},
			{Header:"<sht:txt mid='eduCourseNmV2' mdef='과정명|과정명'/>",  			Type:"Text",   Hidden:0, Width:250, Align:"Left",   ColMerge:1, SaveName:"eduCourseNm",  	KeyField:0, Format:"",      UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='eduAppSYmdV1' mdef='교육시작일|교육시작일'/>", 	Type:"Date",   Hidden:0, Width:80,  Align:"Center", ColMerge:1, SaveName:"eduSYmd",  		KeyField:0, Format:"Ymd",   UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='eduAppEYmdV1' mdef='교육종료일|교육종료일'/>", 	Type:"Date",   Hidden:0, Width:80,  Align:"Center", ColMerge:1, SaveName:"eduEYmd",  		KeyField:0, Format:"Ymd",   UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='subjectLecture' mdef='강의과목|강의과목'/>",  		Type:"Text",   Hidden:0, Width:250, Align:"Left",   ColMerge:1, SaveName:"subjectLecture",  	KeyField:0, Format:"",      UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='lectureFee' mdef='강사료|강사료'/>", 			Type:"Int",    Hidden:0, Width:70,  Align:"Center", ColMerge:1, SaveName:"lectureFee", 		Format:"", 		UpdateEdit:0, InsertEdit:0 },
			
			{Header:"<sht:txt mid='eduResultAppV1' mdef='교육\n결과보고|교육\n결과보고'/>",Type:"Image",  Hidden:0, Width:60,  Align:"Center", ColMerge:0, SaveName:"selectImg",       KeyField:0, Format:"",      UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='applYmdV9' mdef='신청|신청'/>",				Type:"Html",   Hidden:0, Width:45,  Align:"Center",	ColMerge:0,	SaveName:"btnApp",  Sort:0 ,	Cursor:"Pointer"},
			{Header:"<sht:txt mid='detail'         mdef='세부\n내역|세부\n내역'/>",	Type:"Image",  Hidden:0, Width:45,  Align:"Center", ColMerge:0, SaveName:"detail",         KeyField:0, Format:"",      UpdateEdit:0,   InsertEdit:0,	Cursor:"Pointer" },
			{Header:"<sht:txt mid='applYmdV2'      mdef='신청일자|신청일자'/>",			Type:"Date",   Hidden:0, Width:80,  Align:"Center", ColMerge:0, SaveName:"applYmd",        KeyField:0, Format:"Ymd",   UpdateEdit:0,   InsertEdit:0 },
  			{Header:"<sht:txt mid='applStatusNmV1' mdef='신청상태|신청상태'/>",		Type:"Combo",  Hidden:0, Width:80,  Align:"Center", ColMerge:0, SaveName:"applStatusCd",   KeyField:0, Format:"",      UpdateEdit:0,   InsertEdit:0 },
  			
  			//Hidden
  			{Header:"sabun",		Hidden:1, SaveName:"sabun"},
  			{Header:"applInSabun",	Hidden:1, SaveName:"applInSabun"},
	
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		sheet1.SetImageList(0, "${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetImageList(1,"${ctx}/common/images/icon/icon_x.png");
 		sheet1.SetImageList(2,"${ctx}/common/images/icon/icon_o.png");

		sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함

		//공통코드 한번에 조회
		var grpCds = "R10010";
		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd="+grpCds,false).codeList, "전체");
		sheet1.SetColProperty("applStatusCd", 	{ComboText:"|"+codeLists["R10010"][0], ComboCode:"|"+codeLists["R10010"][1]} );  //  결재상태
		
		$(window).smartresize(sheetResize); sheetInit();
	}


	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var sXml = sheet1.GetSearchData("${ctx}/LectureFeeApp.do?cmd=getLectureFeeAppList", $("#sheet1Form").serialize() );
			sheet1.LoadSearchData(sXml );
			break;
        case "Save":   
			if( !confirm('<msg:txt mid="alertDelete" mdef="삭제하시겠습니까?" />')) { initDelStatus(sheet1); return;}
       		IBS_SaveName(document.sheet1Form,sheet1);
        	sheet1.DoSave( "${ctx}/LectureFeeApp.do?cmd=deleteLectureFeeApp", $("#sheet1Form").serialize(), -1, 0); 
        	break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param); 
			break;
		}
	}

	//-----------------------------------------------------------------------------------
	//		sheet1 이벤트
	//-----------------------------------------------------------------------------------
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
			if( Code > -1 ) doAction1("Search"); 
		} catch (ex) { 
			alert("OnSaveEnd Event Error " + ex); 
		}
	}


	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			if( Row < sheet1.HeaderRows() ) return;
			
		    if( sheet1.ColSaveName(Col) == "detail" && Value != "" ) {
		    	showApplPopup( Row );

		    }else if( sheet1.ColSaveName(Col) == "btnApp" && Value != ""){
		    	if(Value.indexOf('신청') >= 1){
		    		showApplPopup( -1 );
		    	} else if(Value.indexOf('삭제') >= 1){
		    		sheet1.SetCellValue(Row, "sStatus", "D");
		    		doAction1("Save");
		    	};

		    }
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}
	

	//-----------------------------------------------------------------------------------
	//		신청 팝업
	//-----------------------------------------------------------------------------------
	function showApplPopup( Row ) {

		if(!isPopup()) {return;}
		
		var args = new Array(5);
		var auth    = "A"
		  , applCd = "503"
		  , applSeq = ""
		  , searchSabun = "${ssnSabun}" 
		  , applYmd = "${curSysYyyyMMdd}"
		  , url     = "/ApprovalMgr.do?cmd=viewApprovalMgrLayer"
		  , initFunc = 'initLayer';
		  
		args["applStatusCd"] = "11";
		if( Row > -1  ){
			if(sheet1.GetCellValue(Row, "applStatusCd") != "11") {
				auth = "R";  
				url = "/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
			}
			applSeq     = sheet1.GetCellValue(Row,"applSeq");
			searchSabun = sheet1.GetCellValue(Row,"applInSabun");
			applYmd     = sheet1.GetCellValue(Row,"applYmd");
			args["applStatusCd"] = sheet1.GetCellValue(Row, "applStatusCd");
			initFunc = 'initResultLayer';
		} 

		var p = {
				searchApplCd: applCd
			  , searchApplSeq: applSeq
			  , adminYn: 'N'
			  , authPg: auth
			  , searchSabun: searchSabun
			  , searchApplSabun: $('#searchUserId').val()
			  , searchApplYmd: applYmd 
			  , etc01: sheet1.GetCellValue(Row,"eduSeq")
			  , etc02: sheet1.GetCellValue(Row,"eduEventSeq")
			};
		var approvalMgrLayer = new window.top.document.LayerModal({
			id: 'approvalMgrLayer',
			url: url,
			parameters: p,
			width: 800,
			height: 815,
			title: '신청서',
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

	//신청 후 리턴
	function getReturnValue(returnValue) {
		doAction1("Search");
	}

	//인사헤더에서 이름 변경 시 
    function setEmpPage() {
    	$("#searchSabun").val($("#searchUserId").val());
    	doAction1("Search");
    }


</script>
</head>
<body class="hidden">
<div class="wrapper">
	<!-- include 기본정보 page TODO -->
	<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>

	<form id="sheet1Form" name="sheet1Form" >
		<input type="hidden" id="searchSabun" name="searchSabun" value=""/>
	
	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li id="txt" class="txt"><tit:txt mid='lectureFeeApp' mdef='사내강사료신청'/></li>
				<li class="btn">
					<a href="javascript:doAction1('Down2Excel')" 	class="btn outline-gray" ><tit:txt mid="download" mdef="다운로드"/></a>
					<a href="javascript:doAction1('Search')" 		class="btn dark"><tit:txt mid='104081' mdef='조회'/></a>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
	</form>
	
</div>
</body>
</html>