<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">

var p = eval("${popUpStatus}");

$(function() {

	var arg = p.window.dialogArguments;
	var t_searchAppraisalCd;
	var t_searchAppraisalCd1;

	if( arg != undefined ) {
    	$("#searchSabun").val(arg["searchSabun"]); // 상벌점 실적에서 쓸 파라미터
    	$("#searchAppSabun").val(arg["searchSabun"]); // 코칭에서 쓸 파라미터
    	t_searchAppraisalCd = arg["searchAppraisalCd"]; // 실적에서 쓸 파라미터
    	t_searchAppraisalCd1 = arg["searchAppraisalCd"]; // 코칭내용에서 쓸 파라미터
    	$("#searchYear").val("20"+arg["searchAppraisalCd"].substring(0,2));
    }

	//평가진행상태
	 var result = ajaxCall("/CompAppSelfReg.do?cmd=getCompAppSelfRegSearchAppraisalCdMap","searchAppraisalCd="+t_searchAppraisalCd,false);

	 if(result != null && result.map != null){
		$("#searchAppraisalCd").val(result.map.searchAppraisalCd); // 실적에서 쓸 파라미터
	 }

	//평가진행상태
	 var result = ajaxCall("/CompAppSelfReg.do?cmd=getCompAppSelfRegSearchAppraisalCdMap","searchAppraisalCd="+t_searchAppraisalCd1 + "&searchAppTypeCd=F",false);

	 if(result != null && result.map != null){
		$("#searchAppraisalCd1").val(result.map.searchAppraisalCd); // 코칭에서 쓸 파라미터
	 }

     $(".close").click(function() {
	    	p.self.close();
     });

	var initdata = {};
	initdata.Cfg = {FrozenCol:4,SearchMode:smLazyLoad,Page:22};
	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
	initdata.Cols = [
		{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"삭제",		Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
		{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
		{Header:"목표측정지표(KPI)",	Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"mboIndexKpi",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:300 },
		{Header:"지표구분",			Type:"Combo",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appIndexGubunCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"가중치(%)",			Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appBasisPoint",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:3 },
		{Header:"목표",				Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"mboTarget",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:300 },
		{Header:"측정방법",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appIndexMethod",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:300,ToolTip:1 },
		{Header:"본인실적",			Type:"Text",	Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"appSelfResult",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100,ToolTip:1 },
		{Header:"본인평가",			Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appClassCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"SEQ",				Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"seq",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"평가id",			Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"사번",				Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
		{Header:"자기평가확정여부",	Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appraisalYn",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"평가점수",			Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appPoint",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"첨부파일",			Type:"Html",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"btnFile",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
		{Header:"첨부번호",			Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"fileSeq",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 }
	]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);/* sheet1.SetCountPosition(4); */



	var initdata2 = {};
	initdata2.Cfg = {FrozenCol:4,SearchMode:smLazyLoad,Page:22};
	initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
	initdata2.Cols = [
		{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"삭제",		Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
		{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
		{Header:"평가id",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"사번",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
		{Header:"본인의견",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appMemo",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 }
	]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

	//지표구분
	var comboCodeList2 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00011"), "");
	sheet1.SetColProperty("appIndexGubunCd", 			{ComboText:comboCodeList2[0], ComboCode:comboCodeList2[1]} );


	var initdata = {};
	initdata.Cfg = {/* FrozenCol:6 ,*/SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
	initdata.Cols = [
		{Header:"No",		Type:"${sNoTy}",	Hidden:1,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"삭제",		Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
		{Header:"상태",		Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
		{Header:"일자",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"ymd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"구분",		Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"gubun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"상세구분",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"gubunNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"내용",		Type:"Text",	Hidden:0,	Width:200,	Align:"Center",	ColMerge:0,	SaveName:"memo",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"상벌점",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sPoint",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"승진포인트",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sgPoint",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 }
	]; IBS_InitSheet(sheet3, initdata);sheet3.SetEditable("${editable}");sheet3.SetVisible(true);/* sheet3.SetCountPosition(4); */sheet3.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

	var gubun 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P20040"), "전체");
	sheet3.SetColProperty("gubun", 			{ComboText:gubun[0], ComboCode:gubun[1]} );

	var initdata = {};
	initdata.Cfg = {/* FrozenCol:6 ,*/SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
	initdata.Cols = [
		{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"삭제",		Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
		{Header:"상태",		Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
		{Header:"평가ID코드(TPAP101)",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"사원번호",				Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"평가소속코드",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"평가차수코드",			Type:"Text",	Hidden:1,	Width:200,	Align:"Center",	ColMerge:0,	SaveName:"appSeqCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"평가자사번",				Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appSabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"코칭일자",				Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"coaYmd",			KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"코칭장소",				Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"coaPlace",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1330 },
		{Header:"코칭내용",				Type:"Text",	Hidden:0,	Width:300,	Align:"Left",	ColMerge:0,	SaveName:"memo",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1330,  MultiLineText:1,Wrap:1, ToolTip:1  }
	]; IBS_InitSheet(sheet4, initdata);sheet4.SetEditable("${editable}");sheet4.SetVisible(true);/* sheet4.SetCountPosition(4); */sheet4.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");


	var coboCodeList1 = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAppraisalCdListMobOrgTargetReg&searchAppStepCd=3&searchAppTypeCd=F&searchAppraisalSeq=0",false).codeList, "");	//평가명
	var coboCodeList2 = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAppIndexGubunCdList",false).codeList, "");	//지표구분
	$("#searchAppraisalCd").html(coboCodeList1[2]);
	sheet4.SetColProperty("appIndexGubunCd", 			{ComboText:coboCodeList2[0], ComboCode:coboCodeList2[1]} );



	$(window).smartresize(sheetResize); sheetInit();
	doAction1("Search");
});

//Sheet1 Action
function doAction1(sAction) {
	switch (sAction) {
	case "Search": 	 	sheet1.DoSearch( "${ctx}/MboAppSelfReg.do?cmd=getMboAppSelfRegList", $("#srchFrm").serialize() ); break;
	case "Save":
						IBS_SaveName(document.srchFrm,sheet1);
						sheet1.DoSave( "${ctx}/MboAppSelfReg.do?cmd=saveMboAppSelfReg", $("#srchFrm").serialize()); break;
	case "Insert":		sheet1.SelectCell(sheet1.DataInsert(0), "col2"); break;
	case "Copy":		sheet1.DataCopy(); break;
	case "Clear":		sheet1.RemoveAll(); break;
	case "Down2Excel":
		var downcol = makeHiddenSkipCol(sheet1);
		var param = {DownCols:downcol, SheetDesign:1, Merge:1};
		sheet1.Down2Excel(param);
	break;
	case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
	}
}
//Example Sheet2 Action
function doAction2(sAction) {
	switch (sAction) {
	case "Search": 	 	sheet2.DoSearch( "${ctx}/MboAppSelfReg.do?cmd=getMboAppSelfRegList2", $("#srchFrm").serialize() ); break;
	case "Save": 		setSheetData();
						if($("#searchStatusCd").val() == "5"){
							alert("평가완료 상태에서는 저장할 수 없습니다.");
							 break;
						}
						IBS_SaveName(document.srchFrm,sheet2);
						sheet2.DoSave( "${ctx}/MboAppSelfReg.do?cmd=saveMboAppSelfReg2", $("#srchFrm").serialize()); break;
	case "Insert":		sheet2.SelectCell(sheet1.DataInsert(0), "col2"); break;
	case "Copy":		sheet2.DataCopy(); break;
	case "Clear":		sheet2.RemoveAll(); break;
	case "Down2Excel":	sheet2.Down2Excel(); break;
	case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
	}
}

// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try{
		if (Msg != ""){
			alert(Msg);
		}

		//목표측정KIP ComboBox
		 var coboCodeList3 = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getTargetIndexKpiCdListSabun&searchSabun="+$("#searchSabun").val()+"&searchAppraisalCd="+$("#searchAppraisalCd").val(),false).codeList, "");
         sheet1.SetColProperty("mboIndexKpi", 			{ComboText:coboCodeList3[0], ComboCode:coboCodeList3[1]} );



		 if($("#searchStatusCd").val() == "5"){
			sheet1.SetColEditable("appSelfResult",0);
		 }else{
			sheet1.SetColEditable("appSelfResult",1);
		 }
		//파일 첨부 시작
			for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){

					if(sheet1.GetCellValue(i,"fileSeq") == ''){
						sheet1.SetCellValue(i, "btnFile", '<a class="basic">첨부</a>');
						sheet1.SetCellValue(i, "sStatus", 'R');
					}else{
						sheet1.SetCellValue(i, "btnFile", '<a class="basic">다운로드</a>');
						sheet1.SetCellValue(i, "sStatus", 'R');
					}
			}
		doAction2("Search");
		sheetResize();
	}catch(ex){
		alert("OnSearchEnd Event Error : " + ex);
	}
}

// 조회 후 에러 메시지
function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try{
		if (Msg != ""){
			alert(Msg);
		}
		getSheetData();

		doAction3("Search");
		sheetResize();
	}catch(ex){
		alert("OnSearchEnd Event Error : " + ex);
	}
}



// 저장 후 메시지
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try{
		if(Msg != ""){
			alert(Msg);
		}
		doAction1("Search");
	}catch(ex){
		alert("OnSaveEnd Event Error " + ex);
	}
}


// 저장 후 메시지
function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try{
		if(Msg != ""){
			alert(Msg);
		}
		doAction2("Search");
	}catch(ex){
		alert("OnSaveEnd Event Error " + ex);
	}
}

// 셀에서 키보드가 눌렀을때 발생하는 이벤트
function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
	try {
		// Insert KEY
		if (Shift == 1 && KeyCode == 45) {
			doAction1("Insert");
		}
		//Delete KEY
		if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
			sheet1.SetCellValue(Row, "sStatus", "D");
		}
	} catch (ex) {
		alert("OnKeyDown Event Error : " + ex);
	}
}

function sheet1_OnClick(Row, Col, Value) {
	try{

		var rv = null;
		var args    = new Array();

		args["elementType"] = sheet1.GetCellValue(Row, "elementType");
		args["elementCd"]   = sheet1.GetCellValue(Row, "elementCd");
		args["elementNm"]   = sheet1.GetCellValue(Row, "elementNm");
		args["sdate"]       = sheet1.GetCellValue(Row, "sdate");

		if(Row > 0 && sheet1.ColSaveName(Col) == "detail"){
			var rv = openPopup("/PayAllowanceElementPropertyPopup.do?cmd=payAllowanceElementPropertyPopup", args, "1000","520");
			if(rv!=null){
			}
		}

		if(sheet1.ColSaveName(Col) == "btnFile"){
			var param = [];
			param["fileSeq"] = sheet1.GetCellValue(Row,"fileSeq");
			if(sheet1.GetCellValue(Row,"btnFile") != ""){
				var authPgTemp="${authPg}";
				var rv = openPopup("/fileuploadJFileUpload.do?cmd=fileMgrPopup&authPg="+authPgTemp, param, "740","620");
				if(rv != null){
					if(rv["fileCheck"] == "exist"){
						sheet1.SetCellValue(Row, "btnFile", '<a class="basic">다운로드</a>');
						sheet1.SetCellValue(Row, "fileSeq", rv["fileSeq"]);
					}else{
						sheet1.SetCellValue(Row, "btnFile", '<a class="basic">첨부</a>');
						sheet1.SetCellValue(Row, "fileSeq", "");
					}
				}
			}
		}
	}catch(ex){alert("OnClick Event Error : " + ex);}
}

//Sheet1 Action
function doAction3(sAction) {
	switch (sAction) {
		case "Search":
			sheet3.DoSearch( "${ctx}/CompApp1stApr.do?cmd=getCompApp1stAprPrizePopupList", $("#srchFrm").serialize() );
			break;
	}
}

// 조회 후 에러 메시지
function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != ""){
			alert(Msg);
		}
		doAction4("Search");
		sheetResize();
	} catch (ex) {
		alert("OnSearchEnd Event Error : " + ex);
	}
}

//Sheet1 Action
function doAction4(sAction) {
	switch (sAction) {
	case "Search": 	 	case "Search": 	 	sheet4.DoSearch( "${ctx}/CompApp1stApr.do?cmd=getMboCoachingAprListPopup", $("#srchFrm").serialize() ); break;
	}
}

// 조회 후 에러 메시지
function sheet4_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}


// 시트에서 폼으로 세팅.
function getSheetData() {

	var chkCnt = sheet2.RowCount();
	var row = sheet2.LastRow();

	if(chkCnt == 0) {
		$('#searchAppMemo').val("");
		return;
	}

	$('#searchAppMemo').val(sheet2.GetCellValue(row,"appMemo"));
}

// 폼에서 시트로 세팅.
function setSheetData() {
	var chkCnt = sheet2.RowCount();
	var row;
	if(chkCnt  == 0){
		row = sheet2.DataInsert(0);
	}else{
		row = sheet2.LastRow();
	}
	sheet2.SetCellValue(row,"appraisalCd",$("#searchAppraisalCd").val());
	sheet2.SetCellValue(row,"sabun",$("#searchSabun").val());
	sheet2.SetCellValue(row,"appMemo",$("#searchAppMemo").val());
}


</script>
</head>
<body class="bodywrap">
    <div class="wrapper">
        <div class="popup_title">
            <ul>
                <li>실적현황</li>
                <li class="close"></li>
            </ul>
        </div>
        <div class="popup_main">
            <form id="srchFrm" name="srchFrm">
                <input type="hidden" id="searchSabun" name="searchSabun" value=""/>
                <input type="hidden" id="searchAppSabun" name="searchAppSabun" value=""/>
                <input type="hidden" id="searchAppraisalCd" name="searchAppraisalCd" />
                <input type="hidden" id="searchAppraisalCd1" name="searchAppraisalCd1" />
                <input type="hidden" id="searchYear" name="searchYear" />
	        </form>
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li id="txt" class="txt">실적</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript">createIBSheet("sheet1", "100%", "50%","kr"); </script>
			<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">본인의견</li>
						</ul>
					</div>
					<table class="table w100p" id="htmlTable">
						<tr>
							<td >
								<textarea disabled="disabled" id="searchAppMemo" name="searchAppMemo" class="w100p" rows="3"></textarea>
							</td>
						</tr>
					</table>
				</div>
				<div style="display:none">
				<script type="text/javascript">createIBSheet("sheet2", "100%", "10%","kr"); </script>
				</div>

			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li id="txt" class="txt">상벌점</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript">createIBSheet("sheet3", "100%", "50%","kr"); </script>

			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li id="txt" class="txt">코칭</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript">createIBSheet("sheet4", "100%", "50%","kr"); </script>
	        <div class="popup_button outer">
	            <ul>
	                <li>
	                    <a href="javascript:p.self.close();" class="gray large">닫기</a>
	                </li>
	            </ul>
	        </div>
        </div>
    </div>
</body>
</html>