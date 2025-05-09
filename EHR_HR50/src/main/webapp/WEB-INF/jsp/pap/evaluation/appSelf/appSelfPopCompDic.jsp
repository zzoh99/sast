<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>평가그룹팝업</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("${popUpStatus}");

	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
				{Header:"No"			,Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
				{Header:"삭제"			,Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center", ColMerge:0,	SaveName:"sDelete" },
				{Header:"상태"			,Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center", ColMerge:0,	SaveName:"sStatus" },

				{Header:"역량구분"		,Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:1,	SaveName:"mainAppTypeNm",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:500 },
				{Header:"역량명"		,Type:"Text",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:1,	SaveName:"competencyNm",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:500 },
				{Header:"내용"		,Type:"Text",	Hidden:0,	Width:200,	Align:"left",	ColMerge:1,	SaveName:"memo",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:500, Wrap:1 },
				{Header:"역량코드"		,Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"competencyCd",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:500 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetUnicodeByte(3);

		var mainAppTypeList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00007"), "전체");

		$("#searchMainAppType").html(mainAppTypeList[2]);

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	$(function() {
		$(".close, #close").click(function() {
			p.self.close();
		});

        $("#searchCompetencyNm").bind("keyup",function(event){
			if( event.keyCode == 13){
		 		doAction1("Search");
			}
		});

		$("#searchMainAppType").change(function() {
			doAction1("Search");
		});
	});

	function doAction1(sAction){
		switch(sAction){
		case "Search":		//조회
			sheet1.DoSearch("${ctx}/EvaMain.do?cmd=getAppSelfPopCompDicList", $("#sheet1Form").serialize());
			break;
		}
	}

	//조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); }
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="popup_title">
	<ul>
		<li>역량항목</li>
		<li class="close"></li>
	</ul>
	</div>

	<div class="popup_main">
		<form id="sheet1Form" name="sheet1Form" >
	        <div class="sheet_search outer">
	            <div>
	            <table>
	            <tr>
	                <td>
	                	<span>역량구분</span>
	                	<select id="searchMainAppType" name="searchMainAppType">
	                	</select>
	                </td>
	                <td>
	                	<spna>역량명</spna>
	                	<input type="text" class="text" id="searchCompetencyNm" name="searchCompetencyNm">
	                </td>
	                <td>
	                    <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a>
	                </td>
	            </tr>
	            </table>
	            </div>
	        </div>
		</form>
		<div class="inner">
			<div class="sheet_title">
			<ul>
				<li id="txt" class="txt">역량항목조회</li>
			</ul>
			</div>
		</div>
		<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>

		<div class="popup_button outer">
		<ul>
			<li>
				<a id="close" class="gray large">닫기</a>
			</li>
		</ul>
		</div>
	</div>
</div>
</body>
</html>