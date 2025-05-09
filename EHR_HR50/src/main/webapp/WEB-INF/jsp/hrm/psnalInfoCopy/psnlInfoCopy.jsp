<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>인사정보복사</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly,FrozenCol:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No|No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"복사원본|회사코드",		Type:"Text",		Hidden:1,					Width:100,	Align:"Left",	ColMerge:0,	SaveName:"oriEnterCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"복사원본|회사",			Type:"Text",		Hidden:1,					Width:100,	Align:"Left",	ColMerge:0,	SaveName:"oriEnterNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"복사원본|소속",			Type:"Text",		Hidden:0,					Width:100,	Align:"Left",	ColMerge:0,	SaveName:"oriOrgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"복사원본|직급",			Type:"Text",		Hidden:Number("${jgHdn}"),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"oriJikgubNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"복사원본|직위",			Type:"Text",		Hidden:Number("${jwHdn}"),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"oriJikweeNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"복사원본|사번",			Type:"Text",		Hidden:0,					Width:80,	Align:"Center",	ColMerge:0,	SaveName:"oriSabun",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"복사원본|성명",			Type:"Text",		Hidden:0,					Width:80,	Align:"Center",	ColMerge:0,	SaveName:"oriName",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"복사원본|퇴사일자",		Type:"Date",		Hidden:0,					Width:80,	Align:"Center",	ColMerge:0,	SaveName:"retYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },

			{Header:"복사대상|사번",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"복사대상|성명",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"복사확정|복사확정",		Type:"CheckBox",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"copyYn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N"},
			{Header:"복사취소|복사취소",		Type:"CheckBox",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"cancelYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N"},
			{Header:"작업구분|작업구분",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"endNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"비고|비고",			Type:"Text",		Hidden:0,	Width:200,	Align:"Center",	ColMerge:0,	SaveName:"note",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:200 }

		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		$(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");
		
		// 이름 입력 시 자동완성
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "oriName",
					CallbackFunc : function(returnValue){
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow, "oriEnterCd",	rv["enterCd"]);
						sheet1.SetCellValue(gPRow, "oriEnterNm",	rv["enterNm"]);
						sheet1.SetCellValue(gPRow, "oriOrgNm",		rv["orgNm"]);
						sheet1.SetCellValue(gPRow, "oriSabun",		rv["sabun"]);
						sheet1.SetCellValue(gPRow, "oriName",		rv["name"]);
						sheet1.SetCellValue(gPRow, "oriJikgubNm",	rv["jikgubNm"]);
						sheet1.SetCellValue(gPRow, "oriJikweeNm",	rv["jikweeNm"]);
						sheet1.SetCellValue(gPRow, "retYmd",		rv["retYmd"]);
					}
				},
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue){
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow, "sabun",	rv["sabun"]);
						sheet1.SetCellValue(gPRow, "name",	rv["name"]);
					}
				}
			]
		});
		
	});

	$(function() {

        $("#srchName").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/PsnlInfoCopy.do?cmd=getPsnlInfoCopyList", $("#srchForm").serialize());
			break;
		case "Save":
			if(!dupChk(sheet1,"sabun", true, true)){break;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/PsnlInfoCopy.do?cmd=savePsnlInfoCopy", $("#sheet1Form").serialize());
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			break;
		case "procAppr":
	        var cnt = 0;
	        for(var i = 2; i < sheet1.RowCount()+2; i++) {
	            if(sheet1.GetCellValue(i, "sStatus") != "R") {
	                alert("변경된 건이 있어 작업을 진행할 수 없습니다.\n변경된 건에 대해 저장을 하신 후 작업하기시 바랍니다.");
	                return;
	            }
	            if(sheet1.GetCellValue(i, "copyYn") == "Y") {
	                cnt++;
	            }
	        }

	        if(cnt == 0) {
	            alert("복사처리중인 데이터가 없습니다.");
	            return;
	        }

	        if (!confirm("[복사실행]은 모든 복사처리중인 데이터에 대해서 복사가 됩니다. 복사실행을 하시겠습니까?")) {
	        	return;
	        }

	    	var data = ajaxCall("${ctx}/PsnlInfoCopy.do?cmd=prcPsnlInfoCopySave","",false);

	    	if(data.Result.Code == "1") {
	    		alert("처리되었습니다.");
	    		doAction1("Search");
	    	} else {
		    	alert(data.Result.Message);
	    	}

			break;
		case "procCancel":
	        var cnt = 0;
	        for(var i = 2; i < sheet1.RowCount()+2; i++) {
	            if(sheet1.GetCellValue(i, "sStatus") != "R") {
	                alert("변경된 건이 있어 작업을 진행할 수 없습니다.\n변경된 건에 대해 저장을 하신 후 작업하기시 바랍니다.");
	                return;
	            }
	            if(sheet1.GetCellValue(i, "cancelYn") == "Y") {
	                cnt++;
	            }
	        }

	        if(cnt == 0) {
	            alert("취소처리중인 데이터가 없습니다.");
	            return;
	        }

	        if (!confirm("[복사취소]는 모든 취소처리중인 데이터에 대해서 취소 됩니다. 복사취소 하시겠습니까?")) {
	        	return;
	        }

	    	var data = ajaxCall("${ctx}/PsnlInfoCopy.do?cmd=prcPsnlInfoCopyCancel","",false);

	    	if(data.Result.Code == "1") {
	    		alert("처리되었습니다.");
	    		doAction1("Search");
	    	} else {
		    	alert(data.Result.Message);
	    	}

			break;
		case "Copy":
			var row = sheet1.DataCopy();
			sheet1.SetCellValue( row, "sabun", "");
			sheet1.SetCellValue( row, "name", "");
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
	
	function sheet1_OnBeforeCheck(Row, Col) {
		try {
			
			sheet1.SetAllowCheck(true);
			
			if(sheet1.ColSaveName(Col) == "copyYn") {
				
				if(sheet1.GetCellValue(Row,"cancelYn") == "Y") {
					alert("복사확정 및 복사취소는 동시선택이 가능하지 않습니다.");
					sheet1.SetAllowCheck(false);
				}else{
					sheet1.SetAllowCheck(true);
				}
				
			}else if(sheet1.ColSaveName(Col) == "cancelYn") {
				
				if(sheet1.GetCellValue(Row,"copyYn") == "Y") {
					alert("복사확정 및 복사취소는 동시선택이 가능하지 않습니다.");
					sheet1.SetAllowCheck(false);
				}else{
					sheet1.SetAllowCheck(true);
				}
			}
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}


	//키를 눌렀을때 발생.
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			if(sheet1.GetCellEditable(Row,Col) == true) {
				if(sheet1.ColSaveName(Col) == "oriName" && KeyCode == 46) {
					sheet1.SetCellValue(Row,"oriEnterCd", "");
					sheet1.SetCellValue(Row,"oriEnterNm", "");
					sheet1.SetCellValue(Row,"oriSabun", "");
					sheet1.SetCellValue(Row,"oriOrgNm", "");
					sheet1.SetCellValue(Row,"oriJikweeNm", "");
					sheet1.SetCellValue(Row,"oriJikgubNm", "");
					sheet1.SetCellValue(Row,"oriName", "");
					sheet1.SetCellValue(Row,"retYmd", "");
				}
			}
		} catch (ex) {
			alert("OnKeyDown Event Error " + ex);
		}
	}

	// 팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
			if(sheet1.ColSaveName(Col) == "oriName") {
				employeePopup(Row, Col);
			}else if ( sheet1.ColSaveName(Col) == "name" ){
				employeePopup(Row, Col);
			}
		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}
	
	function employeePopup(Row, Col){
		
		if(!isPopup()) {return;}

		var arg = [];
		arg["searchEnterCdView"] = "Y";

		gPRow = Row;
		pGubun = sheet1.ColSaveName(Col);
		
        openPopup("/Popup.do?cmd=employeePopup&authPg=R", arg, "740","520");
	}

	function getReturnValue(returnValue) {
       	var rv = $.parseJSON('{' + returnValue+ '}');
        if(pGubun == "oriName"){
        	sheet1.SetCellValue(gPRow,"oriEnterCd", "${ssnEnterCd}");
			sheet1.SetCellValue(gPRow,"oriEnterNm", "");
			sheet1.SetCellValue(gPRow,"oriSabun", rv["sabun"]);
			sheet1.SetCellValue(gPRow,"oriOrgNm", rv["orgNm"]);
			sheet1.SetCellValue(gPRow,"oriJikgubNm", rv["jikgubNm"]);
			sheet1.SetCellValue(gPRow,"oriJikweeNm", rv["jikweeNm"]);
			sheet1.SetCellValue(gPRow,"oriName", rv["name"]);
			sheet1.SetCellValue(gPRow,"retYmd", rv["retYmd"]);
        }else if(pGubun == "name"){
        	sheet1.SetCellValue(gPRow,"sabun", rv["sabun"]);
        	sheet1.SetCellValue(gPRow,"name", rv["name"]);
        }
	}
</script>
</head>
<body class="bodywrap">
<form id="sheet1Form" name="sheet1Form"></form>
<div class="wrapper">
	<form id="srchForm" name="srchForm">
	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<th>사번/성명</th>
			<td>
				<input id="srchName" name="srchName" type="text" class="text"/>
			</td>
			<td>
				<btn:a href="javascript:doAction1('Search');" css="btn dark" mid='search' mdef="조회"/>
			</td>
		</tr>
		</table>
		</div>
	</div>
	</form>
	<div class="outer">
		<div class="explain">
			<div class="title">※ 도움말</div>
			<div class="txt">
				<ul>
					<li>▶ 복사대상 : 인사마스터, 가족, 주소, 연락처, 학력, 경력, 보증, 병역, 병역특례, 보훈, 장애, 어학, 포상, 징계, 연수</li>
					<li>▶ 수동 복사대상 : 발령 (아래 두곳 메뉴 중 한곳에서 이전 발령 처리) </li>
					<li> - 인사관리 > 발령정보 > 발령내역수정</li>
					<li> - 인사관리 > 발령정보 > 발령처리</li>
					<li> - 인사관리 > 발령정보 > 발령처리</li>
					<li><strong color="point-red">※ 인사자료 삭제 처리 후 복사되므로 참고 바랍니다. (필수 : 채용 발령 처리 후 사용)</strong></li>
				</ul>
			</div>
		</div>
		<div class="sheet_title">
		<ul>
			<li class="txt">인사정보복사</li>
			<li class="btn">
				<btn:a href="javascript:doAction1('procAppr');" css="btn outline authA" mid='111823' mdef="복사실행"/>
				<btn:a href="javascript:doAction1('procCancel');" css="btn outline authA" mid='111061' mdef="복사취소"/>
				<btn:a href="javascript:doAction1('Insert');" css="btn outline_gray authA" mid='insert' mdef="입력"/>
				<btn:a href="javascript:doAction1('Save');" css="btn filled authA" mid='save' mdef="저장"/>
				<btn:a href="javascript:doAction1('Down2Excel');" css="btn outline_gray authR" mid='down2excel' mdef="다운로드"/>
			</li>
		</ul>
		</div>
	</div>

	<script type="text/javascript"> createIBSheet("sheet1", "100%", "98%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
