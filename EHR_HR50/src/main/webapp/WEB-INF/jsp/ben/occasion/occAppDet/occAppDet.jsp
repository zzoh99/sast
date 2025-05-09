<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head> <title>경조신청 세부내역</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

var searchApplSeq    = "${searchApplSeq}";
var adminYn          = "${adminYn}";
var authPg           = "${authPg}";
var searchApplSabun  = "${searchApplSabun}";
var searchApplInSabun= "${searchApplInSabun}";
var searchApplYmd    = "${searchApplYmd}";
var applStatusCd	 = "";
var applYn	         = "";
var pGubun           = "";
var gPRow = "";
var adminRecevYn     = "N"; //수신자 여부
var user;

	$(function() {
		
		parent.iframeOnLoad(220);

		//----------------------------------------------------------------
		$("#searchApplSeq").val(searchApplSeq);
		$("#searchApplSabun").val(searchApplSabun);
		$("#searchApplYmd").val(searchApplYmd);

		applStatusCd = parent.$("#applStatusCd").val();
		applYn = parent.$("#applYn").val(); // 현 결재자와 세션사번이 같은지 여부

		if(applStatusCd == "") {
			applStatusCd = "11";
		}

		if( ( adminYn == "Y" ) || ( applStatusCd == "31"  && applYn == "Y" ) ){ //담당자거나 수신결재자이면
			
			if( applStatusCd == "31") { //수신처리중일 때만 지급정보 수정 가능
				$("#payYmd").removeClass("transparent").removeAttr("readonly");
				$("#payNote").removeClass("transparent").removeAttr("readonly");
				$("#payYmd").datepicker2();
			}

			adminRecevYn = "Y";
			$(".payInfo").show();
			parent.iframeOnLoad(300);
		}
		
		//----------------------------------------------------------------
		
		
		//은행코드 콤보
		var bankCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H30001"), "선택");//은행코드(H30001)
		$("#bankCd").html(bankCdList[2]);
		
		//계좌구분코드 콤보
		var accTypeCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00180"), "");//계좌구분코드(C00180)
		$("#accTypeCd").html(accTypeCdList[2]);
		
		// 신청, 임시저장
		if(authPg == "A") {
			
			//경조구분 콤보
			var param = "&searchApplSabun="+searchApplSabun+"&searchApplYmd="+searchApplYmd+"&useYn=Y";
			var occCdList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getOccAppDetOccCdList"+param, false).codeList, " ");
			$("#occCd").html(occCdList[2]);
			
			//신청자정보 조회
			user = ajaxCall( "${ctx}/OccApp.do?cmd=getOccAppDetUseInfo", $("#searchForm").serialize(),false);
			if ( user != null && user.DATA != null ){ 
				$("#searchApplName").val(user.DATA.applName);
				$("#phoneNo").val(user.DATA.phoneNo);
				
				// 급여계좌 정보 등록되어 있는 경우
				if( user.DATA.accNm != null && user.DATA.accNm != ""
					&& user.DATA.accNo != null && user.DATA.accNo != ""
						&& user.DATA.bankCd != null && user.DATA.bankCd != "" ) {
					$("#accNm").val(user.DATA.accNm);
					$("#accNo").val(user.DATA.accNo);
					$("#bankCd").val(user.DATA.bankCd);
					$("#accTypeCd").val(user.DATA.accountType);
				} else {
					// 급여계좌 정보가 불분명한 경우 기타계좌로 선택.
					$("#accTypeCd").val("03");
				}
				
				$("#workMonth").val(user.DATA.workMonth); //근속개월수
				//$("#span_tmp").html(user.DATA.workMonth); //근속개월수
			}
		
			$("#occYmd").datepicker2();

			$("#famCd").change(function() {
				var obj = $("#famCd option:selected");
				var myWorkMonth = parseInt($("#workMonth").val());
				var workMonth = parseInt(obj.attr("workMonth"));
				
				if( myWorkMonth < workMonth ){
					var str = "";
					if( workMonth > 12 ){
						var iyear = workMonth/12;
						var imon = workMonth%12;
						if( iyear > 0 ) str += iyear + "년";
						if( imon > 0 ) str += imon + "개월";
					} else{
						str = workMonth + "개월";
					}
					
					alert("근속년수 "+str+" 이상부터 신청 가능합니다."); 

					$("#famCd").html("");
					$("#occMon").val("");
					$("#occMon_won").html("");
					$("#occHoliday").val("");
					$("#occHoliday_day").html("");
	
					$("#wreathYn").val("");
					$("#outfitYn").val("");
					$("#giftYn").val("");
					$("#flowerBasketYn").val("");
					$("#span_wreathYn").hide();
					$("#span_outfitYn").hide();
					$("#span_giftYn").hide();
					$("#span_flowerBasketYn").hide();
					
					$("#evidenceDocTxt").html("");
				}else{
					
					if($("#famCd").val() == "10"){ //본인
						$("#famNm").val( $("#searchApplName").val());
					}else{
						$("#famNm").val("");
					}
					
					$("#occMon").val(makeComma( obj.attr("occMon") ));
					$("#occMon_won").html( ( $("#occMon").val() == "")?"":"원");
					$("#occHoliday").val(obj.attr("occHoliday") );
					$("#occHoliday_day").html( ( $("#occHoliday").val() == "")?"":"일");
	
					$("#wreathYn").val(obj.attr("wreathYn") );
					$("#outfitYn").val(obj.attr("outfitYn") );
					$("#giftYn").val(obj.attr("giftYn") );
					$("#flowerBasketYn").val(obj.attr("flowerBasketYn") );
					
					if( obj.attr("wreathYn") == "Y" ) $("#span_wreathYn").show();
					else  $("#span_wreathYn").hide();
					if( obj.attr("outfitYn") == "Y" ) $("#span_outfitYn").show();
					else  $("#span_outfitYn").hide();
					if( obj.attr("giftYn") == "Y" ) $("#span_giftYn").show();
					else  $("#span_giftYn").hide();
					if( obj.attr("flowerBasketYn") == "Y" ) $("#span_flowerBasketYn").show();
					else  $("#span_flowerBasketYn").hide();
					
					$("#evidenceDocTxt").html(obj.attr("evidenceDoc"));
				}
			}); 

			$("#occCd").change(function() {
				var param = "&occCd="+$("#occCd").val(); 
				param += "&searchApplSabun="+$("#searchApplSabun").val(); 
				//가족대상 콤보 및 경조기준정보 가져오기
				var famCdList = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getOccAppDetFamCdList&useYn=Y"+param, false).codeList
				        , "occMon,occHoliday,workMonth,wreathYn,outfitYn,giftYn,flowerBasketYn,evidenceDoc"
				        , "");
				$("#famCd").html(famCdList[2]).change();
			});
			
		} else if (authPg == "R") {
			//경조구분 콤보
			var occCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","B60020"), " ");
			$("#occCd").html(occCdList[2]);

			//가족구분 (전체)
			var famCdList = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "B60030"), "");
			$("#famCd").html(famCdList[2]);
		}
		
		//계좌구분 선택시 계좌폼 잠금/해제 초기 화면 및 이벤트 등록
		$('#searchForm').on('change', 'select[name="accTypeCd"]',function() {
			// 급여계좌 선택시
			if( $(this).val() == "01" ) {
				// 급여계좌 정보가 등록되어 있지 않은 경우 기타계좌 선택처리함.
				if(    user.DATA.accNm  == null || user.DATA.accNm == ""
					|| user.DATA.accNo  == null || user.DATA.accNo == ""
					|| user.DATA.bankCd == null || user.DATA.bankCd == ""
				) {
					if(authPg == "A") {
						alert("급여계좌 정보가 등록되어 있지 않습니다.");
					}
					$("#accTypeCd").val("03");
				}
			}
			
			$("#accNm").val("");
			$("#accNo").val("");
			$("#bankCd").val("");
			checkAccTypeCd();
		});

		doAction("Search");
		checkAccTypeCd();
	});
	
	// Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search":
			// 입력 폼 값 셋팅
			var data = ajaxCall( "${ctx}/OccApp.do?cmd=getOccAppDetMap", $("#searchForm").serialize(),false);

			if ( data != null && data.DATA != null ){ 
				$("#occCd").val(data.DATA.occCd);

				if(authPg == "A") {
					$("#occCd").change();
				}
				$("#famCd").val(data.DATA.famCd);
				$("#famNm").val(data.DATA.famNm);
				$("#occYmd").val(formatDate(data.DATA.occYmd, "-"));
				$("#occMon").val(makeComma(data.DATA.occMon));
				$("#occMon_won").html( ( $("#occMon").val() == "")?"":"원");
				$("#occHoliday").val(data.DATA.occHoliday);
				$("#occHoliday_day").html( ( $("#occHoliday").val() == "")?"":"일");
				
				$("#phoneNo").val(data.DATA.phoneNo);
				$("#addr").val(data.DATA.addr);

				$("#bankCd").val(data.DATA.bankCd);
				$("#accNo").val(data.DATA.accNo);
				$("#accNm").val(data.DATA.accNm);
				$("#accTypeCd").val(data.DATA.accTypeCd);

				$("#wreathYn").val(data.DATA.wreathYn );
				$("#outfitYn").val(data.DATA.outfitYn );
				$("#giftYn").val(data.DATA.giftYn );
				$("#flowerBasketYn").val(data.DATA.flowerBasketYn );
				if( data.DATA.wreathYn == "Y" ) $("#span_wreathYn").show();
				else  $("#span_wreathYn").hide();
				if( data.DATA.outfitYn == "Y" ) $("#span_outfitYn").show();
				else  $("#span_outfitYn").hide();
				if( data.DATA.giftYn == "Y" ) $("#span_giftYn").show();
				else  $("#span_giftYn").hide();
				if( data.DATA.flowerBasketYn == "Y" ) $("#span_flowerBasketYn").show();
				else  $("#span_flowerBasketYn").hide();

				$("#note").val(data.DATA.note);
				
				$("#evidenceDocTxt").html(data.DATA.evidenceDoc);

				if( adminRecevYn == "Y" ){
					$("#payYmd").val(formatDate(data.DATA.payYmd, "-"));
					$("#payNote").val(data.DATA.payNote);
				}
				
				if(authPg != "A") {
					convertReadModeForAppDet($("#searchForm"));
				}
			}

			break;
		}
	}
	
	function checkAccTypeCd() {
		var selected = $("select[name=accTypeCd] option:selected").val();
		if (selected == '01') {
			$('#bankCd').attr("disabled",true);
			$('#accNm').attr('readonly',true);
			$('#accNo').attr('readonly',true);
			if(user != null && user != undefined && user.DATA != null && user.DATA != undefined) {
				$("#accNm").val(user.DATA.accNm);
				$("#accNo").val(user.DATA.accNo);
				$("#bankCd").val(user.DATA.bankCd);
			}
		} else {
			$('#bankCd').attr("disabled",false);
			$('#accNm').attr('readonly',false);
			$('#accNo').attr('readonly',false);
			
		}
	}

	//--------------------------------------------------------------------------------
	//  저장 시 필수 입력 및 조건 체크
	//--------------------------------------------------------------------------------
	function checkList(status) {
		var ch = true;

		// 화면의 개별 입력 부분 필수값 체크
		$(".required").each(function(index){
			if($(this).val() == null || $(this).val() == ""){
				alert($(this).parent().prev().text()+"<msg:txt mid='required2' mdef='은(는) 필수값입니다.' />");
				$(this).focus();
				ch =  false;
				return false;
			}

			return ch;
		});
		
		if( ch ){
			/*
			var today = "${curSysYyyyMMdd}";
			var occYmd = $("#occYmd").val().replace(/-/gi, "");
			var dayBetween = getDaysBetween(today , occYmd ) - 1 ;
			if(dayBetween < -90 || dayBetween > 90 ){
				alert("경조일 전후 90일 이내에 신청 가능합니다.");
				ch =  false;
				return false;
				
			}*/
			//중복체크 확인
			var map = ajaxCall( "${ctx}/OccApp.do?cmd=getOccAppDupChk",$("#searchForm").serialize(),false);
			if ( map != null && map.DATA != null ){
				if( map.DATA.cnt != "0" ){
					alert("<msg:txt mid='appDupErrMsg' mdef='동일한 신청 건이 있어 신청 할 수 없습니다.'/>")
					ch =  false;
					return false;
				}

			}
		}
		

		return ch;
	}

	//--------------------------------------------------------------------------------
	//  임시저장 및 신청 시 호출
	//--------------------------------------------------------------------------------
	function setValue(status) {
		var returnValue = false;

		try {
			//관리자 수신담당자 경우 지급정보 저장
			if( adminRecevYn == "Y" ){

				//전송 전 잠근 계좌선택 풀기
				$('#bankCd').attr("disabled",false);
				
				var rtn = ajaxCall("${ctx}/OccApp.do?cmd=saveOccAppDetAdmin", $("#searchForm").serialize(), false);
				checkAccTypeCd();

				if(rtn.Result.Code < 1) {
					alert(rtn.Result.Message);
					returnValue = false;
				} else {
					returnValue = true;
				}
				
			}else{
			
				if ( authPg == "R" )  {
					return true;
				}
				
				// 항목 체크 리스트
				if ( !checkList() ) {
					return false;
				}
		
				//전송 전 잠근 계좌선택 풀기
				$('#bankCd').attr("disabled",false);
	
				//저장
				var data = ajaxCall("${ctx}/OccApp.do?cmd=saveOccAppDet",$("#searchForm").serialize(),false);
				checkAccTypeCd();
	
				if(data.Result.Code < 1) {
					alert(data.Result.Message);
					returnValue = false;
				}else{
					returnValue = true;
				}
				
			}

		} catch (ex){
			alert("Error!" + ex);
			checkAccTypeCd();
			returnValue = false;
		}

		return returnValue;
	}
	
</script>

<style type="text/css">

/*---- checkbox ----*/
input[type="checkbox"]  { 
	display:inline-block; width:20px; height:20px; cursor:pointer; appearance:none; 
 	-moz-appearance:checkbox; -webkit-appearance:checkbox; margin-top:2px;background:none;
    border: 5px solid red;
}
label {
	vertical-align:-2px;padding-right:10px;
}

.payInfo { display:none; }
.payInfo th {background-color:#f4f4f4 !important; }
</style>
</head>
<body class="bodywrap">
<div class="wrapper">

	<form name="searchForm" id="searchForm" method="post">
	<input type="hidden" id="searchApplSabun"	name="searchApplSabun"	 value=""/>
	<input type="hidden" id="searchApplName"	name="searchApplName"	 value=""/>
	<input type="hidden" id="searchApplSeq"		name="searchApplSeq"	 value=""/>
	<input type="hidden" id="searchApplYmd"		name="searchApplYmd"	 value=""/>
	<input type="hidden" id="searchAuthPg"		name="searchAuthPg"	     value=""/>
	
	<input type="hidden" id="workMonth"			name="workMonth"		 value=""/>
	<input type="hidden" id="wreathYn"			name="wreathYn"		     value=""/>
	<input type="hidden" id="outfitYn"			name="outfitYn"		     value=""/>
	<input type="hidden" id="giftYn"			name="giftYn"		     value=""/>
	<input type="hidden" id="flowerBasketYn"	name="flowerBasketYn"	 value=""/>
	
	<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='appTitle' mdef='신청내용'/></li>
		</ul>
	</div>
	<table class="table">
		<colgroup>
			<col width="15%" />
			<col width="35%" />
			<col width="15%" />
			<col width="35%" />
		</colgroup>
	
		<tr>
			<th><tit:txt mid='occCd' mdef='경조구분'/></th>
			<td>
				<select id="occCd" name="occCd" class="${selectCss} ${required} " ${disabled}></select>
			</td>
			<th><tit:txt mid='famCdV4' mdef='가족구분'/></th>
			<td>
				<select id="famCd" name="famCd" class="${selectCss} ${required} " ${disabled}></select>
				<span id="span_tmp">&nbsp;</span>
			</td>
		</tr>	
		<tr>
			<th><tit:txt mid='114541' mdef='경조일자'/></th>
			<td>
				<input type="text" id="occYmd" name="occYmd" class="${dateCss} ${required} w80" ${readonly} maxlength="10"/>
			</td>
			<th><tit:txt mid='104395' mdef='대상자명'/></th>
			<td>
				<input type="text" id="famNm" name="famNm" class="${textCss} ${required} w80" ${readonly} maxlength="20"/>
			</td>
		</tr>	
		<tr>
			<th><tit:txt mid='occMon' mdef='경조금'/></th>
			<td class="txt_item">
				<input type="text" id="occMon" name="occMon" class="text transparent w80 with-unit" readonly/><span id="occMon_won"></span>
			</td> 
			<th><tit:txt mid='occHoliday' mdef='휴가일수'/></th>
			<td class="txt_item">
				<input type="text" id="occHoliday" name="occHoliday" class="text transparent w20 with-unit" readonly/><span id="occHoliday_day"></span>
			</td> 
		</tr>
		<tr>
			<th><tit:txt mid='occItem' mdef='지원물품'/></th>
			<td colspan="3" class="txt_item">
				<span id="span_flowerBasketYn" style="display:none;"><label><tit:txt mid='flowerBasketYn' mdef='꽃바구니'/></label></span>
				<span id="span_wreathYn" style="display:none;"><label><tit:txt mid='wreathYnV1' mdef='경조화환'/></label></span>
				<span id="span_outfitYn" style="display:none;"><label><tit:txt mid='outfitYn' mdef='상조물품'/></label></span>
				<span id="span_giftYn" style="display:none;"><label><tit:txt mid='giftYn' mdef='축하선물'/></label></span>
			</td>	
		</tr>
		<tr>
			<th><tit:txt mid='resLocation' mdef='장소(주소)'/></th>
			<td colspan="3">
				<input type="text" id="addr" name="addr" class="${textCss} ${required} w100p" ${readonly}/>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='112985' mdef='전화번호'/></th>
			<td>
				<input type="text" id="phoneNo" name="phoneNo" class="${textCss} ${required} w100" ${readonly} maxlength="30"/>
			</td>
			<th><tit:txt mid='112434' mdef='계좌구분 '/></th>
			<td>
				<select id="accTypeCd" name="accTypeCd" class="${selectCss} ${required} " ${disabled}></select>
			</td>
		</tr>		
		<tr>
			<th><tit:txt mid='114577' mdef='입금은행'/></th>
			<td>
				<select id="bankCd" name="bankCd" class="${selectCss} ${required} " ${disabled}></select>
			</td>
			<th><tit:txt mid='113147' mdef='예금주명'/></th>
			<td>
				<input type="text" id="accNm" name="accNm" class="${textCss} ${required} w80" ${readonly} maxlength="20"/>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='104465' mdef='계좌번호'/></th>
			<td colspan="3">
				<input type="text" id="accNo" name="accNo" class="${textCss} ${required} w200" ${readonly} maxlength="50"/>
			</td>
		</tr>		
		<tr>
			<th><tit:txt mid='103783' mdef='비고' /></th>
			<td colspan="3"><textarea id="note" name="note" rows="3" class="${textCss} w100p" ${readonly}  maxlength="1000"></textarea></td>
		</tr>
		<tr>
			<th><tit:txt mid='evidenceDocTxt' mdef='증빙서류'/></th>
			<td colspan="3" class="txt_item">
				<div id="evidenceDocTxt"></div>
			</td> 
		</tr>
		</table>
		
			
		<div class="sheet_title payInfo">
			<ul>
				<li class="txt"><tit:txt mid='payInfo' mdef='지급정보'/></li>
			</ul>
		</div>
		<table class="table payInfo">
			<colgroup>
				<col width="120px" />
				<col width="25%" />
				<col width="120px" />
				<col width="" />
			</colgroup>
			<tr>
				<th><tit:txt mid='112700' mdef='지급일자'/></th>
				<td><input type="text" id="payYmd" name="payYmd" class="date2 transparent w80" readonly/></td>
				<th><tit:txt mid='payNote' mdef='지급메모'/></th>
				<td><input type="text" id="payNote" name="payNote" class="text transparent w90p" readonly/></td>
			</tr>
		</table>
		
	</form>
</div>
		
</body>
</html>