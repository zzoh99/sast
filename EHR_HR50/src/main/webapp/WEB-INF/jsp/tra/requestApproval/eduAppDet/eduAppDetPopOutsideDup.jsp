<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("${popUpStatus}");
	var checkType="";

	var arg = p.popDialogArgumentAll();

	$(function() {
		if( arg != "undefined" ) {
			$("#searchEduCourseNm").val(arg["eduCourseNm"]);
		}

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:0,	Width:"${sNoWdt}",		Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}", Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}", Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"<sht:txt mid='check' mdef='선택'/>",			Type:"Radio",		Hidden:0,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"chk",				KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='eduCourseNmV1' mdef='교육과정명'/>",		Type:"Text",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"eduCourseNm",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='eduOrgNm' mdef='교육기관'/>",			Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"eduOrgNm",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },

			{Header:"hiddenValue",	Type:"Text",		Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"eduSeq",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"hiddenValue",	Type:"Text",		Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"eduOrgCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"hiddenValue",	Type:"Text",		Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"eduMethodCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"hiddenValue",	Type:"Text",		Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"eduBranchCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"hiddenValue",	Type:"Text",		Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"eduMBranchCd",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetUnicodeByte(3);

		$(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");

		$(".close").click(function() {
			p.self.close();
		});
	});

	/*Sheet1 Action*/
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 		//조회
			sheet1.DoSearch( "${ctx}/EduAppDet.do?cmd=getEduAppDetPopOutsideDupList", $("#srchFrm").serialize() );
			break;
		}
	}

	// 	조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") alert(Msg);
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet1_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		setValue();
	}

	function setValue(Row) {
		if ( 0 < sheet1.RowCount() ) {
			var Row = sheet1.GetSelectRow();

			var rv = new Array(1);

			rv["eduSeq"				]	=	sheet1.GetCellValue(Row,"eduSeq"			);

			if ( sheet1.GetCellValue(Row,"eduCourseNm") == "해당사항 없음" ) {
				rv["eduCourseNm"]	=	$("#searchEduCourseNm").val();
			} else {
				rv["eduCourseNm"]	=	sheet1.GetCellValue(Row,"eduCourseNm");
			}

			rv["eduOrgCd"			]	=	sheet1.GetCellValue(Row,"eduOrgCd"			);
			rv["eduOrgNm"			]	=	sheet1.GetCellValue(Row,"eduOrgNm"			);
			rv["eduMethodCd"		]	=	sheet1.GetCellValue(Row,"eduMethodCd"		);
			rv["eduBranchCd"		]	=	sheet1.GetCellValue(Row,"eduBranchCd"		);
			rv["eduMBranchCd"		]	=	sheet1.GetCellValue(Row,"eduMBranchCd"		);
		}

		p.popReturnValue(rv);
		p.window.close();
	}

	function doSelect() {
		var sRow = sheet1.FindCheckedRow("chk");

		if(sRow == "") {
			alert("<msg:txt mid='110136' mdef='항목을 선택하여 주세요.'/>");
			return;
		}

		sheet1_OnDblClick(sRow);
	}

</script>


</head>
<body class="bodywrap">
	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li><tit:txt mid='eduAppDetPop' mdef='회차별'/></li>
				<li class="close"></li>
			</ul>
		</div>
		<div class="popup_main">
			<form id="srchFrm" name="srchFrm" >
			<div class="sheet_search outer">
	            <div>
	            <table>
	            <tr>
	            	<th><tit:txt mid='113788' mdef='교육과정명'/></th>
	                <td>  <input type="text" name="searchEduCourseNm" id="searchEduCourseNm" type="text" class="text" /> </td>
	                <td>
	                    <btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/>
	                </td>
	            </tr>
	            </table>
	            </div>
	        </div>
			</form>

	        <div class="inner">
				<div class="sheet_title">
				<ul>
					<li id="txt" class="txt"><tit:txt mid='eduAppDetOutSideV1' mdef='외부교육과정조회'/></li>
				</ul>
				</div>
			</div>

			<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>

			<div class="popup_button outer">
			<ul>
				<li>
					<btn:a href="javascript:doSelect();" css="pink large" mid='110716' mdef="확인"/>
					<btn:a href="javascript:p.self.close();" css="gray large" mid='110881' mdef="닫기"/>
				</li>
			</ul>
			</div>
		</div>
	</div>
</body>
</html>
