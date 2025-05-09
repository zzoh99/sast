<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html><html><head><title>대상자 선택 팝업</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<!-- 
include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"
-->

<style type="text/css">
/*
html, body {
	overflow:auto;
}
*/
.overAuto {overflow:auto;}
</style>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";
	/*
	 * sheet Init
	 */
	$(function(){
	
		const modal = window.top.document.LayerModalUtility.getModal('authGrpUserMgrTargetLayer');

		createIBSheet3(document.getElementById('authTargetSht-wrap'), "authTargetSht", "100%", "100%", "${ssnLocaleCd}");
		
		var initdata = {};
			initdata.Cfg = {FrozenCol:4,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly, DataRowMerge:0, ChildPage:5, AutoFitColWidth:'init|search|resize|rowtransaction'};
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
				
			]; IBS_InitSheet(authTargetSht, initdata);authTargetSht.SetEditable("${editable}");authTargetSht.SetVisible(true);authTargetSht.SetCountPosition(4);authTargetSht.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");authTargetSht.SetImageList(1,"${ctx}/common/images/icon/icon_o.png");authTargetSht.SetImageList(2,"${ctx}/common/images/icon/icon_x.png");

		// sheet 높이 계산
		var sheetHeight = $(".modal_body").height() - $("#srchFrm").height() - $(".sheet_title").height() - 2;
		authTargetSht.SetSheetHeight(sheetHeight);
			
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

			authTargetSht.DoSearch( "${ctx}/AuthGrpUserMgr.do?cmd=getAuthGrpUserMgrTargetPopupList", $("#srchFrm").serialize());
			break;		
		case "Down2Excel": //엑셀내려받기

			authTargetSht.Down2Excel({ DownCols : makeHiddenSkipCol(authTargetSht), SheetDesign : 1, Merge : 1 });
			break;

		}
	}

	
	function setValue() {
		
		var cnt = 0;
		var tArray = new Array();
				
		for(var i=1;i<=authTargetSht.LastRow();i++){
			if(authTargetSht.GetCellValue(i, "chooseRow") == "1"){
				var rv = new Array(11);		
				
				rv["orgPath"] 	= authTargetSht.GetCellValue(i, "orgPath");		//경로
				rv["orgCd"] 	= authTargetSht.GetCellValue(i, "orgCd");			//조직코드
				rv["orgNm"] 	= authTargetSht.GetCellValue(i, "orgNm");		//소속					
				rv["sabun"] 	= authTargetSht.GetCellValue(i, "sabun");			//사번
				rv["name"] 	= authTargetSht.GetCellValue(i, "name");			//성명
				rv["jikweeNm"] 	= authTargetSht.GetCellValue(i, "jikweeNm");	//직위
				rv["jikweeCd"] 	= authTargetSht.GetCellValue(i, "jikweeCd");	//직위
				rv["jikchakNm"] 	= authTargetSht.GetCellValue(i, "jikchakNm");	//직책
				rv["jikchakCd"] 	= authTargetSht.GetCellValue(i, "jikchakCd");	//직책
				rv["jikgubNm"] 	= authTargetSht.GetCellValue(i, "jikgubNm");	//직급
				rv["jikgubCd"] 	= authTargetSht.GetCellValue(i, "jikgubCd");	//직급
				rv["gradeNm"] 	= authTargetSht.GetCellValue(i, "gradeNm");		//등급
				rv["gradeCd"] 	= authTargetSht.GetCellValue(i, "gradeCd");		//등급
				rv["jikjongNm"] 	= authTargetSht.GetCellValue(i, "jikjongNm");	//직종
				rv["jikjongCd"] 	= authTargetSht.GetCellValue(i, "jikjongCd");	//직종
								
				tArray[cnt] = rv;				
				cnt++;
			}			
		}
		
		console.log(tArray);
		
		if(cnt == 0){
			alert("선택된 대상자가 없습니다.");
			return;
		}
		
		//p.popReturnValue2(tArray);
		//p.window.close();
        const modal = window.top.document.LayerModalUtility.getModal('authGrpUserMgrTargetLayer');
        modal.fire('authGrpUserMgrTargetTrigger', tArray ).hide();
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

	function authTargetSht_OnSearchEnd(Code, ErrMsg, StCode, StMsg) {
		try {
			if (ErrMsg != "") {
				location.href = "/JSP/ErrorPage.jsp?errorMsg=" + ErrMsg;
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function authTargetSht_OnSaveEnd(Code, ErrMsg, StCode, StMsg) {
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
			if(!isPopup()) {return;}
			gPRow = "";
			pGubun = "orgBasicPopup";

			let layerModal = new window.top.document.LayerModal({
				id : 'orgLayer'
				, url : '/Popup.do?cmd=viewOrgBasicLayer&authPg=${authPg}'
				, parameters : {}
				, width : 740
				, height : 520
				, title : '<tit:txt mid='orgSchList' mdef='조직 리스트 조회'/>'
				, trigger :[
					{
						name : 'orgTrigger'
						, callback : function(result){
							if(!result.length) return;
							$("#searchOrgNm").val(result[0].orgNm);
							$("#searchOrgCd").val(result[0].orgCd);
						}
					}
				]
			});
			layerModal.show();


		}catch(ex){alert("Open Popup Event Error : " + ex);}
	}
	
	function getReturnValue(rv) {
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
	<div class="wrapper modal_layer">
        <div class="modal_body">
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
						<span>직급  </span><select id="searchJikgubCd" name="searchJikgubCd" class="w120" /></select>
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
				<div id="authTargetSht-wrap"></div>
				<!-- <script type="text/javascript">createIBSheet("authTargetSht", "100%", "100%","${ssnLocaleCd}"); </script> -->
				</td>
			</tr>
		</table>
	</div>


	<div class="modal_footer">
		<a href="javascript:setValue();" class="btn filled"><tit:txt mid='104435' mdef='확인'/></a>
		<btn:a href="javascript:closeCommonLayer('authGrpUserMgrTargetLayer');" css="btn outline_gray" mid='110881' mdef="닫기"/>
	</div>
</div>
</body>

</html>
