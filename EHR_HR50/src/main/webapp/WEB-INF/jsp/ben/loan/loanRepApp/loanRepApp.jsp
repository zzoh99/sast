<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>대출금상환신청</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {
		
		//Sheet 초기화
		init_sheet1(); 
		$(window).smartresize(sheetResize); sheetInit();

		
		//사번셋팅
		setEmpPage();
	});

	//Sheet 초기화
	function init_sheet1(){

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColLoan:1,ColResize:1,HeaderCheck:0};
		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo",		Sort:0 },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:1,    Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:1,    Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"Html",		Hidden:0,	 Width:45,              Align:"Center",	ColMerge:0,	SaveName:"btnDel",  Sort:0 },

			{Header:"<sht:txt mid='dbItemDesc' mdef='세부\n내역'/>",	Type:"Image",	Hidden:0, Width:45,	 Align:"Center", SaveName:"detail",			KeyField:0,	Format:"",		Edit:0 },
			{Header:"<sht:txt mid='applYmdV5' mdef='신청일'/>",		Type:"Date",	Hidden:0, Width:80,	 Align:"Center", SaveName:"applYmd",		KeyField:0,	Format:"Ymd",	Edit:0 },
			{Header:"<sht:txt mid='applStatusNm' mdef='신청상태' />",	Type:"Combo",	Hidden:0, Width:80,	 Align:"Center", SaveName:"applStatusCd",	KeyField:0,	Format:"",		Edit:0 },

			{Header:"<sht:txt mid='loanCdV2' mdef='대출구분'/>",		Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"loanCd",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0},
			{Header:"<sht:txt mid='loanYmd_V2124' mdef='대출일'/>",			Type:"Date",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"loanYmd",		KeyField:0,	Format:"Ymd",	Edit:0 },
			{Header:"<sht:txt mid='loanAmt' mdef='대출금'/>",			Type:"Int",		Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"loanMon",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0},
			{Header:"<sht:txt mid='repayYmd_V3183' mdef='상환일자'/>",		Type:"Date",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"repYmd",		KeyField:0,	Format:"Ymd",	Edit:0},
 			{Header:"<sht:txt mid='repayReqAmt' mdef='상환금'/>",			Type:"Int",		Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"repMon",		KeyField:0,	Format:"",		Edit:0},
 			{Header:"<sht:txt mid='intMon' mdef='이자'/>",			Type:"Int",		Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"intMon",		KeyField:0,	Format:"",		Edit:0},
 			{Header:"<sht:txt mid='principalPayMon' mdef='계'/>",			Type:"Int",		Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"totoMn",		CalcLogic:"|repMon|+|intMon|", KeyField:0,	Format:"", Edit:0},
 			
  			//Hidden
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"sabun"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applSabun"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applInSabun"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applSeq"}
  			
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(0);
  		
  		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("detail", 1);
		sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함
			
		//==============================================================================================================================
		//공통코드 한번에 조회
		var grpCds = "B50010,R10010";
		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd="+grpCds,false).codeList, "전체");
		
		sheet1.SetColProperty("applStatusCd",  	{ComboText:"|"+codeLists["R10010"][0], ComboCode:"|"+codeLists["R10010"][1]} );// 신청상태
		sheet1.SetColProperty("loanCd", 		{ComboText:"|"+codeLists["B50010"][0], ComboCode:"|"+codeLists["B50010"][1]} );// 대출구분
		//==============================================================================================================================
	}


	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				sheet1.DoSearch( "${ctx}/LoanRepApp.do?cmd=getLoanRepAppList", $("#sheet1Form").serialize() );
	        	break;	
	        case "Save": //임시저장의 경우 삭제처리.      
				if( !confirm("삭제하시겠습니까?")) { initDelStatus(sheet1); return;}  
	       		IBS_SaveName(document.sheet1Form,sheet1);
	        	sheet1.DoSave( "${ctx}/LoanRepApp.do?cmd=deleteLoanRepApp", $("#sheet1Form").serialize(), -1, 0); 
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
		  , url     = "/ApprovalMgr.do?cmd=viewApprovalMgrLayer"
		  , initFunc = 'initLayer';
		  
		args["applStatusCd"] = "11";
		  
		if( Row > -1  ){
			if(sheet1.GetCellValue(Row, "applStatusCd") != "11") {
				auth = "R";  
				url ="/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
			}
			applSeq     = sheet1.GetCellValue(Row,"applSeq");
			applInSabun = sheet1.GetCellValue(Row,"applInSabun");
			applYmd     = sheet1.GetCellValue(Row,"applYmd");
			initFunc = 'initResultLayer';
			args["applStatusCd"] = sheet1.GetCellValue(Row, "applStatusCd");
		}
		var p = {
				searchApplCd: '102'
			  , searchApplSeq: applSeq
			  , adminYn: 'N'
			  , authPg: auth
			  , searchSabun: applInSabun
			  , searchApplSabun: $('#searchUserId').val()
			  , searchApplYmd: applYmd 
			};
		var approvalMgrLayer = new window.top.document.LayerModal({
			id: 'approvalMgrLayer',
			url: url,
			parameters: p,
			width: 800,
			height: 815,
			title: '대출상환신청',
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
	
	//신청 팝업에서  리턴
	function getReturnValue(returnValue) {
		doAction1("Search");
	}

	//인사헤더에서 이름 변경 시 호출 됨 
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
	<form id="sheet1Form" name="sheet1Form" >
		<input type="hidden" id="searchSabun" name="searchSabun" value=""/>
		<input type="hidden" id="searchApplSeq" name="searchApplSeq" value=""/>
	</form>

	<div class=outer>
		<div class="sheet_title">
		<ul>
			<li id="txt" class="txt"><tit:txt mid='loanRepApp' mdef='대출상환신청'/></li>
			<li class="btn">
				<a href="javascript:doAction1('Down2Excel')" 	class="btn outline-gray" ><tit:txt mid='download' mdef='다운로드'/></a>
				<a href="javascript:showApplPopup(-1);" 		class="btn filled" ><tit:txt mid='appComLayout' mdef='신청'/></a>
				<a href="javascript:doAction1('Search')" 		class="btn dark" ><tit:txt mid='104081' mdef='조회'/></a>
			</li>
		</ul>
		</div>
	</div>
	
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>

</body>
</html>