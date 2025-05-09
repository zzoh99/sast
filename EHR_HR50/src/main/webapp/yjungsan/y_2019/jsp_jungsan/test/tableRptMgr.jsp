<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>연말정산항목관리</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function() {
		$("#searchTableKind").change(function(){
			setTableName();	
		});

		$("#searchDbUser,#searchTableName").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
		});

	});
	
	//Sheet1 Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search": 	 	
			if( $("#searchDbUser").val() == "" ) {
				alert("OWNER 를 입력하세요.");
				$("#searchDbUser").focus();
				return;
			}
			
			setReportParams() ;
			//레포트 공통 IFrame호출
			//레포트 공통 팝업창에서 쓰는 IFRAME으로, 같이 공통으로 사용한다.
			submitCall($("#paramFrm"),"reportPage_ifrmsrc","post","../common/rdPopupIframe.jsp");
		}
	}
	
	
	/**
	 * 출력 iframe setting method
	 * 레포트 공통 IFRAME에 맞춘 개발 코드 템플릿
	 * by JSG
	 */
	function setReportParams(){
		pm = "";
		if($("#searchTableKind").val() =="List") {
		    reportFileNm = "sys/TableList.mrd";
		    pm          = pm + "["+$("#searchDbUser").val()+"]";
		}else if($("#searchTableKind").val()=="ViewCol") {
		    reportFileNm = "sys/TableViewCol.mrd";
		    pm          = pm + "["+$("#searchDbUser").val()+"] ["+$("#searchTableName").val()+"]";
		}else if($("#searchTableKind").val()=="ViewRow") {
		    reportFileNm = "sys/TableViewRow.mrd";
		    pm          = pm + "["+$("#searchDbUser").val()+"] ["+$("#searchTableName").val()+"]";
		};
		
		$("#Mrd").val(reportFileNm);
		$("#Param").val(pm);
		$("#ParamGubun").val("rp") ;//파라매터구분(rp/rv)
		$("#ToolbarYn").val("Y") ;//툴바여부
		$("#ZoomRatio").val("100") ;//확대축소비율
	
		$("#SaveYn").val("Y") ;//기능컨트롤_저장
		$("#PrintYn").val("Y") ;//기능컨트롤_인쇄
		$("#ExcelYn").val("Y") ;//기능컨트롤_엑셀
		$("#WordYn").val("Y") ;//기능컨트롤_워드
		$("#PptYn").val("Y") ;//기능컨트롤_파워포인트
		$("#HwpYn").val("Y") ;//기능컨트롤_한글
		$("#PdfYn").val("Y") ;//기능컨트롤_PDF
	}		
	
	function setTableName() {
	    var tableKind = $("#searchTableKind").val();
	    if((tableKind == "ViewRow") || (tableKind == "ViewCol")) {
	    	$("#searchTableName").attr("disabled", false);
	        $("#searchTableName").focus();
	    }else {
	    	$("#searchTableName").val("");
	    	$("#searchTableName").attr("disabled", true);
	        $("#searchTableKind").focus();
	    }
	}	

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="paramFrm" name="paramFrm" >
		<input type="hidden" id="Mrd" >
		<input type="hidden" id="Param" name="Param">
		<input type="hidden" id="ToolbarYn">
		<input type="hidden" id="ZoomRatio">
		<input type="hidden" id="ParamGubun">
		<input type="hidden" id="SaveYn">
		<input type="hidden" id="PrintYn">
		<input type="hidden" id="ExcelYn">
		<input type="hidden" id="WordYn">
		<input type="hidden" id="PptYn">
		<input type="hidden" id="HwpYn">
		<input type="hidden" id="PdfYn">		
	</form>
	<form id="srchFrm" name="srchFrm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td> <span>OWNER </span> <input id="searchDbUser" name ="searchDbUser" value="EHR_PTH" type="text" class="text center"/> </td>						
						<td> <span>명세서종류 </span> 
							<select id="searchTableKind" name="searchTableKind"> 
		                        <option value="List" selected>테이블리스트</option>
		                        <option value="ViewCol">테이블명세_가로</option>
		                        <option value="ViewRow">테이블명세_세로</option>						
							</select> 
						</td>						

						<td> <span>테이블명 </span> <input id="searchTableName" name ="searchTableName" type="text" class="text" disabled/> </td>					
						<td> <a href="javascript:doAction('Search')" id="btnSearch" class="button">조회</a> </td>
						
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
							<li id="txt" class="txt">테이블명세서</li>
						</ul>
					</div>
				</div>
				<div class="table_rpt">
					<iframe name="reportPage_ifrmsrc" id="reportPage_ifrmsrc" frameborder='0' class='tab_iframes'></iframe>
				</div>
				
			</td>
		</tr>
	</table>
</div>
</body>
</html>