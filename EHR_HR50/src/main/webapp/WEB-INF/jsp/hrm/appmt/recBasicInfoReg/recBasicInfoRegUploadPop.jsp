<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>채용(인사기본사항) 업로드</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript" src="/common/js/execAppmt.js"></script>

<script type="text/javascript">
	var p = eval("${popUpStatus}");
	var arg = p.popDialogArgumentAll();
	
	var processNo = "";
	var processNm = "";
	
	var POST_ITEMS = [];	
	
	$(function() {
		// 발령항목 조회
		POST_ITEMS = ajaxCall("${ctx}/AppmtItemMapMgr.do?cmd=getAppmtItemMapMgrList","searchUseYn=Y",false).DATA;		
		
	    if( arg != undefined ) {
	    	processNo		= arg["processNo"];
	    	processNm		= arg["processNm"];
	    }else{
			if ( p.popDialogArgument("processNo") !=null ) { processNo		   		= p.popDialogArgument("processNo"); }
			if ( p.popDialogArgument("processNm") !=null ) { processNm		   		= p.popDialogArgument("processNm"); }
	    }
	    
	    $("#processTitle").text( "   (발령번호 : " + processNo+" ["+processNm + "] \)")
	    $("#searchProcessNo").val(processNo);
	    
		var initdata1 = {};
		initdata1.Cfg = {FrozenCol:3,SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
  			{Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"상태",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
   			
   			{Header:"발령번호",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"processNo",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
   			{Header:"일련번호",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"receiveNo",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
   			{Header:"사번생성룰구분",		Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabunType",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
   			{Header:"사번",			Type:"Text",	    Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:13 },
   			{Header:"발령",				Type:"Combo",		Hidden:0,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"ordTypeCd",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"발령상세",			Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"ordDetailCd",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
   			{Header:"성명",				Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
   			{Header:"입력일",				Type:"Date",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"regYmd",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
   			{Header:"그룹입사일",			Type:"Date",	Hidden:Number("${gempYmdHdn}"),	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"gempYmd",		KeyField:1,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"입사일",				Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"empYmd",		KeyField:1,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='traYmdYn' mdef='시용종료일'/>",		Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"traYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
   			{Header:"채용구분",			Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"stfType",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
   			{Header:"채용경로",			Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"empType",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
   			
			{Header:"조정직급",			Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base1Cd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
   			{Header:"조정직급(년차)",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"careerYyCnt",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"경력인정년월(월)",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"careerMmCnt",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
   			{Header:"성명(한자)",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"cname",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
   			{Header:"성명(영문)",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ename1",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
   			{Header:"주민번호",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"resNo2",		KeyField:0,	Format:"IdNo",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
   			{Header:"성별",				Type:"Combo",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sexType",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1 },
   			{Header:"음양력",				Type:"Combo",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"lunType",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1 },
   			{Header:"생년월일",			Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"birYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
   			{Header:"결혼여부",			Type:"Combo",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"wedYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1 },
   			{Header:"결혼일자",			Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"wedYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
   			{Header:"외국인\n여부",			Type:"Combo",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"foreignYn",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1 },
   			{Header:"국적",				Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"nationalCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
   			{Header:"이메일",				Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"mailAddr",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"휴대폰",				Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"mobileNo",	KeyField:1,	Format:"PhoneNo",PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:20 },
			//{Header:"전화번호",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"telNo",		KeyField:0,	Format:"PhoneNo",PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:20 },

			{Header:"<sht:txt mid='eyeL' mdef='시력_좌'/>",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"eyeL",			KeyField:0,	Format:"NullFloat",		PointCount:1,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='eyeR' mdef='시력_우'/>",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"eyeR",			KeyField:0,	Format:"NullFloat",		PointCount:1,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='daltonismCd' mdef='색신'/>",		Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"daltonismCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 }, 
   			{Header:"<sht:txt mid='ht' mdef='신장'/>",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ht",			KeyField:0,	Format:"NullFloat",		PointCount:2,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='wt' mdef='체중'/>",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"wt",			KeyField:0,	Format:"NullFloat",		PointCount:2,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
   			{Header:"혈액형",				Type:"Combo",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"bloodCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
   			{Header:"종교",				Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"relCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
   			{Header:"취미",				Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"hobby",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1000 },
   			{Header:"특기",				Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"specialityNote",KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1000 },
	   			
			
			{Header:"<sht:txt mid='base1Ymd' mdef='근속기준일'/>",		Type:"Date",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base1Ymd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='base1Ymd' mdef='근속기준일'/>",		Type:"Date",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base1Ymd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='base2Ymd' mdef='기준일2'/>",		Type:"Date",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base2Ymd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='base3Ymd' mdef='기준일3'/>",		Type:"Date",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base3Ymd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='base1Yn' mdef='근속예외여부'/>",		Type:"CheckBox",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base1Yn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100,	FalseValue:"N", TrueValue:"Y" },
			{Header:"<sht:txt mid='base2Yn' mdef='사택사용여부'/>",		Type:"CheckBox",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base2Yn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100,	FalseValue:"N", TrueValue:"Y" },
			{Header:"<sht:txt mid='base3Yn' mdef='기준여부3'/>",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base3Yn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='base2Cd' mdef='기준코드2'/>",		Type:"Combo",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base2Cd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='base3Cd' mdef='기준코드3'/>",		Type:"Combo",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base3Cd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='base1Nm' mdef='기준설명1'/>",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base1Nm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1000 },
			{Header:"<sht:txt mid='base2Nm' mdef='기준설명2'/>",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base2Nm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1000 },
			{Header:"<sht:txt mid='base3Nm' mdef='기준설명3'/>",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base3Nm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1000 },
			{Header:"발령세부사유",			Type:"Combo",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ordReasonCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
   			
   			//{Header:"입사경로",			Type:"Combo",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"pathCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
   			//{Header:"입사추천자",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"recomName",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
   			
   			{Header:"사번\n확정",		Type:"CheckBox",    Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabunYn",	    KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
   			{Header:"채용순번",		Type:"Text",	    Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"seq",    KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
   			{Header:"지원자번호",		Type:"Text",	    Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"applKey",    KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
   			
			{Header:"성명(한자)",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"nameCn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"성명(영문)",			Type:"Text",		Hidden:1,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"nameUs",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
						{Header:"입사경로",			Type:"Combo",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"pathCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"입사추천자",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"recomName",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"채용공고명",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"seqNm",    	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"퇴직(전출)\n회사",		Type:"Combo",		Hidden:1,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"ordEnterCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"퇴직(전출)\n사번",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"ordEnterSabun",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },

			{Header:"발령확정\n여부",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"ordYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"reason",			Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"reason",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:200 },
		    {Header:"외국인등록번호",		Type:"Text",		Hidden:1,	Width:110,	Align:"Center",	ColMerge:0,	SaveName:"foreignNo",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:200 },
		    {Header:"승인/반려\n여부",		Type:"Combo",		Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"apprYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"개인이메일",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"psnlEmail",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }

   			
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		//남/여 구분(1:남 2:여)
		var sexType = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H00010"), " ");
		//국적
		var nationalCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20290"), " ");
		//혈액형
		var bloodCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20460"), " ");
		//채용구분
		var stfType = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","F10001"), " ");
		//채용경로
		var empType = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","F10003"), " ");
		//입사경로
		//var pathCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","F65010"), " ");
		//종교
		var relCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20350"), " ");
		//사번생성룰구분
		var sabunType = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10160"), "");
		//입사발령
		//var ordDetailCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdDetailCdList&inOrdType=10,",false).codeList, "");//입사 발령
		
		var ordTypeCd = stfConvCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdTypeList&inOrdType=10,",false).codeList, "");//입사 발령형태
		var ordDetailCd = stfConvCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdDetailCdList&inOrdType=10,",false).codeList, "");//입사 발령종류
		
		
		var daltonismCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20337"), " ");	//색맹여부
		var base1Cd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20010"), " ");	//경력직위

		sheet1.SetColProperty("foreignYn", 		{ComboText:"|Y|N", ComboCode:"|Y|N"} );
		sheet1.SetColProperty("nationalCd", 	{ComboText:"|"+nationalCd[0], ComboCode:"|"+nationalCd[1]} );
		sheet1.SetColProperty("sexType", 		{ComboText:"|"+sexType[0], ComboCode:"|"+sexType[1]} );
		sheet1.SetColProperty("bloodCd", 		{ComboText:"|"+bloodCd[0], ComboCode:"|"+bloodCd[1]} );
		sheet1.SetColProperty("stfType", 		{ComboText:"|"+stfType[0], ComboCode:"|"+stfType[1]} );
		sheet1.SetColProperty("empType", 		{ComboText:"|"+empType[0], ComboCode:"|"+empType[1]} );
		//sheet1.SetColProperty("pathCd", 		{ComboText:"|"+pathCd[0], ComboCode:"|"+pathCd[1]} );
		sheet1.SetColProperty("relCd", 			{ComboText:"|"+relCd[0], ComboCode:"|"+relCd[1]} );
		sheet1.SetColProperty("lunType", 		{ComboText:"|양|음", ComboCode:"|1|2"} );
		sheet1.SetColProperty("wedYn", 			{ComboText:"|기혼|미혼", ComboCode:"|Y|N"} );
		sheet1.SetColProperty("sabunType", 		{ComboText:"|"+sabunType[0], ComboCode:"|"+sabunType[1]} );
		sheet1.SetColProperty("ordDetailCd", 		{ComboText:"|"+ordDetailCd[0], ComboCode:"|"+ordDetailCd[1]} );
		sheet1.SetColProperty("ordTypeCd",		{ComboText:ordTypeCd[0], ComboCode:ordTypeCd[1]} );	
		
		sheet1.SetColProperty("daltonismCd", 	{ComboText:"|"+daltonismCd[0], ComboCode:"|"+daltonismCd[1]} );
		sheet1.SetColProperty("base1Cd", 		{ComboText:"|"+base1Cd[0], ComboCode:"|"+base1Cd[1]} );

		$(window).smartresize(sheetResize); sheetInit();
	});

	$(function() {
        $(".close").click(function() {
	    	p.self.close();
	    });
	});

	//Sheet0 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Save":	
			IBS_SaveName(document.sheet1Form,sheet1);		
			var paramStr = setAppmtParamSet(POST_ITEMS,sheet1,sheet1.FindStatusRow("U")+"".split(";"),$("#sheet1Form"));		
			sheet1.DoSave( "${ctx}/RecBasicInfoReg.do?cmd=saveRecBasicInfoRegNew", $("#sheet1Form").serialize()+paramStr+"&ordGubun=A");			
			break;			
		case "Insert":
			var row = sheet1.DataInsert();
			sheet1.SetCellValue(row, "processNo", processNo);
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			var d = new Date();
			var fName = "excel_" + d.getTime() + ".xlsx";
			sheet1.Down2Excel($.extend(param, { FileName:fName, SheetDesign:1, Merge:1 }));
			break;
		case "UploadData":
			if ( processNo == "" ){
				alert("발령번호를 먼저 선택후 수행하세요.");
				return;
			}
			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet1.LoadExcel(params);
			break;
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
				if (Msg != "") {
					alert(Msg);
				}
				p.window.close();
				p.window.opener.doAction1("Search");
			} catch (ex) {
				alert("OnSaveEnd Event Error " + ex);
			}
	}
	
	function sheet1_OnLoadExcel(result) {

		/* if(result) {
			sheet1.SetRangeValue( processNo, sheet1.HeaderRows(), 2, sheet1.LastRow(), 2);
		} else {
			alert('엑셀 로딩중 오류가 발생하였습니다.');
		} */
	}

</script>
</head>
<body class="bodywrap">
<form id="sheet1Form" name="sheet1Form"></form>
	<input type="hidden" id="searchProcessNo" name="searchProcessNo" /> 
    <div class="wrapper">
        <div class="popup_title">
            <ul>
                <li>채용(인사기본사항) 업로드 </li>
                <li class="close"></li>
            </ul>
        </div>

        <div class="popup_main">
	        <table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	            <tr>
	                <td>
	                <div class="inner">
	                    <div class="sheet_title">
	                    <ul>
	                        <li id="txt" class="txt">채용(인사기본사항) 업로드 <span id="processTitle" style="color: red;"></span> </li>
							<li class="btn">
								<a href="javascript:doAction1('Down2Excel');" class="basic authR">양식다운로드</a>
								<a href="javascript:doAction1('Insert');" class="basic authA">입력</a>
								<a href="javascript:doAction1('Save');" class="basic authA">저장</a>
								<a href="javascript:doAction1('UploadData');" class="basic authA">업로드</a>								
							</li>
	                    </ul>
	                    </div>
	                </div>
	                <script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
	                </td>
	            </tr>
	        </table>

	        <div class="popup_button outer">
	            <ul>
	                <li>
	                	<a href="javascript:p.self.close();" class="gray large">닫기</a>              
	                </li>
	            </ul>
	        </div>
        </div>
    </div>
</body>
</html>