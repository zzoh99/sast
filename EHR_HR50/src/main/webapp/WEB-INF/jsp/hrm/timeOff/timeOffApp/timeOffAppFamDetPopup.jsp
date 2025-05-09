<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="bodywrap"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='104203' mdef='가족돌봄휴직신청 팝업'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var famList 	= null;
var famres 		= null;
var famSdate 	= "";
var famEdate	= "";
var tDay		= 0;
var saveData	= null;
var searchTimeOff = "${etc01}";

$(function(){

	famList = ajaxCall("${ctx}/TimeOffApp.do?cmd=getTimeOffAppFamDetFamCodeList",$("#sheetForm").serialize(),false).DATA;
	famres 	= convCode( famList, "선택");

	$("#famres").html(famres[2]);
// 	$("#famres").append("<option value='99'><tit:txt mid='103900' mdef='기타'/></option>");
	$("#famres").change(function(){
		for(var i=0; i<famList.length; i++){
			if($(this).children("option:selected").text() == famList[i].codeNm){
				$("#famNm").val(famList[i].codeNm);
				$("#famCd").val(famList[i].famCd);
			}
		}

// 		if( $(this).val()=="99") $("#inputFam").show();
// 		else $("#inputFam").hide();

		if($("#famres").val() != ""){
			doAction1("Search");
		}
	});

	saveData= ajaxCall("${ctx}/TimeOffApp.do?cmd=getTimeOffAppPatDetSaveMap",$("#sheetForm").serialize(),false);
	if(saveData.DATA){


 		$("#famres option").each(function(){
 			if($(this).text() == saveData.DATA.famNm){
 				$(this).attr("selected", "selected");
 			}
 		});

// 		if($("#famres").val()=="99") {
// 			$("#inputFam").val(saveData.DATA.famNm).show();
// 		}
		$("#famCd").val(saveData.DATA.famCd);
		$("#famNm").val(saveData.DATA.famNm);
		$("#sdate").val(saveData.DATA.refSdate);
		$("#edate").val(saveData.DATA.refEdate);
		$("#reason").val(saveData.DATA.refReason);
		$("#etc").val(saveData.DATA.etc);
	}




	var typeTerm = ajaxCall("${ctx}/TimeOffApp.do?cmd=getTimeOffTypeTermMap",$("#sheetForm").serialize(),false);
	if(typeTerm.DATA){

		$("#limitTerm").val(typeTerm.DATA.limitTerm);
	}

	var initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:0, DataRowMerge:0};
	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
	initdata.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",	Type:"${sNoTy}",  	Hidden:1,   Width:"${sNoWdt}",  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",	Type:"${sDelTy}", 	Hidden:1,  Width:"${sDelWdt}", Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
		{Header:"<sht:txt mid='statusCd' mdef='상태'/>",	Type:"${sSttTy}", 	Hidden:1,  Width:"${sSttWdt}", Align:"Center",  ColMerge:0,   SaveName:"sStatus" },
		{Header:"<sht:txt mid='applCd_V3774' mdef='신청종류'/>",	Type:"Combo",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"applCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='applYmdV5' mdef='신청일'/>",	Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"applYmd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='sYmdV1' mdef='시작일'/>",	Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='edate' mdef='종료일'/>",	Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='workDay' mdef='일수'/>",		Type:"AutoSum",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"chkBx",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
	]; IBS_InitSheet(sheet1, initdata);sheet1.SetCountPosition(4);

	var applCd		= convCode( ajaxCall("${ctx}/AppBeforeLst.do?cmd=getAppBeforeLstApplCdList","",false).codeList, "");
	sheet1.SetColProperty("applCd", 	{ComboText:applCd[0], ComboCode:applCd[1]} );

	$(window).smartresize(sheetResize);
	sheetInit();
	parent.iframeOnLoad("350px");
	//Cancel 버튼 처리
	$(".close").click(function(){
		self.close();
	});
	
	if(searchTimeOff == "Y"){
		//$("#applButton", parent.document).css("display","none");
	}

	if($("#famres").val() != ""){
		doAction1("Search");
	}

	if("${authPg}"=="R"){
		$("#famres").addClass("readonly").attr("disabled","disabled");
		$("#reason").addClass("readonly").attr("readOnly","readOnly");
		$("#etc").addClass("readonly").attr("readOnly","readOnly");
		$("#sdate").addClass("readonly").attr("readOnly","readOnly");
		$("#edate").addClass("readonly").attr("readOnly","readOnly");
	}else{
		$("#sdate").datepicker2({
			startdate:"edate",
			onReturn: function(date) {
				var num = getDaysBetween(date.replace(/-/g,""),$("#edate").val().replace(/-/g,""));
				$("#day").text(num+"일");
				tDay = num;
			}
		});
		$("#edate").datepicker2({
			enddate:"sdate",
			onReturn: function(date) {
				var num = getDaysBetween($("#sdate").val().replace(/-/g,""),date.replace(/-/g,""));
				$("#day").text(num+"일");
				tDay = num;
			}
		});
	}

});

function doAction1(sAction) {
	switch (sAction) {
		case "Search":  sheet1.DoSearch( "${ctx}/TimeOffApp.do?cmd=getTimeOffAppFamDetList",$("#sheetForm").serialize()); break;
	}
}
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); }
		sheetResize();
	} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg);} } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}

function setValue(status){
	if(status == "21"){//타인신청의 경우
		//첨부파일 1개이상 필수
		if(parent.supSheet.LastRow() <= 0)
		{
			alert("첨부파일은 필수 입니다.");
			return false;
		}
	}

	if($("#authPg").val() == "A") {
		if($("#famres").val() == "") {return alert("<msg:txt mid='109390' mdef='대상자명을 선택 하세요.'/>");}
		if($("#sdate").val() == "") {return alert("<msg:txt mid='109726' mdef='휴직 시작일을 선택해 주세요.'/>");}
		if($("#edate").val() == "") {return alert("<msg:txt mid='110451' mdef='휴직 종료일을 선택해 주세요.'/>");}


		if($("#famres").val()=="99") {
			if($.trim( $("#inputFam").val() )==""){return alert("<msg:txt mid='110181' mdef='대상자 이름을 입력하십시오.'/>");}
			$("#famNm").val($("#inputFam").val());
		}

	 	var totalDay = Number(tDay)+sheet1.GetSumValue("chkBx");
		var applTitle = $("#applTitle", parent.document).val();
		var limitTerm = $("#limitTerm").val();

		if(totalDay < 30){
			return alert( applTitle+"의 최소 사용기간은 30일 이상 입니다.");
		}

		if(totalDay > limitTerm){
			return alert( applTitle+"의 최대 사용기간은 "+ limitTerm +" 입니다.");
		}

		if($("#searchApplCd").val() == '64'){
			if($("#reason").val() == "") {return alert("<msg:txt mid='110026' mdef='휴직 사유를 입력하여 주십시오.'/>");}
		}

		$("#famres").attr("disabled",false);

		var rtn = ajaxCall("${ctx}/TimeOffApp.do?cmd=saveTimeOffAppFamDet",$("#sheetForm").serialize(),false);
		if(rtn.Result.Code < 1) {
			alert(rtn.Result.Message);
			return false;
		}
	}

	return true;
}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">

	<div>
		<form id="sheetForm" name="sheetForm" >
			<input id="searchApplCd" 	name="searchApplCd" 	type="hidden" value="${searchApplCd}"/>
			<input id="searchApplSeq" 	name="searchApplSeq" 	type="hidden" value="${searchApplSeq}"/>
			<input id="searchApplSabun" name="searchApplSabun" 	type="hidden" value="${searchApplSabun}"/>
			<input id="adminYn" 		name="adminYn" 			type="hidden" value="${adminYn}"/>
			<input id="authPg" 			name="authPg" 			type="hidden" value="${authPg}"/>
			<input id="searchApplYmd" 	name="searchApplYmd" 	type="hidden" value="${searchApplYmd}"/>
			<input id="searchSabun" 	name="searchSabun" 		type="hidden" value="${searchSabun}"/>
			<input id="famCd"			name="famCd" 			type="hidden" value=""/>
			<input id="famNm"			name="famNm" 			type="hidden" value=""/>

			<input id="limitTerm"			name="limitTerm" 			type="hidden" value=""/>

			<div class="inner">
				<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='appTitle' mdef='신청내용'/></li>
					</ul>
				</div>
			</div>
			<table class="table">
				<colgroup>
					<col width="20%" />
					<col width="80%" />
				</colgroup>
				<tr>
					<th><tit:txt mid='104395' mdef='대상자명'/></th>
					<td>
						<select id="famres" name="famres" >
						</select>
<!-- 						<input id="inputFam" name="inputFam" type="text" class="text" style="display:none"/> -->
					</td>
				</tr>
				<tr>
					<th><tit:txt mid='103909' mdef='휴직기간'/></th>
					<td>
						<input id="sdate" name="sdate" type="text" class="date2" style="" readonly/>
						<input id="edate" name="edate" type="text" class="date2" style="" readonly/>
						<span id="day" style="margin-left:10px;"></span>
					</td>
				</tr>
				<tr>
					<th><tit:txt mid='104299' mdef='휴직사유'/></th>
					<td><textarea id="reason" name="reason" rows="2" class="w100p"></textarea></td>
				</tr>
				<tr>
					<th><tit:txt mid='103783' mdef='비고'/></th>
					<td><textarea id="etc" name="etc" rows="2" class="w100p"></textarea></td>
				</tr>
			</table>
		</form>
		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<tr>
				<td>
					<div class="inner">
						<div class="sheet_title">
							<ul>
								<li class="txt"><tit:txt mid='104008' mdef='기신청내용'/></li>
							</ul>
						</div>
					</div>
					<script type="text/javascript"> createIBSheet("sheet1", "100%", "40%", "${ssnLocaleCd}"); </script>
				</td>
			</tr>
		</table>
	</div>
</div>

</body>
</html>
