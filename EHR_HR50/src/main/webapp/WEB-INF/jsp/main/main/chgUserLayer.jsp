<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="${ctx}/common/js/ras/jsbn.js" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/js/ras/prng4.js" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/js/ras/rng.js" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/js/ras/rsa.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">
	var baselimit = ("${ssnTokenChkTime}" !="") ? "${ssnTokenChkTime}": 30;
	var limit = baselimit;
	var stop = false;

	$(function() {
		createIBSheet3(document.getElementById('chgUserEmpSht-wrap'), "chgUserEmpSht", "100%", "100%","${ssnLocaleCd}");
		createIBSheet3(document.getElementById('chgUserOrgSht-wrap'), "chgUserOrgSht", "100%", "100%","${ssnLocaleCd}");

		var initdata = {};
		//###########################소속도
		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, ChildPage:22, AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			//{Header:"<sht:txt mid='sNo' mdef='No'/>",	Type:"${sNoTy}",  	Hidden:0,   Width:"${sNoWdt}",  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
			//{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",	Type:"${sDelTy}", 	Hidden:1,  Width:"${sDelWdt}", Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
			//{Header:"<sht:txt mid='sStatus' mdef='상태'/>",	Type:"${sSttTy}", 	Hidden:1,  Width:"${sSttWdt}", Align:"Center",  ColMerge:0,   SaveName:"sStatus" },
			{Header:"<sht:txt mid='priorOrgCd_V3144' mdef='상위부서코드'/>",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	SaveName:"priorOrgCd",	Edit:0},
			{Header:"<sht:txt mid='orgNm_V5096' mdef='조직트리'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	SaveName:"orgNm",		Edit:0,TreeCol:1 },
			{Header:"<sht:txt mid='orgCdV8' mdef='부서코드'/>",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	SaveName:"orgCd",		Edit:0}
		]; IBS_InitSheet(chgUserOrgSht, initdata);
		// sheet 높이 계산
		let chgUserOrgShtHeight = $(".modal_body").height() - $("#sheetForm").height() - $(".sheet_title").height() - 2;
		chgUserOrgSht.SetSheetHeight(chgUserOrgShtHeight);

		chgUserOrgSht.SetVisible(true);
		chgUserOrgSht.SetEditableColorDiff(0); //편집불가 상관없이 기본색상 출력
		chgUserOrgSht.SetSelectionMode(1);
		chgUserOrgSht.SetWaitImageVisible(0);
		chgUserOrgSht.SetFocusAfterProcess(0);
		//chgUserOrgSht.FitColWidth();

		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:4, DataRowMerge:0, AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",	Type:"${sNoTy}",  	Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center",  SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",	Type:"${sDelTy}", 	Hidden:1,  Width:"${sDelWdt}", Align:"Center",  SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",	Type:"${sSttTy}", 	Hidden:1,  Width:"${sSttWdt}", Align:"Center",  SaveName:"sStatus" },
			{Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",	Type:"Text",     	Hidden:0,  Width:120,   Align:"Center",  SaveName:"orgNm",   	KeyField:0},
			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",	Type:"Text",      	Hidden:0,  Width:80,   	Align:"Center",  SaveName:"jikchakNm",	KeyField:0},
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",	Type:"Text",      	Hidden:0,  Width:80,   	Align:"Center",  SaveName:"jikweeNm",	KeyField:0},
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",	Type:"Text",      	Hidden:0,  Width:40,  	Align:"Center",  SaveName:"name",  		KeyField:0},
			{Header:"TOKEN",Type:"Text",      	Hidden:1,  Width:40,  	Align:"Center",  SaveName:"tSabun",  	KeyField:0}
		]; IBS_InitSheet(chgUserEmpSht, initdata); chgUserEmpSht.SetEditable(false);chgUserEmpSht.SetVisible(true);chgUserEmpSht.SetEditableColorDiff (0);chgUserEmpSht.SetFocusAfterProcess(0);
		// sheet 높이 계산
		let chgUserEmpShtHeight = $(".modal_body").height() - $("#sheetForm").height() - $(".sheet_title").height() - 2;
		chgUserEmpSht.SetSheetHeight(chgUserEmpShtHeight);

		$(window).smartresize(sheetResize); sheetInit();

		$("#name, #orgNm").bind("keyup",function(event){
			if( event.keyCode == 13){ $("#orgCd").val(); orgList(); $(this).focus(); }
		});

		$("#sabun").val("${ssnSabun}");
		doAction2("Search");
		//doAction3("Search");
		$("#sabun").val("");


		$("#confirmPass").keyup(function(e){
			if( e.keyCode == 13) {changeUser();}
		});

		$("#name").focus();

	});
	function orgList(){
		// $("#orgCd").val("");
		doAction3("Search");
	}
	function doAction2(sAction) {
		switch (sAction) {
			case "Search":
				chgUserOrgSht.DoSearch( "${ctx}/AppPathReg.do?cmd=getAppPathOrgList", $("#sheetForm").serialize());
				break;
		}
	}
	function doAction3(sAction) {
		//switch (sAction) { case "Search":  chgUserEmpSht.DoSearch( "${ctx}/AppPathReg.do?cmd=getAppPathRegOrgUserList", $("#sheetForm").serialize()); break; }
		switch (sAction) { case "Search":  chgUserEmpSht.DoSearch( "${ctx}/AppPathReg.do?cmd=getOrgUserTokenList", $("#sheetForm").serialize()); break; }
	}

	// 조회 후 에러 메시지
	function chgUserOrgSht_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {alert(Msg);}
			chgUserOrgSht.SetFocusAfterProcess(0);
			sheetResize();
			$("#name").focus();
		} catch (ex) {alert("OnSearchEnd Event Error : " + ex);}
	}

	function chgUserEmpSht_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {alert(Msg);}
			chgUserEmpSht.SetFocusAfterProcess(0);
			//sheetResize();

			//stop = false;
			//limit = baselimit;
			//$("#limit_loc").css("display","");
			//chechRefreshTime();

		} catch (ex) {alert("OnSearchEnd Event Error : " + ex);}
	}


	function chgUserOrgSht_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		try {
			selectSheet = chgUserOrgSht;
			chgUserOrgSht.SetCellBackColor(OldRow, OldCol, "#FFFFFF");
			chgUserOrgSht.SetCellBackColor(NewRow, NewCol, "#8998A4");

			if( OldRow != NewRow ) {
				$("#orgCd").val(chgUserOrgSht.GetCellValue(NewRow,"orgCd"));
				$("#name").val("");
				$("#orgNm").val("");
				doAction3("Search");
			}
		} catch (ex) { alert("OnSelectCell Event Error " + ex); }
	}


	function chgUserEmpSht_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		try {
			selectSheet = chgUserEmpSht;

			if( OldRow != NewRow ) {

				$("#vOrgNm").html(chgUserEmpSht.GetCellValue(NewRow,"orgNm"));
				$("#vName").html(chgUserEmpSht.GetCellValue(NewRow,"name"));
				$("#vJikweeNm").html(chgUserEmpSht.GetCellValue(NewRow,"jikweeNm"));
				$("#tSabun").val(chgUserEmpSht.GetCellValue(NewRow,"tSabun"));
				openConF(1);

			}
		} catch (ex) { alert("OnSelectCell Event Error " + ex); }
	}


	function chechRefreshTime(){
		if( limit > 0 && stop == "true" ){
			$("#limit_sec").html(limit);
			if( !stop ) setTimeout("chechRefreshTime()",1100);
		}else if( limit > 0 && stop == false ){

		}else{
			p.window.close();
		}
		limit--;
	}

	//사용자변경 비밀번호 확인창 열기/닫기
	function openConF(flag){
		if( flag == 1 ){
			stop = true;
			$("#cfpop").show();
			setTimeout("setConfirmPassFocus()",100); //왜인지 모르지만 focus()가 바로 안되서 딜레이를 줌.
		}else {
			stop = false;
			limit = baselimit;
			chechRefreshTime();
			$("#cfpop").hide();
		}
	}
	function setConfirmPassFocus(){
		$("#confirmPass").focus();

	}

	//사용자변경
	function changeUser(){
		try {

			if( $("#confirmPass").val() == "" ){
				$("#confirmPass").focus();
				alert("<msg:txt mid='109422' mdef='로그인 비밀번호을 입력 해주세요.'/>");
				return;
			}

			//RSA 암호화 생성
			var rsa = new RSAKey();
			rsa.setPublic($("#RSAModulus").val(), $("#RSAExponent").val());

			//사용자 계정정보를 암호화 처리
			var pwd = rsa.encrypt($("#confirmPass").val());

			$("#chgSabun").val($("#tSabun").val());
			$("#confirmPwd").val(pwd);

			if(confirm("선택된 사용자로 로그인 하시 겠습니까?")){
				submitCall($("#submitForm"), "_self", "POST", "${ctx}/loginUser.do");
			}
		} catch (ex) { alert("changeUser Error " + ex); }
	}
</script>
<style type="text/css">
	#cfpop div.pwd_confirm {margin:10px;}
	#cfpop div.pwd_confirm table th {width:70px; padding:3px; }
	#cfpop div.pwd_confirm table td select {padding:3px;}
	#cfpop div.pwd_confirm table td input {width:80%;padding:3px;padding-left:10px;}
	#cfpop {position:absolute; top:0; left:0; width:100%; height:100%;padding:20px;display:none;}
	#cfpop div.back{position:absolute; top:0; left:0; width:100%; height:100%; background-color:#f4f4f4; z-index:10;opacity: 0.3;}
	#cfpop div.body{position:absolute; top:50%; left:50%; width:400px; height:420px; margin-left:-200px;margin-top:-200px;background-color:#fff; z-index:11; border:1px solid #b1b1b1;}

</style>
<div class="wrapper modal_layer">
	<form id="submitForm" name="submitForm">
		<input id="chgSabun" name="chgSabun" 		type="hidden" />
		<input id="confirmPwd" name="confirmPwd" 	type="hidden" />
	</form>
	<div class="modal_body">
		<div id="cfpop">
			<div class="back"></div>
			<div class="body">
<%--				<div class="popup_title">--%>
<%--					<ul>--%>
<%--						<li><tit:txt mid='113571' mdef='사용자 변경 로그인 확인'/></li>--%>
<%--						<li class="close" onclick="openConF(2)"></li>--%>
<%--					</ul>--%>
<%--				</div>--%>
				<div class="popup_password pwd_confirm">
					<div class="sheet_title">
						<ul>
							<li class="txt"><tit:txt mid='112174' mdef='변경 대상자'/></li>
						</ul>
					</div>
					<table border="0" cellpadding="0" cellspacing="0" class="default">
						<tr>
							<th><span><tit:txt mid='104279' mdef='소속'/></span></th>
							<td colspan="3"><span id="vOrgNm"></span></td>
						</tr>
						<tr>
							<th><span><tit:txt mid='103915' mdef='이름'/></span></th>
							<td><span id="vName"></span></td>
							<th><span><tit:txt mid='104104' mdef='직위'/></span></th>
							<td><span id="vJikweeNm"></span></td>
						</tr>
					</table>
				</div>
				<div class="popup_password pwd_confirm">
					<div class="sheet_title">
						<ul>
							<li class="txt"><tit:txt mid='pwdConfirmPop' mdef='비밀번호 확인'/></li>
						</ul>
					</div>
					<table border="0" cellpadding="0" cellspacing="0" class="default">
						<tr>
							<th><span><tit:txt mid='103915' mdef='이름'/></span></th>
							<td><span>${ssnAdminName}</span></td>
							<th><span><tit:txt mid='103975' mdef='사번'/></span></th>
							<td><span>${ssnAdminSabun}</span></td>
						</tr>
						<tr>
							<th><span><tit:txt mid='113098' mdef='비밀번호'/></span></th>
							<td colspan="3"><span><input type="password" name="confirmPass" id="confirmPass" class="required"></span></td>
						</tr>
					</table>
				</div>
				<div class="modal_footer">
					<btn:a href="javascript:changeUser();" css="btn filled" mid='110716' mdef="확인"/>
					<btn:a href="javascript:openConF(2);" css="btn outline_gray" mid='110881' mdef="닫기"/>
				</div>
			</div>
		</div>
		<form id="sheetForm" name="sheetForm">
			<input id="orgCd" 		name="orgCd" 		type="hidden" />
			<input id="sabun" 		name="sabun" 		type="hidden" />
			<input id="tSabun" 		name="tSabun" 		type="hidden" />
			<input type="hidden" id="RSAModulus" value="${RSAModulus}" />
			<input type="hidden" id="RSAExponent" value="${RSAExponent}" />
			<div class="sheet_search outer">
				<div>
					<table>
						<tr>
							<th><tit:txt mid='103880' mdef='성명'/></th>
							<td>
								<input id="name" name="name" type="text" class="text" style="ime-mode:active;"  />
							</td>
							<th><tit:txt mid='104279' mdef='소속'/></th>
							<td>
								<input id="orgNm" name="orgNm" type="text" class="text" />
							</td>
							<td>
								<a href="javascript:orgList();" class="button"><tit:txt mid='104081' mdef='조회'/></a>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</form>
			<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
				<tr>
					<td id="orgMain" class="sheet_left w25p">
						<div class="inner">
							<div class="sheet_title">
								<ul>
									<li class="txt">조직트리</li>
									<li class="btn">
									</li>
								</ul>
							</div>
						</div>
						<div id="chgUserOrgSht-wrap"></div>
					</td>
					<td id="listMain" class="sheet_left w50p">
						<div class="inner">
							<div class="sheet_title">
								<ul>
									<li class="txt"><tit:txt mid='schUser' mdef='사용자 검색'/></li>
									<li id="limit_loc" class="btn" style="display:none" ><span id='limit_sec'>"+limit+"</span>초 후에는  로그인이 불가합니다.
									</li>

								</ul>
							</div>
						</div>
						<div id="chgUserEmpSht-wrap"></div>
					</td>
				</tr>
			</table>
	</div>
	<div class="modal_footer">
		<btn:a href="javascript:closeCommonLayer('chgUserLayer');" css="btn outline_gray" mid='110881' mdef="닫기"/>
	</div>
</div>
