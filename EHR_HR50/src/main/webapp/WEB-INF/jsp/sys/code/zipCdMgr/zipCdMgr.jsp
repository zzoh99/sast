<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='113278' mdef='우편번호관리'/></title>

<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function() {
		var folder = "${uploadFld1}";
		var initdata = {};
		initdata.Cfg = {SearchMode:smServerPaging,Page:20};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [

			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus" },
			{Header:"<sht:txt mid='seqV4' mdef='seq'/>",			Type:"Text", Hidden:1,  Width:0,  Align:"Center",  SaveName:"idx",  EditLen:6 },
			{Header:"<sht:txt mid='zip' mdef='우편번호'/>",		Type:"Text", Hidden:0,  Width:100,Align:"Center",  SaveName:"zipcode",    EditLen:6 },
			{Header:"<sht:txt mid='jusoS' mdef='신주소'/>",			Type:"Text", Hidden:0,  Width:400,Align:"Left",    SaveName:"jusoS",     EditLen:200 },
			{Header:"<sht:txt mid='jibunAddr' mdef='지번주소'/>",		Type:"Text", Hidden:0,  Width:200,Align:"Left",    SaveName:"jusoG",     EditLen:200 },
			{Header:"<sht:txt mid='addrEng' mdef='영문주소'/>",		Type:"Text", Hidden:0,  Width:200,Align:"Left",    SaveName:"jusoE",     EditLen:200 },
			{Header:"<sht:txt mid='sido_V3625' mdef='시도'/>",			Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"sido",     EditLen:10 },
			{Header:"<sht:txt mid='sidoE' mdef='시도영문'/>",		Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"sidoE",    EditLen:20 },
			{Header:"<sht:txt mid='sigungu' mdef='시군구'/>",			Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"sigungu",  EditLen:20 },
			{Header:"<sht:txt mid='sigunguE' mdef='시군구영문'/>",		Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"sigunguE", EditLen:50 },
			{Header:"<sht:txt mid='upmyon' mdef='읍면'/>",			Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"upmyon",   EditLen:20 },
			{Header:"<sht:txt mid='upmyonE' mdef='읍면영문'/>",		Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"upmyonE",  EditLen:20 },
			{Header:"<sht:txt mid='roadCode' mdef='도로명코드'/>",		Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"roadCode", EditLen:20 },
			{Header:"<sht:txt mid='doroAddr' mdef='도로명'/>",			Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"roadName", EditLen:20 },
			{Header:"<sht:txt mid='roadNameE' mdef='도로명영문'/>",		Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"roadNameE",EditLen:20 },
			{Header:"<sht:txt mid='isUnder' mdef='지하여부'/>",		Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"isUnder",  EditLen:20 },
			{Header:"<sht:txt mid='bdnoM' mdef='건물번호본번'/>",		Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"bdnoM",    EditLen:20 },
			{Header:"<sht:txt mid='bdnoS' mdef='건물번호부번'/>",		Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"bdnoS",    EditLen:20 },
			{Header:"<sht:txt mid='bdnoD' mdef='건물관리번호'/>",		Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"bdnoD",    EditLen:20 },
			{Header:"<sht:txt mid='massDelevery' mdef='다량배달처명'/>",		Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"massDelevery",  EditLen:20 },
			{Header:"<sht:txt mid='sigungubdName' mdef='시군구용건물명'/>",	Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"sigungubdName", EditLen:20 },
			{Header:"<sht:txt mid='lawDongCode' mdef='법정동코드'/>",		Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"lawDongCode",   EditLen:20 },
			{Header:"<sht:txt mid='lawDongName' mdef='법정동명'/>",		Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"lawDongName",   EditLen:20 },
			{Header:"<sht:txt mid='ri' mdef='리명'/>",			Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"ri",            EditLen:20 },
			{Header:"<sht:txt mid='govDongName' mdef='행정동명'/>",		Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"govDongName",   EditLen:20 },
			{Header:"<sht:txt mid='isMountin' mdef='산여부'/>",			Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"isMountin",     EditLen:20 },
			{Header:"<sht:txt mid='jibunM' mdef='지번본번'/>",		Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"jibunM",        EditLen:20 },
			{Header:"<sht:txt mid='upmyundongNo' mdef='을면동일련번호'/>",	Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"upmyundongNo",  EditLen:20 },
			{Header:"<sht:txt mid='jibunS' mdef='지번부번'/>",		Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"jibunS",        EditLen:20 },
			{Header:"<sht:txt mid='oldZipcode' mdef='우편번호6'/>",		Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"oldZipcode",    EditLen:20 },
			{Header:"<sht:txt mid='oldZipcodeNo' mdef='우편번호일련번호6'/>",	Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"oldZipcodeNo",  EditLen:20 }
		]; IBS_InitSheet(mySheet, initdata); mySheet.SetCountPosition(4); mySheet.SetEditable(false);

		$("#searchWord").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction("Search"); return $(this).focus();
			}
		});
		$("#searchGubun").change(function(){
			if($(this).val() != "0"){
				$("#searchWord").attr("disabled",false);
			}else{
				$("#searchWord").attr("disabled",true);
				$("#searchWord").val("");
			}
		});

		$(window).smartresize(sheetResize); sheetInit();
		doAction("Search");
	});
	function doAction(sAction) {
		switch (sAction) {
		case "Search": 	 	var param = {"Param":"cmd=getZipCdMgrList&defaultRow=20&"+$("#mySheetForm").serialize()};
							mySheet.DoSearchPaging( "${ctx}/ZipCdMgr.do", param ); break;
		}
	}
	function mySheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	}
</script>
</head>
<body class="bodywrap">
	<div class="wrapper">
		<form id="mySheetForm" name="mySheetForm">
			<div class="sheet_search outer">
				<div>
					<table>
						<tr>
							<!--
							<td>
								<span><tit:txt mid='103997' mdef='구분'/></span>
								<select id="searchGubun" name="searchGubun" >
								<option value="1" selected>도로명/건물명 통합검색</option>
								<option value="2">지번주소로 도로명주소 찾기</option>
								</select>
							</td>
							-->
							<th><tit:txt mid='114546' mdef='검색어'/></th>
							<td>
								<input id="searchWord" name ="searchWord" type="text" class="text"  style="width:200px"/>
							</td>
							<td>
								<btn:a id="srchBtn" onclick="javascript:doAction('Search');" css="button" mid='110697' mdef="조회"/>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</form>

		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<tr>
				<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li class="txt"><tit:txt mid='113278' mdef='우편번호관리'/></li>
							<li class="btn">
								<a id="downBtn" onclick="javascript:doAction('Down2Excel');" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("mySheet", "100%", "100%", "${ssnLocaleCd}"); </script>
				</td>
			</tr>
		</table>
	</div>
</body>
</html>
