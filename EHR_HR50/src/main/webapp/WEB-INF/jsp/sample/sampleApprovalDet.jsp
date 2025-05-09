<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head> <title>Sample신청 세부내역</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

	<!--
		결재 상태나, 수신 담당자의 화면 등 결재 프로세스에 따른 신청결재 화면의 입력란을 제어하기 위한 설정

		gubun - THRI103.GUBUN = 결재 진행 구분(0:본인,1:결재,3:수신)/ 수신인 경우 수신 담당자( 업무 처리자 결재 상태 )로 신청결재 하단의 업무처리 입력란을 컨트롤
		adminYn - Admin 수정 여부를 컨트롤

		나머진 아래 케이스를 보고 분석
 	-->

<script type="text/javascript">

var searchApplSeq    = "${searchApplSeq}";
var adminYn          = "${adminYn}";
var authPg           = "${authPg}";
var searchApplSabun  = "${searchApplSabun}";
var searchApplInSabun= "${searchApplInSabun}";
var searchApplYmd    = "${searchApplYmd}";
var applStatusCd	 = "";
var pGubun           = "";
var gPRow = "";

	$(function() {

		parent.iframeOnLoad(100);
		
		// 신청 상태가 없을 경우
		if(applStatusCd == ""){
			//무조건 임시정장으로 본다.
			applStatusCd = "11";
		}
		
		//----------------------------------------------------------------
		$("#searchApplSeq").val(searchApplSeq);
		$("#searchApplSabun").val(searchApplSabun);
		$("#searchApplYmd").val(searchApplYmd);

		applStatusCd = parent.$("#applStatusCd").val();

		if(applStatusCd == "") {
			applStatusCd = "11";
		}

		/*
		 *	authPg에 따른 세팅이 필요할 경우
		 */
	    if(authPg=="A"){
	    	$("#zipCodePopup").show();					// 신청 화면인 경우에만 zipCodePopup Icon이 보이게
	    }else{
	    	$("#zipCodePopup").hide();					// 신청 화면 외에는 zipCodePopup Icon이 안보임( 해당 내용 수정 불가능 하게 )
	    }

		/*
		 *	수신 담당자나 admin인 경우에만 세팅이 필요한 경우
		 */
		if(applStatusCd == "31" || adminYn =='Y') {
			$("#divApp").show();
		}

		doAction1("Search");
	});


	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":

			//결재내역 조회 후 화면에 세팅
			var data = ajaxCall("${ctx}/Sample.do?cmd=getSampleApprovalMap","&searchApplSeq="+searchApplSeq,false);

			if ( data != null && data.DATA != null ){ 

				$("#tstZipcode").val(data.map['tstZipcode']);		// 우편번호
				$("#tstAddr").val(data.map['tstAddr']);				// 기본주소
				$("#tstAddrDtl").val(data.map['tstAddrDtl']);		// 상세주소
				$("#tstComment").val(data.map['tstComment']);		// 담당자 의견

			}

			break;
		}

	}


	//--------------------------------------------------------------------------------
	//  저장 시 필수 입력 및 조건 체크
	//--------------------------------------------------------------------------------
	function checkList(){

		var ch = true;

		// 화면의 개별 입력 부분 필수값 체크
		$(".required").each(function(index){
			if($.trim($(this).val()).length == 0){
				alert($(this).parent().prev().text()+"은 필수값입니다.");
				$(this).focus();
				ch =  false;
				return ch;
			}
		});

		if(!ch){
			return;
		}

		return ch;
	}

	/*
	 *	체크 및 저장 로직
	 *	- appraovalMgr이나 approvalMgrResult에서 결재요청 및 결재 등의 Action이 취해지면, iframe( 신청/결재 프로그램 )의 setValue()를 호출하게 됨
	 */
	function setValue(status){

		var rtn;
		var returnValue = false;

		try {

			if ( authPg == "R" )  {
				return true;
			}
			
	        // 항목 체크 리스트
	        if ( !checkList() ) {
	            return false;
	        }

			//저장
			var data = ajaxCall("${ctx}/Sample.do?cmd=saveSampleApprovalDet",$("#dataForm").serialize(),false);

            if(data.Result.Code < 1) {
                alert(data.Result.Message);
				returnValue = false;
            }else{
				returnValue = true;
            }
			
			

		} catch (ex){
			alert("저장중 스크립트 오류발생!" + ex);
			returnValue = false;
		}
		return returnValue;
	}


	//우편번호찾기 팝업
	function zipCodePopup(){

		if(!isPopup()) {return;}

		pGubun = "ZipCodePopup";

		openPopup("/ZipCodePopup.do?cmd=viewZipCodePopup&authPg=${authPg}", "", "740","620");
		
	}
	

	// 팝업 리턴 함수
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

		if ( pGubun == "ZipCodePopup" ){
			$("#tstZipcode").val(rv["zip"]);
			$("#tstAddr").val(v["doroAddr"]);
			$("#tstAddrDtl").val(rv["detailAddr"]);
		}
    }
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="dataForm" name="dataForm" >
	<input type="hidden" id="searchApplSabun"	name="searchApplSabun"	 value=""/>
	<input type="hidden" id="searchApplName"	name="searchApplName"	 value=""/>
	<input type="hidden" id="searchApplSeq"		name="searchApplSeq"	 value=""/>
	<input type="hidden" id="searchApplYmd"		name="searchApplYmd"	 value=""/>
	<input type="hidden" id="searchAuthPg"		name="searchAuthPg"	     value=""/>
	
	<input type="hidden" id="fileNm" name="fileNm" value=""/>

		
	<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='104063' mdef='신청내역'/></li>
		</ul>
	</div>
	<table class="table">
		<colgroup>
			<col width="15%" />
			<col width="85%" />
		</colgroup>
		<tr>
				<th><tit:txt mid='112055' mdef='우편번호'/></th>
			<td>
				<input id="tstZipcode" name="tstZipcode" type="text" class="${textCss} ${required} w100" value="" readonly />
				<a href="javascript:zipCodePopup();" id="zipCodePopup" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
			</td>

		</tr>
		<tr>
		<th><tit:txt mid='addr1' mdef='기본주소'/></th>
			<td>
				<input id="tstAddr" name="tstAddr" type="text" class="${textCss} ${required} w100p left" readonly />
			</td>
		</tr>
		<tr>
		<th><tit:txt mid='113463' mdef='상세주소'/></th>
			<td>
				<input id="tstAddrDtl" name="tstAddrDtl" type="text" class="${textCss} w100p left" ${readonly} />
			</td>
		</tr>
	</table>

	<div class="sheet_title divApp" style="display:none;">
		<ul>
			<li class="txt">수신 담당자 내역</li>
		</ul>
	</div>
	<table class="table divApp" style="display:none;">
		<colgroup>
			<col width="15%" />
			<col width="85%" />
		</colgroup>
		<tr>
			<th align="center">의견</th>
			<td>
				<input id="tstComment" name="tstComment" type="text" class="${textCssAdmin} ${readonlyAdmin} ${requiredAdmin} w100p left" ${readonlyAdmin} maxLength="200" size="200"/>
			</td>
		</tr>
	</table>
			
	</form>
</div>
</body>
</html>
