<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> 
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		$("#searchFromYmd").datepicker2({startdate:"searchFromYmd"});
		$("#searchToYmd").datepicker2({enddate:"searchToYmd"});		
		
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22}; 
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}", Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
            {Header:"<sht:txt mid='appEnterCdV1' mdef='회사'/>",			Type:"Text",     Hidden:1,  Width:0,  Align:"Center",		 ColMerge:0,   SaveName:"enterCd",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='bizCdV2' mdef='구분'/>",			Type:"Combo",    Hidden:0,  Width:30, 	Align:"Center",  	 ColMerge:0,   SaveName:"bizCd",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",			Type:"Text",     Hidden:0,  Width:20, 	Align:"Center",  	 ColMerge:0,   SaveName:"seq",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='objectNm' mdef='Object명'/>",		Type:"Text",     Hidden:0,  Width:80, 	Align:"Left",  	 	 ColMerge:0,   SaveName:"objectNm",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='errLocation' mdef='Error 위치'/>",	Type:"Text",     Hidden:1,  Width:0, 	Align:"Center",  	 ColMerge:0,   SaveName:"errLocation",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='errLog' mdef='Error 내용'/>",	Type:"Text",     Hidden:0,  Width:150, 	Align:"Left",  	 ColMerge:0,   SaveName:"errLog",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='chkdateV2' mdef='최종수정시간'/>",	Type:"Date",     Hidden:0,  Width:80, 	Align:"Center",  	 ColMerge:0,   SaveName:"chkdate",   KeyField:0,   CalcLogic:"",   Format:"YmdHms",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='chkidV1' mdef='수정자'/>",			Type:"Text",     Hidden:0,  Width:40, 	Align:"Center",  	 ColMerge:0,   SaveName:"chkid",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetColProperty("bizCd", 			{ComboText:"ERP|Groupware", ComboCode:"ERP|GW"} );

		$("#searchObjectNm, #searchChkid").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		
		$("#searchBizCd").bind("change", function(event){
			doAction1("Search") ;
		}) ;
		
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/InterLogMgr.do?cmd=getInterLogMgrList", $("#srchFrm").serialize() ); break;
		
		case "Clear":		sheet1.RemoveAll(); break;
		
		case "Down2Excel":	var downcol = makeHiddenSkipCol(sheet1);
							var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
							sheet1.Down2Excel(param); break;	
							break;
							
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { 
			if (Msg != "") {
				alert(Msg); 
			} sheetResize(); 
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function callInterfaceJava() {
		progressBar(true) ;
		if( !confirm("ERP와 인사정보를 동기화하시겠습니까?") ) { progressBar(false) ; return ; }
		
		var params = "ymd="+"${curSysYyyyMMdd}" ;
    	var data = ajaxCall("${ctx}/JcoExcute.do?cmd=callRFCPersnalInfo",params,false);
    	alert(data.Result.Code) ;
    	callLogProc(data.Result.Code) ;
    	progressBar(false) ;
    	
    	doAction1("Search");
	}
	
	function callLogProc(errLog) {	
		var params = "bizCd=" + "ERP" + 
					 "&objectNm=" + "callRFCPersnalInfo" +
					 "&errLocation=" + "10" +
					 "&errLog=" + errLog ;
		var ajaxCallCmd = "callP_COM_SET_LOG";
		
		var data = ajaxCall("/ExecAppmt.do?cmd="+ajaxCallCmd,params,false);
		
		if(data == null || data.Result == null) {
			alert("<msg:txt mid='alertInterLogMgr2' mdef='P_COM_SET_LOG를 사용할 수 없습니다.'/>") ;
		}
		progressBar(false) ;
	}

	function callProc() {
		
		progressBar(true) ;
		if( !confirm("그룹웨어와 동기화하시겠습니까?") ) { progressBar(false) ; return ; }
		
		var params = "searchDate="+$("#searchDate").val() ;
		var ajaxCallCmd = "callP_GW_MASTER_INFO_IF" ;
		
    	var data = ajaxCall("/InterLogMgr.do?cmd="+ajaxCallCmd,"",false);
    	/*
    	if(data.Result.Code == null) {
    		alert( "동기화 완료" ) ;
    		
    		var params = "bizCd=" + "GW" + 
						 "&objectNm=" + "P_GW_MASTER_INFO_IF" +
						 "&errLocation=" + "10" +
						 "&errLog=" + "그룹웨어 동기화 완료" ;
			var ajaxCallCmd = "callP_COM_SET_LOG";
			
			var data = ajaxCall("/ExecAppmt.do?cmd="+ajaxCallCmd,params,false);
			
			if(data == null || data.Result == null) {
				alert("<msg:txt mid='alertInterLogMgr2' mdef='P_COM_SET_LOG를 사용할 수 없습니다.'/>") ;
			}
    		
    	} else {
    		alert( "동기화 도중 : "+data.Result.Message ) ;

	    	if(data.Result.Code == null) {
	    		
	    		var params = "bizCd=" + "GW" + 
							 "&objectNm=" + "P_GW_MASTER_INFO_IF" +
							 "&errLocation=" + "10" +
							 "&errLog=" + "그룹웨어 동기화 도중 : "+data.Result.Message ;
				var ajaxCallCmd = "callP_COM_SET_LOG";
				
				var data = ajaxCall("/ExecAppmt.do?cmd="+ajaxCallCmd,params,false);
				
				if(data == null || data.Result == null) {
					alert("<msg:txt mid='alertInterLogMgr2' mdef='P_COM_SET_LOG를 사용할 수 없습니다.'/>") ;
				}
    		}
    	}
    	*/
		progressBar(false) ;
    	
		doAction1("Search");
	}
	
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
<!-- 					
						<th><tit:txt mid='112488' mdef='회사 '/></th>
						<td > <select id="searchEnterCd" name="searchEnterCd"> </select> </td>
 -->						
 						<th><tit:txt mid='104420' mdef='기간'/></th>
						<td>
							<input id="searchFromYmd" name="searchFromYmd" type="text" size="10" class="date2" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),0)%>"/> ~
							<input id="searchToYmd" name="searchToYmd" type="text" size="10" class="date2" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>"/>
						</td>	
						<th><tit:txt mid='103997' mdef='구분'/></th>
						<td>  
							 <select id="searchBizCd" name ="searchBizCd">
							 	<option value=""> 전체 </option>
							 	<option value="GW"> Groupware </option>
							 	<option value="ERP"> ERP </option>
							 </select>
						</td>	
						<th><tit:txt mid='114735' mdef=' Object명 '/></th>				
						<td>  <input id="searchObjectNm" name ="searchObjectNm" type="text" class="text" /> </td>	
						<th><tit:txt mid='112245' mdef=' 수정자 '/></th>	
						<td>  <input id="searchChkid" name ="searchChkid" type="text" class="text" /> </td>		
						<td> <btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/> </td>
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
							<li id="txt" class="txt"><tit:txt mid='interLogMgr' mdef='인터페이스 Log관리'/></li>
							<li class="btn">
								<!-- 제주항공 특화 소스
								<btn:a href="javascript:callProc();" css="blue authA" mid='111091' mdef="그룹웨어 동기화"/>
								<btn:a href="javascript:callInterfaceJava();" css="pink authA" mid='111552' mdef="ERP 인사정보 동기화"/>
								-->
								<btn:a href="javascript:doAction1('Down2Excel');" css="basic authR" mid='110698' mdef="다운로드"/>
							</li>							
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
