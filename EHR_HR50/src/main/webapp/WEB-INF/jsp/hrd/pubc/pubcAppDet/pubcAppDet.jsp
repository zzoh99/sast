<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head> <title>사내공모신청 세부내역</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<c:choose>
	<c:when test="${adminYn == 'N' }">
		<c:set var="textCssAdmin"	value="text transparent" />
		<c:set var="dateCssAdmin"	value="date2 transparent" />
		<c:set var="requiredAdmin"	value="" />
		<c:set var="required"		value="required" />
	</c:when>
	<c:otherwise>
		<c:set var="textCssAdmin"	value="text" />
		<c:set var="dateCssAdmin"	value="date2" />
		<c:set var="requiredAdmin"	value="required" />
		<c:set var="required"		value="" />
	</c:otherwise>
</c:choose>

<script type="text/javascript">

var searchApplSeq    = "${searchApplSeq}";
var adminYn          = "${adminYn}";
var authPg           = "${authPg}";
var searchApplSabun  = "${searchApplSabun}";
var searchApplInSabun= "${searchApplInSabun}";
var searchApplYmd    = "${searchApplYmd}";
var etc01    		 = "${etc01}";
var applStatusCd	 = "";
var applYn	         = "";
var pGubun           = "";
var gPRow = "";
var adminRecevYn     = "N"; //수신자 여부

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
			$("#choiceYn").removeClass("readonly").removeAttr("disabled");
			$("#choiceRsn").removeClass("transparent").removeAttr("readonly");
			
			adminRecevYn = "Y";
		}
		
		//----------------------------------------------------------------		
		
		var param = "";
		// 신청, 임시저장
		if(authPg == "A") {
			param = "&useYn=Y";
		} 
		
		// 신청, 임시저장
		if(authPg == "A") {
			//신청자정보 조회
			var user = ajaxCall( "${ctx}/PubcApp.do?cmd=getPubcAppDetUseInfo", $("#searchForm").serialize(),false);
			if ( user != null && user.DATA != null ){ 
				$("#searchApplName").val(user.DATA.applName);
			}

			// etc01(pubcId) 값이 null이 아닌경우, 사내공모명 자동 설정
			if(etc01 != null && etc01 != 'null') {
				let pubcInfo = ajaxCall( "${ctx}/PubcApp.do?cmd=getPubcAppDetPubcInfoMap&searchPubcId="+etc01, $("#searchForm").serialize(),false);
				if ( pubcInfo != null && pubcInfo.DATA != null ){
					$("#pubcId").val(pubcInfo.DATA.pubcId);
					$("#pubcNm").val(pubcInfo.DATA.pubcNm);
					$("#pubcDivNm").val(pubcInfo.DATA.pubcDivNm);
					$("#pubcStatNm").val(pubcInfo.DATA.pubcStatNm);
					$("#jobNm").val(pubcInfo.DATA.jobNm);
					$("#applStaYmd").val(getDateVal(pubcInfo.DATA.applStaYmd));
					$("#applEndYmd").val(getDateVal(pubcInfo.DATA.applEndYmd));
					$("#pubcContent").text(pubcInfo.DATA.pubcContent);
				}
			}

		} else if (authPg == "R") {
			$("#searchPubcNm").find("img").remove();
		}
		
		doAction("Search");
	});
	// Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search":
			// 입력 폼 값 셋팅
			var data = ajaxCall( "${ctx}/PubcApp.do?cmd=getPubcAppDetMap", $("#searchForm").serialize(),false);
			
			if ( data != null && data.DATA != null ){ 
				$("#pubcId").val(data.DATA.pubcId);
				$("#pubcNm").val(data.DATA.pubcNm);
				$("#pubcDivNm").val(data.DATA.pubcDivNm);
				$("#pubcStatNm").val(data.DATA.pubcStatNm);
				$("#jobNm").val(data.DATA.jobNm);
				$("#applStaYmd").val(formatDate(data.DATA.applStaYmd, "-"));
				$("#applEndYmd").val(formatDate(data.DATA.applEndYmd, "-"));
				$("#pubcContent").text(data.DATA.pubcContent);
				$("#applRsn").text(data.DATA.applRsn);
				$("#planTxt").text(data.DATA.planTxt);
				$("#note").val(data.DATA.note);
				
				if( data.DATA.choiceYn == "Y" ) $("#choiceYn" ).prop("checked", true);
				
				$("#choiceRsn").val(data.DATA.choiceRsn);
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
		
		if(!ch) return ch;
		
		if ( authPg == "A") {
	        // 신청서 중복 체크
	        var dupData = ajaxCall("${ctx}/PubcApp.do?cmd=getPubcAppDetDupCnt", $("#searchForm").serialize(),false);
	
	        if(dupData.DATA != null && dupData.DATA.dupCnt != "null" && dupData.DATA.dupCnt != "0"){
	       		alert("기신청서에 공모명에 대한 동일한 데이터가 존재합니다.");	
				return false;
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

				var rtn = ajaxCall("${ctx}/PubcApp.do?cmd=savePubcAppDetAdmin", $("#searchForm").serialize(), false);

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
		        
		        var rtn = ajaxCall("${ctx}/PubcApp.do?cmd=savePubcAppDet",$("#searchForm").serialize(),false);

				if(rtn.Result.Code < 1) {
					alert(rtn.Result.Message);
					returnValue = false;
				}else{
					returnValue = true;
				}
				
			}
			

		} catch (ex){
			alert("Error!" + ex);
			returnValue = false;
		}

		return returnValue;
	}
	
	// 공모명 팝업
	function doSearchPubcNm() {
		if(!isPopup()) {return;}

		let w = 800;
		let h = 700;
		let url = "/PubcApp.do?cmd=viewPubcAppDetLayer";
		let p = {
			searchApplSabun : searchApplSabun,
			checkType : "Y",
			authPg : "A"
		};

		gPRow = "";
		pGubun = "viewPubcAppDetPopup";

		// openPopup(url,args,800,700);
		var pubcAppDetLayer = new window.top.document.LayerModal({
			id: 'pubcAppDetLayer',
			url: url,
			parameters: p,
			width: w,
			height: h,
			title: '사내공모 리스트 조회',
			trigger: [
				{
					name: 'pubcAppDetLayerTrigger',
					callback: function(rv) {
						getReturnValue(rv);
					}
				}
			]
		});
		pubcAppDetLayer.show();



	}
	
	function getDateVal(pVal) {
		if ( pVal.length == 8 ) {
			return pVal.substr(0,4) +"-"+ pVal.substr(4,2) +"-"+ pVal.substr(6,2);
		} else {
			return pVal;
		}
	}
	
	//팝업 콜백 함수.
	function getReturnValue(rv) {

	    if(pGubun == "viewPubcAppDetPopup") {
	    	$("#pubcId").val(rv.pubcId);
	    	$("#pubcNm").val(rv.pubcNm);
	    	$("#pubcDivNm").val(rv.pubcDivNm);
	    	$("#pubcStatNm").val(rv.pubcStatNm);
	    	$("#jobNm").val(rv.jobNm);
	    	$("#applStaYmd").val(getDateVal(rv.applStaYmd));
	    	$("#applEndYmd").val(getDateVal(rv.applEndYmd));
	    	$("#pubcContent").text(rv.pubcContent);
	    }
	}
</script>

<style type="text/css">

/*---- checkbox ----*/
input[type="checkbox"]  { 
	display:inline-block; width:20px; height:20px; cursor:pointer; appearance:none; 
 	-moz-appearance:checkbox; -webkit-appearance:checkbox; margin-top:2px;background:none;
    border: 5px solid red;
}

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
		
		<input type="hidden" id="pubcId" name="pubcId" />
		
		<div class="sheet_title">
			<ul>
				<li class="txt">신청내용</li>
			</ul>
		</div>
		<table class="table">
			<colgroup>
				<col width="13%" />
				<col width="20%" />
				<col width="13%" />
				<col width="20%" />
				<col width="13%" />
				<col width="*" />
			</colgroup>
			<tr>
				<th>공모명</th>
				<td>
					<div class="search-wrap">
						<input id="pubcNm" name="pubcNm" type="text" class="text">
						<a type="button" class="btn-search" id="searchPubcNm" href="javascript:doSearchPubcNm();" >
							<i class="mdi-ico">search</i>
						</a>
					</div>
				</td>
				<th>공모구분</th>
				<td>
					<input type="text" id="pubcDivNm" name="pubcDivNm" class="text transparent w100p" readonly>
				</td>
				<th>공모상태</th>
				<td>
					<input type="text" id="pubcStatNm" name="pubcStatNm" class="text transparent w100p" readonly>
				</td>
			</tr>
			<tr>
				<th>공모직무</th>
				<td>
					<input type="text" id="jobNm" name="jobNm" class="text transparent readonly w100p" readonly>
				</td>
				<th>신청시작일</th>
				<td>
					<input type="text" id="applStaYmd" name="applStaYmd" class="text transparent w100p" readonly>
				</td>
				<th>신청종료일</th>
				<td>
					<input type="text" id="applEndYmd" name="applEndYmd" class="text transparent w100p" readonly>
				</td>
			</tr>
			<tr>
				<th>공모내용</th>
				<td colspan="5">
					<textarea id="pubcContent" name="pubcContent" rows="4" class="text transparent w100p" readonly></textarea>
				</td>
			</tr>
			<tr>
				<th>지원동기</th>
				<td colspan="5">
					<textarea id="applRsn" name="applRsn" rows="4" class="${textCss} w100p" ${readonly}></textarea>
				</td>
			</tr>
			<tr>
				<th>직무수행계획</th>
				<td colspan="5">
					<textarea id="planTxt" name="planTxt" rows="4" class="${textCss} w100p" ${readonly}></textarea>
				</td>
			</tr>
			<tr>
				<th>비고</th>
				<td colspan="5">
					<input type="text" id="note" name="note" class="${textCss} w100p" ${readonly}>
				</td>
			</tr>
		</table>
		
		<div class="sheet_title">
			<ul>
				<li class="txt">선정정보</li>
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
				<th>선정여부</th>
				<td><input type="checkbox" id="choiceYn" name="choiceYn" class="readonly" value="Y" disabled/></td>
				<th>선정사유</th>
				<td><input type="text" id="choiceRsn" name="choiceRsn" class="text transparent w100p" readonly/></td>
			</tr>
		</table>
		
	</form>
</div>
		
</body>
</html>