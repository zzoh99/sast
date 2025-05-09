<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>연말정산결과 급여반영</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

	$(function() {	
		$("#searchWorkYy").val("<%=yeaYear%>");
		
		var initdata1 = {};
		initdata1.Cfg = {FrozenCol:5,SearchMode:smLazyLoad,Page:22}; 
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata1.Cols = [
   			{Header:"No",		Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },    
   			{Header:"상태",		Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},    
			{Header:"년도",		Type:"Text",	Hidden:1,  Width:0,    Align:"Center",   ColMerge:0,   SaveName:"work_yy",         		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },     
			{Header:"급여일자코드",	Type:"Text",	Hidden:1,  Width:0,    Align:"Center",   ColMerge:0,   SaveName:"pay_action_cd",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },     
			{Header:"급여일자",		Type:"Popup",	Hidden:0,  Width:0,    Align:"Center",   ColMerge:0,   SaveName:"pay_action_nm",      	KeyField:1,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },     
			{Header:"사업장코드",	Type:"Text",	Hidden:1,  Width:0,    Align:"Center",   ColMerge:0,   SaveName:"business_place_cd",  	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },     
			{Header:"성명",		Type:"Text",	Hidden:0,  Width:0,    Align:"Center",   ColMerge:0,   SaveName:"name",         		KeyField:1,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:50 },     
			{Header:"사번",		Type:"Text",	Hidden:1,  Width:0,    Align:"Center",   ColMerge:0,   SaveName:"sabun",         		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },     
			{Header:"부서명",		Type:"Text",	Hidden:0,  Width:0,    Align:"Center",   ColMerge:0,   SaveName:"org_nm",         		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },     
			{Header:"직급",		Type:"Text",	Hidden:0,  Width:0,    Align:"Center",   ColMerge:0,   SaveName:"jikgub_nm",         	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },     
			{Header:"직위",		Type:"Text",	Hidden:0,  Width:0,    Align:"Center",   ColMerge:0,   SaveName:"jikwee_nm",         	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },     
			{Header:"급여항목코드",	Type:"Text",	Hidden:1,  Width:0,    Align:"Center",   ColMerge:0,   SaveName:"element_cd",        	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },     
			{Header:"급여항목",		Type:"Text",	Hidden:0,  Width:0,    Align:"Center",   ColMerge:0,   SaveName:"element_nm",        	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },     
			{Header:"원금액",		Type:"Text",	Hidden:1,  Width:0,    Align:"Center",   ColMerge:0,   SaveName:"principal_mon",     	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 },     
			{Header:"금액",		Type:"Int",		Hidden:0,  Width:0,    Align:"Right",	 ColMerge:0,   SaveName:"mth_mon",         		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },     
			{Header:"작업여부",		Type:"Text",	Hidden:0,  Width:0,    Align:"Center",   ColMerge:0,   SaveName:"apply_yn",         	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		//사업장코드
	    var bizPlaceCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList","getBizPlaceCdList") , "전체");
		
		$("#searchBizPlaceCd").html(bizPlaceCdList[2]);

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});
	
	$(function() {
		$("#searchWorkYy").bind("keyup",function(event){
			makeNumber(this,"A");
			if( event.keyCode == 13){ 
				doAction1('Search'); 
			}
		});
		$("#searchSbNm").bind("keyup",function(event){
			if( event.keyCode == 13){ 
				doAction1('Search');
			}
		});
	});
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if($("#searchWorkYy").val() == "" || $("#searchWorkYy").val().length < 4) { 
				alert("년도를 입력하여 주십시오.");
				return;
			}
			sheet1.DoSearch( "<%=jspPath%>/yeaResultPayCre/yeaResultPayCreRst.jsp?cmd=selectYeaResultPayCreList", $("#sheetForm").serialize() );
			break;
		case "Save": 		
			sheet1.DoSave( "<%=jspPath%>/yeaResultPayCre/yeaResultPayCreRst.jsp?cmd=saveYeaResultPayCre", $("#sheetForm").serialize() ); 
			break;
		case "Copy":		
			var newRow = sheet1.DataCopy(); 
			sheet1.SetCellValue(newRow, "pay_action_cd", "") ;
			sheet1.SetCellValue(newRow, "pay_action_nm", "") ;
			sheet1.SelectCell(newRow, "pay_action_nm");
			break;
		case "Down2Excel":
			sheet1.Down2Excel();
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { 
			alertMessage(Code, Msg, StCode, StMsg);
			sheetResize();
		} catch (ex) { 
			alert("OnSearchEnd Event Error : " + ex); 
		}
	}
	
	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { 
			alertMessage(Code, Msg, StCode, StMsg);
		} catch (ex) { 
			alert("OnSaveEnd Event Error " + ex); 
		}
	}

	//  Type이 POPUP인 셀에서 팝업버튼을 눌렀을때 발생하는 이벤트
    function sheet1_OnPopupClick(Row, Col){
        try{
        	var colName = sheet1.ColSaveName(Col);
     		if(colName == "pay_action_nm") {
     			openPayDayPopup("false") ;
     		}
        
        } catch(ex) {
        	alert("OnPopupClick Event Error : " + ex);
        }
    }

    var pGubun = "";
	var gSearchGubun = "";
	
	//급여일자 조회 팝업
	function openPayDayPopup(searchGubun){
	    try{
	    	
	    	if(!isPopup()) {return;}
	    	gSearchGubun = searchGubun;
			pGubun = "yeaResultPayCrePayDayPopup";
			
			var args    = new Array();
			var rv = openPopup("<%=jspPath%>/yeaResultPayCre/yeaResultPayCrePayDayPopup.jsp", args, "740","520");
			/*
	        if(rv!=null){
	    		if(searchGubun == "true"){
	    			$("#searchPayApplyCd").val(rv["payActionCd"]) ;
	    			$("#searchPayApplyNm").val(rv["payActionNm"]) ;
	    		}else{
	    			sheet1.SetCellValue(sheet1.GetSelectRow(), "pay_action_cd", rv["payActionCd"]) ;
	    			sheet1.SetCellValue(sheet1.GetSelectRow(), "pay_action_nm", rv["payActionNm"]) ;
	    			sheet1.SetCellValue(sheet1.GetSelectRow(), "work_yy", rv["payYm"].substring(0,4) ) ;
	    		}
	        }
			*/
	    } catch(ex) {
	    	alert("Open Popup Event Error : " + ex);
	    }
	}
	
	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

		if ( pGubun == "yeaResultPayCrePayDayPopup" ){
			if(gSearchGubun == "true"){
    			$("#searchPayApplyCd").val(rv["payActionCd"]) ;
    			$("#searchPayApplyNm").val(rv["payActionNm"]) ;
    		}else{
    			sheet1.SetCellValue(sheet1.GetSelectRow(), "pay_action_cd", rv["payActionCd"]) ;
    			sheet1.SetCellValue(sheet1.GetSelectRow(), "pay_action_nm", rv["payActionNm"]) ;
    			sheet1.SetCellValue(sheet1.GetSelectRow(), "work_yy", rv["payYm"].substring(0,4) ) ;
    		}
		}
	}
	
    function doConfirm(){
        searchWorkYY		= $("#searchWorkYY").val();
        searchPayActionCd	= $("#searchPayActionCd").val();
        searchBizPlaceCd    = $("#searchBizPlaceCd").val();
        searchPayApplyCd    = $("#searchPayApplyCd").val();
        searchName			= $("#searchName").val();

        if(searchPayApplyCd == ""){
            alert("급여반영일자가 선택되지 않았습니다.");
            return;
        }
        if(confirm("연말정산급여반영처리를 실행하시겠습니까?")) {
            if(checkRowCnt()){
        	    
        		ajaxCall("<%=jspPath%>/yeaResultPayCre/yeaResultPayCreRst.jsp?cmd=prcYeaResultPayCre",$("#sheetForm").serialize()
	   	    			,true
	   	    			,function(){
							$("#progressCover").show();
	   	    			}
	   	    			,function(){
							$("#progressCover").hide();
							doAction1("Search") ;
	   	    			}
				);
            }
        }
    }
    
    function checkRowCnt(){
        if(sheet1.RowCount() > 0){
            if(confirm("이미 반영결과가 존재합니다.덮어쓰시겠습니까?")){
                return true;
            }else{
                return false;
            }
        }
        return true;
    }
</script>
</head>
<body class="hidden">
<div id="progressCover" style="display:none;position:absolute;top:0;bottom:0;left:0;right:0;background:url(<%=imagePath%>/common/process.png) no-repeat 50% 50%;"></div>
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
        <input type="hidden" id="searchAdjustType"  name="searchAdjustType" value="1" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<span>년도 </span>
							<input id="searchWorkYy" name ="searchWorkYy" type="text" class="text w40" maxlength="4"/>
						</td>
						<td>
							<span>급여사업장</span>
							<select id="searchBizPlaceCd" name ="searchBizPlaceCd" onChange="javascript:doAction1('Search')"  class="box"></select> 
						</td>
					</tr>
					<tr>
						<td>
							<span>사번/성명 </span>
							<input id="searchSbNm" name ="searchSbNm" type="text" class="text w90"/>
						</td>
						<td>
							<span>급여반영일자</span> 
							<input type="hidden" id="searchPayApplyCd" name="searchPayApplyCd" value="" />
							<input type="hidden" id="sabun" name="sabun" class="text" value="" />
							<input type="text" id="searchPayApplyNm" name="searchPayApplyNm" class="text readonly" value="" validator="required" readonly style="width:150px" />
							<a onclick="javascript:openPayDayPopup('true');" href="#" class="button6"><img src="<%=imagePath%>/common/btn_search2.gif"/></a> 
						</td>
						<td> 
							<a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a>
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
							<li id="txt" class="txt">연말정산결과 급여반영</li>
							<li class="btn">
								<a href="javascript:doAction1('Copy');" 		class="basic authA">복사</a>
								<a href="javascript:doAction1('Save');" 		class="basic authA">저장</a>
								<a href="javascript:doAction1('Down2Excel');" 	class="basic authR">다운로드</a>
								<a href="javascript:doConfirm();" 				class="basic authA">연말정산결과반영</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>