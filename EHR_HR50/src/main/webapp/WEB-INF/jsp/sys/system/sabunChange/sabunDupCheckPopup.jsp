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
	/*Sheet 기본 설정 */
	$(function() {

		$("#useBtn").hide();

        $("#searchSabun").bind("keyup",function(event){
			if( event.keyCode == 13){
		 		doAction("Search");
			}
		});

        // 숫자만 입력가능
//        $("#searchSabun").keyup(function() {
//             makeNumber(this,'A');
//         });

        $("#searchSabun").focus();


        $(".close").click(function() {
	    	p.self.close();
	    });
	});

	/*Sheet Action*/
	function doAction(sAction) {
		switch (sAction) {
			case "Search": //조회
				if( ( $.trim( $("#searchSabun").val( )) ) == "" ){
					alert("<msg:txt mid='109449' mdef='사번을 입력하세요.'/>");
					$("#searchSabun").focus();
				}else{
				    var result = ajaxCall("${ctx}/SabunChange.do?cmd=getSabunDupCheckPopupMap", $("#srchFrm").serialize(), false);

				    if(result.map != null){
				        if(result.map.dupYn == 'Y'){

				        	$("#useSabun").val($("#searchSabun").val());
				        	$("#info").text("사용가능한 사번 입니다.");
				        	$("#useBtn").show();


				        }else{
				        	$("#useSabun").val("");
				        	$("#info").text("이미 사용중인 사번 입니다.");
                            $("#useBtn").hide();
				        }
				    }
				}
	            break;
		}
    }

	function returnSabun(){
	    if( $("#useSabun").val() == "" ) {
	         alert("중복조회 후 사용 하실수 있습니다.");
	        return;
	    }
    	var returnValue = new Array();

		returnValue["sabun"]	= $("#useSabun").val();

		if(p.popReturnValue) p.popReturnValue(returnValue);
        p.self.close();
	}


</script>

</head>
<body class="bodywrap">
    <div class="wrapper">
        <div class="popup_title">
            <ul>
                <li><tit:txt mid='113630' mdef='사번중복 조회'/></li>
                <li class="close"></li>
            </ul>
        </div>
        <div class="popup_main">
            <form id="srchFrm" name="srchFrm">
            <input type="hidden" name="useSabun" id="useSabun"  />
                <div class="sheet_search outer">
                    <div>
                    <table>
                    <tr>
                    	<th><tit:txt mid='103975' mdef='사번'/></th>
                        <td>  <input id="searchSabun" name ="searchSabun" type="text" class="text" maxlength="13"/> </td>
                        <td>
                            <btn:a href="javascript:doAction('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/>

                        </td>
                        <td>
                            <div id="infoDiv"><span style="color:red" id="info"></span><span id="useBtn"><btn:a href="javascript:returnSabun();" id="btnSearch" css="pink" mid='111104' mdef="사용"/></span></div>
                        </td>

                    </tr>
                    </table>
                    </div>
                </div>
	        </form>
	        <div class="popup_button outer">
	            <ul>
	                <li>
	                    <btn:a href="javascript:p.self.close();" css="gray large" mid='110881' mdef="닫기"/>
	                </li>
	            </ul>
	        </div>
        </div>
    </div>
</body>
</html>
