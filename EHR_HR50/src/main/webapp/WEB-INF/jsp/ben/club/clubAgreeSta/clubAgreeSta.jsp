<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head><title>급여공제동의이력</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";
	var grpCd           = "${grpCd}";
	
	$(function() {

		//기준일자 날짜형식, 날짜선택 시 
		$("#searchYmd").datepicker2({
			onReturn:function(){
				getClubAgreeStaClubCode();
				doAction1("Search");
			}
		});
		
		$("#searchYmd").on("keyup", function(event) {
			if( event.keyCode == 13) {
				getClubAgreeStaClubCode();
				doAction1("Search");
			}
		});
		
		$("#searchSabunName").on("keyup", function(event) {
			if( event.keyCode == 13) {
				doAction1("Search");
			}
		});

		$("#searchClubSeqCd").on("change", function(e) {
			doAction1("Search");
		});
		
		getClubAgreeStaClubCode();
		
		init_sheet();

		doAction1("Search");
	});
	
	function init_sheet(){ 
		
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly,FrozenCol:0,FrozenColRight:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		
		initdata.Cols = [
			
				{Header:"No|No",				Type:"${sNoTy}",  Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo",		Sort:0 },
				{Header:"동호회|동호회",		Type:"Text",	Hidden:0,	Width:140,	Align:"Center",	ColMerge:0,	SaveName:"clubNm",		KeyField:0,	Format:"",		Edit:0 },
				{Header:"회장|회장",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabunAView",	KeyField:0,	Format:"",		Edit:0 },
				
				{Header:"사번|사번",			Type:"Text",   	Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"sabun", 			Edit:0},
				{Header:"성명|성명",			Type:"Text",   	Hidden:0, Width:80,		Align:"Center", ColMerge:0,  SaveName:"name", 			Edit:0},
				{Header:"부서|부서",			Type:"Text",   	Hidden:0, Width:90, 	Align:"Left",   ColMerge:0,  SaveName:"orgNm", 			Edit:0},
				
				{Header:"시작일자|시작일자",		Type:"Date",	Hidden:0,	Width:85,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:0,	Format:"Ymd",	Edit:0 },
				{Header:"종료일자|종료일자",		Type:"Date",	Hidden:0,	Width:85,	Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	Format:"Ymd",	Edit:0 },
				{Header:"급여공제동의일시|급여공제동의일시",Type:"Date",	Hidden:0,	Width:110,	Align:"Center",	ColMerge:0,	SaveName:"agreeDate",	KeyField:0,	Format:"YmdHm",	Edit:0 },
				{Header:"서명이미지|서명이미지", 	Type:"Image", Hidden:0, Width:80,Align:"Center", ColMerge:1, SaveName:"fileSeqUrl", 	Format:"", 		UpdateEdit:0, InsertEdit:0, ImgWidth:80, ImgHeight:30},
				
				//Hidden
  				{Header:"Hidden",	Hidden:1, SaveName:"fileSeq"},
	  			
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		sheet1.SetDataAlternateBackColor(sheet1.GetDataBackColor()); //홀짝 배경색 같게
		sheet1.SetEditableColorDiff(1); //편집불가 배경색 적용안함
		
		$(window).smartresize(sheetResize); sheetInit();
	}
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var optionCnt = $("#searchClubSeqCd option").length;
			if (optionCnt && optionCnt <= 1) {sheet1.RemoveAll(); break;} //옵션개수가 전체뿐이면 조회 안함
			var sXml = sheet1.GetSearchData("${ctx}/ClubAgreeSta.do?cmd=getClubAgreeStaList", $("#sheet1Form").serialize() );
			sheet1.LoadSearchData(sXml );
			break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param); 
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	
	function getClubAgreeStaClubCode(){
		var param = "&searchYmd="+$("#searchYmd").val();
		var clubCodeList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getClubAgreeStaClubCode"+param,false).codeList, "전체");
		$("#searchClubSeqCd").html(clubCodeList[2]);
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
	<!-- 조회조건 -->
	<div class="sheet_search outer">
		<table>
		<tr>
			<th>기준일자</th>
			<td>
				<input type="text" id="searchYmd" name="searchYmd" class="date2 w80" value="${curSysYyyyMMddHyphen}"/>
			</td>
            <th><span>동호회</span></th>
			<td>
				<select id="searchClubSeqCd" name="searchClubSeqCd"></select>
			</td>
			<th><span><tit:txt mid="104330" mdef="사번/성명" /></span></th>
			<td>
				<input type="text" id="searchSabunName" name="searchSabunName" class="text" style="ime-mode:active;" />
			</td>
			<td>
				<btn:a href="javascript:doAction1('Search')" mid="search" mdef="조회" css="btn dark"/>
			</td>
		</tr>
		</table>
	</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li id="txt" class="txt">동호회 급여공제동의이력</li> 
				<li class="btn"> 
					<btn:a href="javascript:doAction1('Down2Excel');" 	css="btn outline-gray authR" mid='down2excel' mdef="다운로드"/>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
