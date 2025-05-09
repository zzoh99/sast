<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> 
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
$(function() {

	$("#searchPostItemNm").bind("keyup",function(event){
		if(event.keyCode == 13){
			doAction1("Search");
		}
	});

	//시트 초기화 
	var initdata = {};
	initdata.Cfg = {FrozenCol:7,SearchMode:smLazyLoad,Page:22}; 
	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
	initdata.Cols = [
		
		{Header:"No",		Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
		{Header:"삭제",		Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"), Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0 },
		{Header:"상태",		Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"), Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
		
		{Header:"매핑항목\n코드", 	Type:"Text",    Hidden:0,   Width:70,  	Align:"Center", ColMerge:0, SaveName:"postItem",    KeyField:1, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
		{Header:"매핑항목명",   	Type:"Text",    Hidden:0,   Width:100,  Align:"Left", 	ColMerge:0, SaveName:"postItemNm",  KeyField:1, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
		{Header:"매핑필드",    		Type:"Text",    Hidden:0,   Width:120,  Align:"Left", 	ColMerge:0, SaveName:"columnCd",    KeyField:1, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
		{Header:"매핑필드명",		Type:"Text",    Hidden:0,   Width:100,  Align:"Left", 	ColMerge:0, SaveName:"columnNm",    KeyField:1, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },		
		{Header:"Size",				Type:"Text",   	Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"limitLength", KeyField:1, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
		{Header:"컴포넌트",			Type:"Combo",   Hidden:0,   Width:80,   Align:"Center", ColMerge:0, SaveName:"cType",   	KeyField:1, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
		{Header:"데이터타입",		Type:"Combo",   Hidden:1,   Width:80,   Align:"Center", ColMerge:0, SaveName:"dType",   	KeyField:1, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
		{Header:"데이터",			Type:"Text",    Hidden:1,   Width:300,  Align:"Left", 	ColMerge:0, SaveName:"dContent",   	KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
		{Header:"팝업구분",			Type:"Text",    Hidden:0,   Width:70,   Align:"Center", ColMerge:0, SaveName:"popupType",   KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
		{Header:"읽기\n여부",		Type:"CheckBox",Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"readOnlyYn",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 , TrueValue:"Y", FalseValue:"N"},
		{Header:"컬럼\n머지",		Type:"CheckBox",Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"mergeYn",   	KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 , TrueValue:"Y", FalseValue:"N"},
		{Header:"연관필드",			Type:"Text",    Hidden:1,   Width:70,   Align:"Center", ColMerge:0, SaveName:"relColumnCd", KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
		{Header:"입력시\n데이터\n조회여부",		Type:"CheckBox",Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"dataYn",   	KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 , TrueValue:"Y", FalseValue:"N"},
		{Header:"사용\n유무",		Type:"CheckBox",Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"useYn",   	KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 , TrueValue:"Y", FalseValue:"N"},
		{Header:"순번",				Type:"Text",    Hidden:0,   Width:70,   Align:"Center", ColMerge:0, SaveName:"seq",   		KeyField:0, Format:"Int",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 },
		{Header:"비고1",			Type:"Text",    Hidden:1,   Width:70,   Align:"Center", ColMerge:0, SaveName:"note1",   	KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000 },
		{Header:"비고2",			Type:"Text",    Hidden:1,   Width:70,   Align:"Center", ColMerge:0, SaveName:"note2",   	KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000 },
		{Header:"비고3",			Type:"Text",    Hidden:1,   Width:70,   Align:"Center", ColMerge:0, SaveName:"note3",   	KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000 },
		{Header:"비고4",			Type:"Text",    Hidden:1,   Width:70,   Align:"Center", ColMerge:0, SaveName:"note4",   	KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000 },
		{Header:"비고5",			Type:"Text",    Hidden:1,   Width:70,   Align:"Center", ColMerge:0, SaveName:"note5",   	KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000 },
		
		
	]; IBS_InitSheet(sheet1, initdata); sheet1.SetEditable("${editable}"); sheet1.SetEditableColorDiff(0); //편집불가 상관없이 기본색상 출력
	sheet1.SetVisible(true);sheet1.SetCountPosition(4);
	
	//콤보박스
	var ctype=[" |COMBO|TEXT|TEXTAREA|CHECKBOX|POPUP|DATE"," |C|T|A|H|P|D"];
	sheet1.SetColProperty("cType", 	{ComboText:ctype[0], ComboCode:ctype[1] });
	var dtype=[" |TEXT|SQL|FUNCTION"," |T|S|F"];
	sheet1.SetColProperty("dType", 	{ComboText:dtype[0], ComboCode:dtype[1] });
	
	$(window).smartresize(sheetResize); sheetInit();
	doAction1("Search");
	
});
//************************************************************************************
// ibsheet 관련 func.
//************************************************************************************
//Sheet1 Action
function doAction1(sAction) {
	switch (sAction) {
	case "Search":		
		sheet1.DoSearch( "${ctx}/AppmtItemMapMgr.do?cmd=getAppmtItemMapMgrList",$("#sheet1Form").serialize() );
		break;
	case "Save":
		if(!dupChk(sheet1,"postItem", true, true)){break;}
		IBS_SaveName(document.sheet1Form,sheet1);
		sheet1.DoSave( "${ctx}/AppmtItemMapMgr.do?cmd=saveAppmtItemMapMgr", $("#sheet1Form").serialize());
		break;
	case "Insert":
		var row = sheet1.DataInsert(-1);
		break;
	case "Copy":
		sheet1.DataCopy();
		break;
	case "Down2Excel":
		var downcol = makeHiddenSkipCol(sheet1);
		var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
		var d = new Date();
		var fName = "발령항목매핑관리_" + d.getTime();
		sheet1.Down2Excel($.extend(param, { FileName:fName, SheetDesign:1, Merge:1 }));
		break;
	}
}
//조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "") {
			alert(Msg);
		}

		sheetResize();
	} catch (ex) {
		alert("OnSearchEnd Event Error : " + ex);
	}
}

// 저장 후 메시지
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "") {
			alert(Msg);
		}
		doAction1("Search");
	} catch (ex) {
		alert("OnSaveEnd Event Error " + ex);
	}
}

//키를 눌렀을때 발생.
function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
	try {
		if(sheet1.GetCellEditable(Row,Col) == true && KeyCode == 46) {
			switch(sheet1.ColSaveName(Col)){
			case "jobNm":
				sheet1.SetCellValue(Row,"jobCd","");
				break;
			case "orgNm":
				sheet1.SetCellValue(Row,"orgCd","");
				break;
			}
			
		}
	} catch (ex) {
		alert("OnKeyDown Event Error " + ex);
	}
}

// 팝업 클릭시 발생
function sheet1_OnPopupClick(Row,Col) {
	try {
		/* if(sheet1.ColSaveName(Col) == "jobNm") {
			if(!isPopup()) {return;}
			
			gPRow = Row;
			pGubun = "jobNm1";

	        var win = openPopup("/Popup.do?cmd=jobSchemePopup&authPg=R", "", "800","750");
		} */
	} catch (ex) {
		alert("OnPopupClick Event Error : " + ex);
	}
}

//팝업 콜백 함수.
function getReturnValue(returnValue) {
	var rv = $.parseJSON('{' + returnValue+ '}');

    /* if(pGubun == "jobNm1") {
        sheet1.SetCellValue(gPRow, "jobCd", rv["jobCd"] );
        sheet1.SetCellValue(gPRow, "jobNm", rv["jobNm"] );
    } */
}

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th>항목명</th>
						<td>
							<input type="text" id="searchPostItemNm" name="searchPostItemNm" class="text"/>
						</td>
						<td>
							<a href="javascript:doAction1('Search');" class="button">조회</a>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt">발령항목매핑관리</li>
			<li class="btn">				
				
				<a href="javascript:doAction1('Insert');" class="basic authA">입력</a>
				<a href="javascript:doAction1('Copy');" class="basic authA">복사</a>
				<a href="javascript:doAction1('Save');" class="basic authA">저장</a>
				<a href="javascript:doAction1('Down2Excel');" class="basic authR">다운로드</a>
			</li>
		</ul>
		</div>
	</div>	
	
	<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
</div>
</body>