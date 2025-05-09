<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html> <html><head> <title>기타공제</title>
<%@ page import="yjungsan.util.*"%>
<%@ page import="java.util.Map"%>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%@ include file="yeaDataCommon.jsp"%>

<%String orgAuthPg = request.getParameter("orgAuthPg");%>

<script type="text/javascript">
	var orgAuthPg = "<%=orgAuthPg%>";
	//도움말
	var helpText;
	//기준년도
	var systemYY;

	$(function() {
        //엑셀,파일다운 시 화면명 저장(교보증권) - 2021.10.26
        $("#menuNm").val($(document).find("title").text()); //엑셀,CURD
		/*필수 기본 세팅*/
		$("#searchWorkYy").val( 	$("#searchWorkYy", parent.document).val() 		) ;
		$("#searchAdjustType").val( $("#searchAdjustType", parent.document).val() 	) ;
		$("#searchSabun").val( 		$("#searchSabun", parent.document).val() 		) ;
		systemYY = $("#searchWorkYy", parent.document).val();

	    $('#B010_14').mask('000,000,000,000,000', {reverse: true});
	    $('#B010_15').mask('000,000,000,000,000', {reverse: true});
	    //$('#B010_16').mask('000,000,000,000,000', {reverse: true});
	    $('#B010_17').mask('000,000,000,000,000', {reverse: true});
	    $('#B010_18').mask('000,000,000,000,000', {reverse: true});
	    $('#B010_01').mask('000,000,000,000,000', {reverse: true});
	    $('#B010_03').mask('000,000,000,000,000', {reverse: true});
	    $('#B010_09').mask('000,000,000,000,000', {reverse: true});
	    $('#B010_11').mask('000,000,000,000,000', {reverse: true});
	    //$('#B010_30').mask('000,000,000,000,000', {reverse: true}); //2019-11-14. 100% 감면대상소득 삭제
	    $('#B010_31').mask('000,000,000,000,000', {reverse: true});
	    $('#B010_32').mask('000,000,000,000,000', {reverse: true});
	    $('#B010_33').mask('000,000,000,000,000', {reverse: true});

	    $('#B010_40').mask('000,000,000,000,000', {reverse: true});
	    $('#B010_42').mask('000,000,000,000,000', {reverse: true});
	    $('#B010_43').mask('000,000,000,000,000', {reverse: true});
	    $('#B010_46').mask('000,000,000,000,000', {reverse: true});
	    $('#B010_47').mask('000,000,000,000,000', {reverse: true});
	    $('#B010_45').mask('000,000,000,000,000', {reverse: true});

	    $('#C015_01').mask('000,000,000,000,000', {reverse: true});
	    $('#C015_02').mask('000,000,000,000,000', {reverse: true});
	    $('#C015_03').mask('000,000,000,000,000', {reverse: true});

		//일반직원일경우 읽기만가능
		setReadOnly();

		//2020-12-23. 담당자 마감일때 수정 불가 처리
		var empStatus = $("#tdStatusView>font:first", parent.document).attr("class");
		if(orgAuthPg == "A" && (empStatus == "close_3" || empStatus == "close_4")) {
			$("#btnDisplayYn01").hide() ;
		}

		//기본정보 조회(도움말 등등).
		initDefaultData() ;

		//기본자료 조회
		parent.doSearchCommonSheet();
	});

	//기본데이터 조회
	function initDefaultData() {
		//도움말 조회
		var param1 = "searchWorkYy="+$("#searchWorkYy").val();
		param1 += "&queryId=getYeaDataHelpText";

		var result1 = ajaxCall("<%=jspPath%>/common/commonSelect.jsp?cmd=commonSelectMap",param1+"&adjProcessCd=B010",false);
		helpText = nvl(result1.Data.help_text1,"") + nvl(result1.Data.help_text2,"") + nvl(result1.Data.help_text3,"");
		//안내메세지
        $("#infoLayer").html(helpText).hide();
	}

	//기본자료 설정.
	function sheetSet(){
		var comSheet = parent.commonSheet;

		if(comSheet.RowCount() > 0){
			$("#B010_14").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "B010_14") > 0 ? comSheet.FindText("adj_element_cd", "B010_14") : "","input_mon"));
			$("#B010_15").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "B010_15") > 0 ? comSheet.FindText("adj_element_cd", "B010_15") : "","input_mon"));
			//$("#B010_16").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "B010_16"),"input_mon"));
			$("#B010_17").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "B010_17") > 0 ? comSheet.FindText("adj_element_cd", "B010_17") : "","input_mon"));
			$("#B010_18").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "B010_18") > 0 ? comSheet.FindText("adj_element_cd", "B010_18") : "","input_mon"));
			$("#B010_05").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "B010_05") > 0 ? comSheet.FindText("adj_element_cd", "B010_05") : "","input_mon"));
			$("#B010_01").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "B010_01") > 0 ? comSheet.FindText("adj_element_cd", "B010_01") : "","input_mon"));
			$("#B010_03").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "B010_03") > 0 ? comSheet.FindText("adj_element_cd", "B010_03") : "","input_mon"));
			$("#B010_09").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "B010_09") > 0 ? comSheet.FindText("adj_element_cd", "B010_09") : "","input_mon"));
			$("#B010_11").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "B010_11") > 0 ? comSheet.FindText("adj_element_cd", "B010_11") : "","input_mon"));
			//$("#B010_30").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "B010_30"),"input_mon")); //2019-11-14. 100% 감면대상소득 삭제
			$("#B010_31").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "B010_31") > 0 ? comSheet.FindText("adj_element_cd", "B010_31") : "","input_mon"));
			$("#B010_32").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "B010_32") > 0 ? comSheet.FindText("adj_element_cd", "B010_32") : "","input_mon"));
			$("#B010_33").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "B010_33") > 0 ? comSheet.FindText("adj_element_cd", "B010_33") : "","input_mon"));

			$("#B010_40").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "B010_40") > 0 ? comSheet.FindText("adj_element_cd", "B010_40") : "","input_mon"));
			$("#B010_42").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "B010_42") > 0 ? comSheet.FindText("adj_element_cd", "B010_42") : "","input_mon"));
			$("#B010_43").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "B010_43") > 0 ? comSheet.FindText("adj_element_cd", "B010_43") : "","input_mon"));
			$("#B010_46").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "B010_46") > 0 ? comSheet.FindText("adj_element_cd", "B010_46") : "","input_mon"));
			$("#B010_47").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "B010_47") > 0 ? comSheet.FindText("adj_element_cd", "B010_47") : "","input_mon"));
			$("#B010_45").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "B010_45") > 0 ? comSheet.FindText("adj_element_cd", "B010_45") : "","input_mon"));

			$("#C015_01").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "C015_01") > 0 ? comSheet.FindText("adj_element_cd", "C015_01") : "","input_mon"));
			$("#C015_02").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "C015_02") > 0 ? comSheet.FindText("adj_element_cd", "C015_02") : "","input_mon"));
			$("#C015_03").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "C015_03") > 0 ? comSheet.FindText("adj_element_cd", "C015_03") : "","input_mon"));
		} else {
			$("#B010_14").val("");
			$("#B010_15").val("");
			//$("#B010_16").val("");
			$("#B010_17").val("");
			$("#B010_18").val("");
			$("#B010_05").val("");
			$("#B010_01").val("");
			$("#B010_03").val("");
			$("#B010_09").val("");
			$("#B010_11").val("");
			//$("#B010_30").val(""); //2019-11-14. 100% 감면대상소득 삭제
			$("#B010_31").val("");
			$("#B010_32").val("");
			$("#B010_33").val("");

			$("#B010_40").val("");
			$("#B010_42").val("");
			$("#B010_43").val("");
			$("#B010_46").val("");
			$("#B010_47").val("");
			$("#B010_45").val("");

			$("#C015_01").val("");
			$("#C015_02").val("");
			$("#C015_03").val("");

		}
	}

	function setReadOnly() {
<%--		if(orgAuthPg != "A") {	--%>
<%		if( !"Y".equals(adminYn) ) {	%>
			$("#B010_14").addClass("transparent").attr("readonly", true) ;
			$("#B010_15").addClass("transparent").attr("readonly", true) ;
			//$("#B010_16").addClass("transparent").attr("readonly", true) ;
			$("#B010_17").addClass("transparent").attr("readonly", true) ;
			$("#B010_18").addClass("transparent").attr("readonly", true) ;
			$("#B010_01").addClass("transparent").attr("readonly", true) ;
			$("#B010_03").addClass("transparent").attr("readonly", true) ;
			//$("#B010_09").addClass("transparent").attr("readonly", true) ;
			//$("#B010_11").addClass("transparent").attr("readonly", true) ;
			//$("#B010_30").addClass("transparent").attr("readonly", true) ;
			//$("#B010_31").addClass("transparent").attr("readonly", true) ;
			//$("#B010_32").addClass("transparent").attr("readonly", true) ;
			//$("#B010_33").addClass("transparent").attr("readonly", true) ;

			$("#B010_45").addClass("transparent").attr("readonly", true) ;			
			
			$("#C015_01").addClass("transparent").attr("readonly", true) ;
			$("#C015_02").addClass("transparent").attr("readonly", true) ;
			$("#C015_03").addClass("transparent").attr("readonly", true) ;
<%--
			$("#spanSave").hide() ;
--%>
<%		} else {	%>
			$("#B010_14").attr("readonly", false) ;
			$("#B010_15").attr("readonly", false) ;
			//$("#B010_16").attr("readonly", false) ;
			$("#B010_17").attr("readonly", false) ;
			$("#B010_18").attr("readonly", false) ;
			$("#B010_01").attr("readonly", false) ;
			$("#B010_03").attr("readonly", false) ;
			$("#B010_09").attr("readonly", false) ;
			$("#B010_11").attr("readonly", false) ;
			//$("#B010_30").attr("readonly", false) ;
			//$("#B010_31").attr("readonly", false) ;
			//$("#B010_32").attr("readonly", false) ;
			//$("#B010_33").attr("readonly", false) ;

			$("#B010_45").attr("readonly", false) ;
			
			$("#C015_01").attr("readonly", false) ;
			$("#C015_02").attr("readonly", false) ;
			$("#C015_03").attr("readonly", false) ;
<%--
			$("#spanSave").show() ;
--%>
<%		}	%>
	}

	//연말정산 안내
	function yeaDataExpPopup(title, helpText, height, width){
		var url 	= "<%=jspPath%>/common/yeaDataExpPopup.jsp";
		openYeaDataExpPopup(url, width, height, title, helpText);
	}

	//데이터 저장.
	function saveCommonData(){
		var comSheet = parent.commonSheet;

		if(comSheet.RowCount() == 0) {
			return;
		} else {
			parent.doInsertCommonSheet("B010_14",$("#B010_14").val());
			parent.doInsertCommonSheet("B010_15",$("#B010_15").val());
			//parent.doInsertCommonSheet("B010_16",$("#B010_16").val());
			parent.doInsertCommonSheet("B010_17",$("#B010_17").val());
			parent.doInsertCommonSheet("B010_18",$("#B010_18").val());
			parent.doInsertCommonSheet("B010_05",$("#B010_05").val());
			parent.doInsertCommonSheet("B010_01",$("#B010_01").val());
			parent.doInsertCommonSheet("B010_03",$("#B010_03").val());
			parent.doInsertCommonSheet("B010_09",$("#B010_09").val());
			parent.doInsertCommonSheet("B010_11",$("#B010_11").val());
			//parent.doInsertCommonSheet("B010_30",$("#B010_30").val()); //2019-11-14. 100% 감면대상소득 삭제
			parent.doInsertCommonSheet("B010_31",$("#B010_31").val());
			parent.doInsertCommonSheet("B010_32",$("#B010_32").val());
			parent.doInsertCommonSheet("B010_33",$("#B010_33").val());

			parent.doInsertCommonSheet("B010_40",$("#B010_40").val());
			parent.doInsertCommonSheet("B010_42",$("#B010_42").val());
			parent.doInsertCommonSheet("B010_43",$("#B010_43").val());
			parent.doInsertCommonSheet("B010_46",$("#B010_46").val());
			parent.doInsertCommonSheet("B010_47",$("#B010_47").val());
			parent.doInsertCommonSheet("B010_45",$("#B010_45").val());

			parent.doInsertCommonSheet("C015_01",$("#C015_01").val());
			parent.doInsertCommonSheet("C015_02",$("#C015_02").val());
			parent.doInsertCommonSheet("C015_03",$("#C015_03").val());

			parent.doSaveCommonSheet();
			//parent.getYearDefaultInfoObj();

		}
		//parent.getYearDefaultInfoObj();
	}

	function sheetChangeCheck() {
		return false;
	}

	$(function() {

		var infoMsg = "[중소기업 취업자에 대한 감면]에서 70%와 90%는 동시에 값을 넣을수 없습니다.";

      	//70% 감면대상소득 선택시 90% 감면대상소득 초기화
        $(document).on('input', "#B010_32", function () {
        	$("#B010_33").val('0');
        });

      	//90% 감면대상소득 선택시 70% 감면대상소득 초기화
        $(document).on('input', "#B010_33", function () {
        	$("#B010_32").val('0');
        });

      	//70% 감면대상소득 선택시 안내메세지
        $("#B010_32").click(function(){
       		alert(infoMsg);
       	});

      	//90% 감면대상소득 선택시 안내메세지
		$("#B010_33").click(function(){
			alert(infoMsg);
       	});
    })

    /* 주택자금 안내 버튼 */
	$(document).ready(function(){

    	$("#InfoMinus").hide();

    	/* 보험료안내 버튼 기능 Start */
    	//안내+ 버튼 선택시 안내- 버튼 호출
    	$("#InfoPlus").live("click",function(){
	    		var btnId = $(this).attr('id');
	    		if(btnId == "InfoPlus"){
	    			$("#InfoMinus").show();
	    			$("#InfoPlus").hide();
	    		}
    	});

    	//안내- 버튼 선택시 안내+ 버튼 호출
    	$("#InfoMinus").live("click",function(){
    			var btnId = $(this).attr('id');
	    		if(btnId == "InfoMinus"){
	    			$("#InfoPlus").show();
	    			$("#InfoMinus").hide();
	    		}
		});

    	//안내+ 선택시 화면 호출
    	$("#InfoPlus").click(function(){
    		$("#infoLayer").show("fast");
    		$("#infoLayerMain").show("fast");
        });

    	//안내- 선택시 화면 숨김
    	$("#InfoMinus").click(function(){
    		$("#infoLayer").hide("fast");
    		$("#infoLayerMain").hide("fast");
        });
    	/* 보험료안내 버튼 기능 End */
    });

  //기본공제안내 안내 팝업 실행후 클릭시 창 닫음
    $(document).mouseup(function(e){
    	if(!$("#infoLayer div").is(e.target)&&$("#infoLayer div").has(e.target).length==0){
    		$("#infoLayer").fadeOut();
    		$("#infoLayerMain").fadeOut();
    		$("#InfoMinus").hide();
    		$("#InfoPlus").show();
    	}
    });
</script>
</head>
<body  style="overflow-x:hidden;overflow-y:auto;">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
	<input type="hidden" id="searchWorkYy" name="searchWorkYy" value="" />
	<input type="hidden" id="searchAdjustType" name="searchAdjustType" value="" />
	<input type="hidden" id="searchSabun" name="searchSabun" value="" />
	<input type="hidden" id="menuNm" name="menuNm" value="" />
	</form>
	<div class="outer">
    <div class="sheet_title">
        <ul>
            <li class="txt"> 세액감면
            	<!-- <a href="javascript:yeaDataExpPopup('세액감면 및 기타세액공제', helpText, 520, 680);" class="cute_gray authR">세액감면 및 기타세액공제 안내</a> -->
				<!-- <a href = "#" class="cute_gray" id="cute_gray_authR" >세액감면 및 기타세액공제 안내</a> -->
				<a href="#layerPopup" class="basic btn-white ico-question" id="InfoPlus"><b>세액감면 및 기타세액공제  안내+</b></a>
	            <a href="#layerPopup" class="basic btn-white ico-question" id="InfoMinus" style="display:none"><b>세액감면 및 기타세액공제  안내-</b></a>
            	<font width="90%" class="title red" style="font-size: 12px;">
					세액감면 및 기타세액공제 등록은 인사 담당자에게 문의해 주십시오.
				</font>
            </li>
            <li class="btn right">
<%if("Y".equals(adminYn)) {%>
            	<span id="spanSave">
            		<span id="btnDisplayYn01">
	            	<font class='blue'>비활성화된 항목은 [연간소득관리>연간소득_개별] 하단 기타소득사항에서 등록</font>
	            	<a href="javascript:saveCommonData();" class="basic btn-save authA">저장</a>
	            	</span>
	            </span>
<%} %>
    		</li>

        </ul>
    </div>
    </div>

	<div id="infoLayer" class="new" style="display:none"></div>
	
	<!-- Sample Ex&Image End -->
    <table border="0" cellpadding="0" cellspacing="0" class="default line outer">
	<colgroup>
		<col width="15%" />
		<col width="10%" />
		<col width="15%" />
		<col width="" />
	</colgroup>
	<tr>
		<th class="left">소득세법 59의5</th>
		<th class="center">감면세액</th>
		<td class="right">
			<input id="B010_14" name="B010_14" type="text" class="text w90 right" /> 원
		</td>
		<td class="left">
			&nbsp;정부간 협약에 의하여 우리나라에 파견된 외국인이 당사국의 정부로부터 받는 급여
		</td>
	</tr>
	<tr>
		<th class="left" rowspan="2">조세특례제한법 제18조</th>
		<th class="center">50% 감면세액</th>
		<td class="right">
			<input id="B010_15" name="B010_15" type="text" class="text w90 right" /> 원
		</td>
		<td class="left" >
			&nbsp;외국인 기술자에 대한 소득세 감면
		</td>
	</tr>
	<tr>
		<th class="center">70% 감면세액</th>
		<td class="right">
			<input id="B010_18" name="B010_18" type="text" class="text w90 right" /> 원
		</td>
		<td class="left" >
			&nbsp;외국인 기술자에 대한 소득세 감면
		</td>
	</tr>
	<!-- 2019-11-14. 100% 감면대상소득 삭제
	<tr>
		<th class="left" rowspan=4>조세특례제한법 제30조</th>
		<th class="center">100% 감면대상소득</th>
		<td class="right">
			<input id="B010_30" name="B010_30" type="text" class="text w90 right" readonly disabled /> 원
		</td>
		<td class="left" >
			&nbsp;2013.12.31일 이전 입사한 조세특례제한법 제 30조에 해당하는 중소기업 취업자의 감면 대상 소득
		</td>
	</tr>
	-->
	<!-- 
	<tr>
		<th class="left" rowspan=3>조세특례제한법 제30조</th>
		<th class="center">50% 감면대상소득</th>
		<td class="right">
			<input id="B010_31" name="B010_31" type="text" class="text w90 right" readonly disabled /> 원
		</td>
		<td class="left" >
			&nbsp;2014.01.01일 이후 입사한 조세특례제한법 제 30조에 해당하는 중소기업 취업자의 감면 대상 소득
		</td>
	</tr>
	-->
	<tr>
		<th class="left" rowspan=2>조세특례제한법 제30조</th><!-- 2019-11-14. 100% 감면대상소득 삭제로 인해 추가 -->
		<th class="center">70% 감면대상소득</th>
		<td class="right" id="TOP_B010_32">
			<input id="B010_32" name="B010_32" type="text" class="text w90 right" onclick="myFunc(); this.onclick='';" readonly disabled /> 원
		</td>
		<td class="left" >
			&nbsp;<font class="red">[청년 이외의 자에 대한 소득] (한도 200만원)</font><br>
			&nbsp;조세특례제한법 제 30조에 해당하는 중소기업에서 2026.12.31 까지 취업한 근로자에 대한 소득세 감면<br>
		</td>
	</tr>
	<tr>
		<th class="center">90% 감면대상소득</th>
		<td class="right">
			<input id="B010_33" name="B010_33" type="text" class="text w90 right" readonly disabled /> 원
		</td>
		<td class="left" >
			&nbsp;<font class="red">[청년에 대한 소득] (한도 200만원)</font><br>
			&nbsp;조세특례제한법 제 30조에 해당하는 중소기업에서 2026.12.31 까지 취업한 근로자에 대한 소득세 감면<br>
		</td>
	</tr>
	<tr>
		<th class="left">조세특례제한법 제19조</th>
		<th class="center">대상소득</th>
		<td class="right">
			<input id="B010_40" name="B010_40" type="text" class="text w90 right" readonly disabled /> 원
		</td>
		<td class="left">
			&nbsp;<font class="red">[성과공유 중소기업의 경영성과급 세액공제](총급여 7천만원이하 적용)</font><br>
			&nbsp;조세특례제한법 제 27조의2에 해당하는 중소기업에서 2019.01.01 이후 지급분부터 지급분에 대한 소득세 감면
		</td>
	</tr>
    <tr>
		<th class="left" rowspan="4">조세특례제한법 제29조의6</th>
        <th class="center">(청년) 50% 감면 대상소득</th>
        <td class="right">
            <input id="B010_46" name="B010_46" type="text" class="text w90 right" readonly disabled /> 원
        </td>
        <td class="left">
            &nbsp;<font class="red">[중견기업 핵심인력 성과보상기금 소득세 감면]</font><br>
            &nbsp;조세특례제한법 제 29조의6에 해당하는 중견기업에서 2024.12.31 까지 가입한 근로자에 대한 소득세 감면
        </td>
    </tr>
	<tr>
		<th class="center">(청년) 90% 감면 대상소득</th>
		<td class="right">
			<input id="B010_47" name="B010_47" type="text" class="text w90 right" readonly disabled /> 원
		</td>
		<td class="left">
			&nbsp;<font class="red">[중소기업 핵심인력 성과보상기금 소득세 감면]</font><br>
			&nbsp;조세특례제한법 제 29조의6에 해당하는 중소기업에서 2024.12.31 까지 가입한 근로자에 대한 소득세 감면
		</td>
	</tr>
	<tr>
		<th class="center">(그 외) 30% 감면 대상소득</th>
		<td class="right">
			<input id="B010_43" name="B010_43" type="text" class="text w90 right" readonly disabled /> 원
		</td>
		<td class="left">
			&nbsp;<font class="red">[중견기업 핵심인력 성과보상기금 소득세 감면]</font><br>
			&nbsp;조세특례제한법 제 29조의6에 해당하는 중견기업에서 2024.12.31 까지 가입한 근로자에 대한 소득세 감면
		</td>
	</tr>
	<tr>
		<th class="center">(그 외) 50% 감면 대상소득</th>
		<td class="right">
			<input id="B010_42" name="B010_42" type="text" class="text w90 right" readonly disabled /> 원
		</td>
		<td class="left">
			&nbsp;<font class="red">[중소기업 핵심인력 성과보상기금 소득세 감면]</font><br>
			&nbsp;조세특례제한법 제 29조의6에 해당하는 중소기업에서 2024.12.31 까지 가입한 근로자에 대한 소득세 감면
		</td>
	</tr>
	<tr>
		<th class="left">조세특례제한법 제18조의3</th>
		<th class="center">감면세액</th>
		<td class="right">
			<input id="B010_45" name="B010_45" type="text" class="text w90 right"/> 원
		</td>
		<td class="left" >
			&nbsp;<font class="red">[내국인 우수 인력 국내복귀시 소득세 감면]</font><br>
			&nbsp;조세특례제한법 제 18조의3에 해당하는 대상자들에 대해 소득세 감면 (적용기한 2022.12.31)
		</td>
	</tr>
	<tr>
		<th class="left">조세조약</th>
		<th class="center">감면세액</th>
		<td class="right">
			<input id="B010_17" name="B010_17" type="text" class="text w90 right" /> 원
		</td>
		<td class="left">
			&nbsp;조세조약의 교직자 조항으로 소득세를 면제받는 자
		</td>
	</tr>
	</table>
	<!-- miniTable2 -->
	<div class="outer">
    <div class="sheet_title">
        <ul>
            <li class="txt"> 세액공제
            </li>
            <li class="btn right">
    		</li>
        </ul>
    </div>
    </div>
    <table border="0" cellpadding="0" cellspacing="0" class="default line outer">
	<colgroup>
		<col width="15%" />
		<col width="10%" />
		<col width="15%" />
		<col width="" />
	</colgroup>
	<tr style="display:none;">
		<th class="left">기부 정치자금</th>
		<th class="center">자동계산</th>
		<td class="right">
			<input id="B010_05" name="B010_05" type="text" class="text w90 right transparent" readonly /> 원
		</td>
		<td class="left">
			&nbsp;정치자금법에 따라 정당, 후원회, 선거관리위원회에 기부한 정치자금으로 <br>
			&nbsp;10만원 이하까지는 세액공제 적용 ※ min[90,909원, 입력금액×100/110]</br>
		</td>
	</tr>
	<tr>
		<th class="left">납세조합공제</th>
		<th class="center">공제세액</th>
		<td class="right">
			<input id="B010_01" name="B010_01" type="text" class="text w90 right" /> 원
		</td>
		<td class="left" >
			&nbsp;납세조합에 의하여 원천징수된 근로소득에 대한 종합소득 산출세액의 5%
		</td>
	</tr>
	<tr>
		<th class="left">주택차입금</th>
		<th class="center">이자상환액</th>
		<td class="right">
			<input id="B010_03" name="B010_03" type="text" class="text w90 right" /> 원
		</td>
		<td class="left" >
			&nbsp;95.11.1.~97.12.31.기간 중에 미분양주택의 취득과 관련하여<br>
			&nbsp;국민주택기금으로부터 차입한 대출금의 이자 상환액 중 30% <br>
			&nbsp;※ 주택차입금 이자세액공제를 받는 차입금의 이자는 <br>
			&nbsp;장기주택저당차 입금 이자상환액공제를 적용받을 수없음
		</td>
	</tr>
	<tr>
		<th class="left" rowspan=2>외국납부세액</th>
		<th class="center">소득금액</th>
		<td class="right">
			<input id="B010_09" name="B010_09" type="text" class="text w90 right" readonly disabled/> 원
		</td>
		<td class="left">
		    <%if("Y".equals(adminYn)) {%><font class='blue'>[소득공제자료관리>외납세이월내역관리]에서 등록</font><br><%} %>
			&nbsp;거주자의 근로소득금액에 국외원천소득이 합산되어 있는 경우 그 국외원천소득에 대하여<br>
			&nbsp;외국에서 외국납부세액을 납부하였거나 납부할 것이 있을 때 소득금액
		</td>
	</tr>
	<tr>

		<th class="center">납부세액</th>
		<td class="right">
			<input id="B010_11" name="B010_11" type="text" class="text w90 right" readonly disabled/> 원
		</td>
		<td class="left">
		    <%if("Y".equals(adminYn)) {%><font class='blue'>[소득공제자료관리>외납세이월내역관리]에서 등록</font><br><%} %>
			&nbsp;거주자의 근로소득금액에 국외원천소득이 합산되어 있는 경우 그 국외원천소득에 대하여<br>
			&nbsp;외국에서 외국납부세액을 납부하였거나 납부할 것이 있을 때 납부세액
		</td>
	</tr>
	</table>

	<!-- miniTable3 -->
	<div class="outer">
    <div class="sheet_title">
        <ul>
            <li class="txt"> 납부특례세액
            </li>
            <li class="btn right">
    		</li>
        </ul>
    </div>
    </div>
    <table border="0" cellpadding="0" cellspacing="0" class="default line outer">
	<colgroup>
		<col width="20%" />
		<col width="20%" />
		<col width="" />
	</colgroup>
	<tr>
		<th class="left">소득세</th>
		<td class="right">
			<input id="C015_01" name="C015_01"  type="text" class="text w90 right" /> 원
		</td>
		<td rowspan="3" class="left">
			&nbsp;"주식매수선택권 행사이익과 관련된 소득세액의 1/3만 납부할 수 있음.<br>
			&nbsp;이후 2개 연도의 확정신고시 남은 금액의 1/2씩 각각 납부할 수 있음.<br>
			&nbsp;※ 행사이익과 관련된 소득세액<br>
    		&nbsp;= 해당 과세기간의 결정세액 - 행사이익에 따른 소득금액을 제외하여 산출한 결정세액"<br>
		</td>
	</tr>
	<tr>
		<th class="left">지방소득세</th>
		<td class="right">
			<input id="C015_02" name="C015_02"  type="text" class="text w90 right" /> 원
		</td>
		</td>
	</tr>
	<tr>
		<th class="left">농어촌특별세</th>
		<td class="right">
			<input id="C015_03" name="C015_03"  type="text" class="text w90 right" /> 원
		</td>
		</td>
	</tr>
	</table>
</div>
</body>
</html>