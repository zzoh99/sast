<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> 
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var postItemGrpCd = []; //발령세부항목
	var saveResultMsg = "";
	var pGubun;
	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:4,SearchMode:smLazyLoad,Page:22}; 
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
    		{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
   			{Header:"삭제",		Type:"${sDelTy}",	Hidden:0,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"상태",		Type:"${sSttTy}",	Hidden:0,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"발령형태",	Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"ordTypeCd",	KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"발령종류",	Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"ordDetailCd", KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"소속",		Type:"Text",      Hidden:0,  Width:120,  Align:"Left",    ColMerge:0,   SaveName:"orgNm",       KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"사번",		Type:"Text",      Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"sabun",       KeyField:1,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"성명",		Type:"Text",     Hidden:0,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"name",        KeyField:1,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"직책코드",	Type:"Text",      Hidden:1,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"jikchakCd",   KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직책",		Type:"Text",      Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"jikchakNm",   KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"PAYBAND",	Type:"Text",      Hidden:1,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"jikweeCd",    KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직급",		Type:"Text",      Hidden:Number("${jgHdn}"),  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"jikgubNm",    KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직구분코드",	Type:"Text",      Hidden:1,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"workType",    KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직군",		Type:"Text",      Hidden:1,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"workTypeNm",  KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },			
			{Header:"직급",		Type:"Text",      Hidden:1,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"jikgubCd",    KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직무코드",	Type:"Text",      Hidden:1,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"jobCd",       KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직무",		Type:"Text",      Hidden:1,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"jobNm",       KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"적용순서",   Type:"Text",      Hidden:1,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"applySeq",        KeyField:0, Format:"Number",PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35 },
			{Header:"이력조회여부",Type:"CheckBox",Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"visualYn",        KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 , TrueValue:"Y", FalseValue:"N" },
            {Header:"발령일자",   Type:"Date",      Hidden:1,   Width:80,   Align:"Center", ColMerge:0, SaveName:"ordYmd",          KeyField:1, Format:"Ymd",   PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"발령소속명",  Type:"Popup",     Hidden:0,   Width:120,  Align:"Center",  ColMerge:0,   SaveName:"ordOrgNm",    KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"발령소속코드", Type:"Text",     Hidden:1,   Width:70,   Align:"Center",  ColMerge:0, SaveName: "ordOrgCd",      KeyField:1, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100},
			{Header:"재직상태",		Type:"Text",      Hidden:1,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"statusCd",       KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"사원구분",		Type:"Text",      Hidden:1,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"manageCd",       KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"급여타입",		Type:"Text",      Hidden:1,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"payType",       KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
		];

		
		var ordTypeCd = convCode( ajaxCall("${ctx}/OrgAppmtMgr.do?cmd=getOrgAppmtMgrTabOrdTypeCodeList", "", false).codeList, "");	//발령종류
		$("#chgOrdTypeCd").html(ordTypeCd[2]);
		var ordDetailCd = convCode( ajaxCall("${ctx}/OrgAppmtMgr.do?cmd=getOrgAppmtMgrTabOrdCodeList", "chgOrdTypeCd="+$("#chgOrdTypeCd option:selected").val(), false).codeList, "");	//발령종류

		$("#chgOrdDetailCd").html(ordDetailCd[2]);
		
		
        $("#chgOrdTypeCd").change(function(){
            
        	var ordDetailCd = convCode( ajaxCall("${ctx}/OrgAppmtMgr.do?cmd=getOrgAppmtMgrTabOrdCodeList", "chgOrdTypeCd="+$("#chgOrdTypeCd option:selected").val(), false).codeList, "");	//발령종류
			$("#chgOrdDetailCd").html(ordDetailCd[2]);
        });
		
		$("#chgOrdYmd").datepicker2();
		// 발령항목 조회
        var POST_ITEMS = ajaxCall("${ctx}/AppmtItemMapMgr.do?cmd=getAppmtItemMapMgrList","searchUseYn=Y",false).DATA;
        // 발령항목 SHEET에 PUSH
        var postItemsNames  = "";
        var grcodeCds = "";
        for(var ind in POST_ITEMS){
            
            var postItem = POST_ITEMS[ind];
            postItemsNames += ","+postItem.postItem;
            if(postItem.popupType){
                grcodeCds += ","+postItem.popupType;
                postItemGrpCd.push({"grpCd":postItem.popupType, "col":convCamel(postItem.postItem+"_VALUE"), "realCol":postItem.columnCd});
            }
            //sheet header init
			if(postItem.columnCd == "ORG_CD"){
				initdata.Cols.push({Header:"발령소속",    Type:"Text",     Hidden:1,   Width:70,   Align:"Center",  ColMerge:0, SaveName: convCamel(postItem.postItem+"_VALUE"),            KeyField:1, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100});
			}else {
				initdata.Cols.push({Header:postItem.postItemNm,   Type:"Text",    Hidden:1,   Width:70,   Align:"Center", ColMerge:0, SaveName: convCamel(postItem.postItem+"_VALUE"),            KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:postItem.limitLength});
			}
        }
        
        initdata.Cols.push({Header:"선택",       Type:"DummyCheck",Hidden:0,  Width:40,   Align:"Center",  ColMerge:0,   SaveName:"select",      KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 });
        
        
        
        IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
        
        if(grcodeCds.length>1) grcodeCds = grcodeCds.substring(1);
        
        //$.extend(commonLists, convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd="+grcodeCds,false).codeList, " "));

      //저장시 사용할 post item 별 id 값
        $("<input></input>",{id:"s_SAVENAME2",name:"s_SAVENAME2",type:"hidden"}).appendTo($("#mySheetForm"));
        $("#mySheetForm #s_SAVENAME2").val(postItemsNames);
        
		//Autocomplete
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue){
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(sheet1.GetSelectRow(),"sabun",rv.sabun);
				    	sheet1.SetCellValue(sheet1.GetSelectRow(),"name",rv.name);
				    	sheet1.SetCellValue(sheet1.GetSelectRow(),"orgCd",rv.orgCd);
				    	sheet1.SetCellValue(sheet1.GetSelectRow(),"orgNm",rv.orgNm);
				    	sheet1.SetCellValue(sheet1.GetSelectRow(),"jikchakCd",rv.jikchakCd);
				    	sheet1.SetCellValue(sheet1.GetSelectRow(),"jikchakNm",rv.jikchakNm);
				    	sheet1.SetCellValue(sheet1.GetSelectRow(),"jikweeCd",rv.jikweeCd);
				    	sheet1.SetCellValue(sheet1.GetSelectRow(),"workType",rv.workType);
				    	sheet1.SetCellValue(sheet1.GetSelectRow(),"jikgubCd",rv.jikgubCd);
				    	sheet1.SetCellValue(sheet1.GetSelectRow(),"jobCd",rv.jobCd);
				    	sheet1.SetCellValue(sheet1.GetSelectRow(),"statusCd",rv.statusCd);
				    	sheet1.SetCellValue(sheet1.GetSelectRow(),"manageCd",rv.manageCd);
				    	sheet1.SetCellValue(sheet1.GetSelectRow(),"payType",rv.payType);
					}
				}
			]
		}); 
		
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	function setSheet1Param() {
		for(var i=sheet1.HeaderRows();i<sheet1.RowCount()+sheet1.HeaderRows();i++){
			if(sheet1.GetCellValue(i,"sStatus") =="I"){
				sheet1.SetCellValue(i, "ordYmd",$("#chgOrdYmd").val());
				sheet1.SetCellValue(i, "ordDetailCd",$("#chgOrdDetailCd").val());
				sheet1.SetCellValue(i, "ordTypeCd",$("#chgTypeCd").val());
			}

			for(var ind in postItemGrpCd){
				if(postItemGrpCd[ind].grpCd=="") continue;
				var val = "";
				if(postItemGrpCd[ind].realCol == "ORG_CD") { //조직정보를 발령조직 정보로 전달
					val = sheet1.GetCellValue(i, "ordOrgCd");
				}else {
					val = sheet1.GetCellValue(i, convCamel(postItemGrpCd[ind].realCol));
				}
				console.log(convCamel(postItemGrpCd[ind].realCol) + " : " +val);
				if(val != "-1" && val != "") sheet1.SetCellValue(i, postItemGrpCd[ind].col, val);
			}
		}
	}
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			//var param = "orgCd="+sheet1.GetCellValue(sheet1.GetSelectRow(),"orgCd");
			sheet1.DoSearch( "${ctx}/OrgAppmtMgr.do?cmd=getOrgAppmtMgrTab1UserList", param, 1 );
			break;
		case "Save": 		
					
			if($("#chgOrdTypeCd").val() == "") {
				alert("발령을 선택하여 주십시오.");
				return;
			}
			
			if($("#chgOrdDetailCd").val() == "") {
				alert("발령상세를 선택하여 주십시오.");
				return;
			}
			
			if($("#chgOrdYmd").val() == "") {
				alert("발령일자를 지정하세요.");
				return;
			}

            var param = "&chgOrdDetailCd="+$("#chgOrdDetailCd").val()
			+"&chgOrdTypeCd="+$("#chgOrdTypeCd").val()
			+"&chgOrdYmd="+$("#chgOrdYmd").val().replace(/-/gi,"")
			+"&searchProcessNo="+$("#searchProcessNo").val();
			setSheet1Param();
            IBS_SaveName(document.mySheetForm,sheet1);
			sheet1.DoSave( "${ctx}/OrgAppmtMgr.do?cmd=saveOrgAppmtMgrTab2User", $("#mySheetForm").serialize());
			break;
			
		case "Insert":		sheet1.SelectCell(sheet1.DataInsert(0), "name"); break;
		case "Copy":		sheet1.DataCopy(); break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":	sheet1.Down2Excel(); break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		case "OrgSet":
			if($("#chgOrgCd").val() == "") {
				alert("발령소속을 선택하세요.");
				return;
			}

			if(sheet1.CheckedRows("select") == 0) {
				alert("직원을 선택하세요.");
				return;
			}

			if($("#chgOrgCd").val() != sheet1.GetCellValue(sheet1.GetSelectRow(), "orgCd")) {
                for( i = sheet1.HeaderRows(); i < sheet1.RowCount() + sheet1.HeaderRows(); i++) {
                    if(sheet1.GetCellValue(i,"select") == 1){
                    	sheet1.SetCellValue(i, "ordOrgCd",$("#chgOrgCd").val());
                    	sheet1.SetCellValue(i, "ordOrgNm",$("#chgOrgNm").val());
                    }
                }
			} else {
				alert("선택하신 소속이 같은 소속입니다. \n 다른 소속을 선택하세요.");
				$("#chgOrgCd").val("");
				$("#chgOrgNm").val("");
			}
			break;
		case "OrgClear":
            if(sheet1.RowCount()<=0){
                return;
            }
            if( !confirm(" 발령소속을 초기화 하시겠습니까?" ) ) {
                return;
            }
            for( i = 1; i <= sheet1.RowCount(); i++) {
               	sheet1.SetCellValue(i, "ordOrgCd","");
               	sheet1.SetCellValue(i, "ordOrgNm","");

               	if(sheet1.GetCellValue(i,"processNo") == "") {
                   	sheet1.SetCellValue(i, "sStatus","R");
               	}
            }
			break;
		case "ProcessClear":
			$("#searchProcessNo").val("");
			$("#searchProcessTitle").val("");
			break;
		}

	}
	

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
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

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	}
	
	// 팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
			if(sheet1.ColSaveName(Col) == "name") {
		        var rst = openPopup("/Popup.do?cmd=employeePopup&authPg=R", "", "740","520");   
		        if(rst != null){
	                sheet1.SetCellValue(Row, "sabun", rst["sabun"] );
	                sheet1.SetCellValue(Row, "name", rst["name"] );
	                sheet1.SetCellValue(Row, "orgNm", rst["orgNm"] );
	                sheet1.SetCellValue(Row, "jikchakNm", rst["jikchakNm"] );
	                sheet1.SetCellValue(Row, "jikgubNm", rst["jikgubNm"] );
		        }
			}else if(sheet1.ColSaveName(Col) == "ordOrgNm"){

				if(!isPopup()) {return;}
				gPRow  = Row;
				pGubun = "orgTreePopup";
				showOrgPopup(Row);
	            <%--var win = openPopup("/Popup.do?cmd=orgTreePopup&authPg=${authPg}", "", "740","520");--%>
			}else if(sheet1.ColSaveName(Col) == "processNo") {
	            var rst = openPopup("/AppmtConfirmPopup.do?cmd=viewAppmtConfirmPopup&authPg=${authPg}", "", "740","520");
	            if(rst != null){
	                sheet1.SetCellValue(Row, "processNo", rst["processNo"] );
	            }
			}
		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}

	// 소속 선택 팝업
	function showOrgPop() {
		if(!isPopup()) {return;}
		
		pGubun = "searchOrgTreePopup";

		showOrgPopup();
	}


	// 소속 팝업
	function showOrgPopup(row) {

		if(!isPopup()) {return;}
		gPRow = "";

		var w = 750, h = 920;
		var title = "<tit:txt mid='orgTreePop' mdef='조직도 조회'/>";
		var url = "/Popup.do?cmd=viewOrgTreeLayer";

		var layerModal = new window.top.document.LayerModal({
			id : 'orgTreeLayer',
			url : url,
			parameters: {searchEnterCd : ''},
			width : w,
			height : h,
			title : title,
			trigger: [
				{
					name: 'orgTreeLayerTrigger',
					callback: function(rv) {
						getReturnValue(rv,row);
					}
				}
			]
		});
		layerModal.show();
		/*
        if(rst != null){
            $("#searchOrgCd").val(rst["orgCd"]);
            $("#searchOrgNm").val(rst["orgNm"]);
        }
        */
	}

	// 발령번호 선택 팝업
	function showProcessPop() {
		if(!isPopup()) {return;}
        pGubun = "searchAppmtConfirmPopup";
        //var win = openPopup("/AppmtConfirmPopup.do?cmd=viewAppmtConfirmPopup&authPg=${authPg}", "", "740","520");
        openPopup("/Popup.do?cmd=viewAppmtProcessNoMgrPopup&authPg=R", "", "1000","520");
		
	}


	// 발령번호 선택 팝업
	function showProcessLayerPop() {
		if(!isPopup()) {return;}
		pGubun = "searchAppmtConfirmPopup";
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
	function getReturnValue(returnValue, row) {
		var rv = returnValue;

        if(pGubun == "searchOrgTreePopup"){
        	$("#chgOrgCd").val(rv["orgCd"]);
        	$("#chgOrgNm").val(rv["orgNm"]);
        } else if(pGubun == "searchAppmtConfirmPopup") {
        	$("#searchProcessNo").val(rv["processNo"]);
            $("#searchProcessTitle").val(rv["processTitle"]);
        } else if(pGubun == "orgTreePopup") {
        	sheet1.SetCellValue(row, "ordOrgCd", rv["orgCd"] );
            sheet1.SetCellValue(row, "ordOrgNm", rv["orgNm"] );
        } else if(pGubun == "appmtConfirmPopup") {
            sheet1.SetCellValue(row, "processNo", rv["processNo"] );
        }
	}
	
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="mySheetForm" name="mySheetForm" >
		<div class="sheet_search outer">
			<div>
			<table>
			<tr>
                   <th>발령</th>
				<td>
                    <select id="chgOrdTypeCd" name="chgOrdTypeCd" class="required">
                    </select>
                </td>
				<th>발령상세</th>
				<td>
					<select id="chgOrdDetailCd" name="chgOrdDetailCd" class="required">
					</select>
				</td>
				<th>발령일자</th>
				<td>
					<input id="chgOrdYmd" name="chgOrdYmd" type="text" size="10" class="date2 required"/>
				</td>	
				<th>변경소속</th>			
				<td>
					<input id="chgOrgNm" name="chgOrgNm" type="text" class="text readonly" readonly />
					<input id="chgOrgCd" name="chgOrgCd" type="hidden" class="text" />
					<a href="javascript:showOrgPop();" class="button6"><img src="${ctx}/common/images/common/btn_search2.gif"/></a>
				</td>
				<td>
					<a href="javascript:doAction1('OrgSet');" class="button">변경소속반영</a>
					<a href="javascript:doAction1('OrgClear');" class="basic authA">초기화</a>
				</td>
			</tr>
			<tr class="show">
				<th>발령번호</th>
				<td colspan="4">
                    <input type="text" id="searchProcessNo" name="searchProcessNo" class="text readonly required" readonly />
                    <a href="javascript:showProcessLayerPop();" class="button6"><img src="${ctx}/common/images/common/btn_search2.gif"/></a>
                    <input type="text" id="searchProcessTitle" name="searchProcessTitle" class="text w150 readonly required" readonly />
                    <a onclick="javascript:doAction1('ProcessClear');" class="button7"><img src="/common/images/icon/icon_undo.png"></a>
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
							<li id="txt" class="txt">조직변경</li>
							<li class="btn">
<%--								<a href="javascript:doAction1('Search');" class="button authA">조회</a>--%>
								<a href="javascript:doAction1('Insert')" class="basic authA">입력</a>
								<a href="javascript:doAction1('Copy')" 	class="basic authA">복사</a>
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