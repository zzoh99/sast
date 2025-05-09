<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>인사기본(발령내역수정)</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	var POST_ITEMS = null;

	$(function() {
		
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:0,Page:22,FrozenCol:10,DataRowMerge:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
   			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"\n삭제",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"상태",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

   			{Header:"사번",				Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
			{Header:"성명",				Type:"Text",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:200 },
   			{Header:"발령",				Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"ordTypeCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
			{Header:"발령상세",			Type:"Combo",	Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"ordDetailCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"발령세부사유",		Type:"Combo",	Hidden:1,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"ordReasonCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"발령일자",			Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ordYmd",			KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"적용\n순서",		Type:"Text",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"applySeq",		KeyField:1,	Format:"Number",PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:35 },
			{Header:"이력조\n회여부",	Type:"CheckBox",Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"visualYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 , TrueValue:"Y", FalseValue:"N" },

		];
		// 발령항목 조회
		POST_ITEMS = ajaxCall("${ctx}/AppmtItemMapMgr.do?cmd=getAppmtItemMapMgrList","searchUseYn=Y",false).DATA;

		// 발령항목 SHEET에 PUSH
		var postItemsNames  = "SABUN,ORD_TYPE_CD,ORD_DETAIL_CD,ORD_YMD,APPLY_SEQ";
		var grcodeCds = "";
		var postItemGrpCd = [];
		var commonLists = {};
		for(var ind in POST_ITEMS){

			var postItem = POST_ITEMS[ind];
			if ( postItem.cType == "P" || postItem.cType == "C" ){
				postItemsNames += ","+postItem.columnCd;
				postItemsNames += ","+(postItem.columnCd).replace("_CD", "")+"_NM";
			}else{
				postItemsNames += ","+postItem.columnCd;
			}
			if(postItem.popupType){

				if(postItem.popupType == "ORG" || postItem.popupType == "JOB" || postItem.popupType == "LOCATION"){
					if(!commonLists[postItem.popupType]){
						commonLists[postItem.popupType] = convCode(ajaxCall("${ctx}/LargeAppmtMgr.do?cmd=getExectedDContent","postItem="+postItem.postItem,false).DATA," ");
					}
				}
				grcodeCds += ","+postItem.popupType;
				postItemGrpCd.push({"grpCd":postItem.popupType, "col":convCamel(postItem.columnCd+"_")});

			}
			//sheet header init
			if(postItem.cType == "D") {
					initdata1.Cols.push({Header:postItem.postItemNm,	Type:"Date",	Hidden:0,	Width:110,	Align:"Center",	ColMerge:0,	SaveName: convCamel(postItem.columnCd+"_"),			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:"10"});
			} else if (postItem.cType == "C"){
				initdata1.Cols.push({Header:postItem.postItemNm,	 Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName: convCamel(postItem.columnCd+"_"),			    KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:"200"});
				initdata1.Cols.push({Header:postItem.postItemNm+"명", Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName: convCamel(postItem.nmColumnCd+"_"),			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:"200"});
			} else if (postItem.cType == "P") {
				if (postItem.popupType == "ORG") {
					pGubun = "orgPopup";
				} else if (postItem.popupType == "JOB" ){
					pGubun = "jobPopup";
				} else if (postItem.popupType == "LOCATION" ){
					pGubun = "locationPopup1";
				} 
				initdata1.Cols.push({Header:postItem.postItemNm+"코드",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName: convCamel(postItem.columnCd+"_"),			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:"200"});
				initdata1.Cols.push({Header:postItem.postItemNm,	Type:"PopupEdit",	Hidden:0,	Width:110,	Align:"Center",	ColMerge:0,	SaveName: convCamel(postItem.nmColumnCd+"_"),		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:"200"});
			}else{
				initdata1.Cols.push({Header:postItem.postItemNm,	Type:"Text",	Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName: convCamel(postItem.columnCd+"_"),			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:postItem.limitLength});
			}


		}IBS_InitSheet(sheet1, initdata1);/* sheet1.SetEditable("${editable}"); */sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		//저장시 사용할 post item 별 id 값
		$("<input></input>",{id:"s_SAVENAME2",name:"s_SAVENAME2",type:"hidden"}).appendTo($("#empForm"));
		$("#empForm #s_SAVENAME2").val(postItemsNames);

		//공통코드 조회
		if(grcodeCds.length>1) grcodeCds = grcodeCds.substring(1);
		//$.extend(commonLists, convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd="+grcodeCds,false).codeList, " "));
		$.extend(commonLists, convCodes( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCommonCodeLists2&grpCd="+grcodeCds,false).codeList, " "));
 		//console.log(commonLists);
 		//alert(JSON.stringify(commonLists))

		for(var ind in postItemGrpCd){
			if(postItemGrpCd[ind].grpCd=="")continue;
			if(!commonLists[postItemGrpCd[ind].grpCd])continue;
			//if(postItemGrpCd[key][0].length==0)continue;

			if(postItemGrpCd[ind].grpCd == "ORG" || postItemGrpCd[ind].grpCd == "JOB" || postItemGrpCd[ind].grpCd == "LOCATION"){
			   sheet1.SetColProperty(postItemGrpCd[ind].col,         {ComboText:"|"+commonLists[postItemGrpCd[ind].grpCd][0], ComboCode:"|"+commonLists[postItemGrpCd[ind].grpCd][1]} );
			}else{

			   sheet1.SetColProperty(postItemGrpCd[ind].col,         {ComboText:"|"+commonLists[postItemGrpCd[ind].grpCd][0], ComboCode:"|"+commonLists[postItemGrpCd[ind].grpCd][1]} );
			   sheet1.SetColProperty((postItemGrpCd[ind].col).replace("Cd", "")+"Nm",         {ComboText:"|"+commonLists[postItemGrpCd[ind].grpCd][0], ComboCode:"|"+commonLists[postItemGrpCd[ind].grpCd][0]} );
			}
		}
		//발령
		var ordTypeCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdTypeCdManagerList",false).codeList, "전체");	//발령종류
		var ordDetailCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdDetailCdManagerList",false).codeList, " ");	//발령상세종류
		var ordReasonCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H40110"), " ");

		sheet1.SetColProperty("ordTypeCd", 		{ComboText:"|"+ordTypeCd[0], ComboCode:"|"+ordTypeCd[1]} );
		sheet1.SetColProperty("ordDetailCd", 		{ComboText:"|"+ ordDetailCd[0], ComboCode:"|"+ordDetailCd[1]} );
		sheet1.SetColProperty("ordReasonCd", 		{ComboText:"|"+ ordReasonCd[0], ComboCode:"|"+ordReasonCd[1]} );

		$("#searchOrdTypeCd").html(ordTypeCd[2]);//검색조건의 발령
		
		

		//Autocomplete
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue){
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(sheet1.GetSelectRow(),"sabun",rv.sabun);
				    	sheet1.SetCellValue(sheet1.GetSelectRow(),"name",rv.name);
					}
				}
			]
		}); 	
		

		$(window).smartresize(sheetResize); sheetInit();

		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,MergeSheet:0,Page:22,FrozenCol:7,DataRowMerge:0};
		initdata2.HeaderMode = {Sort:0,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata2.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",			Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"상태",			Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"사번",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"시작일자",		Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sdate",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"종료일자",		Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"edate",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
		]; 
		
		
		for(var ind in POST_ITEMS){

			var postItem = POST_ITEMS[ind];

			if(postItem.popupType){

				if(postItem.popupType == "ORG" || postItem.popupType == "JOB" || postItem.popupType == "LOCATION"){
					if(!commonLists[postItem.popupType]){
						commonLists[postItem.popupType] = convCode(ajaxCall("${ctx}/LargeAppmtMgr.do?cmd=getExectedDContent","postItem="+postItem.postItem,false).DATA," ");
					}
				}
				grcodeCds += ","+postItem.popupType;
				postItemGrpCd.push({"grpCd":postItem.popupType, "col":convCamel(postItem.columnCd+"_")});

			}
			//sheet header init
			if(postItem.cType == "D") {
					initdata2.Cols.push({Header:postItem.postItemNm,	Type:"Date",	Hidden:0,	Width:110,	Align:"Center",	ColMerge:0,	SaveName: convCamel(postItem.columnCd+"_"),			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:"10"});
			} else if (postItem.cType == "C"){
				initdata2.Cols.push({Header:postItem.postItemNm,	Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName: convCamel(postItem.columnCd+"_"),			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:"200"});
			} else if (postItem.cType == "P") {
				if (postItem.popupType == "ORG") {
					pGubun = "orgPopup";
				} else if (postItem.popupType == "JOB" ){
					pGubun = "jobPopup";
				}  
				initdata2.Cols.push({Header:postItem.postItemNm,	Type:"PopupEdit",	Hidden:0,	Width:110,	Align:"Center",	ColMerge:0,	SaveName: convCamel((postItem.columnCd).replace("_CD", "")+"_NM"),			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:"200"});
			}else{
				initdata2.Cols.push({Header:postItem.postItemNm,	Type:"Text",	Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName: convCamel(postItem.columnCd+"_"),			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:postItem.limitLength});
			}
		}
		
		IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable(false);sheet2.SetVisible(true);sheet2.SetCountPosition(4);
		
		for(var ind2 in postItemGrpCd){
			if(postItemGrpCd[ind2].grpCd=="")continue;
			if(!commonLists[postItemGrpCd[ind2].grpCd])continue;
			//if(postItemGrpCd[key][0].length==0)continue;

			if(postItemGrpCd[ind2].grpCd == "ORG" || postItemGrpCd[ind2].grpCd == "JOB" || postItemGrpCd[ind2].grpCd == "LOCATION"){
			   sheet2.SetColProperty(postItemGrpCd[ind2].col,         {ComboText:"|"+commonLists[postItemGrpCd[ind2].grpCd][0], ComboCode:"|"+commonLists[postItemGrpCd[ind2].grpCd][1]} );
			}else{
			   sheet2.SetColProperty(postItemGrpCd[ind2].col,         {ComboText:"|"+commonLists[postItemGrpCd[ind2].grpCd][0], ComboCode:"|"+commonLists[postItemGrpCd[ind2].grpCd][1]} );
			}
		}
		
		$(window).smartresize(sheetResize); sheetInit();

         $("#searchKeyword").bind("keyup",function(event){
			if( event.keyCode == 13){
				sheetSearch();
			}
		});

	});

	//Sheet0 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if($("#sabun").val() == "") {
				alert("사원을 검색하여 주십시오.");
				return;
			}

			var param = "sabun="+$("#sabun").val();

			sheet1.DoSearch( "${ctx}/AppmtHistoryMgr.do?cmd=getAppmtHistoryMgrExecList", param );

			break;
		case "Save":
			var SaveJson = sheet1.GetSaveJson(); // validation 체크
			if(SaveJson.Code == undefined || SaveJson.Code == ""){
				if(!dupChk(sheet1,"ordYmd|applySeq", true, true)){break;}
				if(!dupChk(sheet1,"sabun|ordTypeCd|ordYmd|applySeq", true, true)){break;}
				//변경에 대한 사유 기록
				commentPopup();
			}
			
			break;
		case "Insert":
			if($("#sabun").val() == "") {
				alert("사원을 검색하여 주십시오.");
				return;
			}

			var row = sheet1.DataInsert(0);

			sheet1.SetCellValue(row,"sabun",$("#sabun").val());
			
			for(var ind in POST_ITEMS){
				var postItem = POST_ITEMS[ind];
				if ( postItem.cType == "P" || postItem.cType == "C" ){
					if (/_CD$/.test(postItem.columnCd)) { //_CD로 끝나는 필드일 경우 처리
						sheet1.SetCellValue(row, convCamel(postItem.nmColumnCd+"_"), sheet1.GetCellText(row,convCamel(postItem.columnCd+"_")));
					} else if (/^WORK_TYPE$/.test(postItem.columnCd)) {
						sheet1.SetCellValue(row,"workTypeNm",sheet1.GetCellText(row,"workType"));
					} else if (/^PAY_TYPE$/.test(postItem.columnCd)) {
						sheet1.SetCellValue(row,"payTypeNm",sheet1.GetCellText(row,"payType"));
					} else if (/^SAL_CLASS$/.test(postItem.columnCd)) {
						sheet1.SetCellValue(row,"salClassNm",sheet1.GetCellText(row,"salClass"));
					}
				}
			}
			
			sheet1.SelectCell(row, "ordTypeCd");
			break;
		case "Copy":
			sheet1.DataCopy();
			break;
		case "Clear":
			sheet1.RemoveAll();
			sheet2.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			var d = new Date();
			var fName = "개인발령내역_" + d.getTime();
			sheet1.Down2Excel($.extend(param, { FileName:fName, SheetDesign:1, Merge:1 }));
			break;
		}
	}

	//Sheet0 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			if($("#sabun").val() == "") {
				alert("사원을 검색하여 주십시오.");
				return;
			}

			var param = "sabun="+$("#sabun").val();

			sheet2.DoSearch( "${ctx}/AppmtHistoryMgr.do?cmd=getAppmtHistoryMgrOrgList", param );

			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			var d = new Date();
			var fName = "개인조직사항_" + d.getTime();
			sheet2.Down2Excel($.extend(param, { FileName:fName, SheetDesign:1, Merge:1 }));
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){
				var lOrdDetailCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdDetailCdManagerList&ordTypeCd="+ sheet1.GetCellValue(i, "ordTypeCd"),false).codeList, " ");	//발령상세종류
				var lOrdReasonCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&note1="+ sheet1.GetCellValue(i, "ordTypeCd"), "H40110"), " ");

				sheet1.InitCellProperty(i,"ordDetailCd", {Type:"Combo", ComboCode:"|"+lOrdDetailCd[1], ComboText:"|"+lOrdDetailCd[0]});
				sheet1.InitCellProperty(i,"ordReasonCd", {Type:"Combo", ComboCode:"|"+lOrdReasonCd[1], ComboText:"|"+lOrdReasonCd[0]});
	        }

			sheetResize();

		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}

		doAction2('Search');
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			callProcPerRow('prcAppmtHistoryCreate');
			doAction1("Search");

		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			if(sheet1.GetCellEditable(Row,Col) == true) {
				if(sheet1.ColSaveName(Col) == "orgNm" && KeyCode == 46) {
					sheet1.SetCellValue(Row,"orgCd","");
				} else if(sheet1.ColSaveName(Col) == "jobNm" && KeyCode == 46) {
					sheet1.SetCellValue(Row,"jobCd","");
				} else if(sheet1.ColSaveName(Col) == "dispatchOrgNm" && KeyCode == 46) {
					sheet1.SetCellValue(Row,"dispatchOrgCd","");
				} else if(sheet1.ColSaveName(Col) == "locationNm" && KeyCode == 46) {
					sheet1.SetCellValue(Row,"locationCd","");
				}
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	// 셀 값이 바뀔때 발생
	function sheet1_OnChange(Row, Col, Value) {
		try{
            if( sheet1.ColSaveName(Col) == "ordTypeCd" ) {

				if(Value == "") {
					//sheet1.CellComboItem(Row,"ordDetailCd", {"ComboCode":"","ComboText":""});
					//sheet1.CellComboItem(Row,"ordReasonCd", {"ComboCode":"","ComboText":""});
					sheet1.InitCellProperty(Row,"ordDetailCd", {Type:"Combo", ComboCode:"", ComboText:""});
					sheet1.InitCellProperty(Row,"ordReasonCd", {Type:"Combo", ComboCode:"", ComboText:""});
				} else {
					var lOrdDetailCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdDetailCdManagerList&ordTypeCd="+ sheet1.GetCellValue(Row, "ordTypeCd"),false).codeList, " ");	//발령상세종류
					var lOrdReasonCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&note1="+Value, "H40110"), " ");
					sheet1.InitCellProperty(Row,"ordDetailCd", {Type:"Combo", ComboCode:"|"+lOrdDetailCd[1], ComboText:"|"+lOrdDetailCd[0]});
					sheet1.InitCellProperty(Row,"ordReasonCd", {Type:"Combo", ComboCode:"|"+lOrdReasonCd[1], ComboText:"|"+lOrdReasonCd[0]});
				}
            } else if(sheet1.GetCellProperty(Row, Col, 'Type') == "Combo" || sheet1.GetCellProperty(Row, Col, 'Type') == "PopupEdit") {
    			for(var ind in POST_ITEMS){
    				var postItem = POST_ITEMS[ind];
    				if ( convCamel(postItem.columnCd+"_") == sheet1.ColSaveName(Col) ){
    					if (/_CD$/.test(postItem.columnCd)) { //_CD로 끝나는 필드일 경우 처리
    						sheet1.SetCellValue(Row, convCamel(postItem.nmColumnCd+"_"), sheet1.GetCellText(Row, convCamel(postItem.columnCd+"_")));
    						break;
    					} else if (/^WORK_TYPE$/.test(postItem.columnCd)) {
    						sheet1.SetCellValue(Row,"workTypeNm",sheet1.GetCellText(Row,"workType"));
    						break;
    					} else if (/^PAY_TYPE$/.test(postItem.columnCd)) {
    						sheet1.SetCellValue(Row,"payTypeNm",sheet1.GetCellText(Row,"payType"));
    						break;
    					} else if (/^SAL_CLASS$/.test(postItem.columnCd)) {
    						sheet1.SetCellValue(Row,"salClassNm",sheet1.GetCellText(Row,"salClass"));
    						break;
    					}
    				}
    			}
            }
            
		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}

	// 팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
			if(sheet1.ColSaveName(Col) == "processNo") {
				if(!isPopup()) {return;}

				gPRow = Row;
				pGubun = "processNo1";

	            // var win = openPopup("/AppmtConfirmPopup.do?cmd=viewAppmtConfirmPopup&authPg=R", "", "740","520");
				showProcessPop();
			} else if(sheet1.ColSaveName(Col) == "orgNm") {
				if(!isPopup()) {return;}

				gPRow = Row;
				pGubun = "orgNm1";

		        // var win = openPopup("/Popup.do?cmd=orgTreePopup&authPg=R", "", "800","750");
				orgTreePopup();
			} else if(sheet1.ColSaveName(Col) == "workorgNm") {
				if(!isPopup()) {return;}

				gPRow = Row;
				pGubun = "workorgNm1";

		        //var win = openPopup("/View.do?cmd=viewOrgTreeSubPopup&authPg=R", "", "700","750");
		        // var win = openPopup("/Popup.do?cmd=orgBasicPopup&authPg=R", "", "800","750");
				orgSearchPopup();
			} else if(sheet1.ColSaveName(Col) == "jobNm") {
				if(!isPopup()) {return;}

				gPRow = Row;
				pGubun = "jobNm1";

		        // var win = openPopup("/Popup.do?cmd=jobPopup&authPg=R", "", "800","750");
				jobPopup();
			} else if(sheet1.ColSaveName(Col) == "dispatchOrgNm") {
				if(!isPopup()) {return;}
				gPRow = Row;
				pGubun = "dispatchOrgNm1";

		        // var win = openPopup("/Popup.do?cmd=orgBasicPopup&authPg=R", "", "950","750");
				orgSearchPopup();
			} else if(sheet1.ColSaveName(Col) == "locationNm") {
				if(!isPopup()) {return;}

				gPRow = Row;
				pGubun = "locationPopup1";

		        //var win = openPopup("/LocationCodePopup.do?cmd=viewLocationCodePopup&authPg=R", "", "950","750");
				locationPopup();
			}
		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = returnValue;

        if(pGubun == "processNo1"){
			sheet1.SetCellValue(gPRow, "processNo", rv["processNo"] );
        } else if(pGubun == "orgNm1") {
			if (rv.length > 0) rv = rv[0];
            sheet1.SetCellValue(gPRow, "orgCd", rv["orgCd"] );
            sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"] );
        } else if(pGubun == "workorgNm1") {
			if (rv.length > 0) rv = rv[0];
            sheet1.SetCellValue(gPRow, "workorgCd", rv["orgCd"] );
            sheet1.SetCellValue(gPRow, "workorgNm", rv["orgNm"] );
        } else if(pGubun == "jobNm1") {
            sheet1.SetCellValue(gPRow, "jobCd", rv["jobCd"] );
            sheet1.SetCellValue(gPRow, "jobNm", rv["jobNm"] );
        } else if(pGubun == "dispatchOrgNm1") {
			if (rv.length > 0) rv = rv[0];
            sheet1.SetCellValue(gPRow, "dispatchOrgCd", rv["orgCd"] );
            sheet1.SetCellValue(gPRow, "dispatchOrgNm", rv["orgNm"] );
        } else if(pGubun == "locationPopup1") {
            sheet1.SetCellValue(gPRow, "locationCd", rv["code"] );
            sheet1.SetCellValue(gPRow, "locationNm", rv["codeNm"] );
        } else if(pGubun == "orgNm2") {
			if (rv.length > 0) rv = rv[0];
            sheet2.SetCellValue(gPRow, "orgCd", rv["orgCd"] );
            sheet2.SetCellValue(gPRow, "orgNm", rv["orgNm"] );
        } else if(pGubun == "jobNm2") {
            sheet2.SetCellValue(gPRow, "jobCd", rv["jobCd"] );
            sheet2.SetCellValue(gPRow, "jobNm", rv["jobNm"] );
        } else if(pGubun == "dispatchOrgNm2") {
			if (rv.length > 0) rv = rv[0];
            sheet2.SetCellValue(gPRow, "dispatchOrgCd", rv["orgCd"] );
            sheet2.SetCellValue(gPRow, "dispatchOrgNm", rv["orgNm"] );
        } else if(pGubun == "searchEmployeePopup") {
        	$("#sabun").val(rv["sabun"]);
        	$("#name").val(rv["name"]);
        	$("#cresNo").val(rv["cresNo"]);
        	$("#searchKeyword").val(rv["name"]);

            sheetSearch();
        }
	}

	// 사원검색 팝업
	function showEmployeePop() {
		if(!isPopup()) {return;}

		pGubun = "searchEmployeePopup";

		var args = new Array(1);
		args["topKeyword"] = $("#searchKeyword").val();

        var win = openPopup("/Popup.do?cmd=employeePopup&authPg=R", args, "740","520");
	}

	function sheetSearch() {
		if($("#sabun").val() == "") {
			alert("사원을 검색하여 주십시오.");
			return;
		}

		doAction1('Search');
	}

	function setEmpPage(){
		$("#sabun").val($("#searchUserId").val());
		$("#name").val($("#searchKeyword").val());
		sheetSearch();
	}

	function callProc(procName) {

		var sht1Count = 0;
		var sht2Count = 0;

		for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){
			if ( sheet1.GetCellValue (i, "sStatus") == "I"){
				sht1Count++;
			}
		}
		for(var r = sheet2.HeaderRows(); r < sheet2.RowCount() + sheet2.HeaderRows(); r++){
			if ( sheet2.GetCellValue ( r, "sStatus") == "I"){
				sht2Count++;
			}
		}

		if( sht1Count > 0 || sht2Count > 0 ) {
			alert("입력중인 행이 존재합니다. 저장후 처리하시기 바랍니다.") ;
			return ;
		}

		var params = "sabun=" + $("#sabun").val();
		var data = ajaxCall("/AppmtHistoryMgr.do?cmd=prcAppmtHistoryCreate",params,false);

		if(data == null || data.Result == null) {
			msg = "prcAppmtHistoryCreate 를 사용할 수 없습니다." ;
			return msg ;
		}

		if(data.Result.Code == null || data.Result.Code == "") {
			msg = "TRUE" ;
			procCallResultMsg = data.Result.Message ;
		} else {
	    	msg = "데이터 처리도중 : "+data.Result.Message;
		}

		return msg ;
	}

	function callProcPerRow(procName) {
		if( $("#sabun").val() == "" ) {
			alert("사번을 선택하여 주십시오.") ;
			return ;
		} else {
			var checker = callProc(procName) ;
			if( checker != "TRUE" ) {
				return ;
			}else{
				//alert(procCallResultMsg) ;
				doAction2("Search") ;
			}
		}
	}

	function returnCmtVal(comment){
		if (comment == "") {
			alert("발령내역수정 사유를 입력하십시오.")
		} else {
			var tmp = replaceAll(comment, "\n", "<br>");
			$("#modifyCmt").val(tmp);
			IBS_SaveName(document.empForm,sheet1);
			sheet1.DoSave( "${ctx}/AppmtHistoryMgr.do?cmd=saveAppmtHistoryMgrExec", $("#empForm").serialize() );
		}
	}
	
    function commentPopup(){

		let layerModal = new window.top.document.LayerModal({
			id : 'appmtHistoryMgrLayer'
			, url : '/AppmtHistoryMgr.do?cmd=viewAppmtHistoryMgrLayer'
			, width : 400
			, height : 400
			, title : '발령내역수정 사유'
			, trigger :[
				{
					name : 'appmtHistoryMgrLayerTrigger'
					, callback : function(result){
						returnCmtVal(result.comment);
					}
				}
			]
		});
		layerModal.show();
	}

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

	// 사원검색 팝입
	function empSearchPopup(param) {
		let layerModal = new window.top.document.LayerModal({
			id : 'employeeLayer'
			, url : '/Popup.do?cmd=viewEmployeeLayer&authPg=R'
			, parameters : param
			, width : 840
			, height : 520
			, title : '사원조회'
			, trigger :[
				{
					name : 'employeeTrigger'
					, callback : function(result){
						getReturnValue(result);
					}
				}
			]
		});
		layerModal.show();
	}

	//  소속 팝입
	function orgTreePopup(){
		try{
			var w = 740, h = 520;
			var p = { searchEnterCd: "${ssnEnterCd}" };
			var title = "<tit:txt mid='orgTreePop' mdef='조직도 조회'/>";
			var url = "/Popup.do?cmd=viewOrgTreeLayer";
			var layerModal = new window.top.document.LayerModal({
				id : 'orgTreeLayer',
				url : url,
				parameters: p,
				width : w,
				height : h,
				title : title,
				trigger: [
					{
						name: 'orgTreeLayerTrigger',
						callback: function(rv) {
							getReturnValue(rv);
						}
					}
				]
			});
			layerModal.show();
		}catch(ex){alert("Open Popup Event Error : " + ex);}
	}

	//  소속 팝업
	function orgSearchPopup(param){
		try{
			if(!isPopup()) {return;}
			// gPRow = "";
			// pGubun = "orgBasicPopup";

			let layerModal = new window.top.document.LayerModal({
				id : 'orgLayer'
				, url : '/Popup.do?cmd=viewOrgBasicLayer&authPg=R'
				, parameters : param
				, width : 740
				, height : 520
				, title : '<tit:txt mid='orgSchList' mdef='조직 리스트 조회'/>'
				, trigger :[
					{
						name : 'orgTrigger'
						, callback : function(result){
							getReturnValue(result);
						}
					}
				]
			});
			layerModal.show();
		}catch(ex){alert("Open Popup Event Error : " + ex);}
	}

	//팝업 클릭시 발생
	function jobPopup(param) {
		if(!isPopup()) {return;}
		var layer = new window.top.document.LayerModal({
			id : 'jobPopupLayer'
			, url : "${ctx}/Popup.do?cmd=jobPopup&authPg=${authPg}"
			, parameters: param
			, width : 740
			, height : 720
			, title : "직무 리스트 조회"
			, trigger :[
				{
					name : 'jobPopupTrigger'
					, callback : function(rv){
						getReturnValue(rv);
					}
				}
			]
		});
		layer.show();
	}

	// location 선택 팝업
	function locationPopup() {
		if(!isPopup()) {return;}
		const layer = new window.top.document.LayerModal({
			id : 'locationCodeLayer'
			, url : "${ctx}/LocationCodePopup.do?cmd=viewLocationCodeLayer&authPg=R"
			, parameters: {}
			, width : 450
			, height : 700
			, title : "근무지검색"
			, trigger :[
				{
					name : 'locationCodeLayerTrigger'
					, callback : function(rv){
						getReturnValue(rv);
					}
				}
			]
		});
		layer.show();
	}
</script>
</head>
<body class="bodywrap">
	<div class="wrapper">
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<form id="empForm" name="empForm" >
							<th>성명/사번</th>
							<td>
								<input id="name" name="name" type="hidden"/>
								<input type="text"   id="searchKeyword"  name="searchKeyword" class="text" style="ime-mode:active"/>
								<input type="hidden" id="searchEmpType"  name="searchEmpType" value="I"/> <!-- Include에서  사용 -->
								<input type="hidden" id="searchStatusCd" name="searchStatusCd" value="A" /><!-- in ret -->
								<input type="hidden" id="searchUserId"   name="searchUserId" value="" />
							</td>

							<th>사번</th>
							<td>
								<input id="sabun" name="sabun" type="text" class="text readonly" readonly />
							</td>
							<td>
								<a href="javascript:doAction1('Search');" class="button">조회</a>
							</td>
							<input id='modifyCmt' name='modifyCmt' type='hidden' class='text w100p'></input>
						</form>
					</tr>
				</table>
			</div>
		</div>

		<div class="outer" id="sh1">
			<div class="sheet_title">
				<ul>
					<li class="txt">개인발령내역</li>
					<li class="btn">
						<!-- <a href="javascript:callProcPerRow('prcAppmtHistoryCreate')"	class="pink authA">개인조직사항적용</a> -->
						<a href="javascript:doAction1('Search');" class="basic authR">조회</a>
						<a href="javascript:doAction1('Insert');" class="basic authA">입력</a>
						<a href="javascript:doAction1('Copy');" class="basic authA">복사</a>
						<a href="javascript:doAction1('Save');" class="basic authA">저장</a>
						<a href="javascript:doAction1('Down2Excel');" class="basic authR">다운로드</a>
					</li>
				</ul>
			</div>
		</div>

		<script type="text/javascript"> createIBSheet("sheet1", "100%", "50%");</script>

		<div class="outer" id="sh2">
			<div class="sheet_title">
				<ul>
					<li class="txt">개인조직사항 &nbsp;<b><font color="red">※ 개인발령내역을 입력/수정/삭제 하시면 해당 발령내역이 개인조직사항에 자동으로 반영 됩니다.</font></b></li>
					<li class="btn">
						<a href="javascript:doAction2('Search');" class="basic authR">조회</a>
						<!-- <a href="javascript:doAction2('Insert');" class="basic authA">입력</a>
						<a href="javascript:doAction2('Copy');" class="basic authA">복사</a>
						<a href="javascript:doAction2('Save');" class="basic authA">저장</a> -->
						<a href="javascript:doAction2('Down2Excel');" class="basic authR">다운로드</a>
					</li>
				</ul>
			</div>
		</div>

		<script type="text/javascript"> createIBSheet("sheet2", "100%", "50%"); </script>
	</div>

</body>
</html>