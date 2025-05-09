<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>역량PopUp</title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var p = eval("${popUpStatus}");

	$(function() {
		$(".close, #close").click(function() {
			p.self.close();
		});

		// 공통코드조회
		var ldsGubunList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L90030"), "");

		// sheet init
		var initdata = {};
		initdata.Cfg = {FrozenCol:4,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			//{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			//{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"<sht:txt mid='competencyCd' mdef='역량코드'/>",	Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"ldsCompetencyCd",		KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='competencyNmV1' mdef='역량'/>",		Type:"Text",	Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"ldsCompetencyNm",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"역량개요",	Type:"Text",	Hidden:0,	Width:300,	Align:"Left",	ColMerge:0,	SaveName:"ldsCompetencyMemo",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"<sht:txt mid='useYnV8' mdef='사용구분'/>",	Type:"Combo",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"useYn",				KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='surveyItemType' mdef='분류'/>",		Type:"Combo",	Hidden:1,	Width:110,	Align:"Center",	ColMerge:0,	SaveName:"ldsGubun",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",		Type:"Int",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"seq",					KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:22 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(0);sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetUnicodeByte(3);

		sheet1.SetColProperty("ldsGubun",	{ComboText:ldsGubunList[0], ComboCode:ldsGubunList[1]} );
		sheet1.SetColProperty("useYn",		{ComboText:"사용|미사용", ComboCode:"Y|N"} );

		$(window).smartresize(sheetResize); sheetInit();

		// 조회조건 이벤트
		$("#searchLdsCompetencyNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search"); $(this).focus();
			}
		});

		$("#searchLdsGubun").bind("change", function(){
			doAction1("Search");
		});

		// 조회조건 값 setting
		$("#searchLdsGubun").html("<option value=''>전체</option>"+ldsGubunList[2]);

		var arg = p.window.dialogArguments;
	    if( arg != undefined ) {
		    ;
	    }

		// 조회
		doAction1("Search");
	});

	function setValue(){
		if(sheet1.GetSelectRow() < 1 ){
			alert("항목을 선택하세요.");
			return;
		}

		var rv = new Array();

		rv["ldsCompetencyCd"] = sheet1.GetCellValue(sheet1.GetSelectRow(), "ldsCompetencyCd");
		rv["ldsCompetencyNm"] = sheet1.GetCellValue(sheet1.GetSelectRow(), "ldsCompetencyNm");

		p.popReturnValue(rv);
		p.window.close();
	}
</script>

<!-- sheet1 -->
<script type="text/javascript">
	/**
	 * Sheet 각종 처리
	 */
	function doAction1(sAction){
		switch(sAction){
			case "Search":		//조회
				sheet1.DoSearch( "${ctx}/LDSCompetencyMng.do?cmd=getLDSCompetencyMngList1", $("#srchFrm").serialize() );
				break;
		}
	}

	//<!-- 조회 후 에러 메시지 -->
	function sheet1_OnSearchEnd(Code, ErrMsg, StCode, StMsg){
		try{
			if (ErrMsg != ""){
				alert(ErrMsg);
			}

			if ( sheet1.RowCount() == 1) {
				setValue();
			}

			sheetResize();
		}catch(ex){alert("OnSearchEnd Event Error : " + ex);}
	}

	// 더블 클릭했을 때
	function sheet1_OnDblClick(Row, Col, CellX, CellY, CellW, CellH) {
		setValue();
	}
</script>
</head>
<body class="bodywrap">
	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li><tit:txt mid='idsCompetencyMngPop' mdef='역량조회'/></li>
				<li class="close"></li>
			</ul>
		</div>

		<div class="popup_main">
		<form id="srchFrm" name="srchFrm">
		<input id="authPg" name="authPg" type="hidden" value="" />
		<input id="searchUseYn" name="searchUseYn" type="hidden" value="Y" />

		<div class="sheet_search outer">
            <div>
            <table>
            <tr>
                <td> <span><tit:txt mid='appSelf3' mdef='역량'/></span> <input type="text" name="searchLdsCompetencyNm" id="searchLdsCompetencyNm" type="text" class="text" /> </td>
                <td class="hide"> <span><tit:txt mid='112118' mdef='분류'/></span> <select id="searchLdsGubun" name="searchLdsGubun"></select> </td>
                <td>
                    <a href="javascript:doAction1('Search')" id="btnSearch" class="button"><tit:txt mid='104081' mdef='조회'/></a>
                </td>
            </tr>
            </table>
            </div>
        </div>
        </form>

		<div class="inner">
			<div class="sheet_title">
			<ul>
				<li id="txt" class="txt"><tit:txt mid='114518' mdef='역량 조회'/></li>
			</ul>
			</div>
		</div>
		<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>

		<div class="popup_button outer">
		<ul>
			<li>
				<a href="javascript:setValue();" id="prcCall" class="pink large"><tit:txt mid='104435' mdef='확인'/></a>
				<a id="close" class="gray large"><tit:txt mid='104157' mdef='닫기'/></a>
			</li>
		</ul>
		</div>

	</div>
</div>
</body>
</html>
