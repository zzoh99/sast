<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<script type="text/javascript">
var chkRow;
var chkCol;
var chkClick = "N";

	$(function() {
        const modal = window.top.document.LayerModalUtility.getModal('appStatusMgrLayer');
        var arg = modal.parameters;

	    if( arg != undefined ) {
	    	$("#searchAppraisalCds").val(arg["appraisalCd"]);
	    	$("#searchSabuns").val(arg["sabun"]);
	    	$("#searchAppOrgCds").val(arg["appOrgCd"]);
	    	$("#searchAppStepCds").val(arg["appStepCd"]);
	    	$("#searchAppStatusCd").val(arg["appStatusCd"]);
	    }
	});

	$(function() {
		var appStatusCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P10018"), "");
		var appStatusCdArr = appStatusCdList[1].split("|");
		var appStatusNmArr = appStatusCdList[0].split("|");
		var spanRadioHtml_1 = "";
		var spanRadioHtml_2 = "";

		for( var i=0; i<appStatusCdArr.length; i++) {
			var checked = "";
			var disabled = "";
			if ( appStatusCdArr[i] == $("#searchAppStatusCd").val() ) {
				checked = "checked";
			}
/*
			if ( parseInt(appStatusCdArr[i], 10) > parseInt($("#searchAppStatusCd").val(), 10) ) {
				disabled = "disabled";
			}
*/
			spanRadioHtml_1 = spanRadioHtml_1 + "\n<th>"+ appStatusNmArr[i] +"</th>";
			spanRadioHtml_2 = spanRadioHtml_2
				+ "\n<td align='center'><input type='radio' id='appStatusCd_"+ i +"' name='appStatusCd' value='"+ appStatusCdArr[i] +"' "+ checked +" "+ disabled +"/></td>";
		}

		$("#spanRadio").html("<table class='table w100p'><tr>"+ spanRadioHtml_1 +"</tr><tr>"+ spanRadioHtml_2 +"</tr></table>");
	});

	function change(){
		var appStatusCd = $("input[name=appStatusCd]:checked").val();

		if( appStatusCd == $("#searchAppStatusCd").val() ){
			alert("진행상태가 변경되지 않았습니다.");
			return;
		}else{
			if(confirm("선택한 상태로 변경 하시겠습니까?")){
				var data = ajaxCall("${ctx}/AppStatusMgr.do?cmd=saveAppStatusMgrPop",$("#srchFrm").serialize(),false);
				if(data.Result.Code > 0) {
					alert("처리되었습니다.");

					var rv = new Array();
					rv["Code"] = "1";

                    const modal = window.top.document.LayerModalUtility.getModal('appStatusMgrLayer');
                    modal.fire('appStatusMgrLayerTrigger', rv).hide();
                } else {
			    	alert(data.Result.Message);
		    	}
			}
		}
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
    <div class="modal_body">
        <form id="srchFrm" name="srchFrm">
            <input type="hidden" id="searchAppraisalCds" 	name="searchAppraisalCds" 	value=""/>
            <input type="hidden" id="searchSabuns" 			name="searchSabuns"       	value=""/>
            <input type="hidden" id="searchAppOrgCds" 		name="searchAppOrgCds"    	value=""/>
            <input type="hidden" id="searchAppStepCds" 		name="searchAppStepCds"   	value=""/>
            <input type="hidden" id="searchAppStatusCd" 	name="searchAppStatusCd"   	value=""/>

            <div class="inner">
                <span id="spanRadio"></span>
            </div>
        </form>
    </div>
    <div class="modal_footer">
        <a href="javascript:change();" 	class="btn filled">변경</a>
        <a href="javascript:closeCommonLayer('appStatusMgrLayer');" class="btn outline_gray">닫기</a>
    </div>
</div>
</body>
</html>