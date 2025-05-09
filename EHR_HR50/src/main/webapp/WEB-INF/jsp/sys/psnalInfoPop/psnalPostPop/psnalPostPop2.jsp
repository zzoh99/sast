<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='112955' mdef='발령세부내역'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

	var p = eval("${popUpStatus}");
	var arg = p.window.dialogArguments;

	var sabun = arg['sabun'];
	var enterCd = arg['enterCd'];
	var dbLink = arg['dbLink'];
	var ordDetailCd = arg['ordDetailCd'];
	var ordYmd = arg['ordYmd'];
	var applySeq = arg['applySeq'];
	var authPg = "${authPg}";

	$(function() {
		
        $(".close").click(function() {
	    	p.self.close();
	    });
        
        if(authPg == "A") {
        	$("#hdnMemo").show();
        }
        
        var param = "sabun="+sabun
			        +"&enterCd="+enterCd
			        +"&dbLink="+dbLink
        			+"&ordDetailCd="+ordDetailCd
        			+"&ordYmd="+ordYmd
        			+"&applySeq="+applySeq;
        
    	var dataMap = ajaxCall("/PsnalPostPop.do?cmd=getPsnalPostPop2",param,false);

    	if(dataMap != null && dataMap.DATA != null) {
    		var data = dataMap.DATA;
    		
    		$('#sabun').text(data.sabun);
    		$('#name').text(data.name);
    		$('#orgDetailNm').text(data.ordDetailNm);
    		$('#applySeq').text(data.applySeq);
    		$('#orgYmd').text(formatDate(data.ordYmd,"-"));
    		$('#ordEYmd').text(formatDate(data.ordEYmd,"-"));
    		$('#statusNm').text(data.statusNm);
    		$('#manageNm').text(data.manageNm);
    		$('#locationNm').text(data.locationNm);
    		$('#orgNm').text(data.orgNm);
    		$('#jikchakNm').text(data.jikchakNm);
    		$('#workTypeNm').text(data.workTypeNm);
    		$('#jobNm').text(data.jobNm);
    		$('#jikweeNm').text(data.jikweeNm);
    		$('#traYmd').text(formatDate(data.traYmd,"-"));
    		$('#gempYmd').text(formatDate(data.gempYmd,"-"));
    		$('#returnYmd').text(formatDate(data.returnYmd,"-"));
    		$('#empYmd').text(formatDate(data.empYmd,"-"));
    		$('#ctitleChgYmd').text(formatDate(data.ctitleChgYmd,"-"));
    		$('#jikgubChgYmd').text(formatDate(data.jikgubChgYmd,"-"));
    		$('#fpromYmd').text(formatDate(data.fpromYmd,"-"));
    		$('#dispatchOrgNm').text(data.dispatchOrgNm);
    		$('#removeOrgNm').text(data.removeOrgNm);
    		$('#base1Nm').text(data.base1Nm);
    		$('#salClassNm').text(data.salClassNm);
    		$('#payTypeNm').text(data.payTypeNm);
    		$('#jikgubNm').text(data.jikgubNm);
    		$('#payGroupNm').text(data.payGroupNm);
    		$('#contractSymd').text(formatDate(data.contractSymd,"-"));
    		$('#contractEymd').text(formatDate(data.contractEymd,"-"));
    		$('#ordReasonNm').text(data.ordReasonNm);
    		$('#resignReasonNm').text(data.resignReasonNm);
    		$('#retPathNm').text(data.retPathNm);
    		$('#memo').text(data.memo);
    		
    		Num_Comma($('#enterPayNm').text($.trim(data.enterPay)).get(0));
    	}
	});
	
	// 날짜 포맷을 적용한다..
	function formatDate(strDate, saper) {
		if(strDate == "" || strDate == null) {
			return "";
		}

		if(strDate.length == 10) {
			return strDate.substring(0,4)+saper+strDate.substring(5,7)+saper+strDate.substring(8,10);
		} else if(strDate.length == 8) {
			return strDate.substring(0,4)+saper+strDate.substring(4,6)+saper+strDate.substring(6,8);
		}
	}
	
</script>

</head>
<body class="bodywrap" tabindex="1">
<div class="wrapper popup_scroll">
	<div class="popup_title">
	<ul>
		<li><tit:txt mid='detail' mdef='세부내역'/></li>
		<li class="close"></li>
	</ul>
	</div>
	
	<div class="popup_main">
		
		<div class="sheet_title">
		<ul>
			<li id="txt" class="txt"><tit:txt mid='detail' mdef='세부내역'/></li>
		</ul>
		</div>
		
		<table border="0" cellpadding="0" cellspacing="0" class="table">
		<colgroup>
			<col width="15%" />
			<col width="35%" />
			<col width="15%" />
			<col width="35%" />
		</colgroup>
		<tr>
			<th><tit:txt mid='113328' mdef='발령구분'/></th>
			<td><span id="orgDetailNm"></span></td>
			<th><tit:txt mid='114040' mdef='발령순번'/></th>
			<td><span id="applySeq"></span></td>
		</tr>
		<tr>
			<th><tit:txt mid='103975' mdef='사번'/></th>
			<td><span id="sabun"></span></td>
			<th><tit:txt mid='103880' mdef='성명'/></th>
			<td><span id="name"></span></td>
		</tr>
		<tr>
			<th><tit:txt mid='114390' mdef='발령일자'/></th>
			<td><span id="orgYmd"></span></td>
			<th><tit:txt mid='113697' mdef='발령종료일자'/></th>
			<td><span id="ordEYmd"></span></td>
		</tr>
		</table>
		
		<table border="0" cellpadding="0" cellspacing="0" class="table" style="margin-top:10px;">
		<colgroup>
			<col width="20%" />
			<col width="80%" />
		</colgroup>
		<tr>
			<th><tit:txt mid='104472' mdef='재직상태'/></th>
			<td><span id="statusNm"></span></td>
		</tr>
		<tr>
			<th><tit:txt mid='103784' mdef='사원구분'/></th>
			<td><span id="manageNm"></span></td>
		</tr>
		<tr>
			<th><tit:txt mid='104281' mdef='근무지'/></th>
			<td><span id="locationNm"></span></td>
		</tr>
		<tr>
			<th><tit:txt mid='104279' mdef='소속'/></th>
			<td><span id="orgNm"></span></td>
		</tr>
		<tr>
			<th><tit:txt mid='103785' mdef='직책'/></th>
			<td><span id="jikchakNm"></span></td>
		</tr>
		<tr>
			<th><tit:txt mid='104089' mdef='직군'/></th>
			<td><span id="workTypeNm"></span></td>
		</tr>
		<tr>
			<th><tit:txt mid='103973' mdef='직무'/></th>
			<td><span id="jobNm"></span></td>
		</tr>
		<tr>
			<th><tit:txt mid='104104' mdef='직위'/></th>
			<td><span id="jikweeNm"></span></td>
		</tr>
		<tr>
			<th><tit:txt mid='103939' mdef='면수습일'/></th>
			<td><span id="traYmd"></span></td>
		</tr>
		<tr>
			<th><tit:txt mid='104473' mdef='그룹입사일'/></th>
			<td><span id="gempYmd"></span></td>
		</tr>
		<tr style="display:none">
			<th><tit:txt mid='104402' mdef='복직예정일'/></th>
			<td><span id="returnYmd"></span></td>
		</tr>
		<tr>
			<th><tit:txt mid='103881' mdef='입사일'/></th>
			<td><span id="empYmd"></span></td>
		</tr>
		<tr style="display:none">
			<th><tit:txt mid='104534' mdef='직위변경일'/></th>
			<td><span id="ctitleChgYmd"></span></td>
		</tr>
		<tr style="display:none">
			<th><tit:txt mid='112274' mdef='직급조정일'/></th>
			<td><span id="jikgubChgYmd"></span></td>
		</tr>
		<tr style="display:none">
			<th><tit:txt mid='104234' mdef='직급변경일'/></th>
			<td><span id="fpromYmd"></span></td>
		</tr>
		<tr>
			<th><tit:txt mid='112600' mdef='파견/겸직소속'/></th>
			<td><span id="dispatchOrgNm"></span></td>
		</tr>
		<tr style="display:none">
			<th><tit:txt mid='112957' mdef='해임소속'/></th>
			<td><span id="removeOrgNm"></span></td>
		</tr>
		<tr style="display:none">
			<th><tit:txt mid='113329' mdef='파견업체'/></th>
			<td><span id="base1Nm"></span></td>
		</tr>
		<tr>
			<th><tit:txt mid='113330' mdef='급여유형'/></th>
			<td><span id="payTypeNm"></span></td>
		</tr>
		<tr style="display:none">
			<th><tit:txt mid='111906' mdef='연봉등급'/></th>
			<td><span id="jikgubNm"></span></td>
		</tr>
		<tr style="display:none">
			<th><tit:txt mid='114041' mdef='급여호봉'/></th>
			<td><span id="salClassNm"></span></td>
		</tr>
		<tr style="display:none">
			<th><tit:txt mid='114391' mdef='Pay그룹'/></th>
			<td><span id="payGroupNm"></span></td>
		</tr>
		<tr>
			<th><tit:txt mid='113331' mdef='계약기간'/></th>
			<td>
				<span id="contractSymd"></span> ~
				<span id="contractEymd"></span>
			</td>
		</tr>
		</table>		
				
		<table border="0" cellpadding="0" cellspacing="0" class="table" style="margin-top:10px;">
		<colgroup>
			<col width="20%" />
			<col width="80%" />
		</colgroup>
		<tr style="display:none">
			<th ><tit:txt mid='112601' mdef='입사시연봉(만원)1111'/></th>
			<td>
				<span id="enterPayNm"></span>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='114392' mdef='발령사유'/></th>
			<td>
				<span id="ordReasonNm"></span>
			</td>
		</tr>
		<tr style="display:none">
			<th><tit:txt mid='112956' mdef='퇴직사유'/></th>
			<td>
				<span id="resignReasonNm"></span>
			</td>
		</tr>
		<tr style="display:none">
			<th><tit:txt mid='111907' mdef='퇴직후진로'/></th>
			<td>
				<span id="retPathNm"></span>
			</td>
		</tr>
		<tr id="hdnMemo" style="display:none;">
			<th><tit:txt mid='103783' mdef='비고'/></th>
			<td><span id="memo"></span></td>
		</tr>
		</table>
		
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



