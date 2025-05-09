<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<!-- ajax error -->
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp" %>

<% request.setAttribute("uploadType", "appl"); %>
<script>
var isProgress = false;

var approvalLayer = {
	id: 'approvalMgrLayer',
	fileSeq: '',
	prgExists: false,
	iframeLoad: false,
	execLvlCode: true,
	approvalLine: [],
	referersLine: [],
	inapplLine: []
};

$(function() {

	// 결재선 토글버튼
	$("#approvalLineDropdown").on("click", function (e) {
		$(this).toggleClass("active");
		const isActive = $(this).hasClass("active");
		if (isActive) {
			$("#approvalLayerAppLineTable").hide();
			$("#hr-wrap").show();
			$("#approvalLineDropdownIcon").css("transform", "rotate(180deg)");
		} else {
			$("#approvalLayerAppLineTable").show();
			$("#hr-wrap").hide();
			$("#approvalLineDropdownIcon").css("transform", "rotate(0deg)");
		}
		e.stopPropagation();
	});

	//title setting
	//$('#modal-' + approvalLayer.id).find('div.layer-modal-header span.layer-modal-title').text('${uiInfo.applTitle}');
	//제목 수정여부에 따라 제목 수정
	let obj;
	if ('${uiInfo.titleYn}' == 'Y') {
		obj = $('.layer-modal-header').children('#inputTitle');
		$('#modal-' + approvalLayer.id).find('div.layer-modal-header span.layer-modal-title').hide();
		obj.show();
		obj.val('${uiInfo.applTitle}');
	}else {
		$('#modal-' + approvalLayer.id).find('div.layer-modal-header span.layer-modal-title').text('${uiInfo.applTitle}');
	}
	if ('${uiInfo.appPathYn}' == 'Y') $('#btnApprovalLineChange').show();
	if ('${uiInfo.orgLevelYn}' == 'Y') $('#approvalLayerLvlCode').show();
	if ('${uiInfo.fileYn}' == 'Y') $('#uploadDiv').show();

	//신청서에서 height-full 선택시 ui 수정
	if($('#modal-' + approvalLayer.id).find('div.modal-size').attr('class').includes('height-full')) {
		$('#modal-' + approvalLayer.id).find('div.modal-size').css('max-height', '100vh');
		$('.modal_body').css('max-height', 'calc(100vh - 150px)');
		$('.modal_body').css('height', '100%');
	}

	//결재선 변경이 없는 경우 처리
	if ('${uiInfo.appPathYn}' == 'Y' && '${uiInfo.orgLevelYn}' != 'Y') {
		$('#approvalLayerLineArea').hide();
		$('#approvalLayerLineBlankArea').show();
	}

	//결재처리여부, 수신처리여부가 N이면 결재라인을 숨김
	if ('${uiInfo.agreeYn}' == 'N' && '${uiInfo.recevYn}' == 'N') {
		$('#approvalLayerAppLineTable').hide();
		$('#approvalLayerLineArea').hide();
		$('#approvalLayerConfirmPerson').hide();
	}

	//신청시 유의사항 정보가 있을 경우
	if ('${uiInfo.etcNoteYn}' == 'Y') {
		$('#approvalLayerCommentArea').show();
		//유의사항 정보에 첨부파일이 존재한다면
		if (Number('${uiInfo.etcNoteFileCnt}') > 0) {
			$('#btnApprovalLayerEtcFileDownload').show();
			$('#btnApprovalLayerEtcFileDownload').click(function() {
				noticeFileLayer('${uiInfo.etcNoteFileSeq}');
			});
		}
	}

	//신청서 LEVELCODE SETTING
	const lvls = convCodeIdx(ajaxCall('/ApprovalMgr.do?cmd=getApprovalMgrLevelCodeList', queryStringToJson({searchApplSabun: '${searchApplSabun}'}), false).DATA, '', -1);
	$('#approvalLayerLvlCode').html(lvls[2]);
	$('#approvalLayerLvlCode').val('${orgLvl.orgLvl}');

	if ('${applSeqExist}' == 'N') {
		initApprovalLine();
	} else {
		var param = { searchApplSeq: '${searchApplSeq}' };
		var applmi = ajaxCall('/ApprovalMgr.do?cmd=getApprovalMgrTHRI103', queryStringToJson(param), false).DATA;
		$('#approvalLayerTitle').html(applmi.title);
		$('.layer-modal-header').children('#inputTitle').val(applmi.title);
		$('#applStatusCd').val(applmi.applStatusCd);
		approvalLayer.fileSeq = applmi.fileSeq;
		
		var appls = ajaxCall('/ApprovalMgr.do?cmd=getApprovalMgrTHRI107', queryStringToJson(param), false).DATA;
		setApprovalLayerApplTBody(appls);
		approvalLayer.approvalLine = appls.filter(a => a.gubun != '3');
		approvalLayer.inapplLine = appls.filter(a => a.gubun == '3').map(ia => ({
				...ia
			  , empAlias: ia.agreeEmpAlias
			  , org: ia.agreeOrgNm
			  , jikchak: ia.agreeJikchakNm
			  , jikwee: ia.agreeJikweeNm
			  , orgAppYn: ia.orgAppYn
		}));
		
		if (appls && appls.length > 0) {
			approvalLayer.execLvlCode = false;
		}
		$('#approvalLayerLvlCode').val(appls[0].pathSeq);
		var referers = ajaxCall('/ApprovalMgr.do?cmd=getApprovalMgrTHRI125', queryStringToJson(param), false).DATA;
		setApprovalLayerReferUser(referers);

		if ('${uiInfo.agreeYn}' == 'N') {
			$('#approvalLayerLvlCode').val('0');
			$('#approvalLayerAppLineTable').hide();
			$('#approvalLayerLineArea').hide();
			$('#approvalLayerConfirmPerson').hide();
			$('#approvalLayerTitle').text('');
		}
	}

	if (approvalLayer.approvalLine == null || !approvalLayer.approvalLine.length) {
		var user = {
			agreeName: '${userInfo.name}',
			agreeSabun: '${userInfo.sabun}',
			agreeOrgCd: '${userInfo.orgCd}',
			agreeOrgNm: '${userInfo.orgNm}',
			agreeJikweeCd: '${userInfo.jikweeCd}',
			agreeJikweeNm: '${userInfo.jikweeNm}',
			agreeJikchakCd: '${userInfo.jikchakCd}',
			agreeJikchakNm: '${userInfo.jikchakNm}',
			agreeSeq: 1,
			applTypeCdNm: '기안',
			applTypeCd:'30' 
		};
		approvalLayer.approvalLine = [ user ];
		setApprovalLayerApplTBody(approvalLayer.approvalLine);
	}

	callIframeBody();
	initFileUploadIframe("approvalMgrLayerUploadForm", approvalLayer.fileSeq, "appl", "${authPg}");
	$('#authorFrame').on("load", function() { setIframeHeight(this.id); });

	//신청서 LEVELCODE EVNET
	$('#approvalLayerLvlCode').change(function() {
		if (approvalLayer.execLvlCode) {
			initApprovalLine();
		}
		approvalLayer.execLvlCode = true;
	});

	//신청일자 시작일, 종료일
	const startYmd = '${startYmd}' || '';
	const endYmd = '${endYmd}' || '';
	if('${searchApplCd}' === '22' && startYmd !== '' && endYmd !== ''){
		$('#authorFrame').on('load', function(){
			$(this).get(0).contentDocument.getElementById('sYmd').value = '${startYmd}';
			$(this).get(0).contentDocument.getElementById('eYmd').value = '${endYmd}';
		});
	}
});

function initApprovalLine() {
	var param = { searchApplCd: '${searchApplCd}', searchApplSabun: '${searchApplSabun}', lvlCode: $('#approvalLayerLvlCode').val() };
	var appls = ajaxCall('/ApprovalMgr.do?cmd=getApprovalMgrApplChgList', queryStringToJson(param), false).DATA;
	approvalLayer.approvalLine = appls;
	
	var inappls = ajaxCall('/ApprovalMgr.do?cmd=getApprovalMgrInList', queryStringToJson(param), false).DATA;
	approvalLayer.inapplLine = inappls.map(ia => ({
			...ia
		  , empAlias: ia.name
		  , agreeName: ia.name
		  , agreeSabun: ia.sabun
		  , gubun: '3'
		  , org: ia.orgNm
		  , orgCd: ia.orgCd
		  , jikchak: ia.jikchakNm
		  , jikchakCd: ia.jikchakCd
		  , jikwee: ia.jikweeNm
		  , jikweeCd: ia.jikweeCd
		  , orgAppYn: ia.orgAppYn
		}));
	
	var aps = [ ...appls, ...inappls ];
	setApprovalLayerApplTBody(aps);

	if ('${uiInfo.agreeYn}' == 'N') {
		/* 결재처리여부가 N이면 0단계(본인)결재선만 박고 화면에 안보이게 처리하고 멈춤  by JSG 2013.10.08 In JejuAir */
		$('#approvalLayerLvlCode').val('0');
		$('#approvalLayerAppLineTable').hide();
		$('#approvalLayerLineArea').hide();
		$('#approvalLayerConfirmPerson').hide();
		$('#approvalLayerTitle').text('');
	}

	var referers = ajaxCall('/ApprovalMgr.do?cmd=getApprovalMgrReferUserChgList', queryStringToJson(param), false).DATA;

	referers = referers.map(r => ({
		  ccOrgNm: r.orgNm
		, ccOrgCd: r.orgCd
		, ccJikchakCd: r.jikchakCd
		, ccJikchakNm: r.jikchakNm
		, ccJikweeCd: r.jikweeCd
		, ccJikweeNm: r.jilweeNm
		, ccEmpName: r.ccName
		, ...r
	}));
	setApprovalLayerReferUser(referers);

	$('#applStatusCd').val('');
}

function closeApprovalMgrLayer() {
	const modal = window.top.document.LayerModalUtility.getModal(approvalLayer.id);
	modal.fire('approvalMgrLayerTrigger', {}).hide();
}

function setApprovalLayerApplTBody(appls) {
	var apptbody = appls.reduce((a, c, i) => {
		var time = c.agreeTime && c.agreeTime != '' ?  cTimeFormat(new Date(c.agreeTime)):'';
		var status =  c.agreeStatusCdNm ? c.agreeStatusCdNm:'';

		var name = c.agreeName ? c.agreeName:c.name ? c.name:'';
		var orgNm = c.agreeOrgNm ? c.agreeOrgNm:c.orgNm ? c.orgNm:'';
		var jwNm = c.agreeJikweeNm ? c.agreeJikweeNm:c.jikweeNm ? c.jikweeNm:'';

		if (c.deputyYn == 'Y') {
			a += '<tr style="border-bottom: none;">\n'
					+ '	<td>' + (i + 1) + '</td>\n'
					+ '	<td>' + c.applTypeCdNm + '</td>\n'
					+ '	<td>' + name + '</td>\n'
					+ '	<td>' + orgNm + '</td>\n'
					+ '	<td>' + jwNm + '</td>\n'
					+ '	<td></td>\n'
					+ '	<td><span class="state_icon_green"></span></td>\n'
					+ '</tr>\n'
					+ '<tr>\n'
					+ '	<td></td>\n'
					+ '	<td>대결</td>\n'
					+ '	<td>' + c.deputyName + '</td>\n'
					+ '	<td>' + c.deputyOrgNm + '</td>\n'
					+ '	<td>' + c.deputyJikweeNm + '</td>\n'
					+ '	<td>' + time + '</td>\n'
					+ '	<td><span class="state_icon_green"></span>' + status + '</td>\n'
					+ '</tr>\n';
		} else {
			a += '<tr>\n'
					+ '	<td>' + (i + 1) + '</td>\n'
					+ '	<td>' + c.applTypeCdNm + '</td>\n'
					+ '	<td>' + name + '</td>\n'
					+ '	<td>' + orgNm + '</td>\n'
					+ '	<td>' + jwNm + '</td>\n'
					+ '	<td>' + time + '</td>\n'
					+ '	<td><span class="state_icon_green"></span>' + status + '</td>\n'
					+ '</tr>\n';
		}
		return a;
	}, '');
	$('#approvalLayerApplTBody').html(apptbody);
}

function setApprovalLayerReferUser(referers) {
	approvalLayer.referersLine = referers;
	var refererHtml = referers.reduce((a, c) => {
						if (a != '') a += ' / ';
						a += c.ccOrgNm + ' ' + c.ccEmpName + '(' + c.ccSabun + ')';
						return a;
					  }, '');
	$('#approvalLayerReferUser').html(refererHtml);
}

function callIframeBody() {
	var prgcd = "${uiInfo.detailPrgCd}"
	if(prgcd != '') {
		var form = $("#authorForm");
		var lvlcode = $('#approvalLayerLvlCode').val();
		form.append('<input type="hidden" name="lvlCode" id="lvlCode" value="' + lvlcode + '" />');
		approvalLayer.prgExists = true;
		submitCall(form, "authorFrame", "post", prgcd);
	} else {
		iframeOnLoad("0px");
	}
}

/**
 * 상세화면 iframe 내 높이 재조정.
 * @param ih
 * @modify 2024.04.23 Det.jsp 내에서 부모의 iframeOnLoad를 호출할 때 아직 화면이 그려지기 전에 iframe의 높이를 지정하는 경우가 있어 0.3초 후 다시 높이를 조정. by kwook
 */
function iframeOnLoad(ih) {
	try {
		setTimeout(function() {
			var ih2 = parseInt((""+ih).split("px").join(""));
			var wrpH = 0;
			$("#authorFrame").contents().find(".wrapper").children().each((idx, ele) => wrpH += $(ele).outerHeight(true));
			if (wrpH > ih2)
				$("#authorFrame").height(wrpH);
			else
				$("#authorFrame").height(ih2);
		}, 300);

		approvalLayer.iframeLoad = true;
	} catch(e) {
		$("#authorFrame").height(ih);
		approvalLayer.iframeLoad = true;
	}
}

function setIframeHeight(id) {
	var ifrm = document.getElementById(id);
	if (ifrm) {
		ifrm.style.visibility = 'hidden';
		ifrm.style.height = ifrm.contentDocument.body.scrollHeight + "px";
		ifrm.style.visibility = 'visible';
	}
}

function changeApprovalLine() {
	if(!isPopup()) {return;}
	var args = { 
			orgCd: '${userInfo.orgCd}'
		  , pathSeq: $('#approvalLayerLvlCode').val()
		  , searchApplSabun: '${searchApplSabun}'
	   	  , lines: getApprovalLineJson()
		};
	var url 	= "/ApprovalMgr.do?cmd=viewApprovalMgrChgLineLayer";
	var changeApprovalLineLayer = new window.top.document.LayerModal({
			id: 'changeApprovalLineLayer',
			url,
			parameters: args,
			width: 1200,
			height: 750,
			title: "<tit:txt mid='appPathReg' mdef='결재 경로 변경'/>",
			trigger: [
				{ name: 'changeApprovalLineTrigger', callback: function(rv) { changeApprovalLineRtn(rv); } }
			]
		});
	changeApprovalLineLayer.show();
	//openLayer(url, args, 1200, 750, 'initApprovalChangeLayer', changeApprovalLineRtn);
}

function changeApprovalLineRtn(param) {
	if (param) {
		var { appls, inappls, referer } = param;
		approvalLayer.approvalLine = appls.map(a => ({
			agreeSeq: a.agreeSeq,
			agreeName: a.name,
			agreeEmpAlias: a.empAlias,
			agreeSabun: a.agreeSabun,
			applTypeCd: a.applTypeCd,
			applTypeCdNm: a.applTypeCdNm,
			agreeOrgCd: a.orgCd,
			agreeOrgNm: a.orgNm,
			agreeJikweeNm: a.jikweeNm,
			agreeJikweeCd: a.jikweeCd,
			agreeJikchakNm: a.jikchakNm,
			agreeJikchakCd: a.jikchakCd,
		}));
		approvalLayer.inapplLine = inappls.map(a => ({
			agreeSabun: a.agreeSabun,
			applTypeCd: a.applTypeCd,
			applTypeCdNm: a.applTypeCdNm,
			empAlias: a.empAlias,
			agreeName: a.name,
			gubun: '3',
			org: a.orgNm,
			orgCd: a.orgCd,
			jikchak: a.jikchakNm,
			jikchakCd: a.jikchakCd,
			jikwee: a.jikweeNm,
			jikweeCd: a.jikweeCd
		}));
		setApprovalLayerApplTBody([...appls, ...inappls]);
		referer = referer.map(a => ({
			ccSabun: a.ccSabun,
			ccOrgNm: a.orgNm,
			ccOrgCd: a.orgCd,
			ccJikchakCd: a.jikchakCd,
			ccJikchakNm: a.jikchakNm,
			ccJikweeCd: a.jikweeCd,
			ccJikweeNm: a.jilweeNm,
			ccEmpName: a.name,
			ccEmpAlias: a.name,
			pathSeq: a.pathSeq
		}));
		setApprovalLayerReferUser(referer);
	}
}

function getApprovalLineJson() {
	var data = {
			appls: [],
			deputys: [],
			inusers: [],
			refers: [],
		};
	 
	data.appls = approvalLayer.approvalLine.filter(a => (a.deputyYn != 'Y' || (a.deputySabun && a.deputySabun == ''))).map((a, i) => ({
		agreeSeq: a.agreeSeq ? a.agreeSeq: '#agreeSeq#',
		name: a.agreeName,
		agreeSabun: a.agreeSabun,
		empAlias: a.agreeEmpAlias,
		applTypeCd: a.applTypeCd,
		gubun: a.applTypeCd == '30' ? '0':'1',
		orgCd: a.agreeOrgCd,
		org: a.agreeOrgNm,
		jikwee: a.agreeJikweeNm,
		jikweeCd: a.agreeJikweeCd,
		jikchak: a.agreeJikchakNm,
		jikchakCd: a.agreeJikchakCd
	}));

	data.deputys = approvalLayer.approvalLine.filter(a => (a.deputyYn == 'Y' || (a.deputySabun && a.deputySabun != ''))).map((a, i) => ({
		sabun: a.deputySabun,
		org: a.deputyOrgNm,
		agreeSabun: a.agreeSabun,
		jikwee: a.deputyJikweeNm,
		jikchak: a.deputyJikchakNm
	}));

	data.inusers = approvalLayer.inapplLine;

	if (approvalLayer.referersLine && approvalLayer.referersLine.length > 0) {
		var author = approvalLayer.approvalLine.find(a => a.applTypeCd == '30');
		author = {inSabun: author.agreeSabun,
				  name: author.agreeName,
				  inOrg: author.agreeOrgNm,
				  inOrgCd: author.agreeOrgCd,
				  inJikchak: author.agreeJikchakNm,
				  inJikchakCd: author.agreeJikchakCd,
				  inJikwee: author.agreeJikweeNm,
				  inJikweeCd: author.agreeJikweeCd,
				  agreeSeq: author.agreeSeq};
		  
		data.refers = approvalLayer.referersLine.map(a => ({
			...author
		  , referName: a.name
		  , referSabun: a.ccSabun
		  , referOrg: a.ccOrgNm
		  , referOrgCd: a.ccOrgCd
		  , referJikchak: a.ccJikchakNm
		  , referJikchakCd: a.ccJikchakCd
		  , referJikwee: a.ccJikweeNm
		  , referJikweeCd: a.ccJikweeCd
		  , referEmpAlias: a.ccEmpAlias
		}));
	}

	return data;
}

async function doAction(action) {
	if(isProgress) {return;}

	if (action == '21' && $.trim('${uiInfo.confirmMsg}')) {
		if (!confirm('${uiInfo.confirmMsg}')) return;
	}
	
	$('#applStatusCd').val(action);
	if(!approvalLayer.iframeLoad) {
		return alert("<msg:txt mid='109888' mdef='업무 화면이 로딩 되지 않았습니다.n 로딩완료후 다시 시도 하십시오!'/>");
	}

	//첨부파일 관련 로직은 후에 적용
	var attFileCnt = getFileUploadContentWindow("approvalMgrLayerUploadForm").getFileList();
	//첨부파일 필수여부 체크 (임시저장일 경우 제외)
	if("${uiInfo.fileEssentialYn}" == 'Y' && attFileCnt == 0 && action != "11" && $('#fileReqYn').val() != "N") {
		return alert("파일 첨부가 필요한 신청입니다.");
	}

	//결재선이 지정되지 않은 경우
	var line = [...approvalLayer.approvalLine, ...approvalLayer.inapplLine];
	if (!line || !line.length) {
		return alert("결재선이 지정되어 있지 않습니다.\n결재선을 지정해 주시기 바랍니다.");
	}  

	//본인 결제가 허용되지 않았는데 결제자가 자기밖에 없는경우
	if( '${uiInfo.pathSelfCloseYn}' == 'N' &&  line.length == 1 ) {
		return alert('결재선이 본인만 지정되었습니다. 결재자를 추가로 지정하여 신청해 주십시오.');
	}

	//하위 문서의 applseq를 새로운 applseq로 셋팅
	if ($('#reApplSeq').val() != null && $('#reApplSeq').val() != '') {
		$('#authorFrame').contents().find('#searchApplSeq').val($('#reApplSeq').val());
	}

	$('#pathSeq').val($('#approvalLayerLvlCode').val());
	$("#authorForm>#fileSeq").val(getFileUploadContentWindow("approvalMgrLayerUploadForm").getFileSeq());
	const param = {
		...formToJson($("#authorForm")),
		...getApprovalLineJson()
	};

	//제목수정여부 확인
	if ('${uiInfo.titleYn}' == 'Y') {
		param.applTitle =$('#inputTitle').val();
	}

	isProgress = true;
	progressBar(true, "Please Wait...");
	setTimeout(async () => {
		var validation = await callIframeSaveLogic(action);
		if (validation) {
			callSave(action, param);
			closeApprovalMgrLayer();
		}
		progressBar(false);
		isProgress = false;
	}, 1000);
	
}

async function callIframeSaveLogic(action) {
	isProgress = true;
	var rtn = false;
	if (approvalLayer.prgExists) {
		rtn = await $("#authorFrame").get(0).contentWindow.setValue(action);
	} else {
		rtn = true;
	}
	return rtn;
} 

function callSave(action, param) {
	var r = ajaxTypeJson('/ApprovalMgr.do?cmd=saveApprovalMgr', param, false);
	if (r) {
		var msg = '';
		switch (r.Code) {
		case 1: msg = (action == '11') ? '저장 되었습니다.':'신청 되었습니다.'; break;
		case 0: msg = (action == '11') ? '저장된 내용이 없습니다.':'신청된 내용이 없습니다.'; break;
		case -1: msg = (action == '11') ? '저장에 실패했습니다.':'신청에 실패했습니다.'; break;
		}

		if (action == '21' && Number(r.cnt) > 0) {
			try {
				//var sendp = {applSeq: $('#searchApplSeq').val(), applStatusCd: action, firstDiv: 'Y'};
				//ajaxCall('/Send.do?cmd=callMailAppl', queryStringToJson(sendp), false);
			} catch (e) {
				alert('메일 발송 중 오류가 발생했습니다.')
			}
		}
		alert(msg);
	}
}

function noticeFileLayer(fileSeq) {

	let layerModal = new window.top.document.LayerModal({
		id : 'fileMgrLayer'
		, url : 'fileuploadJFileUpload.do?cmd=viewFileMgrLayer'
		, parameters : {
			authPg : 'R',
			fileSeq : fileSeq,
			fileLayerId : 'noticeFileLayer'
		}
		, width : 740
		, height : 420
		, title : '파일다운로드'
		, trigger :[
			{
				name : 'fileMgrLayerTrigger'
				, callback : function(result){
				}
			}
		]
	});
	layerModal.show();
}

</script>
<div class="wide wrapper modal_layer">
	<!--
	<div class="modal_header">
	  <span id="approvalLayerTitle">${uiInfo.applTitle}</span><i class="mdi-ico" onclick="closeApprovalMgrLayer()">close</i>
	</div>
	 -->
	<div class="modal_body">
		<form id="jejuForm" name="jejuForm"></form>
		<form id="authorForm" name="form">
			<input id="searchApplCd" 	name="searchApplCd" 	type="hidden" value="${searchApplCd}"/>
			<input id="searchApplSeq" 	name="searchApplSeq" 	type="hidden" value="${searchApplSeq}"/>
			<input id="reApplSeq" 		name="reApplSeq" 		type="hidden" value="${reApplSeq}"/>
			<input id="searchApplSabun" name="searchApplSabun" 	type="hidden" value="${searchApplSabun}"/>
			<input id="searchApplName" 	name="searchApplName" 	type="hidden" value="${userInfo.name}"/>
			<input id="adminYn" 		name="adminYn" 			type="hidden" value="${adminYn}"/>
			<input id="authPg" 			name="authPg" 			type="hidden" value="${authPg}"/>
			<input id="searchApplYmd" 	name="searchApplYmd" 	type="hidden" value="${searchApplYmd}"/>
			<input id="searchSabun" 	name="searchSabun" 		type="hidden" value="${searchSabun}"/>
			<input id="pathSeq" 		name="pathSeq" 			type="hidden" value=""/>
			<input id="applStatusCd" 	name="applStatusCd" 	type="hidden" value=""/>
			<input id="fileSeq"			name="fileSeq"			type="hidden" value=""/>
			<input id="gubun" 			name="gubun" 			type="hidden" value="${gubun}"/>
			<input id="procExecYn" 			name="procExecYn" 			type="hidden" value="${uiInfo.procExecYn}"/>
			<input id="afterProcStatusCd"	name="afterProcStatusCd"	type="hidden" value=""/>
			<input id="etc01"			name="etc01"			type="hidden" value="${etc01}"/>
			<input id="etc02"			name="etc02"			type="hidden" value="${etc02}"/>
			<input id="etc03"			name="etc03"			type="hidden" value="${etc03}"/>
			<input id="applTitle"       name="applTitle"        type="hidden" value="${uiInfo.applTitle}" />
			<div class="modal_body_header">
				<div id="approvalLayerLineArea" class="box1">
		          <p class="title">결재정보</p>
		          <div class="select_wrap" >
		            <select id="approvalLayerLvlCode" class="custom_select" style="display:none;">
		            </select>
		          </div>
		          <button id="btnApprovalLineChange" type="button" class="btn outline icon_text" style="display:none;" onclick="changeApprovalLine()">
		            <i class="mdi-ico">published_with_changes</i>결재선변경
		          </button>
		        </div>
		        <div id="approvalLayerLineBlankArea" class="box1" style="display:none;"></div>
		        <div id="approvalLayerConfirmPerson" class="box2 right_control">
<%--		          <div class="count">--%>
<%--		            결재자 <span id="approvalLayerLvlLineCount" class="title"></span>--%>
<%--		          </div>--%>
		          <div class="title" id="approvalLineDropdown"><i class="mdi-ico rotate" id="approvalLineDropdownIcon">keyboard_arrow_up</i></div>
		        </div>
			</div>
		</form>
		<hr class="no_table" id="hr-wrap">
			<div id="approvalLayerAppLineTable" class="table_scroll_pay">
				<table class="basic type5 toggle_table">
		            <thead>
		              <tr>
		                <th>순번</th>
		                <th>구분</th>
		                <th>승인자</th>
		                <th>부서</th>
		                <th>직위</th>
		                <th>결재일시</th>
		                <th>결재상태</th>
		              </tr>
		            </thead>
		            <tbody id="approvalLayerApplTBody">
		              <tr>
		                <td colspan="7" class="no_file">
		                  <div>
		                    <i class="mdi-ico">drive_file_rename_outline</i>
		                    <span>입력된 결제정보가 없습니다.</span>
		                  </div>
		                </td>
		              </tr>
		            </tbody>
				</table>
			</div>
			
			<table border="0" cellpadding="0" cellspacing="0" class="settle">
				<colgroup>
					<col width="15%" />
					<col width="85%" />
				</colgroup>
				<tr>
					<th><tit:txt mid='113550' mdef=' 수신참조 '/></th>
					<td id="approvalLayerReferUser"> </td>
				</tr>
			</table>
			
			<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid='201706090000001' mdef='신청자'/></li>
				</ul>
			</div>
			<table border="0" cellpadding="0" cellspacing="0" class="settle">
				<colgroup>
		            <col width="12%" />
		            <col width="13%" />
		            <col width="12%" />
		            <col width="13%" />
		            <col width="12%" />
		            <col width="13%" />
		            <col width="12%" />
		            <col width="13%" />
				</colgroup>
				<tr>
					<th><tit:txt mid='104084' mdef='신청일자'/></th>
					<td>${userInfo.applYmd}</td>
					<th><tit:txt mid='114648' mdef=' 소속 '/></th>
					<td>${userInfo.orgNm}</td>
					<th> 사번 </th>
					<td>${userInfo.sabun}</td>
					<th><tit:txt mid='114252' mdef=' 성명 '/></th>
					<td>${userInfo.name}</td>
				</tr>
			</table>
			<div class="h5"></div>
			<iframe id="authorFrame" name="authorFrame" frameborder="0" class="author_iframe" style="height:100px; min-height:317px;"></iframe>
		</hr>
		<div id="approvalLayerCommentArea" class="notice" style="display:none;">
	      <div class="notice_title">
	        <i class="mdi-ico">error</i>&nbsp;<span><tit:txt mid='appInstruction' mdef='신청시 유의사항'/></span>
	        <div class="btn-wrap">
	        	<button type="button" id="btnApprovalLayerEtcFileDownload" class="btn" style="display:none;">다운로드</button>
	        </div>
	      </div>
	      <div class="notice_desc">${uiInfo.etcNote}</div>
	    </div>	
		<div id="uploadDiv" style="display:none;">
			<iframe id="approvalMgrLayerUploadForm" name="approvalMgrLayerUploadForm" frameborder="0" class="author_iframe" style="width:100%; height:150px;"></iframe>
		</div>
	</div>
	<div class="modal_footer">
	  <button type="button" id="btnApplCancel" class="btn outline_gray" onclick="closeApprovalMgrLayer()">취소</button>
	  <button type="button" id="btnApplTemp" class="btn filled" onclick="doAction('11')">임시저장</button>
	  <button type="button" id="btnApplConfirm" class="btn filled" onclick="doAction('21')">신청</button>
	</div>
</div>