<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>채용(인사기본사항)</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script language="javascript" src="/common/js/httpRequest.js" ></script>

<script type="text/javascript">
	var p = eval("${popUpStatus}");
	var arg = p.popDialogArgumentAll();
	var receiveNo = arg['receiveNo']||"";

	$(function() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
   			{Header:"일련번호",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"receiveNo",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
   			{Header:"입력일",				Type:"Date",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"regYmd",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"성명",				Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"성명(한자)",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"nameCn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"성명(영문)",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"nameUs",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"주민번호",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"resNo",		KeyField:0,	Format:"IdNo",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:13 },
			{Header:"주민번호",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"resNo2",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:13 },
			{Header:"외국인번호",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"foreignNo",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:13 },
			
			{Header:"생년월일",			Type:"Date",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"birYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"음양구분",			Type:"Combo",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"lunType",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"성별",				Type:"Combo",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sexType",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"혈액형",				Type:"Combo",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"bloodCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"결혼여부",			Type:"Combo",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"wedYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"결혼일자",			Type:"Date",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"wedYmd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:"외국인\n여부",		Type:"Combo",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"foreignYn",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"국적",				Type:"Combo",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"nationalCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"종교",				Type:"Combo",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"relCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"취미",				Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"hobby",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000 },
			{Header:"특기",				Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"specialityNote",KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000 },
			{Header:"휴대폰",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"mobileNo",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:20 },
			{Header:"이메일",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"mailAddr",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"채용구분",			Type:"Combo",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"stfType",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"채용경로",			Type:"Combo",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"empType",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },

			{Header:"그룹입사일",       Type:"Date",    Hidden:Number("${gempYmdHdn}"),   Width:100,  Align:"Center", ColMerge:0, SaveName:"gempYmd",     KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"입사일",           Type:"Date",    Hidden:1,   Width:100,  Align:"Center", ColMerge:0, SaveName:"empYmd",     KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"시용종료일",         Type:"Date",    Hidden:1,   Width:100,  Align:"Center", ColMerge:0, SaveName:"traYmd",     KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			
			{Header:"<sht:txt mid='base1Ymd' mdef='기준일1'/>",		Type:"Date",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base1Ymd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='base2Ymd' mdef='기준일2'/>",		Type:"Date",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base2Ymd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='base3Ymd' mdef='기준일3'/>",		Type:"Date",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base3Ymd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='base1Yn' mdef='기준여부1'/>",		Type:"CheckBox",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base1Yn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100,	FalseValue:"N", TrueValue:"Y" },
			{Header:"<sht:txt mid='base2Yn' mdef='기준여부2'/>",		Type:"CheckBox",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base2Yn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100,	FalseValue:"N", TrueValue:"Y" },{Header:"<sht:txt mid='base3Yn' mdef='기준여부3'/>",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base3Yn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='base2Cd' mdef='기준코드2'/>",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base2Cd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='base3Cd' mdef='기준코드3'/>",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base3Cd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='base1Nm' mdef='기준설명1'/>",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base1Nm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"<sht:txt mid='base2Nm' mdef='기준설명2'/>",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base2Nm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"<sht:txt mid='base3Nm' mdef='기준설명3'/>",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base3Nm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"<sht:txt mid='ht' mdef='신장'/>",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ht",			KeyField:0,	Format:"NullFloat",		PointCount:2,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='wt' mdef='체중'/>",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"wt",			KeyField:0,	Format:"NullFloat",		PointCount:2,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='eyeL' mdef='시력_좌'/>",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"eyeL",			KeyField:0,	Format:"NullFloat",		PointCount:1,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='eyeR' mdef='시력_우'/>",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"eyeR",			KeyField:0,	Format:"NullFloat",		PointCount:1,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='daltonismCd' mdef='색신'/>",		Type:"Combo",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"daltonismCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"입사경로",			Type:"Combo",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"pathCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"입사추천자",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"recomName",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			
			{Header:"인정직위",			Type:"Combo",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"base1Cd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"인정직위\n(년차)",	Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"careerYyCnt",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"인정직위\n(개월)",	Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"careerMmCnt",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"발령",				Type:"Combo",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"ordTypeCd",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"발령상세",			Type:"Combo",	Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"ordDetailCd",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"발령세부사유",		Type:"Combo",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"ordReasonCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			
			//사용안함
			{Header:"전화번호",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"telNo",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:20 }


		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(true);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var lunType = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H00030"), "");	//음양구분
		var sexType = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H00010"), " ");	//성별
		var bloodCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20460"), " ");	//혈액형
		var nationalCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20290"), "");	//국적
		var relCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20350"), " ");	//종교
		var stfType = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","F10001"), "");	//채용구분
		var empType = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","F10003"), "");	//채용경로
		var pathCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","F65010"), " ");	//입사경로
		var daltonismCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20337"), " ");	//색맹여부
		
		var base1Cd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20030"), " ");	//경력인정직위코드(H20030)
		var ordTypeCd = stfConvCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdTypeList&inOrdType=10,",false).codeList, "");//입사 발령형태
		var ordDetailCd = stfConvCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdDetailCdList&inOrdType=10,",false).codeList, "");//입사 발령
		var ordReasonCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&note1=A", "H40110"), " ");

		sheet1.SetColProperty("lunType", 		{ComboText:"|"+lunType[0], ComboCode:"|"+lunType[1]} );
		sheet1.SetColProperty("sexType", 		{ComboText:"|"+sexType[0], ComboCode:"|"+sexType[1]} );
		sheet1.SetColProperty("bloodCd", 		{ComboText:"|"+bloodCd[0], ComboCode:"|"+bloodCd[1]} );
		sheet1.SetColProperty("wedYn", 			{ComboText:"|기혼|미혼", ComboCode:"|Y|N"} );
		sheet1.SetColProperty("foreignYn", 		{ComboText:"|Y|N", ComboCode:"|Y|N"} );
		sheet1.SetColProperty("nationalCd", 	{ComboText:"|"+nationalCd[0], ComboCode:"|"+nationalCd[1]} );
		sheet1.SetColProperty("relCd", 			{ComboText:"|"+relCd[0], ComboCode:"|"+relCd[1]} );
		sheet1.SetColProperty("stfType", 		{ComboText:"|"+stfType[0], ComboCode:"|"+stfType[1]} );
		sheet1.SetColProperty("empType", 		{ComboText:"|"+empType[0], ComboCode:"|"+empType[1]} );
		sheet1.SetColProperty("pathCd", 		{ComboText:"|"+pathCd[0], ComboCode:"|"+pathCd[1]} );
		sheet1.SetColProperty("daltonismCd", 	{ComboText:"|"+daltonismCd[0], ComboCode:"|"+daltonismCd[1]} );
		sheet1.SetColProperty("base1Cd", 		{ComboText:"|"+base1Cd[0], ComboCode:"|"+base1Cd[1]} );
		sheet1.SetColProperty("ordTypeCd",		{ComboText:ordTypeCd[0], ComboCode:ordTypeCd[1]} );	
		sheet1.SetColProperty("ordDetailCd",	{ComboText:ordDetailCd[0], ComboCode:ordDetailCd[1]} );
		sheet1.SetColProperty("ordReasonCd",	{ComboText:"|"+ordReasonCd[0], ComboCode:"|"+ordReasonCd[1]} );

		if($("#hdnAuthPg").val() == 'A') {
			$("#lunType").html(lunType[2]);
			$("#sexType").html(sexType[2]);
			$("#bloodCd").html(bloodCd[2]);
			$("#wedYn").html("<option value=''></option><option value='Y'>기혼</option> <option value='N' selected>미혼</option>");
			$("#foreignYn").html("<option value=''></option><option value='Y'>Y</option> <option value='N' selected>N</option>");
			$("#nationalCd").html(nationalCd[2]);
			$("#relCd").html(relCd[2]);
			$("#pathCd").html(pathCd[2]);			
			$("#stfType").html(stfType[2]);
			$("#empType").html(empType[2]);
			$("#nationalCd").val("KR");
			$("#daltonismCd").html(daltonismCd[2]);
			$("#base1Cd").html(base1Cd[2]);
			$("#ordTypeCd").html(ordTypeCd[2]);
			$("#ordDetailCd").html(ordDetailCd[2]);
			$("#ordReasonCd").html(ordReasonCd[2]);
		}

		doAction1("Search");
	});

	$(function() {
        $(".close").click(function() {
	    	p.self.close();
	    });

        $("#resNo1","#resNo2").bind("keyup",function(event){
        	makeNumber(this,"A");
		});
        
        

        $("#foreignYn").bind("change",function(event){
        	var aa = $("#foreignYn").val();
        	if($("#foreignYn").val() =="Y"){
        		$("#foreignNo1").removeClass("readonly");
        		$("#foreignNo1").attr("readonly",false);
        		$("#foreignNo2").removeClass("readonly");
        		$("#foreignNo2").attr("readonly",false);
        		
        		var resNo1 = $("#resNo1").val();
        		var resNo2 = $("#resNo2").val();
        		$("#foreignNo1").val(resNo1);
        		$("#foreignNo2").val(resNo2);
        		
        			
        	}else{
        		$("#foreignNo1").addClass("readonly");
        		$("#foreignNo1").attr("readonly",true);
        		$("#foreignNo2").addClass("readonly");
        		$("#foreignNo2").attr("readonly",true);
        		$("#foreignNo1").val("");
        		$("#foreignNo2").val("");
        		
        	}
        	
		});
        

		if($("#hdnAuthPg").val() == 'A') {
			$( "#regYmd,#birYmd,#wedYmd,#traYmd,#base1Ymd,#base2Ymd,#base3Ymd" ).datepicker2();
			

			$("#gempYmd").datepicker2({
               onReturn: function(date) {
                    $("#empYmd").val(date);
                    var data = ajaxCall( "${ctx}/RecBasicInfoReg.do?cmd=getRecBasicInfoRegPopMap&searchEmpYmd="+date,"",false);
                    var traYmd = data.traYmd.substring(0,8)+"01";
                    $("#traYmd").val(traYmd);
	            }
	        });

			$("#empYmd").datepicker2({
               onReturn: function(date) {
                    var data = ajaxCall( "${ctx}/RecBasicInfoReg.do?cmd=getRecBasicInfoRegPopMap&searchEmpYmd="+date,"",false);
                    var traYmd = data.traYmd.substring(0,8)+"01";
                    $("#traYmd").val(traYmd);
	            }
	        });		
		}
				
	});

	//Sheet0 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var param = "receiveNo="+receiveNo;
			sheet1.DoSearch( "${ctx}/RecBasicInfoReg.do?cmd=getRecBasicInfoRegPopList", param);
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
			$('#regYmd').val("${curSysYyyyMMddHyphen}");
			return;
		}
		
		$('#resNo1').val(sheet1.GetCellValue(row,"resNo").substring(0,6));
		
		$('#name').val(sheet1.GetCellValue(row,"name"));	
		$('#nameCn').val(sheet1.GetCellValue(row,"nameCn"));
		$('#nameUs').val(sheet1.GetCellValue(row,"nameUs"));
		$('#sexType').val(sheet1.GetCellValue(row,"sexType"));
		$('#regYmd').val(sheet1.GetCellText(row,"regYmd"));
		$('#birYmd').val(sheet1.GetCellText(row,"birYmd"));
		$('#relCd').val(sheet1.GetCellValue(row,"relCd"));
		$('#bloodCd').val(sheet1.GetCellValue(row,"bloodCd"));
		$('#lunType').val(sheet1.GetCellValue(row,"lunType"));
		$('#hobby').val(sheet1.GetCellValue(row,"hobby"));
		$('#specialityNote').val(sheet1.GetCellValue(row,"specialityNote"));
		$('#wedYn').val(sheet1.GetCellValue(row,"wedYn"));
		$('#wedYmd').val(sheet1.GetCellText(row,"wedYmd"));
		$('#telNo').val(sheet1.GetCellValue(row,"telNo"));
		$('#mobileNo').val(sheet1.GetCellValue(row,"mobileNo"));
		$('#foreignYn').val(sheet1.GetCellValue(row,"foreignYn"));
		 
		if($("#foreignYn").val() == 'Y') {
			
			$('#foreignNo1').val(sheet1.GetCellValue(row,"foreignNo").substring(0,6));
			$('#foreignNo2').val(sheet1.GetCellValue(row,"foreignNo").substring(6,13));
			
       		$("#foreignNo1").removeClass("readonly");
       		$("#foreignNo1").attr("readonly",false);
       		$("#foreignNo2").removeClass("readonly");
       		$("#foreignNo2").attr("readonly",false);
        		
		}  
			
		$('#nationalCd').val(sheet1.GetCellValue(row,"nationalCd"));
		
		/*
		var mailAddr = sheet1.GetCellValue(row,"mailAddr");
		mailAddr = mailAddr.split("@");
		$('#mailAddr').val(mailAddr[0]);
		*/
		
		$('#mailAddr').val(sheet1.GetCellValue(row,"mailAddr"));
		
		$('#stfType').val(sheet1.GetCellValue(row,"stfType"));
		$('#empType').val(sheet1.GetCellValue(row,"empType"));
		$('#pathCd').val(sheet1.GetCellValue(row,"pathCd"));
		$('#recomName').val(sheet1.GetCellValue(row,"recomName"));		

		$('#gempYmd').val(sheet1.GetCellText(row,"gempYmd"));
        $('#empYmd').val(sheet1.GetCellText(row,"empYmd"));
        $('#traYmd').val(sheet1.GetCellText(row,"traYmd"));		
		
   		$('#ht').val(sheet1.GetCellValue(row,"ht"));
		$('#wt').val(sheet1.GetCellValue(row,"wt"));
		$('#eyeL').val(sheet1.GetCellValue(row,"eyeL"));
		$('#eyeR').val(sheet1.GetCellValue(row,"eyeR"));
		$('#daltonismCd').val(sheet1.GetCellValue(row,"daltonismCd"));
		
		$('#base1Ymd').val(sheet1.GetCellText(row,"base1Ymd"));
		$('#base2Ymd').val(sheet1.GetCellText(row,"base2Ymd"));
		$('#base3Ymd').val(sheet1.GetCellText(row,"base3Ymd"));

		$('#base1Yn').val(sheet1.GetCellValue(row,"base1Yn"));
		$('#base2Yn').val(sheet1.GetCellValue(row,"base2Yn"));
		$('#base3Yn').val(sheet1.GetCellValue(row,"base3Yn"));

		$('#base1Cd').val(sheet1.GetCellValue(row,"base1Cd"));
		$('#base2Cd').val(sheet1.GetCellValue(row,"base2Cd"));
		$('#base3Cd').val(sheet1.GetCellValue(row,"base3Cd"));

		$('#base1Nm').val(sheet1.GetCellValue(row,"base1Nm"));
		$('#base2Nm').val(sheet1.GetCellValue(row,"base2Nm"));
		$('#base3Nm').val(sheet1.GetCellValue(row,"base3Nm"));
		
		$('#careerYyCnt').val(sheet1.GetCellValue(row,"careerYyCnt"));
		$('#careerMmCnt').val(sheet1.GetCellValue(row,"careerMmCnt"));

		$('#ordTypeCd').val(sheet1.GetCellValue(row,"ordTypeCd"));
		$('#ordDetailCd').val(sheet1.GetCellValue(row,"ordDetailCd"));
		$('#ordReasonCd').val(sheet1.GetCellValue(row,"ordReasonCd"));
		
		if (sheet1.GetCellValue(row,"base1Yn") == 'Y' ) $("#base1Yn").attr("checked",true); 
		else $("#base1Yn").attr("checked",false); 
		
		if (sheet1.GetCellValue(row,"base2Yn") == 'Y' ) $("#base2Yn").attr("checked",true); 
		else $("#base2Yn").attr("checked",false); 
		
		if (sheet1.GetCellValue(row,"base3Yn") == 'Y' ) $("#base3Yn").attr("checked",true); 
		else $("#base3Yn").attr("checked",false); 			

		
		if($("#hdnAuthPg").val() == 'A') {
			$('#resNo2').val(sheet1.GetCellValue(row,"resNo").substring(6,13));
		} else {			
			$('#resNo2').val("*******");
			
			if($("#foreignYn").val() == 'Y') {
				$('#foreignNo2').val("*******");	
			}
			
			$('#sexTypeNm').val(sheet1.GetCellText(row,"sexType"));
			$('#lunTypeNm').val(sheet1.GetCellText(row,"lunType"));
			$('#relNm').val(sheet1.GetCellText(row,"relCd"));
			$('#bloodNm').val(sheet1.GetCellText(row,"bloodCd"));
			$('#wedYnNm').val(sheet1.GetCellText(row,"wedYn"));
			$('#foreignYnNm').val(sheet1.GetCellText(row,"foreignYn"));
			$('#nationalNm').val(sheet1.GetCellText(row,"nationalCd"));
			$('#stfTypeNm').val(sheet1.GetCellText(row,"stfType"));
			$('#empTypeNm').val(sheet1.GetCellText(row,"empType"));
			$('#pathNm').val(sheet1.GetCellText(row,"pathCd"));
            $('#daltonismNm').val(sheet1.GetCellText(row,"daltonismNm"));  
    		$('#base1CdNm').val(sheet1.GetCellText(row,"base1Cd"));
    		$('#base2CdNm').val(sheet1.GetCellText(row,"base2Cd"));
    		$('#base3CdNm').val(sheet1.GetCellText(row,"base3Cd"));
    		$('#ordTypeNm').val(sheet1.GetCellText(row,"ordTypeCd"));
    		$('#ordDetailNm').val(sheet1.GetCellText(row,"ordDetailCd"));
			$('#ordReasonCdNm').val(sheet1.GetCellText(row,"ordReasonCd"));
		}
	}

	// 폼에서 시트로 세팅.
	function setSheetData() {

		var row = sheet1.LastRow();

		if($("#hdnAuthPg").val() == 'A') {
			
			if($('#regYmd').val() == "") {
				alert("입력일을 입력하여 주십시오.");
				$('#regYmd').focus();
				return;
			}
			
			if($('#gempYmd').val() == "") {
				alert("그룹입사일을 입력하여 주십시오.");
				$('#gempYmd').focus();
				return;
			}			
			
			if($('#empYmd').val() == "") {
				alert("입사일을 입력하여 주십시오.");
				$('#empYmd').focus();
				return;
			}						

			if($('#name').val() == "") {
				alert("성명을 입력하여 주십시오.");
				$('#name').focus();
				return;
			}
			
			
			if($('#resNo1').val() == "" || $('#resNo2').val() == "") {
				alert("주민번호를 입력하여 주십시오.");
				$('#resNo1').focus();
				return;
			}

			if($('#foreignYn').val() != "Y") {	//외국인인 경우 주민번호 체크하지 않음
				if(isValid_socno($('#resNo1').val()+$('#resNo2').val()) == false){
					if(confirm("주민등록번호가 유효하지 않습니다. 그래도 입력하시겠습니까?")) {
						
					}else{
						$('#resNo1').focus();
						return;
					}
				}
			}
			
			if($('#foreignYn').val() == "Y") {	//외국인인 경우 주민번호 체크하지 않음
				var foreignNo1 =  $('#foreignNo1').val();
				var foreignNo2 =  $('#foreignNo2').val();
				$('#resNo1').val(foreignNo1);
				$('#resNo2').val(foreignNo2);
				
				if(isValid_socno($('#foreignNo1').val()+$('#foreignNo2').val()) == false){
					if(confirm("외국인등록번호가 유효하지 않습니다. 그래도 입력하시겠습니까?")) {
						
					}else{
						$('#foreignNo1').focus();
						return;
					}
				}
			}
			
			
			


			if($('#mobileNo').val() != "" &&  telCheck($('#mobileNo')) == false) {
				$('#mobileNo').focus();
				return;
			}


			if($('#mailAddr').val() != "" &&  emailCheck($('#mailAddr')) == false) {
				$('#mailAddr').focus();
				return;
			}
			
			//그룹웨어 이메일 체크, 구축 회사에 따라 구현 필요
			/*
			if($('#mailAddr').val() != "") {
				
				var vId = $('#mailAddr').val();
				
				var devUrlStr = "";		//구축 회사 url 정의 필요    
			    var prodUrlStr = "";	//구축 회사 url 정의 필요
				
				if(hIp.equals("127.0.0.1") || hIp.toLowerCase().equals("local")){
					urlStr = devUrlStr + "?service_id=GW00004&&user_id="+idCheck;	
				}
				else{
					urlStr = prodUrlStr + "?service_id=GW00004&&user_id="+idCheck;	
				}
				
		       var data = ajaxCall( "${ctx}/RecBasicInfoReg.do?cmd=getGroupWareIdCheck&urlStr="+urlStr,"",false);
		       
		       if (data.rtnData =="true"){
		    	   alert('사용할 수 있는 이메일 아이디 입니다.');
		    	   
		       }else{
		    	   alert('사용할 수 없는 이메일 아이디 입니다.');
		    	   $('#mailAddr').focus()
		    	   return ;	
		       }
		       
			}
			*/
			
			if($('#stfType').val() == "") {
				alert("채용구분을 입력하여 주십시오.");
				$('#stfType').focus();
				return;
			}

			 if($('#empType').val() == "") {
				alert("채용경로를 입력하여 주십시오.");
				$('#empType').focus();
				return;
			} 
			
			if($('#ordTypeCd').val() == "") {
				alert("발령을 선택하여 주십시오.");
				$('#ordTypeCd').focus();
				return;
			}			
			
			if($('#ordDetailCd').val() == "") {
				alert("발령상세를을 선택하여 주십시오.");
				$('#ordDetailCd').focus();
				return;
			}

			var rtnValue = [];
			
			rtnValue["ordTypeCd"] = $('#ordTypeCd').val();
			rtnValue["ordDetailCd"] = $('#ordDetailCd').val();
			rtnValue["ordReasonCd"] = $('#ordReasonCd').val();			

			rtnValue["resNo"] = $('#resNo1').val()+$('#resNo2').val();
			
			rtnValue["foreignNo"] = $('#foreignNo1').val()+$('#foreignNo2').val();
			
			rtnValue["name"] = $('#name').val();
			rtnValue["sexType"] = $('#sexType').val();
			rtnValue["regYmd"] = formatDate($('#regYmd').val(),"");
			rtnValue["birYmd"] = formatDate($('#birYmd').val(),"");
			rtnValue["nameCn"] = $('#nameCn').val();
			rtnValue["nameUs"] = $('#nameUs').val();
			rtnValue["relCd"] = $('#relCd').val();
			rtnValue["bloodCd"] = $('#bloodCd').val();
			rtnValue["lunType"] = $('#lunType').val();
			rtnValue["hobby"] = $('#hobby').val();
			rtnValue["specialityNote"] = $('#specialityNote').val();
			rtnValue["wedYn"] = $('#wedYn').val();
			rtnValue["wedYmd"] = formatDate($('#wedYmd').val(),"");
			rtnValue["telNo"] = $('#telNo').val();
			rtnValue["mobileNo"] = $('#mobileNo').val();
			rtnValue["foreignYn"] = $('#foreignYn').val();
			rtnValue["nationalCd"] = $('#nationalCd').val();
			
			/*
			if ( $('#mailAddr').val() == "" ) {
				rtnValue["mailAddr"] = "";
			} else {
				rtnValue["mailAddr"] = $('#mailAddr').val()+"@구축회사 메일 주소";
			}
			*/
			
			rtnValue["mailAddr"] = $('#mailAddr').val();

			rtnValue["stfType"] = $('#stfType').val();
			rtnValue["empType"] = $('#empType').val();
			rtnValue["pathCd"] = $('#pathCd').val();
			rtnValue["recomName"] = $('#recomName').val();
			
			
			rtnValue["gempYmd"] = formatDate($('#gempYmd').val(),"");
			rtnValue["empYmd"] =  formatDate($('#empYmd').val(),""); 
			rtnValue["traYmd"] =  formatDate($('#traYmd').val(),""); 
			
			rtnValue["ht"] = $('#ht').val();
			rtnValue["wt"] = $('#wt').val();
			rtnValue["eyeL"] = $('#eyeL').val();
			rtnValue["eyeR"] = $('#eyeR').val();
			rtnValue["daltonismCd"] = $('#daltonismCd').val();
			
			rtnValue["base1Ymd"] =  formatDate($('#base1Ymd').val(),""); 
			rtnValue["base2Ymd"] =  formatDate($('#base2Ymd').val(),""); 
			rtnValue["base3Ymd"] =  formatDate($('#base3Ymd').val(),""); 

			if ( $("#base1Yn").is(":checked") == true ) rtnValue["base1Yn"] = "Y";
			else rtnValue["base1Yn"] = "N";
			
			if ( $("#base2Yn").is(":checked") == true ) rtnValue["base2Yn"] = "Y";
			else rtnValue["base2Yn"] = "N";
			
			if ( $("#base3Yn").is(":checked") == true ) rtnValue["base3Yn"] = "Y";
			else rtnValue["base3Yn"] = "N";
			
			rtnValue["base1Cd"] = $('#base1Cd').val();
			rtnValue["base2Cd"] = $('#base2Cd').val();
			rtnValue["base3Cd"] = $('#base3Cd').val();
			
			rtnValue["base1Nm"] = $('#base1Nm').val();
			rtnValue["base2Nm"] = $('#base2Nm').val();
			rtnValue["base3Nm"] = $('#base3Nm').val();
			
			rtnValue["careerYyCnt"] = $('#careerYyCnt').val();
			rtnValue["careerMmCnt"] = $('#careerMmCnt').val();
			rtnValue["ordTypeCd"] = $('#ordTypeCd').val();
			rtnValue["ordDetailCd"] = $('#ordDetailCd').val();
			rtnValue["ordReasonCd"] = $('#ordReasonCd').val();
			
			p.popReturnValue(rtnValue);
		}

		p.window.close();
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

	function telCheck(obj) {
		var regExp = /^(01[016789]{1}|02|0[3-9]{1}[0-9]{1})-?[0-9]{3,4}-?[0-9]{4}$/;

	    if (!regExp.test($(obj).val())) {
	        alert("잘못된 전화번호입니다. 숫자 또는 - 를 포함한 숫자만 입력하세요.\n예) 050XXXXXXXX,050-XXXX-XXXX");
	        $(obj).focus();
	        $(obj).select();
	        return false;
	    }
	    return true;
	}

	function emailCheck(obj) {
        var regExp = /([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;

	    if (!regExp.test($(obj).val())) {
	    	alert('이메일 주소가 유효하지 않습니다.');
	        $(obj).focus();
	        $(obj).select();
	        return false;
	    }
	    return true;
	}

	
	function idCheck(){
		var vId = $('#mailAddr').val();
		
		$.ajax({
			type : 'POST',
			//dataType : "JSON",
			traditional : true,
			url : '${ctx}/getIdCheck.do',
			async:false,
			data : {
				idCheck : vId
			},
			success : function(data) {
				if(data=='true'){
					alert("사용할 수 있는 아이디입니다.");
				}else{
					alert("사용할 수 없는 아이디입니다.");
				}
			},
			error : function(e) {
		        //alert("실패 "+request+":"+status+":"+error);
		        alert(e.status);
		    }
		});
	}
</script>
</head>

<body class="bodywrap">
	<div class="wrapper">
		<input id="hdnAuthPg" name="hdnAuthPg" type="hidden" value="${authPg}">
        <div class="popup_title">
            <ul>
                <li>채용(인사기본사항)</li>
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
				<th>입력일</th>
				<td><input id="regYmd" name="regYmd" type="text" class="${dateCss} required" ${readonly}></td>
				<th>그룹입사일/입사일</th>
                <td>
                	<input id="gempYmd" name="gempYmd" type="text" class="${dateCss} required" ${readonly}>
                   	/
                   	<input id="empYmd" name="empYmd" type="text" class="${dateCss} required" ${readonly}>
                </td>
			</tr>
			<tr>
				<th>성명(한글/한자)</th>
				<td>
			<c:choose>
				<c:when test="${authPg == 'A'}">
					<input id="name" name="name" type="text" class="${textCss} required" maxlength="30" ${readonly}>
					<input id="nameCn" name="nameCn" type="text" class="${textCss}" maxlength="30" ${readonly}>
				</c:when>
				<c:otherwise>
					<input id="name" name="name" type="text" class="${textCss}" maxlength="30" ${readonly}>
				</c:otherwise>
			</c:choose>
				</td>
				<th>영문명(Full)</th>
				<td>
					<input id="nameUs" name="nameUs" type="text" class="${textCss}" style="width:200px;" maxlength="100" ${readonly}>
				</td>
			</tr>
			<tr>
				<th>주민등록번호/성별</th>
				<td><input id="resNo1" name="resNo1" type="text" class="${textCss} required" maxlength="6" ${readonly} style="width:50px;"> -
				<input id="resNo2" name="resNo2" type="text" class="${textCss} required" maxlength="7" ${readonly} style="width:60px;">
				/
			<c:choose>
				<c:when test="${authPg == 'A'}">
					<select id="sexType" name="sexType">
					</select>
				</c:when>
				<c:otherwise>
					<input id="sexTypeNm" name="sexTypeNm" type="text" class="${textCss}" readonly>
				</c:otherwise>
			</c:choose>	
				</td>
				<th>생년월일</th>
				<td>
			<c:choose>
				<c:when test="${authPg == 'A'}">
					<select id="lunType" name="lunType">
					</select>
				</c:when>
				<c:otherwise>
					<input id="lunTypeNm" name="lunTypeNm" type="text" class="${textCss}" readonly>
				</c:otherwise>
			</c:choose>
				/							
				<input id="birYmd" name="birYmd" type="text" class="${dateCss}" ${readonly}>
				</td>
			</tr>
			<tr>
				<th>외국인여부/국적</th>
				<td>
			<c:choose>
				<c:when test="${authPg == 'A'}">
					<select id="foreignYn" name="foreignYn">
					</select>
					/
					<select id="nationalCd" name="nationalCd">
                    </select>
				</c:when>
				<c:otherwise>
					<input id="foreignYnNm" name="foreignYnNm" type="text" class="${textCss}" readonly>
					/
					<input id="nationalNm" name="nationalNm" type="text" class="${textCss}" readonly>
				</c:otherwise>
			</c:choose>
				</td>
				<th>결혼여부/일자</th>
				<td>
			<c:choose>
				<c:when test="${authPg == 'A'}">
					<select id="wedYn" name="wedYn">
					</select>
				</c:when>
				<c:otherwise>
					<input id="wedYnNm" name="wedYnNm" type="text" class="${textCss}" readonly>
				</c:otherwise>
			</c:choose>
				/
				<input id="wedYmd" name="wedYmd" type="text" class="${dateCss}" ${readonly}>
				</td>
			</tr>			
			<tr class="hide">
				<th>시력/색신</th>
				<td>좌&nbsp;(<input id="eyeL" name="eyeL" type="text" class="${textCss} center w25" ${readonly}>)
					우&nbsp;(<input id="eyeR" name="eyeR" type="text" class="${textCss} center w20" ${readonly}>)
						/
						<c:choose>
							<c:when test="${authPg == 'A'}">
								<select id="daltonismCd" name="daltonismCd"></select>
								<input 	id="daltonismNm" name="daltonismNm" type="hidden" class="${textCss}" ${readonly}>
							</c:when>
							<c:otherwise>
								<input id="daltonismCd" name="daltonismCd" type="hidden" class="${textCss}" ${readonly}>
								<input id="daltonismNm" name="daltonismNm" type="text" class="${textCss}" readonly>
							</c:otherwise>
						</c:choose>
				</td>
				<th>신장/체중</th>
				<td>
				<input id="ht" name="ht" type="text" class="${textCss} center w40" ${readonly}>&nbsp;Cm 
				/
				<input id="wt" name="wt" type="text" class="${textCss} center w40" ${readonly}>&nbsp;Kg
				</td>
			</tr>
			
			<tr>
			<!-- 
				<th>혈액형/종교</th>
				<td>
					<c:choose>
						<c:when test="${authPg == 'A'}">
							<select id="bloodCd" name="bloodCd">
							</select>
						</c:when>
						<c:otherwise>
							<input id="bloodNm" name="bloodNm" type="text" class="${textCss}" readonly>
						</c:otherwise>
					</c:choose>
						/
					<c:choose>
						<c:when test="${authPg == 'A'}">
							<select id="relCd" name="relCd">
							</select>
						</c:when>
						<c:otherwise>
							<input id="relNm" name="relNm" type="text" class="${textCss}" readonly>
						</c:otherwise>
					</c:choose>			
				</td>
				-->
				<th>외국인등록번호</th>
				<td><input id="foreignNo1" name="foreignNo1" type="text" class="${textCss} readonly" readonly maxlength="6" ${readonly} style="width:50px;"> -
				<input id="foreignNo2" name="foreignNo2" type="text" class="${textCss} readonly " readonly maxlength="7" ${readonly} style="width:60px;">
				
				<th>수습종료일</th>
				<td><input id="traYmd" name="traYmd" type="text" class="${dateCss}" ${readonly}></td>				
			</tr>			
			<tr>
				<th>이메일</th>
				<td>
					<input id="mailAddr" name="mailAddr" type="text" class="${textCss} required w100p" maxlength="100" ${readonly}>
					<!-- <span style="font-size:13px;">@구축회사 메일 주소</span>	 -->
					<!-- <button id="idCheckButton" type="button" onclick="idCheck();">중복체크</button> -->
				</td>
				<th>휴대폰</th>
				<td>
					<input id="mobileNo" name="mobileNo" type="text" class="${textCss}" style="width:110px;" maxlength="20" ${readonly}>
				</td>
			</tr>		
			<tr>
				<th>취미</th>
				<td><input id="hobby" name="hobby" type="text" class="${textCss} w100p" maxlength="100" ${readonly}></td>
				<th>특기</th>
				<td><input id="specialityNote" name="hobby" type="text" class="${textCss} w100p" maxlength="100" ${readonly}></td>
			</tr>	
			<tr class="hide">
				<th>발령상세/세부사유</th>
				<td>
					<c:choose>
						<c:when test="${authPg == 'A'}">
							<select id="ordTypeCd" name="ordTypeCd" class="required"></select>
						</c:when>
						<c:otherwise>
							<input id="ordTypeNm" name="ordTypeNm" type="text" class="${textCss}" readonly>
						</c:otherwise>
					</c:choose>				
					<c:choose>
						<c:when test="${authPg == 'A'}">
							<select id="ordDetailCd" name="ordDetailCd" class="required"></select>
						</c:when>
						<c:otherwise>
							<input id="ordDetailNm" name="ordDetailNm" type="text" class="${textCss}" readonly>
						</c:otherwise>
					</c:choose>
						/
					<c:choose>
						<c:when test="${authPg == 'A'}">
							<select id="ordReasonCd" name="ordReasonCd"></select>
						</c:when>
						<c:otherwise>
							<input id="ordReasonNm" name="ordReasonNm" type="text" class="${textCss}" readonly>
						</c:otherwise>
					</c:choose>
				</td>
				<th>인정직위(년월)</th>
				<td>
					<c:choose>
						<c:when test="${authPg == 'A'}">
							<select id="base1Cd" name="base1Cd"></select>
							<input  id="base1Nm" name="base1Nm" type="hidden" class="${textCss} w60" ${readonly}>
							(<input id="careerYyCnt" name="careerYyCnt" type="text" class="${textCss} center w20 hide" ${readonly}> &nbsp;년)	 
							<input id="careerMmCnt" name="careerMmCnt" type="text" class="${textCss} center w20" ${readonly}>&nbsp;개월)
						</c:when>
						<c:otherwise>
							<input id="base1Cd" name="base1Cd" type="hidden" class="${textCss}" ${readonly}>
							<input id="base1Nm" name="base1Nm" type=hidden class="${textCss} w60" readonly>
							(<input id="careerYyCnt" name="careerYyCnt" type="hidden" class="${textCss} center w20 hide" ${readonly}>&nbsp;년)	 
							(<input id="careerMmCnt" name="careerMmCnt" type="hidden" class="${textCss} center w20" ${readonly}>&nbsp;개월)
						</c:otherwise>
					</c:choose>
				</td>
			</tr>
			<tr>
				<th>채용구분/채용경로</th>
				<td>
					<c:choose>
						<c:when test="${authPg == 'A'}">
							<select id="stfType" name="stfType" class="required"></select>
						</c:when>
						<c:otherwise>
							<input id="stfTypeNm" name="stfTypeNm" type="text" class="${textCss}" readonly>
						</c:otherwise>
					</c:choose>
					/
					<c:choose>
						<c:when test="${authPg == 'A'}">
							<select id="empType" name="empType" class="required">
							</select>
						</c:when>
						<c:otherwise>
							<input id="empTypeNm" name="empTypeNm" type="text" class="${textCss}" readonly>
						</c:otherwise>
					</c:choose>
				</td>
				<th>입사추천자</th>
				<td>
					<span class="hide">
					<c:choose>
						<c:when test="${authPg == 'A'}">
							<select id="pathCd" name="pathCd">
							</select>
						</c:when>
						<c:otherwise>
							<input id="pathNm" name="pathNm" type="text" class="${textCss}" readonly>
						</c:otherwise>
					</c:choose>
					/
					</span>
					<input id="recomName" name="recomName" type="text" class="${textCss}" style="width:110px;" maxlength="50" ${readonly}>
				</td>
			</tr>
			<tr class="hide">
			<td>
				<input id="base2Ymd" 	name="base2Ymd" 	type="hidden">
				<input id="base3Ymd" 	name="base3Ymd" 	type="hidden">
				<input id="base3Yn" 	name="base3Yn" 		type="hidden">
				<input id="base2CdNm" 	name="base2CdNm"	type="hidden">
				<input id="base3Cd" 	name="base3Cd" 		type="hidden">
				<input id="base3CdNm" 	name="base3CdNm" 	type="hidden">
			</td>
		</tr>
			</table>

			<div class="hide">
				<script type="text/javascript"> createIBSheet("sheet1", "0", "0", "kr"); </script>
			</div>

			<div class="popup_button outer">
			<ul>
				<li>
			<c:choose>
				<c:when test="${authPg == 'A'}">
					<a href="javascript:setSheetData();" class="pink large">확인</a>
					<a href="javascript:p.self.close();" class="gray large">닫기</a>
				</c:when>
				<c:otherwise>
					<a href="javascript:p.self.close();" class="gray large">닫기</a>
				</c:otherwise>
			</c:choose>
				</li>
			</ul>
			</div>
		</div>
	</div>
</body>
</html>