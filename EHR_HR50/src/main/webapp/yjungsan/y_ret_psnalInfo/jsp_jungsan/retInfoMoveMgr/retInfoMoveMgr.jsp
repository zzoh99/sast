<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>인적사항관리</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var msg="";

    $(function() {
    	
        
    	var initdata = {};
        initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly}; 
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
        
        initdata.Cols = [
			{Header:"No",	    Type:"<%=sNoTy%>",	Hidden:Number("<%=sNoHdn%>"),	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",	    Type:"<%=sDelTy%>",	Hidden:1,Width:"<%=sDelWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",	    Type:"<%=sSttTy%>",	Hidden:Number("<%=sSttHdn%>"),Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"기준일자",	Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"std_ymd",			KeyField:0,	Format:"Ymd",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:200 },
			{Header:"성명",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:200 },
			{Header:"사번",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:200 },
			{Header:"퇴직일",		Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"ret_ymd",			KeyField:0,	Format:"Ymd",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:200 },
			{Header:"상태",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"dest_status_cd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:200 },
			{Header:"작업대상\n여부",		Type:"CheckBox",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"exec_yn",	KeyField:0,	Format:"",		TrueValue:"Y", FlaseValue:"N",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"분리일자",	Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"move_date",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"파기일자",	Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"dest_date",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("<%=editable%>");
		
        initdata.Cols = [
			{Header:"No",			Type:"<%=sNoTy%>",	Hidden:Number("<%=sNoHdn%>"), 	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:1,	SaveName:"sNo" },
			{Header:"구분",	Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"item_cf_cd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:200 },
			{Header:"테이블명",	Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"tab_nm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:200 },
			{Header:"컬럼명",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"col_nm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:200 },
			{Header:"항목명",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"item_nm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"갱신된값",		Type:"Text",		Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"upd_val",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:2000 },
			{Header:"분리된값",		Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"ori_val",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:2000 },
			{Header:"오류정보",	Type:"Text",		Hidden:1,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"err_msg",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:2000 }

		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable(false);
		sheet2.SetVisible(true);sheet2.SetCountPosition(4);
      	
		var comboList   = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","RET0001"), ""); // 항목구분
		var comboList2   = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","RET0002"), ""); // 파기상태
		
		sheet2.SetColProperty("item_cf_cd",     {ComboText:comboList[0], ComboCode:comboList[1]} );
		
		sheet1.SetColProperty("dest_status_cd",     {ComboText:comboList2[0], ComboCode:comboList2[1]} );
		
		$("#searchDestStatusCd").html("<option value=''>전체</option>"+comboList2[2]);
		
		$("#searchFromYmd,#searchToYmd,#searchSabunNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		
		$("#searchFromYmd").datepicker2({startdate:"searchToYmd",
            onReturn: function(date) {
            	displayRetFromTo();
            	doAction1("Search") ;
            }
		});
		
		$("#searchToYmd").datepicker2({startdate:"searchFromYmd",
            onReturn: function(date) {
            	displayRetFromTo();
            	doAction1("Search") ;
            }
		});

		displayRetFromTo();
		
        $(window).smartresize(sheetResize);
        sheetInit();
        
        doAction1("Search");
    });

    //Sheet1 Action
    function doAction1(sAction) {
        switch (sAction) {
        case "Search": 
            sheet1.DoSearch( "<%=jspPath%>/retInfoMoveMgr/retInfoMoveMgrRst.jsp?cmd=getRetInfoMoveMgrList1", $("#sheetForm").serialize() );
            break;
        case "Save":
            sheet1.DoSave( "<%=jspPath%>/retInfoMoveMgr/retInfoMoveMgrRst.jsp?cmd=saveRetInfoMoveMgr1"); 
            break;
        case "Prc_P_HRM_RET_INFO_MOVE":
        	 	
	        for(var i = 1; i < sheet1.RowCount()+1; i++) {
	        	if(sheet1.GetCellValue(i, "sStatus") != "R") {
	                alert("작업대상 체크 및 저장후 실행해주십시오.");
	                return;
	            }
	        }
	        
        	chkRetInfoMove(); 
        	
        	var confMsg = "아래 조건에 해당하는 대상자의 개인정보를 분리작업 합니다." + "\n";
        	    confMsg = confMsg + "기준일자 : " + $("#searchFromYmd").val() + " ~ " + $("#searchToYmd").val() + "\n";
        	    confMsg = confMsg + "상태 : 분리전" + "\n";
        	    confMsg = confMsg + "작업대상여부 : 체크" + "\n";
        	    confMsg = confMsg + "실행하시겠습니까?";
        	
        	if( confirm(confMsg) ){
        		// 개인정보분리실행
    			var result = ajaxCall("<%=jspPath%>/retInfoMoveMgr/retInfoMoveMgrRst.jsp?cmd=Prc_P_HRM_RET_INFO_MOVE", $("#sheetForm").serialize(),false);
        		
        		doAction1("Search");
        	}


            break;
            
        case "Down2Excel":
        	var downcol = makeHiddenSkipCol(sheet1);
            var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
            sheet1.Down2Excel(param);
            break;
        }
    }
    
    function callbackResult(data) {
    	if(data == null) {
    		alert("개인정보분리실행 오류입니다.");
    		return;
    	}
    	doAction1("Search");
    }    
    
    function chkRetInfoMove(){
    	if( $("#searchFromYmd").val() == "" ){
    		alert("기준일자(시작일)항목을 입력해 주세요.");
    		$("#searchFromYmd").focus();
    		return;
    	}
    	
    	if( $("#searchToYmd").val() == "" ){
    		alert("기준일자(종료일)항목을 입력해 주세요.");
    		$("#searchToYmd").focus();
    		return;
    	}
    	
    }
    
    function displayRetFromTo(){
		var queryId = "";
		queryId = $("#searchFromYmd").val().replace(/-/g, "");
		queryId = "getMoveRetymd&fromRetYmd="+$("#searchFromYmd").val().replace(/-/g, "")+"&toRetYmd="+$("#searchToYmd").val().replace(/-/g, "");
	
		var retYmd = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList",queryId) , "");
		$("#fromRetYmd").html(retYmd[1]);
		$("#toRetYmd").html(retYmd[0]);
    }

    //조회 후 에러 메시지
    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try { 
            alertMessage(Code, Msg, StCode, StMsg);
            
            for(var i = sheet1.HeaderRows(); i <= sheet1.RowCount()+sheet1.HeaderRows() ; i++) {
            	if(sheet1.GetCellValue(i,"dest_status_cd") != "A"){
					sheet1.SetCellEditable(i, "exec_yn",false);
				}
            }
            
            sheetResize();
            
            doAction2("Search");
        } catch(ex) {
            alert("OnSearchEnd Event Error : " + ex); 
        }
    }

    //저장 후 메시지
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
    
	// 셀 변경시 발생
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		try {
			if(sheet1.GetSelectRow() > 0) {
				if(OldRow != NewRow) {
					doAction2("Search");
				}
			}
		} catch (ex) {
			alert("OnSelectCell Event Error : " + ex);
		}
	}

  //sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			var row = sheet1.GetSelectRow();
			$("#searchSabun").val(sheet1.GetCellValue(row,"sabun"));
			sheet2.DoSearch( "<%=jspPath%>/retInfoMoveMgr/retInfoMoveMgrRst.jsp?cmd=getRetInfoMoveMgrList2", $("#sheetForm").serialize() );
			break;
		case "Save":
			sheet2.DoSave( "<%=jspPath%>/retInfoMoveStd/retInfoMoveStdRst.jsp?cmd=saveRetInfoMoveStd2");
			break;
		case "Insert":
			var row = sheet2.DataInsert(0);
			break;
        case "Copy":
            sheet2.DataCopy();
            break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet2.Down2Excel(param);
			break;
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

			if(Code > 0) {
				doAction2("Search");
			}
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	
	
	// 시트에서 폼으로 세팅.
	function getSheetData() {

		var row = sheet1.LastRow();

		if(row == 0) {
			return;
		}
		
		$('#stdMmTxt').val(sheet1.GetCellValue(row,"std_mm"));
		$("input[id='batchYn']:input[value="+sheet1.GetCellValue(row,"batch_yn")+"]").attr("checked",true);
		
	}
	
	function setSheetData() {
		var row = sheet1.LastRow();
		
		if(row == 0) {
			row = sheet1.DataInsert(0);
		}
		
		sheet1.SetCellValue(row, "std_mm", $('#stdMmTxt').val());
		sheet1.SetCellValue(row, "batch_yn", $("input[id='batchYn']:checked").val());
	}
    
    
</script>
</head>

<body class="bodywrap">
<div class="wrapper">
    <form id="sheetForm" name="sheetForm" >
    	<input id="searchSabun" name="searchSabun" type="hidden"/>
    	<input id="retSabun" name="retSabun" type="hidden"/>
    	<input id="retStdYmd" name="retStdYmd" type="hidden"/>
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<span>기준일자</span>
							<input id="searchFromYmd" name="searchFromYmd" type="text" class="text required" value="<%=curSysYyyyMMddHyphen%>" /> ~
							<input id="searchToYmd" name="searchToYmd" type="text" class="text required" value="<%=curSysYyyyMMddHyphen%>" />
						</td>
						<td>
							<span>상태</span>
							<select id="searchDestStatusCd" name="searchDestStatusCd"></select>
						</td>
						<td>
							<span>성명/사번</span>
							<input id="searchSabunNm" name="searchSabunNm" type="text" class="text"/>
						</td>
						<td>
							<a href="javascript:doAction1('Search');" class="button">조회</a>
						</td>
					</tr>
					<tr>
						<td>
							<span>퇴직일자&nbsp;&nbsp;</span>
							<span id="fromRetYmd" name="fromRetYmd"></span>
							<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
							<span id="toRetYmd" name="toRetYmd"></span>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<colgroup>
		<col width="60%" />
		<col width="*" />
	</colgroup>
	<tr>
		<td class="sheet_left">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt">개인정보분리대상</li>
					<li class="btn">
						<a href="javascript:doAction1('Prc_P_HRM_RET_INFO_MOVE');" class="basic authA">개인정보분리</a>
						<a href="javascript:doAction1('Save');" class="basic authA">저장</a>
						<a href="javascript:doAction1('Down2Excel');" class="basic authR">다운로드</a>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
		</td>
		<td class="sheet_right">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt">파기상세</li>
					<li class="btn">
						<a href="javascript:doAction2('Down2Excel');" class="basic authR">다운로드</a>
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