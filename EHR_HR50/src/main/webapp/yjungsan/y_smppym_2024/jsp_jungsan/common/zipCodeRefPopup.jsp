<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>주소 조회</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<%
	String engAddrUseStatus = (String)request.getParameter("engAddrUseStatus");
%>
<script type="text/javascript">
	var p = eval("<%=popUpStatus%>");
	
	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smServerPaging,Page:20};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
	
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",			Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete" },
			{Header:"상태",			Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus" },
			{Header:"seq",			Type:"Text", Hidden:1,  Width:0,  Align:"Center",  SaveName:"idx",  		  EditLen:6 },
			{Header:"우편번호",		Type:"Text", Hidden:0,  Width:100,Align:"Center",  SaveName:"zipcode",    	  EditLen:6 },
			{Header:"도로명주소",		Type:"Text", Hidden:1,  Width:400,Align:"Left",    SaveName:"juso",     	  EditLen:200 },
			{Header:"신주소",			Type:"Text", Hidden:0,  Width:400,Align:"Left",    SaveName:"juso_s",     	  EditLen:200 },
			{Header:"지번주소",		Type:"Text", Hidden:0,  Width:200,Align:"Left",    SaveName:"juso_g",     	  EditLen:200 },
			{Header:"영문주소",		Type:"Text", Hidden:0,  Width:200,Align:"Left",    SaveName:"juso_e",     	  EditLen:200 },
			{Header:"시도",			Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"sido",     	  EditLen:10 },
			{Header:"시도영문",		Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"sido_e",    	  EditLen:20 },
			{Header:"시군구",			Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"sigungu",  	  EditLen:20 },
			{Header:"시군구영문",		Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"sigungu_e", 	  EditLen:50 },
			{Header:"읍면",			Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"upmyon",   	  EditLen:20 },
			{Header:"읍면영문",		Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"upmyon_e",  	  EditLen:20 },
			{Header:"도로명코드",		Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"road_code", 	  EditLen:20 },
			{Header:"도로명",			Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"road_name",      EditLen:20 },
			{Header:"도로명영문",		Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"road_name_e",	  EditLen:20 },
			{Header:"지하여부",		Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"isUnder",  	  EditLen:20 },
			{Header:"건물번호본번",		Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"bdno_m",    	  EditLen:20 },
			{Header:"건물번호부번",		Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"bdno_s",    	  EditLen:20 },
			{Header:"건물관리번호",		Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"bdno_d",    	  EditLen:20 },
			{Header:"다량배달처명",		Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"mass_delevery",  EditLen:20 },
			{Header:"시군구용건물명",	Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"sigungubd_name", EditLen:20 },
			{Header:"법정동코드",		Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"law_dong_code",  EditLen:20 },
			{Header:"법정동명",		Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"law_dong_name",  EditLen:20 },
			{Header:"리명",			Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"ri",             EditLen:20 },
			{Header:"행정동명",		Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"gov_dong_name",  EditLen:20 },
			{Header:"산여부",			Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"is_mountin",     EditLen:20 },
			{Header:"지번본번",		Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"jibun_m",        EditLen:20 },
			{Header:"을면동일련번호",	Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"upmyundong_no",  EditLen:20 },
			{Header:"지번부번",		Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"jibun_s",        EditLen:20 },
			{Header:"우편번호6",		Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"old_zipcode",    EditLen:20 },
			{Header:"우편번호일련번호6",	Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"old_zipcodeNo",  EditLen:20 }
		]; IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(4); sheet1.SetEditable(false);sheet1.SetEditableColorDiff(0); //편집불가 상관없이 기본색상 출력
	
		$("#searchWord").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction("Search"); return $(this).focus();
			}
		});
		
		$("#notFindAddrStatus").bind("click",function(event){
			if( !$("#notFindAddrStatus").is(":checked") ){
				$("#zipCode").attr("readonly", "readonly");			$("#zipCode").addClass("readonly");

			}else{
				$("#zipCode").removeAttr("readonly");		$("#zipCode").removeClass("readonly");
			}
		});
		
		$(window).smartresize(sheetResize); sheetInit();
		doAction("Search");
	});
	
	function engCheck(){
		if("${engAddrUseStatus}" != "Y"){
			$("#doroFullAddrEngTR").hide();
			$("#dtlAddrEngTR").hide();
		}
	}

	
	/*Sheet Action*/
	function doAction(sAction) {
		switch (sAction) {
		case "Search": //조회
			//getZipCodePopupDoroList
			var param = {"Param":"cmd=getZipCodePopupDoroList&defaultRow=20&"+$("#srchFrm").serialize()};
			sheet1.DoSearchPaging( "<%=jspPath%>/common/zipCodeRefPopupRst.jsp", param );			
			break;
		}
    } 
	
// 	조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") alert(Msg);
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet1_OnClick(Row, Col){
		try{
			setAddr();
		} catch(ex){
			alert("OnClick Event Error : " + ex);
		}
	}

	//2013-05-27 김장현 - 주소 부분에 세팅
	function setAddr(){
		//직접입력이 아닐 경우에만 주소 부분에 세팅

		if( !$("#notFindAddrStatus").is(":checked") ){
			//2013-05-27 김장현 - 팝업 주소창에서 상세주소까지 입력 하게 변경
			$("#zipCode").val(sheet1.GetCellValue(sheet1.GetSelectRow(), "zipcode"));
			$("#doroFullAddr").val(sheet1.GetCellValue(sheet1.GetSelectRow(), "juso_s"));
			$("#doroAddr").val(sheet1.GetCellValue(sheet1.GetSelectRow(), "juso"));
			var addrNote = "";
			var lawDongName = sheet1.GetCellValue(sheet1.GetSelectRow(), "law_dong_name");
			var sigungubdName = sheet1.GetCellValue(sheet1.GetSelectRow(), "sigungubd_name");
			if(lawDongName != ""){
				addrNote += "("+lawDongName;
				if(sigungubdName != "")	addrNote += ", "+sigungubdName;
				addrNote += ")";
			}
			$("#addrNote").val(addrNote);
			$("#doroFullAddrEng").val(sheet1.GetCellValue(sheet1.GetSelectRow(), "juso_e"));

		}else{
			alert("직접입력의 경우, 조회 내역을 사용 할 수 없습니다.\n조회 내역을 사용하시려면 직접입력 체크박스를 해제해주십시오.");
			return;
		}
	}

	function setValue(){
		var resDoroFullAddr = "";

		var resDoroFullAddrEng = $("#doroFullAddrEng").val();;

		var resDoroAddr = $("#doroAddr").val();
		var resDtlAddr = $("#dtlAddr").val();
		var resAddrNote = $("#addrNote").val();
		var resZipCode = $("#zipCode").val();

		var resDtlAddrEng = $("#dtlAddrEng").val();

		//직접입력
		if( $("#notFindAddrStatus").is(":checked") ){
			resDoroFullAddr = $("#dtlAddr").val();

			if( resZipCode == null || resZipCode == "" || resZipCode.length != 5){
				alert("우편번호를 입력하여 주십시오.");
				$("#zipCode").focus();
				return;
			}

			if( resDoroFullAddr == null || resDoroFullAddr == "" ){
				alert("주소를 입력하여 주십시오.");
				$("#dtlAddr").focus();
				return;
			}

		} else{
			//우편번호 및 도로명주소 체크
			var checkzipCode = $("#zipCode").val();
			var checkDoroAddr =	$("#doroFullAddr").val();
			if( checkDoroAddr.length < 1 || checkzipCode.length < 1 ){
				alert( "주소찾기 기능을 통해 주소를 검색 한 후, 도로명 주소를 선택하여 주십시오." );
				return;
			}

			resDoroFullAddr = resDoroAddr;

			//상세 주소가 있다면 구분을 위해 사이에 ', ' 문자열 삽입.
			if(resDtlAddr.length > 0 ){
				resDoroFullAddr += ", "+resDtlAddr;
			}

			//법정동 및 공동주택명이 있다면 구분을 위해 사이에 ' ' 문자열 삽입.
			if(resAddrNote.length > 0 ){
				resDoroFullAddr += " "+resAddrNote;
			}

			//영문도로명주소 조합
			resDoroFullAddrEng = resDtlAddrEng + ", " + resDoroFullAddrEng;

		}

		var arrayList = new Array();
	    arrayList[0] = resZipCode;
	    arrayList[1] = resDoroFullAddr;
	    arrayList[2] = '';
	    arrayList[3] = '';
	    
	    if(p.popReturnValue) p.popReturnValue(arrayList);
	    p.self.close();
	}

</script>
</head>

<body class="bodywrap" onLoad="engCheck();">
	<div class="wrapper">
		<div class="popup_title">
				<ul>
						<li>주소조회</li>
						<li class="close"></li>
				</ul>
		</div>
		<div class="popup_main">
			<div class="outer">
				<table>
					<tr>
						<td><span>* 검색방법</span></br>
						1. 도로명/건물명 입력 <B>예)</B> 사평대로 84, 남부순환로 2406, 예술의전당<br/>
						2. 지번주소 입력 <B>예)</B> 반포동 112-4, 서초동 700<br/>
						<span style="color:#D35572"><b>3. 도로명주소가 존재하지 않을 경우에만, 직접입력을 통해 주소를 입력 하십시오.</b></span>
						</td>
					</tr>
				</table>
			</div>
			<form id="srchFrm" name="srchFrm">
				<input type="hidden" name="hangle_giha" value="지하" />
				<input type="hidden" name="hangle_san" value="산" />
				<div class="sheet_search outer">
					<div>
						<table>
							<tr>
								<td>
									<span>검색어</span>
									<input id="searchWord" name ="searchWord" type="text" class="text"  style="width:300px"/>
								</td>
								<td><input type="checkbox" id="notFindAddrStatus" name="notFindAddrStatus" style="vertical-align:middle;"/>직접입력</td>
								<td><a href="javascript:doAction('Search')" id="btnSearch" class="button">조회</a></td>
							</tr>
						</table>
					</div>
				</div>
			</form>
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li id="txt" class="txt">주소조회</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script>
			<div class="outer" style="margin-top:10px;">
				<table border="0" cellpadding="0" cellspacing="0" class="default">
						<colgroup>
								<col width="17%" />
								<col width="" />
						</colgroup>
						<tr>
								<td>우편번호</td>
								<td><input type="text" id="zipCode" name="zipCode" size="30" maxlength="7" class="readonly" readOnly/></td>
						</tr>
						<tr>
								<td>도로명주소</td>
								<td><input type="text" id="doroFullAddr" name="doroFullAddr" size="70" class="readonly" readOnly/></td>
						</tr>
						<tr>
								<td>상세주소</td>
								<td><input type="text" id="dtlAddr" name="dtlAddr" size="70"/></td>
						</tr>
						<tr id="doroFullAddrEngTR" >
								<td>영문도로명주소</td>
								<td><input type="text" id="doroFullAddrEng" name="doroFullAddr" size="70" class="readonly" readOnly/></td>
						</tr>
						<tr id="dtlAddrEngTR" >
								<td>영문상세주소</td>
								<td><input type="text" id="dtlAddrEng" name="dtlAddr" size="70"/></td>
						</tr>
						<input type="hidden" id="doroAddr" name="doroAddr" />
					<input type="hidden" id="addrNote" name="addrNote" />
				</table>
			</div>
			<div class="popup_button outer">
			<ul>
				<li>
					<a href="javascript:setValue();" class="pink large">확인</a>
					<a href="javascript:p.self.close();" class="gray large">닫기</a>
				</li>
			</ul>
			</div>
		</div>
	</div>
</body>
</html>