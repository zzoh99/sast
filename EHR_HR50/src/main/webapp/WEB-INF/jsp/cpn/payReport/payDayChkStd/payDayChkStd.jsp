<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='112073' mdef='급여지급율관리'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->

<script type="text/javascript">

//선택된 탭
	var newIframe;
	var oldIframe;
	var iframeIdx;

	$(function() {

		newIframe = $('#tabs-1 iframe');
		iframeIdx = 0;

		$( "#tabs" ).tabs({
			beforeActivate: function(event, ui) {
				iframeIdx = ui.newTab.index();
				newIframe = $(ui.newPanel).find('iframe');
				oldIframe = $(ui.oldPanel).find('iframe');
				showIframe();
			}
		});

		//탭 높이 변경
		function setIframeHeight() {
		    var iframeTop = $("#tabs ul.tab_bottom").height() + 16;
		    $(".layout_tabs").each(function() {
		        $(this).css("top",iframeTop);
		    });
		}

     	// 화면 리사이즈
		$(window).resize(setIframeHeight);
		setIframeHeight();
		//showIframe();

	});

    //Sheet Action
    var selectTab = "tab1";

    function doAction() {
        switch (selectTab) {
        case "tab1":      tab1.doAction('Search'); break;
        case "tab2":      tab2.doAction('Search'); break;
        //case "tab3":      tab3.doAction('Search'); break;
        }
    }

	function showIframe() {
		if(typeof oldIframe != 'undefined') {
			oldIframe.attr("src","${ctx}/common/hidden.html");
		}
		if(iframeIdx == 0) {
			newIframe.attr("src","${ctx}/PayDayChkStd.do?cmd=viewPayDayChkTab1Std"+"&authPg=${authPg}");
		} else if(iframeIdx == 1) {
			newIframe.attr("src","${ctx}/PayDayChkStd.do?cmd=viewPayDayChkTab2Std"+"&authPg=${authPg}");
		}
		/* else if(iframeIdx == 2) {
			newIframe.attr("src","${ctx}/PayDayChkTab3Std.do?cmd=viewPayDayChkTab3Std"+"&authPg=${authPg}");
		} */
	}

    //  사원조회 팝업
    function openOrgSchemePopup(){
		let layerModal = new window.top.document.LayerModal({
			id : 'employeeLayer'
			, url : '/Popup.do?cmd=viewEmployeeLayer&authPg=${authPg}'
			, parameters : {}
			, width : 840
			, height : 520
			, title : '사원조회'
			, trigger :[
				{
					name : 'employeeTrigger'
					, callback : function(result){
						$("#searchName").val(result.name);
						$("#searchSabunHidden").val(result.sabun);
					}
				}
			]
		});
		layerModal.show();


        <%--try{--%>

        <%--	var args    = new Array();--%>
        <%--	var rv = openPopup("/Popup.do?cmd=employeePopup&authPg=${authPg}", args, "740","520");--%>
        <%--    if(rv!=null){--%>

        <%--    	$("#searchName").val(rv["name"]);--%>
        <%--    	$("#searchSabunHidden").val(rv["sabun"]);--%>
        <%--    }--%>
        <%--}catch(ex){alert("Open Popup Event Error : " + ex);}--%>
    }

    //  급여일자 조회 팝업
   /* function openPayDayPopup(){
        try{

        	var args    = new Array();
        	var rv = openPopup("/PayDayPopup.do?cmd=payDayPopup&authPg=${authPg}", args, "740","520");
            if(rv!=null){

            	$("#searchPayActionNmHidden").val(rv["payActionCd"]);
            	$("#searchPayActionNm").val(rv["payActionNm"]);

            }
        }catch(ex){alert("Open Popup Event Error : " + ex);}
    }
   */
	// 최근급여일자 조회
	function getCpnLatestPaymentInfo() {
		var procNm = "최근급여일자";
		// 급여구분(C00001-00001.급여)
		var paymentInfo = ajaxCall("${ctx}/PayDayChkStd.do?cmd=getCpnQueryList", "queryId=getCpnLatestPaymentInfoMap&procNm="+procNm+"&runType=00001,", false);

		if (paymentInfo.DATA != null && paymentInfo.DATA != "" && typeof paymentInfo.DATA[0] != "undefined") {
			$("#searchPayActionNmHidden").val(paymentInfo.DATA[0].payActionCd);
			$("#searchPayActionNm").val(paymentInfo.DATA[0].payActionNm);
		} else if (paymentInfo.Message != null && paymentInfo.Message != "") {
			alert(paymentInfo.Message);
		}
	}

    function bodyOnload() {
    	//사업장코드 관리자권한만 전체사업장 보이도록, 그외는 권한사업장만.
		var url     = "queryId=getBusinessPlaceCdList";
		var allFlag = true;
		if ("${ssnSearchType}" != "A"){
			url    += "&searchChkPlace=Y&sabun=${ssnSabun}&grpCd=${ssnGrpCd}";
			allFlag = false;
		}		
		var businessPlaceCd = "";
		if(allFlag) {
			businessPlaceCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, ("${ssnLocaleCd}" != "en_US" ? "전체" : "All"));	//사업장	
		} else {
			businessPlaceCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, "");	//사업장
		}
		$("#businessPlaceCd").html(businessPlaceCd[2]);
    	
    	getCpnLatestPaymentInfo();
    	showIframe();
    }


 // 급여일자 검색 팝업
    function openPayDayPopup() {
		let layerModal = new window.top.document.LayerModal({
			id : 'payDayLayer'
			, url : '/PayDayPopup.do?cmd=viewPayDayLayer&authPg=${authPg}'
			, parameters : {}
			, width : 840
			, height : 520
			, title : '<tit:txt mid='payDayPop' mdef='급여일자 조회'/>'
			, trigger :[
				{
					name : 'payDayTrigger'
					, callback : function(result){
						$("#searchPayActionNmHidden").val(result.payActionCd);
						$("#searchPayActionNm").val(result.payActionNm);
					}
				}
			]
		});
		layerModal.show();



    	<%--try{--%>
    	<%--	if(!isPopup()) {return;}--%>
    	<%--	gPRow = "";--%>
    	<%--	pGubun = "payDayPopup";--%>

    	<%--	var w		= 840;--%>
    	<%--	var h		= 520;--%>
    	<%--	var url		= "/PayDayPopup.do?cmd=payDayPopup";--%>
    	<%--	var args	= "";--%>

    	<%--	var result = openPopup(url+"&authPg=${authPg}", args, w, h);--%>
    	<%--	/*--%>
    	<%--	if (result) {--%>
    	<%--		var payActionCd	= result["payActionCd"];--%>
    	<%--		var payActionNm	= result["payActionNm"];--%>

    	<%--		$("#searchPayActionCd").val(payActionCd);--%>
    	<%--		$("#searchPayActionNm").val(payActionNm);--%>

    	<%--		doAction1("Search");--%>
    	<%--	}--%>
    	<%--	*/--%>
    	<%--}catch(ex){alert("Open Popup Event Error : " + ex);}--%>
    }

    function getReturnValue(returnValue) {
    	var rv = $.parseJSON('{' + returnValue+ '}');

        if(pGubun == "payDayPopup"){
    		$("#searchPayActionNmHidden").val(rv["payActionCd"]);
    		$("#searchPayActionNm").val(rv["payActionNm"]);
        }
    }
</script>
</head>
<body class="bodywrap" onload="bodyOnload();">
<div class="wrapper">
	<form id="mySheetForm" name="mySheetForm" >
		<div class="sheet_search outer">
			<input type="hidden" id="searchSabunHidden" name="searchSabunHidden" value="" />
			<input type="hidden" id="searchPayActionNmHidden" name="searchPayActionNmHidden" value="" />
			<table>
				<tr>
					<th><tit:txt mid='103880' mdef='성명'/></th>
					<td>
						<input id="searchName" name="searchName" type="hidden"/>
						<input type="text"   id="searchKeyword"  name="searchKeyword" class="text" style="ime-mode:active"/>
						<input type="hidden" id="searchEmpType"  name="searchEmpType" value="I"/> <!-- Include에서  사용 -->
						<input type="hidden" id="searchStatusCd" name="searchStatusCd" value="A" /><!-- in ret -->
						<input type="hidden" id="searchUserId"   name="searchUserId" value="${ssnSabun}" />
					</td>
					<th><tit:txt mid='113512' mdef='&nbsp;&nbsp;급여일자'/></th>
					<td>
					    <input type="text" id="searchPayActionNm" name="searchPayActionNm" class="text" value="" validator="required" readonly="readonly" style="width:150px" />
						<a  onclick="javascript:openPayDayPopup()" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
<%--						<a onclick="$('#searchPayActionNmHidden,#searchPayActionNm').val('');" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>--%>
					</td>
					<th><tit:txt mid='114399' mdef='사업장'/></th>
					<td>  <select id="businessPlaceCd" name="businessPlaceCd"> </select> </td>
				</tr>
			</table>
		</div>
	</form>

	<div style="position:absolute;width:100%;top:60px;bottom:0;">
        <div id="tabs">
            <ul class="tab_bottom">
                <li><btn:a href="#tabs-1" onclick="javascript:showIframe()" mid='111658' mdef="발령"/></li>
                <li><btn:a href="#tabs-2" onclick="javascript:showIframe()" mid='111652' mdef="근태"/></li>
                <!--
                <li><btn:a href="#tabs-3" onclick="javascript:showIframe()" mid='111157' mdef="징계"/></li>
                -->
            </ul>

            <div id="tabs-1">
                <div  class='layout_tabs'><iframe id="tab1" name="tab1" src='${ctx}/common/hidden.html' frameborder='0' class='tab_iframes'></iframe></div>
            </div>
            <div id="tabs-2">
                <div  class='layout_tabs'><iframe id="tab2" name="tab2" src='${ctx}/common/hidden.html' frameborder='0' class='tab_iframes'></iframe></div>
            </div>
            <!--
            <div id="tabs-3">
                <div  class='layout_tabs'><iframe id="tab3" name="tab3" src='${ctx}/common/hidden.html' frameborder='0' class='tab_iframes'></iframe></div>
            </div>
            -->
        </div>
    </div>
</div>
</body>
</html>