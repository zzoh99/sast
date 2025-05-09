<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html><html><head><title>대상자 선택 팝업</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<style type="text/css">
/*
html, body {
	overflow:auto;
}
*/
.overAuto {overflow:auto;}
</style>
<script type="text/javascript">
	
	var p = eval("${popUpStatus}");
	var gPRow = "";
	var pGubun = "";
			
	/*
	 * sheet Init
	 */
	$(function(){
	
		 var initdata = {};
			initdata.Cfg = {FrozenCol:4,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
			initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
			initdata.Cols = [
				{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo", Sort:0 },
				{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",	Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
				{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
				{Header:"조직코드",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"orgCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				
				{Header:"\n선택", 		Type:"DummyCheck",  Hidden:0,  Width:50,    Align:"Center",  ColMerge:0,   SaveName:"chooseRow",	Sort:0  },
				{Header:"소속경로",		Type:"Text",		Hidden:0,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"orgPath",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				{Header:"소속",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				{Header:"사번",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				{Header:"성명",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				{Header:"직급코드",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				{Header:"직급",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				{Header:"등급코드",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"gradeCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				{Header:"등급",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"gradeNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				{Header:"직위코드",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				{Header:"직위",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				{Header:"직책코드",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikchakCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				{Header:"직책",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				{Header:"직책구분코드",	Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikchakGubunCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				{Header:"직책구분",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikchakGubunNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				{Header:"직종코드",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikjongCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				{Header:"직종",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikjongNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }				
				
			]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");sheet1.SetImageList(1,"${ctx}/common/images/icon/icon_o.png");sheet1.SetImageList(2,"${ctx}/common/images/icon/icon_x.png");
			
			
			var jikjongCdArr = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","HHI35"), "<tit:txt mid='103895' mdef='전체'/>");	//직종코드
			$("#searchJikjongCd").html(jikjongCdArr[2]);			
			var jikgubCdArr = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20010"), "<tit:txt mid='103895' mdef='전체'/>");	//직급코드
			$("#searchJikgubCd").html(jikgubCdArr[2]);
			var gradeCdArr = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H90204"), "<tit:txt mid='103895' mdef='전체'/>");	//등급코드
			$("#searchGradeCd").html(gradeCdArr[2]);
			var jikweeCdArr 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20030"), ("<tit:txt mid='103895' mdef='전체'/>"));	//직위
			$("#searchJikweeCd").html(jikweeCdArr[2]);
			var jikchakCdArr 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20020"), ("<tit:txt mid='103895' mdef='전체'/>"));	//직책
			$("#searchJikchakCd").html(jikchakCdArr[2]);

			var jikchakGubunCdArr 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","HHI04"), ("<tit:txt mid='103895' mdef='전체'/>"));	//직책구분
			$("#searchJikchakGubunCd").html(jikchakGubunCdArr[2]);
			
			$("#searchSabun").bind("keyup",function(event){
				if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
			});
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});
	
	/**
	 * Sheet 각종 처리
	 */
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": //조회

			sheet1.DoSearch( "${ctx}/AuthGrpUserMgr.do?cmd=getAuthGrpUserMgrTargetPopupList", $("#srchFrm").serialize());
			break;		
		case "Down2Excel": //엑셀내려받기

			sheet1.Down2Excel({ DownCols : makeHiddenSkipCol(sheet1), SheetDesign : 1, Merge : 1 });
			break;

		}
	}

	
	function setValue() {
		
		var cnt = 0;
		var tArray = new Array();
				
		for(var i=1;i<=sheet1.LastRow();i++){
			if(sheet1.GetCellValue(i, "chooseRow") == "1"){
				var rv = new Array(11);		
				
				rv["orgPath"] 	= sheet1.GetCellValue(i, "orgPath");		//경로
				rv["orgCd"] 	= sheet1.GetCellValue(i, "orgCd");			//조직코드
				rv["orgNm"] 	= sheet1.GetCellValue(i, "orgNm");		//소속					
				rv["sabun"] 	= sheet1.GetCellValue(i, "sabun");			//사번
				rv["name"] 	= sheet1.GetCellValue(i, "name");			//성명
				rv["jikweeNm"] 	= sheet1.GetCellValue(i, "jikweeNm");	//직위
				rv["jikweeCd"] 	= sheet1.GetCellValue(i, "jikweeCd");	//직위
				rv["jikchakNm"] 	= sheet1.GetCellValue(i, "jikchakNm");	//직책
				rv["jikchakCd"] 	= sheet1.GetCellValue(i, "jikchakCd");	//직책
				rv["jikgubNm"] 	= sheet1.GetCellValue(i, "jikgubNm");	//직급
				rv["jikgubCd"] 	= sheet1.GetCellValue(i, "jikgubCd");	//직급
				rv["gradeNm"] 	= sheet1.GetCellValue(i, "gradeNm");		//등급
				rv["gradeCd"] 	= sheet1.GetCellValue(i, "gradeCd");		//등급
				rv["jikjongNm"] 	= sheet1.GetCellValue(i, "jikjongNm");	//직종
				rv["jikjongCd"] 	= sheet1.GetCellValue(i, "jikjongCd");	//직종
								
				tArray[cnt] = rv;				
				cnt++;
			}			
		}
		
		console.log(tArray);
		
		if(cnt == 0){
			alert("선택된 대상자가 없습니다.");
			return;
		}
		
		p.popReturnValue2(tArray);
		p.window.close();
	}

	function addComma(n) {
		if (isNaN(n)) {
			return 0;
		}
		var reg = /(^[+-]?\d+)(\d{3})/;
		n += '';
		while (reg.test(n))
			n = n.replace(reg, '$1' + ',' + '$2');
		return n;
	}

	function sheet1_OnSearchEnd(Code, ErrMsg, StCode, StMsg) {
		try {
			if (ErrMsg != "") {
				location.href = "/JSP/ErrorPage.jsp?errorMsg=" + ErrMsg;
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet1_OnSaveEnd(Code, ErrMsg, StCode, StMsg) {
		try {
			if (ErrMsg != "") {
				alert(ErrMsg);
				doAction1("Search");
			}
		} catch (ex) {
			alert("OnSaveEnd Event Error : " + ex);
		}
	}
	
	function fnSearchJikgubChange(){
		
		var searchJikgubCd = $("#searchJikgubCd option:selected").val();		
		var param = "&searchJikgubCd="+searchJikgubCd;
		var gradeCdArr = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getGradeCdListByJikgubCd"+param,false).codeList, "전체");		
		$("#searchGradeCd").html(gradeCdArr[2]);
		
	}
	
	function orgSearchPopup(){
		try{
			var w 		= 840;
			var h 		= 520;
			var url 	= "/Popup.do?cmd=orgBasicPopup";
			var args 	= new Array();

			args["orgCd"] = "";
			args["orgNm"] = "";

			if(!isPopup()) {return;}			
			pGubun = "childOrgPopup";
			openPopup(url+"&authPg=${authPg}", args, w, h);

		}catch(ex){alert("Open Popup Event Error : " + ex);}
	}
	
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');		
		if(pGubun == "childOrgPopup"){
			$("#searchOrgCd").val(rv["orgCd"]);
			$("#searchOrgNm").val(rv["orgNm"]);
		}	   
	}
	
	function setCheckBox(){
		var chk = $("input:checkbox[id='searchType']").is(":checked");
		
		if(chk == true){
			$("#searchPriorYn").val("Y");
		}else{
			$("#searchPriorYn").val("N");
		}		
	}
	
</script>

</head>
<body class="bodywrap">
	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li>대상자 선택</li>
				<li class="close" onclick="p.self.close()"></li>
			</ul>
		</div>
        <div class="popup_main">
		<form id="srchFrm" name="srchFrm" tabindex="1">
            
            
            <input type="hidden" id="searchPriorYn" name="searchPriorYn" value="N" />
            
			<div class="sheet_search outer">
				<div>
				<table>
				<tr>
					<td colspan="2">
						<span>부서명  </span>
						<input id="searchOrgCd" name ="searchOrgCd" type="hidden" class="text"/>
						<input id="searchOrgNm" name ="searchOrgNm" type="text" class="text" readOnly/>
						<a href="javascript:orgSearchPopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
						<a onclick="$('#searchOrgCd').val('');$('#searchOrgNm').val('');return false;" href="javascript:void(0);" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
						&nbsp;<input type="checkbox" class="checkbox" id="searchType" name="searchType" style="vertical-align:middle;" onClick="setCheckBox();" />&nbsp;<b><tit:txt mid='104304' mdef='하위조직포함'/></b>
						
						<span>직위  </span><select id="searchJikweeCd" name="searchJikweeCd" class="w120"/></select>
					</td>
					<td> 
						<span>직책 </span><select id="searchJikchakCd" name="searchJikchakCd" class="w120"/></select>&nbsp;&nbsp;&nbsp;
					</td>
					<td> 
						<span>직책구분 </span><select id="searchJikchakGubunCd" name="searchJikchakGubunCd" class="w100"/></select>&nbsp;&nbsp;&nbsp;
					</td>
				</tr>
				<tr>
					<td colspan="4"> 
					 	<span>직종 </span><select id="searchJikjongCd" name="searchJikjongCd" class="w120"/></select>
						<span>직급  </span><select id="searchJikgubCd" name="searchJikgubCd" class="w120" onchange="fnSearchJikgubChange();" /></select>
						<span>등급  </span><select id="searchGradeCd" name="searchGradeCd" class="w120"/></select>
					 	<span>성명/사번 </span> <input id="searchSabun" name ="searchSabun" type="text" class="text" />&emsp;&emsp;&emsp;
					 	<btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='110697' mdef="조회" style="vertical-align:middle;" /> 
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
						<li id="txt" class="txt">대상자 선택</li>
						<li class="btn">
						</li>
					</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
				</td>
			</tr>
		</table>

		<div class="popup_button outer">
			<ul>
				<li>
					<a href="javascript:setValue();" class="pink large authA"><tit:txt mid='104435' mdef='확인'/></a>
					<btn:a href="javascript:p.self.close();" css="gray large" mid='110881' mdef="닫기"/>
				</li>
			</ul>
		</div>
	</div>
</div>
</body>

</html>
