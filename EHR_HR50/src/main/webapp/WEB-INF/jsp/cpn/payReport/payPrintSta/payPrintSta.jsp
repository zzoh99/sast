<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
	$(function() {
		//var businessPlaceCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getBusinessPlaceCdList",false).codeList, "<tit:txt mid='103895' mdef='전체'/>");	//사업장
		//사업장코드 관리자권한만 전체사업장 보이도록, 그외는 권한사업장만.
		/* var url     = "queryId=getBusinessPlaceCdList";
		var allFlag = true;
		if ("${ssnSearchType}" != "A"){
			url    += "&searchChkPlace=Y&sabun=${ssnSabun}&grpCd=${ssnGrpCd}";
			allFlag = false;
		}
		var businessPlaceCd = "";
		if(allFlag) {
			businessPlaceCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, ("${ssnLocaleCd}" != "en_US" ? "<tit:txt mid='103895' mdef='전체'/>" : "All"));	//사업장
		} else {
			businessPlaceCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, "");	//사업장
		}	 */

		var businessPlaceCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrgMapItemBpCdList",false).codeList, "<tit:txt mid='103895' mdef='전체'/>");	//소속구분항목(급여사업장)

		$("#searchBusinessPlaceCd").html(businessPlaceCd[2]);

		$("#searchOrgNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
		});

		getCpnLatestPaymentInfo();
		/*기존 로직 그대로 적용 : 레포트 구분을 위한 로직이 된다.
		 */
	    //1.참고사항의 헤더수 출력
		var hdrCnt1 = 0;
	    var hdrCnt2 = 0;
	    var hdrCnt3 = 0;
	    var hdrMaxCnt1 = 8;
	    var hdrMaxCnt2 = 21;
	    var hdrMaxCnt3 = 16;
	    var cnt1 = ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&searchPayActionCd="+$("#searchPayActionCd").val(),"queryId=getSheetHeaderCnt1",false);
		//2.지급내역의 헤더수 출력
		var cnt2 = ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&searchPayActionCd="+$("#searchPayActionCd").val()+"&searchElementType=A","queryId=getSheetHeaderCnt2",false);
		//3.공제내역의 헤더수 출력
		var cnt3 = ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&searchPayActionCd="+$("#searchPayActionCd").val()+"&searchElementType=D","queryId=getSheetHeaderCnt2",false);

		var hdrCnt1 = cnt1.codeList[0].cnt ;
		var hdrCnt2 = cnt2.codeList[0].cnt ;
		var hdrCnt3 = cnt3.codeList[0].cnt ;

	});

	//Sheet1 Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search":
			var data = ajaxCall("/PayPrintSta.do?cmd=getRdRk", $("#srchFrm").serialize(), false);
			if ( data != null && data.DATA != null ){
				const rdData = {
					rk : data.DATA.rk
				};
				submitCallRd($("#paramFrm"),"reportPage_ifrmsrc","post","/RdIframe.do", "/PayPrintSta.do?cmd=getEncryptRd", rdData)
			}
		}
	}

	 // 급여일자 검색 팝입
    function payActionSearchPopup() {
    	try{
			if(!isPopup()) {return;}
			gPRow = "";
			pGubun = "payDayPopup";

			let layerModal = new window.top.document.LayerModal({
				id : 'payDayLayer'
				, url : '/PayDayPopup.do?cmd=viewPayDayLayer&authPg=R'
				, parameters : {
					runType : '00001,0002'
				}
				, width : 840
				, height : 520
				, title : '<tit:txt mid='payDayPop' mdef='급여일자 조회'/>'
				, trigger :[
					{
						name : 'payDayTrigger'
						, callback : function(result){
							$("#searchPayActionCd").val(result.payActionCd);
							$("#searchPayActionNm").val(result.payActionNm);

							if ($("#searchPayActionCd").val() != null && $("#searchPayActionNm").val() != "") {
								doAction("Search");
							}
						}
					}
				]
			});
			layerModal.show();
    	}catch(ex){alert("Open Popup Event Error : " + ex);}
    }

    function getReturnValue(returnValue) {
    	var rv = returnValue;
    }

	// 최근급여일자 조회
	function getCpnLatestPaymentInfo() {
		var procNm = "최근급여일자";
		// 급여구분(C00001-00001.급여)
		var paymentInfo = ajaxCall("${ctx}/PayPrintSta.do?cmd=getCpnQueryList", "queryId=getCpnLatestPaymentInfoMap&procNm="+procNm+"&runType=00001,", false);

		if (paymentInfo.DATA != null && paymentInfo.DATA != "" && typeof paymentInfo.DATA[0] != "undefined") {
			$("#searchPayActionCd").val(paymentInfo.DATA[0].payActionCd);
			$("#searchPayActionNm").val(paymentInfo.DATA[0].payActionNm);

			if ($("#payActionCd").val() != null && $("#payActionCd").val() != "") {
				//	doAction("Search");
			}
		} else if (paymentInfo.Message != null && paymentInfo.Message != "") {
			alert(paymentInfo.Message);
		}
	}

	//  소속 팝업
    function orgSearchPopup(){
        try{
			if(!isPopup()) {return;}
			gPRow = "";
			pGubun = "orgBasicPopup";

			let layerModal = new window.top.document.LayerModal({
				id : 'orgLayer'
				, url : '/Popup.do?cmd=viewOrgBasicLayer&authPg=${authPg}'
				, parameters : {}
				, width : 740
				, height : 520
				, title : '<tit:txt mid='orgSchList' mdef='조직 리스트 조회'/>'
				, trigger :[
					{
						name : 'orgTrigger'
						, callback : function(result){
							if(!result.length) return;
							$("#searchOrgNm").val(result[0].orgNm);
							$("#searchOrgCd").val(result[0].orgCd);
						}
					}
				]
			});
			layerModal.show();
        }catch(ex){alert("Open Popup Event Error : " + ex);}
    }


</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="paramFrm" name="paramFrm" >
		<input type="hidden" id="Mrd">
		<input type="hidden" id="Param">
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
						<th><tit:txt mid='104477' mdef='급여일자'/></th>
						<td>
							<input type="hidden" id="searchPayActionCd" name="searchPayActionCd" value="" /><input type="hidden" id="sabun" name="sabun" class="text" value="" />
							<input type="text" id="searchPayActionNm" name="searchPayActionNm" class="text" value="" validator="required" readonly="readonly" style="width:150px" />
							<a onclick="javascript:payActionSearchPopup();return false;" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
						</td>
						<th><tit:txt mid='114399' mdef='사업장'/></th>
						<td>
							<select id="searchBusinessPlaceCd" name ="searchBusinessPlaceCd" class="box"></select>
						</td>
					</tr>
					<tr>
						<th><tit:txt mid='104295' mdef='소속 '/></th>
						<td>
							<input type="hidden" id="searchOrgCd" name="searchOrgCd">
							<input id="searchOrgNm" name ="searchOrgNm" type="text" class="text readonly" readOnly style="width:148px"/>
							<a onclick="javascript:orgSearchPopup();return false;" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
							<a onclick="$('#searchOrgCd,#searchOrgNm').val('');return false;" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
						</td>
						<th><tit:txt mid='112108' mdef='출력단위'/></th>
						<td>
							<select id="searchPrintUnit" name ="searchPrintUnit" class="box">
							    <option value="1" >개인별</option>
		                        <option value="2" >팀별</option>
		                        <option value="3" >사업장별</option>
		                        <option value="4" >개인+팀별</option>
							</select>
						</td>
						<td><a href="javascript:doAction('Search')" id="btnSearch" class="button"><tit:txt mid='104081' mdef='조회'/></a></td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main" >
		<tr>
			<td>
				<div class="table_rpt">
					<iframe name="reportPage_ifrmsrc" id="reportPage_ifrmsrc" frameborder='0' class='tab_iframes'></iframe>
				</div>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
