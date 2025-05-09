<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">
	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='statusCd' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='gntNmV3' mdef='근태종류'/>",	Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"gntCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='workDay' mdef='일수'/>",		Type:"Float",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"gntCnt",	KeyField:0,	Format:"",	PointCount:2,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetCountPosition(0);
		// 근태코드
		var gntCdList = convCode( ajaxCall("/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCpnGntCdList",false).codeList, "");
		sheet1.SetColProperty("gntCd", {ComboText:"|"+gntCdList[0], ComboCode:"|"+gntCdList[1]} );

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='statusCd' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='workCdV1' mdef='근무명'/>",		Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"workCd",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='thour' mdef='근무시간'/>",	Type:"Float",	Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"workHour",	KeyField:0,	Format:"",	PointCount:2,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='applyYy' mdef='적용일'/>",		Type:"Date",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"applyYy",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		]; IBS_InitSheet(sheet2, initdata1);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		sheet2.SetCountPosition(0);
		var workCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getWorkCdList"), "");
		sheet2.SetColProperty("workCd", 		{ComboText:"|"+workCd[0], ComboCode:"|"+workCd[1]} );

		$(window).smartresize(sheetResize); sheetInit();

		$("#searchSYm").val("<%= DateUtil.getCurrentTime("yyyy-MM")%>") ;
		$("#searchEYm").val("<%= DateUtil.getCurrentTime("yyyy-MM")%>") ;

		getAppCurrYmd();

		setEmpPage();
	});

	$(function() {
		$("#searchSYm, #searchEYm").datepicker2({
			ymonly:true,
			onReturn:function(date){
				$("#"+this.id).val(date);
				getAppYmd();
				searchAll();
			}
		});

		$("#searchSYm, #searchEYm").bind("keyup",function(event){
			if( event.keyCode == 13){
				getAppYmd();
				searchAll();
				$(this).focus();
			}
		});
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":	sheet1.DoSearch( "${ctx}/PsnlTimeWorkSta.do?cmd=getPsnlTimeWorkStaList1", $("#sheet1Form").serialize() ); break;
		case "Save":
		case "Insert":
			sheet1.SelectCell(sheet1.DataInsert(0), 4);
			break;
		case "Copy":		sheet1.DataCopy(); break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":
		var downcol = makeHiddenSkipCol(sheet1);
		var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
		sheet1.Down2Excel(param); break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}
	//Example Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet2.DoSearch( "${ctx}/PsnlTimeWorkSta.do?cmd=getPsnlTimeWorkStaList2", $("#sheet1Form").serialize() ); break;
		case "Save":
		case "Insert":		sheet2.SelectCell(sheet2.DataInsert(0), 4); break;
		case "Copy":		sheet2.DataCopy(); break;
		case "Clear":		sheet2.RemoveAll(); break;
		case "Down2Excel":	sheet2.Down2Excel(); break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
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

	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
				if (Msg != "") { alert(Msg); }
				doAction2("Search");
			} catch (ex) {
				alert("OnSaveEnd Event Error " + ex);
			}
	}

	function searchAll(){
		try{
			$("#searchSabun").val($("#searchUserId").val());
			doAction1("Search");
			doAction2("Search");
		}catch(ex){alert("searchAll Event Error : " + ex);}
	}

	function setEmpPage() {
		$("#searchSabun").val($("#searchUserId").val());
		searchAll();
	}

	function timePopupClick(){
		try{
			if(!isPopup()) {return;}
			//var rv = openPopup("/PsnlTimeWorkSta.do?cmd=viewPsnlTimeStaLayer", args, "740","520");
			const p = { searchSabun: $("#searchSabun").val(),
						searchSYm: $("#searchSYm").val(),
						searchEYm: $("#searchEYm").val(),
						sdate: $("#sdate").val(),
						edate: $('#edate').val() };
			let psnlTimeStaLayer = new window.top.document.LayerModal({
				  id : 'psnlTimeStaLayer', 
				  url : '/PsnlTimeWorkSta.do?cmd=viewPsnlTimeStaLayer',
				  parameters: p, 
				  width : 740, 
				  height : 520, 
				  title : '<tit:txt mid='psnlTimeStaPop' mdef='근태상세내역'/>'
			  });
			psnlTimeStaLayer.show();
		} catch(ex) {alert("OnPopupClick Event Error : " + ex);}
	}

	function workPopupClick(){
		try{
			if(!isPopup()) {return;}
			const p = { searchSabun: $("#searchSabun").val(),
						searchSYm: $("#searchSYm").val(),
						searchEYm: $("#searchEYm").val(),
						sdate: $("#sdate").val(),
						edate: $('#edate').val(),
						payType: $("#searchEmpPayType").val() };
			/*<tit:txt mid='psnlWorkStaPop' mdef='근무상세내역'/>*/
			//var rv = openPopup("/PsnlTimeWorkSta.do?cmd=viewPsnlWorkStaPop", args, "920","520");
			let psnlWorkStaLayer = new window.top.document.LayerModal({
				  id : 'psnlWorkStaLayer', 
				  url : '/PsnlTimeWorkSta.do?cmd=viewPsnlWorkStaLayer',
				  parameters: p, 
				  width : 920, 
				  height : 520, 
				  title : '<tit:txt mid='psnlWorkStaPop' mdef='근무상세내역'/>'
			  });
			psnlWorkStaLayer.show();
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}

	// 대상년월일 조회
	function getAppYmd() {
		if($("#searchSYm").val() == "" || $("#searchEYm").val() == "") {
			alert("<msg:txt mid='alertYmdCheck' mdef='대상년월을 입력하여 주십시오.'/>");
			return;
		}

		$("#searchSabun").val($("#searchUserId").val());
		var data = ajaxCall("${ctx}/PsnlTimeWorkSta.do?cmd=getPsnlTimeWorkStaYmd","searchSYm="+$("#searchSYm").val()+"&searchEYm="+$("#searchEYm").val()+"&searchSabun="+$("#searchSabun").val() ,false);

		if(data != null && data.DATA != null) {
			if(data.DATA.stdwSDd != undefined) {
				$("#ymdTxt").text("("+formatDate(data.DATA.stdwSDd,"-") +" ~ " +formatDate(data.DATA.stdwEDd,"-")+")");
			}
			$("#sdate").val(data.DATA.stdwSDd);
			$("#edate").val(data.DATA.stdwEDd);
		} else {
			if(data.Message != null && data.Message != "") {
				alert(data.Message);
			}
			$("#ymdTxt").text("");
			$("#sdate").val("");
			$("#edate").val("");
		}

	}

	// 대상년월일 조회
	function getAppCurrYmd() {

		$("#searchSabun").val($("#searchUserId").val());
		var data = ajaxCall("${ctx}/PsnlTimeWorkSta.do?cmd=getPsnlTimeWorkStaCurrYmd","searchSabun="+$("#searchSabun").val(),false);

		if(data != null && data.DATA != null) {
			if(data.DATA.stdwSDd != undefined) {
				$("#searchSYm").val(data.DATA.ym.substr(0,4)+"-"+data.DATA.ym.substr(4,2));
				$("#searchEYm").val(data.DATA.ym.substr(0,4)+"-"+data.DATA.ym.substr(4,2));
				$("#ymdTxt").text("("+formatDate(data.DATA.stdwSDd,"-") +" ~ " +formatDate(data.DATA.stdwEDd,"-")+")");
			}

			$("#sdate").val(data.DATA.stdwSDd);
			$("#edate").val(data.DATA.stdwEDd);
		} else {
			if(data.Message != null && data.Message != "") {
				alert(data.Message);
			}

			getAppYmd();

			//$("#searchSYm").val("");
			//$("#searchEYm").val("");
			//$("#ymdTxt").text("");
			//$("#sdate").val("");
			//$("#edate").val("");
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

	function doApp(){

		if($("#searchYm").val() == "") {
			alert("<msg:txt mid='alertYmdCheck' mdef='대상년월을 입력하여 주십시오.'/>");
			return;
		}

		var data = ajaxCall("${ctx}/TimWorkCount.do?cmd=getTimWorkCount","schYm="+$("#searchYm").val().replace(/-/gi,"") ,false);

		if(data != null && data.DATA != null) {

			if(data.DATA.endYn == 'Y'){
				alert("<msg:txt mid='alertPsnlTimeWorkSta1' mdef='해당월의 근태집계는 이미 마감되었습니다.\n월근태/근무집계에서 마감을 해제하셔야 합니다.\n데이터 정확성의 문제가 발생할 수 있으니 마감을 해제할 때는 신중을 기해주시기 바랍니다.'/>");
				return;
			}else{

				progressBar(true) ;
				if(!confirm("<msg:txt mid='confirmBatchV1' mdef='작업하시겠습니까?'/>")) { progressBar(false) ; return ;}

				var param = "schYm="+$("#searchYm").val().replace(/-/gi,"")
							+"&sabun="+$("#searchSabun").val();
				var data = ajaxCall("${ctx}/TimWorkCount.do?cmd=prcTimWorkCount",param+"&gubun=app&placeCd=",false);

		    	if(data.Result != null && data.Result.Code == "1") {
		    		alert("<msg:txt mid='110120' mdef='처리되었습니다.'/>");
		    		searchAll();
			    	progressBar(false) ;
		    	} else if(data.Result != null && data.Result.Message != null){
			    	alert(data.Result.Message);
			    	progressBar(false) ;
		    	}
			}

		} else {
			if(data.Message != null && data.Message != "") {
				alert(data.Message);
				return;
			}
		}
	}

</script>
</head>
<body class="hidden">
<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
	<input type="hidden" id="searchSabun" name="searchSabun" />
		<div class="sheet_search sheet_search_s outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='114444' mdef='대상년월'/> </th>
						<td> 

						<input id="searchSYm" name ="searchSYm" type="text" class="date2 required" /> ~
						<input id="searchEYm" name ="searchEYm" type="text" class="date2 required" />


						<span id="ymdTxt" class="hide"></span>
						<input id="sdate" name="sdate" type="hidden" />
						<input id="edate" name="edate" type="hidden" />
						</td>
						<td> <btn:a href="javascript:searchAll();" id="btnSearch" css="btn dark" mid="search" mdef="조회"/> </td>
						<td class="hide"> <btn:a href="javascript:doApp();" id="btnApp" css="btn filled" mid="createV3" mdef="근태근무집계"/> </td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<colgroup>
		<col width="50%" />
		<col width="50%" />
	</colgroup>
	<tr>
		<td class="sheet_left">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid='psnlTimeworkSta1' mdef='근태집계내역'/></li>
					<li class="btn">
						<a href="javascript:timePopupClick();" class="btn outline_gray"><tit:txt mid='2017083001015' mdef='상세내역'/></a>
						<!--
						<a href="javascript:doAction1('Insert')" class="basic authA">입력</a>
						<a href="javascript:doAction1('Save')" 	 class="basic authA">저장</a>
						-->
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
		</td>
		<td class="sheet_right">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid='psnlTimeworkSta2' mdef='근무집계내역'/></li>
					<li class="btn">
						<a href="javascript:workPopupClick()" class="btn outline_gray"><tit:txt mid='2017083001015' mdef='상세내역'/></a>
						<!--
						<a href="javascript:doAction2('Insert')" class="basic authA">입력</a>
						<a href="javascript:doAction2('Save')" 	class="basic authA">저장</a>
						-->
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet2", "100%", "100%", "${ssnLocaleCd}"); </script>
		</td>
	</tr>
	</table>
</div>
</body>
</html>