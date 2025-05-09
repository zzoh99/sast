<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"> <head> <title>개인근무스케줄관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var headerStartCnt = 0;
var locationCdList = "";
var titleList = null;

	$(function() {
		// from - to 일자 근태대상기준일(TTIM004)에서 가져오도록 처리
		var data = ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getStandDtFromTTIM004",false);

		if(data != null && data.codeList[0] != null ) {
			$("#searchSymd").val(data.codeList[0].symd);
			$("#searchEymd").val(data.codeList[0].eymd);
		}

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:50, FrozenCol:0, MergeSheet:msNone};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
             {Header:"No",			Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),   Width:Number("${sNoWdt}"),  Align:"Center", ColMerge:0,   SaveName:"sNo" }
         ] ; IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(4);

        var workOrgCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getCommonWorkOrgCdList"), "<tit:txt mid='103895' mdef='전체'/>");
		$("#searchWorkOrgCd").html( workOrgCdList[2] ) ;
		$("#searchWorkOrgCd").select2({placeholder:("${ssnLocaleCd}" != "en_US" ? " 선택" : " Select")});


		//사업장코드 관리자권한만 전체사업장 보이도록, 그외는 권한사업장만.
		var url     = "queryId=getBusinessPlaceCdList";
		var allFlag = "<tit:txt mid='103895' mdef='전체'/>";
		if ("${ssnSearchType}" != "A"){
			url    += "&searchChkPlace=Y&sabun=${ssnSabun}&grpCd=${ssnGrpCd}";
			allFlag = "";

			var searchOrgUrl = "queryId=getTSYS319orgList&ssnSearchType=${ssnSearchType}&ssnGrpCd=${ssnGrpCd}&searchSabun=${ssnSabun}";
	        //var searchOrgCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", searchOrgUrl,false).codeList, "<tit:txt mid='103895' mdef='전체'/>");
	        var searchOrgCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", searchOrgUrl,false).codeList, "");
			$("#searchOrgCd").html(searchOrgCdList[2]);
		}
		var bizPlaceCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", url,false).codeList, allFlag);
		$("#searchBizPlaceCd").html(bizPlaceCdList[2]);

		//근무지 관리자권한만 전체근무지 보이도록, 그외는 권한근무지만.
		url     = "queryId=getLocationCdListAuth";
		allFlag = true;
		if ("${ssnSearchType}" != "A"){
			url    += "&searchChkPlace=Y&sabun=${ssnSabun}&grpCd=${ssnGrpCd}";
			allFlag = false;
		}

		if(allFlag) {
			locationCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, ("${ssnLocaleCd}" != "en_US" ? "전체" : "All"));	//사업장
		} else {
			locationCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, "");	//사업장
		}
		$("#searchLocationCd").html(locationCdList[2]);

        $("#searchSymd").datepicker2({
        	startdate:"searchEymd",
   			onReturn:function(date){
   				//doAction1("Search"); // 2014.12.22 막음
				getCommonCodeList();
   			}
        });

        $("#searchEymd").datepicker2({
        	enddate:"searchSymd",
   			onReturn:function(date){
   				//doAction1("Search"); // 2014.12.22 막음
				getCommonCodeList();
   			}
        });

		getCommonCodeList();

		$("#searchSymd, #searchEymd").bind("keyup",function(event){
			//if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); } // 2014.12.22 막음
		});
		$("#searchWorkOrgCd, #searchOrgCd, #searchJikweeCd, #searchManageCd, #searchBizPlaceCd").bind("change",function(event){
			//doAction1("Search"); // 2014.12.22 막음
		});
		$("#searchSabun").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
				$(this).focus();
			}
			if( event.keyCode == 8 || event.keyCode == 46){  //back/del
				clearCode(2);
			}
		});


		//doAction1("Search");
		searchTitleList();
		$(window).smartresize(sheetResize);
		sheetInit();
	});

	function getCommonCodeList() {
		let baseSYmd = $("#searchSymd").val();
		let baseEYmd = $("#searchEymd").val();

		// 급여유형(H10110)
		var payType = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10110", baseSYmd, baseEYmd), "");
		$("#payType").html(payType[2]);
		$("#payType").select2({placeholder:("${ssnLocaleCd}" != "en_US" ? " 선택" : " Select")});

		// 사원구분코드(H10030)
		var manageCdList = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10030", baseSYmd, baseEYmd), "<tit:txt mid='103895' mdef='전체'/>");
		$("#searchManageCd").html(manageCdList[2]);

		// 직위코드(H20030)
		var jikweeCdList = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20030", baseSYmd, baseEYmd), "<tit:txt mid='103895' mdef='전체'/>");
		$("#searchJikweeCd").html(jikweeCdList[2]);
	}

	// 필수값/유효성 체크
	function chkInVal() {
		// 시작일자와 종료일자 체크
		if($("#searchSymd").val() == ""){
			alert("근무기간 시작일자를 입력 해주세요.");
			$("#searchSymd").focus();
			return false;
		}
		if($("#searchEymd").val() == ""){
			alert("근무기간 종료일자를 입력 해주세요.");
			$("#searchEymd").focus();
			return false;
		}

		if ($("#searchSymd").val() != "" && $("#searchEymd").val() != "") {
			if (!checkFromToDate($("#searchSymd"),$("#searchEymd"),"근무기간","근무기간","YYYYMMDD")) {
				return false;
			}
		}

		return true;
	}

	//Sheet Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
				if(!chkInVal()){break;}
				searchTitleList();

				$("#multiPayType").val(getMultiSelect($("#payType").val()));
				$("#multiWorkOrgCd").val(getMultiSelect($("#searchWorkOrgCd").val()));

				sheet1.DoSearch( "${ctx}/DailyWorkStatus.do?cmd=getDailyWorkStatusList", $("#sheetForm").serialize() );
				break;
		case "Save":
			if(!dupChk(sheet1,"sabun|ymd", false, true)){break;}
			IBS_SaveName(document.sheetForm,sheet1);
			sheet1.DoSave( "${ctx}/DailyWorkStatus.do?cmd=saveDailyWorkStatus", $("#sheetForm").serialize()); break;

			break;
		case "Insert":
			sheet1.DataInsert(0) ;
			break;
		case "Copy":
			sheet1.SelectCell(sheet1.DataCopy(), 4);
			break;
		case "Clear":		sheet1.RemoveAll(); break;
        /*
		case "Down2Excel":
        	sheet1.SetColHidden("btnCalc", 1);
        	var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param);
        	sheet1.SetColHidden("btnCalc", 0);
			break;
		*/
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};

			sheet1.Down2Excel(param);

			break;
		case "LoadExcel":
			// 업로드
			sheet1.RemoveAll();
			var params = {};
			sheet1.LoadExcel(params);
			break;
		case "DownTemplate":
			// 양식다운로드
			var sdowncols = "ymd|sabun|inHm|outHm";

			for (i=headerStartCnt; i<=sheet1.LastCol();i++){
				if (sheet1.GetColHidden(i) == 0) sdowncols += "|" + i.toString();
			}
			sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:sdowncols});
			break;
		}
	}

	/*SETTING HEADER LIST*/
	function searchTitleList() {

		titleList = ajaxCall("${ctx}/DailyWorkStatus.do?cmd=getDailyWorkStatusHeaderList", $("#sheetForm").serialize(), false);
		if (titleList != null && titleList.DATA != null) {

			sheet1.Reset();

			var v=0;
			var initdata1 = {};
			initdata1.Cfg = {SearchMode:smLazyLoad,Page:50, MergeSheet:msHeaderOnly,FrozenCol:0};
			//initdata1.Cfg = {SearchMode:smServerPaging, Page:200, MergeSheet:msNone, FrozenCol:9};

			initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};

			initdata1.Cols = [];
			initdata1.Cols[v++] = {Header:"No|No",				Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),   Width:Number("${sNoWdt}"),  Align:"Center", ColMerge:0,   SaveName:"sNo" };
			//initdata1.Cols[v++] = {Header:"<sht:txt mid='sDelete' mdef='삭제'/>",		Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),  Width:Number("${sDelWdt}"), Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0};
			//initdata1.Cols[v++] = {Header:"<sht:txt mid='statusCd' mdef='상태'/>",		Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),  Width:Number("${sSttWdt}"), Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0};

			initdata1.Cols[v++] = {Header:"사업장|사업장",		Type:"Text",		Hidden:0, 	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"businessPlaceNm",	KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100};
			initdata1.Cols[v++] = {Header:"근무지|근무지",		Type:"Combo",		Hidden:0,  Width:70,	Align:"Center",	ColMerge:0,	SaveName:"locationCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
			initdata1.Cols[v++] = {Header:"소속|소속",			Type:"Text",		Hidden:0,  Width:100,	Align:"Center",  ColMerge:1,   SaveName:"orgNm",			KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			initdata1.Cols[v++] = {Header:"사번|사번",			Type:"Text",		Hidden:0,  Width:60,	Align:"Center",  ColMerge:1,   SaveName:"sabun",		   	KeyField:1,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 };
			initdata1.Cols[v++] = {Header:"성명|성명",			Type:"Text",		Hidden:0,  Width:50,	Align:"Center",  ColMerge:1,   SaveName:"name",		   	KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 };
			initdata1.Cols[v++] = {Header:"직위|직위",			Type:"Text",		Hidden:Number("${jwHdn}"),  Width:60,	Align:"Center",  ColMerge:1,   SaveName:"jikweeNm",		KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 };
			initdata1.Cols[v++] = {Header:"직책|직책",			Type:"Text",		Hidden:0,  Width:60,	Align:"Center",  ColMerge:1,   SaveName:"jikchakNm",		KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 };
			initdata1.Cols[v++] = {Header:"직급|직급",			Type:"Text",		Hidden:0,  Width:60,	Align:"Center",  ColMerge:1,   SaveName:"jikgubNm",		KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 };
			initdata1.Cols[v++] = {Header:"사원구분|사원구분",	Type:"Text",		Hidden:0,  Width:60,	Align:"Center",  ColMerge:1,   SaveName:"manageNm",		KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 };
			initdata1.Cols[v++] = {Header:"근무조|근무조",		Type:"Text",		Hidden:0,  Width:60,	Align:"Center",  ColMerge:1,   SaveName:"workOrgNm",	KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 };
			//initdata1.Cols[v++] = {Header:"직종|직종",			Type:"Text",		Hidden:0,  Width:60,	Align:"Center",  ColMerge:1,   SaveName:"workTypeNm",	KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 };

			if($("input[id='searchSumFlag']:checked").val() != "Y") {
				initdata1.Cols[v++] = {Header:"근무일|근무일",			Type:"Date",		Hidden:0,  Width:60,	Align:"Center",  ColMerge:1,   SaveName:"ymd",		KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 };
				initdata1.Cols[v++] = {Header:"근태|근태",				Type:"Text",		Hidden:0,  Width:60,	Align:"Center",  ColMerge:1,   SaveName:"gntCd",	KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0 };
				initdata1.Cols[v++] = {Header:"TIMECARD시간|출근",		Type:"Text",		Hidden:0,  Width:60,	Align:"Center",  ColMerge:1,   SaveName:"tcInHm",		KeyField:0,   CalcLogic:"",   Format:"Hm",       PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 };
				initdata1.Cols[v++] = {Header:"TIMECARD시간|퇴근",		Type:"Text",		Hidden:0,  Width:60,	Align:"Center",  ColMerge:1,   SaveName:"tcOutHm",	KeyField:0,   CalcLogic:"",   Format:"Hm",       PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 };
				initdata1.Cols[v++] = {Header:"인정근무시간|출근",			Type:"Text",		Hidden:0,  Width:60,	Align:"Center",  ColMerge:1,   SaveName:"inHm",		KeyField:0,   CalcLogic:"",   Format:"Hm",       PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 };
				initdata1.Cols[v++] = {Header:"인정근무시간|퇴근",			Type:"Text",		Hidden:0,  Width:60,	Align:"Center",  ColMerge:1,   SaveName:"outHm",	KeyField:0,   CalcLogic:"",   Format:"Hm",       PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 };
			}

			initdata1.Cols[v++] = {Header:"급여유형|급여유형",			Type:"Text",		Hidden:0,  Width:60,	Align:"Center",  ColMerge:1,   SaveName:"payTypeNm",		KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 };
			initdata1.Cols[v++] = {Header:"근무\n시간|근무\n시간",		Type:"Text",		Hidden:1,  Width:50,	Align:"Center", ColMerge:1,   SaveName:"realWorkTime",	KeyField:0,   CalcLogic:"",   Format:"",       PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 };

			var sumCols = "";
			headerStartCnt = v;
			var i = 0 ;
			for(; i<titleList.DATA.length; i++) {
				initdata1.Cols[v++] = {Header:titleList.DATA[i].codeNm+"|"+titleList.DATA[i].codeNm,	Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:titleList.DATA[i].saveNameDisp,	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
				sumCols += v +"|";
				initdata1.Cols[v++] = {Header:titleList.DATA[i].codeNm+"|"+titleList.DATA[i].codeNm,	Type:"AutoSum",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:titleList.DATA[i].sumSaveNameDisp,	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
			}
			//initdata1.Cols[v++] = {Header:"temp",Type:"AutoSum",		Hidden:1,  Width:50,   Align:"Center", 	ColMerge:1,   SaveName:"temp",		KeyField:0,   CalcLogic:"",   Format:"",       PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 };

			IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
			sheet1.SetUseDefaultTime(0);
			///sheet1.SetDataAutoTrim(0);  ////// 2014.12.19 테스트...

			sumCols = sumCols.substring(0,(sumCols.length-1));
			if($("input[id='searchSumFlag']:checked").val() != "Y") {
				var info = [{StdCol:"name", SumCols:sumCols, CaptionCol:"orgNm"}];
				sheet1.ShowSubSum(info);
			}

			/* 콤보값 설정 */
			/*
			var gntCdList    = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCpnGntCdList",false).codeList, "");
			sheet1.SetColProperty("gntCd", 		{ComboText:"|"+gntCdList[0], ComboCode:"|"+gntCdList[1]} );
			*/
			var timeCdList    = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getWorkTimeCdList&searchShortNameFlag=Y",false).codeList, "");
			sheet1.SetColProperty("timeCd", 		{ComboText:"|"+timeCdList[0], ComboCode:"|"+timeCdList[1]} );
			sheet1.SetColProperty("locationCd", {ComboText:"|"+locationCdList[0], ComboCode:"|"+locationCdList[1]});
			//var workOrgCdList = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getCommonWorkOrgCdList"), "");
			//sheet1.SetColProperty("workOrgCd", 		{ComboText:"|"+workOrgCdList[0], ComboCode:"|"+workOrgCdList[1]} );

			$("#searchSbNm").bind("keyup",function(event) {
				if (event.keyCode == 13) {
					doAction1("Search");
				}
			});
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			sheetResize();
			/**
            for(var Col = 0; Col <= sheet1.LastCol(); Col++) {
                if( sheet1.ColSaveName(Col).substring(0, 6) == "workCd" ) {
                    sumWorkCd(sheet1.ColSaveName(Col));
                }
            }*/

            if (sheet1.RowCount() > 0){

        		if (titleList != null && titleList.DATA != null) {
    				// lastRow 소계행, 합계행 계산

    				for(var row = sheet1.HeaderRows(); row <= sheet1.LastRow(); row++){
    					if ( sheet1.GetCellValue(row, "sabun") == ""){
		        			for(var i=0; i<titleList.DATA.length; i++) {
			        			var tempValue = Number(sheet1.GetCellValue(row, titleList.DATA[i].sumSaveNameDisp));
			        			if ( tempValue != 0){
				        			var tMM       = (tempValue % 60 < 10)? "0"+(tempValue % 60) : (tempValue % 60);
				        			var value =  Math.floor(tempValue / 60) + ":" + tMM;

				        			sheet1.SetCellValue(row, titleList.DATA[i].saveNameDisp, value);
			        			}
		        			}
    					}
    				}
        		}
            }


		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); }
			doAction1("Search");
		} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
			if( sheet1.ColSaveName(Col) == "btnCalc" ) {
				setSheetWorkTime(Row);
			}
		}catch(ex){
			alert("OnClick Event Error : " + ex);
		}
	}

	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol,isDelete) {
		try{
		}catch(ex){
			alert("OnSelectCell Event Error : " + ex);
		}
	}

		// 출퇴근 입력시, 기본근무.... 시간 set
	function setSheetWorkTime(Row){
		var param = "searchSabun=" + sheet1.GetCellValue(Row, "sabun")
		  + "&ymd=" + sheet1.GetCellValue(Row, "ymd")
		  + "&shm=" + sheet1.GetCellValue(Row, "inHm")
		  + "&ehm=" + sheet1.GetCellValue(Row, "outHm");

		var workTimeList = ajaxCall("${ctx}/OtWorkAppDet.do?cmd=getOtWorkAppDetWokrTimeList", param, false);
		if (workTimeList != null && workTimeList.DATA != null) {
			var i = 0 ;

			for(; i<workTimeList.DATA.length; i++) {
				sheet1.SetCellValue(Row, workTimeList.DATA[i].saveName, workTimeList.DATA[i].colValue);
			}
		}
	}


	// 기본근무 ~ .. 시간 sum
	function sumWorkCd(colName){
		var sumData = 0;
		var val     = 0;
		var hh, mm;
		// 시간계산해서 마지막 row에 set
		for (var i=1;i<sheet1.LastRow();i++){
			val = sheet1.GetCellValue(i, colName);
			//if (val.length == 4){
				sumData += parseInt(val.substring(0, 2), 10) *60 + parseInt(val.substring(2, 4));
			//}
		}
		hh = Math.floor(sumData/60);
		mm = (sumData - Math.floor(sumData/60) *60);
		sheet1.SetCellValue(sheet1.LastRow(), colName, hh.toString() + ((mm.toString().length<2)?":0":":") + mm.toString());
	}

	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

	}

	// 소속 팝업
	function showOrgPopup() {
		if(!isPopup()) {return;}

        // openPopup("/Popup.do?cmd=orgBasicPopup&authPg=R", "", "740","520", function (rv){
		// 	$("#searchOrgCd").val(rv["orgCd"]);
        // 	$("#searchOrgNm").val(rv["orgNm"]);
        // 	doAction1("Search");
        // });

		let layerModal = new window.top.document.LayerModal({
			id : 'orgTreeLayer'
			, url : '/Popup.do?cmd=viewOrgTreeLayer&authPg=${authPg}'
			, parameters : {searchEnterCd : ''}
			, width : 740
			, height : 520
			, title : '<tit:txt mid='orgSchList' mdef='조직도 조회'/>'
			, trigger :[
				{
					name : 'orgTreeLayerTrigger'
					, callback : function(result){
						$("#searchOrgCd").val(result["orgCd"]);
						$("#searchOrgNm").val(result["orgNm"]);
					}
				}
			]
		});
		layerModal.show();
	}

	// 사원 팝업
	function showEmployeePopup() {
		if(!isPopup()) {return;}

		/*
        openPopup("/Popup.do?cmd=employeePopup&authPg=R", "", "740","520", function (rv){
   			$('#name').val(rv["name"]);
   			$('#searchSabun').val(rv["sabun"]);
   	    	doAction1("Search");
        });*/
        let layerModal = new window.top.document.LayerModal({
            id : 'employeeLayer'
            , url : '/Popup.do?cmd=viewEmployeeLayer&authPg=R'
            , parameters : {}
            , width : 740
            , height : 520
            , title : '사원조회'
            , trigger :[
                {
                    name : 'employeeTrigger'
                    , callback : function(result){
                        $('#name').val(result.name);
                        $('#searchSabun').val(result.sabun);
                        doAction1("Search");
                    }
                }
            ]
        });
        layerModal.show();
	}

	function clearCode(num) {

		if(num == 1) {
			$("#searchOrgCd").val("");
			$("#searchOrgNm").val("");
			//doAction1("Search");  // 2014.12.22 막음
		} else {
			$('#name').val("");
		}
	}

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
		<input id="defaultRow" name="defaultRow" type="hidden" >
		<input type="hidden" id="multiPayType" name="multiPayType" value="" />
		<input type="hidden" id="multiWorkOrgCd" name="multiWorkOrgCd" value="" />

		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th>근무일</th>
						<td>
							<input id="searchSymd" name="searchSymd" type="text" class="date2 required"/> ~
							<input id="searchEymd" name="searchEymd" type="text" class="date2 required"/>
						</td>
						<th>근무지</th>
						<td>
							<select id="searchLocationCd" name="searchLocationCd"> </select>
							
						</td>
						<th>사업장</th>
						<td>
							<select id="searchBizPlaceCd" name="searchBizPlaceCd" > </select>
						</td>
						<td>
							<input id="searchSumFlag" name="searchSumFlag" type="checkbox" class="checkbox" value="Y" checked/>합계행만
						</td>
					</tr>
					<tr>
					</tr>
					<c:if test="${ssnJikweeUseYn == 'Y'}">
						<th>직위</th>
						<td> 
							<select id="searchJikweeCd" name="searchJikweeCd" > </select>
						</td>
					</c:if>
						<th>사원구분</th>
						<td>
							<select id="searchManageCd" name="searchManageCd" > </select>
						</td>
						<th>근무조</th>
						<td>
							<select id="searchWorkOrgCd" name="searchWorkOrgCd" multiple=""> </select>
						</td>


					<tr>
						<th>소속</th>
						<td>
						<c:choose>
						<c:when test="${ssnSearchType =='A'}">
							<input type="hidden" id="searchOrgCd" name="searchOrgCd" />
							<input type="text" id="searchOrgNm" name="searchOrgNm"  class="text readonly w100" readonly/><a href="javascript:showOrgPopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
							<a href="javascript:clearCode(1)" class="button7"><img src="/common/images/icon/icon_undo.png"/></a>
						</c:when>
						<c:otherwise>
							<select id="searchOrgCd" name="searchOrgCd" > </select>
						</c:otherwise>
						</c:choose>
							<input id="searchOrgType" name="searchOrgType" type="checkbox" class="checkbox" value="Y" checked/>하위포함
						</td>
						<th>사번/성명</th>
						<td>
							<input type="text" id="searchSabun" name="searchSabun" class="text" />
							<input id="name"  name="name"  type="text" class="text readonly" readonly/><a href="javascript:showEmployeePopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
						</td>
						<th>급여유형</th>
						<td>  <select id="payType" name="payType" multiple=""> </select> </td>
						<td><a href="javascript:doAction1('Search');" class="button" >조회</a> </td>
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
							<li class="txt">일근무집계</li>
							<li class="btn">
								<a href="javascript:doAction1('Down2Excel');" 	class="basic authR" >다운로드</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>

</div>
</body>
</html>