<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>

<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
   			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
//   			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
//   			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

  			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
  			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

  			{Header:"<sht:txt mid='eduSurveyYn' mdef='만족도YN'/>",  			Type:"Text",     Hidden:1,  Width:40,   Align:"Center",  ColMerge:0,   SaveName:"eduSurveyYn",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
  			{Header:"<sht:txt mid='selectImgV2' mdef='만족도\n조사'/>",  		Type:"Image",     Hidden:0,  Width:40,   Align:"Center",  ColMerge:0,   SaveName:"selectImg",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
  			{Header:"<sht:txt mid='applYmdV6' mdef='신청일자'/>",    		Type:"Date",      Hidden:1,  Width:70,  Align:"Center",  ColMerge:0,   SaveName:"applYmd",        KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
  			{Header:"<sht:txt mid='agreeStatusCd' mdef='결재상태'/>",    		Type:"Combo",     Hidden:1,  Width:70,  Align:"Center",  ColMerge:0,   SaveName:"applStatusCd",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:100 },
  			{Header:"<sht:txt mid='eduSeqV1' mdef='교육순번'/>",   		Type:"Text",      Hidden:1,  Width:70,  Align:"Left",    ColMerge:0,   SaveName:"eduSeq",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:100 },
  			{Header:"<sht:txt mid='eduCourseNmV1' mdef='교육과정명'/>",    		Type:"Text",      Hidden:0,  Width:150,  Align:"Left",    ColMerge:0,   SaveName:"eduCourseNm",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
  			{Header:"<sht:txt mid='eduEventSeqV1' mdef='교육회차순번'/>",     	Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"eduEventSeq",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
  			{Header:"<sht:txt mid='eduEventNmV1' mdef='교육회차명'/>",     		Type:"Text",      Hidden:0,  Width:150,  Align:"Left",    ColMerge:0,   SaveName:"eduEventNm",    KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
  			{Header:"<sht:txt mid='eduEventSubV1' mdef='교육EVENT명(부제)'/>", 	Type:"Text",      Hidden:1,  Width:70,  Align:"Center",  ColMerge:0,   SaveName:"eduEventSub",   KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
  			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>", 				Type:"Text",      Hidden:1,  Width:70,  Align:"Center",  ColMerge:0,   SaveName:"sabun",           KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
  			{Header:"<sht:txt mid='eduSYmdV1' mdef='교육시작일'/>",      	Type:"Date",      Hidden:0,  Width:70,  Align:"Center",  ColMerge:0,   SaveName:"eduSYmd",       KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
  			{Header:"<sht:txt mid='eduEYmdV1' mdef='교육종료일'/>",      	Type:"Date",      Hidden:0,  Width:70,  Align:"Center",  ColMerge:0,   SaveName:"eduEYmd",       KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
  			{Header:"<sht:txt mid='agreeSabunV2' mdef='hideHead'/>",   		Type:"Text",      Hidden:1,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"applSeq",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
  			{Header:"<sht:txt mid='agreeSabunV2' mdef='hideHead'/>",   		Type:"Text",      Hidden:1,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"oApplSeq",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
  			{Header:"<sht:txt mid='agreeSabunV2' mdef='hideHead'/>",   		Type:"Text",      Hidden:1,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"eduSeq",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 }
		];
//  		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
 		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(true);sheet1.SetVisible(true);

 		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
 		sheet1.SetImageList(1,"${ctx}/common/images/icon/icon_x.png");
 		sheet1.SetImageList(2,"${ctx}/common/images/icon/icon_o.png");

 		//  결재상태
 		var applStatusCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R10010"), "");
		sheet1.SetColProperty("applStatusCd", 			{ComboText:"|"+applStatusCd[0], ComboCode:"|"+applStatusCd[1]} );
		sheet1.SetDataLinkMouse("selectImg", 1);
		$(window).smartresize(sheetResize); sheetInit();
		setEmpPage();
// 		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			// 조회 대상 사원 번호 셋팅
// 			setEmpPage();
			sheet1.DoSearch( "${ctx}/EduApp.do?cmd=getEduSurveryLstList", $("#sheet1Form").serialize() ); break;
        //case "Save":
       		// 해당 화면에는 저장기능 없이 삭제 기능만 존재 한다.
       		// 신규행 입력 및 저장은 팝업을 통하여 이루어진다.
       	//	IBS_SaveName(document.sheet1Form,sheet1);
        //	sheet1.DoSave( "${ctx}/EduSurveryLst.do?cmd=deleteEduSurveryLst", $("#sheet1Form").serialize()); break;
        case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheet1.Down2Excel(param); break;
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

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } doAction1("Search"); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
		    if( sheet1.ColSaveName(Col) == "selectImg" && Row >= sheet1.HeaderRows() ) {
		    	if(!isPopup()) {return;}

				gPRow = "";
				pGubun = "viewEduSurveryPopup";

				const p = {
					searchApplSabun: $("#searchUserId").val(),
					searchApplSeq: sheet1.GetCellValue(Row, "applSeq"),
					searchEduSeq: sheet1.GetCellValue(Row, "eduSeq"),
					searchEduEventSeq: sheet1.GetCellValue(Row, "eduEventSeq"),
					searchEduSurveyYn: sheet1.GetCellValue(Row, "eduSurveyYn"),
					authPg: "A"
				};

				let eduSurveryLayer = new window.top.document.LayerModal({
					id : 'eduSurveryLayer',
					url : '${ctx}/EduApp.do?cmd=viewEduSurveryPopup',
					parameters : p,
					width : 880,
					height : 850,
					title : '<tit:txt mid='eduSurvery' mdef='교육만족도조사'/>',
					trigger :[
						{
							name : 'eduSurveryTrigger',
							callback : function(rv){
								getReturnValue(rv);
							}
						}
					]
				});

				eduSurveryLayer.show();
		    }
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}

    function setEmpPage() {

    	$("#searchSabun").val($("#searchUserId").val());

    	doAction1("Search");
    }

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		if(pGubun == "viewEduSurveryPopup"){
			doAction1("Search");
		}
	}

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<!-- include 기본정보 page TODO -->
	<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>

	<form id="sheet1Form" name="sheet1Form" >
	<input type="hidden" id="searchSabun" name="searchSabun" value=""/>
<!-- 		<div class="sheet_search outer"> -->
<!-- 			<div> -->
<!-- 				<table> -->
<!-- 					<tr> -->
<!-- 					</tr> -->
<!-- 				</table> -->
<!-- 			</div> -->
<!-- 		</div> -->
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="outer">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='eduSurveryLst' mdef='만족도조사'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/>
								<btn:a href="javascript:doAction1('Down2Excel')" 	css="basic" mid='110698' mdef="다운로드"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
