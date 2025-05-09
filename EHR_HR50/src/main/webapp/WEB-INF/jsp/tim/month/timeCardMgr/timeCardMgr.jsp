<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>TimeCard 관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var popGubun = "";
var gPRow = "";

	$(function() {

		$("#searchSabunName").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
				$(this).focus();
			}
		});

		getCommonCodeList();
		/*
		var data = ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getStandDtFromTTIM004",false);

		if(data != null && data.codeList[0] != null ) {
			$("#searchSymd").val(data.codeList[0].symd);
			$("#searchEymd").val(data.codeList[0].eymd);
		}*/

		$("#searchSymd").val("${curSysYyyyMMddHyphen}");
		$("#searchEymd").val("${curSysYyyyMMddHyphen}");

		$("#searchSdate").datepicker2({startdate:"searchEdate"});
		$("#searchEdate").datepicker2({enddate:"searchSdate"});

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

		$("#searchBizPlaceCd, #searchOrgCd, #searchWorkType").bind("change",function(event){
			doAction1("Search");
		});

		$("#searchSymd, #searchEymd").bind("keydown",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		$("#sabun").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
				$(this).focus();
			}
			if( event.keyCode == 8 || event.keyCode == 46){  //back/del
				clearCode(2);
			}
		});
		
		
		init_sheet();
		
	});

	function getCommonCodeList() {
		// 급여유형(H10110)
		var payType = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10110"), "");
		$("#payType").html(payType[2]);
		$("#payType").select2({placeholder:("${ssnLocaleCd}" != "en_US" ? " 선택" : " Select")});

		//직군
		var workTypeList = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10050"), "전체");
		$("#searchWorkType").html(workTypeList[2]);
	}
	
	function init_sheet(){

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:10,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
     			{Header:"No|No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
    			{Header:"삭제|삭제",			Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
       			{Header:"상태|상태",			Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 },
       			{Header:"근무\n마감|근무\n마감",	Type:"Text",		Hidden:0,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"closeYn",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0 },
    			{Header:"근무일|근무일",		Type:"Date",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"ymd",			KeyField:1,	Format:"Ymd",	UpdateEdit:0,	InsertEdit:1 },
    			{Header:"요일|요일",			Type:"Text",		Hidden:0,					Width:45,			Align:"Center",	ColMerge:0,	SaveName:"dayNm",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:1 },
    			{Header:"근무지|근무지",		Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"locationCd",	KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0 },
    			{Header:"소속|소속",			Type:"Text",		Hidden:0,					Width:150,			Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0 },
				{Header:"사번|사번",			Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",		UpdateEdit:0,	InsertEdit:0 },
				{Header:"성명|성명",			Type:"Popup",		Hidden:0,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:1 },
				{Header:"직급|직급",			Type:"Text",		Hidden:Number("${jgHdn}"),	Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",	KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0 },
				{Header:"직위|직위",			Type:"Text",		Hidden:Number("${jwHdn}"),	Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0 },
				{Header:"직책|직책",			Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",	KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0 },
				{Header:"직군|직군",			Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"workTypeNm",	KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0 },
				{Header:"급여유형|급여유형",		Type:"Text",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"payTypeNm",	KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0 },
				{Header:"TimeCard|보존\n여부",	Type:"CheckBox",	Hidden:0,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"protectYn",	KeyField:0,	Format:"",		UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y", FalseValue:"N"},
    			{Header:"TimeCard|출근일",	Type:"Date",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"inYmd",		KeyField:0,	Format:"Ymd",	UpdateEdit:0,	InsertEdit:1 },
				{Header:"TimeCard|출근시간",	Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"inHm",		KeyField:0,	Format:"Hm",	UpdateEdit:0,	InsertEdit:1 },
				{Header:"TimeCard|퇴근일",	Type:"Date",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"outYmd",		KeyField:0,	Format:"Ymd",	UpdateEdit:0,	InsertEdit:1 },
				{Header:"TimeCard|퇴근시간",	Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"outHm",		KeyField:0,	Format:"Hm",	UpdateEdit:0,	InsertEdit:1 },
				{Header:"eHr|출근일",			Type:"Date",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"eInYmd",		KeyField:0,	Format:"Ymd",	UpdateEdit:0,	InsertEdit:1 },
				{Header:"eHr|출근시간",		Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"eInHm",		KeyField:0,	Format:"Hm",	UpdateEdit:0,	InsertEdit:1 },
				{Header:"eHr|퇴근일",			Type:"Date",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"eOutYmd",		KeyField:0,	Format:"Ymd",	UpdateEdit:0,	InsertEdit:1 },
				{Header:"eHr|퇴근시간",		Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"eOutHm",		KeyField:0,	Format:"Hm",	UpdateEdit:0,	InsertEdit:1 },
				{Header:"비고|비고",			Type:"Text",		Hidden:0,					Width:200,			Align:"Left",	ColMerge:0,	SaveName:"memo",		KeyField:0,	Format:"",		UpdateEdit:1,	InsertEdit:1 },
				{Header:"\n선택|\n선택",		Type:"DummyCheck",	Hidden:1,					Width:45,			Align:"Center",	ColMerge:0,	SaveName:"selChk",		KeyField:0,	Format:"",		UpdateEdit:1,	InsertEdit:1 },
		];IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);


		//헤더 색상
		sheet1.SetRangeBackColor(0,sheet1.SaveNameCol("protectYn"),1,sheet1.SaveNameCol("outHm"), "#E1F0F5");  //연파랑
		sheet1.SetRangeBackColor(0,sheet1.SaveNameCol("eInYmd"),1,sheet1.SaveNameCol("eOutHm"), "#fdf0f5");  //분홍이
		
		//사업장코드 관리자권한만 전체사업장 보이도록, 그외는 권한사업장만.
		var url     = "queryId=getBusinessPlaceCdList";
		var allFlag = true;
		if ("${ssnSearchType}" != "A"){
			url    += "&searchChkPlace=Y&sabun=${ssnSabun}&grpCd=${ssnGrpCd}";
			allFlag = false;
		}
		var bizPlaceCdList = "";
		if(allFlag) {
			bizPlaceCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, "전체");	//사업장
		} else {
			bizPlaceCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, "");	//사업장
		}
		$("#searchBizPlaceCd").html(bizPlaceCdList[2]);

		//근무지 관리자권한만 전체근무지 보이도록, 그외는 권한근무지만.
		url     = "queryId=getLocationCdListAuth";
		allFlag = true;
		if ("${ssnSearchType}" != "A"){
			url    += "&searchChkPlace=Y&sabun=${ssnSabun}&grpCd=${ssnGrpCd}";
			allFlag = false;
		}
		var locationCdList = "";
		if(allFlag) {
			locationCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, "전체");	//사업장
		} else {
			locationCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, "");	//사업장
		}
		$("#searchLocationCd").html(locationCdList[2]);
		
		sheet1.SetColProperty("locationCd", {ComboText:"|"+locationCdList[0], ComboCode:"|"+locationCdList[1]});
		
		$(window).smartresize(sheetResize); sheetInit();
		
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if( !checkDate('Search') ){
				return;
			}

			$("#multiPayType").val(getMultiSelect($("#payType").val()));

			var sXml = sheet1.GetSearchData("${ctx}/TimeCardMgr.do?cmd=getTimeCardMgrList", $("#sheet1Form").serialize() );
			sXml = replaceAll(sXml,"sheetRowEdit", "Edit");
			sheet1.LoadSearchData(sXml );
			
			break;
		case "Save":
			if(!dupChk(sheet1,"sabun|ymd", false, true)){break;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/TimeCardMgr.do?cmd=saveTimeCardMgr", $("#sheet1Form").serialize()); break;
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
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param); break;
		case "DownTemplate":
			// 양식다운로드
			sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"ymd|sabun|inYmd|inHm|outYmd|outHm"});
			//sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"ymd|sabun|inHm|outHm"});
			break;
		case "LoadExcel":
			var params = {};
			sheet1.LoadExcel(params);
			break;
		case "Secom":
			if( !checkDate('Secom') ){
				return;
			}

			if(!confirm($("#searchSdate").val()+"~"+$("#searchEdate").val()+"의 세콤 출퇴근 이력을 가져오시겠습니까?")) { return ;}
			progressBar(true) ;

			setTimeout(
				function(){

					var param = "searchSdate="+$("#searchSdate").val().replace(/-/gi,"") + "&searchEdate="+$("#searchEdate").val().replace(/-/gi,"");
					var data = ajaxCall("${ctx}/Schedule.do?cmd=getSecomData",param,false);
					if(data.Result.Code > -1) {
						alert("처리되었습니다.");
						//doAction1('Search');
				    	progressBar(false) ;
						
					} else {
				    	alert("처리중 오류가 발생했습니다.\n"+data.Result.Message);
				    	progressBar(false) ;
					}
				}
			, 100);
			

			break;

		}
	}

	function checkDate(sAction){
		switch (sAction) {
			case "Search" :
				if ( $("#searchSymd").val().length < 10 || $("#searchEymd").val().length < 10){
					alert("<msg:txt mid='2017082900921' mdef='근무일 From ~ To를 정확히 입력하시기 바랍니다.'/>");
					return false;
				}
				if ($("#searchSymd").val() != "" && $("#searchEymd").val() != "") {
					if (!checkFromToDate($("#searchSymd"),$("#searchEymd"),"근무일","근무일","YYYYMMDD")) {
						return false;
					}
				}
				break;
			case "Secom" :
				if( $("#searchSdate").val() == "" ){
					alert("기준 시작일자를 입력 해주세요.");
					$("#searchSdate").focus();
					return;
				}
				if( $("#searchEdate").val() == "" ){
					alert("기준 종료일자를 입력 해주세요.");
					$("#searchEdate").focus();
					return;
				}
				if ($("#searchSdate").val() != "" && $("#searchEdate").val() != "") {
					if (!checkFromToDate($("#searchSdate"),$("#searchEdate"),"기준일","기준일","YYYYMMDD")) {
						return false;
					}
				}
				break;
		}
		return true;
	}

	//-----------------------------------------------------------------------------------
	//		sheet1 이벤트
	//-----------------------------------------------------------------------------------
	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); }
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
			}
			if( Code > -1 ) doAction1("Search"); 

		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	
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

	function sheet1_OnChange(Row, Col, Value) {

		if(sheet1.ColSaveName(Col) == "ymd") {
			sheet1.SetCellValue(Row, "inYmd",  Value);
			sheet1.SetCellValue(Row, "outYmd", Value);
		}
		if(sheet1.ColSaveName(Col) != "protectYn") {
			sheet1.SetCellValue(Row, "protectYn",  true);
		}
	}


	function getReturnValue(rv) {

		if ( popGubun == "insert"){
			sheet1.SetCellValue(gPRow, "sabun",			rv["sabun"] );
			sheet1.SetCellValue(gPRow, "name",			rv["name"] );
			sheet1.SetCellValue(gPRow, "orgNm",			rv["orgNm"] );
			sheet1.SetCellValue(gPRow, "alias",			rv["alias"] );
			sheet1.SetCellValue(gPRow, "jikgubNm",		rv["jikgubNm"] );
			sheet1.SetCellValue(gPRow, "jikweeNm",		rv["jikweeNm"] );
			sheet1.SetCellValue(gPRow, "jikchakNm",		rv["jikchakNm"] );
	        sheet1.SetCellValue(gPRow, "workTypeNm",	rv["workTypeNm"] );
	        sheet1.SetCellValue(gPRow, "payTypeNm",		rv["payTypeNm"] );
	        sheet1.SetCellValue(gPRow, "locationCd",	rv["locationCd"] );
        }
	}

	// 소속 팝업
	function showOrgPopup() {
		if(!isPopup()) {return;}

		popGubun = "O";
		var p = { searchEnterCd: "${ssnEnterCd}" };
		let layerModal = new window.top.document.LayerModal({
			id : 'orgTreeLayer'
			, url : '/Popup.do?cmd=viewOrgTreeLayer&authPg=${authPg}'
			, parameters : p
			, width : 740
			, height : 520
			, title : '<tit:txt mid='orgSchList' mdef='조직도 조회'/>'
			, trigger :[
				{
					name : 'orgTreeLayerTrigger'
					, callback : function(rv){
						$("#searchOrgCd").val(rv.orgCd);
						$("#searchOrgNm").val(rv.orgNm);
						if(rv.priorOrgCd == "0") { $("#searchOrgCd").val("0"); }
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

		if ("" != $("#sabun").val()) confirmMsg += " Sabun:" + $("#sabun").val() + ", Name:" + $("#name").val()

		confirmMsg += "\n<msg:txt mid='2017082900926' mdef='가져오기를 실행하시겠습니까?'/>";

		if( !confirm(confirmMsg) ) {
			return ;
		}

		var params  = "searchSymd="+ $("#searchSymd").val().replace(/\-/g,'')
					+ "&searchEymd="+ $("#searchEymd").val().replace(/\-/g,'')
					+ "&searchSabun="+$("#sabun").val();

		var data = ajaxCall("/TimeCardMgr.do?cmd=callP_TIM_SECOM_TIME_CRE",params,false);

		if(data == null || data.Result == null) {
			msg = procName+" : <msg:txt mid='2017082900925' mdef='사용할 수 없습니다.'/>" ;
			return msg ;
		}

		if(data.Result.Code == null || data.Result.Code == "OK") {
			msg = "TRUE" ;
			procCallResultMsg = data.Result.Message ;
	    	alert("<msg:txt mid='2017082900924' mdef='정상처리 되었습니다.'/>");

	    	doAction1('Search');
		} else {
	    	msg = Row+"Row(s) Error : "+data.Result.Message;
	    	alert(msg);
		}

	}

	function callProcHourChgOsstem(flag){
		if( !checkDate() ){
			return;
		}

		var params  = "searchSymd="+ $("#searchSymd").val().replace(/\-/g,'')
					+ "&searchEymd="+ $("#searchEymd").val().replace(/\-/g,'')
					+ "&searchBizPlaceCd="+ $("#searchBizPlaceCd").val();
/*
		if($("#searchBizPlaceCd").val() == "") {

			alert("<msg:txt mid='2017082900922' mdef='사업장을 선택하십시오.'/>");
			return;
		}
*/
		// 여기서 체크. 입력기간에 ttim999 마감인  경우 처리 못하도록 메시지 처리
		var data = ajaxCall("${ctx}/TimeCardMgr.do?cmd=getTimeCardMgrCount", params, false);

		if(data != null && data.DATA != null) {

			if (data.DATA.endYn == "Y"){
				alert("<msg:txt mid='2017082900923' mdef='근무이력이 이미 마감되었습니다. 처리하실 수 없습니다.'/>");
				return;
			}
		}

		var confirmMsg = "[" +$("#searchSymd").val() + " ~ " + $("#searchEymd").val() +"]" ;

    	var sRow = sheet1.FindCheckedRow("selChk");
    	var arrRow = sRow.split("|");

    	if ( flag == 1 ){
			confirmMsg += "\n<msg:txt mid='2017082900927' mdef='근무이력을 반영합니다.'/>";
		} else {
    			if ( sheet1.CheckedRows("selChk") < 1 ){
				alert("<msg:txt mid='2017082900929' mdef='개별반영할 사번을 선택하십시오.'/>");
				return;
			} else if (sheet1.CheckedRows("selChk") > 50){
				alert("<msg:txt mid='2017082900928' mdef='한번에 최대 50건 가능합니다.'/>");
				return;
			}

        	//for(idx=0; idx<=arrRow.length-1; idx++){
        	//	confirmMsg += " ["+sheet1.GetCellValue(arrRow[idx], "name" )+"]";
        	//}
			confirmMsg += "\n<msg:txt mid='2017082900930' mdef='근무이력 개별반영합니다'/>";
		}

		confirmMsg += " <msg:txt mid='2017082900931' mdef='진행하시겠습니까?'/>";

		if( !confirm(confirmMsg) ) {
			return ;
		}

		progressBar(true) ;

		setTimeout(function(){
			if ( flag == 1 ){
				var msg = callProc( "", $("#searchSymd").val().replace(/\-/g,''), $("#searchEymd").val().replace(/\-/g,'') ) ;
				if(msg != true) {
					alert( msg ) ;
					progressBar(false) ;
					return ;
				}
			} else {
	        	for(idx=0; idx<=arrRow.length-1; idx++){
	    			var msg = callProc( sheet1.GetCellValue(arrRow[idx], "sabun") , $("#searchSymd").val().replace(/\-/g,''), $("#searchEymd").val().replace(/\-/g,'') ) ;
	    			if(msg != true) {
	    				alert( sheet1.SetCellValue(arrRow[idx], "name")+ "-> " + msg ) ;
	    				progressBar(false) ;
	    				return ;
	    			}
	        	}
			}
			progressBar(false) ;
	    	alert("<msg:txt mid='2017082900924' mdef='정상처리 되었습니다.'/>");
	    	doAction1('Search');
		},1000);

	}

	//근무이력반영
	function callProc(searchSabun, searchSymd, searchEymd) {

		var params = "searchSymd="+ $("#searchSymd").val().replace(/\-/g,'')
				   + "&searchEymd="+ $("#searchEymd").val().replace(/\-/g,'')
				   + "&searchBizPlaceCd="+ $("#searchBizPlaceCd").val()
				   + "&sabun="+searchSabun;

    	var data = ajaxCall("/TimeCardMgr.do?cmd=callTimeCardMgrWorkHourChg", params, false);

    	if(data.Result.Code == null || data.Result.Code == "OK") {
    		msg = true ;
    	} else {
	    	msg = "Error : "+data.Result.Message;
    	}

    	return msg ;
	}

</script>
<style type="text/css">
/* table.table img.ui-datepicker-trigger {margin-left:-1px!important;}
table.table .date2 {height:21px!important; text-align:center!important;} */
</style>
</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="outer">
		<form id="sheet1Form" name="sheet1Form" >
		<input type="hidden" id="multiPayType" name="multiPayType" value="" />
		<div class="sheet_search">
			<table>
				<tr>
					<th><tit:txt mid='104060' mdef='근무일'/> </th>
					<td>
						<input type="text" id="searchSymd" name="searchSymd"  class="required date2" value="" /> ~
						<input type="text" id="searchEymd" name="searchEymd"  class="required date2" value="" />
					</td>
					<th><tit:txt mid='104281' mdef='근무지'/></th>
					<td>
						<select id="searchLocationCd" name="searchLocationCd"> </select>
					</td>
					<th class="hide"><tit:txt mid='114399' mdef='사업장'/></th>
					<td class="hide">							
						<select id="searchBizPlaceCd" name="searchBizPlaceCd"> </select>
					</td>
					<th class="hide"><tit:txt mid='113330' mdef='급여유형'/></th>
					<td class="hide">
						 <select id="payType" name="payType" multiple=""> </select> 
					</td>
					<th>직군 </th>
					<td>
						<select id="searchWorkType" name="searchWorkType" > </select> 
					</td>
				</tr>
				<tr>
					<th><tit:txt mid='104279' mdef='소속'/> </th>
					<td>
						<input type="hidden" id="searchOrgCd" name="searchOrgCd" />
						<input type="text" id="searchOrgNm" name="searchOrgNm"  class="text readonly" readonly/><a href="javascript:showOrgPopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
						<a href="javascript:clearCode(1)" class="button7"><img src="/common/images/icon/icon_undo.png"/></a>
						<input id="searchOrgType" name="searchOrgType" type="checkbox" class="checkbox" value="Y" checked/><label for="searchOrgType"><tit:txt mid='112471' mdef='하위포함'/></label>
					</td>
					<th><tit:txt mid='104330' mdef='사번/성명'/></th>
					<td>
						<input type="text" id="searchSabunName" name="searchSabunName" class="text w100" style="ime-mode:active;" />
					</td>
					<th><tit:txt mid='2017082900932' mdef='출근누락여부'/></th>
					<td>
						<input id="searchTypeIn" name="searchTypeIn" type="checkbox" class="checkbox" value="Y" />
					</td>
					<th><tit:txt mid='2017082900934' mdef='퇴근누락여부'/></th>
					<td>
						<input id="searchTypeOut" name="searchTypeOut" type="checkbox" class="checkbox" value="Y" />
					</td>
					<td>
						<btn:a href="javascript:doAction1('Search');" css="btn dark" mid='search' mdef="조회"/>
					</td>
				</tr>

			</table>
			</div>
		</form>
		<div class="h10"></div>
		<table class="table">
			<colgroup>
				<col width="100px" />
				<col width="300px" />
				<col width="300px" />
				<col width="" />
			</colgroup>
			<tr>
				<th>기준일자</th>
				<td><input type="text" id="searchSdate" name="searchSdate"  class="date2" value="${curSysYyyyMMddHyphen}" />
					~ 
				    <input type="text" id="searchEdate" name="searchEdate"  class="date2" value="${curSysYyyyMMddHyphen}" />
				</td>
				
				<td align="left"> 
					<a href="javascript:doAction1('Secom');"           class="btn filled authA">세콤출퇴근기록 가저오기</a> <!-- 세콤이력 가져올 때 근무이력도 반영 해줌. -->
				</td>
				<td></td>
			</tr>
			
		</table>
	</div>
	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li id="txt" class="txt"><tit:txt mid='2017082900935' mdef='TimeCard관리'/></li>
				<li id="txt" class="txt hide"><span><tit:txt mid='2017082900940' mdef='개별 가져오기 실행시 사번 입력'/></span></li>
				<li class="btn">
					<!-- btn:a href="javascript:callProcHourChgOsstem(1)"  css="pink authA" mid="2017082900937" mdef="근무이력전체반영"/ -->
					<!-- btn:a href="javascript:callProcHourChgOsstem(2)"  css="pink authA" mid="2017082900936" mdef="근무이력개별반영"/ -->
					<btn:a href="javascript:doAction1('LoadExcel');"   css="btn outline-gray hide authA" mid="upload" mdef="업로드"/>
					<btn:a href="javascript:doAction1('Down2Excel');"  css="btn outline-gray authR" mid="download" mdef="다운로드"/>
					<btn:a href="javascript:doAction1('Save');"        css="btn soft  authA" mid="save" mdef="저장"/>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>

</div>
</body>
</html>