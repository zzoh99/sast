<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<title><tit:txt mid='104192' mdef='소급상세 '/> </title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var p = eval("${popUpStatus}");

$(function() {
	//close 처리
	$(".close").click(function(){
		p.self.close();
		p.$("#col1").attr("width", "100%");
		p.sheetResize();

	});


	var initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad, Page:22, FrozenCol:0, MergeSheet:msHeaderOnly};
	initdata.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};
	initdata.Cols = [
// 		{Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"지급|항목",			Type:"Text",		Hidden:0,				Width:50,			Align:"Center",	ColMerge:0,	SaveName:"reportNm",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"지급|금액",			Type:"AutoSum",		Hidden:0,				Width:50,			Align:"Right",	ColMerge:0,	SaveName:"resultMon",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		
	]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(0);sheet1.SetCountPosition(0);

	var initdata2 = {};
	initdata2.Cfg = {SearchMode:smLazyLoad, Page:22, FrozenCol:0, MergeSheet:msHeaderOnly};
	initdata2.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};
	initdata2.Cols = [
// 		{Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"공제|항목",			Type:"Text",		Hidden:0,				Width:50,			Align:"Center",	ColMerge:0,	SaveName:"reportNm",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"공제|금액",			Type:"AutoSum",			Hidden:0,				Width:50,			Align:"Right",	ColMerge:0,	SaveName:"resultMon",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		
	]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable(0);sheet2.SetCountPosition(0);

	sheetInit();
	
	var initdata3 = {};
	initdata3.Cfg = {SearchMode:smLazyLoad, Page:22, FrozenCol:0, MergeSheet:msHeaderOnly};
	initdata3.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};
	initdata3.Cols = [
// 		{Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"항목명",			Type:"Text",		Hidden:0,				Width:50,			Align:"Center",	ColMerge:0,	SaveName:"itemNm",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"소급전",			Type:"AutoSum",		Hidden:0,				Width:50,			Align:"Right",	ColMerge:0,	SaveName:"giResultMon",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"소급후",			Type:"AutoSum",		Hidden:0,				Width:50,			Align:"Right",	ColMerge:0,	SaveName:"resultMon",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"차액",			Type:"AutoSum",		Hidden:0,				Width:50,			Align:"Right",	ColMerge:0,	SaveName:"gapMon",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		
	]; IBS_InitSheet(sheet3, initdata3);sheet3.SetEditable(0);sheet3.SetCountPosition(0);
	
	sheetInit();
	
	sheet1.DoSearch( "${ctx}/RetroPersonal.do?cmd=getRetroDetailPopList1", $("#sheet1Form").serialize() );
	sheet2.DoSearch( "${ctx}/RetroPersonal.do?cmd=getRetroDetailPopList2", $("#sheet1Form").serialize() );
	sheet3.DoSearch( "${ctx}/RetroPersonal.do?cmd=getRetroDetailPopLst", $("#sheet1Form").serialize() );
	
	$(window).smartresize(sheetResize);
});

//조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { 
		
		if (Msg != "") 
		{
			alert(Msg); 
		}
		/*  else {
			sheet1.SetRowBackColor(sheet1.RowCount()+sheet1.HeaderRows()-1, '#FAD5E6');
		} */
		sheetResize();
	
	} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

//조회 후 에러 메시지
function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { 
		
		if (Msg != "") 
		{
			alert(Msg); 
		}
		/* else {
			sheet2.SetRowBackColor(sheet2.RowCount()+sheet2.HeaderRows()-1, '#FAD5E6');
		} */
		sheetResize();
	
	} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

</script>

<body class="bodywrap scrollAuto">
<div class="wrapper">
<!-- 	<div class="popup_title"> -->
<!-- 		<ul> -->
<%-- 			<li><tit:txt mid='103893' mdef='상세'/></li> --%>
<!-- 			<li class="close"></li> -->
<!-- 		</ul> -->
<!-- 	</div> -->
	<form name="sheet1Form" id="sheet1Form">
		<input type="hidden" name="payActionCd" id="payActionCd" value="${paramMap.payActionCd}"/> 
		<input type="hidden" name="rtrPayActionCd" id="rtrPayActionCd" value="${paramMap.rtrPayActionCd}"/> 
		<input type="hidden" name="sabun" id="sabun" value="${paramMap.sabun}"/> 
	</form>
	
	
		<input type="hidden" name="payActionCd" id="payActionCd"/> 
		<input type="hidden" name="rtrPayActionCd" id="rtrPayActionCd"/> 
		<input type="hidden" name="sabun" id="sabun"/> 

	<div class=""><!-- class="popup_main" -->
		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<colgroup>
				<col width="1%"/>
				<col width="34%"/>
				<col width="1%"/>
				<col width="34%"/>
				<col width="1%"/>
				<col width="34%"/>
				<col width="1%"/>
			</colgroup>
			<tr style="vertical-align: top;">
				<td></td>
				<td>
					<div class="inner" id="inner1">
						<div class="sheet_title">
							<ul>
								<li class="txt">수당 상세</li>
							</ul>
						</div>
						<script type="text/javascript">createIBSheet("sheet1", "100%", "90%", "${ssnLocaleCd}"); </script>
					</div>
				</td>
				<td></td>
				<td>
					<div class="inner" id="inner2">
						<div class="sheet_title">
							<ul>
								<li class="txt">공제 상세</li>
							</ul>
						</div>
						<script type="text/javascript">createIBSheet("sheet2", "100%", "90%", "${ssnLocaleCd}"); </script>
					</div>
				</td>
				<td></td>
				<td>
					<div class="inner" id="inner3">
						<div class="sheet_title">
							<ul>
								<li class="txt">소급전/후/차</li>
							</ul>
						</div>
					<script type="text/javascript">createIBSheet("sheet3", "100%", "90%", "${ssnLocaleCd}"); </script>
				</tr>
				<%--
					<div class="inner" id="inner3">
						<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
							<tr>
								<td>
									<div class="inner" style="margin-left:5px;">
										<div class="sheet_title">
											<ul>
												<li class="txt">급여내역</li>
											</ul>
										</div>
										<table border="0" cellpadding="0" cellspacing="0" class="table inner fixed" id="">
											<colgroup>
												<col width="25%" />
												<col width="25%" />
												<col width="25%" />
												<col width="25%" />
											</colgroup>
											<tr>
												<th class="left"><tit:txt mid='103989' mdef='급여총액'/></th>
												<td class="right">${list2.totEarningMon}</td>
												<th class="left"><tit:txt mid='104194' mdef='총액미포함액'/></th>
												<td class="right">${list2.exTotMon}</td>
											</tr>
											<tr>
												<th class="left"><tit:txt mid='104489' mdef='비과세총액'/></th>
												<td class="right">${list2.notaxTotMon}</td>
												<th class="left"><tit:txt mid='104373' mdef='공제총액'/></th>
												<td class="right">${list2.totDedMon}</td>
											</tr>
											 <tr>
												<th class="left"><tit:txt mid='103990' mdef='상여기초액'/></th>
												<td class="right">${list2.bonBaseMon}</td>
												<th class="left"><tit:txt mid='104096' mdef='년상여총지급율'/></th>
												<td class="right">${list2.bonBaseRate}</td>
											</tr> 
											<tr>
												<th class="left"><tit:txt mid='103892' mdef='월상여지급율'/></th>
												<td class="right">${list2.bonRate}</td>
												<th class="left"><b><tit:txt mid='104374' mdef='실지급액'/></b></th>
												<td class="right">${list2.paymentMon}</td>
											</tr>
										</table>
									</div>
								</td>
							</tr>
						</table>
					</div>
					
					--%>
				</td>
				<td></td>
			</tr>
		</table>
	</div>
</div>
</body>
</html>
