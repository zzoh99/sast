<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>부서별월근태현황 세부내역</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("${popUpStatus}");
	var gPRow = "";
	var pGubun = "";
	
	$(function() {
		
		var arg = p.popDialogArgumentAll();
		$("#searchYm").val(arg["ym"].replace(/-/gi,""));
		$("#searchSabun").val(arg["sabun"]);
		
        $("#span_ym").html(arg["ym"]);
        $("#span_name").html(arg["name"]);
        $("#span_jikgubNm").html(arg["jikgubNm"]);
        $("#span_orgNm").html(arg["orgNm"]);
		
		//Cancel 버튼 처리
		$(".close").click(function(){
			p.self.close();
		});
		
        init_sheet1();

		doAction1("Search");
	});

	/*
	 * sheet Init
	 */
	function init_sheet1(){
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			//{Header:"삭제",				Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			//{Header:"상태",				Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			
            {Header:"근태종류",        Type:"Text",    Hidden:0, Width:200, Align:"Center", ColMerge:1, SaveName:"gntNm",          KeyField:0, Format:"",      UpdateEdit:0,   InsertEdit:0 },            {Header:"시작일",         Type:"Date",    Hidden:0, Width:80,  Align:"Center", ColMerge:1, SaveName:"sYmd",           KeyField:0, Format:"Ymd",   UpdateEdit:0,   InsertEdit:0 },
            {Header:"종료일",         Type:"Date",    Hidden:0, Width:80,  Align:"Center", ColMerge:1, SaveName:"eYmd",           KeyField:0, Format:"Ymd",   UpdateEdit:0,   InsertEdit:0 },
            {Header:"적용\n일수",      Type:"Text",    Hidden:0, Width:60,  Align:"Center",  ColMerge:1, SaveName:"closeDay",       KeyField:0, Format:"",      UpdateEdit:0,   InsertEdit:0 },
  		
        ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);


		$(window).smartresize(sheetResize); sheetInit();

	}
	/*Sheet Action*/
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": //조회
            sheet1.DoSearch( "${ctx}/OrgMonthWorkSta.do?cmd=getOrgMonthWorkStaPopList", $("#sheet1Form").serialize());
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
<div class="wrapper">

	<div class="popup_title">
		<ul>
			<li>개인별  월근태현황</li>
			<li class="close"></li>
		</ul>
	</div>
		
	<div class="popup_main">
        <form id="sheet1Form" name="sheet1Form" tabindex="1">
	        <input type="hidden" id="searchYm"       name="searchYm" />
	        <input type="hidden" id="searchSabun"    name="searchSabun" />
	        	        
			<div class="sheet_search outer">
				<table>
				<tr>
                    <th>대상년월</th>
                    <td>
                        <label id="span_ym"></label>
                    </td>
					<th>성명</th>
					<td>
						<label id="span_name"></label>
					</td>
					<th>직급</th>
					<td>
						<label id="span_jikgubNm"></label>
					</td>
					<th>소속</th>
					<td>
						<label id="span_orgNm"></label>
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
				<li id="txt" class="txt">개인별  월근태현황</li>
				<li class="btn">&nbsp;</li>
			</ul>
			</div>
		</div>
		<script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script>
				
		<div class="popup_button outer">
			<ul>
				<li>
					<a href="javascript:p.self.close();" class="gray large authR">닫기</a>
				</li>
			</ul>
		</div>	
	</div>
</div>
</body>
</html>
