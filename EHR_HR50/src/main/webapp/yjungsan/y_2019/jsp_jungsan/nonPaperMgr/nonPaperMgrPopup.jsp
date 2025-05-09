<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html><head> <title>연간소득_개별</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var templeteTitle1 = "업로드시 이 행은 삭제 합니다\n\n";
	var p = eval("<%=popUpStatus%>");
	var vsIndex = "";//업로드파일 제어를 위함
	
	
	$(function() {
		
		var arg = p.window.dialogArguments;

		var srchSabun		= "";   
		var srchAdjustType	= "";   
		var srchYear		= "";   
		var titleName		= "";
		
		/* if( arg != undefined ) {
			// opener 그리드에서 선택된 값
			srchSabun		= arg["sabun"];   
			srchAdjustType	= arg["srchAdjustType"];   
			srchYear		= arg["srchYear"];   
			titleName		= arg["titleName"];
			
		}else{ */
			srchSabun 	  	= p.popDialogArgument("sabun");
		    srchYear 	  	= p.popDialogArgument("work_yy");
		    srchAdjustType 	= p.popDialogArgument("adjust_type");
			/* srchAdjustType  = p.popDialogArgument("srchAdjustType");
			srchYear       	= p.popDialogArgument("srchYear");
			titleName 		= p.popDialogArgument("titleName"); */
		//}
		
		$("#srchYear").val( srchYear ) ;
		$("#srchSabun").val( srchSabun ) ;
		$("#srchAdjustType").val( srchAdjustType ) ; 
		
		
		$("#filepathtest").hide();
		// 1번 그리드
		var initdata1 = {};
		initdata1.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:100,MergeSheet:msHeaderOnly}; 
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata1.Cols = [
			{Header:"No",		Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },    
			{Header:"삭제",		Type:"<%=sDelTy%>",   Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},    
   			{Header:"상태",		Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},    
   		 	{Header:"성명",		Type:"Popup",	Hidden:1,  	Width:70,   Align:"Center",  	ColMerge:0,   SaveName:"name",			KeyField:0,   CalcLogic:"",   	Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"회사구분",	Type:"Text",  	Hidden:1,  	Width:100, 	Align:"Center",  	ColMerge:0,   SaveName:"enter_cd",     	KeyField:0,   CalcLogic:"",   	Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,	EditLen:100 },
			{Header:"사번",      	Type:"Text",  	Hidden:1,  	Width:80,  	Align:"Center",  	ColMerge:0,   SaveName:"sabun",      	KeyField:0,   CalcLogic:"",   	Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,	EditLen:100 },
			{Header:"귀속년도",	Type:"Text",  	Hidden:1,  	Width:100, 	Align:"Center",  	ColMerge:0,   SaveName:"work_yy",     	KeyField:0,   CalcLogic:"",   	Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,	EditLen:100 },
			{Header:"정산구분",    Type:"Combo",   Hidden:1,  	Width:100,  Align:"Center",  	ColMerge:0,   SaveName:"adjust_type",   KeyField:0,   CalcLogic:"",   	Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"파일순번",	Type:"Text",	Hidden:1,  	Width:60,	Align:"Center",		ColMerge:0,	  SaveName:"file_seq",	 	KeyField:0,	               		Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"파일구분",	Type:"Combo",  	Hidden:0,  	Width:70,	Align:"Center",  	ColMerge:0,   SaveName:"file_type",    	KeyField:1,   CalcLogic:"",   	Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,	EditLen:100 },		
			{Header:"파일경로",	 Type:"Text",   Hidden:1,  	Width:60,	Align:"Center",		ColMerge:0,	  SaveName:"file_path",     KeyField:0,	                    Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"파일명",	    Type:"Text",	Hidden:0,  	Width:100,	Align:"Center",		ColMerge:0,	  SaveName:"file_name",     KeyField:0,	                    Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			/* {Header:"사업장",		Type:"Text",  	Hidden:1,  	Width:100, 	Align:"Center",  	ColMerge:0,   SaveName:"business_place",KeyField:0,   CalcLogic:"",   	Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,	EditLen:100 }, */
			{Header:"업로드일자",  Type:"Date",  	Hidden:0,  	Width:70,	Align:"Center",  	ColMerge:0,   SaveName:"upload_date",   KeyField:0,   CalcLogic:"",   	Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,	EditLen:100, TrueValue:"Y", FalseValue:"N" },
			{Header:"다운로드",	Type:"Image",	Hidden:0,	Width:30,	Align:"Center",		ColMerge:0,	  SaveName:"help_pic2",	 	KeyField:0,	               		Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 ,Cursor:"Pointer"},
			{Header:"업로드",	    Type:"Image",	Hidden:1,	Width:60,	Align:"Center",		ColMerge:0,	  SaveName:"help_pic3",	 	KeyField:0,	               		Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 ,Cursor:"Pointer"},
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
		$("#searchAdjustType").html(adjustTypeList[2]).val("1");
		//$("#searchFileCodeList").html(fileCodeList[2]);
			
		sheet1.SetColProperty("file_type", {ComboText:"|"+fileCodeList[0], ComboCode:"|"+fileCodeList[1]});
		sheet1.SetColProperty("adjust_type", {ComboText:"|"+adjustTypeList[0], ComboCode:"|"+adjustTypeList[1]});
		sheet1.SetImageList(0,"<%=imagePath%>/icon/icon_info.png");
		
		$(window).smartresize(sheetResize); sheetInit();
        
		doAction1("Search");
		//양식다운로드 title 정의
		templeteTitle1 += "년월 : YYYY-MM   예)2013-01 \n";
	});
	
	$(function() {
		$("#srchYear").bind("keyup",function(event){
			if( event.keyCode == 13){ 
				doAction1("Search"); 
				$(this).focus();
			}
		});
		
		//Cancel 버튼 처리 
		$(".close").click(function(){
			p.self.close(); 
		});
	});

    //Sheet Action1
    function doAction1(sAction) {
        switch (sAction) {
        case "Search":
			sheet1.DoSearch( "<%=jspPath%>/nonPaperMgr/nonPaperMgrRst.jsp?cmd=selectNonPaperMgrStPopList", $("#srchFrm").serialize() );
        	break;
        case "Save":
			// 중복체크
			//if (!dupChk(sheet1, "work_yy|adjust_type|sabun|ym", true, true)) {break;}
        	sheet1.DoSave("<%=jspPath%>/nonPaperMgr/nonPaperMgrRst.jsp?cmd=saveNonPaperPopMgr");

        	break;
        case "Insert":    
        	
        	var vsInsertCheck = sheet1.FindStatusRow("I");
        	
        	if(vsInsertCheck != null && vsInsertCheck != ""){
        		
        		alert("입력 중인 파일이 존재합니다.");
        		break;
        	}
        	
       		var newRow = sheet1.DataInsert(-1);
       		
    		$('#fileUploadFrame').contents().find('#uploadSabun').val($("#srchSabun").val());
    		$('#fileUploadFrame').contents().find('#uploadAdjustType').val($("#srchAdjustType").val());	
    		$('#fileUploadFrame').contents().find('#uploadYear').val($("#srchYear").val());
    		//파일명을 만들기위한 값세팅
    		
       		$('#fileUploadFrame').contents().find('#fileNm').click();//파일업로드 버튼클릭
       		
       		vsIndex = newRow;//업로드될 로우의 값을 저장
       		
        	sheet1.SetCellValue(newRow, "work_yy"    , $("#srchYear").val()); 
        	sheet1.SetCellValue(newRow, "sabun"      , $("#srchSabun").val()); 
        	sheet1.SetCellValue(newRow, "adjust_type", $("#srchAdjustType").val()); 
        	sheet1.SetCellValue(newRow, "sStatus"    ,		"I");
        	
        	break;
        case "Copy":        
        	sheet1.DataCopy();
        	break;
        case "Clear":
        	sheet1.RemoveAll(); 
        	break;
        /* case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param); 
			break;
        case "Down2Template":
			var param  = {DownCols:"6|7|8|9|10|11|12|14|15|16|17|18|19|20|21|22|23|25|26|27|28|29|30|31|40",SheetDesign:1,Merge:1,DownRows:'0',ExcelFontSize:"9"
				,TitleText:templeteTitle1,UserMerge :"0,0,1,24"};
			sheet1.Down2Excel(param); 
			break;
        case "LoadExcel":  
        	doAction1("Clear") ; 
        	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; 
        	sheet1.LoadExcel(params);
        	break; */
        }
    }

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { 
			alertMessage(Code, Msg, StCode, StMsg);
			if(Code == 1) {
				doAction1('Search'); 
			}
		} catch(ex) { 
			alert("OnSaveEnd Event Error " + ex); 
		}
	}
	
	function callbackGetFilePath(){
	//업로드된 경로를 가져옴	
		var vsFileName = $('#fileUploadFrame').contents().find("#saveFileName").val();
		var vsFilePath = $('#fileUploadFrame').contents().find("#saveFilePath").val();
	    sheet1.SetCellValue(vsIndex, "file_path", vsFilePath);
	    sheet1.SetCellValue(vsIndex, "file_name", vsFileName);
		$("#saveFilePath").val(vsFilePath);
	}
	

	// 로드 후 메시지
	function sheet1_OnLoadExcel() { 
		//엑셀로부터 업로드 된 데이터에 대하여 히든 key값을 세팅한다.
		for(var i = 1; i < sheet1.RowCount()+1; i++) {
			if( sheet1.GetCellValue(i, "sStatus") == "I") {
        		sheet1.SetCellValue(i, "work_yy",		$("#srchYear").val()); 
        		sheet1.SetCellValue(i, "adjust_type",	$("#srchAdjustType").val()); 
        		sheet1.SetCellValue(i, "sabun",			$("#srchSabun").val()); 
			}
		}
	}	
		
	function setValue() {
		var rv = new Array(1);

		rv["closeFlag"] = true ;                             
		
		//p.window.returnValue = rv;     
		if(p.popReturnValue) p.popReturnValue(rv);
		p.window.close(); 
	}
	
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		//if(sheet1.GetCellValue(Row, "sStatus") != "I") {
			try{
			    if(Row > 0 && sheet1.ColSaveName(Col) == "help_pic2"){
			    	//다운로드 아이콘 클릭
			    	var browser = "";
			    	var vsActionUrl = "";
			    	var vsFilePath = sheet1.GetCellValue(Row, "file_path");
			    	var vsencPath = encodeURIComponent(vsFilePath);
			    	var filename = sheet1.GetCellValue(Row, "file_name");
			    	var agent = navigator.userAgent.toLowerCase(); 
			    	
			    // MS 계열 브라우저를 구분하기 위함.
			     if( agent.indexOf('trident') > -1 || agent.indexOf('edge/') > -1) {
			        browser = 'ie';
			        //if(name === 'Microsoft Internet Explorer') { // IE old version (IE 10 or Lower)
			            //agent = /msie ([0-9]{1,}[\.0-9]{0,})/.exec(agent);
			            //browser += parseInt(agent[1]);
			        //} else { // IE 11+
			            //if(agent.indexOf('trident') > -1) { // IE 11 
			                //browser += 11;
			            	//agent = /msie ([0-9]{1,}[\.0-9]{0,})/.exec(agent);
				           // browser += parseInt(agent[1]);
			            //} else 
			            if(agent.indexOf('edge/') > -1) { // Edge
			                browser = 'edge';
	                    }
			        //}
			    } else if(agent.indexOf('safari') > -1) { // Chrome or Safari
			        if(agent.indexOf('opr') > -1) { // Opera
			            browser = 'opera';
			        } else if(agent.indexOf('chrome') > -1) { // Chrome
			            browser = 'chrome';
			        } else { // Safari
			            browser = 'safari';
			        }
			    } else if(agent.indexOf('firefox') > -1) { // Firefox
			        browser = 'firefox';
			    }
				

		    	if(browser.indexOf('ie') > -1 || browser.indexOf('edge') > -1){

		    		vsActionUrl = encodeURI("nonPaperFileUploadMgr.jsp?updownFlag=DOWN&downFilePath="+vsencPath+"&downFileName="+filename);
		    		
		    	}else{
		    		
		    		vsActionUrl = "nonPaperFileUploadMgr.jsp?updownFlag=DOWN&downFilePath="+vsencPath+"&downFileName="+filename;
		    	}
		    	//브라우저 버전별 인코딩

					//파일 다운로드 플래그정의 updownFlag
			    	$('#fileUploadFrame').contents().find("#srchFrm1").attr("action", vsActionUrl);
			    	//프레임내의 폼을 서브밋시킴 (컨트롤러이동)
					$('#fileUploadFrame').contents().find("#srchFrm1").submit();
			    	
			    }
			} catch(ex) {
				alert("OnSelectCell Event Error : " + ex);
			}
		//}
	}
	
</script>
</head>
<body class="bodywrap" style="overflow-y: auto;">
<div class="wrapper">
	<div class="popup_title">
	<ul>
		<li>증빙자료관리<font color="purple"><!-- &nbsp;&nbsp;-&nbsp;&nbsp;<span id="titleName"></span>님--></font></li>
		<!--<li class="close"></li>-->
	</ul>
	</div>
	<form id="srchFrm" name="srchFrm">
	    <input id="srchSabun"      name="srchSabun" type="hidden" value ="" />
		<input id="srchYear"       name="srchYear" type="hidden" value=""/>
		<input id="srchAdjustType" name="srchAdjustType" type="hidden" value=""/>
		<input id="saveFilePath"   name="saveFilePath" type="hidden" value=""/>
		<input id="pgAuth"         name="pgAuth" type="hidden" value="<%=authPg%>"/>
	</form>
	<iframe id="fileUploadFrame" src="nonPapeFileUpload.jsp" height="100px" width="200px" scrolling="no" style="display: none;">
	</iframe>
	<div class="popup_main">
		<div>
			<div class="outer">
				<div class="sheet_title">
		        <ul>
		            <li class="txt">증빙자료관리</li>
		            <li class="btn">
		              <a href="javascript:doAction1('Insert')"   class="basic authA"> 입력</a>
		              <a href="javascript:doAction1('Save')"   class="basic authA">저장</a>
		            </li>
		        </ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet1", "100%", "400px"); </script>			
		</div>
		<div class="popup_button outer">
		<ul>
			<li>
				<a href="javascript:setValue();" class="pink large">확인</a>
				<a href="javascript:p.self.close();" class="gray large">닫기</a>
			</li>
		</ul>
		</div>
	</div>
</div>
</body>
</html>