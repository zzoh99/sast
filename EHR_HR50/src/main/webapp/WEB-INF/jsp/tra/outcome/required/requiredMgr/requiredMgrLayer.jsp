<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {
		const modal = window.top.document.LayerModalUtility.getModal('requiredMgrLayer');
		var arg = modal.parameters;

		createIBSheet3(document.getElementById('requiredMgrLayerSht1-wrap'), "requiredMgrLayerSht1", "100%", "100%", "${ssnLocaleCd}");

		//교육구분 선택 시
		$("#searchGubunCd, #searchEduLevel").on("change", function(e) {
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
		
		$("#searchEduYm").datepicker2({ymonly:true,onReturn:function(){doAction1("Search");}});

		//Sheet 초기화
		init_requiredMgrLayerSht1();

		doAction1("Search");

	});

	//Sheet 초기화
	function init_requiredMgrLayerSht1(){

		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"교육구분",		Type:"Combo",		Hidden:0,	Width:170,	Align:"Center",	ColMerge:0,	SaveName:"gubunCd",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1 },
			{Header:"과정명",			Type:"Text", 		Hidden:0,	Width:300,	Align:"Left",	ColMerge:0,	SaveName:"eduCourseNm",		KeyField:1,	Format:"",	Edit:0 },
			{Header:"과정난이도",		Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"eduLevel",		KeyField:0,	Format:"",			UpdateEdit:0,	InsertEdit:0 },
			{Header:"입과월",			Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"eduYm",			KeyField:1,	CalcLogic:"",	Format:"Ym",	Edit:0},
			{Header:"직급",			Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1 },
			{Header:"직급년차",		Type:"Int",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"jikgubYear",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2 },
			{Header:"직무명",			Type:"Popup",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"jobNm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1},
			

			//Hidden
			{Header:"Hidden",   Hidden:1,   SaveName:"eduSeq"},
			{Header:"Hidden",	Hidden:1,	SaveName:"eduEventSeq"},
			{Header:"Hidden",	Hidden:1,	SaveName:"eduSYmd"},
			{Header:"Hidden",	Hidden:1,	SaveName:"eduEYmd"},
			
        ]; IBS_InitSheet(requiredMgrLayerSht1, initdata);requiredMgrLayerSht1.SetEditable("${editable}");requiredMgrLayerSht1.SetVisible(true);requiredMgrLayerSht1.SetCountPosition(4);

		//공통코드 한번에 조회
		var grpCds = "L16010,H20010,L10090";
		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists&useYn=Y","grpCd="+grpCds,false).codeList, "전체");
		requiredMgrLayerSht1.SetColProperty("gubunCd",  	{ComboText:"|"+codeLists["L16010"][0], ComboCode:"|"+codeLists["L16010"][1]} ); //교육구분 
		requiredMgrLayerSht1.SetColProperty("jikgubCd",  	{ComboText:"|"+codeLists["H20010"][0], ComboCode:"|"+codeLists["H20010"][1]} ); //직급
		requiredMgrLayerSht1.SetColProperty("eduLevel",  	{ComboText:"|"+codeLists["L10090"][0], ComboCode:"|"+codeLists["L10090"][1]} ); //과정난이도
		

		// 교육구분
		$("#searchGubunCd").html(codeLists["L16010"][2]);
		// 직급
		$("#searchJikgubCd").html(codeLists["H20010"][2]);
		//과정난이도
		$("#searchEduLevel").html(codeLists["L10090"][2]);
		
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
	        	requiredMgrLayerSht1.DoSearch( "${ctx}/RequiredMgr.do?cmd=getRequiredMgrPopList", $("#requiredMgrLayerSht1Form").serialize() );
	            break;
	        case "Down2Excel":  //엑셀내려받기
	            requiredMgrLayerSht1.Down2Excel();
	            break;
	    }
	}
	
	//---------------------------------------------------------------------------------------------------------------
	// requiredMgrLayerSht1 Event
	//---------------------------------------------------------------------------------------------------------------

	// 조회 후 에러 메시지
	function requiredMgrLayerSht1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	
	function requiredMgrLayerSht1_OnDblClick(Row, Col){
		var rv = new Array();
		
		rv["eduSeq"]		= requiredMgrLayerSht1.GetCellValue(Row, "eduSeq");
		rv["eduEventSeq"]	= requiredMgrLayerSht1.GetCellValue(Row, "eduEventSeq");
		rv["eduLevel"]		= requiredMgrLayerSht1.GetCellValue(Row, "eduLevel");
		rv["eduYm"]		    = requiredMgrLayerSht1.GetCellValue(Row, "eduYm");
		rv["eduSYmd"]		= requiredMgrLayerSht1.GetCellValue(Row, "eduSYmd");
		rv["eduEYmd"]		= requiredMgrLayerSht1.GetCellValue(Row, "eduEYmd");
		rv["eduCourseNm"]	= requiredMgrLayerSht1.GetCellValue(Row, "eduCourseNm");

		const modal = window.top.document.LayerModalUtility.getModal('requiredMgrLayer');
		modal.fire('requiredMgrLayerTrigger', rv).hide();
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
	<div class="modal_body">
        <form id="requiredMgrLayerSht1Form" name="requiredMgrLayerSht1Form" tabindex="1">
			<div class="sheet_search outer">
				<table>
					<tr>
						<th>기준년도</th>
						<td>
							<input type="text" id="searchYear" name="searchYear" class="text required w70 center" value="${curSysYear}" maxlength="4"/>
						</td>
						<th>교육구분</th>
						<td>
							<select id="searchGubunCd" name="searchGubunCd"></select>
						</td>
						<th>과정난이도</th>
						<td>
							<select id="searchEduLevel" name="searchEduLevel"></select>
						</td>
					</tr>
					<tr>
						<th>입과월</th>
						<td>
							<input type="text" id="searchEduYm" name="searchEduYm" value="" class="date2"/>
						</td>
						<th>과정명</th>
						<td>
							<input type="text"  id="searchEduCourseNm" name ="searchEduCourseNm" class="text w150" />
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
					<li id="txt" class="txt">필수교육과정</li>

				</ul>
			</div>
		</div>
		<div id="requiredMgrLayerSht1-wrap"></div>
	</div>
	<div class="modal_footer">
		<a href="javascript:closeCommonLayer('requiredMgrLayer')" class="btn outline_gray">닫기</a>
	</div>
</div>
</body>
</html>
