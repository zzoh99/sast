<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>임직원 조회 팝업</title>

<script type="text/javascript">
	var srchBizCd = null;
	var ssnSearchType = "";	
	/*Sheet 기본 설정 */
	$(function() {
		createIBSheet3(document.getElementById('orgCapaEmpLayerSheet-wrap'), "orgCapaEmpLayerSheet", "100%", "100%", "kr");
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

		var baseUrl = "";
        var modal = window.top.document.LayerModalUtility.getModal('orgCapaEmpLayer');
        var { searchOrgCd, searchOrgNm, searchColNm, searchBaseDate, searchMonth, searchYear, searchOrdTypeCd, groupEnterCd, baseUrl } = modal.parameters;
        var titleTxt;
		if( searchMonth === "00") {
			titleTxt = searchOrgNm + " " + searchBaseDate + " 현인원(" + searchColNm + ")";
			searchMonth = searchYear + "0101";
			if( searchYear == "${curSysYear}" ) {
				searchMonthEnd = "${curSysYyyyMMdd}";
			} else {
				searchMonthEnd = searchBaseDate;
			}
			
			if(searchOrdTypeCd == ""){
				searchMonth = "";
			}
		} else {
			titleTxt = searchOrgNm + " " + searchYear + "년 " + searchMonth + "월(" + searchColNm + ")";
			searchMonth =  searchYear + searchMonth + "01";
		}        

		$('#modal-orgCapaEmpLayer').find('div.layer-modal-header span.layer-modal-title').text(titleTxt);
        $("#searchOrgCd").val(searchOrgCd);
        $("#searchBaseDate").val(searchBaseDate);
		$("#searchMonth").val(searchMonth);
		$("#searchMonthEnd").val(searchMonthEnd);
		$("#searchOrdTypeCd").val(searchOrdTypeCd);
		$("#groupEnterCd").val(groupEnterCd);		
		$("#except1").val(except1);
		$("#except2").val(except2);
		$("#except3").val(except3);
		$("#baseUrl").val(baseUrl);

		//배열 선언				
		var initdata = {};
		//SetConfig
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:4, DataRowMerge:0, AutoFitColWidth:'init|search|resize|rowtransaction'};
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
		IBS_InitSheet(orgCapaEmpLayerSheet, initdata); orgCapaEmpLayerSheet.SetCountPosition(4);orgCapaEmpLayerSheet.SetEditableColorDiff (0);
		orgCapaEmpLayerSheet.SetImageList(1,"${ctx}/common/images/icon/icon_popup.png");
		orgCapaEmpLayerSheet.SetDataLinkMouse("detail0",1);


		$(window).smartresize(sheetResize); sheetInit();

		var sheetHeight = $(".modal_body").height() - $(".sheet_title").height() - 2;
		orgCapaEmpLayerSheet.SetSheetHeight(sheetHeight);


		doAction("Search");
		
        $("#searchKeyword").bind("keyup",function(event){
			if( event.keyCode == 13){
		 		doAction("Search");
			}
		});
	});
	
	/*Sheet Action*/
	function doAction(sAction) {
		switch (sAction) {
			case "Search": //조회
				orgCapaEmpLayerSheet.DoSearch( "${ctx}/OrgCapaEmpPopup.do?cmd=getOrgCapaEmpList", $("#mySheetForm").serialize() );
	            break;
		}
    } 
	
	// 	조회 후 에러 메시지 
	function orgCapaEmpLayerSheet_OnSearchEnd(Code, ErrMsg, StCode, StMsg) {
		try{
		  	if(orgCapaEmpLayerSheet.RowCount() == 0) {
		    	alert("대상 직원에 대한 조회 권한이 없거나 해당사원이 존재 하지 않습니다.");
		  	}
		  	orgCapaEmpLayerSheet.FocusAfterProcess = false;
		  	orgCapaEmpLayerSheet.FitSize(1, 1);
	  	}catch(ex){alert("OnSearchEnd Event Error : " + ex);}
	}

	function orgCapaEmpLayerSheet_OnDblClick(Row, Col){
		try{
			returnFindUser(Row, Col);
		}catch(ex){alert("OnDblClick Event Error : " + ex);}
	}
	
	function returnFindUser(Row,Col){
	    if(orgCapaEmpLayerSheet.GetCellValue(1,0) == undefined ) {
			alert("대상 직원에 대한 조회 권한이 없거나 해당사원이 존재 하지 않습니다.");
			return;
	    }
	    if(orgCapaEmpLayerSheet.RowCount() <= 0) {
			alert("대상 직원에 대한 조회 권한이 없거나 해당사원이 존재 하지 않습니다.");
			return;
	    }

    	$("#selectedUserId").val(orgCapaEmpLayerSheet.GetCellValue(Row, "empSabun"));
    	var user = ajaxCall("/Employee.do?cmd=getBaseEmployeeDetail",$("#mySheetForm").serialize(),false);
    	if(user.map != null && user.map != "undefine") user = user.map;
    	var modal = window.top.document.LayerModalUtility.getModal('orgCapaEmpLayer');
    	modal.fire('orgCapaEmpLayerTrigger', user).hide();
	}
</script>

</head>
<body class="bodywrap">

    <div class="wrapper modal_layer">
       <div class="modal_body">
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
				<input type="hidden" id="baseUrl" name="baseUrl"/>

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
			<div id="orgCapaEmpLayerSheet-wrap"></div>
			<!-- <script type="text/javascript">createIBSheet("orgCapaEmpLayerSheet", "100%", "100%","kr"); </script> -->
	   </div>
		<div class="modal_footer">
					<a href="javascript:closeCommonLayer('orgCapaEmpLayer');" class="gray large">닫기</a>
		</div>
    </div>
</body>
</html>
