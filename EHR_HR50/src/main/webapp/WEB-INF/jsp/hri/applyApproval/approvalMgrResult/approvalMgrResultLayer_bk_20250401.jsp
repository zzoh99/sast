<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!-- ajax error -->
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp" %>


<% request.setAttribute("uploadType", "appl"); %>
<script>
var approvalResultLayer = {
		id: 'approvalMgrLayer',
		searchApplCd: '${searchApplCd}',
		searchApplSeq: '${searchApplSeq}',
		fileSeq: '',
		pathSeq: '',
		agreeSeq: '',
		agreeSabun: '',
		agreeGubun: '',
		searchSabun: '',
		referAgreeSeq: '',
		agreeUserStatus: '',
		agreeUserMemo: '',
		signView: 'status',
		prgExists: false,
		iframeLoad: false,
		execLvlCode: true,
		deputy:null,
		approvalLine: [],
		referersLine: [],
		inapplLine: []
	};

$(function() {
	//title setting
	$('#modal-' + approvalResultLayer.id).find('div.layer-modal-header span.layer-modal-title').text('${applMasterInfo.title}');
	//신청서 height-full 처리
	if($('#modal-' + approvalResultLayer.id).find('div.modal-size').attr('class').includes('height-full')) {
		$('#modal-' + approvalResultLayer.id).find('div.modal-size').css('max-height', '100vh');
		$($('.modal_body')[0]).css('max-height', 'calc(100vh - 150px)');
		$($('.modal_body')[0]).css('height', '100%');
	}
	var prgcd = "${uiInfo.detailPrgCd}";
	if (prgcd != '') {
		approvalResultLayer.prgExists = true;
	}
	if (approvalResultLayer.prgExists) {
		submitCall($("#approvalMgrResultLayerForm"), "authorResultFrame", "post", "${uiInfo.detailPrgCd}");
	} else {
		iframeOnLoad("0px");
	}

	//UI 정보에 따른 화면 편집
	//if ('${uiInfo.printYn}' == 'Y') $('.print').show();
	if ('${uiInfo.fileYn}' == 'Y') $('#uploadDiv').show();
	if ('${uiInfo.etcNoteYn}' == 'Y') $('#approvalLayerCommentArea').show();
	if ('${uiInfo.reUseYn}' == 'Y' && '${applMasterInfo.applSabun}' == '${ssnSabun}') {
		$('#btnApplReuse').show();
	}
	if ("${uiInfo.commentYn}" == 'Y') {
		$('#approvalMgrResultLayerCommentArea').show();
		searchApprovalComment();
	} else {
		$('#approvalMgrResultLayerCommentArea').hide();
	}

	if ('${uiInfo.webPrintYn}'  == 'Y') $("#btnApprovalMgrWebPrint").show();
	
	if ('${applMasterInfo.applSabun}' == '${ssnSabun}' && '${cancelButton.cancel}' == 'YES') $('#btnApplRecall').show();

	initFileUploadIframe("approvalMgrResultLayerUploadForm", "${applMasterInfo.fileSeq}", "appl", "${authPg}");

	//관리자라면 결재상태 OPTION정보 처리를 해준다
	if ('${param.adminYn}' == 'Y') {
		var codes = convCodeIdx(ajaxCall('/CommonCode.do?cmd=getCommonCodeList', 'grpCd=R10010&useYn=Y', false).codeList, '', -1);
		$('#approvalMgrResultStatusCd').html(codes[2]);
		$('#approvalMgrResultStatusCd').val('${applMasterInfo.applStatusCd}');
		$('#approvalMgrResultstatusTable').show();
		$('#btnApplSave').show();
	}
	
	//결재라인 생성
	var param = { searchApplSeq: '${searchApplSeq}' };
	var appls = ajaxCall('/ApprovalMgrResult.do?cmd=getApprovalMgrResultTHRI107', queryStringToJson(param), false).DATA;
	setApprovalResultLayerApplTBody(appls);
	approvalResultLayer.approvalLine = appls.filter(a => a.gubun != '3');
	approvalResultLayer.inapplLine = appls.filter(a => a.gubun == '3').map(ia => ({
			...ia
		  , empAlias: ia.agreeEmpAlias
		  , org: ia.orgNm
		  , jikchak: ia.agreeJikchakNm
		  , jikwee: ia.agreeJikweeNm
		  , orgAppYn: ia.orgAppYn
	}));

	var referers = ajaxCall('/ApprovalMgrResult.do?cmd=getApprovalMgrResultTHRI125', queryStringToJson(param), false).DATA;
	approvalResultLayer.referersLine = referers; 
	setApprovalResultLayerReferUser(referers);

	$('#authorResultFrame').on("load", function() { setIframeHeight(this.id); });
});

function closeApprovalMgrResultLayer() {
	const modal = window.top.document.LayerModalUtility.getModal(approvalResultLayer.id);
	modal.fire('approvalMgrLayerTrigger').hide();
}

function approvalMgrResultCommentSave() {
	var comments = $('#approvalMgrResultComments').val().replace(/(?:\r\n|\r|\n)/g, '\\n');
	$('#approvalMgrResultComments').val(comments);

	const param = {
		searchApplSeq: approvalResultLayer.searchApplSeq,
		searchApplCd: approvalResultLayer.searchApplCd,
		comments: comments
	};
	ajaxCall('/ApprovalMgrResult.do?cmd=saveComment', queryStringToJson(param), false);
	$('#approvalMgrResultComments').val('');
	searchApprovalComment();
}

function approvalMgrResultDelComment(seq) {
	if (confirm('의견을 삭제하시겠습니까?')) {
		const param = { 
				commentsSeq: seq,
				searchApplSeq: approvalResultLayer.searchApplSeq,
				searchApplCd: approvalResultLayer.searchApplCd
			};
		ajaxCall('/ApprovalMgrResult.do?cmd=delComment', queryStringToJson(param), false);
		searchApprovalComment();
	}
}

function searchApprovalComment() {
	var alreadyHtml = $('#approvalLayerCommentContents');
	if (alreadyHtml) alreadyHtml.remove();
	
	var {searchApplCd, searchApplSeq} = approvalResultLayer;
	const p = { searchApplCd, searchApplSeq };
	var rv = ajaxCall('/ApprovalMgrResult.do?cmd=getCommentList', queryStringToJson(p), false);
	if (rv && rv.DATA) {
		var comments = rv.DATA;
		var commentsHtml = comments.reduce((a, c) => {
			var comment = c.comments.split('\\n').join('<br />'); 
			a += '<table class="default" style="margin-bottom:2px" >\n'
			   + '	<colgroup>\n'
			   + '		<col width="10%" />\n'
			   + '		<col width="70%" />\n'
			   + '		<col width="15%" />\n'
			   + '	</colgroup>\n'
			   + '<tr style="height:25px;">\n'
			   + '	<td class="center"><a href="#" onclick="profilePopup(\'' + c.sabun + '\')" class="center tBlue">' + c.empName + '</a></td>\n'
			   + '	<td style="background:#fff;">' + comment + '</td>\n'
			   + '	<td class="tBlue">' + c.chkdate 
			if ('${sessionScope.ssnSabun}' == c.sabun) {
				a += '&nbsp;&nbsp;&nbsp;' 
				   + '<a name="commentDel" href="javascript:approvalMgrResultDelComment(\'' +  c.commentsSeq + '\')" class="button7">'
				   + '	<img src="/common/images/icon/icon_basket.png" />\n'
				   + '</a>';
			} 
			a += '	</td>\n'
			   + '</tr>\n</table>\n';
			return a;
		}, '');

		if (commentsHtml != '') 
			commentsHtml  = '<th colspan="3" id="approvalLayerCommentContents" align="center">' + commentsHtml + '</th>';
		$('#approvalMgrResultLayerCommentTable').append(commentsHtml);
	}
}

function setApprovalResultLayerApplTBody(appls) {
	if (appls.length > 0) approvalResultLayer.pathSeq = appls[0].pathSeq;
	appls.map(a => {
		if (a.agreeStatusCd == '20') a = {...a, agreeSabun: '${ssnSabun}'};
		return a;
	})
	
	var memoInput = '';
	var memoShow = false;
	appls.filter(a => a.agreeStatusCd == '10').forEach(a => {
		approvalResultLayer.agreeSabun = a.agreeSabun;
		approvalResultLayer.agreeSeq = a.agreeSeq;
		if (a.deputyYn == 'Y' || a.deputyName != '') {
			$('#btnApplConfirm').show();
			$('#btnApplReject').show();
			var jknm = a.deputyJikchakNm == '' ? a.deputyJikweeNm:a.deputyJikchakNm;
			approvalResultLayer.deputy = {inSabun: a.deputySabun, inOrg: a.deputyOrgNm, inJikchak: jknm, inJikwee: a.deputyJikweeNm};
			approvalResultLayer.searchSabun = '${ssnSabun}';
			memoShow = true;
			
			var deputyInfo = [ a.deputyOrgNm, jknm, a.deputyEmpAlias ];
			memoInput = '<tr style="display:none;">\n'
				 	  + '	<th>' + deputyInfo.join(' / ') + '</th>\n'
				 	  + '	<td><input id="approvalMgrResultLayerAgreeUserMemo" name="agreeUserMemo" type="text" class="text w100p" /></td>\n'
				 	  + '</tr>\n';
		} else if (a.agreeSabun == '${ssnSabun}') {
			$('#btnApplConfirm').show();
			$('#btnApplReject').show();
			approvalResultLayer.referAgreeSeq = a.agreeSeq;
			memoShow = true;
			var jknm = "${userInfo.jikchakNm}"==""?"${userInfo.jikweeNm}":"${userInfo.jikchakNm}"
			var applInfo = [ "${userInfo.orgNm}", jknm, "${userInfo.name}" ];
			memoInput = '<tr style="display:none;">\n'
				 	  + '	<th>' + applInfo.join(' / ') + '</th>\n'
				 	  + '	<td><input id="approvalMgrResultLayerAgreeUserMemo" name="agreeUserMemo" type="text" class="text w100p" /></td>\n'
				 	  + '</tr>\n';
		} else if (a.agreeSabun == '${ssnOrgCd}') {
			$('#btnApplConfirm').show();
			$('#btnApplReject').show();
			memoShow = true;
			var jknm = "${userInfo.jikchakNm}"==""?"${userInfo.jikweeNm}":"${userInfo.jikchakNm}"
			var applInfo = [ "${userInfo.orgNm}", jknm, "${userInfo.name}" ];
			memoInput = '<tr style="display:none;">\n'
				 	  + '	<th>' + applInfo.join(' / ') + '</th>\n'
				 	  + '	<td><input id="approvalMgrResultLayerAgreeUserMemo" name="agreeUserMemo" type="text" class="text w100p" /></td>\n'
				 	  + '</tr>\n';
		}
	});

	var memo = '';
	appls.forEach(a => {
		if (a.memo != '') {
			if (a.deputyYn == 'Y' || a.deputyName != '') {
				var jikchak = a.deputyJikchakNm == '' ? a.deputyJikweeNm:a.deputyJikchakNm;
				var i = [ a.deputyOrgNm, jikchak, a.deputyEmpAlias ];
				memo += '<tr><th>' + i.join(' / ') + '</th><td>' + a.memo + '</td></tr>';
			} else {
				var jikchak = a.agreeJikchakNm == '' ? a.agreeJikweeNm:a.agreeJikchakNm;
				var i = [ a.agreeOrgNm, jikchak, a.agreeEmpAlias ];
				memo += '<tr><th>' + i.join(' / ') + '</th><td>' + a.memo + '</td></tr>';
			}
		}
	});

	$('#approvalMgrResultMemoTable').append(memo);
	if (memoShow) $('#approvalMgrResultMemoTable').append(memoInput);

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

	if (apptbody != '') {
		$('#approvalResultLayerApplTBody').html(apptbody);
	}
}

function setApprovalResultLayerReferUser(referers) {
	if (referers && referers.length > 0) {
		var ref = '';
		var prevSeq = -1;
		var refHtml = referers.reduce((a, c, i) => {
			ref = c.ccOrgNm + ' ' + c.name + '(' + c.ccSabun + ')';
			var con = [c.inOrgNm, c.inJikchakNm, c.inName];
			var txt =  con.join(' / ') + '<br/><span style="font-family:verdana;font-size:11px;letter-spacing:-1px">' + c.chkdate + '</span>';
			a += '<tr class="delTr">\n'
					+ '	<td>' + txt + '</td>\n'
					+ '	<td id="referTd' + c.inSabun + '">' + ref + '</td>\n'
					+ '</tr>\n';
			return a;
		}, '');	

		$('#approvalMgrResultReferTable').append(refHtml);
	}
}

/**
 * 상세화면 iframe 내 높이 재조정.
 * @param ih
 * @modify 2024.04.23 Det.jsp 내에서 부모의 iframeOnLoad를 호출할 때 아직 화면이 그려지기 전에 iframe의 높이를 지정하는 경우가 있어 0.4초 후 다시 높이를 조정. by kwook
 */
function iframeOnLoad(ih) {
	try {
		setTimeout(function() {
			var ih2 = parseInt((""+ih).split("px").join(""));
			var wrpH = 0;
			$("#authorResultFrame").contents().find(".wrapper").children().each((idx, ele) => wrpH += $(ele).outerHeight(true));
			if (wrpH > ih2)
				$("#authorResultFrame").height(wrpH);
			else
				$("#authorResultFrame").height(ih2);
		}, 400);
		approvalResultLayer.iframeLoad = true;
	} catch(e) {
		$("#authorResultFrame").height(ih);
		approvalResultLayer.iframeLoad = true;
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

function approvalLayerResultComment(option) {
	if (!approvalResultLayer.iframeLoad) {
		return alert('<msg:txt mid="alertFrameLoad" mdef="업무 화면이 로딩 되지 않았습니다.\n 로딩완료후 다시 시도 하십시오." />'); 	
	}

	/* 근로시간단축 신청 */
	if("${searchApplCd}" == "300"){
		var rtn;
		if(status == 1){
			rtn = $("#authorResultFrame").get(0).contentWindow.adminDoSave2('0');
		}else{
			rtn = $("#authorResultFrame").get(0).contentWindow.adminDoSave2('2');
		}
		if(rtn == 0){
			hideOverlay();
			return;
		}
	}

	approvalResultLayer.agreeUserStatus = option;
	if (option == '0') {
		$("#appCmtTitle").html("반려의견");
		$("#cmtBtn").html("반려");
	} else {
		$("#appCmtTitle").html("결재의견");
		$("#cmtBtn").html("결재");
	}
	$('.modal_body.h-auto').css('height', 'auto'); // 결재의견 창 높이 고정
	$(".layer-cmt").show();
	$("#approvalMgrResultMemo").focus();
	$("#approvalMgrResultMemo").html("");
}

function saveApprovalMgrComment() {
	approvalResultLayer.agreeUserMemo = replaceAll($("#approvalMgrResultMemo").val(), "\n", "<br>");
	showOverlay(500);
	saveApprovalMgrResult(approvalResultLayer.agreeUserStatus);
	closeApprovalMgrPopCmt();
}

function closeApprovalMgrPopCmt(){
	$(".layer-cmt").hide();
	$("#approvalMgrResultMemo").html("");
	hideOverlay();
}

function approvalLayerResultReUse(option) {
	var p = {
			searchApplCd: '${searchApplCd}'
		  , searchApplSeq: approvalResultLayer.searchApplSeq
		  , adminYn: 'N'
		  , authPg: 'A'
		  , searchSabun: '${searchSabun}'
		  , searchApplSabun: $('#searchApplSabun').val()
		  , searchApplYmd: '${searchApplYmd}'
		  , reUseYn: 'Y'
		  , etc03: '${etc03}'
		};
	//upload div정보가 신청 layer와 겹치므로 삭제
	$('#uploadDiv').remove();
	//openLayer('/ApprovalMgr.do?cmd=viewApprovalMgrLayer', p, 800, 815, 'initLayer');
	//get Trigger
	const modal = window.top.document.LayerModalUtility.getModal(approvalResultLayer.id);
	const trigger = modal.getTrigger('approvalMgrLayerTrigger');
	closeApprovalMgrResultLayer();
	new window.top.document.LayerModal({
		id: 'approvalMgrLayer',
		url: '/ApprovalMgr.do?cmd=viewApprovalMgrLayer',
		parameters: p,
		width: 800,
		height: 815,
		title: '근태신청',
		trigger: [ trigger ]
	}).show();
}

function getApprovalResultLineJson() {
	var data = {
			appls: [],
			deputys: [],
			inusers: [],
			refers: [],
		};

	data.appls = approvalResultLayer.approvalLine.filter(a => (a.deputyYn != 'Y' || (a.deputySabun && a.deputySabun == ''))).map((a, i) => ({
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

	data.deputys = approvalResultLayer.approvalLine.filter(a => (a.deputyYn == 'Y' || (a.deputySabun && a.deputySabun != ''))).map((a, i) => ({
		sabun: a.deputySabun,
		org: a.deputyOrgNm,
		agreeSabun: a.agreeSabun,
		jikwee: a.deputyJikweeNm,
		jikchak: a.deputyJikchakNm
	}));

	data.inusers = approvalResultLayer.inapplLine;

	/**
	 * 중복 참조자 발생하여 임시 주석 24.11.13 - 강상구
	 * 결과화면에서 참조자 추가 기능 생길 시 반영 필요
	 */
	// if (approvalResultLayer.referersLine && approvalResultLayer.referersLine.length > 0) {
	// 	var tmp = approvalResultLayer.approvalLine.find(a => approvalResultLayer.agreeSeq == a.agreeSeq);
	// 	if(tmp != null && tmp != undefined){
	// 		var author = approvalResultLayer.deputy ? approvalResultLayer.deputy
	// 				:{inSabun: tmp.agreeSabun,
	// 					inOrg: tmp.agreeOrgNm,
	// 					inOrgCd: tmp.agreeOrgCd,
	// 					inJikchak: tmp.agreeJikchakNm,
	// 					inJikwee: tmp.agreeJikweeNm,
	// 					agreeSeq: tmp.agreeSeq};
	//
	// 		data.refers = approvalResultLayer.referersLine.map(a => ({
	// 			...author
	// 			, referName: a.name
	// 			, referSabun: a.ccSabun
	// 			, referOrg: a.ccOrgNm
	// 			, referOrgCd: a.ccOrgCd
	// 			, referJikchak: a.ccJikchakNm
	// 			, referJikchakCd: a.ccJikchakCd
	// 			, referJikwee: a.ccJikweeNm
	// 			, referJikweeCd: a.ccJikweeCd
	// 			, referEmpAlias: a.ccEmpAlias
	// 		})).filter((item, index, self) =>
	// 			index === self.findIndex(i => i.referSabun === item.referSabun)
	// 		);
	// 	}
	// }

	return data;
}

function approvalLayerResultCancel() {
	showOverlay(500);
	const p = {searchApplSeq: '${searchApplSeq}', statusCd: '11'}
	var rv = ajaxCall('/ApprovalMgrResult.do?cmd=updateCancelStatusCd', queryStringToJson(p), false);
	if (Number(rv.cnt) > 0) alert('신청서가 회수되었습니다.');
	else alert('신청서 회수 시 오류가 발생했습니다.');
	hideOverlay();
	closeApprovalMgrResultLayer();
}

function approvalResultLayerPrintPage() {
	let w = 815;
	let h = 900;
	let url = "/ApprovalMgrResult.do?cmd=viewApprovalMgrResultPrintLayer";
	let p = {
		prgCd : '${ctx}${uiInfo.detailPrgCd}',
		applTitle: '${applMasterInfo.title}'
	};

	var printLayer = new window.top.document.LayerModal({
		id: 'approvalMgrResultPrintLayer',
		url: url,
		parameters: p,
		width: w,
		height: h,
		title: '인쇄 미리보기',
		trigger: [
			{
				name: 'approvalMgrResultPrintLayerTrigger',
				callback: function(rv) {
				}
			}
		]
	});
	printLayer.show();
}

<%--function approvalResultLayerPrintPage() {--%>
<%--	$("#printForm").append("<input type='hidden' id='prgCd' name='prgCd' value='" + "${ctx}${uiInfo.detailPrgCd}" + "' />");--%>

<%--	var height = document.body.clientHeight;--%>
<%--	var width = document.body.clientWidth;--%>
<%--	var x = window.screenX || window.screenLeft || 0;--%>
<%--	var y = window.screenY || window.screenTop || 0;--%>

<%--	var popX = x + (width - 900) / 2;--%>
<%--	var popY = y + (height - 900) / 2;--%>

<%--	globalWindowPopup = window.open("", "ApprovalMgrPrint", "width=815px,height=900px,top=" + popY + ",left=" + popX + ",scrollbars=no,resizable=yes,menubar=no");--%>
<%--	$('#printForm').attr({method: 'post', target: 'ApprovalMgrPrint', action: '/ApprovalMgrResult.do?cmd=viewApprovalMgrResultPrint'}).submit();--%>
<%--	globalWindowPopup.focus();--%>
<%--	return;--%>
<%--}--%>

//관리자만 사용하는 저장 function
<c:if test="${adminYn == 'Y'}">
async function approvalLayerResultAdminSave(option) {
	showOverlay(500);

	/* 근로시간단축 신청 */
	if("${searchApplCd}" == "300"){
		/* 결재처리중(근무시간 조정) */
		if($("#applStatusCd").val() == '21' || $("#applStatusCd").val() == '31'){
			var rtn = $("#authorResultFrame").get(0).contentWindow.adminDoSave2('1');

			if(rtn == 0){
				hideOverlay();
				return;
			}
		}
		/* 결재반려 */
		if($("#applStatusCd").val() == '23' || $("#applStatusCd").val() == '33'){
			var rtn = $("#authorResultFrame").get(0).contentWindow.adminDoSave2('2');

			if(rtn == 0){
				hideOverlay();
				return;
			}
		}
	}

	var validation = await callIframeResultSaveLogic(option);
	var statusCd = $('#approvalMgrResultStatusCd').val();
	var applStatusCd = $('#applStatusCd').val();
	var procExecYn = $('#procExecYn').val();
	var afterProcStatusCd = $('#afterProcStatusCd').val();
	var searchApplSabun = $('#searchApplSabun').val();
	//searchApplSeq
	//statusCd
	if (validation) {
		const p = {...approvalResultLayer, statusCd, applStatusCd, procExecYn, afterProcStatusCd, searchApplSabun };
		var rv = ajaxCall('/ApprovalMgrResult.do?cmd=updateStatusCd', queryStringToJson(p), false);
		if (Number(rv.cnt) > 0) {
			alert($('#approvalMgrResultStatusCd option:selected').text() + ' 되었습니다.');
			hideOverlay();
			closeApprovalMgrResultLayer();
		}
	} else {
		hideOverlay();
	}
}
</c:if>

async function saveApprovalMgrResult(option) {
	if (!approvalResultLayer.iframeLoad) return alert('<msg:txt mid="alertFrameLoad" mdef="업무 화면이 로딩 되지 않았습니다.\n 로딩완료후 다시 시도 하십시오." />');
	showOverlay(500); 

	//appl save가 필요한 상황이 안올듯? (결재라인 변경 기능이 없음)
	//참조자는 값만 있으면 save..
	var lines = getApprovalResultLineJson();
	var referSave = lines.refers && lines.refers.length ? 'Save':'';
	var param = {
			...lines,
			...approvalResultLayer,
			referSave: referSave,
			applSave: '',
			agreeGubun: option,
			procExecYn: $('#procExecYn').val(),
			afterProcStatusCd: $('#afterProcStatusCd').val()
		};

	setTimeout(async () => {
		var validation = await callIframeResultSaveLogic(option);
		if (validation) {
			callResultSave(option, param);
			closeApprovalMgrResultLayer();
		}
		hideOverlay();
	}, 1000);
	
}

async function callIframeResultSaveLogic(option) {
	var rtn = false;
	if (approvalResultLayer.prgExists) {
		rtn = await $("#authorResultFrame").get(0).contentWindow.setValue(option);
	} else {
		rtn = true;
	}
	return rtn;
} 

async function callResultSave(option, param) {
	var rv = ajaxTypeJson("${ctx}/ApprovalMgrResult.do?cmd=saveApprovalMgrResult", param, false);
	if (rv) {
		var message = '';
		if (Number(rv.cnt) > 0) {
			if (option == 1) message = "<msg:txt mid='alertOkAppl' mdef='결재 되었습니다.'/>";
			else message = "<msg:txt mid='alertRestoreOk' mdef='반려 되었습니다.'/>";
			try {
				//const p = {applSeq: approvalResultLayer.searchApplSeq, applStatusCd: option, firstDiv: 'N'};
				//ajaxCall("${ctx}/Send.do?cmd=callMailAppl", queryStringToJson(p), false);
			} catch (e) {
				alert('메일전송 중 오류가 발생했습니다.');
			}
		} else {
			if (option == 1) message = "<msg:txt mid='alertErrorAppl' mdef='결재 실패 하였습니다.'/>";
			else message = "<msg:txt mid='alertErrorCompanion' mdef='반려 실패 하였습니다.'/>";
		}
		alert(message);
	}
}
</script>

<div class="wide wrapper modal_layer">
	<div class="modal_body">
		<hr class="no_table">
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
		            <tbody id="approvalResultLayerApplTBody">
		              <tr>
		                <td colspan="7" class="no_file">
		                  <div>
		                    <i class="mdi-ico">drive_file_rename_outline</i>
		                    <span>입력된 결재정보가 없습니다.</span>
		                  </div>
		                </td>
		              </tr>
		            </tbody>
				</table>
			</div>
			<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid='201706090000001' mdef='신청자'/></li>
					<li class="btn"><a id="btnApprovalMgrWebPrint" style="display:none;" href="javascript:approvalResultLayerPrintPage();" class="basic windowPrint">WEB인쇄</a></li>
				</ul>
			</div>
			<div id="approvalMgrResultLayerUserInfo">
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
			</div>
			
			<!-- <div style="width:100%; text-align:right; margin-bottom:1px;">
				<a id="btnApprovalMgrWebPrint" style="display:none;" href="javascript:approvalResultLayerPrintPage();" class="basic windowPrint">WEB인쇄</a>
			</div> -->
			
			<div class="h5"></div>
			<iframe id="authorResultFrame" name="authorResultFrame" frameborder="0" class="author_iframe" style="width:100%; height:100px; min-height:317px;"></iframe>
			
			<div id="uploadDiv" style="display:none">
				<iframe id="approvalMgrResultLayerUploadForm" name="approvalMgrResultLayerUploadForm" frameborder="0" class="author_iframe" style="width:100%; height:150px;"></iframe>
			</div>
			<div id="approvalLayerCommentArea" class="notice" style="display:none;">
		      <div class="notice_title">
		        <i class="mdi-ico">error</i>&nbsp;<span><tit:txt mid='appInstruction' mdef='신청시 유의사항'/></span>
		      </div>
		      <div class="notice_desc">${uiInfo.etcNote}</div>
		    </div>
		    <div class="h15"></div>
		    <table class="sheet_main" id="approvalMgrResultLayerCommentArea" style="display:none;">
				<tr>
					<td>
						<span>
							<table id="approvalMgrResultLayerCommentTable" class="table">
								<colgroup>
									<col width="15%" />
									<col width="70%" />
									<col width="15%" />
								</colgroup>
								<tr id="commentWrite">
									<th class="center" style="border: 1px solid #ebeef0">의견달기</th>
									<td style="border:1px solid #ebeef0;">
										<form id="cmtFrm" name="cmtFrm">
											<textarea id="approvalMgrResultComments" name="approvalMgrResultComments" row="3" style="width:100%;" maxlength="4000"></textarea>
										</form>
									</td>
									<th class="center middle" style="border:1px solid #ebeef0;">
										<span>
											<a href="javascript:approvalMgrResultCommentSave();" class="basic large">의견등록</a>
										</span>
									</th>
								</tr>
							</table>
						</span>
					</td>
				</tr>
	        </table>
	        <form id="approvalMgrResultLayerForm" name="approvalMgrResultLayerForm">
	        	<div id="authorFormAttr">
					<input id="searchApplCd" 	name="searchApplCd" 	type="hidden" value="${searchApplCd}"/>
					<input id="searchApplSeq" 	name="searchApplSeq" 	type="hidden" value="${searchApplSeq}"/>
					<input id="searchApplSabun" name="searchApplSabun" 	type="hidden" value="${searchApplSabun}"/>
					<input id="adminYn" 		name="adminYn" 			type="hidden" value="${param.adminYn}"/>
					<input id="authPg" 			name="authPg" 			type="hidden" value="${authPg}"/>
					<input id="searchApplYmd" 	name="searchApplYmd" 	type="hidden" value="${searchApplYmd}"/>
					<input id="searchSabun" 	name="searchSabun" 		type="hidden" value="${searchSabun}"/>
					<input id="referUserStr" 	name="referUserStr" 	type="hidden" value=""/>
					<input id="applStatusCd" 	name="applStatusCd" 	type="hidden" value="${applMasterInfo.applStatusCd}"/>
					<input id="fileSeq"			name="fileSeq"			type="hidden" value=""/>
					<input id="agreeSeq"		name="agreeSeq"			type="hidden" value=""/>
					<input id="agreeGubun"		name="agreeGubun"		type="hidden" value=""/>
					<input id="referUserOriEtc"	name="referUserOriEtc"	type="hidden" value=""/>
					<input id="referUserNewEtc"	name="referUserNewEtc"	type="hidden" value=""/>
					<input id="applSave" 		name="applSave" 		type="hidden" value=""/>
					<input id="referSave" 		name="referSave" 		type="hidden" value=""/>
					<input id="pathSeq" 		name="pathSeq" 			type="hidden" value=""/>
					<input id="gubun" 			name="gubun" 			type="hidden" value="${gubun}"/>
					<input id="procExecYn"      name="procExecYn"       type="hidden" value="${uiInfo.procExecYn}"/>
			        <input id="afterProcStatusCd"name="afterProcStatusCd"type="hidden" value="${applMasterInfo.applStatusCd}"/> <!-- 이전신청서 상태코드  2020.01.14 -->
					<input id="etc01"			name="etc01"			type="hidden" value="${etc01}"/>
					<input id="etc02"			name="etc02"			type="hidden" value="${etc02}"/>
					<input id="etc03"			name="etc03"			type="hidden" value="${etc03}"/>
					<input id="deputyInfo"		name="deputyInfo"		type="hidden" value=""/>
					<input id="agreeUserStatus"	name="agreeUserStatus"	type="hidden" value=""/> <!-- 결재/반려 여부 -->
		            <input id="applYn"          name="applYn"           type="hidden" value="${applYn}"/> <!-- 현 결재자와 세션사번이 같은지 여부 -->
				</div>
				
				<table id="approvalMgrResultMemoTable" border="0" cellpadding="0" cellspacing="0" class="settle mat20">
					<colgroup>
						<col width="25%" />
						<col width="75%" />
					</colgroup>
				</table>
				
				<div id="approvalMgrResultRefArea" class="sheet_title mat10">
					<ul>
						<li class="txt">수신참조 내역</li>
					</ul>
				</div>
				
				<table id="approvalMgrResultReferTable" border="0" cellpadding="0" cellspacing="0" class="settle mat10">
					<colgroup>
						<col width="40%" />
						<col width="60%" />
					</colgroup>
					<tr>
						<th><tit:txt mid='113912' mdef='권한추가자'/></th>
						<th><tit:txt mid='112372' mdef='참조자'/></th>
					</tr>
				</table>
				
				<table id="approvalMgrResultstatusTable" border="0" cellpadding="0" cellspacing="0" class="settle mat10" style="display:none">
					<colgroup>
						<col width="15%" />
						<col width="85%" />
					</colgroup>
					<tr>
						<th><tit:txt mid='112999' mdef='결재상태'/></th>
						<td>
							<select id="approvalMgrResultStatusCd" style="appearance:auto" name="approvalMgrResultStatusCd" >
							</select>
						</td>
					</tr>
				</table>
			</form>
		</hr>
	</div>
	<div class="modal_footer">
	  <button type="button" id="btnApplConfirm" class="btn filled" onclick="approvalLayerResultComment('1')" style="display:none;">결재</button>
		<button type="button" id="btnApplReject" class="btn filled" onclick="approvalLayerResultComment('0')" style="display:none;">반려</button>
		<button type="button" id="btnApplRecall" class="btn filled" onclick="approvalLayerResultCancel()" style="display:none;">회수</button>
		<button type="button" id="btnApplReuse" class="btn filled" onclick="approvalLayerResultReUse('0')" style="display:none;">재사용</button>
		<button type="button" id="btnApplSave" class="btn filled" onclick="approvalLayerResultAdminSave('3')" style="display:none;">저장</button>
		<button type="button" id="btnApplCancel" class="btn outline_gray" onclick="closeApprovalMgrResultLayer()">닫기</button>
	</div>

	<form id="printForm" name="printForm"></form>
	<!-- 결재의견 팝업 -->
	<div class="layer-cmt modal_background" style="border-radius:20px;"></div>
	<div class="layer-cmt modal modal-size width-md height-sm" style="display: none;">
		<div class="modal_header">
			<span id="appCmtTitle">결재의견</span><i class="mdi-ico" onclick="closeApprovalMgrPopCmt()">close</i>
		</div>
		<div class="modal_body h-auto" style="height: auto;">
			<form id="popFrm" name="popFrm" >
				<table class="default">
					<tr>
						<td class="content">
							<textarea id="approvalMgrResultMemo" name="approvalMgrResultMemo" rows="3" class="${textCss} w100p"></textarea>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<div class="modal_footer">
			<btn:a id="cmtBtn" href="javascript:saveApprovalMgrComment();" mid="ok" mdef="확인" css="btn filled"/>
			<btn:a href="javascript:closeApprovalMgrPopCmt();" mid="close" mdef="닫기" css="btn outline_gray"/>
		</div>
	</div>
</div>
