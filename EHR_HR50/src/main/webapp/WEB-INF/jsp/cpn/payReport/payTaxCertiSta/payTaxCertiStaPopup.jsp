<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> 
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
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
				alert("<msg:txt mid='109375' mdef='OWNER 를 입력하세요.'/>");
				$("#searchDbUser").focus();
				return;
			}
			
			submitCall($("#srchFrm"),"reportPage_ifrmsrc","post","/TableRptMgr.do?cmd=viewTable_report");

			 			
			/* 예전 소스, 리포트 구현 방법이 정해지면 구현 해야 함, 2013.05.22, 최범수
            var tableKind = document.all.searchTableKind.value;
            var tableName = document.all.searchTableName.value;

            var param = "&searchDbUser=" + document.form.searchDbUser.value;
            	param += "&searchTableKind=" + document.form.searchTableKind.value;
            	param += "&searchTableName=" + document.form.searchTableName.value;
            
            reportPage_ifrmsrc.location.href = "/JSP/report/sys/TableView_report_view.jsp?" + param;
            */
		}
	}
	
	function setTableName() {
	    var tableKind = $("#searchTableKind").val();
	    if((tableKind == "viewCol") || (tableKind == "viewRow")) {
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
	<form id="srchFrm" name="srchFrm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th>OWNER </th>
						<td>  <input id="searchDbUser" name ="searchDbUser" value="EHR_PTH" type="text" class="text" /> </td>	
						<th><tit:txt mid='112425' mdef='명세서종류 '/></th>					
						<td>  
							<select id="searchTableKind" name="searchTableKind"> 
		                        <option value="list" selected>테이블리스트</option>
		                        <option value="viewCol">테이블명세_가로</option>
		                        <option value="viewRow">테이블명세_세로</option>						
							</select> 
						</td>						
						<th><tit:txt mid='113137' mdef='테이블명 '/></th>
						<td>  <input id="searchTableName" name ="searchTableName" type="text" class="text" /> </td>					
						<td> <a href="javascript:doAction('Search')" id="btnSearch" class="button"><tit:txt mid='104081' mdef='조회'/></a> </td>
						
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
							<li id="txt" class="txt"><tit:txt mid='tableRptMgr' mdef='테이블명세서'/></li>
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
