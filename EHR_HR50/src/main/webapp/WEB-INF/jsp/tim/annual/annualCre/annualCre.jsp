<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		
		$( "#searchYear" ).datepicker2({ymonly:true});
		$( "#searchYm" ).datepicker2({ymonly:true});
		$( "#searchYmd" ).datepicker2();
		
		var gntCdList     = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCpnAnnualGntCdList",false).codeList, ""); //근태코드
		var gntTypeCdList = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getComTypeListTTIM010", false).codeList
	                      , "gntCd,searchSeq", "");
		
		$("#searchGntCd").html(gntCdList[2]);
		$("#searchGntTypeCd").html(gntTypeCdList[2]);

		$("#searchGntTypeCd").bind("change", function(){
			$("#searchGntCd").val($("#searchGntTypeCd option:selected").attr("gntCd"));
			$("#searchSeq").val($("#searchGntTypeCd option:selected").attr("searchSeq"));
			$("#tr1").hide();$("#tr3").hide();$("#tr7").hide();
			$("#tr"+$("#searchGntTypeCd").val()).show();
		}).change();
    	

	});

    function annualCreate(){
    	if( $("#searchGntTypeCd").val() == "1" && $( "#searchYear" ).val() == "" ){
    		alert("기준년도를 입력하세요.");
    		$( "#searchYear" ).focus();
            return;
    	}

    	if( $("#searchGntTypeCd").val() == "3" && $( "#searchYm" ).val() == "" ){
    		alert("대상년월을 입력하세요.");
    		$( "#searchYm" ).focus();
            return;
    	}
    	
    	if( $("#searchGntTypeCd").val() == "7" && $( "#searchYmd" ).val() == "" ){
    		alert("기준일자를 입력하세요.");
    		$( "#searchYmd" ).focus();
            return;
    	}
        if (!confirm("휴가를 생성 하시겠습니까?")) return;
        
		progressBar(true) ;
		
		setTimeout(
			function(){
				var param = "";
				if( $("#searchGntTypeCd").val() == "1" ){
			    	param = "searchDate="+$("#searchYear").val();
					
				}else if( $("#searchGntTypeCd").val() == "3" ){
					param = "searchDate="+$("#searchYm").val().replace(/-/g, '');
					
				}else if( $("#searchGntTypeCd").val() == "7" ){
					param = "searchDate="+$("#searchYmd").val().replace(/-/g, '');
				}
						
		    	$("#searchGntCd").removeAttr("disabled");
		    	param +=  "&searchSeq="+$("#searchSeq").val();
		    	param +=  "&searchGntCd="+$("#searchGntCd").val();
		    	
		    	$("#searchGntCd").attr("disabled", true);
		    	
				var data = ajaxCall("${ctx}/AnnualCre.do?cmd=prcAnnualCreateCall", param,false);
				if(data.Result.Code == null) {
		    		alert("정상 처리되었습니다.");
			    	progressBar(false) ;
		    	} else {
			    	alert("처리중 오류가 발생했습니다.\n"+data.Result.Message);
			    	progressBar(false) ;
		    	}
			}
		, 100);
    	
    }
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="searchForm" name="searchForm" >
		<input type="hidden" id="searchSeq" name="searchSeq" />
		<div class="sheet_title">
			<ul>
				<li class="txt">휴가생성</li>
			</ul>
		</div>

		<table class="table">
			<colgroup>
				<col width="150" />
				<col width="" />
			</colgroup>
			<tr>
				<th style="width:150px;">대상자</th>
				<td><select id="searchGntTypeCd" name="searchGntTypeCd"></select></td>
			</tr>
			<tr>
				<th style="width:150px;">휴가구분</th>
				<td><select id="searchGntCd" name="searchGntCd" disabled class="transparent hideSelectButton "></select></td>
			</tr>
			<tr id="tr1" style="display:none;">
				<th>기준년월</th>
				<td><input type="text" id="searchYear" name="searchYear" class="date2 required center"  value=""/></td>
			</tr>
			<tr id="tr3" style="display:none;">
				<th>입사월</th>
				<td><input type="text" id="searchYm" name="searchYm" class="date2 required center"  value=""/></td>
			</tr>
			<tr id="tr7" style="display:none;">
				<th>기준일자</th>
				<td><input type="text" id="searchYmd" name="searchYmd" class="date2 required center"  value=""/></td>
			</tr>
			<tr>
				<td style="text-align: center;" colspan="2">
					<a href="javascript:annualCreate()" class="button authA large">생 성</a>
				</td>
			</tr>
		</table>
	</form>
	
	
	
	<table style="width:100%;" class="hide">
		<tr>
		<td class="bottom">
		<div class="explain">
			<div class="title">설명</div>
			<div class="txt">
			<ul>
				<li>1. 휴가생성을 매뉴얼로 실행하기 위한 화면입니다.</li>
				<li>2. 기준일, 사번/성명을 선택하시고 생성 버튼을 클릭하여 휴가를 생성합니다.</li>
				<li>3. 기준일 시점까지의 사용휴가와 발생휴가를 고려하여 휴가가 발생됩니다.</li>
			</ul>
			</div>
		</div>
		</td>
	</tr>
	</table>
</div>
</body>
</html>