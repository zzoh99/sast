<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>인사기본(직무)</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<%@ include file="/WEB-INF/jsp/hrm/psnalInfo/psnalBasicInf/psnalBasicDefined.jsp"%>

<script type="text/javascript">
	$(function() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:0,Page:22,FrozenCol:0,DataRowMerge:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0},
			{Header:"상태",		Type:"${sSttTy}", 	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0},
			{Header:"사번",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직무",		Type:"Text",	Hidden:1,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"jobCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"직무",		Type:"Popup",	Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"jobNm",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"시작일",		Type:"Date",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"종료일",		Type:"Date",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"수행기간",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"workYmCnt",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		//관리자가 아닌 경우 table 수정불가로
		if("${authPg}" == 'R') sheet1.SetEditable(false);

		$(window).smartresize(sheetResize); sheetInit();
	
		setEmpPage() ;
	});
	
	function setEmpPage() { 
		$("#hdnSabun").val($("#searchUserId",parent.document).val());
	
		doAction1("Search");
	}


	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var param = "sabun="+$("#hdnSabun").val();
			sheet1.DoSearch( "${ctx}/PsnalJob.do?cmd=getPsnalJobList", param );
			break;
		case "Save":
			IBS_SaveName(document.srchFrm,sheet1);
			sheet1.DoSave( "${ctx}/PsnalJob.do?cmd=savePsnalJob", $("#srchFrm").serialize());
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			sheet1.SelectCell(row, "jobNm");
			sheet1.SetCellValue(row, "sabun", $("#hdnSabun").val());
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
		}
	}

	// 조회 후 에러 메시지
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

	// 저장 후 이벤트
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != "") alert(Msg);

			//작업

			doAction1("Search");
		}catch(ex){
			alert("OnSaveEnd Event Error : " + ex);
		}
	}

	// 팝업 클릭시 이벤트
	function sheet1_OnPopupClick(Row, Col){
		try{
			switch(sheet1.ColSaveName(Col)){
				case "jobNm":
					gPRow = Row;
					pGubun = "jobPopup";
					//var args = new Array();
					//args["searchJobType"] = "10030";
					//var args = { "searchJobType": "10030"};
					//openPopup("/Popup.do?cmd=jobSchemePopup&authPg=R", args, "800","520");
					jobSchemePopup();
					break;
			}
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}
	
    // 직무검색 팝입
    function jobSchemePopup(Row, Col) {
        var args = new Array();
        args["searchJobType"] = "10030";
        let layerModal = new window.top.document.LayerModal({
            id : 'jobSchemeLayer'
            , url : '/Popup.do?cmd=viewJobSchemeLayer&authPg=R'
            , parameters : {
                searchJobType : '10030'
            }
            , width : 800
            , height : 520
            , title : '직무분류표 조회'
            , trigger :[
                { 
                     name : 'jobSchemeTrigger'
                    , callback : function(result){
                        sheet1.SetCellValue(gPRow, "jobCd", result.jobCd);
                        sheet1.SetCellValue(gPRow, "jobNm", result.jobNm);
                    }
                }
            ]
        });
        layerModal.show();
    }
	
	function sheet1_OnChange(Row, Col, Value) {
		try{
			if( sheet1.ColSaveName(Col) == "sdate" || sheet1.ColSaveName(Col) == "edate"  ) {
				if(sheet1.GetCellValue(Row,"sdate") != "" && sheet1.GetCellValue(Row,"edate") != "") {
					if(sheet1.GetCellValue(Row,"sdate") > sheet1.GetCellValue(Row,"edate")) {
						alert("직무종료일은 시작일 이후 날짜로 입력하여 주십시오.");
						sheet1.SetCellValue(Row,"edate","");
					}
				}
			}
		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}

	// 팝업 리턴 함수
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');
		if(pGubun == "jobPopup") {
			sheet1.SetCellValue(gPRow, "jobCd", rv["jobCd"]);
			sheet1.SetCellValue(gPRow, "jobNm", rv["jobNm"]);
		}
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
	<input id="hdnSabun" name="hdnSabun" type="hidden">
	<input id="hdnAuthPg" name="hdnAuthPg" type="hidden" value="${authPg}">
	</form>

	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">직무</li>
			<li class="btn">
				<btn:a href="javascript:doAction1('Search');" css="btn dark authR" mid='search' mdef="조회"/>
				<btn:a href="javascript:doAction1('Insert');" css="btn outline_gray authA" mid='insert' mdef="입력"/>
				<btn:a href="javascript:doAction1('Save');" css="btn filled authA" mid='save' mdef="저장"/>
				<btn:a href="javascript:doAction1('Down2Excel');" css="btn outline_gray authR" mid='down2excel' mdef="다운로드"/>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
