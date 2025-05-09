<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- <%@ page import="com.hr.common.util.DateUtil" %> --%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script src="/common/js/jquery/select2.js"></script>

<script type="text/javascript">
var pRow = "";
var pGubun = "";

var titleList = new Array();

var payGroupCdList = null;

	$(function() {

		$("input[type='text'], textarea").keydown(function(event){
			if(event.keyCode == 27){
				return false;
			}
		});

		$("#searchSDate").datepicker2({startdate:"searchEDate", onReturn: getCommonCodeList});
		$("#searchEDate").datepicker2({enddate:"searchSDate", onReturn: getCommonCodeList});
		$("#searchEDate, #searchSDate").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		getCommonCodeList();
		/*
		$("#searchStatusCd").select2({
			placeholder: "선택"
		});
		*/


		$("#searchPayGroupCd").bind("change", function(e) {
			doAction1("Search");
		});
		
		var initdata = {};
		initdata.Cfg = {FrozenCol:5,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"연봉그룹",		Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"payGroupCd",	KeyField:1,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
			{Header:"사번",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:15},
			{Header:"성명",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:30},
			{Header:"부서",			Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
			{Header:"계약유형",		Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"manageNm",	KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
			{Header:"직책",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",	KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
			{Header:"직위",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
			{Header:"직급",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",	KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
			{Header:"재직상태",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"statusNm",	KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"시작일",			Type:"Date",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	Format:"Ymd",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
			{Header:"종료일",			Type:"Date",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	Format:"Ymd",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10}

		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

		doActionT();
		$(window).smartresize(sheetResize); sheetInit();

        $("#searchNm, #searchOrgNm, #searchSDate, #searchEDate").bind("keyup",function(event){
            if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
        });

		//연봉항목그룹 코드
		payGroupCdList = convCode( ajaxCall("${ctx}/PerPayYearMgr.do?cmd=getPerPayYearEleGroupCodeList","",false).codeList, "");
		$("#searchPayGroupCd").html(payGroupCdList[2]);
		sheet1.SetColProperty("payGroupCd", 			{ComboText:"|"+payGroupCdList[0], ComboCode:"|"+payGroupCdList[1]});

		//doAction1("Search");
		/*2016.12.20 자동계산 추가 : 함두호*/
		initAutoCalcStd();
		
		//setSheetAutocompleteEmp( "sheet1", "name");
		//Autocomplete
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue){
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow, "sabun",		rv["sabun"]);
						sheet1.SetCellValue(gPRow, "name",		rv["name"]);
						sheet1.SetCellValue(gPRow, "orgNm",		rv["orgNm"]);
						sheet1.SetCellValue(gPRow, "manageNm",	rv["manageNm"]);
						sheet1.SetCellValue(gPRow, "jikchakNm",	rv["jikchakNm"]);
						sheet1.SetCellValue(gPRow, "jikweeNm",	rv["jikweeNm"]);
						sheet1.SetCellValue(gPRow, "jikgubNm",	rv["jikgubNm"]);
						sheet1.SetCellValue(gPRow, "workType",	rv["workType"]);
						sheet1.SetCellValue(gPRow, "workTypeNm",rv["workTypeNm"]);
						sheet1.SetCellValue(gPRow, "statusCd",	rv["statusCd"]);
						sheet1.SetCellValue(gPRow, "statusNm",	rv["statusNm"]);
						sheet1.SetCellValue(gPRow, "empYmd",	rv["empYmd"]);
						sheet1.SetCellValue(gPRow, "gempYmd",	rv["gempYmd"]);
					}
				}
			]
		});

		
	});

function doActionT() {
    $("#pivot-config").click(function() {
        sheet1.ShowPivotDialog();
    });

    $("#go-base").click(function() {
        sheet1.GoToBaseSheet();
    });
    sheet1.FitColWidth();
    sheet1.LoadSearchData(this.data, {
        Sync: 1
    });

//     sheet1.ShowPivotTable({
//         Rows: "orgNm",
//         Cols: "jikchakCd"
//     });

//     setTimeout(function() {
//     	if (typeof sheet1_Pivot !== "undefined" && sheet1_Pivot !== null) sheet1_Pivot.FitColWidth();
//     }, 300);
}

function getCommonCodeList() {
	let baseSYmd = $("#searchSDate").val();
	let baseEYmd = $("#searchEDate").val();

	// 계약유형
	var manageCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10030",baseSYmd ,baseEYmd), "");
	$("#searchManageCd").html(manageCdList[2]);
	$("#searchManageCd").select2({
		placeholder: "선택"
	});

	// 직책
	var jikchakCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20020",baseSYmd ,baseEYmd), "");
	$("#searchJikchakCd").html(jikchakCdList[2]);
	$("#searchJikchakCd").select2({
		placeholder: "선택"
	});

	// 직위
	var jikweeCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20030",baseSYmd ,baseEYmd), "");
	$("#searchJikweeCd").html(jikweeCdList[2]);
	$("#searchJikweeCd").select2({
		placeholder: "선택"
	});

	// 직급
	var jikgubCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20010",baseSYmd ,baseEYmd), "");
	$("#searchJikgubCd").html(jikgubCdList[2]);
	$("#searchJikgubCd").select2({
		placeholder: "선택"
	});

	// 재직상태
	var statusCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10010",baseSYmd ,baseEYmd), "");
	$("#searchStatusCd").html(statusCdList[2]);
	$("#searchStatusCd").select2({placeholder:""});
	$("#searchStatusCd").select2("val", ["AA"]);
}

function doActionT2() {
	sheet1.FitColWidth();
	sheet1.LoadSearchData(this.data, {
        Sync: 1
    });
}

function makeHiddenSkipExCol(sobj,excols){
	var lc = sobj.LastCol();
	var colsArr = new Array();
	for(var i=0;i<=lc;i++){
		if(1==sobj.GetColHidden(i) || sobj.GetCellProperty(0, i, "Type")== "Status" || sobj.GetCellProperty(0, i, "Type")== "DelCheck"){
			colsArr.push(i);
		}
	}
	var excolsArr = excols.split("|");
	
	for(var i=0;i<=lc;i++){
		if($.inArray(sobj.ColSaveName(i),excolsArr) != -1){
			colsArr.push(i);
		}
	}

	var rtnStr = "";
	for(var i=0;i<=lc;i++){
		if($.inArray(i,colsArr) == -1){
			rtnStr += "|"+ i;
		}
	}
	return rtnStr.substring(1);
}

/**
 * Sheet 각종 처리
 */
function doAction1(sAction){
	switch(sAction){
		case "Search":	//조회

						$("#searchManageCdHidden").val(getMultiSelectValue($("#searchManageCd").val()));
						$("#searchStatusCdHidden").val(getMultiSelectValue($("#searchStatusCd").val()));
						$("#searchJikweeCdHidden").val(getMultiSelectValue($("#searchJikweeCd").val()));
						$("#searchJikchakCdHidden").val(getMultiSelectValue($("#searchJikchakCd").val()));
						$("#searchJikgubCdHidden").val(getMultiSelectValue($("#searchJikgubCd").val()));

						searchTitleList();
						break;

		case "Save":	//저장
						if(!dupChk(sheet1,"sabun|sdate", false, true)){break;}
						IBS_SaveName(document.srchFrm,sheet1);
						sheet1.DoSave( "${ctx}/PerPayYearMgr.do?cmd=savePerPayYearMgr", $("#srchFrm").serialize() );

						break;

		case "Insert":
				if($("#searchPayGroupCd").val() == null || $("#searchPayGroupCd").val() == "") {
					alert("연봉그룹명을 선택하여 주시기 바랍니다. ");
					return;
				} else {
					sheet1.SelectCell(sheet1.DataInsert(0), 4);
					sheet1.SetCellValue(sheet1.GetSelectRow(), "payGroupCd", $("#searchPayGroupCd").val());
				}
				break;
						

		case "Copy":
			if($("#searchPayGroupCd").val() == null || $("#searchPayGroupCd").val() == "") {
				alert("연봉그룹명을 선택하여 주시기 바랍니다. ");
				return;
			} else {
				var row = sheet1.DataCopy();
				sheet1.SelectCell(row, 4);
				sheet1.SetCellValue(row, "payGroupCd", $("#searchPayGroupCd").val());
			}
			break;
		case "Down2Excel":  //엑셀내려받기
			if($("#searchPayGroupCd").val() == null || $("#searchPayGroupCd").val() == "") {
				alert("연봉그룹명을 선택하여 주시기 바랍니다. ");
				return;
			} else {
				sheet1.Down2Excel({DownCols:makeHiddenSkipCol(sheet1),SheetDesign:1,Merge:1});
			}
			break;

		case "LoadExcel":   //엑셀업로드
			if($("#searchPayGroupCd").val() == null || $("#searchPayGroupCd").val() == "") {
				alert("연봉그룹명을 선택하여 주시기 바랍니다. ");
				return;
			} else {
				var params = {Mode:"HeaderMatch", WorkSheetNo:1};
				sheet1.LoadExcel(params);
			}
			break;
		case "Down2Template":
			if (titleList["headerListCd"] == null || titleList["headerListCd"] == undefined) {
				alert("조회 후 양식다운로드해 주시기 바랍니다.");
				return;
			}
			if($("#searchPayGroupCd").val() == null || $("#searchPayGroupCd").val() == "") {
				alert("연봉그룹명을 선택하여 주시기 바랍니다. ");
				return;
			} else {
				var exCols = "sNo|payGroupCd|name|orgNm|manageNm|jikchakNm|jikgubNm|jikweeNm|workType|workTypeNm|statusNm|eletotYearMon|eletotMonthMon";
				var downCols = makeHiddenSkipExCol(sheet1,exCols);
				var param  = {DownCols:downCols,SheetDesign:1,Merge:1,DownRows:'0',ExcelFontSize:"9"};
				sheet1.Down2Excel(param);
			}
			break;
		case "edateUpdate":
						showOverlay(0,"처리중입니다. 잠시만 기다려주세요.");
						setTimeout(function(){
						var result = ajaxCall("${ctx}/PerPayYearMgr.do?cmd=prcP_CPN403_EDATE_UPDATE", "", false);
			
						if (result != null && result["Result"] != null && result["Result"]["Code"] != null) {
							alert(result["Result"]["Message"]);
			
							if (result["Result"]["Code"] == "0" || result["Result"]["Code"] == "OK") {
								doAction1('Search');
							}
						} else {
							alert("종료일자 UPDATE 오류입니다.");
						}
						hideOverlay();
						}, 100);
						break;
										
		case "AutoCalculate":
						if(sheet1.CheckedRows("calcChk") == 0) {alert("선택된 행이 없습니다.");break;}
						if(!confirm("연봉계산을 수행 하시겠습니까?")) { break; }
						
						var ele110Idx = -1;
						// 기본급(연봉) 컬럼을 찾는다. element_cd = '110'
						for(var i=0; i<100; i++) {
							if(sheet1.ColSaveName(i) == -1) {break;}
							
							if(sheet1.ColSaveName(i) == "ele110") {
								ele110Idx = i;
							}
						}
						// 모든행을 돌면서 체크된 행의 연봉계산을 수행
						if(ele110Idx > -1) {
							var rowCnt = sheet1.RowCount();
							
							for(var i=1; i<=rowCnt; i++) {
								if(sheet1.GetCellValue(i,"calcChk") == 1) {
									autoCalculate(i, ele110Idx);
								}
							}
							alert("계산이 완료되었습니다.");
						} else {
							alert("'기본급(연봉)'항목이 없습니다.");
						}
						
						break;
	}
}

function searchTitleList() {

	var dataList = ajaxCall("${ctx}/PerPayYearMgr.do?cmd=getPerPayYearMgrTitleList", $("#srchFrm").serialize(), false);

	for(var i=0; i < dataList.DATA.length; i++) {
		titleList["headerListCd"] = dataList.DATA[i].elementCd.split("|");
		titleList["headerListCdCamel"] = dataList.DATA[i].elementCdCamel.split("|");
		titleList["headerListNm"] = dataList.DATA[i].elementNm.split("|");
		titleList["headerOrderValue"] = dataList.DATA[i].orderValues.split(",");
		titleList["headerSetValue"] = dataList.DATA[i].setValues.split(",");
	}

	sheet1.Reset();

	if (dataList != null && dataList.DATA != null) {

		var v = 0;

		var initdata1 = {};
		initdata1.Cfg = {FrozenCol:6,SearchMode:smLazyLoad, Page:22/* , FrozenCol:11 */ };
		initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};

		initdata1.Cols = [];

		initdata1.Cols[v++] = {Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" };
		initdata1.Cols[v++] = {Header:"삭제",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0, HeaderCheck:1 };
		initdata1.Cols[v++] = {Header:"상태",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 };
		initdata1.Cols[v++] = {Header:"연봉그룹",		Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"payGroupCd",	KeyField:1,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100};
		initdata1.Cols[v++] = {Header:"사번",			Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:20};
		initdata1.Cols[v++] = {Header:"성명",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:20};
		initdata1.Cols[v++] = {Header:"부서",			Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:150};
		initdata1.Cols[v++] = {Header:"계약유형",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"manageNm",	KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100};
		initdata1.Cols[v++] = {Header:"직책",			Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",	KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100};
		initdata1.Cols[v++] = {Header:"직위",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100};
		initdata1.Cols[v++] = {Header:"직급",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",	KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100};
		initdata1.Cols[v++] = {Header:"직구분",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"workType",	KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100};
		initdata1.Cols[v++] = {Header:"직구분",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"workTypeNm",	KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100};
		initdata1.Cols[v++] = {Header:"재직상태",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"statusNm",	KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100};
		initdata1.Cols[v++] = {Header:"시작일",			Type:"Date",			Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	Format:"Ymd",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10};
		initdata1.Cols[v++] = {Header:"종료일",			Type:"Date",			Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	Format:"Ymd",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10};
		initdata1.Cols[v++] = {Header:"선택",			Type:"CheckBox",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"calcChk",		KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10};

		var columnInfo = "";
		// 주의! 소스코드의 처음 제작자 의도는 항목들의 합계를 계산하여 연봉총액, 월급여총액을 표기하려 했던 것으로 보이나 쿼리쪽에도 오류가 있고 바로 아래 javascript 소스코드에도 오류가 존재함. 해당 오류로 인해 추후에 누군가가 쿼리 쪽에 totYearMon 및 totMonthMon 항목을 주석 처리한 것으로 보임.
		// 만약 연봉총액, 월급여총액 표기가 필요한 경우 쿼리쪽 오류를 수정해야하고 아래 javascript 소스코드 오류도 수정을 해야함.
		// 또한 조회 조건 연봉그룹명에 '선택' 항목을 제거하여 연봉그룹을 필수로 선택하도록 수정되어 있는 것도 고려해야 됨. (위의 오류와도 어느정도 연관이 되어 수정하신 측면도 있는 것 같음)
		// 연봉총액, 월급여총액을 계산하기위한 CalcLogic에 들어갈 항목
		var calcLogic = {};
		// PRIORITY이 9999인 항목중 SET_VALUE가 10인건 연봉총액을 계산하기위한 데이터
		//                      , SET_VALUE가 11인건 월급여총액을 계산하기위한 항목
		for(var i=0; i<titleList["headerOrderValue"].length; i++) {
			//console.log("headerOrderValue:"+titleList["headerOrderValue"][i]);
			if(titleList["headerOrderValue"][i] != "9999") {
				// 처음에는 값이 없어 undefined
				if(calcLogic[titleList["headerSetValue"][i]] == undefined) {
					// 처음에 값이 들어가므로 '+'없이 더할 항목만 입력
					calcLogic[titleList["headerSetValue"][i]]  = "|ele"+titleList["headerListCdCamel"][i]+"|";
				} else {
					calcLogic[titleList["headerSetValue"][i]] += "+|ele"+titleList["headerListCdCamel"][i]+"|";
				}
			}
		}
		//console.log("calcLogic10:"+calcLogic["10"]);
		//console.log("calcLogic11:"+calcLogic["11"]);
		
		for(var i=0; i<titleList["headerListCd"].length; i++){
			if(titleList["headerListCd"][i] == "totYearMon" || titleList["headerListCd"][i] == "totMonthMon"){
				var calcData = calcLogic[titleList["headerSetValue"][i]];
				initdata1.Cols[v++]  = { Header:titleList["headerListNm"][i],	CalcLogic:calcData,		Type:"Int",	Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"ele"+titleList["headerListCdCamel"][i],	KeyField:0,	Format:"NullInteger",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
			}else{
				initdata1.Cols[v++]  = { Header:titleList["headerListNm"][i],	Type:"Int",	Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"ele"+titleList["headerListCdCamel"][i],	KeyField:0,	Format:"NullInteger",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 };
				columnInfo = columnInfo + "'" + titleList["headerListCd"][i] + "' AS " + "ELE_" + titleList["headerListCd"][i]+",";
			}
			//alert("ELE_"+titleList["headerListCd"][i]);
		}
		
		columnInfo = columnInfo.slice(0,columnInfo.length-1);

		// $("#columnInfo").val(encodeURI(columnInfo));

		initdata1.Cols[v++]  = { Header:"비고",		Type:"Text",	Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"bigo",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000};
		
		IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(4);

		sheet1.ShowGroupRow('', '{%s} <font color="gray">({%c}건)</font>');
		doActionT2();

		//연봉항목그룹 코드
		payGroupCdList = convCode( ajaxCall("${ctx}/PerPayYearMgr.do?cmd=getPerPayYearEleGroupCodeList","",false).codeList, "");
		$("#searchPayGroupCd").html(payGroupCdList[2]);
		sheet1.SetColProperty("payGroupCd", {ComboText:"|"+payGroupCdList[0], ComboCode:"|"+payGroupCdList[1]});
		
		sheet1.DoSearch( "${ctx}/PerPayYearMgr.do?cmd=getPerPayYearMgrList", $("#srchFrm").serialize() );
	}
}

var calcList = null;
function initAutoCalcStd() {
	
	// 계산식 리스트
	calcList = ajaxCall("${ctx}/PerPayYearMgr.do?cmd=getPerPayYearStdList","",false);
	calcList = calcList.DATA;

	// 치환가능 텍스트 리스트
	var txtlist = ajaxCall("${ctx}/PerPayYearMgr.do?cmd=getChangeElementList","",false);
	var txtData = txtlist.DATA; 

	// 텍스트(ex:#기본급(연봉)#)를 코드로 변경(ex:#101#)
	for(var i=0; i<calcList.length; i++) {
		calcList[i] = getCalcTxtToCode(calcList[i], txtData);
	}
	
}
function getCalcTxtToCode(chgObj, txtlist) {
	for(var i=0; i<txtlist.length; i++) {
		if(chgObj.calcLogic.indexOf("#"+txtlist[i].elementNm+"#") > -1) {
			// 계산식의 텍스트를 코드로 변경한다.
			chgObj.calcLogic = replaceAll(chgObj.calcLogic, "#"+txtlist[i].elementNm+"#", "#"+txtlist[i].elementCd+"#");
		}
	}
	return chgObj;
}

function autoCalculate(Row, Col) {
	try {
		var colName = sheet1.ColSaveName(Col);
		if(colName == "ele110"){
			// 급여항목코드가 110(기본급(연봉))인 컬럼이 변경되었을때 
			// 그 이후 컬럼의 계산식을 찾아서 자동계산
			for(var i=(Col+1); i<100; i++) {
				// i번째 컬럼이 없으면 for문 종료
				if(sheet1.ColSaveName(i) == -1) break;
				// 계상항목
				var elementCd = replaceAll(sheet1.ColSaveName(i), "ele", "");
				// 직구분
				var workType  = sheet1.GetCellValue(Row, "workType");
				// 계산식
				var calcLogic = getCalcLogic(elementCd, workType);
				if(calcLogic != "") {
					// 계산식의 코드 부분을 실제 데이터로 입력
					while(calcLogic.indexOf("#") > -1) {
						// 첫번째 #의 인덱스
						var fidx = calcLogic.indexOf("#");
						// 두번째 #의 인덱스
						var sidx = calcLogic.indexOf("#", fidx + 1);
						// 두번째 #이 없으면 while문 종료
						if(sidx == -1) break;
						var varName = calcLogic.substring(fidx, sidx+1); // 계산식의 변수를 가져온다.
						var colName = "ele" + calcLogic.substring(fidx + 1, sidx); // 조회된 컬럼의 세이브네임을 가져온다.
						calcLogic = replaceAll(calcLogic, varName, sheet1.GetCellValue(Row, colName));
					}
					// result라는 변수에 계산식 계산결과를 입력
					//console.log(calcLogic);
					$.globalEval("var result = "+calcLogic+";");
					//시트에 display
					result = numRound(result, 0);
					sheet1.SetCellValue(Row, i, result);
				}
			}
		}
	} catch(ex) {alert("OnChange Event Error : " + ex);}
}

function sheet1_OnChange(Row, Col, Value) {
	try{
		autoCalculate(Row, Col);
	}catch(ex){alert("OnChange Event Error : " + ex);}
}

function getCalcLogic(elementCd, workType) {
	for(var i=0; i<calcList.length; i++) {
		if(calcList[i].elementCd == elementCd && calcList[i].workType == workType) {
			return calcList[i].calcLogic;
		}
	}
	return "";
}


// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "") {
			alert(Msg);
		}
		
		//sheetResize();
	} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

//저장 후 메시지
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "") {
			alert(Msg);
		}
		if (Code != "-1"){
			doAction1("Search");
		}
	} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}

// 팝업 클릭시 발생
function sheet1_OnPopupClick(Row,Col) {

	var colName = sheet1.ColSaveName(Col);
	if(colName !== 'name') return;

	let layerModal = new window.top.document.LayerModal({
		id : 'employeeLayer'
		, url : '/Popup.do?cmd=viewEmployeeLayer&authPg=${authPg}'
		, parameters : {
			name : sheet1.GetCellValue(Row, "name")
			, sabun : sheet1.GetCellValue(Row, "sabun")
		}
		, width : 840
		, height : 520
		, title : '사원조회'
		, trigger :[
			{
				name : 'employeeTrigger'
				, callback : function(result){
					sheet1.SetCellValue(Row, "name",   result.name);
					sheet1.SetCellValue(Row, "sabun",   result.sabun);
					sheet1.SetCellValue(Row, "orgNm",   result.orgNm);
					sheet1.SetCellValue(Row, "jikchakNm",   result.jikchakNm);
					sheet1.SetCellValue(Row, "jikweeNm",   result.jikweeNm);
					sheet1.SetCellValue(Row, "jikgubNm",   result.jikgubNm);
					sheet1.SetCellValue(Row, "manageNm",   result.manageNm);
					sheet1.SetCellValue(Row, "workType",   result.workType);
					sheet1.SetCellValue(Row, "workTypeNm",   result.workTypeNm);
				}
			}
		]
	});
	layerModal.show();

	<%--try {--%>

	<%--	var colName = sheet1.ColSaveName(Col);--%>
	<%--	var args    = new Array();--%>

	<%--	var rv = null;--%>

	<%--	if(colName == "name") {--%>

	<%--	if(!isPopup()) {return;}--%>
	<%--		gPRow = Row;--%>
	<%--		pGubun = "employeePopup";--%>
	<%--		openPopup("/Popup.do?cmd=employeePopup&authPg=${authPg}", args, "740","520");--%>
	<%--	}--%>

	<%--} catch (ex) {--%>
	<%--	alert("OnPopupClick Event Error : " + ex);--%>
	<%--}--%>
}

//엑셀로드시
function sheet1_OnLoadExcel(result) {
	try{
		if(result) {
			for(var i=sheet1.HeaderRows(); i<=sheet1.LastRow(); i++) {
				sheet1.SetCellValue(i, "payGroupCd", $("#searchPayGroupCd").val());
			}
		} else {
			alert("엑셀 로딩중 오류가 발생하였습니다.");
		}
	}catch(ex){alert("OnLoadExcel Event Error : " + ex);}
}

function getReturnValue(returnValue) {
	var rv = $.parseJSON('{' + returnValue+ '}');

    if(pGubun == "employeePopup"){
        sheet1.SetCellValue(gPRow, "name",   rv["name"] );
  	  	sheet1.SetCellValue(gPRow, "sabun",  rv["sabun"] );
        sheet1.SetCellValue(gPRow, "orgNm",  rv["orgNm"] );
        sheet1.SetCellValue(gPRow, "jikchakNm",  rv["jikchakNm"] );
        sheet1.SetCellValue(gPRow, "jikweeNm",  rv["jikweeNm"] );
        sheet1.SetCellValue(gPRow, "jikgubNm",  rv["jikgubNm"] );
        sheet1.SetCellValue(gPRow, "manageNm",  rv["manageNm"] );
        sheet1.SetCellValue(gPRow, "workType",  rv["workType"] );
        sheet1.SetCellValue(gPRow, "workTypeNm",  rv["workTypeNm"] );

    }else if(pGubun == "orgBasicPopup"){
		$("#searchOrgCd").val(rv["orgCd"]);
		$("#searchOrgNm").val(rv["orgNm"]);
    } else if ( pGubun == "sheetAutocompleteEmp" ){
   		sheet1.SetCellValue(gPRow, "sabun",rv["sabun"]);
		sheet1.SetCellValue(gPRow, "name",rv["name"]);
        sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"]);
        sheet1.SetCellValue(gPRow, "jikchakNm",  rv["jikchakNm"] );
        sheet1.SetCellValue(gPRow, "jikweeNm",  rv["jikweeNm"] );
        sheet1.SetCellValue(gPRow, "jikgubNm",  rv["jikgubNm"] );
        sheet1.SetCellValue(gPRow, "manageNm",  rv["manageNm"] );
        sheet1.SetCellValue(gPRow, "workType",  rv["workType"] );
        sheet1.SetCellValue(gPRow, "workTypeNm",  rv["workTypeNm"] );
    }
}

function getMultiSelectValue( value ) {
	if( value == null || value == "" ) return "";
	if (value.indexOf("m") == -1) return value+","; // 선택된 값이 한개일 경우 Dao에서 배열로 바뀌지 않아서 오류남 콤마 추가
	//return "'"+String(value).split(",").join("','")+"'";
		return value;
}

// 소속 팝입
function orgSearchPopup(){

	let layerModal = new window.top.document.LayerModal({
		id : 'orgLayer'
		, url : '/Popup.do?cmd=viewOrgBasicLayer&authPg=A'
		, parameters : {}
		, width : 840
		, height : 520
		, title : '<tit:txt mid='orgSchList' mdef='조직 리스트 조회'/>'
		, trigger :[
			{
				name : 'orgTrigger'
				, callback : function(result){
					if(!result.length) return;

					$("#searchOrgCd").val(result[0].orgCd);
					$("#searchOrgNm").val(result[0].orgNm);
				}
			}
		]
	});
	layerModal.show();

	// try{
	// 	var w 		= 840;
	// 	var h 		= 520;
	// 	var url 	= "/Popup.do?cmd=orgBasicPopup";
	// 	var args 	= new Array();
	//
	// 	args["orgCd"] = "";
	// 	args["orgNm"] = "";
	//
	// 	if(!isPopup()) {return;}
	// 	gPRow = "";
	// 	pGubun = "orgBasicPopup";
	// 	openPopup(url+"&authPg=A", args, w, h);
	// 	/*
	// 	if (result) {
	// 		var orgCd	= result["orgCd"];
	// 		var orgNm	= result["orgNm"];
	//
	// 		$("#orgCd").val(orgCd);
	// 		$("#orgNm").val(orgNm);
	// 	}
	// 	*/
	// }catch(ex){alert("Open Popup Event Error : " + ex);}
}

function chkInVal(sAction) {
	if ($("#searchOjtYear").val() == "") {
		alert("년도를 입력하십시오.");
		$("#searchOjtYear").focus();
		return false;
	}

	return true;
}

</script>



</head>
<body class="hidden">
<div class="wrapper">
<form id="srchFrm" name="srchFrm" >

	<input type="hidden" id="searchManageCdHidden" name="searchManageCdHidden" value="" />
	<input type="hidden" id="searchStatusCdHidden" name="searchStatusCdHidden" value="" />
	<input type="hidden" id="searchJikweeCdHidden" name="searchJikweeCdHidden" value="" />
	<input type="hidden" id="searchJikchakCdHidden" name="searchJikchakCdHidden" value="" />
	<input type="hidden" id="searchJikgubCdHidden" name="searchJikgubCdHidden" value="" />

<%--	<input type="hidden" id="columnInfo" name="columnInfo" value="" />--%>

		<div class="sheet_search outer">
			<div>
				<table>
				<!--
					<tr>
						<td> 
							<span class="w50">조회기간 </span>
							<input type="text" id="searchSDate" name="searchSDate" class="date2" value="${curSysYyyyMMddHyphen}" />
							~ <input type="text" id="searchEDate" name="searchEDate" class="date2" value="${curSysYyyyMMddHyphen}" />
						</td>
						<td> 
							<span class="w50">연봉그룹명</span>
							<select id="searchPayGroupCd" name ="searchPayGroupCd" ></select> 
						</td>
						<td> 
							<span class="w50">소속</span>
							<input id="searchOrgNm" name ="searchOrgNm" type="text" class="text w100" /> 
						</td>
<%-- 						<input type="hidden" id="searchOrgCd" name="searchOrgCd" class="text" value="" />
						<input type="text" id="searchOrgNm" name="searchOrgNm" class="text" value="" readonly="readonly" style="width:120px" />
						<a onclick="javascript:orgSearchPopup();" href="#" class="button6"><img src="/common/${theme}/images/btn_search2.gif" /></a>
						<a onclick="$('#searchOrgCd,#searchOrgNm').val('');" href="#" class="button7"><img src="/common/${theme}/images/icon_undo.gif" /></a> --%> </td>
						
						<td> 
							<span class="w50">직급</span>
							<select id="searchJikgubCd" name ="searchJikgubCd" multiple=""></select> 
						</td>
						
					</tr>
					<tr>
						<td> 
							<span class="w50">계약유형 </span>
							<select id="searchManageCd" name ="searchManageCd" multiple=""></select> 
							<span class="w50">직책</span>
							<select id="searchJikchakCd" name ="searchJikchakCd" multiple=""></select>
						</td>
						<td> 
							<span class="w50">직위</span>
							<select id="searchJikweeCd" name ="searchJikweeCd" multiple=""></select> 
						</td>
						<td> 
							<span class="w50">사번/성명</span>
							<input id="searchNm" name ="searchNm" type="text" class="text" /> 
						</td>
						<td> 
							<span class="w50">재직상태</span>
							<select id="searchStatusCd" name ="searchStatusCd" multiple=""></select> 
						</td>
					    <td> 
					    	<a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a> 
					    </td>
					</tr>
		  		-->
					<tr>
						<th>조회기간 </th>
						<td> 
							<input type="text" id="searchSDate" name="searchSDate" class="date2" value="${curSysYyyyMMddHyphen}" />
							~ <input type="text" id="searchEDate" name="searchEDate" class="date2" value="${curSysYyyyMMddHyphen}" />
						</td>
						<th>연봉그룹명</th>
						<td> 
							<select id="searchPayGroupCd" name ="searchPayGroupCd" ></select> 
						</td>
						<th>소속</th>
						<td> 
							<input id="searchOrgNm" name ="searchOrgNm" type="text" class="text w100" /> 
						</td>

						
					</tr>
					<tr>
					<%-- 						<input type="hidden" id="searchOrgCd" name="searchOrgCd" class="text" value="" />
						<input type="text" id="searchOrgNm" name="searchOrgNm" class="text" value="" readonly="readonly" style="width:120px" />
						<a onclick="javascript:orgSearchPopup();" href="#" class="button6"><img src="/common/${theme}/images/btn_search2.gif" /></a>
						<a onclick="$('#searchOrgCd,#searchOrgNm').val('');" href="#" class="button7"><img src="/common/${theme}/images/icon_undo.gif" /></a> --%> </td>
						
						<th>직급</th>
						<td> 
							<select id="searchJikgubCd" name ="searchJikgubCd" multiple=""></select> 
						</td>
						<th>계약유형 </th>
						<td><select id="searchManageCd" name ="searchManageCd" multiple=""></select></td>
						<th>직책</th>
						<td><select id="searchJikchakCd" name ="searchJikchakCd" multiple=""></select></td>
					</tr>
					
					<tr>
						<th>직위</th>
						<td> 
							<select id="searchJikweeCd" name ="searchJikweeCd" multiple=""></select> 
						</td>
						<th>사번/성명</th>
						<td> 
							<input id="searchNm" name ="searchNm" type="text" class="text" /> 
						</td>
						<th>재직상태</th>
						<td> 
							<select id="searchStatusCd" name ="searchStatusCd" multiple=""></select> 
						</td>
					    <td> 
					    	<a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a> 
					    </td>
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
							<li id="txt" class="txt">연봉관리</li>
							<li class="btn">
								<a id="pivot-config"	class="basic authR">피벗 설정</a>
								<a id="go-base"	class="basic authR">원본 시트 보기</a>
 								<!-- <a href="javascript:doAction1('AutoCalculate')" class="basic authA">연봉계산</a> -->
 								<a href="javascript:doAction1('edateUpdate')" 	class="button">종료일자UPDATE</a>
 								<a href="javascript:doAction1('Down2Template')" class="basic authA">양식다운로드</a>
								<a href="javascript:doAction1('LoadExcel')" 	class="basic authA">업로드</a>
								<a href="javascript:doAction1('Insert')"		class="basic authA">입력</a>
								<a href="javascript:doAction1('Copy')"			class="basic authA">복사</a>
								<a href="javascript:doAction1('Save')"			class="basic authA">저장</a>
								<a href="javascript:doAction1('Down2Excel')"	class="basic authR">다운로드</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>