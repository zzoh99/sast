<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>업적점수결과업로드</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";
var classCdList = null;	// 선택평가의 평가등급 코드 목록(TPAP110)

	$(function() {

		$("input[type='text']").keydown(function(event){
			if(event.keyCode == 27){
				return false;
			}
		});


//=========================================================================================================================================

		var searchAppraisalCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdList&searchAppTypeCd=A,B,C",false).codeList, "");
		$("#searchAppraisalCd").html(searchAppraisalCd[2]);

//=========================================================================================================================================


		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"평가ID",			Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",			KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"사번",				Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",				KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"성명",				Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",				KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:50 },
			{Header:"평가소속코드",			Type:"Text",	Hidden:0,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"appOrgCd",			KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:200 },
			{Header:"평가소속",			Type:"Popup",	Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"appOrgNm",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:200 },
			//{Header:"소속",				Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appOrgNm",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:200 },
			{Header:"직급명",				Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직위명",				Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		
			/*
			{Header:"직위(H20030)",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"직무코드(TORG201)",	Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jobCd",				KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"직무명",				Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jobNm",				KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500 },
			{Header:"직군코드(H10050)",	Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"workType",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"직종명",				Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"workTypeNm",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"직책명",				Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"직책(H20020)",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikchakCd",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"직급(H20010)",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },

			*/
			
			{Header:"본인업적점수",		Type:"Text",	Hidden:1,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"mboTAppSelfPoint",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"본인역량점수",		Type:"Text",	Hidden:1,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"compTAppSelfPoint",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"본인업적등급",		Type:"Combo",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"mboTAppSelfClassCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"본인역량등급",		Type:"Combo",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"compTAppSelfClassCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },

			{Header:"1차업적점수",		Type:"Text",	Hidden:1,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"mboTApp1stPoint",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"1차역량점수",		Type:"Text",	Hidden:1,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"compTApp1stPoint",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"1차업적등급",		Type:"Combo",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"mboTApp1stClassCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"1차역량등급",		Type:"Combo",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"compTApp1stClassCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			
			{Header:"2차업적점수",		Type:"Text",	Hidden:1,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"mboTApp2ndPoint",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"2차역량점수",		Type:"Text",	Hidden:1,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"compTApp2ndPoint",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"2차업적등급",		Type:"Combo",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"mboTApp2ndClassCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"2차역량등급",		Type:"Combo",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"compTApp2ndClassCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			
			{Header:"3차업적점수",		Type:"Text",	Hidden:1,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"mboTApp3rdPoint",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"3차역량점수",		Type:"Text",	Hidden:1,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"compTApp3rdPoint",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"3차업적등급",		Type:"Combo",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"mboTApp3rdClassCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"3차역량등급",		Type:"Combo",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"compTApp3rdClassCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },

			{Header:"평가점수",			Type:"Int",		Hidden:1,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"mboPoint",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			
			{Header:"최종수정시간",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"chkdate",				KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"최종수정자",			Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"chkid",				KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"최종수정자",			Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"chkname",				KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		//Autocomplete	
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue) {
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow,"name"      , rv["name"]);
						sheet1.SetCellValue(gPRow,"sabun"     , rv["sabun"]);
						sheet1.SetCellValue(gPRow,"orgNm"     , rv["orgNm"]);
						sheet1.SetCellValue(gPRow,"orgCd"     , rv["orgCd"]);
						sheet1.SetCellValue(gPRow,"appOrgCd"  , rv["orgCd"]);
						sheet1.SetCellValue(gPRow,"appOrgNm"  , rv["orgNm"]);
						sheet1.SetCellValue(gPRow,"jikchakCd" , rv["jikchakCd"]);
						sheet1.SetCellValue(gPRow,"jikchakNm" , rv["jikchakNm"]);
						sheet1.SetCellValue(gPRow,"jikweeCd"  , rv["jikweeCd"]);
						sheet1.SetCellValue(gPRow,"jikweeNm"  , rv["jikweeNm"]);
						sheet1.SetCellValue(gPRow,"jikgubCd"  , rv["jikgubCd"]);
						sheet1.SetCellValue(gPRow,"jikgubNm"  , rv["jikgubNm"]);
						sheet1.SetCellValue(gPRow,"gempYmd"   , rv["gempYmd"]);
						sheet1.SetCellValue(gPRow,"empYmd"    , rv["empYmd"]);
						sheet1.SetCellValue(gPRow,"workType"  , rv["workType"]);
						sheet1.SetCellValue(gPRow,"workTypeNm", rv["workTypeNm"]);
					}
				}
			]
		});

		$(window).smartresize(sheetResize); sheetInit();
		sheetResize();
		//doAction1("Search");

		$("#searchAppOrgNm, #searchNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
		
		$("#searchAppraisalCd").bind("change", function(event){
			// 평가등급코드 조회 Start
			var classCdListsParam = "queryId=getAppClassMgrCdListBySeq&searchAppStepCd=5";
				classCdListsParam += "&searchAppraisalCd=" + $(this).val();
				
			classCdList = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",classCdListsParam,false).codeList, "");

			// 평가구분에 따른 업적,역량평가대상자여부 컬럼 출력 여부 설정
			var appTypeCd = $(this).val().substring(2,3);
			if( appTypeCd == "C" ){				// 종합평가
				mboHdn = 0;
				compHdn = 0;
			} else if( appTypeCd == "A" ) {		// 성과평가
				mboHdn = 0;
				compHdn = 1;
			} else if( appTypeCd == "B" ) {		// 역량평가
				mboHdn = 1;
				compHdn = 0;
			}
			
			/* 무신사 역량평가 사용안함. */
			//compHdn = 1;
			
			sheet1.SetColHidden("mboTAppSelfPoint"  , 1);		// 본인업적점수
			sheet1.SetColHidden("mboTApp1stPoint"   , 1);		// 1차업적점수
			sheet1.SetColHidden("mboTApp1stClassCd" , mboHdn);		// 1차업적등급
			sheet1.SetColHidden("mboTApp2ndClassCd" , mboHdn);		// 2차업적평가등급
			sheet1.SetColHidden("mboTApp3rdClassCd" , mboHdn);		// 3차업적평가등급
			
			sheet1.SetColHidden("compTAppSelfPoint" , 1);		// 본인역량점수
			sheet1.SetColHidden("compTApp1stPoint"  , 1);		// 1차역량점수
			sheet1.SetColHidden("compTApp1stClassCd", compHdn);		// 1차역량등급
			sheet1.SetColHidden("compTApp2ndClassCd", compHdn);		// 2차역량평가등급
			sheet1.SetColHidden("compTApp3rdClassCd", compHdn);		// 3차역량평가등급
			
			// 성과 등급 콤보
			sheet1.SetColProperty("mboTApp1stClassCd",	{ComboText : "|"+classCdList["1"][0],	ComboCode: "|"+classCdList["1"][1]} );
			sheet1.SetColProperty("mboTApp2ndClassCd",	{ComboText : "|"+classCdList["2"][0],	ComboCode: "|"+classCdList["2"][1]} );
			sheet1.SetColProperty("mboTApp3rdClassCd",	{ComboText : "|"+classCdList["6"][0],	ComboCode: "|"+classCdList["6"][1]} );
			
			// 역량 등급 콤보
			sheet1.SetColProperty("compTApp1stClassCd",	{ComboText : "|"+classCdList["1"][0],	ComboCode: "|"+classCdList["1"][1]} );
			sheet1.SetColProperty("compTApp2ndClassCd",	{ComboText : "|"+classCdList["2"][0],	ComboCode: "|"+classCdList["2"][1]} );
			sheet1.SetColProperty("compTApp3rdClassCd",	{ComboText : "|"+classCdList["6"][0],	ComboCode: "|"+classCdList["6"][1]} );
			
			doAction1("Search");
		});
		
		$("#searchAppraisalCd").change();
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if(!checkList()) return ;
			sheet1.DoSearch( "${ctx}/AppResultUpload.do?cmd=getAppResultUploadList", $("#sendForm").serialize() );
			break;
		case "Save":
			if(!dupChk(sheet1,"appraisalCd|sabun|appOrgCd", true, true)){break;}
			IBS_SaveName(document.sendForm,sheet1);
			sheet1.DoSave( "${ctx}/AppResultUpload.do?cmd=saveAppResultUpload", $("#sendForm").serialize());
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			var searchAppraisalCd = $("#searchAppraisalCd").val();
			sheet1.SetCellValue( row, "appraisalCd", searchAppraisalCd);
			break;
		case "Copy":
			var row = sheet1.DataCopy();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1, ExcelFontSize:"9", ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
		case "LoadExcel":
			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet1.LoadExcel(params);
			break;
		case "DownTemplate":
			//sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownCols:"sabun|name|mboTApp1stPoint|compTApp1stPoint|mboTApp1stClassCd|compTApp1stClassCd|mboTApp2ndClassCd|compTApp2ndClassCd", ExcelFontSize:"9", ExcelRowHeight:"20", FileName:"업적_역량평가결과업로드_양식_" + $("#searchAppraisalCd").val() + ".xlsx"});
			sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownCols:"sabun|name|appOrgCd|appOrgNm|mboTApp1stClassCd|mboTApp2ndClassCd|mboTApp3rdClassCd|compTApp1stClassCd|compTApp2ndClassCd|compTApp3rdClassCd", ExcelFontSize:"9", ExcelRowHeight:"20", FileName:"업적_역량평가결과업로드_양식_" + $("#searchAppraisalCd").val() + ".xlsx"});
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

	function sheet1_OnLoadExcel(result) {

		if(result) {

			for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){
				sheet1.SetCellValue(i, "appraisalCd", $("#searchAppraisalCd").val());
			}

		}

	}

	// Type이 POPUP인 셀에서 팝업버튼을 눌렀을때 발생하는 이벤트
	function sheet1_OnPopupClick(Row, Col) {
		try {
			switch (sheet1.ColSaveName(Col)) {
			case "appOrgNm":
				if (!isPopup()) {return;}
				
				var args = new Array();
				args["searchAppraisalCd"] = $("#searchAppraisalCd").val();
				args["searchAppStepCd"] = '5';
				
				gPRow = Row;
				pGubun = "orgBasicPapCreatePopup";
				
				openPopup("/Popup.do?cmd=orgBasicPapCreatePopup", args, "680","520");
				break;
			default:
				break;
			}
		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}

	// 입력시 조건 체크
	function checkList(){
		var ch = true;
		var exit = false;
		if(exit){return false;}
		// 화면의 개별 입력 부분 필수값 체크
		$(".required").each(function(index){
			if($(this).val() == null || $(this).val() == ""){
				alert($(this).parent().find("span:first-child").text()+"은(는) 필수값입니다.");
				$(this).focus();
				ch =  false;
				return false;
			}
		});
		return ch;
	}

	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

		if(pGubun == "sheetAutocompleteEmp") {

			sheet1.SetCellValue(gPRow,"name", rv["name"]);
			sheet1.SetCellValue(gPRow,"sabun", rv["sabun"]);

			sheet1.SetCellValue(gPRow,"orgNm", rv["orgNm"]);
			sheet1.SetCellValue(gPRow,"orgCd", rv["orgCd"]);

			sheet1.SetCellValue(gPRow,"appOrgCd", rv["orgCd"]);
			sheet1.SetCellValue(gPRow,"appOrgNm", rv["orgNm"]);

			sheet1.SetCellValue(gPRow,"jikchakCd", rv["jikchakCd"]);
			sheet1.SetCellValue(gPRow,"jikchakNm", rv["jikchakNm"]);

			sheet1.SetCellValue(gPRow,"jikweeCd", rv["jikweeCd"]);
			sheet1.SetCellValue(gPRow,"jikweeNm", rv["jikweeNm"]);

			sheet1.SetCellValue(gPRow,"jikgubCd", rv["jikgubCd"]);
			sheet1.SetCellValue(gPRow,"jikgubNm", rv["jikgubNm"]);

			sheet1.SetCellValue(gPRow,"gempYmd", rv["gempYmd"]);
			sheet1.SetCellValue(gPRow,"empYmd", rv["empYmd"]);

			sheet1.SetCellValue(gPRow,"workType", rv["workType"]);
			sheet1.SetCellValue(gPRow,"workTypeNm", rv["workTypeNm"]);
		} else if (pGubun == "orgBasicPapCreatePopup") {
			sheet1.SetCellValue(gPRow, "appOrgNm", rv["orgNm"]);
			sheet1.SetCellValue(gPRow, "appOrgCd", rv["orgCd"]);
		}
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
<form name="sendForm" id="sendForm" method="post">
	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<td>
				<span>평가명</span>
				<select id="searchAppraisalCd" name="searchAppraisalCd" class="box" onchange="javascript:doAction1('Search');"></select>
			</td>
			<td>
				<span>소속</span>
				<input id="searchAppOrgNm" name="searchAppOrgNm" type="text" class="text" style="ime-mode:active;" />
			</td>
			<td>
				<span>사번/성명</span>
				<input id="searchNm" name="searchNm" type="text" class="text" style="ime-mode:active;" />
			</td>
			<td>
				<a href="javascript:doAction1('Search')" id="btnSearch" class="btn dark">조회</a>
			</td>
		</tr>
		</table>
		</div>
	</div>
</form>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt">평가결과업로드</li>
			<li class="btn">
				<a href="javascript:doAction1('Down2Excel')" 	class="btn outline_gray authR">다운로드</a>
				<a href="javascript:doAction1('DownTemplate')" 	class="btn outline_gray authA">양식다운로드</a>
				<a href="javascript:doAction1('LoadExcel')" 	class="btn outline_gray authA">업로드</a>
				<a href="javascript:doAction1('Copy')" 			class="btn outline_gray authA">복사</a>
				<a href="javascript:doAction1('Insert')" 		class="btn outline_gray authA">입력</a>
				<a href="javascript:doAction1('Save')" 			class="btn filled authA">저장</a>
			</li>
		</ul>
		</div>
	</div>

	<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "kr"); </script>
</div>
</body>
</html>
