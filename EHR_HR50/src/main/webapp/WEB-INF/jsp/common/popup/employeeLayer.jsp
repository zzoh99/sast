<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='113773' mdef='임직원 조회 팝업'/></title>
<%--<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>--%>

<script type="text/javascript">
	var srchBizCd = null;
	<%--var p = eval("${popUpStatus}");--%>
	/*Sheet 기본 설정 */
	$(function() {

        createIBSheet3(document.getElementById('employeeLayerSheet-wrap'), "employeeLayerSheet", "100%", "100%","${ssnLocaleCd}");

		// var arg = p.window.dialogArguments;


        const modal = window.top.document.LayerModalUtility.getModal('employeeLayer');
        var sType 			= modal.parameters.sType || '';
        var topKeyword  	= modal.parameters.topKeyword || '';
        var searchEnterCd  	= modal.parameters.searchEnterCd || '';
        var isHideRet = modal.parameters.isHideRet || '';


	    // if( arg != undefined ) {
	    // 	sType 	   = arg["sType"];
	    // 	topKeyword = arg["topKeyword"];
	    // 	searchEnterCd = arg["searchEnterCd"];
	    // 	isHideRet = arg["isHideRet"];
	    // }else{
		// 	if ( p.popDialogArgument("sType") !=null ) { sType			   				= p.popDialogArgument("sType"); }
		// 	if ( p.popDialogArgument("topKeyword") !=null ) { topKeyword		   		= p.popDialogArgument("topKeyword"); }
		// 	if ( p.popDialogArgument("searchEnterCd") !=null ) { searchEnterCd			= p.popDialogArgument("searchEnterCd"); }
		// 	if ( p.popDialogArgument("isHideRet") !=null ) { isHideRet				    = p.popDialogArgument("isHideRet"); }
	    // }

		//top 에서 검색시 T를 넣어줌=> 전사원 검색이 가능
		//팝업에서 검색시 P를 기본적으로 가져감 => 권한에 따른 검색
		//INCLUDE 에서 검색시 I를 기본적으로 가져감  => 권한에 따른 검색
		$("#searchEmpType").val(sType);
		$("#searchKeyword").val(topKeyword);
		$("#searchEnterCd").val(searchEnterCd);
		if(isHideRet == "Y"){
			$("#searchStatusRadioDiv").hide();
		}
		//배열 선언
		var initdata = {};
		//SetConfig
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:4,DataRowMerge:0, AutoFitColWidth:'init|search|resize|rowtransaction'};
		//HeaderMode
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		//InitColumns + Header Title
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:0,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",	Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus" },
 			{Header:"<sht:txt mid='enterCd' mdef='회사명'/>",		Type:"Text",		Hidden:1,	Width:0,			Align:"Center",	ColMerge:0,	SaveName:"enterNm", UpdateEdit:0 },
 			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",	Type:"Text",		Hidden:0,	Width:70,			Align:"Center",	ColMerge:0,	SaveName:"empSabun", UpdateEdit:0 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",		Type:"Text",		Hidden:0,	Width:70,			Align:"Center",	ColMerge:0,	SaveName:"empName", UpdateEdit:0 },
			{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",		Type:"Text",		Hidden:Number("${aliasHdn}"),	Width:100,			Align:"Center",	ColMerge:0,	SaveName:"empAlias", UpdateEdit:0 },
			{Header:"<sht:txt mid='orgCdV8' mdef='소속코드'/>",		Type:"Text",		Hidden:1,	Width:60,			Align:"Left",	ColMerge:0,	SaveName:"orgCd", UpdateEdit:0 },
			{Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",		Type:"Text",		Hidden:0,	Width:200,			Align:"Left",	ColMerge:0,	SaveName:"orgNm", UpdateEdit:0 },
			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",	Type:"Text",		Hidden:0,	Width:80,			Align:"Center",	ColMerge:0,	SaveName:"jikchakNm", UpdateEdit:0 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",		Type:"Text",		Hidden:Number("${jwHdn}"),	Width:80,			Align:"Center",	ColMerge:0,	SaveName:"jikweeNm", UpdateEdit:0 },
			{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",			Type:"Text",		Hidden:Number("${jgHdn}"),	Width:80,			Align:"Center",	ColMerge:0,	SaveName:"jikgubNm", UpdateEdit:0 },
			{Header:"<sht:txt mid='statusCdV1' mdef='재직\n상태'/>",	Type:"Text",		Hidden:0,	Width:45,			Align:"Center",	ColMerge:0,	SaveName:"statusNm", UpdateEdit:0 }

		];
		IBS_InitSheet(employeeLayerSheet, initdata); employeeLayerSheet.SetCountPosition(4);employeeLayerSheet.SetEditableColorDiff (0);

		var sheetHeight = $('.modal_body').height() - $('#mySheetForm').height() - $('.sheet_title').height();
		$(window).smartresize(sheetResize); sheetInit();
		employeeLayerSheet.SetSheetHeight(sheetHeight);

		$("#searchKeyword").focus();

		//검색어 있을경우 검색
		if($("#searchKeyword").val() != ""){
			doActionEmp("Search");
		}

		//임직원공통인 경우 퇴직자검색조건 숨김
		if("${grpCd}" == "99") {
			$("#searchStatusRadioDiv").hide();
		}

        $("#searchKeyword").bind("keyup",function(event){
			if( event.keyCode == 13){
				$(this).blur();
		 		doActionEmp("Search");
		 		event.preventDefault();
			}
		});

        // $(".close").click(function() {
	    // 	p.self.close();
	    // });
		sheetResize();
	});

	/*Sheet Action*/
	function doActionEmp(sAction) {
		switch (sAction) {
			case "Search": //조회
				if( ( $.trim( $("#searchKeyword").val( )) ) == "" ){
					alert("<msg:txt mid='109671' mdef='성명 또는 사번을 입력하세요.'/>");
					$("#searchKeyword").focus();
				}else{
				    //employeeLayerSheet.DoSearch( "${ctx}/Popup.do?cmd=getEmployeeList", $("#mySheetForm").serialize() );
				    employeeLayerSheet.DoSearch( "${ctx}/Employee.do?cmd=employeeList", $("#mySheetForm").serialize(),1 );
				}
	            break;
		}
    }

	// 	조회 후 에러 메시지
	function employeeLayerSheet_OnSearchEnd(Code, ErrMsg, StCode, StMsg) {
		try{
		  	if(employeeLayerSheet.RowCount() == 0) {
		    	alert("<msg:txt mid='alertAuthEmp1' mdef='대상 직원에 대한 조회 권한이 없거나 해당사원이 존재 하지 않습니다.'/>");
		  	}

			// setSheetSize(employeeLayerSheet);
            sheetResize();
	  	}catch(ex){alert("OnSearchEnd Event Error : " + ex);}
	}

	//높이 또는 너비가 변경된 경우 각 컬럼의 너비를 새로 맞춘다.
    //setSheetSize(employeeLayerSheet);
	function employeeLayerSheet_OnResize(lWidth, lHeight) {
		try {
			// setSheetSize(employeeLayerSheet);
            sheetResize();
		} catch (ex) {
			alert("OnResize Event Error : " + ex);
		}
	}

	function employeeLayerSheet_OnDblClick(Row, Col){
        
        returnFindUser(Row,Col);
		// try{
		// 	returnFindUser(Row,Col);
		// }
		// catch(ex){
		// 	alert("OnDblClick Event Error : " + ex);
		// }
		// finally{
		// 	p.self.close();;
		// }
	}

	function returnFindUser(Row,Col){
	    if( employeeLayerSheet.GetCellValue(1,0) == undefined ) {
	    	alert("<msg:txt mid='alertAuthEmp1' mdef='대상 직원에 대한 조회 권한이 없거나 해당사원이 존재 하지 않습니다.'/>");
	        return;
	    }
	    if(employeeLayerSheet.RowCount() <= 0) {
	    	//alert("<msg:txt mid='alertAuthEmp1' mdef='대상 직원에 대한 조회 권한이 없거나 해당사원이 존재 하지 않습니다.'/>");
	    	return;
	    }

    	var returnValue = new Array(26);
    	$("#selectedUserId").val(employeeLayerSheet.GetCellValue(Row,"empSabun"));

	    //임직원 데이터를 가져올땐 '퇴직자 제외' 체크여부와 상관없이 데이터 조회
	    var srcStatusCd = $("#searchStatusCd").val();
    	$("#searchStatusCd").val('A');

    	var user = ajaxCall("/Employee.do?cmd=getBaseEmployeeDetail",$("#mySheetForm").serialize(),false);
        if(user.map != null && user.map != "undefine") user = user.map;

    	$("#searchStatusCd").val(srcStatusCd);

        const modal = window.top.document.LayerModalUtility.getModal('employeeLayer');
        modal.fire('employeeTrigger', {
            enterCd : user.enterCd
            , enterNm : user.enterNm
            , sabun : user.sabun
            , name : user.name
            , alias : user.empAlias
            , sexType : user.sexType
            , empYmd : user.empYmd
            , gempYmd : user.gempYmd
            , traYmd : user.traYmd
            , retYmd : user.retYmd
            , jikchakCd : user.jikchakCd
            , jikchakNm : user.jikchakNm
            , jikweeCd : user.jikweeCd
            , jikweeNm : user.jikweeNm
            , jikgubCd : user.jikgubCd
            , jikgubNm : user.jikgubNm
            , manageCd : user.manageCd
            , manageNm : user.manageNm
            , workType : user.workType
            , workTypeNm : user.workTypeNm
            , payType : user.payType
            , payTypeNm : user.payTypeNm
            , orgCd : user.orgCd
            , orgNm : user.orgNm
            , statusCd : user.statusCd
            , statusNm : user.statusNm
            , jobCd : user.jobCd
            , jobNm : user.jobNm
            , locationCd : user.locationCd
            , locationNm : user.locationNm
            , resNo : user.resNo
            , cresNo : user.cresNo
            , yearYmd : user.yearYmd
            , businessPlaceCd : user.businessPlaceCd
            , ccCd : user.ccCd
            , birYmd : user.birYmd
            , lunType : user.lunType
            , ename1 : user.ename1
            , officeTel : user.officeTel
            , homeTel : user.homeTel
            , faxNo : user.faxNo
            , handPhone : user.handPhone
            , connectTel : user.connectTel
            , mailId : user.mailId
            , outMailId : user.outMailId
            , currJikgubYmd	: user.currJikgubYmd
            , workYyCnt : user.workYyCnt
            , workMmCnt : user.workMmCnt
            , jikgubYear : user.jikgubYear
            , hqOrgCd : user.hqOrgCd
            , hqOrgNm : user.hqOrgNm
            , rk : user.rk
        }).hide();

    	// // if(user.map != null && user.map != "undefine") user = user.map;
    	// returnValue["enterCd"] 		= user.enterCd;
    	// returnValue["enterNm"] 		= user.enterNm;
    	// returnValue["sabun"] 		= user.sabun;
 		// returnValue["name"] 		= user.name;
 		// returnValue["alias"]     	= user.empAlias;
 		// returnValue["sexType"] 		= user.sexType;
 		// returnValue["empYmd"] 		= user.empYmd;
 		// returnValue["gempYmd"] 		= user.gempYmd;
 		// returnValue["traYmd"] 		= user.traYmd;
 		// returnValue["retYmd"] 		= user.retYmd;
 		// returnValue["jikchakCd"] 	= user.jikchakCd;
 		// returnValue["jikchakNm"] 	= user.jikchakNm;
 		// returnValue["jikweeCd"] 	= user.jikweeCd;
 		// returnValue["jikweeNm"] 	= user.jikweeNm;
 		// returnValue["jikgubCd"] 	= user.jikgubCd;
 		// returnValue["jikgubNm"] 	= user.jikgubNm;
		// returnValue["manageCd"]		= user.manageCd;
		// returnValue["manageNm"]		= user.manageNm;
 		// returnValue["workType"] 	= user.workType;
 		// returnValue["workTypeNm"] 	= user.workTypeNm;
		// returnValue["payType"]    	= user.payType;
		// returnValue["payTypeNm"]    = user.payTypeNm;
		// returnValue["orgCd"]    	= user.orgCd;
		// returnValue["orgNm"]    	= user.orgNm;
		// returnValue["statusCd"]		= user.statusCd;
		// returnValue["statusNm"]		= user.statusNm;
		// returnValue["jobCd"]		= user.jobCd;
		// returnValue["jobNm"]		= user.jobNm;
		// returnValue["locationCd"]	= user.locationCd;
		// returnValue["locationNm"]	= user.locationNm;
		// returnValue["resNo"]		= user.resNo;
		// returnValue["cresNo"]		= user.cresNo;
		// returnValue["yearYmd"]		= user.yearYmd;
		// returnValue["businessPlaceCd"]	= user.businessPlaceCd;
		// returnValue["ccCd"]				= user.ccCd;
		// returnValue["birYmd"]			= user.birYmd;
		// returnValue["lunType"]			= user.lunType;
		// returnValue["ename1"]			= user.ename1;
		// /*연락처 추가 - Order : CBS , Coding : JSG*/
		// returnValue["officeTel"]		= user.officeTel;
		// returnValue["homeTel"]			= user.homeTel;
		// returnValue["faxNo"]			= user.faxNo;
		// returnValue["handPhone"]		= user.handPhone;
		// returnValue["connectTel"]		= user.connectTel;
		// returnValue["mailId"]			= user.mailId;
		// returnValue["outMailId"]		= user.outMailId;
		// /*직급년차 등 추가 - Order : CHJ , Coding : JSG*/
		// returnValue["currJikgubYmd"]	= user.currJikgubYmd;
		// returnValue["workYyCnt"]		= user.workYyCnt;
		// returnValue["workMmCnt"]		= user.workMmCnt;
		// //직급년차 추가 2020.07.28
		// returnValue["jikgubYear"]		= user.jikgubYear;
		// //본부 추가 2020.08.24
		// returnValue["hqOrgCd"]		    = user.hqOrgCd;
		// returnValue["hqOrgNm"]		    = user.hqOrgNm;
        //
		// if(p.popReturnValue) p.popReturnValue(returnValue);
		// p.self.close();
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
    function employeeLayerSheet_OnKeyDown(Row, Col, KeyCode, Shift) {
        try {
            // Insert KEY
            if (KeyCode == 13) {
                returnFindUser(Row,Col);
            }

        } catch (ex) {
            alert("OnKeyDown Event Error : " + ex);
        }
    }
</script>

</head>
<body class="bodywrap">
    <div class="wrapper modal_layer">
        <div class="modal_body">
            <form id="mySheetForm" name="mySheetForm">
                <input type="hidden" id="searchEnterCd" name="searchEnterCd" value=""/>
                <input type="hidden" id="searchStatusCd" name="searchStatusCd" value="RA"/>
                <input type="hidden" id="searchEmpType" name="searchEmpType" value="P"/> <!-- 팝업에서 사용 -->
                <input type="hidden" id="selectedUserId" name="selectedUserId" />
                <div class="sheet_search outer">
                    <div>
                    <table>
                    <tr>
                    	<th><tit:txt mid='112947' mdef='성명/사번'/></th>
                        <td>  <input id="searchKeyword" name ="searchKeyword" type="text" class="text" style="ime-mode:active;"/> </td>
                        <td id="searchStatusRadioDiv">
                        	<input name="searchStatusRadio" onchange="$('#searchStatusCd').val('RA');" checked="checked" type="radio"  class="radio" id="retireeExclude"/><label for="retireeExclude"><tit:txt mid='113521' mdef='퇴직자 제외'/></label>
							<input name="searchStatusRadio" onchange="$('#searchStatusCd').val('A');" type="radio" class="radio" id="retireeInclude" /><label for="retireeInclude"><tit:txt mid='114221' mdef='퇴직자 포함'/></label>
                        </td>
                        <td>
                            <btn:a href="javascript:doActionEmp('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/>
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
                                    <li id="txt" class="txt"><tit:txt mid='schEmployee' mdef='사원조회'/></li>
                                </ul>
                            </div>
                        </div>
                        <div id="employeeLayerSheet-wrap"></div>
                        <!-- <script type="text/javascript">createIBSheet("employeeLayerSheet", "100%", "100%","${ssnLocaleCd}"); </script> -->
                    </td>
                </tr>
            </table>
        </div>
        <div class="modal_footer">
            <btn:a href="javascript:closeCommonLayer('employeeLayer');" css="btn outline_gray" mid='110881' mdef="닫기"/>
        </div>
    </div>
</body>
</html>
