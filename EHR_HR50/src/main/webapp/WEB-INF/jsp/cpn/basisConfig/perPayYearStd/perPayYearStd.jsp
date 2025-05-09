<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='sabunRuleMgr' mdef='사번생성규칙'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22}; 
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		
		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='elementNmV3' mdef='급여항목'/>",	Type:"Combo",	Hidden:0,	Width:140,	Align:"Center",	ColMerge:0,	SaveName:"elementCd",	KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='applJobJikgunNmV1' mdef='직군'/>",		Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"workType",	KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='cRule' mdef='계산식'/>",	Type:"Text",	Hidden:0,	Width:300,	Align:"Center",	ColMerge:0,	SaveName:"calcLogic",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2000 },
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		var elementCd 	= convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCpnEtcAnnual",false).codeList, "<tit:txt mid='103895' mdef='전체'/>");
		sheet1.SetColProperty("elementCd", {ComboText:elementCd[0], ComboCode:elementCd[1]} );
		$("#elementCd").html(elementCd[2]) ;
		
		var workType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10050"), "<tit:txt mid='103895' mdef='전체'/>");
		sheet1.SetColProperty("workType", {ComboText:"|"+workType[0], ComboCode:"|"+workType[1]} );
		$("#searchWorkType").html(workType[2]) ;
		
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
		
		getChangeElementList();
	});
	
	function getChangeElementList() {
		// 치환텍스트 조회
		var txtlist = ajaxCall("${ctx}/PerPayYearStd.do?cmd=getChangeElementList","",false);
		txtlist = txtlist.DATA;
		// 한줄에 보여지는 치환텍스트 수
		var colcnt = 3;
		// 한칸의 너비
		var colsize = 120;
		
		var intxt = "<li><table><colgroup>";
		for(var i=0; i<colcnt; i++) {
			intxt += "<col style='width:"+colsize+"px;'>";
		}
		intxt += "</colgroup><tr>";
		
		for(var i=0; i<txtlist.length; i++) {
			//alert(txtlist[i].elementNm);
			//changeElementTxt
			if(i%colcnt == 0) {
				intxt += "</tr><tr>";
			}
			intxt += "<td>#"+txtlist[i].elementNm+"#</td>";
		}
		intxt += "</tr></table></li>";
		$("#changeElementTxt").html(intxt);
	}
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	
			sheet1.DoSearch( "${ctx}/PerPayYearStd.do?cmd=getPerPayYearStdList", $("#srchFrm").serialize()); 
			break;
		case "Save":
			if(!dupChk(sheet1, "elementCd|workType", true, "")) {
				break;
			}
			IBS_SaveName(document.srchFrm,sheet1);
			sheet1.DoSave( "${ctx}/PerPayYearStd.do?cmd=savePerPayYearStd", $("#srchFrm").serialize()); 
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			break;
		case "Copy":
			sheet1.DataCopy(); 
			break;
		case "Clear":		
			sheet1.RemoveAll(); 
			break;
		case "Down2Excel":	
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
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
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { 
			if (Msg != "") {
				alert(Msg); 
			}
			
			doAction1("Search");				
		} catch (ex) { 
			alert("OnSaveEnd Event Error " + ex); 
		}
	}
	
	// 셀 값 변경시 발생
	function sheet1_OnChange(Row, Col, Value) {
		try { 
		    var sSaveName = sheet1.ColSaveName(Col);
		} catch (ex) { 
			alert("OnChange Event Error " + ex); 
		}
	}
	
	function sheet1_OnValidation(Row, Col, Value) {
		try { 
		} catch (ex) { 
			alert("OnValidation Event Error " + ex); 
		}
	}

</script>
</head>
<body class="bodywrap">
<form id="sheet1Form" name="sheet1Form"></form>
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='113481' mdef='급여항목 '/></th>
						<td>  <select id="elementCd" name="elementCd"> </select> </td>
						<th><tit:txt mid='104261' mdef='직군 '/></th>
						<td>  <select id="searchWorkType" name="searchWorkType"> </select> </td>
						<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="button"><tit:txt mid='104081' mdef='조회'/></a> </td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='113064' mdef='연봉계산식'/></li>
			<li class="btn">
				<a href="javascript:doAction1('Insert');" class="basic authA"><tit:txt mid='104267' mdef='입력'/></a>
				<a href="javascript:doAction1('Copy');" class="basic authA"><tit:txt mid='104335' mdef='복사'/></a>
				<a href="javascript:doAction1('Save');" class="basic authA"><tit:txt mid='104476' mdef='저장'/></a>
				<a href="javascript:doAction1('Down2Excel');" class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
			</li>
		</ul>
		</div>
	</div>
	
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
	
	<div class="explain inner">
		<div class="title"><tit:txt mid='112356' mdef='치환가능 텍스트'/></div>
		<div class="txt">
		<ul id="changeElementTxt">
			<!-- 
			<li><tit:txt mid='112357' mdef='- 구분 : 사번부여시 고정으로 등록하는 값'/></li>
			<li style="line-height:5px">&nbsp;</li>
			<li><tit:txt mid='114115' mdef='- 고정값 : 최대 10자리까지 고정값 등록 가능'/></li>
			<li style="text-indent:47px"><tit:txt mid='113768' mdef='고정값 : 고정값으로 처리'/></li>
			<li style="text-indent:47px"><tit:txt mid='112684' mdef='년(YYYY), 년(YY) : 입사년과 고정값으로 처리'/></li>
			<li style="text-indent:47px"><tit:txt mid='113420' mdef='년월(YYYYMM), 년월(YYMM) : 입사년월과 고정값으로 처리'/></li>
			<li style="line-height:5px">&nbsp;</li>
			<li>- 고정값위치 &nbsp전 : <b>"구분"</b>의 앞에 위치 => ex) 구분값: <font style="color:blue">년월(YYYYMM)</font>, 고정값 : <font style="color:red">P</font> <b>→</b> <font style="color:red">P</font><font style="color:blue">201301</font><font style="color:green">001</font></li>
			<li style="text-indent:65px"> 중 : <b>"구분"</b>과 <b>"자동부여자릿수"</b> 중간 위치 => ex) 구분값: <font style="color:blue">년월(YYYYMM)</font>, 고정값 : <font style="color:red">P</font> <b>→</b> <font style="color:blue">201301</font><font style="color:red">P</font><font style="color:green">001</font></li>
			<li style="text-indent:65px"> 후 : <b>"구분", "자동부여자릿수"</b>에 관계 없이 맨뒤에 위치 => ex) 구분값: <font style="color:blue">년월(YYYYMM)</font>, 고정값 : <font style="color:red">P</font> <b>→</b> <font style="color:blue">201301</font><font style="color:green">001</font><font style="color:red">P</font></li>
			<li style="line-height:5px">&nbsp;</li>
			<li><tit:txt mid='112361' mdef='- 자동부여규칙 : 전번 - 전체 직원에서 자리수 증가 '/></li>
			<li style="text-indent:80px"><tit:txt mid='113422' mdef='년번 - 입사년도 기준 직원에서 자리수 증가 '/></li>
			<li style="text-indent:80px"><tit:txt mid='114488' mdef='월번 - 입사월 기준 직원에서 자리수 증가 '/></li>
			 -->
		</ul>
		</div>
	</div>
</div>
</body>
</html>
