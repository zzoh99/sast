<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>평가차수반영비율</title>

<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {

		var appraisalCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdList",false).codeList, ""); //평가명
		var comGubunCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00007"),""); // 역량구분.

		$("#searchAppraisalCd").html(appraisalCdList[2]);
		$("#searchComGubunCd").html("<option value=''>전체</option>"+comGubunCdList[2]);

		$("#searchAppraisalCd, #searchComGubunCd").bind("change",function(event){
			doAction("Search");
		});
		$("#searchAppraisalCd").val($("#searchAppraisalCd", parent.document).val());
		//Sheet 초기화
		inist_sheet1();
		inist_sheet2();
		inist_sheet3();
		inist_sheet4();

		$(window).smartresize(sheetResize); sheetInit();
		doAction("Search");
	});

	function inist_sheet1(){
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No"	,Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
			{Header:"삭제"	,Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center", ColMerge:0,   SaveName:"sDelete" },
			{Header:"상태"	,Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center", ColMerge:0,   SaveName:"sStatus" },

			{Header:"적용순서" 		,Type:"Int",	Hidden:0,	Width:50,	Align:"Center", ColMerge:0, SaveName:"seq",	KeyField:1},
			{Header:"범위그룹순번"		,Type:"Int",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appTRateSeq",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
			{Header:"범위그룹명"		,Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appTRateNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
			{Header:"범위구분"			,Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"scopeGubun",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
			{Header:"범위적용"			,Type:"Image",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"btnSet",		Cursor:"Pointer" },
			{Header:"업적반영비율"		,Type:"Int",	Hidden:0,	Width:75,	Align:"Center",	ColMerge:0,	SaveName:"mboRate",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
			{Header:"역량반영비율"		,Type:"Int",	Hidden:0,	Width:75,	Align:"Center",	ColMerge:0,	SaveName:"competencyRate",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
			{Header:"합계"			,Type:"Int",	Hidden:0,	Width:75,	Align:"Center",	ColMerge:0,	SaveName:"rateSum",	KeyField:0,	CalcLogic:"|mboRate|+|competencyRate|", 	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10},
			{Header:"기타반영비율"		,Type:"Int",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"etcRate",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
			{Header:"평가ID"			,Type:"Text",	Hidden:1,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"appraisalCd",	KeyField:1,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"비고"			,Type:"Text",	Hidden:0,  Width:180,  Align:"Left",  ColMerge:0,   SaveName:"note",			KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata); sheet1.SetEditable("${editable}"); sheet1.SetCountPosition(4); sheet1.SetUnicodeByte(3);sheet1.SetVisible(true);

		var famList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdList",false).codeList, ""); // 평가명
		$("#searchAppraisalCd").html(famList[2]); //평가명

		sheet1.SetColProperty("scopeGubun", {ComboText:"|전체|범위적용", ComboCode:"|A|O"} );
		//sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_write.png");
		sheet1.SetDataLinkMouse("scope", 1);
		sheet1.SetDataLinkMouse("temp2", 1);

	}

	function inist_sheet2(){
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",				Type:"${sDelTy}", 	Hidden:1,  Width:"${sDelWdt}", Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
			{Header:"상태",				Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"상위소속코드",			Type:"Text",		Hidden:1,  Width:0,   Align:"Center",  ColMerge:0,   SaveName:"scopeValueTop",        	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"소속코드",			Type:"Text",		Hidden:1,  Width:0,   Align:"Center",  ColMerge:0,   SaveName:"scopeValue",        	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"소속명",				Type:"Text", 		Hidden:0,  Width:100, Align:"Left",  ColMerge:0,   SaveName:"scopeValueNm",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100,    TreeCol:1 },
			{Header:"등록",				Type:"CheckBox",  Hidden:0,  Width:20,  Align:"Center",  ColMerge:0,   SaveName:"chk",        		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1 }
		];
		IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);
		sheet2.SetFocusAfterProcess(0);
	}

	function inist_sheet3(){

		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, DataRowMerge:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",			Type:"${sNoTy}",  	Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center",  ColMerge:0,   SaveName:"sNo" },

			{Header:"선택",			Type:"Radio",  		Hidden:0,  Width:40,  	Align:"Center",  ColMerge:0,   SaveName:"sel" },
			{Header:"범위", 			Type:"Text",     	Hidden:0,  Width:130,  	Align:"Left",    ColMerge:0,   SaveName:"authScopeNm" },
			{Header:"등록",			Type:"CheckBox",  	Hidden:0,  Width:35,  	Align:"Center",  ColMerge:0,   SaveName:"useYn",  TrueValue:"Y",  FalseValue:"N"},

			{Header:"범위코드",		Type:"Text",     	Hidden:1,  Width:0,    	Align:"Left",    ColMerge:0,   SaveName:"authScopeCd"},
			{Header:"범위적용구분",		Type:"Text",    	Hidden:1,  Width:0,    	Align:"Center",  ColMerge:0,   SaveName:"scopeType"},
			{Header:"프로그램URL", 	Type:"Text",     	Hidden:1,  Width:0,    	Align:"Left",    ColMerge:0,   SaveName:"prgUrl"},
			{Header:"SQL문", 		Type:"Text",      	Hidden:1,  Width:0,    	Align:"Left",    ColMerge:0,   SaveName:"sqlSyntax"},
			{Header:"필드명", 		Type:"Text",      	Hidden:1,  Width:0,    	Align:"Left",    ColMerge:0,   SaveName:"tableNm" }
		];
		IBS_InitSheet(sheet3, initdata);sheet3.SetEditable(false);sheet3.SetVisible(true);
		sheet3.SetEditableColorDiff(0);
		sheet3.SetFocusAfterProcess(0);

	}

	function inist_sheet4(){

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",			Type:"${sNoTy}",  	Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
			{Header:"삭제",			Type:"${sDelTy}", 	Hidden:1,  Width:"${sDelWdt}", Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
			{Header:"상태",			Type:"${sSttTy}", 	Hidden:1,  Width:"${sSttWdt}", Align:"Center",  ColMerge:0,   SaveName:"sStatus" },
			{Header:"범위항목값",		Type:"Text",      	Hidden:0,  Width:50,  	Align:"Left",    ColMerge:0,   SaveName:"scopeValue",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"범위항목명",		Type:"Text",   		Hidden:0,  Width:110,	Align:"Left",    ColMerge:0,   SaveName:"scopeValueNm",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:4000},
            {Header:"등록",			Type:"CheckBox",  	Hidden:0,  Width:35,  	Align:"Center",  ColMerge:0,   SaveName:"chk",           KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, DefaultValue:"1" }
        ]; IBS_InitSheet(sheet4, initdata);sheet4.SetEditable("${editable}");sheet4.SetVisible(true);sheet4.SetCountPosition(4);

		//Autocomplete
		$(sheet4).sheetAutocompleteNew({
			Columns: [{   ColSaveName : "scopeValueNm"
					    , CallbackFunc: function(returnValue){
		      				var rv = $.parseJSON('{' + returnValue+ '}');
		      				sheet4.SetCellValue(gPRow, "scopeValue", 	rv["sabun"]);
		      				sheet4.SetCellValue(gPRow, "scopeValueNm", 	rv["name"]);
		  				  }
			          }]
		});

	}

</script>

<script type="text/javascript">
/**
 *조회조건 에터키 입력시 조회
 */
function check_Enter(){
	if (event.keyCode==13) doAction("Search");
}

function goCopyConfig() {
var openWindow=CenterWin ("ConfigCopy_popup7.jsp?searchApprasialCd="+document.all.searchApprasialCd.value , "CopyConfig", "status=no, scrollbars=no,status=no,fullscreen=no,width=740,height=152, top=0, left=0");
}

/**
 * Sheet 각종 처리
 */
function doAction(sAction){
	switch (sAction) {
	case "Search": 	 	sheet1.DoSearch( "${ctx}/AppRate.do?cmd=getAppRateTab2", $("#srchFrm").serialize() ); break;
	case "Search2": 	 	sheet1.DoSearch( "${ctx}/AppRate.do?cmd=getAppRateTab2ScopeCd", $("#srchFrm").serialize() ); break;
	case "Save":
		//if(sheet1.FindStatusRow("I") != ""){
		//	if(!dupChk(sheet1,"appraisalCd|app1stYn", true, true)){break;}
	//	}
		IBS_SaveName(document.srchFrm,sheet1);
		sheet1.DoSave( "${ctx}/AppRate.do?cmd=saveAppRateTab2", $("#srchFrm").serialize()); break;
	case "Insert":		var Row = sheet1.DataInsert(0);
						sheet1.SetCellValue(Row, "appraisalCd", $("#searchAppraisalCd").val());
						//sheet1.SelectCell(Row, "app1stYn");
						sheet1.SetCellValue(Row, "appTRateSeq", getColMaxValue(sheet1, "appTRateSeq"));
						break;
	case "Copy":
		var row = sheet1.DataCopy();
		//sheet1.SelectCell(Row, "app1stYn");
		sheet1.SetCellValue(row, "appTRateSeq", getColMaxValue(sheet1, "appTRateSeq"));
		break;
	case "Clear":		sheet1.RemoveAll(); break;
	case "Down2Excel":
		sheet1.Down2Excel({DownCols:makeHiddenSkipCol(sheet1),SheetDesign:1,Merge:1});
		break;
	case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
	}
}

function doAction2(sAction){
	switch (sAction) {
	case "Search":
		//sheet2.DoSearch( "${ctx}/AppCompItemMgr.do?cmd=getAppCompItemMgrScopeCd", $("#srchFrm").serialize() );
		sheet2.DoSearch( "${ctx}/AppGroupMgr.do?cmd=getAppGroupMgrOrgSchemeList", $("#srchFrm").serialize()+"&"+$("#sheetForm").serialize());
		break;
	case "Save":
		// 체크박스를 체크 or 체크해제 하게 되면 sStatus가 수정으로 바뀌게 되어 엉뚱한 데이터를 저장처리 하는 오류 수정
		for (var i = sheet2.HeaderRows(); i < sheet2.RowCount() + sheet2.HeaderRows(); i++) {
			sheet2.SetCellValue(i, "sStatus", "R");
		}

		var sRow = sheet2.FindCheckedRow("chk");
		var arr = sRow.split("|");
		for(var i=0; i<arr.length; i++){
        	sheet2.SetCellValue(arr[i],"sStatus", "I");
		}
		// 전체 체크 해제할 경우 저장할 내역이 없다는 alert가 발생하므로 deleteAppGroupMgrOrgScheme 쿼리를 실행하기 위해 한 행의 sStatus를 'D'로 변경하여 넘겨줌.
		if (sheet2.CheckedRows("chk") < 1) {
			sheet2.SetCellValue(1, "sStatus", "D");
		}

		$("#searchAuthScopeCd").val("W10"); //조직
		IBS_SaveName(document.sheetForm,sheet2);
		if (!sheet2.DoSave( "${ctx}/AppGroupMgr.do?cmd=saveAppGroupMgrOrgScheme", $("#sheetForm").serialize())) {
			// "저장하시겠습니까?" confirm 후 취소를 할 경우 저장 전처리로 sStatus를 "I"로 변경한 행들 때문에 체크박스 클릭이 불가능한 오류 수정
			for (var i = sheet2.HeaderRows(); i < sheet2.RowCount() + sheet2.HeaderRows(); i++) {
				sheet2.SetCellValue(i, "sStatus", "R");
			}
		}
		break;
	case "Clear":
		sheet2.RemoveAll();
		break;
	case "Down2Excel":
		var downcol = makeHiddenSkipCol(sheet2);
		var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
		sheet2.Down2Excel(param);

		break;
	case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet2.LoadExcel(params); break;
	}
}


//Sheet3 Action
function doAction3(sAction) {
	switch (sAction) {
	case "Search":
		sheet3.DoSearch( "${ctx}/AppGroupMgr.do?cmd=getAppGroupMgrScopeList", $("#sheetForm").serialize());
		break;
	case "PrcClear": //범위설정 초기화
		if (!confirm("설정된 범위항목들이 모두 삭제됩니다.\n초기화 하시겠습니까?")) return;

		var data = ajaxCall("${ctx}/AppGroupMgr.do?cmd=deleteAppGroupMgrScopeAll3",$("#sheetForm").serialize(),false);

		if(data.Result.Code == -1) {
			alert(data.Result.Message);
		} else {
			doAction2("Search");
			doAction3("Search");
			doAction4("Clear");
			alert("처리되었습니다.");
		}
		break;
	case "Clear":
		sheet3.RemoveAll();
		break;
	}
}

//Sheet4 Action
function doAction4(sAction) {
	// doAction2에서 조직을 저장할 때 searchAuthScopeCd에 "W10" 값을 셋트하기 때문에 조직을 먼저 저장할 경우 달라진 searchAuthScopeCd 값 때문에 발생하는 오류 수정
	$("#searchAuthScopeCd").val(sheet3.GetCellValue(sheet3.GetSelectRow(), "authScopeCd"));
	switch (sAction) {
	case "Search":
	    if( $("#searchAuthScopeCd").val()== "W20"  ) { //성명
	    	sheet4.DoSearch( "${ctx}/AppGroupMgr.do?cmd=getAppGroupMgrScopeEmpList", $("#sheetForm").serialize());
	    }else{
	    	sheet4.DoSearch( "${ctx}/AppGroupMgr.do?cmd=getAppGroupMgrScopeCodeList", $("#sheetForm").serialize());
	    }
		break;
	case "Save":
		var chkcnt = 0;
		for(i=1; i<=sheet4.LastRow(); i++){
			if( sheet4.GetCellValue(i,"sStatus") == "I" ){
				sheet4.SetCellValue(i,"chk", "1");
	        	chkcnt++;
			}else if( sheet4.GetCellValue(i,"chk") == "1" ) {
	        	sheet4.SetCellValue(i,"sStatus", "I");
	        	chkcnt++;
	        } else {
	        	sheet4.SetCellValue(i,"sStatus", "D");
	        }
		}
		if( chkcnt > 0 ){
        	sheet3.SetCellValue(sheet3Row,"useYn", "Y", 0);
		}else{
			sheet3.SetCellValue(sheet3Row,"useYn", "N", 0);
		}

		IBS_SaveName(document.sheetForm,sheet4);
		if (!sheet4.DoSave( "${ctx}/AppGroupMgr.do?cmd=saveAppGroupMgrScope", $("#sheetForm").serialize())) {
			// "저장하시겠습니까?" confirm 후 취소를 할 경우 저장 전처리로 sStatus를 "D"로 변경한 행들 때문에 체크박스 클릭이 불가능한 오류 수정
			for (var i = sheet4.HeaderRows(); i < sheet4.RowCount() + sheet4.HeaderRows(); i++) {
				sheet4.SetCellValue(i, "sStatus", "R");
			}
		}
		break;
	case "Insert":
		var Row = sheet4.DataInsert();
		sheet4.SetCellValue(Row, "chk", "1");
		sheet4.SetToolTipText(Row, "scopeValueNm", "성명을 입력해주세요.");
		break;
	case "Clear":
		sheet4.RemoveAll();
		break;
	case "DownTemplate":
		// 양식다운로드
		sheet4.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"scopeValue|scopeValueNm"});
		break;
	case "LoadExcel":
		var params = {Mode:"HeaderMatch", WorkSheetNo:1};
		sheet4.LoadExcel(params);
		break;
	}
}


// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try{
		if (Msg != ""){
			alert(Msg);
		}
		sheetResize();
	}catch(ex){
		alert("OnSearchEnd Event Error : " + ex);
	}
}

// 저장 후 메시지
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try{
		if(Msg != "")alert(Msg);
		if ( Code != -1 ) doAction("Search");

	}catch(ex){
		alert("OnSaveEnd Event Error " + ex);
	}
}

function sheet1_OnPopupClick(Row, Col){
	try{
		var colName = sheet1.ColSaveName(Col);
		if(colName == "competencyNm") {
			if(!isPopup()) {return;}

			var args	= new Array();
			openPopup("${ctx}/PapCptcPopup.do?cmd=viewPapCptcPopup", args, "1000","700", function (rv){
				sheet1.SetCellValue(Row, "competencyCd",	rv["competencyCd"] );
				sheet1.SetCellValue(Row, "competencyNm",	rv["competencyNm"] );
				sheet1.SetCellValue(Row, "comGubunCd",		rv["mainAppType"] );
			});
		}
	}catch(ex){alert("OnPopupClick Event Error : " + ex);}
}

function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol,isDelete) {
	try {
		if( sheet1.ColSaveName(NewCol) != "btnSet" ){
			doAction2("Clear");
			doAction3("Clear");
			doAction4("Clear");
		    $(".setBtn").hide();
		}
	} catch (ex) {
		alert("sheet1_OnSelectCell Event Error : " + ex);
	}
}


function sheet1_OnClick(Row, Col, Value) {
	try{

		if(sheet1.GetCellValue(Row, "sStatus") != "R") return;

		if( sheet1.ColSaveName(Col) == "btnSet" ){

			if(sheet1.GetCellValue(Row,"scopeGubun") != "O") {
				alert("범위구분에서 [범위적용]으로 선택했을 경우만 조회를 할 수 있습니다.");
				doAction2("Clear");
				doAction3("Clear");
				doAction4("Clear");
				$(".setBtn").hide();
				return;
			}

		    $("#searchItemNm").text(sheet1.GetCellValue(Row,"appGroupNm"));
		    $("#searchUseGubun").val("TR");
		    $("#searchItemValue1").val(sheet1.GetCellValue(Row,"appraisalCd"));
		    $("#searchItemValue2").val(sheet1.GetCellValue(Row,"appTRateSeq"));
		    $("#searchItemValue3").val("0");

		    //초기값
		    $(".setBtn").show();$(".btnEmp").hide();
			sheet4.SetCellValue(0, "scopeValue", "범위코드");
			sheet4.SetCellValue(0, "scopeValueNm", "범위명");

			// 조회...
			doAction2("Search");
			doAction3("Search");
			doAction4("Clear");
		}
/*
		if( sheet1.ColSaveName(Col) == "scope" 	&& Row >= sheet1.HeaderRows()) {
			if(!isPopup()) {return;}

			if( sheet1.GetCellValue(Row,"sStatus") == "I" ) {
				alert("입력 상태에서는 범위설정을 하실 수 없습니다.");
				return;
			}
			if(sheet1.GetCellValue(Row,"scopeGubun") != "O") {
				alert("범위구분에서 [범위적용]으로 선택했을 경우만 조회를 할 수 있습니다.");
				return;
			}

			var args = new Array();
			args["searchUseGubun"] = "C";
			args["searchItemValue1"] = sheet1.GetCellValue(Row,"appraisalCd");
			args["searchItemValue2"] = sheet1.GetCellValue(Row,"competencyCd");
			args["searchItemValue3"] = sheet1.GetCellValue(Row,"seq");
			args["searchItemNm"] = sheet1.GetCellValue(Row,"competencyNm");

			gPRow = Row;
			pGubun = "appGroupMgrRngPop";

			openPopup("${ctx}/AppGroupMgrRngPop.do?cmd=viewAppGroupMgrRngPop&authPg=${authPg}",args,"740","700");
		}

		if(sheet1.GetCellValue(Row, "sStatus") != "I"	&& Row >= sheet1.HeaderRows()){
			setSheet2Txt();
		}
		*/

	}catch(ex){alert("OnClick Event Error : " + ex);}
}

//---------------------------------------------------------------------------------------------------------------
// sheet2 Event
//---------------------------------------------------------------------------------------------------------------

// 조회 후 에러 메시지
function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try{
		if (Msg != ""){
			alert(Msg);
		}
		sheetResize();
	}catch(ex){
		alert("sheet2_OnSearchEnd Event Error : " + ex);
	}
}
// 저장 후 메시지
function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try{
		if(Msg != ""){
			alert(Msg);
		}
		if ( Code != -1 ) {
			doAction2("Search");
		}


	}catch(ex){
		alert("sheet2_OnSaveEnd Event Error " + ex);
	}
}
function sheet2_OnChange(Row, Col, Value){
	try{
		if( sheet2.ColSaveName(Col) == "chk" && Row == sheet2.GetSelectRow() ) {
			if( Row == 1 ) {
				for( i = 1 ; i <= sheet2.RowCount(); i++) {
					sheet2.SetCellValue(i, "chk",sheet2.GetCellValue(Row, "chk"));
				}
			} else {
				for( i = Row+1 ; i <= sheet2.RowCount(); i++) {
					if(  sheet2.GetCellValue(i, "scopeValueTop") != sheet2.GetCellValue(Row, "scopeValueTop") && sheet2.GetRowLevel(i) > sheet2.GetRowLevel(Row) ) {
						sheet2.SetCellValue(i, "chk",sheet2.GetCellValue(Row, "chk"));
					} else {
						break;
					}
				}
			}
		}
	}catch(ex){
		alert("sheet2_OnChange Event Error : " + ex);
	}
}
//---------------------------------------------------------------------------------------------------------------
// sheet3 Event
//---------------------------------------------------------------------------------------------------------------

// 조회 후 에러 메시지
function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try{
		if (Msg != ""){
			alert(Msg);
		}
		sheetResize();
	}catch(ex){
		alert("sheet3_OnSearchEnd Event Error : " + ex);
	}
}
function sheet3_OnSelectCell(OldRow, OldCol, NewRow, NewCol,isDelete) {
	try{
		sheet3Row = NewRow;
		sheet3.SetCellValue(NewRow, "sel", 1);
		$("#searchSqlSyntax").val(sheet3.GetCellValue(NewRow, "sqlSyntax"));
		$("#searchAuthScopeCd").val(sheet3.GetCellValue(NewRow, "authScopeCd"));

		if( $("#searchAuthScopeCd").val()== "W20"  ) { //성명
			sheet4.SetCellValue(0, "scopeValue", "사번");
			sheet4.SetCellValue(0, "scopeValueNm", "성명");
			$(".btnEmp").show();
		}else{
			var authScopeNm = sheet3.GetCellValue(NewRow, "authScopeNm");
			sheet4.SetCellValue(0, "scopeValue", authScopeNm+"코드");
			sheet4.SetCellValue(0, "scopeValueNm", authScopeNm+"명");
			$(".btnEmp").hide();
		}

		doAction4("Search");
	}catch(ex){alert("sheet3_OnSelectCell Event Error : " + ex);}
}


// 저장 후 메시지
function sheet3_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try{
		if(Msg != ""){
			alert(Msg);
		}
		if ( Code != -1 ) {
			doAction3("Search");
			doAction2("Search");
			//setSheet2Txt();
		}

	}catch(ex){
		alert("sheet3_OnSaveEnd Event Error " + ex);
	}
}

//---------------------------------------------------------------------------------------------------------------
// sheet4 Event
//---------------------------------------------------------------------------------------------------------------

function sheet4_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try{
		if (Msg != ""){
			alert(Msg);
		}
		sheetResize();
	}catch(ex){
		alert("sheet4_OnSearchEnd Event Error : " + ex);
	}
}

// 저장 후 메시지
function sheet4_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try{
		// Header값을 변경한 Sheet는 저장 후 sStatus의 Header값이 삭제되는 버그가 있어서 해당 오류 수정
		sheet4.SetCellValue(0, "sStatus", "상태");
		if(Msg != ""){
			alert(Msg);
		}
		if ( Code != -1 ) {
			doAction4("Search");
		}
	}catch(ex){
		alert("sheet4_OnSaveEnd Event Error " + ex);
	}
}

function sheet4_OnChange(Row, Col, Value){
	try{
		if( sheet3.GetCellValue(sheet3.GetSelectRow(), "authScopeCd") == "W20" && sheet4.ColSaveName(Col) == "chk" && Value == "0" && sheet4.GetCellValue(Row, "sStatus") == "I"  ) {
			sheet4.RowDelete(Row, 0);
		}
	}catch(ex){
		alert("sheet4_OnChange Event Error : " + ex);
	}
}

function sheet4_OnLoadExcel(result) {
	try {
		if (!result) {
			alert("엑셀 로딩중 오류가 발생하였습니다.");
			return;
		}
		for (var i = sheet4.HeaderRows(); i < sheet4.RowCount() + sheet4.HeaderRows(); i++) {
			sheet4.SetCellValue(i, "chk", "1");
		}
	} catch (ex) {
		alert("sheet4_OnLoadExcel Event Error : " + ex);
	}
}

function setSheet2Txt(){
	var Row = sheet1.GetSelectRow();

	$("#competencyCd").val(sheet1.GetCellValue(Row, "competencyCd"));
	$("#seq").val(sheet1.GetCellValue(Row, "seq"));
	var seqInfo = ajaxCall("${ctx}/AppCompItemMgr.do?cmd=getAppCompItemMgrTblNm", "queryId=getAppCompItemMgrTblNm&"+ $("#srchFrm").serialize(), false);

	$("#txt1").html("&nbsp;");
	doAction2("Clear");
	$.each(seqInfo.DATA, function(idx, value){
		var tag = $("<a/>", {
			"class":"gray large",
			text:value.authScopeNm,
			scopeCd:value.scopeCd,
			tableNm:value.tableNm,
			click:function(){
					$("#scopeCd").val($(this).attr("scopeCd"));
					$("#tableNm").val($(this).attr("tableNm"));
					$("#txt1 a").attr("class","gray large");
					$(this).attr("class","green large");
					doAction2("Search");
				}
		});

		$("#txt1").append(tag);
	});


}

//팝업 콜백 함수.
function getReturnValue(returnValue) {
	var rv = $.parseJSON('{' + returnValue+ '}');

}
</script>

</head>
<body class="bodywrap">

<div class="wrapper">
	<form id="sheetForm" name="sheetForm">
		<input id="searchUseGubun" 			name="searchUseGubun" 			type="hidden" />
		<input id="searchItemValue1" 		name="searchItemValue1" 		type="hidden" />
		<input id="searchItemValue2" 		name="searchItemValue2" 		type="hidden" />
		<input id="searchItemValue3" 		name="searchItemValue3" 		type="hidden" />
		<input id="searchSqlSyntax" 		name="searchSqlSyntax" 			type="hidden" />
		<input id="searchAuthScopeCd" 		name="searchAuthScopeCd" 		type="hidden" />
	</form>
	
	<form id="srchFrm" name="srchFrm" >
		<input type="hidden" id="searchAppraisalCd" name="searchAppraisalCd" />
		<input type="hidden" id="appTRateSeq" name="appTRateSeq" />
		<input type="hidden" id="tableNm" name="tableNm" />
		<input type="hidden" id="scopeCd" name="scopeCd" />
		
		<input type="hidden" id="competencyCd" name="competencyCd" />
		<input type="hidden" id="seq" name="seq" />
	</form>
	<table class="sheet_main">
		<colgroup>
			<col width="" />
			<col width="320px" />
			<col width="320px" />
		</colgroup>
		<tr>
			<td class="sheet_left">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">종합평가</li>
							<li class="btn">
								<a href="javascript:doAction('Down2Excel')" 	class="btn outline-gray authR">다운로드</a>
								<a href="javascript:doAction('Copy')" 	class="btn outline-gray authA">복사</a>
								<a href="javascript:doAction('Insert')" class="btn outline-gray authA">입력</a>
								<a href="javascript:doAction('Save')" 	class="btn filled authA">저장</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "70%", "100%","kr"); </script>
			</td>
			<td class="sheet_right">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li class="txt">범위설정</li>
							<li id="" class="btn setBtn">
							    <a href="javascript:doAction3('PrcClear');" class="btn filled authA" id="btnMake">범위설정초기화</a>
								<a href="javascript:doAction3('Search')" class="btn dark">조회</a>
							</li>
						</ul>
					</div>
					<script type="text/javascript">createIBSheet("sheet3", "100%", "230px","kr"); </script>
				</div>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li class="txt">범위항목</li>
							<li id="" class="btn setBtn">
								<a href="javascript:doAction4('DownTemplate')" class="btn outline-gray authR btnEmp">양식</a>
								<a href="javascript:doAction4('LoadExcel')" class="btn outline-gray authR btnEmp">업로드</a>
								<a href="javascript:doAction4('Insert')" class="btn outline-gray authA btnEmp" style="display:none;">입력</a>
								<a href="javascript:doAction4('Save')" 	class="btn filled authA">저장</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet4", "100%", "100%","kr"); </script>
			</td>

			<td class="sheet_right">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li class="txt">조직범위</li>
							<li id="txt1" class="btn setBtn">
								<a href="javascript:doAction2('Save')" 	 class="btn filled authA">저장</a>
								<a href="javascript:doAction2('Search')" class="btn dark">조회</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet2", "100%", "100%","kr"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>