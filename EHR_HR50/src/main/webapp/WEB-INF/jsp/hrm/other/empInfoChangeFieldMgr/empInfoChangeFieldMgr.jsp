<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> 
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		//event
		$("#searchColumnCd").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
		$("#searchEmpTable").change(function(){
			doAction1("Search");
		});
		
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:1000,MergeSheet:msAll,FrozenCol:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='statusCd' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
            			
			
			{Header:"<sht:txt mid='empTable' mdef='테이블'/>", Type:"Combo",    Hidden:0,   Width:70,  	Align:"Center", ColMerge:0, SaveName:"empTable",       KeyField:1, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='columnCd' mdef='항목필드'/>", Type:"Text",    Hidden:0,   Width:100,  	Align:"Center", ColMerge:0, SaveName:"columnCd",       KeyField:1, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='columnNm_V6716' mdef='항목필드명'/>", Type:"Text",    Hidden:0,   Width:100,  	Align:"Center", ColMerge:0, SaveName:"columnNm",       KeyField:1, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"Size",				Type:"Text",   	Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"limitLength", KeyField:1, Format:"Int",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='cType' mdef='컴포넌트'/>",			Type:"Combo",   Hidden:0,   Width:80,   Align:"Center", ColMerge:0, SaveName:"cType",   	KeyField:1, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='dataTypeV1' mdef='데이터타입'/>",		Type:"Combo",   Hidden:1,   Width:80,   Align:"Center", ColMerge:0, SaveName:"dType",   	KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='dContent' mdef='데이터'/>",			Type:"Text",    Hidden:1,   Width:180,  Align:"Left", 	ColMerge:0, SaveName:"dContent",   	KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
			{Header:"<sht:txt mid='popupType' mdef='팝업구분'/>",			Type:"Text",    Hidden:0,   Width:70,   Align:"Center", ColMerge:0, SaveName:"popupType",   KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='pkType' mdef='PK\n구분'/>",		Type:"Combo",Hidden:0,   Width:70,   Align:"Center", ColMerge:0, SaveName:"pkType",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
			{Header:"<sht:txt mid='notNullYn' mdef='NOT NULL\n여부'/>",	Type:"CheckBox",Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"notNullYn",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 , TrueValue:"Y", FalseValue:"N"},
			{Header:"<sht:txt mid='cryptKey' mdef='암호화\n구분'/>",		Type:"Combo",    Hidden:0,   Width:70,   Align:"Center", ColMerge:0, SaveName:"cryptKey", KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='readOnlyYn' mdef='읽기\n여부'/>",		Type:"CheckBox",Hidden:0,   Width:40,   Align:"Center", ColMerge:0, SaveName:"readOnlyYn",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 , TrueValue:"Y", FalseValue:"N"},
			{Header:"<sht:txt mid='mergeYn_V6040' mdef='컬럼\n머지'/>",		Type:"CheckBox",Hidden:0,   Width:40,   Align:"Center", ColMerge:0, SaveName:"mergeYn",   	KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 , TrueValue:"Y", FalseValue:"N"},
			{Header:"<sht:txt mid='relColumnCd' mdef='연관필드'/>",			Type:"Text",    Hidden:0,   Width:70,   Align:"Center", ColMerge:0, SaveName:"relColumnCd", KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			
			{Header:"<sht:txt mid='groupColumnCd' mdef='그룹필드'/>",			Type:"Text",    Hidden:0,   Width:70,   Align:"Center", ColMerge:0, SaveName:"groupColumnCd", KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='groupSeparator' mdef='그룹\n구분자'/>",			Type:"Text",    Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"groupSeparator", KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='useYn' mdef='사용\n유무'/>",		Type:"CheckBox",Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"useYn",   	KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 , TrueValue:"Y", FalseValue:"N"},
			{Header:"<sht:txt mid='useYn' mdef='조회\n항목'/>",		Type:"CheckBox",Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"displayYn",   KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 , TrueValue:"Y", FalseValue:"N"},
			{Header:"<sht:txt mid='useYn' mdef='조회\n조건'/>",		Type:"CheckBox",Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"conditionYn", KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 , TrueValue:"Y", FalseValue:"N"},
			{Header:"<sht:txt mid='infoSeq' mdef='순번'/>",				Type:"Text",    Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"seq",   		KeyField:0, Format:"Int",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 },
			{Header:"<sht:txt mid='hiddenValColumnCd' mdef='hidden데이터조합'/>",	Type:"Text",    Hidden:0,   Width:70,   Align:"Center", ColMerge:0, SaveName:"hiddenValColumnCd",   	KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000 },
			{Header:"<sht:txt mid='note1' mdef='비고1'/>",			Type:"Text",    Hidden:0,   Width:70,   Align:"Center", ColMerge:0, SaveName:"note1",   	KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000 },
			{Header:"<sht:txt mid='note2' mdef='비고2'/>",			Type:"Text",    Hidden:0,   Width:70,   Align:"Center", ColMerge:0, SaveName:"note2",   	KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000 },
			{Header:"<sht:txt mid='note3' mdef='비고3'/>",			Type:"Text",    Hidden:0,   Width:70,   Align:"Center", ColMerge:0, SaveName:"note3",   	KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000 },
			{Header:"<sht:txt mid='note4' mdef='비고4'/>",			Type:"Text",    Hidden:0,   Width:70,   Align:"Center", ColMerge:0, SaveName:"note4",   	KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000 },
			{Header:"<sht:txt mid='note5' mdef='비고5'/>",			Type:"Text",    Hidden:0,   Width:70,   Align:"Center", ColMerge:0, SaveName:"note5",   	KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000 },

		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		
		//콤보박스
		sheet1.SetColProperty("transType", 		{ComboText:"|입력|수정|삭제|입력,수정|입력,삭제|수정,삭제|입력,수정,삭제", ComboCode:"|I|U|D|ID|IU|UD|IUD"} );
		var empTable = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getEmpInfoChangeTableMgrList&searchDisplayYn=Y&searchCodeNm=Y",false).codeList, "");
		sheet1.SetColProperty("empTable", 		{ComboText:" |"+empTable[0], ComboCode:"|"+empTable[1]} );		
		var ctype=[" |COMBO|TEXT|TEXTAREA|CHECKBOX|POPUP|DATE|MONTH|FILE|HIDDEN|INT"," |C|T|A|H|P|D|M|F|N|I"];
		sheet1.SetColProperty("cType", 	{ComboText:ctype[0], ComboCode:ctype[1] });
		var dtype=[" |TEXT|SQL|FUNCTION"," |T|S|F"];
		sheet1.SetColProperty("dType", 	{ComboText:dtype[0], ComboCode:dtype[1] });
		var pktype=[" |Primary Key|Sequence"," |P|S"];
		sheet1.SetColProperty("pkType", 	{ComboText:pktype[0], ComboCode:pktype[1] });
		var cryptKey=[" |양방향|단방향"," |twoWay|oneWay"];
		sheet1.SetColProperty("cryptKey", 	{ComboText:cryptKey[0], ComboCode:cryptKey[1] });
		
		$(window).smartresize(sheetResize); sheetInit();
		
		$("#searchEmpTable").html(empTable[2]);
		
		doAction1("Search");
	});
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/PsnalBasicInf.do?cmd=getEmpInfoChangeFieldMgrList", $("#srchFrm").serialize() ); break;
		case "Save": 		
							if(!dupChk(sheet1,"empTable|columnCd", true, true)){break;}
							IBS_SaveName(document.srchFrm,sheet1);
							sheet1.DoSave( "${ctx}/PsnalBasicInf.do?cmd=saveEmpInfoChangeFieldMgr", $("#srchFrm").serialize()); break;
		case "Insert":		
							var row = sheet1.DataInsert(0);
							sheet1.SetCellValue(row, "empTable", $("#searchEmpTable").val());
							sheet1.SetCellValue(row, "useYn","Y");
							sheet1.SelectCell(row, "columnCd"); 
							break;
		case "Copy":		sheet1.DataCopy(); break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":	sheet1.Down2Excel(); break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	
	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } /* doAction1("Search"); */ } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}
	
	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
				sheet1.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}
	
	// 팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
			if(sheet1.ColSaveName(Col) == "name") {
				if(!isPopup()) {return;}
			
				gPRow = Row;
				pGubun = "employeePopup";

				var win = openPopup("/Popup.do?cmd=employeePopup&authPg=R", "", "740","520");
			}
		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}
	
	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');
		
		
		if(pGubun == "employeePopup") {
	    	sheet1.SetCellValue(sheet1.GetSelectRow(),"sabun",rv.sabun);
	    	sheet1.SetCellValue(sheet1.GetSelectRow(),"name",rv.name);
	    	sheet1.SetCellValue(sheet1.GetSelectRow(),"orgNm",rv.orgNm);
	    	sheet1.SetCellValue(sheet1.GetSelectRow(),"jikgubNm",rv.jikgubNm);
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
						<th><tit:txt mid='112835' mdef='테이블명/테이블ID '/></th>	
						<td>  <select id="searchEmpTable" name="searchEmpTable"></select></td>
						<th><tit:txt mid='112157' mdef='항목필드명<br>항목필드ID '/></th>
						<td>  <input id="searchColumnCd" name ="searchColumnCd" type="text" class="text"  /> </td>
						<td> <btn:a href="javascript:doAction1('Search')" id="btnSearch" css="btn dark" mid='btn dark' mdef="조회"/> </td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='113559' mdef='사원정보변경항목관리'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Insert')" css="btn outline_gray authA" mid='insert' mdef="입력"/>
								<btn:a href="javascript:doAction1('Copy')" 	css="btn outline_gray authA" mid='copy' mdef="복사"/>
								<btn:a href="javascript:doAction1('Save')" 	css="btn filled authA" mid='save' mdef="저장"/>
								<btn:a href="javascript:doAction1('Down2Excel')" 	css="btn outline_gray authR" mid='down2excel' mdef="다운로드"/>
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
