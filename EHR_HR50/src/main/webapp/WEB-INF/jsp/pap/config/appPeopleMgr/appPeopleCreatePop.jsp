<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>평가대상자생성팝업</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("${popUpStatus}");
	var stepYn;
	$(function() {

		var arg = p.popDialogArgumentAll();

		 if( arg != undefined ) {
			$("#appraisalCd").val(arg["searchAppraisalCd"]);
			$("#appStepCd").val(arg["searchAppStepCd"]);
			$("#appBaseYmd").val(arg["searchDBaseYmdView"]);
		}

		$(".close, #close").click(function() {
			p.self.close();
		});


		var appStepCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppStepNm&searchAppraisalCd="+$("#appraisalCd").val()+"&searchAppStepCd="+$("#appStepCd").val(),false).codeList, "");
		$("#appStepNm").html(appStepCdList[2]);
		$("#appBaseYmdNm").html($("#appBaseYmd").val());
		$("#appBaseYmd").val($("#appBaseYmd").val().replace(/-/gi,''));

		if($("#appStepCd").val() == "1" || $("#appStepCd").val() == "3"){
			$("#p3").attr("disabled", true);
			$("#p4").attr("disabled", true);
			stepYn = true;
		}
	});

	function goProc(){

		var chkYn = false;

		$(".chk").each(function(index){
			if($(this).is(':checked')){
				if(index == 0){
					chkYn = true;
					if(confirm("평가대상자 생성 작업을 하시겠습니까? \n기존 셋팅된 데이터가 초기화 됩니다.")){
						showOverlay(0, "평가대상자 생성 중입니다.<br>잠시만 기다려주세요.");
						setTimeout(
							function(){
								var data = ajaxCall("/AppPeopleMgr.do?cmd=prcAppPeopleCreateMgr1",$("#mySheetForm").serialize(),false);
						    	if(data.Result.Code == null) {
									top.opener.doAction1("Search");
						    		alert("처리되었습니다.");
						    		hideOverlay();
						    	} else {
							    	alert("처리 중 오류가 발생했습니다.\n"+data.Result.Message);
						    		hideOverlay();
						    	}
							}
						, 100);
					}

				}else if(index == 1){
					chkYn = true;
					if(confirm("평가자 생성 작업을 하시겠습니까? \n기존 셋팅된 데이터가 초기화 됩니다.")){
						showOverlay(0, "평가자 생성 중입니다.<br>잠시만 기다려주세요.");
						setTimeout(
							function(){
								var data = ajaxCall("/AppPeopleMgr.do?cmd=prcAppPeopleCreateMgr2",$("#mySheetForm").serialize(),false);
						    	if(data.Result.Code == null) {
									top.opener.doAction1("Search");
						    		alert("처리되었습니다.");
						    		hideOverlay();
						    	} else {
							    	alert("처리 중 오류가 발생했습니다.\n"+data.Result.Message);
						    		hideOverlay();
						    	}
							}
						, 100);
					}

				}else if(index == 2){
					chkYn = true;
					if(confirm("평가그룹 생성 작업을 하시겠습니까? \n기존 셋팅된 데이터가 초기화 됩니다.")){
						showOverlay(0, "평가그룹 생성 중입니다.<br>잠시만 기다려주세요.");
						setTimeout(
							function(){
								var data = ajaxCall("/AppPeopleMgr.do?cmd=prcAppPeopleCreateMgr3",$("#mySheetForm").serialize(),false);
						    	if(data.Result.Code == null) {
									top.opener.doAction1("Search");
						    		alert("처리되었습니다.");
						    		hideOverlay();
						    	} else {
							    	alert("처리 중 오류가 발생했습니다.\n"+data.Result.Message);
						    		hideOverlay();
						    	}
							}
						, 100);
					}
				} else if (index == 3) {
					chkYn = true;
					if(confirm("평가그룹 맵핑 작업을 하시겠습니까? \n기존 셋팅된 데이터가 초기화 됩니다.")){
						showOverlay(0, "평가그룹 맵핑 중입니다.<br>잠시만 기다려주세요.");
						setTimeout(
							function(){
								var data = ajaxCall("/AppPeopleMgr.do?cmd=prcAppPeopleCreateMgr4",$("#mySheetForm").serialize(),false);
						    	if(data.Result.Code == null) {
									top.opener.doAction1("Search");
						    		alert("처리되었습니다.");
						    		hideOverlay();
						    	} else {
							    	alert("처리 중 오류가 발생했습니다.\n"+data.Result.Message);
						    		hideOverlay();
						    	}
							}
						, 100);
					}
				}
			}

		});

		if(!chkYn){
			alert("생성할 작업을 선택하세요");
		}
	}

	function chk2(idx){
		if(idx == "p1"){
			if( $( 'input[name="p1"]' ).is( ':checked' )){
				$("#p2").attr("disabled", true);
				$("#p3").attr("disabled", true);
				$("#p4").attr("disabled", true);
			}else{
				if(stepYn){
					$("#p2").attr("disabled", false);
				}else{
					$("#p2").attr("disabled", false);
					$("#p3").attr("disabled", false);
					$("#p4").attr("disabled", false);
				}
			}

		}else if(idx == "p2"){
			if( $( 'input[name="p2"]' ).is( ':checked' )){
				$("#p1").attr("disabled", true);
				$("#p3").attr("disabled", true);
				$("#p4").attr("disabled", true);
			}else{
				if(stepYn){
					$("#p1").attr("disabled", false);
				}else{
					$("#p1").attr("disabled", false);
					$("#p3").attr("disabled", false);
					$("#p4").attr("disabled", false);
				}
			}
		}else if(idx == "p3"){
			if( $( 'input[name="p3"]' ).is( ':checked' )){
				$("#p1").attr("disabled", true);
				$("#p2").attr("disabled", true);
				$("#p4").attr("disabled", true);
			}else{
				$("#p1").attr("disabled", false);
				$("#p2").attr("disabled", false);
				$("#p4").attr("disabled", false);
			}
		} else if (idx == "p4") {
			if ($('input[name="p4"]').is(':checked')) {
				$("#p1").attr("disabled", true);
				$("#p2").attr("disabled", true);
				$("#p3").attr("disabled", true);
			} else {
				$("#p1").attr("disabled", false);
				$("#p2").attr("disabled", false);
				$("#p3").attr("disabled", false);
			}
		}
	}

</script>
</head>
<body class="bodywrap">
		<form id="mySheetForm" name="mySheetForm" >
		<input type="hidden" name="appraisalCd" id="appraisalCd" />
		<input type="hidden" name="appStepCd" id="appStepCd" />
		<input type="hidden" name="appBaseYmd" id="appBaseYmd" />
		<input type="hidden" name="appSeqCd" id="appSeqCd" />
<div class="wrapper">
	<div class="popup_title">
	<ul>
		<li>평가대상자 생성</li>
		<li class="close"></li>
	</ul>
	</div>

	<div class="popup_main">

		<table class="table">
			<colgroup>
				<col width="20%" />
				<col width="20%" />
				<col width="60%" />
			</colgroup>
			<tr>
				<th align="center">평가단계</th>
				<td>
					<span id="appStepNm"></span>
				</td>
				<td rowspan="6">
				<span>평가단계별 대상자, 평가자, 평가그룹을 등록하는 화면입니다.<br/>
						작업순서:피평가자 > 평가자 > 평가그룹 생성 > 평가그룹 맵핑<br/>
						1. [피평가자]:기준일자를 기준으로 [피평가자]정보를 생성합니다.<br/>
						2. [평가자]:평가대상정의>평가조직관리 메뉴에 등록된 조직장을 기준으로<br/>
								      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1차와 2차 및 3차 평가자를 생성합니다.<br/>
								      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;평가조직관리에서 생성되는 조직장정보는 조직관리>조직종합관리의<br/>
								      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[조직장]탭에 등록된 정보를 바탕으로 생성된 결과입니다.<br/>						
						3. [평가그룹 생성]:기본적인 평가그룹을 생성합니다.<br/>
								      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;평가그룹 생성 전 반드시 피평가자가 생성되어 있어야 합니다.<br/>
								4. [평가그룹 맵핑]:평가그룹설정에서 설정된 평가그룹이 맵핑됩니다.  <br/>
								       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;최종평가단계에서만 사용됩니다.<br/>
								       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;주의 : [평가자]와 [평가그룹]은 정확한 대상자관리를 위하여 다음 대상자만 업데이트 합니다.<br/>
								       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;평가여부 : Y, 평가대상자확정여부 : N<br/>
								       </span>
				</td>
			</tr>
			<tr>
				<th>생성기준일</th>
				<td>
					<span id="appBaseYmdNm"></span>
				</td>
			</tr>
			<tr>
				<th>피평가자</th>
				<td>
					<input type="checkbox" id="p1" name="p1" value="" class="chk" onClick="chk2('p1');"/>
				</td>
			</tr>
			<tr>
				<th>평가자</th>
				<td>
					<input type="checkbox" id="p2" name="p2" value="" class="chk" onClick="chk2('p2');"/>
				</td>
			</tr>
			<tr>
				<th>평가그룹 생성</th>
				<td>
					<input type="checkbox" id="p3" name="p3" value="" class="chk" onClick="chk2('p3');"/>
				</td>
			</tr>
			<tr>
				<th>평가그룹 맵핑</th>
				<td>
					<input type="checkbox" id="p4" name="p4" value="" class="chk" onClick="chk2('p4');"/>
				</td>
			</tr>
		</table>
		<div class="popup_button">
			<ul>
				<li>
					<a href="javascript:goProc();" class="pink large">생성</a>
					<a href="javascript:p.self.close();" class="gray large">닫기</a>
				</li>
			</ul>
		</div>
	</div>
</div>
</form>
</body>
</html>