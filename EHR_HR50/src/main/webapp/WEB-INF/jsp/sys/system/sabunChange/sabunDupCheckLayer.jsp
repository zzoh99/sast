<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='113773' mdef='임직원 조회 팝업'/></title>

<script type="text/javascript">
var sabunDupCheckLayer = { id: 'sabunDupCheckLayer' };
var srchBizCd = null;
/*Sheet 기본 설정 */
$(function() {
	$("#btnSave").hide();
    $("#infoDiv").hide();
    $("#searchSabun").bind("keyup", function(event){ if(event.keyCode == 13){ doAction("Search");}});
    $("#searchSabun").focus();
});

/*Sheet Action*/
function doAction(sAction) {
	switch (sAction) {
		case "Search": //조회
			if( ( $.trim( $("#searchSabun").val( )) ) == "" ){
				alert("<msg:txt mid='109449' mdef='사번을 입력하세요.'/>");
				$("#searchSabun").focus();
			} else {
			    var result = ajaxCall("${ctx}/SabunChange.do?cmd=getSabunDupCheckPopupMap", $("#srchFrm").serialize(), false);
			    if(result.map != null){
                    $("#infoDiv").show();
			        if(result.map.dupYn == 'Y'){
			        	$("#useSabun").val($("#searchSabun").val());
			        	$("#info").text("사용가능한 사번 입니다.");
			        	$("#btnSave").show();
			        }else{
			        	$("#useSabun").val("");
			        	$("#info").text("이미 사용중인 사번 입니다.");
                        $("#btnSave").hide();
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
    const modal = window.top.document.LayerModalUtility.getModal(sabunDupCheckLayer.id);
	var p = { sabun : $('#useSabun').val() };
	modal.fire(sabunDupCheckLayer.id + 'Trigger', p).hide();
}
</script>

</head>
<body class="bodywrap">
    <div class="wrapper modal_layer">
        <div class="modal_body">
            <form id="srchFrm" name="srchFrm">
            <input type="hidden" name="useSabun" id="useSabun"  />
                <div class="sheet_search outer">
                    <div>
                    <table>
                    <tr>
                    	<th><tit:txt mid='103975' mdef='사번'/></th>
                        <td>  <input id="searchSabun" name ="searchSabun" type="text" class="text" maxlength="13"/> </td>
                        <td>
                            <btn:a href="javascript:doAction('Search')" id="btnSearch" css="btn dark" mid='110697' mdef="조회"/>
                        </td>
                        <td>
                            <div id="infoDiv" style="display: inline-flex; align-items: center;"><span style="color:red" id="info"></span><btn:a href="javascript:returnSabun();" id="btnSave" css="btn filled" mid='111104' mdef="사용"/></div>
                        </td>
                    </tr>
                    </table>
                    </div>
                </div>
	        </form>
        </div>
        <div class="modal_footer">
            <btn:a href="javascript:closeCommonLayer('sabunDupCheckLayer');" css="btn outline_gray" mid='110881' mdef="닫기"/>
        </div>
    </div>
</body>
</html>
