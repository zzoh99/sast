<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- <%@ page import="com.hr.common.util.DateUtil" %> --%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script src="/common/js/jquery/select2.js"></script>

<script type="text/javascript">
	var pRow = "";
	var pGubun = "";
	
	var titleList = new Array();
	
	var payGroupCdList = null;

	$(function() {

		$("input[type='text'], textarea").keydown(function(event){
			if(event.keyCode == 27){
				return false;
			}
		});

		$("#searchSDate").datepicker2({startdate:"searchEDate", onReturn: getCommonCodeList});
		$("#searchEDate").datepicker2({enddate:"searchSDate", onReturn: getCommonCodeList});
		$("#searchEDate, #searchSDate").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		
		// 연봉항목
		var elementCdList 	= convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getPerPayYearLstEleList&searchSDate="+$("#searchSDate").val(),false).codeList, "");
		$("#searchElementCd").html(elementCdList[2]);
		$("#searchElementCd").select2({
			placeholder: "선택"
		});
		$("#searchElementCd").select2("val", ["YB00"]);
		
		getCommonCodeList();
		
		//연봉항목그룹 코드
		payGroupCdList = convCode( ajaxCall("${ctx}/PerPayYearLst.do?cmd=getPerPayYearEleGroupCodeList","",false).codeList, "선택");
		$("#searchPayGroupCd").html(payGroupCdList[2]);
		$("#searchPayGroupCd").bind("change", function(e) {
			doAction1("Search");
		});
		
		var initdata = {};
		initdata.Cfg = {FrozenCol:5,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"연봉그룹",		Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"payGroupCd",	KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"사번",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:15},
			{Header:"성명",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30},
			{Header:"부서",			Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"계약유형",		Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"manageNm",	KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"직책",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",	KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"직위",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"직급",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",	KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"재직상태",		Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"statusNm",	KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"시작일",			Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:0,	Format:"Ymd",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10},
			{Header:"종료일",			Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	Format:"Ymd",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10}

		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		
		//setSheetAutocompleteEmp( "sheet1", "name" );
		
		//Autocomplete	
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue) {
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow,"name", rv["name"]);
						sheet1.SetCellValue(gPRow,"sabun", rv["sabun"]);
						sheet1.SetCellValue(gPRow,"orgNm", rv["orgNm"]);
						sheet1.SetCellValue(gPRow,"manageNm", rv["manageNm"]);
						sheet1.SetCellValue(gPRow,"jikchakNm", rv["jikchakNm"]);
						sheet1.SetCellValue(gPRow,"jikweeNm", rv["jikweeNm"]);
						sheet1.SetCellValue(gPRow,"jikgubNm", rv["jikgubNm"]);
						sheet1.SetCellValue(gPRow,"statusNm", rv["statusNm"]);
					}
				}
			]
		});
		
		$(window).smartresize(sheetResize); sheetInit();

		$("#searchNm, #searchOrgNm, #searchSDate, #searchEDate").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		
		//doAction1("Search");
	});

	function getCommonCodeList() {
		let baseSYmd = $("#searchSDate").val();
		let baseEYmd = $("#searchEDate").val();

		// 계약유형
		var manageCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10030", baseSYmd, baseEYmd), "");
		$("#searchManageCd").html(manageCdList[2]);
		$("#searchManageCd").select2({
			placeholder: "선택"
		});

		/*
		// 직책
		var jikchakCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20020"), "");
		$("#searchJikchakCd").html(jikchakCdList[2]);
		$("#searchJikchakCd").select2({
			placeholder: "선택"
		});

		// 직위
		var jikweeCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20030"), "");
		$("#searchJikweeCd").html(jikweeCdList[2]);
		$("#searchJikweeCd").select2({
			placeholder: "선택"
		});

		// 직급
		var jikgubCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20010"), "");
		$("#searchJikgubCd").html(jikgubCdList[2]);
		$("#searchJikgubCd").select2({
			placeholder: "선택"
		});
		*/

		// 재직상태
		var statusCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10010", baseSYmd, baseEYmd), "");
		$("#searchStatusCd").html(statusCdList[2]);
		$("#searchStatusCd").select2({placeholder:""});
		$("#searchStatusCd").select2("val", ["AA"]);
		/*
		$("#searchStatusCd").select2({
			placeholder: "선택"
		});
		*/
	}
	
	/**
	 * Sheet 각종 처리
	 */
	function doAction1(sAction){
		switch(sAction){
			case "Search":	//조회
				$("#searchElementCdHidden").val(getMultiSelectValue($("#searchElementCd").val()));
				$("#searchManageCdHidden").val(getMultiSelectValue($("#searchManageCd").val()));
				$("#searchStatusCdHidden").val(getMultiSelectValue($("#searchStatusCd").val()));
				//$("#searchJikweeCdHidden").val(getMultiSelectValue($("#searchJikweeCd").val()));
				//$("#searchJikchakCdHidden").val(getMultiSelectValue($("#searchJikchakCd").val()));
				//$("#searchJikgubCdHidden").val(getMultiSelectValue($("#searchJikgubCd").val()));
				searchTitleList();
				break;
			
			case "Down2Excel":  //엑셀내려받기
				if($("#searchElementCd").val() == null || $("#searchElementCd").val() == "") {
					alert("연봉항목을 선택하여 주시기 바랍니다. ");
					return;
				} else {
					sheet1.Down2Excel({DownCols:makeHiddenSkipCol(sheet1),SheetDesign:1,Merge:1});
				}
				break;
		}
	}
	
	function searchTitleList() {
		
		var dataList = null;
		if( $("#searchElementCdHidden").val() != "" ) {
			var array = $("#searchElementCdHidden").val();
			array = array.slice(0,array.length-1).split(",");
			var data = new Array();
			for(var idx = 0; idx < array.length; idx++) {
				//console.log(idx, array[idx]);
				data.push({
					elementNm : $("option[value=" + array[idx] + "]", "#searchElementCd").text(),
					elementCd : array[idx].replace(/'/g, "")
				});
			}
			dataList = {DATA : data};
		} else {
			alert("연봉항목을 선택해주십시오.");
			return;
		}
		//console.log('dataList', dataList);
		
		if (dataList != null && dataList.DATA != null) {
			sheet1.Reset();
	
			var v = 0;
	
			var initdata1 = {};
			initdata1.Cfg = {FrozenCol:6,SearchMode:smLazyLoad, Page:22/* , FrozenCol:11 */ };
			initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};
	
			initdata1.Cols = [];
	
			initdata1.Cols[v++] = {Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" };
			initdata1.Cols[v++] = {Header:"연봉그룹",		Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"payGroupCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100};
			initdata1.Cols[v++] = {Header:"사번",		Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:20};
			initdata1.Cols[v++] = {Header:"성명",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:20};
			initdata1.Cols[v++] = {Header:"부서",		Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:150};
			initdata1.Cols[v++] = {Header:"계약유형",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"manageNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100};
			initdata1.Cols[v++] = {Header:"직책",		Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100};
			initdata1.Cols[v++] = {Header:"직위",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100};
			initdata1.Cols[v++] = {Header:"직급",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100};
			initdata1.Cols[v++] = {Header:"직구분",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"workType",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100};
			initdata1.Cols[v++] = {Header:"직구분",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"workTypeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100};
			initdata1.Cols[v++] = {Header:"재직상태",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"statusNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100};
			initdata1.Cols[v++] = {Header:"시작일",		Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10};
			initdata1.Cols[v++] = {Header:"종료일",		Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10};
			initdata1.Cols[v++] = {Header:"선택",		Type:"CheckBox",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"calcChk",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10};
	
			var columnInfo = "";
			var item = null;
			
			for(var i = 0; i < dataList.DATA.length; i++) {
				item = dataList.DATA[i];
				
				// add column
				initdata1.Cols[v++]  = {
					  Header:item.elementNm
					, Type:"Int"
					, Hidden:0
					, Width:100
					, Align:"Right"
					, ColMerge:0
					, SaveName:"ele" + item.elementCd.substring(0, 1).toUpperCase() + item.elementCd.substring(1, item.elementCd.length).toLowerCase()
					, KeyField:0
					, Format:"NullInteger"
					, PointCount:0
					, UpdateEdit:0
					, InsertEdit:0
					, EditLen:100
				};
				
				// add column for SQL
				columnInfo = columnInfo + "'" + item.elementCd + "' AS " + "ELE_" + item.elementCd +",";
			}
			initdata1.Cols[v++]  = { Header:"비고",		Type:"Text",	Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"bigo",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000};
			
			columnInfo = columnInfo.slice(0,columnInfo.length-1);
			// $("#columnInfo").val(columnInfo);
			
			IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(4);
			
			sheet1.SetColProperty("payGroupCd", 			{ComboText:"|"+payGroupCdList[0], ComboCode:"|"+payGroupCdList[1]});
			
			// 데이타 조회
			sheet1.DoSearch( "${ctx}/PerPayYearLst.do?cmd=getPerPayYearLstList", $("#srchFrm").serialize() );
		}
	}
	
	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	
	function getMultiSelectValue( value ) {
		if( value == null || value == "" ) return "";
		if (value.indexOf("m") == -1) return value+","; // 선택된 값이 한개일 경우 Dao에서 배열로 바뀌지 않아서 오류남 콤마 추가
		//return "'"+String(value).split(",").join("','")+"'";
		return value;
	}
	
	//  소속 조회 팝입
	function openOrgSchemePopup(){
		let parameters = {
			multiSelect : 'N'
			, baseDate : $("#searchEDate").val()
		};
		let hiddenOrg = $("#searchOrgCdHidden").val().replace(/'/g, "");
		if(hiddenOrg !== '') parameters.chooseOrgCds = hiddenOrg;

		let layerModal = new window.top.document.LayerModal({
			id : 'orgLayer'
			, url : '/Popup.do?cmd=viewOrgBasicLayer&authPg=${authPg}'
			, parameters : parameters
			, width : 800
			, height : 520
			, title : '<tit:txt mid='orgSchList' mdef='조직 리스트 조회'/>'
			, trigger :[
				{
					name : 'orgTrigger'
					, callback : function(result){
						if(!result.length) return;

						if(result.length === 1){
							$("#searchOrgCdHidden").val(result[0].orgCd);
							$("#searchOrgNm").val(result[0].orgNm);
						}else{
							let orgCdArr = [];
							let orgNmArr = [];
							for(let i=0; i<result.length; i++){
								orgCdArr.push('\'' + result[i].orgCd + '\'');
								orgNmArr.push(result[i].orgNm)
							}

							$("#searchOrgCdHidden").val(orgCdArr.join(','));
							$("#searchOrgNm").val(orgNmArr.join(','));
						}
					}
				}
			]
		});
		layerModal.show();

		<%--try{--%>
		<%--	if(!isPopup()) {return;}--%>

		<%--	gPRow = "";--%>
		<%--	pGubun = "orgBasicPopup";--%>

		<%--	var args    = new Array();--%>
		<%--		args['multiSelect'] = "Y";--%>
		<%--		args['baseDate']    = $("#searchEDate").val();--%>

		<%--	if($("#searchOrgCdHidden").val() != "") {--%>
		<%--		args['chooseOrgCds'] = $("#searchOrgCdHidden").val().replace(/'/g, "");--%>
		<%--	}--%>
		<%--	var rv = openPopup("/Popup.do?cmd=orgBasicPopup&authPg=${authPg}", args, "800","520");--%>
		<%--}catch(ex){alert("Open Org Search Popup Event Error : " + ex);}--%>
	}
	
	//  직급 조회 팝입
	function openJikgubSchemePopup(){

		let parameters = {
			multiSelect : 'Y'
			, baseDate : $("#searchEDate").val()
		};
		if($("#searchJikgubCdHidden").val() !== ''){
			parameters.chooseJikgubCds = $("#searchJikgubCdHidden").val().replace(/'/g, "");
		}
		let layerModal = new window.top.document.LayerModal({
			id : 'jikgubLayer'
			, url : '/Popup.do?cmd=viewJikgubBasicLayer&authPg=${authPg}'
			, parameters : parameters
			, width : 860
			, height : 520
			, title : '직급 리스트 조회'
			, trigger :[
				{
					name : 'jikgubTrigger'
					, callback : function(result){
						if(!result.length) return;

						if(result.length === 1){
							$("#searchJikgubCdHidden").val(result[0].jikgubCd);
							$("#searchJikgubNm").val(result[0].jikgubNm);
						}else{
							let jikgubCdArr = [];
							let jikgubNmArr = [];
							for(let i=0; i<result.length; i++){
								jikgubCdArr.push('\'' + result[i].jikgubCd + '\'');
								jikgubNmArr.push(result[i].jikgubNm)
							}
							$("#searchJikgubCdHidden").val(jikgubCdArr.join(','));
							$("#searchJikgubNm").val(jikgubNmArr.join(','));
						}
					}
				}
			]
		});
		layerModal.show();



		<%--try{--%>
		<%--	if(!isPopup()) {return;}--%>

		<%--	gPRow = "";--%>
		<%--	pGubun = "jikgubBasicPopup";--%>

		<%--	var args    = new Array();--%>
		<%--		args['multiSelect'] = "Y";--%>
		<%--		args['baseDate']    = $("#searchEDate").val();--%>

		<%--	if($("#searchJikgubCdHidden").val() != "") {--%>
		<%--		args['chooseJikgubCds'] = $("#searchJikgubCdHidden").val().replace(/'/g, "");--%>
		<%--	}--%>
		<%--	var rv = openPopup("/Popup.do?cmd=jikgubBasicPopup&authPg=${authPg}", args, "740","520");--%>
		<%--}catch(ex){alert("Open Jikgub Search Popup Event Error : " + ex);}--%>
	}
	
	//  직책 조회 팝입
	function openJikchakSchemePopup(){

		let parameters = {
			multiSelect : 'Y'
			, baseDate : $("#searchEDate").val()
		};
		if($("#searchJikchakCdHidden").val() !== ''){
			parameters.chooseJikchakCds = $("#searchJikchakCdHidden").val().replace(/'/g, "");
		}
		let layerModal = new window.top.document.LayerModal({
			id : 'jikchakLayer'
			, url : '/Popup.do?cmd=viewJikchakBasicLayer&authPg=${authPg}'
			, parameters : parameters
			, width : 860
			, height : 520
			, title : '직책 리스트 조회'
			, trigger :[
				{
					name : 'jikchakTrigger'
					, callback : function(result){
						if(!result.length) return;

						if(result.length === 1){
							$("#searchJikchakCdHidden").val(result[0].jikchakCd);
							$("#searchJikchakNm").val(result[0].jikchakNm);
						}else{
							let jikchakCdArr = [];
							let jikchakNmArr = [];
							for(let i=0; i<result.length; i++){
								jikchakCdArr.push('\'' + result[i].jikchakCd + '\'');
								jikchakNmArr.push(result[i].jikchakNm)
							}
							$("#searchJikchakCdHidden").val(jikchakCdArr.join(','));
							$("#searchJikchakNm").val(jikchakNmArr.join(','));
						}
					}
				}
			]
		});
		layerModal.show();

		<%--try{--%>
		<%--	if(!isPopup()) {return;}--%>
		<%--	--%>
		<%--	gPRow = "";--%>
		<%--	pGubun = "jikchakBasicPopup";--%>
		<%--	--%>
		<%--	var args    = new Array();--%>
		<%--		args['multiSelect'] = "Y";--%>
		<%--		args['baseDate']    = $("#searchEDate").val();--%>
		<%--		--%>
		<%--	if($("#searchJikchakCdHidden").val() != "") {--%>
		<%--		args['chooseJikchakCds'] = $("#searchJikchakCdHidden").val().replace(/'/g, "");--%>
		<%--	}--%>
		<%--	var rv = openPopup("/Popup.do?cmd=jikchakBasicPopup&authPg=${authPg}", args, "740","520");--%>
		<%--}catch(ex){alert("Open Jikchak Search Popup Event Error : " + ex);}--%>
	}
	
	//  직위 조회 팝입
	function openJikweeSchemePopup(){
		let parameters = {
			multiSelect : 'Y'
			, baseDate : $("#searchEDate").val()
		};
		if($("#searchJikweeCdHidden").val() !== ''){
			parameters.chooseJikchakCds = $("#searchJikweeCdHidden").val().replace(/'/g, "");
		}
		let layerModal = new window.top.document.LayerModal({
			id : 'jikweeLayer'
			, url : '/Popup.do?cmd=viewJikweeBasicLayer&authPg=${authPg}'
			, parameters : parameters
			, width : 860
			, height : 520
			, title : '직위 리스트 조회'
			, trigger :[
				{
					name : 'jikweeTrigger'
					, callback : function(result){
						if(!result.length) return;

						if(result.length === 1){
							$("#searchJikweeCdHidden").val(result[0].jikweeCd);
							$("#searchJikweeNm").val(result[0].jikweeNm);
						}else{
							let jikweeCdArr = [];
							let jikweeNmArr = [];
							for(let i=0; i<result.length; i++){
								jikweeCdArr.push('\'' + result[i].jikweeCd + '\'');
								jikweeNmArr.push(result[i].jikweeNm)
							}
							$("#searchJikweeCdHidden").val(jikweeCdArr.join(','));
							$("#searchJikweeNm").val(jikweeNmArr.join(','));
						}
					}
				}
			]
		});
		layerModal.show();


		<%--try{--%>
		<%--	if(!isPopup()) {return;}--%>
		<%--	--%>
		<%--	gPRow = "";--%>
		<%--	pGubun = "jikweeBasicPopup";--%>
		<%--	--%>
		<%--	var args    = new Array();--%>
		<%--		args['multiSelect'] = "Y";--%>
		<%--		args['baseDate']    = $("#searchEDate").val();--%>
		<%--		--%>
		<%--	if($("#searchJikweeCdHidden").val() != "") {--%>
		<%--		args['chooseJikweeCds'] = $("#searchJikweeCdHidden").val().replace(/'/g, "");--%>
		<%--	}--%>
		<%--	var rv = openPopup("/Popup.do?cmd=jikweeBasicPopup&authPg=${authPg}", args, "740","520");--%>
		<%--}catch(ex){alert("Open Jikwee Search Popup Event Error : " + ex);}--%>
	}

	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');
		// if(pGubun == "orgBasicPopup"){
		// 	var orgNms = "";
		// 	var orgCds = "";
		// 	if( rv["LIST"] != null && rv["LIST"] != undefined ) {
		// 		var LIST = eval(rv["LIST"]);
		// 		//console.log('LIST', LIST);
		// 		if( LIST != null && LIST != undefined && LIST.length > 0 ) {
		// 			var item = null;
		// 			for( var i = 0; i < LIST.length; i++) {
		// 				item = LIST[i];
		// 				if(orgNms != "" ) orgNms += ",";
		// 				if(orgCds != "" ) orgCds += ",";
		// 				orgNms += item.orgNm;
		// 				orgCds += "'" + item.orgCd + "'";
		// 			}
		// 		}
		// 	}
		// 	$("#searchOrgNm").val(orgNms);
		// 	$("#searchOrgCdHidden").val(orgCds);
		// }
		
		// if(pGubun == "jikgubBasicPopup"){
		// 	var jikgubNms = "";
		// 	var jikgubCds = "";
		// 	if( rv["LIST"] != null && rv["LIST"] != undefined ) {
		// 		var LIST = eval(rv["LIST"]);
		// 		//console.log('LIST', LIST);
		// 		if( LIST != null && LIST != undefined && LIST.length > 0 ) {
		// 			var item = null;
		// 			for( var i = 0; i < LIST.length; i++) {
		// 				item = LIST[i];
		// 				if(jikgubNms != "" ) jikgubNms += ",";
		// 				if(jikgubCds != "" ) jikgubCds += ",";
		// 				jikgubNms += item.jikgubNm;
		// 				jikgubCds += "'" + item.jikgubCd + "'";
		// 			}
		// 		}
		// 	}
		// 	$("#searchJikgubNm").val(jikgubNms);
		// 	$("#searchJikgubCdHidden").val(jikgubCds);
		// }
		
		// if(pGubun == "jikchakBasicPopup"){
		// 	var jikchakNms = "";
		// 	var jikchakCds = "";
		// 	if( rv["LIST"] != null && rv["LIST"] != undefined ) {
		// 		var LIST = eval(rv["LIST"]);
		// 		//console.log('LIST', LIST);
		// 		if( LIST != null && LIST != undefined && LIST.length > 0 ) {
		// 			var item = null;
		// 			for( var i = 0; i < LIST.length; i++) {
		// 				item = LIST[i];
		// 				if(jikchakNms != "" ) jikchakNms += ",";
		// 				if(jikchakCds != "" ) jikchakCds += ",";
		// 				jikchakNms += item.jikchakNm;
		// 				jikchakCds += "'" + item.jikchakCd + "'";
		// 			}
		// 		}
		// 	}
		// 	$("#searchJikchakNm").val(jikchakNms);
		// 	$("#searchJikchakCdHidden").val(jikchakCds);
		// }
		
		if(pGubun == "jikweeBasicPopup"){
			var jikweeNms = "";
			var jikweeCds = "";
			if( rv["LIST"] != null && rv["LIST"] != undefined ) {
				var LIST = eval(rv["LIST"]);
				//console.log('LIST', LIST);
				if( LIST != null && LIST != undefined && LIST.length > 0 ) {
					var item = null;
					for( var i = 0; i < LIST.length; i++) {
						item = LIST[i];
						if(jikweeNms != "" ) jikweeNms += ",";
						if(jikweeCds != "" ) jikweeCds += ",";
						jikweeNms += item.jikweeNm;
						jikweeCds += "'" + item.jikweeCd + "'";
					}
				}
			}
			$("#searchJikweeNm").val(jikweeNms);
			$("#searchJikweeCdHidden").val(jikweeCds);
		}
	}

</script>
</head>
<body class="hidden">
<div class="wrapper">
<form id="srchFrm" name="srchFrm" >

	<input type="hidden" id="searchOrgCdHidden"     name="searchOrgCdHidden"     value="" />
	<input type="hidden" id="searchElementCdHidden" name="searchElementCdHidden" value="" />
	<input type="hidden" id="searchManageCdHidden"  name="searchManageCdHidden"  value="" />
	<input type="hidden" id="searchStatusCdHidden"  name="searchStatusCdHidden"  value="" />
	<input type="hidden" id="searchJikweeCdHidden"  name="searchJikweeCdHidden"  value="" />
	<input type="hidden" id="searchJikchakCdHidden" name="searchJikchakCdHidden" value="" />
	<input type="hidden" id="searchJikgubCdHidden"  name="searchJikgubCdHidden"  value="" />

	<input type="hidden" id="columnInfo" name="columnInfo" value="" />

		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th>조회기간 </th>
						<td> 
							<input type="text" id="searchSDate" name="searchSDate" class="date2" value="${curSysYyyyMMddHyphen}" />
							~ <input type="text" id="searchEDate" name="searchEDate" class="date2" value="${curSysYyyyMMddHyphen}" />
						</td>
						<%--
						<th>연봉그룹명</th>
						<td> 
							<select id="searchPayGroupCd" name ="searchPayGroupCd" ></select>
						</td>
						 --%>
						<th>직급</th>
						<td> 
							<!-- <select id="searchJikgubCd" name ="searchJikgubCd" multiple=""></select> -->
							<input type="text" id="searchJikgubNm" name="searchJikgubNm" class="text required readonly alignL" value="" readonly style="width:150px" />
							<a href="javascript:openJikgubSchemePopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
							<a onclick="$('#searchJikgubNm,#searchJikgubCdHidden').val('');"  class="button7"><img src="/common/${theme}/images/icon_undo.gif" /></a>
						</td>
						<th>직책 </th>
						<td> 
							<!-- <select id="searchJikchakCd" name ="searchJikchakCd" multiple=""></select> -->
							<input type="text" id="searchJikchakNm" name="searchJikchakNm" class="text required readonly alignL" value="" readonly style="width:150px" />
							<a href="javascript:openJikchakSchemePopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
							<a onclick="$('#searchJikchakNm,#searchJikchakCdHidden').val('');"  class="button7"><img src="/common/${theme}/images/icon_undo.gif" /></a>
						</td>
						<th>직위 </th>
						<td> 
							<!-- <select id="searchJikweeCd" name ="searchJikweeCd" multiple=""></select> -->
							<input type="text" id="searchJikweeNm" name="searchJikweeNm" class="text required readonly alignL" value="" readonly style="width:150px" />
							<a href="javascript:openJikweeSchemePopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
							<a onclick="$('#searchJikweeNm,#searchJikweeCdHidden').val('');"  class="button7"><img src="/common/${theme}/images/icon_undo.gif" /></a>
						</td>
					</tr>
					<tr>
						<th>소속</th>
						<td> 
							<input type="text" id="searchOrgNm" name="searchOrgNm" class="text required readonly alignL" value="" readonly style="width:215px" />
							<a href="javascript:openOrgSchemePopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
							<a onclick="$('#searchOrgNm,#searchOrgCdHidden').val('');"  class="button7"><img src="/common/${theme}/images/icon_undo.gif" /></a>
						</td>
						<th>재직상태 </th>
						<td> 
							<select id="searchStatusCd" name ="searchStatusCd" multiple=""></select>
						</td>
						<th>계약유형 </th>
						<td colspan="2"> 
							<select id="searchManageCd" name ="searchManageCd" multiple=""></select>
						</td>
					</tr>
					<tr>
						<th>연봉항목 </th>
						<td> 
							<select id="searchElementCd" name ="searchElementCd" multiple=""></select>
						</td>
						<th>사번/성명 </th>
						<td> 
							<input id="searchNm" name ="searchNm" type="text" class="text" />
						</td>
						<td colspan="4"> <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a> </td>
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
							<li id="txt" class="txt">연봉내역조회</li>
							<li class="btn">
								<a href="javascript:doAction1('Down2Excel')"	class="basic authR">다운로드</a>
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