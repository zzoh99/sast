<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html> <html><head> <title>이관관리</title>
<%@ page import="yjungsan.util.*"%>
<%@ page import="java.util.Map"%>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<%String orgAuthPg = request.getParameter("orgAuthPg");%>

<script type="text/javascript">

	$(function() {

		$("#searchWorkYy").val("<%=yeaYear%>") ;

		//이관내역시트
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No",			Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
   			{Header:"삭제",			Type:"<%=sDelTy%>",   Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
   			{Header:"상태",			Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
   			{Header:"귀속년도",		Type:"Text",      Hidden:0,  Width:0,     Align:"Center",  ColMerge:1,   SaveName:"work_yy",	KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100  },
   			{Header:"업무구분",       Type:"Combo",     Hidden:0,  Width:60,    Align:"Center",  ColMerge:1,   SaveName:"sec_cd",  	KeyField:1,   CalcLogic:"",   Format:"",  		PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100  },
   			{Header:"테이블명",		Type:"Text",      Hidden:0,  Width:60,    Align:"Center",  ColMerge:1,   SaveName:"tb_nm",		KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100  },
   			{Header:"테이블코멘트",		Type:"Text",      Hidden:0,  Width:60,    Align:"Left",    ColMerge:1,   SaveName:"tb_cmt",		KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:1000 },
   			{Header:"컬럼명",			Type:"Text",      Hidden:0,  Width:60,    Align:"Center",  ColMerge:1,   SaveName:"col_nm",		KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100  },
   			{Header:"컬럼코멘트",		Type:"Text",      Hidden:0,  Width:60,    Align:"Left",    ColMerge:1,   SaveName:"col_cmt",	KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000 },
   			{Header:"순서",			Type:"Int",       Hidden:0,  Width:60,    Align:"Center",  ColMerge:1,   SaveName:"seq",		KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100  },
   			{Header:"비과세여부",		Type:"CheckBox",  Hidden:0,  Width:60,    Align:"Center",  ColMerge:1,   SaveName:"notax_yn",	KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1,	TrueValue:"Y", FalseValue:"N", HeaderCheck:0  },
   			{Header:"비과세출력여부",	Type:"CheckBox",  Hidden:0,  Width:60,    Align:"Center",  ColMerge:1,   SaveName:"notax_print_yn",	KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1,	TrueValue:"Y", FalseValue:"N", HeaderCheck:0  }
        ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

        sheet1.SetColProperty("sec_cd",					{ComboText:"기본정보|근무지정보|소득공제|세액감면세액공제",	ComboCode:"A|B|C|D"} );
        
        doAction1("Search");
        $(window).smartresize(sheetResize); sheetInit();
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "<%=jspPath%>/yeaMig/yeaMigStdMgrRst.jsp?cmd=selectMigMgrList", $("#sheetForm").serialize() );
			break;
		case "Save":
			if(!dupChk(sheet1, "tb_nm|col_nm", false, true)) {break;}
			sheet1.DoSave( "<%=jspPath%>/yeaMig/yeaMigStdMgrRst.jsp?cmd=saveMigMgr",$("#sheetForm").serialize());
			break;
		case "Insert":
			var Row = sheet1.DataInsert(0);
			sheet1.SetCellValue(Row,"sec_cd",$("#searchMigType").val());
			sheet1.SetCellValue(Row,"work_yy",$("#searchWorkYy").val());
			break;
		case "Copy":
			var Row = sheet1.DataCopy();
			sheet1.SetCellValue(Row,"work_yy",$("#searchWorkYy").val());
			break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,menuNm:$(document).find("title").text()};
			sheet1.Down2Excel(param);
			break;
		}
	}

    //조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			sheetResize();
		} catch(ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	//저장 후 메시지
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
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
    <form id="sheetForm" name="sheetForm" >
    <input type="hidden" id="menuNm" name="menuNm" value="" />
    <div class="sheet_search outer">
        <div>
        <table>
			<tr>
			    <td><span>년도</span>
					<input id="searchWorkYy" name ="searchWorkYy" type="text" class="text center" maxlength="4" style="width:35px"/>
				</td>
				<td>
					<span>업무구분</span>
					<select class="box" id="searchMigType" name ="searchMigType" onChange="javascript:doAction1('Search')">
		                <option value="A">기본정보</option>
		                <option value="B">근무지정보</option>
		                <option value="C">소득공제</option>
		                <option value="D">세액감면세액공제</option>
		            </select>
				</td>
				<td><a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a></td>
			</tr>
        </table>
        </div>
    </div>
    </form>

    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">이관기준관리</li>
            <li class="btn">
				<a href="javascript:doAction1('Insert')" 		class="basic authA">입력</a>
				<a href="javascript:doAction1('Copy')" 			class="basic authA">복사</a>
				<a href="javascript:doAction1('Save')" 			class="basic btn-save authA">저장</a>
				<a href="javascript:doAction1('Down2Excel')" 	class="basic btn-download authR">다운로드</a>
            </li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>