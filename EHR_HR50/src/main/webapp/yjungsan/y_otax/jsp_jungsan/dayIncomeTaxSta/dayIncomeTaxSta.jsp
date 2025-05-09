<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>일용소득원천징수영수증 출력</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<!--
 * 일용소득원천징수영수증 출력
 * @author JM
-->
<script type="text/javascript">
$(function() {
	var initdata = {};
	initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly}; 
	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
	initdata.Cols = [
		{Header:"No",	Type:"<%=sNoTy%>",	Hidden:Number("<%=sNoHdn%>"),	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"삭제",	Type:"<%=sDelTy%>",	Hidden:Number("<%=sDelHdn%>"),	Width:"<%=sDelWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
		{Header:"상태",	Type:"<%=sSttTy%>",	Hidden:Number("<%=sSttHdn%>"),	Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
		{Header:"전체",	Type:"CheckBox",	Hidden:0,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"rd_check_box",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
		{Header:"사번",	Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"성명",	Type:"Popup",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
   	]; IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(0);

	//------------------------------------- 조회조건 콤보 -------------------------------------//
	// 사업장(TORG109)
	var tcpn121Cd = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList", "getTorg109List"), "전체");
	$("#businessPlaceCd").html(tcpn121Cd[2]);
	
	// 영수증구분(C00315)
	var purposeCd = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYM=<%=curSysYear%>-<%=curSysMon%>", "C00315"), "");
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
	
	$("#earnerCd").val("1"); //일용소득

	$("#workPart").val();
	//2021.07.12 (지급분기)
	workPartSet();
	
	//doAction1("Search");
});

//2021.07.12 (지급분기)
function workPartSet(){
	   if($("#year").val() == "2021"){
		     $("#workPartGubun").val("2");
	         $('#workPart').empty();
	         $('#workPart').append("<option value='1'>1/4분기(1월~3월)</option>");
	         $('#workPart').append("<option value='2'>2/4분기(4월~6월)</option>");
	         $('#workPart').append("<option value='07'>7월</option>");
	         $('#workPart').append("<option value='08'>8월</option>");
	         $('#workPart').append("<option value='09'>9월</option>");
	         $('#workPart').append("<option value='10'>10월</option>");
	         $('#workPart').append("<option value='11'>11월</option>");
	         $('#workPart').append("<option value='12'>12월</option>");
	    }else if($("#year").val() > "2021"){
	    	$("#workPartGubun").val("1");
	        $('#workPart').empty();
	        $('#workPart').append("<option value='01'>1월</option>");
	        $('#workPart').append("<option value='02'>2월</option>");
	        $('#workPart').append("<option value='03'>3월</option>");
	        $('#workPart').append("<option value='04'>4월</option>");
	        $('#workPart').append("<option value='05'>5월</option>");
	        $('#workPart').append("<option value='06'>6월</option>");        
	        $('#workPart').append("<option value='07'>7월</option>");
	        $('#workPart').append("<option value='08'>8월</option>");
	        $('#workPart').append("<option value='09'>9월</option>");
	        $('#workPart').append("<option value='10'>10월</option>");
	        $('#workPart').append("<option value='11'>11월</option>");
	        $('#workPart').append("<option value='12'>12월</option>");
	    }else{
	    	$("#workPartGubun").val("3");
	        $('#workPart').empty();
	        $('#workPart').append("<option value='1'>1/4분기(1월~3월)</option>");
	        $('#workPart').append("<option value='2'>2/4분기(4월~6월)</option>");
	        $('#workPart').append("<option value='3'>3/4분기(7월~9월)</option>");
	        $('#workPart').append("<option value='4'>4/4분기(10월~12월)</option>");
	    }	
}

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
			sheet1.DoSearch("<%=jspPath%>/dayIncomeTaxSta/dayIncomeTaxStaRst.jsp?cmd=selectDayIncomeTaxStaList", $("#sheet1Form").serialize());
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
	var rdTitle = "일용근로소득원천징수영수증";
	
	if($("#year").val() < "2021" || ( $("#year").val() == "2021" && ($("#workPart").val() == "1" || $("#workPart").val() == "2" ))){
		var reportFileNm = "EtcEarnWithholdReceipt3.mrd";
	}
	else if(($("#year").val() < "2023") || ($("#year").val() <= "2023" && $("#workPart").val() < "03")) {
		var reportFileNm = "EtcEarnWithholdReceipt3_2021.mrd";
	}
	else{
		var reportFileNm = "EtcEarnWithholdReceipt3_2023.mrd";
	}
	
	var sabuns = "";
	var earnerCd = $("#earnerCd").val();
	var purposeCd = $("#purposeCd").val();
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

	if (purposeCd == "A") {
		purposeNm = "(소득자 보관용)";
	} else {
		purposeNm = "(지급자 보관용)";
	}

	args["rdTitle"] = rdTitle;
	args["rdMrd"] = "cpn/origintax/" + reportFileNm;
	//args["rdParam"] = "["+$("#year").val()+"] P_WORK_PART["+$("#workPart").val()+"] ["+$("#purposeCd").val()+"] ["+<%=session.getAttribute("ssnEnterCd")%>+"] ["+sabuns+"] ["+imgPath+"] ["+purposeNm+"]";
	args["rdParam"] = "P_WORK_YY["+$("#year").val()+"] P_WORK_PART["+$("#workPart").val()+"] P_PURPOSE_CD["+$("#purposeCd").val()+"] P_ENTER_CD[<%=removeXSS(session.getAttribute("ssnEnterCd"), '1')%>] P_SABUN["+sabuns+"] P_IMG_URL["+imgPath+"] P_PRINT_YMD["+$("#printYmd").val()+"]";
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
	<input type="hidden" id="workPartGubun" name="workPartGubun" value="">
		<div class="sheet_search outer">
			<div>
					<table>
						<tr>
							<td><span>귀속년도</span> 
							    <input type="text" id="year"name="year" class="text" maxlength="4" value=""style="width: 40px" onchange="workPartSet();" /> 
								<input type="hidden" id="earnerCd" name="earnerCd" />
							</td>
							<td><span>신고기간</span> 
							    <select id="workPart" name="workPart"></select>
							</td>
							<td><span>용도</span>
							    <select id="purposeCd" name="purposeCd"></select>
							</td>
							<td><span>사번/성명</span>
							     <input type="text" id="sabunName" name="sabunName" class="text" value="" style="ime-mode: active" />
							</td>
							<td><a href="javascript:doAction1('Search')" class="button authR">조회</a>
							</td>
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
							<li>1.[일용근로소득원천징수영수증] 발행 화면입니다.</li>
							<li>2.[전체]를 선택하면 선택된 사원에 관계없이 모든 사원에 대해 출력됩니다.</li>
							<li>3.특정 사원에 대해서만 출력하려면, [전체] 선택을 해지한 후, 원하는 사원을 선택하시면 됩니다.</li>
						</ul>
					</div>
				</div>
			</td>
		</tr>
	</table>
</div>
</body>
</html>