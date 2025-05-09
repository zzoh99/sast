<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!-- <%@ page import="com.hr.common.util.DateUtil" %> -->
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {
		
		// 계약서 유형
		var contTypeList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","Z00001"), "");
		
		// 항목형식
		var eleFormatCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H90415"), "");

		//IBsheet1 init
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",	Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제", 	Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0},
			{Header:"상태", 	Type:"${sSttTy}", 	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0},

			{Header:"항목코드",		Type:"Text",   Hidden:0,   Width:150,  Align:"Center",   ColMerge:0, SaveName:"eleCd",        KeyField:1, Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:50 },
			{Header:"항목명",			Type:"Text",   Hidden:0,   Width:150,  Align:"Center",   ColMerge:0, SaveName:"eleNm",        KeyField:1, Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:500 },
			{Header:"항목형식",		Type:"Combo",  Hidden:0,   Width:150,  Align:"Center",   ColMerge:0, SaveName:"eleFormatCd",  KeyField:0, Format:"",         PointCount:0,   UpdateEdit:1,   InsertEdit:1 },
			{Header:"SEQ",			Type:"Int",    Hidden:0,   Width:60,   Align:"Center",   ColMerge:0, SaveName:"seq",          KeyField:0, Format:"Integer",  PointCount:0,   UpdateEdit:1,   InsertEdit:1 },
			{Header:"비고",			Type:"Text",   Hidden:0,   Width:300,  Align:"Left",     ColMerge:0, SaveName:"note",         KeyField:0, Format:"",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
			{Header:"계약서유형",		Type:"Text",   Hidden:1,   Width:100,  Align:"Center",   ColMerge:0, SaveName:"contType",     KeyField:1, Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0 }

		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);
		sheet1.SetUnicodeByte(3);
		
		sheet1.SetColProperty("eleFormatCd", 			{ComboText:"|"+eleFormatCdList[0], ComboCode:"|"+eleFormatCdList[1]} );
		$(window).smartresize(sheetResize); sheetInit();

		$("#searchContType").html( contTypeList[2] );
		$("#searchContType").bind("change", function(event) {
			doAction1("Search");
		});

		doAction1("Search");
	});

	/* IB시트 함수 */
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/EmpContractEleMgr.do?cmd=getEmpContractEleMgrList", $("#srchFrm").serialize() );
			break;
		case "Save":
			//중복 체크 (변수 : "컬럼명|컬럼명")
			if(!dupChk(sheet1,"eleCd|contType", true, true)){break;}
			IBS_SaveName(document.srchFrm,sheet1);
			sheet1.DoSave( "${ctx}/EmpContractEleMgr.do?cmd=saveEmpContractEleMgr", $("#srchFrm").serialize());
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			sheet1.SetCellValue(row, "contType", $("#searchContType").val());
			break;
		case "Copy":
			var row = sheet1.DataCopy();
			break;
		}
	}

	// 조회 후 이벤트
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != "") alert(Msg);

			//작업

			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 이벤트
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != "") alert(Msg);

			//작업

			doAction1("Search");
		}catch(ex){
			alert("OnSaveEnd Event Error : " + ex);
		}
	}
	
	function sheet1_OnChange(Row, Col, Value) {
		try{
			//사원검색
			switch(sheet1.ColSaveName(Col)){
				case "eleNm":
					var eleCd = "";
					if(sheet1.GetCellValue(Row,"eleNm") != "") {
						eleCd = "#" + sheet1.GetCellValue(Row,"eleNm") + "#";
					}
					sheet1.SetCellValue(Row, "eleCd", eleCd);
					break;
			}
			
			
		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}

</script>
</head>
<body class="bodywrap">
	<div class="wrapper">
		<form id="srchFrm" name="srchFrm" >
			<div class="sheet_search outer">
				<div>
					<table>
						<tr>
							<th>계약서 유형 </th>
							<td>
								 <select id="searchContType" name="searchContType" class="box" ></select>
							</td>
							<td>
								<a href="javascript:doAction1('Search')" id="btnSearch" class="btn dark">조회</a>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</form>
	
	 	<div class="explain">
			<div class="title">유의사항</div>
			<div class="txt">
				※ 한글형식금액 입력 항목의 경우 숫자형식금액항목 이름에 "<span class="f_point strong">_한글</span>"로 설정하시면 [<span class="f_point strong">계약서배포</span>] 기능에서 금액 입력 시 자동 변환됩니다.<br />
				&nbsp;&nbsp;- 숫자형식금액 항목명 : <span class="f_point strong">기본연봉</span><br />
				&nbsp;&nbsp;- 한글형식금액 항목명 : <span class="f_point strong">기본연봉_한글</span><br />
				※ 항목형식을 날짜로 설정하시면 [<span class="f_point strong">계약서배포</span>] 기능에서 날짜 입력 시 OOOO년 O월 O일 형식으로 자동 변환됩니다.<br />
				&nbsp;&nbsp;- <span class="f_point strong">20190101</span> or <span class="f_point strong">190101</span> or <span class="f_point strong">2019-01-01</span> or <span class="f_point strong">19-01-01</span> → <span class="f_point strong">2019년 1월 1일</span>
			</div>
		</div>
	
		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="outer">
					<div class="sheet_title">
					<ul>
						<li class="txt">계약서항목관리</li>
						<li class="btn">
							<a href="javascript:doAction1('Insert')" class="btn outline_gray authA">입력</a>
							<a href="javascript:doAction1('Copy')" 	class="btn outline_gray authA">복사</a>
							<a href="javascript:doAction1('Save')" 	class="btn filled authA">저장</a>
						</li>
					</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet1", "100%", "70%"); </script>
			</td>
		</tr>
		</table>
	</div>
</body>
</html>