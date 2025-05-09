<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>서무변경신청내역</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">

	$(function() {		
		
		$(".date2").datepicker2();
		
		$("#searchPayYmTo, #searchPayYmFrom").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata1.Cols = [
			{Header:"No|No",								Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
   			{Header:"삭제|삭제", 							Type:"${sDelTy}",	Hidden:0,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"상태|상태", 							Type:"${sSttTy}",	Hidden:0,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
   			{Header:"세부내역|세부내역",				Type:"Image",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"detail",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"신청일자|신청일자", 				Type:"Date",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"applYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"신청상태|신청상태", 				Type:"Text",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"applStatusNm",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"신청상태CD", 						Type:"Text",			Hidden:1,	Width:10,	Align:"Center",	ColMerge:0,	SaveName:"applStatusCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"변경구분|변경구분", 				Type:"Text",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"applTypeNm",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },			
			{Header:"적용\n시작일|적용\n시작일", 	Type:"Date",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sYmd",				KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"기존 서무|성명",					Type:"Text",			Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"curName",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"기존 서무|사번 ",					Type:"Text",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,		SaveName:"curSabun",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"신규 서무|성명",					Type:"Text",			Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"newName",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"신규 서무|사번 ",					Type:"Text",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,		SaveName:"newSabun",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"신규 서무|소속 ",					Type:"Text",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,		SaveName:"newOrgNm",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"신규 서무|직위 ",					Type:"Text",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,		SaveName:"newJikweeNm",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"신규 서무|직책 ",					Type:"Text",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,		SaveName:"newJikchakNm",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"비고|비고",									Type:"Text",			Hidden:0,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"bigo",					KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"신청서순번",						Type:"Text",			Hidden:1,	Width:10,	Align:"Center",	ColMerge:0,	SaveName:"applSeq",			KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
			{Header:"신청자사번",						Type:"Text",			Hidden:1,	Width:10,	Align:"Center",	ColMerge:0,	SaveName:"applInSabun",			KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50}
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(true);sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		//세부내역 버튼 이미지
		//sheet1.SetImageList(0,"/common/images/icon/icon_info.png");
		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("detail",true);
		
		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata2.Cols = [
   			{Header:"No|No",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
   			{Header:"성명|성명",					Type:"Text",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",				KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
   			{Header:"사번|사번",					Type:"Text",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabun",				KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
   			{Header:"소속|소속",					Type:"Text",			Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",				KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   			{Header:"직위|직위",				Type:"Text",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,		SaveName:"jikweeNm",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
   			{Header:"직책|직책",				Type:"Text",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,		SaveName:"jikchakNm",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
   			{Header:"신청일|신청일", 				Type:"Date",			Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"applDate",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 }
			
   		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		var deptPartPayAppBnCd = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getDeptPartPayAppBnCdList", false).codeList, "전체");
		$("#deptPartPayAppBnCd").html(deptPartPayAppBnCd[2]);

		var applStatusCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getApplStatusCdList&applStatusNotCd=310,"), "전체");
		
		$("#searchApplStatusCd").html(applStatusCd[2]);

		doAction1("Search");		
		doAction2("Search");
		
		$(window).smartresize(sheetResize); sheetInit();
		setEmpPage();
	});

	$(function() {
		$("#searchApplStatusCd,#deptPartPayAppBnCd").change(function(){
			doAction1("Search") ;
		});		
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if($("#searchFromYmd").val() == "") {
				alert("시작일을 입력하여 주십시오.");
				return;
			}
			if($("#searchFromTo").val() == "") {
				alert("종료일을 입력하여 주십시오.");
				return;
			}
			if($("#searchFromYmd").val() > $("#searchFromTo").val() ) {
				alert("시작일은 종료일보다 작아야 합니다.");
				return;
			}

			var param = "searchSabun="+$("#searchUserId").val()
						+"&searchFromYmd="+$("#searchFromYmd").val()
						+"&searchToYmd="+$("#searchToYmd").val()
						+"&searchApplStatusCd="+$("#searchApplStatusCd").val();

			sheet1.DoSearch( "${ctx}/GetDataList.do?cmd=getPartMgrAppList",param );
			break;
        case "Save":        	
        	IBS_SaveName(document.sheet1Form,sheet1);
        	// 삭제 처리만 저장
        	sheet1.DoSave( "${ctx}/SaveData.do?cmd=deletePartMgrApp", $("#sheet1Form").serialize()); break;
        	        	
		case "Down2Excel":
			var downcol = makeHiddenImgSkipCol(sheet1);
			
			var param  	= {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param);
			break;
		}
	}
	
	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } doAction1("Search"); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}
	
	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
						
			var param = "searchSabun="+$("#searchUserId").val()
			
			sheet2.DoSearch( "${ctx}/GetDataList.do?cmd=getPartMgrAppCurEmpList",param );
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

			//doAction2("Search");
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
		    }
		    
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}	

	//신청 팝업
	function showApplPopup(auth,applSeq,applInSabun,applYmd, applStatusCd) {
		if(auth == "") {
			alert("권한을 입력하여 주십시오.");
			return;
		}
		
		if(!isPopup()) {return;}

		var p = {
				searchApplCd: '330'
			  , searchApplSeq: applSeq
			  , adminYn: 'N'
			  , authPg: auth
			  , searchSabun: applInSabun
			  , searchApplSabun: $('#searchUserId').val()
			  , searchApplYmd: applYmd 
			  , searchOrgCd: $("#searchOrgCd").val() 
			};
		var url = "";
		var initFunc = '';
		if(applStatusCd == "" || applStatusCd == "11" ) {
			url     = "/ApprovalMgr.do?cmd=viewApprovalMgrLayer";
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
	
	function setEmpPage() {
		$("#searchSabun").val($("#searchUserId").val());
		//$("#searchName").val($("#searchKeyword").val());
		
		// 사번으로 OrgCd 조회
		var data = ajaxCall("${ctx}/GetDataList.do?cmd=getPartMgrAppOrgCd",$("#sheet1Form").serialize(),false);		
		$("#searchOrgCd").val(data.DATA[0].orgCd);
		
		doAction1("Search");
		doAction2("Search");
	}
	
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>
	<form id="sheet1Form" name="sheet1Form" >
	<input type="hidden" id="searchSabun" name="searchSabun" value=""/>
	<input type="hidden" id="searchOrgCd" name="searchOrgCd" value=""/>
		<div class="sheet_search outer" style="margin-top:10px;">
			<div>
				<table>
					<tr>
						<td colspan="4"><span>신청일자 </span>
							<input id="searchFromYmd" 	name="searchFromYmd" type="text" size="10" class="date2" value="<%=Integer.parseInt(DateUtil.getThisYear())-5%>-01-01" /> 
							~
							<input id="searchToYmd" 	name="searchToYmd" type="text" size="10" class="date2" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>"/>
						</td>
						<td colspan="2"> <span><tit:txt mid='112999' mdef='결재상태'/></span>
					<select id="searchApplStatusCd" name="searchApplStatusCd">
					</select> </td>
						<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a> </td>
					</tr>
				</table>

			</div>
		</div>
	</form>
 
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<colgroup>
		<col width="65%" />
		<col width="35%" />
	</colgroup>
	<tr>
		<td class="sheet_left">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt">서무변경신청내역</li>
					<li class="btn">
						<a href="javascript:showApplPopup('A','','${ssnSabun}','${curSysYyyyMMdd}','11');" class="button authR">신청</a>
						<a href="javascript:doAction1('Search');" class="basic">조회</a>
						<a href="javascript:doAction1('Save')" 	class="basic">저장</a>
						<a href="javascript:doAction1('Down2Excel');" class="basic">다운로드</a>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet1", "50%", "100%"); </script>
		</td>
		<td class="sheet_right">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt">현 서무정보</li>
					<li class="btn">
						<a href="javascript:doAction2('Search');" class="basic">조회</a>
						<a href="javascript:doAction2('Down2Excel')" class="basic authR">다운로드</a>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet2", "50%", "100%"); </script>
		</td>
	</tr>
	</table>
 

</body>
</html>
