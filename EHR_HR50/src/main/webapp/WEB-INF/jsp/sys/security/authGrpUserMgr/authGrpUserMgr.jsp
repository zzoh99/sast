<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='grpCd' mdef='권한그룹코드'/>",			Type:"Text",	Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"grpCd",		KeyField:1,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
			{Header:"<sht:txt mid='authScopeV2' mdef='권한그룹'/>",			Type:"Text",	Hidden:0,	Width:85,	Align:"Left",	ColMerge:0,	SaveName:"grpNm",		KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100},
			{Header:"<sht:txt mid='commonYnV2' mdef='전사여부'/>",			Type:"Combo",	Hidden:0,	Width:55,	Align:"Center",	ColMerge:0,	SaveName:"commonYn",	KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1},
			{Header:"<sht:txt mid='dataRwTypeV1' mdef='데이터권한'/>",			Type:"Combo",	Hidden:0,	Width:65,	Align:"Center",	ColMerge:0,	SaveName:"dataRwType",	KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1},
			{Header:"<sht:txt mid='enterAllYnV1' mdef='그룹사전체\n조회여부'/>",	Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"enterAllYn",	KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1},
			{Header:"<sht:txt mid='searchTypeV1' mdef='조회구분'/>",			Type:"Combo",	Hidden:0,	Width:75,	Align:"Center",	ColMerge:0,	SaveName:"searchType",	KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100},
			{Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",				Type:"Int",		Hidden:1,	Width:0,	Align:"Right",	ColMerge:0,	SaveName:"seq",			KeyField:0,	CalcLogic:"",	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:20},
			{Header:"<sht:txt mid='authScopeNmV2' mdef='권한범위'/>",			Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"authScope",	KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1}
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		sheet1.SetColProperty("commonYn", {ComboText:"<sht:txt mid='yesOrNo|no' mdef='예|아니오'/>", ComboCode:"Y|N"} );
		sheet1.SetColProperty("dataRwType", {ComboText:"<sht:txt mid='dataRwTypeV3' mdef='읽기/쓰기|읽기'/>", ComboCode:"A|R"} );
		sheet1.SetColProperty("enterAllYn", {ComboText:"<sht:txt mid='yesOrNo|no' mdef='예|아니오'/>", ComboCode:"Y|N"} );
		sheet1.SetColProperty("searchType", {ComboText:"<sht:txt mid='searchTypeV4' mdef='자신만조회|권한범위적용|전사'/>", ComboCode:"P|O|A"} );

		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",		Hidden:0,						Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13},
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",		Type:"Text",		Hidden:0,						Width:50,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
			{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",		Type:"Text",		Hidden:Number("${aliasHdn}"),	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"alias",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",		Type:"Text",		Hidden:Number("${jgHdn}"),		Width:50,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",	Type:"Text",		Hidden:Number("${jwHdn}"),		Width:50,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",		Type:"Text",		Hidden:0,						Width:100,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000},
			{Header:"<sht:txt mid='grpCd' mdef='권한그룹코드'/>",	Type:"Text",		Hidden:1,						Width:0,	Align:"Center",	ColMerge:0,	SaveName:"grpCd",		KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10},
			{Header:"<sht:txt mid='dataRwTypeV1' mdef='데이터권한'/>",	Type:"Combo",	Hidden:0,						Width:70,	Align:"Center",	ColMerge:0,	SaveName:"dataRwType",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1},
			{Header:"<sht:txt mid='searchTypeV1' mdef='조회구분'/>",Type:"Combo",		Hidden:0,						Width:70,	Align:"Center",	ColMerge:0,	SaveName:"searchType",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100},
			{Header:"자동등록",										Type:"Text",     	Hidden:0,  						Width:40,   Align:"Center", ColMerge:0, SaveName:"autoYn",   	KeyField:0, CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='authGroup' mdef='권한\n범위'/>",	Type:"Image",		Hidden:0,						Width:30,	Align:"Center",	ColMerge:0,	SaveName:"authGroup",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1,Cursor:"Pointer"}
		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);sheet2.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet2.SetColProperty("dataRwType", {ComboText:"<sht:txt mid='dataRwTypeV3' mdef='읽기/쓰기|읽기'/>", ComboCode:"A|R"} );
		sheet2.SetColProperty("searchType", {ComboText:"<sht:txt mid='searchTypeV4' mdef='자신만조회|권한범위적용|전사'/>", ComboCode:"P|O|A"} );
		sheet2.GetDataLinkMouse("authGroup");

		$("#searchName").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		$(window).smartresize(sheetResize); sheetInit();
		sheet2.SetFocusAfterProcess(0);
		doAction1("Search");
		
		//Autocomplete
		$(sheet2).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue){
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet2.SetCellValue(gPRow, "sabun",		rv["sabun"]);
						sheet2.SetCellValue(gPRow, "name",		rv["name"]);
						sheet2.SetCellValue(gPRow, "orgNm",		rv["orgNm"]);
						sheet2.SetCellValue(gPRow, "jikchakCd",	rv["jikchakCd"]);
						sheet2.SetCellValue(gPRow, "jikweeNm",	rv["jikweeNm"]);
						sheet2.SetCellValue(gPRow, "jikgubNm",	rv["jikgubNm"]);
						sheet2.SetCellValue(gPRow, "statusCd",	rv["statusCd"]);
						sheet2.SetCellValue(gPRow, "statusNm",	rv["statusNm"]);
						sheet2.SetCellValue(gPRow, "empYmd",	rv["empYmd"]);
						sheet2.SetCellValue(gPRow, "gempYmd",	rv["gempYmd"]);
					}
				}
			]
		});		
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/AuthGrpUserMgr.do?cmd=getAuthGrpUserMgrSheet1List", $("#sheetForm").serialize() ); break;
		case "Down2Excel":
							var downcol = makeHiddenSkipCol(sheet1);
							var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
							sheet1.Down2Excel(param);
				
							break;
		}
	}
	//Example Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet2.DoSearch( "${ctx}/AuthGrpUserMgr.do?cmd=getAuthGrpUserMgrSheet2List", $("#sheetForm").serialize(),1 ); break;
		case "Save":
							IBS_SaveName(document.sheetForm,sheet2);
							sheet2.DoSave( "${ctx}/AuthGrpUserMgr.do?cmd=saveAuthGrpUserMgr", $("#sheetForm").serialize()); break;
		case "Insert":		var Row = sheet2.DataInsert(0);
							sheet2.SelectCell(Row, "name");
					        sheet2.SetCellValue(Row, "grpCd",$("#searchGrpCd").val());
					        sheet2.SetCellValue(Row, "dataRwType",sheet1.GetCellValue(sheet1.GetSelectRow(), "dataRwType"));
					        sheet2.SetCellValue(Row, "searchType",sheet1.GetCellValue(sheet1.GetSelectRow(), "searchType"));
					        sheet2.SetCellValue(Row, "authGroup",0);
					        sheet2.SetCellValue(Row, "autoYn","N");
							break;
		case "Copy":		var Row = sheet2.DataCopy();
							sheet2.SetCellValue(Row, "autoYn","N");
							break;
		case "Clear":		sheet2.RemoveAll(); break;
		case "Down2Excel":
							var downcol = makeHiddenSkipCol(sheet2);
							var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
							sheet2.Down2Excel(param);
				
							break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 셀에 마우스 클릭했을때 발생하는 이벤트
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
		try{
	    	$("#searchGrpCd").val(sheet1.GetCellValue(NewRow, "grpCd"));
	    	doAction2("Search");
	  	}catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet2_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction2("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet2.GetCellValue(Row, "sStatus") == "I") {
				sheet2.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	function sheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
		    if( Row > 0 && sheet2.ColSaveName(Col) == "authGroup" && Row >= sheet1.HeaderRows()) {
		        if( sheet2.GetCellValue(Row,"sStatus") == "I" ) {
		            alert("<msg:txt mid='alertAuthGrpUser1' mdef='입력 상태에서는 권한범위 설정을 하실 수 없습니다.'/>");
		            return;
		        }
		        if(sheet2.GetCellValue(Row,"searchType") != "O") {
		            alert("<msg:txt mid='alertAuthGrpUser2' mdef='조회구분에서 [권한범위적용]으로 선택했을 경우만 권한범위 설정을 할 수 있습니다.'/>");
		            return;
		        }
		        authGrpUserMgrScopePopup(Row);
		    }

		    if( sheet2.ColSaveName(Col) == "sDelete"  && Row >= sheet1.HeaderRows()) {
		    	if( sheet2.GetCellValue(Row,"sDelete") == 1 ) {
			        if(confirm("현재 데이터를 삭제를 하게 되면, \n\n권한범위의 모든자료가 삭제됩니다. \n\n계속 진행하시겠습니까?")) {
			            sheet2.SetCellValue(Row,"sDelete",1);
			        }else {
			            sheet2.SetCellValue(Row,"sDelete",0);
			        }
		    	}
		    }
	  	}catch(ex){alert("OnClick Event Error : " + ex);}
	}

	// 팝업 클릭시 발생
	function sheet2_OnPopupClick(Row,Col) {
		try {
			if(sheet2.ColSaveName(Col) == "name") {
				if(!isPopup()) {return;}
	            let layerModal = new window.top.document.LayerModal({
	    			id : 'employeeLayer', 
	    			url : '/Popup.do?cmd=viewEmployeeLayer&authPg=${authPg}', 
	    			parameters : { sType: 'G' }, 
	    			width : 840, 
	    			height : 520, 
	    			title : '사원조회', 
	    			trigger :[
	    				{
	    					name : 'employeeTrigger', 
	    					callback : function(rv){
	    						sheet2.SetCellValue(Row, "sabun",		rv["sabun"] );
	    			        	sheet2.SetCellValue(Row, "name",		rv["name"] );
	    			        	sheet2.SetCellValue(Row, "alias",		rv["alias"] );
	    			        	sheet2.SetCellValue(Row, "jikgubNm",	rv["jikgubNm"] );
	    			        	sheet2.SetCellValue(Row, "jikweeNm",	rv["jikweeNm"] );
	    			        	sheet2.SetCellValue(Row, "orgNm",		rv["orgNm"] );
	    					}
	    				}
	    			]
	    		});
	    		layerModal.show();
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	/**
	 * 권한범위 window open event
	 */
	function authGrpUserMgrScopePopup(Row){
		if(!isPopup()) {return;}
		gPRow = Row;
		pGubun = "authGrpUserMgrScopePopup";
		var title = "<tit:txt mid='authGrpUserMgrScope' mdef='사용자 권한범위 설정'/>";
  		var w 		= 740;
		var h 		= 580;
		var url 	= "${ctx}/AuthGrpUserMgr.do?cmd=viewAuthGrpUserMgrScopeLayer&authPg=${authPg}";
		var p = { searchSabun:sheet2.GetCellValue(Row, "sabun"), searchGrpCd: sheet2.GetCellValue(Row, "grpCd") };
		var layer = new window.top.document.LayerModal({
			id: 'authGrpUserMgrScopeLayer',
			url: url,
			parameters: p,
			width: w,
			height: h,
			title: title,
			trigger: [
				{
					name: 'authScopeMgrLayerTrigger',
					callback: function(rv) {
						sheet1.SetCellValue(Row, "authScopeCd", 	rv["authScopeCd"] );
						sheet1.SetCellValue(Row, "authScopeNm", 	rv["authScopeNm"] );
						sheet1.SetCellValue(Row, "scopeType", 		rv["scopeType"] );
						sheet1.SetCellValue(Row, "prgUrl", 			rv["prgUrl"] );
						sheet1.SetCellValue(Row, "sqlSyntax", 		rv["sqlSyntax"] );
						sheet1.SetCellValue(Row, "tableNm", 		rv["tableNm"] );
					}
				}
			]
		});
		layer.show();
		
	}
	
	function targetPopup(){				
		var args = new Array();
		let layerModal = new window.top.document.LayerModal({
            id : 'authGrpUserMgrTargetLayer'
          , url : '/AuthGrpUserMgr.do?cmd=viewAuthGrpUserMgrTargetLayer&authPg=${authPg}'
          , parameters : args
          , width : 1100
          , height : 500
          , title : '대상자 선택'
          , trigger :[
              {
                    name : 'authGrpUserMgrTargetTrigger'
                  , callback : function(result){
                      if(!result.length) return;
                      for(var i=0;i<result.length;i++){
                          var row = sheet2.DataInsert(0);
                          sheet2.SetCellValue(row, "sStatus", "I");                           //상태 
                          sheet2.SetCellValue(row, "sabun", result[i].sabun);                 //사번 
                          sheet2.SetCellValue(row, "name", result[i].name);                   //성명
                          sheet2.SetCellValue(row, "jikgubNm", result[i].jikgubNm);           //직급
                          sheet2.SetCellValue(row, "jikweeNm", result[i].jikweeNm);           //직위
                          sheet2.SetCellValue(row, "orgNm", result[i].orgNm);                 //소속
                          sheet2.SetCellValue(row, "orgCd", result[i].orgCd);                 //소속코드
                          sheet2.SetCellValue(row, "grpCd",$("#searchGrpCd").val());          //권한그룹코드
                          sheet2.SetCellValue(row, "dataRwType",$("#searchDataRwType").val());//데이터권한
                          sheet2.SetCellValue(row, "searchType",$("#searchType").val());      //조회구분
                          sheet2.SetCellValue(row, "authGroup",0);                            //권한범위
                      }
                  }
              }
          ]
      });
      layerModal.show();
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<input type="hidden" id="searchGrpCd" name="searchGrpCd">
						<th><tit:txt mid='104450' mdef='성명 '/></th>
						<td>  <input id="searchName" name ="searchName" type="text" class="text" /> </td>
						<td> <btn:a href="javascript:doAction2('Search')" id="btnSearch" css="btn dark" mid='110697' mdef="조회"/> </td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<colgroup>
		<col width="40%" />
		<col width="60%" />
	</colgroup>
	<tr>
		<td class="sheet_left">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid='authorityV1' mdef='권한그룹'/></li>
					<li class="btn">
						<btn:a href="javascript:doAction1('Down2Excel')" 	css="btn outline-gray authR" mid='110698' mdef="다운로드"/>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet1", "50%", "100%", "${ssnLocaleCd}"); </script>
		</td>
		<td class="sheet_right">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid='schUserV1' mdef='사용자'/></li>
					<li class="btn">
						<a href="javascript:doAction2('Down2Excel')" 	class="btn outline-gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
						<btn:a href="javascript:doAction2('Copy')" 	css="btn outline-gray authA" mid='110696' mdef="복사"/>
						<btn:a href="javascript:doAction2('Insert')" css="btn outline-gray authA" mid='110700' mdef="입력"/>
						<btn:a href="javascript:doAction2('Save')" 	css="btn soft authA" mid='110708' mdef="저장"/>
						<a href="javascript:targetPopup();" class="btn filled authA" >대상자선택</a>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet2", "50%", "100%", "${ssnLocaleCd}"); </script>
		</td>
	</tr>
	</table>
</div>
</body>
</html>