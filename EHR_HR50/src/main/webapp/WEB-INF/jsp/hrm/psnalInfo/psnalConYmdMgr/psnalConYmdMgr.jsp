<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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

		//IBsheet1 init
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",	Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>", 	Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0},
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>", 	Type:"${sSttTy}", 	Hidden:1,Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0},

			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",      Type:"Text",   Hidden:0,   Width:60,  Align:"Center",   ColMerge:0, SaveName:"sabun",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",      Type:"Popup",   Hidden:0,   Width:60,  Align:"Center",   ColMerge:0, SaveName:"name",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",      Type:"Text",   Hidden:0,   Width:130,  Align:"Left",   ColMerge:0, SaveName:"orgNm",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:50 },
			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",      Type:"Text",   Hidden:0,   Width:60,  Align:"Center",   ColMerge:0, SaveName:"jikchakNm",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",      Type:"Text",   Hidden:0,   Width:60,  Align:"Center",   ColMerge:0, SaveName:"jikweeNm",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",      Type:"Text",   Hidden:0,   Width:60,  Align:"Center",   ColMerge:0, SaveName:"jikgubNm",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='manageCd' mdef='사원구분'/>",   Type:"Text",   Hidden:0,   Width:60,  Align:"Center",   ColMerge:0, SaveName:"manageNm",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='contractSymd_V796' mdef='계약시작일'/>",  Type:"Date",   Hidden:0,   Width:100,  Align:"Center",   ColMerge:0, SaveName:"conRYmd",  KeyField:0, Format:"Ymd",  PointCount:0,   UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='contractEymd_V799' mdef='계약종료일'/>",  Type:"Date",   Hidden:0,   Width:100,  Align:"Center",   ColMerge:0, SaveName:"conEYmd",  KeyField:0, Format:"Ymd",  PointCount:0,   UpdateEdit:0,   InsertEdit:0 }


		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		//사원구분
 		var manageCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10030"), "");
 		$("#manageCd").html(manageCd[2]);
		$("#manageCd").select2({placeholder:""});
	    $("#manageCd").val(["E0002","E0003","E0013"]).trigger("change");

	    $("#manageCd").change(function(){
	    	if($(this).val() == null){
	    		 $(this).select2({placeholder:"선택"});
	    	}
	    });

		initPage();

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});
	// 기본 화면설정
	function initPage(){
		$("#searchSabunNameAlias").on("keyup", function(e) {
			if(e.keyCode == 13) {
				doAction1("Search");
			}
		});

	}

	/* IB시트 함수 */
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			$("#multiManageCd").val(getMultiSelect($("#manageCd").val()));
			sheet1.DoSearch( "${ctx}/PsnalConYmdMgr.do?cmd=getPsnalConYmdMgrList", $("#srchFrm").serialize() );
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
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

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
	<input type="hidden" id="multiManageCd" name="multiManageCd" value="" />
	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<th><tit:txt mid='112277' mdef='사번/성명 '/></th>
			<td>
				 <input id="searchSabunNameAlias" name="searchSabunNameAlias" type="text" class="text" />
			</td>
			<th><tit:txt mid='103784' mdef='사원구분'/></th>
			<td>
				<select id="manageCd" name="manageCd" multiple=""></select>
			</td>
			<td>
				<btn:a href="javascript:doAction1('Search')" id="btnSearch" css="btn dark" mid='110697' mdef="조회"/>
			</td>
		</tr>
		</table>
		</div>
	</div>

	</form>

	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<tr>
		<td>
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt">개인별계약기간관리</li>
					<li class="btn">
						<btn:a href="javascript:doAction1('Down2Excel')" 	css="btn outline_gray authR" mid='110698' mdef="다운로드"/>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
		</td>
	</tr>
	</table>
</div>

</body>
</html>
