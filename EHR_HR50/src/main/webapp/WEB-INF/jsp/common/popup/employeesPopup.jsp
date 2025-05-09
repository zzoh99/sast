<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='113773' mdef='임직원 조회 팝업'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var srchBizCd = null;
	var p = eval("${popUpStatus}");
	var openSheetNm = null;
	var openSheet = null;

	/*Sheet 기본 설정 */
	$(function() {
		var arg = p.window.dialogArguments;

		if( arg != undefined ) {
			openSheet		= p.popDialogSheet(arg["sheetNm"]);
		}else{
			openSheet		= p.popDialogSheet(p.popDialogArgument("sheetNm"));
		}

		var sType 			= "";
		var topKeyword  	= "";
		var searchEnterCd  	= "";

	    if( arg != undefined ) {
	    	sType 	   = arg["sType"];
	    	topKeyword = arg["topKeyword"];
	    	searchEnterCd = arg["searchEnterCd"];
	    }else{
			if ( p.popDialogArgument("sType") !=null ) { sType			   				= p.popDialogArgument("sType"); }
			if ( p.popDialogArgument("topKeyword") !=null ) { topKeyword		   		= p.popDialogArgument("topKeyword"); }
			if ( p.popDialogArgument("searchEnterCd") !=null ) { searchEnterCd			= p.popDialogArgument("searchEnterCd"); }
	    }

		//top 에서 검색시 T를 넣어줌=> 전사원 검색이 가능
		//팝업에서 검색시 P를 기본적으로 가져감 => 권한에 따른 검색
		//INCLUDE 에서 검색시 I를 기본적으로 가져감  => 권한에 따른 검색
		$("#searchEmpType").val(sType);
		$("#searchKeyword").val(topKeyword);
		$("#searchEnterCd").val(searchEnterCd);


		//배열 선언
		var initdata = {};
		//SetConfig
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:4, DataRowMerge:0};
		//HeaderMode
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		//InitColumns + Header Title
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:0,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus" },
			{Header:"<sht:txt mid='check' mdef='선택'/>",		Type:"DummyCheck",	Hidden:0,	Width:50,			Align:"Center",	ColMerge:0,	SaveName:"selectChk",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
 			{Header:"<sht:txt mid='enterCd' mdef='회사명'/>",		Type:"Text",		Hidden:1,	Width:0,			Align:"Center",	ColMerge:0,	SaveName:"enterNm", UpdateEdit:0 },
 			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",		Hidden:0,	Width:100,			Align:"Center",	ColMerge:0,	SaveName:"empSabun", UpdateEdit:0 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",		Type:"Text",		Hidden:0,	Width:100,			Align:"Center",	ColMerge:0,	SaveName:"empName", UpdateEdit:0 },
			{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",		Type:"Text",		Hidden:1,	Width:100,			Align:"Center",	ColMerge:0,	SaveName:"empAlias", UpdateEdit:0 },
			{Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",		Type:"Text",		Hidden:0,	Width:200,			Align:"Left",	ColMerge:0,	SaveName:"orgNm", UpdateEdit:0 },
			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",		Type:"Text",		Hidden:0,	Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikchakNm", UpdateEdit:0 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",		Type:"Text",		Hidden:1,	Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikweeNm", UpdateEdit:0 },
			{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",		Type:"Text",		Hidden:1,	Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikgubNm", UpdateEdit:0 },
			{Header:"<sht:txt mid='statusCdV1' mdef='재직\n상태'/>",	Type:"Text",		Hidden:0,	Width:45,			Align:"Center",	ColMerge:0,	SaveName:"statusNm", UpdateEdit:0 }

		];
		IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(4);sheet1.SetEditableColorDiff (0);

		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:0,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus" },
			{Header:"<sht:txt mid='check' mdef='선택'/>",		Type:"DummyCheck",	Hidden:1,	Width:50,			Align:"Center",	ColMerge:0,	SaveName:"selectChk",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
 			{Header:"<sht:txt mid='enterCd' mdef='회사명'/>",		Type:"Text",		Hidden:1,	Width:0,			Align:"Center",	ColMerge:0,	SaveName:"enterNm", UpdateEdit:0 },
 			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",		Hidden:0,	Width:100,			Align:"Center",	ColMerge:0,	SaveName:"empSabun", UpdateEdit:0 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",		Type:"Text",		Hidden:0,	Width:100,			Align:"Center",	ColMerge:0,	SaveName:"empName", UpdateEdit:0 },
			{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",		Type:"Text",		Hidden:1,	Width:100,			Align:"Center",	ColMerge:0,	SaveName:"empAlias", UpdateEdit:0 },
			{Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",		Type:"Text",		Hidden:0,	Width:200,			Align:"Left",	ColMerge:0,	SaveName:"orgNm", UpdateEdit:0 },
			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",		Type:"Text",		Hidden:0,	Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikchakNm", UpdateEdit:0 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",		Type:"Text",		Hidden:1,	Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikweeNm", UpdateEdit:0 },
			{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",		Type:"Text",		Hidden:1,	Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikgubNm", UpdateEdit:0 },
			{Header:"<sht:txt mid='statusCdV1' mdef='재직\n상태'/>",	Type:"Text",		Hidden:0,	Width:45,			Align:"Center",	ColMerge:0,	SaveName:"statusNm", UpdateEdit:0 }

		];
		IBS_InitSheet(sheet2, initdata); sheet2.SetCountPosition(4);sheet2.SetEditableColorDiff (0);

		$(window).smartresize(sheetResize);
		sheetInit();

		//검색어 있을경우 검색
		if($("#searchKeyword").val() != ""){
			doAction("Search");
		}

        $("#searchKeyword").bind("keyup",function(event){
			if( event.keyCode == 13){
		 		doAction("Search");
			}
		});

        $(".close").click(function() {
	    	p.self.close();
	    });
	});

	/*Sheet Action*/
	function doAction(sAction) {
		switch (sAction) {
			case "Search": //조회
				if( ( $.trim( $("#searchKeyword").val( )) ) == "" ){
					alert("<msg:txt mid='109671' mdef='성명 또는 사번을 입력하세요.'/>");
					$("#searchKeyword").focus();
				}else{
				    //sheet1.DoSearch( "${ctx}/Popup.do?cmd=getEmployeeList", $("#mySheetForm").serialize() );
				    sheet1.DoSearch( "${ctx}/Employee.do?cmd=employeeList", $("#mySheetForm").serialize(),1 );
				}
	            break;
		}
    }

	// 	조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, ErrMsg, StCode, StMsg) {
		try{
		  	if(sheet1.RowCount() == 0) {
		    	alert("<msg:txt mid='alertAuthEmp1' mdef='대상 직원에 대한 조회 권한이 없거나 해당사원이 존재 하지 않습니다.'/>");
		  	}
		  	sheet1.FocusAfterProcess = false;
			setSheetSize(sheet1);
	  	}catch(ex){alert("OnSearchEnd Event Error : " + ex);}
	}

	//높이 또는 너비가 변경된 경우 각 컬럼의 너비를 새로 맞춘다.
    //setSheetSize(sheet1);
	function sheet1_OnResize(lWidth, lHeight) {
		try {
			setSheetSize(sheet1);
		} catch (ex) {
			alert("OnResize Event Error : " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			if(sheet1.ColSaveName(Col) == "selectChk") {
				if(Value == 1) {
					var row = sheet2.DataInsert(0);
					for(var i = 0 ; i < sheet1.LastCol(); i++) {
						sheet2.SetCellValue(row, i, sheet1.GetCellValue(Row, i));
					}
				} else {
					for(var i = 1 ; i <= sheet2.RowCount(); i++){
						if(sheet2.GetCellValue(i, "empSabun") == sheet1.GetCellValue(Row, "empSabun")) {
							sheet2.RowDelete(i,0);
						}
					}
				}
			}
		}
		catch(ex){
			alert("OnClick Event Error : " + ex);
		}
	}

	function sheet1_OnDblClick(Row, Col){
		try{
			//returnFindUser(Row,Col);
		}
		catch(ex){
			alert("OnDblClick Event Error : " + ex);
		}
		finally{
			//p.self.close();
		}
	}

	var idx = 0;
	/*
	function returnFindUser(Row,Col){
	    if( sheet1.GetCellValue(1,0) == undefined ) {
	         alert("<msg:txt mid='alertAuthEmp1' mdef='대상 직원에 대한 조회 권한이 없거나 해당사원이 존재 하지 않습니다.'/>");
	        return;
	    }
	    if(sheet1.RowCount() <= 0) {
	      alert("<msg:txt mid='alertAuthEmp1' mdef='대상 직원에 대한 조회 권한이 없거나 해당사원이 존재 하지 않습니다.'/>");
	      return;
	    }

    	var returnValue = new Array(26);
    	$("#searchUserId").val(sheet1.GetCellValue(Row,"empSabun"));

    	var user = ajaxCall("/Employee.do?cmd=getBaseEmployeeDetail",$("#mySheetForm").serialize(),false);

    	if(user.map != null && user.map != "undefine") user = user.map;
    	returnValue["sabun"] 		= user.sabun;
 		returnValue["name"] 		= user.name;
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
		//연락처 추가 - Order : CBS , Coding : JSG
		returnValue["officeTel"]		= user.officeTel;
		returnValue["homeTel"]			= user.homeTel;
		returnValue["faxNo"]			= user.faxNo;
		returnValue["handPhone"]		= user.handPhone;
		returnValue["connectTel"]		= user.connectTel;
		returnValue["mailId"]			= user.mailId;
		returnValue["outMailId"]		= user.outMailId;
		//직급년차 등 추가 - Order : CHJ , Coding : JSG
		returnValue["currJikgubYmd"]	= user.currJikgubYmd;
		returnValue["workYyCnt"]		= user.workYyCnt;
		returnValue["workMmCnt"]		= user.workMmCnt;
		if(idx > 0) {
			var row = openSheet.DataInsert(0);
			openSheet.SetSelectRow(row);
		}
		if(p.popReturnValue) p.popReturnValue(returnValue);
		idx++;
	}
	*/


	function returnFindUser2(Row){
	    if( sheet2.GetCellValue(1,0) == undefined ) {
	         alert("<msg:txt mid='alertAuthEmp1' mdef='대상 직원에 대한 조회 권한이 없거나 해당사원이 존재 하지 않습니다.'/>");
	        return;
	    }
	    if(sheet2.RowCount() <= 0) {
	      alert("<msg:txt mid='alertAuthEmp1' mdef='대상 직원에 대한 조회 권한이 없거나 해당사원이 존재 하지 않습니다.'/>");
	      return;
	    }

    	var returnValue = new Array(26);
    	$("#selectedUserId").val(sheet2.GetCellValue(Row,"empSabun"));

    	var user = ajaxCall("/Employee.do?cmd=getBaseEmployeeDetail",$("#mySheetForm").serialize(),false);

    	if(user.map != null && user.map != "undefine") user = user.map;
    	returnValue["sabun"] 		= user.sabun;
 		returnValue["name"] 		= user.name;
 		returnValue["empAlias"] 	= user.empAlias;
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

		if(idx > 0) {
			var row = openSheet.DataInsert(0);
			openSheet.SetSelectRow(row);
		}
		if(p.popReturnValue) p.popReturnValue(returnValue);
		idx++;
	}

	function fnConfirm() {
		for(var i = 1 ; i <= sheet2.RowCount() ; i++) {
			returnFindUser2(i);
		}
		p.self.close();
	}
</script>

</head>
<body class="bodywrap">
    <div class="wrapper">
        <div class="popup_title">
            <ul>
                <li><tit:txt mid='schEmployee' mdef='사원조회'/></li>
                <li class="close"></li>
            </ul>
        </div>
        <div class="popup_main">
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
                        <td> <input name="searchStatusRadio" onchange="$('#searchStatusCd').val('RA');" checked="checked" type="radio"  class="radio"/> <tit:txt mid='113521' mdef='퇴직자 제외'/></td>
                        <td> <input name="searchStatusRadio" onchange="$('#searchStatusCd').val('A');" type="radio" class="radio"/><tit:txt mid='114221' mdef='퇴직자 포함'/></td>
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
			<script type="text/javascript">createIBSheet("sheet1", "100%", "330px", "${ssnLocaleCd}"); </script>

			<div class="sheet_title">
			<ul>
				<li id="txt" class="txt"><tit:txt mid='112367' mdef='선택사원'/></li>
			</ul>
			</div>
			<script type="text/javascript">createIBSheet("sheet2", "100%", "30%", "${ssnLocaleCd}"); </script>

	        <div class="popup_button outer">
	            <ul>
	                <li>
	                    <btn:a href="javascript:fnConfirm();" css="pink large" mid='110716' mdef="확인"/>
	                    <btn:a href="javascript:p.self.close();" css="gray large" mid='110881' mdef="닫기"/>
	                </li>
	            </ul>
	        </div>
        </div>
    </div>
</body>
</html>
