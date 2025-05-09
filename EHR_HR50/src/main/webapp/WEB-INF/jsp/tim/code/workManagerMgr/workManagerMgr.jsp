<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {
		$("#searchDate").datepicker2();


		$("#searchSabunName, #searchOrgNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		
		init_sheet1();
		$(window).smartresize(sheetResize); sheetInit();
		
		
		doAction1("Search");
	});

	function init_sheet1(){ 
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22, MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"담당소속",	Type:"Popup",		Hidden:0,	Width:200,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1},
			{Header:"사번",		Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"성명",		Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1},
			{Header:"직위",		Type:"Text",		Hidden:Number("${jwHdn}"),	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"직급",		Type:"Text",		Hidden:Number("${jgHdn}"),	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"시작일",		Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1},
			{Header:"종료일",		Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1},
			{Header:"비고",		Type:"Text",		Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"note",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1},
			
			//Hidden
			{Header:"orgCd", 	Type:"Text", Hidden:1, SaveName:"orgCd"},
			{Header:"useYn", 	Type:"Text", Hidden:1, SaveName:"useYn"},
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		//Autocomplete
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue){
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow, "sabun",		rv["sabun"]);
						sheet1.SetCellValue(gPRow, "name",		rv["name"]);
						sheet1.SetCellValue(gPRow, "orgCd",		rv["orgCd"]);
						sheet1.SetCellValue(gPRow, "orgNm",		rv["orgNm"]);
						sheet1.SetCellValue(gPRow, "jikweeNm",	rv["jikweeNm"]);
						sheet1.SetCellValue(gPRow, "jikweeNm",	rv["jikweeNm"]);
					}
				}
			]
		});
	}
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":

				if($("#searchDate").val() == ""){
					alert("기준일은 필수조회 조건 입니다.");
					$("searchDate").foccs();
					return false;
				}

				sheet1.DoSearch( "${ctx}/WorkManagerMgr.do?cmd=getWorkManagerMgrList", $("#sheet1Form").serialize() );

				break;
		case "Save":
			if(!dupChk(sheet1,"orgCd|sabun|sdate", false, true)){break;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/WorkManagerMgr.do?cmd=saveWorkManagerMgr", $("#sheet1Form").serialize()); 
			break;
		case "Insert":
			sheet1.DataInsert(0);
			break;
		case "Copy":		
			sheet1.DataCopy(); 
			break;
		case "Clear":		
			sheet1.RemoveAll(); 
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param); 
			break;
		case "LoadExcel":	
			var params = {Mode:"HeaderMatch", WorkSheetNo:1}; 
			sheet1.LoadExcel(params); 
			break;
		}
	}

	//-----------------------------------------------------------------------------------
	//		sheet1 이벤트
	//-----------------------------------------------------------------------------------
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
		try { 
			if (Msg != "") { 
				alert(Msg); 
			} 
			if( Code > -1 ) doAction1("Search"); 
		} catch (ex) { 
			alert("OnSaveEnd Event Error " + ex); 
		}
	}


	function sheet1_OnPopupClick(Row, Col){
		try{
			sheet1.SetBlur();
			if(Row > 0 && sheet1.ColSaveName(Col) == "orgNm") {

				gPRow = Row;
				pGubun = "orgLayer";

				let layerModal = new window.top.document.LayerModal({
					id : 'orgLayer'
					, url : '/Popup.do?cmd=viewOrgBasicLayer&authPg=${authPg}'
					, parameters : {}
					, width : 740
					, height : 520
					, title : '<tit:txt mid='orgSchList' mdef='조직 리스트 조회'/>'
					, trigger :[
						{
							name : 'orgTrigger'
							, callback : function(result){
								if(!result.length) return;
								sheet1.SetCellValue(Row, "orgCd", result[0].orgCd);
								sheet1.SetCellValue(Row, "orgNm", result[0].orgNm);
							}
						}
					]
				});
				layerModal.show();
				
			}

		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}
	
	
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
		<div class="sheet_search outer">
			<table>
				<tr>
					<th>기준일</th>
					<td>
						<input type="text" id="searchDate" name="searchDate" class="date2 required" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>">
					</td>
					<th>담당소속</th>
					<td>
						<input type="text" id="searchOrgNm" name="searchOrgNm" class="text" />
					</td>
					<th>사번/성명</th>
					<td>  <input type="text" id="searchSabunName" name="searchSabunName" class="text" /> </td>
					<td> <btn:a href="javascript:doAction1('Search');" css="btn dark" mid='search' mdef="조회"/> </td>
				</tr>
			</table>
		</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li id="txt" class="txt">근무담당자관리</li>
				<li class="btn">
					<a href="javascript:doAction1('Insert')" class="btn outline_gray authA">입력</a>
					<a href="javascript:doAction1('Copy')" 	class="btn outline_gray authA">복사</a>
					<a href="javascript:doAction1('Save')" 	class="btn filled authA">저장</a>
					<a href="javascript:doAction1('Down2Excel')" 	class="btn outline_gray authR">다운로드</a>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>

</div>

<!-- 공통코드 레이어 팝업 -->
<%@ include file="/WEB-INF/jsp/common/include/layerPopup.jsp"%>
</body>
</html>