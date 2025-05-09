<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head> <title>어학시험응시료신청 세부내역</title>
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
		
		$('#testMon').mask('000,000,000,000,000', { reverse : true });
		$('#payMon').mask('000,000,000,000,000', { reverse : true });		

		applStatusCd = parent.$("#applStatusCd").val();
		applYn = parent.$("#applYn").val(); // 현 결재자와 세션사번이 같은지 여부

		if(applStatusCd == "") {
			applStatusCd = "11";
		}

		if( ( adminYn == "Y" ) || ( applStatusCd == "31"  && applYn == "Y" ) ){ //담당자거나 수신결재자이면
			
			if( applStatusCd == "31") { //수신처리중일 때만 지급정보 수정 가능
				$("#payMon").removeClass("transparent").removeAttr("readonly");
				$("#payYm").removeClass("transparent").removeAttr("readonly");
				$("#payYm").datepicker2({ymonly:true});
				$("#payNote").removeClass("transparent").removeAttr("readonly");
			}

			adminRecevYn = "Y";			
			$(".payInfo").show();
			parent.iframeOnLoad(300);
		}
		
		//----------------------------------------------------------------
			
		//어학시험 콤보 		
		var testCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20307"), "선택");
		$("#testCd").html(testCdList[2]);

		// 신청, 임시저장
		if(authPg == "A") {
			$("#testYmd").datepicker2();
		} else if (authPg == "R") {
		}

		doAction("Search");		
	});
	
	// Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search":
			// 입력 폼 값 셋팅
			var data = ajaxCall( "${ctx}/FtestmonApp.do?cmd=getFtestmonAppDetMap", $("#searchForm").serialize(),false);

			if ( data != null && data.DATA != null ){ 
		 	
					$("#testCd").val(data.DATA.testCd); //어학시험코드
					$("#testYmd").val(formatDate(data.DATA.testYmd,"-"));	// 시험일자
					$("#testMon").val(makeComma(data.DATA.testMon)); //응시료
					$("#note").val(data.DATA.note); //비고
					

				if( adminRecevYn == "Y" ){
					$("#payMon").val(makeComma(data.DATA.payMon));
					$("#payMon_won").html( ( $("#payMon").val() == "")?"":"원");
					$("#payYm").val(formatDate(data.DATA.payYm, "-"));
					$("#payNote").val(data.DATA.payNote);
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

			//중복체크 확인
			var map = ajaxCall( "${ctx}/FtestmonApp.do?cmd=getFtestmonAppDupChk",$("#searchForm").serialize(),false);
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

			//관리자 수신담당자 경우 지급정보 저장
			if( adminRecevYn == "Y" ){
				
				var rtn = ajaxCall("${ctx}/FtestmonApp.do?cmd=saveFtestmonAppDetAdmin", $("#searchForm").serialize(), false);

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
				var data = ajaxCall("${ctx}/FtestmonApp.do?cmd=saveFtestmonAppDet",$("#searchForm").serialize(),false);
	
	            if(data.Result.Code < 1) {
	                alert(data.Result.Message);
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
			<th>어학시험</th>
			<td colspan="3">
				<select id="testCd" name="testCd" class="${selectCss} ${required} " ${disabled}></select>
			</td>			
		</tr>	
		<tr>
			<th>시험일자</th>
			<td>
				<input type="text" id="testYmd" name="testYmd" class="${dateCss} ${required} w80" ${readonly} maxlength="10"/>				
			</td>
			<th>응시료</th>
			<td>
				<input type="text" id="testMon" name="testMon" class="${textCss} ${required} w80" ${readonly} /><span> 원</span>
			</td>
		</tr>	
		
		<tr>
			<th><tit:txt mid='103783' mdef='비고' /></th>
			<td colspan="3"><textarea id="note" name="note" rows="3" class="${textCss} w100p" ${readonly}  maxlength="1000"></textarea></td>
		</tr>
		</table>
		
		<div class="sheet_title payInfo">
			<ul>
				<li class="txt">지급정보</li>
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
				<th>지급금액</th>
				<td><input type="text" id="payMon" name="payMon" class="text transparent w80" readonly/><span id="payMon_won"></span></td>
				<th>급여년월</th>
				<td><input type="text" id="payYm" name="payYm" class="date2 transparent w90" readonly maxlength="6"/></td>
			</tr>
			<tr>				
				<th>지급메모</th>
				<td colspan="5"><textarea id="payNote" name="payNote" rows="3" class="${textCss} w100p transparent" readonly maxlength="1000"></textarea></td>
			</tr>
		</table>
		
	</form>
</div>
		
</body>
</html>