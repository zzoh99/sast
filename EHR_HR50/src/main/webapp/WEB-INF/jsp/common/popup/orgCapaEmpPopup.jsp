<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>임직원 조회 팝업</title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var p = eval("${popUpStatus}");
	var srchBizCd = null;
	var ssnSearchType = "";	

	/*Sheet 기본 설정 */
	$(function() {
    
		var searchOrgCd 	= "";
        var searchOrgNm 	= "";
        var searchColNm 	= "";
        var searchBaseDate 	= "";
		var searchMonth 	= "";
		var searchMonthEnd 	= "";
		// 발령타입
		var searchOrdTypeCd = "";
		var groupEnterCd = "";
		
		var except1 	= "";
		var except2 	= "";
		var except3 	= "";
		
        ssnSearchType = "${ssnSearchType}";
        
        var arg = p.window.dialogArguments;
	    if( arg != undefined ) {
			searchOrgCd 	= arg["orgCd"];
	        searchOrgNm 	= arg["orgNm"];
	        searchColNm 	= arg["colNm"];
	        searchBaseDate 	= arg["baseDate"];
			searchMonth 	= arg["month"];			
			searchYear 	    = arg["year"];
			groupEnterCd	= arg["groupEnterCd"];
			
	    	except1		= arg["except1"];
	    	except2		= arg["except2"];
	    	except3		= arg["except3"];					

	    }else{
	    	if(p.popDialogArgument("orgCd")!=null)		searchOrgCd  	= p.popDialogArgument("orgCd");
	    	if(p.popDialogArgument("orgNm")!=null)		searchOrgNm  	= p.popDialogArgument("orgNm");
	    	if(p.popDialogArgument("colNm")!=null)		searchColNm  	= p.popDialogArgument("colNm");
	    	if(p.popDialogArgument("baseDate")!=null)	searchBaseDate  = p.popDialogArgument("baseDate");
			if(p.popDialogArgument("month")!=null)		searchMonth  	= p.popDialogArgument("month");
			if(p.popDialogArgument("year")!=null)		searchYear  	= p.popDialogArgument("year");
			if(p.popDialogArgument("ordTypeCd")!=null)			searchOrdTypeCd  	= p.popDialogArgument("ordTypeCd");
			if(p.popDialogArgument("groupEnterCd")!=null)		groupEnterCd  	= p.popDialogArgument("groupEnterCd");
			
			if(p.popDialogArgument("except1")!=null)		except1  	= p.popDialogArgument("except1");
			if(p.popDialogArgument("except2")!=null)		except2  	= p.popDialogArgument("except2");
			if(p.popDialogArgument("except3")!=null)		except3  	= p.popDialogArgument("except3");
		}
		
		var titleTxt;

		if( searchMonth == "00") {
			
			titleTxt = searchOrgNm + " " + searchBaseDate + " 현인원(" + searchColNm + ")";
			searchMonth = searchYear + "0101";

			if( searchYear == "${curSysYear}" ) {
				searchMonthEnd = "${curSysYyyyMMdd}";
			} else {
				//searchMonthEnd = searchYear + "1231";
				
				searchMonthEnd = searchBaseDate;
			}
			
			if(searchOrdTypeCd == ""){
				searchMonth = "";
			}
			
			
		} else {
			titleTxt = searchOrgNm + " " + searchYear + "년 " + searchMonth + "월(" + searchColNm + ")";
			searchMonth =  searchYear + searchMonth + "01";
		}        
        	
        $("#searchOrgCd").val(searchOrgCd);
        $("#titleTxt").html(titleTxt);
        $("#searchBaseDate").val(searchBaseDate);
		$("#searchMonth").val(searchMonth);
		$("#searchMonthEnd").val(searchMonthEnd);
		$("#searchOrdTypeCd").val(searchOrdTypeCd);
		$("#groupEnterCd").val(groupEnterCd);		
		
		$("#except1").val(except1);
		$("#except2").val(except2);
		$("#except3").val(except3);
        
		//배열 선언				
		var initdata = {};
		//SetConfig
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:4, DataRowMerge:0};
		//HeaderMode
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		//InitColumns + Header Title
		initdata.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:0,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",			Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete" },
			{Header:"상태",			Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus" },
			{Header:"회사코드",		Type:"Text",		Hidden:1,	Width:0,			Align:"Center",	ColMerge:0,	SaveName:"enterCd", UpdateEdit:0 },
 			{Header:"회사명",			Type:"Text",		Hidden:1,	Width:0,			Align:"Center",	ColMerge:0,	SaveName:"enterNm", UpdateEdit:0 },
 			{Header:"프로필",			Type:"Image",		Hidden:1,	Width:40,			Align:"Center",	ColMerge:1,	SaveName:"detail0",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0},
 			{Header:"사진",			Type:"Image",		Hidden:0,	Width:90,			Align:"Center",	ColMerge:0,	SaveName:"photo",	UpdateEdit:0, ImgWidth:80, ImgHeight:90 },
 			{Header:"사번",			Type:"Text",		Hidden:0,	Width:50,			Align:"Center",	ColMerge:0,	SaveName:"empSabun", UpdateEdit:0 },
			{Header:"성명",			Type:"Text",		Hidden:0,	Width:60,			Align:"Center",	ColMerge:0,	SaveName:"empName", UpdateEdit:0 },
			{Header:"소속",			Type:"Text",		Hidden:0,	Width:130,			Align:"Center",	ColMerge:0,	SaveName:"orgNm", UpdateEdit:0 },
			{Header:"직책",			Type:"Text",		Hidden:0,	Width:80,			Align:"Center",	ColMerge:0,	SaveName:"jikchakNm", UpdateEdit:0 },
			{Header:"직위",			Type:"Text",		Hidden:0,	Width:80,			Align:"Center",	ColMerge:0,	SaveName:"jikweeNm", UpdateEdit:0 },
			{Header:"재직\n상태",		Type:"Text",		Hidden:1,	Width:45,			Align:"Center",	ColMerge:0,	SaveName:"statusNm", UpdateEdit:0 },
			{Header:"조회권한",		Type:"Text",		Hidden:1,	Width:45,			Align:"Center",	ColMerge:0,	SaveName:"authYn", UpdateEdit:0 }
			
		];                  
		IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(4);sheet1.SetEditableColorDiff (0);

		sheet1.SetImageList(1,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("detail0",1);
		
		$(window).smartresize(sheetResize);
		sheetInit();
		
		doAction("Search");

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
				sheet1.DoSearch( "${ctx}/OrgCapaEmpPopup.do?cmd=getOrgCapaEmpList", $("#mySheetForm").serialize() );
	            break;
		}
    } 
	
	// 	조회 후 에러 메시지 
	function sheet1_OnSearchEnd(Code, ErrMsg, StCode, StMsg) {
		try{
		  	if(sheet1.RowCount() == 0) {
		    	alert("대상 직원에 대한 조회 권한이 없거나 해당사원이 존재 하지 않습니다.");
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
	function sheet1_OnDblClick(Row, Col){
		try{
			returnFindUser(Row,Col);
		}catch(ex){alert("OnDblClick Event Error : " + ex);}
	}
	
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {

		var authYn = sheet1.GetCellValue(Row, "authYn");
		
		if(sheet1.ColSaveName(Col) == "detail0" && Value != "") {
			if(ssnSearchType == "A"){
				
				if( "${profilePopYn}"=="Y"){
					// 인사기본 팝업 
					var url     = "${ctx}/EisEmployeePopup.do?cmd=viewEmployeeProfilePopup&authPg=R";
		            var args    = new Array();
		            args["sabun"]      = sheet1.GetCellValue(Row, "empSabun");
		            args["enterCd"]    = sheet1.GetCellValue(Row, "enterCd");
		            args["empName"]    = sheet1.GetCellValue(Row, "empName");
		            openPopup(url,args,"1250","780");
				}else{
					// 부모창 인사 기본으로 이동
					var returnValue    = new Array(2);
		            returnValue["sabun"]       = sheet1.GetCellValue(Row, "empSabun");
					returnValue["enterCd"]     = sheet1.GetCellValue(Row, "enterCd");

					if(p.popReturnValue) p.popReturnValue(returnValue);
					p.self.close();
				}
	            
			}else if(ssnSearchType == "P"){
				// 프로필 화면 팝업 띄우기
				var url     = "${ctx}/EmpProfilePopup.do?cmd=viewEmpProfile&authPg=${authPg}";
	            var args    = new Array();
	            args["sabun"]       = sheet1.GetCellValue(Row, "empSabun");
	            args["enterCd"]     = sheet1.GetCellValue(Row, "enterCd");
	            
				openPopup(url,args,"610","350");
			}else if(ssnSearchType == "B"){
				/*
				if( "${profilePopYn}"=="Y"){
					// 인사기본 팝업 
					var url     = "${ctx}/EisEmployeePopup.do?cmd=viewEmployeeProfilePopup&authPg=R";
		            var args    = new Array();
		            args["sabun"]      = sheet1.GetCellValue(Row, "empSabun");
		            args["enterCd"]    = sheet1.GetCellValue(Row, "enterCd");
		            args["empName"]    = sheet1.GetCellValue(Row, "empName");
		            openPopup(url,args,"1250","780");
				}else{
					// 부모창 인사 기본으로 이동
					var returnValue    = new Array(2);
		            returnValue["sabun"]       = sheet1.GetCellValue(Row, "empSabun");
					returnValue["enterCd"]     = sheet1.GetCellValue(Row, "enterCd");

					if(p.popReturnValue) p.popReturnValue(returnValue);
					p.self.close();
					
				}
				*/
				
			}else if(ssnSearchType == "O"){
				/*
				var chkVal = "N";
				var chkOrg = sheet1.GetCellValue(Row, "orgCd");
				
				if(authYn == "Y"){
					if( "${profilePopYn}"=="Y"){
						// 인사기본 팝업 
						var url     = "${ctx}/EisEmployeePopup.do?cmd=viewEmployeeProfilePopup&authPg=R";
			            var args    = new Array();
			            args["sabun"]      = sheet1.GetCellValue(Row, "empSabun");
			            args["enterCd"]    = sheet1.GetCellValue(Row, "enterCd");
			            args["empName"]    = sheet1.GetCellValue(Row, "empName");
			            openPopup(url,args,"1250","780");
					}else{
						// 부모창 인사 기본으로 이동
						var returnValue    = new Array(2);
			            returnValue["sabun"]       = sheet1.GetCellValue(Row, "empSabun");
						returnValue["enterCd"]     = sheet1.GetCellValue(Row, "enterCd");

						if(p.popReturnValue) p.popReturnValue(returnValue);
						p.self.close();
						
					}
				}else{
					 var url     = "${ctx}/EmpProfilePopup.do?cmd=viewEmpProfile&authPg=${authPg}";
	                 var args    = new Array();
	                 args["sabun"]       = sheet1.GetCellValue(Row, "empSabun");
	                 args["enterCd"]     = sheet1.GetCellValue(Row, "enterCd");
	                 
	                 openPopup(url,args,"610","350");
				}
				*/
				
			}
			
		}
	}
	
	
	function returnFindUser(Row,Col){
	    if( sheet1.GetCellValue(1,0) == undefined ) {
	         alert("대상 직원에 대한 조회 권한이 없거나 해당사원이 존재 하지 않습니다.");
	        return;
	    }
	    if(sheet1.RowCount() <= 0) {
	      alert("대상 직원에 대한 조회 권한이 없거나 해당사원이 존재 하지 않습니다.");
	      return;
	    }
	    
    	var returnValue = new Array(26);
    	$("#selectedUserId").val(sheet1.GetCellValue(Row,"empSabun"));
    	
    	var user = ajaxCall("/Employee.do?cmd=getBaseEmployeeDetail",$("#mySheetForm").serialize(),false);
    	if(user.map != null && user.map != "undefine") user = user.map;

    	returnValue["sabun"] 		= user.sabun;
 		returnValue["name"] 		= user.name;
 		returnValue["sexType"] 		= user.sexType;
 		returnValue["empYmd"] 		= user.empYmd;
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
		returnValue["resNo"]		= user.resNo;
		returnValue["cresNo"]		= user.cresNo;
		returnValue["yearYmd"]		= user.yearYmd;
		returnValue["businessPlaceCd"]	= user.businessPlaceCd;
		returnValue["ccCd"]				= user.ccCd;
		
		p.window.returnValue = returnValue;
		p.window.close();
	}
</script>

</head>
<body class="bodywrap">

    <div class="wrapper">
        <div class="popup_title">
            <ul>
                <li id="titleTxt" name="titleTxt"></li>
                <li class="close"></li>
            </ul>
        </div>
        
        <div class="popup_main">
            <form id="mySheetForm" name="mySheetForm">
                <input type="hidden" id="searchStatusCd" name="searchStatusCd" value="RA"/> 
                <input type="hidden" id="searchEmpType" name="searchEmpType" value="P"/> <!-- 팝업에서 사용 -->
                <input type="hidden" id="selectedUserId" name="selectedUserId" />
                <input type="hidden" id="searchOrgCd" name="searchOrgCd" />
                <input type="hidden" id="searchBaseDate" name="searchBaseDate" />
				<input type="hidden" id="searchMonth" name="searchMonth" />
				<input type="hidden" id="searchMonthEnd" name="searchMonthEnd" />
				<input type="hidden" id="searchOrdTypeCd" name="searchOrdTypeCd" />
				<input type="hidden" id="groupEnterCd" name="groupEnterCd" />
				
				<input type="hidden" id="except1" name="except1"/>
				<input type="hidden" id="except2" name="except2"/>
				<input type="hidden" id="except3" name="except3"/>       
				
                <!--  
                <div class="sheet_search outer">
                    <div>
                    <table>
                    <tr>
                        <td> <span>성명/사번</span> <input id="searchKeyword" name ="searchKeyword" type="text" class="text" /> </td>
                        <td> <input name="searchStatusRadio" onchange="$('#searchStatusCd').val('RA');" checked="checked" type="radio"  class="radio"/> 퇴직자 제외</td>
                        <td> <input name="searchStatusRadio" onchange="$('#searchStatusCd').val('A');" type="radio" class="radio"/> 퇴직자 포함</td>
                        <td>
                            <a href="javascript:doAction('Search')" id="btnSearch" class="button">조회</a>
                        </td>
                    </tr>
                    </table>
                    </div>
                </div>
            	-->
	        </form>
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li id="txt" class="txt">사원조회</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>

	        <div class="popup_button outer">
	            <ul>
	                <li>
	                    <a href="javascript:p.self.close();" class="gray large">닫기</a>
	                </li>
	            </ul>
	        </div>
        </div>
    </div>
</body>
</html>
