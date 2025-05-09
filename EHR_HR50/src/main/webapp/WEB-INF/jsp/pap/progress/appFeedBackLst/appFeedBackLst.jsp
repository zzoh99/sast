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
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22, MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No|No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",				Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",				Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			
			{Header:"\n선택|\n선택",			Type:"CheckBox",	Hidden:1,					Width:50,	Align:"Center",	ColMerge:0,	SaveName:"chk",					KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"평가명|평가명",			Type:"Text",		Hidden:0,					Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appraisalNm",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"소속|소속",				Type:"Text",		Hidden:0,					Width:150,	Align:"Center",	ColMerge:0,	SaveName:"appOrgNm",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직위|직위",				Type:"Text",		Hidden:Number("${jwHdn}"),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직급|직급",				Type:"Text",		Hidden:Number("${jgHdn}"),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직책|직책",				Type:"Text",		Hidden:0,					Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"평가등급|업적",			Type:"Text",		Hidden:1,					Width:60,	Align:"Center",	ColMerge:0,	SaveName:"finalMboClassNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"평가등급|역량",			Type:"Text",		Hidden:1,					Width:60,	Align:"Center",	ColMerge:0,	SaveName:"finalCompClassNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"평가등급|다면",			Type:"Text",		Hidden:1,					Width:60,	Align:"Center",	ColMerge:0,	SaveName:"finalMutualClassNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"평가등급|최종",			Type:"Text",		Hidden:0,					Width:60,	Align:"Center",	ColMerge:0,	SaveName:"finalClassNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0},

			{Header:"출력|출력",				Type:"Image",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"print", Cursor:"Pointer" },
			{Header:"이의제기|세부\n내역",		Type:"Image",		Hidden:0,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"detail", Cursor:"Pointer" },
			{Header:"이의제기|상태",			Type:"Text",		Hidden:0,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"protestYn"},
			{Header:"이의제기|의견(업적)",		Type:"Text",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"protestMemoMbo"},
			{Header:"이의제기|의견(역량)",		Type:"Text",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"protestMemoComp"},

			{Header:"이의제기|허용여부",		Type:"Text",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"exceptionYn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"이의제기|허용시작일",		Type:"Date",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"exceptionSdate",		KeyField:0, Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"이의제기|허용종료일",		Type:"Date",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"exceptionEdate",		KeyField:0, Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			
			{Header:"평가ID|평가ID",			Type:"Text",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd"},
			{Header:"평가소속|평가소속",		Type:"Text",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd"},
			{Header:"사번|사번",				Type:"Text",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"sabun"}

		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("true");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetImageList(1,"${ctx}/common/images/icon/icon_popup.png");
		//sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_print.png");
		sheet1.SetDataLinkMouse("detail",1);
		$(window).smartresize(sheetResize); sheetInit();

		setEmpPage();
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/AppFeedBackLst.do?cmd=getAppFeedBackLstList", $("#srchFrm").serialize() ); break;
		case "Save":
							IBS_SaveName(document.srchFrm,sheet1);
							sheet1.DoSave( "${ctx}/AppFeedBackLst.do?cmd=saveAppFeedBackLst", $("#srchFrm").serialize()); break;
		case "Insert":		sheet1.SelectCell(sheet1.DataInsert(0), "col2"); break;
		case "Copy":		sheet1.DataCopy(); break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
			break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		case "Print": //출력
			rdPopup();
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

	function exception_chk(Row){
		if(sheet1.GetCellValue(Row, "exceptionYn") == "Y"){
			var date = new Date();
			/* 날짜 테스트용 */
			//date = makeDateFormat("2017-06-25");

			if(makeDateFormat(sheet1.GetCellValue(Row, "exceptionSdate")) != false && makeDateFormat(sheet1.GetCellValue(Row, "exceptionEdate")) != false) {
				if (date < makeDateFormat(sheet1.GetCellValue(Row, "exceptionSdate"))) {
					alert("이의제기는 이의제기 허용시작일 이전에 할 수 없습니다.");
					return 0;
				} else if (date > makeDateFormat(sheet1.GetCellValue(Row, "exceptionEdate"))) {
					alert("확인 및 입력할 수 있는 기간이 아닙니다!");
					return 0;
				}
			}else{
				alert("이의제기 허용시작일 또는 종료일이 없습니다.\n관리자에게 문의하세요.");
				return 0;
			}
			return 2;
		}else{
			alert("이의제기가 허용되지 않는 평가입니다!");
			return 0;
		}
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
			if(Row <= 1) return;
			if(sheet1.ColSaveName(Col) == "detail" ){
				/* 이의제기 조건 체크 */
				var chkData = exception_chk(Row);
				var protestYn;
				var protestFeedBackYn;
				var saveBtnYn;

				if(chkData == 0) {
					return;
				}else if(chkData == 1){
					protestYn		   = 'N';
					protestFeedBackYn   = 'N';
					saveBtnYn			= 'N';
				}else if(chkData == 2){
					protestYn		   = 'Y';
					protestFeedBackYn   = 'N';
					saveBtnYn			= 'Y';
				}
				if(!isPopup()) {return;}

		 		var args = {};
		 		args["searchAppraisalCd"]	   = sheet1.GetCellValue(Row, "appraisalCd");
		 		args["searchSabun"]			 = sheet1.GetCellValue(Row, "sabun");
		 		args["searchAppOrgCd"]		  = sheet1.GetCellValue(Row, "appOrgCd");
		 		args["protestYn"]			   = protestYn;
		 		args["protestMemoMbo"]			= sheet1.GetCellValue(Row, "protestMemoMbo");
		 		args["protestMemoComp"]			= sheet1.GetCellValue(Row, "protestMemoComp");
		 		args["protestMemoFeedBackYn"]   = protestFeedBackYn;
				args["saveBtnYn"]   			= saveBtnYn;
				gPRow = "";
				pGubun = "apFeedBackLstCommentView";

				var layer = new window.top.document.LayerModal({
					id : 'apFeedBackLstCommentViewLayer'
					, url : "${ctx}/AppFeedBackLst.do?cmd=viewAppFeedBackLstComment"
					, parameters: args
					, width : 500
					, height : 850
					, title : "이의제기"
					, trigger :[
						{
							name : 'apFeedBackLstCommentViewTrigger'
							, callback : function(rv){
								doAction1("Search");
							}
						}
					]
				});
				layer.show();




			}else if(sheet1.ColSaveName(Col) == "print" && Value == "1" ){
				rdPopup(sheet1.GetCellValue(Row, "appraisalCd"), sheet1.GetCellValue(Row, "sabun"), sheet1.GetCellValue(Row, "appOrgCd"));
			}
		}catch(ex){
			alert("OnClick Event Error : " + ex);
		}
	}

	function setEmpPage() {
		$("#searchSabun").val($("#searchUserId").val());
		$("#searchName").val($("#searchKeyword").val());

		doAction1("Search");
	}

	/**
	 * 출력 window open event
	 * 레포트 공통에 맞춘 개발 코드 템플릿
	 * by JSG
	 */
	function rdPopup(){
		if(!isPopup()) {return;}

		var w 		= 1200;
		var h 		= 950;
		var url 	= "${ctx}/RdPopup.do";
		var args 	= new Array();
		// args의 Y/N 구분자는 없으면 N과 같음

		var rdMrd   = "pap/progress/AppReport_HR.mrd";
		var rdTitle = "평가출력물";
		var rdParam = "";

		var searchAppraisalCdSAbunAppOrgCd_s = "";

		for ( var i=sheet1.HeaderRows(); i<=sheet1.LastRow(); i++ ) {
			if ( sheet1.GetCellValue(i, "chk") == 0 ) continue;
			searchAppraisalCdSAbunAppOrgCd_s = searchAppraisalCdSAbunAppOrgCd_s + "('" + sheet1.GetCellValue(i, "appraisalCd") + "', '"+ sheet1.GetCellValue(i, "sabun") +"', '"+ sheet1.GetCellValue(i, "appOrgCd") +"'),";
		}

		if ( searchAppraisalCdSAbunAppOrgCd_s == "" ) {
			alert("선택된 피평가자가 없습니다.");
			return;
		}

		searchAppraisalCdSAbunAppOrgCd_s = searchAppraisalCdSAbunAppOrgCd_s.substr(0, searchAppraisalCdSAbunAppOrgCd_s.length-1);

		rdParam  = rdParam +"[${ssnEnterCd}] "; //회사코드
		rdParam  = rdParam +"[5] "; //단계
		rdParam  = rdParam +"[6] "; //차수
		rdParam  = rdParam +"["+ searchAppraisalCdSAbunAppOrgCd_s +"] "; //피평가자 사번, 평가소속
		rdParam  = rdParam +"[Y] "; //최종결과출력

		var imgPath = " " ;
		args["rdTitle"] = rdTitle ;	//rd Popup제목
		args["rdMrd"] =  rdMrd;		//( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명
		args["rdParam"] = rdParam;	//rd파라매터
		args["rdParamGubun"] = "rp";//파라매터구분(rp/rv)
		args["rdToolBarYn"] = "Y" ;	//툴바여부
		args["rdZoomRatio"] = "100";//확대축소비율

		args["rdSaveYn"] 	= "Y" ;//기능컨트롤_저장
		args["rdPrintYn"] 	= "Y" ;//기능컨트롤_인쇄
		args["rdExcelYn"] 	= "Y" ;//기능컨트롤_엑셀
		args["rdWordYn"] 	= "Y" ;//기능컨트롤_워드
		args["rdPptYn"] 	= "Y" ;//기능컨트롤_파워포인트
		args["rdHwpYn"] 	= "Y" ;//기능컨트롤_한글
		args["rdPdfYn"] 	= "Y" ;//기능컨트롤_PDF

		gPRow = "";
		pGubun = "rdPopup";

		openPopup(url,args,w,h);//알디출력을 위한 팝업창
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
	<!-- 호출 팝업 넘겨줄 키 값 -->
	<input type="hidden" id="exceptionSdateValue" name="exceptionSdateValue" value=""/>
	<input type="hidden" id="exceptionEdateValue" name="exceptionEdateValue" value=""/>
	</form>
		<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">평가결과피드백</li>
			<li class="btn">
				<a href="javascript:doAction1('Down2Excel')" class="btn outline_gray authR">다운로드</a>
				<a href="javascript:doAction1('Search')" class="btn dark">조회</a>
				<!--<a href="javascript:doAction1('Print')"  class="basic authR">출력</a>-->
				<!-- 결제문서 아니라고해서 주석.
				<a href="javascript:doAction1('Search')" class="button">이의신청</a>
				-->
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>