<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript" src="/common/js/execAppmt.js"></script>
<script src="/assets/js/utility-script.js?ver=7"></script>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";
	var POST_ITEMS = [];

	$(function() {
		if("${pictureHdn}" == "Y"){
			$("#searchPhotoYn").attr('checked', true);
		}else{
			$("#searchPhotoYn").attr('checked', false);
		}	

		$('#btnHide').hide();
		//$("#searchPhotoYn").attr('checked', 'checked');
		
		// 발령항목 조회
		POST_ITEMS = ajaxCall("${ctx}/AppmtItemMapMgr.do?cmd=getAppmtItemMapMgrList","searchUseYn=Y",false).DATA;
		
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:msHeaderOnly,Page:22,FrozenCol:7};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
   			{Header:"No|No",						Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"상태|상태",      					Type:"${sSttTy}",	Hidden:0,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus", Sort:0 },
			{Header:"신청순번|신청순번",				Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"applSeq",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			
			{Header:"세부\n내역|세부\n내역",				Type:"Image",	Hidden:0,	Width:45,	Align:"Center",	ColMerge:0,	SaveName:"ibsImage",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"사직원\n출력|사직원\n출력",			Type:"CheckBox",	Hidden:0,  Width:50,   Align:"Center",	ColMerge:1,	SaveName:"selectcheck",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:22, TrueValue:"Y", FalseValue:"N" },
			{Header:"<sht:txt mid='photoV1' mdef='사진|사진'/>",							Type:"Image",	Hidden:0,  	MinWidth:55, 		Align:"Center", ColMerge:0,		SaveName:"photo",			UpdateEdit:0, ImgMinWidth:50, ImgHeight:60 },
			{Header:"사번|사번",						Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"성명|성명",						Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },			
			{Header:"소속|소속",						Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직책코드|직책코드",													Type:"Text",	Hidden:1,	MinWidth:60,	Align:"Center",	ColMerge:0,	SaveName:"jikchakCd",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"직책|직책",															Type:"Text",	Hidden:0,	MinWidth:60,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직위코드|직위코드",													Type:"Text",	Hidden:1,	MinWidth:60,	Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"직위|직위",															Type:"Text",	Hidden:Number("${jwHdn}"),	MinWidth:60,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직급코드|직급코드",													Type:"Text",	Hidden:1,	MinWidth:60,	Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"직급|직급",															Type:"Text",	Hidden:Number("${jgHdn}"),	MinWidth:60,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"신청일자|신청일자",				Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"신청상태|신청상태",				Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applStatusCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },			
			{Header:"최종출근일|최종출근일",		Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"finWorkYmd",	KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"퇴직희망일|퇴직희망일",						Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"retSchYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"퇴직일|퇴직일",						Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"retYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:10 },
			{Header:"퇴직\n설문|퇴직\n설문",				Type:"Image",	Hidden:Number("${retSurveyHdn}"),	Width:45,	Align:"Center",	ColMerge:0,	SaveName:"surveyImage",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },			
			{Header:"비밀\n서약서|비밀\n서약서",			Type:"Image",	Hidden:Number("${retAgreeHdn}"),	Width:45,	Align:"Center",	ColMerge:0,	SaveName:"agreeImage",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"퇴직사유|퇴직사유",				Type:"Combo",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"retReasonCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },			
			
			{Header:"면담\n상태|면담\n상태",				Type:"Combo",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"retInterviewSeq",KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"퇴직면담|1차",					Type:"Text",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"convName1",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"퇴직면담|2차",					Type:"Popup",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"convName2",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"퇴직면담|2차(사번)",				Type:"Text",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"convSabun2",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			
			{Header:"품의번호|품의번호",				Type:"Text",	Hidden:1,	Width:100,	Align:"Center", ColMerge:0,	SaveName:"processNo",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },			
			{Header:"선택|선택",						Type:"CheckBox",Hidden:1,	Width:40,	Align:"Center", ColMerge:0,	SaveName:"ibsCheck",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1 },
			
			{Header:"인수인계서|등록\n여부",				Type:"CheckBox",	Hidden:1,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"takeoverFileYn",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N"},
			{Header:"인수인계서|첨부파일",				Type:"Html",		Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"btnFile",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"첨부번호|첨부번호",				Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"takeoverFileSeq",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			
			{Header:"대상자사번|대상자사번",				Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"applSabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"신청자사번|신청자사번",				Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"applInSabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		
			{Header:"발령\n연계처리|발령\n연계처리",	Type:"CheckBox",	Hidden:0,	Width:69,	Align:"Center",	ColMerge:0,	SaveName:"prePostYn",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"발령\n연계처리|발령\n연계처리",	Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"prePostYn2",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1},
			{Header:"발령|발령",						Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ordTypeCd",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"발령상세|발령상세",				Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ordDetailCd",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"발령일|발령일",					Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ordYmd",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"발령seq|발령seq",					Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"applySeq",    KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"발령확정\n여부|발령확정\n여부",	Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"ordYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"재직상태|재직상태",				Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"statusCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"전자서명|비밀유지",				Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"signFileSeq",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"전자서명|사직원",				Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"signFileSeq1",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"발령확정\n여부|발령확정\n여부",	Type:"Image",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"ibsImage4",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"rk",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"rk",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"rk2",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"rk2",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0},
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		initdata1 = {};
		initdata1.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",			Type:"${sDelTy}",	Hidden:1,	Width:45,	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"상태",			Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"면담자",			Type:"Text",		Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"adviserName",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },			
			{Header:"면담일",			Type:"Date",		Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"ccrYmd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:"차수",			Type:"Combo",		Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"retInterviewSeq",KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			
			//hiddenFilde
			{Header:"사번",			Type:"Text",		Hidden:1,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"면담자(사번)",	Type:"Text",		Hidden:1,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"adviser",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"구분",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"ccrCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"일련번호",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"seq",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"면담내용",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"memo",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000 }
		]; IBS_InitSheet(sheet2, initdata1);sheet2.SetEditable(true);sheet2.SetVisible(true);sheet2.SetCountPosition(4);


		sheet1.SetCountPosition(0);
			
		sheet1.SetImageList(0,"/common/images/icon/icon_x.png");
		sheet1.SetImageList(1,"/common/images/icon/icon_o.png");
		sheet1.SetImageList(3,"/common/images/icon/icon_popup.png");

		sheet1.SetDataLinkMouse("ibsImage", 1);
		sheet1.SetDataLinkMouse("agreeImage", 1);
		sheet1.SetDataLinkMouse("surveyImage", 1);
		sheet1.SetDataLinkMouse("retInterviewImage", 1);

		var applStatusCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getApplStatusCdList&applStatusNotCd=11,"), "전체");
		sheet1.SetColProperty("applStatusCd", 	{ComboText:applStatusCd[0], ComboCode:applStatusCd[1]} );
		$("#applStatusCd").html(applStatusCd[2]);

		getCommonCodeList();

		//var TypeCd 		= convCode( ajaxCall("${ctx}/GetDataList.do?cmd=getTimeOffStdMgrTypeCodeList","ordType='20','30'",false).DATA, "");
		var TypeCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdTypeList&inOrdType=60,",false).codeList, "");
		
		sheet1.SetColProperty("ordTypeCd", 	{ComboText:TypeCd[0], 	ComboCode:TypeCd[1]} );
		
		//발령상세
		//var ordDetailCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdDetailCdManagerList&ordType=60",false).codeList, "");
		//sheet1.SetColProperty("ordDetailCd",       {ComboText:"|"+ordDetailCd[0], ComboCode:"|"+ordDetailCd[1]} );

		$("#sYmd").datepicker2({startdate:"eYmd", onReturn: getCommonCodeList});
		$("#eYmd").datepicker2({enddate:"sYmd", onReturn: getCommonCodeList});
		
		$("#name,#sYmd,#eYmd,#orgNm").bind("keyup",function(event){
			if( event.keyCode == 13){ 
				doAction1("Search"); 
				$(this).focus(); 
			}
		});
		
		$("#applStatusCd,#searchRetInterviewSeq").bind("change",function(event){
			doAction1("Search"); 
			$(this).focus();
		});
		
		$("#searchPhotoYn").click(function() {
			doAction1("Search");
		});

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	function getCommonCodeList() {
		let baseSYmd = $("#sYmd").val();
		let baseEYmd = $("#eYmd").val();

		var retReasonCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&note1=Y","H40100", baseSYmd, baseEYmd), " ");
		sheet1.SetColProperty("retReasonCd", 	{ComboText:retReasonCd[0], ComboCode:retReasonCd[1]} );

		var retInterviewCd    =  codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H90922", baseSYmd, baseEYmd);
		var retInterviewCdSheet    = convCode( retInterviewCd , " ");
		sheet1.SetColProperty("retInterviewSeq",{ComboText:retInterviewCdSheet[0], ComboCode:retInterviewCdSheet[1]} );
		sheet2.SetColProperty("retInterviewSeq",{ComboText:retInterviewCdSheet[0], ComboCode:retInterviewCdSheet[1]} );
		retInterviewCd     = stfConvCode(retInterviewCd, "전체");
		$("#retInterviewSeq").html(retInterviewCdSheet[2]);
		$("#searchRetInterviewSeq").html(retInterviewCd[2]);

		var ccrCd 		   = stfConvCode( codeList("/CommonCode.do?cmd=getCommonCodeList","H90009", baseSYmd, baseEYmd), "");
		sheet2.SetColProperty("ccrCd", 			{ComboText:ccrCd[0], ComboCode:ccrCd[1]} );
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":

			/*
			if($("#sYmd").val() == "") {
				alert("신청일자 시작일을 입력하여 주십시오.");
				$("#sYmd").focus();
				return;
			}
			if($("#eYmd").val() == "") {
				alert("신청일자 종료일을 입력하여 주십시오.");
				$("#eYmd").focus();
				return;
			}
			*/

			var param = "sYmd="+$("#sYmd").val().replace(/-/gi,"")
						+"&eYmd="+$("#eYmd").val().replace(/-/gi,"")
						+"&orgCd="+$("#orgCd").val()
						+"&orgNm="+$("#orgNm").val()
						+"&applStatusCd="+$("#applStatusCd").val()
						+"&searchRetInterviewSeq="+$("#searchRetInterviewSeq").val()
						+"&name="+$("#name").val();
			
			clearAllData();
			
			if($("#searchPhotoYn").is(":checked") == true){
				sheet1.SetDataRowHeight(60);
				sheet1.SetColHidden("photo", 0);
			}else{
				sheet1.SetAutoRowHeight(0);
				sheet1.SetDataRowHeight(24);
				sheet1.SetColHidden("photo", 1);
			}

			sheet1.DoSearch( "${ctx}/RetireApr.do?cmd=getRetireAprList",param );
			break;
		case "Save":
			IBS_SaveName(document.sheetForm,sheet1);
			sheet1.DoSave( "${ctx}/RetireApr.do?cmd=updateRetireApr", $("#sheetForm").serialize(),-1);
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
		}
	}
	
	//Detail Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":			
			var row = sheet1.GetSelectRow();
			var sabun = sheet1.GetCellValue(row,"sabun");
			var applSeq = sheet1.GetCellValue(row,"applSeq");
			sheet2.DoSearch( "${ctx}/RetireInterview.do?cmd=getRetireRecodeList","sabun="+sabun+"&schApplSeq="+applSeq);
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			
			for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){

				if(sheet1.GetCellValue(i, "ordTypeCd") !=""){
					var lOrdReasonCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdDetailCdManagerList&ordTypeCd="+ sheet1.GetCellValue(i, "ordTypeCd"),false).codeList, " ");	//발령상세종류
					sheet1.InitCellProperty(i,"ordDetailCd", {Type:"Combo", ComboCode:"|"+lOrdReasonCd[1], ComboText:"|"+lOrdReasonCd[0]});
				}
			}
			

			sheetResize();

			if(sheet1.RowCount() > 0) {
				for(var i = 2; i < sheet1.RowCount()+2; i++) {
					/*
					if(sheet1.GetCellValue(i, "applStatusCd") != '99' || sheet1.GetCellValue(i, "ordYn") != "N") {
						sheet1.SetRowEditable(i,false);
					} else {
						sheet1.SetRowEditable(i,true);
					}
					*/
					
					if(sheet1.GetCellValue(i,"prePostYn") == "Y") {
						sheet1.SetRowEditable(i, 0);
					}
					
					//sheet1.SetCellValue(i, "btnPrt", '<a class="basic" onclick="rdPopup('+i+')">출력</a>');
					//sheet1.SetCellValue(i, "sStatus","R");
					
					//인수인계파일첨부
					if(sheet1.GetCellValue(i,"takeoverFileSeq") == ''){
						sheet1.SetCellValue(i, "btnFile", '<btn:a css="basic" mid="attachFile" mdef="첨부"/>');
						sheet1.SetCellValue(i, "sStatus", 'R');					
					}else{
						sheet1.SetCellValue(i, "btnFile", '<btn:a css="basic" mid="down2excel" mdef="다운로드"/>');
						sheet1.SetCellValue(i, "sStatus", 'R');
					}
				}
			}
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

	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
		    if( sheet1.ColSaveName(Col) == "ibsImage" && Row >= sheet1.HeaderRows()) {

		    	var applSabun = sheet1.GetCellValue(Row,"applSabun");
	    		var applSeq = sheet1.GetCellValue(Row,"applSeq");
	    		var applInSabun = sheet1.GetCellValue(Row,"applInSabun");
	    		var applYmd = sheet1.GetCellValue(Row,"applYmd");

	    		showApplPopup("R",applSeq,applSabun,applInSabun,applYmd);

		    } else if( sheet1.ColSaveName(Col) == "surveyImage" && Row >= sheet1.HeaderRows()) {
		    	//설문지
		    	if(!isPopup()) {return;}
		    	
		    	<%--var url    = "${ctx}/RetireAppDet.do?cmd=viewRetireSurveyPopup&authPg=R";--%>
		        <%--var args    = new Array();--%>
		        
				<%--var	sabun 	= sheet1.GetCellValue(Row,"sabun");--%>
				<%--var	reqDate = sheet1.GetCellValue(Row,"applYmd");--%>
				<%--var	applSeq = sheet1.GetCellValue(Row,"applSeq");--%>

		        <%--args["sabun"]    = sabun;--%>
		        <%--args["reqDate"]  = reqDate;--%>
		        <%--args["applSeq"]  = applSeq;--%>
				
		        <%--openPopup(url, args, "820","700");--%>
				var url    = "${ctx}/RetireApp.do?cmd=viewRetireSurveyLayer&authPg=R";
				var w = 835, h = 700;
				var title = '퇴직설문지';
				var sabun, reqDate, applSeq;
				sabun 	= sheet1.GetCellValue(Row,"sabun");
				reqDate = sheet1.GetCellValue(Row,"applYmd");
				applSeq = sheet1.GetCellValue(Row,"applSeq");

				var p = {	sabun, reqDate, applSeq  };
				var layer = new window.top.document.LayerModal({
					id: 'retireSurveyLayer',
					url,
					parameters: p,
					width: w,
					height: h,
					title: title,
				});
				layer.show();

		    } else if(sheet1.ColSaveName(Col) == "btnFile" && Row >= sheet1.HeaderRows()){
		    	//인수인계서 파일첨부
				var param = [];
				param["fileSeq"] = sheet1.GetCellValue(Row,"takeoverFileSeq");
				if(sheet1.GetCellValue(Row,"btnFile") != ""){
					if(!isPopup()) {return;}

					gPRow = Row;
					pGubun = "fileMgrPopup1";

					var authPgTemp="${authPg}";
					var rv = openPopup("/fileuploadJFileUpload.do?cmd=fileMgrPopup&authPg="+authPgTemp+"&uploadType=assurance", param, "1024","400");
				}
			} else if( sheet1.ColSaveName(Col) == "agreeImage" && Row >= sheet1.HeaderRows()) {
				//비밀유지서약서
				if(!isPopup()) {return;}
				const data = {
					rk : sheet1.GetCellValue(Row, 'rk'),
					type : 1
				};

				window.top.showRdLayer('/RetireApp.do?cmd=getEncryptRd', data, null,"비밀유지서약서");
			<%--	var w 		= 800;--%>
			<%--	var h 		= 600;--%>
			<%--	var url 	= "${ctx}/RdPopup.do";--%>
			<%--	var args 	= new Array();--%>

			<%--	var	sabun = sheet1.GetCellValue(Row,"sabun");--%>
			<%--	var	reqDate = sheet1.GetCellValue(Row,"applYmd");--%>
			<%--	var	applSeq = sheet1.GetCellValue(Row,"applSeq");--%>
			<%--	var secretSeq =  sheet1.GetCellValue(Row,"signFileSeq");  //비밀유지 서약--%>

			<%--	var rdMrd = "";--%>
			<%--	var rdTitle = "";--%>
			<%--	var rdParam = "";--%>

			<%--	//rdMrd = "/hrm/retire/RetireAgree.mrd";--%>
			<%--	rdMrd = "/hrm/retire/RetireSecret.mrd";--%>
			<%--	rdTitle = "비밀유지서약서";--%>
			<%--	rdParam = "[${ssnEnterCd}]"--%>
			<%--			+ "["+sabun+"]"--%>
			<%--			+ "["+reqDate+"]"--%>
			<%--			+ "[${baseURL}]"--%>
			<%--			+ "["+secretSeq+"]";--%>
			<%--	--%>


			<%--	var imgPath = " " ;--%>
			<%--	args["rdTitle"] = rdTitle ;	//rd Popup제목--%>
			<%--	args["rdMrd"] =  rdMrd;		//( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명--%>
			<%--	args["rdParam"] = rdParam;	//rd파라매터--%>
			<%--	args["rdParamGubun"] = "rp";//파라매터구분(rp/rv)--%>
			<%--	args["rdToolBarYn"] = "Y" ;	//툴바여부--%>
			<%--	args["rdZoomRatio"] = "100";//확대축소비율--%>

			<%--	args["rdSaveYn"] 	= "Y" ;//기능컨트롤_저장--%>
			<%--	args["rdPrintYn"] 	= "Y" ;//기능컨트롤_인쇄--%>
			<%--	args["rdExcelYn"] 	= "Y" ;//기능컨트롤_엑셀--%>
			<%--	args["rdWordYn"] 	= "Y" ;//기능컨트롤_워드--%>
			<%--	args["rdPptYn"] 	= "Y" ;//기능컨트롤_파워포인트--%>
			<%--	args["rdHwpYn"] 	= "Y" ;//기능컨트롤_한글--%>
			<%--	args["rdPdfYn"] 	= "Y" ;//기능컨트롤_PDF--%>

			<%--	openPopup(url,args,w,h);//알디출력을 위한 팝업창--%>

		    <%--} else if( sheet1.ColSaveName(Col) == "surveyImage" && Row >= sheet1.HeaderRows()) {--%>
		    <%--	//설문지--%>
		    <%--	if(!isPopup()) {return;}--%>
		    <%--	var auth = "R";--%>
		    <%--	if(sheet1.GetCellValue(Row, "applStatusCd") == "11") {--%>
		    <%--		//신청 팝업--%>
		    <%--		auth = "A";--%>
		    <%--	} else {--%>
		    <%--		//결재팝업--%>
		    <%--		auth = "R";--%>
		    <%--	}--%>

		    <%--	var url    = "${ctx}/RetireAppDet.do?cmd=viewRetireSurveyPopup&authPg=" + auth;--%>
		    <%--    var args    = new Array();--%>
		    <%--    --%>
			<%--	var	sabun 	= sheet1.GetCellValue(Row,"sabun");--%>
			<%--	var	reqDate = sheet1.GetCellValue(Row,"applYmd");--%>
			<%--	var	applSeq = sheet1.GetCellValue(Row,"applSeq");--%>

		    <%--    args["sabun"]    = sabun;--%>
		    <%--    args["reqDate"]  = reqDate;--%>
		    <%--    args["applSeq"]  = applSeq;--%>
			<%--	--%>
		    <%--    openPopup(url, args, "820","900");--%>
		    }else if (sheet1.ColSaveName(Col) == "selectcheck"  ){
		    	sheet1.SetCellValue(Row, "sStatus","R");
		    }
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}
	
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		//면담내용
		if(OldRow != NewRow) {
//			$(".detilaDiv").show();
			doAction2("Search");
		}
	}

	// 팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
			if(sheet1.ColSaveName(Col) == "processNo") {
				if(!isPopup()) {return;}

				gPRow = Row;
				pGubun = "viewAppmtConfirmPopup";
	            openPopup("/AppmtConfirmPopup.do?cmd=viewAppmtConfirmPopup&authPg=R", "", "740","520");
			} else if (sheet1.ColSaveName(Col) == "convName2") {
				// 사원검색 팝입
				empSearchPopup(Row, Col);
			}
		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}
	
	function sheet1_OnChange(Row, Col, Value, OldValue, RaiseFlag) {

		try{

			var sSaveName = sheet1.ColSaveName(Col);

			//퇴직일 변경 시 발령일 변경
			if(sSaveName == "retYmd"){
				sheet1.SetCellValue(Row, "ordYmd", Value, 0);
			}
			
			if( sheet1.ColSaveName(Col) == "ordTypeCd" ) {
				var lOrdReasonCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdDetailCdManagerList&ordTypeCd="+ sheet1.GetCellValue(Row, "ordTypeCd"),false).codeList, " ");	//발령상세종류

				sheet1.InitCellProperty(Row,"ordDetailCd", {Type:"Combo", ComboCode:"|"+lOrdReasonCd[1], ComboText:"|"+lOrdReasonCd[0]});
			}
			

		}catch(ex){alert("OnChange Event Error : " + ex);}

	}
	
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	
	function sheet2_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		if(sheet2.RowCount() > 0) {
			setTableData();
		} else {
			$("#retInterviewSeq").val("");
			$("#ccrYmd").val("");
			$("#memo").val("");
		}
	}
	
	//테이블 영역에 데이터 셋팅
	function setTableData() {
		//읽기전용
		var row = sheet2.GetSelectRow();
		
		//차수,일자,내용,SEQ
		var retInterviewSeq = sheet2.GetCellValue(row,"retInterviewSeq");
		var ccrYmd 			= sheet2.GetCellValue(row,"ccrYmd");
		var memo 			= sheet2.GetCellValue(row,"memo");
		$("#retInterviewSeq").val(retInterviewSeq);
		$("#ccrYmd").val(formatDate(ccrYmd,"-"));
		$("#memo").val(memo);
		
		$("#retInterviewSeq").removeClass().addClass("disabled").attr("disabled","disabled");
		$("#ccrYmd").addClass("transparent").attr("readonly","readonly").removeClass("required");
		$("#memo").removeClass().addClass("w100p text transparent readonly").attr("readonly",true);
		
		$(".ui-datepicker-trigger", detailForm).hide();
	}
	
	//조회시 전체 데이터 초기화
	function clearAllData() {
		sheet1.RemoveAll();
		sheet2.RemoveAll();
		$("#retInterviewSeq").val("");
		$("#ccrYmd").val("");
		$("#memo").val("");
		$(".detilaDiv").hide();
		
	}
	
	// 사원검색 팝입
	function empSearchPopup(Row, Col) {
		if(!isPopup()) {return;}

		var w		= 840;
		var h		= 520;
		var url		= "/Popup.do?cmd=employeePopup";
		var args	= new Array();

		openPopup(url+"&authPg=R", args, w, h, function (rv){
			sheet1.SetCellValue(Row, "convSabun2", rv["sabun"]);
			sheet1.SetCellValue(Row, "convName2", rv["name"]);
		});
	}

	// 초기화
	function clearCode() {
		$('#orgNm').val("");
		//$('#orgCd').val("");
	}

	// 소속 팝업
	function showOrgPopup() {
		if(!isPopup()) {return;}

		pGubun = "orgBasicPopup";
        openPopup("/Popup.do?cmd=orgBasicPopup&authPg=R", "", "740","520");
	}

	//신청 팝업
	function showApplPopup(auth,seq,applSabun,applInSabun,applYmd) {
		if(!isPopup()) {return;}

		if(auth == "") {
			alert("권한을 입력하여 주십시오.");
			return;
		}

		var p = {
				searchApplCd: '99'
			  , searchApplSeq: seq
			  , adminYn: 'N'
			  , authPg: auth
			  , searchSabun: applInSabun
			  , searchApplSabun: applSabun
			  , searchApplYmd: applYmd 
			};
		var url ="/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
		var initFunc = 'initResultLayer';

		pGubun = "viewApprovalMgrResult";
		var approvalMgrLayer = new window.top.document.LayerModal({
			id: 'approvalMgrLayer',
			url: url,
			parameters: p,
			width: 1100,
			height: 815,
			title: '근태신청',
			trigger: [
				{
					name: 'approvalMgrLayerTrigger',
					callback: function(rv) {
						getReturnValue(rv);
					}
				}
			]
		});
		approvalMgrLayer.show();
		//window.top.openLayer(url, p, 800, 815, initFunc, getReturnValue);
	}

	// 품의 일괄적용
	function setProcessNo() {
		var processNo = $("#prcNo").val();

		if(processNo == "") {
			alert("품의번호를 선택하여 주십시오.");
		} else if(sheet1.RowCount() > 0 && sheet1.CheckedRows("ibsCheck") > 0) {
			var sRow = sheet1.FindCheckedRow("ibsCheck");
			var arrRow = sRow.split("|");

			for(var i = 0; i < arrRow.length; i++) {
				if(arrRow[i] != "") {
					sheet1.SetCellValue(arrRow[i],"processNo",processNo);
				}
			}
			alert("품의번호가 일괄적용 되었습니다.");
		} else {
			alert("체트된 행이 없거나 데이터가 없습니다.");
		}
	}

	function ordBatch(){

		if( sheet1.CheckedRows("prePostYn") == "0") {
			alert("<msg:txt mid='109724' mdef='선택된 자료가 없습니다.'/>");
			return;
		}

		var arrRow = sheet1.FindCheckedRow("prePostYn");
		var errRow = "";

		$(arrRow.split("|")).each(function(index,value){
			if(sheet1.GetCellValue(value,"applStatusCd") != 99) {
				errRow = value;
				return false;
			}
		});

		if(errRow != "") {
			errRow = Number(errRow) -1;
			alert(errRow+"행은 결재완료 상태가 아닙니다.\n발령연계처리는 결재완료 상태에서만 가능합니다.");
			return;
		};

		//if(!confirm("발령연계처리 하시겠습니까?")) {
		//return;
		//}
		//IBS_SaveName(document.sheetForm,sheet1);
		//sheet1.DoSave("${ctx}/TimeOffApr.do?cmd=saveTimeOffAprOrd", $("#sheetForm").serialize(),-1,0);
		
		IBS_SaveName(document.sheetForm,sheet1);
		//var paramStr = setAppmtParamSet(POST_ITEMS,sheet1,sheet1.FindStatusRow("U")+"".split(";"),$("#sendForm"));
		//sheet1.DoSave( "${ctx}/RecBasicInfoReg.do?cmd=saveRecBasicInfoRegNew", $("#sheetForm").serialize()+paramStr+"&ordGubun=E");
		sheet1.DoSave( "${ctx}/OrdBatch.do?", $("#sheetForm").serialize());
	}
	/**
	 * 출력 window open event
	 * 레포트 공통에 맞춘 개발 코드 템플릿
	 * by JSG
	 */
	function rdPopup(){
		if(!isPopup()) {return;}
		pGubun = "rdPopup";
		
		var applSeq = "";
		var rk = "";
		
		if(sheet1.RowCount() != 0){
	  		var w 		= 800;
			var h 		= 600;
			var url 	= "${ctx}/RdPopup.do";
			var args 	= new Array();
			// args의 Y/N 구분자는 없으면 N과 같음

			var rdMrd = "";
			var rdTitle = "";
			var rdParam = "";

			rdMrd = "hrm/retire/Retire_EB.mrd";
			rdTitle = "사직원";
			rdParam = "[${ssnEnterCd}]"
					+ "["+applSeq+"]"
					+ "["+applSeq+"]"
					+ "["+applSeq+"]"
					+ "[${baseURL}]";

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

			
			openPopup(url,args,w,h);//알디출력을 위한 팝업창
		}else{
			alert("출력할 대상이 없습니다. 조회 후 사용해주십시요.");
		}
	}

	function showRd(){
		var applSeq = "";
		var rk = "";
		if(sheet1.RowCount() != 0){

			var sRow = sheet1.FindCheckedRow("selectcheck");
			if( sRow && sRow != null && sRow != "" ) {
				$(sRow.split("|")).each(function(index,value){
					applSeq += ",('${ssnEnterCd}','" + sheet1.GetCellValue(value,"applSeq") + "')";
					rk += "," + sheet1.GetCellValue(value,"rk2");
				});
			}

			if( applSeq == "" ){
				alert("<msg:txt mid='109876' mdef='출력 대상자를 선택하세요'/>");
				return;
			}

			<%--let parameters = Utils.encase('${ssnEnterCd}');--%>
			<%--parameters += Utils.encase(applSeq);--%>
			<%--parameters += Utils.encase(applSeq);--%>
			<%--parameters += Utils.encase(applSeq);--%>
			<%--parameters += Utils.encase('${imageBaseUrl}');--%>

			//암호화 할 데이터 생성
		    /*
			const data = {
			    	rdMrd : '/hrm/retire/Retire_EB.mrd'
				, parameterType : 'rp'//rp 또는 rv
				, parameters : parameters
			};
			*/
			//window.top.showRdLayer(data);
			
			
            // const data = {
            // 		parameters : applSeq
            // };
			// window.top.showRdLayer('/RetireApr.do?cmd=getEncryptRd', data);

			if( rk == "" ){
				alert("<msg:txt mid='109876' mdef='출력 대상자를 선택하세요'/>");
				return;
			}

			const data = {
				rk : rk,
				type : 2
			};

			window.top.showRdLayer('/RetireApp.do?cmd=getEncryptRd', data, null, "사직원");

		}else{
			alert("출력할 대상이 없습니다. 조회 후 사용해주십시요.");
		}
	}

	//팝업 콜백 함수.
	function getReturnValue(rv) {
		if(pGubun == "viewAppmtConfirmPopup") {
            sheet1.SetCellValue(gPRow, "processNo", rv["processNo"] );
		} else if(pGubun == "orgBasicPopup") {
        	$("#orgCd").val(rv["orgCd"]);
        	$("#orgNm").val(rv["orgNm"]);
		} else if(pGubun == "viewApprovalMgrResult") {
        	doAction1("Search");
		} else if(pGubun == "fileMgrPopup1") {
			if(rv["fileCheck"] == "exist"){
				sheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid="down2excel" mdef="다운로드"/>');
				sheet1.SetCellValue(gPRow, "takeoverFileSeq", rv["fileSeq"]);
				sheet1.SetCellValue(gPRow, "takeoverFileYn", "Y");
				
			}else{
				sheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid="attachFile" mdef="첨부"/>');
				sheet1.SetCellValue(gPRow, "takeoverFileSeq", "");
				sheet1.SetCellValue(gPRow, "takeoverFileYn", "N");
			}
		}
	}

	//닫기 버튼 클릭시 Sheet Resize
	function detailDivHide() {
		$('.detilaDiv').hide();
		sheetResize();
	}
	function ShowDetail(){
		$('.detilaDiv').show();
		
		$('#btnShow').hide();
		$('#btnHide').show();
		sheetResize();
	}
	
	function HideDetail(){
		$('.detilaDiv').hide();
		$('#btnShow').show();
		$('#btnHide').hide();
	 
		sheetResize();
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
		<div class="sheet_search outer">
			<div>
			<table>
			<tr>
				<th>신청일자</th>
				<td>
					<input id="sYmd" name="sYmd" type="text" size="10" class="date2" value="<%//= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),-365)%>"/> ~
					<input id="eYmd" name="eYmd" type="text" size="10" class="date2" value="<%//=DateUtil.getCurrentTime("yyyy-MM-dd")%>"/>
				</td>
				<th><tit:txt mid='112999' mdef='결재상태'/></th>
				<td>
					<select id="applStatusCd" name="applStatusCd">
					</select>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='104279' mdef='소속'/></th>
				<td>
					<input id="orgNm" name="orgNm" type="text" class="text" style="" />					
					<input id="orgCd" name="orgCd" type="hidden" class="text" style="" readonly/>
					<!-- 
					<a href="# " class="button6"><img id="findOrg" src="/common/${theme}/images/btn_search2.gif"/></a>
					<a href="#" class="button7"><img id="clsOrg" src="/common/${theme}/images/icon_undo.gif"/></a>
					 -->
				</td>	
				<th>성명/사번</th>			
				<td>
					<input id="name" name="name" type="text" class="text" style=""/>
				</td>
				<th class="hide">면담상태</th>
				<td class="hide">
					<select id="searchRetInterviewSeq" name="searchRetInterviewSeq">
					</select>
				</td>
				<th><tit:txt mid='112988' mdef='사진포함여부 '/></th>
				<td>
					<input id="searchPhotoYn" name="searchPhotoYn" type="checkbox"  class="checkbox" />
				</td>
				<td>
					<btn:a href="javascript:doAction1('Search');" css="btn dark" mid='search' mdef="조회"/>
				</td>
			</tr>
			</table>
			</div>
		</div>
	</form>
	<table style="width:100%;table-layout: fixed;">
		<colgroup>
			<col width="" />
			<col class="detilaDiv" width="560px" style="display:none;" />
		</colgroup> 
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li class="txt">퇴직신청현황</li>
						<li class="btn">
<%--							<btn:a href="javascript:rdPopup()"					css="basic authA" mid='printV1' mdef="출력"/>--%>
<%--
							품의번호 <input id="prcNo" name="prcNo" type="text" class="text w100" />
							<btn:a href="javascript:setProcessNo();" css="basic authA" mid='111689' mdef="품의일괄적용"/>
--%>
							<btn:a href="javascript:doAction1('Down2Excel');" css="btn outline-gray authR" mid='down2excel' mdef="다운로드"/>
							<btn:a href="javascript:showRd()"					css="btn outline-gray authA" mid='printV1' mdef="출력"/>
							<btn:a href="javascript:ShowDetail();" css="btn soft" mid='down2excel' mdef="면담내역 열기" id="btnShow" />
							<btn:a href="javascript:HideDetail();" css="btn soft authR" mid='down2excel' mdef="면담내역 닫기" id="btnHide"/>
							<btn:a href="javascript:doAction1('Save')" css="btn soft" mid='save' mdef="저장"/>
							<btn:a href="javascript:ordBatch()" css="btn filled" mid='110765' mdef="발령연계처리"/>
						</li>
					</ul>
					</div>
				</div>
					<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script> 
			</td>
			<td class="detilaDiv" style="padding:10px;vertical-align: top;display: none;">
				<div style="position:absolute;top:104px;right:0px;bottom:0;width:540px;border:1px solid #e3e3e3;padding:0;">
					<div class="popup_title">
					<ul>
						<li>퇴직면담</li> 
						<li class="close" onclick="javascript:HideDetail();"><i class="mdi-ico">close</i></li>
					</ul>
					</div>
			
					<div class="sheet_title">
					<ul>
						<li class="txt2"></li>
					</ul>
					</div>
					
					<script type="text/javascript"> createIBSheet("sheet2", "100%", "40%"); </script>
					
					<div>
						<form id="detailForm" name="detailForm" >
							<input type="hidden" id="interviewSeq" name="interviewSeq"/>
							<input type="hidden" id="ccrCd" name="ccrCd" value="90"/>
							<table class="table">  
							<colgroup>
								<col width="80px" />
								<col width="" />
							</colgroup>
							<tr>
								<th>면담차수</th>
								<td>
									<select id="retInterviewSeq" name="retInterviewSeq" class="required" disabled></select>
								</td>									
							</tr>
							<tr>
								<th>면담일자</th>
								<td colspan="3"><input type="text" id="ccrYmd" name="ccrYmd" class="date2 readonly" readonly="readonly" ></td>
							</tr>
							<tr>
								<th>면담내용</th>
								<td>
									<textarea id="memo" name="memo" rows="3" cols="" class="w100p ${textCss} readonly" readonly="readonly"></textarea>
								</td>
							</tr>
							</table>
						</form>	
					</div>
				</div>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
