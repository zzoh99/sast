<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='112604' mdef='조건검색코드항목관리 팝업'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<!--   VALIDATION	 -->
<script src="/common/js/jquery/jquery.validate.js" type="text/javascript" charset="utf-8"></script>

<style type="text/css">
</style>
<script type="text/javascript">
var openSheet = null;
var sRow = null;
var p = eval("${popUpStatus}");
$(function(){
	var arg = p.window.dialogArguments;
	if( arg != undefined ) {
		openSheet		= arg["sheet"];
	}else{
		openSheet		= p.popDialogSheet("sheet1");
	}

	var bizCdList 	= convCodeIdx( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R10020"), "",-1);
	var orgLevelCdList	= convCodeIdx( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W82020"), "",-1);
	$("#bizCd").html(bizCdList[2]);
	$("#orgLevelCd").html(orgLevelCdList[2]);
	//Cancel 버튼 처리
	$(".close").click(function(){
		p.self.close();
	});
	sRow = openSheet.GetSelectRow();

	$("#applCd").val(		openSheet.GetCellValue(sRow,"applCd"));
	$("#applNm").val(		openSheet.GetCellValue(sRow,"applNm"));
	$("#note1").val(		openSheet.GetCellValue(sRow,"note1"));
	$("#bizCd").val(		openSheet.GetCellValue(sRow,"bizCd"));
	$("#applTitle").val(	openSheet.GetCellValue(sRow,"applTitle"));
	$("#seq").val(			openSheet.GetCellValue(sRow,"seq"));
	$("#detailPrgCd").val(	openSheet.GetCellValue(sRow,"detailPrgCd"));
	$("#prgCd").val(		openSheet.GetCellValue(sRow,"prgCd"));
	$("#prgPath").val(		openSheet.GetCellValue(sRow,"prgPath"));
	$("#agreePrgCd").val(	openSheet.GetCellValue(sRow,"agreePrgCd"));
	$("#agreePrgPath").val(	openSheet.GetCellValue(sRow,"agreePrgPath"));
	$("#orgLevelCd").val(	openSheet.GetCellValue(sRow,"orgLevelCd"));

	$("#memo").val(			openSheet.GetCellValue(sRow,"memo"));

	setChk("agreeYn", 		openSheet.GetCellValue(sRow,"agreeYn"));
	setChk("recevYn", 		openSheet.GetCellValue(sRow,"recevYn"));
	setChk("applMailYn", 	openSheet.GetCellValue(sRow,"applMailYn"));
	setChk("agreeMailYn", 	openSheet.GetCellValue(sRow,"agreeMailYn"));
	setChk("useYn", 		openSheet.GetCellValue(sRow,"useYn"));

	setChk("fileYn", 		openSheet.GetCellValue(sRow,"fileYn"));
	setChk("printYn", 		openSheet.GetCellValue(sRow,"printYn"));
	setChk("visualYn", 		openSheet.GetCellValue(sRow,"visualYn"));
	setChk("comboViewYn", 	openSheet.GetCellValue(sRow,"comboViewYn"));
	setChk("etcNoteYn", 	openSheet.GetCellValue(sRow,"etcNoteYn"));

	$(":checkbox").change(function(){
		if( $(this).attr("checked") ) $(this).attr("value","Y");
		else $(this).attr("value","N");
	});
	var msg = {};
	setValidate( $("#sheetForm"),msg );
});

function save() {
	if( !$("#sheetForm").valid() ) { return; };
	//openSheet.SetCellValue(sRow,"applCd",		$("#applCd" ).val() );
	openSheet.SetCellValue(sRow,"applNm",		$("#applNm" ).val() );
	openSheet.SetCellValue(sRow,"note1",		$("#note1" ).val() );
	openSheet.SetCellValue(sRow,"bizCd",		$("#bizCd" ).val() );
	openSheet.SetCellValue(sRow,"applTitle",	$("#applTitle" ).val() );
	openSheet.SetCellValue(sRow,"useYn",		$("#useYn" ).is(":checked")==true?"Y":"N" );
	openSheet.SetCellValue(sRow,"seq",			$("#seq" ).val() );
	openSheet.SetCellValue(sRow,"detailPrgCd",	$("#detailPrgCd" ).val() );
	openSheet.SetCellValue(sRow,"prgCd",		$("#prgCd" ).val() );
	openSheet.SetCellValue(sRow,"prgPath",		$("#prgPath" ).val() );
	openSheet.SetCellValue(sRow,"agreePrgCd",	$("#agreePrgCd" ).val() );
	openSheet.SetCellValue(sRow,"agreePrgPath",	$("#agreePrgPath" ).val() );
	openSheet.SetCellValue(sRow,"orgLevelCd",	$("#orgLevelCd" ).val() );
	openSheet.SetCellValue(sRow,"memo",			$("#memo" ).val() );
	openSheet.SetCellValue(sRow,"agreeYn",		$("#agreeYn").is(":checked")==true?"Y":"N" );
	openSheet.SetCellValue(sRow,"recevYn",		$("#recevYn").is(":checked")==true?"Y":"N" );
	openSheet.SetCellValue(sRow,"applMailYn",	$("#applMailYn").is(":checked")==true?"Y":"N" );
	openSheet.SetCellValue(sRow,"agreeMailYn",	$("#agreeMailYn").is(":checked")==true?"Y":"N" );
	openSheet.SetCellValue(sRow,"fileYn",		$("#fileYn").is(":checked")==true?"Y":"N" );
	openSheet.SetCellValue(sRow,"printYn",		$("#printYn").is(":checked")==true?"Y":"N" );
	openSheet.SetCellValue(sRow,"visualYn",		$("#visualYn").is(":checked")==true?"Y":"N" );
	openSheet.SetCellValue(sRow,"comboViewYn",	$("#comboViewYn").is(":checked")==true?"Y":"N" );
	openSheet.SetCellValue(sRow,"etcNoteYn",	$("#etcNoteYn").is(":checked")==true?"Y":"N" );
// 	window.returnValue = rv;
	p.window.close();
}

function setChk(id, val){
	if(val=="Y") $("#"+id).attr("checked",true);
}

</script>
</head>
<body class="bodywrap">
<form id="sheetForm" name="sheetForm" >

<div class="wrapper">
	<div class="popup_title">
		<ul>
			<li><tit:txt mid='appCdMgrDetail' mdef='신청서코드세부내역'/></li>
			<li class="close"></li>
		</ul>
	</div>

	<div class="popup_main">
		<table class="table">
		<colgroup>
			<col width="15%" />
			<col width="35%" />
			<col width="15%" />
			<col width="35%" />
		</colgroup>
		<tr>
			<th><tit:txt mid='114633' mdef='신청서코드'/></th>
			<td>
				<input id="applCd" name="applCd" type="text" class="text" style="width:99%;" readonly="readonly"/>
			</td>
			<th><tit:txt mid='112137' mdef='신청서명'/></th>
			<td>
				<input id="applNm" name="applNm" type="text" class="text" style="width:99%;" maxlength="100" vtxt="신청서명"/>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='113193' mdef='약어명'/></th>
			<td>
				<input id="note1" name="note1" type="text" class="text" style="width:99%;" maxlength="100" vtxt="약어명"/>
			</td>
			<th><tit:txt mid='113901' mdef='업무구분코드'/></th>
			<td>
				<select id="bizCd" name="bizCd"> </select>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='113539' mdef='신청/결재 제목'/></th>
			<td>
				<input id="applTitle" name="applTitle" type="text" class="text" style="width:99%;" maxlength="100" vtxt="신청/결재 제목"/>
			</td>
			<th><tit:txt mid='111965' mdef='사용여부'/></th>
			<td>
				<input id="useYn" name="useYn" type="checkbox" />
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='111896' mdef='순서'/></th>
			<td>
				<input id="seq" name="seq" type="text" class="text" style="width:99%;" validator="number" vtxt="순서"/>
			</td>
			<th><tit:txt mid='112474' mdef='프로그램ID'/></th>
			<td>
				<input id="detailPrgCd" name="detailPrgCd" type="text" class="text" style="width:99%;" maxlength="100" vtxt="프로그램ID"/>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='113902' mdef='신청프로그램명'/></th>
			<td>
				<input id="prgCd" name="prgCd" type="text" class="text" style="width:99%;" maxlength="100" vtxt="신청프로그램명"/>
			</td>
			<th><tit:txt mid='113540' mdef='신청프로그램경로'/></th>
			<td>
				<input id="prgPath" name="prgPath" type="text" class="text" style="width:99%;" maxlength="100" vtxt="신청프로그램경로"/>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='112829' mdef='결재프로그램명'/></th>
			<td>
				<input id="agreePrgCd" name="agreePrgCd" type="text" class="text" style="width:99%;" maxlength="100" vtxt="결재프로그램명"/>
			</td>
			<th><tit:txt mid='114635' mdef='결재프로그램경로'/></th>
			<td>
				<input id="agreePrgPath" name="agreePrgPath" type="text" class="text" style="width:99%;" maxlength="100" vtxt="결재프로그램경로"/>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='114636' mdef='결재처리필요여부'/></th>
			<td>
				<input id="agreeYn" name="agreeYn" type="checkbox" />
			</td>
			<th><tit:txt mid='114238' mdef='수신처리필요여부'/></th>
			<td>
				<input id="recevYn" name="recevYn" type="checkbox" />
			</td>
		</tr>
		<tr>
			<th>신청(결재)시<br/>메일발송여부</th>
			<td><input id="applMailYn" name="applMailYn" type="checkbox" style="vertical-align:middle;"/>
			</td>
			<th>처리완료시<br/>메일발송여부</th>
			<td>
				<input id="agreeMailYn" name="agreeMailYn" type="checkbox"  style="vertical-align:middle;"/>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='113164' mdef='출력여부'/></th>
			<td>
				<input id="printYn" name="printYn" type="checkbox" />
			</td>
			<th><tit:txt mid='112138' mdef='첨부파일여부'/></th>
			<td>
				<input id="fileYn" name="fileYn" type="checkbox" />
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='113543' mdef='보여주기'/></th>
			<td>
				<input id="visualYn" name="visualYn" type="checkbox" />
			</td>
			<th><tit:txt mid='114637' mdef='콤보보여주기'/></th>
			<td>
				<input id="comboViewYn" name="comboViewYn" type="checkbox" />
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='114638' mdef='결재선Level'/></th>
			<td>
				<select id="orgLevelCd" name="orgLevelCd"> </select>
			</td>
			<th><tit:txt mid='112830' mdef='유의사항필요여부'/></th>
			<td>
				<input id="etcNoteYn" name="etcNoteYn" type="checkbox" />
			</td>
		</tr>
		<tr>
			<th>MEMO</th>
			<td colspan="3">
				<textarea id="memo" name="memo" style="width:99%;height:50px" maxlength="1000" vtxt="MEMO"></textarea>
			</td>
		</tr>
		</table>

		<div class="popup_button">
			<ul>
				<li>
					<a href="javascript:save();" class="pink large"><tit:txt mid='104435' mdef='확인'/></a>
					<a href="javascript:p.self.close();" class="gray large"><tit:txt mid='104157' mdef='닫기'/></a>
				</li>
			</ul>
		</div>
	</div>
</div>
</form>
</body>
</html>
