<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>대량발령</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";
	var saveResultMsg = "";
	var POST_ITEMS = null;
	var _selInfo = null;

	$(function() {
		
		
		$("#searchOrdTypeCd").change(function(){
			$(this).bind("selected").val();

			var searchOrdTypeCd = $(this).val();

			var searchOrdDetailCd = "";
			var searchOrdReasonCd = "";

			if(searchOrdTypeCd != null){
				searchOrdDetailCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdDetailCdManagerList&useYn=Y&ordTypeCd="+searchOrdTypeCd ,false).codeList, "선택");
				searchOrdReasonCd  = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&note1="+searchOrdTypeCd, "H40110"), "선택");
			}
			$("#searchOrdDetailCd").html(searchOrdDetailCd[2]);
			$("#searchOrdReasonCd").html(searchOrdReasonCd[2]);
			
			var rtn = ajaxCall("${ctx}/GetDataList.do?cmd=getLargeAppmtMgrColumMap","ordTypeCd="+searchOrdTypeCd ,false).DATA;
			
			if ( rtn != null ){
				
				if ( rtn.length > 0 ){
					
					for ( var i=0; i < rtn.length; i++){
						var columnCd    = rtn[i].columnCd;
						var columnNm    = rtn[i].columnNm;
						var mandatoryYn = rtn[i].mandatoryYn;
						var visibleYn   = rtn[i].visibleYn;
						
						if ( visibleYn == "Y" ){

							sheet1.SetColHidden(columnCd, 0);
							sheet1.SetColHidden(columnNm, 0);
						}
						if ( visibleYn == "N" ){

							sheet1.SetColHidden(columnCd, 1);
							sheet1.SetColHidden(columnNm, 1);
						}
						if ( mandatoryYn == "Y" ){

							var info = {KeyField : 1};
							sheet1.SetColProperty(0, columnCd, info);
							sheet1.SetColProperty(0, columnNm, info);
						}
						if ( mandatoryYn == "N" ){

							var info = {KeyField : 0};
							sheet1.SetColProperty(0, columnCd, info);
							sheet1.SetColProperty(0, columnNm, info);
						}
					}
				}
				
			}
			sheet1.RemoveAll();
			//doAction1("Search");
		});
		
		$("#searchOrdDetailCd").change(function(){
			sheet1.RemoveAll();
		});
		
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:0,Page:22,FrozenCol:10,DataRowMerge:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
   			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"상태",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

   			{Header:"사번",				Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"성명",				Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:200 },
   			{Header:"발령",				Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"ordTypeCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"발령상세",			Type:"Combo",	Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"ordDetailCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"발령세부사유",		Type:"Combo",	Hidden:1,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"ordReasonCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"발령일자",			Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ordYmd",			KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"적용\n순서",		Type:"Text",	Hidden:0,	Width:35,	Align:"Center",	ColMerge:0,	SaveName:"applySeq",		KeyField:0,	Format:"Number",PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"이력조\n회여부",	Type:"CheckBox",Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"visualYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 , TrueValue:"Y", FalseValue:"N" },

		];
		// 발령항목 조회
		POST_ITEMS = ajaxCall("${ctx}/AppmtItemMapMgr.do?cmd=getAppmtItemMapMgrList","searchUseYn=Y",false).DATA;

		// 발령항목 SHEET에 PUSH
		var postItemsNames  = "";
		var grcodeCds = "";
		var postItemGrpCd = [];
		var commonLists = {};
		for(var ind in POST_ITEMS){
			var postItem = POST_ITEMS[ind];

			postItemsNames += ","+postItem.postItem;
			if(postItem.popupType){

				if(postItem.popupType == "ORG" || postItem.popupType == "JOB" || postItem.popupType == "LOCATION"){
					if(!commonLists[postItem.popupType]){
						//postItem.dContent >> postItem.postItem 로 변경 SQL injection
						commonLists[postItem.popupType] = convCode(ajaxCall("${ctx}/LargeAppmtMgr.do?cmd=getExectedDContent","postItem="+postItem.postItem,false).DATA," ");
					}
				}
				grcodeCds += ","+postItem.popupType;
				postItemGrpCd.push({"grpCd":postItem.popupType, "col":convCamel(postItem.postItem+"_VALUE")});

			}
			//sheet header init
			if(postItem.cType == "D") {
					initdata1.Cols.push({Header:postItem.postItemNm,	Type:"Date",	Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName: convCamel(postItem.postItem+"_VALUE"),			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:"10"});
			} else if (postItem.cType == "C"){
				initdata1.Cols.push({Header:postItem.postItemNm,	Type:"Combo",	Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName: convCamel(postItem.postItem+"_VALUE"),			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:"200"});
			} else if (postItem.cType == "P") {
				if (postItem.popupType == "ORG") {
					if ( postItem.columnCd == "ORG_CD" ){
						pGubun = "orgPopup";
					}else if ( postItem.columnCd == "DISPATCH_ORG_CD" ){
						pGubun = "dispatchOrgPopup";
					}
				} else if (postItem.popupType == "JOB" ){
					pGubun = "jobPopup";
				}  
				initdata1.Cols.push({Header:postItem.postItemNm+"코드",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName: convCamel(postItem.postItem+"_VALUE"),			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:"200"});
				initdata1.Cols.push({Header:postItem.postItemNm,	Type:"PopupEdit",	Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName: convCamel(postItem.postItem+"_NM_VALUE"),			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:"200"});
			} else if (postItem.cType == "A") {
				initdata1.Cols.push({Header:postItem.postItemNm,	Type:"Text",	Hidden:0,	Width:300,	Align:"Left",	ColMerge:0,	SaveName: convCamel(postItem.postItem+"_VALUE"),			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:postItem.limitLength});
			}else{
				initdata1.Cols.push({Header:postItem.postItemNm,	Type:"Text",	Hidden:0,	Width:120,	Align:"Left",	ColMerge:0,	SaveName: convCamel(postItem.postItem+"_VALUE"),			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:postItem.limitLength});
			}

		}IBS_InitSheet(sheet1, initdata1);/* sheet1.SetEditable("${editable}"); */sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		//저장시 사용할 post item 별 id 값
		$("<input></input>",{id:"s_SAVENAME2",name:"s_SAVENAME2",type:"hidden"}).appendTo($("#sheet1Form"));
		$("#sheet1Form #s_SAVENAME2").val(postItemsNames);

		//공통코드 조회
		if(grcodeCds.length>1) grcodeCds = grcodeCds.substring(1);
		$.extend(commonLists, convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd="+grcodeCds,false).codeList, " "));
// 		console.log(commonLists);


		for(var ind in postItemGrpCd){
			if(postItemGrpCd[ind].grpCd=="")continue;
			if(!commonLists[postItemGrpCd[ind].grpCd])continue;
			//if(postItemGrpCd[key][0].length==0)continue;

			if(postItemGrpCd[ind].grpCd == "ORG" || postItemGrpCd[ind].grpCd == "JOB" || postItemGrpCd[ind].grpCd == "LOCATION"){
			   sheet1.SetColProperty(postItemGrpCd[ind].col,         {ComboText:"|"+commonLists[postItemGrpCd[ind].grpCd][0], ComboCode:"|"+commonLists[postItemGrpCd[ind].grpCd][1]} );
			}else{
			   sheet1.SetColProperty(postItemGrpCd[ind].col,         {ComboText:"|"+commonLists[postItemGrpCd[ind].grpCd][0], ComboCode:"|"+commonLists[postItemGrpCd[ind].grpCd][1]} );
			}
		}
		//발령
		var ordTypeCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdTypeCdManagerList",false).codeList, "선택");	//발령종류
		var ordDetailCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdDetailCdManagerList",false).codeList, "선택");	//발령상세종류
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
	});
	$(function() {
		$("#popupProcessNo").click(function(){
			pGubun = "processNoMgr";
			showProcessPop();
		});

		$("#searchOrdYmdFrom").datepicker2({startdate:"searchOrdYmdTo"});
		$("#searchOrdYmdTo").datepicker2({enddate:"searchOrdYmdFrom"});
	});

	//Sheet0 Action
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
			if(!isCheck()){break;}
			sheet1.DoSearch( "${ctx}/LargeAppmtMgr.do?cmd=getLargeAppmtMgrList",$("#sheet1Form").serialize() );

			break;
		case "Save":
			/*
			if($("#searchProcessNo").val() == "" ){
				alert("발령번호를 먼저 선택후 수행하세요.");
				return;
			}
			*/
			if(!dupChk(sheet1,"ordTypeCd|sabun|ordYmd", true, true)){break;}

			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/LargeAppmtMgr.do?cmd=saveLargeAppmtMgrExec", $("#sheet1Form").serialize());
			break;
		case "Insert"		:
			/*
			if($("#searchProcessNo").val() == "") {
				alert("발령번호를 먼저 선택후 수행하세요.");
				return;
			}
			*/
			
			if(!isCheck()){break;}
			
			var searchOrdTypeCd   = $("#searchOrdTypeCd").val();
			var searchOrdDetailCd = $("#searchOrdDetailCd").val();
			
			var row = sheet1.DataInsert();
			sheet1.SetCellValue(row, "visualYn","Y");
			
			sheet1.SetCellValue(row, "ordTypeCd", searchOrdTypeCd);
			sheet1.SetCellValue(row, "ordDetailCd", searchOrdDetailCd);
			sheet1.SelectCell(row, "sabun");
			break;
		case "Copy"			:
			var row = sheet1.DataCopy();
			// Hidden 데이터 모두 Clear
			for(var i=0; i<sheet1.GetCols().length; i++) {
				if(sheet1.GetColHidden(i)) {
					sheet1.SetCellValue(row, i, "");
				}
			}
			sheet1.SetCellValue(row, "applySeq","");
			sheet1.SetCellValue(row, "visualYn","Y");
			sheet1.SelectCell(row, "sabun");
			break;
		case "Clear":
			sheet1.RemoveAll();
			break;
		case "UploadData":
			/*
			if($("#searchProcessNo").val() == "") {
				alert("발령번호를 먼저 선택후 수행하세요.");
				return;
			}
			*/
			if(!isCheck()){break;}
			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet1.LoadExcel(params);
			break;
		case "DownData":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			var d = new Date();
			var fName = "대량발령_" + d.getTime();
			sheet1.Down2Excel($.extend(param, { FileName:fName, SheetDesign:1, Merge:1, ExcelFontSize:"9",ExcelRowHeight:"20" }));
			break;
		case "Down2Excel":
			/* if($("#searchProcessNo").val() == "") {
				alert("발령번호를 먼저 선택후 수행하세요.");
				return;
			} */

			if(!isCheck()){break;}
			
			var downcol = makeHiddenSkipCol(sheet1);
			downcol = downcol.replace("|5|6|8", "");

			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,DownRows:0};
			var d = new Date();
			var fName = "대량발령(업로드)_" + d.getTime();
			sheet1.Down2Excel($.extend(param, { FileName:fName, SheetDesign:1, Merge:1, ExcelFontSize:"9",ExcelRowHeight:"20" }));

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

/* 			for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){ 
				var lOrdDetailCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdDetailCdManagerList&ordTypeCd="+ sheet1.GetCellValue(i, "ordTypeCd"),false).codeList, " ");	//발령상세종류
				var lOrdReasonCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&note1="+ sheet1.GetCellValue(i, "ordTypeCd"), "H40110"), " ");

				sheet1.InitCellProperty(i,"ordDetailCd", {Type:"Combo", ComboCode:"|"+lOrdDetailCd[1], ComboText:"|"+lOrdDetailCd[0]});
				sheet1.InitCellProperty(i,"ordReasonCd", {Type:"Combo", ComboCode:"|"+lOrdReasonCd[1], ComboText:"|"+lOrdReasonCd[0]});
	        } */
			
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				saveResultMsg = Msg;
				if(Code>0){
					alert("저장 되었습니다.");
					doAction1("Search");
				} else {
					setStatusShowErrorPopup(saveResultMsg);
				}
			}
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 체크박스 체크전에 발생
	function sheet1_OnBeforeCheck(Row, Col) {
		try{
			/* sheet1.SetAllowCheck(true);

		    if(sheet1.ColSaveName(Col) == "sDelete") {
		        if(sheet1.GetCellValue(Row, "sStatus") == "R") {
		            alert("삭제할 수 없습니다. 초기화 하실려면 [초기화] 버튼을 클릭하십시오.");
					sheet1.SetAllowCheck(false);
		        }
		    } */

		}catch(ex){alert("OnBeforeCheck Event Error : " + ex);}
	}

	// 팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
			if(sheet1.ColSaveName(Col) == "processNo") {
				if(!isPopup()) {return;}

				gPRow = Row;
				pGubun = "appmtConfirmPopup";

	            // var win = openPopup("/AppmtConfirmPopup.do?cmd=viewAppmtConfirmPopup&authPg=R", "", "740","520");
				showProcessPop();
			} else if(sheet1.ColSaveName(Col) == "name") {
				if(!isPopup()) {return;}

				gPRow = Row;
				pGubun = "employeePopup";
				var param = {"topKeyword":sheet1.GetCellValue(Row, Col)};
				empSearchPopup(param);
				// var win = openPopup("/Popup.do?cmd=employeePopup&authPg=R", param, "740","520");
			} else if(sheet1.ColSaveName(Col) == "item2NmValue") {
				if(!isPopup()) {return;}

				gPRow = Row;
				pGubun = "orgPopup";
				var param = {"searchOrgNm":sheet1.GetCellValue(Row, Col)};
				orgSearchPopup(param);
				// var win = openPopup("/Popup.do?cmd=orgBasicPopup&authPg=R", param, "740","520");

			} else if(sheet1.ColSaveName(Col) == "item11NmValue") {
				if(!isPopup()) {return;}

				gPRow = Row;
				pGubun = "dispatchOrgPopup";
				var param = {"searchOrgNm":sheet1.GetCellValue(Row, Col)};
				// var win = openPopup("/Popup.do?cmd=orgBasicPopup&authPg=R", param, "740","520");
				orgSearchPopup(param);
			} else if(sheet1.ColSaveName(Col) == "item9NmValue") {
				if(!isPopup()) {return;}

				gPRow = Row;
				pGubun = "jobPopup";
				var param = {"searchJobNm":sheet1.GetCellValue(Row, Col)};
				// var win = openPopup("/Popup.do?cmd=jobPopup&authPg=R", param, "740","520");
				jobPopup(param);
			} else {
				for(var i = 0 ; i < POST_ITEMS.length ; i++) {
					if(sheet1.ColSaveName(Col) == convCamel(POST_ITEMS[i].postItem+"_NM_VALUE")) {
						gPRow = Row;
						_selInfo = POST_ITEMS[i];
						
						var objid = convCamel(_selInfo.columnCd);
						var popuptype = _selInfo.popupType
						pGubun = {"objid":_selInfo.postItem}; 
						var param = {"codeNm":sheet1.GetCellValue(Row, Col), "grpCd":popuptype};
						if(popuptype.indexOf(".")==-1) openPopup("/Popup.do?cmd=commonCodePopup&authPg=R", param, "740","620");
						else empInfoDynamicPopup(objid,popuptype);
					}
				}
			}

		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}


	function sheet1_OnChange(Row, Col, Value, OldValue) {
		
		if( sheet1.ColSaveName(Col) == "ordTypeCd") {

/* 			if(Value == "") { 
				sheet1.CellComboItem(Row,"ordDetailCd", {"ComboCode":"","ComboText":""});
				sheet1.CellComboItem(Row,"ordReasonCd", {"ComboCode":"","ComboText":""});

			} else {
				var ordDetailCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdDetailCdManagerList&ordTypeCd="+ sheet1.GetCellValue(Row, "ordTypeCd"),false).codeList, " ");	//발령상세종류
				
				var ordReasonCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&note1="+Value, "H40110"), " ");

				sheet1.CellComboItem(Row,"ordDetailCd", {"ComboCode":ordDetailCd[1],"ComboText":ordDetailCd[0]});
				sheet1.CellComboItem(Row,"ordReasonCd", {"ComboCode":ordReasonCd[1],"ComboText":ordReasonCd[0]});
			}	 */		
		}
	}
	
	function sheet1_OnLoadExcel(result) {
		try {
			if(result) {
				
				var searchOrdTypeCd   = $("#searchOrdTypeCd").val();
				var searchOrdDetailCd = $("#searchOrdDetailCd").val();
				
				sheet1.SetRangeValue(searchOrdTypeCd,   sheet1.HeaderRows(), 5, sheet1.LastRow(), 5);
				sheet1.SetRangeValue(searchOrdDetailCd, sheet1.HeaderRows(), 6, sheet1.LastRow(), 6);
			}
		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}
		 


	// 쉬트내에서 찾기
	function sheetFindName() {
		var name = $("#findName").val();

		if(name == "") {
			return;
		}

		var row = 0;
		if(sheet1.GetSelectRow() < sheet1.LastRow()) {
			row = sheet1.FindText("name",name,sheet1.GetSelectRow()+1,2)
		} else {
			row = -1;
		}

		if(row > 0) {
			sheet1.SelectCell(row,"name");
		} else if(row == -1) {
			if(sheet1.GetSelectRow() > 1) {
				row = sheet1.FindText("name",name,1,2);
				if(row > 0) {
					sheet1.SelectCell(row,"name");
				}
			}
		}

	}

	// 발령번호 팝업
	function showProcessNoPop() {
		if(!isPopup()) {return;}

		pGubun = "searchAppmtConfirmPopup";

        var win = openPopup("/AppmtConfirmPopup.do?cmd=viewAppmtConfirmPopup&authPg=R", "", "740","520");
	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = returnValue;

		if(pGubun == "processNoMgr") {
	    	$("#searchProcessNo").val(rv.processNo);
	    	$("#searchProcessTitle").val(rv.processTitle);
	    	// doAction1("Search");
	    }else if(pGubun == "employeePopup") {
	    	sheet1.SetCellValue(sheet1.GetSelectRow(),"sabun",rv.sabun);
	    	sheet1.SetCellValue(sheet1.GetSelectRow(),"name",rv.name);
	    }else if(pGubun == "orgPopup") {
			if (rv.length > 0) {
				rv =  rv[0];
			}
	    	sheet1.SetCellValue(sheet1.GetSelectRow(),"item2Value",rv.orgCd);
	    	sheet1.SetCellValue(sheet1.GetSelectRow(),"item2NmValue",rv.orgNm);
	    }else if(pGubun == "dispatchOrgPopup") {
			if (rv.length > 0) {
				rv =  rv[0];
			}
	    	sheet1.SetCellValue(sheet1.GetSelectRow(),"item11Value",rv.orgCd);
	    	sheet1.SetCellValue(sheet1.GetSelectRow(),"item11NmValue",rv.orgNm);
	    }else if(pGubun == "jobPopup") {
	    	sheet1.SetCellValue(sheet1.GetSelectRow(),"item9Value",rv.jobCd);
	    	sheet1.SetCellValue(sheet1.GetSelectRow(),"item9NmValue",rv.jobNm);
	    }else if(pGubun == "orgPopup2") {
	    	sheet1.SetCellValue(sheet1.GetSelectRow(),"item16Value",rv.orgCd);
	    	sheet1.SetCellValue(sheet1.GetSelectRow(),"item16NmValue",rv.orgNm);
	    	    	
	    } else {
        	
			var popCd = "code";
			var popNm = "codeNm";
			
			var relcolcds = (convCamel(pGubun.objid + "_VALUE")+","+ convCamel(pGubun.objid + "_NM_VALUE")).split(",");
			
			for(var i in relcolcds){
				if(!relcolcds[i])continue;
				var colid = relcolcds[i];//convCamel(relcolcds[i]+"");
				var popVal = "";

				if(colid.substring(colid.length-7) == "NmValue"){
					popVal = rv[popNm];
				}else if(colid.substring(colid.length-5) == "Value"){
					popVal = rv[popCd];
				}
				sheet1.SetCellValue(gPRow, colid, popVal);
			}
        }
	}
	
	function isCheck(){
		
		var ch = true;
		
		var searchOrdTypeCd   = $("#searchOrdTypeCd").val();
		var searchOrdDetailCd = $("#searchOrdDetailCd").val();
		
		if ( searchOrdTypeCd == "" || searchOrdDetailCd == "" ){
			alert("발령은 필수값 입니다.");
			ch = false;
		}
		
		return ch;
	}

	function setStatusShowErrorPopup(eMsg){
		try{
			const oeMsg = $.parseJSON(unescapeXss(eMsg));

			if(oeMsg.length){
				for(var ind in oeMsg){
					for(var i=1 ; i<sheet1.RowCount()+1; i++){
						if( sheet1.GetCellValue(i,"sNo") == oeMsg[ind].sNo){
							sheet1.SetRowFontColor(i, "#FF0000");
							sheet1.SetCellValue(i,"sStatus","I");
							break;
						}
					}
				}
			}
			if(oeMsg.length>0 && confirm("저장중 에러건이 있습니다. 확인하시겠습니까?")){
				viewAppmtSaveErrorPopup(eMsg);
			}
		} catch(e) {
			console.log(e.toString())
		} finally {
			eMsg = null;
		}
	}

	function viewAppmtSaveErrorPopup(eMsg){
		if(!eMsg)eMsg = saveResultMsg;
		if(!eMsg)eMsg = "[]";

		let appmtSaveErrorLayer = new window.top.document.LayerModal({
			id : 'appmtSaveErrorLayer'
			, url : '/Popup.do?cmd=viewAppmtSaveErrorLayer&authPg=R'
			, parameters: {"errorList":eMsg}
			, width : 940
			, height : 620
			, title : "발령 에러메시지"
		});
		appmtSaveErrorLayer.show();

		eMsg = null;
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

	//  소속 팝업
	function orgSearchPopup(param){
		try{
			if(!isPopup()) {return;}
			gPRow = "";
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
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form">
	<input type="hidden" id="searchOrdYn" name="searchOrdYn" value="N"/>
	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<th>발령일</th>
			<td>
				<input id="searchOrdYmdFrom" name="searchOrdYmdFrom" type="text" size="10" class="date2 required" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),-30)%>"/> ~
				<input id="searchOrdYmdTo" name="searchOrdYmdTo" type="text" size="10" class="date2 required" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),+30)%>"/>
			</td>
			<th>발령번호</th>
			<td>
				<input type="text" id="searchProcessNo" name="searchProcessNo" class="text readonly" readonly />
				<a class='button6'><img id="popupProcessNo"src='/common/images/common/btn_search2.gif'/></a>
				<input type="text" id="searchProcessTitle" name="searchProcessTitle" class="text readonly" style="width:150px;" readonly />
				<a onclick="javascript:doAction1('ProcessClear');" class="button7"><img src="/common/images/icon/icon_undo.png"></a>
			</td>
		</tr>
		<tr>
			<th>발령</th>
			<td>
				<select id="searchOrdTypeCd" name="searchOrdTypeCd" class="required"><option value=''>선택</option></select>
				<select id="searchOrdDetailCd" name="searchOrdDetailCd" class="required"><option value=''>선택</option></select>
				<!-- <select id="searchOrdReasonCd" name="searchOrdReasonCd"><option value=''>전체</option></select> -->
			</td>
			<th>사번/성명</th>
			<td>
				<input id="searchSabun" name="searchSabun" type="text" class="text" />

			</td>
			<td>
				<a href="javascript:doAction1('Search');" class="button">조회</a>
			</td>
		</tr>
		</table>
		</div>
	</div>
	</form>
	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">대량발령&nbsp;<b><font color="red">※ 업로드 엑셀 작성 시 적용순서는 입력 하지 마십시오. 변경 항목만 작성하시면 나머지 항목은 현재 기준으로 자동 저장 됩니다.</font></b></li>
			<li class="btn">
				<!-- 발령번호 -->
				<input id="processNo" name="processNo" type="text" class="text w200 hide"/>
<!-- 				<a href="javascript:showProcessNoPop();" class="button6"><img src="/common/images/common/btn_search2.gif"/></a> -->


				<a href="javascript:doAction1('Down2Excel');" class="button authR">양식다운로드</a>
				<a href="javascript:doAction1('Clear');" class="basic authR">초기화</a>
				<a href="javascript:doAction1('Insert')" class="basic authR">입력</a>
				<a href="javascript:doAction1('Copy')" 	class="basic authR">복사</a>
				<a href="javascript:doAction1('Save');" class="basic authR">저장</a>
				<a href="javascript:doAction1('UploadData');" class="basic authA">업로드</a>
				<a href="javascript:doAction1('DownData');" class="basic authA">다운로드</a>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>