<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid="202005150000095" mdef="기타지급신청" /></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">

	$(function() {		
		
		$("#searchPayYmFrom").datepicker2({ymonly:true});
		$("#searchPayYmTo").datepicker2({ymonly:true});
		$("#searchPayYmTo, #searchPayYmFrom").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No' />",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
   			{Header:"<sht:txt mid='sDelete' mdef='삭제' />", 		Type:"${sDelTy}",	Hidden:0,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='sStatus' mdef='상태' />", 		Type:"${sSttTy}",	Hidden:0,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
   			{Header:"<sht:txt mid='ibsImageV3' mdef='세부내역' />",	Type:"Image",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"detail",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"<sht:txt mid='applYmdV6' mdef='신청일자' />", 	Type:"Date",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"applYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='applStatusNm' mdef='신청상태' />", 	Type:"Text",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"applStatusNm",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='' mdef='신청상태CD' />", 	Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"applStatusCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='payYm_V121' mdef='합산년월' />", 	Type:"Date",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"payYm",				KeyField:0,	Format:"Ym",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='elementNmV5' mdef='수당명' />",		Type:"Text",			Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"benefitBizNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='payMonV1' mdef='지급총액' />",	Type:"AutoSum",			Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"totMon",			KeyField:0,	Format:"Integer",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },			
			{Header:"<sht:txt mid='note' mdef='비고' />",			Type:"Text",			Hidden:0,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"bigo",					KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"<sht:txt mid='' mdef='신청서순번' />",	Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applSeq",			KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
			{Header:"<sht:txt mid='' mdef='신청자사번' />",	Type:"Text",		Hidden:1,	Width:30,	Align:"Center",	ColMerge:0,	SaveName:"applInSabun",			KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50}
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(true);sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		//세부내역 버튼 이미지
		//sheet1.SetImageList(0,"/common/images/icon/icon_info.png");
		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("detail",true);
		
		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata2.Cols = [
   			{Header:"<sht:txt mid='sNo' mdef='No' />",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
   			{Header:"<sht:txt mid='name' mdef='성명' />",		Type:"Text",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",				KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
   			{Header:"<sht:txt mid='sabun' mdef='사번' />",		Type:"Text",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",				KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
   			{Header:"<sht:txt mid='orgNm' mdef='소속' />",		Type:"Text",			Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",				KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   			{Header:"<sht:txt mid='jikgubNm' mdef='직급' />",		Type:"Text",			Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   			{Header:"<sht:txt mid='seq' mdef='순번' />",		Type:"Text",			Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"seq",				KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
   			{Header:"<sht:txt mid='benefitBizNm' mdef='수당명' />",		Type:"Text",			Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"benefitBizNm",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='monV3' mdef='금액' />",		Type:"AutoSum",			Hidden:0,	Width:120,	Align:"Right",	ColMerge:0,	SaveName:"payMon",			KeyField:0,	Format:"Integer",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"<sht:txt mid='detailBigo' mdef='비고(상세)' />",	Type:"Text",			Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"detailBigo",		KeyField:0,		Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 }
   		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		var allText = "<sch:txt mid='all' mdef='전체' />";
		var etcPayAppBnCd = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getEtcPayAppBnCdList", false).codeList, allText);
		$("#etcPayAppBnCd").html(etcPayAppBnCd[2]);

		var applStatusCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getApplStatusCdList&applStatusNotCd=310,"), allText);
		//sheet1.SetColProperty("applStatusCd", 	{ComboText:applStatusCd[0], ComboCode:applStatusCd[1]} );
		
		$("#searchApplStatusCd").html(applStatusCd[2]);

		doAction1("Search");
		
		$(window).smartresize(sheetResize); sheetInit();
		setEmpPage();
	});

	$(function() {
		$("#searchApplStatusCd,#etcPayAppBnCd").change(function(){
			doAction1("Search") ;
		});		
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if($("#searchPayYmFrom").val() == "") {
				alert("<msg:txt mid='alertSearchYmFrom' mdef='시작월을 입력하여 주십시오.' />");
				return;
			}
			if($("#searchPayYmTo").val() == "") {
				alert("<msg:txt mid='alertSearchYmTo' mdef='종료월을 입력하여 주십시오.' />");
				return;
			}
			if($("#searchPayYmFrom").val() > $("#searchPayYmTo").val() ) {
				alert("<msg:txt mid='109544' mdef='시작월이 종료월보다 큽니다.' />");
				return;
			}

			var param = "sabun="+$("#searchUserId").val()
						+"&searchPayYmFrom="+$("#searchPayYmFrom").val()
						+"&searchPayYmTo="+$("#searchPayYmTo").val()
						+"&searchBenefitBizCd="+$("#etcPayAppBnCd").val()
						+"&searchApplStatusCd="+$("#searchApplStatusCd").val()

			sheet1.DoSearch( "${ctx}/GetDataList.do?cmd=getEtcPayAppList",param );
			break;
        case "Save":        	
        	IBS_SaveName(document.sheet1Form,sheet1);
        	// 삭제 처리만 저장
        	sheet1.DoSave( "${ctx}/EtcPayApp.do?cmd=deleteEtcPayApp", $("#sheet1Form").serialize()); break;			
		case "Down2Excel":
			var downcol = makeHiddenImgSkipCol(sheet1);
			
			var param  	= {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param);
			break;
		}
	}
	
	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			
			var applSeq = sheet1.GetCellValue( sheet1.GetSelectRow(), "applSeq");
			var param = "applSeq="+ applSeq ;
			
			sheet2.DoSearch( "${ctx}/GetDataList.do?cmd=getEtcPayAppDetailList",param );
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet2.Down2Excel(param);
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			
			for (var i=1; i<=sheet1.RowCount()+1; i++) {

				if(sheet1.GetCellValue(i, "updateYn") == "Y"){
					sheet1.SetCellFontColor(i, "updateYn", "#FF0000");				
					sheet1.SetCellFontBold(i, "updateYn", 1);				
				}			
			}

			doAction2("Search");
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
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

	// 헤더에서 호출
	function setEmpPage() {
    	$("#searchSabun").val($("#searchUserId").val());
		doAction1("Search");
	}
	
	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
    	
		try {
			if( Row < sheet1.HeaderRows() ) return;

		    if( sheet1.ColSaveName(Col) == "detail" ) {
		    	var auth = "R";
		    	if(sheet1.GetCellValue(Row, "applStatusCd") == "11") {
		    		//신청 팝업
		    		auth = "A";
		    	} else {
		    		//결재팝업
		    		auth = "R";
		    	}
		    	showApplPopup(auth //,"310"
		    			     ,sheet1.GetCellValue(Row,"applSeq")
	    				     ,sheet1.GetCellValue(Row,"applInSabun")
	    				     ,sheet1.GetCellValue(Row,"applYmd")
							 ,sheet1.GetCellValue(Row,"applStatusCd")
							);
		    //} else {
		    }
		    // 상세내역 조회
		    doAction2("Search");
		    //}
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}	

	//신청 팝업
	function showApplPopup(auth,applSeq,applInSabun,applYmd, applStatusCd) {
		if(auth == "") {
			alert("<msg:txt mid='110262' mdef='권한을 입력하여 주십시오.' />");
			return;
		}
		
		if(!isPopup()) {return;}

		var p = {
				searchApplCd: '310'
			  , searchApplSeq: applSeq
			  , adminYn: 'N'
			  , authPg: auth
			  , searchSabun: applInSabun
			  , searchApplSabun: $('#searchUserId').val()
			  , searchApplYmd: applYmd 
			};
		var url = "";
		var initFunc = '';
		if(applStatusCd == "" || applStatusCd == "11" ) {
			url = "/ApprovalMgr.do?cmd=viewApprovalMgrLayer";
			initFunc = 'initLayer';
		} else {
			url ="/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
			initFunc = 'initResultLayer';
		}

		var args = new Array(5);		
		args["applStatusCd"] = applStatusCd;
		var approvalMgrLayer = new window.top.document.LayerModal({
			id: 'approvalMgrLayer',
			url: url,
			parameters: p,
			width: 800,
			height: 815,
			title: '근태신청',
			trigger: [
				{
					name: 'approvalMgrLayerTrigger',
					callback: function(rv) {
						getReturnValue(rv);
					}
				}
			]
		});
		approvalMgrLayer.show();
		//window.top.openLayer(url, p, 800, 815, initFunc, getReturnValue);
	}

	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{'+ returnValue+'}');
		doAction1("Search");
	}
	
	function openUserNmPopup(){
		try{

			var args    = new Array();
			var rv = openPopup("/Popup.do?cmd=employeePopup&authPg=${authPg}", args, "740","520");
			if(rv!=null){

				$("#searchNm").val(rv["name"]);
				$("#searchSabun").val(rv["sabun"]);

			}
		}catch(ex){alert("Open Popup Event Error : " + ex);}
	}

	function sheet1_OnBeforeCheck(Row, Col) {
		try{
            sheet1.SetAllowCheck(true);
		    if(sheet1.ColSaveName(Col) == "sDelete") {
		        if(sheet1.GetCellValue(Row, "applStatusCd") != "11" && sheet1.GetCellValue(Row, "applStatusCd") != "12") {
		            sheet1.SetAllowCheck(false);
		            return;
		        }
		    }		    
		}catch(ex){
			alert("OnBeforeCheck Event Error : " + ex);
		}
	}
	
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>
	<form id="sheet1Form" name="sheet1Form" >
	<input type="hidden" id="searchSabun" name="searchSabun" value=""/>
		<div class="sheet_search outer" style="margin-top:10px;">
			<div>
				<table>
					<tr>
						<th><tit:txt mid="202005150000092" mdef="합산년월" /> </th>
						<td colspan="3">
							<input id="searchPayYmFrom" name ="searchPayYmFrom" class="date2" type="text"  value="<%=Integer.parseInt(DateUtil.getThisYear())-1 + "-01" %>"/>
							~
							<input id="searchPayYmTo" name ="searchPayYmTo" class="date2" type="text"  value="<%=DateUtil.getCurrentTime("yyyy-MM")%>"/>
						</td>
						<th><tit:txt mid="etcPayAppBnCd" mdef="수당명" /> </th>
						<td>  <select id="etcPayAppBnCd" name="etcPayAppBnCd"> </select></td>
						<th><tit:txt mid='112999' mdef='결재상태'/></th>
						<td> 
					<select id="searchApplStatusCd" name="searchApplStatusCd">
					</select> </td>
						<td> 
							<btn:a mid="search" mdef="조회" href="javascript:doAction1('Search');" id="btnSearch" css="button" />
						</td>
					</tr>
				</table>

			</div>
		</div>
	</form>
 
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<colgroup>
		<col width="60%" />
		<col width="40%" />
	</colgroup>
	<tr>
		<td class="sheet_left">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid="202005150000095" mdef="기타지급신청내역" /></li>
					<li class="btn">						
						<btn:a mid="111859" mdef="신청" href="javascript:showApplPopup('A','','${ssnSabun}','${curSysYyyyMMdd}','11');"  css="button authR" />
						<btn:a mid="search" mdef="조회" href="javascript:doAction1('Search');"  css="basic" />
						<btn:a mid="save" mdef="저장" href="javascript:doAction1('Save');"  css="basic" />
						<btn:a mid="download" mdef="다운로드" href="javascript:doAction1('Down2Excel');"  css="basic" />
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet1", "50%", "100%","${ssnLocaleCd}"); </script>
		</td>
		<td class="sheet_right">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid="2017083001015" mdef="상세내역" /></li>
					<li class="btn">
						<btn:a mid="download" mdef="다운로드" href="javascript:doAction2('Down2Excel');"  css="basic authR" />
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet2", "50%", "100%","${ssnLocaleCd}"); </script>
		</td>
	</tr>
	</table>
 

</body>
</html>
