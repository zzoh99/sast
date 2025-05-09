<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head> <title>담당직무신청</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">

	$(function() {
		//Sheet 초기화
		init_sheet();
		
		//사번셋팅
		setEmpPage();
	});

	//Sheet 초기화
	function init_sheet(){

		// 기간 default 값
		$("#searchFromApplYmd").val("${curSysYear}");
		$("#searchToApplYmd").val("${curSysYear}");

		// 숫자만 입력가능
		$("#searchFromApplYmd, searchToApplYmd").keyup(function() {
			makeNumber(this,'A');
			if( event.keyCode == 13) {
				doAction1("Search");
			}
		});

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo",		Sort:0 },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:1,    Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:1,    Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"Html",		Hidden:0,	 Width:45,              Align:"Center",	ColMerge:0,	SaveName:"btnDel",  Sort:0 },

			{Header:"<sht:txt mid='ibsImageV3' mdef='세부내역' />",	Type:"Image",		Hidden:0, 	Width:45,	 Align:"Center", SaveName:"detail",			Format:"",		Edit:0 },
			{Header:"<sht:txt mid='applYmdV6' mdef='신청일자' />",		Type:"Date",		Hidden:0, 	Width:50,	 Align:"Center", SaveName:"applYmd",		Format:"Ymd",	Edit:0 },
			{Header:"<sht:txt mid='applStatusNm' mdef='신청상태' />",		Type:"Combo",		Hidden:0, 	Width:80,	 Align:"Center", SaveName:"applStatusCd",	Format:"",		Edit:0 },

			{Header:"<sht:txt mid='departmentV1' mdef='부서'/>",			Type:"Combo",		Hidden:0,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"orgCd",	Edit:0 },
			{Header:"<sht:txt mid='mainJobCd' mdef='대표직무'/>",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jobCd",	Edit:0 },
			{Header:"<sht:txt mid='applyYy' mdef='적용일'/>",		Type:"Date",		Hidden:0, 	Width:50,	Align:"Center", SaveName:"applyYmd",		Format:"Ymd",	Edit:0 },
			{Header:"<sht:txt mid='taskCdV1' mdef='과업'/>",			Type:"Combo",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"taskCd",	Edit:0 },
		
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applSeq"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"sabun"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"jobMType"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"jobDType"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applInSabun"}

  		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
  		
  		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("detail", 1);
		sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함
		
		// 콥보 리스트
		/* ########################################################################################################################################## */
		
		var grpCds = "R10010";
		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists&useYn=Y","grpCd="+grpCds,false).codeList, "");
		sheet1.SetColProperty("applStatusCd",  	{ComboText:"|"+codeLists["R10010"][0], ComboCode:"|"+codeLists["R10010"][1]} );//  신청상태
		
		var orgCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrgCdList",false).codeList, "");	//조직코드
		
		var jobCdParam = "&searchJobType=10030&codeType=1";
		var jobCd = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getJobMgrList"+jobCdParam, false).codeList
		            , "code,codeNm"
		            , " ");
		
		var taskCdParam = "&searchJobType=10040&codeType=1";
		var taskCd = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getJobMgrList"+taskCdParam, false).codeList
		            , "code,codeNm"
		            , " ");
		
		sheet1.SetColProperty("orgCd", {ComboText:"|"+orgCd[0], ComboCode:"|"+orgCd[1]} );
		sheet1.SetColProperty("taskCd", {ComboText:"|"+taskCd[0], ComboCode:"|"+taskCd[1]} );
		sheet1.SetColProperty("jobCd", {ComboText:"|"+jobCd[0], ComboCode:"|"+jobCd[1]} );
		/* ########################################################################################################################################## */

		$(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");
		
	}

	function checkList(){
		if( $("#searchFromApplYmd").val().length != 4 && $("#searchFromApplYmd").val().length != 0 ){
			alert("<msg:txt mid='alertReqYear' mdef='신청년도를 정확히 입력해주세요.'/>");
			$("#searchFromApplYmd").focus();
			return false;
		}

		if( $("#searchToApplYmd").val().length != 4 && $("#searchToApplYmd").val().length != 0 ){
			alert("<msg:txt mid='alertReqYear' mdef='신청년도를 정확히 입력해주세요.'/>");
			$("#searchToApplYmd").focus();
			return false;
		}

		var from = $("#searchFromApplYmd").val();
		var to = $("#searchToApplYmd").val();
		if (parseInt(from) > parseInt(to)) {
			alert("<msg:txt mid='110396' mdef='시작일자가 종료일자보다 큽니다.'/>");
			$("#searchFromApplYmd").focus();
			return false;
		}

		return true;
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				if( !checkList() ) return;
				var sXml = sheet1.GetSearchData("${ctx}/JobRegApp.do?cmd=getJobRegAppList", $("#sheet1Form").serialize() );
				sXml = replaceAll(sXml,"shtcolEdit", "Edit");
				sheet1.LoadSearchData(sXml);
	        	break;	
	        case "Save": //임시저장의 경우 삭제처리.      
				if( !confirm('<msg:txt mid="alertDelete" mdef="삭제하시겠습니까?" />')) { initDelStatus(sheet1); return;}
	       		IBS_SaveName(document.sheet1Form,sheet1);
	        	sheet1.DoSave( "${ctx}/JobRegApp.do?cmd=deleteJobRegApp", $("#sheet1Form").serialize(), -1, 0); 
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
		  , url = "/ApprovalMgr.do?cmd=viewApprovalMgrLayer"
		  , initFunc = 'initLayer'
		  , pageApply = 1;
		  
		args["applStatusCd"] = "11";
		if( Row > -1  ){
			if(sheet1.GetCellValue(Row, "applStatusCd") != "11") {
				auth = "R";  
				url = "/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
			}
			applSeq     = sheet1.GetCellValue(Row,"applSeq");
			applInSabun = sheet1.GetCellValue(Row,"applInSabun");
			applYmd     = sheet1.GetCellValue(Row,"applYmd");
			pageApply = 2;
			args["applStatusCd"] = sheet1.GetCellValue(Row, "applStatusCd");
			initFunc = 'initResultLayer';
		}

		var p = {
				searchApplCd: '180'
			  , searchApplSeq: applSeq
			  , adminYn: 'N'
			  , authPg: auth
			  , searchSabun: applInSabun
			  , searchApplSabun: $('#searchUserId').val()
			  , searchApplYmd: applYmd 
			  , etc01: pageApply
			};

		var approvalMgrLayer = new window.top.document.LayerModal({
			id: 'approvalMgrLayer',
			url: url,
			parameters: p,
			width: 800,
			height: 815,
			title: '담당직무신청',
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
		<input type="hidden" id="searchTitleYn" name="searchTitleYn" value="Y"/>
		
		<div class="sheet_search sheet_search_s outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='reqYear' mdef='신청년도'/></th>
						<td>  <input type="text" class="text date2" id="searchFromApplYmd" name="searchFromApplYmd" maxlength="4"/>
							~
							<input type="text" class="text date2" id="searchToApplYmd" name="searchToApplYmd" maxlength="4"/>
						</td>
						<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a> </td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	
	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li class="txt"><tit:txt mid='reqJob' mdef='담당직무신청'/></li>
				<li class="btn">
					<btn:a mid="110698" mdef="다운로드" href="javascript:doAction1('Down2Excel');" css="btn outline-gray" />
					<btn:a mid="110819" mdef="신청" href="javascript:showApplPopup(-1);" css="btn filled" />
					<btn:a href="javascript:doAction1('Search')" mid="search" mdef="조회" css="btn dark"/>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script>

</body>
</html>
