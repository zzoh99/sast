<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='recAppmtDetail' mdef='채용발령내역'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("${popUpStatus}");
	var arrParam = p.popDialogArgumentAll();
	var receiveNo = arrParam['receiveNo']||"";

	$(function() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",								Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='seq' mdef='일련번호'/>",							Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"receiveNo",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"<sht:txt mid='regYmd' mdef='입력일'/>",							Type:"Date",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"regYmd",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='ordDetailCd' mdef='발령'/>",						Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"ordDetailCd",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='teacherNm' mdef='성명'/>",							Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='resNo2' mdef='주민번호'/>",							Type:"Text",	Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"resNo",		KeyField:1,	Format:"IdNo",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"<sht:txt mid='sexTypeV1' mdef='성별'/>",							Type:"Combo",	Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"sexType",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"<sht:txt mid='birthYmd' mdef='생년월일'/>",						Type:"Date",	Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"birYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='orgYn' mdef='소속'/>",								Type:"Popup",	Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='orgCdV1' mdef='소속코드'/>",						Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"orgCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='jikchakYn' mdef='직책'/>",							Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikchakCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='jikweeYn' mdef='직위'/>",							Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='jikgubYn' mdef='직급'/>",							Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='workYn' mdef='직군'/>",							Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"workType",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='manageCd' mdef='사원구분'/>",						Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"manageCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='payType' mdef='급여유형'/>",						Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"payType",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='salClassNm' mdef='호봉'/>",						Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"salClass",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='locationNm_V1358' mdef='근무지\n(Location)'/>",		Type:"Popup",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"locationNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='locationCd_V1359' mdef='근무지\n(Location)코드'/>",	Type:"Combo",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"locationCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='jobYn' mdef='직무'/>",								Type:"Popup",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jobNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='moveJikgunJobCd' mdef='직무코드'/>",				Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"jobCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='gempYmd' mdef='그룹입사일'/>",						Type:"Date",	Hidden:Number("${gempYmdHdn}"),	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"gempYmd",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='empYmdYn' mdef='입사일'/>",						Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"empYmd",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='traYmdYn' mdef='수습종료일'/>",						Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"traYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='contractSymd' mdef='발령기간\n시작일'/>",				Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"contractSymd",KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='contractEymd' mdef='발령기간\n종료일'/>",				Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"contractEymd",KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },

			
			{Header:"포인트",															Type:"Text",	Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"sgPoint",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			
			//사용안함
			{Header:"<sht:txt mid='ctitleChgYmd' mdef='직위변경일'/>",					Type:"Date",	Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"ctitleChgYmd",KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='fpromYmd' mdef='직급변경일'/>",						Type:"Date",	Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"fpromYmd",	KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='enterPay' mdef='입사시연봉\n(만원)'/>",				Type:"Int",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"enterPay",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"<sht:txt mid='payGroupCd' mdef='pay그룹'/>",						Type:"Combo",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"payGroupCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 }
		]; IBS_InitSheet(sheet1, initdata1);

		sheet1.SetEditable(false);
		sheet1.SetVisible(false);
		sheet1.SetCountPosition(4);

		var sexType = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H00010"), "");
		var ordDetailCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdDetailCdList",false).codeList, "");	//발령종류
		var manageCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10030"), "");
		var locationCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getLocationCdList",false).codeList, "");	//LOCATION
		var jikchakCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20020"), "");
		var workType = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10050"), "");
		var jikweeCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20030"), "");
		var payType = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10110"), "");
		var jikgubCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20010"), "");
		var payGroupCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20060"), "");
		var salClass = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C10000"), "");

		sheet1.SetColProperty("sexType", 			{ComboText:"|"+sexType[0], ComboCode:"|"+sexType[1]} );
		sheet1.SetColProperty("ordDetailCd", 		{ComboText:"|"+ordDetailCd[0], ComboCode:"|"+ordDetailCd[1]} );
		sheet1.SetColProperty("manageCd", 			{ComboText:"|"+manageCd[0], ComboCode:"|"+manageCd[1]} );
		sheet1.SetColProperty("locationCd", 		{ComboText:"|"+locationCd[0], ComboCode:"|"+locationCd[1]} );
		sheet1.SetColProperty("jikchakCd", 			{ComboText:"|"+jikchakCd[0], ComboCode:"|"+jikchakCd[1]} );
		sheet1.SetColProperty("workType", 			{ComboText:"|"+workType[0], ComboCode:"|"+workType[1]} );
		sheet1.SetColProperty("jikweeCd", 			{ComboText:"|"+jikweeCd[0], ComboCode:"|"+jikweeCd[1]} );
		sheet1.SetColProperty("payType", 			{ComboText:"|"+payType[0], ComboCode:"|"+payType[1]} );
		sheet1.SetColProperty("jikgubCd", 			{ComboText:"|"+jikgubCd[0], ComboCode:"|"+jikgubCd[1]} );
		sheet1.SetColProperty("payGroupCd", 		{ComboText:"|"+payGroupCd[0], ComboCode:"|"+payGroupCd[1]} );
		//sheet1.SetColProperty("salClass", 			{ComboText:"|"+salClass[0], ComboCode:"|"+salClass[1]} );

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	$(function() {
        $(".close").click(function() {
	    	p.self.close();
	    });
	});

	//Sheet0 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var param = "receiveNo="+receiveNo;
			sheet1.DoSearch( "${ctx}/GetDataList.do?cmd=getSabunCreAppmtPopList", param);
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
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 시트에서 폼으로 세팅.
	function getSheetData() {

		var row = sheet1.LastRow();

		if(row == 0) {
			return;
		}

		$('#name').val(sheet1.GetCellValue(row,"name"));
		$('#regYmd').val(sheet1.GetCellText(row,"regYmd"));
		$('#birYmd').val(sheet1.GetCellText(row,"birYmd"));
		$('#sexTypeNm').val(sheet1.GetCellText(row,"sexType"));
		//$('#ordDetailNm').val(sheet1.GetCellText(row,"ordDetailCd"));
		$('#empYmd').val(sheet1.GetCellText(row,"empYmd"));
		$('#manageNm').val(sheet1.GetCellText(row,"manageCd"));
		$('#locationNm').val(sheet1.GetCellText(row,"locationCd"));
		$('#orgNm').val(sheet1.GetCellValue(row,"orgNm"));
		$('#jikchakNm').val(sheet1.GetCellText(row,"jikchakCd"));
		$('#workTypeNm').val(sheet1.GetCellText(row,"workType"));
		$('#jobNm').val(sheet1.GetCellValue(row,"jobNm"));
		$('#jikweeNm').val(sheet1.GetCellText(row,"jikweeCd"));
		$('#jikgubNm').val(sheet1.GetCellText(row,"jikgubCd"));
		$('#traYmd').val(sheet1.GetCellText(row,"traYmd"));
		$('#gempYmd').val(sheet1.GetCellText(row,"gempYmd"));
		$('#ctitleChgYmd').val(sheet1.GetCellText(row,"ctitleChgYmd"));
		$('#fpromYmd').val(sheet1.GetCellText(row,"fpromYmd"));
		$('#payTypeNm').val(sheet1.GetCellText(row,"payType"));
		$('#salClassNm').val(sheet1.GetCellText(row,"salClass"));
		$('#enterPayNm').val(sheet1.GetCellText(row,"enterPay"));
		$('#contractSymd').val(sheet1.GetCellText(row,"contractSymd"));
		$('#contractEymd').val(sheet1.GetCellText(row,"contractEymd"));
		$('#payGroupNm').val(sheet1.GetCellText(row,"payGroupCd"));
		
		$('#sgPointNm').val(sheet1.GetCellText(row,"sgPoint"));
		
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

		return strDate;
	}

</script>
</head>

<body class="bodywrap">
	<div class="wrapper">
        <div class="popup_title">
            <ul>
                <li><tit:txt mid='recAppmtDetail' mdef='채용발령내역'/></li>
                <li class="close"></li>
            </ul>
        </div>

        <div class="popup_main">
			<table border="0" cellpadding="0" cellspacing="0" class="default">
			<colgroup>
				<col width="15%" />
				<col width="35%" />
				<col width="15%" />
				<col width="35%" />
			</colgroup>
			<tr>
				<th><tit:txt mid='112113' mdef='입력일'/></th>
				<td><input id="regYmd" name="regYmd" type="text" class="${textCss} w100p" readonly></td>
				<th><tit:txt mid='103939' mdef='수습종료일'/></th>
				<td>
					<input id="traYmd" name="traYmd" type="text" class="${textCss} w100p" readonly>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='103880' mdef='성명'/></th>
				<td>
					<input id="name" name="name" type="text" class="${textCss} w100p" readonly>
				</td>
				<th><tit:txt mid='104011' mdef='성별'/></th>
				<td>
					<input id="sexTypeNm" name="sexTypeNm" type="text" class="${textCss} w100p" readonly>
				</td>
			</tr>

			<tr>
				<th><tit:txt mid='104279' mdef='소속'/></th>
				<td>
					<input id="orgNm" name="orgNm" type="text" class="${textCss} w100p" readonly>
				</td>
				<th><tit:txt mid='103785' mdef='직책'/></th>
				<td>
					<input id="jikchakNm" name="jikchakNm" type="text" class="${textCss} w100p" readonly>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='104104' mdef='직위'/></th>
				<td>
					<input id="jikweeNm" name="jikweeNm" type="text" class="${textCss} w100p" readonly>
				</td>
				<th><tit:txt mid='104471' mdef='직급'/></th>
				<td>
					<input id="jikgubNm" name="jikgubNm" type="text" class="${textCss} w100p" readonly>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='104089' mdef='직군'/></th>
				<td>
					<input id="workTypeNm" name="workTypeNm" type="text" class="${textCss} w100p" readonly>
				</td>
				<th><tit:txt mid='103784' mdef='사원구분'/></th>
				<td>
					<input id="manageNm" name="manageNm" type="text" class="${textCss} w100p" readonly>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='113330' mdef='급여유형'/></th>
				<td>
					<input id="payTypeNm" name="payTypeNm" type="text" class="${textCss} w100p" readonly>
				</td>
				<th><tit:txt mid='114617' mdef='호봉'/></th>
				<td>
					<input id="salClassNm" name="salClassNm" type="text" class="${textCss} w100p" readonly>
				</td>
			</tr>
							<tr>
				<th>포인트</th>
				<td>
					<input id="sgPointNm" name="sgPointNm" type="text" class="${textCss} w100p" readonly>
				</td>
				<th><tit:txt mid='103973' mdef='직무'/></th>
				<td>
					<input id="jobNm" name="jobNm" type="text" class="${textCss} w100p" readonly>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='104473' mdef='그룹입사일'/></th>
				<td>
					<input id="gempYmd" name="gempYmd" type="text" class="${textCss} w100p" readonly>
				</td>
				<th><tit:txt mid='103881' mdef='입사일'/></th>
				<td>
					<input id="empYmd" name="empYmd" type="text" class="${textCss} w100p" readonly>
				</td>
			</tr>
			<tr class="hide">
				<th><tit:txt mid='114618' mdef='발령기간 시작일'/></th>
				<td>
					<input id="contractSymd" name="contractSymd" type="text" class="${textCss} w100p" readonly>
				</td>
				<th><tit:txt mid='113177' mdef='발령기간 종료일'/></th>
				<td>
					<input id="contractEymd" name="contractEymd" type="text" class="${textCss} w100p" readonly>
				</td>
			</tr>
			<tr class="hide">
				<th><tit:txt mid='104534' mdef='직위변경일'/></th>
				<td>
					<input id="ctitleChgYmd" name="ctitleChgYmd" type="text" class="${textCss} w100p" readonly>
				</td>
				<th><tit:txt mid='104234' mdef='직급변경일'/></th>
				<td>
					<input id="fpromYmd" name="fpromYmd" type="text" class="${textCss} w100p" readonly>
				</td>
			</tr>
			<tr class="hide">
				<th><tit:txt mid='113524' mdef='입사시연봉(만원)'/></th>
				<td>
					<input id="enterPayNm" name="enterPayNm" type="text" class="${textCss} w100p" readonly>
				</td>
				<th><tit:txt mid='112747' mdef='pay그룹'/></th>
				<td>
					<input id="payGroupNm" name="payGroupNm" type="text" class="${textCss} w100p" readonly>
				</td>
			</tr>
			</table>

			<div class="hide">
				<script type="text/javascript"> createIBSheet("sheet1", "0", "0", "${ssnLocaleCd}"); </script>
			</div>

			<div class="popup_button outer">
			<ul>
				<li>
					<btn:a href="javascript:p.self.close();" css="gray large" mid='close' mdef="닫기"/>
				</li>
			</ul>
			</div>
		</div>
	</div>
</body>
</html>
