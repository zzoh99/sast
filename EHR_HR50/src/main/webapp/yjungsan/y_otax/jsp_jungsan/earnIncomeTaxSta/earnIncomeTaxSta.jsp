<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>원천징수영수증 출력</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<!--
 * 원천징수영수증출력
 * @author JM
-->
<script type="text/javascript">
$(function() {
	
	/*영문은 브로제 전용*/
	
	var initdata = {};
	initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly}; 
	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
	initdata.Cols = [
		{Header:"No",	Type:"<%=sNoTy%>",	Hidden:Number("<%=sNoHdn%>"),	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"삭제",	Type:"<%=sDelTy%>",	Hidden:Number("<%=sDelHdn%>"),	Width:"<%=sDelWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
		{Header:"상태",	Type:"<%=sSttTy%>",	Hidden:Number("<%=sSttHdn%>"),	Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
		{Header:"전체",	Type:"CheckBox",	Hidden:0,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"rd_check_box",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
		{Header:"소득구분",Type:"Combo",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"earner_cd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"사번",	Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"성명",	Type:"Popup",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
   	]; IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(0);

	//------------------------------------- 조회조건 콤보 -------------------------------------//
	// 사업장(TORG109)
	var tcpn121Cd = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList", "getTorg109List"), "전체");
	$("#businessPlaceCd").html(tcpn121Cd[2]);
	
	// 소득구분(C00502)
	var earnerCd = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchYM=<%=curSysYear%>"+"-"+"<%=curSysMon%>", "getEtcEarnerCdList"), "");
	sheet1.SetColProperty("earner_cd", {ComboText:"|"+earnerCd[0], ComboCode:"|"+earnerCd[1]});
	$("#earnerCd").html(earnerCd[2].replace('<option value=\'11\'>거주자의 기타소득</option>', ''));
	
	// 영수증구분(C00315)
	var purposeCd = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYM=<%=curSysYear%>"+"-"+"<%=curSysMon%>", "C00315"), "");
	$("#purposeCd").html(purposeCd[2]);

	$(window).smartresize(sheetResize);
	sheetInit();

	$("#year").bind("keyup",function(event) {
		makeNumber(this, 'A');
	});
	$("#month").bind("keyup",function(event) {
		makeNumber(this, 'A');
	});
	$("#sabunName").bind("keyup",function(event) {
		if (event.keyCode == 13) {
			doAction1("Search");
		}
	});
	
	$("#printYmd").datepicker2();
	$("#printYmd").val("<%=curSysYear%>"+"-"+"<%=curSysMon%>"+"-"+"<%=curSysDay%>");

	$("#year").val("<%=curSysYear%>");
	$("#month").val("<%=curSysMon%>");
	
	$("#year, #month").bind("keyup",function(event){
		if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
	});
	
		
	//doAction1("Search");
});

function chkInVal(sAction) {
	if (sAction == "Rd") {
		if ($("#purposeCd").val() == "") {
			alert("용도를 선택하십시오.");
			$("#purposeCd").focus();
			return false;
		}
		if ($("#earnerCd").val() == "") {
			alert("소득구분을 선택하십시오.");
			$("#earnerCd").focus();
			return false;
		}
		if ($("#printYmd").val() == "") {
			alert("출력일자를 입력하십시오.");
			$("#printYmd").focus();
			return false;
		}
	}

	return true;
}

function doAction1(sAction) {
	switch (sAction) {
		case "Search":
			if ($("#earnerCd").val() == "") {
				alert("소득구분을 선택하십시오.");
				$("#earnerCd").focus();
				return;
			}			
			sheet1.DoSearch("<%=jspPath%>/earnIncomeTaxSta/earnIncomeTaxStaRst.jsp?cmd=selectEarnIncomeTaxStaList", $("#sheet1Form").serialize());
			break;

		case "Clear":
			sheet1.RemoveAll();
			break;

		case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
			break;

		case "Rd":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			// 보고서 출력
			callRd();
			break;
			
		case "RdEng":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			// 보고서 출력
			callRdEng();
			break;
	}
}

// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } sheetResize();	} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

//보고서 출력
function callRd() {
	var w 		= 840;
	var h 		= 480;
	var url 	= "<%=jspPath%>/common/rdPopup.jsp";
	var args 	= new Array();
	// args의 Y/N 구분자는 없으면 N과 같음

	var rdTitle = "";
	var reportFileNm = "";
	var sabuns = "";
	var earnerCd = $("#earnerCd").val();
	var imgPath = "<%=rdStempImgUrl%>";
	var checkYn = "N";
	var rowCnt = sheet1.RowCount();
	for (var i=1; i<=rowCnt; i++) {
		if (sheet1.GetCellValue(i, "rd_check_box") == "1") {
			sabuns += "'" + sheet1.GetCellValue(i, "sabun") + "',";
			checkYn = "Y";
		}
	}
	if (checkYn == "N") {
		alert("선택된 직원이 없습니다.");
		return;
	}
	if (sabuns.length > 1) {
		sabuns = sabuns.substr(0,sabuns.length-1);
	} else {
		alert("선택된 사원이 없습니다.");
		return;
	}

	switch (earnerCd) {
		case "3":
	    	reportFileNm = "EtcEarnWithholdReceipt2.mrd";
			rdTitle = "사업소득원천징수영수증";
			break;

		case "5":
	    	reportFileNm = "EtcEarnWithholdReceipt.mrd";
			rdTitle = "기타소득원천징수영수증";
			break;

		case "7":
	    	reportFileNm = "EtcEarnWithholdReceipt4.mrd";
			rdTitle = "비거주자 사업.기타소득원천징수영수증";
			break;

		case "9":
	    	reportFileNm = "EtcEarnWithholdReceipt5.mrd";
			rdTitle = "이자.배당소득원천징수영수증";
			w = 1000;
			break;
	}

	args["rdTitle"] = rdTitle;
	args["rdMrd"] = "cpn/origintax/" + reportFileNm;
	args["rdParam"] = "P_WORK_YY["+$("#year").val()+""+$("#month").val()+"] P_PURPOSE_CD["+$("#purposeCd").val()+"] P_ENTER_CD[<%=removeXSS(session.getAttribute("ssnEnterCd"), '1')%>] P_SABUN["+sabuns+"] P_IMG_URL["+imgPath+"] P_PRINT_YMD["+$("#printYmd").val()+"]";
	args["rdParamGubun"]= "rv";	//파라매터구분(rp/rv)
	args["rdToolBarYn"]	= "Y";	//툴바여부
	args["rdZoomRatio"]	= "100";//확대축소비율
	args["rdSaveYn"]	= "Y" ;	//기능컨트롤_저장
	args["rdPrintYn"]	= "Y" ;	//기능컨트롤_인쇄
	args["rdExcelYn"]	= "Y" ;	//기능컨트롤_엑셀
	args["rdWordYn"]	= "Y" ;	//기능컨트롤_워드
	args["rdPptYn"]		= "Y" ;	//기능컨트롤_파워포인트
	args["rdHwpYn"]		= "Y" ;	//기능컨트롤_한글
	args["rdPdfYn"]		= "Y" ;	//기능컨트롤_PDF

	if(!isPopup()) {return;}
	openPopup(url,args,w,h);
}


//보고서 출력
function callRdEng() {
	var w 		= 840;
	var h 		= 480;
	var url 	= "<%=jspPath%>/common/rdPopup.jsp";
	var args 	= new Array();
	// args의 Y/N 구분자는 없으면 N과 같음

	var rdTitle = "";
	var reportFileNm = "";
	var sabuns = "";
	var earnerCd = $("#earnerCd").val();
	var imgPath = "<%=rdStempImgUrl%>";
	var checkYn = "N";
	var rowCnt = sheet1.RowCount();
	for (var i=1; i<=rowCnt; i++) {
		if (sheet1.GetCellValue(i, "rd_check_box") == "1") {
			sabuns += "'" + sheet1.GetCellValue(i, "sabun") + "',";
			checkYn = "Y";
		}
	}
	if (checkYn == "N") {
		alert("선택된 직원이 없습니다.");
		return;
	}
	if (sabuns.length > 1) {
		sabuns = sabuns.substr(0,sabuns.length-1);
	} else {
		alert("선택된 사원이 없습니다.");
		return;
	}

	switch (earnerCd) {
		case "3":
	    	reportFileNm = "";
			rdTitle = "사업소득원천징수영수증";
			break;

		case "5":
	    	reportFileNm = "";
			rdTitle = "기타소득원천징수영수증";
			break;

		case "7":
	    	reportFileNm = "";
			rdTitle = "비거주자 사업.기타소득원천징수영수증";
			break;

		case "9":
	    	reportFileNm = "EtcEarnWithholdReceipt5en.mrd";
			rdTitle = "이자.배당소득원천징수영수증";
			w = 1000;
			break;
	}
	
	if(reportFileNm == "") { return ; }

	args["rdTitle"] = rdTitle;
	args["rdMrd"] = "cpn/origintax/" + reportFileNm;
	args["rdParam"] = "P_WORK_YY["+$("#year").val()+""+$("#month").val()+"] P_PURPOSE_CD["+$("#purposeCd").val()+"] P_ENTER_CD[<%=removeXSS(session.getAttribute("ssnEnterCd"), '1')%>] P_SABUN["+sabuns+"] P_IMG_URL["+imgPath+"] P_PRINT_YMD["+$("#printYmd").val()+"]";
	args["rdParamGubun"]= "rv";	//파라매터구분(rp/rv)
	args["rdToolBarYn"]	= "Y";	//툴바여부
	args["rdZoomRatio"]	= "100";//확대축소비율
	args["rdSaveYn"]	= "Y" ;	//기능컨트롤_저장
	args["rdPrintYn"]	= "Y" ;	//기능컨트롤_인쇄
	args["rdExcelYn"]	= "Y" ;	//기능컨트롤_엑셀
	args["rdWordYn"]	= "Y" ;	//기능컨트롤_워드
	args["rdPptYn"]		= "Y" ;	//기능컨트롤_파워포인트
	args["rdHwpYn"]		= "Y" ;	//기능컨트롤_한글
	args["rdPdfYn"]		= "Y" ;	//기능컨트롤_PDF

	if(!isPopup()) {return;}
	openPopup(url,args,w,h);
}

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form">
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td> <span>사업장</span> <select id="businessPlaceCd" name="businessPlaceCd"> </select> </td>
						<td> <span>귀속년도</span> <input type="text" id="year" name="year" class="text" maxlength="4" value="" style="width:40px" /> </td>
						<td> <span>귀속월</span>
							<select id="month" name="month" onchange="javascript:earnerCdFilter();">
								<option value='%'>전체</option>
								<option value='01'>1월</option>
								<option value='02'>2월</option>
								<option value='03'>3월</option>
								<option value='04'>4월</option>
								<option value='05'>5월</option>
								<option value='06'>6월</option>
								<option value='07'>7월</option>
								<option value='08'>8월</option>
								<option value='09'>9월</option>
								<option value='10'>10월</option>
								<option value='11'>11월</option>
								<option value='12'>12월</option>
							</select>
						</td>
						<td> <span>소득구분</span> <select id="earnerCd" name="earnerCd"> </select> </td>
						<td> <font color='blue'>※ 거주자의기타소득은 기타소득과 동일한 양식으로 출력됨으로<br>&nbsp&nbsp&nbsp'기타소득' 으로 조회하시기 바랍니다.</font> </td>
					</tr>
					<tr>
						<td colspan="2"> <span>용도</span> <select id="purposeCd" name="purposeCd"> </select> </td>
						<td> <span>사번/성명</span> <input type="text" id="sabunName" name="sabunName" class="text" value="" style="ime-mode:active" /> </td>
						<td> <a href="javascript:doAction1('Search')"	class="button authR">조회</a> </td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<colgroup>
			<col width="" />
			<col width="7px" />
			<col width="400px" />
		</colgroup>
		<tr>
			<td class="top">
				<div class="outer">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">출력대상자 </li>
							<li class="btn">
								<span>출력일자</span> <input type="text" id="printYmd" name="printYmd" class="text date2 required" value="" />  
								<a href="javascript:doAction1('Rd')"	class="basic">출력</a>
					       <!-- <a href="javascript:doAction1('RdEng')"	class="basic" id="rdEngBtn" name="rdEngBtn">출력(영문)</a> -->
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "50%", "100%"); </script>
			</td>
			<td></td>
			<td class="top">
				<div style="height:25px"></div>
				<div class="explain">
					<div class="txt">
						<ul>
							<li>1.[기타소득원천징수영수증] 발행 화면입니다.</li>
							<li>2.[전체]를 선택하면 선택된 직원에 관계없이 모든 직원에 대해 출력됩니다.</li>
							<li>3.특정 직원에 대해서만 출력하려면, [전체] 선택을 해지한 후, 원하는 직원을 선택하시면 됩니다.</li>
						</ul>
					</div>
				</div>
			</td>
		</tr>
	</table>
</div>
</body>
</html>