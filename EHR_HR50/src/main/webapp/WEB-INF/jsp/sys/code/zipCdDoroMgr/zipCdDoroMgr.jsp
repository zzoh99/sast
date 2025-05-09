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
		initdata.Cfg = {SearchMode:smServerPaging,Page:100};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
				{Header:"<sht:txt mid='sNo' mdef='No'/>",       Type:"${sNoTy}",  Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
				{Header:"<sht:txt mid='zip' mdef='우편번호'/>",			Type:"Text",			Hidden:0,	Width:100,				Align:"Center",	ColMerge:0,	SaveName:"zipcode", 			UpdateEdit:0 },
				{Header:"<sht:txt mid='doroFullAddr' mdef='도로명주소'/>",		Type:"Text",			Hidden:0,	Width:250,				Align:"Left",	ColMerge:0,	SaveName:"doroFullAddr", 		UpdateEdit:0 },
				{Header:"<sht:txt mid='jibunAddr' mdef='지번주소'/>",			Type:"Text",			Hidden:0,	Width:300,				Align:"Left",	ColMerge:0,	SaveName:"jibunAddr", 			UpdateEdit:0 },
				{Header:"<sht:txt mid='buildingManageNum' mdef='빌딩관리번호'/>",		Type:"Text",			Hidden:1,	Width:100,				Align:"Center",	ColMerge:0,	SaveName:"buildingManageNum", UpdateEdit:0 },
				{Header:"<sht:txt mid='addrNote' mdef='법정동주택명'/>",		Type:"Text",			Hidden:1,	Width:100,				Align:"Center",	ColMerge:0,	SaveName:"addrNote", 			UpdateEdit:0 },
				{Header:"<sht:txt mid='doroAddr' mdef='도로명'/>",			Type:"Text",			Hidden:1,	Width:100,				Align:"Center",	ColMerge:0,	SaveName:"doroAddr", 			UpdateEdit:0 },
				{Header:"<sht:txt mid='doroAddrEng' mdef='영문도로명'/>",		Type:"Text",			Hidden:0,	Width:250,				Align:"Center",	ColMerge:0,	SaveName:"doroAddrEng", 			UpdateEdit:0 }
		]; IBS_InitSheet(mySheet, initdata); mySheet.SetCountPosition(4); mySheet.SetEditable(false);

// 		doAction("Search");
	});
	function doAction(sAction) {
		switch (sAction) {
		case "Search":
			var text = $('#searchAddress').val().trim();

			valid = searchNameCheck(text);

	 		if(valid == true) {

				mySheet.DoSearch( "${ctx}/ZipCodePopup.do?cmd=getZipCodePopupDoroList&defaultRow=100&", $("#mySheetForm").serialize() );
	 		}

			break;

		case "Down2Excel":	mySheet.Down2Excel(); break;
		}
	}
	function mySheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	function mySheet_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); }
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	function mySheet_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && mySheet.GetCellValue(Row, "sStatus") == "I") {
				mySheet.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}
	function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	}

	function IsRoad(sText) {
	    var ValidChars = "개길도로리";
	    var IsRoad=true;

	    if (ValidChars.indexOf(sText) == -1){
	        IsRoad = false;
	    }
	    return IsRoad;
	}

	function IsNumeric(sText) {
	    var ValidChars = "0123456789";
	    var IsNumber=true;
	    var Char;

	    for (i = 0; i < sText.length && IsNumber == true; i++) {
	        Char = sText.charAt(i);
	        if (ValidChars.indexOf(Char) == -1){
	            IsNumber = false;
	        }
	    }
	    return IsNumber;
	}

	// 주소 검색 시, 검색 단어 체크
	function searchNameCheck(search){

		// 1. 3자 이상
		if( search.length < 3){
			alert( "도로명주소나, 지번주소를 3자이상 입력하여 주십시오." );
			return false;
		}

		// 2. 특수문자 '-'이외에 입력 금지
		var re = /[~!@\#$%^&*\()\=+_']/gi;

	    if(re.test(search)){
	        alert("<msg:txt mid='alertNotSChar' mdef='특수문자는 입력하실수 없습니다.'/>");
	        return false;
	    }

		// 3. 한글 무족건 포함
		var check = /[ㄱ-ㅎ|ㅏ-ㅣ|가-히]/;

		if(!check.test(search)){
			alert("<msg:txt mid='alertSrchBunjiV1' mdef='도로명주소나, 지번주소의 한글을 1자 이상 입력하여 주십시오.'/>");
			return false;
		}

		return true;
	}

</script>
</head>
<body class="bodywrap">
	<div class="wrapper">
		<form id="mySheetForm" name="mySheetForm">
			<input type="hidden" id="srchSido" name="srchSido">
			<input type="hidden" id="srchDoroNm" name="srchDoroNm">
			<input type="hidden" id="srchGunMoolNum" name="srchGunMoolNum">
			<input type="hidden" id="srchGunMoolNumSec" name="srchGunMoolNumSec">
			<input type="hidden" id="srchGunMoolManageNum" name="srchGunMoolManageNum" >
			<div class="sheet_search outer">
				<div>
					<table>
						<tr>
							<th><tit:txt mid='113649' mdef='검색어입력'/></th>
							<td>
								<input id="searchAddress" name ="searchAddress" type="text" class="text w100" placeholder="도로명주소"//>
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
							<li class="txt"><tit:txt mid='112229' mdef='도로명 우편번호관리'/></li>
							<li class="btn">
								<a id="downBtn" onclick="javascript:doAction('Down2Excel')" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
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
