<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head> <title>제목</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%><!-- Jquery -->
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%><!-- IBSheet -->

<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>	<!-- Employee Header를 Include 할 경우 필수 추가 -->

<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {
		//Sheet 초기화
		init_sheet();
		
		//사번셋팅
		setEmpPage();
	});

	//Sheet 초기화
	function init_sheet(){

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo'           mdef='No'/>",			Type:"${sNoTy}",	Hidden:0,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5'    mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus'       mdef='상태'/>",			Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='sDelete V5'    mdef='삭제'/>",			Type:"Html",		Hidden:0,	 Width:45,          Align:"Center",	ColMerge:0,	SaveName:"btnDel",  Sort:0 },

			{Header:"<sht:txt mid='dbItemDesc'    mdef='세부\n내역'/>",	Type:"Image",		Hidden:0,	Width:45,	Align:"Center",	ColMerge:0,	SaveName:"detail",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1},
			{Header:"<sht:txt mid='applYmdV6'     mdef='신청일자'/>",		Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applYmd",			KeyField:0,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50},
			{Header:"<sht:txt mid='agreeStatusCd' mdef='결재상태'/>",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applStatusCd",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50},

			{Header:"<sht:txt mid='apApplSeqV2'   mdef='신청서순번'/>",	Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applSeq",			KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:22},
			{Header:"<sht:txt mid='appSabunV6'    mdef='사원번호'/>",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13},

			{Header:"<sht:txt mid='zip'           mdef='우편번호'/>",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"tstZipcode",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:7},
			{Header:"<sht:txt mid='addr'          mdef='주소'/>",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"tstAddr",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:300},
			{Header:"<sht:txt mid='addr2'         mdef='상세주소'/>",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"tstAddrDtl",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000},
			{Header:"결재자 의견",		                               		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"tstComment",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000}

			]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

			sheet1.SetDataLinkMouse("detail", 1);

	 		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

	 		//  결재상태
	 		var applStatusCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R10010"), "");
			sheet1.SetColProperty("applStatusCd", {ComboText:"|"+applStatusCd[0], ComboCode:"|"+applStatusCd[1]} );


			$(window).smartresize(sheetResize); sheetInit();

	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search": 	 	
				//sheet1.DoSearch( "/Sample.do?cmd=getSampleApprovalList", $("#sheet1Form").serialize() );
				var sXml = sheet1.GetSearchData("${ctx}/Sample.do?cmd=getSampleApprovalList", $("#sheet1Form").serialize() );
				sXml = replaceAll(sXml,"shtcolEdit", "Edit");
				sheet1.LoadSearchData(sXml );
				break;
			case "Save": //임시저장의 경우 삭제처리.      
				if( !confirm("삭제하시겠습니까?")) { initDelStatus(sheet1); return;}  
				IBS_SaveName(document.sheet1Form,sheet1);
				sheet1.DoSave( "/Sample.do?cmd=deleteSampleApproval", $("#sheet1Form").serialize());
				break;
			case "Insert":		
				sheet1.DataInsert(0); 
				break;
			case "Copy":
				var Row = sheet1.DataCopy();
			    sheet1.SetCellValue(Row,"seq","");
			    break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
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
			
		    if( sheet1.ColSaveName(Col) == "detail" ) {
		    	showApplPopup( Row );

		    }else if( sheet1.ColSaveName(Col) == "btnDel" && Value != ""){
				sheet1.SetCellValue(Row, "sStatus", "D");
				doAction1("Save");
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
		  , applSeq = ""
		  , applInSabun = "${ssnSabun}" 
		  , applYmd = "${curSysYyyyMMdd}"
		  , url     = "/ApprovalMgr.do?cmd=viewApprovalMgr";
		  
		args["applStatusCd"] = "11";
		  
		if( Row > -1  ){
			if(sheet1.GetCellValue(Row, "applStatusCd") != "11") {
				auth = "R";  
				url ="/ApprovalMgrResult.do?cmd=viewApprovalMgrResult";
			}
			applSeq     = sheet1.GetCellValue(Row,"applSeq");
			applInSabun = sheet1.GetCellValue(Row,"applInSabun");
			applYmd     = sheet1.GetCellValue(Row,"applYmd");

			args["applStatusCd"] = sheet1.GetCellValue(Row, "applStatusCd");
		}
		
		url += "&searchApplCd=999"
			+ "&searchApplSeq="+applSeq
			+ "&adminYn=N"
			+ "&authPg="+auth
			+ "&searchSabun="+applInSabun // 신청 내용을 입력 하는 사람
			+ "&searchApplSabun="+$("#searchUserId").val()// 대상자 사번
			+ "&searchApplYmd="+applYmd;

		var result = openPopup(url, args, 950, 800);
	}

	// 신청결재 팝업 콜백 함수. 필수
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

		if(pGubun == "viewApprovalMgr"){
			doAction1("Search");
		}
	}

 	// Employee 헤더 임직원 조회
	function setEmpPage() {
		$("#searchSabun").val($("#searchUserId").val());

		doAction1("Search");
	}

</script>

</head>
<body class="bodywrap">
<div class="wrapper">

	<!-- include 기본정보 page TODO -->
	<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>

	<!-- 	Form 생성 시작 -->
	<form id="sheet1Form" name="sheet1Form">
		<input type="hidden" id="searchSabun" name="searchSabun" value=""/>
	</form>

	<table class="sheet_main">
	<tr>
		<td>
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li id="txt" class="txt">신청결재 가이드</li>
					<li class="btn">
						<btn:a href="javascript:showApplPopup(-1);" 		css="button authR" 	mid='110819' mdef="신청"/>
						<btn:a href="javascript:doAction1('Search')" 		css="basic" 		mid='110697' mdef="조회"/>
						<btn:a href="javascript:doAction1('Down2Excel')" 	css="basic" 		mid='110698' mdef="다운로드"/>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
		</td>
	</tr>
	</table>

</div>
</body>
</html>
