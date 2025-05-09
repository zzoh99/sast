<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>인적사항관리</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var zipcodePg = "";

    $(function() {
    	
        
        var initdata = {};
        initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly}; 
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
        
        initdata.Cols = [
			{Header:"No",	    Type:"<%=sNoTy%>",	Hidden:Number("<%=sNoHdn%>"),	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",	    Type:"<%=sDelTy%>",	Hidden:Number("<%=sDelHdn%>"),Width:"<%=sDelWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",	    Type:"<%=sSttTy%>",	Hidden:Number("<%=sSttHdn%>"),Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"파기기준개월",	Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"std_mm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:200 },
			{Header:"파기기준일",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"std_dd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:200 },
			{Header:"일배치사용여부",	Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"batch_yn",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("<%=editable%>");
		
        initdata.Cols = [
			{Header:"No",			Type:"<%=sNoTy%>",	Hidden:Number("<%=sNoHdn%>"), 	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:1,	SaveName:"sNo" },
			{Header:"삭제",			Type:"<%=sDelTy%>",	Hidden:Number("<%=sDelHdn%>"),	Width:"<%=sDelWdt%>",	Align:"Center",	ColMerge:1,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",			Type:"<%=sSttTy%>",	Hidden:Number("<%=sSttHdn%>"),	Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:1,	SaveName:"sStatus",	Sort:0 },
			{Header:"테이블명",	Type:"Text",		Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"tab_nm",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:200 },
			{Header:"컬럼명",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"col_nm",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:200 },
			{Header:"항목명",		Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"item_nm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"구분",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"item_cf_cd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"UPDATE값",		Type:"Text",		Hidden:1,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"upd_val",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:200 }

		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("<%=editable%>");
		sheet2.SetVisible(true);sheet2.SetCountPosition(4);
      	
		var comboList   = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","RET0001"), ""); // 항목구분
		
		sheet2.SetColProperty("item_cf_cd",     {ComboText:comboList[0], ComboCode:comboList[1]} );
		$("#searchItemCfCd").html("<option value=''>전체</option>"+comboList[2]);
		
		$("#searchItemNm,#searchTabNm,#searchColNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction2("Search"); $(this).focus(); }
		});
		
        $(window).smartresize(sheetResize);
        sheetInit();
        
        doAction1("Search"); 
    });

    //Sheet1 Action
    function doAction1(sAction) {
        switch (sAction) {
        case "Search": 
            sheet1.DoSearch( "<%=jspPath%>/retInfoDestStd/retInfoDestStdRst.jsp?cmd=getRetInfoDestStdList1", $("#sheetForm").serialize() );
            break;
        case "Save":
        	setSheetData();
            sheet1.DoSave( "<%=jspPath%>/retInfoDestStd/retInfoDestStdRst.jsp?cmd=saveRetInfoDestStd1"); 
            break;
        case "Insert":
            var Row = sheet1.DataInsert(0) ;
            sheet1.SetCellValue(Row, "national_cd", "KR");
    		sheet1.SetCellValue(Row, "add_type",    "1" );
    		sheet1.SetCellValue(Row, "foreign_yn",  "N" );
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

    //조회 후 에러 메시지
    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try { 
            alertMessage(Code, Msg, StCode, StMsg);
            
            sheetResize(); 
            getSheetData();
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

  //sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			sheet2.DoSearch( "<%=jspPath%>/retInfoDestStd/retInfoDestStdRst.jsp?cmd=getRetInfoDestStdList2", $("#sheetForm").serialize() );
			break;
		case "Save":
			sheet2.DoSave( "<%=jspPath%>/retInfoDestStd/retInfoDestStdRst.jsp?cmd=saveRetInfoDestStd2");
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
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<span>구분</span>
							<select id="searchItemCfCd" name="searchItemCfCd"></select>
						</td>
						<td>
							<span>항목명</span>
							<input id="searchItemNm" name="searchItemNm" type="text" class="text" style="width: 65%"/>
						</td>
					</tr>
					<tr>
						<td>
							<span>테이블명</span>
							<input id="searchTabNm" name="searchTabNm" type="text" class="text" style="width: 65%"/>
						</td>
						<td>
							<span>컬럼명</span>
							<input id="searchColNm" name="searchColNm" type="text" class="text"/>
						</td>
						<td>
							<a href="javascript:doAction2('Search');" class="button">조회</a>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	
	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">파기기준설정</li>
			<li class="btn">
				<a href="javascript:doAction1('Save');" class="basic authA">저장</a>
			</li>
		</ul>
		</div>
	</div>
	
	<form id="stdForm" name="stdForm">

		<table border="0" cellpadding="0" cellspacing="0" class="default outer">
		<colgroup>
			<col width="13%" />
			<col width="37%" />
			<col width="13%" />
			<col width="*" />
		</colgroup>
		<tr>
			<th>대상자기준</th>
			<td>
				퇴직일로부터 <input id="stdMmTxt" name="stdMmTxt" type="text" class="text" style="width:30px"> 개월
				<!-- <input id="stdDdTxt" name="stdDdTxt" type="text" class="text"  style="width:30px"> 일 --> 
				경과
			</td>
			<th>일배치 사용여부</th>
			<td>
				<span>사용 </span><input type="radio" id="batchYn" name="batchYn" value="Y"/>
				<span>미사용 </span><input type="radio" id="batchYn" name="batchYn" value="N" checked/>
			</td>
		</tr>
		</table>


	</form>	

    <div class="outer">
        <div class="sheet_title">
		<ul>
			<li class="txt">파기항목설정</li>
			<li class="btn">
				<a href="javascript:doAction2('Insert');" class="basic authA">입력</a>
				<a href="javascript:doAction2('Copy');" class="basic authA">복사</a>
				<a href="javascript:doAction2('Save');" class="basic authA">저장</a>
				<a href="javascript:doAction2('Down2Excel');" class="basic authR">다운로드</a>
			</li>
		</ul>
        </div>
    </div>
    
    <div class="hide">
    <script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
    </div>
    
    <script type="text/javascript"> createIBSheet("sheet2", "100%", "100%"); </script>
</div>
</body>
</html>