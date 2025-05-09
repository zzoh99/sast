<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- <%@ page import="com.hr.common.util.DateUtil" %> --%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var pRow = "";
var pGubun = "";

	$(function() {
		//==============================================================================================================================
		//공통코드 한번에 조회
		var grpCds = "R20100";
		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd="+grpCds,false).codeList, "전체");
		//==============================================================================================================================
		
		var initdata = {};
		
		// 권한그룹 시트 초기화
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:1,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",	Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='check' mdef='선택'/>",			Type:"Radio",		Hidden:0,	Width:30,	Align:"Center",	ColMerge:0,	SaveName:"selectChk",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	TrueValue:"Y",	FalseValue:"N" },
			{Header:"<sht:txt mid='grpCd' mdef='권한그룹코드'/>",	Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"code",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 },
			{Header:"<sht:txt mid='authScopeV2' mdef='권한그룹'/>",	Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"codeNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		
		// 컬럼항목 시트 초기화
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:1,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",	Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='check' mdef='선택'/>",			Type:"DummyCheck",	Hidden:0,	Width:30,	Align:"Center",	ColMerge:0,	SaveName:"selectChk",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	TrueValue:"Y",	FalseValue:"N" },
			{Header:"<sht:txt mid='eleId' mdef='항목'/>",			Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"colId",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"<sht:txt mid='elementNmV6' mdef='항목'/>",	Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"colName",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0}
		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);
		
		
		// 컬럼항목 속성시트 초기화
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly,DragMode:1,DragRow:1};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='grcodeCdV1' mdef='그룹코드'/>",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"grpCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"<sht:txt mid='eleId' mdef='항목ID'/>",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"colId",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"<sht:txt mid='benefitElem터Nm' mdef='항목명'/>",	Type:"Text",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"colName",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"<sht:txt mid='2017082500493' mdef='데이터타입'/>",	Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"colType",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0},
			{Header:"<sht:txt mid='width' mdef='너비(px)'/>",			Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"colWidth",	KeyField:0,	Format:"Number",PointCount:0,	UpdateEdit:1,	InsertEdit:0},
			{Header:"<sht:txt mid='elementAlign' mdef='정렬'/>",		Type:"CheckBox",	Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"colAlign",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0, MaxCheck: 1, RadioIcon: 1, HeaderCheck:0},
			{Header:"<sht:txt mid='eleTypeV1' mdef='출력형식'/>",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"colFormat",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0},
			{Header:"<sht:txt mid='2017082500494' mdef='항목순서'/>",	Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"colOrder",	KeyField:1,	Format:"Number",PointCount:0,	UpdateEdit:1,	InsertEdit:0},
		]; IBS_InitSheet(sheet3, initdata);sheet3.SetEditable("${editable}");sheet3.SetVisible(true);sheet3.SetCountPosition(4);
		
		/* Set radio */
		sheet3.SetColProperty("colAlign",  	{ItemText:"|"+codeLists["R20100"][0], ItemCode:"|"+codeLists["R20100"][1]} );// 정렬
		
		/* Set combo */
		// 데이터타입
		sheet3.SetColProperty("colType", {
			ComboText : "|문자열|정수형|실수형|날짜형",
			ComboCode : "|Text|Int|Float|Date"
		});
		// 출력형식
		sheet3.SetColProperty("colFormat", {
			ComboText : "|년월일(날짜형)|년월(날짜형)|월일(날짜형)|시분초(날짜형)|시분(날짜형)|년월일시분초(날짜형)|년월일시분(날짜형)|정수|실수 |주민등록번호",
			ComboCode : "|Ymd|Ym|Md|Hms|Hm|YmdHms|YmdHm|Integer|Float|IdNo"
		});
		
		$(window).smartresize(sheetResize); sheetInit();
		
		doAction1("Search");
	});
	
	// Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/EmpList.do?cmd=getGrpCdMgrGrpCdList", $("#srchFrm").serialize() ); break;
			break;
		}
	}
	
	// Sheet1 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	
	// Sheet1 조회 후 에러 메시지
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol,isDelete) {
		try {
			if (OldRow != NewRow) {
				sheet1.SetCellValue(NewRow, "selectChk", "Y");
				$("#searchGrpCd").val(sheet1.GetCellValue(NewRow, "code"));
				if( $("#searchGrpCd").val() != "" ) {
					doAction2("Search");
					doAction3("Search");
				}
			}
		} catch (ex) { alert("OnSelectCell Event Error : " + ex); }
	}
	
	
	// Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			sheet2.DoSearch( "${ctx}/EmpList.do?cmd=getEmpListNotUseColumnListByGrpCd", $("#srchFrm").serialize() ); break;
			break;
		case "Add"   :
			var count = 0;
			for(var i = 1 ; i <= sheet2.RowCount(); i++) {
				if( sheet2.GetCellValue(i, "selectChk") == "Y" ) {
					sheet2.SetCellValue(i,"sStatus", "U");
					count++;
				}
			}
			if(count == 0) {
				alert("추가 대상 항목을 선택해주십시오.");
			} else {
				IBS_SaveName(document.srchFrm,sheet2);
				sheet2.DoSave( "${ctx}/EmpList.do?cmd=saveEmpListItem" , $("#srchFrm").serialize());
			}
			break;
		}
	}
	
	// Sheet2 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) { alert("[sheet2] OnSearchEnd Event Error : " + ex); }
	}

	// Sheet2 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "")alert(Msg);
			doAction2("Search");
			doAction3("Search");
		}catch(ex){
			alert("[sheet2] OnSaveEnd Event Error " + ex);
		}
	}

	
	// Sheet3 Action
	function doAction3(sAction) {
		switch (sAction) {
		case "Search":
			sheet3.DoSearch( "${ctx}/EmpList.do?cmd=getEmpListItemMgrList", $("#srchFrm").serialize() ); break;
			break;
		case "Save":
			IBS_SaveName(document.srchFrm,sheet3);
			sheet3.DoSave( "${ctx}/EmpList.do?cmd=saveEmpListItemMgr", $("#srchFrm").serialize());
			break;
		case "Preview":
			if( sheet3.RowCount() > 0 ) {
				if(!isPopup()) {return;}

				let url 	= "/EmpList.do?cmd=viewEmpListPreviewLayer";
				let args 	= {"searchGrpCd": $("#searchGrpCd").val()};

				gPRow = "";
				pGubun = "empListPreviewLayer";

				let layerModal = new window.top.document.LayerModal({
					id: 'empListPreviewLayer',
					url: url,
					parameters: args,
					width: 1600,
					height: 820,
					title: '미리보기',
				});

				layerModal.show();

			} else {
				alert("선택된 권한그룹 하위에 등록된 항목이 없습니다.\n인원명부항목 등록 및 설정 후 진행하시기 바랍니다.");
			}
			break;
		}
	}
	
	// Sheet3조회 후 에러 메시지
	function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) { alert("[sheet3] OnSearchEnd Event Error : " + ex); }
	}

	// Sheet3 저장 후 메시지
	function sheet3_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "")alert(Msg);
			doAction2("Search");
			doAction3("Search");
		}catch(ex){
			alert("[sheet3] OnSaveEnd Event Error " + ex);
		}
	}
	
	// Sheet3 드래그 시작시 이벤트
	var sheet3DragRow = 0;
	function sheet3_OnDragStart(Rows, Cols) {
		try{
			sheet3DragRow = Rows;
			//console.log('sheet3DragRow', sheet3DragRow);
		}catch(ex){
			alert("[sheet3] OnDragStart Event Error " + ex);
		}
	}
	
	// 드래그 행을 드랍위치에 추가하고 드래그 시트에서 삭제한다.
	function sheet3_OnDropEnd(FromSheet, FromRow, ToSheet, ToRow, X, Y, Type) {
		try {
			// 같은 시트이며 Row가 변경된 경우 진행
			if( FromSheet.id == ToSheet.id && ToSheet && ToRow > 0 ) {
				//console.log('sheet3_OnDropEnd', 'FromRow', FromRow, 'ToSheet', ToSheet, 'ToRow', ToRow, 'X', X, 'Y', Y, 'Type', Type);
				var originValue1 = "", originValue2 = "";
				for(var i = 0; i <  ToSheet.LastCol()+1; i++) {
					let saveName = ToSheet.ColSaveName(i);
					if( saveName === 'sNo' || saveName === 'sStatus' || saveName === 'sDelete' ) {
						continue;
					}
					
					originValue1 = ToSheet.GetCellValue(FromRow, saveName);
					originValue2 = ToSheet.GetCellValue(ToRow, saveName);
				
					ToSheet.SetCellValue(FromRow, saveName, originValue2);
					ToSheet.SetCellValue(ToRow, saveName, originValue1);
				}
				
				//if( sheet3DragRow > 0 ) {
					sheet3DragRow = 0;
					// Sheet3 순서 재정렬
					rearrageColOrder();
				//}
			}
		}catch(ex){
			alert("[sheet3] OnDropEnd Event Error " + ex);
		}
	}

	// Sheet3 셀에 변경 됐을때 발생하는 이벤트
	function sheet3_OnChange(Row, Col, Value){
		try{
			var saveName = sheet3.ColSaveName(Col);
			
			if( sheet3DragRow == 0 ) {
				// 출력형식이 변경된 경우
				if(saveName == "colFormat") {
					if( "|Ymd|Ym|Md|Hms|Hm|YmdHms|YmdHm|".indexOf(Value) > 0 ) {	// 날짜 포맷을 선택한 경우
						sheet3.SetCellValue(Row, "colType", "Date");
						
					} else if( Value == "Integer" ) {								// 정수 포맷을 선택한 경우
						sheet3.SetCellValue(Row, "colType", "Int");
						
					} else if( Value == "Float" ) {									// 실수 포맷을 선택한 경우
						sheet3.SetCellValue(Row, "colType", "Float");
						
					} else {
						sheet3.SetCellValue(Row, "colType", "Text");
					}
				}
			}
			
		}catch(ex){
			alert("[sheet3] OnChange Event Error " + ex);
		}
	}
	
	// Sheet3 순서 재정렬
	function rearrageColOrder() {
		//console.log('rearrageColOrder');
		for(var Row = sheet3.HeaderRows(); Row < sheet3.RowCount() + sheet3.HeaderRows(); Row++){
			sheet3.SetCellValue(Row, "colOrder", Row * 10);
		}
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<input type="hidden" id="searchGrpCd" name="searchGrpCd" value="" />
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<colgroup>
			<col width="12%" />
			<col width="18%" />
			<col width="50px" />
			<col width="*" />
		</colgroup>
		<tr>
			<td>
				<div class="sheet_title inner">
					<ul>
						<li id="txt" class="txt"><tit:txt mid='2017082500491' mdef='인원명부항목관리'/></li>
						<li class="btn"></li>
					</ul>
				</div>
				<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
			</td>
			<td class="padl20">
				<div class="sheet_title inner">
					<ul>
						<li id="txt" class="txt">사용 가능 항목</li>
						<li class="btn"></li>
					</ul>
				</div>
				<script type="text/javascript"> createIBSheet("sheet2", "100%", "100%","${ssnLocaleCd}"); </script>
			</td>
			<td class="alignC">
				<a href="javascript:doAction2('Add');" title="사용 항목으로 추가">
					<img src="/common/images/common/arrow_right1.gif" />
					<br/>
					<strong class="f_s11 mat5">추가</strong>
				</a>
			</td>
			<td>
				<div class="sheet_title inner">
					<ul>
						<li id="txt" class="txt">사용 항목</li>
						<li class="btn">
							<span>※ 시트 행을 마우스 <strong class="f_point">Drag &amp; Drop</strong>으로 위/아래로 움직여 항목순서를 변경 할 수 있습니다.</span>
							<btn:a href="javascript:doAction3('Search');"  css="btn dark"      mid='110697'  mdef="조회"/>
							<btn:a href="javascript:doAction3('Save');"    css="btn filled authA" mid='110708'  mdef="저장"/>
							<btn:a href="javascript:doAction3('Preview');" css="btn outline_gray"       mid='preview' mdef="미리보기"/>
						</li>
					</ul>
				</div>
				<script type="text/javascript"> createIBSheet("sheet3", "100%", "100%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
