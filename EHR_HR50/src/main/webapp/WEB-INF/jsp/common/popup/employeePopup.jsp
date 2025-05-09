<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='113773' mdef='임직원 조회 팝업'/></title>

<script type="text/javascript">
	var srchBizCd = null;

	/*Sheet 기본 설정 */
	$(function() {
        var modal = window.top.document.LayerModalUtility.getModal('employeeLayer');
        createIBSheet3(document.getElementById('employee-wrap'), "employeeSheet", "100%", "100%", "${ssnLocaleCd}");

		var sType 			= "";
		var topKeyword  	= "";
		var searchEnterCd  	= "";
		var isHideRet = "N";
	    if( modal != undefined ) {
	    	sType 	   = modal.parameters.sType;
	    	topKeyword = modal.parameters.topKeyword;
	    	searchEnterCd = modal.parameters.searchEnterCd;
	    	isHideRet = modal.parameters.isHideRet;
	    }

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
		IBS_InitSheet(employeeSheet, initdata); employeeSheet.SetCountPosition(4);employeeSheet.SetEditableColorDiff (0);

		$(window).smartresize(sheetResize); sheetInit();
        var sheetHeigth = $(".modal_body").height() - $("#mySheetForm").height() -  $(".sheet_title").height() -2;
        employeeSheet.SetSheetHeight(sheetHeigth < 0 ? $(".modal_body").height() : sheetHeigth);

		$("#searchKeyword").focus();

		//검색어 있을경우 검색
		if($("#searchKeyword").val() != ""){
			doAction("Search");
		}

		//임직원공통인 경우 퇴직자검색조건 숨김
		if("${grpCd}" == "99") {
			$("#searchStatusRadioDiv").hide();
		}

        $("#searchKeyword").bind("keyup",function(event){
			if( event.keyCode == 13){
				$(this).blur();
		 		doAction("Search");
		 		event.preventDefault();
			}
		});

        $(".close").click(function() {
	    	closeCommonLayer('employeeLayer');
	    });
		sheetResize();
	});

	/*Sheet Action*/
	function doAction(sAction) {
		switch (sAction) {
			case "Search": //조회
				if( ( $.trim( $("#searchKeyword").val( )) ) == "" ){
					alert("<msg:txt mid='109671' mdef='성명 또는 사번을 입력하세요.'/>");
					$("#searchKeyword").focus();
				}else{
				    //employeeSheet.DoSearch( "${ctx}/Popup.do?cmd=getEmployeeList", $("#mySheetForm").serialize() );
				    employeeSheet.DoSearch( "${ctx}/Employee.do?cmd=employeeList", $("#mySheetForm").serialize(),1 );
				}
	            break;
		}
    }

	// 	조회 후 에러 메시지
	function employeeSheet_OnSearchEnd(Code, ErrMsg, StCode, StMsg) {
		try{
		  	if(employeeSheet.RowCount() == 0) {
		    	alert("<msg:txt mid='alertAuthEmp1' mdef='대상 직원에 대한 조회 권한이 없거나 해당사원이 존재 하지 않습니다.'/>");
		  	}

			// setSheetSize(employeeSheet);
            sheetResize();
	  	}catch(ex){alert("OnSearchEnd Event Error : " + ex);}
	}

	//높이 또는 너비가 변경된 경우 각 컬럼의 너비를 새로 맞춘다.
    //setSheetSize(employeeSheet);
	function employeeSheet_OnResize(lWidth, lHeight) {
		try {
			// setSheetSize(employeeSheet);
            sheetResize();
		} catch (ex) {
			alert("OnResize Event Error : " + ex);
		}
	}

	function employeeSheet_OnDblClick(Row, Col){
		try{
			returnFindUser(Row,Col);
		}
		catch(ex){
			alert("OnDblClick Event Error : " + ex);
		}
		finally{
			closeCommonLayer('employeeLayer');
		}
	}

	function returnFindUser(Row,Col){
	    if( employeeSheet.GetCellValue(1,0) == undefined ) {
	    	alert("<msg:txt mid='alertAuthEmp1' mdef='대상 직원에 대한 조회 권한이 없거나 해당사원이 존재 하지 않습니다.'/>");
	        return;
	    }
	    if(employeeSheet.RowCount() <= 0) {
	    	//alert("<msg:txt mid='alertAuthEmp1' mdef='대상 직원에 대한 조회 권한이 없거나 해당사원이 존재 하지 않습니다.'/>");
	    	return;
	    }

    	var returnValue = new Array(26);
    	$("#selectedUserId").val(employeeSheet.GetCellValue(Row,"empSabun"));

	    //임직원 데이터를 가져올땐 '퇴직자 제외' 체크여부와 상관없이 데이터 조회
	    var srcStatusCd = $("#searchStatusCd").val();
    	$("#searchStatusCd").val('A');

    	var user = ajaxCall("/Employee.do?cmd=getBaseEmployeeDetail",$("#mySheetForm").serialize(),false);

    	$("#searchStatusCd").val(srcStatusCd);

    	if(user.map != null && user.map != "undefine") user = user.map;
    	returnValue["enterCd"] 		= user.enterCd;
    	returnValue["enterNm"] 		= user.enterNm;
    	returnValue["sabun"] 		= user.sabun;
 		returnValue["name"] 		= user.name;
 		returnValue["alias"]     	= user.empAlias;
 		returnValue["sexType"] 		= user.sexType;
 		returnValue["empYmd"] 		= user.empYmd;
 		returnValue["gempYmd"] 		= user.gempYmd;
 		returnValue["traYmd"] 		= user.traYmd;
 		returnValue["retYmd"] 		= user.retYmd;
 		returnValue["jikchakCd"] 	= user.jikchakCd;
 		returnValue["jikchakNm"] 	= user.jikchakNm;
 		returnValue["jikweeCd"] 	= user.jikweeCd;
 		returnValue["jikweeNm"] 	= user.jikweeNm;
 		returnValue["jikgubCd"] 	= user.jikgubCd;
 		returnValue["jikgubNm"] 	= user.jikgubNm;
		returnValue["manageCd"]		= user.manageCd;
		returnValue["manageNm"]		= user.manageNm;
 		returnValue["workType"] 	= user.workType;
 		returnValue["workTypeNm"] 	= user.workTypeNm;
		returnValue["payType"]    	= user.payType;
		returnValue["payTypeNm"]    = user.payTypeNm;
		returnValue["orgCd"]    	= user.orgCd;
		returnValue["orgNm"]    	= user.orgNm;
		returnValue["statusCd"]		= user.statusCd;
		returnValue["statusNm"]		= user.statusNm;
		returnValue["jobCd"]		= user.jobCd;
		returnValue["jobNm"]		= user.jobNm;
		returnValue["locationCd"]	= user.locationCd;
		returnValue["locationNm"]	= user.locationNm;
		returnValue["resNo"]		= user.resNo;
		returnValue["cresNo"]		= user.cresNo;
		returnValue["yearYmd"]		= user.yearYmd;
		returnValue["businessPlaceCd"]	= user.businessPlaceCd;
		returnValue["ccCd"]				= user.ccCd;
		returnValue["birYmd"]			= user.birYmd;
		returnValue["lunType"]			= user.lunType;
		returnValue["ename1"]			= user.ename1;
		/*연락처 추가 - Order : CBS , Coding : JSG*/
		returnValue["officeTel"]		= user.officeTel;
		returnValue["homeTel"]			= user.homeTel;
		returnValue["faxNo"]			= user.faxNo;
		returnValue["handPhone"]		= user.handPhone;
		returnValue["connectTel"]		= user.connectTel;
		returnValue["mailId"]			= user.mailId;
		returnValue["outMailId"]		= user.outMailId;
		/*직급년차 등 추가 - Order : CHJ , Coding : JSG*/
		returnValue["currJikgubYmd"]	= user.currJikgubYmd;
		returnValue["workYyCnt"]		= user.workYyCnt;
		returnValue["workMmCnt"]		= user.workMmCnt;
		//직급년차 추가 2020.07.28
		returnValue["jikgubYear"]		= user.jikgubYear;  
		//본부 추가 2020.08.24
		returnValue["hqOrgCd"]		    = user.hqOrgCd;
		returnValue["hqOrgNm"]		    = user.hqOrgNm;

        var rtnModal = window.top.document.LayerModalUtility.getModal('employeeLayer');
        rtnModal.fire("employeeTrigger", returnValue).hide();
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
    function employeeSheet_OnKeyDown(Row, Col, KeyCode, Shift) {
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
                        	<input name="searchStatusRadio" onchange="$('#searchStatusCd').val('RA');" checked="checked" type="radio"  class="radio"/>  <tit:txt mid='113521' mdef='퇴직자 제외'/>
							<input name="searchStatusRadio" onchange="$('#searchStatusCd').val('A');" type="radio" class="radio"/>  <tit:txt mid='114221' mdef='퇴직자 포함'/>
                        </td>
                        <td>
                            <btn:a href="javascript:doAction('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/>
                        </td>
                    </tr>
                    </table>
                    </div>
                </div>

	        </form>
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li id="txt" class="txt"><tit:txt mid='schEmployee' mdef='사원조회'/></li>
				</ul>
				</div>
			</div>

            <div id="employee-wrap"></div>

        </div>
        <div class="modal_footer">
            <a href="javascript:closeCommonLayer('employeeLayer');" class="btn outline_gray">닫기</a>
        </div>
    </div>
</body>
</html>
