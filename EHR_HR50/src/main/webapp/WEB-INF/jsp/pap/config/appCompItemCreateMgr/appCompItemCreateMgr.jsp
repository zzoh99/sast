<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {

		//평가명 변경 시
		$("#searchAppraisalCd").bind("change",function(event){
			//평가 타입 가져오기
			var data = ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&"
						, "queryId=getAppraisalTypeCdMap&searchAppraisalCd=" + $("#searchAppraisalCd").val()
						, false).codeList;
			if(data != null && data.length > 0){
				$("#searchAppTypeCd").val(data[0].appTypeCd);
			}else{
				$("#searchAppTypeCd").val("");
			}
			//평가명리스트
			var appStepCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppStepCdList&searchAppraisalCd=" + $(this).val(),false).codeList, "");
			try{
				if ( appStepCdList == false ){
					$("#searchAppStepCd").html("<option value=''>선택하세요</option>");
				}else if( appStepCdList[1] == "" || appStepCdList[1].split("|").length == 1){
					$("#searchAppStepCd").html(appStepCdList[2]);
					//doAction1("Search");
				}else{
					$("#searchAppStepCd").html("<option value=''>선택하세요</option>"+appStepCdList[2]);
				}
			}catch(e){}

		});

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"성명",			Type:"Text",	Hidden:0,  Width:80,  Align:"Center",	ColMerge:0,   SaveName:"name",			KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"사번",			Type:"Text",	Hidden:0,  Width:80,  Align:"Center",	ColMerge:0,   SaveName:"sabun",			KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"평가소속",		Type:"Text",	Hidden:0,  Width:100,  Align:"Center",	ColMerge:0,   SaveName:"appOrgNm",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직책",			Type:"Text",	Hidden:0,  Width:100,  Align:"Center",	ColMerge:0,   SaveName:"jikchakNm",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"역량구분",		Type:"Text",	Hidden:0,  Width:100,  Align:"Center",	ColMerge:0,   SaveName:"comGubunNm",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"역량명",		Type:"Text",	Hidden:0,  Width:100,  Align:"Center",	ColMerge:0,   SaveName:"competencyNm",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"평가ID",		Type:"Text",	Hidden:1,  Width:100,  Align:"Center",	ColMerge:0,   SaveName:"appraisalCd",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"평가소속코드",	Type:"Text",	Hidden:1,  Width:100,  Align:"Center",	ColMerge:0,   SaveName:"appOrgCd",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"역량코드",		Type:"Text",	Hidden:1,  Width:100,  Align:"Center",	ColMerge:0,   SaveName:"competencyCd",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var famList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdList",false).codeList, ""); // 평가명, 다면평가 제외
		var comboList1	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00007"),"전체"); // 역량구분

		$("#searchAppraisalCd").html(famList[2]); //평가명
		$("#searchComGubunCd").html(comboList1[2]); //역량구분


		//평가명 변경 시
		$("#searchComGubunCd").bind("change",function(event){
			//평가 타입 가져오기

			var val = $(this).val();

			try{

				if ( val == "" ){
					$("#searchCompetencyCd").html("<option value=''>전체</option>");
				}else{
					var searchCompetencyCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppCompItemCreateMgrCodeList&searchComGubunCd=" + val,false).codeList, "전체");
					if ( searchCompetencyCdList == false ){
						$("#searchCompetencyCd").html(searchCompetencyCdList[2]);
					}else if( searchCompetencyCdList[1] == "" || searchCompetencyCdList[1].split("|").length == 1){
						$("#searchCompetencyCd").html(searchCompetencyCdList[2]);
						//doAction1("Search");
					}else{
						$("#searchCompetencyCd").html(searchCompetencyCdList[2]);
					}
				}
			}catch(e){}

		});

		$("#searchAppraisalCd").change();
		$("#searchComGubunCd").change();


		$("#searchAppStepCd, #searchCompetencyCd").bind("change",function(event){
			doAction1("Search");
		});

		$("#searchNameSabun").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search"); $(this).focus();
			}
		});

		$("#searchName").bind("keyup",function(event){
			if( event.keyCode == 13){
				employeePopup(); $(this).focus();
			}
		});

		$(window).smartresize(sheetResize); sheetInit();

		//doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
							if ($("#searchAppraisalCd").val() == "") {
								alert("평가명을 선택하세요.");
								return;
							}
							if($("#searchAppStepCd").val() == ""){
								alert("평가단계를 선택하세요.");
								return;
							}
							sheet1.DoSearch( "${ctx}/AppCompItemCreateMgr.do?cmd=getAppCompItemCreateMgrList", $("#sheetForm").serialize() );
							break;
		case "Save":
							IBS_SaveName(document.sheetForm,sheet1);
							sheet1.DoSave( "${ctx}/AppCompItemCreateMgr.do?cmd=saveAppCompItemCreateMgr", $("#sheetForm").serialize()); break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":	sheet1.Down2Excel({DownCols:makeHiddenSkipCol(sheet1),SheetDesign:1,Merge:1}); break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); }
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "") alert(Msg);
			if ( Code != "-1" ) doAction1("Search");
		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function makeDic(){
		if ($("#searchAppraisalCd").val() == "") {
			alert("평가명을 선택하세요.");
			return;
		}
		if($("#searchAppStepCd").val() == ""){
			alert("평가단계를 선택하세요.");
			return;
		}

		var msg = "전체 평가대상자들의 역량평가표를 생성합니다\n계속하시겠습니까?";
		if(  $("#searchSabun").val() != "" ){
			msg = "대상자 ["+$("#searchName").val()+"]님의 역량평가표를 생성합니다\n계속하시겠습니까?";
		}
		if(confirm(msg)){
	        var data = ajaxCall("${ctx}/AppCompItemCreateMgr.do?cmd=prcAppCompItemCreateMgr",$("#sheetForm").serialize(),false);
			if(data.Result.Code == null) {
	    		doAction1("Search");
	    		alert("처리되었습니다.");
	    	} else {
		    	alert(data.Result.Message);
	    	}
		}
	}
    //사원 팝업
    function employeePopup(){

		const p = {
			topKeyword : $("#searchName").val()
		};

		var layer = new window.top.document.LayerModal({
			id : 'employeeLayer'
			, url : '/Popup.do?cmd=viewEmployeeLayer&authPg=${authPg}'
			, parameters: p
			, width : 650
			, height : 720
			, title : "인원조회"
			, trigger :[
				{
					name : 'employeeTrigger'
					, callback : function(rv){
						getReturnValue(rv);
					}
				}
			]
		});
		layer.show();

        <%--try{--%>
        <%--    if(!isPopup()) {return;}--%>

        <%--    var args = new Array();--%>
        <%--    args["topKeyword"] = $("#searchName").val();--%>

        <%--    gPRow = "";--%>
        <%--    pGubun = "searchEmployeePopup";--%>

        <%--    openPopup("${ctx}/Popup.do?cmd=employeePopup", args, "740","520");--%>

        <%--}catch(ex){alert("Open Popup Event Error : " + ex);}--%>
    }
    //팝업 콜백 함수.
    function getReturnValue(rv) {
        //var rv = $.parseJSON('{' + returnValue+ '}');

        //if(pGubun == "searchEmployeePopup"){
            $("#searchName").val(rv["name"]);
            $("#searchSabun").val(rv["sabun"]);
        //}
    }
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
		<input id="searchAppTypeCd" name ="searchAppTypeCd" type="hidden" value="" />
		<input id="searchSabun" name ="searchSabun" type="hidden" value="" />

		<div class="sheet_search outer">
			<div>

				<table>
					<tr>
						<td>
							<span>평가명</span>
							<select name="searchAppraisalCd" id="searchAppraisalCd" ></select>
						</td>
						<td>
							<span>평가단계</span>
							<select name="searchAppStepCd" id="searchAppStepCd" class="reqiured"></select>
						</td>
					</tr>
					<tr>
						<td>
							<span>역량구분</span>
							<select name="searchComGubunCd" id="searchComGubunCd" ></select>
						</td>
						<td>
							<span>역량명</span>
							<select name="searchCompetencyCd" id="searchCompetencyCd" ></select>
						</td>
						<td>
							<span>성명/사번</span>
							<input id="searchNameSabun" name ="searchNameSabun" type="text" class="text" />
						</td>
						<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="btn dark">조회</a> </td>
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
							<li id="txt" class="txt">역량평가표생성결과</li>
							<li class="btn">

							    <span>대상자 &nbsp;</span>
							    <!-- 대상자 명칭을 변경하고 팝업으로 조회하지 않을 경우 searchSabun이 변경되지 않는 오류가 발생하여 readonly처리 -->
	                            <input id="searchName" name="searchName" type="text" class="text" readonly="readonly"/>
								<a onclick="javascript:employeePopup();" class="ico-btn" id="btnAppSabunPop"><img src="/common/${theme}/images/btn_search2.gif"/></a>
								<a onclick="$('#searchSabun,#searchName').val('');" class="ico-btn"><img src="/common/images/icon/icon_undo.png"/></a>
								<a href="javascript:makeDic()" class="button authA">역량평가표생성</a>
								<a href="javascript:doAction1('Save')" 	class="btn soft authA">저장</a>
								<a href="javascript:doAction1('Down2Excel')" 	class="btn outline-gray authR">다운로드</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>