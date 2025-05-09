<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var gradeInfo = ajaxCall("/CompAppSelfReg.do?cmd=getPapGradeInfoList","searchAppTypeCd=B,",false);

	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"평가",				Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"pop",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"사번",				Type:"Text",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"성명",				Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"소속",	    		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"직위",				Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"직책",				Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"본인평가상태",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"selfStatusNm",KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"평가\n진행상태",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"statusNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"평가소속",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appOrgNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"본인평가\n점수",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appPoint",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"본인평가\n등급",		Type:"Combo",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appClassCdSelf",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"평가\n점수",			Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"u1AppPoint",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"평가\n등급",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appClassCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"입사일",				Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"empYmd",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"APPRAISAL_CD",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"APP_ORG_CD",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"SELF_STATUS_CD",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"selfStatusCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"STATUS_CD",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"statusCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"APPRAISAL_YY",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appraisalYy",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"ORG_CD",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"orgCd",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"APP_SABUN",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appSabun",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msAll};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata2.Cols = [
   			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"역량종류",		Type:"Combo",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"comGubunCd",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"역량코드",		Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"competencyCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"역량항목",		Type:"Text",	Hidden:0,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"competencyNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"역량정의",		Type:"Text",	Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"competencyMemo",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"가중치\n(%)",	Type:"AutoSum",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"appBasisPoint",	KeyField:0,	Format:"Float",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"본인\n평가",		Type:"Combo",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"appClassCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"1차평가",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appClassCd1",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:5 },
			{Header:"평가점수",		Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"appPoint1",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"평가코드",		Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"appraisalCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"사번",			Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"SUNBUN",		Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"sunbun",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"자기평가확정여부",Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"appraisalYn",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"1차평가확정여부", Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"appraisalYn1",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"평가상태", 		Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"statusNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"1차 평가의견",	Type:"Text",	Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"appAppMemo",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100  , MultiLineText:1, ToolTip:1},
			{Header:"2차 평가의견",	Type:"Text",	Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"appAppMemo2",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100  , MultiLineText:1, ToolTip:1}
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);


		 sheet2.SetDataRowMerge(1);
		 sheet2.SetEditEnterBehavior("newline");

		//평가명
		var comboCodeList1  = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAppraisalCdListAppType&searchAppTypeCd=B,",false).codeList, "");
		$("#searchAppraisalCd").html(comboCodeList1[2]);

		//역량종류
		var comboCodeList2 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00007"), "");
		sheet2.SetColProperty("comGubunCd", 			{ComboText:comboCodeList2[0], ComboCode:comboCodeList2[1]} );

		//평가등급코드
		var comboCodeList3 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00001"), "");
		sheet2.SetColProperty("appClassCd", 			{ComboText:comboCodeList3[0], ComboCode:comboCodeList3[1]} );

		sheet1.SetColProperty("appClassCdSelf", 			{ComboText:comboCodeList3[0], ComboCode:comboCodeList3[1]} );

		var papAdmin = ajaxCall("/MboOrgTargetReg.do?cmd=getMboOrgTargetRegPapAdminMap","&searchSabun="+$("#searchAppSabun").val(),false); //admin 여부
     	if(papAdmin != null && papAdmin.map != null) {
     		if(papAdmin.map.papAdminYn == 'N'){
     			$(".button6").hide();
     			$(".button7").hide();
     		}
     	}

     	//평가기간 체크 하여 버튼 보임 안보임 처리
        var data2 = ajaxCall("/MboOrgTargetReg.do?cmd=getTargetButtonVislYnMap","searchAppraisalCd="
        		+$("#searchAppraisalCd").val()+"&searchappStepCd=5",false);
        if(data2 != null && data2.map != null) {
        	if(data2.map.vislYn == "N"){
     			$(".group2").hide();
     		}
        }

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/CompApp1stApr.do?cmd=getCompApp1stAprList", $("#srchFrm").serialize() ); break;
		case "Save1":
							if(chkConfirm()){
								IBS_SaveName(document.srchFrm,sheet1);
								sheet1.DoSave( "${ctx}/CompApp1stApr.do?cmd=saveCompApp1stApr1", $("#srchFrm").serialize());
							}
							break;
		case "Save2":
							if(chkEval()){
								IBS_SaveName(document.srchFrm,sheet1);
								sheet1.DoSave( "${ctx}/CompApp1stApr.do?cmd=saveCompApp1stApr3", $("#srchFrm").serialize());
							}
							break;
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
	//Example Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet2.DoSearch( "${ctx}/CompApp1stApr.do?cmd=getCompApp1stAprList2", $("#srchFrm").serialize() ); break;
		case "Save":
			  	if(chkBeforeSave()){
			  		IBS_SaveName(document.srchFrm,sheet2);
					sheet2.DoSave( "${ctx}/CompApp1stApr.do?cmd=saveCompApp1stApr2", $("#srchFrm").serialize());
			  	}
			  	 break;
		case "Insert":		sheet2.SelectCell(sheet1.DataInsert(0), "col2"); break;
		case "Copy":		sheet2.DataCopy(); break;
		case "Clear":		sheet2.RemoveAll(); break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet2.Down2Excel(param);
			break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != ""){
				alert(Msg);
			}
			if(sheet1.RowCount() == 0){
				$("#searchAppSabun").val("");
				doAction2("Search");
			}

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

			var coboCodeList3 = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getTargetIndexKpiCdList&searchAppSabun="+$("#searchSabun").val()+"&searchAppraisalCd="+$("#searchAppraisalCd").val(),false).codeList, "");
		     sheet2.SetColProperty("targetIndexKpi", 			{ComboText:coboCodeList3[0], ComboCode:coboCodeList3[1]} );

		     var tmpSttsCd = sheet1.GetCellValue(sheet1.GetSelectRow(),"statusCd");
		     if(tmpSttsCd != "21"){
		     	sheet2.SetColEditable("chkMemo1",0);
		     }else{
		    	sheet2.SetColEditable("chkMemo1",1);
		     }

		     var row = sheet1.GetSelectRow();
		     if(sheet1.GetCellValue(row,"statusCd") == 5 ){
		    	 sheet2.SetColEditable("appClassCd1",0);
		    	 sheet2.SetColEditable("appAppMemo",0);

		     }else{
		    	 sheet2.SetColEditable("appClassCd1",1);
		    	 sheet2.SetColEditable("appAppMemo",1);
		     }

		     calTotalPoint1();
		     calTotalPoint2();
		     //합계 행 다듬기
			 var lr = sheet1.LastRow();
			 sheet2.SetSumValue("sNo","합계");
			 sheet2.SetMergeCell(lr, 0, 1,3);

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



	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
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
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}


  //사원 팝입
    function employeePopup(){
        try{

         var args    = new Array();
         var rv = openPopup("/Popup.do?cmd=employeePopup", args, "740","520");
            if(rv!=null){


	            $("#searchName").val(rv["name"]);
	            $("#searchAppSabun").val(rv["sabun"]);
	            $("#searchOrgNm").val(rv["orgNm"]);
	            $("#searchJikweeNm").val(rv["jikweeNm"]);
	            $("#searchJikchakNm").val(rv["jikchakNm"]);

	         	doAction1("Search");
            }
        }catch(ex){alert("Open Popup Event Error : " + ex);}
    }

 	// 셀 변경시 발생
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		try {

			if(sheet1.GetSelectRow() > 0) {
				if(OldRow != NewRow) {
					$("#iAppraisalNm").text($("#searchAppraisalCd option:selected").text());
					$("#iAppName").text($("#searchName").val());
					$("#iStatus").text(sheet1.GetCellValue(NewRow,"statusNm"));
					$("#iName").text(sheet1.GetCellValue(NewRow,"name"));
					$("#iOrgnm").text(sheet1.GetCellValue(NewRow,"orgNm"));
					$("#iJikwee").text(sheet1.GetCellValue(NewRow,"jikweeNm"));
					$("#iJikchak").text(sheet1.GetCellValue(NewRow,"jikchakNm"));
					$("#searchSabun").val(sheet1.GetCellValue(NewRow,"sabun"));

					$("#iAppPoint").text(sheet1.GetCellValue(NewRow,"appPoint"));
					$("#iAppClassCdSelf").text(sheet1.GetCellText(NewRow,"appClassCdSelf"));
					$("#iAppClassCd").text(sheet1.GetCellValue(NewRow,"appClassCd"));
					$("#iU1AppPoint").text(sheet1.GetCellValue(NewRow,"u1AppPoint"));
				}
				doAction2("Search");
			}
		} catch (ex) {
			alert("OnSelectCell Event Error " + ex);
		}
	}

	//승인
	function chkConfirm(){

		var chkValue;
		for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){
			sheet1.SetCellValue(i,"sStatus","U");
		}

		for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){
			var v_statusCd = sheet1.GetCellValue(i,"statusCd");
			if(v_statusCd == 1){
				 alert("미평가 피평가자가 존재합니다.\n모든 피평가자를 평가 후 평가확정 하십시요.");
                 return false;
			}

			if(v_statusCd == 5){
				 alert("이미 평가완료 처리 하셨습니다.");
                return false;
			}
		}

		for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){
			var v_u1AppPoint = sheet1.GetCellValue(i,"u1AppPoint");
			if(v_u1AppPoint == ""){
				 alert("평가 처리 되지 않았습니다.\n 평가 처리 후 평가확정 하십시요.");
                 return false;
			}
		}

		return true;
	}
	function chkEval(){
		var chkValue;
		for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){
			sheet1.SetCellValue(i,"sStatus","U");
			var v_statusCd = sheet1.GetCellValue(i,"statusCd");
			if(v_statusCd == 5){
				 alert("이미 평가완료 처리 하셨습니다.");
               return false;
			}
		}
		return true;
	}

	function sheet2_OnChange(Row, Col, Value){
    	var colName = sheet2.ColSaveName(Col);
    	if(colName == "appClassCd1"){
    		calTotalPoint2();
    	}
    }

	 function calTotalPoint1(){

		 var row = sheet1.GetSelectionRows();
    	 var totalPoint = sheet1.GetCellValue(row,"appPoint");
    	 var totalGrade = sheet1.GetCellText(row,"appClassCdSelf");


    	var lr = sheet2.LastRow();
		sheet2.SetCellValue(lr,"appClassCd",totalPoint+"/"+totalGrade);
		sheet2.SetCellValue(lr,"competencyMemo","점수/등급");
		sheet2.SetCellAlign(lr,"competencyMemo","Right");
    }

	 function calTotalPoint2(){


    	 var totalPoint = 0;
    	 var totalGrade = "";
    	 var totalGradeCd = "";
    	 if(gradeInfo.DATA != null){
    		 for(var i = sheet2.HeaderRows(); i<sheet2.RowCount()+sheet2.HeaderRows(); i++){
    				var appClassCd = sheet2.GetCellValue(i, "appClassCd1");

    				if(appClassCd != ""){
    					        var tempPoint = appClassCd*sheet2.GetCellValue(i, "appBasisPoint")/100;
    							totalPoint += tempPoint;
    							sheet2.SetCellValue(i,"appPoint1",tempPoint);
    				}
   			 }
    	 }

    	for(j=0; j < gradeInfo.DATA.length; j++){
    		 	if(gradeInfo.DATA[j].toPoint <= totalPoint && totalPoint <= gradeInfo.DATA[j].fromPoint){
					totalGrade = gradeInfo.DATA[j].codeNm;
					totalGradeCd = gradeInfo.DATA[j].appClassCd;
					break;
				}
		}
    	totalPoint = Round(totalPoint,2);

    	var lr = sheet2.LastRow();
		sheet2.SetCellValue(lr,"appClassCd1",totalPoint);

    }


	function chkBeforeSave(){

		for(var i = sheet2.HeaderRows(); i<sheet2.RowCount()+sheet2.HeaderRows(); i++){
			var v_appClassCd1 = sheet2.GetCellValue(i,"appClassCd1");
			if(v_appClassCd1 == ""){
				alert("1차평가를 하지 않은 항목이 존재 합니다.\n 1차평가 후 저장 처리 하세요");
				return false;
			}

			if(v_appClassCd1 > 100){
				alert("평가점수는 100을 넘을 수 없습니다. \n 조정 후 저장 처리 하세요");
				sheet2.SelectCell(i,"appClassCd1");
				return false;
			}
		}
		return true;

	}

		//특정자리 반올림
	function Round(n, pos) {
    	var digits = Math.pow(10, pos);

    	var sign = 1;
    	if (n < 0) {
    	sign = -1;
    	}

    	// 음수이면 양수처리후 반올림 한 후 다시 음수처리
    	n = n * sign;
    	var num = Math.round(n * digits) / digits;
    	num = num * sign;

    	return num.toFixed(pos);
    }





</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
	<input id="searchSabun" 	name ="searchSabun" type="hidden" value="" />
	<input id="searchYn" 	name ="searchYn" type="hidden" value="" />

	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<td colspan="2">
				<span>평가명 </span> <select id="searchAppraisalCd" name="searchAppraisalCd"> </select>
			</td>
			<td><span>성명 </span>
				<input id="searchName" name ="searchName" value="${sessionScope.ssnName}" type="text" class="text readonly " readOnly />
				<input id="searchAppSabun" name ="searchAppSabun" value="${sessionScope.ssnSabun}" type="hidden" class="text"  />
				<a onclick="javascript:employeePopup();" class="button6"><img src="/common/images/common/btn_search2.gif"/></a>
				<a onclick="$('#searchSabun,#searchName').val('');" class="button7"><img src="/common/images/icon/icon_undo.png"/></a>
			</td>
			<td>
			</td>
		</tr>
		<tr>
			<td> <span>소속 </span> <input id="searchOrgNm" 	    name ="searchOrgNm" type="text" class="text readonly w150" value="${sessionScope.ssnOrgNm}" readOnly /> </td>
			<td> <span>직위 </span> <input id="searchJikweeNm"   name ="searchJikweeNm" type="text" class="text readonly" value="${sessionScope.ssnJikweeNm}" readOnly /> </td>
			<td> <span>직책 </span> <input id="searchJikchakNm"  name ="searchJikchakNm" type="text" class="text readonly"  value="${sessionScope.ssnJikchakNm}"  readOnly /> </td>
			<td>
				<a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a>
			</td>
		</tr>

		</table>
		</div>
	</div>
	</form>

	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<colgroup>
		<col width="27%" />
		<col width="15px" />
		<col width="73%" />
	</colgroup>
	<tr>
		<td class="">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt">피평가자</li>
					<li class="btn">
						<a href="javascript:doAction1('Save2')" 	class="basic authA group2">평가</a>
						<a href="javascript:doAction1('Save1')" 	class="basic authA group2">확정</a>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
		</td>
		<td></td>
		<td class="">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt">피평가자정보</li>
					<li class="btn">

					</li>
				</ul>
				</div>
			</div>
			<div class="inner">
				<table class="table w100p" id="htmlTable">
					<colgroup>
						<col width="11%" />
						<col width="15%" />
						<col width="9%" />
						<col width="15%" />
						<col width="11%" />
						<col width="15%" />
						<col width="11%" />
						<col width="13%" />
					</colgroup>
					<tr>
						<th>평가명</th>
						<td colspan="3">
							<span id="iAppraisalNm" name="iAppraisalNm"></span>
						</td>
						<th>평가자</th>
						<td>
							<span id="iAppName" name="iAppName" type="text"></span>
						</td>
						<th>진행상태</th>
						<td>
							<span id="iStatus" name="iStatus" type="text"></span>
						</td>
					</tr>
					<tr>
						<th>성명</th>
						<td>
							<span id="iName" name="iName" type="text"></span>
						</td>
						<th>소속</th>
						<td>
							<span id="iOrgnm" name="iOrgnm" type="text"></span>
						</td>
						<th>직위</th>
						<td>
							<span id="iJikwee" name="iJikwee" type="text"></span>
						</td>
						<th>직책</th>
						<td>
							<span id="iJikchak" name="iJikchak" type="text"></span>
						</td>
					</tr>
					<tr>
						<th>본인평가</th>
						<td colspan="3">
							<span id="iAppPoint" name="iAppPoint" type="text"></span>
							/<span id="iAppClassCdSelf" name="iAppClassCdSelf" type="text"></span>
						</td>
						<th>1차평가</th>
						<td colspan="3">
							<!-- <span id="iAppClassCd" name="iAppClassCd" type="text"></span> -->
							<span id="iU1AppPoint" name="iU1AppPoint" type="text"></span>
						</td>
					</tr>
				</table>
			</div>
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt">역량평가</li>
					<li class="btn">
						<a href="javascript:doAction2('Save')" 	class="basic authA group2">저장</a>

					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet2", "100%", "100%"); </script>
		</td>
	</tr>
	</table>

</div>
</body>
</html>