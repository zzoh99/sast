<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>정산자료입력현황</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>


<style type="text/css">
	#infoLayer{ padding:0px; border:4px solid #ddd; position:absolute;z-index:100; left:100px; top:100px; background:#fff; }
	div.explain{ margin: 0px; }	
</style>

<script type="text/javascript">

	$(function() {
		$("#searchWorkYy").val("<%=yeaYear%>") ;
		
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly}; 
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No",			Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },    
			{Header:"상태",			Type:"<%=sSttTy%>",	Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"대상년도",			Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"work_yy",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4 },
			{Header:"정산구분",			Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"adjust_type",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"급여구분",			Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"pay_action_cd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"사번",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",				KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"성명",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"조직",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"org_nm",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"본인마감",			Type:"CheckBox",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"input_close_yn",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"본인마감2",		Type:"CheckBox",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"input_close_yn_src",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"담당자마감",		Type:"CheckBox",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"apprv_yn",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"계산결과\n개인오픈",		Type:"CheckBox",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"result_open_yn",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"본인결과\n확인여부",	Type:"CheckBox",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"result_confirm_yn",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"최종마감\n여부",	Type:"CheckBox",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"final_close_yn",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N" }
        ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

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
				doAction1("Search");
			}
		});
		$("#searchSbNm").bind("keyup",function(event){
			if( event.keyCode == 13){ 
				doAction1("Search"); 
			}
		});
		
		$("#InfoPlus").live("click",function(){
    		var btnId = $(this).attr('id'); 
    		if(btnId == "InfoPlus"){
    			$("#InfoMinus").show("fast");
    			$("#InfoPlus").hide("fast");
    		}
    		
    		$("#infoLayer").show("fast");
    		$("#infoLayerMain").show("fast");
		});
		
		$("#InfoMinus").live("click",function(){
			var btnId = $(this).attr('id'); 
    		if(btnId == "InfoMinus"){
    			$("#InfoPlus").show("fast");
    			$("#InfoMinus").hide("fast");    			
    		}
    		
    		$("#infoLayer").hide("fast");
    		$("#infoLayerMain").hide("fast");
		});
		
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if($("#searchWorkYy").val() == "") {
				alert("대상년도는 필수 입력항목입니다.");
			}
			if($("#searchWorkYy").val().length != 4) {
				alert("대상년도는 4자리 숫자로 입력하십시요.");
			}
			
			sheet1.DoSearch( "<%=jspPath%>/inputStatus/inputStatusRst.jsp?cmd=selectInputStatusList", $("#sheetForm").serialize() ); 
			break;
		case "Save":
			if($("#searchPayActionCd").val() == "") {
				alert($("#searchWorkYy").val()+"년 연말정산항목이 존재하지 않습니다.");
			}
			
			sheet1.DoSave( "<%=jspPath%>/inputStatus/inputStatusRst.jsp?cmd=saveInputStatus", $("#sheetForm").serialize() ); 			
			break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,CheckBoxOnValue:"Y",CheckBoxOffValue:"N"};
			sheet1.Down2Excel(param);
			break;
		}
	}

	//조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { 
			alertMessage(Code, Msg, StCode, StMsg);
			sheetResize();
			
			getActionCd();
			
		} catch(ex) {
			alert("OnSearchEnd Event Error : " + ex); 
		}
	}
	
	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			if(Code == 1) {
				doAction1("Search");
			}
		} catch(ex) {
			alert("OnSaveEnd Event Error " + ex); 
		}
	}
	
	//일자로 연말정산 코드 가져오기
	function getActionCd(){
		var rst = ajaxCall("<%=jspPath%>/inputStatus/inputStatusRst.jsp?cmd=selectInputStatusActionCd",$("#sheetForm").serialize(),false);
		
		if(rst.Result.Code == 1) {
			if(typeof rst.Data.pay_action_cd != "undefined") {
				$("#searchPayActionCd").val(rst.Data.pay_action_cd);
			} else {
				$("#searchPayActionCd").val("");
			}
		}
	}

	//일괄승인 클릭시
	function clickCloseTotal(){
		var type = "";
		var confirmMsg = "";
		var searchWorkYY = "";
		var searchAdjustType = "";
		
		if($("#searchClosedType").val() == "") {
			alert("마감여부 항목을 선택해주세요");
			$("#searchClosedType").focus();
			return;
		} else {
			confirmMsg = "인원전체를 "+$("#searchClosedType option[selected]").text()+"  처리하시겠습니까?";
		}
		
		if(confirm(confirmMsg)){
			if( $("#searchPayActionCd").val() == "" ) {
				alert($("#searchWorkYy").val() + "년 연말정산항목이 존재하지 않습니다.");  
				return;
			}
			
			ajaxCall("<%=jspPath%>/inputStatus/inputStatusRst.jsp?cmd=prcInputStatusCloseAll",$("#sheetForm").serialize()
					,true
					,function(){
						$("#progressCover").show();
					 }
					,function(){
						$("#progressCover").hide();
			    		doAction1("Search");
					}
			);
		}
	}
</script>
</head>
<body class="bodywrap">
<div id="progressCover" style="display:none;position:absolute;top:0;bottom:0;left:0;right:0;background:url(<%=imagePath%>/common/process.png) no-repeat 50% 50%;"></div>
<div class="wrapper">
    <form id="sheetForm" name="sheetForm" >
	<input id="searchAdjustType" name ="searchAdjustType" type="hidden" value="1"/>
	<input id="searchPayActionCd" name="searchPayActionCd" type="hidden" value=""/>
    <div class="sheet_search outer">
        <div>
        <table>
			<tr>
			    <td>
			    	<span>년도</span>
					<input id="searchWorkYy" name ="searchWorkYy" type="text" class="text" maxlength="4" style="width:35px"/>
				</td>
				<td>
					<span>사업장</span>
					<select id="searchBizPlaceCd" name ="searchBizPlaceCd" class="box">
					</select> 
				</td>
				<td>
					<span>마감여부</span>
                    <select id="searchClosedType" name="searchClosedType" class="box">
                        <option value="">전체</option>
                        <option value="CLOSED">본인마감</option>
                        <option value="OPENED">본인미마감</option>
                        <option value="MANAGE_CLOSED">담당자마감</option>
	            		<option value="MANAGE_OPENED">담당자미마감</option>
	            		<option value="RESULT_CONFIRM">본인결과확인</option>
	            		<option value="NON_RESULT_CONFIRM">본인결과미확인	</option>            		
	            		<option value="FINAL_CLOSE_CLOSED">최종마감</option>
	            		<option value="FINAL_CLOSE_OPENED">최종미마감 </option>
                    </select>
                    <a href="javascript:clickCloseTotal()" class="basic authA">일괄승인</a>
				</td>
				<td>
					<span>사번/성명</span>
					<input id="searchSbNm" name ="searchSbNm" type="text" class="text" maxlength="15" style="width:100px"/>
				</td>
				<td>
					<a href="javascript:doAction1('Search')" class="button">조회</a>
				</td>
			</tr>
        </table>
        </div>
    </div>
    </form>
    
    <div class="outer" id="infoLayerMain" style="display:none">
    	<table>
    		<tr>
    			<td>
    				<div id="infoLayer">
    					<div class="explain">
							<div class="title">도움말</div>
							<div class="txt">
								<ul>
									<li>1. 계산내역 화면에 금액이 조회되려면 담당자마감, 계산결과개인오픈이 체크되어 있어야 합니다.</li>
							        <li>2. 계산내역 화면에 원천징수영수증 출력은 옵션6번, 도장출력은 옵션 19번을 확인해 주십시오.</li>
							        <li>3. 최종마감여부가 체크되어있으면 임직원 금액 확인 버튼은 보이지 않습니다.</li>
								</ul>
							</div>
						</div>
    				</div>
    			</td>
    		</tr>
    	</table>
    </div>
    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">정산자료입력현황
            	<a href="#layerPopup" class="cute_gray" id="InfoPlus"><b>도움말+</b></a>
	        	<a href="#layerPopup" class="cute_gray" id="InfoMinus" style="display:none"><b>도움말-</b></a>
            </li>
            <li class="btn">
				<a href="javascript:doAction1('Save')" 			class="basic authA">저장</a>
				<a href="javascript:doAction1('Down2Excel')" 	class="basic authR">다운로드</a>
            </li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>