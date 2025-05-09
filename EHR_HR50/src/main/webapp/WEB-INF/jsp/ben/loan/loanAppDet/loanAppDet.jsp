<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head> <title>대출신청 세부내역</title>
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
		
		parent.iframeOnLoad();

		//----------------------------------------------------------------
		$("#searchApplSeq").val(searchApplSeq);
		$("#searchApplSabun").val(searchApplSabun);
		$("#searchApplYmd").val(searchApplYmd);

		applStatusCd = parent.$("#applStatusCd").val();
		applYn = parent.$("#applYn").val(); // 현 결재자와 세션사번이 같은지 여부

		if(applStatusCd == "") {
			applStatusCd = "11";
		}
		
		//alert("authPg : " + authPg + ", adminYn : " + adminYn + ", applStatusCd : " + applStatusCd + ", applYn : " + applYn);

		if( ( adminYn == "Y" ) || ( applStatusCd == "31"  && applYn == "Y" ) ){ //담당자거나 수신결재자이면
			
			if( applStatusCd != "99") { 
				$("#loanMon").removeClass("transparent").removeAttr("readonly");
				$("#loanYmd").removeClass("transparent").removeAttr("readonly");
				$("#repMon").removeClass("transparent").removeAttr("readonly");
				$("#payNote").removeClass("transparent").removeAttr("readonly");
				$("#loanYmd").datepicker2();
				$("#loanMon").mask("000,000,000,000,000", {reverse: true});
				$("#repMon").mask("000,000,000,000,000", {reverse: true});
				
				$("#loanPeriod").removeClass("transparent").removeAttr("readonly");
				$("#intRate").removeClass("transparent").removeAttr("readonly");

				
				//대출확정금액 변경 시 월상환액 조회
				$("#loanMon").on("change", function(event) {
					var info = ajaxCall( "${ctx}/LoanApp.do?cmd=getLoanAppDetMon", $("#searchForm").serialize(),false);
					var mon  = 0;
					if ( info != null && info.DATA != null ){
						mon  = info.DATA.mon;
						if( mon > 0 ) mon = makeComma(mon);
						$("#repMon").val(mon);
					}
				});
			
			}

			adminRecevYn = "Y";
		}
		
		//----------------------------------------------------------------
		
		//은행코드 콤보
		var bankCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H30001"), "선택");//은행코드(H30001)
		$("#bankCd").html(bankCdList[2]);
		
		// 신청, 임시저장
		if(authPg == "A") {

			//신청자정보 조회
			var user = ajaxCall( "${ctx}/LoanApp.do?cmd=getLoanAppDetUseInfo", $("#searchForm").serialize(),false);
			if ( user != null && user.DATA != null ){ 
				$("#accHolder").val(user.DATA.accHolder);
				$("#accNo").val(user.DATA.accNo);
				$("#bankCd").val(user.DATA.bankCd);
			}
			
			// 대출희망일 datepicker 설정
			$("#inputLoanReqYmd").datepicker2({
				onReturn:function(date){
					$("#loanCd").html("");
					if(date != null && date != "") {
						initLoadCdCombo(date);
					}
				}
			});
			$("#inputLoanReqYmd").change(function(){
				$("#loanCd").html("");
				var date = $(this).val();
				if(date != null && date != "") {
					initLoadCdCombo(date);
				}
			});

			/* 20201013 무신사 대출 신청 방식 변경
			//대출구분 콤보
			var param = "&searchApplSabun="+$("#searchApplSabun").val();
			var loanCdList = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getLoanAppDetLoanCd"+param, false).codeList
			        , "loanOrgNm,loanLmtMon,loanPeriod,loanDoc,loanNote,intRate,loanReqYmd"
			        , "");
			$("#loanCd").html(loanCdList[2]);
			*/

			$("#loanCd").change(function() {
				var obj = $("#loanCd option:selected");
				$("#span_loanOrgNm").html(obj.attr("loanOrgNm") ); //대출처
				if(obj.attr("loanLmtMon") == "0" || obj.attr("loanLmtMon") == "-1") {
					$("#span_loanLmtMon").html("0원" );
				} else {
					$("#span_loanLmtMon").html(makeComma(obj.attr("loanLmtMon"))+"원" );
				}
				$("#span_loanPeriod").html(obj.attr("loanPeriod") +"개월");
				$("#span_loanDoc").html(replaceAll(obj.attr("loanDoc"), "\n","<br>") );
				$("#span_loanNote").html(replaceAll(obj.attr("loanNote"), "\n","<br>")  );
				$("#span_intRate").html(obj.attr("intRate")+" %" );
				
				// 2020.10.13 무신사 추가
				$("#span_workMonthByReqYmd").html(obj.attr("empWorkMonth") +"개월(대출희망일기준)"); // 근속개월
				$("#reqIntRate").val(obj.attr("intRate"));
				$("#loanReqPeriod").val(obj.attr("loanPeriod") );
				
				/* 20201013 무신사 대출 신청 방식 변경
				$("#intRate").val(obj.attr("intRate"));
				$("#loanReqYmd").val(obj.attr("loanReqYmd"));
				$("#span_loanReqYmd").html(formatDate(obj.attr("loanReqYmd"),"-"));
				$("#loanPeriod").val(obj.attr("loanPeriod") );
				*/
				
				if( obj.attr("stdMonth") == "0" ) {
					alert("대출희망일기준 근속개월 " + obj.attr("minWorkMonth") + "개월 이상부터 신청 가능합니다.");
				} else if( obj.attr("chaMon") == "0" ) {
					alert("현재 대출한도 산정을 위한 계산 완료된 퇴직월급여 내역이 없습니다.\n자세한 내용은 담당자에 문의하시기 바랍니다.");
				}
				
				if($("#span_loanNote").height() > 20) {
					parent.iframeOnLoad($("body").height() + 18);
				} else {
					parent.iframeOnLoad();
				}
				
			});
			//$("#loanCd").change();

			$("#loanReqMon").mask("000,000,000,000,000", {reverse: true});
			
		} else if (authPg == "R") {
			//대출구분
			var loanCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","B50010"), " ");
			$("#loanCd").html(loanCdList[2]);
		}

		doAction("Search");
	});
	
	// Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search":
			// 입력 폼 값 셋팅
			var data = ajaxCall( "${ctx}/LoanApp.do?cmd=getLoanAppDetMap", $("#searchForm").serialize(),false);

			if ( data != null && data.DATA != null ){ 
				if(authPg == "A") {
					if( data.DATA.loanReqYmd != null && data.DATA.loanReqYmd != undefined ) {
						$("#loanReqYmd").val(data.DATA.loanReqYmd); //대출희망일
						$("#inputLoanReqYmd").val(formatDate(data.DATA.loanReqYmd,"-")); //대출희망일
						
						// 대출구분 콤보 생성
						initLoadCdCombo(data.DATA.loanReqYmd);
						$("#loanCd").val(data.DATA.loanCd);
						$("#loanCd").change();
					}
				}else if(authPg == "R") {
					$("#loanCd").val(data.DATA.loanCd);
					$("#span_loanOrgNm").html(data.DATA.loanOrgNm ); //대출처
					
					//대출한도
					if(data.DATA.loanLmtMon == 0) {
						$("#span_loanLmtMon").html("0원" );
					} else {
						$("#span_loanLmtMon").html(makeComma(data.DATA.loanLmtMon)+"원" );
					}
					
					$("#span_loanPeriod").html(data.DATA.stdLoanPeriod +"개월"); //최대상환기간
					$("#span_loanDoc").html(replaceAll(data.DATA.loanDoc, "\n","<br>") ); //제출서류
					$("#span_loanNote").html(replaceAll(data.DATA.loanNote, "\n","<br>") ); //유의사항

					$("#span_intRate").html(data.DATA.reqIntRate+" %" );
					$("#intRate").val(data.DATA.intRate); //이율
					$("#loanReqYmd").val(data.DATA.loanReqYmd); //대출희망일
					$("#span_loanReqYmd").html(formatDate(data.DATA.loanReqYmd,"-"));
					$("#inputLoanReqYmd").hide();
					
					$("#span_workMonthByReqYmd").html(data.DATA.workMonth +"개월(대출희망일기준)"); // 근속개월
				}
				
				$("#loanReqPeriod").val(data.DATA.loanReqPeriod); //신청상환기간
				$("#loanReqMon").val(makeComma(data.DATA.loanReqMon)); //대출신청금액

				$("#bankCd").val(data.DATA.bankCd); //입금은행
				$("#accHolder").val(data.DATA.accHolder); //예금주
				$("#accNo").val(data.DATA.accNo); //계좌번호
				
				$("#note").val(data.DATA.note); 
				
				if( adminRecevYn == "Y" || applStatusCd == "99" ){
					$("#loanYmd").val(formatDate(data.DATA.loanYmd, "-")); //대출시작일(지급일)
					$("#loanPeriod").val(makeComma(data.DATA.loanPeriod)); //확정상환기간
					$("#intRate").val(makeComma(data.DATA.intRate)); //확정이자
					$("#loanMon").val(makeComma(data.DATA.loanMon)); //대출확정금액
					$("#repMon").val(makeComma(data.DATA.repMon)); //월상환액

					$("#loanMon_unit").html( ( data.DATA.loanMon == "")?"":"원");
					$("#repMon_unit").html( ( data.DATA.repMon == "")?"":"원");
					$("#loanPeriod_unit").html( ( data.DATA.loanPeriod == "")?"":"개월");
					$("#intRate_unit").html( ( data.DATA.intRate == "")?"":"%");
					
					if( $("#loanYmd").val() == ""){
						$("#loanYmd").val(formatDate(data.DATA.loanReqYmd, "-"));
					}
					if( $("#loanPeriod").val() == ""){
						$("#loanPeriod").val(data.DATA.loanReqPeriod);
					}
					if( $("#intRate").val() == ""){
						$("#intRate").val(data.DATA.reqIntRate);
					}
					if( $("#loanMon").val() == ""){
						$("#loanMon").val(makeComma(data.DATA.loanReqMon));
					}
					if( $("#repMon").val() == ""){
						$("#loanMon").change();
					}
				}
				
				if(authPg != "A") {
					convertReadModeForAppDet($(".reqInfo"));
				}

				$("#loanReqMon").mask("000,000,000,000,000", {reverse: true});
				
				if($("#span_loanNote").height() > 20) {
					parent.iframeOnLoad($("body").height() + 18);
				} else {
					parent.iframeOnLoad();
				}
			}

			break;
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
			
			if( parseInt(replaceAll($("#loanReqMon").val(), ",","")) > parseInt(replaceAll($("#span_loanLmtMon").html(), ",","") )){
				alert("대출신청금액은 대출한도 "+$("#span_loanLmtMon").html()+"을 넘길 수 없습니다.");
				ch =  false;
				return false;
			}  

			
			if( parseInt($("#loanReqPeriod").val()) > parseInt(replaceAll($("#span_loanPeriod").html(), "개월","") )){
				alert("상환기간은 최대상환기간 "+$("#span_loanPeriod").html()+"을 넘길 수 없습니다.");
				ch =  false;
				return false;
			}  
			
			//중복체크 확인
			var map = ajaxCall( "${ctx}/LoanApp.do?cmd=getLoanAppDetDupChk",$("#searchForm").serialize(),false);
			if ( map != null && map.DATA != null ){ 
				if( map.DATA.loanRemMon != "0"   ){
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

				var rtn = ajaxCall("${ctx}/LoanApp.do?cmd=saveLoanAppDetAdmin", $("#searchForm").serialize(), false);

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
		        
		      	//저장
				var data = ajaxCall("${ctx}/LoanApp.do?cmd=saveLoanAppDet",$("#searchForm").serialize(),false);
	
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
	
	// 대출구분 콤보 셋팅
	function initLoadCdCombo(date) {
		var loanReqYmd = date.replace(/-/g, '');
		//대출구분 콤보
		var param = "";
		param += "&searchApplSabun="+$("#searchApplSabun").val();
		param += "&loanReqYmd=" + loanReqYmd;
		
		$("#loanReqYmd").val(loanReqYmd);
		
		var loanCdList = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getLoanAppDetLoanCd"+param, false).codeList
		        , "loanOrgNm, loanLmtMon, loanDoc, loanNote, empWorkMonth, workMonth, loanLmtRate, intRate, loanPeriod, minWorkMonth, stdMonth, chaMon"
		        , "");
		$("#loanCd").html(loanCdList[2]);
		$("#loanCd").change();
	}
</script>

<style type="text/css">
.payInfo {margin-top:10px;}
.payInfo th {background-color:#FDF0F5 !important; }
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
	
	<input type="hidden" id="loanReqYmd"		name="loanReqYmd"	 	 value=""/>
	<input type="hidden" id="reqIntRate"		name="reqIntRate"	 	 value=""/>
	
	
	<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='appTitle' mdef='신청내용'/></li>
		</ul>
	</div>
	<table class="table reqInfo">
		<colgroup>
			<col width="120px" />
			<col width="30%" />
			<col width="120px" />
			<col width="" />
		</colgroup>
		
		<tr>
			<th><tit:txt mid='loanReqYmd' mdef='대출희망일'/></th>
			<td>
				<input type="text" id="inputLoanReqYmd" name="inputLoanReqYmd" class="${textCss} ${required} date2" ${readonly} />
				<span id="span_loanReqYmd">&nbsp;</span>
			</td> 
			<th><tit:txt mid='workMonthByReqYmd' mdef='근속개월'/></th>
			<td>
				<span id="span_workMonthByReqYmd">&nbsp;</span>
			</td> 
		</tr>
	
		<tr>
			<th><tit:txt mid='loanCdV2' mdef='대출구분'/></th>
			<td>
				<select id="loanCd" name="loanCd" class="${selectCss} ${required} " ${disabled}></select>
			</td>
			<th><tit:txt mid='loanOrgNm' mdef='대출처'/></th>
			<td>
				<span id="span_loanOrgNm">&nbsp;</span>
			</td>
		</tr>	
		<tr>
			<th><tit:txt mid='loanLmtMon' mdef='대출한도'/></th>
			<td>
				<span id="span_loanLmtMon">&nbsp;</span>
			</td>
			<th><tit:txt mid='loanPeriod' mdef='최대상환기간'/></th>
			<td>
				<span id="span_loanPeriod">&nbsp;</span>
			</td>
		</tr>	
		<tr>
			<th><tit:txt mid='loanDoc' mdef='제출서류'/></th>
			<td colspan="3">
				<span id="span_loanDoc">&nbsp;</span>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='psnlWorkScheduleMgr2' mdef='유의사항'/></th>
			<td colspan="3">
				<span id="span_loanNote">&nbsp;</span>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='loanReqPeriod' mdef='상환기간'/></th>
			<td>
				<input type="text" id="loanReqPeriod" name="loanReqPeriod" class="${textCss} ${required} w20 " ${readonly} maxlength="2"/>&nbsp;개월
			</td> 
			<th><tit:txt mid='intRate' mdef='이율'/></th>
			<td>
				<span id="span_intRate">&nbsp;</span>
			</td> 
		</tr>
		<tr>
			<th><tit:txt mid='loanReqMon' mdef='대출신청금액'/></th>
			<td colspan="3">
				<input type="text" id="loanReqMon" name="loanReqMon" class="${textCss} ${required} w80 " ${readonly} maxlength="20"/>&nbsp;원
			</td> 
		</tr>		
		<tr>
			<th><tit:txt mid='bankCd' mdef='입금은행'/></th>
			<td>
				<select id="bankCd" name="bankCd" class="${selectCss} ${required} " ${disabled}></select>
			</td>
			<th><tit:txt mid='113147' mdef='예금주'/></th>
			<td>
				<input type="text" id="accHolder" name="accHolder" class="${textCss} ${required} w80" ${readonly} maxlength="20"/>
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
		</table>
		
		<table class="table payInfo">
			<colgroup>
				<col width="120px" />
				<col width="150px" />
				<col width="120px" />
				<col width="150px" />
				<col width="120px" />
				<col width="" />
			</colgroup>
			<tr>
				<th><tit:txt mid='loanYmd' mdef='대출시작일(지급일)'/></th>
				<td>
					<input type="text" id="loanYmd" name="loanYmd" class="date2 transparent w80" readonly/>
				</td>
				<th><tit:txt mid='loanPeriodV1' mdef='확정상환기간'/></th>
				<td>
					<input type="text" id="loanPeriod" name="loanPeriod" class="text transparent w30 " readonly/>&nbsp;<span id="loanPeriod_unit"></span>
				</td> 
				<th><tit:txt mid='intRateV1' mdef='확정이자율'/></th>
				<td>
					<input type="text" id="intRate" name="intRate" class="text transparent w20 " readonly/>&nbsp;<span id="intRate_unit"></span>
				</td> 
			</tr>
			<tr>
				<th><tit:txt mid='loanMon' mdef='대출확정금액'/></th>
				<td>
					<input type="text" id="loanMon" name="loanMon" class="text transparent w80 " readonly/>&nbsp;<span id="loanMon_unit"></span>
				</td> 
				<th><tit:txt mid='repMon' mdef='월상환액'/></th>
				<td colspan="3">
					<input type="text" id="repMon" name="repMon" class="text transparent w80 " readonly/>&nbsp;<span id="repMon_unit"></span>
				</td> 
			</tr>
		</table>
		
	</form>
</div>
		
</body>
</html>