<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='104201' mdef='사내추천 세부내역'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var searchApplSeq = "${searchApplSeq}";
	var adminYn = "${adminYn}";
	var authPg = "${authPg}";
	var searchApplSabun = "${searchApplSabun}";
	var searchSabun = "${searchSabun}";
	var searchApplYmd = "${searchApplYmd}";
	
	$(function() {
		parent.iframeOnLoad("430px");
		
		
	});
	
	$(function() {
		
		if(authPg=="A"){
	    }else{
	    	$("#reqData").attr("readonly", true);
		    $("#gubun").attr("disabled", true);
		    
	    }
	    
	    if(adminYn=="N"){
	    	$("#processData").attr("readonly", true);
	    }
		
		
		// 세션 사번
		$("#searchSabun").val(searchSabun);

		// 신청자
		$("#searchApplSabun").val(searchApplSabun);
		
		
		// 신청순번
		$("#searchApplSeq").val(searchApplSeq);
		
		
		
		//신청일자
		$("#applYmd").val(searchApplYmd);
		$("#applYmdTmp").val(formatDate(searchApplYmd,"-"));
		
		// 기본 입력 사항

		//추천인과의 관계 코드
		var gubunCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&useYn=Y","B10800"), ""); //그룹코드
		$("#gubun").html(gubunCdList[2]);

	    // 신고내용
	    $("#reqData").maxbyte(2000);

		//구분 변경 시 신고내용 기본양식 표시
		$('#dataForm').on('change', 'select[name="gubun"]', function() {
			var reqData = codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&useYn=Y&code="+$(this).val(), "B10800"); //개인고충신고구분
			$("#reqData").val(reqData[0].note1);
		});
	    
		$("#gubun").trigger('change');
		
	    // 처리결과
	    $("#processData").maxbyte(2000);

		doAction1("Search");
	});
	
	// 날짜 포맷을 적용한다..
	function formatDate(strDate, saper) {
		if(strDate == "" || strDate == null) {
			return "";
		}

		try {
			if(strDate.length == 10) {
				return strDate.substring(0,4)+saper+strDate.substring(5,7)+saper+strDate.substring(8,10);
			} else if(strDate.length == 8) {
				return strDate.substring(0,4)+saper+strDate.substring(4,6)+saper+strDate.substring(6,8);
			} else {
				return "";
			}
		} catch(e) {
			return "";
		}
	}
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":

			// 입력 폼 값 셋팅
			var data = ajaxCall("${ctx}/HrQueryApp.do?cmd=getHrQueryAppDetMap",$("#dataForm").serialize(),false);
			
			if(data.map == null){
				$("#reqDate").val('<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>');
				
				
				return;
			}else{
				$("#reqDate").val(data.map.reqDate);				
			}
			
		    
		    // 구분
		    $("#gubun").val(data.map.gubun);
		    
		    // 요청내용
		    $("#reqData").val(data.map.reqData);
		   
			// 처리결과
			$("#processData").val(data.map.processData);
 
			break;
		}
	}

	// 입력시 조건 체크
	function checkList(){

		var ch = true;
	
		// 화면의 개별 입력 부분 필수값 체크
// 		$(".require").each(function(index){
// 			if($(this).val().length == 0){
// 				alert($(this).parent().prev().text()+"은 필수값입니다.");
// 				$(this).focus();				
// 				ch =  false;
// 				return false;
// 			}
// 		});
		
		if(adminYn=="N"){
			if($("#reqData").val().length == 0){
				alert($("#reqData").parent().prev().text()+"은 필수값입니다.");
				$("#reqData").focus();
				ch =  false;
			}
		}else{
			/*
			if($("#processData").val().length == 0){
				alert($("#processData").parent().prev().text()+"은 필수값입니다.");
				$("#processData").focus();
				ch =  false;
			}
			*/
		}
		
		
		
		
		return ch;
	}	
	
	// 저장후 리턴함수 
	function setValue(){
		var rtn;
		var returnValue = false;

		// 항목 체크 리스트
		if(checkList()){
			
			try{
				$("#gubun").attr("disabled", false);
				var rtn = ajaxCall("${ctx}/HrQueryApp.do?cmd=saveHrQueryAppDet",$("#dataForm").serialize(),false);
				
				
				if(rtn.Result.Code < 1) {
					alert(rtn.Result.Message);
					returnValue = false;
				}else{
					returnValue = true;
				}		
				
			} catch (ex){
				alert("Script Errors Occurred While Saving." + ex);
				returnValue = false;
			}
			returnValue = true;
		}else{
			returnValue = false;
		}
		return returnValue;
	}
</script>
</head>
<body class="bodywrap">
<form id="dataForm" name="dataForm" >
<input type="hidden" id="searchSabun" name="searchSabun" value=""/>
<input type="hidden" id="searchApplSabun" name="searchApplSabun" value=""/>
<input type="hidden" id="searchApplSeq" name="searchApplSeq" value=""/>
<input id="applYmd" name="applYmd" type="hidden" />

<!-- <input type="hidden" id="searchRegGubun" name="searchRegGubun" value=""/> -->
<div class="wrapper">	
	<div class="outer">
	
		<div class="sheet_title">
			<ul>
				<li class="txt">신고</li>
			</ul>
		</div>
	
		<table class="table">
			<colgroup>
				<col width="25%" />
				<col width="25%" />
				<col width="25%" />
				<col width="25%" />
			</colgroup>
			<tr>
				<th align="center"><tit:txt mid='103997' mdef='구분'/></th>
				<td>
					<select id="gubun" name="gubun" class="${textCss} ${readonly} w100p require"></select>
				</td>
				<th align="center"><tit:txt mid='104389' mdef='신청일'/></th>
				<td>
					<input id="applYmdTmp" name="applYmdTmp" class="text transparent" ${readonly} />
				</td>
			</tr>
		
			<tr>
				<th align="center">신고내용</th>
				<td colspan="3">
					<textarea id="reqData" name="reqData"  rows="10" cols="85" class="w100p"></textarea>
					
				</td>
			</tr>
			<tr style="display:none">
				<td colspan="4" align="center">담당자</th>
			</tr>
			<tr>
				<th align="center"><tit:txt mid='104105' mdef='처리결과'/></th>
				<td colspan="3">
					<textarea id="processData" name="processData" class="${textCss} w100p" rows="10" cols="85" ></textarea>
				</td>
			</tr>
		</table>
	</div>
</div>
</form>
</body>
</html>
