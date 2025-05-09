<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<title>이의제기신청현황</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	let pGubun = "";
	let gPRow = "";

	$(function() {
		$("#searchSabunName").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22, MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No|No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },

			{Header:"사번|사번",			Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",				Format:"",	PointCount:0, Edit:0},
			{Header:"성명|성명",			Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",				Format:"",	PointCount:0, Edit:0},
			{Header:"소속|소속",			Type:"Text",	Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"appOrgNm",			Format:"",	PointCount:0, Edit:0},
			{Header:"최종상태|최종상태",	Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"fbStatusCd",			Format:"",	PointCount:0, Edit:0},
			{Header:"평가등급|평가등급",	Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appFinalClassCd",		Format:"",	PointCount:0, Edit:0},
			{Header:"1차|이의제기",		Type:"Text",	Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"memo1st",				Format:"",	PointCount:0, Edit:0},
			{Header:"1차|첨부",			Type:"Image",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"detail1st",			Format:"",	PointCount:0, Edit:0},
			{Header:"1차|피드백",		Type:"Text",	Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"feedback1st",			Format:"",	PointCount:0, Edit:0},
			{Header:"1차|작성자",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"feedback1stSabun",	Format:"",	PointCount:0, Edit:0},
			{Header:"2차|이의제기",		Type:"Text",	Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"memo2nd",				Format:"",	PointCount:0, Edit:0},
			{Header:"2차|첨부",			Type:"Image",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"detail2nd",			Format:"",	PointCount:0, Edit:0},
			{Header:"2차|피드백",		Type:"Text",	Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"feedback2nd",			Format:"",	PointCount:0, Edit:0},
			{Header:"2차|작성자",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"feedback2ndSabun",	Format:"",	PointCount:0, Edit:0},
			{Header:"3차|이의제기",		Type:"Text",	Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"memo3rd",				Format:"",	PointCount:0, Edit:0},
			{Header:"3차|첨부",			Type:"Image",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"detail3rd",			Format:"",	PointCount:0, Edit:0},
			{Header:"3차|피드백",		Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"feedback3rd",			Format:"",	PointCount:0, Edit:0},
			{Header:"3차|작성자",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"feedback3rdSabun",	Format:"",	PointCount:0, Edit:0},

			// hidden
			{Header:"hidden",	Type:"Text",	Hidden:1,	SaveName:"appraisalCd"},
			{Header:"hidden",	Type:"Text",	Hidden:1,	SaveName:"appOrgCd"},
			{Header:"hidden",	Type:"Text",	Hidden:1,	SaveName:"fileSeq1st"},
			{Header:"hidden",	Type:"Text",	Hidden:1,	SaveName:"fileSeq2nd"},
			{Header:"hidden",	Type:"Text",	Hidden:1,	SaveName:"fileSeq3rd"},
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("detail1st",1);
		sheet1.SetDataLinkMouse("detail2nd",1);
		sheet1.SetDataLinkMouse("detail3rd",1);

		//공통코드 한번에 조회
		const grpCds = "'P10020','P00001'";
		const codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists&useYn=Y","grpCd="+grpCds,false).codeList, "");
		sheet1.SetColProperty("fbStatusCd",  	{ComboText:"|"+codeLists["P10020"][0], ComboCode:"|"+codeLists["P10020"][1]} ); // 이의제기상태
		sheet1.SetColProperty("appFinalClassCd",  	{ComboText:"|"+codeLists["P00001"][0], ComboCode:"|"+codeLists["P00001"][1]} ); // 평가등급

		//평가아이디 코드
		const searchAppraisalCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdListOkr&searchAppStepCd=5",false).codeList, "");
		$("#searchAppraisalCd").html(searchAppraisalCd[2]);

		const searchCicCd = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getOkrFeedbackRstCicCdList", false).codeList, "선택");
		$("#searchCicCd").html(searchCicCd[2]);

		$(window).smartresize(sheetResize); sheetInit();

	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if(!checkRequired())return;
			sheet1.DoSearch( "${ctx}/OkrAppFeedBackRst.do?cmd=getOkrAppFeedBackRstList", $("#srchFrm").serialize() );
			break;
			
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
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
			if(Msg != ""){
				alert(Msg);
			}
			doAction1("Search");
		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
			if(Row <= 1) return;
			let sSaveName = sheet1.ColSaveName(Col);

			if(sSaveName == "detail1st"){
				attachFile(sheet1.GetCellValue(Row, "fileSeq1st"))
			}

			if(sSaveName == "detail2nd"){
				attachFile(sheet1.GetCellValue(Row, "fileSeq2nd"))
			}

			if(sSaveName == "detail3rd"){
				attachFile(sheet1.GetCellValue(Row, "fileSeq3rd"))
			}
		}catch(ex){
			alert("OnClick Event Error : " + ex);
		}
	}

	// 첨부파일 등록
	function attachFile(fileSeq){
		if(!isPopup()) {return;}

		var param = [];
		pGubun = "searchFileSeq";
		param["fileSeq"] = fileSeq;
		var win = openPopup("/fileuploadJFileUpload.do?cmd=fileMgrPopup&authPg=R&uploadType=papProtest", param, "740","420");
	}

	// 화면의 개별 입력 부분 필수값 체크
	function checkRequired(){
		if($("#searchAppraisalCd").val() == null || $("#searchAppraisalCd").val() == ""){
			alert("평가명을 선택하여 주십시오");
			return false;
		}

		if($("#searchCicCd").val() == null || $("#searchCicCd").val() == ""){
			alert("CIC/총괄을 선택하여 주십시오");
			return false;
		}

		return true;
	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

		if(pGubun == "searchFileSeq") {

		}
	}

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<intput type="hidden" id="searchGrpCd" name="searchGrpCd" value="${grpCd}"/>
		<div class="sheet_search outer">
			<table>
				<tr>
					<td>
						<span>평가명</span>
						<select id="searchAppraisalCd" name="searchAppraisalCd" class="box required"></select>
					</td>
					<td>
						<span>CIC/총괄</span>
						<select id="searchCicCd" name="searchCicCd" class="box required"></select>
					</td>
					<td>
						<span>사번/성명</span>
						<input type="text" id="searchSabunName" name="searchSabunName" class="text">
					</td>
					<td>
						<a href="javascript:doAction1('Search')" class="button">조회</a>
					</td>
				</tr>
			</table>
		</div>
	</form>
		<div class="inner">
			<div class="sheet_title">
				<ul>
					<li class="txt">이의제기신청현황</li>
					<li class="btn">
						<a href="javascript:doAction1('Down2Excel')" class="basic authR">다운로드</a>
					</li>
				</ul>
			</div>
		</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>