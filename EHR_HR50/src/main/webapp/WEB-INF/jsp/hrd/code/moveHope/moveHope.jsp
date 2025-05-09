<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp" %>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var EnterKeyEvent = function(control, searchFunc, searchParam){
		$(control).bind("keyup", function(event) {
			if (event.keyCode == 13) {
				searchFunc(searchParam);
				$(control).focus();
			}
		});
	};

	var SelectChangeEvent = function(control, searchFunc, searchParam){
		$(control).on("change", function() {
			searchFunc(searchParam);
			$(control).focus();
		});
	};

	$(function() {
		var initdata = {};
		initdata.Cfg = {FronzenCol:0, SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:100};
		initdata.HeaderMode = {Sort:1, ColMove:0, ColResize:0, HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo'     mdef='No'            />" ,Type:"${sNoTy}"  ,Hidden:Number("${sNoHdn}")  ,Width:"${sNoWdt}"   ,Align:"Center", ColMerge:0, SaveName:"sNo"},
			{Header:"<sht:txt mid='sDelete' mdef='삭제'          />" ,Type:"${sDelTy}" ,Hidden:Number("${sDelHdn}") ,Width:"${sDelWdt}"  ,Align:"Center", ColMerge:0, SaveName:"sDelete" ,Sort:0 ,HeaderCheck:0},
			{Header:"<sht:txt mid='sStatus' mdef='상태'          />" ,Type:"${sSttTy}" ,Hidden:1                    ,Width:"${sSttWdt}"  ,Align:"Center", ColMerge:0, SaveName:"sStatus" ,Sort:0},
			{Header:"<sht:txt mid='moveHopeNm'        mdef='이동희망사유'  />" ,Type:"Text"      ,Hidden:0                    ,Width:300           ,Align:"Center" ,ColMerge:0 ,SaveName:"moveHopeNm"     ,KeyField:1 ,UpdateEdit:1 ,InsertEdit:1 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='startYmd'        mdef='시작일'        />" ,Type:"Date"      ,Hidden:0                    ,Width:100           ,Align:"Center" ,ColMerge:0 ,SaveName:"startYmd"		,EndDateCol: "endYmd"           ,KeyField:1 ,UpdateEdit:1 ,InsertEdit:1 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='endYmd'        mdef='종료일'        />" ,Type:"Date"      ,Hidden:0                    ,Width:100           ,Align:"Center" ,ColMerge:0 ,SaveName:"endYmd"    		,StartDateCol: "startYmd"     ,KeyField:1 ,UpdateEdit:1 ,InsertEdit:1 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='seq'        mdef='순서'          />" ,Type:"Int"       ,Hidden:0                    ,Width:50            ,Align:"Center" ,ColMerge:0 ,SaveName:"seq"            ,KeyField:0 ,UpdateEdit:1 ,InsertEdit:1 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='enterCd'        mdef='enterCd'              />" ,Type:"Text"      ,Hidden:1                    ,Width:50            ,Align:"Center" ,ColMerge:0 ,SaveName:"enterCd"        ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='moveHopeCd'        mdef='moveHopeCd'              />" ,Type:"Text"      ,Hidden:1                    ,Width:50            ,Align:"Center" ,ColMerge:0 ,SaveName:"moveHopeCd"     ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
		];
		IBS_InitSheet(sheet1, initdata);
		sheet1.SetVisible(true);
		sheet1.SetCountPosition(4);


		loadUI();
		loadEvent();

		sheetInit();

		

	});

	function loadUI(){
		$(window).smartresize(sheetResize);
		doAction1("Search");
	}

	function loadEvent(){
		$("input:text").each(function(index){
			EnterKeyEvent(this, doAction1, "Search")
		});

		$("select").each(function(index){
			SelectChangeEvent(this, doAction1, "Search");
		})


	}

	function loadLookupCombo(sheet, fieldName, codeList){
		sheet.SetColProperty(fieldName, {ComboText:"|"+codeList[0], ComboCode:"|"+codeList[1]} );

	}

	function doAction1(sAction){
		switch (sAction) {
			case "Search":
				var params = "searchMoveHopeNm=" + $("#searchMoveHopeNm").val() ;

				sheet1.DoSearch( "${ctx}/MoveHope.do?cmd=getMoveHopeList", params);

				break;

			case "Save":
				IBS_SaveName(document.sheet1Form,sheet1);
				sheet1.DoSave( "${ctx}/MoveHope.do?cmd=saveMoveHope", $("#sheet1Form").serialize());
				break;

			case "Insert":
				var row = sheet1.DataInsert(0);
				sheet1.SetCellValue(row, "enterCd", "${ssnEnterCd}");
				sheet1.SelectCell(row, 2);

				break;

			case "Copy":
				var row = sheet1.DataCopy();
				sheet1.SelectCell(row, 2);
				sheet1.SetCellValue(row, "moveHopeCd" ,"");
				sheet1.SetCellValue(row, "seq"        ,"");

				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9"};
				sheet1.Down2Excel(param);

				break;
		}
	}

	function sheet1_OnSearchEnd(code, msg, stCode, stMsg){
		try{
			if (msg !="") 
				alert(msg);

			sheetResize();
		} catch(ex) {
			    alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet1_OnSaveEnd(code, msg, stCode, stMsg){
		try{
			if (msg !="")
				alert(msg);

			doAction1("Search");

		} catch(ex) {
			    alert("OnSaveEnd Event Error : " + ex);
		}
	}

	function sheet1_OnClick(row, col, value, cellX, cellY, cellW, cellH){
		try{
			if ( sheet1.ColSaveName(col) == "colName") {
				//TODO something
				return;
			}

			//doAction1("Search");

		} catch(ex) {
			    alert("OnClick Event Error : " + ex);
		}
	}

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='' mdef='이동희망사유' /></th>
						<td>
							<input id="searchMoveHopeNm" name="searchMoveHopeNm" type="Text" class="text" />
						</td>
						<td>
							<btn:a href="javascript:doAction1('Search');" id="btnSearch" css="button" mid='search' mdef='조회' />
						</td>
					</tr>

				</table>
			</div>
		</div>
	</form>
	<form id="sheet1Form" name="sheet1Form"></form>
	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li id="txt1" class="txt"><tit:txt mid='' mdef='이동희망사유코드(CDP)'/></li>
				<li class="btn">
					<btn:a href="javascript:doAction1('Insert')"		css="basic authA" mid='110700' mdef="입력"/>
					<btn:a href="javascript:doAction1('Copy')"			css="basic authA" mid='110696' mdef="복사"/>
					<btn:a href="javascript:doAction1('Save')"			css="basic authA" mid='110708' mdef="저장"/>
					<btn:a href="javascript:doAction1('Down2Excel')"	css="basic authR" mid='110698' mdef="다운로드"/>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
