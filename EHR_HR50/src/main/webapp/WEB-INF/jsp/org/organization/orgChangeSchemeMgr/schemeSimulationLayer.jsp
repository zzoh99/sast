<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="hidden">
<head>
	<title>조직개편시뮬레이션</title>
	<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
	<style type="text/css">
		.w20p {width:20% !important}
		
		.pad5 {padding:15px !important;}
		
		.modal_body {
			background-color:#efefef;
			overflow-y: auto;
		}
		
		.tab_status {
		}
		.tab_status li {float:left !important;}
		.tab_status li a {
			min-width:160px;
			display:inline-block;
			text-align:center;
		}
		.tab_status li.item {
			width:160px !important;
			height:24px;
			position:relative;
			background:#fff;
			padding:0px !important;
			line-height:24px !important;
			font-size:13px;
			font-weight:normal;
			color:#f18d00;
		}
		.tab_status li.item:after {
			content:"";
			position:absolute;
			left:0;
			bottom:0;
			width:0;
			height:0;
			border-left:12px solid #efefef;
			border-top:12px solid transparent;
			border-bottom:12px solid transparent;
		}
		.tab_status li.item:before {
			content:"";
			position:absolute;
			right:0;
			bottom:0;
			width:0;
			height:0;
			border-left:12px solid #fff;
			border-top:12px solid #efefef;
			border-bottom:12px solid #efefef;
		}

		.tab_status li.item.on {
			background:#f7d518;
			color:#fff;
			font-weight:bold;
		}
		.tab_status li.item:first-child::after {
			border:none;
		}
		.tab_status li.item.on:before {
			border-left:12px solid #f7d518;
			border-top:12px solid #efefef;
			border-bottom:12px solid #efefef;
		}
		
		.tab_status li.item.on a {
			color:#fff !important;
		}
		.tab_status li.item.on:after {
			border-left:12px solid #efefef;
			border-top:12px solid transparent;
			border-bottom:12px solid transparent;
		}
		
		.tab_status li.item a.complate:after {
			content:"";
			position:absolute;
			right:10px;
			bottom:0;
			width:16px;
			height:16px;
			background-image:url('/common/images/icon/icon_ok.png');
			background-repeat: no-repeat;
			background-position: -2px -4px;
			background-size:16px;
		}

		.button_white {
			background-color: #FFFFFF;
			/*color: white !important;*/
			border: 1px solid #b3b3b3;
			padding: 7px 16px;
			border-radius: 10px;
		}

		.button_blue {
			background-color: #2570f9;
			color: white !important;
			border: none;
			padding: 7px 16px;
			border-radius: 10px;
		}

		.bSelect {
			padding: 5px;
			border: 1px solid #e0e2e5;
			font-size: 12px !important;
			border-radius: 0;
			font-size: inherit;
			font-family: inherit;
			color: inherit;
			-webkit-appearance: none;
		}

		.selectNew {
			border-radius: 0;
			font-size: 12px;
			/* height: 35px; */
			border-radius: 8px;
			padding: 8px !important;
			cursor: pointer;
			color: #9f9f9f;
			background-image: url('../assets/images/expand_more.png');
			background-repeat: no-repeat;
			background-position: calc(100% - 4px) center;
			background-size: 25px 25px;
			color: #323232;
			padding-right: 30px !important;
		}
	</style>
	<script type="text/javascript">
		var pGubun = "";
		var sdate1 = "";
		var preSrchVersion = "";
		var simulationInfoData = null;
		var changeYn = "N";
		
		$(function() {
			const modal = window.top.document.LayerModalUtility.getModal('schemeSimulationLayer');
			arg = modal.parameters;

			if( arg != undefined ) {
				sdate1 = arg.sdate;
			}
			
			// 탭화면 전환용 폼 생성
			$("<form></form>",{id:"iTabForm",name:"iTabForm",method:"post"}).appendTo('body');
			
			// 창닫기 이벤트
			$(".close").click(function() {
				closeCommonLayer('schemeSimulationLayer');
			});
			
			// 버전 콤보 셋팅
			initVersionCombo();
			
			simulationInfoData = ajaxCall( "${ctx}/OrgChangeSchemeMgr.do?cmd=getSchemeSimulationInfo", "sdate="+sdate1, false );
			if(simulationInfoData != null && simulationInfoData.DATA != null) {
				changeYn = simulationInfoData.DATA.changeYn;
				if(changeYn == "Y") {
					$("#btn__manage_verion").hide();
				}
			}
			
			$("#srchVersion")
			.focus(function(evt) {
				preSrchVersion = $(this).val();
			})
			.change(function(evt) {
				if(changeYn == "Y" || confirm("버전을 변경하시는 경우 작업하시던 내용을 잃어버릴 수 있습니다.\n작업하시던 내용이 있으신 경우 저장 후 실행 해주시기 바랍니다.\n\n버전을 변경하시겠습니까?")) {
					showDefaultPage();
				} else {
					$(this).val(preSrchVersion);
				}
			});

			// 전체화면출력
			modal.makeMini();
			modal.makeFull();

			// iframe size 조정
			setTimeout(function() {
				sheetResize();
			}, 200);

			viewTab('viewSchemeSimulationOrg');

		});
		
		// 버전 콤보 셋팅
		function initVersionCombo() {
			$("#srchVersion").html("");
			var orgVerData = ajaxCall("${ctx}/OrgChangeSchemeMgr.do?cmd=getOrgVerComboList", "sdate="+sdate1, false ).DATA;
			if(orgVerData != null && orgVerData != undefined && orgVerData.length > 0) {
				for(var i = 0; i < orgVerData.length; i++) {
					if(orgVerData[i].compYn == "Y") {
						$("#srchVersion").append("<option value=\"" + orgVerData[i].code + "\" selected=\"selected\">[확정] " + orgVerData[i].codeNm + "</option>");
					} else {
						$("#srchVersion").append("<option value=\"" + orgVerData[i].code + "\">" + orgVerData[i].codeNm + "</option>");
					}
				}
			}
		}
		
		// 기본화면 출력
		function showDefaultPage() {
			viewTab('viewSchemeSimulationOrg');
		}

		// 버전 관리 클릭시 이벤트
		function goVerMgr() {
			if(!isPopup()) {return;}
			pGubun = "versionMgrPopup";

			var args = new Array();
			args["sdate"] = sdate1;
			args["compYn"] = ($("#compYn").val() == "") ? "N" : $("#compYn").val();

			let layerModal = new window.top.document.LayerModal({
				id : 'versionMgrLayer'
				, url : "/Popup.do?cmd=viewOrgChangeVerMgrLayer&authPg=${authPg}"
				, parameters : args
				, width : 800
				, height : 620
				, title : '조직개편 버전관리'
				, trigger :[
					{
						name : 'versionMgrLayerTrigger'
						, callback : function(result){
							initVersionCombo();
							viewTab('viewSchemeSimulationOrg');
						}
					}
				]
			});
			layerModal.show();
		}
		
		// 출력된 탭에 수정된 내용이 있는지 확인
		function isChangeDataInTab() {
			try {
				var obj = document.getElementById("iTabFrame");
				var objDoc = obj.contentWindow || obj.contentDocument;
				var isChange = false;
				
				if(objDoc.isChange != null && objDoc.isChange != undefined) {
					isChange = objDoc.isChange();
				}
				return isChange;
			} catch (ex) {
				alert("[isChangeDataInTab] 탭 화면 체크 중 오류가 발생했습니다. : " + ex);
			}
		}
		
		// 선택 탭 화면 출력
		function viewTab(cmd) {
			var pageUrl = "/OrgChangeSchemeMgr.do";
			var versionNm = $("#srchVersion").val();
			var $formObj = $("#iTabForm");
			
			var isContinues = true;
			if(isChangeDataInTab() == true && !confirm("저장되지 않은 작업 내용이 있습니다.\n작업중인 내용을 저장하신 후 다시 시도해주십시오.\n\n저장하지 않고 계속 진행하시겠습니까?")) {
				isContinues = false;
			}
			
			if(isContinues) {
				if(cmd != null && cmd != '') {
					pageUrl += "?cmd=" + cmd;
					
					$formObj.html("");
					$formObj.append($('<input type="hidden" value="' + sdate1 + '" name="sdate" id="sdate" />'));
					$formObj.append($('<input type="hidden" value="' + $("#srchVersion option:selected", "#paramFrm").val() + '" name="versionNm" id="versionNm" />'));
					
					if(cmd == "schemeSimulationOrg") {
					}
					submitCall($formObj, "iTabFrame", "POST", pageUrl);
				}
				$(".tab_status .item").removeClass("on");
				let ward = cmd.replaceAll("view", "");
				let first = ward[0].toString().toLowerCase();
				ward = ward.slice(1, ward.length);
				$("#tab_" + (first + ward)).addClass("on");
			}
		}

		// 탭 높이 변경
		function sheetResize() {
			var conHeight = $(".modal_body").height() - $(".alignR").outerHeight(true) - 20;
			var conWidth = $(".modal_body").width();
			$("#iTabFrame").css("height", conHeight + "px");
			$("#iTabFrame").css("width", conWidth + "px");
		}

	</script>
</head>
<body class="bodywrap">
	<div class="wrapper modal_layer">
		<div class="modal_body">
			<div id="versionMgr" class="alignR">
				<ul class="tab_status">
					<li class="item">
						<a class="f_point complate">일자등록</a>
					</li>
					<li class="item" id="tab_schemeSimulationOrg">
						<a href="javascript:viewTab('viewSchemeSimulationOrg');" class="f_point">개편안작성 [조직]</a>
					</li>
					<li class="item" id="tab_schemeSimulationEmp">
						<a href="javascript:viewTab('viewSchemeSimulationEmp');" class="f_point">개편안작성 [인사]</a>
					</li>
					<li class="item" id="tab_schemeSimulationReOrgSta">
						<a href="javascript:viewTab('viewSchemeSimulationReOrgSta');" class="f_point">개편현황</a>
					</li>
					<li class="item" id="tab_schemeSimulationFinalConfirm">
						<a href="javascript:viewTab('viewSchemeSimulationFinalConfirm');" class="f_point">최종확인</a>
					</li>
					<!-- 
					<li class="item" id="tab_schemeSimulationProcessingLinkage">
						<a href="javascript:viewTab('schemeSimulationProcessingLinkage');" class="f_point">발령연계처리</a>
					</li>
					 -->
				</ul>
				<form id="paramFrm" name="paramFrm" >
					<input id="gubun" name="gubun" type="hidden" value="" />
					<input id="sdate" name="sdate" type="hidden" value="" />
					<input id="compYn" name="compYn" type="hidden" value="" />
					<input id="srchSDate" name="srchSDate" type="hidden" value="" />
					
					<span class="tGray valignM">버전</span>
					&nbsp;
					<select class="selectNew" id="srchVersion" name="srchVersion" class="w150 bSelect"></select>
<%--					<btn:a href="javascript:goVerMgr();" css="button btn_base" mid='verMgr' id="btn__manage_verion" mdef="버전관리"/>--%>
					<btn:a href="javascript:goVerMgr();" css="btn filled" mid='verMgr' id="btn__manage_verion" mdef="버전관리"/>
				</form>
			</div>
			<iframe name="iTabFrame" id="iTabFrame" src="" scrolling="no" marginwidth="0" marginheight="0" frameborder="0" class="mat15" style="border:1px #dedede solid; background:#fff;"></iframe>
		</div>
	</div>
</body>
</html>