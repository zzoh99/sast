<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
	<!-- CSS -->
	<link href="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp5/css/style.css" rel="stylesheet" />
	<link href="${ctx}/common/js/contextmenu/jquery.contextMenu.css" rel="stylesheet" />
	<link href="${ctx}/common/css/theme/base/jquery-ui.css"rel="stylesheet" />

	<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
	<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<style type="text/css">
	.validateTips { border: 1px solid transparent; padding: 0.3em; }

	#dialog_detail_info > table > tbody > tr > td {
		padding-top: 5px;
	}

	.label_td {
		width : 120px;
	}
	
	.bg_sheet {background-color:#787878 !important;}
	
	.scrollBodyOrg, .scrollBodyEmp {
		display:block;
		width:400px;
		border-collapse: collapse;
		border:1px solid #ccc;
	}

	.scrollBodyOrg tbody, .scrollBodyEmp tbody {
		display:block;
		height:450px;
		overflow-x:hidden;
		overflow-y:scroll;
	}
	
	.scrollBodyOrg tbody tr td, .scrollBodyEmp tbody tr td {
		border-right:1px solid #eee;
		border-bottom:1px solid #eee;
	}
	.scrollBodyOrg tbody tr:last-child td, .scrollBodyEmp tbody tr:last-child td {
	}
	
	.scrollBodyOrg td, .scrollBodyEmp td {
		padding:5px 0 5px 15px;
	}

	.scrollBodyOrg th:nth-child(1), .scrollBodyOrg td:nth-child(1) {width:60px;}
	.scrollBodyOrg th:nth-child(2), .scrollBodyOrg td:nth-child(2) {width:100px;}
	.scrollBodyOrg th:last-child {width:200px;}
	.scrollBodyOrg td:last-child {width:calc(207px - 19px);}

	.scrollBodyEmp {width:700px;}
	.scrollBodyEmp th:nth-child(1), .scrollBodyEmp td:nth-child(1) {width:60px;}
	.scrollBodyEmp th:nth-child(2), .scrollBodyEmp td:nth-child(2) {width:114px;}	/* 이름 */
	.scrollBodyEmp th:nth-child(3), .scrollBodyEmp td:nth-child(3) {width:101px;}	/* 사번 */
	.scrollBodyEmp th:nth-child(4), .scrollBodyEmp td:nth-child(4) {width:71px;}	/* 직위 */
	.scrollBodyEmp th:nth-child(5), .scrollBodyEmp td:nth-child(5) {width:190px;}	/* 조직명 */
	.scrollBodyEmp th:last-child {width:66px;}	/* 재직여부 */
	.scrollBodyEmp td:last-child {width:calc(66px - 19px); border-right:none;}
	
	#btn_addNewOrg {
		z-index:10;
		position:absolute;
		bottom:10px;
		right:10px;
		display:inline-block;
		width:40px;
		height:40px;
		background-color:#808ea2;
		border:0;
		border-radius:100%;
		color:#fff;
		font-size:16px;
		font-weight:bold;
		line-height:32px;
		overflow:hidden;
	}
	#btn_addNewOrg span {
		display:inline-block;
		width:40px;
		height:40px;
		border-radius:20px;
		background-color:#808ea2;
		color:#fff;
		font-size:36px;
		font-weight:bold;
		line-height:40px;
		text-align:center;
		vertical-align:middle;
	}
	#btn_addNewOrg em {
		vertical-align:middle;
	}
	#btn_addNewOrg:hover {
		width:160px;
		height:48px;
		background-color:#003070;
		border:4px #003070 solid;
	}
	#btn_addNewOrg:hover span {
		background-color:#fff;
		color:#003070;
	}

	.button_blue {
		background-color: #2570f9;
		color: white !important;
		border: none;
		padding: 7px 16px;
		border-radius: 10px;
	}
	.selectNew {
		border-radius: 0;
		font-size: 12px;
		font-family: 'NotoSansKr', 'OpenSans';
		/* height: 35px; */
		border-radius: 8px;
		padding: 2px 8px !important;
		cursor: pointer;
		color: #9f9f9f;
		background-image: url('../assets/images/expand_more.png');
		background-repeat: no-repeat;
		background-position: calc(100% - 4px) center;
		background-size: 25px 25px;
		color: #323232;
		padding-right: 30px !important;
	}
	.context-menu-icon::before {
		transform: translate(-10%, -50%);
	}
	.context-menu-icon.context-menu-hover:before {
		color: #2980b9;
	}
	.ui-dialog .ui-dialog-titlebar-close .ui-icon-closethick{
		text-indent:0;
	}
	.ui-dialog .ui-dialog-titlebar-close .ui-icon-closethick::before { 
	    content:'\e5cd';
	    font-family: 'Material Icons Round Regular';
	    font-size: 16px;
	    color: #777777;
	}
	
</style>

<script src="${ctx}/common/js/contextmenu/orgSchemeSimulation/jquery.contextMenu.js?=3" type="text/javascript" charset="utf-8"></script>
<!-- IBOrg# 5 코어 -->
<script src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp5/iborginfo.js?=3" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp5/iborg.js?v=20250321" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp5/iborg2excel.js?=3" type="text/javascript" charset="utf-8"></script>

<!-- IBOrg# 5 관련 스크립트 -->
<script src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp5/lib/jquery.blockUI.js?=3" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/plugin/IBLeaders/Org/orgSchemeSimulation/contextMenuObj.js?v=20250324" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/plugin/IBLeaders/Org/orgSchemeSimulation/ibconfig.js?=3" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/plugin/IBLeaders/Org/orgSchemeSimulation/loadObj.js?=3" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/plugin/IBLeaders/Org/orgSchemeSimulation/btnObj.js?=3" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/plugin/IBLeaders/Org/orgSchemeSimulation/orgObj.js?v=20250324" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/plugin/IBLeaders/Org/orgSchemeSimulation/sheetObj.js?v=20250324" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/plugin/IBLeaders/Org/orgSchemeSimulation/dialogObj.js?v=20250324" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">
	var myOrg;
	var baseURL = "${baseURL}";
	var pGubun = "";
	
	/*
	 * iborg 조직도 뷰를 호출한다.
	 * 20170424 kwook.
	 */
	var p = eval("${popUpStatus}");
	
	var sdate1 = "${param.sdate}";
	var versionNm = "${param.versionNm}";
	var simulationInfoData = null;

	$(function() {
		if(versionNm == "undefined") versionNm = null;
		
		simulationInfoData = ajaxCall( "${ctx}/OrgChangeSchemeMgr.do?cmd=getSchemeSimulationInfo", "sdate="+sdate1, false );
		if(simulationInfoData != null && simulationInfoData.DATA != null) {
			$("#compYn").val(simulationInfoData.DATA.changeYn);
		}

		setCompBtn("");

		if(versionNm != null) {
			btnObj.init();
			orgObj.config.isConfirmed = $("#compYn").val();
			orgObj.init();
			sheetObj.init();
		} else {
			// 버전관리 팝업 출력
			p.goVerMgr();
		}
		
		$("#viewType").change(function(){
			var nodes = myOrg.nodes();
			if(nodes != null && nodes != undefined && nodes.length > 0) {
				for(var idx = 0; idx < nodes.length; idx++) {
					var key = nodes[idx].key;
					var item = myOrg.nodes(key);
					var template = item.template();
					
					//console.log('item', item.level());
					var changeTemplate = $(this).val();

					if(template.indexOf("_") > 0) {
						changeTemplate += template.substring(template.indexOf("_"), template.length);
					}
					
					item.template(changeTemplate);
				}
			}
		});
		
		$("#viewType").val("Org");
		
		// 확정 상태인 경우
		if(orgObj.config.isConfirmed == "Y") {
			
			// 저장 버튼 화면 미출력
			$("#btn__save").hide();
			
			// 조회 버튼 화면 미출력
			$("#btn__search").hide();
			
			// 시트 보기 버튼 화면 미출력
			$("#btn__view_sheet").hide();
			
			// [Tip], [신규 추가] 버튼 화면 미출력
			$("#btnTip, #btn_addNewOrg").hide();
		
		}

		if(versionNm != null) {
			// 조직도 초기 설정에 필요한 시간 이후 조회하도록 Timeout을 설정함.
			// 원래는 orgObj.init() 처리 후 doAction을 실행하도록 해야하지만,
			// 다른 개발자들이 기본 조회 부분을 찾기 어려울수 있어서 부득이하게 Timeout을 걸어놓음.
			setTimeout(function() {
				orgSearch();
			}, 200);
		}

		$("#searchKeyword").bind("keyup",function(event){
			if( event.keyCode == 13){
				$(this).blur();
		 		dialogObj.empSearch();
			}
		});
		
	});

	//결과값을 넘겨준다.
	function returnResult() {
 		var rv = new Array();
		p.popReturnValue(rv);
	}

	// 버전 관리 클릭시 이벤트
	function goVerMgr() {
		if(!isPopup()) {return;}

		pGubun = "versionMgrPopup";

		var args = new Array();
		args["sdate"] = sdate1;
		args["compYn"] = $("#compYn").val();

		var rv = openPopup("/Popup.do?cmd=viewOrgChangeVerMgrPopup&authPg=${authPg}", args, "900","620");
	}

	// 조회 시 조직도 조회
	function orgSearch() {
		var sdate = sdate1;
		
		// 조회중 표시를 위한 Block 영역 생성
		loadObj.showBlockUI();

		orgObj.ClearData();

		// 트리 데이터 삭제
		mySheet.RemoveAll();

		// 레벨 정렬 체크기능 확인
		orgObj.UseLevelAlign(1);


		// 트리로 조직 데이터 조회
		// 트리(시트)에서 조회 완료 후, 조직도 모듈에서 데이터를 생성하게 처리함.
		mySheet.DoSearch("${ctx}/OrgChangeSchemeMgr.do?cmd=getOrgView", "sdate="+sdate+"&versionNm="+versionNm );

		// 조직도 재조회
	}

	// 조직도 확정 여부에 따라 버튼 세팅
	function setCompBtn(yn) {
		if(yn == "") { // 미리 세팅된 조직도 확정여부가 없을 경우.
			var cnt = ajaxCall("${ctx}/OrgChangeSchemeMgr.do?cmd=getChkConfYn", "sdate="+sdate1, false).DATA.cnt;
			if(cnt == 0)
				$("#compYn").val('N');
			else
				$("#compYn").val('Y');
		} else if(yn == "Y") {
			$("#compYn").val('Y');  // 조직도 확정으로 세팅
		} else if(yn == "N") {
			$("#compYn").val('N');  // 조직도 미확정으로 세팅
		}

		var compYn = $("#compYn").val();
		if(compYn == "Y") {
			// 확정 또는 확정취소 버튼 세팅
			$("#confirm").hide();
			$("#confCancel").show();
			
			// iborg contextmenu 비활성화 세팅
			menu.node.appendChild.disabled = true;
			menu.node.closeNode.disabled = true;
			menu.node.detailInfo.disabled = true;
			
			/*
			// 상세정보 팝업 비활성화 세팅
			var ddi = $("#dialog_detail_info");
			ddi.find("#changeGubun").prop("disabled", true);

			// input들 모두 readonly로 세팅.
			ddi.find("input").each(function(idx, obj) {
				$(obj).prop("readonly", true);
				$(obj).addClass("readonly");
			});

			// 팝업 띄우는 버튼 숨기기
			ddi.find("#btnSabunPop3").hide();
			ddi.find("#priorOrgNmAfter").removeClass("w70p");
			ddi.find("#priorOrgNmAfter").addClass("w100p");
			ddi.find("#chiefNmAfter").removeClass("w70p");
			ddi.find("#chiefNmAfter").addClass("w100p");
			*/
		}
		else {
			$("#confirm").show();
			$("#confCancel").hide();
			
			// iborg contextmenu 활성화 세팅
			menu.node.appendChild.disabled = false;
			menu.node.closeNode.disabled = false;
			menu.node.detailInfo.disabled = false;

			/*
			var ddi = $("#dialog_detail_info");
			ddi.find("#changeGubun").prop("disabled", false);
			ddi.find("#btnSabunPop3").show();
			ddi.find("#priorOrgNmAfter").removeClass("w100p");
			ddi.find("#priorOrgNmAfter").addClass("w70p");
			ddi.find("#chiefNmAfter").removeClass("w100p");
			ddi.find("#chiefNmAfter").addClass("w70p");
			*/
		}
		
	}

	// 조직도 저장
	function orgSave(){
		if(confirm("저장하시겠습니까?")) {
			if(mySheet.IsDataModified()) {
				loadObj.showBlockUI();
				IBS_SaveName(document.paramFrm,mySheet);
				mySheet.DoSave( "${ctx}/OrgChangeSchemeMgr.do?cmd=saveOrgChangeView", $("#paramFrm").serialize(), -1, 0);
			} else {
				alert('저장할 내역이 없습니다.');
			}
		}
	}

	function getSaveJson(){

		var SaveJson = mySheet.GetSaveJson();
		//console.log( JSON.stringify( SaveJson ) );
		
	}

	// 시트 화면 출력
	function viewSheet() {
		if($("#sheetBox").is(":visible")) {
			$("#sheetDiv").hide();
			$("#sheetBox").slideUp();
			$("#btn__view_sheet").text("View Sheet");
			$("#btn__view_sheet").removeClass("bg_sheet");
		} else {
			$("#sheetBox").css({
				"width" : "calc(100% - 80px)",
				"height" : "calc(100vh - 194px)"
			});
			$("#sheetDiv").css({
				"width" : "100%",
				"height" : "100%",

			});
			$("#sheetDiv").show();
			$("#sheetBox").slideDown();
			$("#btn__view_sheet").text("Hidden Sheet");
			$("#btn__view_sheet").addClass("bg_sheet");
		}
	}
	
	// 시트 변경 여부 출력
	function printModifySheet() {
		var insertCnt = mySheet.RowCount("I");
		var updateCnt = mySheet.RowCount("U");
		var deleteCnt = mySheet.RowCount("D");
		var modified = ((insertCnt + updateCnt + deleteCnt) > 0) ? true : false;
		if ( modified ){
			$("#td_diff_text").text("변경 사항이 있습니다.");
		}else {
			$("#td_diff_text").text("");
		}
	}
	
	// 변경 여부
	function isChange() {
		if($("#td_diff_text").text().length > 0) {
			return true;
		}
		return false;
	}
	
</script>
</head>
<body class="bodywrap">
	<form id="paramFrm" name="paramFrm" >
		<input id="gubun" name="gubun" type="hidden" value="">
		<input id="sdate" name="sdate" type="hidden" value="">
		<input id="compYn" name="compYn" type="hidden" value="">
	</form>
	
	<div class="wrapper">
		<div class="sheet_title" style="padding:0px 20px;">
			<ul>
				<li class="txt big">개편안작성[조직]</li>
				<li class="btn">
					<span id="td_diff_text" class="f_blue strong valignM"></span>
					<span class="valignM">출력형식</span>
					<select class="selectNew" id="viewType" name="viewType">
						<option value="Org2">가로</option>
						<option value="Org">가로[+조직장](Default)</option>
						<option value="VertOrg">세로</option>
						<option value="VertLeader">세로[+조직장]</option>
					</select>
					<a href="javascript:orgSave();" id="btn__save" class="btn filled">저장</a>
					<a href="javascript:orgSearch();" id="btn__search" class="btn outline_gray">조회</a>
					<a href="javascript:viewSheet();" id="btn__view_sheet" class="btn outline">Sheet View</a>
				</li>
			</ul>
		</div>
	</div>
	
	<div id="sheetBox" style="z-index:1000; position:fixed; top:60px; right:40px; display: none; padding:10px; background-color:#787878; border:2px #787878 solid; border-radius:5px 0 5px 5px; box-sizing: border-box;">
		<div id="sheetDiv" style="width:100%; height:100%;"></div>
	</div>
	
	<div id="body">
		<div class="contents">
			<div id="orgDiv" style="position:fixed; top:80px; left:1px; right:0px; bottom:0px; height:100%;"></div>
		</div>
	</div>


<!-- [Dialog] 조직 조회 -->
	<div id="dialog_search_org" title="조직 조회" style="display:none;">
		<input type="hidden" id="pGubun" name="pGubun" />
		<p class="validateTips">조직을 선택해 주십시오.</p>
		<table class="scrollBodyOrg">
			<thead>
				<tr>
					<th>선택</th>
					<th>부서코드</th>
					<th>조직명</th>
				</tr>
			</thead>
			<tbody>
			</tbody>
		</table>
	</div>
<!-- [Dialog] 조직 조회 End -->


<!-- [Dialog] 조직원 조회 -->
	<div id="dialog_search_emp" title="조직원 조회" style="display:none;">
		<p class="validateTips">조직원을 검색 후 [선택] 버튼을 클릭해 주십시오.</p>
		<div class="alignR" style="padding-bottom:5px;">
			<form id="empSearchForm" name="empSearchForm">
				<input type="hidden" id="pGubun" name="pGubun" />
				<input type="hidden" id="searchStatusCd" name="searchStatusCd" value="RA"/>
				<input type="hidden" id="searchEmpType" name="searchEmpType" value="P"/> <!-- 팝업에서 사용 -->
				<input type="text" id="searchKeyword" name="searchKeyword" class="text w200" style="ime-mode:active;" />
				<a href="javascript:dialogObj.empSearch();" class="button" style="display:inline-block">조회</a>
			</form>
		</div>
		<table class="scrollBodyEmp">
			<thead>
				<tr>
					<th>선택</th>
					<th>이름</th>
					<th>사번</th>
					<th>직위</th>
					<th>조직명</th>
					<th>재직여부</th>
				</tr>
			</thead>
			<tbody>
			</tbody>
		</table>
	</div>
<!-- [Dialog] 조직원 조회 End -->


<!-- [Dialog] 하위조직추가 -->
	<div id="dialog_append_child" class="dialog-wrapper" title="하위부서 추가" style="display:none;">
		<p class="validateTips f_point strong">하위추가 후 [상세정보]를 통해 추가사항을 입력할 수 있습니다.</p>
		<p class="mat10">
			<label for="chkNew"><input type="checkbox" name="chkNew" id="chkNew" class="form-checkbox" onclick="javascript:dialogObj.toggleAppendMode(this);" /> 신규 조직</label>
		</p>
		<table class="default mat10">
			<tr>
				<td class="label_td" style="padding:5px;">
					<label for="name">조직코드</label>
				</td>
				<td style="padding:5px;">
					<input type="text" name="orgCd" id="orgCd" value="" class="text ui-widget-content ui-corner-all required w70p" />
					<a onclick="javascript:dialogObj.orgBasicPopup(0);" href="#" class="button6" id="btnSabunPop0"><img src="/common/images/icon/icon_search.png"/></a>
				</td>
			</tr>
			<tr>
				<td class="label_td" style="padding:5px;">
					<label for="orgNm">조직명</label>
				</td>
				<td style="padding:5px;">
					<input type="text" name="orgNm" id="orgNm" value="" class="text ui-widget-content ui-corner-all required w80p" />
				</td>
			</tr>
		</table>
		<table class="default" style="border-top:none; display:none;" id="input_etc">
			<tr>
				<td class="label_td" style="padding:5px;">
					<label for="orgEngNm">영문조직명</label>
				</td>
				<td style="padding:5px;">
					<input type="text" name="orgEngNm" id="orgEngNm" value="" class="text ui-widget-content ui-corner-all required w80p" />
				</td>
			</tr>
			<tr>
				<td class="label_td" style="padding:5px;">
					<label for="priorOrgNm">상위조직</label>
				</td>
				<td style="padding:5px;">
					<input type="hidden" id="priorOrgCd" name="priorOrgCd" value="" />
					<input type="text" name="priorOrgNm" id="priorOrgNm" value="" class="text ui-widget-content ui-corner-all required w70p" readonly ></input>
					<a onclick="javascript:dialogObj.orgBasicPopup(1);" href="#" style="display:inline-block" class="button6" id="btnSabunPop"><img style="margin-left: 0px;" src="/common/images/icon/icon_search.png"/></a>
				</td>
			</tr>
			<tr>
				<td class="label_td" style="padding:5px;">
					<label for="name">조직장</label>
				</td>
				<td style="padding:5px;">
					<input type="hidden" id="chiefSabun" 	name="chiefSabun"  value="" />
					<input type="hidden" id="chiefPositionNm" 	name="chiefPositionNm"  value="" />
					<input type="text" 	 id="chiefNm"		name="chiefNm"  value="" class="text ui-widget-content ui-corner-all w70p readonly" readonly="readonly" />
					<a onclick="javascript:dialogObj.empBasicPopup(1);" href="#" style="display:inline-block" class="button6" id="btnChiefPop1"><img style="margin-left: 0px;" src="/common/images/icon/icon_search.png"/></a>
					<a onclick="javascript:dialogObj.resetChief(1);" href="#" style="display:inline-block" class="button6" id="btnChiefDel1"><img style="margin-left: 0px;" src="/common/images/icon/icon_x.png"/></a>
				</td>
			</tr>
		</table>
	</div>
<!-- [Dialog] 하위조직추가 End -->


<!-- [Dialog] 상세정보 -->
	<div id="dialog_detail_info" title="상세정보" style="display:none;">
		<p class="validateTips f_point strong">조직의 상세정보를 변경/확인 합니다.</p>
		<table class="default mat10">
			<colgroup>
				<col width="150px" />
				<col width="200px" />
				<col width="150px" />
				<col width="200px" />
			</colgroup>
			<tr>
				<td class="label_td">
					<label for="orgCd">조직코드</label>
				</td>
				<td>
					<input type="text" name="orgCd" id="orgCd" value="" class="text ui-widget-content ui-corner-all w90p required readonly" readonly="readonly" />
					<input type="hidden" name="changeGubun" id="changeGubun" />
				</td>
				<td class="label_td">
					<label for="orgNm" style="margin-left: 10px;">조직명</label>
				</td>
				<td>
					<input type="text" name="orgNm" id="orgNm" value="" class="text ui-widget-content ui-corner-all w90p readonly" readonly="readonly" />
				<!-- 
					<select id="changeGubun" name="changeGubun" class="w150">
						<option value="">선택</option>
						<option value="1">신규</option>
						<option value="2">조직명변경</option>
						<option value="3">상위조직변경</option>
						<option value="4">폐지</option>
						<option value="5">통합</option>
						<option value="6">분할</option>
						<option value="7">조직장변경</option>
					</select>
				 -->
				</td>
			</tr>
			<tr class="hide">
				<td class="label_td">
					<label for="orgNmPre">조직명(변경전)</label>
				</td>
				<td>
					<input type="text" name="orgNmPre" id="orgNmPre" value="" class="text ui-widget-content ui-corner-all w90p readonly" readonly="readonly" />
				</td>
				<td class="label_td">
					<label for="orgNmAfter" style="margin-left: 10px;">조직명(변경후)</label>
				</td>
				<td>
					<input type="text" name="orgNmAfter" id="orgNmAfter" value="" class="text ui-widget-content ui-corner-all w90p readonly" readonly="readonly" />
				</td>
			</tr>

			<tr class="hide">
				<td class="label_td">
					<label for="orgEngNmPre">영문조직명(변경전)</label>
				</td>
				<td>
					<input type="text" name="orgEngNmPre" id="orgEngNmPre" value="" class="text ui-widget-content ui-corner-all w90p readonly" readonly="readonly" />
				</td>
				<td class="label_td">
					<label for="orgEngNmAfter" style="margin-left: 10px;">영문조직명(변경후)</label>
				</td>
				<td>
					<input type="text" name="orgEngNmAfter" id="orgEngNmAfter" value="" class="text ui-widget-content ui-corner-all w90p readonly" readonly="readonly" />
				</td>
			</tr>

			<tr>
				<td class="label_td">
					<label for="btnSabunPop2">상위조직(변경전)</label>
				</td>
				<td>
					<input type="hidden" id="priorOrgCdPre" 	name="priorOrgCdPre"  value="" />
					<input type="text" 	 id="priorOrgNmPre"		name="priorOrgNmPre"  value="" class="text ui-widget-content ui-corner-all w90p" readonly="readonly" />
					<!-- 
					<a onclick="javascript:dialogObj.orgBasicPopup(2);" href="#" class="button6" id="btnSabunPop2"><img src="/common/images/icon/icon_search.png"/></a>
					 -->
				</td>
				<td class="label_td">
					<label for="btnSabunPop3" style="margin-left: 10px;">상위조직(변경후)</label>
				</td>
				<td>
					<input type="hidden" id="priorOrgCdAfter" 	name="priorOrgCdAfter"  value="" />
					<input type="text" 	 id="priorOrgNmAfter"	name="priorOrgNmAfter"  value="" class="text ui-widget-content ui-corner-all w90p" readonly="readonly" />
					<!-- 
					<a onclick="javascript:dialogObj.orgBasicPopup(3);" href="#" class="button6" id="btnSabunPop3"><img src="/common/images/icon/icon_search.png"/></a>
					<a onclick="javascript:dialogObj.resetOrg(3);" href="#" class="button6" id="btnSabunPop3"><img src="/common/images/icon/icon_x.png"/></a>
					 -->
				</td>
			</tr>

			<tr>
				<td class="label_td">
					<label for="chiefNmPre">조직장(변경전)</label>
				</td>
				<td>
					<input type="hidden" id="chiefSabunPre" 		name="chiefSabunPre"  value="" />
					<input type="hidden" id="chiefPositionNmPre" 	name="chiefPositionNmPre"  value="" />
					<input type="text" 	 id="chiefNmPre"			name="chiefNmPre"  value="" class="text ui-widget-content ui-corner-all w90p readonly" readonly="readonly" />
					<!-- 
					<a onclick="javascript:dialogObj.empBasicPopup(2);" href="#" class="button6" id="btnChiefPop2"><img src="/common/images/icon/icon_search.png"/></a>
					 -->
				</td>
				<td class="label_td">
					<label for="btnSabunPop3" style="margin-left: 10px;">조직장(변경후)</label>
				</td>
				<td>
					<input type="hidden" id="chiefSabunAfter" 		name="chiefSabunAfter"  value="" />
					<input type="hidden" id="chiefPositionNmAfter" 	name="chiefPositionNmAfter"  value="" />
					<input type="text" 	 id="chiefNmAfter"			name="chiefNmAfter"  value="" class="text ui-widget-content ui-corner-all w90p" readonly="readonly" />
					<!-- 
					<a onclick="javascript:dialogObj.empBasicPopup(3);" href="#" class="button6" id="btnChiefPop3"><img src="/common/images/icon/icon_search.png"/></a>
					<a onclick="javascript:dialogObj.resetChief(3);" href="#" class="button6" id="btnChiefDel3"><img src="/common/images/icon/icon_x.png"/></a>
					 -->
				</td>
			</tr>
			<tr>
				<td class="label_td">
					<label for="vrtclOrderYn">하위조직 세로정렬여부</label>
				</td>
				<td>
					<input type="checkbox" id="vrtclOrderYn" name="vrtclOrderYn" value="Y"/>
				</td>
				<td class="label_td">
				</td>
				<td></td>
			</tr>
		</table>
	</div>
<!-- [Dialog] 상세정보 End -->


<!-- [Dialog] 상위조직변경 -->
	<div id="dialog_prior_change" title="상위조직변경" style="display:none;">
		<input type="hidden" name="orgCd" id="orgCd" />
		<table class="default mat10">
			<tr>
				<td class="label_td">
					<label>상위조직(변경전)</label>
				</td>
				<td>
					<input type="hidden" id="priorOrgCdPre" 	name="priorOrgCdPre"  value="" />
					<input type="text" 	 id="priorOrgNmPre"		name="priorOrgNmPre"  value="" class="text ui-widget-content ui-corner-all w100p" readonly="readonly" />
				</td>
				<td class="label_td">
					<label for="btnOrgPop4" style="margin-left: 10px;">상위조직(변경후)</label>
				</td>
				<td>
					<input type="hidden" id="priorOrgCdAfter" 	name="priorOrgCdAfter"  value="" />
					<input type="text" 	 id="priorOrgNmAfter"	name="priorOrgNmAfter"  value="" class="text ui-widget-content ui-corner-all w70p" readonly="readonly" />
					<a onclick="javascript:dialogObj.orgBasicPopup(4);" href="#" class="button6" id="btnOrgPop4"><img src="/common/images/icon/icon_search.png"/></a>
					<a onclick="javascript:dialogObj.resetOrg(4);" href="#" class="button6"><img src="/common/images/icon/icon_x.png"/></a>
				</td>
			</tr>
		</table>
	</div>
<!-- [Dialog] 하위조직추가 End -->


<!-- [Dialog] 조직장변경 -->
	<div id="dialog_chief_change" title="조직장변경" style="display:none;">
		<input type="hidden" name="orgCd" id="orgCd" />
		<table class="default mat10">
			<tr>
				<td class="label_td">
					<label>조직장(변경전)</label>
				</td>
				<td>
					<input type="hidden" id="chiefSabunPre" 		name="chiefSabunPre"  value="" />
					<input type="hidden" id="chiefPositionNmPre" 	name="chiefPositionNmPre"  value="" />
					<input type="text" 	 id="chiefNmPre"			name="chiefNmPre"  value="" class="text ui-widget-content ui-corner-all w100 readonly" readonly="readonly" />
				</td>
				<td class="label_td">
					<label for="btnEmpPop4" style="margin-left: 10px;">조직장(변경후)</label>
				</td>
				<td>
					<input type="hidden" id="chiefSabunAfter" 		name="chiefSabunAfter"  value="" />
					<input type="hidden" id="chiefPositionNmAfter" 	name="chiefPositionNmAfter"  value="" />
					<input type="text" 	 id="chiefNmAfter"			name="chiefNmAfter"  value="" class="text ui-widget-content ui-corner-all w100" readonly="readonly" />
					<a onclick="javascript:dialogObj.empBasicPopup(4);" href="#" class="button6" id="btnEmpPop4"><img src="/common/images/icon/icon_search.png"/></a>
					<a onclick="javascript:dialogObj.resetChief(4);" href="#" class="button6" id="btnResetChief4"><img src="/common/images/icon/icon_x.png"/></a>
					<label for="vacancyYn"><input type="checkbox" name="vacancyYn" id="vacancyYn" class="valignM" onclick="javascript:dialogObj.toggleChiefSearchBtn();" /> 공석</label>
				</td>
			</tr>
		</table>
	</div>
<!-- [Dialog] 조직장변경 End -->


<!-- [Dialog] 하위조직순서변경 -->
	<div id="dialog_order_change" title="하위조직순서변경" style="display:none;">
		<p class="validateTips f_point strong">마우스를 이용하여 조직을 선택 후 마우스키를 누른 상태로 위/아래로 움직여 순서를 변경합니다.</p>
		<div id="orderEditList" class="mat10" style="padding:20px;">
		</div>
	</div>
<!-- [Dialog] 하위조직순서변경 End -->


	<div id="btnTip" style="z-index:10; position:absolute; bottom:0; left:0; border:1px #666 solid; border-radius:0 5px 0 0; background:#666; color:#fff; padding:0 10px; cursor:pointer;" onclick="javascript:$(this).hide();$('#tipConts').slideDown();"><strong>Tip</strong></div>
	<div id="tipConts" style="z-index:15; position: fixed; background-color: #666; bottom: 0; left: 0; padding:5px 10px; z-index: 5; border-radius : 0 5px 0 0; height: 88px; border: #666 1px solid; color:#fff; cursor:pointer; display:none;" onclick="javascript:$('#tipConts').slideUp(100);$('#btnTip').show();">
		※[버전관리] 버튼을 클릭하여 여러 조직도 시안을 관리할 수 있습니다.
		<br/>
		※ 조직을 선택/드래그하여 조직 구조를 변경할 수 있습니다.
		<br/>
		※ <span class="f_red strong">Ctrl</span> 키를 누른 상태로 선택/드래그하는 경우 보다 정확히 조직을 옮길수 있습니다.
		<br/>
		※ 조직을 우클릭하여 속성을 변경하거나 하위조직을 추가할 수 있습니다.
		<!-- 
		<br/>
		※ 작업이 완료되면 [확정] 버튼을 클릭하여 조직개편안을 확정합니다.
		 -->
	</div>
	
	<a id="btn_addNewOrg" class="" style="cursor: pointer;" onclick="javascript:dialogObj.openNewOrgRegDialog(null);" title="신규 조직 추가">
		<span style="">+</span>
		<em>신규 조직 추가</em>
	</a>

</body>
</html>