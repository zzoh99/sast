<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {

		var initdata = {};
		initdata.Cfg = {FrozenCol:10,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No|No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",		Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"평가코드|평가코드",		Type:"Combo",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"피평가자|사번",			Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"피평가자|성명",			Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"피평가자|소속cd",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"orgCd",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"피평가자|소속",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"피평가자|직위cd",		Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"피평가자|직위",			Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"피평가자|직급cd",		Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"피평가자|직급",			Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"피평가자|직책cd",		Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"jikchakCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"피평가자|직책",			Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"피평가자|직군cd",		Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"workTypeCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"피평가자|직군",			Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"workTypeNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"피평가자|직무cd",		Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"jobCd",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"피평가자|직무",			Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"jobNm",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"피평가자|평가그룹",		Type:"Combo",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appGroupCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"종합평가|COMPETENCE",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appCPoint",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"종합평가|ATTITUDE",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appAPoint",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"종합평가|종합점수",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appSPoint",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"종합평가|평가등급",		Type:"Combo",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appClassCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"종합평가|조정점수",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appFPoint",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"종합평가|순위",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"seq",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"인사소위원회|최종등급",	Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"finalClassCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"인사소위원회|조정사유",	Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"memo",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"인사위원회|확인등급",		Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"confirmClassCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"인사위원회|확인의견",		Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"confirmMemo",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"최종등급\n(환산등급)|최종등급\n(환산등급)",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"lastClassCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"평가결과F/B여부",	Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"fbYn",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"실적확인",				Type:"Image",		Hidden:0,	Width:100, Align:"Center", ColMerge:0,  SaveName:"pfmChk" ,  	KeyField:0,   CalcLogic:"", Format:"",     		PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:50}
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		//평가코드
		var appraisalCd = convCode( ajaxCall("/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdListAppType&searchAppTypeCd=C,",false).codeList, "");
		var confirmClassCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00001"), "");		//평가등급코드
		$("#confirmClassCd").html(confirmClassCd[2]);
		//option 입력
		$("#searchAppraisalCd").html(appraisalCd[2]);
		sheet1.SetColProperty("appraisalCd", {ComboText:appraisalCd[0], ComboCode:appraisalCd[1]} );
		var comboCdList7 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00001"), "전체");
		sheet1.SetColProperty("finalClassCd", 	{ComboText:"|"+comboCdList7[0], ComboCode:"|"+comboCdList7[1]} );
		sheet1.SetColProperty("confirmClassCd", 	{ComboText:"|"+comboCdList7[0], ComboCode:"|"+comboCdList7[1]} );
		//var comboCdList3 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20030"), "전체");
		//$("#searchJikwee").html(comboCdList3[2]);
/*
		//평가그룹
		var appGroupCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppGroupCdList&searchAppraisalCd="+$("#searchAppraisalCd").val(),false).codeList, "전체");
		//option입력
		$("#searchAppGroupCd").html(appGroupCd[2]);
		sheet1.SetColProperty("appGroupCd", 	{ComboText:appGroupCd[0], ComboCode:appGroupCd[1]} );

		//직위
		var comboCdList3 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20030"), "전체");
		$("#searchJikwee").html(comboCdList3[2]);

		//직책
		var comboCdList4 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20020"), "전체");
		$("#searchJikchak").html(comboCdList4[2]);

		//직종
		var comboCdList5 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10050"), "전체");
		$("#searchWorkType").html(comboCdList5[2]);

		//직무
		var comboCdList6 = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getJobCdList",false).codeList, "전체");
		$("#searchJob").html(comboCdList6[2]);

		//평가등급
		var comboCdList7 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00001"), "전체");
		sheet1.SetColProperty("appClassCd", 	{ComboText:"|"+comboCdList7[0], ComboCode:"|"+comboCdList7[1]} );
		sheet1.SetColProperty("finalClassCd", 	{ComboText:"|"+comboCdList7[0], ComboCode:"|"+comboCdList7[1]} );
*/
		$("#searchAppraisalCd").change(function(){
			doAction1("Search");
			doAction2("Search");
		});

		$("#searchOrgNm,#searchName").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search");doAction2("Search"); $(this).focus(); }
		});

	    initdata2 = {};
		initdata2.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata2.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:1,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",			Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",			Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"평가명",		Type:"Combo",	Hidden:1,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"평가조직",		Type:"Combo",	Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"평가차수",		Type:"Combo",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"appSeqCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"평가인원",		Type:"Int",		Hidden:0,	Width:60,	Align:"Right",	ColMerge:0,	SaveName:"totCnt",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:5 },
			{Header:"평가등급",		Type:"Combo",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appClassCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"S등급인원",		Type:"Int",		Hidden:0,	Width:60,	Align:"Right",	ColMerge:0,	SaveName:"appGroupSCnt",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:5 },
			{Header:"A+등급인원",		Type:"Int",		Hidden:0,	Width:60,	Align:"Right",	ColMerge:0,	SaveName:"appGroupACnt",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:5 },
			{Header:"A등급인원",		Type:"Int",		Hidden:0,	Width:60,	Align:"Right",	ColMerge:0,	SaveName:"appGroupBCnt",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:5 },
			{Header:"B등급인원",		Type:"Int",		Hidden:0,	Width:60,	Align:"Right",	ColMerge:0,	SaveName:"appGroupCCnt",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:5 },
			{Header:"C등급인원",		Type:"Int",		Hidden:0,	Width:60,	Align:"Right",	ColMerge:0,	SaveName:"appGroupDCnt",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:5 },
			{Header:"비고",			Type:"Text",	Hidden:1,	Width:300,	Align:"Left",	ColMerge:0,	SaveName:"note",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:33 , MultiLineText:1  }
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(0);
		 sheet2.SetEditEnterBehavior("newline");

		var comboList1 	= convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdListAppType",false).codeList, ""); // 평가명
		var comboList2 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00001"), "");		//평가등급코드
		var comboList3 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00003"), "");		//평가차수
		var comboList4 	= convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getOrgCdList",false).codeList, ""); // 평가명


		sheet2.SetColProperty("appraisalCd", 			{ComboText:comboList1[0], ComboCode:comboList1[1]} );
		sheet2.SetColProperty("appClassCd", 			{ComboText:comboList2[0], ComboCode:comboList2[1]} );
		sheet2.SetColProperty("appSeqCd", 				{ComboText:comboList3[0], ComboCode:comboList3[1]} );
		sheet2.SetColProperty("appOrgCd", 				{ComboText:comboList4[0], ComboCode:comboList4[1]} );

		var orgCd;

		if("${ssnDataRwType}" == "A" || "${ssnGrpCd}" == "10") {
			orgCd = stfConvCode( codeList("${ctx}/AppCommitteeMgr.do?cmd=getAppCommitteeOrgListAdmin",""), "");
		} else {
			orgCd = stfConvCode( codeList("${ctx}/AppCommitteeMgr.do?cmd=getAppCommitteeOrgList",""), "");
		}

		$("#orgCd").html(orgCd[2]);

		$(window).smartresize(sheetResize); sheetInit();
		 doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/AppCommitteeMgr.do?cmd=getAppCommitteeMgrList", $("#srchFrm").serialize() );

		  break;
		case "Save": 		
							IBS_SaveName(document.srchFrm,sheet1);
							sheet1.DoSave( "${ctx}/AppCommitteeMgr.do?cmd=saveAppCommitteeMgr", $("#srchFrm").serialize()); break; 
		case "Insert":		sheet1.SelectCell(sheet1.DataInsert(0), "col2"); break;
		case "Copy":		sheet1.DataCopy(); break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
		break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}
	function doAction2(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet2.DoSearch( "${ctx}/AppCommitteeMgr.do?cmd=getAppCommitteeMgrList2", $("#srchFrm").serialize() ); break;
		}
	}
	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != ""){
				alert(Msg);
			}
			for(var r = sheet1.HeaderRows(); r<sheet1.RowCount()+sheet1.HeaderRows(); r++){
				sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
				sheet1.SetDataLinkMouse("pfmChk",1);
				sheet1.SetCellValue(r,"pfmChk","0");
				sheet1.SetCellValue(r, "sStatus", 'R');
			}
			getAppStatus();
			doAction2("Search");
			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != ""){
				alert(Msg);
			}
			
			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != ""){
				alert(Msg);
			}
			doAction1("Search");
		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction1("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
				sheet1.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value) {
		try{

			var rv = null;
			var args    = new Array();

			args["elementType"] = sheet1.GetCellValue(Row, "elementType");
			args["elementCd"]   = sheet1.GetCellValue(Row, "elementCd");
			args["elementNm"]   = sheet1.GetCellValue(Row, "elementNm");
			args["sdate"]       = sheet1.GetCellValue(Row, "sdate");

			if(Row > 0 && sheet1.ColSaveName(Col) == "detail"){
				var rv = openPopup("/PayAllowanceElementPropertyPopup.do?cmd=payAllowanceElementPropertyPopup", args, "1000","520");
				if(rv!=null){
				}
			}
			
			if(sheet1.ColSaveName(Col) == "pfmChk"){
				var year = "${curSysYear}";
				var args				=	new	Array();
				args["searchSabun"]			=	sheet1.GetCellValue(Row, "sabun");
				args["searchAppraisalCd"]   = 	year.substring(2, 4)+"B01";
				var rv	= openPopup("/CompApp1stApr.do?cmd=viewPfmcCoachingPrizeChk", args, "740","800");
			}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}

//  Type이 POPUP인 셀에서 팝업버튼을 눌렀을때 발생하는 이벤트
    function sheet1_OnPopupClick(Row, Col){
        try{

          var colName = sheet1.ColSaveName(Col);
          var args    = new Array();

          args["name"]   = sheet1.GetCellValue(Row, "name");
          args["sabun"]  = sheet1.GetCellValue(Row, "sabun");

          var rv = null;

          if(colName == "name") {

              var rv = openPopup("/Popup.do?cmd=employeePopup", args, "740","520");
              if(rv!=null){
                  sheet1.SetCellValue(Row, "name",   rv["name"] );
                  sheet1.SetCellValue(Row, "sabun",  rv["sabun"] );

                  sheet1.SetCellValue(Row, "resNo",  rv["resNo"].replace(/\//g,'') );
              }
          }

        }catch(ex){alert("OnPopupClick Event Error : " + ex);}
    }

 // 소속 팝입
	function orgSearchPopup() {
		var w		= 680;
		var h		= 520;
		var url		= "/Popup.do?cmd=orgBasicPopup";
		var args	= new Array();

		var result = openPopup(url+"&authPg=R", args, w, h);

		if (result) {
			var orgCd	= result["orgCd"];
			var orgNm	= result["orgNm"];

			$("#searchOrgCd").val(orgCd);
			$("#searchOrgNm").val(orgNm);
		}
	}


//  사원 팝입
	function employeePopup(){
	    try{

	     var args    = new Array();
	     var rv = openPopup("/Popup.do?cmd=employeePopup", args, "740","520");
	        if(rv!=null){


	         $("#searchName").val(rv["name"]);
	         $("#searchSabun").val(rv["sabun"]);

	        }
	    }catch(ex){alert("Open Popup Event Error : " + ex);}
	}


	// ------------------ 중단 checkbox 처리 -------------------//
	var getAppStatus = function(){
		var rtn = ajaxCall("${ctx}/AppCommitteeMgr.do?cmd=getAppCommitteeMgrMap&searchAppraisalCd=" + $("#searchAppraisalCd").val() ,$("#srchFrm").serialize(),false);

		var closeYn = rtn.map.closeYn;
		var conYn	= rtn.map.conYn;

		$("#searchCloseYn").val(closeYn);
		$("#searchConYn").val(conYn);

		if(closeYn != null || closeYn != ""){
			if(closeYn =="Y"){
				$("#apprclose").attr("checked", true);
				for(var r = sheet1.HeaderRows(); r<sheet1.RowCount()+sheet1.HeaderRows(); r++){
					sheet1.SetRowEditable(r,0);
				}
			}else{
				$("#apprclose").attr("checked", false);
			}
		}

		if(conYn != null || conYn != ""){
			if(conYn == "Y"){
				$("#apprsum").attr("checked", true);
			}else{
				$("#apprsum").attr("checked", false);
			}
		}
	};


</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
	<input type="hidden" id="searchCloseYn" name="searchCloseYn" />
	<input type="hidden" id="searchConYn" name="searchConYn" />
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<span>평가명</span>
							<select name="searchAppraisalCd" id="searchAppraisalCd" onChange="javascript:doAction1('Search');">
							</select>
						</td>
						<td><span>소속 </span>
						<select id="orgCd" name="orgCd"></select>
						</td>
						<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a> </td>
					</tr>
				</table>
			</div>
		</div>
	</form>

<c:choose>
	<c:when test="${authPg != null && authPg eq 'A'}">
		<c:set var="displayYn" value="show"/>
	</c:when>
	<c:otherwise>
		<c:set var="displayYn" value="hide"/>
	</c:otherwise>
</c:choose>

	<div class="${displayYn}">
		<table class="table">
				<colgroup>
					<col width="15%" />
					<col width="35%" />
					<col width="15%" />
					<col width="" />
				</colgroup>

		</table>
	</div>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
		<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">평가기준</li>
					</ul>
		</div>
	</div>
	<div class="outer">
	<script type="text/javascript"> createIBSheet("sheet2", "100%", "58px"); </script>
	</div>
				<div class="outer">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">인사위원회</li>
							<li class="btn">
								<!-- <a href="javascript:doAction1('Insert')" class="basic authA">입력</a> -->
								<!-- <a href="javascript:doAction1('Copy')" 	class="basic authA">복사</a> -->
								<a href="javascript:doAction1('Save')" 	class="basic authA">저장</a>
								<a href="javascript:doAction1('Down2Excel')" 	class="basic authR">다운로드</a>
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