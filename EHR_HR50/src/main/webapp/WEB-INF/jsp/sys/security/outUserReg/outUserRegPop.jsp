<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"><head> 
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<title><tit:txt mid='114364' mdef='외부사용자등록 중복체크'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var p = eval("${popUpStatus}");
	
	$(function() {
        var arg = p.window.dialogArguments;

	    if( arg != undefined ) {
	    	$("#searchType").val(arg["searchType"]);
	    }else{
			if ( p.popDialogArgument("searchType") !=null ) { $("#searchType").val(p.popDialogArgument("searchType")); }
	    }
	    
	    if ( $("#searchType").val() == "SABUN")	$(".tdSabun").removeClass("hide");
	    if ( $("#searchType").val() == "ID")	$(".tdId").removeClass("hide");
	});
	
	function doAction(sAction) {
		switch (sAction) {
		case "Search":
			var searchVal = "";
			
			if ( $("#searchType").val() == "SABUN")	searchVal = $("#searchSabun").val();
			if ( $("#searchType").val() == "ID")	searchVal = $("#searchId").val();
			
			if ( searchVal == "" ) {
				alert("<msg:txt mid='110071' mdef='조회할 값을 입력해 주세요'/>");
				return;
			}
		    
			var data = ajaxCall("${ctx}/OutUserReg.do?cmd=getOutUserRegPopMap", $("#srchFrm").serialize(), false);
			
			if ( 0 < data.map.cnt ) {
				alert("이미 사용중입니다.");
				
			} else {
				if ( !confirm("["+ searchVal +"]을 사용하시겠습니까?") ) return;
				
				var rv = new Array(2);
				rv["searchVal"] = searchVal;

				if(p.popReturnValue) p.popReturnValue(rv);
				p.window.close();
			}
			
			break;
		}
	}
</script>
</head>
<body class="bodywrap">
    <div class="wrapper">
        <div class="popup_main">
        	<form id="srchFrm" name="srchFrm" >
        		<input type="hidden" id="searchType" name="searchType" />
        		
		        <div class="sheet_search outer">
		            <div>
		                <table>
		                    <tr>
		                        <td class="hide tdSabun">
		                            <span><tit:txt mid='104470' mdef='사번 '/></span>
		                            <input id="searchSabun" name="searchSabun" type="text" class="text w100" maxlength=13 />
		                        </td>
		                        <td class="hide tdId">
		                            <span>ID </span>
		                            <input id="searchId" name="searchId" type="text" class="text w100" maxlength=100 />
		                        </td>
		                        <td>
		                            <btn:a href="javascript:doAction('Search')" id="btnSearch" css="button"  mid='110697' mdef="조회"/>
		                        </td>
		                    </tr>
						</table>
		            </div>
		        </div>
		    </form>
        </div>
	</div>
</body>
</html>
