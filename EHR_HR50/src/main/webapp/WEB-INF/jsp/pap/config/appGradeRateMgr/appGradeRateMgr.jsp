<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		//var appSeqCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getComCodeNoteList&searchGrcodeCd=P00003&searchUseYn=Y&searchNote1=Y",false).codeList, "");
		var appSeqCdList = convCode( ajaxCall("/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCommonCodeList&grpCd=P00003&inCode=2,6",false).codeList, "");

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"S등급비율"	,Type:"Int",	 	Hidden:0,  Width:100,	Align:"Center",	ColMerge:0,SaveName:"appSRate",		KeyField:1,CalcLogic:"",Format:"###\\%",			PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:100 },
			{Header:"A등급비율"	,Type:"Int",	 	Hidden:0,  Width:100,	Align:"Center",	ColMerge:0,SaveName:"appARate",		KeyField:1,CalcLogic:"",Format:"###\\%",			PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:100 },
			{Header:"B등급비율"	,Type:"Int",	 	Hidden:0,  Width:100,	Align:"Center",	ColMerge:0,SaveName:"appBRate",		KeyField:1,CalcLogic:"",Format:"###\\%",			PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:100 },
			{Header:"C등급비율"	,Type:"Int",	 	Hidden:0,  Width:100,	Align:"Center",	ColMerge:0,SaveName:"appCRate",		KeyField:1,CalcLogic:"",Format:"###\\%",			PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:100 },
			{Header:"D등급비율"	,Type:"Int",	 	Hidden:0,  Width:100,	Align:"Center",	ColMerge:0,SaveName:"appDRate",		KeyField:1,CalcLogic:"",Format:"###\\%",			PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:100 },
			{Header:"합계"		,Type:"Int",	 	Hidden:0,  Width:100,	Align:"Center",	ColMerge:0,SaveName:"totCnt",		KeyField:0,CalcLogic:"|appSRate|+|appARate|+|appBRate|+|appCRate|+|appDRate|",Format:"###\\%",			PointCount:0,UpdateEdit:0,InsertEdit:0,EditLen:100 },
			{Header:"비고"		,Type:"Text",	 	Hidden:0,  Width:100,	Align:"Left",	ColMerge:0,SaveName:"note",			KeyField:0,CalcLogic:"",Format:"",			PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:1000 },

			{Header:"평가ID"		,Type:"Text",	 	Hidden:1,  Width:100,  Align:"Center",	ColMerge:0,SaveName:"appraisalCd",	KeyField:1,CalcLogic:"",Format:"",			PointCount:0,UpdateEdit:0,InsertEdit:1,EditLen:10 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(0);
		sheet1.SetUnicodeByte(3);

		initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata2.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"평가차수",		Type:"Text",	 	Hidden:1,  Width:70, 	Align:"Center",	ColMerge:0,SaveName:"appSeqNm",		KeyField:0,CalcLogic:"",Format:"",	  PointCount:0, UpdateEdit:0,InsertEdit:0,EditLen:100 },
			{Header:"평가그룹",		Type:"Text",	 	Hidden:0,  Width:150, 	Align:"Center",	ColMerge:0,SaveName:"appGroupNm",	KeyField:0,CalcLogic:"",Format:"",	  PointCount:0, UpdateEdit:0,InsertEdit:0,EditLen:10 },
			{Header:"전체\n기준인원",	Type:"Int",			Hidden:0,  Width:100,  	Align:"Center",	ColMerge:0,SaveName:"totCnt",		KeyField:0,CalcLogic:"",Format:"",	  PointCount:0, UpdateEdit:0,InsertEdit:0,EditLen:13 },
			
			/* 20190627 TPAP217 조직평가등급항목 관리 기능 추가로 사용안함.
			{Header:"S등급",			Type:"Int",	 	Hidden:0,  Width:100,	Align:"Center",	ColMerge:0,SaveName:"appGroupSCnt",	KeyField:1,CalcLogic:"",Format:"",	  PointCount:0, UpdateEdit:1,InsertEdit:1,EditLen:100 },
			{Header:"A등급",			Type:"Int",	 	Hidden:0,  Width:100,	Align:"Center",	ColMerge:0,SaveName:"appGroupACnt",	KeyField:1,CalcLogic:"",Format:"",	  PointCount:0, UpdateEdit:1,InsertEdit:1,EditLen:100 },
			{Header:"B등급",			Type:"Int",	 	Hidden:0,  Width:100,	Align:"Center",	ColMerge:0,SaveName:"appGroupBCnt",	KeyField:1,CalcLogic:"",Format:"",	  PointCount:0, UpdateEdit:1,InsertEdit:1,EditLen:100 },
			{Header:"C등급",			Type:"Int",	 	Hidden:0,  Width:100,	Align:"Center",	ColMerge:0,SaveName:"appGroupCCnt",	KeyField:1,CalcLogic:"",Format:"",	  PointCount:0, UpdateEdit:1,InsertEdit:1,EditLen:100 },
			{Header:"D등급",			Type:"Int",	 	Hidden:0,  Width:100,	Align:"Center",	ColMerge:0,SaveName:"appGroupDCnt",	KeyField:1,CalcLogic:"",Format:"",	  PointCount:0, UpdateEdit:1,InsertEdit:1,EditLen:100 },
			*/
			
			{Header:"등급별\n계획인원",	Type:"Int",			Hidden:0,  Width:100,	Align:"Center",	ColMerge:0,SaveName:"totCalc",		KeyField:0,CalcLogic:"|appGroupSCnt|+|appGroupACnt|+|appGroupBCnt|+|appGroupCCnt|+|appGroupDCnt|",Format:"",			PointCount:0,UpdateEdit:0,InsertEdit:0,EditLen:100 },
			{Header:"비고",			Type:"Text",		Hidden:0,  Width:100,	Align:"Left",	ColMerge:0,SaveName:"note",			KeyField:0,CalcLogic:"",Format:"",	  PointCount:0, UpdateEdit:1,InsertEdit:1,EditLen:1000 },

			{Header:"평가ID",			Type:"Text",		Hidden:1,  Width:50,	Align:"Center",	ColMerge:0,SaveName:"appraisalCd",	KeyField:1,CalcLogic:"",Format:"",	  PointCount:0, UpdateEdit:0,InsertEdit:1,EditLen:10 },
			{Header:"평가종류",		Type:"Text",		Hidden:1,  Width:50,	Align:"Center",	ColMerge:0,SaveName:"appTypeCd",	KeyField:1,CalcLogic:"",Format:"",	  PointCount:0, UpdateEdit:0,InsertEdit:1,EditLen:10 },
			{Header:"appSeqCd",		Type:"Text",		Hidden:1,  Width:50,	Align:"Center",	ColMerge:0,SaveName:"appSeqCd",		KeyField:1,CalcLogic:"",Format:"",	  PointCount:0, UpdateEdit:0,InsertEdit:1,EditLen:10 },
			{Header:"평가대상그룹",		Type:"Text",		Hidden:1,  Width:50,	Align:"Center",	ColMerge:0,SaveName:"appGroupCd",	KeyField:1,CalcLogic:"",Format:"",	  PointCount:0, UpdateEdit:0,InsertEdit:1,EditLen:10 }
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);sheet2.SetUnicodeByte(3);

		sheet2.SetDataLinkMouse("totCnt",1);

		$(window).smartresize(sheetResize); sheetInit();

		var appraisalCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAppraisalCdList&searchAppTypeCd=A,B,C",false).codeList, ""); // 평가명
		$("#searchAppraisalCd").html(appraisalCdList[2]); //평가명
		$("#searchAppSeqCd").html(appSeqCdList[2]);

		//평가종류
		var searchAppTypeCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P10003"), "");
		$("#searchAppTypeCd").html(searchAppTypeCdList[2]);

		$("#searchAppraisalCd").bind("change",function(event){
			//setAppClassCd();
			if( $(this).val() != "" ) {
				$("#searchAppTypeCd").val($(this).val().substring(2,3));
			}
			doAction1("Search");
		});

		$("#searchAppSeqCd").bind("change",function(event){
			doAction1("Search");
		});

		$("#searchAppraisalCd").change();
	});

	function setAppClassCd(){

		//평가등급기준 -- 평가종류에 따라 다른 등급을 가져옴.

		var saveNameLst1 = ["appSRate", "appARate", "appBRate", "appCRate", "appDRate"];
		var saveNameLst2 = ["appGroupSCnt", "appGroupACnt", "appGroupBCnt", "appGroupCCnt", "appGroupDCnt"];

		classCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppClassCdList&searchAppraisalCd="+$("#searchAppraisalCd").val(),false).codeList, ""); // 평가등급
		clsLst = classCdList[0].split("|");

		for( var i=0; i<clsLst.length ; i++){
			sheet1.SetColHidden(saveNameLst1[i], 0 );
			sheet1.SetCellValue(0, saveNameLst1[i], clsLst[i] );
			sheet2.SetColHidden(saveNameLst2[i], 0 );
			sheet2.SetCellValue(0, saveNameLst2[i], clsLst[i] );
		}
		var len = clsLst.length;
		if(classCdList[0] == "" ) len = 0;
		for( var i=len; i<saveNameLst1.length ; i++){
			sheet1.SetColHidden(saveNameLst1[i], 1 );
			sheet2.SetColHidden(saveNameLst2[i], 1 );
		}

	}
</script>
<!-- sheet1 script -->
<script type="text/javascript">
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/AppGradeRateMgr.do?cmd=getAppGradeRateMgrList1", $("#srchFrm").serialize() ); break;
		case "Save":
							if(sheet1.FindStatusRow("I") != ""){
								if(!dupChk(sheet1,"appraisalCd", false, true)){break;}
							}
							IBS_SaveName(document.srchFrm,sheet1);
							sheet1.DoSave( "${ctx}/AppGradeRateMgr.do?cmd=saveAppGradeRateMgr1", $("#srchFrm").serialize());
							break;
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

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != "") alert(Msg);
			if ( Code != -1 ) {

				doAction2("Search");
			}
			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "") alert(Msg);
			if ( Code != -1 ){
				doAction1("Search");
			}
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

	function sheet1_OnChange(Row, Col, Value, OldValue, RaiseFlag) {

		if(sheet1.GetCellValue(Row, "totCnt") > 100){
			alert('등급의 합은 100을 초과 할수 없습니다.');
			sheet1.ReturnCellData(Row, Col);
		}
	}
</script>

<!-- sheet2 script -->
<script type="text/javascript">

	function initSheet2() {
		
		// 시트 초기화
		sheet2.Reset();
		
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata1.Cols = [
			{Header:"No|No",						Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",						Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",						Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			
			{Header:"평가ID|평가ID",					Type:"Text",	 	Hidden:1,  Width:50,	Align:"Center",	ColMerge:0,SaveName:"appraisalCd",	KeyField:1,CalcLogic:"",Format:"",	  PointCount:0, UpdateEdit:0,InsertEdit:1,EditLen:10 },
			{Header:"평가종류|평가종류",				Type:"Text",		Hidden:1,  Width:50,	Align:"Center",	ColMerge:0,SaveName:"appTypeCd",	KeyField:1,CalcLogic:"",Format:"",	  PointCount:0, UpdateEdit:0,InsertEdit:1,EditLen:10 },
			{Header:"평가차수코드|평가차수코드",			Type:"Text",	 	Hidden:1,  Width:50,	Align:"Center",	ColMerge:0,SaveName:"appSeqCd",		KeyField:1,CalcLogic:"",Format:"",	  PointCount:0, UpdateEdit:0,InsertEdit:1,EditLen:10 },
			{Header:"평가대상그룹|평가대상그룹",			Type:"Text",	 	Hidden:1,  Width:50,	Align:"Center",	ColMerge:0,SaveName:"appGroupCd",	KeyField:1,CalcLogic:"",Format:"",	  PointCount:0, UpdateEdit:0,InsertEdit:1,EditLen:10 },

			{Header:"평가차수|평가차수",				Type:"Text",	 	Hidden:1,  Width:70, 	Align:"Center",	ColMerge:0,SaveName:"appSeqNm",		KeyField:0,CalcLogic:"",Format:"",	  PointCount:0, UpdateEdit:0,InsertEdit:0,EditLen:100 },
			{Header:"평가그룹|평가그룹",				Type:"Text",	 	Hidden:0,  Width:150, 	Align:"Center",	ColMerge:0,SaveName:"appGroupNm",	KeyField:0,CalcLogic:"",Format:"",	  PointCount:0, UpdateEdit:0,InsertEdit:0,EditLen:10 },
			{Header:"전체\n기준인원|전체\n기준인원",		Type:"Int",		 	Hidden:0,  Width:100,  	Align:"Center",	ColMerge:0,SaveName:"totCnt",		KeyField:0,CalcLogic:"",Format:"",	  PointCount:0, UpdateEdit:0,InsertEdit:0,EditLen:13 }
		];

		// 컬럼 추가
		var appClassCdList = "";
		var totCalcTxt = "";
		
		var data = ajaxCall("${ctx}/AppGradeRateStd.do?cmd=getAppGradeRateStdClassItemList",$("#srchFrm").serialize(),false);
		if(data != null && data != undefined && data.DATA != null && data.DATA != undefined && data.DATA.length > 0) {
			var item = null;
			for(var i = 0; i < data.DATA.length; i++) {
				item = data.DATA[i];
				var colHeaderNm = item.appClassNm;
				var colSaveNm = "appClassCd_";
				
				// 컬럼 정보 추가
				initdata1.Cols.push({Header:colHeaderNm + "|인원", Type:"Int", Hidden:1, Width:60, Align:"Center", ColMerge:0, SaveName:colSaveNm + (i+1)         , KeyField:0, Format:"", PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:6 });
				initdata1.Cols.push({Header:colHeaderNm + "|최소", Type:"Int", Hidden:0, Width:60, Align:"Center", ColMerge:0, SaveName:colSaveNm + "min_" + (i+1), KeyField:0, Format:"", PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:6 });
				initdata1.Cols.push({Header:colHeaderNm + "|최대", Type:"Int", Hidden:0, Width:60, Align:"Center", ColMerge:0, SaveName:colSaveNm + "max_" + (i+1), KeyField:0, Format:"", PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:6 });
				
				if(i > 0) {
					appClassCdList += "@";
					totCalcTxt += "+";
				}
				appClassCdList += item.appClassCd;
				totCalcTxt += "|" + colSaveNm + "|";
			}
		}
		
		// 컬럼 정보 추가
		initdata1.Cols.push({Header:"등급별\n계획인원|등급별\n계획인원",	Type:"Int",		Hidden:1,  Width:100,	Align:"Center",	ColMerge:0,SaveName:"totCalc",			KeyField:0,	CalcLogic:totCalcTxt,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 });
		initdata1.Cols.push({Header:"절대평가여부|절대평가여부",			Type:"CheckBox",Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"checkIgnoreYn",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1,	TrueValue:"Y", FalseValue:"N" });
		initdata1.Cols.push({Header:"비고|비고",						Type:"Text",	Hidden:0,  Width:100,	Align:"Left",	ColMerge:0,SaveName:"note",				KeyField:0,	CalcLogic:"",			Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 });
		initdata1.Cols.push({Header:"인원수meta|인원",				Type:"Text",	Hidden:1,	Width:60,	Align:"Center", ColMerge:0, SaveName:"cntArr",			KeyField:0, Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 });
		initdata1.Cols.push({Header:"인원수meta|최소",				Type:"Text",	Hidden:1,	Width:60,	Align:"Center", ColMerge:0, SaveName:"minCntArr",		KeyField:0, Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 });
		initdata1.Cols.push({Header:"인원수meta|최대",				Type:"Text",	Hidden:1,	Width:60,	Align:"Center", ColMerge:0, SaveName:"maxCntArr",		KeyField:0, Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 });
		
		// 시트 컬럼 재설정 적용
		IBS_InitSheet(sheet2, initdata1);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);sheet2.SetUnicodeByte(3);
		
		sheet2.SetDataLinkMouse("totCnt", 1);
		
		// 저장 시 분할 저장 설정
		IBS_setChunkedOnSave("sheet1", {
			chunkSize : 25
		});

		$(window).smartresize(sheetResize);
		sheetInit();
		
		$("#appClassCdList").val(appClassCdList);
	}

	//Sheet1 Action
	function doAction2(sAction) {
		switch (sAction) {
			case "Search":
				initSheet2();
				sheet2.DoSearch( "${ctx}/AppGradeRateMgr.do?cmd=getAppGradeRateMgrList2", $("#srchFrm").serialize() );
				break;
				
			case "Save":
				
				/* 무신사 등급별 인원수 범위 개념 적용으로 인하여 총인원과 계획인원 비교 체크 미사용 처리
				if(sheet2.RowCount() > 0) {
					var inwonChk = true;
					for(var i = 1; i < sheet2.RowCount()+1; i++) {
						var totCnt  = sheet2.GetCellValue(i, "totCnt");
						var totCalc = sheet2.GetCellValue(i, "totCalc");
						
						if(totCnt != totCalc) {
							inwonChk = false;
							break;
						}
					}
					
					if(!inwonChk) {
						alert("입력하신 등급별 계획인원의 수가 총인원수와 일치하지 않습니다.");
						break;
					}
				}
				*/
				
				IBS_SaveName(document.srchFrm,sheet2);
				sheet2.DoSave( "${ctx}/AppGradeRateMgr.do?cmd=saveAppGradeRateMgr2", $("#srchFrm").serialize());
				break;
				
			case "Insert":
				var row = sheet2.DataInsert(0);
				break;
				
			case "Copy":
				sheet2.DataCopy();
				break;
				
			case "Clear":
				sheet2.RemoveAll();
				break;
				
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet2);
				var param = {DownCols:downcol, SheetDesign:1, Merge:1};
				sheet2.Down2Excel(param);
				break;
				
			case "LoadExcel":
				var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet2.LoadExcel(params);
				break;
				
			case "Proc":
				if(!confirm( $("#searchAppSeqCd option:selected").text() + "의 평가그룹별 인원배분계획 생성작업을 하시겠습니까?")) return;

				var data = ajaxCall("${ctx}/AppGradeRateMgr.do?cmd=prcAppGradeRateMgr",$("#srchFrm").serialize(),false);
				if(data.Result.Code == null) {
					alert("인원배분계획 생성작업이 완료되었습니다.");
					doAction1("Search");
				} else {
					alert(data.Result.Message);
				}

				break;
		}
	}

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != "") alert(Msg);
			
			// 세부 등급별 인원수 데이터 삽입 처리
			if(sheet2.RowCount() > 0) {
				var headerArr = $("#appClassCdList").val().split("@");
				for(var i = sheet2.HeaderRows(); i<sheet2.RowCount()+sheet2.HeaderRows(); i++){
					var cntArr    = sheet2.GetCellValue( i, "cntArr" );
					var minCntArr = sheet2.GetCellValue( i, "minCntArr" );
					var maxCntArr = sheet2.GetCellValue( i, "maxCntArr" );

					if(cntArr != "" || minCntArr != "" || maxCntArr != "") {
						var valArr    = cntArr.split("@");
						var minValArr = minCntArr.split("@");
						var maxValArr = maxCntArr.split("@");

						for(var j = 0; j < headerArr.length; j++) {
							//console.log("appClassCd_" + (j+1) + " :: " + headerArr[j] + " :: " + valArr[j]);
							if( valArr != null && valArr != undefined && valArr[j] != null && valArr[j] != undefined ) {
								sheet2.SetCellValue( i, "appClassCd_" + (j+1), valArr[j] );
							}
							if( minValArr != null && minValArr != undefined && minValArr[j] != null && minValArr[j] != undefined ) {
								sheet2.SetCellValue( i, "appClassCd_min_" + (j+1), minValArr[j] );
							}
							if( maxValArr != null && maxValArr != undefined && maxValArr[j] != null && maxValArr[j] != undefined ) {
								sheet2.SetCellValue( i, "appClassCd_max_" + (j+1), maxValArr[j] );
							}
						}
						sheet2.SetCellValue( i, "sStatus", "R" );
					}
				}
			}
			
			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "") alert(Msg);
			if ( Code != -1 ) doAction2("Search");
		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet2_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction1("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet2.GetCellValue(Row, "sStatus") == "I") {
				sheet2.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	//
	function sheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
			if( Row >= sheet2.HeaderRows() ) {
				if(sheet2.ColSaveName(Col) == "totCnt"){
					/* if(!isPopup()) {return;}
	
					var args = new Array();
					args["searchAppraisalCd"] = sheet2.GetCellValue(Row, "appraisalCd");
					args["searchAppSeqCd"] = sheet2.GetCellValue(Row, "appSeqCd");
					args["searchAppGroupCd"] = sheet2.GetCellValue(Row, "appGroupCd");
	
					openPopup("${ctx}/AppGradeRateMgr.do?cmd=viewAppGradeOrgRateMgrPop",args,1000,500); */
					
					const p = {
							searchAppraisalCd : sheet2.GetCellValue(Row, "appraisalCd"),
							searchAppSeqCd : sheet2.GetCellValue(Row, "appSeqCd"),
							searchAppGroupCd : sheet2.GetCellValue(Row, "appGroupCd")
					};
					
					var layer = new window.top.document.LayerModal({
					/* 	id : 'appGradeOrgRateMgrLayer'
						, url : '/AppGradeRateMgr.do?cmd=viewAppGradeRateMgrLayer&authPg=R' */
						id : 'appGradeOrgRateMgrLayer'
						, url : '/AppGradeSeqCd2.do?cmd=viewAppGradeOrgRateMgrLayer'
						, parameters: p
						, width : 1000
						, height : 500
						, title : "평가그룹인원"
						, trigger :[
							{
								name : 'appGradeOrgRateMgrLayerTrigger'
								, callback : function(rv){
								}
							}
						]
					});
					layer.show();
				}
			}
		}catch(ex){
			alert("OnClick Event Error : " + ex);
		}
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<input type="hidden" id="appClassCdList" name="appClassCdList" />
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<span>평가명</span>
							<select name="searchAppraisalCd" id="searchAppraisalCd">
							</select>
						</td>
						<td class="hide">
							<span>평가종류</span>
							<select name="searchAppTypeCd" id="searchAppTypeCd" class="box"></select>
						</td>
						<td>
							<span>평가차수</span>
							<select name="searchAppSeqCd" id="searchAppSeqCd" class="box"></select>
						</td>
						<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="btn dark">조회</a> </td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<div class="outer hide">
		<div class="sheet_title">
		<ul>
			<li class="txt">기준배분비율</li>
			<li class="btn">
				<a href="javascript:doAction1('Down2Excel')" 	class="btn outline-gray authR">다운로드</a>
				<a href="javascript:doAction1('Save')" 	class="btn filled authA">저장</a>
			</li>

		</ul>
		</div>
	</div>
	<div class="outer hide">
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "52px"); </script>
	</div>
	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">인원배분기준표</li>
			<li class="btn">
				<a href="javascript:doAction2('Down2Excel')" 	class="btn outline-gray authR">다운로드</a>
				<a href="javascript:doAction2('Save')" 			class="btn soft authA">저장</a>
				<a href="javascript:doAction2('Proc')" 			class="btn filled authA">인원배분기준표생성</a>
			</li>
		</ul>
		</div>
	</div>

	<script type="text/javascript"> createIBSheet("sheet2", "100%", "100%"); </script>

</div>
</body>
</html>