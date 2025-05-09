<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>User Mgr (Admin)</title>

<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
	/*Sheet 기본 설정 */
	$(function() {
		$("#basisYmd").datepicker2();

		$("#empYmdFrom").datepicker2({startdate:"empYmdTo"});
		$("#empYmdTo").datepicker2({enddate:"empYmdFrom"});
		sheet1.SetDataLinkMouse("autoScope", 1);
    	sheet1.SetDataLinkMouse("sPwdChange", 1);

		//배열 선언
		var initdata = {};
		//SetConfig
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:6, DataRowMerge:0};
		//HeaderMode
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		//InitColumns + Header Title
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>", 			Type:"Seq",       	Hidden:0,  Width:"${sNoWdt}",   	Align:"Center",  ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>", 		Type:"DelCheck",	Hidden:0,  Width:"${sNoWdt}",	Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>", 		Type:"Status",     	Hidden:0,  Width:"${sNoWdt}",	Align:"Center",  ColMerge:0,   SaveName:"sStatus" },
			{Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>", 		Type:"Text",      	Hidden:0,  Width:100,  	Align:"Left",    ColMerge:0,   SaveName:"orgNm",  		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>", 		Type:"Text",      	Hidden:0,  Width:60,    Align:"Center",  ColMerge:0,   SaveName:"sabun",       	KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>", 		Type:"Text", 		Hidden:0,  Width:65,   	Align:"Center",  ColMerge:0,   SaveName:"name",       	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>", 		Type:"Text", 		Hidden:Number("${aliasHdn}"),  Width:65,   	Align:"Center",  ColMerge:0,   SaveName:"alias",       	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='empYmd' mdef='입사일'/>", 	Type:"Date",      	Hidden:0,  Width:90,  	Align:"Center",    ColMerge:0,   SaveName:"empYmd",  		KeyField:0,   CalcLogic:"",   Format:"Ymd",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='statusCdV1' mdef='재직\n상태'/>",	Type:"Text",      	Hidden:0,  Width:40,  	Align:"Center",    ColMerge:0,   SaveName:"statusNm",  		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>", 	Type:"Text",      	Hidden:0,  Width:60,  	Align:"Center",    ColMerge:0,   SaveName:"jikchakNm",  		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>", 	Type:"Text",      	Hidden:Number("${jgHdn}"),  Width:60,  	Align:"Center",    ColMerge:0,   SaveName:"jikgubNm",  		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>", 	Type:"Text",      	Hidden:Number("${jwHdn}"),  Width:60,  	Align:"Center",    ColMerge:0,   SaveName:"jikweeNm",  		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='id' mdef='아이디'/>", 			Type:"Text",      	Hidden:0,  Width:80,  	Align:"Center",    ColMerge:0,   SaveName:"id",          	KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='password' mdef='비밀번호'/>",		Type:"Text",      	Hidden:1,  Width:80,  	Align:"Left",    ColMerge:0,   SaveName:"password",    	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:20 },
			{Header:"<sht:txt mid='passwordrmk' mdef='패스워드힌트'/>", 	Type:"Text",      	Hidden:1,  Width:0,		Align:"Left",    ColMerge:0,   SaveName:"passwordrmk", 	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='mainpageType' mdef='초기화면구분'/>", Type:"Text",      	Hidden:1,  Width:80,   	Align:"Center",  ColMerge:0,   SaveName:"mainpageType",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='searchTypeV1' mdef='조회구분'/>", 	Type:"Text",      	Hidden:1,  Width:80,   	Align:"Center",  ColMerge:0,   SaveName:"searchType",  	KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='authScopeV2' mdef='권한그룹'/>", 	Type:"Text",      	Hidden:1,  Width:60,   	Align:"Center",  ColMerge:0,   SaveName:"authScope",  	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1 },
			{Header:"<sht:txt mid='pwdChange' mdef='비밀번호\n초기화'/>",	Type:"Image",    	Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   SaveName:"pwdChange",   	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1 },
			{Header:"<sht:txt mid='rockingYn' mdef='잠금'/>", 	Type:"CheckBox",  	Hidden:0,  Width:40,   	Align:"Center",  ColMerge:0,   SaveName:"rockingYn" },
			{Header:"<sht:txt mid='loginFailCnt' mdef='로그인\n실패횟수'/>",		                            Type:"Text",      	Hidden:0,  Width:50,  	Align:"Center",  ColMerge:0,   SaveName:"loginFailCnt",	KeyField:0,   CalcLogic:"",   Format:"Number",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='mailIdV3' mdef='메일id'/>", 		Type:"Text",      	Hidden:0,  Width:100,  	Align:"Center",  ColMerge:0,   SaveName:"mailId",      	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='skinType' mdef='스킨타입'/>", 	Type:"Combo",     	Hidden:1,  Width:60,  	Align:"Center",  ColMerge:0,   SaveName:"skinType",   	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='skinTypeImg' mdef='스킨타입이미지'/>",	Type:"Text",      	Hidden:1,  Width:60,  	Align:"Center",  ColMerge:0,   SaveName:"skinTypeImg",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='fontType' mdef='폰트타입'/>",		Type:"Combo",      	Hidden:1,  Width:60,  	Align:"Center",  ColMerge:0,   SaveName:"fontType",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='mainType' mdef='메인타입'/>",		Type:"Combo",      	Hidden:1,  Width:60,  	Align:"Center",  ColMerge:0,   SaveName:"mainType",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			
			{Header:"<sht:txt mid='gwUseType' mdef='그룹웨어\n사용구분'/>",	Type:"Combo",      	Hidden:1,  Width:60,  	Align:"Center",  ColMerge:0,   SaveName:"gwUseType",		KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='focType' mdef='FOC\n대상여부'/>",		Type:"Combo",      	Hidden:1,  Width:60,  	Align:"Center",  ColMerge:0,   SaveName:"focType",		KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='pswdChgYmd' mdef='비밀번호변경일자'/>", Type:"Date",    	Hidden:0,  Width:80,  	Align:"Center",  ColMerge:0,   SaveName:"pswdChgYmd",   	    KeyField:0,   CalcLogic:"",   Format:"Ymd",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
		];
		
<%-- 파일다운로드 비밀번호 설정 --%>
<c:if test="${ !empty sessionScope.ssnFileDownSetPwd && sessionScope.ssnFileDownSetPwd eq 'Y' }">
		initdata.Cols.push({Header:"다운로드\n비밀번호\n초기화",	Type:"Image",    	Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   SaveName:"downloadPwdChange",   	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1 });
</c:if>
		
		//초기화
		IBS_InitSheet(sheet1, initdata);
	 	sheet1.SetEditable("${editable}");
	 	sheet1.SetColProperty("skinType", {ComboText:"테마1|테마2|테마3|테마4", ComboCode:"theme1|theme2|theme3|theme4"} );
	 	sheet1.SetColProperty("fontType", {ComboText:"나눔고딕|본고딕|맑은고딕", 			ComboCode:"nanum|notosans|malgun"} );
	 	sheet1.SetColProperty("mainType", {ComboText:"메뉴바|위젯", ComboCode:"M|W"} );

/*
	 	var gwUseType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S30010"), "<tit:txt mid='103895' mdef='전체'/>");	//그룹웨어사용구분
	 	sheet1.SetColProperty("gwUseType", 			{ComboText:gwUseType[0], ComboCode:gwUseType[1]} );	//그룹웨어사용구분
	 	var focType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S30020"), "<tit:txt mid='103895' mdef='전체'/>");	//FOC 대상여부
	 	sheet1.SetColProperty("focType", 			{ComboText:focType[0], ComboCode:focType[1]} );	//FOC 대상여부

	 	$("#gwUseType").html(gwUseType[2]);
		$("#gwUseType").change(function(){
			doAction("Search");
		});

	 	$("#focType").html(focType[2]);
		$("#focType").change(function(){
			doAction("Search");
		});
*/
		sheet1.SetCountPosition(4);
		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
// 	 	sheet1.SetImageList(0,"/HTML/images/icon/ico_write.gif");
// 	    sheet1.SetImageList(1,"/HTML/images/common/bg_check01.gif");
// 	    sheet1.SetImageList(2,"/HTML/images/common/bg_check02.gif");
// 	    sheet1.SetImageList(3,"/HTML/images/common/bg_check03.gif");

		$("#srchSabun,#srchName,#empYmdFrom,#empYmdTo,#basisYmd").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction("Search"); $(this).focus();
			}
		});


 		//초기겁색
 		doAction("Search");
 		
		//setSheetAutocompleteEmp( "sheet1", "name");
		//Autocomplete
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue){
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow, "sabun",		rv["sabun"]);
						sheet1.SetCellValue(gPRow, "name",		rv["name"]);
						sheet1.SetCellValue(gPRow, "orgNm",		rv["orgNm"]);
						sheet1.SetCellValue(gPRow, "jikchakCd",	rv["jikchakCd"]);
						sheet1.SetCellValue(gPRow, "jikweeNm",	rv["jikweeNm"]);
						sheet1.SetCellValue(gPRow, "jikgubNm",	rv["jikgubNm"]);
						sheet1.SetCellValue(gPRow, "statusCd",	rv["statusCd"]);
						sheet1.SetCellValue(gPRow, "statusNm",	rv["statusNm"]);
						sheet1.SetCellValue(gPRow, "empYmd",	rv["empYmd"]);
						sheet1.SetCellValue(gPRow, "gempYmd",	rv["gempYmd"]);
					}
				}
			]
		}); 		

	    $(window).smartresize(sheetResize);

	    sheetInit();
	});

	/**
	 *조회조건 에터키 입력시 조회
	 */
	function check_Enter(){
	    if (event.keyCode==13) doAction("Search");
	}

	function chkInVal() {

		if ($("#empYmdFrom").val() == "" && $("#empYmdTo").val() != "") {
			alert('입사일 시작일을 입력하세요.');
			return false;
		}

		if ($("#empYmdFrom").val() != "" && $("#empYmdTo").val() == "") {
			alert('입사일 종료일을 입력하세요.');
			return false;
		}

		if ($("#empYmdFrom").val() != "" && $("#empYmdTo").val() != "") {
			if (!checkFromToDate($("#empYmdFrom"),$("#empYmdTo"),"입사일","입사일","YYYYMMDD")) {
				return false;
			}
		}
		return true;
	}

	/*Sheet Action*/
	function doAction(sAction) {
		switch (sAction) {
		case "Search": //조회
			if(!chkInVal()){break;}
			sheet1.DoSearch( "${ctx}/UserMgr.do?cmd=getUserMgrList", $("#mySheetForm").serialize() );
		break;
		case "Save":        //저장
			//MERGE 사용 Delete는 따로 구현

	    	var result = sheet1.SetEndEdit(1);
	    	if (!result) {
	    		return;
	    	}
	    	var sd = new Date();
	    	var st = new Date();
	    	//alert( (st-sd )/1000);

	    	/*
	    	result = sheet1.ColValueDup("id");
	    	if(result>0){
	    	    alert(result + "행에 중복된 데이터가 존재합니다");
	    	    sheet1.SelectCell(result,0);
	      		return;
	  	 	}
	    	*/

	    	IBS_SaveName(document.mySheetForm,sheet1);
			sheet1.DoSave("${ctx}/UserMgr.do?cmd=saveUserMgr", $("#mySheetForm").serialize());
            break;
        case "Insert":      //입력
			var Row = sheet1.DataInsert(0);

            sheet1.SetCellValue(Row, "authScope","0");
            sheet1.SetCellValue(Row, "authGroup","1");
            sheet1.SetCellValue(Row, "mainPageType","1");
            sheet1.SetCellValue(Row, "searchType","P");
            sheet1.SetCellValue(Row, "rockingYn","N");
            break;
        case "Copy":        //행복사

        	var Row = sheet1.DataCopy();
        	sheet1.SetCellValue(Row, "id", "");
        	sheet1.SetCellValue(Row, "password", "");
            break;
        case "Clear":        //Clear
            sheet1.RemoveAll();
            break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);

			break;
        case "LoadExcel":   //엑셀업로드
			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet1.LoadExcel(params);
            break;
		}
    }

	/**
	 * 패스워드 초기화
	 */
	function userMgrPwdInit(row, col) {

 		if(sheet1.GetCellValue(row, "mailId") == ""){
			alert("<msg:txt mid='109931' mdef='메일이 등록되어 있지 않습니다. '/>");
			return;
		}


	    if( confirm("주민번호 뒤 7자리로 패스워드가 초기화 됩니다.\n진행 하시겠습니까?") ){

	        var params	= 	  "&sabun="+sheet1.GetCellValue(row, "sabun");
			var result = ajaxCall("/UserMgr.do?cmd=setUserMgrPwdInit",params,false).map;
			//alert(result.Message + "\n"+ result.nenwPwd);
			alert(result.Message + "\n");


 			//메일발송
 			/*
 			if( result.Code > 0){

 				$("#encPwd").val(result.nenwPwd);
				$("#sabun").val(sheet1.GetCellValue(row, "sabun"));
				$("#enterCd").val("${ssnEnterCd}");
				$("#type").val("0");
				var mail= ajaxCall("${ctx}/Send.do?cmd=callMailPwd",$("#sendForm").serialize(),false);
				alert(result.Message);
	       	}
	       	else{
	    		alert("<msg:txt mid='alertErrorInitPassword' mdef='비밀번호 초기화에 실패 하였습니다.'/>");
	       	}
 			*/

	    }
	}//:

	/**
	 * 다운로드 패스워드 초기화
	 */
	function userMgrDownloadPwdInit(row, col) {

		if(sheet1.GetCellValue(row, "mailId") == ""){
			alert("<msg:txt mid='109931' mdef='메일이 등록되어 있지 않습니다. '/>");
			return;
		}

		if( confirm("주민번호 뒤 7자리로 패스워드가 초기화 됩니다.\n진행 하시겠습니까?") ){
			var params = "&sabun="+sheet1.GetCellValue(row, "sabun");
			var result = ajaxCall("/UserMgr.do?cmd=setUserMgrDownloadPwdInit",params,false).map;
			//alert(result.Message + "\n"+ result.nenwPwd);
			alert(result.Message + "\n");

			/*
			//메일발송
 			if( result.Code > 0){
				$("#encPwd").val(result.nenwPwd);
				$("#sabun").val(sheet1.GetCellValue(row, "sabun"));
				$("#enterCd").val("${ssnEnterCd}");
				$("#type").val("0");
				var mail= ajaxCall("${ctx}/Send.do?cmd=callMailPwd",$("#sendForm").serialize(),false);
				alert(result.Message);
			} else {
				alert("<msg:txt mid='alertErrorInitPassword' mdef='비밀번호 초기화에 실패 하였습니다.'/>");
			}
 			*/
		}
	}//:

	function sheet1_OnClick(Row, Col, Value) {
		try{
		    if(Row > 0 && sheet1.ColSaveName(Col) == "pwdChange"){
		    	userMgrPwdInit(Row, Col);
		    }
		    if(Row > 0 && sheet1.ColSaveName(Col) == "downloadPwdChange"){
		    	userMgrDownloadPwdInit(Row, Col);
		    }
	  	}catch(ex){alert("OnClick Event Error : " + ex);}
	}



	// 	조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if(Msg != "") alert(Msg); sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}


	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") { alert(Msg); }
			if( Code > -1 ) {doAction("Search");}
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

  	function sheet1_OnValidation(Row, Col, Value){
  	  	try{
  	    	/*
  	  		if( Col == 7 ) {
  	        	if(sheet1.ColValueDup(7)){
  	            	sheet1.ValidateFail(false);
  	        	}else{
  	            	sheet1.ValidateFail(true);
  	        	}
  	    	}
  	    	*/


  	  	}catch(ex){alert("OnValidation Event Error : " + ex);}
 	}

  	function sheet1_OnPopupClick(Row, Col){
  	  	try{
  	    	if(sheet1.ColSaveName(Col) == "sabun" || sheet1.ColSaveName(Col) == "name") {
  	      		empSearchPopup(Row,Col);
  	    	}
  	  	}catch(ex){alert("OnPopupClick Event Error : " + ex);}
  	}


  	function empSearchPopup(Row, Col){
  		if(!isPopup()) {return;}
  		gPRow = Row;
  		pGubun = "employeePopup";

		var url 	= "/Popup.do?cmd=employeePopup&authPg=${authPg}";
		var args 	= new Array();
		args["name"] 	= sheet1.GetCellValue(Row, "name");
		args["sabun"] 	= sheet1.GetCellValue(Row, "sabun");

		var result = openPopup(url, args, "840","520");
  	}

	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

	    if(pGubun == "employeePopup"){
	  	  	sheet1.SetCellValue(gPRow, "sabun",rv["sabun"]);
		    sheet1.SetCellValue(gPRow, "name",rv["name"]);
		    sheet1.SetCellValue(gPRow, "alias",rv["alias"]);
		    sheet1.SetCellValue(gPRow, "empYmd",rv["empYmd"]);
		    sheet1.SetCellValue(gPRow, "statusNm",rv["statusNm"]);
		    sheet1.SetCellValue(gPRow, "jikchakNm",rv["jikchakNm"]);
		    sheet1.SetCellValue(gPRow, "jikgubNm",rv["jikgubNm"]);
		    sheet1.SetCellValue(gPRow, "jikweeNm",rv["jikweeNm"]);
		    sheet1.SetCellValue(gPRow, "orgNm",rv["orgNm"]);
	    }
	    
	    if(pGubun == "sheetAutocompleteEmp"){
            sheet1.SetCellValue(gPRow, "name",   	rv["name"] );
            sheet1.SetCellValue(gPRow, "sabun",   	rv["sabun"] );
            sheet1.SetCellValue(gPRow, "orgNm",   	rv["orgNm"] );
            sheet1.SetCellValue(gPRow, "manageNm",   rv["manageNm"] );
            sheet1.SetCellValue(gPRow, "jikgubNm",   rv["jikgubNm"] );
            sheet1.SetCellValue(gPRow, "statusNm",   rv["statusNm"] );
	    }	    
	}




</script>


</head>
<body class="bodywrap">

<div class="wrapper">

	<form id=sendForm method="post">
		<input type="hidden" id="employeeNm" name="pageUrl" /> <!-- ? -->
		<input type="hidden" id="enterCd" 	 name="enterCd" /> <!-- pwd seting -->
		<input type="hidden" id="sabun" 	 name="sabun" />   <!-- pwd seting -->
		<input type="hidden" id="encPwd" 	 name="encPwd" />  <!-- pwd seting -->
		<input type="hidden" id="type" 	 	 name="type" />  <!-- pwd seting -->
	</form>
	<form id="mySheetForm" name="mySheetForm">
	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<th><sch:txt mid='sabun' mdef='사번'/></th>
			<td>
				<input id="srchSabun" name="srchSabun" type="text" class="text w100" />
			</td>
			<th><sch:txt mid='name' mdef='성명'/></th>
			<td>
				<input id="srchName" name="srchName" type="text" class="text w100" />
			</td>
			<td>
				<input id="statusCd" name="statusCd" type="radio" value="RA" checked> <tit:txt mid='113521' mdef='퇴직자 제외'/>
				<input id="statusCd" name="statusCd"  type="radio" value="" > <tit:txt mid='114221' mdef='퇴직자 포함'/>
			</td>
			<th><tit:txt mid='104535' mdef='기준일'/></th>
			<td>
				<input id="basisYmd" name="basisYmd" type="text" size="10" class="date2 w100" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>"/>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='103881' mdef='입사일'/></th>
			<td>
				<input id="empYmdFrom" name="empYmdFrom" type="text" size="10" class="date2" value=""/> ~
				<input id="empYmdTo" name="empYmdTo" type="text" size="10" class="date2" value=""/>
			</td>
			<%--
			<td>
				<span><tit:txt mid='103851' mdef='그룹웨어'/></span>
				<select id="gwUseType" name="gwUseType"></select>
			</td>
			<td>
				<span>FOC</span>
				<select id="focType" name="focType"></select>
			</td>
			--%>
			<td colspan="5">
				<btn:a href="javascript:doAction('Search');" id="btnSearch" mid="110697" mdef="조회" css="btn dark"/>
			</td>
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
				<li id="txt" class="txt"><tit:txt mid='userMgr' mdef='사용자관리'/></li>
				<li class="btn">
				    ( 비밀번호초기화: 주민번호 뒷자리 )
					<btn:a href="javascript:doAction('Down2Excel');" mid="110698" mdef="다운로드" css="btn outline-gray"/>
					<btn:a href="javascript:doAction('Copy');" mid="110696" mdef="복사" css="btn outline-gray"/>
					<btn:a href="javascript:doAction('Insert');" mid="110700" mdef="입력" css="btn outline-gray"/>
					<btn:a href="javascript:doAction('Save');" mid="110708" mdef="저장" css="btn filled"/>

				</li>
			</ul>
			</div>
		</div>
		<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
		</td>
	</tr>
	</table>
</div>

</body>
</html>



