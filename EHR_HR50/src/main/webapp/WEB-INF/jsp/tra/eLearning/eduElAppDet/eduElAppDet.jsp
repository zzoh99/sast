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
var closeYn;				//마감여부
var readonly = "${readonly}";

	$(function() {
		
		parent.iframeOnLoad(150);

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
		//----------------------------------------------------------------
			
		//이러닝신청항목
		var eduCdList = convCodeCols( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&useYn=Y","L50110"), "note2"," ");
		$("#eduCd").html(eduCdList[2]);
		
		// 신청, 임시저장
		if(authPg == "A") {

			//대상년월 및 사용자정보 조회
			var user = ajaxCall( "${ctx}/EduElApp.do?cmd=getEduElAppDetInfo&searchApplSabun="+searchApplSabun, "",false);
			if ( user != null && user.DATA != null ){ 
				$("#span_phoneNo").html(user.DATA.phoneNo);
				$("#span_mailId").html(user.DATA.mailId);
				$("#phoneNo").val(user.DATA.phoneNo);
				$("#mailId").val(user.DATA.mailId);
				$("#ym").val(user.DATA.ym);
				$("#span_ym").html(user.DATA.ymView);
			}else{
				$("#span_ym").html("신청기간이 아닙니다.");
				$("#eduCd").html("");
			}
			
			//신청항목 변경 시 
			$("#eduCd").bind("change", function(){
				var param = "&searchItemCd="+$("#eduCd").val();
				var eduDtlCdList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getEduElStdItemDtlList"+param, false).codeList, "");
				$("#eduDtlCd").html(eduDtlCdList[2]);
				
				//강좌명 직접 입력
				var obj = $("#eduCd option:selected");
				if( obj.attr("note2") == "Y" ){
					$("#eduNm").addClass("required");
				}else{
					$("#eduNm").removeClass("required");
				}
				
			});
		} else if (authPg == "R") {

			//이러닝신청세부항목
			var eduDtlCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&useYn=Y","L50120"), " ");
			$("#eduDtlCd").html(eduDtlCdList[2]);
			
		}


		doAction("Search");		
	});
	
	// Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search":
			// 입력 폼 값 셋팅
			var data = ajaxCall( "${ctx}/EduElApp.do?cmd=getEduElAppDetMap", $("#searchForm").serialize(),false);

			if ( data != null && data.DATA != null ){ 
				
				$("#ym").val(data.DATA.ym);
				$("#span_ym").html(data.DATA.ymView);
				$("#span_phoneNo").html(data.DATA.phoneNo);
				$("#span_mailId").html(data.DATA.mailId);
				$("#phoneNo").val(data.DATA.phoneNo);
				$("#mailId").val(data.DATA.mailId);

				$("#eduCd").val(data.DATA.eduCd); 

				if(authPg == "A") {
					$("#eduCd").change();
				}
				$("#eduDtlCd").val(data.DATA.eduDtlCd); 
				$("#eduNm").val(data.DATA.eduNm); 

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
			var map = ajaxCall( "${ctx}/EduElApp.do?cmd=getEduElAppDetDupChk",$("#searchForm").serialize(),false);
			if ( map != null && map.DATA != null ){
				if( map.DATA.dupCnt != "0" ){
					alert("<msg:txt mid='appDupErrMsg' mdef='동일한 신청 건이 있어 신청 할 수 없습니다.'/>")
					ch =  false;
					return false;
				}
				if( map.DATA.cnt > map.DATA.appCnt ){
					alert("<msg:txt mid='eduElAppExcessErrMsg' mdef='대상년월 신청 가능 건수가 초과되어 신청 할 수 없습니다.'/>")
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
	        

	      	//저장
			var data = ajaxCall("${ctx}/EduElApp.do?cmd=saveEduElAppDet",$("#searchForm").serialize(),false);

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
	
	<input type="hidden" id="ym"			name="ym"	     	value=""/>
	<input type="hidden" id="phoneNo"		name="phoneNo"	     value=""/>
	<input type="hidden" id="mailId"		name="mailId"	     value=""/>

	<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='appTitle' mdef='신청내용'/></li>
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
			<th><tit:txt mid='114444' mdef='대상년월'/></th>
			<td colspan="3">
				<span id="span_ym"></span>
			</td>			
		</tr>	
		<tr>
			<th><tit:txt mid='114216' mdef='휴대폰번호'/></th>
			<td>
				<span id="span_phoneNo"></span>				
			</td>
			<th><tit:txt mid='mailId' mdef='메일주소'/></th>
			<td>
				<span id="span_mailId"></span>
			</td>
		</tr>	
		
		<tr>
			<th><tit:txt mid='eduElCd' mdef='신청항목'/></th>
			<td>
				<select id="eduCd" name="eduCd" class="${selectCss} ${required} " ${disabled}></select>	
			</td>
			<th><tit:txt mid='eduDtlCd' mdef='신청세부항목'/></th>
			<td>
				<select id="eduDtlCd" name="eduDtlCd" class="${selectCss} ${required} " ${disabled}></select>	
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='eduNmV1' mdef='강좌명'/></th>
			<td colspan="3">
				<input type="text" id="eduNm" name="eduNm" class="${textCss} w100p" ${readonly} maxlength="100"/>
			</td>
		</tr>		
		</table>
		
	</form>
</div>
		
</body>
</html>