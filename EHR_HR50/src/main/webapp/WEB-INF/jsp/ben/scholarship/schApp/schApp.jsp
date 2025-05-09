<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head> <title>학자금신청</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {

		$("#searchFromApplYmd, #searchToApplYmd").on("keyup", function(event) {
			//신청년도 숫자만 입력
            makeNumber(this,'A');
            
			if( event.keyCode == 13) {
				doAction1("Search");
			}
		});
        
		//Sheet 초기화
		init_sheet();
		
		//사번셋팅
		setEmpPage();
	});

	//Sheet 초기화
	function init_sheet(){

		// 기간 default 값
		$("#searchFromApplYmd").val(parseInt("${curSysYear}")-3);
		$("#searchToApplYmd").val("${curSysYear}");
		
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo",		Sort:0 },
			{Header:"삭제",			Type:"${sDelTy}",	Hidden:1,    Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",			Type:"${sSttTy}",	Hidden:1,    Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"삭제",			Type:"Html",		Hidden:0,	 Width:45,              Align:"Center",	ColMerge:0,	SaveName:"btnDel",  Sort:0 },

			{Header:"세부\n내역",		Type:"Image",		Hidden:0, 	Width:45,	 Align:"Center", SaveName:"detail",			Format:"",		Edit:0 },
			{Header:"신청일",			Type:"Date",		Hidden:0, 	Width:80,	 Align:"Center", SaveName:"applYmd",		Format:"Ymd",	Edit:0 },
			{Header:"신청상태",		Type:"Combo",		Hidden:0, 	Width:80,	 Align:"Center", SaveName:"applStatusCd",	Format:"",		Edit:0 },

			{Header:"학자금",			Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"schTypeCd",	Edit:0 },
			{Header:"지원구분",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"schSupTypeCd",	Edit:0 },
			{Header:"대상자",			Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"famCd",	Edit:0 },
			{Header:"대상자명",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"famNm",		Edit:0 },
			{Header:"생년월일",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"famYmd",		Format:"Ymd", 	Edit:0 },
			{Header:"학교명",			Type:"Text",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"schName",		Edit:0 },
			{Header:"신청년도",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appYear",		Edit:0 },
			{Header:"신청분기",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"divCd",		Format:"", 	Edit:0 },
			{Header:"신청금액",		Type:"Int",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applMon",		Format:"#,###\\원",	Edit:0 },
			{Header:"지급금액",		Type:"Int",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"payMon",		Format:"#,###\\원",	Edit:0 },
			{Header:"급여년월",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"payYm",		Format:"Ym", 	Edit:0 },

  			//Hidden
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"sabun"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applSabun"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applInSabun"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applSeq"}

  		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
  		
  		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("detail", 1);
		sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함

		$(window).smartresize(sheetResize); sheetInit();

	}

	function getCommonCodeList() {
		let baseSYmd = "";
		let baseEYmd = "";

		if ($("#searchFromApplYmd").val() !== "" && $("#searchToApplYmd").val() !== "") {
			baseSYmd = $("#searchFromApplYmd").val() + "-01-01";
			baseEYmd = $("#searchToApplYmd").val() + "-12-31";
		}

		//공통코드 한번에 조회
		let grpCds = "B60050,B60051,B60030,R10010,B60060";
		let params = "grpCd=" + grpCds + "&baseSYmd=" + baseSYmd + "&baseEYmd=" + baseEYmd;
		const codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists&useYn=Y", params, false).codeList, "");

		sheet1.SetColProperty("applStatusCd",  {ComboText:"|"+codeLists["R10010"][0], ComboCode:"|"+codeLists["R10010"][1]} );//  신청상태
		sheet1.SetColProperty("schTypeCd",     {ComboText:"|"+codeLists["B60050"][0], ComboCode:"|"+codeLists["B60050"][1]} ); //학자금
		sheet1.SetColProperty("schSupTypeCd",  {ComboText:"|"+codeLists["B60051"][0], ComboCode:"|"+codeLists["B60051"][1]} ); //학자금지원구분
		sheet1.SetColProperty("famCd",         {ComboText:"|"+codeLists["B60030"][0], ComboCode:"|"+codeLists["B60030"][1]} ); //대상자(경조-가족구분)
		sheet1.SetColProperty("divCd",         {ComboText:"|"+codeLists["B60060"][0], ComboCode:"|"+codeLists["B60060"][1]} ); //신청분기
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				getCommonCodeList();
				if ($("#searchFromApplYmd").val() == "" && $("#searchToApplYmd").val() != "" ){
					//to year만 입력한경우 리턴
					alert("<msg:txt mid='alertVacationApp1' mdef='시작년도를 입력하여 주십시오.'/>");
					return 
				}
				var sXml = sheet1.GetSearchData("${ctx}/SchApp.do?cmd=getSchAppList", $("#sheet1Form").serialize() );
				sXml = replaceAll(sXml,"shtcolEdit", "Edit");
				sheet1.LoadSearchData(sXml);
	        	break;	
	        case "Save": //임시저장의 경우 삭제처리.      
				if( !confirm("삭제하시겠습니까?")) { initDelStatus(sheet1); return;}  
	       		IBS_SaveName(document.sheet1Form,sheet1);
	        	sheet1.DoSave( "${ctx}/SchApp.do?cmd=deleteSchApp", $("#sheet1Form").serialize(), -1, 0); 
	        	break;
	        	
	        case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1, ['Html']);
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
				initFunc = 'initResultLayer';
			}
			applSeq     = sheet1.GetCellValue(Row,"applSeq");
			applInSabun = sheet1.GetCellValue(Row,"applInSabun");
			applYmd     = sheet1.GetCellValue(Row,"applYmd");
			args["applStatusCd"] = sheet1.GetCellValue(Row, "applStatusCd");
		}
		var p = {
				searchApplCd: '103'
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
			title: '학자금신청',
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
<body class="hidden">
<div class="wrapper">
	<!-- include 기본정보 page TODO -->
	<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>
	
	<form id="sheet1Form" name="sheet1Form" >
		<input type="hidden" id="searchSabun" name="searchSabun" value=""/>
		<div class="sheet_search sheet_search_s outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='reqYear' mdef='신청년도'/></th>
						<td>  <input type="text" class="text w70 center" id="searchFromApplYmd" name="searchFromApplYmd"  maxlength="4"/>
							~
							<input type="text" class="text w70 center" id="searchToApplYmd" name="searchToApplYmd"  maxlength="4"/>
						</td>
						<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="btn dark"><tit:txt mid='104081' mdef='조회'/></a> </td></a> </td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	
	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li class="txt"><tit:txt mid='schAppV1' mdef='학자금신청'/></li>
				<li class="btn">
					<!-- <a href="javascript:doAction1('Search')" 		class="basic" >조회</a>-->
					<a href="javascript:doAction1('Down2Excel')" 	class="btn outline-gray" ><tit:txt mid='download' mdef='다운로드'/></a>
					<a href="javascript:showApplPopup(-1);" 		class="btn filled" ><tit:txt mid='appComLayout' mdef='신청'/></a>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script>

</body>
</html>
