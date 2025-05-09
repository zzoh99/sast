<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>평가자</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("${popUpStatus}");
	var gPRow = "";
	var pGubun = "";
	var isSave = false;

	$(function() {
		$(".close, #close").click(function() {
			if(isSave) top.opener.doAction1("Search");
			p.self.close();
		});

		var arg = p.popDialogArgumentAll();
	    if( arg != undefined ) {
		    $("#searchAppraisalCd").val(arg["searchAppraisalCd"]);
		    $("#searchAppStepCd").val(arg["searchAppStepCd"]);
		    $("#searchAppOrgCd").val(arg["searchAppOrgCd"]);
		    $("#searchAppOrgNm").html(arg["searchAppOrgNm"]);
		    $("#searchSabun").val(arg["searchSabun"]);
		    $("#searchName").html(arg["searchName"]);
		    $("#appTypeCd").val(arg["appTypeCd"]);
		    $("#searchAppraisalNm").html(arg["searchAppraisalNm"]);
	    }

		if ($("#searchAppraisalCd").val() == "" || $("#searchAppStepCd").val() == "" || $("#searchAppOrgCd").val() == "" || $("#searchSabun").val() == "") {
			alert("평가대상자가 존재하지 않습니다. \n팝업을 닫고 평가대상자를 입력하시기 바랍니다.");
			p.self.close();
		}
	});
	$(function() {

  		var seqCdParam = "", pHdn = 0;
  		if( $("#appTypeCd").val() == "D"){ //다면평가
  			seqCdParam = "&searchNote4=Y";
  			pHdn = 1; //다면평가는 평가그룹이 없음.
  		}else{
  			seqCdParam = "&searchNote3=Y";
  			pHdn = ($("#searchAppStepCd").val() == "5" )?0:1;
  		}

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata.Cols = [
			{Header:"No"			,Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제"			,Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center", ColMerge:0,	SaveName:"sDelete" },
			{Header:"상태"			,Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center", ColMerge:0,	SaveName:"sStatus" },

			{Header:"차수"			,Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"appSeqCd",		KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"성명"			,Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"appName",			KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:500 },
			{Header:"사번"			,Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"appSabun",		KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"소속"			,Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:1,	SaveName:"orgNm",			KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직급"			,Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"jikgubNm",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직책"			,Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"jikchakNm",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"평가그룹"		,Type:"Popup",		Hidden:pHdn,Width:80,	Align:"Center",	ColMerge:1,	SaveName:"appGroupNm",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },

			{Header:"평가ID"			,Type:"Text",		Hidden:1,	Width:50,	Align:"Left",	ColMerge:1,	SaveName:"appraisalCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500 },
			{Header:"평가단계"		,Type:"Text",		Hidden:1,	Width:50,	Align:"Left",	ColMerge:1,	SaveName:"appStepCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500 },
			{Header:"평가소속코드"	,Type:"Text",		Hidden:1,	Width:50,	Align:"Left",	ColMerge:1,	SaveName:"appOrgCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"평가소속"		,Type:"Text",		Hidden:1,	Width:50,	Align:"Left",	ColMerge:1,	SaveName:"appOrgNm",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"사원번호"		,Type:"Text",		Hidden:1,	Width:50,	Align:"Left",	ColMerge:1,	SaveName:"sabun",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"직위코드"		,Type:"Text",		Hidden:1,	Width:50,	Align:"Left",	ColMerge:1,	SaveName:"jikweeCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500 },
			{Header:"직급코드"		,Type:"Text",		Hidden:1,	Width:50,	Align:"Left",	ColMerge:1,	SaveName:"jikgubCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500 },
			{Header:"직책코드"		,Type:"Text",		Hidden:1,	Width:50,	Align:"Left",	ColMerge:1,	SaveName:"jikchakCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500 },
			{Header:"직위"			,Type:"Text",		Hidden:1,	Width:80,	Align:"Left",	ColMerge:1,	SaveName:"jikweeNm",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"조직코드"		,Type:"Text",		Hidden:1,	Width:50,	Align:"Left",	ColMerge:1,	SaveName:"orgCd",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"평가대상그룹"	,Type:"Text",		Hidden:1,	Width:80,	Align:"Left",	ColMerge:1,	SaveName:"appGroupCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
  		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetUnicodeByte(3);

		//Autocomplete	
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "appName",
					CallbackFunc : function(returnValue) {
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow,"appName",(rv["name"]));
						sheet1.SetCellValue(gPRow,"appSabun",(rv["sabun"]));
						sheet1.SetCellValue(gPRow,"orgCd",(rv["orgCd"]));
						sheet1.SetCellValue(gPRow,"orgNm",(rv["orgNm"]));
						sheet1.SetCellValue(gPRow,"jikgubNm",(rv["jikgubNm"]));
						sheet1.SetCellValue(gPRow,"jikgubCd",(rv["jikgubCd"]));
						sheet1.SetCellValue(gPRow,"jikweeNm",(rv["jikweeNm"]));
						sheet1.SetCellValue(gPRow,"jikweeCd",(rv["jikweeCd"]));
						sheet1.SetCellValue(gPRow,"jikchakNm",(rv["jikchakNm"]));
						sheet1.SetCellValue(gPRow,"jikchakCd",(rv["jikchakCd"]));
						sheet1.SetCellValue(gPRow,"jobCd",(rv["jobCd"]));
						sheet1.SetCellValue(gPRow,"jobNm",(rv["jobNm"]));
					}
				}
			]
		});

 		var appSeqCdList	= convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getComCodeNoteList&searchGrcodeCd=P00003&searchUseYn=Y"+seqCdParam,false).codeList, "");
		sheet1.SetColProperty("appSeqCd",	{ComboText:"|"+appSeqCdList[0], ComboCode:"|"+appSeqCdList[1]} );

		$(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");
	});


	function doAction1(sAction){
		//removeErrMsg();
		switch(sAction){
		case "Search":		//조회
			if ($("#searchAppraisalCd").val() == "" || $("#searchAppStepCd").val() == "" || $("#searchAppOrgCd").val() == "" || $("#searchSabun").val() == "") {
				alert("평가대상자가 존재하지 않습니다. \n팝업을 닫고 평가대상자를 입력하시기 바랍니다.");
				return;
			}
			sheet1.DoSearch("${ctx}/AppPeopleMgr.do?cmd=getAppPeopleMgrList2", $("#sheet1Form").serialize());
			break;

		case "Save":		//저장
			if(sheet1.FindStatusRow("I") != ""){
				if(!dupChk(sheet1,"appraisalCd|appStepCd|sabun|appOrgCd|appSeqCd|appSabun", true, true)){break;}
			}
			 //상사평가 갯수 체크
			var chk = 0;
			for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows() ; i++) {
				if( sheet1.GetCellValue(i, "sStatus") != "D" && sheet1.GetCellValue(i, "appSeqCd") == "3" ){
					chk++;
				}
			}
			/*
			if( chk > 1 ){
				alert("상사평가자는 1명만 등록 가능합니다.");
				return;
			}
			*/
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/AppPeopleMgr.do?cmd=saveAppPeopleMgr2" , $("#sheet1Form").serialize());
			break;

		case "Insert":		//입력
			if ($("#searchAppraisalCd").val() == "" || $("#searchAppStepCd").val() == "" || $("#searchAppOrgCd").val() == "" || $("#searchSabun").val() == "") {
				alert("평가대상자가 존재하지 않습니다. \n팝업을 닫고 평가대상자를 입력하시기 바랍니다.");
				return;
			}

			var Row = sheet1.DataInsert(0);
			sheet1.SetCellValue(Row, "appraisalCd",	$("#searchAppraisalCd").val());
			sheet1.SetCellValue(Row, "sabun",		$("#searchSabun").val());
			sheet1.SetCellValue(Row, "appOrgCd",	$("#searchAppOrgCd").val());
			sheet1.SetCellValue(Row, "appStepCd",	$("#searchAppStepCd").val());
			sheet1.SetCellValue(Row, "appOrgNm",	$("#searchAppOrgNm").val());
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

	//조회 후 에러 메시지
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
		try{
			if(Msg != "") {
				alert(Msg);
			}
			if ( Code != "-1" ) {
				isSave = true;
				doAction1("Search");
			}
		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	//Type이 POPUP인 셀에서 팝업버튼을 눌렀을때 발생하는 이벤트
	function sheet1_OnPopupClick(Row, Col){
		try{
			if( sheet1.ColSaveName(Col) == "appName" ) {
				if(!isPopup()) {return;}

				var args	= new Array();

				gPRow = Row;
				pGubun = "employeePopup";

				openPopup("/Popup.do?cmd=employeePopup", args, "740","520");

			}else if( sheet1.ColSaveName(Col) == "appGroupNm" ) {
				if(!isPopup()) {return;}

				var args = new Array();
				args["searchAppraisalCd"] = sheet1.GetCellValue(Row, "appraisalCd");
				args["searchAppSeqCd"] = sheet1.GetCellValue(Row, "appSeqCd");

				gPRow = Row;
				pGubun = "appPeopleMgrPop";

				openPopup("${ctx}/AppPeopleMgr.do?cmd=viewAppPeopleMgrPop", args, "500","500");
			}

		}catch(ex){
			alert("OnPopupClick Event Error : " + ex);
		}
	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

        if(pGubun == "employeePopup"){
			sheet1.SetCellValue(gPRow,"appName",(rv["name"]));
			sheet1.SetCellValue(gPRow,"appSabun",(rv["sabun"]));
			sheet1.SetCellValue(gPRow,"orgCd",(rv["orgCd"]));
			sheet1.SetCellValue(gPRow,"orgNm",(rv["orgNm"]));
			sheet1.SetCellValue(gPRow,"jikgubNm",(rv["jikgubNm"]));
			sheet1.SetCellValue(gPRow,"jikgubCd",(rv["jikgubCd"]));
			sheet1.SetCellValue(gPRow,"jikweeNm",(rv["jikweeNm"]));
			sheet1.SetCellValue(gPRow,"jikweeCd",(rv["jikweeCd"]));
			sheet1.SetCellValue(gPRow,"jikchakNm",(rv["jikchakNm"]));
			sheet1.SetCellValue(gPRow,"jikchakCd",(rv["jikchakCd"]));
			sheet1.SetCellValue(gPRow,"jobCd",(rv["jobCd"]));
			sheet1.SetCellValue(gPRow,"jobNm",(rv["jobNm"]));
        } else if(pGubun == "appPeopleMgrPop") {
			sheet1.SetCellValue(gPRow,"appGroupCd",(rv["appGroupCd"]));
			sheet1.SetCellValue(gPRow,"appGroupNm",(rv["appGroupNm"]));
		}
	}

	function setValue() {
		var rv = new Array();

		p.popReturnValue(rv);
		p.window.close();
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="popup_title">
	<ul>
		<li>평가자설정</li>
		<li class="close"></li>
	</ul>
	</div>

	<div class="popup_main">
		<form id="sheet1Form" name="sheet1Form" >
		<input type="hidden" name="searchAppraisalCd" id="searchAppraisalCd" value="">
		<input type="hidden" name="searchAppStepCd" id="searchAppStepCd" value="">
		<input type="hidden" name="searchAppOrgCd" id="searchAppOrgCd" value="">
		<input type="hidden" name="searchSabun" id="searchSabun" value="">
		<input type="hidden" name="appTypeCd" id="appTypeCd" value="">

		<div class="sheet_search outer">
            <div>
            <table>
            <tr>
                <td>
                	<span>평가명</span>
					<span id="searchAppraisalNm" class="txt" style="font-weight:normal"></span>
				</td>
                <td>
                	<span>평가대상자</span>
                	<span id="searchName" class="txt" style="font-weight:normal"></span>
                </td>
                <td>
                	<span>평가소속</span>
                	<span id="searchAppOrgNm" class="txt" style="font-weight:normal"></span>
                </td>
                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
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
				<li id="txt" class="txt">평가자</li>
				<li class="btn">
					<a href="javascript:doAction1('Insert')" class="basic authA">입력</a>
					<a href="javascript:doAction1('Copy')" 	class="basic authA">복사</a>
					<a href="javascript:doAction1('Save')" 	class="basic authA">저장</a>
					<a href="javascript:doAction1('Down2Excel')" 	class="basic authR">다운로드</a>
				</li>
			</ul>
			</div>
		</div>
		<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>

		<div class="popup_button outer">
		<div style="text-align:left; color:red;margin-top:-15px">*상사평가,동료평가의 평가자 변경 시 역량평가표를 재생성 해야 합니다.</div>
		<ul>
			<li>
			<%--
				<a href="javascript:setValue();" class="pink large">확인</a>
				--%>
				<a id="close" class="gray large">닫기</a>
			</li>
		</ul>
		</div>
	</div>
</div>
</body>
</html>