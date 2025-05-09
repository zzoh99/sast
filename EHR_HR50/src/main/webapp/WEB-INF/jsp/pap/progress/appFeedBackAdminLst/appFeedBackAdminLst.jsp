<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">
	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No|No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",		Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",		Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"평가년도|평가년도",	Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appraisalYy",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"평가코드|평가코드",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"성과평가|성과평가",	Type:"Text",	Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"appraisalNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"사번|사번",			Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"성명|성명",			Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"소속|소속",			Type:"Text",	Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직책|직책",			Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직위|직위",			Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직급|직급",			Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"년차|년차",			Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"jikgubYeuncha",KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"호봉|호봉",			Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"salClassNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직군|직군",			Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"workTypeNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직무|직무",			Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"jobNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"평가그룹|평가그룹",	Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appGroupCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"조직평가\n점수|조직평가\n점수",		Type:"Text",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"mboPoint",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"조직평가\n등급|조직평가\n등급",		Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"mboClassCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"역량평가\n점수|역량평가\n점수",		Type:"Text",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"compPoint",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"역량평가\n등급|역량평가\n등급",		Type:"Text",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"compClassCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"개인평가\n점수|개인평가\n점수",		Type:"Text",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"appPoint",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"개인평가\n등급|개인평가\n등급",		Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"appClassCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"누적\n승진포인트|누적\n승진포인트",		Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"sumSjPoint",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"상벌점|상벌점",	    Type:"Image",	Hidden:1,  	Width:60,	Align:"Center",	ColMerge:0, SaveName:"prize",		KeyField:0, Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"평가의견|평가의견",	Type:"Image",	Hidden:1,  	Width:60,	Align:"Center",	ColMerge:0, SaveName:"appMemo",		KeyField:0, Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"실적확인|실적확인",	Type:"Image",	Hidden:1,  	Width:60,	Align:"Center",	ColMerge:0, SaveName:"result",		KeyField:0, Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"실적확인|실적확인",	Type:"Image",	Hidden:0,	Width:100, Align:"Center", ColMerge:0,  SaveName:"pfmChk" ,  	KeyField:0,   CalcLogic:"", Format:"",     		PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:50}
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		//헤더머지
		sheet1.SetMergeSheet( msHeaderOnly);

		$(window).smartresize(sheetResize); sheetInit();

		setEmpPage();
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/AppFeedBackAdminLst.do?cmd=getAppFeedBackAdminLstList", $("#srchFrm").serialize() ); break;
		case "Save": 		
							IBS_SaveName(document.srchFrm,sheet1);
							sheet1.DoSave( "${ctx}/AppFeedBackAdminLst.do?cmd=saveAppFeedBackAdminLst", $("#srchFrm").serialize()); break;
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


	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != ""){
				alert(Msg);
			}

			for(var r = sheet1.HeaderRows(); r<sheet1.RowCount()+sheet1.HeaderRows(); r++){
				sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
				sheet1.SetDataLinkMouse("pfmChk",1);
				sheet1.SetCellValue(r,"pfmChk","0");
				sheet1.SetCellValue(r, "sStatus", 'R');
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

			if(Row > 0 && sheet1.ColSaveName(Col) == "appMemo"){

				 var args    = new Array();
		         args["searchSabun"]    = $("#searchSabun").val();
		         args["searchYear"]   	= sheet1.GetCellValue(Row,"appraisalYy");

		         var rv = openPopup("/AppFeedBackAdminLst.do?cmd=viewAppFeedbackLstPopup", args, "700","320");
			}

			if(Row > 0 && sheet1.ColSaveName(Col) == "result"){
			  var args    = new Array();
		         args["searchSabun"]         = $("#searchSabun").val();
		         args["searchAppraisalCd"]   	= sheet1.GetCellValue(Row,"appraisalCd");
		         args["searchYear"]   	= sheet1.GetCellValue(Row,"appraisalYy");

		         var rv = openPopup("/CompAppSelfReg.do?cmd=viewCompAppSelfRegPop", args, "740","520");

			}
			if(Row > 0 && sheet1.ColSaveName(Col) == "prize"){
				 var args    = new Array();
				 args["searchSabun"]			= $("#searchSabun").val();
				 args["searchYear"]   	= sheet1.GetCellValue(Row,"appraisalYy");
				 var rv = openPopup("/CompApp1stApr.do?cmd=compApp1stAprPrizePopup", args, "740","520");


			}

			if(sheet1.ColSaveName(Col) == "pfmChk"){
				var year = "${curSysYear}";
				var args				=	new	Array();
				args["searchSabun"]			=	$("#searchUserId").val();
				args["searchAppraisalCd"]   = 	year.substring(2, 4)+"B01";
				var rv	= openPopup("/CompApp1stApr.do?cmd=viewPfmcCoachingPrizeChk", args, "740","800");
			}


		}catch(ex){alert("OnClick Event Error : " + ex);}
	}

//  Type이 POPUP인 셀에서 팝업버튼을 눌렀을때 발생하는 이벤트
    function sheet1_OnPopupClick(Row, Col){
        try{

          var colName = sheet1.ColSaveName(Col);
          var args    = new Array();

          args["name"]   = sheet1.GetCellValue(Row, "name");
          args["sabun"]  = sheet1.GetCellValue(Row, "sabun");

          var rv = null;

          if(colName == "name") {

              var rv = openPopup("/Popup.do?cmd=employeePopup", args, "740","520");
              if(rv!=null){
                  sheet1.SetCellValue(Row, "name",   rv["name"] );
                  sheet1.SetCellValue(Row, "sabun",  rv["sabun"] );

                  sheet1.SetCellValue(Row, "resNo",  rv["resNo"].replace(/\//g,'') );
              }
          }

        }catch(ex){alert("OnPopupClick Event Error : " + ex);}
    }


    function setEmpPage() {

    	$("#searchSabun").val($("#searchUserId").val());

    	$("#searchName").val($("#searchKeyword").val());


		doAction1("Search");
    }

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<!-- include 기본정보 page TODO -->
	<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>
	<form id="srchFrm" name="srchFrm" >
	<input type="hidden" id="searchSabun" name="searchSabun" value=""/>
	<input type="hidden" id="searchName" name="searchName" value=""/>
	</form>

		<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">평가결과피드백</li>
			<li class="btn">
				<!-- <a href="/html/HRplan.pdf" class="button">사전준비사항</a> -->
				<a href="javascript:doAction1('Search')" class="basic authA">조회</a>
				<a href="javascript:doAction1('Search')" class="basic authA">다운로드</a>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>