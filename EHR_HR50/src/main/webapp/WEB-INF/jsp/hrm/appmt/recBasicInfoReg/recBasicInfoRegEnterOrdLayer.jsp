<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>사간전입 발령</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>

<%@ page import="com.hr.common.util.DateUtil" %>

<script type="text/javascript">
	var p = eval("${popUpStatus}");
	var arg ="";

	$(function() {
        const modal = window.top.document.LayerModalUtility.getModal('recBasicInfoRegEnterOrdLayer');
        arg =  modal.parameters;
        
        createIBSheet3(document.getElementById('sheet1-wrap'), "sheet1", "100%", "100%","${ssnLocaleCd}");
        
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad, MergeSheet:0,Page:22, AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
    		{Header:"No",				Type:"${sNoTy}",	Hidden:0,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },

   			{Header:"선택",				Type:"CheckBox",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"chk",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },

   			{Header:"사번",				Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:13 },
   			
   			{Header:"발령",				Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ordTypeCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"발령상세",			Type:"Combo",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"ordDetailCd",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },

			{Header:"전출회사",			Type:"Combo",	Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"ordEnterCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"전출회사\n사번",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"ordEnterSabun",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"성명",				Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },

			{Header:"입력일",				Type:"Date",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"regYmd",		KeyField:1,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"그룹입사일",			Type:"Date",	Hidden:Number("${gempYmdHdn}"),	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"gempYmd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"입사일",			Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"empYmd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"퇴직일",			Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"retYmd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			
			{Header:"주민번호",			Type:"Text",		Hidden:1,	Width:110,	Align:"Center",	ColMerge:0,	SaveName:"resNo2",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
			{Header:"주민번호",			Type:"Text",		Hidden:1,	Width:110,	Align:"Center",	ColMerge:0,	SaveName:"resNo",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:200 },
			{Header:"성별",				Type:"Combo",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sexType",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1 },
			{Header:"수습종료일",			Type:"Date",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"traYmd",	    KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"성명(한자)",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"nameCn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"성명(영문)",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"nameUs",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"음양구분",			Type:"Combo",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"lunType",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1 },
			{Header:"생년월일",			Type:"Date",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"birthYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"외국인\n여부",		Type:"Combo",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"foreignYn",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1 },
			{Header:"국적",				Type:"Combo",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"nationalCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"결혼여부",			Type:"Combo",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"wedYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1 },
			{Header:"결혼일자",			Type:"Date",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"wedYmd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"시력(좌)",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"eyeL",			KeyField:0,	Format:"NullFloat",		PointCount:1,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"시력(우)",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"eyeR",			KeyField:0,	Format:"NullFloat",		PointCount:1,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"색신",				Type:"Combo",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"daltonismCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"신장",				Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ht",			KeyField:0,	Format:"NullFloat",		PointCount:2,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"체중",				Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"wt",			KeyField:0,	Format:"NullFloat",		PointCount:2,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"혈액형",			Type:"Combo",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"bloodCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"종교",				Type:"Combo",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"relCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"이메일",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"mailAddr",    KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"휴대폰번호",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"mobileNo",    KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"취미",				Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"hobby",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1000 },
			{Header:"특기",				Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"specialityNote",KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1000 },
			{Header:"채용구분",			Type:"Combo",		Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"stfType",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"채용경로",			Type:"Combo",		Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"empType",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"입사경로",			Type:"Combo",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"pathCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"입사추천자",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"recomName",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			
			{Header:"인정직위",			Type:"Combo",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"base1Cd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"인정직위\n(년차)",	Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"careerYyCnt",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"인정직위\n(개월)",	Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"careerMmCnt",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"발령번호",			Type:"Popup",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"processNo",   KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1000 },

			{Header:"발령확정\n여부",	Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"ordYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"발령확정\n여부",	Type:"Image",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"ibsImage4",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },

			{Header:"발령일",			Type:"Date",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ordYmd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"발령seq",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"applySeq",    KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"조회여부",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"visualYn",    KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1 },
			{Header:"채용순번",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"seq",    KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"지원자번호",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"applKey",    KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },

			
			{Header:"<sht:txt mid='base1Ymd' mdef='기준일1'/>",		Type:"Date",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base1Ymd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='base2Ymd' mdef='기준일2'/>",		Type:"Date",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base2Ymd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='base3Ymd' mdef='기준일3'/>",		Type:"Date",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base3Ymd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='base1Yn' mdef='기준여부1'/>",		Type:"CheckBox",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base1Yn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100,	FalseValue:"N", TrueValue:"Y" },
			{Header:"<sht:txt mid='base2Yn' mdef='기준여부2'/>",		Type:"CheckBox",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base2Yn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100,	FalseValue:"N", TrueValue:"Y" },
			{Header:"<sht:txt mid='base3Yn' mdef='기준여부3'/>",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base3Yn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='base2Cd' mdef='기준코드2'/>",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base2Cd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='base3Cd' mdef='기준코드3'/>",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base3Cd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='base1Nm' mdef='기준설명1'/>",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base1Nm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='base2Nm' mdef='기준설명2'/>",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base2Nm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='base3Nm' mdef='기준설명3'/>",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base3Nm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
			
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var lunType = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H00030"), " ");	//음양구분
		var sexType = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H00010"), " ");	//성별
		var bloodCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20460"), " ");	//혈액형
		var nationalCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20290"), " ");	//국적
		var relCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20350"), "");	//종교
		var stfType = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","F10001"), " ");	//채용구분
		var empType = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","F10003"), " ");	//채용경로
		var pathCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","F65010"), " ");	//입사경로
		var daltonismCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20337"), " ");	//색맹여부
		
		var ordDetailCd = stfConvCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdDetailCdList&inOrdType=10,",false).codeList, "");//입사 발령

		//var sabunType = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10160"), " ");	//사번생성룰

		//회사코드
		var ordEnterCdList = codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W90000")
		var ordEnterCd = stfConvCode(ordEnterCdList , "");
		var searchOrdEnterCdOpt = stfConvCode(ordEnterCdList , "<tit:txt mid='103895' mdef='전체' />");
		$("#searchOrdEnterCd").html(searchOrdEnterCdOpt);

		//발령상세[코드]
		sheet1.SetColProperty("ordDetailCd", 		{ComboText:"|"+ordDetailCd[0], ComboCode:"|"+ordDetailCd[1]} );

		var base1Cd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20030"), " ");	//경력인정직위코드(H20030)
		sheet1.SetColProperty("base1Cd", 		{ComboText:"|"+base1Cd[0], ComboCode:"|"+base1Cd[1]} );

		sheet1.SetColProperty("ordEnterCd", 	{ComboText:"|"+ordEnterCd[0], ComboCode:"|"+ordEnterCd[1]} );
		sheet1.SetColProperty("lunType", 		{ComboText:"|"+lunType[0], ComboCode:"|"+lunType[1]} );
		sheet1.SetColProperty("sexType", 		{ComboText:"|"+sexType[0], ComboCode:"|"+sexType[1]} );
		sheet1.SetColProperty("bloodCd", 		{ComboText:"|"+bloodCd[0], ComboCode:"|"+bloodCd[1]} );
		sheet1.SetColProperty("wedYn", 			{ComboText:"|기혼|미혼|이혼", ComboCode:"|Y|N|3"} );
		sheet1.SetColProperty("foreignYn", 		{ComboText:"|Y|N", ComboCode:"|Y|N"} );
		sheet1.SetColProperty("nationalCd", 	{ComboText:"|"+nationalCd[0], ComboCode:"|"+nationalCd[1]} );
		sheet1.SetColProperty("relCd", 			{ComboText:"|"+relCd[0], ComboCode:"|"+relCd[1]} );
		sheet1.SetColProperty("stfType", 		{ComboText:"|"+stfType[0], ComboCode:"|"+stfType[1]} );
		sheet1.SetColProperty("empType", 		{ComboText:"|"+empType[0], ComboCode:"|"+empType[1]} );
		sheet1.SetColProperty("daltonismCd", 	{ComboText:"|"+daltonismCd[0], ComboCode:"|"+daltonismCd[1]} );


		//sheet1.SetColProperty("sabunType", 		{ComboText:"|"+sabunType[0], ComboCode:"|"+sabunType[1]} );

		$("#searchFromYmd").datepicker2({startdate:"searchToYmd"});
		$("#searchToYmd").datepicker2({enddate:"searchFromYmd"});

		$(window).smartresize(sheetResize); sheetInit();

		var sheetHeight = $(".modal_body").height() - $("#sheet1Form").height() - $(".sheet_title").height() - 2;
	    //console.log("sheetHeight : " + sheetHeight);
	    
		sheet1.SetSheetHeight(sheetHeight);
	});

	$(function() {		
		$("#searchFromYmd, #searchToYmd, #searchSabunName").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search"); $(this).focus();
			}
		});		
        
        $(".close").click(function() {
	    	p.self.close();
	    });
	});


	//Sheet0 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":

			sheet1.DoSearch( "${ctx}/GetDataList.do?cmd=getRecBasicInfoRegEnterOrdPopList", $("#sheet1Form").serialize() );

			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			var d = new Date();
			var fName = "excel_" + d.getTime() + ".xlsx";
			sheet1.Down2Excel($.extend(param, { FileName:fName, SheetDesign:1, Merge:1 }));

			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != ""){
				alert(Msg);
			}

			for(var r = sheet1.HeaderRows(); r<sheet1.LastRow()+1; r++){
				if( sheet1.GetCellValue(r,"staffingYn") == "Y" ) {
					sheet1.SetRowEditable(r,false);
				}
			}
 			sheetResize();

		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet1_OnDblClick(Row, Col){
		try{
			sheet1.SetCellValue(Row, "chk", "1") ;
			passData();
	  	}catch(ex){
	  		;
	  	}
	}

	function passData(){
		var rowsSerialize = sheet1.FindCheckedRow("chk");
		var rvArray=[];
		var rvDatas;
		if (rowsSerialize=="") {
			alert("선택 된 값이 없습니다.");
		} else {
			var rows = rowsSerialize.split('|');
			for (var i = 0; i < rows.length; i++) {
				rvDatas="";
				rvDatas={
						 "sabun":sheet1.GetCellValue(rows[i],"sabun")	
						,"ordTypeCd":sheet1.GetCellValue(rows[i],"ordTypeCd")
						,"ordDetailCd":sheet1.GetCellValue(rows[i],"ordDetailCd")
						,"ordEnterCd":sheet1.GetCellValue(rows[i],"ordEnterCd")
						,"ordEnterSabun":sheet1.GetCellValue(rows[i],"ordEnterSabun")

						,"regYmd":sheet1.GetCellValue(rows[i],"regYmd")
						,"gempYmd":sheet1.GetCellValue(rows[i],"gempYmd")
						,"empYmd":sheet1.GetCellValue(rows[i],"empYmd")

						,"name":sheet1.GetCellValue(rows[i],"name")
						,"nameCn":sheet1.GetCellValue(rows[i],"nameCn")
						,"nameUs":sheet1.GetCellValue(rows[i],"nameUs")
						,"resNo":sheet1.GetCellValue(rows[i],"resNo")
						,"resNo2":sheet1.GetCellValue(rows[i],"resNo2")
						,"sexType":sheet1.GetCellValue(rows[i],"sexType")
						,"lunType":sheet1.GetCellValue(rows[i],"lunType")
						,"birthYmd":sheet1.GetCellValue(rows[i],"birthYmd")
						
						,"eyeL":sheet1.GetCellValue(rows[i],"eyeL")
						,"eyeR":sheet1.GetCellValue(rows[i],"eyeR")
						,"ht":sheet1.GetCellValue(rows[i],"ht")
						,"wt":sheet1.GetCellValue(rows[i],"wt")

						,"wedYn":sheet1.GetCellValue(rows[i],"wedYn")
						,"wedYmd":sheet1.GetCellValue(rows[i],"wedYmd")
						,"bloodCd":sheet1.GetCellValue(rows[i],"bloodCd")
						,"relCd":sheet1.GetCellValue(rows[i],"relCd")
						,"foreignYn":sheet1.GetCellValue(rows[i],"foreignYn")
						,"nationalCd":sheet1.GetCellValue(rows[i],"nationalCd")
						,"mobileNo":sheet1.GetCellValue(rows[i],"mobileNo")
						,"mailAddr":sheet1.GetCellValue(rows[i],"mailAddr")
						,"hobby":sheet1.GetCellValue(rows[i],"hobby")
						,"specialityNote":sheet1.GetCellValue(rows[i],"specialityNote")

						,"stfType":sheet1.GetCellValue(rows[i],"stfType")
						,"empType":sheet1.GetCellValue(rows[i],"empType")
						,"pathCd":sheet1.GetCellValue(rows[i],"pathCd")
						,"recomName":sheet1.GetCellValue(rows[i],"recomName")	
						
						,"daltonismCd":sheet1.GetCellValue(rows[i],"daltonismCd")
						,"base1Ymd":sheet1.GetCellValue(rows[i],"base1Ymd")
						,"base2Ymd":sheet1.GetCellValue(rows[i],"base2Ymd")
						,"base3Ymd":sheet1.GetCellValue(rows[i],"base3Ymd")
						,"base1Yn":sheet1.GetCellValue(rows[i],"base1Yn")
						,"base2Yn":sheet1.GetCellValue(rows[i],"base2Yn")
						,"base3Yn":sheet1.GetCellValue(rows[i],"base3Yn")
						,"base1Cd":sheet1.GetCellValue(rows[i],"base1Cd")
						,"base2Cd":sheet1.GetCellValue(rows[i],"base2Cd")
						,"base3Cd":sheet1.GetCellValue(rows[i],"base3Cd")
						,"base1Nm":sheet1.GetCellValue(rows[i],"base1Nm")
						,"base2Nm":sheet1.GetCellValue(rows[i],"base2Nm")
						,"base3Nm":sheet1.GetCellValue(rows[i],"base3Nm")
						,"careerYyCnt":sheet1.GetCellValue(rows[i],"careerYyCnt")
						,"careerMmCnt":sheet1.GetCellValue(rows[i],"careerMmCnt")
						
				}
				rvArray.push(rvDatas);
			}
			//console.log(rvArray);
			//if(p.popReturnValue) p.popReturnValue(rvArray);
			//if(p.popReturnValue) p.window.opener.getReturnValue(rvArray);
			//p.self.close();
            const modal = window.top.document.LayerModalUtility.getModal('recBasicInfoRegEnterOrdLayer');
            modal.fire('recBasicInfoRegEnterOrdTrigger', rvArray).hide();  
		}
	}
	
    function closeLayerModal(){
        const modal = window.top.document.LayerModalUtility.getModal('recBasicInfoRegEnterOrdLayer');
        modal.hide();
    }

</script>
</head>
<body class="bodywrap">

    <div class="wrapper modal_layer">
    <!-- 
        <div class="popup_title">
            <ul>
                <li>사간전입 발령</li>
                <li class="close"></li>
            </ul>
        </div>
 -->
        <div class="modal_body">
            <form id="sheet1Form" name="sheet1Form" onsubmit="return false;">
                <div class="sheet_search outer">
                    <div>
                    <table>
                    <tr>
                    	<th class="hide">전출회사 </th>
						<td class="hide">  <select id="searchOrdEnterCd" 	name="searchOrdEnterCd" onChange="javascript:doAction1('Search');"> </select> </td>
						<th><tit:txt mid="104084" mdef="전출일 " /> </th>
						<td> 
							<input type="text" id="searchFromYmd" name ="searchFromYmd" class="date2 required" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),-30)%>"/> ~
							<input type="text" id="searchToYmd" name ="searchToYmd" class="date2 required" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),+30)%>"/>
						</td>
						<th>사번/성명</th>
                        <td>
                        	<input id="searchSabunName" name="searchSabunName" type="text" class="text"/>
                        </td>
                        <td>
                            <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a>
                        </td>
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
	                        <li id="txt" class="txt">사간전입 발령</li>
							<li class="btn">
								<!--
								<a href="javascript:doAction1('Insert');" class="basic authA">입력</a>
								<a href="javascript:doAction1('Save');" class="basic authA">저장</a>
								 -->
								<a href="javascript:doAction1('Down2Excel');" class="basic authA">다운로드</a>
								<!-- <a href="javascript:doAction1('UploadData');" class="basic authA">업로드</a> -->
							</li>
	                    </ul>
	                    </div>
	                </div>
	                <!--  <script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>-->
	                <div id="sheet1-wrap"></div>
	                </td>
	            </tr>
	        </table>

        </div>
        
        <div class="modal_footer">
	       <a href="javascript:closeLayerModal();" class="btn outline_gray">닫기</a>
	       <a href="javascript:passData();" class="btn filled">선택 데이터 가져오기</a>
        </div>
    </div>
</body>
</html>