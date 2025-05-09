<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>소속개편발령</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";
	var postItemGrpCd = []; //발령세부항목
	
	//var gOrdReasonCd = codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H40110");

	$(function() {

		var ordTypeCd = convCode( ajaxCall("${ctx}/OrgAppmtMgr.do?cmd=getOrgAppmtMgrTabOrdTypeCodeList", "", false).codeList, "");	//발령종류
		$("#chgOrdTypeCd").html(ordTypeCd[2]);
		var ordDetailCd = convCode( ajaxCall("${ctx}/OrgAppmtMgr.do?cmd=getOrgAppmtMgrTabOrdCodeList", "chgOrdTypeCd="+$("#chgOrdTypeCd option:selected").val(), false).codeList, "");	//발령종류
		$("#chgOrdDetailCd").html(ordDetailCd[2]);
		$("#chgOrdTypeCd").change(function(){
			var ordDetailCd = convCode( ajaxCall("${ctx}/OrgAppmtMgr.do?cmd=getOrgAppmtMgrTabOrdCodeList", "chgOrdTypeCd="+$("#chgOrdTypeCd option:selected").val(), false).codeList, "");	//발령종류
			$("#chgOrdDetailCd").html(ordDetailCd[2]);
		});

		$("#chgOrdYmd").datepicker2({
			onReturn:function(date){
				doAction2("Search");
			}
		});

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:0,Page:22,FrozenCol:0,DataRowMerge:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"소속도명",		Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"orgChartNm",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"시작일",			Type:"Text",	Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"상위소속코드",	Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"priorOrgCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"소속코드",		Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100,    TreeCol:1 },
			{Header:"팀",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"orgCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,MergeSheet:0,Page:22,FrozenCol:0,DataRowMerge:0};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata2.Cols = [
			{Header:"No",		   Type:"${sNoTy}",	 Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"상태",		   Type:"${sSttTy}", Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"발령형태",	   Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"ordTypeCd",	KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"발령종류",	   Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"ordDetailCd", KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"소속",		   Type:"Text",      Hidden:0,  Width:120,  Align:"Left",    ColMerge:0,   SaveName:"orgNm",       KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"사번",		   Type:"Text",      Hidden:0,  Width:55,   Align:"Center",  ColMerge:0,   SaveName:"sabun",       KeyField:1,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"성명",		   Type:"Text",      Hidden:0,  Width:45,   Align:"Center",  ColMerge:0,   SaveName:"name",        KeyField:1,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직책코드",	   Type:"Text",      Hidden:1,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"jikchakCd",   KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직책",		   Type:"Text",      Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"jikchakNm",   KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직위코드",	   Type:"Text",      Hidden:1,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"jikweeCd",    KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직위",		   Type:"Text",      Hidden:Number("${jwHdn}"),  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"jikweeNm",    KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직급코드",	   Type:"Text",      Hidden:1,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"jikgubCd",    KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직급",		   Type:"Text",      Hidden:Number("${jgHdn}"),  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"jikgubNm",    KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직무코드",	Type:"Text",      Hidden:1,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"jobCd",       KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직무",		Type:"Text",      Hidden:1,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"jobNm",       KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"적용\n순서",  Type:"Text",      Hidden:1,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"applySeq",        KeyField:0, Format:"Number",PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35 },
			{Header:"이력조\n회여부",  Type:"CheckBox",Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"visualYn",        KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 , TrueValue:"Y", FalseValue:"N" },
            {Header:"발령일자",    Type:"Date",      Hidden:1,   Width:80,   Align:"Center", ColMerge:0, SaveName:"ordYmd",          KeyField:1, Format:"Ymd",   PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"발령소속명",  Type:"Popup",     Hidden:0,   Width:120,  Align:"Center",  ColMerge:0,   SaveName:"ordOrgNm",    KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"발령소속코드", Type:"Text",     Hidden:1,   Width:70,   Align:"Center",  ColMerge:0, SaveName: "ordOrgCd",      KeyField:1, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100},
			{Header:"재직상태",		Type:"Text",      Hidden:1,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"statusCd",       KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"사원구분",		Type:"Text",      Hidden:1,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"manageCd",       KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"급여타입",		Type:"Text",      Hidden:1,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"payType",       KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }

		];

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
				initdata2.Cols.push({Header:"발령소속",    Type:"Text",     Hidden:1,   Width:70,   Align:"Center",  ColMerge:0, SaveName: convCamel(postItem.postItem+"_VALUE"),            KeyField:1, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100});
			}else {
				initdata2.Cols.push({Header:postItem.postItemNm,   Type:"Text",    Hidden:1,   Width:70,   Align:"Center", ColMerge:0, SaveName: convCamel(postItem.postItem+"_VALUE"),            KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:postItem.limitLength});
			}
		}
		initdata2.Cols.push({Header:"선택", Type:"DummyCheck",Hidden:0,  Width:40,   Align:"Center",  ColMerge:0,   SaveName:"select",      KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 });
        IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);
        if(grcodeCds.length>1) grcodeCds = grcodeCds.substring(1);

      //저장시 사용할 post item 별 id 값
        $("<input></input>",{id:"s_SAVENAME2",name:"s_SAVENAME2",type:"hidden"}).appendTo($("#mySheetForm"));
        $("#mySheetForm #s_SAVENAME2").val(postItemsNames);

		sheet1.ShowTreeLevel(-1);
		sheet2.SetFocusAfterProcess(false);

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");

	});

	$(document).on('input', '#chgOrdYmd', function(){
		var pattern = /[0-9]{4}\-[0-9]{2}\-[0-9]{2}/;
		if(pattern.test($(this).val())){
			doAction2("Search");
		}
	})

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/OrgAppmtMgr.do?cmd=getOrgAppmtMgrTab2OrgList", $("#mySheetForm").serialize(),1 );
			break;
		case "ProcessClear":
			$("#searchProcessNo").val("");
			$("#searchProcessTitle").val("");
			break;
		}
	}

	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			var param = "orgCd="+sheet1.GetCellValue(sheet1.GetSelectRow(),"orgCd") + "&chgOrdYmd="+$('#chgOrdYmd').val();
			sheet2.DoSearch( "${ctx}/OrgAppmtMgr.do?cmd=getOrgAppmtMgrTab2UserList", param,1 );
			break;
		case "OrgSet":
			if($("#chgOrgCd").val() == "") {
				alert("발령소속을 선택하세요.");
				return;
			}

			if(sheet2.CheckedRows("select") == 0) {
				alert("직원을 선택하세요.");
				return;
			}

			if($("#chgOrgCd").val() != sheet1.GetCellValue(sheet1.GetSelectRow(), "orgCd")) {
                for( i = 1; i <= sheet2.RowCount(); i++) {
                    if(sheet2.GetCellValue(i,"select") == 1){
                    	sheet2.SetCellValue(i, "item2Value",$("#chgOrgCd").val());
                    	sheet2.SetCellValue(i, "ordOrgNm",$("#chgOrgNm").val());
                    }
                }
			} else {
				alert("선택하신 소속이 같은 소속입니다. \n 다른 소속을 선택하세요.");
				$("#chgOrgCd").val("");
				$("#chgOrgNm").val("");
			}
			break;
		case "OrgClear":
            if(sheet2.RowCount()<=0){
                return;
            }
            if( !confirm(" 발령소속을 초기화 하시겠습니까?" ) ) {
                return;
            }
            for( i = 1; i <= sheet2.RowCount(); i++) {
               	sheet2.SetCellValue(i, "item2Value","");
               	sheet2.SetCellValue(i, "ordOrgNm","");

               	if(sheet2.GetCellValue(i,"processNo") == "") {
                   	sheet2.SetCellValue(i, "sStatus","R");
               	}
            }
			break;
		case "ProcessSet":
			if($("#searchProcessNo").val() == "") {
				alert("발령번호를 선택하세요.");
				return;
			}
			if(sheet2.CheckedRows("select") == 0) {
				alert("대상자를 선택하세요.");
				return;
			}
            for( i = 1; i <= sheet2.RowCount(); i++) {
                if(sheet2.GetCellValue(i,"select") == 1){
                	sheet2.SetCellValue(i, "processNo",$("#searchProcessNo").val());
                }
            }
			break;
		case "ProcessClear":
            if(sheet2.RowCount()<=0){
                return;
            }
            if( !confirm(" 발령번호를 초기화 하시겠습니까?" ) ) {
                return;
            }
            for( i = 1; i <= sheet2.RowCount(); i++) {
               	sheet2.SetCellValue(i, "processNo","");
               	if(sheet2.GetCellValue(i,"ordOrgCd") == "") {
                   	sheet2.SetCellValue(i, "sStatus","R");
               	}
            }
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

			if($("#searchProcessNo").val() == "") {
                alert("발령번호를 선택해 주세요.");
                return;
            }

            var param = "&chgOrdDetailCd="+$("#chgOrdDetailCd").val()
            			+"&chgOrdTypeCd="+$("#chgOrdTypeCd").val()
            			+"&chgOrdYmd="+$("#chgOrdYmd").val().replace(/-/gi,"")
            			+"&searchProcessNo="+$("#searchProcessNo").val();
			$("#chgOrdYmd").val($("#chgOrdYmd").val().replace(/-/gi,""));
			setSheet2Param();
            IBS_SaveName(document.mySheetForm,sheet2);
			sheet2.DoSave( "${ctx}/OrgAppmtMgr.do?cmd=saveOrgAppmtMgrTab2User", $("#mySheetForm").serialize());


			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			var d = new Date();
			var fName = "조직개편발령(조직이동)_" + d.getTime() + ".xlsx";
			sheet2.Down2Excel($.extend(param, { FileName:fName, SheetDesign:1, Merge:1 }));
			break;
		}
	}

	function setSheet2Param() {
		for(var i=sheet2.HeaderRows();i<sheet2.RowCount()+sheet2.HeaderRows();i++) {
			if(sheet2.GetCellValue(i,"sStatus") =="U") {
				sheet2.SetCellValue(i, "ordYmd", $("#chgOrdYmd").val());
				sheet2.SetCellValue(i, "ordDetailCd", $("#chgOrdDetailCd").val());
				sheet2.SetCellValue(i, "ordTypeCd", $("#chgTypeCd").val());

				for (var ind in postItemGrpCd) {
					if (postItemGrpCd[ind].grpCd == "") continue;
					var val = "";
					if (postItemGrpCd[ind].realCol == "ORG_CD") { //조직정보를 발령조직 정보로 전달
						val = sheet2.GetCellValue(i, "ordOrgCd");
					} else {
						val = sheet2.GetCellValue(i, convCamel(postItemGrpCd[ind].realCol));
					}
					console.log(convCamel(postItemGrpCd[ind].realCol) + " : " + val);
					if (val != "-1" && val != "") sheet2.SetCellValue(i, postItemGrpCd[ind].col, val);
				}
			}

		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 셀 변경시 발생
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		try {
			if(sheet1.GetSelectRow() > 0) {
				if(OldRow != NewRow) {
					doAction2("Search");
				}
			}
		} catch (ex) {
			alert("OnSelectCell Event Error " + ex);
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

	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			doAction2("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet2_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			if(sheet2.GetCellEditable(Row,Col) == true) {
				if(sheet2.ColSaveName(Col) == "ordOrgNm" && KeyCode == 46) {
					sheet2.SetCellValue(Row,"ordOrgCd","");
				}
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	// 팝업 클릭시 발생
	function sheet2_OnPopupClick(Row,Col) {
		try {
			if(sheet2.ColSaveName(Col) == "ordOrgNm") {
				if(!isPopup()) {return;}

				gPRow  = Row;
				pGubun = "orgTreePopup";

				showOrgPopup(Row);
	            <%--var win = openPopup("/Popup.do?cmd=orgTreePopup&authPg=${authPg}", "", "740","520");--%>
			} else if(sheet2.ColSaveName(Col) == "processNo") {
				if(!isPopup()) {return;}

				gPRow  = Row;
				pGubun = "appmtConfirmPopup";

	            var win = openPopup("/AppmtConfirmPopup.do?cmd=viewAppmtConfirmPopup&authPg=${authPg}", "", "740","520");
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
        <%--var win = openPopup("/Popup.do?cmd=orgTreePopup&authPg=${authPg}", "", "740","520");--%>
	}


	// 소속 팝업
	function showOrgPopup(row) {

		if(!isPopup()) {return;}
		gPRow = "";

		// var rst = openPopup("/Popup.do?cmd=orgTreePopup&authPg=R", "", "750","920");

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
		console.log(pGubun)
		console.log(gPRow)
		var rv = returnValue;

        if(pGubun == "searchOrgTreePopup"){
        	$("#chgOrgCd").val(rv["orgCd"]);
        	$("#chgOrgNm").val(rv["orgNm"]);
        } else if(pGubun == "searchAppmtConfirmPopup") {


        	$("#searchProcessNo").val(rv["processNo"]);
            $("#searchProcessTitle").val(rv["processTitle"]);



        } else if(pGubun == "orgTreePopup") {
        	sheet2.SetCellValue(row, "item2Value", rv["orgCd"] );
            sheet2.SetCellValue(row, "ordOrgNm", rv["orgNm"] );
        } else if(pGubun == "appmtConfirmPopup") {
            sheet2.SetCellValue(gPRow, "processNo", rv["processNo"] );
        }
	}

</script>
</head>
<body class="bodywrap">
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
					<a href="javascript:doAction2('OrgSet');" class="button">변경소속반영</a>
					<a href="javascript:doAction2('OrgClear');" class="basic authA">초기화</a>
				</td>
			</tr>
			<tr class="">
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
	<colgroup>
		<col width="300px" />
		<col width="*" />
	</colgroup>
	<tr>
		<td class="sheet_left">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt">조직개편발령</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet1", "50%", "100%", "kr"); </script>
		</td>
		<td class="sheet_right">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="btn">
						<a href="javascript:doAction2('Save');" class="basic authA">저장</a>
						<a href="javascript:doAction2('Down2Excel');" class="basic authR">다운로드</a>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet2", "50%", "100%", "kr"); </script>
		</td>
	</tr>
	</table>

</div>
</body>
</html>