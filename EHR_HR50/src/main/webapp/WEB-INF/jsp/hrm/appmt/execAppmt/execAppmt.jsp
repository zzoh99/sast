<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>발령연계처리관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%
	String thisVersion = Long.toString(System.currentTimeMillis());
%>

<script type="text/javascript">
	var ssnEnterCd = "${ssnEnterCd}";
	var ctx = "${ctx}";
</script>
<script type="text/javascript" src="/common/js/execAppmt.js?ver=<%=thisVersion%>"></script>
<script type="text/javascript">
	//발령관련 변수
	var POST_ITEMS = {};
	var POST_ITEMS_CD = {};
	var POST_ITEMS_COL_CD = {};
	var sheet1_col_len = 0;

	var gPRow = "";
	var pGubun = "";

	$(function() {

		$("#searchOrdTypeCd").change(function(){
			$(this).bind("selected").val();

			var searchOrdTypeCd = $(this).val();

			var searchOrdDetailCd = "";
			//var searchOrdReasonCd = "";

			if(searchOrdTypeCd != null){
				searchOrdDetailCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdDetailCdManagerList&useYn=Y&ordTypeCd="+searchOrdTypeCd ,false).codeList, "전체");
				//searchOrdReasonCd  = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&note1="+searchOrdTypeCd, "H40110"), "전체");
			}
			$("#searchOrdDetailCd").html(searchOrdDetailCd[2]);
			//$("#searchOrdReasonCd").html(searchOrdReasonCd[2]);
		});

		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata.Cols = [
			{Header:"No|No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"20",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"상태|상태",				Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"\n삭제|\n삭제",						Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },

			{Header:"\n발령확정\n(취소)|\n발령확정\n(취소)",	Type:"CheckBox",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"ordYn",			KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1 , TrueValue:"Y", FalseValue:"N"},
			{Header:"발령확정\n여부|발령확정\n여부",	    Type:"Combo",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"ordYnTmp",		KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"발령|발령",	    			Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"ordTypeCd",		KeyField:1,	Format:"",			CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"발령구분|발령구분",	    	Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"ordType",		KeyField:0,	Format:"",			CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"발령상세|발령상세",			Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"ordDetailCd",		KeyField:1,	Format:"",			CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"발령세부사유|발령세부사유",	Type:"Combo",		Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"ordReasonCd",		KeyField:0,	Format:"",			CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"발령일|발령일",	    		Type:"Date",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"ordYmd",			KeyField:1,	Format:"Ymd",		CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"발령순번|발령순번",			Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"applySeq",		KeyField:1,	Format:"Number",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:35 },

			{Header:"대상자|사진",				Type:"Image",		Hidden:1,  	MinWidth:55, Align:"Center", ColMerge:0,		SaveName:"photo",			UpdateEdit:0, ImgMinWidth:50, ImgHeight:60 },
			{Header:"대상자|사번",	    		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"대상자|성명",	    		Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:1,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 },

			{Header:"발령번호|발령번호",	    Type:"Text",		Hidden:1,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"processNo",		KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"발령번호|발령제목",	    Type:"Text",		Hidden:1,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"processTitle",		KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },

			{Header:"처리자사번|처리자사번",	Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applSabun",		KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"처리자|처리자",	    	Type:"Text",		Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"applName",		KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 },
			{Header:"발령이력조회여부(Y/N)",   	Type:"CheckBox",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"visualYn",		KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 , TrueValue:"Y", FalseValue:"N"},
			{Header:"확정에러|확정에러",	    Type:"Text",		Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"ordError",		KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:2000 },
			
			{Header:"<sht:txt mid='seqV5' mdef='SEQ'/>",           Type:"Text",      Hidden:1,  Width:10,   Align:"Center",  ColMerge:0,   SaveName:"seq",              KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='punishYmd' mdef='징계일자'/>",       Type:"Date",      Hidden:1,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"punishYmd",         KeyField:1, Format:"Ymd",   PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='punishCd' mdef='징계명'/>",         Type:"Combo",     Hidden:1,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"punishCd",          KeyField:1, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='sdate_V5555' mdef='징계\n시작일'/>",   Type:"Date",      Hidden:1,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"sdate",             KeyField:0, Format:"Ymd",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='edate_V5556' mdef='징계\n종료일'/>",   Type:"Date",      Hidden:1,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"edate",             KeyField:0, Format:"Ymd",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='punishTerm' mdef='징계기간(개월)'/>", Type:"Int",      Hidden:1,  Width:120,  Align:"Right",   ColMerge:0,   SaveName:"punishTerm",        KeyField:0, Format:"NullInteger",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='inOutCd' mdef='사내/외\n구분'/>",  Type:"Combo",     Hidden:1,  Width:60,  Align:"Center",  ColMerge:0,   SaveName:"inOutCd",           KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='suggestOrgCd' mdef='발의부서코드'/>",   Type:"Text",      Hidden:1,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"suggestOrgCd",      KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='suggestOrgNm' mdef='발의부서'/>",       Type:"Text",     Hidden:1,  Width:120,  Align:"Left",    ColMerge:0,   SaveName:"suggestOrgNm",      KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='punishSuggestYmd' mdef='징계발의일'/>",     Type:"Date",      Hidden:1,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"punishSuggestYmd",  KeyField:0, Format:"Ymd",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='punishOffice' mdef='발의기관'/>",       Type:"Text",      Hidden:1,  Width:120,  Align:"Left",    ColMerge:0,   SaveName:"punishOffice",      KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='openYn' mdef='공개여부'/>",       Type:"Combo",     Hidden:1,  Width:50,  Align:"Center",    ColMerge:0,   SaveName:"displayYn",          KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, DefaultValue:"Y"  },
			{Header:"<sht:txt mid='punishMemo' mdef='징계사유'/>", 	   Type:"Text",     Hidden:1,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"punishMemo",    KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000 },
			{Header:"<sht:txt mid='displayMemo' mdef='징계세부내용'/>",   Type:"Text",      Hidden:1,  Width:150,  Align:"Left",    ColMerge:0,   SaveName:"displayMemo",              KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
		
 			{Header:"가족명|가족명",					Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"famNm",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
 			{Header:"가족주민번호|가족주민번호",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"famres",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"등록번호",							Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"applSeq",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
 			{Header:"비고2",					Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ordReasonTxt",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000 },
 			
 			{Header:"[발령내역수정] 수정건수|[발령내역수정] 수정건수",	Type:"Text", Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"isModified",		KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		];
		// 발령항목 조회
		var POST_ITEMS = ajaxCall("${ctx}/AppmtItemMapMgr.do?cmd=getAppmtItemMapMgrList","searchUseYn=Y",false).DATA;
		// 발령항목 SHEET에 PUSH
		var postItemsNames = "";

		for(var ind in POST_ITEMS){
			var postItem = POST_ITEMS[ind];
			postItemsNames += ","+postItem.postItem;
			//sheet header init
			if(postItem.cType == "D")initdata.Cols.push({Header:postItem.postItemNm,	Type:"Date",	Hidden:1,	Width:40,	Align:"Center",	ColMerge:0,	SaveName: convCamel(postItem.postItem+"_VALUE"),			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:postItem.limitLength});
			else initdata.Cols.push({Header:postItem.postItemNm,	Type:"Text",	Hidden:1,	Width:40,	Align:"Center",	ColMerge:0,	SaveName: convCamel(postItem.postItem+"_VALUE"),			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:postItem.limitLength});
			//발령항목 컴포넌트타입이 popup(P) 인 경우는 Nm 추가
			if(postItem.cType == "P" || postItem.cType == "C"){
				postItemsNames += ","+postItem.postItem+"_NM";
				initdata.Cols.push({Header:postItem.postItemNm,	Type:"Text",	Hidden:1,	Width:40,	Align:"Center",	ColMerge:0,	SaveName: convCamel(postItem.postItem+"_NM_VALUE"),			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:"200"});
			}
			POST_ITEMS_CD[convCamel(postItem.postItem+"_value")] = POST_ITEMS[ind];// item cd 로 item cd 설정값을 쉽게 찾기 위해 만듦
			POST_ITEMS_COL_CD[postItem.columnCd] = postItem.postItem;// column 명으로 item cd를 쉽게 찾기 위해 만듦
		}
		sheet1_col_len = initdata.Cols.length;

		$("<input></input>",{id:"s_SAVENAME2",name:"s_SAVENAME2",type:"hidden"}).appendTo($("#sendForm"));
		$("#sendForm #s_SAVENAME2").val(postItemsNames);
		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(true);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		//sheet1.SetDataLinkMouse("ibsImage1", 1);
		//sheet1.SetDataLinkMouse("ibsImage2", 1);
// 		sheet1.SetDataLinkMouse("processNo", 1);

		//sheet1.SetImageList(0,"/common/images/icon/icon_info.png");
		//sheet1.SetImageList(1,"/common/images/icon/icon_search.png");
		
		var OrdTypeCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdTypeCdList",false).codeList, "");	//발령종류
		var OrdDetailCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdDetailCdList",false).codeList, "");	//발령종류

		var userCdOrdTypeCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdTypeCdManagerList&useYn=Y",false).codeList, "전체");	//발령종류
		var userCdOrdDetailCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdDetailCdManagerList&useYn=Y",false).codeList, "전체");
		//var userCdOrdReasonCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&useYn=Y","H40110"), " ");

		
		
		
		sheet1.SetColProperty("ordYnTmp", 		{ComboText:"미확정|확정", ComboCode:"N|Y"} );
		sheet1.SetColProperty("ordTypeCd", 	{ComboText:"|"+OrdTypeCdList[0], ComboCode:"|"+OrdTypeCdList[1]} );
		sheet1.SetColProperty("ordDetailCd", 	{ComboText:"|"+OrdDetailCdList[0], ComboCode:"|"+OrdDetailCdList[1]} );
		//sheet1.SetColProperty("ordReasonCd", 	{ComboText:"|"+userCdOrdReasonCd[0], ComboCode:"|"+userCdOrdReasonCd[1]} );

		//$("#ordReasonCd").attr("hidden",true);
		
		
		var punishCd    = 	  convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getComCodeListUseYn&searchGrcodeCd=H20270",false).codeList, "선택");
		
		//var punishCd    = 	  codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20270", " ");
		
		
		var inOutCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20271"), " ");
		$("#inOutCd").html(inOutCd[2]);
		sheet1.SetColProperty("inOutCd", 			    {ComboText:"|"+inOutCd[0], ComboCode:"|"+inOutCd[1]} );	            // 사내외구분
		
		
		$("#punishCd").html(punishCd[2]);
		sheet1.SetColProperty("punishCd", 			    {ComboText:"|"+punishCd[0], ComboCode:"|"+punishCd[1]} );	            // 징계명
		sheet1.SetColProperty("displayYn", 		{ComboText:"|Y|N", ComboCode:"|Y|N"} ); //  공개여부
		
		

		$("#searchOrdTypeCd").html(userCdOrdTypeCd[2]);//검색조건의 발령
		$("#ordTypeCd").html(userCdOrdTypeCd[2].replace("전체"," "));//발령입력의 발령
		
		$("#ordDetailCd").html(userCdOrdDetailCd[2].replace("전체"," "));//발령입력의 발령
		
		$("#sabun").on("change", function(e) {
			if($(this).val() != "" && $(this).val() != null) {
				// 가족 이름
				var searchFamRes = convCode( ajaxCall("${ctx}/GetDataList.do?cmd=getExecAppmtFamNmList","searchApplSabun="+$(this).val(),false).DATA, "");
				$("#searchFamRes").html(searchFamRes[2]);
				$("#famResTxt").val($("#searchFamRes option:selected").val().substring(0,6)+"-"+$("#searchFamRes option:selected").val().substring(6,13));
			}
		}).change();

		$("#searchFamRes").change(function(){
			$(this).bind("selected").val();
		});

		$("#searchFamRes").on("change", function(e) {
			if($(this).val() != "" && $(this).val() != null) {
				$("#famResTxt").val($(this).val().substring(0,6)+"-"+$(this).val().substring(6,13));
				var strName = $("#searchFamRes option:checked").text().split("(");
				$("#famNm").val(strName[0]);
			}
		}).change();

		$("#searchPhotoYn").click(function() {
			doAction1("Search");
		});

		/*
		$("#ordReasonCd").change(function(){
			$(this).bind("selected").val();

			var searchOrdReasonCd = $(this).val();
			var rtn = ajaxCall("${ctx}/GetDataMap.do?cmd=getOrdResonCdText", "groupCd=H40110&searchOrdReasonCd=" + searchOrdReasonCd, false).DATA;
			var rtnTxt = rtn.reasonTxt;			
			$("#searchReasonTxt").val(rtnTxt);
			$("#item99Value").val(rtnTxt);
			sheet1.SetCellValue(sheet1.GetSelectRow(),"ordReasonTxt",rtnTxt);
			sheet1.SetCellValue(sheet1.GetSelectRow(),"item99Value",rtnTxt);
			
			
		});
		*/

		//$("#searchPhotoYn").attr('checked', 'checked');


		$(window).smartresize(sheetResize); sheetInit();

		//발령항목매핑관리 화면에서 등록한 항목을 화면에 뿌려줌
		// execAppmt.js include 필요
		setPostItemTable(POST_ITEMS, sheet1, $("#dataForm"), "${ctx}");
		//발령항목 화면에 만든 후 [발령확정(취소)</br>에러 메시지]뒤에 붙인다.
		$("#dataForm ._postTable").append("<tr><th>발령확정(취소)</br>에러 메시지</th><td colspan=3><input type='text' id='ordError' class='_postItem' readOnly style='width:90%;height:40px;' /></td></tr>")


		//doAction1("Search");
		//pageSize
		$("#pageSize").bind("keyup",function(event){
			makeNumber(this, 'A');
			Num_Comma(this);

			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
		$("#pageSize").val(1000);
		Num_Comma(document.getElementById("pageSize"));

		$("#page").bind("change", function(e) {
			doAction1("Search");
		});

	});


	$(function() {
        $("#searchSabun").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

		$("#searchOrdYmdFrom").datepicker2({startdate:"searchOrdYmdTo"});
		$("#searchOrdYmdTo").datepicker2({enddate:"searchOrdYmdFrom"});

		$("#popupProcessNo").click(function(){
			pGubun = "processNoMgr";
			showProcessPop();
			// openPopup("/Popup.do?cmd=viewAppmtProcessNoMgrPopup&authPg=R", "", "1000","600");
		});

		/* var appAuth = ajaxCall("${ctx}/ExecAppmt.do?cmd=getExecAppmtAuthInfo","",false);
		if(appAuth != null && appAuth.DATA != null) {
			if(appAuth.DATA.authInfo == "A") {
				//$("#btnAppr").removeClass("hide");
				//$("#btnCancel").removeClass("hide");
			}
		} else {
			alert(appAuth.Message);
		} */
		$("#ordTypeCd").next().find("input").focus(function () {
			$(this).val($.trim($(this).val()));
		});

		//$("#punishDelYmd, #paySYmd, #payEYmd, #problemSymd, #problemEymd, #promotionLimitYmd").datepicker2();
		
		$("#punishYmd, #sdate, #edate, #punishSuggestYmd").datepicker2();

		$("#dataTable").hide();
		$("#dataGdaTable").hide();
		$("#dataMdHstDiv").hide();
	});


	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			/*
			if($("#searchProcessNo").val() == "" ){
				alert("발령번호를 먼저 선택후 수행하세요.");
				return;
			}
			*/
			if($("#searchOrdYmdFrom").val() == "") {
				alert("발령일을 입력하여 주십시오.");
				$("#searchOrdYmdFrom").focus();
				return;
			}
			if($("#searchOrdYmdTo").val() == "") {
				alert("발령일을 입력하여 주십시오.");
				$("#searchOrdYmdTo").focus();
				return;
			}

			$("#searchPageSize").val(($("#pageSize").val()).replace(/\,/g, ""));
			$("#searchPage").val($("#page").val());

			sheet1.DoSearch( "${ctx}/ExecAppmt.do?cmd=getExecAppmtList",$("#sendForm").serialize() );
			break;
		case "Save":
			var rtnFlag = false;

			if(!dupChk(sheet1,"ordYmd|sabun|applySeq", true, true)){break;} 

			if(sheet1.RowCount("I|U") > 0) {
				var arrRows = sheet1.FindStatusRow("I|U");

				$(arrRows.split(";")).each(function(index,value) {

					//post item 필수입력체크
					if(sheet1.GetCellValue(value,"ordTypeCd") !="" && !isValidPostItemMandatory(sheet1, value))rtnFlag = true;
					if(sheet1.GetCellValue(value,"sStatus") =="I"){
						//중복체크 ([발령일, 사번, 발령]3값의 조합은 중복되게 입력할 수 없음.)
						var tbl = $("#dataForm table");
						var params = { "ordYmd":$("#ordYmd",tbl).val()
							         , "ordTypeCd":$("#ordTypeCd",tbl).val()
								     , "ordDetailCd":$("#ordDetailCd",tbl).val()
								     , "sabun":$("#sabun",tbl).val()
								     };
						var dupChk = ajaxCall("${ctx}/ExecAppmt.do?cmd=getPostDupChk",params,false).DATA;
						if(dupChk && dupChk.processNo && dupChk.processNo!=""){
							alert("No."+sheet1.GetCellValue(value, "sNo") +" 번 행과 동일한 [사원, 발령, 발령일]이 발령번호["+dupChk.processNo+"["+dupChk.processTitle+"]]에 등록되어있습니다.");
							rtnFlag = true;
						}
					}
					/* if(sheet1.GetCellValue(value,"inputYn") != "Y" ) {
						alert("세부내역이 입력되지 않았습니다.\n세부내역을 클릭하여 확인하여 주십시오.");
						rtnFlag = true;
					} */
					
					//비고항목 수정안하고 그냥 저장시 
					/*
					if(sheet1.GetCellValue(value,"sStatus") =="I"  && 
							sheet1.GetCellValue(value,"ordReasonTxt") == sheet1.GetCellValue(value,"item99Value")){
						alert("비고란에 발령사유 포맷에 맞춰 작성해 주시기 바랍니다.");
						rtnFlag = true;
					}
					*/
				});
			}

			if(rtnFlag) {
				return;
			}
			setValue();

			IBS_SaveName(document.sendForm,sheet1);
			sheet1.DoSave( "${ctx}/ExecAppmt.do?cmd=saveExecAppmt",$("#sendForm").serialize());
			break;
		case "Insert":
			/*
			if($("#searchProcessNo").val() == ""){
				alert("발령번호를 먼저 선택후 수행하세요.");
				return;
			}
			*/
			clearAndDisable($("#dataForm"));
			andEnable($("#dataForm ._postTr"));
			var row = sheet1.DataInsert(0);
            sheet1.SetCellValue(row, "processNo",$("#searchProcessNo").val());
            sheet1.SetCellValue(row, "processTitle",$("#searchProcessTitle").val());
            sheet1.SetCellValue(row, "visualYn","Y");
            sheet1.SetCellEditable(row,"ordYn",false);
            $("#processNo").val($("#searchProcessNo").val()).attr("disabled",true);
            $("#processTitle").val($("#searchProcessTitle").val()).attr("disabled",true);
            $("#visualYn").attr("checked",true);
            $("#ordDetailCd").children().remove();
            $("#searchFamRes").html("");
			break;
		case "Copy":

			if(sheet1.GetCellValue (sheet1.GetSelectRow(), "ordType") == '10' || 
					(sheet1.GetCellValue (sheet1.GetSelectRow(), "ordType") == '' 
				  && sheet1.GetCellValue (sheet1.GetSelectRow(), "ordTypeCd") == 'A') ) {
				alert("채용 발령은 복사할 수 없습니다.\n[채용기본사항] 등록 후 발령연계처리로 발령처리하십시오.");
			} else {			
				var row = sheet1.DataCopy();
				sheet1.SetCellValue(row,"ordYn","N");
				sheet1.SetCellValue(row,"ordYnTmp","N");
				sheet1.SetCellValue(row,"applySeq","");
				sheet1.SetCellValue(row,"item18Value","N");//조직장(권한)등록 필드 제외
				sheet1_OnSelectCell(null, null, row, 1, false);
				$("#dataForm #ordYmd").change();//발령순번을 조회하기 위해 change event를 발생시킴
			}

			break;
		case "ProcAppr":
			/*
			if($("#searchProcessNo").val() == "" ){
				alert("발령번호를 먼저 선택후 수행하세요.");
				return;
			}
			*/
	        var params = $("#sendForm").serialize();
	        $.extend(params, {"searchOrdYn":"N"});

			var total = ajaxCall("${ctx}/ExecAppmt.do?cmd=getExecAppmtCnt",params,false).DATA;
			if(confirm(total+"건을 일괄확정처리하시겠습니까?")){
		    	var data = ajaxCall("${ctx}/ExecAppmt.do?cmd=prcExecAppmtSave",params,false);

		    	if(data.errorCount == "0") {
		    		alert("처리되었습니다.");
		    	} else {
		    		alert("처리중 에러건이 존재합니다.");
		    		viewAppmtSaveErrorPopup();//발령 에러발생시 에러 조회 popup 띄움
			    	//alert(data.Result.Message);
		    	}
		    	doAction1("Search");
			}
			break;

		case "Clear":
			sheet1.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			var d = new Date();
			var fName = "excel_" + d.getTime() + ".xlsx";
			sheet1.Down2Excel($.extend(param, { FileName:fName, SheetDesign:1, Merge:1 }));
			break;
		case "ProcessClear":
			$("#searchProcessNo").val("");
			$("#searchProcessTitle").val("");
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			sheetResize();

			//우측table 값 clear
			clearAndDisable($("#dataForm"));
			//첫번째 row select
			if(sheet1.GetSelectRow()>1) sheet1_OnSelectCell(null, null, 2, 1, false);

			//검색조건에 해당하는 총 COUNT 조회
			var total = ajaxCall("${ctx}/ExecAppmt.do?cmd=getExecAppmtCnt",$("#sendForm").serialize(),false).DATA;
			$("#page").children().remove();//total
			if(total==0) $("#page").append("<option value='1'>1 페이지");
			else{
				for(var i=0 ; i<(total/($("#searchPageSize").val())) ; i++){
					$("#page").append("<option value='"+(i+1)+"'>"+(i+1)+" 페이지");
				}
			}
			$("#page").val($("#searchPage").val());

			if($("#searchPhotoYn").is(":checked") == true){
				sheet1.SetDataRowHeight(60);
				sheet1.SetColHidden("photo", 0);
			}else{
				sheet1.SetAutoRowHeight(0);
				sheet1.SetDataRowHeight(24);
				sheet1.SetColHidden("photo", 1);
			}

			//확정된 건은 삭제 불가하도록 처리
			for(var i=2 ; i<sheet1.RowCount()+2 ; i++){
				sheet1.SetCellEditable(i,"sDelete",sheet1.GetCellValue(i,"ordYn") != "Y");
				//에러난 건은 text를 빨간색으로
				if(sheet1.GetCellValue(i,"ordError")!=""){
					for(var j=0 ; j<sheet1.LastCol(); j++){
					sheet1.SetCellFontColor(i,j, "red");
					}
				}

			}
			/*
			var sel = sheet1.GetSelectRow();
			if(sheet1.GetCellValue(sel, "ordYnTmp") == "N" ){ 
				andEnable($("#dataForm"));
				andDisable($("#dataForm ._postTr"));
				andEnable($("#dataTable"));
				andEnable($("#dataGdaTable"));
				}
			*/
			tempSize();

		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				if(Msg.indexOf("|")>-1){
					alert(Msg.substring(Msg.indexOf("|")+1));
					viewAppmtSaveErrorPopup();//발령 에러발생시 에러 조회 popup 띄움
				}else alert(Msg);
			}

			if(Code > 0) {
				doAction1("Search");
			}
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		//alert("셀클릭 발생");
		try {
			//clearAndDisable($("#dataForm"));
			if(sheet1.ColSaveName(Col) == "sDelete") {
		        if(sheet1.GetCellValue(Row, "ordYnTmp") == "Y") {
		            alert("확정된 발령건은 삭제할 수 없습니다.");
		            return;
		        }
			}
			if(sheet1.ColSaveName(Col) == "ordYn" ) {
				var chkrow = [];
				for(var i=sheet1.HeaderRows() ; i<sheet1.RowCount()+sheet1.HeaderRows() ; i++){
					if(i==Row)continue;
					if(sheet1.GetCellValue(Row,"sabun") == sheet1.GetCellValue(i,"sabun") && sheet1.GetCellValue(Row,"ordYmd") == sheet1.GetCellValue(i,"ordYmd")&& sheet1.GetCellValue(Row,"applySeq") == sheet1.GetCellValue(i,"applySeq")){

						/* if(Value == "Y" && sheet1.GetCellValue(i,"sStatus") == "I"){
							alert(sheet1.GetCellValue(i, "sNo") +"번째 행의 발령건은 같은사원, 같은발령일로 저장되지 않은 건입니다. 저장 후 같이 확정처리 하세요.");
							sheet1.SetCellValue(Row,"ordYn","N");
							chkrow = [];
							break;

						} */
						chkrow.push(i);
					}
				}
				for(var i in chkrow){
					sheet1.SetCellValue(chkrow[i],"ordYn",Value);
				}
			}
			/*
			if((sheet1.GetCellValue(Row,"sStatus") == "I") ){ 
				
				andEnable($("#dataForm"));
				andEnable($("#dataTable"));
				andEnable($("#dataGdaTable"));
				
			}else if(sheet1.GetCellValue(Row, "ordYnTmp") == "N" ){
				andEnable($("#dataForm"));
				andDisable($("#dataForm ._postTr"));
				andEnable($("#dataTable"));
				andEnable($("#dataGdaTable"));
			}else{
				andDisable($("#dataForm"));
				andDisable($("#dataTable"));
				andDisable($("#dataGdaTable"));
			}
			*/
			/*
			if(sheet1.GetCellValue(OldRow, "ordYnTmp") == "N" ){
				andEnable($("#dataForm"));
				andDisable($("#dataForm ._postTr"));
				andEnable($("#dataTable"));
				andEnable($("#dataGdaTable"));
			}
			*/
			
		} catch (ex) {
			alert("OnClick Event Error9 : " + ex);
		}
	}

	// 셀이 선택시 발생
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol,isDelete){
		try {
			if(sheet1.GetCellValue(NewRow,"sStatus") == "I"){ 
					andEnable($("#dataForm ._postTr"));
			}else{
				andDisable($("#dataForm ._postTr"));
			}
			gPRow = NewRow;
			$("#dataForm #searchKeyword").val(sheet1.GetCellValue(NewRow,"name"));
			$("#dataForm :input").each(function(){
				if($(this).hasClass("_postItem") || $(this).parent().parent().hasClass("_postTr")){
					var val = sheet1.GetCellValue(NewRow,$(this).attr("id")+"");
					var text = sheet1.GetCellText(NewRow,$(this).attr("id")+"");
					if(val!=-1){
						//console.log("date2:"+$(this).hasClass("date2"));
						if($(this).hasClass("date2")) {
							//console.log("id:"+$(this).attr("id")+", val:"+sheet1.GetCellText(NewRow,$(this).attr("id")+""));
							$(this).val(text);//날짜형식 값 set
						} else {
							var id = $(this).attr("id");
							// text format 이 없고, 읽기전용 값이 아닌 값은 set해줌
							if(id.indexOf("_ronly")==-1) $(this).val(val);

							if($(this).is("select") && $("#"+id+"_ronly").length==1){
								if(sheet1.GetCellValue(NewRow,"ordYnTmp")=="Y"){
									$("#"+id+"_ronly").val(val);
									$(this).hide();
									$("._ronly",$(this).parent()).show();
								}else{
									$(this).show();
									$("._ronly",$(this).parent()).hide();
								}
							}
						}

						/* //editable combo 값 set
						if(!$(this).is(":visible") && $(this).next("span").hasClass("custom-combobox")){
							$(this).next("span").find(".custom-combobox-input").val(text);
						} */

						//checkbox 값 set
						if($(this).is(":checkbox")){
							$(this).attr("checked",val == "Y");
						}

					}
				}
			});
			$("#dataForm span").each(function(){
				if($(this).hasClass("_postItem")){
					if($(this).attr("id"))$(this).text(sheet1.GetCellValue(NewRow,$(this).attr("id")+""));
				}
			});

			$("#dataForm #ordTypeCd").change();
			if(sheet1.GetCellValue(NewRow,"sStatus")=="I")andEnable($("#dataForm ._postTr"));
			else{
				//$("#dataForm #ordDetailCd, #visualYn").attr("disabled",false);
				$("#visualYn").attr("disabled",false);
			}

			if(sheet1.GetCellValue(NewRow,"ordYnTmp") == "Y") andDisable($("#dataForm"));
/*
			$("#ordReasonCd").bind("option:selected").val(sheet1.GetCellValue(NewRow,"ordReasonCd"));
			$("#ordReasonCd").attr("disabled",false);
			
			if(sheet1.GetCellValue(NewRow,"item99Value") ==""){
				$("#ordReasonCd").change();
			}
*/
			// 징계발령일때
			/*
			if(sheet1.GetCellValue(NewRow,"ordTypeCd") == "N"){

				$("#punishOffice").val(sheet1.GetCellValue(NewRow,"punishOffice"));
				$("#punishOfficeNm").val(sheet1.GetCellValue(NewRow,"punishOfficeNm"));
				$("#punishReasonCd").val(sheet1.GetCellValue(NewRow,"punishReasonCd"));
				$("#punishReasonNm").val(sheet1.GetCellValue(NewRow,"punishReasonNm"));
				$("#punishMemo").val(sheet1.GetCellValue(NewRow,"punishMemo"));
				$("#punishDelYmd").val(formatDate(sheet1.GetCellValue(NewRow,"punishDelYmd"),"-"));
				$("#promotionLimitYmd").val(formatDate(sheet1.GetCellValue(NewRow,"promotionLimitYmd"),"-"));
				$("#paySYmd").val(formatDate(sheet1.GetCellValue(NewRow,"paySYmd"),"-"));
				$("#payEYmd").val(formatDate(sheet1.GetCellValue(NewRow,"payEYmd"),"-"));
				$("#punishGb").val(sheet1.GetCellValue(NewRow,"punishGb"));
				$("#punishGbNm").val(sheet1.GetCellValue(NewRow,"punishGbNm"));
				$("#problemSymd").val(formatDate(sheet1.GetCellValue(NewRow,"problemSymd"),"-"));
				$("#problemEymd").val(formatDate(sheet1.GetCellValue(NewRow,"problemEymd"),"-"));
				$("#inOutCd").val(sheet1.GetCellValue(NewRow,"inOutCd"));
				$("#detailMemo").val(sheet1.GetCellValue(NewRow,"detailMemo"));
			}
			*/

			
			// 징계발령일때
			var punishVal = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&searchStdCd=PUNISH_ORD_DETAIL_CD", "queryId=getSystemStdValue",false).codeList, "");
			var holVal = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&searchStdCd=REST_CHILD_ORD_DETAIL_CD", "queryId=getSystemStdValue",false).codeList, "");
			//alert("징계내역 조회 될까1?");
			//alert("징계값 : " + punishVal[0]);
			//if(sheet1.GetCellValue(NewRow,"ordTypeCd") == "N"){
			if(sheet1.GetCellValue(NewRow,"ordTypeCd") == punishVal[0]){
				//alert("징계내역 조회 될까2?");
				$("#dataTable").show();		
				$("#seq").val(sheet1.GetCellValue(NewRow,"seq"));
				$("#applySeq").val(sheet1.GetCellValue(NewRow,"applySeq"));
				$("#punishYmd").val(formatDate(sheet1.GetCellValue(NewRow,"punishYmd"),"-"));
				$("#punishCd").val(sheet1.GetCellValue(NewRow,"punishCd"));
				$("#sdate").val(formatDate(sheet1.GetCellValue(NewRow,"sdate"),"-"));
				$("#edate").val(formatDate(sheet1.GetCellValue(NewRow,"edate"),"-"));
				$("#punishTerm").val(sheet1.GetCellValue(NewRow,"punishTerm"));
				$("#inOutCd").val(sheet1.GetCellValue(NewRow,"inOutCd"));
				$("#suggestOrgCd").val(sheet1.GetCellValue(NewRow,"suggestOrgCd"));
				$("#suggestOrgNm").val(sheet1.GetCellValue(NewRow,"suggestOrgNm"));
				$("#punishSuggestYmd").val(formatDate(sheet1.GetCellValue(NewRow,"punishSuggestYmd"),"-"));
				$("#punishOffice").val(sheet1.GetCellValue(NewRow,"punishOffice"));
				$("#displayYn").val(sheet1.GetCellValue(NewRow,"displayYn"));
				$("#punishMemo").val(sheet1.GetCellValue(NewRow,"punishMemo"));
				$("#displayMemo").val(sheet1.GetCellValue(NewRow,"displayMemo"));
				
			}
			

			
			//if(sheet1.GetCellValue(NewRow,"ordDetailCd") == "C01"){
			else if(sheet1.GetCellValue(NewRow,"ordDetailCd") == holVal[0]){	
				var searchSabun = sheet1.GetCellValue(NewRow,"sabun");
				$("#dataGdaTable").show();
				var famres = convCode( ajaxCall("${ctx}/GetDataList.do?cmd=getExecAppmtFamNmList","searchApplSabun="+searchSabun,false).DATA, "");
		 		$("#searchFamRes").html(famres[2]);

		 		if(sheet1.GetCellValue(NewRow,"famres") != ""){
					$("#famNm").val(sheet1.GetCellValue(NewRow,"famNm"));
					$("#searchFamRes").bind("option:selected").val(sheet1.GetCellValue(NewRow,"famres"));
					$("#famResTxt").val(sheet1.GetCellValue(NewRow,"famres").substring(0,6) +"-"+ sheet1.GetCellValue(NewRow,"famres").substring(6,13));
		 		}

				 tempSize(holVal[0]);
			}else{
				$("#dataGdaTable").hide();
			}

			// [발령내역수정]의 변경 이력 표시
			// [발령내역수정]에서 담당자 전결로 THRM191이 곧바로 수정되면, THRM223의 데이터를 함께 갱신해줌
			// - [발령처리]는 발령항목정의에 세팅되지 않은 데이터를 THRM223에서 참조하기 때문!
			// - 변경사유 기록은 THRM222에 이력으로 관리함
			$("#modifySabun").html("");
			$("#modifyCmt").html("");
			$("#dataMdHstTable>tbody").html("");
			$("#dataMdHstDiv").hide();
			if(sheet1.GetCellValue(NewRow,"isModified") > 0){
				$("#dataMdHstTable>tbody").html("<tr><th colspan='4'><tit:txt mid='' mdef='[발령내역수정] 이력'/></th></tr>");
				
				var param = "sabun=" + sheet1.GetCellValue(NewRow,"sabun")
				         + "&ordYmd=" + sheet1.GetCellValue(NewRow,"ordYmd")
				         + "&applySeq=" + sheet1.GetCellValue(NewRow,"applySeq")
		                 + "&ordTypeCd=" + sheet1.GetCellValue(NewRow,"ordTypeCd")
				         + "&ordDetailCd=" + sheet1.GetCellValue(NewRow,"ordDetailCd");
				
				$("#dataMdHstDiv").show();
				var modifyHst = ajaxCall("${ctx}/GetDataList.do?cmd=getExecAppmtMdHstList",param,false) ;
		 		if(modifyHst != null && modifyHst != ""){
		 			if(modifyHst.Message != "") {
		 				alert("OnSelectCell Event Error 8 : " + modifyHst.Message);
		 			} else {
			 			for(var i=0; i < modifyHst.DATA.length; i++) {
				 			if(modifyHst.DATA[i].modifyMode != null && modifyHst.DATA[i].modifyMode != ""){
					 			var dataList0 = modifyHst.DATA[i].modifyMode.split("|");
					 			var dataList1 = modifyHst.DATA[i].modifyCmt.split("|");
					 			var dataList2 = modifyHst.DATA[i].modifySabun.split("|");
					 			var dataList3 = modifyHst.DATA[i].modifyDate.split("|");
					 			for(var j=0; j < dataList0.length; j++) {
									var strTbody = "<tr><th>" + dataList0[j] + "</th>" 
									                 + "<td>" + dataList1[j] + "</td>" 
									                 + "<td>" + dataList2[j] + "</td>" 
									                 + "<td>" + dataList3[j] + "</td></tr>" ;
									$("#dataMdHstTable>tbody").append(strTbody);
								}
				 			}
			 			}
		 			}
		 		}
			}

			


		} catch (ex) {
			alert("OnSelectCell Event Error 8 : " + ex);
		}
	}

	// 값 변경시 발생.
	function sheet1_OnChange(Row, Col, Value){
		try{


		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}

	// 체크 되기 직전 발생.
	function sheet1_OnBeforeCheck(Row, Col) {
		try{
            //sheet1.SetAllowCheck(true);

            /* if(sheet1.ColSaveName(Col) == "ordYn") {
		    	//발령취소인 경우는 발령확정을 체크할 수 없다.
		        if((sheet1.GetCellValue(Row, "ordYnTmp") == "4")) {
		            alert("처리상태가 [발령취소]인 상태에서는 발령확정을 체크할 수 없습니다.");
		            sheet1.SetAllowCheck(false);
		            return;
		        }
		    }
		    */
		    /* if(sheet1.ColSaveName(Col) == "sDelete") {
		        if(sheet1.GetCellValue(Row, "ordYnTmp") == "Y") {
		            alert("확정된 발령건은 삭제할 수 없습니다.");
		            sheet1.SetAllowCheck(false);
		            return;
		        }
		    } */
		}catch(ex){
			alert("OnBeforeCheck Event Error : " + ex);
		}
	}

	function viewAppmtSaveErrorPopup(){

		let appmtSaveErrorLayer = new window.top.document.LayerModal({
			id : 'appmtSaveErrorLayer'
			, url : '/Popup.do?cmd=viewAppmtSaveErrorLayer&authPg=R'
			, parameters: $("#sendForm").serialize()
			, width : 940
			, height : 620
			, title : "발령 에러메시지"
		});
		appmtSaveErrorLayer.show();

		//openPopup("/Popup.do?cmd=viewAppmtSaveErrorPopup&authPg=R", $("#sendForm").serialize(), "940","620");
	}


	function viewModifyHstPopup(){
		var Row = sheet1.GetSelectRow();		
		var args = new Array();

		args["sabun"] = sheet1.GetCellValue(Row,"sabun") ;
		args["ordYmd"] = sheet1.GetCellValue(Row,"ordYmd") ;
		args["applySeq"] = sheet1.GetCellValue(Row,"applySeq") ;
		args["ordTypeCd"] = sheet1.GetCellValue(Row,"ordTypeCd") ;
		args["ordDetailCd"] = sheet1.GetCellValue(Row,"ordDetailCd") ;
		
		openPopup("/Popup.do?cmd=viewAppmtModifyHstPopup&authPg=R", args, "1100","620");
	}


	// 날짜 포맷을 적용한다..
	function formatDate(strDate, saper) {
		if(strDate == "" || strDate == null) {
			return "";
		}

		if(strDate.length == 10) {
			return strDate.substring(0,4)+saper+strDate.substring(5,7)+saper+strDate.substring(8,10);
		} else if(strDate.length == 8) {
			return strDate.substring(0,4)+saper+strDate.substring(4,6)+saper+strDate.substring(6,8);
		}
	}

    function setValue() {
		//alert("저장 준비!!")    	
        var row = "";
        if(sheet1.RowCount() == 0){
            row = sheet1.DataInsert(0);
            gPRow = row;
        }

      //발령이 징계일때
      
        //if(sheet1.GetCellValue(gPRow,"ordTypeCd") == "N"){
        var punishVal = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&searchStdCd=PUNISH_ORD_DETAIL_CD", "queryId=getSystemStdValue",false).codeList, "");	
        //alert("징계코드 값 ? : " + punishVal[0])
        //alert("발령형태 : " + sheet1.GetCellValue(gPRow,"ordTypeCd")); 
        if(sheet1.GetCellValue(gPRow,"ordTypeCd") == punishVal[0]){	
        	//alert("저장 준비1!!")    	
        	
			var params = {"sabun":sheet1.GetCellValue(gPRow,"sabun")};
			var seqChk = ajaxCall("${ctx}/ExecAppmt.do?cmd=getPunishSeq",params,false).DATA;
			//alert($("#seq").val());
			//alert(seqChk.seq);
			if($("#seq").val() == ''){
				sheet1.SetCellValue(gPRow,"seq",seqChk.seq);
			}else{
				sheet1.SetCellValue(gPRow,"seq",$("#seq").val());
			}
        	
	        sheet1.SetCellValue(gPRow,"punishYmd",$("#punishYmd").val());
	        sheet1.SetCellValue(gPRow,"punishCd",$("#punishCd").val());
	        sheet1.SetCellValue(gPRow,"sdate",$("#sdate").val());
	        sheet1.SetCellValue(gPRow,"edate",$("#edate").val());
	        sheet1.SetCellValue(gPRow,"punishTerm",$("#punishTerm").val());
	        sheet1.SetCellValue(gPRow,"inOutCd",$("#inOutCd").val());
	        sheet1.SetCellValue(gPRow,"suggestOrgCd",$("#suggestOrgCd").val());
	        sheet1.SetCellValue(gPRow,"suggestOrgNm",$("#suggestOrgNm").val());
	        sheet1.SetCellValue(gPRow,"punishSuggestYmd",$("#punishSuggestYmd").val());
	        sheet1.SetCellValue(gPRow,"punishOffice",$("#punishOffice").val());
	        sheet1.SetCellValue(gPRow,"displayYn",$("#displayYn").val());
	        sheet1.SetCellValue(gPRow,"punishMemo",$("#punishMemo").val());
	        sheet1.SetCellValue(gPRow,"displayMemo",$("#displayMemo").val());
        }
        
        //alert("저장 준비2!!")    	
      
        //발령이 휴직이고 발령상세가 육아휴직일때
        
        //if(sheet1.GetCellValue(gPRow,"ordDetailCd") == "C01"){
        var holVal = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&searchStdCd=REST_CHILD_ORD_DETAIL_CD", "queryId=getSystemStdValue",false).codeList, "");
        if(sheet1.GetCellValue(gPRow,"ordDetailCd") == holVal[0]){	
        
			sheet1.SetCellValue(gPRow,"famNm",$("#famNm").val());
			sheet1.SetCellValue(gPRow,"famres",$("#searchFamRes").val());
		}
      
    }

    $(document).ready(function(){
    	tempSize();
    });

    function tempSize(type){
    	var h = $('.bodywrap').height()-$('.sheet_search').height()-$('.sheet_main .sheet_title').height();

		if(type == 'C01') {
			h = h - $('#dataGdaTable').height() - 10;
		}

    	$('#area').height(h);
    }


	//  소속 팝업
	
   /*
	function orgSearchPopup(){
        try{
    		if(!isPopup()) {return;}
    		//gPRow = "";
    		pGubun = "orgBasicPopup2";

			var args    = new Array();
			var rv = openPopup("/Popup.do?cmd=orgBasicPopup", args, "740","520");
	*/
			/*
			if(rv!=null){

			       $("#suggestOrgCd").val(rv["orgCd"]);
		            $("#suggestOrgNm").val(rv["orgNm"]);


			}
			*/
   //     }catch(ex){alert("Open Popup Event Error : " + ex);}
   // }
    /*
	
    function getReturnValue(returnValue) {
    	var rv = $.parseJSON('{' + returnValue+ '}');
		if(pGubun == "orgBasicPopup2"){
            $("#suggestOrgCd").val(rv["orgCd"]);
            $("#suggestOrgNm").val(rv["orgNm"]);
        }
    }
	*/
	// 발령번호 선택 팝업
	function showProcessPop() {
		if(!isPopup()) {return;}

		//openPopup("/Popup.do?cmd=viewAppmtProcessNoMgrPopup&authPg=R", "", "1000","600");
		let layerModal = new window.top.document.LayerModal({
			id : 'appmtConfirmLayer'
			, url : '/Popup.do?cmd=viewAppmtProcessNoMgrLayer&authPg=R'
			, parameters : ""
			, width : 1000
			, height : 600
			, title : '발령번호 검색'
			, trigger :[
				{
					name : 'appmtConfirmTrigger'
					, callback : function(result){
						getReturnValue(result);
					}
				}
			]
		});
		layerModal.show();
	}


	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = returnValue;

		if(pGubun == "processNoMgr") {
			$("#searchProcessNo").val(rv.processNo);
			$("#searchProcessTitle").val(rv.processTitle);
			// doAction1("Search");
		}
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">

	<form id="sendForm" name="sendForm" >
		<input type="hidden" id="searchPageSize" name="searchPageSize"/>
		<input type="hidden" id="searchPage" name="searchPage"/>
		<input type="hidden" id="famNm" name="famNm" value=""/>
		<div class="sheet_search outer">
			<div>
			<table>
			<tr>
				<th>발령일</th>
				<td>
					<input id="searchOrdYmdFrom" name="searchOrdYmdFrom" type="text" size="10" class="date2 required" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),-30)%>"/> ~
					<input id="searchOrdYmdTo" name="searchOrdYmdTo" type="text" size="10" class="date2 required" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),+30)%>"/>
				</td>
				<th>사번/성명</th>
				<td>
					<input id="searchSabun" name="searchSabun" type="text" class="text" />
				</td>
				<th>발령번호</th>
				<td>
					<input type="text" id="searchProcessNo" name="searchProcessNo" class="text" readonly />
					<a class='button6' id="popupProcessNo"><img src='/common/images/common/btn_search2.gif'/></a>
					<input type="text" id="searchProcessTitle" name="searchProcessTitle" class="text w150" readonly />
					<a onclick="javascript:doAction1('ProcessClear');" class="button7"><img src="/common/images/icon/icon_undo.png"></a>
				</td>				
			</tr>
			<tr>
				<th>발령</th>
				<td>
					<select id="searchOrdTypeCd" name="searchOrdTypeCd"><option value=''>전체</option></select>
					<select id="searchOrdDetailCd" name="searchOrdDetailCd"><option value=''>전체</option></select>
					<!-- <select id="searchOrdReasonCd" name="searchOrdReasonCd"><option value=''>전체</option></select>-->
				</td>
				<th>확정여부</th>
				<td>
					<select id="searchOrdYn" name="searchOrdYn">
						<option value="" selected>전체</option>
						<option value="Y">확정</option>
					    <option value="N" selected="selected">미확정</option>
					</select>
				</td>
				<th><tit:txt mid='112988' mdef='사진포함여부 '/></th>
				<td>
					 <input id="searchPhotoYn" name="searchPhotoYn" type="checkbox"  class="checkbox" />
				</td>
				<td>
					<a href="javascript:doAction1('Search');" class="btn dark">조회</a>
				</td>
			</tr>
			</table>
			</div>
		</div>
	</form>


	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<colgroup>
			<col width="" />
			<col width="620px;" />
		</colgroup>
		<tr>
			<td class="sheet_left" id="temp">
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li class="txt">*발령취소 : 마지막발령만 처리가능</li>
						<li class="btn">
							<select id="page" name="page">
								<option value="1">1 페이지
							</select>
							<input type="text" id="pageSize" name="pageSize" class="text w50 center" value=""/>

						</li>
					</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet1", "40%", "100%"); </script>

			</td>
			<td class="sheet_right" style="height:100%;">

				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li style="height: 15px;">&nbsp;</li>
						<li class="btn">
							<a href="javascript:doAction1('Insert');" class="btn outline_gray authA">입력</a>
							<a href="javascript:doAction1('Copy');" class="btn outline_gray authA">복사</a>
							<a href="javascript:doAction1('Save');" class="btn filled authA">저장</a>
							<!-- <a href="javascript:doAction1('Down2Excel');" class="btn outline_gray authR">다운로드</a> -->
							<!-- <a href="javascript:doAction1('ProcAppr');" class="btn outline_gray authA">일괄발령확정</a> -->
							<a href="javascript:viewAppmtSaveErrorPopup();" class="btn outline authR">발령확정에러확인</a>
						</li>
					</ul>
					</div>
				</div>
				<div id="area">
				<div style="height:inherit; overflow-y: auto;">
					<form id="dataForm" name="dataForm" >
					<input type="hidden" id="searchReasonTxt" name="searchReasonTxt"/>
					<table border="0" cellpadding="0" cellspacing="0" class="default _postTable" id="contentTb">
						<colgroup>
							<col width="95" />
							<col width="" />
							<col width="100" />
							<col width="" />
							<!-- <col width="8%" />
							<col width="12%" />
							<col width="11%" />
							<col width="" /> -->
						</colgroup>
						<tr class="_postTr">
							<th>발령번호</th>
							<td colspan=3>
							<input type="text" id="processNo" name="processNo" class="text" disabled/>
							<input type="text" id="processTitle" name="processTitle" class="text" style="width:300px;"  disabled/>
							<span class="hide"><font for="visualYn">이력조회여부</font><input type="checkbox" id="visualYn" name="visualYn" value="Y"/></span>
							</td>
						</tr>
						<tr class="_postTr">

							<th>성명</th>
							<td>
								<input type="hidden"   id="sabun"  		name="sabun" />
								<input type="hidden"   id="name"  		name="name" />
								<input type="text"   id="searchKeyword"  		name="searchKeyword" class="text required" style="ime-mode:active;"/>
								<a class='button7'><img class='postItemPopup _clsEmp' src='/common/images/icon/icon_undo.png'/></a>
								<input type="hidden" id="searchEmpType"  		name="searchEmpType" value="I"/> <!-- Include에서  사용 -->
								<input type="hidden" id="searchStatusCd" 		name="searchStatusCd" value="A" /><!-- in ret -->
								<input type="hidden" id="searchUserId"   		name="searchUserId" value="${ssnSabun}" />
								<input type="hidden" id="searchEmpPayType"   	name="searchEmpPayType" value="" />
								<input type="hidden" id="searchCurrJikgubYmd"   name="searchCurrJikgubYmd" value="" />
								<input type="hidden" id="searchWorkYyCnt"   	name="searchWorkYyCnt" value="" />
								<input type="hidden" id="searchWorkMmCnt"   	name="searchWorkMmCnt" value="" />
								<input type="hidden" id="searchSabunRef" 		name="searchSabunRef" value="" />

							</td>
							<th>발령일</th>
							<td>
								<input type="text" id="ordYmd" name="ordYmd" class="date2 text postItemDate required"/>
							</td>
						</tr>
						<tr class="_postTr">
							<th>발령</th>
							<td colspan=3>
								<select id="ordTypeCd" name="ordTypeCd" style="width:150px;" class="required"></select>
								<select id="ordDetailCd" name="ordDetailCd" style="width:150px;" class="required"></select>
								<!-- <select id="ordReasonCd" name="ordReasonCd" style="width:150px;" class=""></select> -->
							</td>
						</tr>
					</table>
					</form>
				</div>
				<span style="line-height:50%">
					<br>
				</span>
				<table border="0" cellpadding="0" cellspacing="0" class="default" id="dataTable">
					<colgroup>
							<col width="95" />
							<col width="" />
							<col width="100" />
							<col width="" />

					</colgroup>
					<tr>
						<th><tit:txt mid='' mdef='징계일자'/></th>
						<td>
							<input type="hidden" id="seq" name="seq"/>
							<input type="hidden" id="applySeq" name="applySeq"/>
							<input id="punishYmd" name="punishYmd" type="text" size="10" class="${dateCss}"/>
						</td>
						<th><tit:txt mid='' mdef='징계명'/></th>
						<td>
							<select id="punishCd" name="punishCd"> </select>
						</td>
					</tr>
					<tr>
						<th><tit:txt mid='' mdef='징계시작일'/></th>
						<td>
							<input id="sdate" name="sdate" type="text" size="10" class="${dateCss}"/>
						</td>
						<th><tit:txt mid='' mdef='징계종료일'/></th>
						<td>
							<input id="edate" name="edate" type="text" size="10" class="${dateCss}" >
						</td>
					</tr>
					<tr>
						<th><tit:txt mid='' mdef='징계기간(개월)'/></th>
						<td>
							<input id="punishTerm" name="punishTerm" type="text" class="${textCss} w60"  />
						</td>
						<th><tit:txt mid='' mdef='사내/외구분'/></th>
						<td>
							<select id="inOutCd" name="inOutCd"> </select>
						</td>
					</tr>
					<!-- 
					<tr>
						<th><tit:txt mid='' mdef='발의부서'/></th>
						<td>
							<input type="hidden" id="suggestOrgCd" name="suggestOrgCd"/>
							<input id="suggestOrgNm" name ="suggestOrgNm" type="text" class="text readonly" readOnly />
							<a onclick="javascript:orgSearchPopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
							<a onclick="$('#suggestOrgCd,#suggestOrgNm').val('');" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
						</td>
						<th><tit:txt mid='' mdef='징계발의일'/></th>
						<td>
							<input id="punishSuggestYmd" name="punishSuggestYmd" type="text" size="10" class="${dateCss}"/>
						</td>
					</tr>
					 -->
					<tr>
						<th><tit:txt mid='' mdef='발의기관'/></th>
						<td>
							<input id="punishOffice" name="punishOffice" type="text" class="${textCss} w60"  />
						</td>
						<th><tit:txt mid='' mdef='공개여부'/></th>
						<td>
							<select id="displayYn" name="displayYn"> 
									<option value=''></option>
									<option value='Y'>Y</option>
									<option value='N'>N</option>
							</select>
						</td>
					</tr>
					<tr>
						<th><tit:txt mid='' mdef='징계사유'/></th>
						<td>
							<input id="punishMemo" name="punishMemo" type="text" class="${textCss} w60"  />
						</td>
						<th><tit:txt mid='' mdef='징계세부내용'/></th>
						<td>
							<input id="displayMemo" name="displayMemo" type="text" class="${textCss} w60"  />
						</td>
					</tr>
				</table>
				<!-- 
				<table border="0" cellpadding="0" cellspacing="0" class="default" id="dataTable">
					<colgroup>
						<col width="70" />
						<col width="140" />
						<col width="75" />
						<col width="" />

					</colgroup>
					<tr>
						<th><tit:txt mid='' mdef=' 기관'/></th>
						<td>
							<input type="hidden" id="punishOffice" name="punishOffice"/>
							<input id="punishOfficeNm" name ="punishOfficeNm" type="text" class="text readonly"  />
							<a onclick="javascript:officeSearchPopup('H20272');" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
						</td>
						<th><tit:txt mid='' mdef='사유'/></th>
						<td>
							<input type="hidden" id="punishReasonCd" name="punishReasonCd"/>
							<input id="punishReasonNm" name ="punishReasonNm" type="text" class="text readonly"  />
							<a onclick="javascript:officeSearchPopup('H20273');" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
							<input id="punishMemo" name="punishMemo" type="text" class="${textCss} w100" ${readonly} />
						</td>
					</tr>
					<tr>
						<th><tit:txt mid='' mdef='징계종료일'/></th>
						<td>
							<input id="punishDelYmd" name="punishDelYmd" type="text" size="10" class="${dateCss}"/>
						</td>
						<th><tit:txt mid='' mdef='승진</br>제재종료일'/></th>
						<td>
							<input id="promotionLimitYmd" name="promotionLimitYmd" type="text" size="10" class="${dateCss}" >
						</td>
					</tr>
					<tr>
						<th><tit:txt mid='' mdef='감봉기간'/></th>
						<td colspan='3'>
							<input id="paySYmd" name="paySYmd" type="text" size="10" class="${dateCss} " />&nbsp;&nbsp;~&nbsp;&nbsp;<input id="payEYmd" name="payEYmd" type="text" size="10" class="${dateCss}" />
						</td>
					</tr>
					<tr>
						<th><tit:txt mid='' mdef='협회제재명'/></th>
						<td>
							<input type="hidden" id="punishGb" name="punishGb"/>
							<input id="punishGbNm" name ="punishGbNm" type="text" class="text readonly" readOnly />
							<a onclick="javascript:officeSearchPopup('H20274');" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
						</td>
						<th><tit:txt mid='' mdef='협회징계기간'/></th>
						<td>
							<input id="problemSymd" name="problemSymd" type="text" size="10" class="${dateCss}"/>~<input id="problemEymd" name="problemEymd" type="text" size="10" class="${dateCss}" />
						</td>
					</tr>
					<tr>
						<th><tit:txt mid='' mdef='행위구분'/></th>
						<td>
							<select id="inOutCd" name="inOutCd"> </select>
						</td>
						<th><tit:txt mid='' mdef='세부내역'/></th>
						<td>
							<input id="detailMemo" name="detailMemo" type="text" class="${textCss} w60"  />
						</td>
					</tr>
				</table>
				-->
				<table border="0" cellpadding="0" cellspacing="0" class="default" id="dataGdaTable">
					<colgroup>
						<col width="95" />
						<col width="" />
					</colgroup>
					<tr>
						<th align="center"><tit:txt mid='' mdef='육아휴직대상자녀'/></th>
						<td>
							<select id="searchFamRes" name="searchFamRes" class="${textCss} ${readonly} ${required}" ${disabled}>
							</select>&nbsp;&nbsp;&nbsp;
							<input id="famResTxt" name="famResTxt" type="text" class="${textCss} w50p ${required}" readonly/>
						</td>
					</tr>
				</table>
				
				<div id="dataMdHstDiv">
					<div class="inner">
						<div class="sheet_title">
						<ul>
							<li class="btn">
								<a href="javascript:viewModifyHstPopup();" class="basic authR">상세</a>
							</li>
							<li style="height: 15px;">&nbsp;</li>
						</ul>
						</div>
					</div>
					<table border="0" cellpadding="0" cellspacing="0" class="default" id="dataMdHstTable">
						<colgroup>							
								<col width="50" align="center" />
								<col width="" />
								<col width="110" />
								<col width="145" align="center" />
						</colgroup>
						<tbody></tbody>
					</table>
				</div>
				
			</div>
			</td>
		</tr>
	</table>
</div>
</body>
</html>