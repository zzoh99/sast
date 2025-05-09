<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp" %>
<!DOCTYPE html><html><head><title>후임자등록</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>
<style>
	/*---- checkbox ----*/
	input[type="checkbox"]  { 
		display: inline-block;
		width: 20px;
		height: 20px;
		appearance: none; -moz-appearance: checkbox; -webkit-appearance: checkbox;
		margin-top: 2px;
		margin-right: 2px;
		background: none;
		cursor: pointer;
	}
	.incomTable { margin-bottom: 10px; }
	.incomTable th { border-right: none !important; }
	.incomTable td { border-left: 1px solid #e7edf0; }
</style>
<!-- 
	후보자 3명의 양식이 같으므로 for문 처리.
	id, name 값 맨 뒤에는 1~3으로 세팅 후 함수 모듈화. ex) clearAll
 -->
<script type="text/javascript">
	var curSeq 				= 1;
	var incomIdArr 			= new Array();
	var extIncomYnArr 		= new Array();
	var incomTimeArr 		= new Array();
	var incomPathArr 		= new Array();
	var incomOutArr 		= new Array();
	var incomImpactArr 		= new Array();
	var incomRsnArr 		= new Array();
	var incomProsArr 		= new Array();
	var incomConsArr 		= new Array();
	
	// 부모 iframe 높이값 계산
	var parentHeight = function() {
		var _height = 0;
		$(".ui-tabs-panel", parent.document).each(function(idx, item){
			if( $(item).css("display") != "none" ) {
				_height = $("iframe", item).outerHeight();
				return false;
			}
		});
		return _height;
	};

	$(function() {
		
		// 외부영입여부 체크박스 이벤트
		$("input.extIncomYn").on("change", function() {
			var $this = $(this), idx = $("input.extIncomYn").index($this), $root = $(".incomTable").eq(idx), seq = $root.attr("seq");
			var isContinue = true;
			if( $this.is(":checked") ) {
				// 후임자가 설정되어 있는 경우 삭제 진행 여부 확인
				if( $root.find(".incomId").text() != "" ) {
					isContinue = false;
					if(confirm("기존에 입력된 내용이 삭제됩니다.\n진행하시겠습니까?")) {
						isContinue = true;
					}
				}
				if( isContinue ) {
					$(".btn_search_incom, .btn_clear_incom", $root).hide();
					// 해당 입력 폼 초기화
					clearAll(seq, true);
				} else {
					// 체크 해제 처리
					$(this).prop("checked", false);
				}
			} else {
				$(".btn_search_incom, .btn_clear_incom", $root).show();
				// 해당 입력 폼 초기화
				clearAll(seq, false);
			}
		});
		
		// 후임자 전체 수
		$("#incomCnt").val($(".incomTable").length);
		
		// 코드 조회
		var incomOut 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","CD1040"), "선택");
		var incomImpact = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","CD1041"), "선택");
		
		$(".incomOut").html(incomOut[2]);
		$(".incomImpact").html(incomImpact[2]);
		
		setTimeout(function() {
			setEmpPage();
			doResizeHeight();
			$(window).resize(doResizeHeight);
		}, 200);
	});
	
	function doAction1(sAction) {
		switch (sAction) {		
			case "Search":
				$("#incomDiv").find(".btn_search_incom, .btn_clear_incom").show();
				$("#incomDiv").find("input[type='text'], input[type='hidden'], textarea, select").val("");
				$("#incomDiv").find("input[type='checkbox']").prop("checked", false);
				$("#incomDiv").find("input, textarea").removeAttr("readonly", true);
				$("#incomDiv").find("select").removeAttr("disabled", true);
				$("#incomDiv").find("span").empty();
				
				var rv = ajaxCall( "${ctx}/IncomingReg.do?cmd=getIncomingRegList", $("#dataForm").serialize(), false);
				if( rv && rv != null && rv.DATA && rv.DATA != null && rv.DATA.length > 0 ) {
					$("#incomIdArr").val("");
					$("#extIncomYnArr").val("");
					$("#incomTimeArr").val("");
					$("#incomPathArr").val("");
					$("#incomOutArr").val("");
					$("#incomImpactArr").val("");
					$("#incomRsnArr").val("");
					$("#incomProsArr").val("");
					$("#incomConsArr").val("");
					
					var rootEle, incomSeq;
					for(var i = 0; i < rv.DATA.length; i++) {
						incomSeq = rv.DATA[i].incomSeq;
						rootEle  = $(".incomTable[seq='" + incomSeq + "']");
						
						if( rv.DATA[i].extIncomYn == "Y" ) {
							rootEle.find(".extIncomYn").prop("checked", true);
							rootEle.find(".btn_search_incom, .btn_clear_incom").hide();
							rootEle.find(".incomSelectButton").hide();
							rootEle.find(".incomClearButton" ).hide();
							clearAll(incomSeq, true);
						} else {
							clearAll(incomSeq, false);
							rootEle.find(".incomId"      ).text(rv.DATA[i].incomId);
							rootEle.find(".incomName"    ).text(rv.DATA[i].incomName);
							rootEle.find(".incomOrgNm"   ).text(rv.DATA[i].incomOrgNm);
							rootEle.find(".incomJikgubNm").text(rv.DATA[i].incomJikgubNm);
							rootEle.find(".incomTime"    ).val(rv.DATA[i].incomTime);
							rootEle.find(".incomPath"    ).val(rv.DATA[i].incomPath);
							rootEle.find(".incomOut"     ).val(rv.DATA[i].incomOut);
							rootEle.find(".incomImpact"  ).val(rv.DATA[i].incomImpact);
							rootEle.find(".incomRsn"     ).val(rv.DATA[i].incomRsn);
							rootEle.find(".incomPros"    ).val(rv.DATA[i].incomPros);
							rootEle.find(".incomCons"    ).val(rv.DATA[i].incomCons);
						}
					}
				}
				
				break;
			case "Save":
				incomIdArr 		= [];
				extIncomYnArr 	= [];
				incomTimeArr 	= [];
				incomPathArr 	= [];
				incomOutArr 	= [];
				incomImpactArr 	= [];
				incomRsnArr 	= [];
				incomProsArr 	= [];
				incomConsArr 	= [];
				
				var rootEle, incomId, extIncomYn, incomTime, incomPath, incomOut, incomImpact, incomRsn, incomPros, incomCons;
				$(".incomTable").each(function(idx, item, arr){
					rootEle     = $(this);
					extIncomYn  = rootEle.find("input[name='extIncomYn']").is(":checked");
					incomId     = rootEle.find(".incomId").text();
					incomTime   = rootEle.find("input[name='incomTime']").val();
					incomPath   = rootEle.find("input[name='incomPath']").val();
					incomOut    = rootEle.find("select[name='incomOut']").val();
					incomImpact = rootEle.find("select[name='incomImpact']").val();
					incomRsn    = rootEle.find("textarea[name='incomRsn']").val();
					incomPros   = rootEle.find("textarea[name='incomPros']").val();
					incomCons   = rootEle.find("textarea[name='incomCons']").val();
					
					//console.log('[SAVE] idx', idx, 'rootEle', rootEle, 'extIncomYn', extIncomYn);
					
					// push
					extIncomYnArr.push((extIncomYn) ? "Y" : "N");
					incomIdArr.push(incomId);
					incomTimeArr.push(incomTime);
					incomPathArr.push(incomPath);
					incomOutArr.push(incomOut);
					incomImpactArr.push(incomImpact);
					incomRsnArr.push(incomRsn);
					incomProsArr.push(incomPros);
					incomConsArr.push(incomCons);
				});
				
				$("#incomIdArr").val(incomIdArr);
				$("#extIncomYnArr").val(extIncomYnArr);
				$("#incomTimeArr").val(incomTimeArr);
				$("#incomPathArr").val(incomPathArr);
				$("#incomOutArr").val(incomOutArr);
				$("#incomImpactArr").val(incomImpactArr);
				$("#incomRsnArr").val(incomRsnArr);
				$("#incomProsArr").val(incomProsArr);
				$("#incomConsArr").val(incomConsArr);
				
				var rv = ajaxCall( "${ctx}/IncomingReg.do?cmd=saveIncomingReg",$("#dataForm").serialize(),false);
				if( rv && rv != null ) {
					alert(rv.Result.Message);
					doAction1("Search");
				}
				
				break;
		}
	}

	// 해당 후보순위의 데이터를 초기화한다.
	var clearAll = function(seq, isDisabled){
		var rootEle  = $(".incomTable[seq='" + seq + "']");
		rootEle.find(".incomId").text("");
		rootEle.find(".incomName").text("");
		rootEle.find(".incomOrgNm").text("");
		rootEle.find(".incomJikgubNm").text("");
		
		rootEle.find(".incomTime").val("");
		rootEle.find(".incomPath").val("");
		rootEle.find(".incomOut").val("");
		rootEle.find(".incomImpact").val("");
		rootEle.find(".incomRsn").val("");
		rootEle.find(".incomPros").val("");
		rootEle.find(".incomCons").val("");
		
		if( isDisabled == undefined || isDisabled == false ) {
			rootEle.find(".incomTime").removeAttr("readonly");
			rootEle.find(".incomPath").removeAttr("readonly");
			rootEle.find(".incomOut").removeAttr("disabled");
			rootEle.find(".incomImpact").removeAttr("disabled");
			rootEle.find(".incomRsn").removeAttr("readonly");
			rootEle.find(".incomPros").removeAttr("readonly");
			rootEle.find(".incomCons").removeAttr("readonly");
			rootEle.find(".extIncomYn").prop("checked", false);
		}
		
		// 기타 입력 폼 비활성화
		if( isDisabled == true ){
			rootEle.find(".incomTime").attr("readonly", true);
			rootEle.find(".incomPath").attr("readonly", true);
			rootEle.find(".incomOut").attr("disabled", true);
			rootEle.find(".incomImpact").attr("disabled", true);
			rootEle.find(".incomRsn").attr("readonly", true);
			rootEle.find(".incomPros").attr("readonly", true);
			rootEle.find(".incomCons").attr("readonly", true);
		}
	};
	
	var clearItem = function(seq) {
		$root = $(".incomTable[seq='" + seq + "']");
		var isContinue = true;
		// 후임자가 설정되어 있는 경우 삭제 진행 여부 확인
		if( $root.find(".incomId").text() != "" ) {
			isContinue = false;
			if(confirm("기존에 입력된 내용이 삭제됩니다.\n진행하시겠습니까?")) {
				isContinue = true;
			}
		}
		if( isContinue ) {
			// 해당 입력 폼 초기화
			clearAll(seq, false);
		}
	};
	
	function setEmpPage() {
		$("#searchSabun").val($("#searchUserId").val());
		doAction1("Search");
	}

	function employeePopup(searchGubun) {
		try {
			if(!isPopup()) {return;}
			gPRow = "";
			pGubun = searchGubun;
			<%--openPopup("${ctx}/Popup.do?cmd=employeePopup", args, "740","520");--%>

			let layerModal = new window.top.document.LayerModal({
				id : 'employeeLayer'
				, url : '/Popup.do?cmd=viewEmployeeLayer'
				, parameters : {}
				, width : 740
				, height : 520
				, title : '사원조회'
				, trigger :[
					{
						name : 'employeeTrigger'
						, callback : function(result){
							getReturnValue(result)
						}
					}
				]
			});
			layerModal.show();

		} catch(ex) { alert("Open Popup Event Error : " + ex); }
	}

	function getReturnValue(rv) {
		if( pGubun == "employeePopup" ) {
			var rootEle  = $(".incomTable[seq='" + curSeq + "']"); 
			rootEle.find(".incomId").text(rv.sabun);
			rootEle.find(".incomName").text(rv.name);
			rootEle.find(".incomOrgNm").text(rv.orgNm);
			rootEle.find(".incomJikgubNm").text(rv.jikweeNm);
		}
	}
	
	function openEmployeePopup(seq) {
		curSeq = seq;
		employeePopup("employeePopup");
	}
	
	// 브라우저에 따른 특정 영역의 높이를 구한다.
	function doResizeHeight() {
		// 화면 높이 계산
		var contentHeight = parentHeight() - getOuterHeight() - 30;
		$("#incomDiv").css("height", contentHeight + "px");
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>
	
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="outer">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">후임자등록</li>
							<li class="btn">
<!-- 
								<span style="font-weight: bold;">
									2순위까지는 반드시 작성하여 주십시오. (성명이 없으면서 외부영입여부가 체크되지 않은 경우 삭제됩니다.)&nbsp;&nbsp;&nbsp;&nbsp;
								</span>
-->
								<a href="javascript:doAction1('Save');" class="button" >저장</a>
								<a href="javascript:doAction1('Search');" class="basic" >조회</a>
							</li>
						</ul>
					</div>
				</div>
			</td>
		</tr>
	</table>
	
	<form name="dataForm" id="dataForm" method="post">
		<input type="hidden" id="searchSabun" 			name="searchSabun" />
		<input type="hidden" id="incomCnt"	 			name="incomCnt" />
		<input type="hidden" id="incomIdArr" 			name="incomIdArr" />
		<input type="hidden" id="extIncomYnArr"			name="extIncomYnArr" />
		<input type="hidden" id="incomTimeArr" 			name="incomTimeArr" />
		<input type="hidden" id="incomPathArr" 			name="incomPathArr" />
		<input type="hidden" id="incomOutArr" 			name="incomOutArr" />
		<input type="hidden" id="incomImpactArr"		name="incomImpactArr" />
		<input type="hidden" id="incomRsnArr" 			name="incomRsnArr" />
		<input type="hidden" id="incomProsArr" 			name="incomProsArr" />
		<input type="hidden" id="incomConsArr" 			name="incomConsArr" />
		
		<div id="incomDiv" class="overflow_auto">
<c:forEach begin="1" end="3" var="cnt" step="1">
			<table border="0" cellpadding="0" cellspacing="0" class="default incomTable" seq="${cnt}">
				<colgroup>
					<col width="5%" />
					<col width="8%" />
					<col width="8%" />
					<col width="13%" />
					<col width="8%" />
					<col width="*" />
					<col width="8%" />
					<col width="*" />
					<col width="8%" />
					<col width="*" />
				</colgroup>
				<tr>
					<th rowspan="6" class="pad-x-10 alignC f_point">
						${cnt}순위
					</th>
					<th rowspan="6">
						<input type="checkbox" id="extIncomYn_${cnt}" name="extIncomYn" class="extIncomYn" value="Y" />
						<label for="extIncomYn_${cnt}" class="valignM">
							외부영입여부
						</label>
					</th>
					<th>성명</th>
					<td class="disp_flex justify_between alignItem_center">
						<div class="disp_flex justify_start alignItem_center h25">
							<span class="incomName"></span>
						</div>
						<div class="alignR mal10">
							<a onclick="javascript:openEmployeePopup('${cnt}');" class="btn_search_incom basic pad-x-6 f_point"><i class="fas fa-search"></i></a>
							<a onclick="javascript:clearItem('${cnt}');"     class="btn_clear_incom basic pad-x-6"><i class="fas fa-undo"></i></a>
						</div>
					</td>
					<th>사번</th>
					<td>
						<span class="incomId"></span>
					</td>
					<th>소속</th>
					<td>
						<span class="incomOrgNm"></span>
					</td>
					<th>직급</th>
					<td>
						<span class="incomJikgubNm"></span>
					</td>
				</tr>
				<tr>
					<th colspan="2" class="center">항목</th>
					<th colspan="2" class="center">선정사유(구체적으로)</th>
					<th colspan="2" class="center">장점</th>
					<th colspan="2" class="center">보완점</th>
				</tr>
				<tr>
					<th>승계소요시간</th>
					<td>
						<input type="text" name="incomTime" class="incomTime text w100p" placeholder="즉시 / OO년 이내" />
					</td>
					<td colspan="2" rowspan="4">
						<textarea name="incomRsn" rows="10" class="incomRsn w100p"></textarea>
					</td>
					<td colspan="2" rowspan="4">
						<textarea name="incomPros" rows="10" class="incomPros w100p"></textarea>
					</td>
					<td colspan="2" rowspan="4">
						<textarea name="incomCons" rows="10" class="incomCons w100p"></textarea>
					</td>
				</tr>
				<tr>
					<th>경력개발경로</th>
					<td>
						<input type="text" name="incomPath" class="incomPath text w100p" placeholder="OO 직무경험 필요" />
					</td>
				</tr>
				<tr>	
					<th>이탈가능성</th>
					<td>
						<select name="incomOut" class="incomOut w100p"></select>
					</td>
				</tr>
				<tr>	
					<th>이탈시 조직의<br>영향 정도</th>
					<td>
						<select name="incomImpact" class="incomImpact w100p"></select>
					</td>
				</tr>
			</table>
</c:forEach>
		</div>
	</form>
</div>
</body>
</html>
