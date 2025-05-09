<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>소득공제서</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<script type="text/javascript">

	$(function() {

		$("#srchYear").val("<%=yeaYear%>") ;
		//searchWorkYy

		var initdata1 = {};
		initdata1.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:100,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata1.Cols = [
			{Header:"No",		Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
			{Header:"삭제",		Type:"<%=sDelTy%>",   Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
   			{Header:"상태",		Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
   		 	{Header:"성명",		Type:"Popup",	Hidden:0,  	Width:70,   Align:"Center",  	ColMerge:0,   SaveName:"name",			KeyField:1,   CalcLogic:"",   	Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"사번",      	Type:"Text",  	Hidden:0,  	Width:70,  	Align:"Center",  	ColMerge:0,   SaveName:"sabun",      	KeyField:1,   CalcLogic:"",   	Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,	EditLen:100 },
			{Header:"회사구분",	Type:"Text",  	Hidden:1,  	Width:100, 	Align:"Center",  	ColMerge:0,   SaveName:"enter_cd",     	KeyField:0,   CalcLogic:"",   	Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,	EditLen:100 },
			{Header:"사업장",		Type:"Text",  	Hidden:1,  	Width:100, 	Align:"Center",  	ColMerge:0,   SaveName:"business_place",KeyField:0,   CalcLogic:"",   	Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,	EditLen:100 },
			{Header:"귀속년도",	Type:"Text",  	Hidden:1,  	Width:100, 	Align:"Center",  	ColMerge:0,   SaveName:"work_yy",     	KeyField:0,   CalcLogic:"",   	Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,	EditLen:100 },
			{Header:"정산구분",    Type:"Combo",   Hidden:0,  	Width:70,  Align:"Center",  	ColMerge:0,   SaveName:"adjust_type",   KeyField:1,   CalcLogic:"",   	Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"파일순번",	Type:"Text",	Hidden:1,  	Width:60,	Align:"Center",		ColMerge:0,	  SaveName:"file_seq",	 	KeyField:0,	               		Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"파일구분",	Type:"Combo",  	Hidden:1,  	Width:70,	Align:"Center",  	ColMerge:0,   SaveName:"file_type",    	KeyField:0,   CalcLogic:"",   	Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,	EditLen:100 },
			{Header:"파일경로",	Type:"Combo",  	Hidden:1,  	Width:70,	Align:"Center",  	ColMerge:0,   SaveName:"file_path_name",KeyField:0,   CalcLogic:"",   	Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,	EditLen:100 },
			{Header:"파일명",		Type:"Combo",  	Hidden:1,  	Width:70,	Align:"Center",  	ColMerge:0,   SaveName:"file_name",KeyField:0,   CalcLogic:"",   	Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,	EditLen:100 },
			{Header:"업로드일자",  Type:"Date",  	Hidden:1,  	Width:70,	Align:"Center",  	ColMerge:0,   SaveName:"upload_date",   KeyField:0,   CalcLogic:"",   	Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,	EditLen:100 },
			{Header:"증빙자료",	Type:"Image",	Hidden:0,	Width:60,	Align:"Center",		ColMerge:0,	  SaveName:"help_pic",	 	KeyField:0,	               		Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 ,Cursor:"Pointer"},
			{Header:"ATTR1",	Type:"Text",	Hidden:1,	Width:90,	Align:"Center",		ColMerge:0,	  SaveName:"attr1",	 		KeyField:0,	               		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"ATTR2",	Type:"Text",	Hidden:1,	Width:90,	Align:"Center",		ColMerge:0,	  SaveName:"attr2",	 		KeyField:0,	               		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"ATTR3",	Type:"Text",	Hidden:1,	Width:90,	Align:"Center",		ColMerge:0,	  SaveName:"attr3",	 		KeyField:0,	               		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"ATTR4",	Type:"Text",	Hidden:1,	Width:90,	Align:"Center",		ColMerge:0,	  SaveName:"attr4",	 		KeyField:0,	               		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"최종수정시간",	Type:"Text",	Hidden:1,	Width:60,	Align:"Center",		ColMerge:0,	  SaveName:"chkdate",		KeyField:0,	               		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"최종수정자", 	Type:"Html",	Hidden:1,	Width:70,	Align:"Center",		ColMerge:0,	  SaveName:"chkid",	 		KeyField:0,	               		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100}
        ]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var adjustTypeList 	= stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00303"), "전체");
		var fileCodeList 	= stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","YEA001"), "전체");
	    var bizPlaceCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList","getBizPlaceCdList") , "전체");

		$("#searchBusinessPlaceCd").html(bizPlaceCdList[2]);
		//$("#searchAdjustType").html(adjustTypeList[2]).val("1");
		$("#searchAdjustType").html(adjustTypeList[2]).val("1");
		//$("#searchFileCodeList").html(fileCodeList[2]);

		sheet1.SetColProperty("file_type", {ComboText:"|"+fileCodeList[0], ComboCode:"|"+fileCodeList[1]});
		sheet1.SetColProperty("adjust_type", {ComboText:"|"+adjustTypeList[0], ComboCode:"|"+adjustTypeList[1]});
		sheet1.SetImageList(0,"<%=imagePath%>/icon/icon_info.png");

		$(window).smartresize(sheetResize); sheetInit();

		doAction2("Search");
	});

	$(function() {
		$("#srchYear").bind("keyup",function(event){
			makeNumber(this,"A");
			if( event.keyCode == 13){
				doAction2("Search");
				$(this).focus();
			}
		});
	});

	$(function() {
		$("#searchSbNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction2("Search");
				$(this).focus();
			}
		});
	});

    function doAction2(sAction) {
        switch (sAction) {
        case "Search":
        	if($("#srchYear").val() == "") {
        		alert("대상년도를 입력하여 주십시오.");
        		return;
        	}else if($("#searchSbNm").val().length == ""){
   				return;
   			}
        	sheet1.DoSearch( "<%=jspPath%>/nonPaperMgr/nonPaperMgrRst.jsp?cmd=selectNonPaperMgrStList", $("#srchFrm").serialize() );
        	break;
        }
    }

    //Sheet Action First
    function doAction1(sAction) {
        switch (sAction) {
        case "Search":
        	if($("#srchYear").val() == "") {
        		$("#srchYear").focus();
        		alert("대상년도를 입력하여 주십시오.");
        		return;
        	}
        	sheet1.DoSearch( "<%=jspPath%>/nonPaperMgr/nonPaperMgrRst.jsp?cmd=selectNonPaperMgrStList", $("#srchFrm").serialize() );
        	break;
        case "Save":

        	var vsDelStatus = "";

        	for(var i=1; i <= sheet1.GetTotalRows(); i++){

        		if(sheet1.GetCellValue(i, "sStatus") == "D"){

        			vsDelStatus = "D";

        			continue;
        		}

        	}

        	if(vsDelStatus == "D" && !confirm("삭제하시면 증빙자료도 같이 삭제 됩니다.\n 삭제하시겠습니까?")) break;

        	sheet1.DoSave( "<%=jspPath%>/nonPaperMgr/nonPaperMgrRst.jsp?cmd=save");
        	break;
        case "Insert":
   			if($("#srchYear").val() == ""){
   				alert("대상년도를 입력하여 주십시오.");
        		return;
   			}else if($("#srchYear").val().length != 4){
   				alert("대상년도를 4자리로 입력하여 주십시오.");
   				return;
   			}else if($("#srchYear").val().length == 4){
   				var newRow = sheet1.DataInsert(0);
   	        	sheet1.SetCellValue(newRow, "work_yy", $("#srchYear").val());
   	        	sheet1.SetCellValue(newRow, "adjust_type", $("#srchAdjustType").val() ) ;
   			}
        	break;
        case "Copy":
        	sheet1.DataCopy();
        	break;
        case "Clear":
        	sheet1.RemoveAll();
        	break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param);
			break;
        case "LoadExcel":
			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet1.LoadExcel(params);
			break;
        }
    }


	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			sheetResize();
			if(Code == 1 && sheet1.SearchRows() == 0) {
				//doAction1('Search');
			}
		} catch(ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			if(Code == 1) {
				doAction1("Search");
			}
		} catch(ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 조회 후 에러 메시지
    function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try {
			alertMessage(Code, Msg, StCode, StMsg);
			sheetResize();
        } catch(ex) {
        	alert("OnSearchEnd Event Error : " + ex);
        }
    }


	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		if(sheet1.GetCellValue(Row, "sStatus") != "I") {
					try{
					    if(Row > 0 && sheet1.ColSaveName(Col) == "help_pic"){
					    	nonPaperMgrPopup(Row);
					    }
					} catch(ex) {
						alert("OnSelectCell Event Error : " + ex);
					}
		}
		 else{
			try{
				if (Row > 0 && sheet1.ColSaveName(Col) == "name"){
			    	openEmployeePopup(Row) ;
			    }
			} catch(ex) {
				alert("OnSelectCell Event Error : " + ex);
			}

		}
	}

	//팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
			if(sheet1.ColSaveName(Col) == "name") {
				openEmployeePopup(Row) ;
			}
		} catch(ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}

	//사원 조회
	function openEmployeePopup(Row){
	    try{
		    var args    = new Array();

		    if(!isPopup()) {return;}
		    gPRow = Row;
		    pGubun = "employeePopup";

		    var rv = openPopup("<%=jspPath%>/common/employeePopup.jsp?authPg=<%=authPg%>", args, "740","520");
	    } catch(ex) {
	    	alert("Open Popup Event Error : " + ex);
	    }
	}

		function getReturnValue(returnValue) {

			var rv = $.parseJSON('{'+ returnValue+'}');

			if ( pGubun == "employeePopup" ){
				//사원조회
				sheet1.SetCellValue(gPRow, "name", 		rv["name"] );
				sheet1.SetCellValue(gPRow, "sabun", 	rv["sabun"] );
			}
		}



	/**
	 *  도움말 window open event
	 */
	function nonPaperMgrPopup(Row){

  		var w 		= 800;
		var h 		= 605;
		var url 	= "<%=jspPath%>/nonPaperMgr/nonPaperMgrPopup.jsp?authPg=<%=authPg%>";
		var args 	= new Array();
		args["sabun"] 			= sheet1.GetCellValue(Row, "sabun");
		args["adjust_type"] 	= sheet1.GetCellValue(Row, "adjust_type");
		args["work_yy"] 		= $("#srchYear").val();

		//args["sheet1"]          = sheet1;

			if(!isPopup()) {return;}
			openPopup(url,args,w,h);

		//var rv = openPopup(url,args,w,h);
		/*
		if(rv!=null){
			sheet1.SetCellValue(Row, "work_yy", 		rv["workYy"] );
			sheet1.SetCellValue(Row, "adj_process_cd", 	rv["adjProcessCd"] );
			sheet1.SetCellValue(Row, "adj_process_nm", 	rv["adjProcessNm"] );
			sheet1.SetCellValue(Row, "seq", 			rv["seq"] );
			sheet1.SetCellValue(Row, "help_text1", 		rv["helpText1"] );
			sheet1.SetCellValue(Row, "help_text2", 		rv["helpText2"] );
			sheet1.SetCellValue(Row, "help_text3", 		rv["helpText3"] );
			//if( sheet1.GetCellValue(Row, "sStatus") != "R" )//변경시에만 저장 로직
				//doAction1("Save") ;
		}
		*/
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
    <form id="srchFrm" name="srchFrm">
    <div class="sheet_search outer">
        <div>
        <table>
	        <tr>
	            <td>
	            	<span>귀속</span>
					<input id="srchYear" name ="srchYear" type="text" class="text" maxlength="4" style="width:35px"/>
					<span>년</span>
				</td>
	            <td>
					<span>작업구분</span>
					<select id="searchAdjustType" name ="searchAdjustType" class="box"></select>
				</td>
				<td>
					<span>사업장</span>
					<select id="searchBusinessPlaceCd" name ="searchBusinessPlaceCd" onChange="" class="box"></select>
				</td>
				<td>
					<span>사번/성명</span>
					<input id="searchSbNm" name ="searchSbNm" type="text" class="text w60"/>
				</td>
				<td>
					<a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a>
				</td>
	        </tr>
        </table>
        </div>
    </div>
    </form>

    <div class="inner">
        <div class="sheet_title">
        <ul>
            <li class="txt">증빙자료관리</li>
            <li class="btn">
              <a href="javascript:doAction1('Insert')" class="basic authA">입력</a>
              <a href="javascript:doAction1('Copy')"   class="basic authA">복사</a>
              <a href="javascript:doAction1('Save')"   class="basic authA">저장</a>
              <a href="javascript:doAction1('Down2Excel')"   class="basic authR">다운로드</a>
            </li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>


</div>
</body>
</html>