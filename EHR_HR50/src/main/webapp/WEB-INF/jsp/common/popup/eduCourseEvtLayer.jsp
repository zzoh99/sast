<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<script type="text/javascript">

	$(function() {
		const modal = window.top.document.LayerModalUtility.getModal('eduCourseEvtLayer');
		var arg = modal.parameters;
		if( arg != undefined ) {
			$("#searchEduBranchCd").val(arg["searchEduBranchCd"]);
			$("#searchEduMBranchCd").val(arg["searchEduMBranchCd"]);
		}
		
		//교육구분 선택 시
		$("#searchEduBranchCd, #searchEduMBranchCd").on("change", function(e) {
			doAction1("Search");
		})
		// 숫자만 입력가능
		$("#searchYear").keyup(function() {
			makeNumber(this,'A');
			if( event.keyCode == 13) {
				doAction1("Search");
			}
		});

		$("#searchEduCourseNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		//Sheet 초기화
		createIBSheet3(document.getElementById('eduCourseEvtLayerSht1-wrap'), "eduCourseEvtLayerSht1", "100%", "100%", "${ssnLocaleCd}");
		init_eduCourseEvtLayerSht1();

		doAction1("Search");

	});

	//Sheet 초기화
	function init_eduCourseEvtLayerSht1(){

		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"과정명",			Type:"Text", 		Hidden:0,	Width:300,	Align:"Left",	ColMerge:0,	SaveName:"eduCourseNm",		KeyField:1,	Format:"",	Edit:0 },
			{Header:"교육구분",		Type:"Combo",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"eduBranchCd",		KeyField:1,	Format:"",		Edit:0 },
			{Header:"교육분류",		Type:"Combo",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"eduMBranchCd",	KeyField:1,	Format:"",		Edit:0 },
			{Header:"교육시작일",		Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"eduSYmd",			KeyField:1,	CalcLogic:"",	Format:"Ymd",	Edit:0},	
			{Header:"교육종료일",		Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"eduEYmd",			KeyField:1,	CalcLogic:"",	Format:"Ymd",	Edit:0},	

			//Hidden
			{Header:"Hidden",   Hidden:1,   SaveName:"eduSeq"},
			{Header:"Hidden",	Hidden:1,	SaveName:"eduEventSeq"},
			{Header:"Hidden",	Hidden:1,	SaveName:"inOutType"},
			{Header:"Hidden",	Hidden:1,	SaveName:"eduMethodCd"},
			{Header:"Hidden",	Hidden:1,	SaveName:"jobCd"},
			{Header:"Hidden",	Hidden:1,	SaveName:"jobNm"},
			{Header:"Hidden",	Hidden:1,	SaveName:"realExpenseMon"},
			{Header:"Hidden",	Hidden:1,	SaveName:"laborApplyYn"},
			{Header:"Hidden",	Hidden:1,	SaveName:"eduOrgCd"},
			{Header:"Hidden",	Hidden:1,	SaveName:"eduOrgNm"},
			{Header:"Hidden",	Hidden:1,	SaveName:"eduLevel"},
			
        ]; IBS_InitSheet(eduCourseEvtLayerSht1, initdata);eduCourseEvtLayerSht1.SetEditable("${editable}");eduCourseEvtLayerSht1.SetVisible(true);eduCourseEvtLayerSht1.SetCountPosition(4);


		//공통코드 한번에 조회
		var grpCds = "L10010,L10015";
		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","useYn=Y&grpCd="+grpCds,false).codeList, "전체");

		eduCourseEvtLayerSht1.SetColProperty("eduBranchCd", 	{ComboText:"|"+codeLists["L10010"][0], ComboCode:"|"+codeLists["L10010"][1]} );
		eduCourseEvtLayerSht1.SetColProperty("eduMBranchCd", 	{ComboText:"|"+codeLists["L10015"][0], ComboCode:"|"+codeLists["L10015"][1]} );
		$("#searchEduBranchCd").html(codeLists["L10010"][2]);
		$("#searchEduMBranchCd").html(codeLists["L10015"][2]);
		
		$(window).smartresize(sheetResize); sheetInit();

	}
	
	function checkList(){
		if( $("#searchYear").val() == "" ){
			alert("기준년도를 입력 해주세요");
			$("#searchYear").focus();
			return false;
		}

		if( $("#searchYear").val().length != 4 ){
			alert("기준년도를 정확히 입력 해주세요");
			$("#searchYear").focus();
			return false;
		}
		return true;
	}
	
	//Sheet1 Action
	function doAction1(sAction){
	    switch(sAction){
	        case "Search":      //조회
				if( !checkList() ) return;
	        	eduCourseEvtLayerSht1.DoSearch( "${ctx}/EduCourseMgr.do?cmd=getEduEventMgrList", $("#eduCourseEvtLayerSht1Form").serialize() );
	            break;
	        case "Down2Excel":  //엑셀내려받기
	            eduCourseEvtLayerSht1.Down2Excel();
	            break;
	    }
	}
	
	//---------------------------------------------------------------------------------------------------------------
	// eduCourseEvtLayerSht1 Event
	//---------------------------------------------------------------------------------------------------------------

	// 조회 후 에러 메시지
	function eduCourseEvtLayerSht1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	
	function eduCourseEvtLayerSht1_OnDblClick(Row, Col){
		var rv = new Array();
		
		rv["eduSeq"]		= eduCourseEvtLayerSht1.GetCellValue(Row, "eduSeq");
		rv["eduEventSeq"]	= eduCourseEvtLayerSht1.GetCellValue(Row, "eduEventSeq");
		rv["eduSYmd"]		= eduCourseEvtLayerSht1.GetCellValue(Row, "eduSYmd");
		rv["eduEYmd"]		= eduCourseEvtLayerSht1.GetCellValue(Row, "eduEYmd");
		rv["eduCourseNm"]	= eduCourseEvtLayerSht1.GetCellValue(Row, "eduCourseNm");
		rv["eduBranchCd"]	= eduCourseEvtLayerSht1.GetCellValue(Row, "eduBranchCd");
		rv["eduMBranchCd"]	= eduCourseEvtLayerSht1.GetCellValue(Row, "eduMBranchCd");
		rv["inOutType"]		= eduCourseEvtLayerSht1.GetCellValue(Row, "inOutType");
		rv["eduMethodCd"]	= eduCourseEvtLayerSht1.GetCellValue(Row, "eduMethodCd");
		rv["jobCd"]			= eduCourseEvtLayerSht1.GetCellValue(Row, "jobCd");
		rv["jobNm"]			= eduCourseEvtLayerSht1.GetCellValue(Row, "jobNm");
		rv["eduOrgCd"]		= eduCourseEvtLayerSht1.GetCellValue(Row, "eduOrgCd");
		rv["eduOrgNm"]		= eduCourseEvtLayerSht1.GetCellValue(Row, "eduOrgNm");
		rv["eduLevel"]		= eduCourseEvtLayerSht1.GetCellValue(Row, "eduLevel");
		rv["realExpenseMon"]= eduCourseEvtLayerSht1.GetCellValue(Row, "realExpenseMon");
		rv["laborApplyYn"]	= eduCourseEvtLayerSht1.GetCellValue(Row, "laborApplyYn");

		const modal = window.top.document.LayerModalUtility.getModal('eduCourseEvtLayer');
		modal.fire('eduCourseEvtLayerTrigger', rv).hide();
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
	<div class="modal_body">
        <form id="eduCourseEvtLayerSht1Form" name="eduCourseEvtLayerSht1Form" tabindex="1">
		<div class="sheet_search outer">
			<table>
				<tr>
					<th>기준년도</th>
					<td>
						<input type="text" id="searchYear" name="searchYear" class="text required w70 center" value="${curSysYear}"/>
					</td>
					<th>교육구분</th>
					<td>
						<select id="searchEduBranchCd" name="searchEduBranchCd"></select>
					</td>
				</tr>
				<tr>	
					<th>과정명</th>
					<td>
					    <input type="text"  id="searchEduCourseNm" name ="searchEduCourseNm" class="text w150" />
					</td>
					<th>교육분류</th>
					<td>
						<select id="searchEduMBranchCd" name="searchEduMBranchCd"></select>
					</td>
					<td>
						<a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a>
					</td>
				</tr>
			</table>
		</div>
		</form>
		<div class="inner">
			<div class="sheet_title">
				<ul>
					<li id="txt" class="txt">교육과정</li>
				</ul>
			</div>
		</div>
		<div id="eduCourseEvtLayerSht1-wrap"></div>
	</div>
	<div class="modal_footer">
		<ul>
			<li>
				<a href="javascript:closeCommonLayer('eduCourseEvtLayer');" class="gray large">닫기</a>
			</li>
		</ul>
	</div>
</div>
</body>
</html>
