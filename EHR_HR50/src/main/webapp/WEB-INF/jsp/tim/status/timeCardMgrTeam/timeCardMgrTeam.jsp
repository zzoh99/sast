<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>TimeCard 관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function() {

		var locationCdLst = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOccLocationCd&ssnSearchType=${ssnSearchType}&ssnGrpCd=${ssnGrpCd}",false).codeList, "전체");
		$("#schLocationCd").html(locationCdLst[2]);

		$("#searchYmd").datepicker2();

		var getCpnGntCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCpnGntCdList3",false).codeList, "선택");// 근태구분
		$("#searchGntCd").html(getCpnGntCdList[2]);

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,/* FrozenCol:7, */ MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
				{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
				{Header:"삭제",		Type:"${sDelTy}",	Hidden:1					,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0,  HeaderCheck:0 },
				{Header:"상태",		Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

				{Header:"선택",			Type:"DummyCheck",	Hidden:1,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"chk",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:35, TrueValue:"Y", FalseValue:"N", HeaderCheck:0},

				{Header:"담당자\n확인상태",   Type:"Combo",       Hidden:0,   Width:80,  Align:"Center", ColMerge:0, SaveName:"confirmCd",	KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
				{Header:"마감\n    여부",		Type:"CheckBox",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"closeYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35, HeaderCheck:1, TrueValue:"Y", FalseValue:"N"},
				{Header:"마감여부체크",		Type:"Text",        Hidden:1,   Width:50,   Align:"Center", ColMerge:0, SaveName:"chkCloseYn",	KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
				{Header:"근무일",			Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ymd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				{Header:"요일",				Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"daynm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				{Header:"소속",				Type:"Text",		Hidden:0,	Width:130,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				{Header:"사번",				Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				{Header:"성명",				Type:"Popup",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				{Header:"재직상태",			Type:"Combo",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"statusCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				{Header:"근무조",			Type:"Combo",		Hidden:0,	Width:140,	Align:"Center",	ColMerge:0,	SaveName:"workManageCd",KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				{Header:"근무시간",			Type:"Combo",		Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"timeCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				{Header:"근태구분",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"gntNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				{Header:"결재상태",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applStatusNm",KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
				{Header:"출근시간",			Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"workShm",		KeyField:0,	Format:"Hm",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				{Header:"퇴근시간",			Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"workEhm",		KeyField:0,	Format:"Hm",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				{Header:"근태기\n출근시간",	Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"inHm",		KeyField:0,	Format:"Hm",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				{Header:"근태기\n퇴근시간",	Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"outHm",		KeyField:0,	Format:"Hm",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				{Header:"연장",				Type:"AutoSum",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"overHh",		KeyField:0,	Format:"",		PointCount:1,	UpdateEdit:0,	InsertEdit:0,	EditLen:4 },
				{Header:"야간",				Type:"AutoSum",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"nightHh",		KeyField:0,	Format:"",		PointCount:1,	UpdateEdit:0,	InsertEdit:0,	EditLen:4 },
				{Header:"휴일\n근로",			Type:"AutoSum",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"holHh",		KeyField:0,	Format:"",		PointCount:1,	UpdateEdit:0,	InsertEdit:0,	EditLen:4 },
				{Header:"휴일\n연장",			Type:"AutoSum",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"holOverHh",	KeyField:0,	Format:"",		PointCount:1,	UpdateEdit:0,	InsertEdit:0,	EditLen:4 },
				{Header:"비고",				Type:"Text",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"memo",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000 }
				];
		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var searchWorkManageCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H90300"), "전체");//근무조(H90300)
		var searchTimeCd 		= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H91100"), "전체");//근무시간(H91100)
		var searchApplStatusCd  = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R10010"), "전체");//신청서상태(R10010)

		var confirmCdLst  = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","T75600"), "전체");//담당자확인상태

		// 재직상태
		var statusCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10010"), "전체");
		$("#searchStatusCd").html(statusCdList[2]);

		$("#schConfirmCd").html(confirmCdLst[2]);
		$("#searchWorkManageCd").html(searchWorkManageCd[2]);


		var schTimeGroupCdLst = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&queryId=getTsys319Code&ssnSearchType=${ssnSearchType}&ssnGrpCd=${ssnGrpCd}&searchGrcodeCd=T70010&searchAuthScopeCd=T10","queryId=schTimeGroupCd",false).codeList, "전체");  //근무그룹
		$("#schTimeGroupCd").html(schTimeGroupCdLst[2]);


		sheet1.SetColProperty("confirmCd",   	{ComboText:"|"+confirmCdLst[0], ComboCode:"|"+confirmCdLst[1]} );
		sheet1.SetColProperty("workManageCd", 	{ComboText:"|"+searchWorkManageCd[0], ComboCode:"|"+searchWorkManageCd[1]} );
		sheet1.SetColProperty("timeCd", 		{ComboText:"|"+searchTimeCd[0], ComboCode:"|"+searchTimeCd[1]} );
		sheet1.SetColProperty("applStatusCd", 	{ComboText:"|"+searchApplStatusCd[0], ComboCode:"|"+searchApplStatusCd[1]} );
		sheet1.SetColProperty("statusCd", 		{ComboText:"|"+statusCdList[0], ComboCode:"|"+statusCdList[1]} );

		//사업장코드 관리자권한만 전체사업장 보이도록, 그외는 권한사업장만.
		var url     = "queryId=getBusinessPlaceCdList";
		var allFlag = "전체";
		if ("${ssnSearchType}" != "A"){
			url    += "&searchChkPlace=Y&sabun=${ssnSabun}&grpCd=${ssnGrpCd}";
			allFlag = "";
		}
		var bizPlaceCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", url,false).codeList, allFlag);
		$("#searchBizPlaceCd").html(bizPlaceCdList[2]);

		$(" ").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
				$(this).focus();
			}
		});

/* 		var data = ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getStandDtFromTTIM004",false);

		if(data != null && data.codeList[0] != null ) {
			$("#searchSymd").val(data.codeList[0].symd);
			$("#searchEymd").val(data.codeList[0].eymd);
		} */

		$(window).smartresize(sheetResize); sheetInit();

		$("#searchKeyword").val("");
		//doAction1("Search");

        $("#searchSymd").datepicker2({
        	startdate:"searchEymd",
   			onReturn:function(date){
   				//doAction1("Search");
   			}
        });
        $("#searchEymd").datepicker2({
        	enddate:"searchSymd",
   			onReturn:function(date){
   				//doAction1("Search");
   			}
        });

		$("#searchBizPlaceCd, #searchOrgCd").bind("change",function(event){
			doAction1("Search");
		});

		$("#searchSymd, #searchEymd").bind("keydown",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		$("#searchNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
				$(this).focus();
			}
			if( event.keyCode == 8 || event.keyCode == 46){  //back/del
				clearCode(2);
			}
		});

	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if( !checkDate() ){
				return;
			}
			sheet1.RemoveAll();
			sheet1.DoSearch( "${ctx}/TimeCardMgrTeam.do?cmd=getTimeCardMgrTeamList", $("#empForm").serialize() );
			break;
		case "Save":
			if(!dupChk(sheet1,"sabun|ymd", false, true)){break;}
			IBS_SaveName(document.empForm,sheet1);
			sheet1.DoSave( "${ctx}/TimeCardMgrTeam.do?cmd=saveTimeCardMgrTeam", $("#empForm").serialize()); break;
		case "Insert":
			//신규로우 생성 및 변경
 			var newRow = sheet1.DataInsert(0);
			break;
		case "Copy":
			sheet1.DataCopy();
			break;
		case "Clear":
			sheet1.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelRowHeight:"20"};
			sheet1.Down2Excel(param); break;
		case "DownTemplate":
			// 양식다운로드
			sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"5|7|11|12|13|14"});
			break;
		case "LoadExcel":

			break;

		case "AllColse":
			var data = ajaxCall("${ctx}/TimeCardMgrTeam.do?cmd=saveTimeCardMgrTeamAllColse",$("#empForm").serialize(),false);

            if(data != null && data.Result != null) {
                alert(data.Result.Message);
            }else{
            	alert("마감처리에 실패 하였습니다.");
            }

			break;

		}
	}

	function checkDate(){
		if ( $("#searchSymd").val().length < 10 || $("#searchEymd").val().length < 10){
			alert("근무일 From ~ To를 정확히 입력하시기 바랍니다.");
			return false;
		}
		return true;
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); }

		for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){

			var applStatusNm = sheet1.GetCellValue(i, "applStatusNm");

			if ( applStatusNm != "" ){
				sheet1.SetCellEditable(i, "chk", 0);
			}

			var lchkCloseYn = sheet1.GetCellValue(i, "chkCloseYn");

			if ( lchkCloseYn == "Y" ){
                sheet1.SetRowEditable(i,  0);
            }

		}


			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);

		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
				doAction1('Search');
			}

		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction("Insert");
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

		}catch(ex){alert("OnClick Event Error : " + ex);}
	}

	var popGubun = "";
	var gPRow = "";
	// 팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
			if(sheet1.ColSaveName(Col) == "name") {
				if(!isPopup()) {return;}

				popGubun = "insert";
				gPRow    = Row;
	            var rst = openPopup("/Popup.do?cmd=employeePopup&authPg=${authPg}", "", "740","520");
			}
		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}


	//신청 팝업
	function showApplPopup(auth,seq,searchSabun,applYmd, Row) {

		if(!isPopup()) {return;}

		if(auth == "") {
			alert("권한을 입력하여 주십시오.");
			return;
		}

		 var sCheckRow = sheet1.FindCheckedRow("chk");

		if ( sCheckRow == "" ){
			alert("선택된 내역이 없습니다.");
			return ;
		}

		var arrRow = [];

		$(sCheckRow.split("|")).each(function(index,value){
			arrRow[index] = sheet1.GetCellValue(value,"ymd")+"_"+sheet1.GetCellValue(value,"sabun")+"_"+sheet1.GetCellValue(value,"name");
		});

		var etc03 = "";

		for(var i=0; i<arrRow.length; i++) {
			if(i != 0) {
				etc03 += ",";
			}
			etc03 += arrRow[i];
		}

		var p = {
				searchApplCd: '27'
			  , searchApplSeq: seq
			  , adminYn: 'N'
			  , authPg: auth
			  , searchSabun: searchSabun
			  , searchApplSabun: searchSabun
			  , searchApplYmd: applYmd 
			  , etc02: 'TIME'
			  , etc03: etc03
			};

		var url = "";
		var initFunc = '';
		if(auth == "A") {
			url = "/ApprovalMgr.do?cmd=viewApprovalMgrLayer";
			initFunc = 'initLayer';
		} else {
			url = "/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
			initFunc = 'initResultLayer';
		}

		var args = new Array(5);
		if(Row != ""){
			args["applStatusCd"] = sheet1.GetCellValue(Row, "applStatusCd");
		}else{
			args["applStatusCd"] = "11";
		}

		gPRow = "";
		pGubun = "viewApprovalMgr";
		var approvalMgrLayer = new window.top.document.LayerModal({
			id: 'approvalMgrLayer',
			url: url,
			parameters: p,
			width: 800,
			height: 815,
			title: '신청서',
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


	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

		if( popGubun == "O"){
			$("#searchOrgCd").val(rv["orgCd"]);
        	$("#searchOrgNm").val(rv["orgNm"]);
        	doAction1("Search");
        }else if( popGubun == "E"){
   			$('#name').val(rv["name"]);
   			$('#sabun').val(rv["sabun"]);
   	    	doAction1("Search");
        }else if ( popGubun == "insert"){
			sheet1.SetCellValue(gPRow, "sabun",			rv["sabun"] );
			sheet1.SetCellValue(gPRow, "name",			rv["name"] );
			sheet1.SetCellValue(gPRow, "orgNm",			rv["orgNm"] );
			sheet1.SetCellValue(gPRow, "jikweeNm",		rv["jikweeNm"] );
			sheet1.SetCellValue(gPRow, "jikchakNm",		rv["jikchakNm"] );
        }else if ( popGubun == "timeCardMgrTeamPopTXT" ){
        	doAction1('Search');
        }else if ( popGubun == "timeCardMgrTeamPopEXCEL" ){
        	doAction1('Search');
        }else if( pGubun == "viewApprovalMgr" ){
			doAction1("Search");
		}else if ( pGubun == "timeCardMgrTeamPop" ){

			var searchSymd = rv["searchSymd"];
			var searchEymd = rv["searchEymd"];
			var schTimeGroupCd = rv["schTimeGroupCd"];

			if ( searchSymd != "" ){
				$("#searchSymd").val(searchSymd);
			}
			if ( searchEymd != "" ){
				$("#searchEymd").val(searchEymd);
			}
			if ( schTimeGroupCd != "" ){
				$("#schTimeGroupCd").val(schTimeGroupCd);
			}

			doAction1("Search");
		}
	}

	// 소속 팝업
	function showOrgPopup() {
		if(!isPopup()) {return;}

		popGubun = "O";
        var rst = openPopup("/Popup.do?cmd=orgBasicGrpUserPopup&authPg=R", "", "740","520");
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
			doAction1("Search");
		} else {
			$('#name').val("");
		}
	}

	function sheetSearch() {
		doAction1('Search');
	}
	function setEmpPage(){
		$("#sabun").val($("#searchUserId").val());
		$("#name").val($("#searchKeyword").val());
		sheetSearch();
	}
	function clearEmpPage(){
		$("#sabun").val("");
		$("#name" ).val("");
	}


	function callProcSecomTimeCre(Row, procName) {
		if( !checkDate() ){
			return;
		}

		var confirmMsg = "[" +$("#searchSymd").val() + " ~ " + $("#searchEymd").val() +"]" ;

		if ("" != $("#sabun").val()) confirmMsg += " 사번:" + $("#sabun").val() + ", 성명:" + $("#name").val()

		confirmMsg += "\n가져오기를 실행하시겠습니까?";

		if( !confirm(confirmMsg) ) {
			return ;
		}

		var params  = "searchSymd="+ $("#searchSymd").val().replace(/\-/g,'')
					+ "&searchEymd="+ $("#searchEymd").val().replace(/\-/g,'')
					+ "&searchSabun="+$("#sabun").val();

		var data = ajaxCall("/TimeCardMgrTeam.do?cmd=callP_TIM_SECOM_TIME_CRE",params,false);

		if(data == null || data.Result == null) {
			msg = procName+"를 사용할 수 없습니다." ;
			return msg ;
		}

		if(data.Result.Code == null || data.Result.Code == "OK") {
			msg = "TRUE" ;
			procCallResultMsg = data.Result.Message ;
	    	alert("정상처리 되었습니다.");

	    	doAction1('Search');
		} else {
	    	msg = Row+"행 데이터 처리도중 : "+data.Result.Message;
	    	alert(msg);
		}

	}

	function procP_TIM_DAILY_WORK_CRE(){

		var searchYmd = $("#searchYmd").val().replace(/-/g,"");

		if ( searchYmd == "" ){
			alert("대상자생성일을 입력해주세요.");
			$("#searchYmd").focus();
			return;
		}

		if (confirm( "대상자를 생성하시겠습니까?")) {

			try{

				var param = "&searchYmd="+searchYmd;

				var rtn = ajaxCall("${ctx}/TimeCardMgrTeam.do?cmd=procP_TIM_DAILY_WORK_CRE",param,false);

				if(rtn.Result.Code == "") {
					alert(rtn.Result.Message);
					doAction1("Search");
				}else{
					alert(rtn.Result.Message);
					return;
				}
			} catch (ex){
				alert("저장중 스크립트 오류발생." + ex);
			}
		}
	}

	function callProcHourChgOsstem(flag){
		if( !checkDate() ){
			return;
		}

		var params  = "searchSymd="+ $("#searchSymd").val().replace(/\-/g,'')
					+ "&searchEymd="+ $("#searchEymd").val().replace(/\-/g,'')
					+ "&searchBizPlaceCd="+ $("#searchBizPlaceCd").val();

		if($("#searchBizPlaceCd").val() == "") {

			alert("사업장을 선택하십시오.");
			return;
		}

		// 여기서 체크. 입력기간에 ttim999 마감인  경우 처리 못하도록 메시지 처리
		var data = ajaxCall("${ctx}/TimeCardMgrTeam.do?cmd=getTimeCardMgrTeamCount", params, false);

		if(data != null && data.DATA != null) {

			if (data.DATA.endYn == "Y"){
				alert("근무이력이 이미 마감되었습니다. 처리하실 수 없습니다.");
				return;
			}
		}

		var confirmMsg = "[" +$("#searchSymd").val() + " ~ " + $("#searchEymd").val() +"]" ;

    	var sRow = sheet1.FindCheckedRow("selChk");
    	var arrRow = sRow.split("|");

    	if ( flag == 1 ){
			confirmMsg += "\n근무이력을 반영합니다.";
		} else {
    			if ( sheet1.CheckedRows("selChk") < 1 ){
				alert("개별반영할 사번을 선택하십시오.");
				return;
			} else if (sheet1.CheckedRows("selChk") > 50){
				alert("한번에 최대 50건 가능합니다.");
				return;
			}

        	//for(idx=0; idx<=arrRow.length-1; idx++){
        	//	confirmMsg += " ["+sheet1.GetCellValue(arrRow[idx], "name" )+"]";
        	//}
			confirmMsg += "\n근무이력 개별반영합니다";
		}

		confirmMsg += " 진행하시겠습니까?";

		if( !confirm(confirmMsg) ) {
			return ;
		}


		if ( flag == 1 ){
			var msg = callProc( "", $("#searchSymd").val().replace(/\-/g,''), $("#searchEymd").val().replace(/\-/g,'') ) ;
			if(msg != true) {
				alert( msg ) ;
				return ;
			}
		} else {
        	for(idx=0; idx<=arrRow.length-1; idx++){
    			var msg = callProc( sheet1.GetCellValue(arrRow[idx], "sabun") , $("#searchSymd").val().replace(/\-/g,''), $("#searchEymd").val().replace(/\-/g,'') ) ;
    			if(msg != true) {
    				alert( sheet1.SetCellValue(arrRow[idx], "name")+ "님의 데이터 " + msg ) ;
    				return ;
    			}
        	}
		}
    	alert("정상처리 되었습니다.");
    	doAction1('Search');
	}

	function callProc(searchSabun, searchSymd, searchEymd) {

		var params = "searchSymd="+ $("#searchSymd").val().replace(/\-/g,'')
				   + "&searchEymd="+ $("#searchEymd").val().replace(/\-/g,'')
				   + "&sabun="+searchSabun;

    	var data = ajaxCall("/TimeCardMgrTeam.do?cmd=callP_TIM_WORK_HOUR_CHG_OSSTEM", params, false);

    	if(data.Result.Code == null || data.Result.Code == "OK") {
    		msg = true ;
    	} else {
	    	msg = "반영 도중 : "+data.Result.Message;
    	}

    	return msg ;
	}

	function uploadTxt(msg){
		try{

			if(!isPopup()) {return;}
			var args = new Array();
			gPRow = "";
			popGubun = "timeCardMgrTeamPopTXT";
			args["msg"] = "DAT업로드";
			openPopup("${ctx}/TimeCardMgrTeam.do?cmd=viewTimeCardMgrTeamPopTXT&authPg=${authPg}", args, "740","350");

		}catch(ex){
			alert("Open Popup Event Error : " + ex);
		}
	}

	function uploadExcel(msg){
		try{

			if(!isPopup()) {return;}
			var args = new Array();
			gPRow = "";
			popGubun = "timeCardMgrTeamPopEXCEL";
			args["msg"] = "EXCEL업로드";
			openPopup("${ctx}/TimeCardMgrTeam.do?cmd=viewTimeCardMgrTeamPopEXCEL&authPg=${authPg}", args, "740","350");

		}catch(ex){
			alert("Open Popup Event Error : " + ex);
		}
	}

	function timeCardMgrTeamPop(){
		try{

			if(!isPopup()) {return;}
			var args = new Array();
			gPRow = "";
			pGubun = "timeCardMgrTeamPop";
			openPopup("${ctx}/TimeCardMgrTeam.do?cmd=viewTimeCardMgrTeamPop&authPg=${authPg}", args, "400","190");

		}catch(ex){
			alert("Open Popup Event Error : " + ex);
		}
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="empForm" name="empForm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th>근무일 </th>
						<td>
							<input type="text" id="searchSymd" name="searchSymd"  class="date2 required " value="${curSysYyyyMMddHyphen}" /> ~
							<input type="text" id="searchEymd" name="searchEymd"  class="date2 required " value="${curSysYyyyMMddHyphen}" />
						</td>
						<th>담당자확인상태 </th>
						<td>
							<select id="schConfirmCd" name="schConfirmCd"> </select>
<!-- 							<span>출근누락여부</span>
							<input id="searchTypeIn" name="searchTypeIn" type="checkbox" class="checkbox" value="Y" />
							<span>퇴근누락여부</span>
							<input id="searchTypeOut" name="searchTypeOut" type="checkbox" class="checkbox" value="Y" /> -->
						</td>
						<th>근태기미등록자</th>
						<td><input id="searchTypeInOut" name="searchTypeInOut" type="checkbox" class="checkbox" value="Y" /></td>
						<th class="hide">마감누락여부</th>
						<td class="hide">
                            <input id="schCloseYn" name="schCloseYn" type="checkbox" class="checkbox" value="Y" />
						</td>
					</tr>
					<tr>
						<th>소속 </th>
						<td>
							<input type="text" id="searchOrgNm" name="searchOrgNm"  class="text readonly" />
							<input type="hidden" id="searchOrgCd" name="searchOrgCd" />
							<a href="javascript:showOrgPopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
							<a href="javascript:clearCode(1)" class="button7"><img src="/common/images/icon/icon_undo.png"/></a>
							<input id="searchOrgType" name="searchOrgType" type="checkbox" class="checkbox" value="Y" checked/>하위포함
						</td>
						<th class="hide">근무지</th>
						<td class="hide">
							<select id="schLocationCd" name="schLocationCd" onchange="javascript:doAction1('Search');"> </select>
						</td>
                        <th class="hide">근무그룹 </th>
                        <td class="hide">
                            <select id="schTimeGroupCd" name="schTimeGroupCd" onchange="javascript:doAction1('Search');"> </select>
                        </td>
						<th>사번/성명</th>
                        <td>
							<input id="searchNm" name="searchNm" type="text" class="text" style="ime-mode:active;" />
						</td>
					</tr>
					<tr>
                        <th>교대형태 </th>
						<td>
                            <select id="searchWorkManageCd" name="searchWorkManageCd" onchange="javascript:doAction1('Search');"> </select>
                        </td>
                        <th>근태구분 </th>
						<td>
                            <select id="searchGntCd" name="searchGntCd" onchange="javascript:doAction1('Search');"> </select>
                        </td>
                        <th>재직상태 </th>
                        <td><select id="searchStatusCd" name="searchStatusCd" onchange="javascript:doAction1('Search');"> </select></td>

						<td>
							<a href="javascript:doAction1('Search');" id="btnSearch" class="button">조회</a>
						</td>
                     </tr>
                     <tr>
<!--

                        <td>
							<span>사번/성명</span>
							<input id="sabun" name="sabun" type="text" class="text"/>
							<input id="name"  name="name"  type="text" class="text readonly" readonly/>
							<a href="javascript:showEmployeePopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
						</td> -->
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
							<li id="txt" class="txt">일근태현황</li>
							<li id="txt" class="txt"><!-- <span>개별 가져오기 실행시 <b><font color=Blue>사번</font></b> 입력</span> --></li>
							<li class="btn">
								<a href="javascript:doAction1('Down2Excel');"	class="basic authR">다운로드</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>