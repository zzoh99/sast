<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='103788' mdef='월급여메일발송'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";
	$(function() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='check' mdef='선택'/>",		Type:"DummyCheck",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"check",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",			Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",			Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",			Type:"Text",	Hidden:Number("${aliasHdn}"),	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"alias",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='accResNoV1' mdef='주민번호'/>",		Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"resNo",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='grpNmV2' mdef='조직명'/>",			Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='grpIdV1' mdef='조직코드'/>",		Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"orgCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='jikgubCdV2' mdef='직급코드'/>",		Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='jikweeCdV2' mdef='직위코드'/>",		Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"statusCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",			Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",			Type:"Text",	Hidden:Number("${jgHdn}"),	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",			Type:"Text",	Hidden:Number("${jwHdn}"),	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='payTypeV3' mdef='PAY_TYPE'/>",		Type:"Text",	Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"payType",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='statusCdV5' mdef='재직상태'/>",		Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"statusNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='empYmdV3' mdef='입사일자'/>",		Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"empYmd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='handPhoneV2' mdef='핸드폰'/>",			Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"handPhone",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='mailcnt' mdef='HTML'/>",			Type:"Image",	Hidden:1,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"mailcnt",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='mailIdV5' mdef='메일'/>",			Type:"Text",	Hidden:0,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"mailId",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='mailtitle' mdef='메일제목'/>",		Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"mailtitle",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='mailseq' mdef='메일SEQ'/>",		Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"mailseq",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='mailcont' mdef='내용'/>",			Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"mailcont",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='tagurl' mdef='TAG'/>",			Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"tagurl",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='successYnV2' mdef='발송\n여부'/>",		Type:"Combo",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"successYn",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='contsize' mdef='Byte'/>",			Type:"Text",	Hidden:1,	Width:30,	Align:"Center",	ColMerge:0,	SaveName:"contsize",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetColProperty("successYn", 		{ComboText:"|발송|발송|미발송|발송실패", ComboCode:"|T|Y|F|N"} );
		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		//sheet1.SetFocusAfterProcess(0);

		getCpnLatestPaymentInfo();

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");

	});

	$(function() {
		$("#searchNameSabun").keyup(function(event) {
			if(event.keyCode == 13) {
				doAction1("Search");
			}
		});

		$("#searchSuccessYn").change(function(){
			doAction1("Search");
		});

	    $("#searchSbNm").bind("keyup",function(event){
	    	if( event.keyCode == 13){ searchEmp(); }
	    });
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/MonPayMailCre.do?cmd=getMonPayMailCreList", $("#mySheetForm").serialize(),1 );
			break;
		case "Save":
			if(!dupChk(sheet1,"workOrgCd|sdate", true, true)){break;}
			IBS_SaveName(document.mySheetForm,sheet1);
			sheet1.DoSave( "${ctx}/MonPayMailCre.do?cmd=saveMonPayMailCre", $("#mySheetForm").serialize());
			break;
		case "Insert":
			sheet1.SelectCell(sheet1.DataInsert(0), "workOrgCd");
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

	// 셀 변경시 발생
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		try {
			if(sheet1.GetSelectRow() > 0) {
				if(OldRow != NewRow && sheet1.ColSaveName(NewCol) != "check" ) {
					createHTML(sheet1.GetCellValue(NewRow, "sabun")) ;
				}
			}
		} catch (ex) {
			alert("OnSelectCell Event Error : " + ex);
		}
	}

	//  소속 팝업
    function orgSearchPopup(){
        try{
    		if(!isPopup()) {return;}
    		gPRow = "";
    		pGubun = "orgBasicPopup";

			var args    = new Array();
			var rv = openPopup("/Popup.do?cmd=orgBasicPopup", args, "740","520");
			/*
			if(rv!=null){

				$("#searchOrgCd").val(rv["orgCd"]);
				$("#searchOrgNm").val(rv["orgNm"]);

				doAction1("Search");

			}
			*/
        }catch(ex){alert("Open Popup Event Error : " + ex);}
    }

    // 급여일자 검색 팝업
    function payActionSearchPopup() {
    	try{
    		if(!isPopup()) {return;}
    		gPRow = "";
    		pGubun = "payDayPopup";

    		var w		= 840;
    		var h		= 520;
    		var url		= "/PayDayPopup.do?cmd=payDayPopup";
    		var args	= [];
    		args["runType"] = "00001,00002";

    		var result = openPopup(url+"&authPg=${authPg}", args, w, h);
			/*
    		if (result) {
    			var payActionCd	= result["payActionCd"];
    			var payActionNm	= result["payActionNm"];

    			$("#searchPayActionCd").val(payActionCd);
    			$("#searchPayActionNm").val(payActionNm);

    			doAction1("Search");
    		}
			*/
    	}catch(ex){alert("Open Popup Event Error : " + ex);}
    }

    function getReturnValue(returnValue) {
    	var rv = $.parseJSON('{' + returnValue+ '}');

        if(pGubun == "payDayPopup"){
    		$("#searchPayActionCd").val(rv["payActionCd"]);
    		$("#searchPayActionNm").val(rv["payActionNm"]);
        }else if(pGubun == "orgBasicPopup"){
			$("#searchOrgCd").val(rv["orgCd"]);
			$("#searchOrgNm").val(rv["orgNm"]);

			doAction1("Search");
        }
    }

	function searchEmp(){
		var inputTxt = $("#searchSbNm").val();

		for(var i = sheet1.HeaderRows(); i <= sheet1.LastRow(); i++){
			if (sheet1.GetCellValue(i, "name").indexOf(inputTxt) > -1) {
				sheet1.SelectCell(i, "name");
				return;
			}
			if (sheet1.GetCellValue(i, "sabun").indexOf(inputTxt) > -1) {
				sheet1.SelectCell(i, "sabun");
				return;
			}
		}
	}

	// 최근급여일자 조회
	function getCpnLatestPaymentInfo() {
		var procNm = "최근급여일자";
		// 급여구분(C00001-00001.급여)
		var paymentInfo = ajaxCall("${ctx}/CpnQuery.do?cmd=getCpnQueryList", "queryId=getCpnLatestPaymentInfoMap&procNm="+procNm+"&runType=00001", false);

		if (paymentInfo.DATA != null && paymentInfo.DATA != "" && typeof paymentInfo.DATA[0] != "undefined") {
			$("#searchPayActionCd").val(paymentInfo.DATA[0].payActionCd);
			$("#searchPayActionNm").val(paymentInfo.DATA[0].payActionNm);

			if ($("#payActionCd").val() != null && $("#payActionCd").val() != "") {
				//	doAction("Search");
			}
		} else if (paymentInfo.Message != null && paymentInfo.Message != "") {
			alert(paymentInfo.Message);
		}
	}
	/*
	* 전송될 메일 내용을 실제로 확인하도록 하는 로직 by JSG
	*/
	function createHTML(searchSabun) {

        if($('#searchPayActionCd').val() == ""){
        	alert("메일발송시 필요한  급여일자 값이 비어 있습니다.n다시 급여일자를 선택하여 주시기 바랍니다.");
            return;
        }
        /*************************************************************/
       	var sabunParam = "&receiverSabun=" + searchSabun ;

        var mailContens1 = ajaxCall("${ctx}/MonPayMailCre.do?cmd=getMonPayMailCreHTML1"+sabunParam, $("#mySheetForm").serialize(), false);
   		var mailContens2 = ajaxCall("${ctx}/MonPayMailCre.do?cmd=getMonPayMailCreHTML2"+sabunParam, $("#mySheetForm").serialize(), false);
   		var mailContens3 = ajaxCall("${ctx}/MonPayMailCre.do?cmd=getMonPayMailCreHTML3"+sabunParam, $("#mySheetForm").serialize(), false);
   		//var htmlStr = mailContens1.DATA.length + mailContens2.DATA.length + mailContens3.DATA.length;

   		if (mailContens1 != null && mailContens1.DATA != null) {
   			for(var i = 0; i<mailContens1.DATA.length; i++) {

   			}
   		}

   		if (mailContens2 != null && mailContens2.DATA != null) {
   			for(var i = 0; i<mailContens2.DATA.length; i++) {

   			}
   		}

   		if (mailContens3 != null && mailContens3.DATA != null) {
   			for(var i = 0; i<mailContens3.DATA.length; i++) {

   			}
   		}
   	     var htmlStr =
   	   		"<table width=600>"+
   	        "<tr>"+
   	        "<th  height=\"20\" style=\"text-align:center\"><tit:txt mid='114141' mdef='지급일 : "+mailContens1.DATA[0].paymentYmd+"'/></th></tr>"+
   	        "</table>"+
   	        "<table width=\"600\" height=\"300\"  border=\"1\" cellspacing=\"0\" cellpadding=\"0\" bordercolor=\"#000000\" style=\"border-collapse:collapse\">"+
   	        "<tr bgcolor=\"#CCCCCC\" height=24>"+
   	        "<td height=\"45\"  colspan=\"4\"><table width=100%>"+
   	        "<tr>"+
   	        "<th width=\"14%\" height=\"10\"><tit:txt mid='113445' mdef='&nbsp;사&nbsp;&nbsp;&nbsp;&nbsp;번:'/></th>"+
   	        "<td width=\"20%\">"+ mailContens1.DATA[0].sabun +"</td>"+
   	        "<th width=\"14%\"><tit:txt mid='112383' mdef='&nbsp;사원명: '/></th>"+
   	        "<td width=\"20%\">"+mailContens1.DATA[0].krName+"</td>"+
   	        "<th width=\"14%\"><tit:txt mid='112040' mdef='&nbsp;입사일:'/></th>"+
   	        "<td width=\"20%\">"+mailContens1.DATA[0].empYmd+"</td>"+
   	        "</tr>"+
   	        "<tr>"+
   	        "<th height=\"10\"><tit:txt mid='112384' mdef='&nbsp;부&nbsp;&nbsp;&nbsp;&nbsp;서:'/></th>"+
   	        "<td>"+mailContens1.DATA[0].orgNm+"</td>"+
   	        "<th><tit:txt mid='112722' mdef='&nbsp;직&nbsp;&nbsp;위:'/></th>"+
   	        "<td>"+mailContens1.DATA[0].jikweeNm+"</td>"+
   	        "<th>&nbsp;</th>"+
   	        "<td>&nbsp;</td>"+
   	        "</tr>"+
   	        "</table></td>"+
   	        "</tr>"+


   	        "<tr valign=\"top\">"+
   	        "<td width=\"25%\" rowspan=\"2\" height=\"352\">" ;

   	        for(var i=0; i<18;i++){
   	        	if( i < mailContens2.DATA.length ) {
	   	    		htmlStr = htmlStr + mailContens2.DATA[i].reportNm + "<br>";
   	        	} else {
	   	    		htmlStr = htmlStr + "<br>";
   	        	}
   	    	}
   	        htmlStr = htmlStr+

   	        "</td>"+
   	        "<td width=\"25%\" rowspan=\"2\" align=\"right\">";

   	        for(var i=0; i<18;i++){
   	        	if( i < mailContens2.DATA.length ) {
	   	    		htmlStr = htmlStr + mailContens2.DATA[i].resultMon + "<br>";
   	        	} else {
	   	    		htmlStr = htmlStr + "<br>";
   	        	}
   	    	}
   	        htmlStr = htmlStr+

   	        "</td>"+
   	        "<td width=25% height=\"270\">";
   	        for(var i=0; i<18;i++){
   	        	if( i < mailContens3.DATA.length ) {
	   	    		htmlStr = htmlStr +  mailContens3.DATA[i].reportNm  + "<br>";
   	        	} else {
	   	    		htmlStr = htmlStr + "<br>";
   	        	}
   	    	}
   	        htmlStr = htmlStr+

   	        "</td>"+
   	        "<td width=25% align=\"right\">";
   	        for(var i=0; i<18;i++){
   	        	if( i < mailContens3.DATA.length ) {
	   	    		htmlStr = htmlStr +  mailContens3.DATA[i].resultMon + "<br>";
   	        	} else {
	   	    		htmlStr = htmlStr + "<br>";
   	        	}
   	    	}
   	        htmlStr = htmlStr+

   	        "</td>"+
   	        "</tr>"+
   	        "<tr bgcolor=\"#CCCCCC\">"+
   	        "<th height=\"29\" style=\"text-align:center\"><tit:txt mid='113799' mdef='&nbsp;공 제 액 계'/></th>"+
   	        "<th align=\"right\">"+mailContens1.DATA[0].totDedMon+"</th>"+
   	        "</tr>"+
   	        "<tr bgcolor=\"#CCCCCC\">"+
   	        "<th height=\"29\" style=\"text-align:center\"><tit:txt mid='112041' mdef='&nbsp;지 급 액 계'/></th>"+
   	        "<th align=\"right\">"+mailContens1.DATA[0].totEarningMon+"</th>"+
   	        "<th style=\"text-align:center\"><tit:txt mid='114524' mdef='&nbsp;차인지급액'/></th>"+
   	        "<th align=\"right\">"+mailContens1.DATA[0].paymentMon+"</th>"+
   	        "</tr>"+
   	        "</table>"+
   	        "<table width=600>"+
   	        "<tr><td  height=\"20\" align=\"right\"><tit:txt mid='113446' mdef='귀하의 노고에  진심으로 감사합니다.'/></td></tr>"+
   	        "<tr><td align=center><tit:txt mid='113093' mdef='위 내역은 e-HR 급여관리(개인별급여내역)에서 재확인 가능합니다.'/></td></tr>" +
   	        "</table>" ;
   		/////////////////////////////////////////////////////////////////////////////
   		$("#mailHtml").html(htmlStr) ;
		submitCall($("#mySheetForm"),"mailPage_ifrmsrc","post","${ctx}/MonPayMailCre.do?cmd=callMonPayMailCreIfrm");
	}


	function emailCheck(obj) {
        var regExp = /([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;

	    if (!regExp.test($(obj).val())) {
	    	alert('이메일 주소가 유효하지 않습니다');
	        $(obj).focus();
	        $(obj).select();
	        return false;
	    }
	    return true;
	}

	/*
	* 선택된 사원들에게 각각의 데이터를 비즈니스로직단에서 HTML화 하여 메일로 전송하는 로직 by JSG
	*/
	function sendMail() {

		var fromEmail = "";
		if($("#sendEmail").val() == ""){
			alert("<msg:txt mid='alertMonPayMailCre3' mdef='발신자 Email을 입력하세요.'/>");
			return;
		}else{
			if(emailCheck($("#sendEmail")) == false){
				return;
			}else{
				fromEmail = $("#sendEmail").val();
			}
		}

		progressBar(true) ;

		var sabuns = "";
        var checked = "";
        var searchAllCheck = "";
        var sabunCnt = 0;

        if(sheet1.RowCount() != 0) {
            for(i=1; i<=sheet1.RowCount(); i++) {

                checked = sheet1.GetCellValue(i, "check");
                if (checked == "1" || checked == "Y") {

                	if(sheet1.GetCellValue( i, "mailId" ) != ""){
                		sabuns += ""+sheet1.GetCellValue( i, "sabun" ) + ",";
                	}
                }
            }

            sabuns = sabuns.substr(0,sabuns.length-1);
            if (sabuns.length < 1) {
            	alert("<msg:txt mid='alertMonPayMailCre4' mdef='선택된 사원이 없습니다.'/>");
        		progressBar(false) ;
                return;
            }

        } else {
        	alert("<msg:txt mid='alertMonPayMailCre4' mdef='선택된 사원이 없습니다.'/>");
    		progressBar(false) ;
            return;
        }
        $("#sabuns").val(sabuns) ;
        $("#balsin").val(fromEmail);

		if(!confirm("선택된 사원들에게 메일발송을 실행하시겠습니까?")) { progressBar(false) ; return ; }
		ajaxCall("${ctx}/Send.do?cmd=postMonPayMailCreCallMail",$("#mySheetForm").serialize(),false);

		progressBar(false) ;
		alert("<msg:txt mid='alertMonPayMailCre6' mdef='메일 전송이 완료되었습니다.'/>") ;
		doAction1('Search') ;
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="mySheetForm" name="mySheetForm" >
		<span id="mailHtml" class="hide"> </span>
		<input type="hidden" id="sabuns" name="sabuns">
		<input type="hidden" id="balsin" name="balsin">
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='104477' mdef='급여일자'/></th>
						<td>
							<input type="hidden" id="searchPayActionCd" name="searchPayActionCd" value="" /><input type="hidden" id="sabun" name="sabun" class="text" value="" />
							<input type="text" id="searchPayActionNm" name="searchPayActionNm" class="text" value="" validator="required" readonly="readonly" style="width:120px" />
							<a onclick="javascript:payActionSearchPopup();return false;" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
						</td>
						<th>소속 </th>
						<td>
							<input id="searchOrgNm" name ="searchOrgNm" type="text" class="text readonly" readOnly style="width:120px"/>
							<input type="hidden" id="searchOrgCd" name="searchOrgCd" class="text" value="" />
							<a onclick="javascript:orgSearchPopup();return false;" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
							<a onclick="$('#searchOrgCd,#searchOrgNm').val('');return false;" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
						</td>
						<th><tit:txt mid='104330' mdef='사번/성명'/></th>
						<td>
							<input id="searchNameSabun" name="searchNameSabun" type="text" class="text" />
						</td>
						<th>발송여부 </th>
						<td>
							<select id="searchSuccessYn" name="searchSuccessYn">
								<option value="">전체</option>
								<option value="T,Y">발송</option>
								<option value="F,N">미발송</option>
							</select>
						</td>
						<td><btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/></td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main" style="height:100%">
	<colgroup>
		<col width="50%" />
		<col width="50%" />
	</colgroup>
	<tr >
		<td class="sheet_left">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid='monPayMailCre1' mdef='월급여 메일발송'/></li>
					<li class="btn">
						사번/성명
                        <input type="text" id="searchSbNm" name="searchSbNm" class="text" value="" style="width:70px;"/>
						<btn:a href="javascript:searchEmp();"		css="button" mid='110799' mdef="검색"/>

						<!-- <a href="javascript:createHTML();" class="pink authA"><tit:txt mid='114525' mdef='생성'/></a>
						<a href="javascript:doAction1('Save');" class="basic authA"><tit:txt mid='104476' mdef='저장'/></a> -->
						<btn:a href="javascript:doAction1('Down2Excel');" css="basic authA" mid='110698' mdef="다운로드"/>
						발송Email
						<input type="text" id="sendEmail" name="sendEmail" class="text" value="" style="width:120px;"/>
						<a href="javascript:sendMail();" class="pink authA"><tit:txt mid='112605' mdef='메일발송'/></a>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet1", "50%", "100%", "${ssnLocaleCd}"); </script>
		</td>
		<td class="sheet_right" style="height:100%">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt">메일발송내역
					</li>
					<li class="btn">
					</li>
				</ul>
				</div>
			</div>
			<div style="height:100%">
			<iframe name="mailPage_ifrmsrc" id="mailPage_ifrmsrc" frameborder='0' class='' style="width:100%;height:82%;"></iframe>
			</div>
		</td>
	</tr>
	</table>
</div>
</body>
</html>
