<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head> <title>개인연금신청 세부내역</title>
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

		//----------------------------------------------------------------
		
		//가입상품
		var pensCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","B65110"), "");
		$("#pensCd").html(pensCdList[2]);

		// 신청, 임시저장
		if(authPg == "A") {
			$("#psnlMon").mask('000,000,000,000,000', { reverse : true });

			$("#psnlMon").change(function() {
				var comMon = parseInt($("#compMon").val());
				var psnlMon = replaceAll($("#psnlMon").val(), ",", "");
				if( psnlMon == ""){
					$("#span_totMon").html(makeComma(comMon)+"원");
				}else{
					$("#span_totMon").html(makeComma(comMon+parseInt(psnlMon))+"원");
				}
			});
		}
		doAction("Search");
	});
	
	// Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search":
			// 입력 폼 값 셋팅
			var data = ajaxCall( "${ctx}/PsnalPenApp.do?cmd=getPsnalPenAppDetMap", $("#searchForm").serialize(),false);

			if ( data != null && data.DATA != null ){ 
				$("#pensCd").val(data.DATA.pensCd);
				
				if(authPg == "A" && data.DATA.chk != "")  {
					$("#pensCd").addClass("transparent").addClass("hideSelectButton").attr("disabled",true).removeClass("required");
				}

				$("#jikgubCd").val(data.DATA.jikgubCd);
				$("#span_jikgubNm").html(data.DATA.jikgubNm);
				$("#compMon").val(data.DATA.compMon);
				$("#span_compMon").html(makeComma(data.DATA.compMon));
				$("#psnlMon").val(makeComma(data.DATA.psnlMon)).mask('000,000,000,000,000', { reverse : true });
				$("#span_totMon").html(makeComma(data.DATA.totMon));
				$("#payYm").val(data.DATA.payYm);
				$("#span_payYm").html(formatDate(data.DATA.payYm,"-"));
				$("#note").val(data.DATA.note);
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
			var map = ajaxCall( "${ctx}/PsnalPenApp.do?cmd=getPsnalPenAppDupChk",$("#searchForm").serialize(),false);
			if ( map != null && map.DATA != null ){
				if( map.DATA.cnt != "0" ){
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

			$("#pensCd").removeAttr("disabled",true);
	      	//저장
			var data = ajaxCall("${ctx}/PsnalPenApp.do?cmd=savePsnalPenAppDet",$("#searchForm").serialize(),false);
			
            if(data.Result.Code < 1) {
                alert(data.Result.Message);
				returnValue = false;
            }else{
				returnValue = true;
            }
			
			 

		} catch (ex){
			alert("Error!" + ex);
			returnValue = false;
		}

		return returnValue;
	}
	
</script>
</head>
<body class="bodywrap">
<div class="wrapper">

	<form name="searchForm" id="searchForm" method="post">
	<input type="hidden" id="searchApplSabun"	name="searchApplSabun"	 value=""/>
	<input type="hidden" id="searchApplName"	name="searchApplName"	 value=""/>
	<input type="hidden" id="searchApplSeq"		name="searchApplSeq"	 value=""/>
	<input type="hidden" id="searchApplYmd"		name="searchApplYmd"	 value=""/>
	<input type="hidden" id="searchAuthPg"		name="searchAuthPg"	     value=""/>
	
	<input type="hidden" id="jikgubCd"			name="jikgubCd"	     	 value=""/>
	<input type="hidden" id="compMon"			name="compMon"	     	 value=""/>
	<input type="hidden" id="payYm"				name="payYm"	     	 value=""/>
	
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
			<th>가입상품</th>
			<td>
				<select id="pensCd" name="pensCd" class="${selectCss} ${required} " ${disabled}></select>
			</td>
			<th>직급</th>
			<td>
				<span id="span_jikgubNm">&nbsp;</span>
			</td>
		</tr>	
		<tr>
			<th>개인부담금</th>
			<td>
				<input type="text" id="psnlMon" name="psnlMon" class="${textCss} w80 " ${readonly}/>
			</td> 
			<th>회사지원금</th>
			<td>
				<span id="span_compMon"></span>
			</td> 
		</tr>
		<tr>
			<th>계</th>
			<td> 
				<span id="span_totMon"></span>
			</td>	
			<th>적용시작년월</th>
			<td> 
				<span id="span_payYm"></span>
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