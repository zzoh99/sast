<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html> <html><head> <title>기타공제</title>
<%@ page import="yjungsan.util.*"%>
<%@ page import="java.util.Map"%>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<%String orgAuthPg = request.getParameter("orgAuthPg");%>

<script type="text/javascript">
	var orgAuthPg = "<%=removeXSS(orgAuthPg, '1')%>";
	//도움말
	var helpText;
	//기준년도
	var systemYY;
	
	$(function() {
		/*필수 기본 세팅*/
		$("#searchWorkYy").val( 	$("#searchWorkYy", parent.document).val() 		) ;
		$("#searchAdjustType").val( $("#searchAdjustType", parent.document).val() 	) ;
		$("#searchSabun").val( 		$("#searchSabun", parent.document).val() 		) ;
		systemYY = $("#searchWorkYy", parent.document).val();

	    $('#B010_14').mask('000,000,000,000,000', {reverse: true}); 
	    $('#B010_15').mask('000,000,000,000,000', {reverse: true}); 
	    $('#B010_16').mask('000,000,000,000,000', {reverse: true}); 
	    $('#B010_17').mask('000,000,000,000,000', {reverse: true}); 
	    $('#B010_01').mask('000,000,000,000,000', {reverse: true}); 
	    $('#B010_03').mask('000,000,000,000,000', {reverse: true}); 
	    $('#B010_09').mask('000,000,000,000,000', {reverse: true}); 
	    $('#B010_11').mask('000,000,000,000,000', {reverse: true}); 
		
		//일반직원일경우 읽기만가능
		setReadOnly();
		
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
	}

	//기본자료 설정.
	function sheetSet(){
		var comSheet = parent.commonSheet;

		if(comSheet.RowCount() > 0){
			$("#B010_14").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "B010_14"),"input_mon"));
			$("#B010_15").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "B010_15"),"input_mon"));
			$("#B010_16").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "B010_16"),"input_mon"));
			$("#B010_17").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "B010_17"),"input_mon"));
			$("#B010_05").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "B010_05"),"input_mon"));
			$("#B010_01").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "B010_01"),"input_mon"));
			$("#B010_03").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "B010_03"),"input_mon"));
			$("#B010_09").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "B010_09"),"input_mon"));
			$("#B010_11").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "B010_11"),"input_mon"));
		} else {
			$("#B010_14").val("");
			$("#B010_15").val("");
			$("#B010_16").val("");
			$("#B010_17").val("");
			$("#B010_05").val("");
			$("#B010_01").val("");
			$("#B010_03").val("");
			$("#B010_09").val("");
			$("#B010_11").val("");
		}
	}
	
	function setReadOnly() {
		if(orgAuthPg != "A") {
			$("#B010_14").addClass("transparent").attr("readonly", true) ;
			$("#B010_15").addClass("transparent").attr("readonly", true) ;
			$("#B010_16").addClass("transparent").attr("readonly", true) ;
			$("#B010_17").addClass("transparent").attr("readonly", true) ;
			$("#B010_01").addClass("transparent").attr("readonly", true) ;
			$("#B010_03").addClass("transparent").attr("readonly", true) ;
			$("#B010_09").addClass("transparent").attr("readonly", true) ;
			$("#B010_11").addClass("transparent").attr("readonly", true) ;
			
			$("#spanSave").hide() ;
		} else {
			$("#B010_14").attr("readonly", false) ;
			$("#B010_15").attr("readonly", false) ;
			$("#B010_16").attr("readonly", false) ;
			$("#B010_17").attr("readonly", false) ;
			$("#B010_01").attr("readonly", false) ;
			$("#B010_03").attr("readonly", false) ;
			$("#B010_09").attr("readonly", false) ;
			$("#B010_11").attr("readonly", false) ;

			$("#spanSave").show() ;
		}
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
			parent.doInsertCommonSheet("B010_16",$("#B010_16").val());
			parent.doInsertCommonSheet("B010_17",$("#B010_17").val());
			parent.doInsertCommonSheet("B010_05",$("#B010_05").val());
			parent.doInsertCommonSheet("B010_01",$("#B010_01").val());
			parent.doInsertCommonSheet("B010_03",$("#B010_03").val());
			parent.doInsertCommonSheet("B010_09",$("#B010_09").val());
			parent.doInsertCommonSheet("B010_11",$("#B010_11").val());

			parent.doSaveCommonSheet();
		}		
	}

	function sheetChangeCheck() {
		return false;
	}
</script>
</head>
<body  style="overflow-x:hidden;overflow-y:auto;">
<div class="wrapper">

	<form id="sheetForm" name="sheetForm" >
	<input type="hidden" id="searchWorkYy" name="searchWorkYy" value="" />
	<input type="hidden" id="searchAdjustType" name="searchAdjustType" value="" />
	<input type="hidden" id="searchSabun" name="searchSabun" value="" />
	</form>

	<div class="outer">
    <div class="sheet_title">
        <ul>
            <li class="txt"> 세액감면
            	<a href="javascript:yeaDataExpPopup('세액감면 및 세액공제', helpText, 520, 680);"		class="cute_gray authR">세액감면 및 세액공제 안내</a>
            </li>
            <li class="btn right">
            	<span id="spanSave"><a href="javascript:saveCommonData();" class="basic authA">저장</a></span>
    		</li>
        </ul>
    </div>
    </div>
    <table border="0" cellpadding="0" cellspacing="0" class="default outer">
	<colgroup>
		<col width="15%" />
		<col width="10%" />
		<col width="15%" />
		<col width="" />
	</colgroup>
	<tr>
		<th class="left">소득세법(감면세액)</th>
		<th class="center">감면세액</th>
		<td class="right"> 
			<input id="B010_14" name="B010_14" type="text" class="text w90 right" /> 원 
		</td>
		<td class="left"> 
			&nbsp;정부간 협약에 의하여 우리나라에 파견된 외국인이 당사국의 정부로부터 받는 급여
		</td>
	</tr>
	<tr>
		<th class="left">조세특례제한법[제30조 제외]</th>
		<th class="center">감면세액</th>
		<td class="right"> 
			<input id="B010_15" name="B010_15" type="text" class="text w90 right" /> 원 
		</td>
		<td class="left" > 
			&nbsp;외국인 기술자에 대한 소득세 면제
		</td>
	</tr>
	<tr>
		<th class="left">조세특례제한법 제30조</th>
		<th class="center">감면세액</th>
		<td class="right"> 
			<input id="B010_16" name="B010_16" type="text" class="text w90 right" /> 원 
		</td>
		<td class="left" > 
			&nbsp;조세특례제한법 제 30조에 해당하는 중소기업 취업 청년에 대한 소득세 감면		
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
    <table border="0" cellpadding="0" cellspacing="0" class="default outer">
	<colgroup>
		<col width="15%" />
		<col width="10%" />
		<col width="15%" />
		<col width="" />
	</colgroup>
	<tr>
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
			&nbsp;납세조합에 의하여 원천징수된 근로소득에 대한 종합소득 산출세액의 10%
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
		<th class="left">외국납부</th>
		<th class="center">소득금액</th>
		<td class="right"> 
			<input id="B010_09" name="B010_09" type="text" class="text w90 right" /> 원 
		</td>
		<td class="left"> 
			&nbsp;거주자의 근로소득금액에 국외원천소득이 합산되어 있는 경우 그 국외원천소득에 대하여<br>
			&nbsp;외국에서 외국납부세액을 납부하였거나 납부할 것이 있을 때 소득금액
		</td>
	</tr>
	<tr>
		<th class="left">외국납부</th>
		<th class="center">납부세액</th>
		<td class="right"> 
			<input id="B010_11" name="B010_11" type="text" class="text w90 right" /> 원 
		</td>
		<td class="left"> 
			&nbsp;거주자의 근로소득금액에 국외원천소득이 합산되어 있는 경우 그 국외원천소득에 대하여<br>
			&nbsp;외국에서 외국납부세액을 납부하였거나 납부할 것이 있을 때 납부세액
		</td>
	</tr>
	</table>

	<font width="90%" class="title" style="color: red; font-size: 13px;">
		세액감면 및 세액공제는 담당자 입력화면입니다. 해당 하시는 분은 담당자에게 문의하시기 바랍니다.
	</font>
</div>
</body>
</html>