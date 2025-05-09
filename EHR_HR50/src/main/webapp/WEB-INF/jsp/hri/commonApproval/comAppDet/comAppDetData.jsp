<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head> <title>공통신청 세부내역</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%
Map<String, Object> editorMap = new HashMap<String, Object>();
editorMap.put("minusHeight", "50");
editorMap.put("formNm", "searchForm");
editorMap.put("contentNm", "contents");
request.setAttribute("editor", editorMap);
%>
<script type="text/javascript">

var searchApplCd     = "${searchApplCd}";
var searchApplSeq    = "${searchApplSeq}";
var adminYn          = "${adminYn}";
var authPg           = "${authPg}";
var searchApplSabun  = "${searchApplSabun}";
var searchApplInSabun= "${searchApplInSabun}";
var searchApplYmd    = "${searchApplYmd}";
var applStatusCd	 = "";
var pGubun           = "";
var gPRow = "";
var adminRecevYn     = "N"; //수신자 여부

	$(function() {
		

		//----------------------------------------------------------------
		$("#searchApplSeq", "#searchForm").val(searchApplSeq);
		$("#searchApplSabun", "#searchForm").val(searchApplSabun);
		$("#searchApplYmd", "#searchForm").val(searchApplYmd);

		applStatusCd = parent.$("#applStatusCd").val();

		if(applStatusCd == "") {
			applStatusCd = "11";
		}
		//----------------------------------------------------------------
		$("#searchApplCd", "#dataForm").val(searchApplCd);
		init_form();
		//----------------------------------------------------------------
		
	});
	//데이터폼 로드 후 호출 
	function fnFormLoadEnd(){
		parent.iframeOnLoad(document.body.scrollHeight);
		// 신청, 임시저장
		if(authPg == "A") {

			doAction("Search");
			
		} else if (authPg == "R") {

			$(".ui-datepicker-trigger, .button6, .button7").hide();
			doAction("Search");

		}

	}
	// Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search":
			// 입력 폼 값 셋팅
			var data = ajaxCall( "${ctx}/ComAppDet.do?cmd=getComAppDetData", $("#searchForm").serialize()+"&searchApplCd="+$("#searchApplCd", "#dataForm").val(),false);

			if ( data != null && data.DATA != null ){
				for( var i=0 ; i < data.DATA.length ; i++){
					
					if( data.DATA[i].columnTypeCd == "Label" ){
						if( data.DATA[i].val != "" ){
							$("#span_"+data.DATA[i].id).html( data.DATA[i].val );	
							$("#"+data.DATA[i].id).val( data.DATA[i].val );
						
						}
							
					}else {
						if( data.DATA[i].columnTypeCd == "Popup" ){
							$("#"+data.DATA[i].id+"Nm").val( data.DATA[i].valNm );
						}
						$("#"+data.DATA[i].id).val( data.DATA[i].val );
					}
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
			var data = ajaxCall("${ctx}/ComAppDet.do?cmd=saveComAppDetData",$("#searchForm").serialize()+"&"+$("#dataForm").serialize(),false);

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
<div>

	<form name="searchForm" id="searchForm" method="post">
	<input type="hidden" id="searchApplSabun"	name="searchApplSabun"	 value=""/>
	<input type="hidden" id="searchApplName"	name="searchApplName"	 value=""/>
	<input type="hidden" id="searchApplSeq"		name="searchApplSeq"	 value=""/>
	<input type="hidden" id="searchApplYmd"		name="searchApplYmd"	 value=""/>
	<input type="hidden" id="searchAuthPg"		name="searchAuthPg"	     value=""/>
	</form>
	
	<div class="sheet_title">
		<ul>
			<li class="txt">신청내용</li>
			<li class="btn">&nbsp;</li>
		</ul>
	</div>
	
	<%@ include file="/WEB-INF/jsp/hri/commonApproval/comAppFormMgr/comAppFormMgrForm.jsp"%>
	<div class="h10"></div>
</div>
		
</body>
</html>