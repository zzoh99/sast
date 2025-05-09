<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>압류세부내역</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 압류관리
 * @author JM 
--> 
<script type="text/javascript">
var gPRow = "";
var pGubun = "";

var p = eval("${popUpStatus}");
$(function() {
	var arg = p.window.dialogArguments;

	var sabun  		  = "";
	var name          = "";
	var jikgubCd      = "";
	var jikchakCd     = "";
	var orgNm         = "";
	var statusCd      = "";
	var attatchSymd   = "";
	var attatchNo     = "";
	var attatchNoReadonly     = "";
	var attatchType   = "";
	var attatchStatus = "";
	var debtContent   = "";
	var relationEvent = "";
	var bonder        = "";
	var bondCharger   = "";
	var bondTelNo     = "";
	var bondContent   = "";
	var bondHandNo    = "";
	var attBankNm     = "";
	var attAccountNo  = "";
	var attDepositor  = "";
	var attachMon    = "";
	var attTotMon    = "";
	var receiptMon   = "";
	var remainAmt    = "";
	var courtYmd      = "";
	var invalidYmd    = "";
	var elementCd     = "";
	var note          = "";
	var sAction = "";
	var jikgubNm      = "";
	var jikchakNm     = "";
	var statusNm      = "";

    if( arg != undefined ) {
   		sabun  		  =         arg["sabun"];
   		name          =         arg["name"];
   		jikgubCd      =         arg["jikgubCd"];
   		jikchakCd     =         arg["jikchakCd"];
   		orgNm         =         arg["orgNm"];
   		statusCd      =         arg["statusCd"];
   		attatchSymd   =         arg["attatchSymd"];
   		attatchNo     =         arg["attatchNo"];
   		attatchNoReadonly     =         arg["attatchNoReadonly"];
   		attatchType   =         arg["attatchType"];
   		attatchStatus =         arg["attatchStatus"];
   		debtContent   =         arg["debtContent"];
   		relationEvent =         arg["relationEvent"];
   		bonder        =         arg["bonder"];
   		bondCharger   =         arg["bondCharger"];
   		bondTelNo     =         arg["bondTelNo"];
   		bondContent   =         arg["bondContent"];
   		bondHandNo    =         arg["bondHandNo"];
   		attBankNm     =         arg["attBankNm"];
   		attAccountNo  =         arg["attAccountNo"];
   		attDepositor  =         arg["attDepositor"];
   		attachMon     =         arg["attachMon"];
   		attTotMon     =         arg["attTotMon"];
   		receiptMon    =         arg["receiptMon"];
   		remainAmt     =         arg["remainAmt"];
   		courtYmd      =         arg["courtYmd"];
   		invalidYmd    =         arg["invalidYmd"];
   		elementCd     =         arg["elementCd"];
   		note          =         arg["note"];
   		sAction       =         arg["sAction"];
   		jikgubNm      =         arg["jikgubNm"];
   		jikchakNm     =         arg["jikchakNm"];
   		statusNm      =         arg["statusNm"];
    }else{
    	if(p.popDialogArgument("sabun")!=null)				sabun  		  		=  p.popDialogArgument("sabun");
    	if(p.popDialogArgument("name")!=null)				name          		=  p.popDialogArgument("name");
    	if(p.popDialogArgument("jikgubCd")!=null)			jikgubCd      		=  p.popDialogArgument("jikgubCd");
    	if(p.popDialogArgument("jikchakCd")!=null)			jikchakCd     		=  p.popDialogArgument("jikchakCd");
    	if(p.popDialogArgument("orgNm")!=null)				orgNm         		=  p.popDialogArgument("orgNm");
    	if(p.popDialogArgument("statusCd")!=null)			statusCd      		=  p.popDialogArgument("statusCd");
    	if(p.popDialogArgument("attatchSymd")!=null)		attatchSymd   		=  p.popDialogArgument("attatchSymd");
    	if(p.popDialogArgument("attatchNo")!=null)			attatchNo     		=  p.popDialogArgument("attatchNo");
    	if(p.popDialogArgument("attatchNoReadonly")!=null)	attatchNoReadonly   =  p.popDialogArgument("attatchNoReadonly");
    	if(p.popDialogArgument("attatchType")!=null)		attatchType   		=  p.popDialogArgument("attatchType");
    	if(p.popDialogArgument("attatchStatus")!=null)		attatchStatus 		=  p.popDialogArgument("attatchStatus");
    	if(p.popDialogArgument("debtContent")!=null)		debtContent   		=  p.popDialogArgument("debtContent");
    	if(p.popDialogArgument("relationEvent")!=null)		relationEvent 		=  p.popDialogArgument("relationEvent");
    	if(p.popDialogArgument("bonder")!=null)				bonder        		=  p.popDialogArgument("bonder");
    	if(p.popDialogArgument("bondCharger")!=null)		bondCharger   		=  p.popDialogArgument("bondCharger");
    	if(p.popDialogArgument("bondTelNo")!=null)			bondTelNo     		=  p.popDialogArgument("bondTelNo");
    	if(p.popDialogArgument("bondContent")!=null)		bondContent   		=  p.popDialogArgument("bondContent");
    	if(p.popDialogArgument("bondHandNo")!=null)			bondHandNo    		=  p.popDialogArgument("bondHandNo");
    	if(p.popDialogArgument("attBankNm")!=null)			attBankNm     		=  p.popDialogArgument("attBankNm");
    	if(p.popDialogArgument("attAccountNo")!=null)		attAccountNo  		=  p.popDialogArgument("attAccountNo");
    	if(p.popDialogArgument("attDepositor")!=null)		attDepositor  		=  p.popDialogArgument("attDepositor");
    	if(p.popDialogArgument("attachMon")!=null)			attachMon     		=  p.popDialogArgument("attachMon");
    	if(p.popDialogArgument("attTotMon")!=null)			attTotMon     		=  p.popDialogArgument("attTotMon");
    	if(p.popDialogArgument("receiptMon")!=null)			receiptMon    		=  p.popDialogArgument("receiptMon");
    	if(p.popDialogArgument("remainAmt")!=null)			remainAmt     		=  p.popDialogArgument("remainAmt");
    	if(p.popDialogArgument("courtYmd")!=null)			courtYmd      		=  p.popDialogArgument("courtYmd");
    	if(p.popDialogArgument("invalidYmd")!=null)			invalidYmd    		=  p.popDialogArgument("invalidYmd");
    	if(p.popDialogArgument("elementCd")!=null)			elementCd     		=  p.popDialogArgument("elementCd");
    	if(p.popDialogArgument("note")!=null)				note          		=  p.popDialogArgument("note");
    	if(p.popDialogArgument("sAction")!=null)			sAction       		=  p.popDialogArgument("sAction");
    	if(p.popDialogArgument("jikgubNm")!=null)			jikgubNm       		=  p.popDialogArgument("jikgubNm");
    	if(p.popDialogArgument("jikchakNm")!=null)			jikchakNm       	=  p.popDialogArgument("jikchakNm");
    	if(p.popDialogArgument("statusNm")!=null)			statusNm       		=  p.popDialogArgument("statusNm");
    }




	var initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad, Page:22};
	initdata.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};
	initdata.Cols = [
		{Header:"No",	Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"삭제",	Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
		{Header:"상태",	Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 },
		{Header:"사번",	Type:"Text",		Hidden:1,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"사건번호",	Type:"Text",		Hidden:1,					Width:90,			Align:"Left",	ColMerge:0,	SaveName:"attatchNo",	KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:20 },
		{Header:"순번",	Type:"Int",			Hidden:1,					Width:50,			Align:"Right",	ColMerge:0,	SaveName:"seq",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"공탁일자",	Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"depositYmd",	KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
		{Header:"공탁금",	Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"depositAmt",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"공탁기관",	Type:"Text",		Hidden:0,					Width:100,			Align:"Left",	ColMerge:0,	SaveName:"depositOrgNm",KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:30 },
		{Header:"수수료",	Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"fee",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
	]; IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(0);

	// 직급코드(H20010)
	var jikgubCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20010"), "");
	$("#jikgubCd").val(jikgubCd[2]);

	// 직책코드(H20020)
	var jikchakCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20020"), "");
	$("#jikchakCd").val(jikchakCd[2]);

	// 재직상태코드(H10010)
	var statusCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10010"), "");
	$("#statusCd").val(statusCd[2]);

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

	$("#sabun")				.val(sabun);
	$("#name")				.val(name);
	$("#jikgubCd")			.val(jikgubCd);
	$("#jikchakCd")			.val(jikchakCd);
	$("#orgNm")				.val(orgNm);
	$("#statusCd")			.val(statusCd);
	$("#attatchSymd")		.val(attatchSymd);
	$("#attatchNo")			.val(attatchNo);
	$("#attatchNoReadonly")	.val(attatchNoReadonly);
	$("#attatchType")		.val(attatchType);
	$("#attatchStatus")		.val(attatchStatus);
	$("#debtContent")		.val(debtContent);
	$("#relationEvent")		.val(relationEvent);
	$("#bonder")			.val(bonder);
	$("#bondCharger")		.val(bondCharger);
	$("#bondTelNo")			.val(bondTelNo);
	$("#bondContent")		.val(bondContent);
	$("#bondHandNo")		.val(bondHandNo);
	$("#attBankNm")			.val(attBankNm);
	$("#attAccountNo")		.val(attAccountNo);
	$("#attDepositor")		.val(attDepositor);
	$("#attachMon").val(setComma(attachMon));
	$("#attTotMon").val(setComma(attTotMon));
    $("#receiptMon").val(setComma(receiptMon));
	$("#remainAmt").val(setComma(remainAmt));
	$("#courtYmd")			.val(courtYmd);
	$("#invalidYmd")		.val(invalidYmd);
	$("#elementCd")			.val(elementCd);
	$("#note")				.val(note);
	$("#jikgubNm")			.val(jikgubNm);
	$("#jikchakNm")			.val(jikchakNm);
	$("#statusNm")			.val(statusNm);

	if (sAction != null && typeof sAction != "undefined" && sAction != "Update") {
		$("#btnDepositInfo").css("display","none"); // 공택내역 관련 버튼
	} else {
		if ($("#sabun").val() != null && $("#sabun").val() != "" && $("#attatchNo").val() != null && $("#attatchNo").val() != "") {
			$("#btnEmpSearch").css("display","none"); // 사원검색 버튼
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

	$(".close").click(function() {
		p.self.close();
	});
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

	if ($("#courtYmd").val() != "" && $("#invalidYmd").val() != "") {
		if (!checkFromToDate($("#courtYmd"),$("#invalidYmd"),"결정일","종료일","YYYYMMDD")) {
			return false;
		}
	}
	return true;
}

function doAction1(sAction) {
	switch (sAction) {
		case "Search":
			sheet1.DoSearch("${ctx}/AttachMgr.do?cmd=getAttachMgrDepositInfoList", $("#sheet1Form").serialize());
			break;

		case "Save":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			// 압류세부내역 저장
			if (confirm("저장 하시겠습니까?")) {
				var result = ajaxCall("${ctx}/AttachMgr.do?cmd=saveAttachMgrDtl",$("#sheet1Form").serialize(),false);

				if (result != null && result["Result"] != null && result["Result"]["Code"] != null) {
					if (parseInt(result["Result"]["Code"]) > 0) {
						alert("저장되었습니다.");
						p.popReturnValue();
						p.window.close();
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
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave("${ctx}/AttachMgr.do?cmd=saveAttachMgrDepositInfo", $("#sheet1Form").serialize());
			break;

		case "Insert":
			var Row = sheet1.DataInsert(0);
			sheet1.SetCellValue(Row, "sabun", $("#sabun").val());
			sheet1.SetCellValue(Row, "attatchNo", $("#attatchNo").val());
			sheet1.SelectCell(Row, 2);

			$(window).smartresize(sheetResize);
			sheetInit();
			break;

		case "Copy":
			var Row = sheet1.DataCopy();
			sheet1.SelectCell(Row, 2);
			break;
	}
}

//조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

//저장 후 메시지
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}

// 사원검색 팝업
function empSearchPopup() {
	if(!isPopup()) {return;}
	gPRow = "";
	pGubun = "employeePopup";

	var w		= 840;
	var h		= 520;
	var url		= "/Popup.do?cmd=employeePopup";
	var args	= new Array();

	var result = openPopup(url+"&authPg=R", args, w, h);

}

function getReturnValue(returnValue) {
	var rv = $.parseJSON('{' + returnValue+ '}');

    if(pGubun == "employeePopup"){
		var sabun		= rv["sabun"];
		var name		= rv["name"];
		var jikgubCd	= rv["jikgubCd"];
		var jikgubNm	= rv["jikgubNm"];
		var jikchakCd	= rv["jikchakCd"];
		var jikchakNm	= rv["jikchakNm"];
		var orgNm		= rv["orgNm"];
		var statusCd	= rv["statusCd"];
		var statusNm	= rv["statusNm"];

		$("#sabun").val(sabun);
		$("#name").val(name);
		$("#jikgubCd").val(jikgubCd);
		$("#jikgubNm").val(jikgubNm);
		$("#jikchakCd").val(jikchakCd);
		$("#jikchakNm").val(jikchakNm);
		$("#orgNm").val(orgNm);
		$("#statusCd").val(statusCd);
		$("#statusNm").val(statusNm);
    }
}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="popup_title">
	<ul>
		<li>압류세부내역</li>
		<li class="close"></li>
	</ul>
	</div>
	<form id="sheet1Form" name="sheet1Form">
	<input type="hidden" id="elementCd" name="elementCd" value="" />
	<input type="hidden" id="sStatus" name="sStatus" value="U" />
	<div class="popup_main">
		<div class="sheet_title outer">
		<ul>
			<li class="txt">사원정보</li>
		</ul>
		</div>
		<div style="height:565px;width:100%;overflow:auto;overflow-x:hidden;">
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
				<td><input type="text" id="name" name="name" class="text readonly" readonly /> <a id="btnEmpSearch" onclick="javascript:empSearchPopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a></td>
				<th>사번</th>
				<td><input type="text" id="sabun" name="sabun" class="text required readonly" readonly /></td>
				<th>직급</th>
				<td><input type="text" id="jikgubNm" name="jikgubNm" class="text readonly w100p" readonly /><input type="hidden" id="jikgubCd" name="jikgubCd" class="text" /></td>
			</tr>
			<tr>
				<th>직책</th>
				<td><input type="text" id="jikchakNm" name="jikchakNm" class="text readonly w100p" readonly /><input type="hidden" id="jikchakCd" name="jikchakCd" class="text" /></td>
				<th>소속</th>
				<td><input type="text" id="orgNm" name="orgNm" class="text readonly w100p" readonly /></td>
				<th>재직상태</th>
				<td><input type="text" id="statusNm" name="statusNm" class="text readonly w100p" readonly /><input type="hidden" id="statusCd" name="statusCd" class="text" /></td>
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
				<td colspan="5"><input type="text" id="attatchSymd" name="attatchSymd" class="text required date2" /></td>
			</tr>
			<tr>
				<th>사건번호</th>
				<td><input type="text" id="attatchNo" name="attatchNo" class="text required w100p" /><input type="text" id="attatchNoReadonly" name="attatchNoReadonly" class="text required readonly w100p" readonly style="display:none" /></td>
				<th>사건구분</th>
				<td><select id="attatchType" name="attatchType" class="required"></select></td>
				<th>진행상태</th>
				<td><select id="attatchStatus" name="attatchStatus"></select></td>
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
				<td><input type="text" id="attTotMon" name="attTotMon" class="text w100p right readonly" readonly /></td>
				<th style="display:none;">입금누계액</th>
				<td style="display:none;"><input type="text" id="receiptMon" name="receiptMon" class="text w100p right readonly" readonly /></td>
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
					<a href="javascript:doAction1('Search')"		class="basic authR">조회</a>
					<a href="javascript:doAction1('Insert')"		class="basic authA">입력</a>
					<a href="javascript:doAction1('Copy')"			class="basic authA">복사</a>
					<a href="javascript:doAction1('SaveDeposit')"	class="basic authA">저장</a>
				</li>
			</ul>
			</div>
			<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<tr>
				<td class="top">
				<script type="text/javascript">createIBSheet("sheet1", "100%", "120px", "kr"); </script>
				</td>
			</tr>
			</table>
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
				<td><input type="text" id="courtYmd" name="courtYmd" class="text date2" /></td>
				<th>종료일</th>
				<td><input type="text" id="invalidYmd" name="invalidYmd" class="text date2"/></td>
			</tr>
			<tr>
				<th>비고</th>
				<td colspan="3"><input type="text" id="note" name="note" class="text w100p"/></td>
			</tr>
			</table>
		</div>
		<div class="popup_button outer">
		<ul>
			<li>
				<a href="javascript:doAction1('Save')"	class="pink authA">저장</a>
				<a href="javascript:p.self.close();"	class="gray large">닫기</a>
			</li>
		</ul>
		</div>
	</div>
	</form>
</div>
</body>
</html>