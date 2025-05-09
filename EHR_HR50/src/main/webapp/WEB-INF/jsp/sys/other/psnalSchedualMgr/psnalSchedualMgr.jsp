<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head><title>개인별알림관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {
		$("#searchUseYn").change(function(){
			doAction1("Search");
		});


		init_sheet();
		
		
		doAction1("Search");
	});
	
	function init_sheet(){ 
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22, MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No|No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			
			{Header:"알림제목|알림제목",	 		Type:"Text", 	 Hidden:0, Width:200, Align:"Left", 	SaveName:"title", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"바로가기URL|바로가기URL", 	Type:"Text", 	 Hidden:0, Width:200, Align:"Left", 	SaveName:"linkUrl", 	KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"대상부서|대상자선택",		Type:"Popup",	 Hidden:0, Width:150, Align:"Left",	  	SaveName:"searchDesc",	KeyField:0,	Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"대상부서|조건검색순번",		Type:"Text", 	 Hidden:0, Width:80,  Align:"Center", 	SaveName:"searchSeq",	KeyField:0,	Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"사용여부|사용여부", 		Type:"CheckBox", Hidden:0, Width:80,  Align:"Center", 	SaveName:"useYn", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1,	TrueValue:"Y",	FalseValue:"N", DefaultValue:"N" },
			{Header:"비고|비고", 				Type:"Text", 	 Hidden:0, Width:150, Align:"Left", 	SaveName:"note", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			
			//Hidden
			{Header:"Hidden", Type:"Text", Hidden:1, Width:100, Align:"Center", SaveName:"seq" },
			
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);


		$(window).smartresize(sheetResize); sheetInit();
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/PsnalSchedualMgr.do?cmd=getPsnalSchedualMgrList", $("#sheet1Form").serialize() );
			break;
		case "Save":
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/PsnalSchedualMgr.do?cmd=savePsnalSchedualMgr", $("#sheet1Form").serialize()); 
			break;
		case "Insert":
			sheet1.DataInsert(0);
			break;
		case "Copy":		
			var row = sheet1.DataCopy();
			sheet1.SetCellValue(row, "seq", "");
			
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

	//팝업클릭 시
	function sheet1_OnPopupClick(Row, Col){
		var args 	= new Array();
		try{
			if(sheet1.ColSaveName(Col) == "searchDesc") {
				if(!isPopup()) {return;}

				args["srchBizCd"] = "";
				args["srchType"] = "3";
				args["searchDesc"] = "알림";

				let layerModal = new window.top.document.LayerModal({
					id : 'pwrSrchMgrLayer'
					, url : '/Popup.do?cmd=viewPwrSrchMgrLayer'
					, parameters : args
					, width : 850
					, height : 620
					, title : '<tit:txt mid='112392' mdef='조건 검색 관리'/>'
					, trigger :[
						{
							name : 'pwrTrigger'
							, callback : function(result){
								sheet1.SetCellValue(Row, "searchSeq",   result.searchSeq);
								sheet1.SetCellValue(Row, "searchDesc", result.searchDesc);
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
					<th>사용여부</th>
					<td>
						<select id="searchUseYn" name="searchUseYn">
							<option value="">전체</option>
							<option value="Y">Y</option>
							<option value="N">N</option>
						</select>
					</td>
					<td> <btn:a href="javascript:doAction1('Search');" css="btn dark" mid='search' mdef="조회"/> </td>
				</tr>
			</table>
		</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li id="txt" class="txt">개인별 알림 관리</li>
				<li class="btn">
					<a href="javascript:doAction1('Down2Excel')" 	class="btn outline-gray authR">다운로드</a>
					<a href="javascript:doAction1('Copy')" 	class="btn outline-gray authA">복사</a>
					<a href="javascript:doAction1('Insert')" class="btn outline-gray authA">입력</a>
					<a href="javascript:doAction1('Save')" 	class="btn filled authA">저장</a>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>

</div>
</body>
</html>