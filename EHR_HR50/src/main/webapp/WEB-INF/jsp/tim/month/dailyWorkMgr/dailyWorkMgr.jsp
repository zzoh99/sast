<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>일근무관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<%@ page import="com.hr.common.util.DateUtil" %>
<script type="text/javascript">
var gPRow  = "";
var popGubun = "";
var headerStartCnt = 0;
var locationCdList = "";

	$(function() {

		// from - to 일자 근태대상기준일(TTIM004)에서 가져오도록 처리
		//var data = ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getStandDtFromTTIM004",false);

		//if(data != null && data.codeList[0] != null ) {
			$("#searchSymd").val("${curSysYyyyMMddHyphen}");
			$("#searchEymd").val("${curSysYyyyMMddHyphen}");
		//}

		//근무조
		//var workOrgCdList = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getCommonWorkOrgCdList"), "<tit:txt mid='103895' mdef='전체'/>");
		//$("#searchWorkOrgCd").html( workOrgCdList[2] ) ;

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

 		//==============================================================================================================================
		getCommonCodeList();

		// 급여유형(H10110)
		/*var payType = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10110"), "");
		$("#payType").html(payType[2]);
		$("#payType").select2({placeholder:("${ssnLocaleCd}" != "en_US" ? " 선택" : " Select")});
		*/

		//==============================================================================================================================
			

        $("#searchSymd").datepicker2({
        	startdate:"searchEymd",
   			onReturn:function(date){
				getCommonCodeList();
   				//doAction1("Search"); // 2014.12.22 막음
   			}
        });
        $("#searchEymd").datepicker2({
        	enddate:"searchSymd",
   			onReturn:function(date){
				getCommonCodeList();
   				//doAction1("Search"); // 2014.12.22 막음
   			}
        });

        $("#searchSabunName, #searchSymd, #searchEymd").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
				$(this).focus();
			}
			if( event.keyCode == 8 || event.keyCode == 46){  //back/del
				clearCode(2);
			}
		});
        
/*        $("#searchEditYn").bind("change", function(){
            doAction1("Search");
            
        });*/


		//doAction1("Search");
		searchTitleList();
		$(window).smartresize(sheetResize);sheetInit();
	});

	function getCommonCodeList() {
		//공통코드 한번에 조회
		let baseSYmd = $("#searchSymd").val();
		let baseEYmd = $("#searchEymd").val();

		const workGrpCdList = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&useYn=Y", "T11020", baseSYmd, baseEYmd), "전체");
		$("#searchWorkGrpCd").html(workGrpCdList[2]);

		let grpCds = "H10030,H20030,H20010,H10050";
		let params = "grpCd=" + grpCds
					+ "&baseSYmd=" + baseSYmd
					+ "&baseEYmd=" + baseEYmd;

		const codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists", params,false).codeList, "전체");
		$("#searchManageCd").html(codeLists['H10030'][2]);
		$("#searchJikweeCd").html(codeLists['H20030'][2]);
		$("#searchJikgubCd").html(codeLists['H20010'][2]);
		$("#searchWorkType").html(codeLists['H10050'][2]);
	}
	
	/*SETTING HEADER LIST*/
	function searchTitleList() {
		var hdn = 0;
		var titleList = ajaxCall("${ctx}/DailyWorkMgr.do?cmd=getDailyWorkMgrHeaderList", $("#sheetForm").serialize(), false);
		if (titleList != null && titleList.DATA != null) {

			sheet1.Reset();

			var v=0;
			var initdata1 = {};
			initdata1.Cfg = {SearchMode:smLazyLoad, Page:25, MergeSheet:msHeaderOnly,FrozenCol:10};

			initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};

			initdata1.Cols = [];	
			initdata1.Cols[v++] = {Header:"No|No",						Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),   Width:Number("${sNoWdt}"),  Align:"Center", SaveName:"sNo" };
			initdata1.Cols[v++] = {Header:"\n삭제|\n삭제",					Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),  Width:Number("${sDelWdt}"), Align:"Center", SaveName:"sDelete" , Sort:0};
			initdata1.Cols[v++] = {Header:"상태|상태",						Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),  Width:Number("${sSttWdt}"), Align:"Center", SaveName:"sStatus" , Sort:0};
			initdata1.Cols[v++] = {Header:"근무일|근무일",					Type:"Date",		Hidden:0,  Width:90,  	Align:"Center",		SaveName:"ymd",				KeyField:1,  Format:"Ymd",  UpdateEdit:0,	InsertEdit:1,	EditLen:100 };
			initdata1.Cols[v++] = {Header:"요일|요일",						Type:"Text",		Hidden:0,  Width:40,   	Align:"Center",		SaveName:"dayNm",			KeyField:0,  Format:"",		UpdateEdit:0,	InsertEdit:1,	EditLen:100 };
			initdata1.Cols[v++] = {Header:"구분|구분",						Type:"Text",		Hidden:0,  Width:60,   	Align:"Center",		SaveName:"dayDiv",			KeyField:0,	 Format:"",		UpdateEdit:0,	InsertEdit:1,	EditLen:100 };
			initdata1.Cols[v++] = {Header:"근무지|근무지",					Type:"Combo",		Hidden:1,  Width:100,	Align:"Center",		SaveName:"locationCd",		KeyField:0,	 Format:"",		UpdateEdit:0,	InsertEdit:0 };
			initdata1.Cols[v++] = {Header:"소속|소속",						Type:"Text",		Hidden:0,  Width:150,   Align:"Left",  		SaveName:"orgNm",			KeyField:0,  Format:"",     UpdateEdit:0,   InsertEdit:0 },
			initdata1.Cols[v++] = {Header:"사번|사번",						Type:"Text",		Hidden:0,  Width:60,   	Align:"Center",  	SaveName:"sabun",		   	KeyField:1,  Format:"",     UpdateEdit:0,   InsertEdit:0 };
			initdata1.Cols[v++] = {Header:"성명|성명",						Type:"Text",		Hidden:0,  Width:70,   	Align:"Center",  	SaveName:"name",		   	KeyField:0,  Format:"",     UpdateEdit:0,   InsertEdit:1,   EditLen:100 };
			initdata1.Cols[v++] = {Header:"직위|직위",						Type:"Text",		Hidden:1,  Width:60,   	Align:"Center",  	SaveName:"jikweeNm",		KeyField:0,  Format:"",     UpdateEdit:0,   InsertEdit:0 };
			initdata1.Cols[v++] = {Header:"직급|직급",						Type:"Text",		Hidden:0,  Width:60,   	Align:"Center",  	SaveName:"jikgubNm",		KeyField:0,  Format:"",     UpdateEdit:0,   InsertEdit:0 };
			initdata1.Cols[v++] = {Header:"직책|직책",						Type:"Text",		Hidden:0,  Width:60,   	Align:"Center",  	SaveName:"jikchakNm",		KeyField:0,  Format:"",     UpdateEdit:0,   InsertEdit:0 };
			initdata1.Cols[v++] = {Header:"사원구분|사원구분",				Type:"Text",		Hidden:0,  Width:60,   	Align:"Center",  	SaveName:"manageNm",		KeyField:0,  Format:"",     UpdateEdit:0,   InsertEdit:0 };
			initdata1.Cols[v++] = {Header:"직군|직군",						Type:"Text",		Hidden:0,  Width:60,   	Align:"Center",  	SaveName:"workTypeNm",		KeyField:0,  Format:"",     UpdateEdit:0,   InsertEdit:0 };
			initdata1.Cols[v++] = {Header:"직군|직군",                    Type:"Text",        Hidden:1,  Width:60,    Align:"Center",     SaveName:"workType",        KeyField:0,  Format:"",     UpdateEdit:0,   InsertEdit:0 };
            initdata1.Cols[v++] = {Header:"급여유형|급여유형",				Type:"Text",		Hidden:1,  Width:60,   	Align:"Center",  	SaveName:"payTypeNm",		KeyField:0,  Format:"",     UpdateEdit:0,   InsertEdit:0 };
			initdata1.Cols[v++] = {Header:"근태|근태",						Type:"Text",		Hidden:0,  Width:70,  	Align:"Center", 	SaveName:"gntCd",			KeyField:0,  Format:"",     UpdateEdit:0,   InsertEdit:0 };
			initdata1.Cols[v++] = {Header:"근무시간|근무시간",				Type:"Combo",		Hidden:0,  Width:70, 	Align:"Center", 	SaveName:"timeCd",			KeyField:0,  Format:"",     UpdateEdit:0,   InsertEdit:0,   EditLen:100 };

			initdata1.Cols[v++] = {Header:"TimeCard|출근",				Type:"Text",		Hidden:hdn,Width:60,	Align:"Center",  	SaveName:"tcInHm",			KeyField:0,  Format:"Hm",   UpdateEdit:0,   InsertEdit:0 };
			initdata1.Cols[v++] = {Header:"TimeCard|퇴근",				Type:"Text",		Hidden:hdn,Width:60,	Align:"Center",  	SaveName:"tcOutHm",			KeyField:0,  Format:"Hm",   UpdateEdit:0,   InsertEdit:0 };
			initdata1.Cols[v++] = {Header:"EHR|출근",						Type:"Text",		Hidden:0,  Width:60,	Align:"Center",  	SaveName:"ehrInHm",			KeyField:0,  Format:"Hm",   UpdateEdit:0,   InsertEdit:0 };
			initdata1.Cols[v++] = {Header:"EHR|퇴근",						Type:"Text",		Hidden:0,  Width:60,	Align:"Center",  	SaveName:"ehrOutHm",		KeyField:0,  Format:"Hm",   UpdateEdit:0,   InsertEdit:0 };
			initdata1.Cols[v++] = {Header:"인정근무시간|출근",				Type:"Date",		Hidden:0,  Width:60,	Align:"Center",  	SaveName:"inHm",			KeyField:0,  Format:"Hm",   UpdateEdit:1,   InsertEdit:1,   EditLen:5 };
			initdata1.Cols[v++] = {Header:"인정근무시간|퇴근",				Type:"Date",		Hidden:0,  Width:60,	Align:"Center",  	SaveName:"outHm",			KeyField:0,  Format:"Hm",   UpdateEdit:1,   InsertEdit:1,   EditLen:5 };
			
			initdata1.Cols[v++] = {Header:"계|계",						Type:"Text",		Hidden:0,  Width:50,   	Align:"Center", 	SaveName:"workTime",		KeyField:0,  Format:"Hm",   UpdateEdit:0,   InsertEdit:0, };
			initdata1.Cols[v++] = {Header:"인정\n시간|인정\n시간",			Type:"Text",		Hidden:0,  Width:50,   	Align:"Center", 	SaveName:"realWorkTime",	KeyField:0,  Format:"Hm",   UpdateEdit:0,   InsertEdit:0, };
			initdata1.Cols[v++] = {Header:"타임카드\n누락|타임카드\n누락",		Type:"CheckBox",	Hidden:hdn,Width:50,   	Align:"Center", 	SaveName:"timeCardFlag",	KeyField:0,  Format:"",     UpdateEdit:0,   InsertEdit:0,   HeaderCheck:0 };
			
			initdata1.Cols[v++] = {Header:"근무시간\n수정여부|근무시간\n수정여부",Type:"CheckBox",	Hidden:0,  Width:50,   	Align:"Center", 	SaveName:"updateYn",		KeyField:0,  Format:"",     UpdateEdit:0,   InsertEdit:0,   TrueValue:"Y", FalseValue:"N", HeaderCheck:0};
			initdata1.Cols[v++] = {Header:"\n근무\n마감|\n근무\n마감",		Type:"CheckBox",	Hidden:0,  Width:50,   	Align:"Center", 	SaveName:"closeYn",			KeyField:0,  Format:"",     UpdateEdit:1,   InsertEdit:0,   TrueValue:"Y", FalseValue:"N"};

			headerStartCnt = v;
			var i = 0 ;

			for(; i<titleList.DATA.length; i++) {
				initdata1.Cols[v++] = {Header:titleList.DATA[i].codeNm+"|"+titleList.DATA[i].codeNm, Type:"Date", Hidden:0, Width:60, Align:"Center", SaveName:titleList.DATA[i].saveNameDisp, Format:"Hm", UpdateEdit:1, InsertEdit:1 };
			}
			//initdata1.Cols[v++] = {Header:"temp|temp",Type:"AutoSum", Hidden:1,  Width:50, Align:"Center", SaveName:"temp"};
			initdata1.Cols[v++] = {Header:"비고|비고",						Type:"Text",		Hidden:0,  Width:150,   Align:"Left",   	SaveName:"memo",			KeyField:0,  Format:"",     UpdateEdit:1,   InsertEdit:1,   EditLen:200 };
			initdata1.Cols[v++] = {Header:"특이사항|특이사항",				Type:"Text",		Hidden:0,  Width:150,   Align:"Left",    	SaveName:"memo2",			KeyField:0,  Format:"",     UpdateEdit:1,   InsertEdit:1,   EditLen:1000 };
			initdata1.Cols[v++] = {Header:"수정시간|수정시간",				Type:"Text",		Hidden:0,  Width:100,   Align:"Center",  	SaveName:"chkdate",			KeyField:0,  Format:"",     UpdateEdit:0,   InsertEdit:0 };
			initdata1.Cols[v++] = {Header:"입력자|입력자",					Type:"Text",		Hidden:0,  Width:60,   	Align:"Center",  	SaveName:"chknm",			KeyField:0,  Format:"",     UpdateEdit:0,   InsertEdit:0 };

			initdata1.Cols[v++] = {Header:"휴일구분|휴일구분",				Type:"Text",		Hidden:1,  Width:50,   Align:"Center", 		SaveName:"holidayDiv",		KeyField:0,  Format:"",     UpdateEdit:0,   InsertEdit:0,   EditLen:100 , HeaderCheck:0};
			initdata1.Cols[v++] = {Header:"휴일여부|휴일여부",				Type:"Text",		Hidden:1,  Width:50,   Align:"Center", 		SaveName:"holYn",			KeyField:0,  Format:"",     UpdateEdit:0,   InsertEdit:0,   EditLen:100 , HeaderCheck:0};

			IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
			sheet1.SetUseDefaultTime(0);
			
			IBS_setChunkedOnSave("sheet1", {chunkSize : 25});
			
			//doFilter(); //굳이 미리 보여줄 필요는 없을듯 함.

			
			//Autocomplete	
			$(sheet1).sheetAutocomplete({
				Columns: [
					{
						ColSaveName  : "name",
						CallbackFunc : function(returnValue) {
							var rv = $.parseJSON('{' + returnValue+ '}');
							sheet1.SetCellValue(gPRow,"name", rv["name"]);
							sheet1.SetCellValue(gPRow,"sabun", rv["sabun"]);
							sheet1.SetCellValue(gPRow,"orgNm", rv["orgNm"]);
							sheet1.SetCellValue(gPRow,"jikgubNm", rv["jikgubNm"]);
							sheet1.SetCellValue(gPRow,"jikchakNm", rv["jikchakNm"]);
							sheet1.SetCellValue(gPRow,"manageNm", rv["manageNm"]);
							sheet1.SetCellValue(gPRow,"workTypeNm", rv["workTypeNm"]);
							sheet1.SetCellValue(gPRow,"workType", rv["workType"]);
							sheet1.SetCellValue(gPRow,"payTypeNm", rv["payTypeNm"]);
						}
					}
				]
			});

			var timeCdList    = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getWorkTimeCdList&searchShortNameFlag=Y",false).codeList, "");
			sheet1.SetColProperty("timeCd", 		{ComboText:"|"+timeCdList[0], ComboCode:"|"+timeCdList[1]} );
			sheet1.SetColProperty("locationCd", {ComboText:"|"+locationCdList[0], ComboCode:"|"+locationCdList[1]});
		}
	}

	function doFilter() {

		sheet1.ShowFilterRow();

	    sheet1.LoadSearchData(this.data, {
	        Sync: 1
	    });
	}

	// 필수값/유효성 체크
	function chkInVal() {
		// 시작일자와 종료일자 체크
		if ($("#searchSymd").val() != "" && $("#searchEymd").val() != "") {
			if (!checkFromToDate($("#searchSymd"),$("#searchEymd"),"근무일","근무일","YYYYMMDD")) {
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
			sheet1.ShowProcessDlg("Search");
			setTimeout(function(){
				searchTitleList();
				var sXml = sheet1.GetSearchData("${ctx}/DailyWorkMgr.do?cmd=getDailyWorkMgrList", $("#sheetForm").serialize() );
				sXml = replaceAll(sXml,"rowEdit", "Edit");
				sXml = replaceAll(sXml,"closeYnEdit", "closeYn#Edit");
				sXml = replaceAll(sXml,"dayNmFontColor", "dayNm#FontColor");
				sXml = replaceAll(sXml,"dayDivFontColor", "dayDiv#FontColor");
				sXml = replaceAll(sXml,"ymdFontColor", "ymd#FontColor");
				sheet1.LoadSearchData(sXml );
			}, 100);
			
			break;
		case "Save":
			if(!dupChk(sheet1,"sabun|ymd", false, true)){break;}
			IBS_SaveName(document.sheetForm,sheet1);
			sheet1.DoSave( "${ctx}/DailyWorkMgr.do?cmd=saveDailyWorkMgr", $("#sheetForm").serialize()); break;

			break;
		case "Insert":
			sheet1.DataInsert(0) ;
			break;
		case "Copy":
			sheet1.SelectCell(sheet1.DataCopy(), 4);
			break;
		case "Clear":
			sheet1.RemoveAll();
			break;
		case "Down2Excel":
        	var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param);
        	break;

		case "LoadExcel":
			// 업로드
			var params = {};
			//var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet1.LoadExcel(params);

			break;

		case "DownTemplate":
			// 양식다운로드
			var sdowncols = "ymd|sabun|inHm|outHm";

			for (i=headerStartCnt; i<=sheet1.LastCol();i++){
				if (sheet1.GetColHidden(i) == 0 && sheet1.GetCellProperty(0, i, "InsertEdit") == 1) sdowncols += "|" + i.toString();
			}
			sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0|1", DownCols:sdowncols});
			break;
		}
	}


	//-----------------------------------------------------------------------------------
	//		sheet1 이벤트
	//-----------------------------------------------------------------------------------
	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}


			sheetResize();

			//console.time("searchend_test");
			//for(var Col = 0; Col <= sheet1.LastCol(); Col++) {
			//	if( sheet1.ColSaveName(Col).substring(0, 6) == "workCd" ) {
			//		sumWorkCd(sheet1.ColSaveName(Col));
			 //   }
			//}
			//console.timeEnd("searchend_test");

		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	
	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); }
			if( Code > -1 ) doAction1("Search");
		} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}


	function sheet1_OnChange(Row, Col, Value) {
		try{
			var colName = sheet1.ColSaveName(Col);
			if( sheet1.ColSaveName(Col).substring(0, 6) == "workCd" ) {
				//sumWorkCd(sheet1.ColSaveName(Col));
		    }
			if( sheet1.ColSaveName(Col) == "inHm" || sheet1.ColSaveName(Col) == "outHm") {
			    sheet1.SetCellValue(Row, "updateYn", "Y");
			    
				setSheetWorkTime(Row);
			}

		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}
	
	// 출퇴근 입력시, 기본근무.... 시간 set
	function setSheetWorkTime(Row){
		var param = "searchSabun=" + sheet1.GetCellValue(Row, "sabun")
		  + "&ymd=" + sheet1.GetCellValue(Row, "ymd")
		  + "&shm=" + sheet1.GetCellValue(Row, "inHm")
		  + "&ehm=" + sheet1.GetCellValue(Row, "outHm");

		var workTimeList = ajaxCall("${ctx}/DailyWorkMgr.do?cmd=getDailyWorkMgrTimeList", param, false);
		if (workTimeList != null && workTimeList.DATA != null) {
			var i = 0 ;
	        var sn1="", val1="", sn2="", val2=""; // 생산직 차감근무시간

			for(; i<workTimeList.DATA.length; i++) {
			    var obj = workTimeList.DATA[i];
				sheet1.SetCellValue(Row, obj.saveName, obj.colValue);
				
				//[벽산] 생산직 연장근무 4시간이 넘으면 0.5시간 차감.
				if( sheet1.GetCellValue(Row, "workType") == "B" ){

			        switch (obj.code) { 
			         case "0040": //연장근무
                     case "0075": //휴일연장근무
                         if( obj.colValue >= "0800" ){
                             val2 = "0100";
                         }else if( obj.colValue >= "0400" ){
                             val2 = "0030";
                         } 
			             break;
			             
                     case "0010": //기본근무
                     case "0070": //휴일기본근무
                         if( obj.colValue >= "0800" ){
                             val1 = "0100";
                         }

                     case "0210"://기본근무휴게
                         sn1 = obj.saveName;
                         break;
                     case "0215"://연장근무휴게
                         sn2 = obj.saveName;
                         break;
			        }   
				}
			}
            if( sn1 != "" ) {
                sheet1.SetCellValue(Row, sn1, val1, 0);
            }
	        if( sn2 != "" ) {
	            sheet1.SetCellValue(Row, sn2, val2, 0);
	        }
		}
	}


	// 기본근무 ~ .. 시간 sum
	function sumWorkCd(colName){
		var sumData = 0;
		var val     = 0;
		var hh, mm;
		// 시간계산해서 마지막 row에 set
		for (var i=sheet1.HeaderRows(); i<=sheet1.LastRow(); i++) {
			val = sheet1.GetCellValue(i, colName);
			if (val.length == 4){
				sumData += parseInt(val.substring(0, 2), 10) *60 + parseInt(val.substring(2, 4));
			}
		}
		hh = Math.floor(sumData/60);
		mm = (sumData - Math.floor(sumData/60) *60);
		sheet1.SetCellValue(sheet1.LastRow(), colName, hh.toString() + ((mm.toString().length<2)?":0":":") + mm.toString(), 0);
	}

	 //  Type이 POPUP인 셀에서 팝업버튼을 눌렀을때 발생하는 이벤트
    function sheet1_OnPopupClick(Row, Col){
		try{
			gPRow = Row;
			var colName = sheet1.ColSaveName(Col);
			var args    = new Array();
			var rv = null;
			if(colName == "name") {
				if(!isPopup()) {return;}

				popGubun = "insert";
				gPRow    = Row;
				var rv = openPopup("/Popup.do?cmd=employeePopup", args, "740","520");
			}
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
    }


	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

		if( popGubun == "O"){
			$("#searchOrgCd").val(rv["orgCd"]);
        	$("#searchOrgNm").val(rv["orgNm"]);
        	doAction1("Search");
        }else if( popGubun == "E"){
   			$('#name').val(rv["name"]);
   			$('#searchSabun').val(rv["sabun"]);
   	    	doAction1("Search");
        }else if ( popGubun == "insert"){
			sheet1.SetCellValue(gPRow, "sabun",			rv["sabun"] );
			sheet1.SetCellValue(gPRow, "name",			rv["name"] );
			sheet1.SetCellValue(gPRow, "orgNm",			rv["orgNm"] );
			sheet1.SetCellValue(gPRow, "alias",			rv["alias"] );
			sheet1.SetCellValue(gPRow, "jikgubNm",		rv["jikgubNm"] );
			sheet1.SetCellValue(gPRow, "jikweeNm",		rv["jikweeNm"] );
			sheet1.SetCellValue(gPRow, "jikchakNm",		rv["jikchakNm"] );
			sheet1.SetCellValue(gPRow, "manageNm",		rv["manageNm"] );
	        sheet1.SetCellValue(gPRow, "workTypeNm",	rv["workTypeNm"] );
	        sheet1.SetCellValue(gPRow, "payTypeNm",		rv["payTypeNm"] );
        }
	}

	// 소속 팝업
	function showOrgPopup() {
		if(!isPopup()) {return;}

		popGubun = "O";
        //var rst = openPopup("/Popup.do?cmd=orgBasicPopup&authPg=R", "", "740","520");
        let layerModal = new window.top.document.LayerModal({
            id : 'orgLayer'
            , url : '/Popup.do?cmd=viewOrgBasicLayer&authPg=R'
            , parameters : {}
            , width : 740
            , height : 520
            , title : '<tit:txt mid='orgSchList' mdef='조직 리스트 조회'/>'
            , trigger :[
                {
                    name : 'orgTrigger'
                    , callback : function(result){
                        if(!result.length) return;
                        $("#searchOrgCd").val(result[0].orgCd);
                        $("#searchOrgNm").val(result[0].orgNm);
                    }
                }
            ]
        });
        layerModal.show();
	}

	// 사원 팝업
	function showEmployeePopup() {
		if(!isPopup()) {return;}

		popGubun = "E";
        var rst = openPopup("/Popup.do?cmd=employeePopup&authPg=R", "", "740","520");
	}

	function clearCode(num) {

		if(num == 1) {
			$("#searchOrgCd").val("");
			$("#searchOrgNm").val("");
		} else {
			$('#name').val("");
		}
	}
    
	function openHeplPop(){
	    var itop = $("#helpImg").offset().top+20;
        var ileft = $("#helpImg").offset().left-300-5;
        $("#heplPop").css("left", ileft).css("top", itop).show();
	}
</script>
<style type="text/css">
#heplPop { position:absolute;width:300px;height:auto;padding:10px; background-color:#FFF5C8;border:1px solid #b1b1b1;z-index:31;display:none;}
#heplPop .close {position:absolute; top:-1px; right:-1px; width:15px; height:18px; border:1px solid #b1b1b1;text-align:center;vertical-align:middle; cursor: pointer;}
#heplPop .title { padding-bottom:5px;; border-bottom:1px solid #b1b1b1; font-weight: bold;}
#heplPop .body { padding-top:5px;}
</style>

</head>
<body class="hidden">
<!----------------------------------------------------------------------------------------------------------->
<div id="heplPop" style="display:none;">
    <div class="close"><a href="javascript:$('#heplPop').hide();">X</a></div>
    <div class="title">[ 근무시간 입력 시 주의사항 ] </div>
    <hr>
    <div class="body">
        <ul>
            <li>-. 근무시간 직접 수정 시 생산직의 기본근무휴게, 연장근무휴게 시간은 자동 발생되지 않으므로 직접 값을 넣어 저장 해주세요.  </li>
            <li>-. 생산직 4시간 연장근무 시 0.5시간 연장근무휴게 발생 </li>
        </ul>
    </div>            
</div>
<!----------------------------------------------------------------------------------------------------------->
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
		<input id="defaultRow" name="defaultRow" type="hidden" >
		<div class="sheet_search outer">
			<table>
				<tr>
					<th><tit:txt mid='104060' mdef='근무일'/></th>
					<td>
						<input type="text" id="searchSymd" name="searchSymd" class="date2 required center" /> ~
						<input type="text" id="searchEymd" name="searchEymd" class="date2 required center" />
					</td>
					<th class="hide"><tit:txt mid='104281' mdef='근무지'/></th>
					<td class="hide">
						<select id="searchLocationCd" name="searchLocationCd"> </select>
					</td>	 
					<th><tit:txt mid='114399' mdef='사업장'/></th>
					<td>
						<select id="searchBizPlaceCd" name="searchBizPlaceCd" > </select>
					</td>
					<th>근무그룹</th>
					<td>
						<select id="searchWorkGrpCd" name="searchWorkGrpCd" > </select>
					</td>
					<!-- td>
						<span><tit:txt mid='2017082900933' mdef='휴일제외'/></span>
						<input id="searchHolyday" name="searchHolyday" type="checkbox" class="checkbox" value="Y" />
					</td -->
				</tr>
				<tr>
					<th>직급</th>
					<td>
						<select id="searchJikgubCd" name="searchJikgubCd" > </select>
					</td>
					<th><tit:txt mid='103784' mdef='사원구분'/></th>
					<td>
						<select id="searchManageCd" name="searchManageCd" > </select>
					</td>
					<th>직군</th>
					<td>
						<select id="searchWorkType" name="searchWorkType" > </select>
					</td>
					<th><tit:txt mid='2017082900947' mdef='TimeCard누락'/></th>
					<td>
						<input type="checkbox" id="searchTimeCheck" name="searchTimeCheck" class="checkbox" value="Y" />
					</td>
					<th><tit:txt mid='2017082900948' mdef='일근무제외자 제외'/></th>
					<td>
						<input type="checkbox" id="searchNotWorkerCheck" name="searchNotWorkerCheck" class="checkbox" value="Y" />
					</td>
				</tr>	
				<tr>
					<th><tit:txt mid='104279' mdef='소속'/></th>
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
						<input id="searchOrgType" name="searchOrgType" type="checkbox" class="checkbox" value="Y" checked/><tit:txt mid='112471' mdef='하위포함'/>
					</td>
					<th><tit:txt mid='104330' mdef='사번/성명'/></th>
					<td>
						<input type="text" id="searchSabunName" name="searchSabunName" class="text w100" style="ime-mode:active;" />
						<!-- input type="text" id="searchSabun" name="searchSabun" class="text" />
						<input id="name"  name="name"  type="text" class="text readonly" readonly/><a href="javascript:showEmployeePopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a -->
					</td>
					<th><tit:txt mid='2017082900949' mdef='지각여부'/></th>
					<td>
						<input type="checkbox" id="searchLateCheck" name="searchLateCheck" class="checkbox" value="Y"/>
					</td>
					<th>근태제외</th>
					<td>
						<input type="checkbox" id="searchNotGntCdCheck" name="searchNotGntCdCheck" class="checkbox" value="Y" />
					</td>
					<!-- td> <span><tit:txt mid='113330' mdef='급여유형'/></span> <select id="payType" name="payType" multiple=""> </select> </td -->
					<td colspan="2"><btn:a href="javascript:doAction1('Search');" css="btn dark" mid='search' mdef="조회"/> </td>
				</tr>
			</table>
		</div>
	</form>

	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li class="txt"><tit:txt mid='2017082900950' mdef='일근무관리'/></li>
				<li class="btn">
				    <!-- <a href="javascript:openHeplPop()" class="button7"><img src="/common/images/icon/icon_quest.png" id="helpImg"/></a> -->
					<btn:a href="javascript:doAction1('Down2Excel');" 	css="btn outline-gray authR" mid="download" mdef="다운로드"/>
					<btn:a href="javascript:doAction1('DownTemplate')" 	css="btn outline-gray authA" mid="down2ExcelV1" mdef="양식다운로드"/>
					<btn:a href="javascript:doAction1('LoadExcel')" 	css="btn outline-gray authA" mid="upload" mdef="업로드"/>
					<btn:a href="javascript:doAction1('Copy')" 			css="btn outline-gray authA" mid="copy" mdef="복사"/>
					<btn:a href="javascript:doAction1('Insert')" 		css="btn outline-gray authA" mid="insert" mdef="입력"/>
					<btn:a href="javascript:doAction1('Save');"       	css="btn filled authA" mid="save" mdef="저장"/>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>