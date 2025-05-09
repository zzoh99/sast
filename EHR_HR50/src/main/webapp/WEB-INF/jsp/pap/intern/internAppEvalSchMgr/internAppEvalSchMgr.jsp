<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
var entercdVal = "${ssnEnterCd}";
	$(function() {
		// 공통코드 조회

		// sheet init
		var initdata = {};
		initdata.Cfg = {FrozenCol:4,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNoV1' mdef='No'/>",			Type:"${sNoTy}",	Hidden:0,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V1' mdef='삭제'/>",	Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus V4' mdef='상태'/>",	Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			
			{Header:"조직코드",			Type:"Text",		Hidden:1,					Width:200,	Align:"Left",	ColMerge:0,	SaveName:"orgCd",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"조직",				Type:"Text",		Hidden:0,					Width:100,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"사번",				Type:"Text",		Hidden:0,					Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"성명",				Type:"Text",		Hidden:0,					Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,				UpdateEdit:0,	InsertEdit:1},
			{Header:"직책명",			Type:"Text",		Hidden:0,					Width:80,	Align:"Left",	ColMerge:0,	SaveName:"jikchakNm",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"직위명",			Type:"Text",		Hidden:0,					Width:80,	Align:"Left",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"입사일",			Type:"Date",		Hidden:0,					Width:80,	Align:"Center",	ColMerge:1,	SaveName:"empYmd",		KeyField:0,	Format:"Ymd",UpdateEdit:0,	InsertEdit:0},
			{Header:"시작일",			Type:"Date",		Hidden:0,  					Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:0,	Format:"Ymd",UpdateEdit:0, 	InsertEdit:0,	 PointCount:0,   EditLen:10 },
			{Header:"종료일",			Type:"Date",		Hidden:0,  					Width:100,	Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	Format:"Ymd",UpdateEdit:0, 	InsertEdit:0,	 PointCount:0,   EditLen:10 },
			{Header:"기준일",			Type:"Date",		Hidden:0,  					Width:100,	Align:"Center",	ColMerge:0,	SaveName:"cdate",		KeyField:0,	Format:"Ymd",UpdateEdit:0, 	InsertEdit:0,	 PointCount:0,   EditLen:10 },
			{Header:"수습연장\n여부",	Type:"Text",		Hidden:0,					Width:60,	Align:"Center",	ColMerge:1,	SaveName:"extendYn",	KeyField:0,				UpdateEdit:0,	InsertEdit:0,	TrueValue:"Y", FalseValue:"N",	HeaderCheck:0},
			{Header:"평가ID",			Type:"Text",		Hidden:1,					Width:60,	Align:"Center",	ColMerge:1,	SaveName:"appraisalCd",	KeyField:0,				UpdateEdit:0,	InsertEdit:0,	TrueValue:"Y", FalseValue:"N",	HeaderCheck:0},
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetUnicodeByte(3);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

		initdata.Cols = [
   			{Header:"<sht:txt mid='sNo' mdef='No|No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
   			{Header:"<sht:txt mid='sDelete V5' mdef='삭제|삭제'/>",		Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='sStatus' mdef='상태|상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

   			{Header:"평가단계|평가단계",	Type:"Combo",		Hidden:0,					Width:100,	Align:"Left",	ColMerge:0,	SaveName:"appStepCd",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
   			{Header:"평가회차|평가회차",	Type:"Int",	  		Hidden:0,  					Width:60,	Align:"Right", 	ColMerge:0, SaveName:"seq",			KeyField:0,   			CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:5 },
   			{Header:"평가방향|평가방향",	Type:"Combo",		Hidden:0,					Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appPlan",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"평가자|사번",			Type:"Text",		Hidden:0,					Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appSabun",	KeyField:1,				UpdateEdit:0,	InsertEdit:0},
			{Header:"평가자|성명",			Type:"Text",		Hidden:0,					Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appSabunNm",	KeyField:0,				UpdateEdit:1,	InsertEdit:0},
			{Header:"평가자|조직코드",		Type:"Text",		Hidden:1,					Width:150,	Align:"Left",	ColMerge:0,	SaveName:"appOrgCd",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"평가자|조직명",		Type:"Text",		Hidden:0,					Width:150,	Align:"Left",	ColMerge:0,	SaveName:"appOrgNm",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			
			{Header:"실습기간|시작일",		Type:"Date",		Hidden:0,  					Width:110,	Align:"Center",	ColMerge:0,	SaveName:"examStDt",	KeyField:0,	Format:"Ymd",UpdateEdit:0, 	InsertEdit:0,	 PointCount:0,   EditLen:10 },
			{Header:"실습기간|종료일",		Type:"Date",		Hidden:0,  					Width:110,	Align:"Center",	ColMerge:0,	SaveName:"examEndDt",	KeyField:0,	Format:"Ymd",UpdateEdit:0, 	InsertEdit:0,	 PointCount:0,   EditLen:10 },
			{Header:"평가기간|시작일",		Type:"Date",		Hidden:0,  					Width:110,	Align:"Center",	ColMerge:0,	SaveName:"appStDt",		KeyField:0,	Format:"Ymd",UpdateEdit:1, 	InsertEdit:0,	 PointCount:0,   EditLen:10 },
			{Header:"평가기간|종료일",		Type:"Date",		Hidden:0,  					Width:110,	Align:"Center",	ColMerge:0,	SaveName:"appEndDt",	KeyField:0,	Format:"Ymd",UpdateEdit:1, 	InsertEdit:0,	 PointCount:0,   EditLen:10 },
			{Header:"평가상태|평가상태",	Type:"Combo",		Hidden:0,					Width:100,	Align:"Left",	ColMerge:0,	SaveName:"appStatCd",	KeyField:0,				UpdateEdit:1,	InsertEdit:0},
			{Header:"평가점수|평가점수",	Type:"Text",		Hidden:0,					Width:60,	Align:"Right",	ColMerge:0,	SaveName:"appScr",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			
			{Header:"",						Type:"Text",		Hidden:1,					Width:80,	Align:"Right",	ColMerge:0,	SaveName:"appraisalCd",	KeyField:0,			UpdateEdit:0,	InsertEdit:0},
			{Header:"",						Type:"Text",		Hidden:1,					Width:80,	Align:"Right",	ColMerge:0,	SaveName:"sabun",		KeyField:0,			UpdateEdit:0,	InsertEdit:0},
			{Header:"",						Type:"Text",		Hidden:1,					Width:80,	Align:"Right",	ColMerge:0,	SaveName:"appTypeCd",	KeyField:0,			UpdateEdit:0,	InsertEdit:0},
			{Header:"",						Type:"Text",		Hidden:1,					Width:80,	Align:"Right",	ColMerge:0,	SaveName:"appSeq",		KeyField:0,			UpdateEdit:0,	InsertEdit:0},
			{Header:"",						Type:"Text",		Hidden:1,					Width:80,	Align:"Right",	ColMerge:0,	SaveName:"appSeqDetail",KeyField:0,			UpdateEdit:0,	InsertEdit:0},
			
			]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);sheet2.SetUnicodeByte(3);sheet2.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		var appStatCdList 	 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P20021"), "");	//평가진행상태
		var appStepCdList 	 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P20024"), "");	//평가단계
		var appTypeCdList 	 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P20019"), "");	//평가자구분
		var appPlanCdList 	 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P20023"), "");	//평가방향
		var appraisalCdList		= convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdListByIntern",false).codeList, "");
		$("#searchAppraisalCd").html(appraisalCdList[2]);
		sheet2.SetColProperty("appStatCd",		{ComboText:appStatCdList[0], ComboCode:appStatCdList[1]} );
		sheet2.SetColProperty("appStepCd",		{ComboText:appStepCdList[0], ComboCode:appStepCdList[1]} );
		sheet2.SetColProperty("appTypeCd",		{ComboText:appTypeCdList[0], ComboCode:appTypeCdList[1]} );
		sheet2.SetColProperty("appPlan",		{ComboText:appPlanCdList[0], ComboCode:appPlanCdList[1]} );
		
		$(sheet2).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "appSabunNm",
					CallbackFunc : function(returnValue) {
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet2.SetCellValue(gPRow,"appSabunNm", rv["name"]);
						sheet2.SetCellValue(gPRow,"appSabun", rv["sabun"]);
						sheet2.SetCellValue(gPRow,"appOrgNm", rv["orgNm"]);
						sheet2.SetCellValue(gPRow,"appOrgCd", rv["orgCd"]);
					}
				}
			]
		});
		
		// 조회조건 이벤트
		$("#searchAppraisalCd").bind("change", function(){
			doAction1("Search");
		});

		$("#searchSabunName").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search"); $(this).focus();
			}
		});

		$(window).smartresize(sheetResize); sheetInit();
		// 조회
		doAction1("Search");
	});

	// 평가일정생성
	function create(){
		// 평가대상자 평가대상여부 'Y'인 대상자만 생성해준다.
		if (confirm("기존에 생성된 평가대상자를 제외하고 평가일정을 생성합니다.\n작업을 실행 하시겠습니까?")) {
	    	var data = ajaxCall("${ctx}/InternAppEvalSchMgr.do?cmd=prcInternAppEvalSchMgrCreate",$("#srchFrm").serialize(),false);
			if(data.Result.Code == null) {
				alert("<msg:txt mid='alertCreateOk1' mdef='평가일정생성이 완료되었습니다.'/>");
				doAction1("Search");
	    	} else {
		    	alert(data.Result.Message);
	    	}
		}
	}

	// 평가일정초기화
	function clear(){
		// 평가대상자 평가대상여부 'Y'인 대상자만 생성해준다.
		if (confirm("해당 평가대상자의 평가일정 및 평가결과를 모두 삭제합니다.\n작업을 실행 하시겠습니까?")) {
	    	var data = ajaxCall("${ctx}/InternAppEvalSchMgr.do?cmd=prcInternAppEvalSchMgrClear",$("#srchFrm2").serialize(),false);
			if(data.Result.Code == null) {
				alert("<msg:txt mid='alertCreateOk1' mdef='일정초기화가 완료되었습니다.'/>");
				doAction1("Search");
	    	} else {
		    	alert(data.Result.Message);
	    	}
		}
	}
	
</script>

<!-- sheet1 -->
<script type="text/javascript">
	/**
	 * Sheet 각종 처리
	 */
	function doAction1(sAction){
		switch(sAction){
			case "Search":		//조회
				$("#searchAppraisalCd2").val("");
				$("#searchSabun2").val("");
				$("#searchWEnterCd2").val("");

				doAction2("Clear");

				sheet1.DoSearch( "${ctx}/InternAppEvalSchMgr.do?cmd=getInternAppEvalSchMgrList", $("#srchFrm").serialize() );
				break;

			case "Save":		//저장
				if(sheet1.FindStatusRow("I") != ""){
					if(!dupChk(sheet1,"compAppraisalCd|wEnterCd|sabun", true, true)){break;}
				}

				IBS_SaveName(document.srchFrm,sheet1);
				sheet1.DoSave( "${ctx}/CompAppPeopleMng.do?cmd=saveCompAppPeopleMng1", $("#srchFrm").serialize() );
				break;

			case "Insert":		//입력
				var Row = sheet1.DataInsert(0);
				sheet1.SetCellValue(Row, "compAppraisalCd", $("#searchAppraisalCd").val());
				break;

			case "Copy":		//행복사
				var Row = sheet1.DataCopy();
				break;

			case "Clear":		//Clear
				sheet1.RemoveAll();
				break;

			case "Down2Excel":	//엑셀내려받기
				sheet1.Down2Excel({DownCols:makeHiddenSkipCol(sheet1),SheetDesign:1,Merge:1});
				break;

			case "LoadExcel":	//엑셀업로드
				var params = {Mode:"HeaderMatch", WorkSheetNo:1};
				sheet1.LoadExcel(params);
				break;
		}
	}

	//<!-- 조회 후 에러 메시지 -->
	function sheet1_OnSearchEnd(Code, ErrMsg, StCode, StMsg){
		try{
			if (ErrMsg != ""){
				alert(ErrMsg);
			}
			sheetResize();
		}catch(ex){alert("OnSearchEnd Event Error : " + ex);}
	}

	//<!-- 저장 후 에러 메시지 -->
	function sheet1_OnSaveEnd(Code, ErrMsg, StCode, StMsg){
		try{
			if (ErrMsg != ""){
				alert(ErrMsg) ;
			}

			if ( Code != "-1" ) doAction1("Search") ;

		}catch(ex){alert("OnSaveEnd Event Error : " + ex);}
	}

	//<!--셀에서 키보드가 눌렀을때 발생하는 이벤트-->
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift){
		try{
			// Insert KEY
			if(Shift == 1 && KeyCode == 45){
				doAction1("Insert");
			}

			//Delete KEY
			if(Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row,"sStatus") == "I"){
				sheet1.SetCellValue(Row,"sStatus","D");
			}
		}catch(ex){alert("OnKeyDown Event Error : " + ex);}
	}

	// Click 시
	function sheet1_OnClick(Row, Col, Value){
		try{

		}catch(ex){alert("OnClick Event Error : " + ex);}
	}

	//<!--셀에 마우스 클릭했을때 발생하는 이벤트-->
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
		try{
			var Row = NewRow;

			if ( sheet1.GetCellValue(Row, "sStatus") == "I" ) return;
			if ( OldRow == NewRow ) return;

			$("#searchAppraisalCd2").val(sheet1.GetCellValue(Row, "appraisalCd"));
			$("#searchSabun2").val(sheet1.GetCellValue(Row, "sabun"));

		    doAction2('Search');
		}catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}

	// 팝업 클릭시
	function sheet1_OnPopupClick(Row, Col){
		try{
			if(sheet1.ColSaveName(Col) == "name") {

				if(!isPopup()) {return;}
				gPRow = Row;
				pGubun = "employeePopup";

				var args = new Array();
				args["searchEnterCd"] = sheet1.GetCellValue(Row, "wEnterCd");
				openPopup("${ctx}/Popup.do?cmd=employeePopup", args, "840","520");
			}
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}

	function sheet1_OnChange(Row, Col) {
		try{
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}

	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

	    if(pGubun == "employeePopup"){
			sheet1.SetCellValue(gPRow, "wEnterCd",	rv["enterCd"] );
			sheet1.SetCellValue(gPRow, "sabun",		rv["sabun"] );
			sheet1.SetCellValue(gPRow, "name",		rv["name"] );
			sheet1.SetCellValue(gPRow, "alias",		rv["alias"] );
			sheet1.SetCellValue(gPRow, "orgCd",		rv["orgCd"] );
			sheet1.SetCellValue(gPRow, "orgNm",		rv["orgNm"] );
			sheet1.SetCellValue(gPRow, "jikweeCd",	rv["jikweeCd"] );
			sheet1.SetCellValue(gPRow, "jikweeNm",	rv["jikweeNm"] );
			sheet1.SetCellValue(gPRow, "jikchakCd",	rv["jikchakCd"] );
			sheet1.SetCellValue(gPRow, "jikchakNm",	rv["jikchakNm"] );
			sheet1.SetCellValue(gPRow, "jikgubCd",	rv["jikgubCd"] );
			sheet1.SetCellValue(gPRow, "jikgubNm",	rv["jikgubNm"] );

	    }else if(pGubun == "employeePopup2"){
			sheet2.SetCellValue(gPRow, "appEnterCd",rv["enterCd"] );
			sheet2.SetCellValue(gPRow, "appSabun",	rv["sabun"] );
			sheet2.SetCellValue(gPRow, "appName",	rv["name"] );
			sheet2.SetCellValue(gPRow, "appAlias",	rv["alias"] );
			sheet2.SetCellValue(gPRow, "orgCd",		rv["orgCd"] );
			sheet2.SetCellValue(gPRow, "orgNm",		rv["orgNm"] );
			sheet2.SetCellValue(gPRow, "jikweeCd",	rv["jikweeCd"] );
			sheet2.SetCellValue(gPRow, "jikweeNm",	rv["jikweeNm"] );
			sheet2.SetCellValue(gPRow, "jikchakCd",	rv["jikchakCd"] );
			sheet2.SetCellValue(gPRow, "jikchakNm",	rv["jikchakNm"] );
			sheet2.SetCellValue(gPRow, "jikgubCd",	rv["jikgubCd"] );
			sheet2.SetCellValue(gPRow, "jikgubNm",	rv["jikgubNm"] );
	    } else if(pGubun == "org") {
	    	$("#searchOrgNm").val(rv["orgNm"]);
	    	//doAction1("Search");
	    }
	}
</script>

<!-- sheet2 -->
<script type="text/javascript">
	/**
	 * Sheet 각종 처리
	 */
	function doAction2(sAction){
		switch(sAction){
			case "Search":		//조회
				sheet2.DoSearch( "${ctx}/InternAppEvalSchMgr.do?cmd=getInternAppEvalSchMgrList2", $("#srchFrm2").serialize() );
				break;

			case "Save":		//저장
				if(sheet2.FindStatusRow("I") != ""){
					if(!dupChk(sheet2,"appStepCd|appSeq||sabun|appSabun", true, true)){break;}
				}

				IBS_SaveName(document.srchFrm2,sheet2);
				sheet2.DoSave( "${ctx}/InternAppEvalSchMgr.do?cmd=saveInternAppEvalSchMgr", $("#srchFrm2").serialize() );
				break;

			case "Clear":		//Clear
				sheet2.RemoveAll();
				break;

			case "Down2Excel":	//엑셀내려받기
				sheet2.Down2Excel({DownCols:makeHiddenSkipCol(sheet2),SheetDesign:1,Merge:1});
				break;

			case "LoadExcel":	//엑셀업로드
				var params = {Mode:"HeaderMatch", WorkSheetNo:1};
				sheet2.LoadExcel(params);
				break;
		}
	}

//<!-- 조회 후 에러 메시지 -->
	function sheet2_OnSearchEnd(Code, ErrMsg, StCode, StMsg){
		try{
			if (ErrMsg != ""){
				alert(ErrMsg);
			}
			sheetResize();
		}catch(ex){alert("OnSearchEnd Event Error : " + ex);}
	}

//<!-- 저장 후 에러 메시지 -->
	function sheet2_OnSaveEnd(Code, ErrMsg, StCode, StMsg){
		try{
			if (ErrMsg != ""){
				alert(ErrMsg) ;
			}

			if ( Code != "-1" ) doAction2("Search") ;

		}catch(ex){alert("OnSaveEnd Event Error : " + ex);}
	}

//<!--셀에서 키보드가 눌렀을때 발생하는 이벤트-->
	function sheet2_OnKeyDown(Row, Col, KeyCode, Shift){
		try{
			// Insert KEY
			if(Shift == 1 && KeyCode == 45){
				doAction2("Insert");
			}

			//Delete KEY
			if(Shift == 1 && KeyCode == 46 && sheet2.GetCellValue(Row,"sStatus") == "I"){
				sheet2.SetCellValue(Row,"sStatus","D");
			}
		}catch(ex){alert("OnKeyDown Event Error : " + ex);}
	}

	// 팝업 클릭시
	function sheet2_OnPopupClick(Row, Col){
		try{
			if(sheet2.ColSaveName(Col) == "appName") {
				if(!isPopup()) {return;}
				gPRow = Row;
				pGubun = "employeePopup2";

				var args = new Array();
				args["searchEnterCdView"] = "Y";
				openPopup("${ctx}/Popup.do?cmd=employeePopup", args, "840","520");

			}
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}
	
	function clearCode(num) {
		if(num == 1) {
			$("#searchOrgCd").val("");
			$("#searchOrgNm").val("");
			//doAction1("Search");
		}
	}
	
	function popup(opt){
		pGubun = opt;
		if(opt == "org"){
			openPopup("/Popup.do?cmd=orgTreePopup&authPg=R", "", "740","520");	
		} else if (opt == "group") {
			var args = new Array();
			args["searchAppraisalCd"] = $("#searchAppraisalCd").val();
			//pGubun = "AppEvaluateeMgrPop";
			openPopup("${ctx}/AppEvaluateeMgr.do?cmd=viewAppEvaluateeMgrPop", args, "550","520");		
			//openPopup("/Popup.do?cmd=orgTreePopup&authPg=R", "", "740","520");
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
						<td>
							<span>평가명</span>
							<SELECT id="searchAppraisalCd" name="searchAppraisalCd" class="box"></SELECT>
						</td>
						<td>
							<span>조직</span>
							<input id="searchOrgNm" name="searchOrgNm" type="text" class="text" readonly/>
							<a onclick="javascript:popup('org')" class="button6" ><img src='/common/${theme}/images/btn_search2.gif'/></a>
							<a href="javascript:clearCode(1)" class="button7"><img src="/common/images/icon/icon_undo.png"/></a>
						</td>
						<td>
							<span>성명/사번</span>
							<input id="searchSabunName" name="searchSabunName" type="text" class="text" />
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
							<li id="txt" class="txt">평가대상자</li>
							<li class="btn">
								<a href="javascript:create()" class="button authA"><tit:txt mid='112692' mdef='평가일정생성'/></a>
								<!-- <a href="javascript:doAction1('Insert')" class="basic authA"><tit:txt mid='104267' mdef='입력'/></a> -->
								<!-- <a href="javascript:doAction1('Copy')" 	class="basic authA"><tit:txt mid='104335' mdef='복사'/></a> -->
								<!-- <a href="javascript:doAction1('Save')" 	class="basic authA"><tit:txt mid='104476' mdef='저장'/></a> -->
								<a href="javascript:doAction1('Down2Excel')" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "50%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>

	<form id="srchFrm2" name="srchFrm2" >
		<input type="hidden" id="searchAppraisalCd2" name="searchAppraisalCd2" value="" />
		<input type="hidden" id="searchSabun2" name="searchSabun2" value="" />
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='compAppPeopleMng2' mdef='평가자'/></li>
							<li class="btn">
								<a href="javascript:clear()" class="button authA"><tit:txt mid='112692' mdef='일정초기화'/></a>
								<!--<a href="javascript:doAction2('Search')" class="button"><tit:txt mid='104081' mdef='조회'/></a>-->
								<!--<a href="javascript:doAction2('Insert')" class="basic authA"><tit:txt mid='104267' mdef='입력'/></a>-->
								<!--<a href="javascript:doAction2('Copy')" 	class="basic authA"><tit:txt mid='104335' mdef='복사'/></a>-->
								<a href="javascript:doAction2('Save')" 	class="basic authA"><tit:txt mid='104476' mdef='저장'/></a>
								<!--<a href="javascript:doAction2('Down2Excel')" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>-->
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet2", "100%", "50%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
