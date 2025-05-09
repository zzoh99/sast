<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html> <html><head> <title>주소변경</title>
<%@ page import="yjungsan.util.*"%>
<%@ page import="java.util.Map"%>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("<%=popUpStatus%>");

	$(function() {
		var arg = p.window.dialogArguments;

		if( arg != undefined ) {
			$("#sabun").val(arg["sabun"]);
			$("#add_type").val(arg["add_type"]);
			$("#authPg").val(arg["authPg"]);
		}else{
			var sabun     = "";
			var add_type     = "";
			var authPg     = "";
			
			sabun 	  = p.popDialogArgument("sabun");
			add_type 	  = p.popDialogArgument("add_type");
			authPg 	  = p.popDialogArgument("authPg");
			
			$("#sabun").val(sabun);
			$("#add_type").val(add_type);
			$("#authPg").val(authPg);
		}
		
		if($("#authPg").val() == 'R'){
			$("a#submitBtn").hide();
			$("a#updateBtn").show();
		}else{
			$("a#submitBtn").show();
			$("a#updateBtn").hide();
		}

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, DataRowMerge:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata1.Cols = [
    		 {Header:"No",		        Type:"<%=sNoTy%>",	Hidden:<%=sNoHdn%>,	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:1,	SaveName:"sNo" }
 			,{Header:"상태",				Type:"<%=sSttTy%>",	Hidden:1, Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 }
    		,{Header:"사번", 				Type:"Text",     Hidden:1,  Width:40,  Align:"Left",    	ColMerge:0,   SaveName:"sabun",  	KeyField:0,   CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 }
            ,{Header:"주소종류", 			Type:"Combo",    Hidden:0,  Width:40,  Align:"Center",    	ColMerge:0,   SaveName:"add_type",  KeyField:0,   CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 }
            ,{Header:"우편번호", 			Type:"Text",     Hidden:0,  Width:40,  	Align:"Center",    	ColMerge:0,   SaveName:"zip",  		KeyField:0,   CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 }
            ,{Header:"주소", 				Type:"Text",     Hidden:0,  Width:100,  Align:"Left",    	ColMerge:0,   SaveName:"addr1",  	KeyField:0,   CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
            ,{Header:"변경\n우편번호", 		Type:"Popup",     Hidden:0,  Width:40, 	Align:"Center",    	ColMerge:0,   SaveName:"mod_zip",  		KeyField:0,   CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:10 }
            ,{Header:"변경\n주소", 		Type:"Text",     Hidden:0,  Width:100,  Align:"Left",    	ColMerge:0,   SaveName:"mod_addr1",  	KeyField:0,   CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:100 }
        ];IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(true);sheet1.SetCountPosition(4);

        var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, DataRowMerge:0};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata2.Cols = [
             {Header:"우편번호", 			Type:"Text",     Hidden:0,  Width:50,  	Align:"Center",    	ColMerge:0,   SaveName:"zip",  		KeyField:0,   CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 }
            ,{Header:"주소", 				Type:"Text",     Hidden:0,  Width:200,  Align:"Left",    	ColMerge:0,   SaveName:"addr1",  	KeyField:0,   CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 }
            ,{Header:"반영",				Type:"Image",	 Hidden:0,	Width:20,	Align:"Center",		ColMerge:0,	  SaveName:"set_value",		Sort:0, Cursor:"Pointer"}
        ];IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable(false);sheet2.SetCountPosition(4);
        sheet2.SetImageList(0,"<%=imagePath%>/icon/icon_up.png");

        var addTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList", "H20185"), "전체" );

		sheet1.SetColProperty("add_type", 	{ComboText:"|"+addTypeList[0], ComboCode:"|"+addTypeList[1]});

		$("#add_type").html(addTypeList[2]);

	    $(window).smartresize(sheetResize); sheetInit();
	    doAction("Search");

	    $(".close").click(function() {
	    	p.self.close();
	    });
	});

	/*Sheet Action*/
	function doAction(sAction) {
		switch (sAction) {
		case "Search": 		//조회
			sheet1.DoSearch( "<%=jspPath%>/chgAddress/chgAddressRst.jsp?cmd=getChgAddressPopupList", $("#sheetForm").serialize() );
			break;
		case "Save":
			for(i	= 1; i<=sheet1.LastRow(); i++)	{
				if(sheet1.GetCellValue(i,"mod_zip") == "" || sheet1.GetCellValue(i,"mod_addr1") == ""){
					alert("변경되지 않은 주소정보가 존재합니다. 제출할 수 없습니다.")
					return;
				}
				sheet1.SetCellValue(i,"sStatus","U");
			}
			sheet1.DoSave("<%=jspPath%>/chgAddress/chgAddressRst.jsp?cmd=saveChgAddress");
			break;
		}
    }

	/*Sheet Action*/
	function doAction2(sAction) {
		switch (sAction) {
		case "Search": 		//조회
			sheet2.DoSearch( "<%=jspPath%>/chgAddress/chgAddressRst.jsp?cmd=getAddressMappingList", $("#mappingForm").serialize() );
			break;
		}
    }

	//조회 후 에러 메시지 
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
			if(sheet1.ColSaveName(Col) == "mod_zip") {
				openZipPopup(Row) ;
			}
		} catch(ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}
	
	//저장 후 에러 메시지 
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg){
		try{
			alertMessage(Code, Msg, StCode, StMsg);
			if(Code == 1) {
				p.self.close();
			}
		}catch(ex){alert("OnSaveEnd	Event Error	: "	+ ex);}
	}
	
	function sheet2_OnClick(Row, Col, Value) {
		try{
			if(sheet2.ColSaveName(Col) == "set_value" && Col != 0){
				setResultAddress();
			}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}
	
	var gPRow  = "";
	var pGubun = "";
	// 주소 조회
	function openZipPopup(Row){
	    try{
	    
	    	if(!isPopup()) {return;}
	    	gPRow  = Row;
			pGubun = "zipPopup";
			
		    var args    = new Array();
		    openPopup("<%=jspPath%>/common/zipCodePopup.jsp", "", "740","620");

	    } catch(ex) {
	    	alert("Open Popup Event Error : " + ex);
	    }
	}
	
	//매핑실행
	function mappingAddress(){
		var selectRow = sheet1.GetSelectRow();
		var selectAddr = sheet1.GetCellValue(selectRow,"addr1");
		
		$("#selectAddr").val(selectAddr);
		doAction2("Search");
	}
	
	//변경주소 반영
	function setValue(){
		var arrayList = new Array();

		var selectRow = sheet1.GetSelectRow();
		arrayList["zip"] = sheet1.GetCellValue(selectRow,"mod_zip");
	    arrayList["addr1"] = sheet1.GetCellValue(selectRow,"mod_addr1");

	    p.popReturnValue(arrayList);
	    p.self.close();
	}

	//변환주소 반영
	function setResultAddress(){
		var selectRow = sheet2.GetSelectRow();
		var selectZip = sheet2.GetCellValue(selectRow,"zip");
		var selectAddr = sheet2.GetCellValue(selectRow,"addr1");
		
    	var selectRow = sheet1.GetSelectRow();
    	sheet1.SetCellValue(selectRow, "mod_zip", selectZip);
		sheet1.SetCellValue(selectRow, "mod_addr1", selectAddr);		

	}
	
	function getReturnValue(returnValue) {
       	var rv = $.parseJSON('{' + returnValue+ '}');

        if(pGubun == "zipPopup"){
        	sheet1.SetCellValue(gPRow, "mod_zip", rv["0"]);
    		sheet1.SetCellValue(gPRow, "mod_addr1", rv["1"]);
        }
        
	}
	
</script>

</head>
<body class="bodywrap">

	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li>변경대상 주소</li>
				<!--<li class="close"></li>-->
			</ul>
		</div>
		<form id="sheetForm" name="sheetForm" >
			<input type="hidden" id="sabun" name="sabun" value="" />
			<input type="hidden" id="add_type" name="add_type" value="" />
			<input type="hidden" id="authPg" name="authPg" value="" />
		</form>
		<form id="mappingForm" name="mappingForm" >
			<input type="hidden" id="selectAddr" name="selectAddr" value="" />
		</form>
        <div class="popup_main">

			<div class="outer">
				<script type="text/javascript">createIBSheet("sheet1", "100%", "160px"); </script>
			</div>
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li id="txt" class="txt">변환결과</li>
					<li class="btn">
						<a href="javascript:mappingAddress();" 	class="basic">변환</a>
					</li>
				</ul>
				</div>
			</div>
			<div class="outer">
				<script type="text/javascript">createIBSheet("sheet2", "100%", "250px"); </script>
			</div>

        </div>
		<div class="popup_button outer">
			<ul>
				<li>
					<a id="submitBtn" href="javascript:doAction('Save');" class="green large">제출</a>
					<a id="updateBtn" href="javascript:setValue();" class="blue large">반영</a>
					<a href="javascript:p.self.close();" class="gray large">닫기</a>
				</li>
			</ul>
		</div>
	</div>
</body>
</html>
