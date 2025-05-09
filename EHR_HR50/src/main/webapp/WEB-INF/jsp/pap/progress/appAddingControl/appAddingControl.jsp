<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
	<script type="text/javascript">
	$(function() {
		$("#searchAppraisalCd").bind("change",function(event){

			//$("#btnCon").attr("disabled", true);
			//$("#btnClose").attr("disabled", true);
			//$("#btnCloseCancel").attr("disabled", true);

			$("#StdYn").attr("checked", false);
			$("#conYn").attr("checked", false);
			$("#controlYn").attr("checked", false);
			$("#moveYn").attr("checked", false);
			$("#finalKpiYn").attr("checked", false);
			$("#totGrdYn").attr("checked", false);
			$("#gradeYn").attr("checked", false);
			$("#closeYn").attr("checked", false);

			var data = ajaxCall("${ctx}/AppAddingControl.do?cmd=getAppAddingControlMap1", $("#srchFrm").serialize(), false);

			if (data != null && data.map != null) {
				$("#appTypeCd").val( data.map.appTypeCd );
				$("#totCnt").val( data.map.totCnt );
				$("#appCnt").val( data.map.appCnt );
				$("#exAppCnt").val( data.map.exAppCnt );
				$("#chkAppCnt1").val( data.map.chkAppCnt1 );
				$("#chkAppCnt2").val( data.map.chkAppCnt2 );

				/*
				if ( data.map.stdYn == "Y" ) {
					$("#StdYn").attr("checked", true);
					//$("#btnStd").removeAttr("disabled");
					$("#btnStd").hide();
					$("#btnStdCncl").show();
				} else {
					//$("#btnStdCncl").removeAttr("disabled");
					$("#btnStd").show();
					$("#btnStdCncl").hide();
				}
				*/

				if ( data.map.conYn == "Y" ) {
					$("#conYn").attr("checked", true);
					//$("#btnCon").removeAttr("disabled");
					$("#btnCon").hide();
					$("#btnConCncl").show();
					$("#btnMove").show();
				} else {
					//$("#btnConCncl").removeAttr("disabled");
					$("#btnCon").show();
					$("#btnConCncl").hide();
					$("#btnMove").hide();
					$("#btnTotGrd").hide();
					$("#btnGrade").hide();
					$("#btnGradeCncl").hide();
					$("#btnClose").hide();
					$("#btnCloseCancel").hide();
				}

				/*
				if ( data.map.controlYn == "Y" ) {
					$("#controlYn").attr("checked", true);
				}
				*/

				if ( data.map.moveYn == "Y" ) {
					$("#moveYn").attr("checked", true);
					$("#btnTotGrd").show();
				} else {
					$("#btnTotGrd").hide();
					$("#btnGrade").hide();
					$("#btnGradeCncl").hide();
					$("#btnClose").hide();
					$("#btnCloseCancel").hide();
				}

				/*
				if ( data.map.finalKpiYn == "Y" ) {
					$("#finalKpiYn").attr("checked", true);
				}
				*/

				if ( data.map.totalYn == "Y" ) {
					$("#totGrdYn").attr("checked", true);
				} else {
					$("#btnGrade").hide();
					$("#btnGradeCncl").hide();
					$("#btnClose").hide();
					$("#btnCloseCancel").hide();
				}

				if ( data.map.gradeYn == "Y" ) {
					$("#gradeYn").attr("checked", true);
					//$("#btnGrade").removeAttr("disabled");
					$("#btnGrade").hide();
					$("#btnGradeCncl").show();
				} else {
					//$("#btnGradeCncl").removeAttr("disabled");
					if ( data.map.totalYn == "Y" ) {
						$("#btnGrade").show();
					} else {
						$("#btnGrade").hide();
					}
					$("#btnGradeCncl").hide();
					$("#btnClose").hide();
					$("#btnCloseCancel").hide();
				}

				if ( data.map.closeYn == "Y" ) {
					$("#closeYn").attr("checked", true);
					//$("#btnCloseCancel").removeAttr("disabled");
					$("#btnCon").hide();
					$("#btnConCncl").hide();
					$("#btnMove").hide();
					$("#btnTotGrd").hide();
					$("#btnGrade").hide();
					$("#btnGradeCncl").hide();
					
					$("#btnClose").hide();
					$("#btnCloseCancel").show();
				} else {
					//$("#btnCon").removeAttr("disabled");
					//$("#btnClose").removeAttr("disabled");
					if ( data.map.gradeYn == "Y" ) {
						$("#btnClose").show();
					} else {
						$("#btnClose").hide();
					}
					$("#btnCloseCancel").hide();
				}
			}
			
		});

		var appraisalCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdList&searchAppTypeCd=A,B,C",false).codeList, ""); // 평가명
		$("#searchAppraisalCd").html(appraisalCdList[2]); //평가명
		$("#searchAppraisalCd").change();

	});

/*
	function doStd(cancelYnGugun) {
		var confirmMsg = (cancelYnGugun == "Y") ? "1차평가 후 표준화 작업을 실행 하시겠습니까?" : "1차평가 후 표준화 작업취소를 실행 하시겠습니까?";
		if (!confirm(confirmMsg)) return;
		
		$("#searchCancelYn").val(cancelYnGugun);
		
		var data = ajaxCall("${ctx}/AppAddingControl.do?cmd=prcAppAddingControl8", $("#srchFrm").serialize(), false);
		if (data.Result.Code == null) {
			alert("처리되었습니다.");
			$("#searchAppraisalCd").change();
			$("#btnStd").hide();
			$("#btnStdCncl").show();
			
			if (cancelYnGugun == "C") {	// 작업취소시
				$("#btnStd").show();
				$("#btnStdCncl").hide();
			}
		} else {
			alert(data.Result.Message);
		}
	}
*/

	// 평가결과집계 작업
	function doCon(cancelYnGugun) {
		var confirmMsg = (cancelYnGugun == "Y") ? "평가결과집계 작업을 실행 하시겠습니까?" : "평가결과집계 작업취소를 실행 하시겠습니까?";
		if (!confirm(confirmMsg)) return;
		
		if ($("#closeYn").prop("checked") == true) {
			alert("평가마감 되었습니다.");
			return;
		}
		
		if ($("#chkAppCnt2").val() > 0) {
			alert("주관부서가 2개이상 존재하는 인원이 있습니다. \n주관부서는  대상자당 1개 이어야 합니다. \n평가대상자 관리에서 확인 해주세요.");
			return;
		}
		
		$("#searchCancelYn").val(cancelYnGugun);
		
		var data = ajaxCall("${ctx}/AppAddingControl.do?cmd=prcAppAddingControl1", $("#srchFrm").serialize(), false);
		if (data.Result.Code == null) {
			alert("처리되었습니다.");
			$("#searchAppraisalCd").change();
			$("#btnCon").hide();
			$("#btnConCncl").show();
			
			if (cancelYnGugun=="C") {	// 작업취소시
				$("#btnCon").show();
				$("#btnConCncl").hide();
			}
		} else {
			alert(data.Result.Message);
		}
	}

/*
	// 평가조정계산 작업
	function doControl() {
		if (!confirm("평가조정계산 작업을 실행 하시겠습니까?")) {
			return;
		}
		
		if ($("#closeYn").prop("checked") == true) {
			alert("평가마감 되었습니다.");
			return;
		}
		
		if ($("#conYn").prop("checked") == false) {
			alert("평가집계 작업이 이루어지지 않았습니다");
			return;
		}
		
		var data = ajaxCall("${ctx}/AppAddingControl.do?cmd=prcAppAddingControl2", $("#srchFrm").serialize(), false);
		if (data.Result.Code == null) {
			alert("처리되었습니다.");
			$("#searchAppraisalCd").change();
		} else {
			alert(data.Result.Message);
		}
	}
*/

	// 부서이동평가자반영 작업
	function doMove() {
		if (!confirm("부서이동평가자반영 작업을 실행 하시겠습니까?")) {
			return;
		}
		
		if ($("#closeYn").prop("checked") == true) {
			alert("평가마감 되었습니다.");
			return;
		}
		
		if ($("#conYn").prop("checked") == false) {
			alert("평가집계 작업이 이루어지지 않았습니다");
			return;
		}
		
		var data = ajaxCall("${ctx}/AppAddingControl.do?cmd=prcAppAddingControl3", $("#srchFrm").serialize(), false);
		if (data.Result.Code == null) {
			alert("처리되었습니다.");
			$("#searchAppraisalCd").change();
		} else {
			alert(data.Result.Message);
		}
	}

/*
	// KPI최종결과반영 작업 - 사용안함(교촌꺼)
	function doTotal() {
		if (!confirm("KPI 최종결과반영 작업을 실행 하시겠습니까?")) {
			return;
		}
		
		if ($("#conYn").prop("checked") == false) {
			alert("평가집계 작업이 이루어지지 않았습니다");
			return;
		}
		
		var data = ajaxCall("${ctx}/AppAddingControl.do?cmd=prcAppAddingControl6", $("#srchFrm").serialize(), false);
		if (data.Result.Code == null) {
			alert("처리되었습니다.");
			$("#searchAppraisalCd").change();
		} else {
			alert(data.Result.Message);
		}
	}
*/

	// 종합평가합산 작업
	function doTotGrd() {
		if (!confirm("종합평가합산 작업을 실행 하시겠습니까?")) {
			return;
		}
		
		if ($("#closeYn").prop("checked") == true) {
			alert("평가마감 되었습니다.");
			return;
		}
		
		if ($("#conYn").prop("checked") == false) {
			alert("평가집계 작업이 이루어지지 않았습니다");
			return;
		}
		
		if ($("#moveYn").prop("checked") == false) {
			alert("부서이동평가자반영 작업이 이루어지지 않았습니다");
			return;
		}
		
		var data = ajaxCall("${ctx}/AppAddingControl.do?cmd=prcAppAddingControl7", $("#srchFrm").serialize(), false);
		if (data.Result.Code == null) {
			alert("처리되었습니다.");
			$("#searchAppraisalCd").change();
		} else {
			alert(data.Result.Message);
		}
	}

/*
	// 평가등급계산 작업
	function doGrade() {
		if (!confirm("평가등급계산 작업을 실행 하시겠습니까?")) {
			return;
		}
		
		if ($("#closeYn").prop("checked") == true) {
			alert("평가마감 되었습니다.");
			return;
		}
		
		if ($("#conYn").prop("checked") == false) {
			alert("평가집계 작업이 이루어 지지 않았습니다");
			return;
		}
		
		var data = ajaxCall("${ctx}/AppAddingControl.do?cmd=prcAppAddingControl4", $("#srchFrm").serialize(), false);
		if (data.Result.Code == null) {
			alert("처리되었습니다.");
			$("#searchAppraisalCd").change();
		} else {
			alert(data.Result.Message);
		}
	}
*/

	function doGrade(cancelYnGugun) {
		var confirmMsg = (cancelYnGugun == "Y") ? "최종등급적용 작업을 실행 하시겠습니까?" : "최종등급적용 작업취소를 실행 하시겠습니까?";
		if (!confirm(confirmMsg)) return;
		
		if ($("#closeYn").prop("checked") == true) {
			alert("평가마감 되었습니다.");
			return;
		}
		
		if ($("#conYn").prop("checked") == false) {
			alert("평가집계 작업이 이루어 지지 않았습니다");
			return;
		}
		
		if ($("#moveYn").prop("checked") == false) {
			alert("부서이동평가자반영 작업이 이루어지지 않았습니다");
			return;
		}
		
		if ($("#totGrdYn").prop("checked") == false) {
			alert("종합평가합산 작업이 이루어지지 않았습니다");
			return;
		}
		
		$("#searchCancelYn").val(cancelYnGugun);
		
		var data = ajaxCall("${ctx}/AppAddingControl.do?cmd=prcAppAddingControl4", $("#srchFrm").serialize(), false);
		if (data.Result.Code == null) {
			alert("처리되었습니다.");
			$("#searchAppraisalCd").change();
			$("#btnGrade").hide();
			$("#btnGradeCncl").show();
			
			if (cancelYnGugun == "C") {	// 작업취소시
				$("#btnGrade").show();
				$("#btnGradeCncl").hide();
			}
		} else {
			alert(data.Result.Message);
		}
	}

	// 평가마감
	function doClose() {
		if (!confirm("마감 작업을 실행 하시겠습니까?")) return;
		
		if ($("#conYn").prop("checked") == false) {
			alert("평가집계 작업이 이루어지지 않았습니다");
			return;
		}
		
		if ($("#moveYn").prop("checked") == false) {
			alert("부서이동평가자반영 작업이 이루어지지 않았습니다");
			return;
		}
		
		if ($("#totGrdYn").prop("checked") == false) {
			alert("종합평가합산 작업이 이루어지지 않았습니다");
			return;
		}
		
		if ($("#gradeYn").prop("checked") == false) {
			alert("평가등급계산 작업이 이루어지지 않았습니다");
			return;
		}
		
		var data = ajaxCall("${ctx}/AppAddingControl.do?cmd=prcAppAddingControl5", "searchGubun=S&" + $("#srchFrm").serialize(), false);
		if (data.Result.Code == null) {
			alert("처리되었습니다.");
			$("#searchAppraisalCd").change();
		} else {
			alert(data.Result.Message);
		}
	}

	//평가마감 취소
	function doCloseCancel() {
		if (!confirm("마감취소 작업을 실행 하시겠습니까?")) return;
		
		var data = ajaxCall("${ctx}/AppAddingControl.do?cmd=prcAppAddingControl5", "searchGubun=N&" + $("#srchFrm").serialize(), false);
		if (data.Result.Code == null) {
			alert("처리되었습니다.");
			$("#searchAppraisalCd").change();
		} else {
			alert(data.Result.Message);
		}
	}

	function showList(flag) {
		if (!isPopup()) {return;}
		
		var args = new Array();
		args["searchAppraisalCd"] 	= $("#searchAppraisalCd").val();
		args["searchGubun"] 		= flag;
		let layerModal = new window.top.document.LayerModal({
			id : 'appPeopleShowLayer'
			, url : '${ctx}/AppAddingControl.do?cmd=viewAppPeopleShowLayer'
			, parameters : args
			, width : 500
			, height : 520
			, title : "대상자보기"
			, trigger :[
				{
					name : 'appPeopleShowLayerTrigger'
					, callback : function(result){
					}
				}
			]
		});
		layerModal.show();
		<%--openPopup("${ctx}/AppAddingControl.do?cmd=viewAppPeopleShowPop", args, "500", "520");--%>
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
	<input type="hidden" id="appTypeCd" name="appTypeCd" />
	<input type="hidden" id="searchCancelYn" name="searchCancelYn" />

		<div class="sheet_title">
			<ul>
				<li class="txt">평가결과및집계마감</li>
			</ul>
		</div>

		<table class="table">
			<colgroup>
				<col width="15%" />
				<col width="15%" />
				<col width="15%" />
				<col width="*" />
			</colgroup>
			<tr>
				<th>평가명</th>
				<td colspan="3">
					<select id="searchAppraisalCd" name="searchAppraisalCd"></select>
				</td>
			</tr>
			<tr>
				<th>총인원</th>
				<td colspan="3">
					<input type="text" id="totCnt" name="totCnt" class="text transparent readonly" readonly>
				</td>
			</tr>
			<tr>
				<th>대상인원</th>
				<td>
					<input type="text" id="appCnt" name="appCnt" class="text transparent readonly" readonly>
				</td>
				<th>평가제외자</th>
				<td>
					<input type="text" id="exAppCnt" name="exAppCnt" class="text transparent readonly" readonly>
					<a href="javascript:showList(2)" class="btn outline_gray authA" id="btnShow">대상자보기</a>
				</td>
			</tr>
			<tr>
				<th>2개이상평가대상자</th>
				<td>
					<input type="text" id="chkAppCnt1" name="chkAppCnt1" class="text transparent readonly" readonly>
				</td>
				<th>주관부서가2개이상자</th>
				<td>
					<input type="text" id="chkAppCnt2" name="chkAppCnt2" class="text transparent readonly" readonly>
					<a href="javascript:showList(1)" class="btn outline_gray authA" id="btnShow">대상자보기</a>
				</td>
			</tr>
<%--
			<tr>
				<th>1. 1차평가 후 표준화작업</th>
				<td colspan="3">
					<input type="checkbox" id="StdYn" name="StdYn" class="checkbox" value="N" disabled style="margin-bottom:-7px;" />&nbsp;
					<!-- <a href="javascript:doCon()" class="basic authA" id="btnCon">작업</a> -->
					<a href="javascript:doStd('Y')" class="basic authA btnCloseClass" id="btnStd">작업</a>
                    <a href="javascript:doStd('C')" class="basic authA btnCloseClass" id="btnStdCncl">작업취소</a>
				</td>
			</tr>
--%>
			<tr>
				<th>1. 평가결과집계</th>
				<td colspan="3">
					<input type="checkbox" id="conYn" name="conYn" class="checkbox" value="N" disabled style="margin-bottom:-7px;" />&nbsp;
					<!-- <a href="javascript:doCon()" class="basic authA" id="btnCon">작업</a> -->
					<a href="javascript:doCon('Y')" class="btn outline_gray authA btnCloseClass" id="btnCon">작업</a>
                    <a href="javascript:doCon('C')" class="btn outline_gray authA btnCloseClass" id="btnConCncl">작업취소</a>
				</td>
			</tr>
<%-- 사용안함
			<tr>
				<th>2. 평가조정계산</th>
				<td colspan="3">
					<input type="checkbox" id="controlYn" name="controlYn" class="checkbox" value="N" disabled style="margin-bottom:-7px;" />&nbsp;
					<a href="javascript:doControl()" class="basic authA" id="btnControl">작업</a>
					
				</td>
			</tr>
--%>
			<tr>
				<th>2. 부서이동평가자반영</th>
				<td colspan="3">
					<input type="checkbox" id="moveYn" name="moveYn" class="checkbox" value="N" disabled style="margin-bottom:-7px;" />&nbsp;
					<a href="javascript:doMove()" class="btn outline_gray authA" id="btnMove">작업</a>
				</td>
			</tr>
<%--
			<tr>
				<th>KPI 최종결과반영</th>
				<td colspan="3">
					<input type="checkbox" id="finalKpiYn" name="finalKpiYn" class="checkbox" value="N" disabled style="margin-bottom:-7px;" />&nbsp;
					<a href="javascript:doTotal()" class="basic authA" id="btnTotal">작업</a>
				</td>
			</tr> 
--%>
 			<tr>
				<th>3. 종합평가합산</th>
				<td colspan="3">
					<input type="checkbox" id="totGrdYn" name="totGrdYn" class="checkbox" value="N" disabled style="margin-bottom:-7px;" />&nbsp;
					<a href="javascript:doTotGrd()" class="btn outline_gray authA" id="btnTotGrd">작업</a>&nbsp;&nbsp;평가반영비율관리 화면에서 설정한 비율대로 합산하되 설정에 없는 경우 기본값: 업적평가반영비율 50% / 역량평가반영비율 50%

				</td>
			</tr>
			<tr>
				<th>4. 최종등급적용</th>
				<td colspan="3">
					<input type="checkbox" id="gradeYn" name="gradeYn" class="checkbox" value="N" disabled style="margin-bottom:-7px;" />&nbsp;
					<!-- <a href="javascript:doGrade()" class="basic authA" id="btnGrade">작업</a>  -->
					<a href="javascript:doGrade('Y')" class="btn outline_gray authA btnCloseClass" id="btnGrade">작업</a>
                    <a href="javascript:doGrade('C')" class="btn outline_gray authA btnCloseClass" id="btnGradeCncl">작업취소</a>
				</td>
			</tr>
			<tr>
				<th>5.최종마감/마감취소</th>
				<td colspan="3">
					<input type="checkbox" id="closeYn" name="closeYn" class="checkbox" value="N" disabled style="margin-bottom:-7px;" />&nbsp;
					<a href="javascript:doClose()" class="btn outline_gray authA" id="btnClose">마감</a>
					<a href="javascript:doCloseCancel()" class="btn outline_gray authA" id="btnCloseCancel">마감취소</a>
				</td>
			</tr>
	</table>
	<table style="width:100%;">
		<tr>
		<td class="bottom">
		<div class="explain">
			<div class="title">작업내용</div>
			<div class="txt">
			<ul>
				<li>1. 평가결과를 집계 처리합니다.</li>
				<li>2. 부서이동평가자에 대해 반영 처리합니다.</li>
				<li>3. 종합평가 비율대로 합산 처리합니다.</li>
				<li>4. 조정등급을 반영한 최종 등급이 적용됩니다.</li> 
				<li>5. [마감] 처리를 통해 평가를 최종완료할 수 있습니다. </li>
<%/*
				<li>5. 1차평가 후 표준화작업 시행 시 계산방법</li>
				<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;① 평가 전체점수를 토대로 업적 평균 계산</li>
				<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;② 평가 전체점수를 토대로 업적 편차 계산</li>
				<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;③ 개인별 업적표준화작업(계산)</li>
				<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;④ 역량평균 계산 (소수 셋째자리에서 반올림)</li>
				<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;⑤ 역량편차 계산 (소수 셋째자리에서 반올림)</li>
				<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;⑥ 업적환산 계산(개인의 업적표준화 점수*전체역량편차+전체역량평균)</li>
				<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;⑦ 업적점수 계산(업적환산점수를 소수 셋째자리에서 반올림)</li>
				<!-- <li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;⑧ 업무협조도(원점수/25*7), 업무개선도(원점수/15*7)</li> -->
				<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;⑧ 계산</li>
				<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ■ 역량:업적 = 3:7</li>
				<!-- <li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ■ 역량:업적:업무협조도:업무개선도 = 30:56:7:7</li> -->
*/ %>				
			</ul>
			</div>
		</div>
		</td>
	</tr>
	</table>
	</form>
</div>
</body>
</html>