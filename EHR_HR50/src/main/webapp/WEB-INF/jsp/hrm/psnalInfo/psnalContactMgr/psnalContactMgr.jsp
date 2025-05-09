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
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>", 	Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0},
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>", 	Type:"${sSttTy}", 	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0},

			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",      Type:"Text",   Hidden:0,   Width:60,  Align:"Center",   ColMerge:0, SaveName:"sabun",  KeyField:1, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
			{Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",      Type:"Text",   Hidden:0,   Width:60,  Align:"Center",   ColMerge:0, SaveName:"orgNm",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:50 },
			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",      Type:"Text",   Hidden:0,   Width:60,  Align:"Center",   ColMerge:0, SaveName:"jikchakNm",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",      Type:"Text",   Hidden:0,   Width:60,  Align:"Center",   ColMerge:0, SaveName:"name",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",      Type:"Text",   Hidden:Number("${aliasHdn}"),   Width:60,  Align:"Center",   ColMerge:0, SaveName:"alias",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",      Type:"Text",   Hidden:Number("${jwHdn}"),   Width:60,  Align:"Center",   ColMerge:0, SaveName:"jikweeNm",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",      Type:"Text",   Hidden:Number("${jgHdn}"),   Width:60,  Align:"Center",   ColMerge:0, SaveName:"jikgubNm",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='2017082800776' mdef='연락처구분'/>",     Type:"Combo",   Hidden:0,   Width:100,  Align:"Center",   ColMerge:0, SaveName:"contType",  KeyField:1, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1 },
			{Header:"<sht:txt mid='telNo' mdef='연락처'/>",      Type:"Text",   Hidden:0,   Width:160,  Align:"Left",   ColMerge:0, SaveName:"contAddress",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1 },


		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);

		initPage();

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");

		// 이름 입력 시 자동완성
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue){
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow, "sabun",			rv["sabun"]);
						sheet1.SetCellValue(gPRow, "orgNm",			rv["orgNm"]);
						sheet1.SetCellValue(gPRow, "jikchakNm",		rv["jikchakNm"]);
						sheet1.SetCellValue(gPRow, "name",			rv["name"]);
					}
				}
			]
		});		

	});

	// 기본 화면설정
	function initPage(){

		//연락처구분
		var contType = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H12410"), "");

		sheet1.SetColProperty("contType", 		{ComboText:"|"+contType[0], ComboCode:"|"+contType[1]} );
		$("#contType").html(contType[2]);

		//연락처구분 멀티셀렉트
		$("#contType").select2({placeholder: "<tit:txt mid='111914' mdef='선택'/>"});
		
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
			//멀티셀렉트 검색조건 처리
			$("#searchMultiContType").val( getMultiSelect($("#contType").val()) );
			sheet1.DoSearch( "${ctx}/PsnalContactMgr.do?cmd=getPsnalContactMgrList", $("#srchFrm").serialize() );
			break;
		case "Save":
			//중복 체크 (변수 : "컬럼명|컬럼명")
        	if(!dupChk(sheet1,"", true, true)){break;}
        	IBS_SaveName(document.srchFrm,sheet1);
        	sheet1.DoSave( "${ctx}/PsnalContactMgr.do?cmd=savePsnalContactMgr", $("#srchFrm").serialize());
			break;
		case "Insert":
			sheet1.SelectCell(sheet1.DataInsert(0), "컬럼명");
			break;
		case "Copy":
			sheet1.DataCopy();
        	//sheet1.SetCellValue( Row, "PK컬럼", "" );
			break;
		case "Clear":
			sheet1.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
		case "DownTemplate":
			sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"sabun|contType|contAddress"});
			break;
		case "LoadExcel":
			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet1.LoadExcel(params);
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

	// 팝업 클릭시 이벤트
	function sheet1_OnPopupClick(Row, Col){
		try{
			//사원검색
			switch(sheet1.ColSaveName(Col)){
				case "name":
					if(!isPopup()) {return;}

					sheet1.SelectCell(Row,"name");

					gPRow = Row;
					pGubun = "employeePopup";

					openPopup("${ctx}/Popup.do?cmd=employeePopup", "", "840","520");
					break;
			}
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}

	// 팝업 리턴 함수
	function getReturnValue(returnValue) {
        var rv = $.parseJSON('{' + returnValue+ '}');

        if(pGubun == "employeePopup") {
        	sheet1.SetCellValue(gPRow, "sabun", rv["sabun"]);
        	sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"]);
        	sheet1.SetCellValue(gPRow, "jikchakNm", rv["jikchakNm"]);
        	sheet1.SetCellValue(gPRow, "name", rv["name"]);
        	sheet1.SetCellValue(gPRow, "alias", rv["alias"]);
        	sheet1.SetCellValue(gPRow, "jikweeNm", rv["jikweeNm"]);
        	sheet1.SetCellValue(gPRow, "jikgubNm", rv["jikgubNm"]);
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
			<th><tit:txt mid='112277' mdef='사번/성명 '/></th>
			<td>
				 <input id="searchSabunNameAlias" name="searchSabunNameAlias" type="text" class="text" />
			</td>
			<th>연락처구분 </th>
			<td>
				<select id="contType" name="contType" multiple=""> </select>
				<input type="hidden" id="searchMultiContType" name="searchMultiContType" />
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
					<li class="txt">개인별연락처관리</li>
					<li class="btn">
						<btn:a href="javascript:doAction1('Insert')" css="btn outline_gray authA" mid='110700' mdef="입력"/>
						<btn:a href="javascript:doAction1('Copy')" 	css="btn outline_gray authA" mid='110696' mdef="복사"/>
						<btn:a href="javascript:doAction1('Save')" 	css="btn filled authA" mid='110708' mdef="저장"/>
						<btn:a href="javascript:doAction1('DownTemplate')" 	css="btn outline_gray authR" mid='110702' mdef="양식다운로드"/>
						<btn:a href="javascript:doAction1('LoadExcel')" 	css="btn outline_gray authR" mid='110703' mdef="업로드"/>
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
