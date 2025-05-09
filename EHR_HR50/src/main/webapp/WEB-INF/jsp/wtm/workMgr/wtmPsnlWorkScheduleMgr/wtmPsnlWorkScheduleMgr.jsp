<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>개인근무스케쥴관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";

var SEARCHED_DAY = new Array(35);
var MAX_MONTH = 0 ;//해당월의 마지막일자
var END_YN = "" ;//해당월의 마감여부
var locationCdList = "";
var timeCdList;

	$(function() {	

        $("#searchYm").datepicker2({
        	ymonly:true,
        	onReturn:function(date){
				getWorkGrpCd();
        		progressBar(true);// show progress
        		setTimeout(function(){searchTitleList1();}, 100);
        		//doAction1("Search");
   			}
        });
		$("#searchYm").val("${curSysYyyyMMHyphen}") ;//현재년월 세팅
		
		$("#searchSabunName").on("keyup", function(event) {

			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

		//var payTypeList = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&useYn=Y","H10110"), "");
		var payTypeList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getWtmPsnlWorkScheduleMgrPayType",false).codeList, ""); //사업장
		$("#searchPayType").html(payTypeList[2]);
 		$("#searchPayType").bind("change", function(){
 	        //sheet1 헤더 생성
 	        searchTitleList1();
 		});
		
		//근무조그룹
		getWorkGrpCd();
		$("#searchWorkClassCd").bind("change", function(){
			//근무조그룹에 따라 콤보 변경
			<%--var param = "queryId=getTimWorkTeamCodeList&searchWorkGrpCd="+$("#searchWorkGrpCd").val();--%>
			<%--var workOrgCdList    = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",param,false).codeList, "전체");--%>

			const param = "&searchWorkClassCd="+$("#searchWorkClassCd").val()
			const workGroupCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getWtmWorkGroupCdComboList"+param,false).codeList, "전체");
			$("#searchWorkGroupCd").html(workGroupCdList[2]);
    		// $("#searchWorkOrgCd").html( workGroupCdList[2] ) ;

			const param2 = "queryId=getWorkSchCdList&searchWorkClassCd="+$("#searchWorkClassCd").val();
			timeCdList    = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",param2,false).codeList, "");


		}).change();
		
		
		
		//시트 init
		init_sheet();
		
		//sheet1 헤더 생성
		searchTitleList1();
		
		//toggleSheet();
		
		/*  아래 조건 사용하면 주석 풀 것
		//사업장코드 관리자권한만 전체사업장 보이도록, 그외는 권한사업장만.
		var url     = "queryId=getBusinessPlaceCdList";
		var allFlag = true;
		if ("${ssnSearchType}" != "A"){
			url    += "&searchChkPlace=Y&sabun=${ssnSabun}&grpCd=${ssnGrpCd}";
			allFlag = false;
		}		
		var businessPlaceCd = "";
		if(allFlag) {
			businessPlaceCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, ("${ssnLocaleCd}" != "en_US" ? "전체" : "All"));	//사업장	
		} else {
			businessPlaceCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, "");	//사업장
		}
		$("#searchBizPlaceCd").html(businessPlaceCd[2]);

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
		*/
		

		
	});

    function getWorkGrpCd() {
		let searchYm = $("#searchYm").val();
		let baseSYmd = "";
		let baseEYmd = "";

		if (searchYm !== "") {
			baseSYmd = searchYm + "-01";
			baseEYmd = getLastDayOfMonth(searchYm);
		}

		<%--var searchWorkGrpCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&useYn=Y","T11020", baseSYmd, baseEYmd), "");--%>
		<%--$("#searchWorkGrpCd").html(searchWorkGrpCdList[2]);--%>

		const param = "&searchSdate="+$("#searchYm").val()+'-01'
				+"&searchEdate="+$("#searchYm").val()+'-31'
				+"&searchWorkTypeCd=D"
				+"&searchUseYn=Y"
		const workClassCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getWtmWorkClassCdComboList"+param,false).codeList, "");
		$("#searchWorkClassCd").html(workClassCdList[2]);
	}

	function getLastDayOfMonth(yearMonth) {
		const [year, month] = yearMonth.split('-').map(Number);
		const lastDate = new Date(year, month, 0);

		const yearStr = lastDate.getFullYear().toString();
		const monthStr = (lastDate.getMonth() + 1).toString().padStart(2, '0');
		const dayStr = lastDate.getDate().toString().padStart(2, '0');

		return yearStr + '-' + monthStr + '-' + dayStr;
	}

	function init_sheet(){ 
		var initdata = {};
		//Sheet1  개인근무스케줄관리
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22, FrozenCol:0, MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
             {Header:"<sht:txt mid='sNoV3' mdef='No|No|No'/>",					Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),   Width:Number("${sNoWdt}"),  Align:"Center", ColMerge:0,   SaveName:"sNo" },
             {Header:"<sht:txt mid='sDelete_V3071' mdef='삭제|삭제|삭제'/>",       	Type:"${sDelTy}",   Hidden:1,  Width:Number("${sDelWdt}"), Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
             {Header:"<sht:txt mid='sStatus_V3164' mdef='상태|상태|상태'/>",       	Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),  Width:Number("${sSttWdt}"), Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
             {Header:"<sht:txt mid='orgNmV23' mdef='소속|소속|소속'/>",  			Type:"Text",		Hidden:0,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"",	   KeyField:1,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
             {Header:"<sht:txt mid='sabunV18' mdef='사번|사번|사번'/>",  			Type:"Text",		Hidden:0,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"",	   KeyField:1,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
             {Header:"<sht:txt mid='nameV18' mdef='성명|성명|성명'/>",  			Type:"Text",		Hidden:0,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"",	   KeyField:1,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
             {Header:"<sht:txt mid='jikweeNm' mdef='직위|직위|직위'/>",  			Type:"Text",		Hidden:Number("${jwHdn}"),  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"",	   KeyField:1,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
             {Header:"<sht:txt mid='jikgubNmV9' mdef='직급|직급|직급'/>",  			Type:"Text",		Hidden:Number("${jgHdn}"),  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"",	   KeyField:1,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
         ] ; IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(4);

       	//Sheet2 저장 테이블
 		initdata = {};
      	initdata.Cfg = {SearchMode:smLazyLoad,Page:22, FrozenCol:0, MergeSheet:msNone};
 		initdata.HeaderMode = {Sort:0,ColMove:0,ColResize:0,HeaderCheck:0};
 		initdata.Cols = [
              {Header:"상태",       	Type:"${sSttTy}",   Hidden:0,  Width:45,   Align:"Center", SaveName:"sStatus"},
              {Header:"flag",  		Type:"Text",		Hidden:0,  Width:80,   Align:"Center", SaveName:"flag"},
              {Header:"사번",  		Type:"Text",		Hidden:0,  Width:80,   Align:"Center", SaveName:"sabun"},
              {Header:"근무일자",  	Type:"Text",		Hidden:0,  Width:80,   Align:"Center", SaveName:"ymd"},
              {Header:"근무코드",  	Type:"Text",		Hidden:0,  Width:80,   Align:"Center", SaveName:"workCd"},
              {Header:"근무조",  		Type:"Text",		Hidden:0,  Width:80,   Align:"Center", SaveName:"workGroupCd"},
              {Header:"요청시간",  	Type:"Text",		Hidden:0,  Width:80,   Align:"Center", SaveName:"requestHour"},
              {Header:"인정시간",  	Type:"Int",			Hidden:0,  Width:80,   Align:"Center", SaveName:"applyHour" }
          ] ; IBS_InitSheet(sheet2, initdata);
 
        //Sheet3 근무시간상세
		initdata = {};
   		initdata.Cfg = {SearchMode:smLazyLoad,Page:22, FrozenCol:0, MergeSheet:msHeaderOnly};
   		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1};
   		initdata.Cols = [
                {Header:"<sht:txt mid='2017082900898' mdef='근무'/>",			Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),   Width:100,  Align:"Center", ColMerge:0,   SaveName:"sNo" }
           ] ; IBS_InitSheet(sheet3, initdata); sheet3.SetCountPosition(0);

		sheetInit(); //시트 리사이즈 안함.
	}

	

	//---------------------------------------------------------------------------------------------------------------
	// sheet1 HEADER LIST
	//---------------------------------------------------------------------------------------------------------------
	function searchTitleList1() {


		/* 해당월에 대한 근태 마감여부를 판단, 화면 컨트롤을 조정함 */
		var endData = ajaxCall("${ctx}/WtmPsnlWorkScheduleMgr.do?cmd=getWtmPsnlWorkScheduleMgrEndYn", $("#sheetForm").serialize(), false);

		if (endData != null && endData.DATA != null && endData.DATA.length > 0) {
			END_YN = endData.DATA[0].endYn ;
		} else {
			END_YN = "" ;
		}
		

		var titleList = ajaxCall("${ctx}/WtmPsnlWorkScheduleMgr.do?cmd=getWtmPsnlWorkScheduleMgrHeaderList", $("#sheetForm").serialize(), false);
		if (titleList != null && titleList.DATA != null) {

			sheet1.Reset();

			var v=0;
			var def_cols_cnt = 0;
			var initdata1 = {};
			initdata1.Cfg = {SearchMode:smLazyLoad, Page:22, MergeSheet:msNone, FrozenCol:7};
			initdata1.HeaderMode = {Sort:1, ColMove:0, ColResize:1, HeaderCheck:0};

			initdata1.Cols = [];
			initdata1.Cols[v++]  = {Header:"No|No|No",				Type:"${sNoTy}",	Hidden:0,  Width:45,  Align:"Center", ColMerge:0,   SaveName:"sNo" };
			initdata1.Cols[v++]  = {Header:"삭제|삭제|삭제",			Type:"${sDelTy}",	Hidden:1,  Width:45,  Align:"Center", ColMerge:0,   SaveName:"sDelete",     Sort:0};
			initdata1.Cols[v++]  = {Header:"상태|상태|상태",			Type:"${sSttTy}",	Hidden:0,  Width:45,  Align:"Center", ColMerge:0,   SaveName:"sStatus",     Sort:0};
			initdata1.Cols[v++]  = {Header:"근무조그룹|근무조그룹|근무조그룹", Type:"Text",		Hidden:1,  Width:100, Align:"Center", ColMerge:1,   SaveName:"workGrpCd",	KeyField:0,  Format:"", UpdateEdit:0,   InsertEdit:0 };
			initdata1.Cols[v++]  = {Header:"근무조코드|근무조코드|근무조코드",		Type:"Text",		Hidden:1,  Width:100, Align:"Left",   ColMerge:1,   SaveName:"workGroupCd",	KeyField:0,  Format:"", UpdateEdit:0,   InsertEdit:0 };
			initdata1.Cols[v++]  = {Header:"근무조|근무조|근무조",		Type:"Text",		Hidden:0,  Width:100, Align:"Left",   ColMerge:1,   SaveName:"workGroupNm",	KeyField:0,  Format:"", UpdateEdit:0,   InsertEdit:0 };
			initdata1.Cols[v++]  = {Header:"근무지|근무지|근무지",		Type:"Text",		Hidden:1,  Width:100, Align:"Center", ColMerge:1,	SaveName:"locationNm",	KeyField:0,	 Format:"", UpdateEdit:0,	InsertEdit:0 };
			initdata1.Cols[v++]  = {Header:"소속|소속|소속",			Type:"Text",		Hidden:0,  Width:80,  Align:"Center", ColMerge:1,   SaveName:"orgNm",		KeyField:0,  Format:"", UpdateEdit:0,   InsertEdit:0 };
			initdata1.Cols[v++]  = {Header:"사번|사번|사번",  			Type:"Text",		Hidden:0,  Width:65,  Align:"Center", ColMerge:1,   SaveName:"sabun",	   	KeyField:0,  Format:"", UpdateEdit:0,   InsertEdit:0 };
			initdata1.Cols[v++]  = {Header:"성명|성명|성명",  			Type:"Text",		Hidden:0,  Width:65,  Align:"Center", ColMerge:1,   SaveName:"name",	   	KeyField:0,  Format:"", UpdateEdit:0,   InsertEdit:0 };
			initdata1.Cols[v++]  = {Header:"직위|직위|직위",  			Type:"Text",		Hidden:"${jwHdn}",  Width:60,  Align:"Center", ColMerge:1,   SaveName:"jikweeNm",	KeyField:0,  Format:"", UpdateEdit:0,   InsertEdit:0 };
			initdata1.Cols[v++]  = {Header:"직급|직급|직급",  			Type:"Text",		Hidden:"${jgHdn}",  Width:60,  Align:"Center", ColMerge:1,   SaveName:"jikgubNm",	KeyField:0,  Format:"", UpdateEdit:0,   InsertEdit:0 };
			initdata1.Cols[v++]  = {Header:"사원구분|사원구분|사원구분",	Type:"Text",		Hidden:0,  Width:80,  Align:"Center", ColMerge:1,   SaveName:"manageNm",	KeyField:0,  Format:"", UpdateEdit:0,   InsertEdit:0 };
			initdata1.Cols[v++]  = {Header:"급여유형|급여유형|급여유형",	Type:"Text",		Hidden:1,  Width:80,  Align:"Center", ColMerge:1,   SaveName:"payTypeNm",	KeyField:0,  Format:"", UpdateEdit:0,   InsertEdit:0 };
			
			def_cols_cnt = v;

			var i = 0 ;
			var oldYmColCnt = 0;
			var oldYm = "";
			for(; i<titleList.DATA.length; i++) {
				if(i==0){
					$("#stdYm").val(titleList.DATA[i].yyyyMm.substr(0,4) + titleList.DATA[i].yyyyMm.substr(5,7)) ;
					oldYm = titleList.DATA[i].yyyyMm;
					$("#saveSymd").val(titleList.DATA[i].sunDate);
				}
				if( oldYm != titleList.DATA[i].yyyyMm ){
					oldYmColCnt = i*2;
					oldYm = titleList.DATA[i].yyyyMm;
				}
				SEARCHED_DAY[i] = titleList.DATA[i].day ;

				initdata1.Cols[v++] = {Header:titleList.DATA[i].yyyyMm+"|"+titleList.DATA[i].day+"|"+titleList.DATA[i].dayTitle,	Type:"Combo",	Hidden:0,	Width:55,	Align:"Center",	ColMerge:1,	SaveName:titleList.DATA[i].saveName,		KeyField:1,	Format:"",	UpdateEdit:1,	InsertEdit:1 };
				initdata1.Cols[v++] = {Header:titleList.DATA[i].yyyyMm+"|"+titleList.DATA[i].day+"|"+titleList.DATA[i].dayTitle,	Type:"Text",	Hidden:1,	Width:55,	Align:"Center",	ColMerge:1,	SaveName:titleList.DATA[i].colorSaveName,	KeyField:0,	Format:"",	UpdateEdit:0,	InsertEdit:0 };
			}
			$("#saveEymd").val(titleList.DATA[titleList.DATA.length-1].sunDate);

			//해당월의 마지막일자를 가짐
			MAX_MONTH = i ;

			IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(4);

			if(END_YN == "Y") {
				sheet1.SetEditable(0);
			} else {
				sheet1.SetEditable("${editable}");
			}
			
			/* 콤보값 설정 */ 
			setTimeCdCombo();

			//Row Col row개수 col개수 - 헤더머지세팅 : 이 방식은 자동 데이터 머지가 안됩니다. by JSG
			
			for(var x = 0; x < def_cols_cnt ; x++) {
				sheet1.SetMergeCell(0, x, 3, 1);
			}


			if(oldYmColCnt == 0) {
				sheet1.SetMergeCell(0, def_cols_cnt, 1, (i*2)); // 년월
			}else {
				sheet1.SetMergeCell(0, def_cols_cnt, 1, oldYmColCnt); // 년월
				sheet1.SetMergeCell(0, def_cols_cnt+oldYmColCnt, 1, (i*2)-oldYmColCnt); // 년월
			}


			//sheet1.SetMergeCell(0, 9, 1, i); // 년월
			
			progressBar(false); // hide progress
		}
	}
	//근무시간 콤보 셋팅
	function setTimeCdCombo() {

		for(var col = 0; col <= sheet1.LastCol(); col++) {

			var colName = sheet1.ColSaveName(col);

			if ( colName.substring(0, 2) == "sn") {
				sheet1.SetColProperty(colName, 		{ComboText:"|"+timeCdList[0], ComboCode:"|"+timeCdList[1]} );
			}
		} 
	}
	
	//Sheet Action
	function doAction1(sAction) {
		if( !YmCheck() ) return ;//근무년월 입력 여부 체크
		
		switch (sAction) {
		case "Search":
			searchTitleList1();
			setTimeCdCombo();
			sheet1.DoSearch( "${ctx}/WtmPsnlWorkScheduleMgr.do?cmd=getWtmPsnlWorkScheduleMgrList", $("#sheetForm").serialize() );
			break;
		case "Save":
			setTTIM120Table();
			//if(!dupChk(sheet1,"jikweeCd|leaderYn|careerYn|sdate", false, true)){break;}
			//sheet1.DoSave( "${ctx}/WtmPsnlWorkScheduleMgr.do?cmd=saveWtmPsnlWorkScheduleMgr");
			break;
        case "Down2Excel":
        	var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param); break;
			/* 사용안함.
		case "Insert":
			if(!isPopup()) {return;}

			var newRow = sheet1.DataInsert(0) ;
			sheet1.SetCellValue(newRow, "workOrgCd", $("#searchWorkOrgCd").val()) ;
			var args    = new Array();
         	var rv = null;
            var rv = openPopup("/Popup.do?cmd=employeePopup", args, "740","520");
            popGubun = "insert";
			break;
		case "Copy":
			sheet1.SelectCell(sheet1.DataCopy(), 4);
			break;
		case "Clear":		sheet1.RemoveAll(); break;
		*/
		case "LoadExcel":
			// 업로드
			var params = {};
			sheet1.LoadExcel(params);
			break;
		case "DownTemplate":
			// 양식다운로드
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownRows:"0|1|2", DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param); break;
			// sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0|1", DownCols:"4|5|7|8|9|10|12|15|17|19|21|23|25|27|29|31|33|35|37|39|41|43|45|47|49|51|53|55|57|59|61|63|65|67|69|71|73|75"});
			break;
		}
	}

	//Sheet Action
	function doAction2(sAction) {
		if( !YmCheck() ) return ;//근무년월 입력 여부 체크
		
		switch (sAction) {
		case "Search":
			break;
		case "Save":
			IBS_SaveName(document.sheetForm,sheet2);
			sheet2.DoSave( "${ctx}/WtmPsnlWorkScheduleMgr.do?cmd=saveWtmPsnlWorkScheduleMgr", $("#sheetForm").serialize()); break;
			break;
		}
	}


	function doAction3(sAction) {
		switch (sAction) {
		case "Search":

			$("#spanTimeNm").html(" ");
			try{
				var timeCd = sheet1.GetCellValue(sheet1.GetSelectRow(), sheet1.GetSelectCol());
				var ymd    = sheet1.ColSaveName(sheet1.GetSelectCol()).replace("sn","");
	
				var param   = "ymd="+ymd+"&timeCd="+timeCd;
				
				$("#spanTimeNm").html(" : "+sheet1.GetCellText(sheet1.GetSelectRow(), sheet1.GetSelectCol()));
	
				searchTitleList3(param);
				sheet3.DoSearch( "${ctx}/WtmPsnlWorkScheduleMgr.do?cmd=getWtmPsnlWorkScheduleMgrDayWorkList", param );
			}catch(e){}
			break;
		case "Clear":
			sheet3.RemoveAll();
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
			doAction2("Clear") ;
			doAction3("Clear") ;
			//sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { 
			if (Msg != "") { 
				alert(Msg); 
			} 
			if( Code > -1 ) doAction1("Search"); 
		} catch (ex) { 
			alert("OnSaveEnd Event Error " + ex); 
		}
	}


	function sheet1_OnChange(Row, Col, Value) {
		try{
			if( $("#toggleBtn").attr("data-toggle") === "on" ){
				if( sheet1.ColSaveName(Col).substring(0, 2) == "sn" ) {
					doAction3("Search");
			    }
			}
		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}

	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol,isDelete) {
		try{
			if( $("#toggleBtn").attr("data-toggle") === "on" ){
				if (OldRow != NewRow || OldCol != NewCol){
					if( sheet1.ColSaveName(NewCol).substring(0, 2) == "sn" ) {
						doAction3("Search");
					}
			    }
			}
		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}

	//---------------------------------------------------------------------------------------------------------------
	// sheet2 Event
	//---------------------------------------------------------------------------------------------------------------
	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); }
			if( Code > -1 ) doAction1("Search"); 

		} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
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

			for (var i=2; i<=sheet3.LastRow(); i++){
				for(var j=0; j<=sheet3.LastCol(); j++){
					if( sheet3.ColSaveName(j).substring(0, 2) == "sn" && sheet3.GetCellValue(i, j) != "") {
						sheet3.SetCellBackColor(i, j, sheet3.GetCellValue(i, "rgbCd"));
						sheet3.SetCellValue(i, j, "");
					}
				}
			}
			//sheetResize();
			sheet3.FitColWidth();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}


	//---------------------------------------------------------------------------------------------------------------
	// setTTIM120Table
	//---------------------------------------------------------------------------------------------------------------
	/*TTIM120에 인서트하기 위함*/
	function setTTIM120Table() {

		sheet2.RemoveAll();

		var colName = "";


		var updRows = sheet1.FindStatusRow("I|U"); 
		var arr = updRows.split(";");
		for( var idx = 0; idx < arr.length; idx++){
			var i= arr[idx];
			// 매 사번의 마지막 row는 P_TIM_WORK_HOUR_CHG_OSSTEM 프로시져를 호출하기 위함. 실제 데이터 저장시는 제외해야함
			var sheet2Row = sheet2.DataInsert(0) ;
			sheet2.SetCellValue( sheet2Row, "flag",      "callPro"                 ) ;
			sheet2.SetCellValue( sheet2Row, "sabun",     sheet1.GetCellValue(i, "sabun" )     ) ;
			//sheet2.SetCellValue( sheet2Row, "symd",      $("#saveSymd").val() ) ;
			//sheet2.SetCellValue( sheet2Row, "eymd",      $("#saveEymd").val() ) ;

			//해당월에 대하여 1일부터 말일까지 돌면서 데이터들을 체크함
			for(var col = 0; col <= sheet1.LastCol(); col++) {

				colName = sheet1.ColSaveName(col);

				if ( colName.substring(0, 2) == "sn") {

					if( sheet1.GetCellValue( i, colName ) == "") {
						/* 2015.01.12 막음. 필수 체크 안함
						alert("사번 및 각 일자에 해당하는 데이터는 필수항목 입니다.\n해당 필수항목을 입력하여 주시기 바랍니다.") ;
						doAction2("Clear") ;
						return ;
						*/
					} else {
						if (sheet1.GetCellValue(i, colName) != sheet1.CellSearchValue(i, colName)) {
							var sheet2Row = sheet2.DataInsert(0) ;
							sheet2.SetCellValue( sheet2Row, "flag",      "merge"                 ) ;
							sheet2.SetCellValue( sheet2Row, "sabun",     sheet1.GetCellValue(i, "sabun" )     ) ;
							sheet2.SetCellValue( sheet2Row, "ymd",       colName.substring(2)                 ) ;
							sheet2.SetCellValue( sheet2Row, "workOrgCd", sheet1.GetCellValue(i, "workOrgCd" ) ) ;
							sheet2.SetCellValue( sheet2Row, "workCd",    sheet1.GetCellValue(i, colName)      ) ;
						}

					}
				}
			}
			
		}
		/*sheet2에 데이터 작업 완료후 저장!*/
		doAction2('Save') ;
	}


	//---------------------------------------------------------------------------------------------------------------
	// setSubCountSum
	//---------------------------------------------------------------------------------------------------------------
	/* 해당 로우에 대하여 -D N OFF 휴일 출장- 들을 카운트하여 소계필드에 넣음 */
	function setSubCountSum(Row) {
		var subD = 0 ;
		var subN = 0 ;
		var subOff = 0 ;
		var subH = 0 ;
		var subC = 0 ;
		for(var i = 12; i < MAX_MONTH+12; i++) {
			/* 각 로우별 근무종류별 카운트 */
			sheet1.GetCellValue( Row, i ) == "200" ? subD++ : "" ;
			sheet1.GetCellValue( Row, i ) == "210" ? subN++ : "" ;
			sheet1.GetCellValue( Row, i ) == "220" ? subOff++ : "" ;
			sheet1.GetCellValue( Row, i ) == "230" ? subH++ : "" ;
			//sheet1.GetCellValue( Row, i ).substr(0,2) == "B_" ? subC++ : "" ;
			if(sheet1.GetCellValue( Row, i ) >= 0 && sheet1.GetCellValue( Row, i ).indexOf("B_") == 0) {
				subC++;
			}

			/* 각 로우의 셀별 색상 입히기 */
			if (colorData != null && colorData.DATA != null) {
				for(var j = 0; j < colorData.DATA.length; j++) {
					if( colorData.DATA[j].workCd == sheet1.GetCellValue( Row, i ) ) {
						sheet1.SetCellBackColor(Row, i, colorData.DATA[j].color);
						break ;
					}
				}
			}
		}
		sheet1.SetCellValue( Row, "subD", subD ) ;
		sheet1.SetCellValue( Row, "subN", subN ) ;
		sheet1.SetCellValue( Row, "subOff" ) ;
		sheet1.SetCellValue( Row, "subH", subH ) ;
		sheet1.SetCellValue( Row, "subC", subC ) ;
		//sheet1.SetCellValue( Row, "sStatus", "R") ;
	}

	//---------------------------------------------------------------------------------------------------------------
	// SETTING HEADER LIST
	//---------------------------------------------------------------------------------------------------------------
	function searchTitleList3(param) {
		var titleList = ajaxCall("${ctx}/WtmPsnlWorkScheduleMgr.do?cmd=getWtmPsnlWorkScheduleMgrDayWorkHeaderList", param, false);
		if (titleList != null && titleList.DATA != null) {

			sheet3.Reset();

			var initdata3 = {};
			initdata3.Cfg = {SearchMode:smLazyLoad, Page:22, FrozenCol:2, MergeSheet:msHeaderOnly};
			initdata3.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};

			initdata3.Cols = [];
			initdata3.Cols.push({Header:"color|color",	Type:"Text",    Hidden:1,   Width:0,	Align:"Center", ColMerge:0,   SaveName:"rgbCd" });
			initdata3.Cols.push({Header:"근무|근무",		Type:"Text",    Hidden:0,   Width:80,	Align:"Center", ColMerge:0,   SaveName:"workText",	UpdateEdit:0 });

			for (const titleInfo of titleList.DATA) {
				initdata3.Cols.push({Header:titleInfo.hhText+"|"+titleInfo.mm,	Type:"Text",	Hidden:0,	Width:45,	Align:"Center",	ColMerge:1,	SaveName:titleInfo.colName,	KeyField:0,	Focus:0, Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 });
			}

			IBS_InitSheet(sheet3, initdata3);

			sheet3.SetSelectionMode(0);
			sheet3.SetCountPosition(0);

		}
	}
	
	//  팝업
	function showOrgLayer() {

		new window.top.document.LayerModal({
			id : 'orgLayer'
			, url : '/Popup.do?cmd=viewOrgBasicLayer&authPg=R'
			, parameters : {
			}
			, width : 840
			, height : 800
			, title : '조직 리스트 조회'
			, trigger :[
				{
					name : 'orgTrigger'
					, callback : function(result){
						$("#searchOrgCd").val(result[0].orgCd);
						$("#searchOrgNm").val(result[0].orgNm);
					}
				}
			]
		}).show();
	}
	
	function clearCode(num){
		if(num == 1) {
			$("#searchOrgCd").val("");
			$("#searchOrgNm").val("");
		}else{
			$("#searchSabun").val("");
			$("#searchName").val("");
		}
	}


	//---------------------------------------------------------------------------------------------------------------
	// 근무시간 보기/감추기
	//---------------------------------------------------------------------------------------------------------------
	function toggleSheet() {

		if( $("#toggleBtn").attr("data-toggle") === "on" ) {
			hideSheet();
		} else {
			showSheet();
		}
	}
	function showSheet() {
		$("#toggleBtn").attr("data-toggle", "on");
		$("#toggleBtn").text("<tit:txt mid='2017082900900' mdef='근무시간 감추기'/>");

		$("#gap").addClass("outer");
		$("#gap").show();
		doAction3("Search");
		fnSheetHeightResize();
	}
	function hideSheet() {
		$("#toggleBtn").attr("data-toggle", "off");
		$("#toggleBtn").text("<tit:txt mid='2017082900902' mdef='근무시간 보기'/>");

		$("#gap").removeClass("outer");
		$("#gap").hide();
		fnSheetHeightResize();
	}
	// 시트 리사이즈
	function fnSheetHeightResize() {
	    var outer_height = getOuterHeight();
	    var inner_height = 0;
	    var value = 0;

	    $(".ibsheet").each(function() {
	        inner_height = getInnerHeight($(this));
	        if ($(this).attr("fixed") == "false") {
	            value = parseInt(($(window).height() - outer_height) / $(this).attr("sheet_count") - inner_height);
	            if (value < 100) value = 100;
	            $(this).height(value);
	        }
	    });
	}


	function YmCheck(){
		var rtnValue = ''
		var ym = $("#searchYm").val();
		//alert(ym)
		if (ym == '' || ym == null){
			alert("근무년월을 입력해 주시기 바랍니다.");
			rtnValue = false;
		}else{
			rtnValue = true;
		}
		return rtnValue;
	}
	
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
		<input type="hidden" id="stdYm" name="stdYm" class="" />
		<input type="hidden" id="saveSymd" name="saveSymd" class="" />
		<input type="hidden" id="saveEymd" name="saveEymd" class="" />
		
	    <input type="hidden" id="searchType" name="searchType" value="${ssnSearchType}"/>
		<div class="sheet_search outer">
			<table>
				<tr>
					<th>근무년월</th>
					<td>
						<input type="text" id="searchYm" name="searchYm" class="date2 w60" readonly/>
					</td>
					<th>근무그룹</th> 
					<td>
						<select id="searchWorkClassCd" name="searchWorkClassCd" > </select>
					</td>
					<th>근무조</th> 
					<td>
						 <select id="searchWorkGroupCd" name="searchWorkGroupCd" > </select>
					</td>
<%--					<th>급여유형 (근무기준일)</th>--%>
<%--					<td>--%>
<%--						<select id="searchPayType" name="searchPayType">--%>
<%--						</select>--%>
<%--					</td>--%>
					<!-- 
					<td>
						<span><tit:txt mid='104281' mdef='근무지'/></span>
						<select id="searchLocationCd" name="searchLocationCd"> </select>
						<span><tit:txt mid='114399' mdef='사업장'/></span>
						<select id="searchBizPlaceCd" name="searchBizPlaceCd" > </select>
					</td>
					 -->
				</tr>
				<tr>
					<th><tit:txt mid='104279' mdef='소속'/> </th>
					<td>
						<c:choose>
						<c:when test="${ssnSearchType == 'A' || searchFlag == 'A'}">
							<input id="searchOrgCd" name ="searchOrgCd" type="hidden" class="text" />
							<input id="searchOrgNm" name ="searchOrgNm" type="text" class="text readonly" style="width: 150px" readonly/>
							<a href="javascript:showOrgLayer();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
							<a href="javascript:clearCode(1)" class="button7"><img src="/common/images/icon/icon_undo.png"/></a>
						</c:when>
						<c:otherwise>
							<select id="searchOrgCd" name="searchOrgCd"> </select>
						</c:otherwise>
						</c:choose>
						&nbsp;&nbsp;
						<input id="searchOrgType" name="searchOrgType" type="checkbox" class="checkbox" value="Y" checked"/><label for="searchOrgType">&nbsp;<tit:txt mid='112471' mdef='하위포함'/>&nbsp;</label>
					</td>
					<th><tit:txt mid='104330' mdef='사번/성명'/></th>
					<td colspan="4">
						<input type="text" id="searchSabunName" name="searchSabunName" class="text" />
					</td>
					<td>
						<div class="sheet_title"">
							<ul>
								<li class="btn">
									<a id="toggleBtn" href="javascript:toggleSheet();" class="btn outline_gray" data-toggle="off"><tit:txt mid='2017082900902' mdef='근무시간 보기'/></a>
									<btn:a href="javascript:doAction1('Search');" css="btn dark" mid='search' mdef="조회"/>
								</li>
							</ul>
						</div>
					</td>

				</tr>
			</table>
		</div>
	</form>

	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt">개인근무스케줄관리</li>
			<li class="btn">
				<btn:a href="javascript:doAction1('DownTemplate')" 	css="btn outline_gray authR" mid="down2ExcelV1" mdef="양식다운로드"/>
				<btn:a href="javascript:doAction1('LoadExcel')" 	css="btn outline_gray authR" mid="upload" mdef="업로드"/>
				<a href="javascript:doAction1('Save')" 			class="btn filled authA">저장</a>
				<a href="javascript:doAction1('Down2Excel')" 	class="btn outline_gray authR">다운로드</a>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
		
	<span class="hide">
		<script type="text/javascript">createIBSheet("sheet2", "0", "0", "${ssnLocaleCd}"); </script>
	</span>

	<div id="gap" class="outer" style="display: none;">
		<div class="sheet_title">
			<ul>
				<li class="txt"><tit:txt mid='103861' mdef='근무시간'/><span id="spanTimeNm" class="tOrange"></span></li>
				<li class="btn">
	                 <btn:a  href="javascript:doAction3('Down2Excel')" css="btn outline_gray authR" mid="download" mdef="다운로드"/>
				</li>
			</ul>
		</div>
		<script type="text/javascript"> createIBSheet("sheet3", "100%", "200px", "${ssnLocaleCd}"); </script>
	</div>
</div>
<!-- 공통코드 레이어 팝업 -->
<%@ include file="/WEB-INF/jsp/common/include/layerPopup.jsp"%>
</body>
</html>