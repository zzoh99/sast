<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='114682' mdef='퇴직자 Check List 세부내역'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var searchApplSeq = "${searchApplSeq}";
	var searchSabun = "${searchSabun}";
	var searchApplSabun = "${searchApplSabun}";
	var searchApplYmd = "${searchApplYmd}";
	var adminYn = "${adminYn}";
	var authPg = "${authPg}";
	var ssnSabun = '${ssnSabun}';
	
	
	$(function() {
		$("#searchApplSeq").val(searchApplSeq);
		$("#searchSabun").val(searchSabun);
		$("#searchApplSabun").val(searchApplSabun);
		$("#searchApplYmd").val(searchApplYmd);

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
   			{Header:"<sht:txt mid='statusCd' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='chkItem' mdef='항목'/>",			Type:"Text",		Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"chkItem",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:4000 ,Wrap:1, MultiLineText:1},
			{Header:"<sht:txt mid='chkOrgnm' mdef='부서'/>",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"chkOrgnm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
			{Header:"<sht:txt mid='chkJikwee' mdef='직위'/>",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"chkJikwee",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
			{Header:"<sht:txt mid='chkSabun' mdef='담당자'/>",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"chkSabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
			
			{Header:"<sht:txt mid='chkName' mdef='담당자'/>",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"chkName",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
			{Header:"<sht:txt mid='chkResult' mdef='결과'/>",			Type:"Combo",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"chkResult",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='rmk' mdef='비고'/>",				Type:"Text",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"rmk",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2000 ,Wrap:1, MultiLineText:1},
			{Header:"<sht:txt mid='chkTm' mdef='확인일시'/>",		    Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"chkTm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			
			{Header:"<sht:txt mid='seq' mdef='seq'/>",				Type:"Text",		Hidden:1,	Width:10,	Align:"Center",	ColMerge:0,	SaveName:"seq",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='rdate' mdef='rdate'/>",			Type:"Date",		Hidden:1,	Width:10,	Align:"Center",	ColMerge:0,	SaveName:"rdate",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='chkid' mdef='chkid'/>",			Type:"Text",		Hidden:1,	Width:10,	Align:"Center",	ColMerge:0,	SaveName:"chkid",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },

			{Header:"<sht:txt mid='gubunNm' mdef='gubunNm'/>",		Type:"Text",		Hidden:1,	Width:10,	Align:"Center",	ColMerge:0,	SaveName:"gubunNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			
			{Header:"<sht:txt mid='applSeq' mdef='applSeq'/>",		Type:"Text",		Hidden:1,	Width:10,	Align:"Center",	ColMerge:0,	SaveName:"applSeq",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='applStatusCd' mdef='applStatusCd'/>",		Type:"Text",		Hidden:1,	Width:10,	Align:"Center",	ColMerge:0,	SaveName:"applStatusCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
			
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(true);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetColProperty("chkResult", 				{ComboText:"|확인완료|이슈있음", 	ComboCode:"|10|20"} );
		$(window).smartresize(sheetResize); sheetInit(); 
		parent.iframeOnLoad("300px");

		doAction1("Search");
	});

	$(function() {
		/*
		if(authPg == "A") {
			
		}else{
			sheet1.SetEditable(true);
		}
		 */
		
	 
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			 
			var param = "searchApplSeq="+$("#searchApplSeq").val()	
			+"&searchSabun="+$("#searchSabun").val()					
			+"&searchApplYmd="+$("#searchApplYmd").val();
			sheet1.DoSearch( "${ctx}/RetireApp.do?cmd=getRetireCheckListAppDet", param);
			break;
		case "Save":			
			IBS_SaveName(document.sheet1Form,sheet1); 
			sheet1.DoSave( "${ctx}/RetireApp.do?cmd=saveRetireCheckListMgr", $("#sheet1Form").serialize());
			break;
		}
	}

	
	// 저장후 리턴함수
	function setValue(status) {
		var saveStr;
		var rtn;
		var returnValue = false;
		// 항목 체크 리스트

		try {

			IBS_SaveName(document.sheet1Form,sheet1);
			var rtn = ajaxCall("${ctx}/RetireApp.do?cmd=saveRetireCheckListMgr", $("#sheet1Form").serialize());

			if(rtn.Result.Code < 1) {
				alert(rtn.Result.Message);
				returnValue = false;
			} else {
				returnValue = true;
			}


		} catch (ex){
			alert("저장 중 오휴발생." + ex);
			returnValue = false;
		}

		return returnValue;
	}
	
	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			//희망퇴직일 세팅
			$("#gubunNm").text(sheet1.GetCellValue(sheet1.LastRow(),"gubunNm"));
			var rdate = sheet1.GetCellValue(sheet1.LastRow(),"rdate");
			$("#textRdate").val(rdate.substr(0,4) + "-"+rdate.substr(4,2)+"-"+rdate.substr(6,2));
			
			
			for(var i=sheet1.HeaderRows(); i <sheet1.RowCount()+sheet1.HeaderRows(); i++){
				if(sheet1.GetCellValue(i,"chkSabun") == ssnSabun){
					sheet1.SetRowEditable(i,1);
				}else if (sheet1.GetCellValue(i,"chkSabun") == sheet1.GetCellValue(i,"chkid")){
					sheet1.SetRowEditable(i,0);
				}else{
					sheet1.SetRowEditable(i,0);
				}

				sheet1.SetCellBackColor(i,"chkResult","#FFFFFF");
				sheet1.SetCellBackColor(i,"rmk","#FFFFFF");		
				
			}
			
			if (sheet1.GetCellValue(1,"applStatusCd") == "99") {
				$("#saveBtn").hide();
			}
			else {
				$("#saveBtn").show();
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
			
			//퇴직체크리스트 체크결과(CHK_RESULT) 가 모두 NOT NULL 이면 퇴직체크리스트 신청서 완료(99) 처리
			var param = "applSeq="+sheet1.GetCellValue(1,"applSeq");
			var data = ajaxCall("/RetireApp.do?cmd=prcHrmRetireCheckCnt",param,false);
			
			//doAction1("Search");			
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
 
	// 날짜 포맷을 적용한다..
	function formatDate(strDate, saper) {
		if(strDate == "" || strDate == null) {
			return "";
		}

		if(strDate.length == 10) {
			return strDate.substring(0,4)+saper+strDate.substring(5,7)+saper+strDate.substring(8,10);
		} else if(strDate.length == 8) {
			return strDate.substring(0,4)+saper+strDate.substring(4,6)+saper+strDate.substring(6,8);
		}
	}

	 
</script>
</head>
<body class="bodywrap">
<form id="sheet1Form" name="sheet1Form">

<input type="hidden" id="searchApplSabun"	name="searchApplSabun"	value=""/>
	<input type="hidden" id="searchApplSeq"	name="searchApplSeq"	value=""/>
 	<input type="hidden" id="searchSabun"	name="searchSabun"	value=""/>
 	<input type="hidden" id="searchApplYmd"	name="searchApplYmd"	value=""/>


</form>
<div class="wrapper">
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='114682' mdef='신청내용'/><font size="1")>&nbsp;&nbsp;&nbsp; 추가 내용 기재 필요 시 신청서 하단 '참조의견' 클릭하여 기재</font></li>
			
		</ul>
		
		</div>
	</div>
	<table border="0" cellpadding="0" cellspacing="0" class="table">
	<colgroup>
		<col width="10%" />
		<col width="" />
		<col width="10%" />
	</colgroup>
	<tr>
		<th><span id="gubunNm" name="gubunNm"></span></th>
		<td>
			<input id="textRdate" name="textRdate" type="text" size="10" class="date2 transparent" />
		</td>
		<td >
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="btn" id="saveBtn">
						<btn:a href="javascript:doAction1('Save');" css="basic authR" mid='save' mdef="결재"/>
					</li>
				</ul>
				</div>
			</div>	
		</td>
	</tr>
		
	<tr height="300px">
		<td colspan="3">
			<script type="text/javascript"> createIBSheet("sheet1", "100%", "300px", "${ssnLocaleCd}"); </script>
		</td>
	</tr>
	
	</table>

</div>
</body>
</html>
