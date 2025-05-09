<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head> <title>대출상환신청 세부내역</title>
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

		//----------------------------------------------------------------
		
		// 신청, 임시저장
		if(authPg == "A") {

			$("#repYmd").datepicker2({
				onReturn:function(){
					doAction("IntMon");
				}
			});
			
			$("#repYmd").change(function() {doAction("IntMon");});

			//대출구분 콤보
			var param = "searchApplSabun="+$("#searchApplSabun").val();
			var selectLoanList = convCodeCols(ajaxCall("${ctx}/LoanRepApp.do?cmd=getLoanRepAppDetLoanInfo", param, false).DATA
						        , "loanCd,intRate,applySdate,repMon,loanMon,applSeq,loanEndYmd"
						        , "");
		
			$("#selectLoan").html(selectLoanList[2]);

			$("#selectLoan").change(function() {
				var obj = $("#selectLoan option:selected");
				$("#apApplSeq").val(obj.attr("applSeq"));
				$("#span_loanMon").html(makeComma(obj.attr("loanMon"))+" 원" );
				$("#span_repMon").html(makeComma(obj.attr("repMon"))+" 원" );
				$("#repMon").val(obj.attr("repMon"));
				$("#intRate").val(obj.attr("intRate"));
				$("#applySdate").val(obj.attr("applySdate"));
				$("#loanCd").val(obj.attr("loanCd"));
				$("#loanEndYmd").val(obj.attr("loanEndYmd"));
			}); 
			$("#selectLoan").change();

			
		} else if (authPg == "R") {
		}

		doAction("Search");
	});
	
	
	// Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search":
			// 입력 폼 값 셋팅
			var data = ajaxCall( "${ctx}/LoanRepApp.do?cmd=getLoanRepAppDetMap", $("#searchForm").serialize(),false);

			if ( data != null && data.DATA != null ){ 
				$("#selectLoan").val(data.DATA.selectLoan);
				if(authPg == "A") {
					$("#selectLoan").change();
					
				}else if(authPg == "R") {

					$("#selectLoan").html("<option value='"+data.DATA.selectLoan+"'>"+data.DATA.selectLoanNm+"</option>");
					
					$("#loanCd").val(data.DATA.loanCd);
					$("#span_loanMon").html(makeComma(data.DATA.loanMon)+" 원" );
					$("#span_repMon").html(makeComma(data.DATA.repMon)+" 원" );
					$("#repMon").val(data.DATA.repMon);
					$("#intRate").val(data.DATA.intRate);
					$("#applySdate").val(data.DATA.applySdate);
				}

				$("#apApplSeq").val(data.DATA.apApplSeq);
				$("#repYmd").val(formatDate(data.DATA.repYmd, "-")); 
				$("#span_intMon").html(makeComma(data.DATA.intMon)+" 원");
				if(data.DATA.intMon == "0") {
					$("#span_intMon").html("0 원");
				}
				$("#intMon").val(data.DATA.intMon);
				$("#span_totMon").html(makeComma(data.DATA.totMon)+" 원");
				$("#applyDay").val(data.DATA.applyDay);
				$("#span_applyDay").html(data.DATA.applyDay+" 일");
				
				$("#note").val(data.DATA.note); 
				
			}

			break;
		case "IntMon":
			var repYmd = replaceAll($("#repYmd").val(), "-", "");
			var loanYmd = $("#selectLoan option:selected").attr("loanYmd");
			var loanEndYmd = $("#loanEndYmd").val();
			
			if( loanYmd == "" ) return;
			
			if( repYmd == "" || repYmd.length != 8 ) return;
			
			if( repYmd >= loanYmd ){
				alert("상환일자는 대출일 이후로 입력 해주세요.");
				$("#repYmd").val("");
				return;
			}
			
			var data = ajaxCall( "${ctx}/LoanRepApp.do?cmd=getLoanRepAppDetIntMon", $("#searchForm").serialize(),false);
			if ( data != null && data.DATA != null ){
				$("#span_intMon").html(makeComma(data.DATA.intMon)+" 원");
				if(data.DATA.intMon == "0") {
					$("#span_intMon").html("0 원");
				}
				$("#intMon").val(data.DATA.intMon);
				$("#span_totMon").html(makeComma(data.DATA.totMon)+" 원");
				$("#span_applyDay").html(data.DATA.applyDay+" 일" );
				$("#applyDay").val(data.DATA.applyDay);
			}else{
				alert("이자 계산 시 오류가 발생 했습니다. 입력 정보를 확인 해주세요.");
				$("#repYmd").val("");
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
			
			
			//중복체크 확인
			var map = ajaxCall( "${ctx}/LoanRepApp.do?cmd=getLoanRepAppDetDupChk",$("#searchForm").serialize(),false);
			if ( map != null && map.DATA != null ){ 
				if( map.DATA.cnt != "0"   ){
					alert("동일한 신청 건이 있어 신청 할 수 없습니다.");
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
			
			if ( authPg == "R" )  {
				return true;
			}
			
	        // 항목 체크 리스트
	        if ( !checkList() ) {
	            return false;
	        }
	        
	        doAction("IntMon"); //이자계산
	        
	      	//저장
			var data = ajaxCall("${ctx}/LoanRepApp.do?cmd=saveLoanRepAppDet",$("#searchForm").serialize(),false);

            if(data.Result.Code < 1) {
                alert(data.Result.Message);
				returnValue = false;
            }else{
				returnValue = true;
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
span { letter-spacing:0 !important; padding-left:5px;}
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
	
	<input type="hidden" id="apApplSeq"			name="apApplSeq"	 		 value=""/>
	<input type="hidden" id="loanCd"			name="loanCd"	 		 value=""/>
	<input type="hidden" id="intRate"			name="intRate"	 		 value=""/>
	<input type="hidden" id="intMon"			name="intMon"	 		 value=""/>
	<input type="hidden" id="repMon"			name="repMon"	     	 value=""/>
	<input type="hidden" id="applySdate"		name="applySdate"	     value=""/>
	<input type="hidden" id="applyDay"			name="applyDay"	     value=""/>
	<input type="hidden" id="loanEndYmd"		name="loanEndYmd"	     value=""/>
	
	<div class="sheet_title">
		<ul>
			<li class="txt">신청내용</li>
		</ul>
	</div>
	<table class="table">
		<colgroup>
			<col width="120px" />
			<col width="25%" />
			<col width="120px" />
			<col width="" />
		</colgroup>
	
		<tr>
			<th>대출구분</th>
			<td>
				<select id="selectLoan" name="selectLoan" class="${selectCss} ${required} " ${disabled}></select>
			</td>
			<th>대출금액</th>
			<td>
				<span id="span_loanMon">&nbsp;</span>
			</td>
		</tr>	
		<tr>
			<th>상환금액(잔액)</th>
			<td>
				<span id="span_repMon">&nbsp;</span>
			</td>
			<th>상환일자</th>
			<td>
				<input type="text" id="repYmd" name="repYmd" class="${textCss} ${required} w80" ${readonly} />
			</td>
		</tr>	
		<tr>
			<th>이자금액</th>
			<td>
				<span id="span_intMon">&nbsp;</span>
			</td>
			<th>적용일수</th>
			<td>
				<span id="span_applyDay">&nbsp;</span>
			</td>
		</tr>
		<tr>
			<th>계</th>
			<td colspan="3">
				<span id="span_totMon">&nbsp;</span>
			</td>
		</tr>
		<tr>
			<th>비고</th>
			<td colspan="3"><textarea id="note" name="note" rows="3" class="${textCss} w100p" ${readonly}  maxlength="1000"></textarea></td>
		</tr>
		</table>
	</form>
</div>
		
</body>
</html>