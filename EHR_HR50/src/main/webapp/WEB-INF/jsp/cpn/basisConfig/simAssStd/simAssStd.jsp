<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='simAssStd' mdef='간이세액표관리'/></title>
<link rel="stylesheet" href="/common/${theme}/css/style.css" />
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>

<script type="text/javascript">
	$(function() {

		//기준일자
		$("#searchDate").datepicker2();
		$("#searchDate").mask("1111-11-11");
		$('#searchMon').mask('000,000,000,000,000', { reverse : true });
		$("#searchDate, #searchMon").on("keyup", function(event) {
			if(event.keyCode === 13) {
				doAction("Search");
				$(this).focus();
			}
		});

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22, FrozenCol:4};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
                         {Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",           Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),   Width:Number("${sNoWdt}"),  Align:"Center", ColMerge:0,   SaveName:"sNo" },
                         {Header:"<sht:txt mid='sDelete V1' mdef='삭제|삭제'/>",       Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),  Width:Number("${sDelWdt}"), Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
                         {Header:"<sht:txt mid='sResultV1' mdef='결과|결과'/>",       Type:"${sRstTy}",   Hidden:Number("${sRstHdn}"),  Width:Number("${sRstWdt}"), Align:"Center", ColMerge:0,   SaveName:"sResult" , Sort:0},
                         {Header:"<sht:txt mid='sStatus V4' mdef='상태|상태'/>",       Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),  Width:Number("${sSttWdt}"), Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
                         {Header:"<sht:txt mid='enterCdV5' mdef='회사구분|회사구분'/>",  Type:"Text",      Hidden:1,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"enterCd",   KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
                         {Header:"<sht:txt mid='sDate' mdef='시작일자|시작일자'/>",  Type:"Date",      Hidden:0,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"sdate",     KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
                         {Header:"<sht:txt mid='edateV7' mdef='종료일자|종료일자'/>",  Type:"Date",      Hidden:0,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"edate",     KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
                         {Header:"<sht:txt mid='fMon' mdef='이상금액|이상금액'/>",  Type:"Int",       Hidden:0,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"fMon",      KeyField:1,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:22 },
                         {Header:"<sht:txt mid='tMon' mdef='미만금액|미만금액'/>",  Type:"Int",       Hidden:0,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"tMon",      KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:22 },
                         {Header:"<sht:txt mid='perMon1' mdef='1인|일반'/>",           Type:"Int",       Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"perMon1",   KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
                         {Header:"<sht:txt mid='perMon2' mdef='2인|일반'/>",           Type:"Int",       Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"perMon2",   KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
                         {Header:"<sht:txt mid='perMon3' mdef='3인|일반'/>",           Type:"Int",       Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"perMon3",   KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
                         {Header:"<sht:txt mid='mulMon3' mdef='3인|다자녀'/>",         Type:"Int",       Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"mulMon3",   KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
                         {Header:"<sht:txt mid='perMon4' mdef='4인|일반'/>",           Type:"Int",       Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"perMon4",   KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
                         {Header:"<sht:txt mid='mulMon4' mdef='4인|다자녀'/>",         Type:"Int",       Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"mulMon4",   KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
                         {Header:"<sht:txt mid='perMon5' mdef='5인|일반'/>",           Type:"Int",       Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"perMon5",   KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
                         {Header:"<sht:txt mid='mulMon5' mdef='5인|다자녀'/>",         Type:"Int",       Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"mulMon5",   KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
                         {Header:"<sht:txt mid='perMon6' mdef='6인|일반'/>",           Type:"Int",       Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"perMon6",   KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
                         {Header:"<sht:txt mid='mulMon6' mdef='6인|다자녀'/>",         Type:"Int",       Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"mulMon6",   KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
                         {Header:"<sht:txt mid='perMon7' mdef='7인|일반'/>",           Type:"Int",       Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"perMon7",   KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
                         {Header:"<sht:txt mid='mulMon7' mdef='7인|다자녀'/>",         Type:"Int",       Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"mulMon7",   KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
                         {Header:"<sht:txt mid='perMon8' mdef='8인|일반'/>",           Type:"Int",       Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"perMon8",   KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
                         {Header:"<sht:txt mid='mulMon8' mdef='8인|다자녀'/>",         Type:"Int",       Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"mulMon8",   KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
                         {Header:"<sht:txt mid='perMon9' mdef='9인|일반'/>",           Type:"Int",       Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"perMon9",   KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
                         {Header:"<sht:txt mid='mulMon9' mdef='9인|다자녀'/>",         Type:"Int",       Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"mulMon9",   KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
                         {Header:"<sht:txt mid='perMon10' mdef='10인|일반'/>",          Type:"Int",       Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"perMon10",  KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
                         {Header:"<sht:txt mid='mulMon10' mdef='10인|다자녀'/>",        Type:"Int",       Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"mulMon10",  KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
                         {Header:"<sht:txt mid='perMon11' mdef='11인|일반'/>",          Type:"Int",       Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"perMon11",  KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
                         {Header:"<sht:txt mid='mulMon11' mdef='11인|다자녀'/>",        Type:"Int",       Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"mulMon11",  KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 }  ];

		IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(4);


		sheet1.SetMergeSheet( msHeaderOnly);

		doAction("Search");

		$(window).smartresize(sheetResize); sheetInit();

		$(".sheet_search>div>table>tr input[type=text],select").each(function(){

		});
	});

	//Sheet Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/SimAssStd.do?cmd=getSimAssStdList", $("#sheetForm").serialize() ); break;
		case "Save":
			if(!dupChk(sheet1,"sdate|fMon", false, true)){break;}
			IBS_SaveName(document.sheetForm,sheet1);
			sheet1.DoSave( "${ctx}/SimAssStd.do?cmd=saveSimAssStd", $("#sheetForm").serialize()); break;
		case "Insert":
			sheet1.SelectCell(sheet1.DataInsert(0), ""); break;
		case "Copy":
			sheet1.SelectCell(sheet1.DataCopy(), 5);
			break;
		case "Clear":		sheet1.RemoveAll(); break;
        case "Down2Excel":
        	var downcol = makeHiddenSkipCol(sheet1);
        	var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param); break;
		case "LoadExcel":
			// 업로드
			var params = {};
			sheet1.LoadExcel(params);
			break;
		case "DownTemplate":
			// 양식다운로드
			sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0|1", DownCols:"5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28"});
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } doAction("Search");} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction("Insert");
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

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='104352' mdef='기준일자'/></th>
						<td>
							<input type="text" id="searchDate" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>" name="searchDate" class="date2" />
						</td>
						<th><tit:txt mid='baseMon' mdef='기준금액'/></th>
						<td>
							<input type="text" id="searchMon" name="searchMon" class="text" />
						</td>
						<td><btn:a href="javascript:doAction('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/></td>
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
							<li id="txt" class="txt"><tit:txt mid='simAssStd' mdef='간이세액표관리'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction('DownTemplate')" css="basic authA" mid='110702' mdef="양식다운로드"/>
								<btn:a href="javascript:doAction('Insert')" css="basic authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction('Copy')" 	css="basic authA" mid='110696' mdef="복사"/>
								<btn:a href="javascript:doAction('Save')" 	css="basic authA" mid='110708' mdef="저장"/>
								<btn:a href="javascript:doAction('LoadExcel')" css="basic authA" mid='110703' mdef="업로드"/>
								<a href="javascript:doAction('Down2Excel')" class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
