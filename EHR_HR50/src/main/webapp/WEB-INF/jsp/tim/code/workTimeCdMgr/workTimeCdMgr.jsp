<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>근무시간코드설정</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<!-- ColorPicker Plugin-->
<link href="/common/plugin/ColorPicker/evol-colorpicker.css" rel="stylesheet" />
<script src="/common/js/ui/1.12.1/jquery-ui.min.js" type="text/javascript" charset="utf-8"></script>
<script src="/common/plugin/ColorPicker/evol-colorpicker.js" type="text/javascript"></script>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {
		//TAB
		$("#tabs").tabs();
		$("#tabsIndex").val('0');

		initTabsLine(); //탭 하단 라인 추가
		

		//ColorPicker
	    init_ColorPicker(function(evt, color){
			if(color){
				sheet1.SetCellValue(gPRow, "rgbColor", color);
			}
		});
		

        $("#searchTimeCdNm, #searchTimeNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

        $("#searchGntGubunCd, #searchGntCd").bind("change",function(event){
			doAction3("Search");
		});

		$("#chkDetail").on("change", function() {
			// 상세 체크 상태에 따라 하단 탭 숨김처리
			if ($(this).is(":checked")) {
				const wrpH = document.querySelector(".wrapper").offsetHeight;
				const inoutH = Array.from(document.querySelectorAll(".outer, .inner")).reduce((acc, cur) => acc += cur.offsetHeight, 0);
				$("#detailArea").show();
				const detailAreaH = document.querySelector("#detailArea").offsetHeight;
				sheet1.SetSheetHeight(wrpH - inoutH - detailAreaH);
			} else {
				$("#detailArea").hide();
				const wrpH = document.querySelector(".wrapper").offsetHeight;
				const inoutH = Array.from(document.querySelectorAll(".outer, .inner")).reduce((acc, cur) => acc += cur.offsetHeight, 0);
				sheet1.SetSheetHeight(wrpH - inoutH);
			}
		})


        init_sheet1();
        init_sheet2();
        init_sheet3();


		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	// sheet1 근무시간기준관리
	function init_sheet1(){

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"\n삭제",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"상태",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

   			{Header:"근무시간\n코드",		Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"timeCd",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1 },
			{Header:"근무시간명",			Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"timeNm",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1 },
			{Header:"약어",				Type:"Text",		Hidden:0,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"shortTerm",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1 },
			{Header:"근무\n기준일",		Type:"Combo",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"workdayStd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1 },
			{Header:"근무\n시작시간",		Type:"Date",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"workShm",			KeyField:1,	Format:"Hm",	PointCount:0,	UpdateEdit:1,	InsertEdit:1 },
			{Header:"근무\n종료시간",		Type:"Date",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"workEhm",			KeyField:1,	Format:"Hm",	PointCount:0,	UpdateEdit:1,	InsertEdit:1 },
			{Header:"오전반차\n기준시간",	Type:"Date",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"halfHoliday1",	KeyField:1,	Format:"Hm",	PointCount:0,	UpdateEdit:1,	InsertEdit:1 },
			{Header:"오후반차\n기준시간",	Type:"Date",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"halfHoliday2",	KeyField:1,	Format:"Hm",	PointCount:0,	UpdateEdit:1,	InsertEdit:1 },
			{Header:"근무인정\n시작시간",	Type:"Date",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"beginShm",		KeyField:1,	Format:"Hm",	PointCount:0,	UpdateEdit:1,	InsertEdit:1 },
			{Header:"휴일\n구분",			Type:"CheckBox",	Hidden:0,	Width:55,	Align:"Center",	ColMerge:0,	SaveName:"workYn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"지각\n판정",			Type:"CheckBox",	Hidden:0,	Width:55,	Align:"Center",	ColMerge:0,	SaveName:"lateCheckYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"조퇴\n판정",			Type:"CheckBox",	Hidden:0,	Width:55,	Align:"Center",	ColMerge:0,	SaveName:"leaveCheckYn",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"주야\n여부",			Type:"CheckBox",	Hidden:1,	Width:55,	Align:"Center",	ColMerge:0,	SaveName:"nightYn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"결근\n판정",			Type:"CheckBox",	Hidden:1,	Width:55,	Align:"Center",	ColMerge:0,	SaveName:"absenceYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"결근\근태코드",		Type:"Combo",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"absenceCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1 },
			{Header:"공휴시\n근무시간",		Type:"Combo",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"holTimeCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1 },
			{Header:"공휴시\n인정시간",		Type:"Float",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"holTimeHour",		KeyField:0,	Format:"",		PointCount:1,	UpdateEdit:1,	InsertEdit:1 },
			{Header:"출근시\n근무시간",		Type:"Combo",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"workTimeCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1 },
			{Header:"연장근무\n신청필요",	Type:"CheckBox",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"applyYn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"순서",				Type:"Text",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"seq",				KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1 },
			{Header:"사용\n여부",			Type:"CheckBox",	Hidden:0,	Width:55,	Align:"Center",	ColMerge:0,	SaveName:"useYn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"Color\nRGB",		Type:"Text",		Hidden:0,	Width:60,	Align:"Left",	ColMerge:0,	SaveName:"rgbColor",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1 },

			//Hidden
			{Header:"Hidden", Type:"Text", Hidden:1, SaveName:"workteamCnt"},
			{Header:"Hidden", Type:"Text", Hidden:1, SaveName:"ioCnt"},
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		//Format이 “Hms”, “Hm” 인 경우 셀의 값이 공백인 상태에서 편집을 처음 시작하고자 할때 기본적으로 시스템 현재시간을 표시한다.
		sheet1.SetUseDefaultTime(0); //현재 시간을 표시하지 않도록 설정

		//무단결근
		var absenceCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getCpnGntCdList"), "<tit:txt mid='2017082900840' mdef='해당없음'/>");
		sheet1.SetColProperty("absenceCd", 	{ComboText:"|"+absenceCdList[0], ComboCode:"|"+absenceCdList[1]} );

		//근무기준일
		sheet1.SetColProperty("workdayStd",	{ComboText:"<tit:txt mid='2017082900841' mdef='당일'/>|<tit:txt mid='2017082900842' mdef='전일'/>", ComboCode:"0|-1"} );


	}


	// sheet2 근무시간 상세
	function init_sheet2(){
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo'           mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"\n<sht:txt mid='sDelete'     mdef='삭제'/>",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='statusCd'      mdef='상태'/>",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='seqV2'         mdef='순서'/>",				Type:"Int",			Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"seq",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1 },
			{Header:"<sht:txt mid='workCd'        mdef='근무코드'/>",			Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"workCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1 },
			{Header:"<sht:txt mid='reqSHm'        mdef='시작시간'/>",			Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"shm",		KeyField:0,	Format:"Hm",PointCount:0,	UpdateEdit:1,	InsertEdit:1, EditLen:5 },
			{Header:"<sht:txt mid='reqEHm'        mdef='종료시간'/>",			Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"ehm",		KeyField:0,	Format:"Hm",PointCount:0,	UpdateEdit:1,	InsertEdit:1, EditLen:5 },
			{Header:"<sht:txt mid='2017082900846' mdef='최초인정\n시간(분)'/>",	Type:"Int",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"stdMin",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1 },
			{Header:"<sht:txt mid='2017082900847' mdef='인정단위\n(분)'/>",	Type:"Int",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"unit",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1 },
			{Header:"<sht:txt mid='2017082900839' mdef='승인필요\n여부'/>",		Type:"CheckBox",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applyYn",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1, TrueValue:"Y", FalseValue:"N" },

			//Hidden
			{Header:"Hidden", Type:"Text", Hidden:1, SaveName:"timeCd"},

		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(0);
		sheet2.SetFocusAfterProcess(0); //조회 후 포커스를 두지 않음
		sheet2.SetUseDefaultTime(0); //디폴트 시간 입력 여부

		//근무코드
		var workCdList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getWorkCdList", false).codeList, "");
		sheet2.SetColProperty("workCd", 	{ComboText:workCdList[0], ComboCode:workCdList[1]} );
		
	}

	// sheet3 예외인정근무시간
	function init_sheet3(){
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No|No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"상태|상태",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"근태명|근태명",				Type:"Combo",	Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"gntCd",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 },
			{Header:"근태종류|근태종류",			Type:"Combo",	Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"gntGubunCd",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 },
			{Header:"기본설정|적용시간",			Type:"Float",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"dfStdApplyHour",	KeyField:0,	Format:"",	PointCount:1,	UpdateEdit:0,	InsertEdit:0 },
			{Header:"기본설정|근무코드",			Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"dfWorkCd",		KeyField:0,	Format:"",  PointCount:0,	UpdateEdit:0,	InsertEdit:0 },
			{Header:"예외설정|적용시간",			Type:"Float",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"stdApplyHour",	KeyField:0,	Format:"",  PointCount:1,	UpdateEdit:1,	InsertEdit:1 },
			{Header:"예외설정|근무코드",			Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"workCd",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1 },

			//Hidden
			{Header:"Hidden", Type:"Text", Hidden:1, SaveName:"timeCd"},

		]; IBS_InitSheet(sheet3, initdata);sheet3.SetEditable("${editable}");sheet3.SetVisible(true);sheet3.SetCountPosition(0);
		sheet3.SetFocusAfterProcess(0); //조회 후 포커스를 두지 않음

		//일근무스케쥴
		var workCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getWorkCdList"), "");
		sheet3.SetColProperty("dfWorkCd", 	{ComboText:"|"+workCdList[0], ComboCode:"|"+workCdList[1]} );
		sheet3.SetColProperty("workCd", 	{ComboText:"|"+workCdList[0], ComboCode:"|"+workCdList[1]} );

		var gntCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getCpnGntCdList"), "전체");
		var gntGubunCdList = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","T10003"), "전체");

		sheet3.SetColProperty("gntCd", 			{ComboText:"|"+gntCd[0], ComboCode:"|"+gntCd[1]} );
		sheet3.SetColProperty("gntGubunCd", 	{ComboText:"|"+gntGubunCdList[0], ComboCode:"|"+gntGubunCdList[1]} );

		//근태 종류
		$("#searchGntCd").html(gntCd[2]);
		$("#searchGntGubunCd").html(gntGubunCdList[2]);
		

	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var sXml = sheet1.GetSearchData("${ctx}/WorkTimeCdMgr.do?cmd=getWorkTimeCdMgrList", $("#sheet1Form").serialize() );
			sXml = replaceAll(sXml,"holTimeCdEdit", "holTimeCd#Edit");
			//sXml = replaceAll(sXml,"holTimeHourEdit", "holTimeHour#Edit");
			sXml = replaceAll(sXml,"absenceCdEdit", "absenceCd#Edit");
			sXml = replaceAll(sXml,"rgbColorBackColor", "rgbColor#BackColor");
			sXml = replaceAll(sXml,"holTimeCdComboText", "holTimeCd#ComboText");
			sXml = replaceAll(sXml,"holTimeCdComboCode", "holTimeCd#ComboCode");
			sXml = replaceAll(sXml,"workTimeCdComboText", "workTimeCd#ComboText");
			sXml = replaceAll(sXml,"workTimeCdComboCode", "workTimeCd#ComboCode");
			
			sheet1.LoadSearchData(sXml );

			break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			break;
		case "Save":
			if(!dupChk(sheet1,"timeCd|sdate", false, true)){break;}

			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/WorkTimeCdMgr.do?cmd=saveWorkTimeCdMgr", $("#sheet1Form").serialize());
			break;
		case "Copy":
			sheet1.DataCopy();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param);
			break;
		}
	}


	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			$("#searchTimeCd").val(sheet1.GetCellValue(sheet1.GetSelectRow(),"timeCd"));

			sheet2.DoSearch( "${ctx}/WorkTimeCdMgr.do?cmd=getDayWorkTimeMgrList", $("#sheet2Form").serialize() );
			

			//샘플 근무시간 콤보 
			var tempTimeCdList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getDayWorkTimeMgrTimeCombo", false).codeList, " ");
			$("#tempTimeCd").html(tempTimeCdList[2]);
			$("#tempTimeCd2").html(tempTimeCdList[2]);

			break;
		case "TimeCd":
			sheet2.DoSearch( "${ctx}/WorkTimeCdMgr.do?cmd=getDayWorkTimeMgrTempList", $("#sheet2Form").serialize() );

			break;
		case "Save":

			$("#searchTimeCd").val(sheet1.GetCellValue(sheet1.GetSelectRow(),"timeCd"));

			if(!dupChk(sheet2,"seq", false, true)){break;}

			if (!confirm("저장하시겠습니까?")) return;

			for(var i = sheet2.HeaderRows(); i < sheet2.RowCount()+sheet2.HeaderRows() ; i++) {
				if( sheet2.GetCellValue(i, "sStatus") == "R") sheet2.SetCellValue(i, "sStatus", "I");
			}

			IBS_SaveName(document.sheet2Form, sheet2);
			sheet2.DoSave( "${ctx}/WorkTimeCdMgr.do?cmd=saveDayWorkTimeMgr", $("#sheet2Form").serialize(), -1, 0);
			break;
		case "Insert":
			if(sheet1.GetCellValue(sheet1.GetSelectRow(),"timeCd") == "") {
				alert("<msg:txt mid='109497' mdef='근무시간코드가 설정되지 않았습니다.'/>");
				return;
			}
			var row = sheet2.DataInsert(-1);
			sheet2.SetCellValue(row,"timeCd",sheet1.GetCellValue(sheet1.GetSelectRow(),"timeCd"));
			break;
		case "Copy":
			sheet2.DataCopy();
			break;
		case "Clear":
			sheet2.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet2.Down2Excel(param);
			break;
		}
	}



	//Sheet3 Action
	function doAction3(sAction) {
		switch (sAction) {
		case "Search":
			$("#searchTimeCd").val(sheet1.GetCellValue(sheet1.GetSelectRow(),"timeCd"));
			$("#tempTimeCd2").val("");
			sheet3.DoSearch( "${ctx}/WorkTimeCdMgr.do?cmd=getWorkTimeCdMgrStdHourList", $("#sheet2Form").serialize()+"&"+$("#sheet3Form").serialize() );
			break;
        case "TimeCd":
            sheet3.DoSearch( "${ctx}/WorkTimeCdMgr.do?cmd=getWorkTimeCdMgrStdHourList", $("#sheet2Form").serialize()+"&"+$("#sheet3Form").serialize() );
            break;
		case "Save":
			$("#searchTimeCd").val(sheet1.GetCellValue(sheet1.GetSelectRow(),"timeCd"));

			IBS_SaveName(document.sheet2Form, sheet3);
			sheet3.DoSave( "${ctx}/WorkTimeCdMgr.do?cmd=saveWorkTimeCdMgrStdHour", $("#sheet2Form").serialize());
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet3);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet3.Down2Excel(param);
			break;
		}
	}
	//---------------------------------------------------------------------------------------------------------------
	// sheet1 Event
	//---------------------------------------------------------------------------------------------------------------
	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();

		} catch (ex) {
			alert("sheet1 OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			if( Code > -1 ){
				doAction1("Search");

			}
		} catch (ex) {
			alert("sheet1 OnSaveEnd Event Error " + ex);
		}
	}

	// 값 변경시 발생
	function sheet1_OnChange(Row, Col, Value) {
		// 공휴일여부
		if ( sheet1.ColSaveName(Col) == "workYn"){

			if (Value == "Y"){
				sheet1.SetCellValue(Row, "holTimeCd", "");
				sheet1.SetCellEditable(Row, "holTimeCd", false);

				// 공휴시\n인정근무시간 holTimeHour editable false
				sheet1.SetCellValue(Row, "holTimeHour", "");
				sheet1.SetCellEditable(Row, "holTimeHour", false);

			} else {
				sheet1.SetCellEditable(Row, "holTimeCd", true);

				// 공휴시\n인정근무시간 holTimeHour editable true
				sheet1.SetCellEditable(Row, "holTimeHour", true);
			}
		}else if ( sheet1.ColSaveName(Col) == "rgbColor"){
			sheet1.SetCellBackColor(Row, Col, Value);
			
		}else if ( sheet1.ColSaveName(Col) == "absenceYn"){
			
			if (Value == "Y"){
				sheet1.SetCellEditable(Row, "absenceCd", 1);
			}else{
				sheet1.SetCellValue(Row, "absenceCd", "");
				sheet1.SetCellEditable(Row, "absenceCd", 0);
			}
			
		}
		

	}

	// 셀 변경시 발생
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		try {

			if( $("#chkDetail").is(':checked') == false) return;

			if( NewRow < sheet1.HeaderRows() ) return;


			if(OldRow != NewRow) {
				doAction2("Search");
				doAction3("Search");
			}

		} catch (ex) {
			alert("sheet1 OnSelectCell Event Error " + ex);
		}
	}



	// 체크 되기 직전 발생.
	function sheet1_OnBeforeCheck(Row, Col) {
		try{
            sheet1.SetAllowCheck(true);
		    if(sheet1.ColSaveName(Col) == "sDelete" && sheet1.GetCellValue(Row,Col) == "0") {
		    	if(sheet1.GetCellValue(Row, "workteamCnt") > 0 || sheet1.GetCellValue(Row, "ioCnt") > 0) {

		            if(!confirm("<msg:txt mid='2017082900843' mdef='해당 근무시간에 속해 있는 근무조/출퇴근시간 자료가 존재합니다. 삭제하시겠습니까?'/>")) {
			            sheet1.SetAllowCheck(false);
		            }
		            return;
		    	}
		    }
		}catch(ex){
			alert("sheet1 OnBeforeCheck Event Error : " + ex);
		}
	}


	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
			$(".cp-Div").hide();
			if( sheet1.ColSaveName(Col) == "rgbColor" ){
				gPRow = Row;
				fnSheetDivPopup(sheet1, Row, Col);
				
			}
		}catch(ex){
			alert("sheet1 OnClick Event Error : " + ex);
		}
	}
	//---------------------------------------------------------------------------------------------------------------
	// sheet2 Event
	//---------------------------------------------------------------------------------------------------------------
	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();

			//기본, 연장, 휴게  시간 합산하여 표시
			var data = ajaxCall( "${ctx}/WorkTimeCdMgr.do?cmd=getDayWorkTimeMgrTimeMap", $("#sheet2Form").serialize(),false);

			if ( data != null && data.DATA != null ){
				$("#timeInfo").html("( "+data.DATA.info+" )");
			}
		} catch (ex) {
			alert("sheet2 OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			if( Code > -1 ) doAction2("Search");
		} catch (ex) {
			alert("sheet2 OnSaveEnd Event Error " + ex);
		}
	}


	//---------------------------------------------------------------------------------------------------------------
	// sheet3 Event
	//---------------------------------------------------------------------------------------------------------------
	// 조회 후 에러 메시지
	function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();

		} catch (ex) {
			alert("sheet3 OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet3_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			if( Code > -1 ) doAction3("Search");
		} catch (ex) {
			alert("sheet3 OnSaveEnd Event Error " + ex);
		}
	}


	function moveTab(idx){
		$("#tabsIndex").val(idx);
		$("#tabs").tabs( "option", "active", idx );

		if( idx == 0 ) {
			sheetResize();
			doAction2("Search");
		} else if( idx == 1 ) {
			sheetResize();
			doAction3("Search");
		}

	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form">
	<input type="hidden" id="tabsIndex" name="tabsIndex" />
	<div class="sheet_search outer">
		<table>
		<tr>
			<th>근무시간코드</th>
			<td>
				<input id="searchTimeCdNm" name="searchTimeCdNm" type="text" class="text"/>
			</td>
			<th><tit:txt mid='2017082900844' mdef='근무시간명'/></th>
			<td>
				<input id="searchTimeNm" name="searchTimeNm" type="text" class="text"/>
			</td>
			<td>
				<btn:a href="javascript:doAction1('Search');" css="btn dark" mid='search' mdef="조회"/>
			</td>
		</tr>
		</table>
	</div>
	</form>

	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt">근무시간기준관리</li>
			<li class="btn">
				<input type="checkbox" id="chkDetail" class="checkbox" checked/><label for="chkDetail" style="font-weight:bold; margin-left:4px;">상세</label>
				<btn:a href="javascript:doAction1('Insert');" css="btn outline_gray authA" mid='insert' mdef="입력"/>
				<btn:a href="javascript:doAction1('Copy');" css="btn outline_gray authA" mid='copy' mdef="복사"/>
				<btn:a href="javascript:doAction1('Save');" css="btn filled authA" mid='save' mdef="저장"/>
				<btn:a href="javascript:doAction1('Down2Excel');" css="btn outline_gray authR" mid='down2excel' mdef="다운로드"/>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "50%",  "${ssnLocaleCd}"); </script>

	<div class="h10 outer"></div>
	<div id="detailArea">
		<div id="tabs" class="tab">
			<ul class="tab_bottom">
				<li><a href="#tabs-0" onclick="javascript:moveTab(0)" >근무시간 상세</a></li>
				<li><a href="#tabs-1" onclick="javascript:moveTab(1)" >예외인정근무시간</a></li>
			</ul>
			<div id="tabs-0">
				<form id="sheet2Form" name="sheet2Form">
					<input type="hidden" id="searchTimeCd" name="searchTimeCd" />
					<div class="inner">
						<div class="sheet_title">
						<ul>
							<li class="txt">일일근무스케쥴</li>
							<li class="btn">
								<span id="timeInfo" class="spacingN" style="margin-right:30px;"></span>
								<select id="tempTimeCd" name="tempTimeCd"></select>
								<a href="javascript:doAction2('TimeCd')" class="btn filled authA">가져오기</a>
								&nbsp;&nbsp;&nbsp;
								<btn:a href="javascript:doAction2('Insert')" css="btn outline_gray authA" mid='insert' mdef="입력"/>
								<btn:a href="javascript:doAction2('Copy')" 	css="btn outline_gray authA" mid='copy' mdef="복사"/>
								<btn:a href="javascript:doAction2('Save')" 	css="btn filled authA" mid='save' mdef="저장"/>
								<btn:a href="javascript:doAction2('Down2Excel')" 	css="btn outline_gray authR" mid='download' mdef="다운로드"/>
							</li>
						</ul>
						</div>
					</div>
					
				</form>
				<script type="text/javascript"> createIBSheet("sheet2", "100%", "50%", "${ssnLocaleCd}"); </script>
			</div>

			<div id="tabs-1">
                <form id="sheet3Form" name="sheet3Form">
					<div class="inner">
						<div class="sheet_title">
						<ul>
							<li class="txt">예외인정근무시간</li>
							<li class="btn">
								<b>근태명&nbsp;:&nbsp;&nbsp;</b><select id="searchGntCd" name="searchGntCd"></select>&nbsp;&nbsp;&nbsp;&nbsp;
								<b>근태종류&nbsp;:&nbsp;&nbsp;</b><select id="searchGntGubunCd" name="searchGntGubunCd"></select>
								&nbsp;&nbsp;&nbsp;&nbsp;
								<span id="timeInfo" class="spacingN" style="margin-right:30px;"></span>
	                            &nbsp;&nbsp;&nbsp;
	                            <select id="tempTimeCd2" name="tempTimeCd2"></select>
	                            <a href="javascript:doAction3('TimeCd')" class="btn filled authA">가져오기</a>
	                            &nbsp;&nbsp;&nbsp;
								<btn:a href="javascript:doAction3('Save')" 	css="btn filled authA" mid='save' mdef="저장"/>
								<btn:a href="javascript:doAction3('Down2Excel')" 	css="btn outline_gray authR" mid='download' mdef="다운로드"/>
							</li>
						</ul>
						</div>
					</div>
                </form>
				<script type="text/javascript"> createIBSheet("sheet3", "100%", "50%", "${ssnLocaleCd}"); </script>
			</div>

		</div><!-- tabs -->
	</div>

</div>
</body>
</html>