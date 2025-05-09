<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>연간교육계획신청</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">

	var searchApplSeq    = "${searchApplSeq}";
	var adminYn          = "${adminYn}";
	var authPg           = "${authPg}";
	var searchApplSabun  = "${searchApplSabun}";
	var searchApplInSabun= "${searchApplInSabun}";
	var searchApplYmd    = "${searchApplYmd}";
	var applStatusCd	 = "";
	var applYn	         = "";
	var pGubun           = "";
	var pGubunSabun      = "";
	var gPRow 			 = "";
	var adminRecevYn     = "N"; //수신자 여부
	var closeYn;				//마감여부
	var p = eval("${popUpStatus}");
	
	$(function() {
		
		parent.iframeOnLoad(220);
		
		//----------------------------------------------------------------
		$("#searchApplSeq").val(searchApplSeq);
		$("#searchApplSabun").val(searchApplSabun);
		$("#searchApplYmd").val(searchApplYmd);
		applStatusCd = parent.$("#applStatusCd").val();
		if(applStatusCd == "") {
			applStatusCd = "11";
		}
		//----------------------------------------------------------------
			
		var param = "";
		
		// 신청, 임시저장
		if(authPg == "A") {
		} else if (authPg == "R") {
			$(".isView").hide();
			if( ( adminYn == "Y" ) || ( applStatusCd == "31"  && applYn == "Y" ) ){ //관리자거나 수신결재자이면
				if( applStatusCd == "31" ){ //수신처리중일 때만 처리관련정보 수정가능
				}
				adminRecevYn = "Y";
			}
		}
		
		var codeList = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getYearEduAppYearCode", false).codeList
        , "sdate,edate"
        , "");
		$("#year").html(codeList[2]).change();
		
		var map = ajaxCall( "${ctx}/YearEduOrgApp.do?cmd=getYearEduOrgAppDetOrgMap",$("#searchForm").serialize(),false);
		if ( map != null && map.DATA != null ){
			var data = map.DATA;
			
			$("#orgCd").val( data.orgCd );
			$("#orgNm").val( data.orgNm );
			$("#priorOrgNm").val( data.priorOrgNm );
		}
		
		
		//기준년도 선택시
		$('#searchForm').on('change', 'select[name="year"]',function() {
			if (!$("#year").val()) {
				sheet1.RemoveAll();
				return;
			}
			
			var isDisabled = $("#year").is(":disabled");
			$("#year").attr("disabled",false);
			doAction("SearchSheet");
			$("#year").attr("disabled",isDisabled);
		});
		
		init_sheet();
		
		doAction("Search");
		
		doAction("SearchSheet");
		
	});
	
function init_sheet(){ 
		
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly, FrozenCol:3};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
	
		initdata1.Cols = [
	
			{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",						Type:"${sNoTy}",  Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	SaveName:"sNo",		Sort:0 },
/* 			{Header:"삭제|삭제",					Type:"${sDelTy}", Hidden:0,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",					Type:"${sSttTy}", Hidden:Number("${sSttHdn}"),	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			 */
			{Header:"<sht:txt mid='sabun' mdef='사번|사번'/>",					Type:"Text",   	Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"sabun", 			Edit:0},
			{Header:"<sht:txt mid='name' mdef='성명|성명'/>",					Type:"Text",   	Hidden:0, Width:80,		Align:"Center", ColMerge:0,  SaveName:"name", 			Edit:0},
			{Header:"<sht:txt mid='jikweeNm' mdef='직위|직위'/>",					Type:"Text",   	Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"jikweeNm", 		Edit:0},
			{Header:"<sht:txt mid='eduCourseNmV4' mdef='교육과정명|교육과정명'/>", 		Type:"Text", 	 Hidden:0, Width:150,  Align:"Left",   SaveName:"eduCourseNm", 	KeyField:0, Format:"", 	UpdateEdit:0, InsertEdit:0 },
			{Header:"<sht:txt mid='inOutCdV1' mdef='사내/외\n구분|사내/외\n구분'/>", 	Type:"Combo", 	 Hidden:0, Width:100,  Align:"Center", SaveName:"inOutType", 	KeyField:0, Format:"", 	UpdateEdit:0, InsertEdit:0 },
			{Header:"<sht:txt mid='monEduCostTot' mdef='월별교육비용|합계'/>", 			Type:"AutoSum",  Hidden:0, Width:50,   Align:"Center", SaveName:"totMon", 		KeyField:0, Format:"", 	UpdateEdit:0, InsertEdit:0, CalcLogic:"|mon01|+|mon02|+|mon03|+|mon04|+|mon05|+|mon06|+|mon07|+|mon08|+|mon09|+|mon10|+|mon11|+|mon12|" },
			{Header:"<sht:txt mid='monEduCost1' mdef='월별교육비용|1월'/>",				Type:"AutoSum",  Hidden:0, Width:50,   Align:"Center", SaveName:"mon01", 		KeyField:0, Format:"", 	UpdateEdit:0, InsertEdit:0 },
			{Header:"<sht:txt mid='monEduCost2' mdef='월별교육비용|2월'/>",				Type:"AutoSum",  Hidden:0, Width:50,   Align:"Center", SaveName:"mon02", 		KeyField:0, Format:"", 	UpdateEdit:0, InsertEdit:0 },
			{Header:"<sht:txt mid='monEduCost3' mdef='월별교육비용|3월'/>",				Type:"AutoSum",  Hidden:0, Width:50,   Align:"Center", SaveName:"mon03", 		KeyField:0, Format:"", 	UpdateEdit:0, InsertEdit:0 },
			{Header:"<sht:txt mid='monEduCost4' mdef='월별교육비용|4월'/>", 			Type:"AutoSum",  Hidden:0, Width:50,   Align:"Center", SaveName:"mon04", 		KeyField:0, Format:"", 	UpdateEdit:0, InsertEdit:0 },
			{Header:"<sht:txt mid='monEduCost5' mdef='월별교육비용|5월'/>", 			Type:"AutoSum",  Hidden:0, Width:50,   Align:"Center", SaveName:"mon05", 		KeyField:0, Format:"", 	UpdateEdit:0, InsertEdit:0 },
			{Header:"<sht:txt mid='monEduCost6' mdef='월별교육비용|6월'/>", 			Type:"AutoSum",  Hidden:0, Width:50,   Align:"Center", SaveName:"mon06", 		KeyField:0, Format:"", 	UpdateEdit:0, InsertEdit:0 },
			{Header:"<sht:txt mid='monEduCost7' mdef='월별교육비용|7월'/>", 			Type:"AutoSum",  Hidden:0, Width:50,   Align:"Center", SaveName:"mon07", 		KeyField:0, Format:"", 	UpdateEdit:0, InsertEdit:0 },
			{Header:"<sht:txt mid='monEduCost8' mdef='월별교육비용|8월'/>", 			Type:"AutoSum",  Hidden:0, Width:50,   Align:"Center", SaveName:"mon08", 		KeyField:0, Format:"", 	UpdateEdit:0, InsertEdit:0 },
			{Header:"<sht:txt mid='monEduCost9' mdef='월별교육비용|9월'/>", 			Type:"AutoSum",  Hidden:0, Width:50,   Align:"Center", SaveName:"mon09", 		KeyField:0, Format:"", 	UpdateEdit:0, InsertEdit:0 },
			{Header:"<sht:txt mid='monEduCost10' mdef='월별교육비용|10월'/>", 			Type:"AutoSum",  Hidden:0, Width:50,   Align:"Center", SaveName:"mon10", 		KeyField:0, Format:"", 	UpdateEdit:0, InsertEdit:0 },
			{Header:"<sht:txt mid='monEduCost11' mdef='월별교육비용|11월'/>", 			Type:"AutoSum",  Hidden:0, Width:50,   Align:"Center", SaveName:"mon11", 		KeyField:0, Format:"", 	UpdateEdit:0, InsertEdit:0 },
			{Header:"<sht:txt mid='monEduCost12' mdef='월별교육비용|12월'/>",			Type:"AutoSum",  Hidden:0, Width:50,   Align:"Center", SaveName:"mon12", 		KeyField:0, Format:"", 	UpdateEdit:0, InsertEdit:0 },
			{Header:"<sht:txt mid='eduPriority' mdef='교육우선순위|교육우선순위'/>", 	Type:"Combo", 	 Hidden:0, Width:260,  Align:"Left", SaveName:"priorityCd", 	KeyField:0, Format:"", 	UpdateEdit:0, InsertEdit:0 },
			//Hidden
			{Header:"Hidden", Type:"Text", Hidden:1, SaveName:"seq"},
			{Header:"Hidden", Type:"Text", Hidden:1, SaveName:"year"},
			{Header:"Hidden", Type:"Text", Hidden:1, SaveName:"orgCd"},
	
	
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(0);sheet1.SetVisible(true);sheet1.SetCountPosition(4);
	
		sheet1.SetDataAlternateBackColor(sheet1.GetDataBackColor()); //홀짝 배경색 같게
		
		//==============================================================================================================================
		var grpCds = "L20020,L15010";
			var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd="+grpCds,false).codeList, "");
			sheet1.SetColProperty("inOutType",  		{ComboText:"|"+codeLists["L20020"][0], ComboCode:"|"+codeLists["L20020"][1]} ); //사내/사외구분
			sheet1.SetColProperty("priorityCd",  		{ComboText:"|"+codeLists["L15010"][0], ComboCode:"|"+codeLists["L15010"][1]} ); //교육우선순위
		//==============================================================================================================================
		
		$(window).smartresize(sheetResize); sheetInit();
		
	}
	
	//조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	
	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			if(sheet1.ColSaveName(Col) == "sDelete" && Value == 1 ) {
				sheet1.RowDelete(Row);
			}
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}
	
	// Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search" :
			// 입력 폼 값 셋팅
			var map = ajaxCall( "${ctx}/YearEduOrgApp.do?cmd=getYearEduOrgAppDetMap",$("#searchForm").serialize(),false);

			if ( map != null && map.DATA != null ){
				var data = map.DATA;
				
				$("#year").html("<option value='"+data.year+"'>"+data.year+"</option>");
				$("#orgCd").val(data.orgCd);
				$("#orgCdNm").val(data.orgCdNm);
				$("#priorOrgNm").val( data.priorOrgNm );
			}
			break;
			
		case "SearchSheet" :
			var isDisabled = $("#year").is(":disabled");
			$("#year").attr("disabled",false);
			var sXml = sheet1.GetSearchData("${ctx}/YearEduOrgApp.do?cmd=getYearEduOrgAppDetaAppInfo", $("#searchForm").serialize());
			sheet1.LoadSearchData(sXml );
			$("#year").attr("disabled",isDisabled);
			break;
			
		case "Down2Excel" :
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
			
		}
	}
	
	// 입력시 조건 체크
	function checkList() {
		var ch = true;
		
		// 화면의 개별 입력 부분 필수값 체크
		$(".required").each(function(index){
			if($(this).val() == null || $(this).val() == ""){
				alert($(this).parent().prev().text()+"<msg:txt mid='required2' mdef='은(는) 필수값입니다.' />");
				$(this).focus();
				ch =  false;
				return false;
			}
			return ch;
		});
		//필수값 문제 발생시 Stop
		if (!ch) {return ch;}
		
		var data = ajaxCall( "${ctx}/YearEduOrgApp.do?cmd=getYearEduOrgAppDetDupChk", $("#searchForm").serialize(),false);
		if ( data != null && data.DATA != null && data.DATA.cnt != null && Number(data.DATA.cnt) > 0){
			alert("<msg:txt mid='dupAppErrMsg' mdef='중복신청 건이 있어 신청 할 수 없습니다.'/>")
			return false;
		}

		return ch;
	}

	// 저장후 리턴함수
	function setValue() {
		var returnValue = false;
		try{
			
			// 관리자 또는 수신담당자 경우 지급정보 저장
			if( adminRecevYn == "Y" ){
				returnValue = true;
			}else{

				if ( authPg == "R" )  {return true;}
				
		        // 항목 체크 리스트
		        if ( !checkList() ) {return false;}
		        
		        // 신청서 저장
		        if ( authPg == "A" ){
		        	
					var rtn = eval("("+sheet1.GetSaveData("${ctx}/YearEduOrgApp.do?cmd=saveYearEduOrgAppDet", $("#searchForm").serialize())+")");
	
					if(rtn.Result.Code < 1) {
						alert(rtn.Result.Message);
						returnValue = false;
					} else {
						returnValue = true;
					}
	
				}
			}
		}
		catch(ex){
			alert("Error!" + ex);
			returnValue = false;
		}
		return returnValue;
	}
	

</script>
<style type="text/css">
label {
	vertical-align:-2px;padding-right:10px;
}
</style>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form name="searchForm" id="searchForm" method="post">
	<input type="hidden" id="searchApplSabun"	name="searchApplSabun"	 value=""/>
	<input type="hidden" id="searchApplName"	name="searchApplName"	 value=""/>
	<input type="hidden" id="searchApplSeq"		name="searchApplSeq"	 value=""/>
	<input type="hidden" id="searchApplYmd"		name="searchApplYmd"	 value=""/>
	<input type="hidden" id="orgCd"				name="orgCd"	     	 value=""/>

	<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid="appTitle" mdef="신청내용" /></li>
		</ul>
	</div>
	<table class="table">
		<colgroup>
			<col width="120px" />
			<col width="35%" />
			<col width="120px" />
			<col width="35%" />
		</colgroup>
		<tr>
			<th><tit:txt mid='103774' mdef='기준년도 '/></th>
			<td colspan="3">
				<select id="year" name="year" class="${selectCss} ${required} w150 " ${disabled}></select>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='113316' mdef='부서명'/></th>
			<td>
				<input type="text" id="orgNm" name="orgNm" class="${textCss} transparent w150" readonly />
			</td>
			<th><tit:txt mid='114405' mdef='본부명'/></th>
			<td>
				<input type="text" id="priorOrgNm" name="priorOrgNm" class="${textCss} transparent w150" readonly />
			</td>
		</tr>
	</table>
	<div class="h10">
	</div>
	<div class="sheet_title">
		<ul>
			<li class="btn">(단위:천원)</li>
		</ul>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "400px", "${ssnLocaleCd}"); </script>
	</form>
</div>
</body>
</html>