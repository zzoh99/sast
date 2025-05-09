<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head><title>권한범위사용자관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";
	var sheet3Row=-1;

	$(function() {
		$(".setBtn").hide(); //범위설정 저장 버틈 숨김

		//권한그룹 콤보
		var searchGrpCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&queryId=getAuthScopeUserMgrGrpList","",false).codeList, "");
		$("#searchGrpCd").html(searchGrpCdList[2]);

		//조회조건 이벤트
		$("#searchGrpCd").bind("change",function(event){
			doAction1("Search"); 
			
		});
		//조회조건 이벤트
		$("#searchSabunName").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search"); $(this).focus();
			}
		});
		//Sheet 초기화
		inist_sheet1();
		inist_sheet2();
		inist_sheet3();
		inist_sheet4();

		$(window).smartresize(sheetResize); sheetInit();
		
		doAction1("Search"); 

	});
	
	function inist_sheet1(){

		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22, FrozenColRight:3};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo'           mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete'       mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='statusCd'      mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	SaveName:"sStatus",	Sort:0 },

			{Header:"<sht:txt mid='sabun'         mdef='사번'/>",		Type:"Text",      	Hidden:0,  Width:60,   Align:"Center",  SaveName:"sabun",       KeyField:1,   Format:"", UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='name'          mdef='성명'/>",		Type:"PopupEdit",   Hidden:0,  Width:60,   Align:"Center",  SaveName:"name",        KeyField:0,   Format:"", UpdateEdit:0,   InsertEdit:1 },
			{Header:"<sht:txt mid='jikgubNm'      mdef='직급'/>",		Type:"Text", 		Hidden:Number("${jgHdn}"),  Width:60,   Align:"Center",  SaveName:"jikgubNm",    KeyField:0,   Format:"", UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='orgNmV8'       mdef='부서'/>",		Type:"Text",      	Hidden:0,  Width:100,  Align:"Left",    SaveName:"orgNm",       KeyField:0,   Format:"", UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='dataRwTypeV1'  mdef='데이터권한'/>",	Type:"Combo",     	Hidden:0,  Width:70,   Align:"Center",  SaveName:"dataRwType",  KeyField:0,   Format:"", UpdateEdit:1,   InsertEdit:1 },
			{Header:"<sht:txt mid='searchTypeV1'  mdef='조회구분'/>",		Type:"Combo",     	Hidden:0,  Width:70,   Align:"Center",  SaveName:"searchType",  KeyField:0,   Format:"", UpdateEdit:1,   InsertEdit:1 },
			{Header:"<sht:txt mid='L190911000073' mdef='대상\n보기' />",	Type:"Image",     	Hidden:0,  Width:45,   Align:"Center",  SaveName:"btnView",    	KeyField:0,   Format:"", UpdateEdit:0,   InsertEdit:0, Cursor:"Pointer" },
			{Header:"<sht:txt mid='L190911000074' mdef='범위\n설정' />",	Type:"Image",     	Hidden:0,  Width:45,   Align:"Center",  SaveName:"btnSet",    	KeyField:0,   Format:"", UpdateEdit:0,   InsertEdit:0, Cursor:"Pointer", BackColor:"#ffffb9" },
			
			{Header:"Hidden", Type:"Text", Hidden:1, SaveName:"grpCd"},
		
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		sheet1.SetImageList(0,"${ctx}/common/images	/icon/icon_write.png");
		sheet1.SetImageList(1,"${ctx}/common/images/icon/icon_preview.png");
		 
		sheet1.SetColProperty("dataRwType", {ComboText:"<sht:txt mid='dataRwTypeV3' mdef='읽기/쓰기|읽기'/>", ComboCode:"A|R"} );
		sheet1.SetColProperty("searchType", {ComboText:"<sht:txt mid='searchTypeV4' mdef='자신만조회|권한범위적용|전사'/>", ComboCode:"P|O|A"} );

		//Autocomplete	
		$(sheet1).sheetAutocomplete({
			Columns: [{   ColSaveName : "name" 
					    , CallbackFunc: function(returnValue){
		      				var rv = $.parseJSON('{' + returnValue+ '}');
		      				sheet1.SetCellValue(gPRow, "sabun", rv["sabun"]);
		      				sheet1.SetCellValue(gPRow, "name", 	rv["name"]);
		      				sheet1.SetCellValue(gPRow, "jikgubNm", 	rv["jikgubNm"]);
		      				sheet1.SetCellValue(gPRow, "orgNm", 	rv["orgNm"]);
		  				  }
			          }]
		});
		
	}

	function inist_sheet2(){
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sDelete'      mdef='삭제' />",	Type:"${sDelTy}", 	Hidden:1,  Width:"${sDelWdt}",  Align:"Center",  SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus'      mdef='상태' />",	Type:"${sSttTy}",	Hidden:1,  Width:"${sSttWdt}",	Align:"Center",	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='sabunOrgNmV1' mdef='조직명' />",	Type:"Text", 		Hidden:0,  Width:200, Align:"Left",    SaveName:"scopeValueNm",  KeyField:0, UpdateEdit:0,   InsertEdit:0, TreeCol:1 },
			{Header:"<sht:txt mid='sDeleteV3'    mdef='등록' />",	Type:"CheckBox",  	Hidden:0,  Width:45,  Align:"Center",  SaveName:"chk",        	 KeyField:0, UpdateEdit:1,   InsertEdit:0  },
			
			{Header:"상위소속코드", Type:"Text", Hidden:1, SaveName:"scopeValueTop"},
			{Header:"조직코드",	 Type:"Text", Hidden:1, SaveName:"scopeValue"}
		]; 
		IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(false);sheet2.SetCountPosition(4);
		sheet2.SetFocusAfterProcess(0);

	}

	function inist_sheet3(){
		
		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, DataRowMerge:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"선택",			Type:"Radio",  		Hidden:1,  Width:40,  	Align:"Center",  SaveName:"sel" },
			{Header:"<sht:txt mid='L190911000075' mdef='범위선택' />", 	Type:"Text",     	Hidden:0,  Width:90,  	Align:"Center",  SaveName:"authScopeNm" },
			{Header:"등록",			Type:"CheckBox",  	Hidden:1,  Width:35,  	Align:"Center",  SaveName:"useYn",  TrueValue:"Y",  FalseValue:"N"},
			
			{Header:"범위코드", 		Type:"Text",     	Hidden:1,  Width:0,    	Align:"Left",    SaveName:"authScopeCd"},
			{Header:"범위적용구분", 	Type:"Text",    	Hidden:1,  Width:0,    	Align:"Center",  SaveName:"scopeType"},
			{Header:"프로그램URL", 	Type:"Text",     	Hidden:1,  Width:0,    	Align:"Left",    SaveName:"prgUrl"},
			{Header:"SQL문", 		Type:"Text",      	Hidden:1,  Width:0,    	Align:"Left",    SaveName:"sqlSyntax"},
			{Header:"필드명", 		Type:"Text",      	Hidden:1,  Width:0,    	Align:"Left",    SaveName:"tableNm" }
		]; 
		IBS_InitSheet(sheet3, initdata);sheet3.SetEditable(false);sheet3.SetVisible(false);
		sheet3.SetEditableColorDiff(0); 
		//sheet3.SetFocusAfterProcess(0);
		sheet3.SetDataAlternateBackColor(sheet3.GetDataBackColor()); //홀짝 배경색 같게

		sheet3.SetDataRowHeight(60);
		
	}

	function inist_sheet4(){

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",			Type:"${sNoTy}",  	Hidden:0,  Width:45,  	Align:"Center",  SaveName:"sNo" },
			{Header:"삭제",			Type:"${sDelTy}", 	Hidden:1,  Width:45, 	Align:"Center",  SaveName:"sDelete" },
			{Header:"상태",			Type:"${sSttTy}", 	Hidden:1,  Width:45, 	Align:"Center",  SaveName:"sStatus" },
			{Header:"<sht:txt mid='authScopeCdV4' mdef='범위코드' />",Type:"Text",      	Hidden:0,  Width:50,  	Align:"Left",    SaveName:"scopeValue",    KeyField:0,   Format:"",            UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='L190911000076' mdef='범위명' />",	Type:"PopupEdit",   Hidden:0,  Width:110,	Align:"Left",    SaveName:"scopeValueNm",  KeyField:0,   Format:"",            UpdateEdit:0,   InsertEdit:1,   EditLen:4000},
            {Header:"<sht:txt mid='chkV1'         mdef='등록' />",	Type:"CheckBox",  	Hidden:0,  Width:35,  	Align:"Center",  SaveName:"chk",           KeyField:0,   Format:"",            UpdateEdit:1,   InsertEdit:1,   EditLen:1, DefaultValue:"1" }
        ]; IBS_InitSheet(sheet4, initdata);sheet4.SetEditable("${editable}");sheet4.SetVisible(false);sheet4.SetCountPosition(4);
        
		//Autocomplete	
		$(sheet4).sheetAutocomplete({
			Columns: [{   ColSaveName : "scopeValueNm" 
					    , CallbackFunc: function(returnValue){
		      				var rv = $.parseJSON('{' + returnValue+ '}');
		      				sheet4.SetCellValue(gPRow, "scopeValue", 	rv["sabun"]);
		      				sheet4.SetCellValue(gPRow, "scopeValueNm", 	rv["name"]);
		  				  }
			          }]
		});

	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	
			sheet1.DoSearch( "${ctx}/AuthScopeUserMgr.do?cmd=getAuthScopeUserMgrList", $("#sheet1Form").serialize() ); 
			break;
		case "Save":
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/AuthScopeUserMgr.do?cmd=saveAuthScopeUserMgrUser", $("#sheet1Form").serialize());
			break;
		case "Insert":
			var Row = sheet1.DataInsert(0);
			sheet1.SetCellValue(Row, "searchType", "O");
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}


	//Sheet2 Action
	function doAction2(sAction){
		switch (sAction) {
		case "Search":
			sheet2.DoSearch( "${ctx}/AuthScopeUserMgr.do?cmd=getAuthScopeUserMgrOrgList", $("#sheet1Form").serialize()); 
			break;
		case "Save": 		

			var sRow = sheet2.FindCheckedRow("chk");
			var arr = sRow.split("|");
			for(var i=0; i<arr.length-1; i++){ 
	        	sheet2.SetCellValue(arr[i],"sStatus", "I");
			}

			$("#searchAuthScopeCd").val("W10"); //조직
			IBS_SaveName(document.sheet1Form,sheet2);
			sheet2.DoSave( "${ctx}/AuthScopeUserMgr.do?cmd=saveAuthScopeUserMgr", $("#sheet1Form").serialize()); 
			break;
		}
	}

	//Sheet3 Action
    function doAction3(sAction) {
		switch (sAction) { 
			case "Search":  
				sheet3.DoSearch( "${ctx}/AuthScopeUserMgr.do?cmd=getAuthScopeUserMgrScopeList", $("#sheet1Form").serialize()); 
				break;
		}
    }
	//Sheet4 Action
	function doAction4(sAction) {
		switch (sAction) {
		case "Search":
		    if( $("#searchAuthScopeCd").val()== "W20"  ) { // 성명
		    	sheet4.DoSearch( "${ctx}/AuthScopeUserMgr.do?cmd=getAuthScopeUserMgrScopeEmpList", $("#sheet1Form").serialize());	
		    }else if( $("#searchAuthScopeCd").val() != "" && $("#searchAuthScopeCd").val() != "-1"   ) {
			    sheet4.DoSearch( "${ctx}/AuthScopeUserMgr.do?cmd=getAuthScopeUserMgrScopeOthList", $("#sheet1Form").serialize());	
		    }
			break;
		case "Save":
			var chkcnt = 0;
			for(i=1; i<=sheet4.LastRow(); i++){
				if( sheet4.GetCellValue(i,"sStatus") == "I" ){
					sheet4.SetCellValue(i,"chk", "1");
		        	chkcnt++;
				}else if( sheet4.GetCellValue(i,"chk") == "1" ) {
		        	sheet4.SetCellValue(i,"sStatus", "I");
		        	chkcnt++;
		        } else {
		        	sheet4.SetCellValue(i,"sStatus", "D");
		        }
			}
			
			IBS_SaveName(document.sheet1Form,sheet4);
			sheet4.DoSave( "${ctx}/AuthScopeUserMgr.do?cmd=saveAuthScopeUserMgr", $("#sheet1Form").serialize());
			break;
		case "Insert": 
    		var Row = sheet4.DataInsert(); 
    		sheet4.SetCellValue(Row, "chk", "1");
    		sheet4.SetToolTipText(Row, "scopeValueNm", "<msg:txt mid='alertCondOver4' mdef='사번/성명을 입력해주세요.' />");
			break; 
		case "DownTemplate":
			// 양식다운로드
			sheet4.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"scopeValue|scopeValueNm"});
			break;
		case "LoadExcel":	
			var params = {Mode:"HeaderMatch", WorkSheetNo:1}; 
			sheet4.LoadExcel(params); 
			break;
		}
	}
	
	//---------------------------------------------------------------------------------------------------------------
	// sheet1 Event
	//---------------------------------------------------------------------------------------------------------------

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != ""){
				alert(Msg);
			}
			sheetResize();
		}catch(ex){
			alert("sheet1_OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != ""){
				alert(Msg);
			}

			if ( Code != "-1" ) doAction1("Search");
		}catch(ex){
			alert("sheet1_OnSaveEnd Event Error " + ex);
		}
	}

	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol,isDelete) {
		try {

			if( OldRow !=NewRow && sheet1.ColSaveName(NewCol) != "btnSet" && sheet1.ColSaveName(NewCol) != "btnView"){
			    clearScopeSheet(0);
				if( sheet2.RowCount() > 0) sheet2.RemoveAll();  
				if( sheet3.RowCount() > 0) sheet3.RemoveAll();
				if( sheet4.RowCount() > 0) sheet4.RemoveAll();
			}
		} catch (ex) {
			alert("sheet1_OnSelectCell Event Error : " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {

			if( sheet1.ColSaveName(Col) == "btnSet" ){
				
				if(sheet1.GetCellValue(Row, "sStatus") == "I") {
		            alert("<msg:txt mid='alertAuthGrpUser1' mdef='입력 상태에서는 권한범위 설정을 하실 수 없습니다.'/>");
					return;
				}
				if(sheet1.GetCellValue(Row, "sStatus") == "U") {
		            alert("저장 후 권한범위를 설정할 수 있습니다.");
					return;
				}
		        if(sheet1.GetCellValue(Row,"searchType") != "O") {
		            alert("<msg:txt mid='alertAuthGrpUser2' mdef='조회구분에서 [권한범위적용]으로 선택했을 경우만 권한범위 설정을 할 수 있습니다.'/>");
		            return;
		        }

				$("#searchSabun").val(sheet1.GetCellValue(Row, "sabun"));
			    
			    //초기값
			    $(".setBtn").show();$(".btnEmp").hide();
				sheet4.SetCellValue(0, "scopeValue", "<sht:txt mid='authScopeCdV4' mdef='범위코드' />");  
				sheet4.SetCellValue(0, "scopeValueNm", "<sht:txt mid='L190911000076' mdef='범위명' />");
	
				// 조회...
				doAction3('Search');
				
			}else if( sheet1.ColSaveName(Col) == "btnView" ){
				if(sheet1.GetCellValue(Row, "sStatus") == "I") return;
				scopeUserPopup(Row);
			}
		} catch (ex) {
			alert("sheet1_OnSelectCell Event Error : " + ex);
		}
	}

	function sheet1_OnChange(Row, Col, Value)  {
		try {
		} catch (ex) {
			alert("sheet1_OnChange Event Error : " + ex);
		}
	}

	function sheet1_OnPopupClick(Row, Col) {
		try{
			var colName = sheet1.ColSaveName(Col);
			if (Row >= sheet1.HeaderRows()) {
				if (colName == "name") {
					let layerModal = new window.top.document.LayerModal({
						id : 'employeeLayer'
						, url : '/Popup.do?cmd=viewEmployeeLayer&authPg=${authPg}'
						, parameters : {}
						, width : 840
						, height : 520
						, title : '사원조회'
						, trigger :[
							{
								name : 'employeeTrigger'
								, callback : function(result){
									sheet1.SetCellValue(Row, "sabun",   result.sabun);
									sheet1.SetCellValue(Row, "name",   result.name);
									sheet1.SetCellValue(Row, "orgNm",   result.orgNm);
									sheet1.SetCellValue(Row, "jikgubNm",   result.jikgubNm);
								}
							}
						]
					});
					layerModal.show();
				}
			}
		} catch(ex) {alert("OnPopupClick Event Error : " + ex);}
	}

	//---------------------------------------------------------------------------------------------------------------
	// sheet2 Event
	//---------------------------------------------------------------------------------------------------------------

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != ""){
				alert(Msg);
			}
			sheetResize();
		}catch(ex){
			alert("sheet2_OnSearchEnd Event Error : " + ex);
		}
	}
	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != ""){
				alert(Msg);
			}
			if ( Code != -1 ) {
				doAction2("Search");
			}
			

		}catch(ex){
			alert("sheet2_OnSaveEnd Event Error " + ex);
		}
	}
	function sheet2_OnChange(Row, Col, Value){
		try{
			if($("#searchType").is(":checked")){
				if( sheet2.ColSaveName(Col) == "chk" && Row == sheet2.GetSelectRow() ) {
					if( Row == 1 ) {
						for( i = 1 ; i <= sheet2.RowCount(); i++) {
							sheet2.SetCellValue(i, "chk",sheet2.GetCellValue(Row, "chk"));
						}
					} else {
						for( i = Row+1 ; i <= sheet2.RowCount(); i++) {
							if(  sheet2.GetCellValue(i, "scopeValueTop") != sheet2.GetCellValue(Row, "scopeValueTop") && sheet2.GetRowLevel(i) > sheet2.GetRowLevel(Row) ) {
								sheet2.SetCellValue(i, "chk",sheet2.GetCellValue(Row, "chk"));
							} else {
								break;
							}
						}
					}
				}
			}
		}catch(ex){
			alert("sheet2_OnChange Event Error : " + ex);
		}
	}	
	//---------------------------------------------------------------------------------------------------------------
	// sheet3 Event
	//---------------------------------------------------------------------------------------------------------------

	// 조회 후 에러 메시지
	function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != ""){
				alert(Msg);
			}
			var lrow = sheet3.LastRow();
			sheet3.SetCellFont("FontSize", 1, "authScopeNm", lrow, "authScopeNm" ,14);
			sheet3.SetCellFont("FontBold", 1, "authScopeNm", lrow, "authScopeNm" ,true);

			sheetResize();
		}catch(ex){
			alert("sheet3_OnSearchEnd Event Error : " + ex);
		}
	}
	function sheet3_OnSelectCell(OldRow, OldCol, NewRow, NewCol,isDelete) {
		try{

			sheet3.SetCellBackColor(OldRow, OldCol, "#FFFFFF");
			sheet3.SetCellBackColor(NewRow, NewCol, "#ffffe3");
			
			sheet3Row = NewRow;
			sheet3.SetCellValue(NewRow, "sel", 1); 
			$("#searchAuthScopeCd").val(sheet3.GetCellValue(NewRow, "authScopeCd"));
			$("#searchSqlSyntax").val(sheet3.GetCellValue(NewRow, "sqlSyntax"));
			
			if( $("#searchAuthScopeCd").val()== "W10"  ) { //조직
				clearScopeSheet(2);
				doAction2("Search");
			}else{
				clearScopeSheet(4);
				if( $("#searchAuthScopeCd").val()== "W20"  ) { //성명
					sheet4.SetCellValue(0, "scopeValue", "<tit:txt mid='103975' mdef='사번' />");
					sheet4.SetCellValue(0, "scopeValueNm", "<tit:txt mid='104450' mdef='성명' />");
					$(".btnEmp").show();
				}else{
					var authScopeNm = sheet3.GetCellValue(NewRow, "authScopeNm");
					sheet4.SetCellValue(0, "scopeValue", authScopeNm+"<tit:txt mid='114640' mdef='코드' />");  
					sheet4.SetCellValue(0, "scopeValueNm", authScopeNm+"<tit:txt mid='L19080200067' mdef='명' />");
					$(".btnEmp").hide();
				}
				doAction4("Search");	    
			}
			
		}catch(ex){alert("sheet3_OnSelectCell Event Error : " + ex);}
	}


	// 저장 후 메시지
	function sheet3_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != ""){
				alert(Msg);
			}
			if ( Code != -1 ) {
				doAction3("Search");
			}

		}catch(ex){
			alert("sheet3_OnSaveEnd Event Error " + ex);
		}
	}

	//---------------------------------------------------------------------------------------------------------------
	// sheet4 Event
	//---------------------------------------------------------------------------------------------------------------

	function sheet4_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != ""){
				alert(Msg);
			}
			sheetResize();
		}catch(ex){
			alert("sheet4_OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet4_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != ""){
				alert(Msg);
			}
			if ( Code != -1 ) {
				doAction4("Search");
			}
		}catch(ex){
			alert("sheet4_OnSaveEnd Event Error " + ex);
		}
	}

	function sheet4_OnChange(Row, Col, Value){
		try{
			if( sheet4.ColSaveName(Col) == "chk" && Value == "0" && sheet4.GetCellValue(Row, "sStatus") == "I"  ) {
				sheet4.RowDelete(Row, 0);
			}
		}catch(ex){
			alert("sheet4_OnChange Event Error : " + ex);
		}
	}	

	
	function clearScopeSheet(mode){
		if( mode == 2){
			$(".rightSheet4").hide();
			$(".rightSheet2").show();
			sheet3.SetVisible(true);
			sheet4.SetVisible(false);
			sheet2.SetVisible(true);
			clearSheetSize(sheet2);
			sheetInit();
		}else if( mode == 4 ){
			$(".rightSheet2").hide();
			$(".rightSheet4").show();
			sheet3.SetVisible(true);
			sheet2.SetVisible(false);
			sheet4.SetVisible(true);
			clearSheetSize(sheet4);
			sheetInit();
		}else if( mode == 0 ){
		    $(".setBtn").hide();
			$(".rightSheet2").hide();
			$(".rightSheet4").hide();
			sheet3.SetVisible(false);
			sheet2.SetVisible(false);
			sheet4.SetVisible(false);
			clearSheetSize(sheet2);
			clearSheetSize(sheet4);
			sheetInit();
		}
	}
	
	//대상보기
	function scopeUserPopup(Row){
		if(!isPopup()) {return;}
		gPRow = Row;
		pGubun = "authScopeUserMgrPopup";

  		var w 		= 740;
		var h 		= 580;
		var url 	= "${ctx}/AuthScopeUserMgr.do?cmd=viewAuthScopeUserMgrLayer&authPg=R";
		var args 	= new Array();
		args["searchSabun"] 	= sheet1.GetCellValue(Row, "sabun");
		args["searchGrpCd"] 	= $("#searchGrpCd").val();
		args["searchType"] 		= sheet1.GetCellValue(Row, "searchType");

		//openPopup(url,args,w,h);
		let layerModal = new window.top.document.LayerModal({
            id : 'authScopeUserMgrLayer'
          , url : url
          , parameters : args
          , width : w
          , height : h
          , title : '사용자권한범위관리 팝업'
          , trigger :[
              {
                    name : 'authScopeUserMgrTrigger'
                  , callback : function(result){
                  }
              }
          ]
      });
      layerModal.show();
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm">
		<input id="searchUseGubun" 			name="searchUseGubun" 			type="hidden" />
		<input id="searchItemValue1" 		name="searchItemValue1" 		type="hidden" />
		<input id="searchItemValue2" 		name="searchItemValue2" 		type="hidden" />
		<input id="searchItemValue3" 		name="searchItemValue3" 		type="hidden" />
	</form>
	<form id="sheet1Form" name="sheet1Form" >
		<input type="hidden" id="searchSabun"       name="searchSabun" />
		<input type="hidden" id="searchAuthScopeCd" name="searchAuthScopeCd" />
		<input type="hidden" id="searchSqlSyntax"   name="searchSqlSyntax" />
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><sch:txt mid='grpNm' mdef='권한그룹'/></th>
						<td>
							<select id="searchGrpCd" name="searchGrpCd"></select>
						</td>
						<th><tit:txt mid="104330" mdef="사번/성명" /></th>
						<td>
							<input type="text" id="searchSabunName" name="searchSabunName" class="text" style="ime-mode:active;" />
						</td>
						<td>
							<btn:a href="javascript:doAction1('Search')" id="btnSearch" css="btn dark" mid='search' mdef="조회"/>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	
	<table class="sheet_main">
		<colgroup>
			<col width="" />
			<col width="20px" />
			<col width="100px" />
			<col width="20px" />
			<col width="400px" />
		</colgroup>
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='schUserV1' mdef='사용자' /></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Down2Excel')" css="btn outline-gray authR" mid='down2excel' mdef="다운로드"/>
								<btn:a href="javascript:doAction1('Insert')"     css="btn outline-gray authA" mid='insert' mdef="입력" id="btnIns"/>
								<btn:a href="javascript:doAction1('Save')" 	     css="btn filled authA" mid='save' mdef="저장"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
			</td>
			<td class="sheet_right"><div style="padding-top:200px;" class="setBtn"><img src="/common/images/sub/ico_arrow.png"/></div></td>
			<td class="sheet_right">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li class="txt2">&nbsp;</li>
							<li id="txt1" class="btn setBtn">
								<btn:a href="javascript:doAction3('Search')" css="btn dark" mid='search' mdef="조회"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet3", "100%", "100%","${ssnLocaleCd}"); </script>
			</td>
			<td class="sheet_right"><div style="padding-top:200px;" class="setBtn"><img src="/common/images/sub/ico_arrow2.png"/></div></td>
			<td class="sheet_right">
		
				<div class="inner rightSheet4" style="display:none;">
					<div class="sheet_title">
						<ul>
							<li class="txt"><tit:txt mid='L190911000077' mdef='범위항목' /></li>
							<li id="txt1" class="btn setBtn">
								<btn:a href="javascript:doAction4('DownTemplate')" css="btn outline-gray authR btnEmp"  mid="L190911000079" mdef="양식" />
								<btn:a href="javascript:doAction4('LoadExcel')"    css="btn outline-gray authR btnEmp " mid="upload" mdef="업로드" />
								<btn:a href="javascript:doAction4('Insert')"       css="btn outline-gray authA btnEmp"  mid='insert' mdef="입력" style="display:none;"/>
								<btn:a href="javascript:doAction4('Save')" 	       css="btn filled authA"         mid='save' mdef="저장"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet4", "100%", "100%","${ssnLocaleCd}"); </script>
				
				<div class="rightSheet2" style="display:none;">
					<div class="sheet_title">
						<ul>
							<li class="txt">
								<tit:txt mid='L190911000080' mdef='조직범위' />
							</li>
							<li id="txt1" class="btn setBtn">
								<input type="checkbox" class="checkbox" id="searchType" name="searchType" style="vertical-align:middle;" checked/>&nbsp;<tit:txt mid='104304' mdef='하위조직포함'/>&nbsp;
								<btn:a href="javascript:doAction2('Save')" 	 css="btn filled authA" mid='save' mdef="저장"/>
								<btn:a href="javascript:doAction2('Search')" css="btn dark" mid='search' mdef="조회"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet2", "100%", "100%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
