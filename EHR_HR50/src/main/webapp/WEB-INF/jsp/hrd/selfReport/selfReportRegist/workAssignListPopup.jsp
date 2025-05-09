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
	var p = eval("${popUpStatus}");
	var searchJobCd = "";

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

	var SelectChangeEvent = function(control, searchFunc, searchParam){
		sheet.SetColuProperty(columnName, {ComboText:"|"+ lookupList[0], ComboCode:"|"+lookupList[1]});
	};

	$(function() {
		var arg = p.window.dialogArguments;

		if( arg != undefined ) {
			searchJobCd = arg["searchJobCd" ];
		}else{
			if ( p.popDialogArgument("searchJobCd" ) !=null ) { searchJobCd		= p.popDialogArgument("searchJobCd" ); }
		}

		var initdata = {};
		initdata.Cfg = {FronzenCol:0, SearchMode:smLazyLoad, MergeSheet:msAll, Page:100};
		initdata.HeaderMode = {Sort:0, ColMove:0, ColResize:0, HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo'     mdef='No'               />" ,Type:"${sNoTy}"  ,Hidden:Number("${sNoHdn}")  ,Width:"${sNoWdt}"      ,Align:"Center", ColMerge:0, SaveName:"sNo"},
			{Header:"<sht:txt mid='sDelete' mdef='삭제'             />" ,Type:"${sDelTy}" ,Hidden:Number("${sDelHdn}") ,Width:"${sDelWdt}"     ,Align:"Center", ColMerge:0, SaveName:"sDelete" ,Sort:0 ,HeaderCheck:0},
			{Header:"<sht:txt mid='sStatus' mdef='상태'             />" ,Type:"${sSttTy}" ,Hidden:1                    ,Width:"${sSttWdt}"     ,Align:"Center", ColMerge:0, SaveName:"sStatus" ,Sort:0},
			{Header:"<sht:txt mid='BLANK'        mdef='대분류'           />" ,Type:"Text"      ,Hidden:0                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"gWorkAssignNm"    ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='BLANK'        mdef='중분류'           />" ,Type:"Text"      ,Hidden:0                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"mWorkAssignNm"    ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='BLANK'        mdef='단위업무명'       />" ,Type:"Text"      ,Hidden:0                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"workAssignNm"     ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='BLANK'        mdef='단위업무\n기술서' />" ,Type:"Image"     ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"detail"           ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='BLANK'        mdef='workAssignNote'                 />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"workAssignNote"   ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='BLANK'        mdef='workAssignCd'                 />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"workAssignCd"     ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='BLANK'        mdef='mWorkAssignCd'                 />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"mWorkAssignCd"    ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='BLANK'        mdef='gWorkAssignCd'                 />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"gWorkAssignCd"    ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='BLANK'        mdef='workAssignNoteCd'                 />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"workAssignNoteCd" ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
		];
		IBS_InitSheet(sheet1, initdata);
		sheet1.SetVisible(true);
		sheet1.SetCountPosition(4);
		sheet1.SetImageList(1,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("detail", 1);

		loadUI();
		loadEvent();

		sheetInit();

		doAction1("Search");
	});

	function loadUI(){
		$(window).smartresize(sheetResize);

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
				var params = "searchJobCd=" + searchJobCd +
				             "&searchWorkAssignNm=" + $("#searchWorkAssignNm").val() ;

				sheet1.DoSearch( "${ctx}/SelfReportRegist.do?cmd=getWorkAssignListPopupList", params);

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
			
			/* RD 존재하지않음. 주석처리
			if( ( row > 0 ) && (sheet1.ColSaveName(col) == "detail") ){
				alert("관련 출력물을 제공합니다.");
				return;
			}
			*/

		} catch(ex) {
			alert("OnClick Event Error : " + ex);
		}
	}

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<div class="popup_title">
		<ul>
			<li><tit:txt mid='' mdef='직무별단위업무'/></li>
			<li class="close"></li>
		</ul>
	</div>
	<div class="popup_main">
		<form id="srchFrm" name="srchFrm" >
			<div class="sheet_search outer">
				<div>
					<table>
						<tr>
							<th><tit:txt mid='' mdef='단위업무명' /></th>
							<td>
								<input id="searchWorkAssignNm" name="searchWorkAssignNm" type="Text" class="text" />
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
					<li id="txt1" class="txt"><tit:txt mid='' mdef='직무별단위업무'/></li>
					<li class="btn">

					</li>
				</ul>
			</div>
		</div>
		<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
		<div class="popup_button outer">
			<ul>
				<li>
					<btn:a href="javascript:p.self.close();" css="gray large" mid='110881' mdef="닫기"/>
				</li>
			</ul>
		</div>
	</div>
</div>
</body>
</html>
