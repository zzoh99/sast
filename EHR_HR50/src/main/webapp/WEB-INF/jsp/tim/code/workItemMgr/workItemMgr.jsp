<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html> <head> <title></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<%@ include file="/WEB-INF/jsp/hrm/psnalInfo/psnalBasicInf/psnalBasicDefined.jsp"%>

<script type="text/javascript">
	$(function() {

		var workInputCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getWorkCdList"), "<tit:txt mid='112598' mdef='사용안함'/>");//getWorkCdList
		for(var i = 1; i <= 30; i++) {
			$("#workInputCd"+i).html(workInputCd[2]);
		}

 		var workGubunCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","T10028"), "");	//출력구분
		$("#searchWorkGubunCd").html(workGubunCd[2]);
 		
		
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:1,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='statusCd' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='workCd' mdef='근무코드'/>1",		Type:"Combo",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"workInputCd1",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	ComboText:"|"+workInputCd[0], ComboCode:"|"+workInputCd[1] },
			{Header:"<sht:txt mid='workCd' mdef='근무코드'/>2",		Type:"Combo",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"workInputCd2",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	ComboText:"|"+workInputCd[0], ComboCode:"|"+workInputCd[1] },
			{Header:"<sht:txt mid='workCd' mdef='근무코드'/>3",		Type:"Combo",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"workInputCd3",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	ComboText:"|"+workInputCd[0], ComboCode:"|"+workInputCd[1] },
			{Header:"<sht:txt mid='workCd' mdef='근무코드'/>4",		Type:"Combo",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"workInputCd4",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	ComboText:"|"+workInputCd[0], ComboCode:"|"+workInputCd[1] },
			{Header:"<sht:txt mid='workCd' mdef='근무코드'/>5",		Type:"Combo",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"workInputCd5",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	ComboText:"|"+workInputCd[0], ComboCode:"|"+workInputCd[1] },
			{Header:"<sht:txt mid='workCd' mdef='근무코드'/>6",		Type:"Combo",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"workInputCd6",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	ComboText:"|"+workInputCd[0], ComboCode:"|"+workInputCd[1] },
			{Header:"<sht:txt mid='workCd' mdef='근무코드'/>7",		Type:"Combo",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"workInputCd7",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	ComboText:"|"+workInputCd[0], ComboCode:"|"+workInputCd[1] },
			{Header:"<sht:txt mid='workCd' mdef='근무코드'/>8",		Type:"Combo",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"workInputCd8",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	ComboText:"|"+workInputCd[0], ComboCode:"|"+workInputCd[1] },
			{Header:"<sht:txt mid='workCd' mdef='근무코드'/>9",		Type:"Combo",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"workInputCd9",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	ComboText:"|"+workInputCd[0], ComboCode:"|"+workInputCd[1] },
			{Header:"<sht:txt mid='workCd' mdef='근무코드'/>10",		Type:"Combo",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"workInputCd10",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	ComboText:"|"+workInputCd[0], ComboCode:"|"+workInputCd[1] },
			{Header:"<sht:txt mid='workCd' mdef='근무코드'/>11",		Type:"Combo",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"workInputCd11",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	ComboText:"|"+workInputCd[0], ComboCode:"|"+workInputCd[1] },
			{Header:"<sht:txt mid='workCd' mdef='근무코드'/>12",		Type:"Combo",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"workInputCd12",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	ComboText:"|"+workInputCd[0], ComboCode:"|"+workInputCd[1] },
			{Header:"<sht:txt mid='workCd' mdef='근무코드'/>13",		Type:"Combo",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"workInputCd13",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	ComboText:"|"+workInputCd[0], ComboCode:"|"+workInputCd[1] },
			{Header:"<sht:txt mid='workCd' mdef='근무코드'/>14",		Type:"Combo",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"workInputCd14",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	ComboText:"|"+workInputCd[0], ComboCode:"|"+workInputCd[1] },
			{Header:"<sht:txt mid='workCd' mdef='근무코드'/>15",		Type:"Combo",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"workInputCd15",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	ComboText:"|"+workInputCd[0], ComboCode:"|"+workInputCd[1] },
			{Header:"<sht:txt mid='workCd' mdef='근무코드'/>16",		Type:"Combo",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"workInputCd16",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	ComboText:"|"+workInputCd[0], ComboCode:"|"+workInputCd[1] },
			{Header:"<sht:txt mid='workCd' mdef='근무코드'/>17",		Type:"Combo",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"workInputCd17",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	ComboText:"|"+workInputCd[0], ComboCode:"|"+workInputCd[1] },
			{Header:"<sht:txt mid='workCd' mdef='근무코드'/>18",		Type:"Combo",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"workInputCd18",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	ComboText:"|"+workInputCd[0], ComboCode:"|"+workInputCd[1] },
			{Header:"<sht:txt mid='workCd' mdef='근무코드'/>19",		Type:"Combo",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"workInputCd19",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	ComboText:"|"+workInputCd[0], ComboCode:"|"+workInputCd[1] },
			{Header:"<sht:txt mid='workCd' mdef='근무코드'/>20",		Type:"Combo",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"workInputCd20",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	ComboText:"|"+workInputCd[0], ComboCode:"|"+workInputCd[1] },
			{Header:"<sht:txt mid='workCd' mdef='근무코드'/>21",		Type:"Combo",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"workInputCd21",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	ComboText:"|"+workInputCd[0], ComboCode:"|"+workInputCd[1] },
			{Header:"<sht:txt mid='workCd' mdef='근무코드'/>22",		Type:"Combo",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"workInputCd22",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	ComboText:"|"+workInputCd[0], ComboCode:"|"+workInputCd[1] },
			{Header:"<sht:txt mid='workCd' mdef='근무코드'/>23",		Type:"Combo",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"workInputCd23",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	ComboText:"|"+workInputCd[0], ComboCode:"|"+workInputCd[1] },
			{Header:"<sht:txt mid='workCd' mdef='근무코드'/>24",		Type:"Combo",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"workInputCd24",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	ComboText:"|"+workInputCd[0], ComboCode:"|"+workInputCd[1] },
			{Header:"<sht:txt mid='workCd' mdef='근무코드'/>25",		Type:"Combo",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"workInputCd25",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	ComboText:"|"+workInputCd[0], ComboCode:"|"+workInputCd[1] },
			{Header:"<sht:txt mid='workCd' mdef='근무코드'/>26",		Type:"Combo",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"workInputCd26",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	ComboText:"|"+workInputCd[0], ComboCode:"|"+workInputCd[1] },
			{Header:"<sht:txt mid='workCd' mdef='근무코드'/>27",		Type:"Combo",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"workInputCd27",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	ComboText:"|"+workInputCd[0], ComboCode:"|"+workInputCd[1] },
			{Header:"<sht:txt mid='workCd' mdef='근무코드'/>28",		Type:"Combo",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"workInputCd28",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	ComboText:"|"+workInputCd[0], ComboCode:"|"+workInputCd[1] },
			{Header:"<sht:txt mid='workCd' mdef='근무코드'/>29",		Type:"Combo",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"workInputCd29",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	ComboText:"|"+workInputCd[0], ComboCode:"|"+workInputCd[1] },
			{Header:"<sht:txt mid='workCd' mdef='근무코드'/>30",		Type:"Combo",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"workInputCd30",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	ComboText:"|"+workInputCd[0], ComboCode:"|"+workInputCd[1] },
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(0);

		sheet1.SetFocusAfterProcess(0); sheet1.SetRowHidden(0, 1);
		sheet1.SetDataRowHeight(60);

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	$(function() {
		
		$("select").bind("change", function(){
			if( $(this).attr("id") == "searchWorkGubunCd") return;
			if( $(this).val() == "" ) {
				$(this).css("background-color","#b1b1b1");
			}else{
				$(this).css("background-color","#F4EEDC");
			}	
		});

		$("#searchWorkGubunCd").bind("change", function(){
			doAction1("Search");
		});
		
		
	});

	//Sheet0 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/WorkItemMgr.do?cmd=getWorkItemMgrList", "searchWorkGubunCd="+ $("#searchWorkGubunCd").val());
			break;
		case "Save":
			setSheetData();
			IBS_SaveName(document.infoFrom,sheet1);
			sheet1.DoSave( "${ctx}/WorkItemMgr.do?cmd=saveWorkItemMgr", $("#infoFrom").serialize());
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			getSheetData();
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
			getSheetData() ;
			sheetResize();
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 시트에서 폼으로 세팅.
	function getSheetData() {

		var row = sheet1.LastRow();

		if(row == 0) {

			for(var i = 1; i <= 30; i++) {
				$('#workInputCd'+i).val("");
				$("#workInputCd"+i).css("background-color","#b1b1b1");
			}
			return;
		}

		sheet1.RenderSheet(0);
		for(var i = 1; i <= 30; i++) {
			$('#workInputCd'+i).val(sheet1.GetCellValue(row,"workInputCd"+i));
			
			if( sheet1.GetCellValue(row,"workInputCd"+i) == "" ) {
				$("#workInputCd"+i).css("background-color","#b1b1b1");
				sheet1.SetColHidden("workInputCd"+i, 1);
			}else{
				$("#workInputCd"+i).css("background-color","#F4EEDC");
				sheet1.SetColHidden("workInputCd"+i, 0);
			}
		}
		sheet1.FitColWidth();	// 모든 컬럼의 Width를 재조정
		sheet1.RenderSheet(1);
	}

	// 폼에서 시트로 세팅.
	function setSheetData() {

		var row = sheet1.LastRow();

		if(row == 0) {
			row = sheet1.DataInsert();
		}
		for(var i = 1; i <= 30; i++) {
			sheet1.SetCellValue(row,"workInputCd"+i,$('#workInputCd'+i).val());
		}
	}

	// 날짜 포맷을 적용한다..
	function formatDate(strDate, saper) {
		if(strDate == "") {
			return strDate;
		}

		if(strDate.length == 10) {
			return strDate.substring(0,4)+saper+strDate.substring(5,7)+saper+strDate.substring(8,10);
		} else if(strDate.length == 8) {
			return strDate.substring(0,4)+saper+strDate.substring(4,6)+saper+strDate.substring(6,8);
		}
	}

</script>
</head>

<body>
<div class="wrapper">
	<form id="infoFrom" name="infoFrom">
	<div class="sheet_search outer">
		<table>
		<tr>
			<th>출력구분</th>
			<td>
				<select id="searchWorkGubunCd" name="searchWorkGubunCd"></select>
			</td>
			<td>
				<btn:a href="javascript:doAction1('Search')" mid="search" mdef="조회" css="btn dark"/>
			</td>
		</tr>
		</table>
	</div>
	
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt">근무코드출력항목설명</li>
			<li class="btn">
			    <btn:a href="javascript:doAction1('Save');" css="btn filled authA" mid='save' mdef="저장"/>
			</li>
		</ul>
		</div>
	</div>
	<table border="0" cellpadding="0" cellspacing="0" class="default">
		<colgroup>
			<col width="70px" />
			<col width="28%" />
			<col width="70px" />
			<col width="28%" />
			<col width="70px" />
			<col width="" />
		</colgroup>
		<tr>
			<th>출력순서</th>
			<th><tit:txt mid='workTotalMgr2' mdef='근무코드'/></th>
			<th>출력순서</th>
			<th><tit:txt mid='workTotalMgr2' mdef='근무코드'/></th>
			<th>출력순서</th>
			<th><tit:txt mid='workTotalMgr2' mdef='근무코드'/></th>
		</tr>
		<tr>	
			<th>1</th>
			<td>
				<select id="workInputCd1" name="workInputCd1">
				</select>
			</td>
			<th>11</th>
			<td>
				<select id="workInputCd11" name="workInputCd11">
				</select>
			</td>
			<th>21</th>
			<td>
				<select id="workInputCd21" name="workInputCd21">
				</select>
			</td>
		</tr>
		<tr>
			<th>2</th>
			<td>
				<select id="workInputCd2" name="workInputCd2">
				</select>
			</td>
			<th>12</th>
			<td>
				<select id="workInputCd12" name="workInputCd12">
				</select>
			</td>
			<th>22</th>
			<td>
				<select id="workInputCd22" name="workInputCd22">
				</select>
			</td>
		</tr>
		<tr>
			<th>3</th>
			<td>
				<select id="workInputCd3" name="workInputCd3">
				</select>
			</td>
			<th>13</th>
			<td>
				<select id="workInputCd13" name="workInputCd13">
				</select>
			</td>
			<th>23</th>
			<td>
				<select id="workInputCd23" name="workInputCd23">
				</select>
			</td>
		</tr>
		<tr>
			<th>4</th>
			<td>
				<select id="workInputCd4" name="workInputCd4">
				</select>
			</td>
			<th>14</th>
			<td>
				<select id="workInputCd14" name="workInputCd14">
				</select>
			</td>
			<th>24</th>
			<td>
				<select id="workInputCd24" name="workInputCd24">
				</select>
			</td>
		</tr>
		<tr>
			<th>5</th>
			<td>
				<select id="workInputCd5" name="workInputCd5">
				</select>
			</td>
			<th>15</th>
			<td>
				<select id="workInputCd15" name="workInputCd15">
				</select>
			</td>
			<th>25</th>
			<td>
				<select id="workInputCd25" name="workInputCd25">
				</select>
			</td>
		</tr>
		<tr>
			<th>6</th>
			<td>
				<select id="workInputCd6" name="workInputCd6">
				</select>
			</td>
			<th>16</th>
			<td>
				<select id="workInputCd16" name="workInputCd16">
				</select>
			</td>
			<th>26</th>
			<td>
				<select id="workInputCd26" name="workInputCd26">
				</select>
			</td>
		</tr>
		<tr>
			<th>7</th>
			<td>
				<select id="workInputCd7" name="workInputCd7">
				</select>
			</td>
			<th>17</th>
			<td>
				<select id="workInputCd17" name="workInputCd17">
				</select>
			</td>
			<th>27</th>
			<td>
				<select id="workInputCd27" name="workInputCd27">
				</select>
			</td>
		</tr>
		<tr>
			<th>8</th>
			<td>
				<select id="workInputCd8" name="workInputCd8">
				</select>
			</td>
			<th>18</th>
			<td>
				<select id="workInputCd18" name="workInputCd18">
				</select>
			</td>
			<th>28</th>
			<td>
				<select id="workInputCd28" name="workInputCd28">
				</select>
			</td>
		</tr>
		<tr>
			<th>9</th>
			<td>
				<select id="workInputCd9" name="workInputCd9">
				</select>
			</td>
			<th>19</th>
			<td>
				<select id="workInputCd19" name="workInputCd19">
				</select>
			</td>
			<th>29</th>
			<td>
				<select id="workInputCd29" name="workInputCd29">
				</select>
			</td>
		</tr>
		<tr>
			<th>10</th>
			<td>
				<select id="workInputCd10" name="workInputCd10">
				</select>
			</td>
			<th>20</th>
			<td>
				<select id="workInputCd20" name="workInputCd20">
				</select>
			</td>
			<th>30</th>
			<td>
				<select id="workInputCd30" name="workInputCd30">
				</select>
			</td>
		</tr>
		</table>
	</form>

	<div>
		<div class="sheet_title">
		<ul>
			<li class="txt">미리보기</li>
			<li class="btn">
			</li>
		</ul>
		</div>
	</div>
	<div>
		<script type="text/javascript"> createIBSheet("sheet1", "100%", "100px", "${ssnLocaleCd}"); </script>
	</div>
</div>
</body>
</html>