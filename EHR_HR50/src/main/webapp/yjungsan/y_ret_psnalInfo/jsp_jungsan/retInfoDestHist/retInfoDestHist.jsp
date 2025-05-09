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
			{Header:"삭제",	    Type:"<%=sDelTy%>",	Hidden:1,Width:"<%=sDelWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",	    Type:"<%=sSttTy%>",	Hidden:1,Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"실행종류",	Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"exec_type_cd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:200 },
			{Header:"실행구분",	Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"exec_cf_cd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:200 },
			{Header:"작업일자",	Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"dest_ymd",		KeyField:0,	Format:"Ymd",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"기준퇴직일자",	Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"std_ret_ymd",		KeyField:0,	Format:"Ymd",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"대상자수",	Type:"Int",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"target_cnt",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"파기건수",	Type:"Int",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"dest_cnt",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"오류건수",	Type:"Int",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"err_cnt",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"파기순번",	Type:"Int",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"dest_seq",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);
      	
		
		 initdata.Cols = [
				{Header:"No",			Type:"<%=sNoTy%>",	Hidden:Number("<%=sNoHdn%>"), 	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:1,	SaveName:"sNo" },
				{Header:"사번",	Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:20 },
				{Header:"이름",	Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:20 },
				{Header:"퇴직일",	Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"retYmd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:20 },
				{Header:"테이블명",	Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"tab_nm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:200 },
				{Header:"컬럼명",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"col_nm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:200 },
				{Header:"항목명",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"item_nm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
				{Header:"갱신된값",		Type:"Text",		Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"upd_val",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:2000 },
				{Header:"분리된값",		Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"ori_val",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:2000 },
				{Header:"오류정보",	Type:"Text",		Hidden:1,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"err_msg",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:2000 }

		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable(false);
		sheet2.SetVisible(true);sheet2.SetCountPosition(4);
		
		var comboList   = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","RET0001"), ""); // 항목구분
		
		sheet1.SetColProperty("exec_type_cd",     {ComboText:"분리|파기", ComboCode:"M|D"} );
		sheet1.SetColProperty("exec_cf_cd",     {ComboText:"배치|수동", ComboCode:"B|M"} );
		
		sheet2.SetColProperty("item_cf_cd",     {ComboText:comboList[0], ComboCode:comboList[1]} );
		
		$("#searchFromYmd,#searchToYmd,#searchSabunNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		
		$("#searchFromYmd").datepicker2({startdate:"searchToYmd",
            onReturn: function(date) {
            	doAction1("Search") ;
            }
		});
		
		$("#searchToYmd").datepicker2({startdate:"searchFromYmd",
            onReturn: function(date) {
            	doAction1("Search") ;
            }
		});
		
        $(window).smartresize(sheetResize);
        sheetInit();
        
        doAction1("Search"); 
    });

    //Sheet1 Action
    function doAction1(sAction) {
        switch (sAction) {
        case "Search": 
            sheet1.DoSearch( "<%=jspPath%>/retInfoDestHist/retInfoDestHistRst.jsp?cmd=getRetInfoDestHistList", $("#sheetForm").serialize() );
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
    
  //sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			var row = sheet1.GetSelectRow();
			var param = "destSeq="+sheet1.GetCellValue(row,"dest_seq");
			
			if(sheet1.GetCellValue(row,"exec_type_cd") == "M"){
				sheet2.DoSearch( "<%=jspPath%>/retInfoDestHist/retInfoDestHistRst.jsp?cmd=getRetInfoDestHistList2", param );
			}else{
				sheet2.DoSearch( "<%=jspPath%>/retInfoDestHist/retInfoDestHistRst.jsp?cmd=getRetInfoDestHistList3", param );	
			}
			
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
  

    //조회 후 에러 메시지
    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try { 
            alertMessage(Code, Msg, StCode, StMsg);
            
            sheetResize(); 
// 			doAction2("Search");
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
	
    
</script>
</head>

<body class="bodywrap">
<div class="wrapper">
    <form id="sheetForm" name="sheetForm" >
    <input id="destSeq" name="destSeq" type="hidden" />
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<span>작업일자</span>
							<input id="searchFromYmd" name="searchFromYmd" type="text" class="text required" value="<%=yjungsan.util.DateUtil.getMonthAdd(curSysYear,curSysMon, -1)%>01" /> ~
							<input id="searchToYmd" name="searchToYmd" type="text" class="text required" value="<%=curSysYyyyMMddHyphen%>" />
						</td>
						<td>
							<a href="javascript:doAction1('Search');" class="button">조회</a>
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
					<li class="txt">개인정보파기이력</li>
					<li class="btn">
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
	

<!--     <div class="outer"> -->
<!--         <div class="sheet_title"> -->
<!-- 		<ul> -->
<!-- 			<li class="txt">개인정보파기이력</li> -->
<!-- 			<li class="btn"> -->
<!-- 				<a href="javascript:doAction1('Down2Excel');" class="basic authR">다운로드</a> -->
<!-- 			</li> -->
<!-- 		</ul> -->
<!--         </div> -->
<!--     </div> -->
    
<!--     <script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script> -->
</div>
</body>
</html>