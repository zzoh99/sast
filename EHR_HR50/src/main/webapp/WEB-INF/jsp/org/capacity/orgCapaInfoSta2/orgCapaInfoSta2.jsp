<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		// 트리레벨 정의
		$("#btnPlus").click(function() {
			sheet1.ShowTreeLevel(-1);
		});
		$("#btnStep1").click(function()	{
			sheet1.ShowTreeLevel(0, 1);
		});
		$("#btnStep2").click(function()	{
			sheet1.ShowTreeLevel(1,2);
		});
		$("#btnStep3").click(function()	{
			sheet1.ShowTreeLevel(-1);
		});

		// 2014 년 부터 다음해까지의 년도 옵션 생성.
		var searchYear = $('#year');
		searchYear.empty();
		for (var i = 2014; i <= Number("${curSysYear}")+1; i++) {
			searchYear.append($('<option></option>').val(i).text(i));
		}

		$("#year").val( "${curSysYear}" );
	});

	$(function() {
		$("#year").change(function(){
			doAction1("Search");
		});
	});
	
	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,MergeSheet:msHeaderOnly, Page:22, FrozenCol:11, DataRowMerge:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata.Cols = [
 			  {Header:"No|No", 				Type:"${sNoTy}",      Hidden:0,  Width:40,   Align:"Center",  ColMerge:0,   SaveName:"sNo" },
			  {Header:"상태|상태",				Type:"${sSttTy}",     Hidden:1,	 Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
 			  
              {Header:"시작일|시작일", 			Type:"Text",          Hidden:1,  width:10,   Align:"Left",    ColMerge:0,   SaveName:"sdate",         KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
              {Header:"상위조직코드|상위조직코드",	Type:"Text",  	      Hidden:1,  width:10,   Align:"Left",    ColMerge:0,   SaveName:"priorOrgCd",    KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
              {Header:"조직코드|조직코드", 		Type:"Text",          Hidden:1,  width:10,   Align:"Left",    ColMerge:0,   SaveName:"orgCd",         KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
  			  {Header:"조직명|조직명",			Type:"Text",          Hidden:0,  Width:200,  Align:"Left",    ColMerge:0,   SaveName:"orgNm",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100, Cursor:"",    TreeCol:1,  LevelSaveName:"sLevel" },
              {Header:"조직장|조직장", 			Type:"Text",      	  Hidden:1,  width:10,   Align:"Center",  ColMerge:0,   SaveName:"orgChief",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },              
              //{Header:"해당조직|정원", 			Type:"AutoSum",   	  Hidden:0,  Width:55,   Align:"Center",  ColMerge:0,   SaveName:"orgCnt1",       KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
			  {Header:"해당조직|정원", 			Type:"AutoSum",   	  Hidden:0,  Width:55,   Align:"Center",  ColMerge:0,   SaveName:"orgJikCnt",       KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
			  {Header:"해당조직|현인원", 		Type:"AutoSum",   	  Hidden:0,  Width:55,   Align:"Center",  ColMerge:0,   SaveName:"empCnt1",       KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20},
              {Header:"해당조직|차이", 			Type:"AutoSum",   	  Hidden:0,  Width:55,   Align:"Center",  ColMerge:0,   SaveName:"inter1",        KeyField:0,   CalcLogic:"|empCnt1|-|orgJikCnt|",    Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 },
              {Header:"해당조직|충원계획", 		Type:"AutoSum",       Hidden:0,  Width:55,   Align:"Center",  ColMerge:0,   SaveName:"monTotal",      KeyField:0,   CalcLogic:"|mon1|+|mon2|+|mon3|+|mon4|+|mon5|+|mon6|+|mon7|+|mon8|+|mon9|+|mon10|+|mon11|+|mon12|",  Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 },
              {Header:"1월|계획", 			Type:"AutoSum",       Hidden:0,  Width:55,   Align:"Center",  ColMerge:0,   SaveName:"mon1",          KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"1월|충원",           	Type:"AutoSum",       Hidden:0,  Width:55,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt1",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"2월|계획",           	Type:"AutoSum",       Hidden:0,  Width:55,   Align:"Center",  ColMerge:0,   SaveName:"mon2",          KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"2월|충원",          	Type:"AutoSum",       Hidden:0,  Width:55,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt2",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"3월|계획",           	Type:"AutoSum",       Hidden:0,  Width:55,   Align:"Center",  ColMerge:0,   SaveName:"mon3",          KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"3월|충원",           	Type:"AutoSum",       Hidden:0,  Width:55,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt3",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"4월|계획",          	Type:"AutoSum",       Hidden:0,  Width:55,   Align:"Center",  ColMerge:0,   SaveName:"mon4",          KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"4월|충원",           	Type:"AutoSum",       Hidden:0,  Width:55,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt4",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"5월|계획",           	Type:"AutoSum",       Hidden:0,  Width:55,   Align:"Center",  ColMerge:0,   SaveName:"mon5",          KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"5월|충원",           	Type:"AutoSum",       Hidden:0,  Width:55,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt5",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"6월|계획",           	Type:"AutoSum",       Hidden:0,  Width:55,   Align:"Center",  ColMerge:0,   SaveName:"mon6",          KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"6월|충원",           	Type:"AutoSum",       Hidden:0,  Width:55,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt6",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"7월|계획",           	Type:"AutoSum",       Hidden:0,  Width:55,   Align:"Center",  ColMerge:0,   SaveName:"mon7",          KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"7월|충원",           	Type:"AutoSum",       Hidden:0,  Width:55,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt7",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"8월|계획",           	Type:"AutoSum",       Hidden:0,  Width:55,   Align:"Center",  ColMerge:0,   SaveName:"mon8",          KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"8월|충원",           	Type:"AutoSum",       Hidden:0,  Width:55,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt8",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"9월|계획",           	Type:"AutoSum",       Hidden:0,  Width:55,   Align:"Center",  ColMerge:0,   SaveName:"mon9",          KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"9월|충원",           	Type:"AutoSum",       Hidden:0,  Width:55,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt9",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"10월|계획", 			Type:"AutoSum",       Hidden:0,  Width:55,   Align:"Center",  ColMerge:0,   SaveName:"mon10",         KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"10월|충원", 			Type:"AutoSum",       Hidden:0,  Width:55,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt10",   KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"11월|계획", 			Type:"AutoSum",       Hidden:0,  Width:55,   Align:"Center",  ColMerge:0,   SaveName:"mon11",         KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"11월|충원", 			Type:"AutoSum",       Hidden:0,  Width:55,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt11",   KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"12월|계획", 			Type:"AutoSum",       Hidden:0,  Width:55,   Align:"Center",  ColMerge:0,   SaveName:"mon12",         KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"12월|충원", 			Type:"AutoSum",       Hidden:0,  Width:55,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt12",   KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"예상정원|예상정원", 		Type:"AutoSum",       Hidden:1,  Width:55,   Align:"Center",  ColMerge:0,   SaveName:"allCnt",        KeyField:0,   CalcLogic:"|inter1|+|mon1|+|mon2|+|mon3|+|mon4|+|mon5|+|mon6|+|mon7|+|mon8|+|mon9|+|mon10|+|mon11|+|mon12|",Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 }
		]; 
		
		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		// 헤더 머지
		sheet1.SetMergeSheet( msHeaderOnly);

		$(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/OrgCapaInfoSta2.do?cmd=getOrgCapaInfoSta2Sheet1List", $("#srchFrm").serialize() ); break;
		case "Down2Excel":	sheet1.Down2Excel(); break;
		case "Save":
			$("#searchYear").val("");
			$("#searchYear").val($("#year").val());

			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/OrgCapaInfoSta2.do?cmd=saveOrgCapaInfoSta2", $("#sheet1Form").serialize() ); break;
		}
	}

	// 셀에 마우스 클릭했을때 발생하는 이벤트
  	function sheet1_OnClick(Row, Col, Value){
	  try{
		//계획
		if( (sheet1.ColSaveName(Col) == "mon1" && sheet1.GetCellValue(Row,"mon1") != "")   || (sheet1.ColSaveName(Col) == "mon2" && sheet1.GetCellValue(Row,"mon2") != "")
		 || (sheet1.ColSaveName(Col) == "mon3" && sheet1.GetCellValue(Row,"mon3") != "")   || (sheet1.ColSaveName(Col) == "mon4" && sheet1.GetCellValue(Row,"mon4") != "")
		 || (sheet1.ColSaveName(Col) == "mon5" && sheet1.GetCellValue(Row,"mon5") != "")   || (sheet1.ColSaveName(Col) == "mon6" && sheet1.GetCellValue(Row,"mon6") != "")
		 || (sheet1.ColSaveName(Col) == "mon7" && sheet1.GetCellValue(Row,"mon7") != "")   || (sheet1.ColSaveName(Col) == "mon8" && sheet1.GetCellValue(Row,"mon8") != "")
		 || (sheet1.ColSaveName(Col) == "mon9" && sheet1.GetCellValue(Row,"mon9") != "")   || (sheet1.ColSaveName(Col) == "mon10" && sheet1.GetCellValue(Row,"mon10") != "")
		 || (sheet1.ColSaveName(Col) == "mon11" && sheet1.GetCellValue(Row,"mon11") != "") || (sheet1.ColSaveName(Col) == "mon12" && sheet1.GetCellValue(Row,"mon12") != "")) {
		    if( Row > 1 && Row != sheet1.RowCount() + sheet1.HeaderRows()) {
		    	var searchMonth = "";

				if( sheet1.ColSaveName(Col) == "mon1") searchMonth = "01";
				if( sheet1.ColSaveName(Col) == "mon2") searchMonth = "02";
				if( sheet1.ColSaveName(Col) == "mon3") searchMonth = "03";
				if( sheet1.ColSaveName(Col) == "mon4") searchMonth = "04";
				if( sheet1.ColSaveName(Col) == "mon5") searchMonth = "05";
				if( sheet1.ColSaveName(Col) == "mon6") searchMonth = "06";
				if( sheet1.ColSaveName(Col) == "mon7") searchMonth = "07";
				if( sheet1.ColSaveName(Col) == "mon8") searchMonth = "08";
				if( sheet1.ColSaveName(Col) == "mon9") searchMonth = "09";
				if( sheet1.ColSaveName(Col) == "mon10") searchMonth = "10";
				if( sheet1.ColSaveName(Col) == "mon11") searchMonth = "11";
				if( sheet1.ColSaveName(Col) == "mon12") searchMonth = "12";
		    	
	            if(!isPopup()) {return;}
				gPRow = "";
				pGubun = "orgCapaPlanPopup";

		    	<%--openPopup("/OrgCapaPlanPopup.do?cmd=orgCapaPlanPopup&authPg=${authPg}", args, "650","500");--%>

				const p = {
					searchBaseDate: $("#year").val() + "1231",
					searchOrgNm: sheet1.GetCellValue(Row,"orgNm"),
					searchOrgCd: sheet1.GetCellValue(Row,"orgCd"),
					searchMonth: searchMonth,

				};

				var layer = new window.top.document.LayerModal({
					id : 'orgCapaPlanLayer'
					, url : '/OrgCapaPlanPopup.do?cmd=viewOrgCapaPlanLayer&authPg=${authPg}'
					, parameters: p
					, width : 650
					, height : 500
					, title : "인원조회"
					, trigger :[
						{
							name : 'orgCapaPlanLayerTrigger'
							, callback : function(rv){
								var sabun = rv["sabun"];
								var enterCd = rv["enterCd"];
								goMenu(sabun,enterCd);
							}
						}
					]
				});
				layer.show();
	        }
	    }
		  
		//충원
	    if( (sheet1.ColSaveName(Col) == "monEmpCnt1" && sheet1.GetCellValue(Row,"monEmpCnt1") != "") || (sheet1.ColSaveName(Col) == "monEmpCnt2" && sheet1.GetCellValue(Row,"monEmpCnt2") != "")
		 || (sheet1.ColSaveName(Col) == "monEmpCnt3" && sheet1.GetCellValue(Row,"monEmpCnt3") != "") || (sheet1.ColSaveName(Col) == "monEmpCnt4" && sheet1.GetCellValue(Row,"monEmpCnt4") != "")
		 || (sheet1.ColSaveName(Col) == "monEmpCnt5" && sheet1.GetCellValue(Row,"monEmpCnt5") != "") || (sheet1.ColSaveName(Col) == "monEmpCnt6" && sheet1.GetCellValue(Row,"monEmpCnt6") != "")
		 || (sheet1.ColSaveName(Col) == "monEmpCnt7" && sheet1.GetCellValue(Row,"monEmpCnt7") != "") || (sheet1.ColSaveName(Col) == "monEmpCnt8" && sheet1.GetCellValue(Row,"monEmpCnt8") != "")
		 || (sheet1.ColSaveName(Col) == "monEmpCnt9" && sheet1.GetCellValue(Row,"monEmpCnt9") != "") || (sheet1.ColSaveName(Col) == "monEmpCnt10" && sheet1.GetCellValue(Row,"monEmpCnt10") != "")
		 || (sheet1.ColSaveName(Col) == "monEmpCnt11" && sheet1.GetCellValue(Row,"monEmpCnt11") != "") || (sheet1.ColSaveName(Col) == "monEmpCnt12" && sheet1.GetCellValue(Row,"monEmpCnt12") != "")) {
		    if( Row > 1 && Row != sheet1.RowCount() + sheet1.HeaderRows()) {
		    	var searchMonth = "";
				var baseUrl = "orgCapaInfoSta2";

				if( sheet1.ColSaveName(Col) == "monEmpCnt1") searchMonth = "01";
				if( sheet1.ColSaveName(Col) == "monEmpCnt2") searchMonth = "02";
				if( sheet1.ColSaveName(Col) == "monEmpCnt3") searchMonth = "03";
				if( sheet1.ColSaveName(Col) == "monEmpCnt4") searchMonth = "04";
				if( sheet1.ColSaveName(Col) == "monEmpCnt5") searchMonth = "05";
				if( sheet1.ColSaveName(Col) == "monEmpCnt6") searchMonth = "06";
				if( sheet1.ColSaveName(Col) == "monEmpCnt7") searchMonth = "07";
				if( sheet1.ColSaveName(Col) == "monEmpCnt8") searchMonth = "08";
				if( sheet1.ColSaveName(Col) == "monEmpCnt9") searchMonth = "09";
				if( sheet1.ColSaveName(Col) == "monEmpCnt10") searchMonth = "10";
				if( sheet1.ColSaveName(Col) == "monEmpCnt11") searchMonth = "11";
				if( sheet1.ColSaveName(Col) == "monEmpCnt12") searchMonth = "12";
		    	
	            if(!isPopup()) {return;}
				gPRow = "";
				pGubun = "orgCapaEmpPopup";

				const p = {
					searchBaseDate: $("#year").val() + "1231",
					searchOrgNm: sheet1.GetCellValue(Row,"orgNm"),
					searchOrgCd: sheet1.GetCellValue(Row,"orgCd"),
					searchMonth: searchMonth,
					searchYear: $("#year").val(),
					searchColNm: sheet1.GetCellText(1, Col),
					baseUrl: baseUrl
				};

				var layer = new window.top.document.LayerModal({
					id : 'orgCapaEmpLayer'
					, url : '/OrgCapaEmpPopup.do?cmd=viewOrgCapaEmpLayer&authPg=${authPg}'
					, parameters: p
					, width : 650
					, height : 720
					, title : "인원조회"
					, trigger :[
						{
							name : 'orgCapaEmpLayerTrigger'
							, callback : function(rv){
								var sabun = rv["sabun"];
								var enterCd = rv["enterCd"];
							}
						}
					]
				});
				layer.show();
	        }
	    }
	  }catch(ex){alert("OnClick Event Error : " + ex);}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheet1.ShowTreeLevel(3, 4); sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 셀이 선택되었을때 발생하는 이벤트
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
		try{
	    	$("#searchOrgCd").val(sheet1.GetCellValue(NewRow, "orgCd"));
	  	}catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } doAction1("Search"); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}
	
	//  현인원 조회
	function orgEmpPopup(Row){
	    try{
	     var args    = new Array();
         args["orgCd"] = sheet1.GetCellValue(Row, "orgCd");
         args["orgNm"] = sheet1.GetCellValue(Row, "orgNm");
         openPopup("/Popup.do?cmd=orgEmpPopup&authPg=${authPg}", args, "650","720");
	    }catch(ex){alert("Open Popup Event Error : " + ex);}
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">

	<form id="srchFrm" name="srchFrm" >
		<input id="searchOrgCd" name="searchOrgCd" type="hidden" >
		
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<div class="sheet_title">
							<ul>
								<li class="txt">
									<select id="year" name="year" class="required"></select>
									년도 조직정원관리
								</li>
							</ul>
							</div>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>

	<div class="inner">
		<form id="sheet1Form" name="sheet1Form" >
			<input id="ssnSabun"    name="ssnSabun"    type="hidden" value="${ssnSabun}">
			<input id="ssnEnterCd"  name="ssnEnterCd"  type="hidden" value="${ssnEnterCd}">
			<input id="searchYear"  name="searchYear"  type="hidden" />

			<div class="sheet_title">
			<ul>
				<li id="txt" class="txt">조직정원관리
					<div class="util">
					<ul>
						<li	id="btnPlus"></li>
						<li	id="btnStep1"></li>
						<li	id="btnStep2"></li>
						<li	id="btnStep3"></li>
					</ul>
					</div>
				</li>
				<li class="btn">
					<a href="javascript:doAction1('Down2Excel')" 	class="btn outline-gray authR">다운로드</a>
					<a href="javascript:doAction1('Save')" 			class="btn filled authA">저장</a>
				</li>
			</ul>
			</div>
	</form>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>