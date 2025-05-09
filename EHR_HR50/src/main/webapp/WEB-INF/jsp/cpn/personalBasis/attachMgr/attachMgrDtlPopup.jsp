<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>압류세부내역</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%--<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>--%>
<!--
 * 압류관리
 * @author JM 
--> 
<script type="text/javascript">
var gPRow = "";
var pGubun = "";

$(function() {
	
	createIBSheet3(document.getElementById('attachMgrDtlLayerSht-wrap'), "attachMgrDtlLayerSht", "100%", "300px","${ssnLocaleCd}");

	const modal = window.top.document.LayerModalUtility.getModal('attachMgrDtlLayer');

	const sabun  		=         modal.parameters.sabun;
	const name          =         modal.parameters.name;
	const jikgubCd      =         modal.parameters.jikgubCd;
	const jikchakCd     =         modal.parameters.jikchakCd;
	const orgNm         =         modal.parameters.orgNm;
	const statusCd      =         modal.parameters.statusCd;
	const attatchSymd   =         modal.parameters.attatchSymd;
	const attatchNo     =         modal.parameters.attatchNo;
	const attatchNoReadonly = 	modal.parameters.attatchNoReadonly;
	const attatchType   =         modal.parameters.attatchType;
	const attatchStatus =         modal.parameters.attatchStatus;
	const debtContent   =         modal.parameters.debtContent;
	const relationEvent =         modal.parameters.relationEvent;
	const bonder        =         modal.parameters.bonder;
	const bondCharger   =         modal.parameters.bondCharger;
	const bondTelNo     =         modal.parameters.bondTelNo;
	const bondContent   =         modal.parameters.bondContent;
	const bondHandNo    =         modal.parameters.bondHandNo;
	const attBankNm     =         modal.parameters.attBankNm;
	const attAccountNo  =         modal.parameters.attAccountNo;
	const attDepositor  =         modal.parameters.attDepositor;
	const attachMon     =         modal.parameters.attachMon;
	const attTotMon     =         modal.parameters.attTotMon;
	const receiptMon    =         modal.parameters.receiptMon;
	const remainAmt     =         modal.parameters.remainAmt;
	const courtYmd      =         modal.parameters.courtYmd;
	const invalidYmd    =         modal.parameters.invalidYmd;
	const elementCd     =         modal.parameters.elementCd;
	const elementNm     =         modal.parameters.elementNm;
	const note          =         modal.parameters.note;
	const sAction       =         modal.parameters.sAction;
	const jikgubNm      =         modal.parameters.jikgubNm;
	const jikchakNm     =         modal.parameters.jikchakNm;
	const statusNm      =         modal.parameters.statusNm;

	var initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad, Page:22};
	initdata.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};
	initdata.Cols = [
		{Header:"No",	Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"삭제",	Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
		{Header:"상태",	Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 },
		{Header:"사번",	Type:"Text",		Hidden:1,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"사건번호",	Type:"Text",	Hidden:1,					Width:90,			Align:"Left",	ColMerge:0,	SaveName:"attatchNo",	KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:20 },
		{Header:"순번",		Type:"Int",		Hidden:1,					Width:50,			Align:"Right",	ColMerge:0,	SaveName:"seq",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"공탁일자",	Type:"Date",	Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"depositYmd",	KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
		{Header:"공탁금",	Type:"Int",		Hidden:0,					Width:150,			Align:"Right",	ColMerge:0,	SaveName:"depositAmt",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"공탁기관",	Type:"Text",	Hidden:0,					Width:200,			Align:"Left",	ColMerge:0,	SaveName:"depositOrgNm",KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:30 },
		{Header:"수수료",	Type:"Int",		Hidden:0,					Width:150,			Align:"Right",	ColMerge:0,	SaveName:"fee",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
	]; IBS_InitSheet(attachMgrDtlLayerSht, initdata); attachMgrDtlLayerSht.SetCountPosition(0);
	attachMgrDtlLayerSht.SetSheetHeight(150);

	// 사건구분(C00200)
	var searchAttatchType = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "C00200"), " ");
	$("#attatchType").html(searchAttatchType[2]);

	// 압류진행상태(C00020)
	var searchAttatchStatus = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "C00020"), " ");
	$("#attatchStatus").html(searchAttatchStatus[2]);

	$("#attachMon").bind("keyup",function(event){
		makeNumber(this, 'A');
		Num_Comma(this);
	});

	$("#sabun").val(sabun);
	$("#name").val(name);
	$("#jikgubCd").val(jikgubCd);
	$("#jikchakCd").val(jikchakCd);
	$("#orgNm").val(orgNm);
	$("#statusCd").val(statusCd);
	$("#attatchSymd").val(attatchSymd);
	$("#attatchNo").val(attatchNo);
	$("#attatchNoReadonly").val(attatchNoReadonly);
	$("#attatchType").val(attatchType);
	$("#attatchStatus").val(attatchStatus);
	$("#debtContent").val(debtContent);
	$("#relationEvent").val(relationEvent);
	$("#bonder").val(bonder);
	$("#bondCharger").val(bondCharger);
	$("#bondTelNo").val(bondTelNo);
	$("#bondContent").val(bondContent);
	$("#bondHandNo").val(bondHandNo);
	$("#attBankNm").val(attBankNm);
	$("#attAccountNo").val(attAccountNo);
	$("#attDepositor").val(attDepositor);
	$("#attachMon").val(setComma(attachMon));
	$("#attTotMon").val(setComma(attTotMon));
    $("#receiptMon").val(setComma(receiptMon));
	$("#remainAmt").val(setComma(remainAmt));
	$("#courtYmd").val(courtYmd);
	$("#invalidYmd").val(invalidYmd);
	$("#elementCd").val(elementCd);
	$("#elementNm").val(elementNm);
	$("#note").val(note);
	$("#jikgubNm").val(jikgubNm);
	$("#jikchakNm").val(jikchakNm);
	$("#statusNm").val(statusNm);

	if (sAction && sAction !== "Update") {
		$("#btnDepositInfo").css("display","none"); // 공택내역 관련 버튼
		initEmployeeHeader("name");
	} else {
		if (sabun && attatchNo) {
			$("#name").addClass("transparent readonly").prop("readonly", true);
			$("#attatchNo").css("display","none");
			$("#attatchNoReadonly").css("display","");
			doAction1("Search");
		}
	}

	$(window).smartresize(sheetResize);
	sheetInit();

	$("#attatchSymd").datepicker2();
	$("#courtYmd").datepicker2();
	$("#invalidYmd").datepicker2();

});

function setComma(str) {
	s = new String(str);
	s = s.replace(/\D/g,"");
	if (s.substr(0,1) == 0) {
		s = s.substr(1);
	}
	l=s.length-3;
	while(l>0) {
		s = s.substr(0,l)+","+s.substr(l);
		l-=3;
	}
	return s;
}

// 필수값/유효성 체크
function chkInVal(sAction) {
	if($("#sabun").val() == "") {
		alert("대상자를 선택하십시오.");
		$("#name").focus();
		return false;
	}
	if($("#attatchSymd").val() == "") {
		alert("접수일을 입력하십시오.");
		$("#attatchSymd").focus();
		return false;
	}
	if($("#attatchNo").val() == "") {
		alert("사건번호를 입력하십시오.");
		$("#attatchNo").focus();
		return false;
	}
	if($("#attatchType").val() == "") {
		alert("사건구분을 입력하십시오.");
		$("#attatchType").focus();
		return false;
	}
	if($("#attatchStatus").val() == "") {
		alert("진행상태를 입력하십시오.");
		$("#attatchStatus").focus();
		return false;
	}

	if ($("#courtYmd").val() != "" && $("#invalidYmd").val() != "") {
		if (!checkFromToDate($("#courtYmd"),$("#invalidYmd"),"결정일","종료일","YYYYMMDD")) {
			return false;
		}
	}
	return true;
}

//항목검색 팝업
function elementSearchPopup() {
	let layerModal = new window.top.document.LayerModal({
		id : 'payElementLayer'
		, url : '/PayElementPopup.do?cmd=viewPayElementLayer&authPg=${authPg}'
		, parameters : {
			"elementType": "D" // 공제
		}
		, width : 700
		, height : 520
		, title : '수당,공제 항목'
		, trigger :[
			{
				name : 'payTrigger'
				, callback : function(result){
					$("#elementCd").val(result.resultElementCd);
					$("#elementNm ").val(result.resultElementNm);
				}
			}
		]
	});
	layerModal.show();
}


function doAction1(sAction) {
	switch (sAction) {
		case "Search":
			attachMgrDtlLayerSht.DoSearch("/AttachMgr.do?cmd=getAttachMgrDepositInfoList", $("#attachMgrDtlLayerShtForm").serialize());
			break;

		case "Save":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			// 압류세부내역 저장
			if (confirm("저장 하시겠습니까?")) {
				var result = ajaxCall("${ctx}/AttachMgr.do?cmd=saveAttachMgrDtl",$("#attachMgrDtlLayerShtForm").serialize(),false);

				if (result != null && result["Result"] != null && result["Result"]["Code"] != null) {
					if (parseInt(result["Result"]["Code"]) > 0) {
						alert("저장되었습니다.");
						closeLayerModal("Save");
					} else if (result["Result"]["Message"] != null && result["Result"]["Message"] != "") {
						alert(result["Result"]["Message"]);
					}
				} else {
					alert("저장 오류입니다.");
				}
			}
			break;

		case "SaveDeposit":
			// 공탁내역 저장
			IBS_SaveName(document.attachMgrDtlLayerShtForm,attachMgrDtlLayerSht);
			attachMgrDtlLayerSht.DoSave("${ctx}/AttachMgr.do?cmd=saveAttachMgrDepositInfo", $("#attachMgrDtlLayerShtForm").serialize());
			break;

		case "Insert":
			var Row = attachMgrDtlLayerSht.DataInsert(0);
			attachMgrDtlLayerSht.SetCellValue(Row, "sabun", $("#sabun").val());
			attachMgrDtlLayerSht.SetCellValue(Row, "attatchNo", $("#attatchNo").val());
			attachMgrDtlLayerSht.SelectCell(Row, 2);

			$(window).smartresize(sheetResize);
			sheetInit();
			break;

		case "Copy":
			var Row = attachMgrDtlLayerSht.DataCopy();
			attachMgrDtlLayerSht.SelectCell(Row, 2);
			break;
	}
}

//조회 후 에러 메시지
function attachMgrDtlLayerSht_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

//저장 후 메시지
function attachMgrDtlLayerSht_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "") {
			alert(Msg);
		}
		// closeLayerModal();
	} catch (ex) {
		alert("OnSaveEnd Event Error " + ex);
	}
}

function initEmployeeHeader(inputId) {
	$("#"+inputId).autocomplete(employeeOption(inputId)).data("uiAutocomplete")._renderItem = employeeRenderItem;
}

function employeeOption(inputId) {
	return {
		source: function( request, response ) {
			$.ajax({
				url : "/Employee.do?cmd=employeeList",
				dateType : "json",
				type: "post",
				data: "searchKeyword="+encodeURIComponent($("#"+inputId).val())+"&searchEmpType=I&orderYn=N",
				async: false,
				success: function(data) {
					response( $.map( data.DATA, function( item ) {
						return {
							label: item.empName,
							searchNm	:   $("#" + inputId).val(),
							enterCd 	:	item.enterCd,
							empSabun 	:	item.empSabun,
							empName 	:	item.empName,
							jikgubCd	:	item.jikgubCd,
							jikgubNm	:	item.jikgubNm,
							jikchakCd	:	item.jikchakCd,
							jikchakNm	:	item.jikchakNm,
							jikweeCd	:	item.jikweeCd,
							jikweeNm	:	item.jikweeNm,
							orgNm		:	item.orgNm,
							statusNm	:	item.statusNm
						};
					}));
				},
				error: function(e) {
					alert(e.responseText);
				}
			});
		},
		delay:50,
		autoFocus: false,
		minLength: 2,
		select: function(event, ui) {
			$("#sabun").val(ui.item.empSabun);
			$("#name").val(ui.item.label);
			$("#jikgubCd").val(ui.item.jikgubCd);
			$("#jikgubNm").val(ui.item.jikgubNm);
			$("#jikchakCd").val(ui.item.jikchakCd);
			$("#jikchakNm").val(ui.item.jikchakNm);
			$("#jikweeCd").val(ui.item.jikweeCd);
			$("#jikweeNm").val(ui.item.jikweeNm);
			$("#orgNm").val(ui.item.orgNm);
			$("#statusCd").val(ui.item.statusCd);
			$("#statusNm").val(ui.item.statusNm);
		},
		focus: function() {
			return false;
		},
		open: function() {
			$( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
			document.querySelectorAll(".ui-autocomplete").forEach((_el) => _el.style.setProperty("z-index", 999, "important"));
		},
		close: function() {
			$( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
		}
	};
}

function employeeRenderItem(ul, item) {
	return $("<li />")
			.data("item.autocomplete", item)
			.append(`<a class="employeeLIst">
					     <div class="inner-wrap">
							 <img style="height: 50px; width: 50px; border-radius: 50%;" src="EmpPhotoOut.do?enterCd=\${item.enterCd}&searchKeyword=\${item.empSabun}&t=\${(new Date()).getTime()}"/>
					         <span class="name">
								 \${String(item.empName).split(item.searchNm).join('<b class="f_blue f_bold">'+item.searchNm+'</b>')}
								 &nbsp;[\${String(item.empSabun).split(item.searchNm).join('<b class="f_blue f_bold">'+item.searchNm+'</b>')}]
								 <br/>\${item.orgNm}
							 </span>
<!--							 <span class='sabun'>[\${String(item.empSabun).split(item.searchNm).join('<b class="f_gray_3 f_bold">'+item.searchNm+'</b>')}]<br/></span>-->
							 <span>\${item.jikweeNm}</span>
					         <span class="ml-auto status">\${item.statusNm}</span>
						 </div>
					 </a>`).appendTo(ul);
}

function closeLayerModal(sAction) {
	const modal = window.top.document.LayerModalUtility.getModal('attachMgrDtlLayer');
	modal.fire('attachMgrDtlTrigger', {
		sAction: sAction
	}).hide();
}
</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
	<div class="modal_body" style="overflow-y: auto;">
		<form id="attachMgrDtlLayerShtForm" name="attachMgrDtlLayerShtForm">
			<input type="hidden" id="elementCd" name="elementCd" value="" />
			<div class="sheet_title outer">
				<ul>
					<li class="txt">대상자</li>
					<li class="btn">
					</li>
				</ul>
			</div>
			<table border="0" cellpadding="0" cellspacing="0" class="table outer">
				<colgroup>
					<col width="13%" />
					<col width="20%" />
					<col width="13%" />
					<col width="20%" />
					<col width="13%" />
					<col width="21%" />
				</colgroup>
				<tr>
					<th>성명</th>
					<td>
						<input type="text" id="name" name="name" class="text" />
					</td>
					<th>사번</th>
					<td>
						<input type="text" id="sabun" name="sabun" class="text transparent required readonly" readonly />
					</td>
					<th>직급</th>
					<td>
						<input type="text" id="jikgubNm" name="jikgubNm" class="text transparent readonly w100p" readonly />
						<input type="hidden" id="jikgubCd" name="jikgubCd" class="text" />
					</td>
				</tr>
				<tr>
					<th>직책</th>
					<td>
						<input type="text" id="jikchakNm" name="jikchakNm" class="text transparent readonly w100p" readonly />
						<input type="hidden" id="jikchakCd" name="jikchakCd" class="text" />
					</td>
					<th>소속</th>
					<td>
						<input type="text" id="orgNm" name="orgNm" class="text transparent readonly w100p" readonly />
					</td>
					<th>재직상태</th>
					<td>
						<input type="text" id="statusNm" name="statusNm" class="text transparent readonly w100p" readonly />
						<input type="hidden" id="statusCd" name="statusCd" class="text" />
					</td>
				</tr>
			</table>
			<div class="sheet_title outer">
				<ul>
					<li class="txt">사건내역</li>
				</ul>
			</div>
			<table border="0" cellpadding="0" cellspacing="0" class="table outer">
				<colgroup>
					<col width="13%" />
					<col width="20%" />
					<col width="13%" />
					<col width="20%" />
					<col width="13%" />
					<col width="21%" />
				</colgroup>
				<tr>
					<th>접수일</th>
					<td colspan="5"><input type="text" id="attatchSymd" name="attatchSymd" class="${dateCss} required date2" /></td>
				</tr>
				<tr>
					<th>사건번호</th>
					<td><input type="text" id="attatchNo" name="attatchNo" class="text required w100p" /><input type="text" id="attatchNoReadonly" name="attatchNoReadonly" class="text required readonly w100p" readonly style="display:none" /></td>
					<th>사건구분</th>
					<td><select id="attatchType" name="attatchType" class="required"></select></td>
					<th>진행상태</th>
					<td><select id="attatchStatus" name="attatchStatus"  class="required"></select></td>
				</tr>
				<tr>
					<th>채무내용</th>
					<td><input type="text" id="debtContent" name="debtContent" class="text w100p" /></td>
					<th>관련사건</th>
					<td colspan="3"><input type="text" id="relationEvent" name="relationEvent" class="text w100p" /></td>
				</tr>
			</table>

			<div class="sheet_title outer">
				<ul>
					<li class="txt">채권자 정보</li>
				</ul>
			</div>
			<table border="0" cellpadding="0" cellspacing="0" class="table outer">
				<colgroup>
					<col width="13%" />
					<col width="20%" />
					<col width="13%" />
					<col width="20%" />
					<col width="13%" />
					<col width="21%" />
				</colgroup>
				<tr>
					<th>채권자</th>
					<td><input type="text" id="bonder" name="bonder" class="text w100p" /></td>
					<th>담당자</th>
					<td><input type="text" id="bondCharger" name="bondCharger" class="text w100p" /></td>
					<th>전화번호</th>
					<td><input type="text" id="bondTelNo" name="bondTelNo" class="text w100p" /></td>
				</tr>
				<tr>
					<th>채권내용</th>
					<td colspan="3"><input type="text" id="bondContent" name="bondContent" class="text w100p" /></td>
					<th>이동전화</th>
					<td><input type="text" id="bondHandNo" name="bondHandNo" class="text w100p" /></td>
				</tr>
				<tr>
					<th>은행</th>
					<td><input type="text" id="attBankNm" name="attBankNm" class="text w100p" /></td>
					<th>계좌번호</th>
					<td><input type="text" id="attAccountNo" name="attAccountNo" class="text w100p" /></td>
					<th>예금주명</th>
					<td><input type="text" id="attDepositor" name="attDepositor" class="text w100p" /></td>
				</tr>
			</table>
			<div class="sheet_title outer">
				<ul>
					<li class="txt">청구 및 공제내역</li>
				</ul>
			</div>
			<table border="0" cellpadding="0" cellspacing="0" class="table outer">
				<colgroup>
					<col width="13%" />
					<col width="20%" />
					<col width="13%" />
					<col width="20%" />
					<col width="13%" />
					<col width="21%" />
				</colgroup>
				<tr>
					<th>청구액</th>
					<td><input type="text" id="attachMon" name="attachMon" class="text w100p right" /></td>
					<th>공제누계액</th>
					<td><input type="text" id="attTotMon" name="attTotMon" class="text w100 right readonly" readonly /></td>
					<th style="display:none;">입금누계액</th>
					<td style="display:none;"><input type="text" id="receiptMon" name="receiptMon" class="text w100p right readonly" readonly /></td>
					<th>급여공제항목</th>
					<td>
						<div class="search-outer">
							<input type="text" id="elementNm" name="elementNm" class="text w70 left readonly" readonly "/>
							<a onclick="javascript:elementSearchPopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
						</div>
					
					</td>
				</tr>
				<tr style="display:none">
					<th>청구잔액</th>
					<td colspan="5"><input type="text" id="remainAmt" name="remainAmt" class="text right readonly" readonly /></td>
				</tr>
			</table>
			<div class="sheet_title outer">
				<ul>
					<li class="txt">공탁내역</li>
					<li class="btn" id="btnDepositInfo">
						<a href="javascript:doAction1('Insert')"		class="basic authA">입력</a>
						<a href="javascript:doAction1('Copy')"			class="basic authA">복사</a>
						<a href="javascript:doAction1('SaveDeposit')"	class="basic authA">저장</a>
					</li>
				</ul>
			</div>
			<div id="attachMgrDtlLayerSht-wrap"></div>
			
			<div class="sheet_title outer">
				<ul>
					<li class="txt">기타 내역</li>
				</ul>
			</div>
			<table border="0" cellpadding="0" cellspacing="0" class="table outer">
				<colgroup>
					<col width="13%" />
					<col width="20%" />
					<col width="13%" />
					<col width="54%" />
				</colgroup>
				<tr>
					<th>결정일</th>
					<td><input type="text" id="courtYmd" name="courtYmd" class="text date2 w70" /></td>
					<th>종료일</th>
					<td><input type="text" id="invalidYmd" name="invalidYmd" class="text date2 w70"/></td>
				</tr>
				<tr>
					<th>비고</th>
					<td colspan="3"><input type="text" id="note" name="note" class="text w100p"/></td>
				</tr>
			</table>
		</form>
	</div>
	<div class="modal_footer">
		<a href="javascript:doAction1('Save')"	class="btn filled">저장</a>
		<a href="javascript:closeLayerModal('Close');"	class="btn outline_gray">닫기</a>
	</div>
</div>
</body>
</html>
