<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html>	<html class="hidden"><head> <title>일용소득</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script	type="text/javascript">
	var chgFlag = true;
	$(function() {

		$("#paymentYm").mask("0000-00");
	    //$("#paymentYm").datepicker2({ymonly:true});
		$("#belongYm").mask("0000-00");
	    //$("#belongYm").datepicker2({ymonly:true});

		$("#searchKeyword,#searchSbNm,#paymentYm,#belongYm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
	});

	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
	initdata.Cols =	[
				{Header:"No",				Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>"),	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
				{Header:"삭제",				Type:"<%=sDelTy%>",	Hidden:Number("<%=sDelHdn%>"),	Width:"<%=sDelWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
				{Header:"상태",				Type:"<%=sSttTy%>",	Hidden:Number("<%=sDelHdn%>"),	Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
				{Header:"세부\n내역",			Type:"Image",		Hidden:1,			Width:0,			Align:"Center",	ColMerge:0,	SaveName:"detail",			Cursor:"Pointer",				EditLen:1 },
				{Header:"사번",				Type:"Text",		Hidden:0,			Width:0,			Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
				{Header:"성명",				Type:"Popup",		Hidden:0,			Width:0,			Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
				{Header:"주민번호",			Type:"Text",		Hidden:0,			Width:120,			Align:"Center",	ColMerge:0,	SaveName:"res_no",			KeyField:0,	Format:"IdNo",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
				{Header:"사업장",				Type:"Combo",		Hidden:0,			Width:0,			Align:"Center",	ColMerge:0,	SaveName:"business_place_cd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
				{Header:"Location",			Type:"Combo",		Hidden:1,			Width:0,			Align:"Center",	ColMerge:0,	SaveName:"location_cd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
				// 소득자관리 정보
				{Header:"시작일자",			Type:"Date",		Hidden:1,			Width:0,			Align:"Center",	ColMerge:0,	SaveName:"sdate",			KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
				{Header:"종료일자",			Type:"Date",		Hidden:1,			Width:0,			Align:"Center",	ColMerge:0,	SaveName:"edate",			KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
				{Header:"소득구분",			Type:"Combo",		Hidden:1,			Width:0,			Align:"Center",	ColMerge:0,	SaveName:"earner_cd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				{Header:"소득자구분",			Type:"Combo",		Hidden:1,			Width:0,			Align:"Center",	ColMerge:0,	SaveName:"earner_type",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
				{Header:"사업자등록번호",		Type:"Text",		Hidden:1,			Width:0,			Align:"Center",	ColMerge:0,	SaveName:"regino",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
				{Header:"소득자의상호",			Type:"Text",		Hidden:1,			Width:0,			Align:"Left",	ColMerge:0,	SaveName:"earner_nm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
				{Header:"영문명(상호or성명)",	Type:"Text",		Hidden:1,			Width:0,			Align:"Left",	ColMerge:0,	SaveName:"earner_eng_nm",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
				{Header:"외국인",				Type:"CheckBox",	Hidden:1,			Width:0,			Align:"Center",	ColMerge:0,	SaveName:"citizen_type",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
				{Header:"비거주자",			Type:"CheckBox",	Hidden:1,			Width:0,			Align:"Center",	ColMerge:0,	SaveName:"residency_type",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
				{Header:"거주지국",			Type:"Combo",		Hidden:1,			Width:0,			Align:"Center",	ColMerge:0,	SaveName:"residence_cd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
				{Header:"비실명",				Type:"CheckBox",	Hidden:1,			Width:0,			Align:"Center",	ColMerge:0,	SaveName:"bi_name_yn",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
				{Header:"전화번호",			Type:"Text",		Hidden:1,			Width:0,			Align:"Center",	ColMerge:0,	SaveName:"tel_no",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
				{Header:"주소",				Type:"Text",		Hidden:1,			Width:0,			Align:"Left",	ColMerge:0,	SaveName:"addr",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
				{Header:"은행코드",			Type:"Combo",		Hidden:1,			Width:0,			Align:"Center",	ColMerge:0,	SaveName:"bank_cd",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
				{Header:"계좌번호",			Type:"Text",		Hidden:1,			Width:0,			Align:"Center",	ColMerge:0,	SaveName:"account_no",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
				{Header:"적요",				Type:"Text",		Hidden:1,			Width:0,			Align:"Left",	ColMerge:0,	SaveName:"memo",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
				// 일용소득관리	정보
				{Header:"지급일자",			Type:"Date",		Hidden:0,			Width:0,			Align:"Center",	ColMerge:0,	SaveName:"payment_ymd",		KeyField:1,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:8 },
				{Header:"귀속연월",			Type:"Date",		Hidden:0,			Width:0,			Align:"Center",	ColMerge:0,	SaveName:"belong_ym",		KeyField:1,	Format:"Ym",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:6 },
				{Header:"근무일수",			Type:"Int",			Hidden:0,			Width:0,			Align:"Right",	ColMerge:0,	SaveName:"wkp_cnt",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
				{Header:"최종근무일자",			Type:"Date",		Hidden:0,			Width:0,			Align:"Center",	ColMerge:0,	SaveName:"last_work_ymd",	KeyField:1,	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:8 },
				{Header:"총지급액(과세소득)",	Type:"AutoSum",		Hidden:0,			With:110,			Align:"Right",	ColMerge:0,	SaveName:"tot_mon",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
				{Header:"비과세소득(신고대상)",			Type:"AutoSum",		Hidden:0,			Width:0,			Align:"Right",	ColMerge:0,	SaveName:"ntax_earn_mon",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
				{Header:"소득세",				Type:"AutoSum",		Hidden:0,			Width:0,			Align:"Right",	ColMerge:0,	SaveName:"itax_mon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
				{Header:"지방소득세",			Type:"AutoSum",		Hidden:0,			Width:0,			Align:"Right",	ColMerge:0,	SaveName:"rtax_mon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
	]; IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(0);

	var initdata2 = {};
	initdata2.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
	initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
	initdata2.Cols = [
		{Header:"No",			Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
		{Header:"삭제",			Type:"<%=sDelTy%>",	Hidden:Number("<%=sDelHdn%>"),Width:"<%=sDelWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
		{Header:"상태",			Type:"<%=sSttTy%>",	Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
		{Header:"사번",			Type:"Text",		Hidden:0,			Width:80,			Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"성명",			Type:"Text",		Hidden:0,			Width:80,			Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100},
 		{Header:"주민번호",		Type:"Text",		Hidden:0,			Width:120,			Align:"Center",	ColMerge:0,	SaveName:"res_no",			KeyField:1,	Format:"IdNo",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:13 },
 		{Header:"사업장",			Type:"Combo",		Hidden:0,			Width:90,			Align:"Center",	ColMerge:0,	SaveName:"business_place_cd",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
 		{Header:"Location",		Type:"Combo",		Hidden:1,			Width:90,			Align:"Center",	ColMerge:0,	SaveName:"location_cd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
 		{Header:"소득구분",		Type:"Combo",		Hidden:1,			Width:90,			Align:"Center",	ColMerge:0,	SaveName:"earner_cd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100},
 		// 일용소득관리 정보
 		{Header:"지급일자",		Type:"Date",		Hidden:0,			Width:90,			Align:"Center",	ColMerge:0,	SaveName:"payment_ymd",		KeyField:1,	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:8   },
 		{Header:"귀속연월",		Type:"Date",		Hidden:0,			Width:90,			Align:"Center",	ColMerge:0,	SaveName:"belong_ym",		KeyField:1,	Format:"Ym",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:6   },
 		{Header:"근무일수",		Type:"Int",			Hidden:0,			Width:60,			Align:"Right",	ColMerge:0,	SaveName:"wkp_cnt",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
 		{Header:"최종근무일자",		Type:"Date",		Hidden:0,			Width:90,			Align:"Center",	ColMerge:0,	SaveName:"last_work_ymd",	KeyField:1,	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:8   },
 		{Header:"총지급액(과세소득)",Type:"Int",			Hidden:0,			Width:110,			Align:"Right",	ColMerge:0,	SaveName:"tot_mon",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
 		{Header:"비과세소득",		Type:"Int",			Hidden:0,			Width:90,			Align:"Right",	ColMerge:0,	SaveName:"ntax_earn_mon",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
 		{Header:"소득세",			Type:"Int",			Hidden:0,			Width:90,			Align:"Right",	ColMerge:0,	SaveName:"itax_mon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
 		{Header:"지방소득세",		Type:"Int",			Hidden:0,			Width:90,			Align:"Right",	ColMerge:0,	SaveName:"rtax_mon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
   	]; IBS_InitSheet(sheet2, initdata2); sheet2.SetCountPosition(0);	
	
		// 사업장(TCPN121)
		var bizPlaceCd = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList", "getBizPlaceCdList") , "전체");
		sheet1.SetColProperty("business_place_cd", {ComboText:"|"+bizPlaceCd[0], ComboCode:"|"+bizPlaceCd[1]});
		$("#searchBusinessPlaceCd").html(bizPlaceCd[2]) ;
		
		// Location(TSYS015)
		var locationCd = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList", "getLocationCdAllList") , "전체");
		sheet1.SetColProperty("location_cd", {ComboText:"|"+locationCd[0], ComboCode:"|"+locationCd[1]});
		$("#searchLocationCd").html(locationCd[2]) ;

		// 소득구분(C00502)
		var earnerCd = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYM="+$("#belongYm").val(),"C00502"), "전체");
		sheet1.SetColProperty("earner_cd", {ComboText:"|"+earnerCd[0], ComboCode:"|"+earnerCd[1]});

		//소득자구분 : 일용직으로 적용
		$("#searchEarnerCd").html(earnerCd[2]) ;
		$("#searchEarnerCd").val('1');

		// 소득자구분(C00503)
		var earnerType = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYM="+$("#belongYm").val(),"C00503"), "");
		sheet1.SetColProperty("earner_type", {ComboText:"|"+earnerType[0], ComboCode:"|"+earnerType[1]});

		// 거주지국(H20290)
		var residenceCd	= stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYM="+$("#belongYm").val(),"H20290"), "");
		sheet1.SetColProperty("residence_cd", {ComboText:"|"+residenceCd[0], ComboCode:"|"+residenceCd[1]});

		// 은행코드(H30001)
		var bankCd = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYM="+$("#belongYm").val(),"H30001"), "");
		sheet1.SetColProperty("bank_cd", {ComboText:"|"+bankCd[0], ComboCode:"|"+bankCd[1]});

		//sheet1.SetDataLinkMouse("detail", 1);
		//sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

		sheet1.SetColProperty("citizen_type",	{ComboText:"|외국인|내국인", ComboCode:"|9|1"}	);
		sheet1.SetColProperty("residency_type",		{ComboText:"|비거주자|거주자", ComboCode:"|2|1"}	);
		sheet1.SetColProperty("bi_name_yn",		{ComboText:"|비실명|실명", ComboCode:"|Y|N"}	);

		$(window).smartresize(sheetResize);
		sheetInit();

		$("#searchKeyword").val("");
		doAction1("Search");
	});



	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			$("#searchSbNm").val($("#searchKeyword").val());
			sheet1.DoSearch( "<%=jspPath%>/dayIncomeMgr/dayIncomeMgrRst.jsp?cmd=selectDayIncomeMgrList", $("#empForm").serialize() );
			break;
	case "Insert":
		var Row	= sheet1.DataInsert(0) ;
		sheet1.SetCellValue(Row, "earner_cd",		"1" );	//일용소득
		break;
	case "Copy":
		sheet1.DataCopy();
		break;
	case "Save":
			if(!isNumberChk()) {
				alert("금액은 정수만 입력해 주세요.");
				break;
			}
			for(var	i = 1; i < sheet1.RowCount()+1;	i++) {
				if(sheet1.GetCellValue(i, "sStatus") == "I" || sheet1.GetCellValue(i, "sStatus") == "U" ) {
					if(  sheet1.GetCellValue(i, "wkp_cnt")  > sheet1.GetCellValue(i, "last_work_ymd").substr(6,2) ){
						alert(sheet1.GetCellValue(i, "name") + "대상자의 최종근무일자가 근무일수보다 작을 수 없습니다.");
						return;
					}
				}
				
			}
			
			sheet1.DoSave( "<%=jspPath%>/dayIncomeMgr/dayIncomeMgrRst.jsp?cmd=saveDayIncomeMgr", $("#empForm").serialize() );
			break;
	case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,CheckBoxOnValue:"Y",CheckBoxOffValue:"N",menuNm:$(document).find("title").text()};			
			sheet1.Down2Excel(param);
			break;
		case "Down2Template":
			/*
			var templeteTitle = "업로드시 이 행은 삭제 합니다\n*지급일자 : yyyy-mm-dd, *귀속연월:yyyy-mm 형식으로 입력하여 주세요.";
			var param  = {DownCols:"4|25|26|27|28|29|30|31",SheetDesign:1,Merge:1,DownRows:'0',ExcelFontSize:"9"
				,TitleText:templeteTitle,UserMerge :"0,0,1,8"};
			sheet1.Down2Excel(param);
			*/
			var templeteTitle = "업로드시 이 행은 삭제 합니다\n*지급일자 : yyyy-mm-dd, *귀속연월:yyyy-mm 형식으로 입력하여 주세요.";
			var param  = {DownCols:"3|4|5|6|9|10|11|12|13|14|15",SheetDesign:1,Merge:1,DownRows:'0',ExcelFontSize:"9"
				,TitleText:templeteTitle,UserMerge :"0,0,1,11",menuNm:$(document).find("title").text()};
			sheet2.Down2Excel(param);			
			break;
	case "LoadExcel":
			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet1.LoadExcel(params);
			break;
		}
	}

	//조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg,	StCode,	StMsg);
			sheetResize();
		} catch(ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code,	Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg,	StCode,	StMsg);
			if(Code	== 1) {
				doAction1("Search");
			}
		} catch(ex) {
			alert("OnSaveEnd Event Error " + ex);
		} 
	}

	// 팝업	클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
			if(sheet1.ColSaveName(Col) == "name") {
				openOwnerPopup(Row) ;
			}
		} catch(ex) {
			alert("OnPopupClick Event Error	: " + ex);
		}
	}

	function sheet1_OnLoadExcel(result) {
		try {
			var chgVal1 = "";
			var chgVal2 = "";			
			if(sheet1.RowCount() > 0) {
				for(var	i = 1; i < sheet1.RowCount()+1;	i++) {
					sheet1.SetCellValue(i, "earner_cd", "1");
					chgVal1 = sheet1.GetCellValue(i,"wkp_cnt");
					chgVal2 = sheet1.GetCellValue(i,"tot_mon");			
					chgFlag = false;
					sheet1.SetCellValue(i, "wkp_cnt", "");
					sheet1.SetCellValue(i, "tot_mon", "");
					chgFlag = true;
					sheet1.SetCellValue(i, "wkp_cnt", chgVal1);
					sheet1.SetCellValue(i, "tot_mon", chgVal2);					
				}
			}
		} catch(ex) {
			alert("OnLoadExcel Event Error : " + ex);
		}
	}

	//값이 바뀔때 발생
	function sheet1_OnChange(Row, Col, Value, OldValue) {
		try{

			if(sheet1.ColSaveName(Col) == "wkp_cnt"	|| sheet1.ColSaveName(Col) == "tot_mon") {
				//소득세 계산( (총지급액/근무일수-100000   )*0.027*근무일수   )
				//2019년 개정. 소득세 계산( (총지급액/근무일수-150000   )*0.027*근무일수   )
				var wkpCnt = sheet1.GetCellValue(Row,"wkp_cnt");
				var totMon = sheet1.GetCellValue(Row,"tot_mon");

				if(wkpCnt != ""	&& totMon != ""	&& wkpCnt > 0 && totMon	> 0) {
					var itax = (totMon/wkpCnt-150000)*0.027*wkpCnt;

					if(itax	< 1000)	{
						sheet1.SetCellValue(Row,"itax_mon",0);
					} else {
						sheet1.SetCellValue(Row,"itax_mon",parseInt(itax/10,10)*10);
					}

				} else {
					sheet1.SetCellValue(Row,"itax_mon",0);
				}
			} else if(sheet1.ColSaveName(Col) == "itax_mon") {
				//소득세 변경시	주민세 계산
				if(sheet1.GetCellValue(Row, "itax_mon")	!= "") {
					itaxMon	= sheet1.GetCellValue(Row, "itax_mon");
					sheet1.SetCellValue(Row,"rtax_mon", parseInt(itaxMon*0.1/10,10)*10 );
				} else {
					sheet1.SetCellValue(Row,"rtax_mon", 0 );
				}
			}
			
			if(sheet1.ColSaveName(Col) == "tot_mon"	|| sheet1.ColSaveName(Col) == "ntax_earn_mon"
					|| sheet1.ColSaveName(Col) == "itax_mon"	|| sheet1.ColSaveName(Col) == "rtax_mon") {
				isNumberChk();
			}

		} catch(ex) {
			alert("OnChange	Event Error : "	+ ex);
		}
	} 

	var gPRow  = "";
	var pGubun = "";

	// 사원	조회
	function openOwnerPopup(Row){
	    try{

		if(!isPopup()) {return;}
		gPRow  = Row;
			pGubun = "ownerPopup";

		    var	args	= new Array();
		    args["ownerOnlyYn"]	= "N";
		    args["earnerCd"]= $("#searchEarnerCd").val();
		    var	rv = openPopup("<%=jspPath%>/common/ownerPopup.jsp?authPg=<%=authPg%>",	args, "740","520");
		    /*
		if(rv!=null){
				sheet1.SetCellValue(Row, "name",		rv["name"] );
				sheet1.SetCellValue(Row, "sabun",		rv["sabun"] );
				sheet1.SetCellValue(Row, "res_no",		rv["res_no"] );
		}
		    */
	    } catch(ex)	{
		alert("Open Popup Event	Error :	" + ex);
	    }
	}

	function uploadPopup() {
		if(!isPopup()) {return;}

		var args	= new Array();
		args["searchEarnerCd"] = $("#searchEarnerCd").val();

		pGubun = "dayIncomeMgrPopup";
		openPopup("<%=jspPath%>/dayIncomeMgr/dayIncomeMgrPopup.jsp?authPg=<%=authPg%>",args,800,500);
	}

	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

		if ( pGubun == "ownerPopup" ){
			sheet1.SetCellValue(gPRow, "name",		rv["name"] );
			sheet1.SetCellValue(gPRow, "sabun",	rv["sabun"] );
			sheet1.SetCellValue(gPRow, "res_no",	rv["res_no"] );
			sheet1.SetCellValue(gPRow, "business_place_cd",		rv["business_place_cd"]	);
// 			sheet1.SetCellValue(gPRow, "location_cd",		rv["location_cd"]	);
		} else if( pGubun == "dayIncomeMgrPopup") {
			doAction1("Search");
		}
	}
	
	function isNumberChk() {
		var isNumber = true;
		var reg = /^\d+$/;
		
		if(sheet1.RowCount() > 0) {
			for(var	i = 1; i < sheet1.RowCount()+1;	i++) {
				if(sheet1.GetCellValue(i, "sStatus") == 'I' || sheet1.GetCellValue(i, "sStatus") == 'U') {
					//정수가 아닌 경우 체크
					
					// 총지급액(과세소득)
					if(reg.test(sheet1.GetCellValue(i,"tot_mon")) == false) {
						isNumber = false;
						sheet1.SetCellBackColor( i, "tot_mon", "#ffb8b8" );
					} else {
						sheet1.SetCellBackColor( i, "tot_mon", sheet1.GetCellBackColor(i, "wkp_cnt") );
					}
					
					// 비과세소득
					if(reg.test(sheet1.GetCellValue(i,"ntax_earn_mon")) == false) {
						isNumber = false;
						sheet1.SetCellBackColor( i, "ntax_earn_mon", "#ffb8b8" );
					} else {
						sheet1.SetCellBackColor( i, "ntax_earn_mon", sheet1.GetCellBackColor(i, "wkp_cnt") );
					}
					
					// 소득세
					if(reg.test(sheet1.GetCellValue(i,"itax_mon")) == false) {
						isNumber = false;
						sheet1.SetCellBackColor( i, "itax_mon", "#ffb8b8" );
					} else {
						sheet1.SetCellBackColor( i, "itax_mon", sheet1.GetCellBackColor(i, "wkp_cnt") );
					}
					
					// 지방소득세
					if(reg.test(sheet1.GetCellValue(i,"rtax_mon")) == false) {
						isNumber = false;
						sheet1.SetCellBackColor( i, "rtax_mon", "#ffb8b8" );
					} else {
						sheet1.SetCellBackColor( i, "rtax_mon", sheet1.GetCellBackColor(i, "wkp_cnt") );
					}
				}
			}
		}
		
		return isNumber;
	}

</script>
</head>
<body class="bodywrap">
<div id="progressCover"	style="display:none;position:absolute;top:0;bottom:0;left:0;right:0;background:url(<%=imagePath%>/common/process.png) no-repeat	50% 50%;"></div>
<div class="wrapper">
    <form id="empForm" name="empForm" >
	<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td> <span>귀속연월</span> <input type="text" id="belongYm" name="belongYm" class="text	date2" value="<%=yjungsan.util.DateUtil.getMonthAdd(curSysYear,curSysMon, -1)%>" maxlength="6" /> </td>
						<td> <span>사업장</span> <select id="searchBusinessPlaceCd" name="searchBusinessPlaceCd" onChange="javascript:doAction1('Search');"></select> </td>
						<td class="hide"> <span>Location</span> <select id="searchLocationCd" name="searchLocationCd" onChange="javascript:doAction1('Search');"></select> </td>
						<td> <span>지급연월</span> <input type="text" id="paymentYm" name="paymentYm" class="text date2" value="" maxlength="8"	/> </td>
						<td> <span>성명/사번</span>
								<input type="text" id="searchKeyword" name="searchKeyword" class="text"	value="" style="ime-mode:active" />
								<input type="hidden" id="searchStatusCd" name="searchStatusCd" value="A" />
								<input type="hidden" id="searchUserId"	 name="searchUserId" value="<%=removeXSS(session.getAttribute("ssnSabun"), '1')%>" />
								<input type="hidden" id="searchRegNo_"	 name="searchRegNo_">
								<input type="hidden" id="searchSbNm" name="searchSbNm" class="text" value=""/>

						</td>
						<td class="hide"><span>소득구분</span><select id="searchEarnerCd" name="searchEarnerCd"	></select></td>
						<td> <a	href="javascript:doAction1('Search')"	class="button authR">조회</a> </td>
					</tr>
				</table>
			</div>
		</div>
    </form>

    <div class="outer">
	<div class="sheet_title">
	<ul>
	    <li	class="txt">일용소득</li>
	    <li	class="btn">
	    <!--
				<a href="javascript:doAction1('Down2Template')"	class="basic authA">양식다운로드</a>
				<a href="javascript:doAction1('LoadExcel')"	class="basic authA">업로드</a>
			-->							
				<a href="javascript:doAction1('Down2Template')"	class="basic authA">양식다운로드</a>
				<a href="javascript:doAction1('LoadExcel')"	class="basic authA">업로드</a>				
				<a href="javascript:doAction1('Insert')"		class="basic authA">입력</a>
				<a href="javascript:doAction1('Copy')"			class="basic authA">복사</a>
				<a href="javascript:doAction1('Save')"			class="basic authA">저장</a>
				<a href="javascript:doAction1('Down2Excel')"	class="basic authR">다운로드</a>
	    </li>
	</ul>
	</div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
	<script type="text/javascript"> createIBSheet("sheet2", "100%", "100%"); </script>    
</div>
</body>
</html>