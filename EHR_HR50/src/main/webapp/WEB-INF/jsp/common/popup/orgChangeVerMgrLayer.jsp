<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>조직개편 버전관리</title>
<style>
	.button_blue {
		background-color: #2570f9;
		display: inline-block;
		color: white !important;
		border: none;
		padding: 7px 16px;
		border-radius: 10px;
	}
</style>
<script type="text/javascript">
	var pGubun = "";
	var sdate = "";
	var compYn = "";
	var isEmptyVersion = false;
	
	$(function() {
		const modal = window.top.document.LayerModalUtility.getModal('versionMgrLayer');
		var arg = modal.parameters;

		sdate = arg.sdate;
		compYn = arg.compYn;
		$("#versionMgrLayerFrm #sdate").val(sdate);

		// 확정된 후에는 조직개편 버전관리의 수정이 불가능 함.
		var editYn = 0;
		$("#insert").hide();
		$("#orgCopy").hide();
		$("#verCopy").hide();
		$("#save").hide();
		if(compYn == 'N') {
			editYn = 1;
			$("#insert").show();
			$("#orgCopy").show();
			$("#verCopy").show();
			$("#save").show();
		}
		
		// 조직도 콤보 코드 목록 조회
		var orgComboList = convCode(ajaxCall("${ctx}/OrgChangeSchemeMgr.do?cmd=getOrgComboList", "", false ).DATA, "");
		$("#srchOrg").html(orgComboList[2]);


		createIBSheet3(document.getElementById('versionMgrLayerSht1-wrap'), "versionMgrLayerSht1", "100%", "100%", "${ssnLocaleCd}");
		
		//배열 선언
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, DataRowMerge:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
				{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
				{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0, InsertEdit:editYn, UpdateEdit:editYn },
				{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
				{Header:"<sht:txt mid='sdate' mdef='조직개편일자'/>",		Type:"Date",		Hidden:1,	Width:80,	Align:"Center",		ColMerge:0,		SaveName:"sdate",		KeyField:1,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
				{Header:"<sht:txt mid='versionNm' mdef='버전명'/>",		Type:"Text",		Hidden:0,	Width:200,	Align:"Center",		ColMerge:0,		SaveName:"versionNm",	KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:editYn,	InsertEdit:editYn,	EditLen:20 },
				{Header:"<sht:txt mid='insertSabunV1' mdef='입력자'/>",	Type:"Text",		Hidden:0,	Width:100,	Align:"Center",		ColMerge:0,		SaveName:"insertSabun",	KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:20 },
				{Header:"<sht:txt mid='insertDate' mdef='입력일자'/>",	Type:"Date",		Hidden:0,	Width:80,	Align:"Center",		ColMerge:0,		SaveName:"insertDate",	KeyField:1,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
				{Header:"<sht:txt mid='memoV4' mdef='메모'/>",			Type:"Text",		Hidden:0,	Width:200,	Align:"Center",		ColMerge:0,		SaveName:"memo",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:editYn,	InsertEdit:editYn,	EditLen:500 }
		];
		IBS_InitSheet(versionMgrLayerSht1, initdata);versionMgrLayerSht1.SetVisible(true);versionMgrLayerSht1.SetCountPosition(4);versionMgrLayerSht1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

		$(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");
		
		$("input[name=add_type]").bind("click", function(e){
			if($(this).attr("id") == "add_type_org") {
				$("#combo_org").removeClass("hide");
				$("#versionMgrLayerFrm #combo_version").addClass("hide");
			} else {
				$("#versionMgrLayerFrm #combo_version").removeClass("hide");
				$("#combo_org").addClass("hide");
			}
		});

		$(".close").click(function() {
			popupClose();
		});
	});

	/*Sheet Action*/
	function doAction1(sAction) {
		switch (sAction) {
			case "Search": 		//조회
				versionMgrLayerSht1.DoSearch( "${ctx}/OrgChangeSchemeMgr.do?cmd=getOrgChangeVerMgrList", $("#versionMgrLayerFrm").serialize() );
				break;
			case "Save":
				if(!dupChk(versionMgrLayerSht1,"sdate|versionNm|insertSabun|insertDate", true, true)){break;}
				IBS_SaveName(document.versionMgrLayerFrm,versionMgrLayerSht1);
				versionMgrLayerSht1.DoSave( "${ctx}/OrgChangeSchemeMgr.do?cmd=saveOrgChangeVerMgrList", $("#versionMgrLayerFrm").serialize() );
				break;
			case "OrgCopy":
				var Row = versionMgrLayerSht1.GetSelectRow();
				openOrgCopyPopup(Row);
				break;
			case "VerCopy":
				copyOrgVersion();
				break;
			case "Down2Excel":
				versionMgrLayerSht1.Down2Excel();
				break;
			case "addVersion":
				addVersion();
				break;
		}
	}

	// 	조회 후 에러 메시지
	function versionMgrLayerSht1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") alert(Msg);
			
			if(versionMgrLayerSht1.RowCount() == 0) {
				$("#add_type_org").attr("checked", "checked");
				$("#combo_org").removeClass("hide");
				$("#versionMgrLayerFrm #combo_version").addClass("hide");
				isEmptyVersion = true;
			} else {
				comboHtml = "";
				
				for(var i = 1; i < versionMgrLayerSht1.RowCount() + 1; i++) {
					var versionNm = versionMgrLayerSht1.GetCellValue(i, "versionNm");
					//alert(versionNm);
					comboHtml += '<option value="' + versionNm + '">' + versionNm + '</option>';
				}
				
				$("#versionMgrLayerFrm #srchVersion").html(comboHtml);
				$("#versionMgrLayerFrm #combo_version").removeClass("hide");
				$("#combo_org").addClass("hide");
				$("#add_type_version").attr("checked", "checked");
			}
			
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function versionMgrLayerSht1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			doAction1("Search");

		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	
	// 버전 추가
	function addVersion() {
		if($("input[name=versionNm]").val() == "") {
			alert("버전명을 입력해주십시오.");
			return;
		}
		
		if(versionMgrLayerSht1.RowCount() > 0) {
			var isAlreadyReg = false;
			for(var i = 1; i < versionMgrLayerSht1.RowCount() + 1; i++) {
				var versionNm = versionMgrLayerSht1.GetCellValue(i, "versionNm");
				if(versionNm == $("input[name=versionNm]").val()) {
					isAlreadyReg = true;
					break;
				}
			}
			
			if(isAlreadyReg) {
				alert("이미 등록되어 있는 버전명입니다.\n다시 입력해주십시오.");
				$("input[name=versionNm]").val('');
				$("input[name=versionNm]").focus();
				return;
			}
		}
		
		if($("input[name=add_type]:checked").attr("id") == "add_type_org") {
			if($("#srchOrg").val() == "" || $("#srchOrg").val() == undefined) {
				alert("복사 대상을 선택해주십시오.")
				return;
			}
		} else {
			if($("#versionMgrLayerFrm #srchVersion").val() == "" || $("#versionMgrLayerFrm #srchVersion").val() == undefined) {
				alert("복사 대상을 선택해주십시오.")
				return;
			}
		}
		
		if(confirm("버전을 추가하시겠습니까?")) {
			var versionNmTgt = $("input[name=versionNm]").val();
			var args = "";
			var callUrl = "";
			
			// 조직도를 기준으로 추가하는 경우
			if($("input[name=add_type]:checked").attr("id") == "add_type_org") {
				args += "sdateSrc=" + $("#srchOrg").val();
				args += "&sdateTgt=" + $("#sdate", "#versionMgrLayerFrm").val();
				args += "&versionNmTgt=" + versionNmTgt;
				callUrl = "${ctx}/OrgChangeSchemeMgr.do?cmd=callPrcCopyOrgView";
			} else {
				args += "sdate=" + $("#sdate", "#versionMgrLayerFrm").val();
				args += "&versionNmSrc=" + $("#versionMgrLayerFrm #srchVersion").val();
				args += "&versionNmTgt=" + versionNmTgt;
				callUrl = "${ctx}/OrgChangeSchemeMgr.do?cmd=callPrcCopyOrgVersion&authPg=${authPg}";
			}
			
			var result = ajaxCall(callUrl, args, false);
			if(result.Message != null && result.Message != "") {
				alert(result.Message);
			} else {
				if(isEmptyVersion) {
					isEmptyVersion = false;
					const modal = window.top.document.LayerModalUtility.getModal('versionMgrLayer');
					modal.fire('versionMgrLayerTrigger', {}).hide();
				}
				$("input[name=versionNm]").val('');
				doAction1("Search");
			}
		}
	}

	/**
	 * 조직도 복사 팝업 [사용안함]
	 */
	function openOrgCopyPopup(Row){
		if(!isPopup()) {return;}

  		var w 		= 500;
		var h 		= 300;
		var url 	= "${ctx}/Popup.do?cmd=viewOrgCopyPopup&authPg=${authPg}";
		var args 	= new Array();
		args["sdate"] 		= sdate;
		args["versionNm"]	= versionMgrLayerSht1.GetCellValue(Row, "versionNm");

		pGubun = "orgCopy";

		openPopup(url,args,w,h);
	}

	// 조직 버전 복사 [사용안함]
	function copyOrgVersion() {
		if(Row < 0) {
			alert("선택한 열이 없습니다.");
			return;
		}

		var versionNmTgt = prompt("버전명을 입력해주세요.", "");
		var Row = 0;
		if(versionNmTgt != null && versionNmTgt != undefined) {
			if(versionNmTgt != "") {
				var Row = versionMgrLayerSht1.GetSelectRow();

				if(Row != 0) {
					var args = "";
					args += "sdate=" + versionMgrLayerSht1.GetCellValue(Row, "sdate");
					args += "&versionNmSrc=" + versionMgrLayerSht1.GetCellValue(Row, "versionNm");
					args += "&versionNmTgt=" + versionNmTgt;
					var result = ajaxCall("${ctx}/OrgChangeSchemeMgr.do?cmd=callPrcCopyOrgVersion&authPg=${authPg}", args, false);
					if(result.Message != null && result.Message != "") {
						alert(result.Message);
					} else {
						doAction1("Search");
					}
				} else {
					alert("일치하는 버전명이 없거나, 저장된 상태가 아닙니다.");
				}
			} else {
				alert("버전명을 입력해주세요.");
			}
		}
	}

	function popupClose() {
		const modal = window.top.document.LayerModalUtility.getModal('versionMgrLayer');
		modal.fire('versionMgrLayerTrigger', {}).hide();
	}

	//팝업 콜백 함수.
	function getReturnValue(rv) {
		if(pGubun == "orgCopy"){
			doAction1("Search");
		}
	}

</script>


</head>
<body class="bodywrap">
	<div class="wrapper modal_layer">
		<div class="modal_body">
			<form id="versionMgrLayerFrm" name="versionMgrLayerFrm" tabindex="1">
				<input type="hidden" name="sdate" id="sdate" />
				<table class="table outer">
					<colgroup>
						<col width="15%" />
						<col width="*" />
						<col width="15%" />
						<col width="20%" />
					</colgroup>
					<tr>
						<th>복사 기준</th>
						<td>
							<label><input type="radio" name="add_type" id="add_type_org" class="valignM" /> 조직도를 복사하여 추가</label>
							<br>
							<label><input type="radio" name="add_type" id="add_type_version" class="valignM" /> 등록된 버전을 복사하여 추가</label>
						</td>
						<th>복사 대상 선택</th>
						<td>
							<span id="combo_org">
								<select name="srchOrg" id="srchOrg"></select>
							</span>
							<span id="combo_version">
								버전 <select name="srchVersion" id="srchVersion"></select>
							</span>
						</td>
					</tr>
					<tr>
						<th>버전명</th>
						<td colspan="3">
							<input id="versionNm" name="versionNm" type="text" class="text w200" />
							&nbsp;
							<btn:a href="javascript:doAction1('addVersion');" id="orgCopy" css="authA btn filled" mid='orgCopy' mdef="버전 추가"/>
						</td>
					</tr>
				</table>
			</form>
			<table border="0" cellspacing="0" cellpadding="0" class="sheet_main mat15">
				<tr>
					<td>
						<div class="inner">
							<div class="sheet_title">
							<ul>
								<li id="txt" class="txt">버전</li>
								<li class="btn">
									<!--
									<btn:a href="javascript:doAction1('OrgCopy');" 		id="orgCopy" css="basic authA" mid='orgCopy' mdef="조직도복사"/>
									<btn:a href="javascript:doAction1('VerCopy');" 		id="verCopy" css="basic authA" mid='verCopy' mdef="버전복사"/>
									 -->
									<btn:a href="javascript:doAction1('Down2Excel');" 	css="btn outline-gray authA" mid='down2Excel' mdef='다운로드'/>
									<btn:a href="javascript:doAction1('Save');" 		id="save" css="btn filled authA" mid='save' mdef="저장"/>
									<btn:a href="javascript:doAction1('Search');" 		css="btn dark authA" mid='search' mdef="조회"/>
								</li>
							</ul>
							</div>
						</div>
						<div id="versionMgrLayerSht1-wrap"></div>
					</td>
				</tr>
			</table>
		</div>

		<div class="modal_footer">
			<a href="javascript:popupClose();" class="btn outline_gray">닫기</a>
		</div>
	</div>
</body>
</html>



