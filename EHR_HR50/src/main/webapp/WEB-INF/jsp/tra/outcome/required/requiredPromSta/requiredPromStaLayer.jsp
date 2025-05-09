<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>승격대상자 필수교육 이력</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";
	
	$(function() {
		const modal = window.top.document.LayerModalUtility.getModal('requiredPromStaLayer');
		var arg = modal.parameters;
		$("#searchBaseYmd").val(arg["baseYmd"]);
		$("#searchSabun").val(arg["sabun"]);
		$("#searchJikgubCd").val(arg["jikgubCd"]);
		$("#searchPromCnt").val(arg["promCnt"]);
		
		$("#span_name").html(arg["name"]);
		$("#span_jikgubNm").html(arg["jikgubNm"]);
		$("#span_delayGubun").html(arg["delayGubun"]);

		createIBSheet3(document.getElementById('requiredPromStaLayerSht1-wrap'), "requiredPromStaLayerSht1", "100%", "100%", "${ssnLocaleCd}");
        init_requiredPromStaLayerSht1();

		doAction1("Search");
	});

	/*
	 * sheet Init
	 */
	function init_requiredPromStaLayerSht1(){
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:7};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			//{Header:"삭제",				Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			//{Header:"상태",				Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"과정난이도",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"eduLevel",		KeyField:0,	Format:"",	Edit:0 },
			{Header:"과정명",			Type:"Popup",		Hidden:0,	Width:300,	Align:"Left",	ColMerge:0,	SaveName:"eduCourseNm",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:1 },
			{Header:"교육시작일",		Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"eduSYmd",			KeyField:1,	Format:"Ymd",	Edit:0},	
			{Header:"교육종료일",		Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"eduEYmd",			KeyField:1,	Format:"Ymd",	Edit:0},	
			
			{Header:"이수\n여부",		Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"eduConfirmType",	KeyField:0,	Format:"",		UpdateEdit:1,	InsertEdit:1 },
			
			//Hidden
			{Header:"Hidden",	Hidden:1,	SaveName:"eduSeq"},
			{Header:"Hidden",	Hidden:1,	SaveName:"eduEventSeq"},
			
        ]; IBS_InitSheet(requiredPromStaLayerSht1, initdata);requiredPromStaLayerSht1.SetEditable("${editable}");requiredPromStaLayerSht1.SetVisible(true);requiredPromStaLayerSht1.SetCountPosition(4);


		//공통코드 한번에 조회
		var grpCds = "L10090";
		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists&useYn=Y","grpCd="+grpCds,false).codeList, "전체");
		requiredPromStaLayerSht1.SetColProperty("eduLevel",  	{ComboText:"|"+codeLists["L10090"][0], ComboCode:"|"+codeLists["L10090"][1]} ); //과정난이도
		requiredPromStaLayerSht1.SetColProperty("eduConfirmType",	{ComboText:"|수료|미수료", ComboCode:"|1|0"} );
		
		
		$(window).smartresize(sheetResize); sheetInit();

	}
	/*Sheet Action*/
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": //조회

			var sXml = requiredPromStaLayerSht1.GetSearchData("${ctx}/RequiredPromSta.do?cmd=getRequiredPromStaPopList", $("#requiredPromStaLayerSht1Form").serialize() );
			sXml = replaceAll(sXml,"eduConfirmTypeFontColor", "eduConfirmType#FontColor");
			requiredPromStaLayerSht1.LoadSearchData(sXml );
            break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(requiredPromStaLayerSht1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			requiredPromStaLayerSht1.Down2Excel(param);
			break;
		}
    } 
	
	

	//-----------------------------------------------------------------------------------
	//		requiredPromStaLayerSht1 이벤트
	//-----------------------------------------------------------------------------------
	// 조회 후 에러 메시지 
	function requiredPromStaLayerSht1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "") alert(Msg);    
			sheetResize();
	  	}catch(ex){
	  		alert("OnSearchEnd Event Error : " + ex);
	  	}
	}

</script>
<style type="text/css">
label {vertical-align: middle;}
</style>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
	<div class="modal_body">
        <form id="requiredPromStaLayerSht1Form" name="requiredPromStaLayerSht1Form" tabindex="1">
	        <input type="hidden" id="searchBaseYmd"  name="searchBaseYmd" />
	        <input type="hidden" id="searchSabun"    name="searchSabun" />
	        <input type="hidden" id="searchJikgubCd" name="searchJikgubCd" />
	        <input type="hidden" id="searchPromCnt"  name="searchPromCnt" />
	        	        
			<div class="sheet_search outer">
				<table>
				<tr>
					<th>성명</th>
					<td>
						<label id="span_name"></label>
					</td>
					<th>직급</th>
					<td>
						<label id="span_jikgubNm"></label>
					</td>
					<th>지체여부</th>
					<td>
						<label id="span_delayGubun"></label>
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
				<li id="txt" class="txt">승격대상자  필수교육 이력</li>
				<li class="btn">&nbsp;</li>
			</ul>
			</div>
		</div>
		<div id="requiredPromStaLayerSht1-wrap"></div>
	</div>
	<div class="modal_footer">
		<a href="javascript:closeCommonLayer('requiredPromStaLayer')" class="gray large authR">닫기</a>
	</div>
</div>
</body>
</html>
