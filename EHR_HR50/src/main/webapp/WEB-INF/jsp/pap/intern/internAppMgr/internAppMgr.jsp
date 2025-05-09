<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>승진대상자명단</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

	var vSearchEvlYy = "";

	$(function() {

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly, FrozenCol:7};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",					Type:"${sDelTy}",	Hidden:Number("0"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",					Type:"${sSttTy}",	Hidden:Number("0"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
    		{Header:"평가ID코드(TPAP101)",	Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
			{Header:"평가단계(P00005)",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appStepCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
			{Header:"사원번호",				Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13},
			{Header:"성명",					Type:"Popup",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13},
			{Header:"조직코드(TORG101)",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"orgCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
			{Header:"소속",					Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
			{Header:"직위(H20030)",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
			{Header:"직위",					Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
			{Header:"직무코드(TORG201)",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jobCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
			{Header:"직무명",				Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jobNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
			{Header:"직종코드(H10050)",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"workType",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
			{Header:"직종명",				Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"workTypeNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
			{Header:"직책(H20020)",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikchakCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
			{Header:"직책",					Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
			{Header:"직급(H20010)",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
			{Header:"직급",					Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
			{Header:"입사일",				Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"empYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
			{Header:"계약시작일",				Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"contractSymd",KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
			{Header:"계약종료일",				Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"contractEymd",KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
			{Header:"1차평가",				Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appPoint1",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:50},
			{Header:"2차평가",				Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appPoint2",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:50},
			{Header:"계약연장여부",			Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"contractYn",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
			{Header:"비고",					Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"meno",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100}

		];
		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(true);sheet1.SetVisible(true);

		var famList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdListAppType&searchEvlYy="+$("#searchEvlYy").val()+"&searchAppTypeCd=D,",false).codeList, "");
		var comboCodeList1 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P20030"), "");		//계약연장여부
		
		sheet1.SetColProperty("appraisalCd", {ComboText:famList[0], ComboCode:famList[1]} );
		sheet1.SetColProperty("contractYn", {ComboText:comboCodeList1[0], ComboCode:comboCodeList1[1]} );
		
		$("#searchAppraisalCd").html(famList[2]);

/* 		var userCd1 = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20010"), "전체");
		var userCd2 = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H00010"), "");

		sheet1.SetColProperty("jikweeCd", 		{ComboText:"|"+userCd1[0], ComboCode:"|"+userCd1[1]} );
		sheet1.SetColProperty("tarJikweeCd", 	{ComboText:"|"+userCd1[0], ComboCode:"|"+userCd1[1]} );
		sheet1.SetColProperty("sexType", 		{ComboText:"|"+userCd2[0], ComboCode:"|"+userCd2[1]} ); */

		$("#searchEvlYy").bind("keyup",function(){
			if($(this).val().length == 4 && vSearchEvlYy != $(this).val()){
				//초기화
				$("#searchAppraisalCd").html("");

				var famList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdListAppType&searchEvlYy="+$("#searchEvlYy").val()+"&searchAppTypeCd=Z,",false).codeList, "");
				//option 입력
				$("#searchAppraisalCd").html(famList[2]);
				sheet1.SetColProperty("appraisalCd", {ComboText:famList[0], ComboCode:famList[1]} );

				//화살표 조회 방지용
				vSearchEvlYy = $("#searchEvlYy").val();
				doAction1("Search");
			}
		});

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");

	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			/* var param = "promotionCd="+$("#promotionCd").val()
						+"&choiceYn="+$("#choiceYn").val()
						+"&tarJikweeCd="+$("#tarJikweeCd").val(); */

			sheet1.DoSearch( "${ctx}/InternAppMgr.do?cmd=getInternAppMgrList", $("#mySheetForm").serialize() );
			break;
		case "Save":

			if(!dupChk(sheet1,"promotionCd|sabun", true, true)){break;}
			//IBS_SaveName(document.mySheetForm,sheet1);
			//sheet1.DoSave( "${ctx}/InternAppMgr.do?cmd=saveIntermAppMgr", $("#mySheetForm").serialize());
			break;
		case "Insert":
 			if($("#searchAppraisalCd").val() == null || $("#searchAppraisalCd").val() == "") {
				alert("평가명을 선택하여 주십시오.");
				return;
			}
			var row = sheet1.DataInsert(0);
			sheet1.SetCellValue(row, "appraisalCd" , $("#searchAppraisalCd").val());
			break;
		case "Copy":
			sheet1.DataCopy();
			break;
		case "Clear":
			sheet1.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
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

	// 팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
			if(sheet1.ColSaveName(Col) == "name") {
	            var rst = openPopup("/Popup.do?cmd=employeePopup&authPg=${authPg}", "", "740","520");
	            //var rst = openPopup("/AppmtConfirmPopup.do?cmd=viewAppmtConfirmPopup", "", "740","520");
	            if(rst != null){
	                sheet1.SetCellValue(Row, "sabun",		rst["sabun"] );
	                sheet1.SetCellValue(Row, "name",		rst["name"] );
	                sheet1.SetCellValue(Row, "sexType",		rst["sexType"] );
	                sheet1.SetCellValue(Row, "age",			rst["age"] );
	                sheet1.SetCellValue(Row, "empYmd",		rst["empYmd"] );
	                sheet1.SetCellValue(Row, "orgCd",  		rst["orgCd"] );
	                sheet1.SetCellValue(Row, "orgNm",  		rst["orgNm"] );
	                sheet1.SetCellValue(Row, "jikchakCd",  	rst["jikchakCd"] );
	                sheet1.SetCellValue(Row, "jikchakNm",  	rst["jikchakNm"] );
	                sheet1.SetCellValue(Row, "jikweeCd",  	rst["jikgubCd"] );
	                sheet1.SetCellValue(Row, "jikweeNm",  	rst["jikweeNm"] );
	                sheet1.SetCellValue(Row, "jobCd",  		rst["jobCd"] );
	                sheet1.SetCellValue(Row, "jobNm",  		rst["jobNm"] );
	                sheet1.SetCellValue(Row, "empYmd",  	rst["empYmd"] );
	                sheet1.SetCellValue(Row, "twkpYCnt",  	rst["empYeuncha"] );
	                sheet1.SetCellValue(Row, "wkpYCnt",  	rst["jikgubYeuncha"] );
	                sheet1.SetCellValue(Row, "lastSkYmd",  	rst["currJikgubYmd"] );
	                sheet1.SetCellValue(Row, "workYear",  	rst["workYyCnt"] );
	                sheet1.SetCellValue(Row, "workMonth",  	rst["workMmCnt"] );
/* 	                rv["currJikgubYmd"]
	                rv["workYyCnt"]
	                rv["workMmCnt"]  */
	            }
			}
		} catch (ex) {
			alert("OnPopupClick Event Error " + ex);
		}

	}
	 // 대상자생성
	 function createRcpt(){
		 var args    = new Array();
		 args["searchAppStepCd"] = '5';
		 args["searchAppraisalCd"] = $("#searchAppraisalCd").val();
		 alert(args["searchAppStepCd"]);
		 alert(args["searchAppraisalCd"]);
	     var rv = openPopup("/AppPeopleMgr.do?cmd=viewAppPeopleMgrPop", args, "740","520");
	     doAction1('Search');
	 }
</script>
</head>
<body class="bodywrap">
<div class="wrapper">

	<form id="mySheetForm" name="mySheetForm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<span>평가년도</span>
							<input id="searchEvlYy" name ="searchEvlYy" type="text" class="text" maxlength="4"  value="${curSysYear}" />
						</td>
						<td>
							<span>평가명</span>
							<select name="searchAppraisalCd" id="searchAppraisalCd" onChange="javascript:doAction1('Search');">
							</select>
						</td>
						<td>
							<a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>

	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt">촉탁직평가관리</li>
			<li class="btn">
				<a href="javascript:doAction1('Save');" class="basic authA">저장</a>
				<a href="javascript:doAction1('Down2Excel');" class="basic authR">다운로드</a>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>

</div>
</body>
</html>