<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"차수",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appSeqCdNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"성명",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"사번",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"소속",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appOrgNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },

			{Header:"입사일",		Type:"Date",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"empYmd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"직위명",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"직급명",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"직책명",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"직급년차",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikgubYeuncha",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"평가ID",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"평가소속",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"평가차수",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appSeqCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(0);sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		sheet1.SetUnicodeByte(3);

		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),		Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"세부\n내역", Type:"Image",       Hidden:0,   Width:30,   Align:"Center", ColMerge:0, SaveName:"ibsImage",    KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"차수",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appSeqCdNm",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"Coach",	Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appName",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"날짜",		Type:"Date",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"coaYmd",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10	},
			{Header:"장소",		Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"coaPlace",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:200 },
			{Header:"내용",		Type:"Text",		Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"memo",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1333, Wrap:1, MultiLineText:1  },

			{Header:"수정가능여부",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"editable",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"평가ID",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"사번",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"평가소속",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"평가차수",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appSeqCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"평가사번",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appSabun",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 }
		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);
		sheet2.SetUnicodeByte(3);
		//sheet2.SetEditEnterBehavior("newline");
        sheet2.SetImageList(0,"/common/images/icon/icon_popup.png");
        sheet2.SetDataLinkMouse("ibsImage",true);
        sheet2.SetEditEnterBehavior("newline");
		$(window).smartresize(sheetResize); sheetInit();
	});

	$(function(){
		if ( "${sessionScope.ssnPapAdminYn}" == "Y" ) {
			$(".btnSabunPop").show();
		} else {
			$(".btnSabunPop").hide();
		}

		$("#searchAppraisalCd").bind("change",function(event){
			setAppSeqCd();
		});
		$("#searchAppSeqCd").bind("change",function(event){
			doAction1("Search");
		});

		//평가명
		var appraisalCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAppraisalCdList&searchAppTypeCd=C,A&"+$("#empForm").serialize(),false).codeList, "");	//평가명
		$("#searchAppraisalCd").html(appraisalCdList[2]);
		$("#searchAppraisalCd").change();

		//성명,사번
		$("#searchAppSabun").val("${sessionScope.ssnSabun}");
		$("#searchAppName").val("${sessionScope.ssnName}");
		$("#searchKeyword").val("${sessionScope.ssnName}");
	});

	// 평가차수 setting(평가명 변경시, 사번 변경시)
	function setAppSeqCd() {
		var appSeqCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAppSeqCdListMbo&"+$("#empForm").serialize(),false).codeList, "");

		if ( !appSeqCdList ){
			$("#searchAppSeqCd").html("");
		} else{
			$("#searchAppSeqCd").html(appSeqCdList[2]);
		}

		doAction("Search");
	}

	// 임직원조회 자동완성 결과 세팅 처리
	function setEmpPage(){
		$("#searchAppName").val($("#searchKeyword").val());
		$("#searchAppSabun").val($("#searchUserId").val());
		setAppSeqCd();
	}

	//사원 팝업
	function employeePopup(){
		try{
			if(!isPopup()) {return;}

			var args	= new Array();

			gPRow = "";
			pGubun = "searchEmployeePopup";

			openPopup("/Popup.do?cmd=employeePopup", args, "740","520");
		}catch(ex){alert("Open Popup Event Error : " + ex);}
	}

	function doAction(sAction) {
		switch (sAction) {
		case "Search":
			doAction1("Search");
			break;
		}
	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

        if(pGubun == "searchEmployeePopup"){
			$("#searchAppName").val(rv["name"]);
			$("#searchAppSabun").val(rv["sabun"]);
			setAppSeqCd();
        }else if(pGubun == "viewCoachingInsertPop"){
          	doAction2("Search");
        }
	}

    //신청 팝업
    function insertPopup(authPg,coaYmd) {

    	if ( sheet1.RowCount() == 0 ) {
			alert("피평가자를 선택해 주세요");
			return;
		}

        if(!isPopup()) {return;}

        pGubun = "viewCoachingInsertPop";

        var url ="/AppCoachingApr.do?cmd=viewCoachingInsertPop";

        var args = new Array(10);
        args["appSeqCdNm"]  = sheet1.GetCellValue(sheet1.GetSelectRow(), "appSeqCdNm");
        args["appName"]     = $("#searchAppName").val();
        args["editable"]    = "Y";
        args["appraisalCd"] = $("#searchAppraisalCd2").val();
        args["sabun"]       = $("#searchSabun2").val();
        args["appOrgCd"]    = $("#searchAppOrgCd2").val();
        args["appSeqCd"]    = $("#searchAppSeqCd2").val();
        args["appSabun"]    = $("#searchAppSabun2").val();
        args["coaYmd"]      = coaYmd;
        args["authPg"]      = authPg;

        openPopup(url,args,500,480);
    }

</script>

<!-- sheet1 script -->
<script type="text/javascript">
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			doAction2("Clear");
			sheet1.DoSearch( "${ctx}/AppCoachingApr.do?cmd=getAppCoachingAprList1", $("#empForm").serialize() ); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != "")	alert(Msg);

			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			//// Insert KEY
			//if (Shift == 1 && KeyCode == 45) {
			//	doAction1("Insert");
			//}
			////Delete KEY
			//if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
			//	sheet1.SetCellValue(Row, "sStatus", "D");
			//}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	// 셀이 선택 되었을때 발생한다
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol,isDelete) {
		try {
			if(OldRow == NewRow || sheet1.GetCellValue(NewRow, "sStatus") == "I") return;

			// 피평가자 정보 setting
			$("#iName").html( sheet1.GetCellValue(NewRow, "name") +"/"+ sheet1.GetCellValue(NewRow, "sabun") );
			$("#iOrgnm").html( sheet1.GetCellValue(NewRow, "appOrgNm"));
			$("#iEmpYmd").html( sheet1.GetCellText(NewRow, "empYmd"));
			$("#iJikgub").html( sheet1.GetCellValue(NewRow, "jikgubNm"));
			$("#iJikchak").html( sheet1.GetCellValue(NewRow, "jikchakNm"));
			$("#iJikgubYeuncha").html( sheet1.GetCellValue(NewRow, "jikgubYeuncha"));

			doAction2("Search");
		} catch (ex) {
			alert("OnSelectCell Event Error : " + ex);
		}
	}

</script>

<!-- sheet2 script -->
<script type="text/javascript">
	//Example Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			var Row = sheet1.GetSelectRow();

			$("#searchAppraisalCd2").val( sheet1.GetCellValue(Row, "appraisalCd") );
			$("#searchSabun2").val( sheet1.GetCellValue(Row, "sabun") );
			$("#searchAppOrgCd2").val( sheet1.GetCellValue(Row, "appOrgCd") );
			$("#searchAppSabun2").val( $("#searchAppSabun").val() );
			$("#searchAppSeqCd2").val( sheet1.GetCellValue(Row, "appSeqCd") );

			sheet2.DoSearch( "${ctx}/AppCoachingApr.do?cmd=getAppCoachingAprList2", $("#sheet2Frm").serialize() ); break;
		case "Save":
			if(sheet2.FindStatusRow("I") != ""){
				if(!dupChk(sheet2,"appraisalCd|sabun|appOrgCd|appSeqCd|appSabun|coaYmd", true, true)){break;}
			}
			IBS_SaveName(document.sheet2Frm,sheet2);
			sheet2.DoSave( "${ctx}/AppCoachingApr.do?cmd=saveAppCoachingApr", $("#sheet2Frm").serialize()); break;
		case "Insert":
			if ( sheet1.RowCount() == 0 ) {
				alert("피평가자를 선택해 주세요");
				return;
			}
			//insertPopup();
			/*
			var Row = sheet2.DataInsert(0);

			sheet2.SetCellValue(Row, "appSeqCdNm", sheet1.GetCellValue(sheet1.GetSelectRow(), "appSeqCdNm"));
			sheet2.SetCellValue(Row, "appName", $("#searchAppName").val());

			sheet2.SetCellValue(Row, "editable", "Y");
			sheet2.SetCellValue(Row, "appraisalCd", $("#searchAppraisalCd2").val());
			sheet2.SetCellValue(Row, "sabun", $("#searchSabun2").val());
			sheet2.SetCellValue(Row, "appOrgCd", $("#searchAppOrgCd2").val());
			sheet2.SetCellValue(Row, "appSeqCd", $("#searchAppSeqCd2").val());
			sheet2.SetCellValue(Row, "appSabun", $("#searchAppSabun2").val());
			*/
			//sheet2.SelectCell(Row, "coaYmd");
			break;
		case "Copy":
			var Row = sheet2.DataCopy();

			sheet2.SetCellValue(Row, "appSeqCdNm", sheet1.GetCellValue(sheet1.GetSelectRow(), "appSeqCdNm"));
			sheet2.SetCellValue(Row, "appName", $("#searchAppName").val());

			sheet2.SetCellValue(Row, "editable", "Y");
			sheet2.SetCellValue(Row, "appraisalCd", $("#searchAppraisalCd2").val());
			sheet2.SetCellValue(Row, "sabun", $("#searchSabun2").val());
			sheet2.SetCellValue(Row, "appOrgCd", $("#searchAppOrgCd2").val());
			sheet2.SetCellValue(Row, "appSeqCd", $("#searchAppSeqCd2").val());
			sheet2.SetCellValue(Row, "appSabun", $("#searchAppSabun2").val());

			sheet2.SetRowEditable(Row, 1);
			break;

		case "Clear":
			$("#iName").html( "" );
			$("#iOrgnm").html( "" );
			$("#iEmpYmd").html( "" );
			$("#iJikgub").html( "" );
			$("#iJikchak").html( "" );
			$("#iJikgubYeuncha").html( "" );

			sheet2.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet2.Down2Excel(param);
			break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet2.LoadExcel(params); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != ""){
				alert(Msg);
			}

			// 피평가자가 다른 경우 수정, 삭제 불가
			for( var i=sheet2.HeaderRows(); i<=sheet2.LastRow(); i++) {
				if ( sheet2.GetCellValue(i, "editable") == "N" ) sheet2.SetRowEditable(i, 0);
			}

			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != ""){
				alert(Msg);
			}
			if ( Code != -1 ) doAction2("Search");
		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
	}

    // 셀 클릭시 발생
    function sheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
        try {
        	if (Row < sheet2.HeaderRows()) return;

            if( sheet2.ColSaveName(Col) == "ibsImage" ) {
            	insertPopup("R",sheet2.GetCellValue(Row,"coaYmd"));
            }

        } catch (ex) {
            alert("OnClick Event Error : " + ex);
        }
    }

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="empForm" name="empForm" >
	<input type="hidden" id="searchAppStepCds" name="searchAppStepCds" value="'1','3'" />
	<!-- 조회영역 > 성명 자동완성 관련 추가 -->
	<input type="hidden" id="searchEmpType"  name="searchEmpType" value="I"/>
	<input type="hidden" id="searchUserId"   name="searchUserId" value="" />
	<input type="hidden" id="searchUserEnterCd"  name="searchUserEnterCd" value="" />
	<!-- 조회영역 > 성명 자동완성 관련 추가 -->

	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<td colspan="2">
				<span>평가명 </span> <select id="searchAppraisalCd" name="searchAppraisalCd"> </select>
			</td>
			<td><span>성명 </span>
				<input id="searchAppSabun" name ="searchAppSabun" value="${sessionScope.ssnSabun}" type="hidden" class="text"	/>
				<input id="searchAppName" name ="searchAppName" value="${sessionScope.ssnName}" type="hidden" />
				<input type="text"   id="searchKeyword"  name="searchKeyword" class="text w100" style="ime-mode:active" value="${sessionScope.ssnName}" />
				<!-- 자동완성기능 사용으로 인한 주석 처리
				<input id="searchAppName" name ="searchAppName" value="${sessionScope.ssnName}" type="text" class="text readonly " readOnly /> <a onclick="javascript:employeePopup();" class="button6 btnSabunPop"><img src="/common/images/common/btn_search2.gif"/></a>
				<a onclick="$('#searchAppSabun,#searchAppName').val('');" class="button7 btnSabunPop"><img src="/common/images/icon/icon_undo.png"/></a>
				-->
			</td>
			<td>
				<span>평가명차수</span> <select id="searchAppSeqCd" name="searchAppSeqCd"> </select>
			</td>
			<td>
				<a href="javascript:doAction1('Search')" id="btnSearch" class="btn dark">조회</a>
			</td>
		</tr>
		</table>
		</div>
	</div>
	</form>

	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<colgroup>
		<col width="40%" />
		<col width="15px" />
		<col width="%" />
	</colgroup>
	<tr>
		<td class="">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt">피평가자</li>
					<li class="btn">
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
		</td>
		<td></td>
		<td class="">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt">피평가자정보</li>
					<li class="btn">

					</li>
				</ul>
				</div>
			</div>
			<div class="inner">
				<table class="table w100p" id="htmlTable">
					<colgroup>
						<col width="14%" />
						<col width="20%" />
						<col width="10%" />
						<col width="30%" />
						<col width="13%" />
						<col width="%" />
					</colgroup>
					<tr>
						<th>성명/사번</th><td id="iName"></td>
						<th>소속</th><td id="iOrgnm"></td>
						<th>입사일</th><td id="iEmpYmd"></td>
					</tr>
					<tr>
						<th>직급</th><td id="iJikgub"></td>
						<th>직책</th><td id="iJikchak"></td>
						<th>직급년차</th><td id="iJikgubYeuncha"></td>
					</tr>
				</table>
			</div>
			<form id="sheet2Frm" name="sheet2Frm" >
				<input type="hidden" id="searchAppraisalCd2" name="searchAppraisalCd" value=""/>
				<input type="hidden" id="searchSabun2" name="searchSabun" value=""/>
				<input type="hidden" id="searchAppOrgCd2" name="searchAppOrgCd" value=""/>
				<input type="hidden" id="searchAppSabun2" name="searchAppSabun" value=""/>
				<input type="hidden" id="searchAppSeqCd2" name="searchAppSeqCd" value=""/>
			</form>
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt">Coaching 내역</li>
					<li class="btn">
						<a href="javascript:doAction2('Down2Excel')" 	class="btn outline_gray authR">다운로드</a>
						<a href="javascript:doAction2('Copy')" 			class="btn outline_gray authA">복사</a>
						<a href="javascript:insertPopup('A','');"     class="btn outline_gray authA">입력</a>
						<a href="javascript:doAction2('Save')"			class="btn filled authA">저장</a>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet2", "100%", "100%"); </script>
		</td>
	</tr>
	</table>

</div>
</body>
</html>