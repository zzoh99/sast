<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>채용기본사항등록</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript" src="/common/js/execAppmt.js"></script>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";
	var POST_ITEMS = [];
	$(function() {
		
		$("#btn_moveEmpPictrue").hide();

		// 발령항목 조회
		POST_ITEMS = ajaxCall("${ctx}/AppmtItemMapMgr.do?cmd=getAppmtItemMapMgrList","searchUseYn=Y",false).DATA;

		var initdata1 = {};
		initdata1.Cfg = {FrozenCol:16,SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
			{Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"상태",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
   			{Header:"세부\n내역",			Type:"Image",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"ibsImage1",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"일련\n번호",			Type:"Text",		Hidden:1,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"receiveNo",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"승인/반려\n여부",		Type:"Combo",		Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"apprYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			
			{Header:"사번생성룰\n구분",		Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabunType",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
		//	{Header:"선택",				Type:"CheckBox",	Hidden:0,	Width:55,	Align:"Center",	ColMerge:0,	SaveName:"chkYn",		KeyField:0,	Format:"",		CalcLogic:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1 , TrueValue:"Y", FalseValue:"N"},
			{Header:"사번\n생성/확정",		Type:"CheckBox",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabunYn",	    KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"사번\n확정",			Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabunYn2",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1},
			{Header:"발령연계\n처리",		Type:"CheckBox",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"prePostYn",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"발령연계\n처리",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"prePostYn2",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1},
			{Header:"발령",				Type:"Combo",		Hidden:0,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"ordTypeCd",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"발령상세",			Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"ordDetailCd",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"발령세부사유",			Type:"Combo",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ordReasonCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"입력일",				Type:"Date",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"regYmd",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"사번",				Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:13 },
			{Header:"성명",				Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"주민등록번호(1)",			Type:"Text",		Hidden:1,	Width:110,	Align:"Center",	ColMerge:0,	SaveName:"resNo",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:600 },
			{Header:"주민등록번호",			Type:"Text",		Hidden:0,	Width:110,	Align:"Center",	ColMerge:0,	SaveName:"resNo2",		KeyField:1,	Format:"IdNo",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:13 },
			{Header:"성별",				Type:"Combo",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sexType",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"이메일",				Type:"Text",		Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"mailAddr",    KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"개인이메일",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"psnlEmail",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"그룹입사일",			Type:"Date",		Hidden:Number("${gempYmdHdn}"),	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"gempYmd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"입사일",				Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"empYmd",		KeyField:1,	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"수습종료일",			Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"traYmd",	    KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
	
			{Header:"성명(한자)",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"nameCn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"성명(영문)",			Type:"Text",		Hidden:1,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"nameUs",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"음양구분",			Type:"Combo",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"lunType",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"생년월일",			Type:"Date",		Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"birYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"결혼여부",			Type:"Combo",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"wedYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"결혼일자",			Type:"Date",		Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"wedYmd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"시력(좌)",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"eyeL",		KeyField:0,	Format:"NullFloat",		PointCount:1,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"시력(우)",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"eyeR",		KeyField:0,	Format:"NullFloat",		PointCount:1,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"색신",				Type:"Combo",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"daltonismCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"신장",				Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ht",			KeyField:0,	Format:"NullFloat",		PointCount:2,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"체중",				Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"wt",			KeyField:0,	Format:"NullFloat",		PointCount:2,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"혈액형",				Type:"Combo",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"bloodCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"종교",				Type:"Combo",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"relCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"외국인\n여부",		Type:"Combo",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"foreignYn",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"국적",				Type:"Combo",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"nationalCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"외국인등록번호",		Type:"Text",		Hidden:1,	Width:110,	Align:"Center",	ColMerge:0,	SaveName:"foreignNo",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:200 },
			{Header:"휴대폰",				Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"mobileNo",    KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"취미",				Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"hobby",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"특기",				Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"specialityNote",KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"채용구분",			Type:"Combo",		Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"stfType",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"입사구분",			Type:"Combo",		Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"empType",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"입사경로",			Type:"Combo",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"pathCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"입사추천자",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"recomName",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			
			{Header:"인정직위",			Type:"Combo",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"base1Cd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"인정직위\n(년차)",		Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"careerYyCnt",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"인정직위\n(개월)",		Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"careerMmCnt",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"발령번호",			Type:"Popup",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"processNo",   KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },

			{Header:"퇴직(전출)\n회사",		Type:"Combo",		Hidden:1,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"ordEnterCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"퇴직(전출)\n사번",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"ordEnterSabun",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },

			{Header:"발령확정\n여부",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"ordYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"발령확정\n여부",		Type:"Image",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"ibsImage4",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },

			{Header:"발령일",				Type:"Date",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ordYmd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"발령seq",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"applySeq",    KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"조회여부",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"visualYn",    KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"채용순번",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"seq",    		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"지원자번호",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"applKey",    	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"채용공고명",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"seqNm",    	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },

			{Header:"applTime",			Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"applTime",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:130 },
			{Header:"apprSabun",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"apprSabun",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:130 },
			{Header:"apprTime",			Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"apprTime",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:130 },
			{Header:"reason",			Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"reason",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:200 },
			
			{Header:"<sht:txt mid='chkReEmp' mdef='재입사자'/>",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"chkReEmp",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
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

		sheet1.SetImageList(0,"/common/images/icon/icon_x.png");
 		sheet1.SetImageList(1,"/common/images/icon/icon_x.png");
		sheet1.SetImageList(1,"/common/images/icon/icon_o.png");
		sheet1.SetImageList(3,"/common/images/icon/icon_info.png");
		sheet1.SetDataLinkMouse("ibsImage1", 1);

		sheet1.SetColProperty("wedYn", 			{ComboText:"|미혼|기혼|이혼", ComboCode:"|N|Y|3"} );
		sheet1.SetColProperty("foreignYn", 		{ComboText:"N|Y", ComboCode:"N|Y"} );
		sheet1.SetColProperty("apprYn", 		{ComboText:"승인요청|승인|반려", ComboCode:"A|Y|N"} );

		var seqNm = stfConvCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getSeqNmList",false).codeList, "채용공고 제외 조회");//입사 발령
		$("#searchSeqNm").html(seqNm[2]);
		getCommonCodeList();
		$(window).smartresize(sheetResize); sheetInit();
		//doAction1("Search");
	});

	function getCommonCodeList() {
		let baseSYmd = $("#regYmdFrom").val();
		let baseEYmd = $("#regYmdTo").val();

		let ordTypeCdParams = "baseSYmd=" + baseSYmd + "&baseEYmd=" + baseEYmd + "&queryId=getOrdTypeList&inOrdType=10,"
		const ordTypeCd = stfConvCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", ordTypeCdParams, false).codeList, "");//입사 발령형태
		sheet1.SetColProperty("ordTypeCd",		{ComboText:ordTypeCd[0], ComboCode:ordTypeCd[1]} );

		let ordDetailCdParams = "baseSYmd=" + baseSYmd + "&baseEYmd=" + baseEYmd + "&queryId=getOrdDetailCdList&inOrdType=10,"
		const ordDetailCd = stfConvCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", ordDetailCdParams, false).codeList, "");//입사 발령종류
		sheet1.SetColProperty("ordDetailCd",	{ComboText:ordDetailCd[0], ComboCode:ordDetailCd[1]} );

		var sabunType = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10160", baseSYmd, baseEYmd), " ");	//사번생성룰
		sheet1.SetColProperty("sabunType", 		{ComboText:sabunType[0], ComboCode:sabunType[1]} );

		var ordReasonCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&note1=A", "H40110", baseSYmd, baseEYmd), " ");
		sheet1.SetColProperty("ordReasonCd",	{ComboText:"|"+ordReasonCd[0], ComboCode:"|"+ordReasonCd[1]} );

		var ordEnterCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W90000", baseSYmd, baseEYmd), " ");	//전출회사
		sheet1.SetColProperty("ordEnterCd", 	{ComboText:"|"+ordEnterCd[0], ComboCode:"|"+ordEnterCd[1]} );

		// 채용구분, 입사구분 => 발령형태코드(ordTypeCd), 발령종류코드(ordDetailCd) 사용 사례, 2021.03.01, CBS
		sheet1.SetColProperty("stfType", 		{ComboText:ordTypeCd[0], ComboCode:ordTypeCd[1]} );
		sheet1.SetColProperty("empType", 		{ComboText:ordDetailCd[0], ComboCode:ordDetailCd[1]} );

		// 채용구분, 입사구분 => 발령종류코드(ordDetailCd), 발령상세코드(H40110)(ordReasonCd)  사용 사례, 2021.03.01, CBS
		/*
		sheet1.SetColProperty("stfType", 		{ComboText:ordDetailCd[0], ComboCode:ordDetailCd[1]} );
		sheet1.SetColProperty("empType", 		{ComboText:"|"+ordReasonCd[0], ComboCode:"|"+ordReasonCd[1]} );
		*/

		// 기존 채용구분코드(F10001), 입사구분코드(F10003) 사용 사례, 2021.03.01, CBS
		/*
		var stfType = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","F10001"), " ");	//채용구분
		var empType = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","F10003"), " ");	//입사구분

		sheet1.SetColProperty("stfType", 		{ComboText:"|"+stfType[0], ComboCode:"|"+stfType[1]} );
		sheet1.SetColProperty("empType", 		{ComboText:"|"+empType[0], ComboCode:"|"+empType[1]} );
		*/

		var lunType = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H00030", baseSYmd, baseEYmd), " ");	//음양구분
		sheet1.SetColProperty("lunType", 		{ComboText:"|"+lunType[0], ComboCode:"|"+lunType[1]} );

		var sexType = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H00010", baseSYmd, baseEYmd), " ");	//성별
		sheet1.SetColProperty("sexType", 		{ComboText:"|"+sexType[0], ComboCode:"|"+sexType[1]} );

		var bloodCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20460", baseSYmd, baseEYmd), " ");	//혈액형
		sheet1.SetColProperty("bloodCd", 		{ComboText:"|"+bloodCd[0], ComboCode:"|"+bloodCd[1]} );

		var nationalCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20290", baseSYmd, baseEYmd), " ");	//국적
		sheet1.SetColProperty("nationalCd", 	{ComboText:nationalCd[0], ComboCode:nationalCd[1]} );

		var relCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20350", baseSYmd, baseEYmd), "");	//종교
		sheet1.SetColProperty("relCd", 			{ComboText:"|"+relCd[0], ComboCode:"|"+relCd[1]} );

		var pathCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","F65010", baseSYmd, baseEYmd), " ");	//입사경로
		sheet1.SetColProperty("pathCd", 		{ComboText:"|"+pathCd[0], ComboCode:"|"+pathCd[1]} );

		var daltonismCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20337", baseSYmd, baseEYmd), " ");	//색맹여부
		sheet1.SetColProperty("daltonismCd", 	{ComboText:"|"+daltonismCd[0], ComboCode:"|"+daltonismCd[1]} );

		var base1Cd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20030", baseSYmd, baseEYmd), " ");	//경력인정직위코드(H20030)
		sheet1.SetColProperty("base1Cd",		{ComboText:"|"+base1Cd[0], ComboCode:"|"+base1Cd[1]} );

	}

	$(function() {

        $("#searchName").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search"); $(this).focus();
			}
		});
        
        $("#searchSabunYn,#searchOrdYn,#searchSeqNm").change(function(){
        	if($(this).attr("id") == "searchSeqNm") {
	        	if($(this).val() != "" ) {
	        		$("#btn_moveEmpPictrue").show();
	        	} else {
	        		$("#btn_moveEmpPictrue").hide();
	        	}
        	}
        		
        	doAction1("Search"); $(this).focus();
		});        

		$("#regYmdFrom").datepicker2({startdate:"regYmdTo"});
		$("#regYmdTo").datepicker2({enddate:"regYmdFrom"});

	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			getCommonCodeList();
			if($("#regYmdFrom").val() == "") {
				alert("입력시작일을 입력하여 주십시오.");
				$("#regYmdFrom").focus();
				return;
			}
			if($("#regYmdTo").val() == "") {
				alert("입력종료일을 입력하여 주십시오.");
				$("#regYmdTo").focus();
				return;
			}
			/*
			if($("#searchProcessNo").val() == "" ){
				alert("발령번호를 먼저 선택후 조회하세요.");
				return;
			}
			*/
			sheet1.DoSearch( "${ctx}/RecBasicInfoReg.do?cmd=getRecBasicInfoRegList", $("#sendForm").serialize() );
			break;
		case "Save":
			
			//발령연계처리 적용건이 1건이라도 있으면 발령번호 입력체크
			var sRow = (sheet1.FindStatusRow("U")+"").split(";");
			for(var i in sRow){
				if(sheet1.GetCellValue(sRow[i],"prePostYn") == "Y" && sheet1.GetCellValue(sRow[i],"prePostYn2")!="Y"){
					

					sheet1.SetCellValue(sRow[i],"ordYmd",sheet1.GetCellValue(sRow[i],"empYmd"));
					//발령연계처리적용
					/*
					if($("#searchProcessNo").val() == ""){
						alert("발령연계처리적용건이 있습니다. 발령번호를 선택후 수행하세요.");
						return;
					}else{
						sheet1.SetCellValue(sRow[i],"processNo",$("#searchProcessNo").val());
					}
					*/
				}

				if(sheet1.GetCellValue(sRow[i], "sabunYn") == "Y" && sheet1.GetCellValue(sRow[i], "sabun") == "") {
					alert("사번생성이 되지 않은건은 [사번확정]을 수행할 수 없습니다. \n 사번생성 또는 사원번호를 입력 후 저장하십시오.");
					return;
				}
				// 채용기본사항승인 사용안함
				/*	
				if(sheet1.GetCellValue(sRow[i], "apprYn") == "N" && sheet1.GetCellValue(sRow[i], "sStatus") == "U") {
					sheet1.SetCellValue(sRow[i], "apprYn" , "A");
				}
				*/
			}
			
			
			

			IBS_SaveName(document.sendForm,sheet1);
			//var paramStr = setAppmtParamSet(POST_ITEMS,sheet1,sheet1.FindStatusRow("U")+"".split(";"),$("#sendForm"));
			var paramStr = setAppmtParamSet(POST_ITEMS,sheet1, null ,$("#sendForm"));

			// 주민번호 RSA 암호화
			var rsa = new RSAKey();
			rsa.setPublic("${sessionScope.RSAModulus}", "${sessionScope.RSAExponent}");

			// 주민번호 암호화 처리
			for (var i=sheet1.HeaderRows(); i<=sheet1.LastRow(); i++) {
				if(sheet1.GetCellValue(i, "sStatus") === 'I' || sheet1.GetCellValue(i, "sStatus") === 'U') {
					var resNo = rsa.encrypt(sheet1.GetCellValue(i, "resNo"));
					sheet1.SetCellValue(i, "resNo", resNo);
				}
			}
			sheet1.DoSave( "${ctx}/RecBasicInfoReg.do?cmd=saveRecBasicInfoRegNew", $("#sendForm").serialize()+paramStr+"&ordGubun=");
			//sheet1.DoSave( "${ctx}/SaveData.do?cmd=saveRecBasicInfoReg", $("#sendForm").serialize()+paramStr);
			break;
		case "Insert":
			/*
			if($("#searchProcessNo").val() == "" ){
				alert("발령번호를 먼저 선택후 수행하세요.");
				return;
			}
			*/

			var row = sheet1.DataInsert(0);

			sheet1.SetCellValue(row, "processNo", $("#searchProcessNo").val());
			sheet1.SetCellValue(row, "regYmd", "${curSysYyyyMMddHyphen}");
			//sheet1.SetCellValue(row, "gempYmd", "${curSysYyyyMMddHyphen}");
			//sheet1.SetCellEditable(row,"sabunType" , 0);
			sheet1.SetCellEditable(row,"sabunYn" , 0);
			sheet1.SetCellEditable(row,"prePostYn" , 0);
			
//			sheet1.SetRowEditable(row, false);
//			showDetailPop(row);
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExtendParam:"&secType=RSNO&secParam=resNo2" };
			var d = new Date();
			var fName = "채용기본사항등록_" + d.getTime();
			sheet1.Down2Excel($.extend(param, { FileName:fName, SheetDesign:1, Merge:1 }));

			break;
		case "DownTemplate":
			// 양식다운로드
			var d = new Date();
			var fName = "채용기본사항등록(업로드)_" + d.getTime();
			sheet1.Down2Excel({ FileName:fName, SheetDesign:1, Merge:1, DownRows:"0", DownCols:"sabunType|ordTypeCd|ordDetailCd|sabun|name|resNo2|sexType|mailAddr|gempYmd|empYmd|traYmd"});
			break;

		case "LoadExcel":
			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet1.LoadExcel(params);
			break;

		case "SabunCre":
			if(sheet1.RowCount() > 0) {
				/*
				if(sheet1.RowCount("U") > 0) {
					alert("수정된 데이터가 존재합니다. 저장후 사번을 생성하십시오.");
					return;
				}
				*/
				if($("#regYmdFrom").val() == "") {
					alert("입력일을 입력하여 주십시오.");
					$("#regYmdFrom").focus();
					return;
				}
				if($("#regYmdTo").val() == "") {
					alert("입력일을 입력하여 주십시오.");
					$("#regYmdTo").focus();
					return;
				}
				for(var i = 1; i < sheet1.RowCount()+1; i++) {
					if(!sheet1.GetCellValue(i, "name")) {
						alert("성명을 입력해주세요.");
						return;
					}
					if(!sheet1.GetCellValue(i, "resNo2")) {
						alert("주민등록번호를 입력해주세요.");
						return;
					}
					if(!sheet1.GetCellValue(i, "empYmd")) {
						alert("입사일을 입력해주세요.");
						return;
					}
				}

				var selReceiveNo = ""

				for(var i = 1; i < sheet1.RowCount()+1; i++) {
					console.log(sheet1.GetCellValue(i, "sabunYn"));
					if(sheet1.GetCellValue(i, "sabunYn") == "Y" && sheet1.GetCellValue(i, "sabun") == "") {
						selReceiveNo =selReceiveNo + sheet1.GetCellValue(i,"receiveNo")+",";
					}
				}
				if(selReceiveNo.length==0){
					alert("사번생성할 항목을 선택해주세요. ");
					return;
				}

				if(!confirm("사번을 생성하시겠습니까?")) {
					return;
				}
				
				var selSabun ="";
				var selName ="";
				var selResNo ="";
				selReceiveNo = selReceiveNo.substring(0,selReceiveNo.length-1);

				var param  = "regYmdFrom="+$("#regYmdFrom").val().replace(/-/gi,"");
					param += "&regYmdTo="+$("#regYmdTo").val().replace(/-/gi,"");
					
					param += "&searchProcessNo="+$("#searchProcessNo").val();
					param += "&searchName="+$("#searchName").val();
					param += "&searchSabunYn="+$("#searchSabunYn").val();
					param += "&searchOrdYn="+$("#searchOrdYn").val();
					//param += "&searchSeqNm="+$("#searchSeqNm").val();
					param +="&searchSeqNm="+selReceiveNo;				    
//				var data = ajaxCall("${ctx}/RecBasicInfoReg.do?cmd=prcSabunCreAppmtSave",param,false);
				var data = ajaxCall("${ctx}/RecBasicInfoReg.do?cmd=prcSabunCreAppmtSave",param,false);

				if(data.Result != null ){
			    	alert(data.Result.Message);
			    	doAction1("Search");
				} else {
					alert("알수 없는 에러가 발생하였습니다.\n 관리자에게 문의 바랍니다." );
					doAction1("Search");
				}
			}
			break;
		case "ProcessSet":
			break;
		case "ProcessClear":
			$("#searchProcessNo").val("");
			$("#searchProcessTitle").val("");
			break;
		case "MoveEmpPicture":
			if(confirm("채용공고 사진이미지를 인사시스템으로 복사합니다.\n반드시 사번생성 후 작업을 진행 하셔야 합니다.\n이미 복사된 사진이미지도 새롭게 변경됩니다.\n작업 하시겠습니까?")) {			
				if( $("#searchSeqNm").val() != "" ) {
					var data  = ajaxCall("${ctx}/RecBasicInfoReg.do?cmd=copyPictureFilesByRecServiceReg", "enterCd=${ssnEnterCd}&seq="+$("#searchSeqNm").val(), false);
					if(data.Result != null ){
						alert(data.Result.Message);
					} else {
						alert("알수 없는 에러가 발생하였습니다.\n 관리자에게 문의 바랍니다." );
					}
				}
			} else {
				alert("작업이 취소되었습니다.");
				return;
			}
			break;l
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			sheetResize();

			if(sheet1.RowCount() > 0) {
				for(var i = 1; i < sheet1.RowCount()+1; i++) {

					if(sheet1.GetCellValue(i, "prePostYn") == "Y" || sheet1.GetCellValue(i, "ordYn") == "Y" || sheet1.GetCellValue(i, "sabunYn") == "Y") {

						sheet1.SetCellEditable(i,"sDelete", false);
						sheet1.SetCellEditable(i,"regYmd", false);
						sheet1.SetCellEditable(i,"name", false);
						sheet1.SetCellEditable(i,"resNo", false);
						sheet1.SetCellEditable(i,"resNo2", false);
						sheet1.SetCellEditable(i,"sexType", false);
						sheet1.SetCellEditable(i,"mailAddr", false);
						sheet1.SetCellEditable(i,"stfType", false);
						sheet1.SetCellEditable(i,"empType", false);
						sheet1.SetCellEditable(i,"gempYmd", false);
						sheet1.SetCellEditable(i,"empYmd", false);
						sheet1.SetCellEditable(i,"traYmd", false);

						sheet1.SetCellEditable(i,"sabun", false);
						sheet1.SetCellEditable(i,"sabunType", false);

						sheet1.SetCellEditable(i,"processNo", false);
//						sheet1.SetCellEditable(i,"chkYn", false);
					}
					
					if(sheet1.GetCellValue(i, "prePostYn") == "Y" && sheet1.GetCellValue(i, "sabunYn") == "Y" ){
					
						sheet1.SetCellEditable(i,"ordTypeCd", false);
						sheet1.SetCellEditable(i,"ordDetailCd", false);
					}
							
					if(sheet1.GetCellValue(i,"sabun") == ""){
					//	sheet1.SetCellEditable(i,"sabunYn",false);
					}
					if(sheet1.GetCellValue(i, "sabunYn") != "Y"){
						sheet1.SetCellEditable(i, "prePostYn", false);
					}
					if(sheet1.GetCellValue(i,"prePostYn")=="Y"){
						sheet1.SetCellEditable(i,"sabunYn",false);
					}
					if(sheet1.GetCellValue(i,"ordYn")=="Y"){
						sheet1.SetRowEditable(i, false);
                    }
					
					/*A : 승인요청 , N 반려  */
					// 채용기본사항승인 사용안함
					/*	
					if(sheet1.GetCellValue(i,"apprYn")=="A"){
						sheet1.SetRowEditable(i, false);
						//sheet1.SetCellEditable(i,"sabunYn" ,false);
					}else if(sheet1.GetCellValue(i,"apprYn")=="N"){
						sheet1.SetRowEditable(i, true);
						sheet1.SetCellEditable(i,"sabunType" ,false);
						sheet1.SetCellEditable(i,"sabunYn" ,false);
						sheet1.SetCellEditable(i,"prePostYn" ,false);
						sheet1.SetCellEditable(i,"sabun" ,false);
					}else{
						sheet1.SetRowEditable(i, false);
						sheet1.SetCellEditable(i,"sabunType" ,true);
						sheet1.SetCellEditable(i,"sabunYn" ,true);
						sheet1.SetCellEditable(i,"prePostYn" ,true);
						sheet1.SetCellEditable(i,"sabun" ,true);
					}
                    */
					
					if(sheet1.GetCellValue(i, "sabunYn") == "Y"){
						sheet1.SetCellEditable(i, "sabun", false);
						sheet1.SetCellEditable(i, "sabunType", false);
					}

				}
			}
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

	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {

		    if( sheet1.ColSaveName(Col) == "ibsImage1" ) {
		    	if(sheet1.GetCellValue(Row,"sStatus") == "I" || sheet1.GetCellValue(Row,"sStatus") == "U" ) {
		    		alert("저장후 확인할 수 있습니다.");
		    	} else {
			    	showDetailPop(Row);
		    	}
		    }			
			
			
		    if(sheet1.ColSaveName(Col) == "sDelete") {
		        if(sheet1.GetCellValue(Row,"sabunYn") == "Y" || sheet1.GetCellValue(Row, "prePostYn") == "Y" || sheet1.GetCellValue(Row, "ordYn") == "Y") {
		            alert("[사번확정, 발령연계처리,발령확정] 건은 삭제할 수 없습니다.");
		        }
		     	// 채용기본사항승인 사용안함
				/*	
		        else if(sheet1.GetCellValue(Row,"apprYn") != "N") {
		        	alert("[승인요청, 승인] 건은 삭제할 수 없습니다.");
		        }
		        */
		    }
		    
		    if(sheet1.ColSaveName(Col) == "sabunYn"){
		    	//if(sheet1.GetCellValue(Row,"sabun")==""){
		    	//	alert("사번생성이 되지 않은건은 [사번확정]을 수행할 수 없습니다.");
		    	//}
		    	if(sheet1.GetCellValue(Row,"prePostYn2")=="Y"){
		    		alert("이미 발령연계처리 적용된 건은 [사번확정취소]를 수행할 수 없습니다.");
		    	}
		    }
		    
		    if(sheet1.ColSaveName(Col) == "prePostYn"){
		    	if(sheet1.GetCellValue(Row,"sabunYn2")!="Y"){
		    		alert("사번확정 되지 않은 건은 [발령연계처리적용]을 수행할 수 없습니다.");

		    	}
		    }

			if(sheet1.ColSaveName(Col) == "processNo" && sheet1.GetCellEditable(Row,"processNo") == true){
				if(!isPopup()) {return;}

				gPRow = Row;
				pGubun = "searchAppmtConfirmRowPopup";
				openPopup("/Popup.do?cmd=viewAppmtProcessNoMgrPopup&authPg=R", "", "1000","600");

				
			}

		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}

	// 셀 클릭시 발생
	function sheet1_OnChange(Row, Col, Value, OldValue) {
		try{
			// 채용구분, 입사구분 => 발령형태코드(ordTypeCd), 발령종류코드(ordDetailCd) 사용 사례, 2021.03.01, CBS
			if( sheet1.ColSaveName(Col) == "ordTypeCd"  ) {
				sheet1.SetCellValue(Row,"stfType",sheet1.GetCellValue(Row,"ordTypeCd"));
			}else if( sheet1.ColSaveName(Col) == "ordDetailCd"  ) {
				sheet1.SetCellValue(Row,"empType",sheet1.GetCellValue(Row,"ordDetailCd"));
			}	
			
			// 채용구분, 입사구분 => 발령종류코드(ordDetailCd), 발령상세코드(H40110)(ordReasonCd)  사용 사례, 2021.03.01, CBS
			/*
			if( sheet1.ColSaveName(Col) == "ordDetailCd"  ) {
				sheet1.SetCellValue(Row,"stfType",sheet1.GetCellValue(Row,"ordDetailCd"));
			}else if( sheet1.ColSaveName(Col) == "ordReasonCd"  ) {
				sheet1.SetCellValue(Row,"empType",sheet1.GetCellValue(Row,"ordReasonCd"));
			}
			*/
			
			if( sheet1.ColSaveName(Col) == "resNo2"  ) {
				if(sheet1.GetCellValue(Row,"resNo2") != ""){
					if(pGubun != "recBasicInfoRegPopA"){
						var resno = sheet1.GetCellValue(Row,"resNo2");

						if(isValid_socno(sheet1.GetCellValue(Row,"resNo2")) == false){
							if(confirm("주민등록번호가 유효하지 않습니다. 그래도 입력하시겠습니까?")) {
								if(resno.substr(6, 1) == "1" || resno.substr(6, 1) == "3") {
									sheet1.SetCellValue(Row, "sexType", "1");
								} else if(resno.substr(6, 1) == "2" || resno.substr(6, 1) == "4") {
									sheet1.SetCellValue(Row, "sexType", "2");
								}
							}else{
								sheet1.SetCellValue(Row, "resNo2","");
							}
						}else{
							if(resno.substr(6, 1) == "1" || resno.substr(6, 1) == "3") {
								sheet1.SetCellValue(Row, "sexType", "1");
							} else if(resno.substr(6, 1) == "2" || resno.substr(6, 1) == "4") {
								sheet1.SetCellValue(Row, "sexType", "2");
							}
						}
					}
					sheet1.SetCellValue(Row, "resNo", Value);
					//email 가져오기
					//getEmailFromResno(Row);
				
				}
			/*
			}else if( sheet1.ColSaveName(Col) == "mailAddr"  ) {
				var mailAddr = sheet1.GetCellValue(Row,"mailAddr");
				if(mailAddr != ""){
					if(chkPattern(mailAddr, "EMAIL")){
						mailAddr = mailAddr.substr(0, mailAddr.indexOf("@"));
						var param = "mailAddr=" + mailAddr;
						var data = ajaxCall('${ctx}/RecBasicInfoReg.do?cmd=getMailAddrChk', param, false);
						if(data.result != null){
							var jsonResult = JSON.parse(data.result);
							var str = jsonResult["soap:Envelope"]["soap:Body"]["DuplicateCheck_URResponse"]["DuplicateCheck_URResult"];
							if(str == "EXIST_URCODE"){
								alert("중복된 이메일 입니다");
								sheet1.SetCellValue(Row,"mailAddr", "");
							}else if (str == "ERROR"){
								alert("이메일 중복 조회중 오류가 발생했습니다");
								//sheet1.SetCellValue(Row,"mailAddr", "");
							}
						}else{
							sheet1.SetCellValue(Row,"mailAddr", "");
						}
					}else{
						alert("메일주소를 다시 입력해주세요.");
					}
				}
			*/
			}else if( sheet1.ColSaveName(Col) == "gempYmd"  ) {
				sheet1.SetCellValue(Row,"empYmd",sheet1.GetCellValue(Row,"gempYmd"));
				
				var gempYmd = sheet1.GetCellValue(Row,"gempYmd");
				var days =gempYmd.substr(6,2);

				var traYmd = dateFormatToString(add_months( sheet1.GetCellValue(Row,"gempYmd") , 3), "-");
				
				if(traYmd.length==9){
					traYmd = traYmd.substr(0,8)+days;
				}
				
				sheet1.SetCellValue(Row,"traYmd", traYmd);
				
			}else if( sheet1.ColSaveName(Col) == "empYmd"  ) {
				
				var traYmd = dateFormatToString(add_months( sheet1.GetCellValue(Row,"empYmd") , 3), "-");
				
				var empYmd = sheet1.GetCellValue(Row,"empYmd");
				var days =empYmd.substr(6,2);
				
				if(traYmd.length==9){
					traYmd = traYmd.substr(0,8)+days;
				}
				
				sheet1.SetCellValue(Row,"traYmd", traYmd);
				
			}else if( sheet1.ColSaveName(Col) == "foreignYn"  ) {

				var resNo2 = sheet1.GetCellValue(Row,"resNo2");
				 if(Value =="Y"){
					 sheet1.SetCellValue(Row,"foreignNo", resNo2);	 
				 }else{
					 sheet1.SetCellValue(Row,"foreignNo", "");
				 }
				
								
			}else if(sheet1.ColSaveName(Col) == "sabun"){
				if(Value != ""){
					var objCnt = ajaxCall('${ctx}/GetDataMap.do?cmd=getSabunCreAppmtCnt', "&sabun="+Value, false);

					if (objCnt.DATA != null) {
						if(objCnt.DATA.cnt > 0){
							alert("<msg:txt mid='alertSabunCheck' mdef='해당 사번은 이미 사용중입니다.'/>");
							if( sheet1.GetCellValue(Row, "sStatus") == "I" ) sheet1.SetCellValue(Row, "sabun", "");
							else sheet1.ReturnData(Row);
						}
					}
				}
				
//			}else if(sheet1.ColSaveName(Col) == "chkYn") {
//				sheet1.SetCellValue(Row, "sStatus" , statusOldVal);
/*	메일유효성 체크 및 그룹웨어 중복체크 시작, 구축사별로 확인 후 변경 적용하여야 함 */ 
 
/*
			}else if(sheet1.ColSaveName(Col) == "mailAddr"){
				//주민번호로 email 가져오기
				getEmailFromResno(Row);   
				
				if(Value != "" &&  sheet1.GetCellValue(Row,"chkReEmp") !="Y"){
					var valSp =  Value.split("@");
					var vId = valSp[0];
					var vAddr = valSp[1];
					if(valSp.length  != 2){
						alert('메일주소를 다시 입력해주세요.');
						sheet1.SetCellValue(Row,"mailAddr","");
				    	   return ;
					}
					
					if(vAddr !="구축회사 메일 주소"){					
						alert('메일주소를 다시 입력해주세요.');		
						sheet1.SetCellValue(Row,"mailAddr","");
			    	   return ;
					}

			       var data = ajaxCall( "${ctx}/RecBasicInfoReg.do?cmd=getGroupWareIdCheck&urlStr="+urlStr,"",false);
			       			       
			       if (data.rtnData =="true"){
			    	 //  alert('사용할 수 있는 이메일 아이디 입니다.');
			    	   
			       }else{
			    	   alert('사용할 수 없는 이메일 아이디 입니다. \n 다시 입력해주세요.');
			    	   sheet1.SetCellValue(Row,"mailAddr","");
			    	   return ;	
			       }
				}
*/
/*	메일유효성 체크 및 그룹웨어 중복체크 끝, 구축사별로 확인 후 변경 적용하여야 함 */ 			

			}
		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}
		/*	
	var statusOldVal = "";
	// 체크 되기 직전 발생.
	function sheet1_OnBeforeCheck(Row, Col) {
		try{
	
            if(sheet1.ColSaveName(Col) == "chkYn") {
		        	
            	statusOldVal = sheet1.GetCellValue(Row, "sStatus" );
		        
		    }
	
		}catch(ex){
			alert("OnBeforeCheck Event Error : " + ex);
		}
	}

	*/

	//사번 중복 체크
	/*
	function sheet1_OnChange(Row, Col, Value, OldValue, RaiseFlag) {
		if(sheet1.ColSaveName(Col) == "sabun"){
			if(Value != ""){
				var objCnt = ajaxCall('${ctx}/GetDataMap.do?cmd=getSabunCreAppmtCnt', "&sabun="+Value, false);

				if (objCnt.DATA != null) {
					if(objCnt.DATA.cnt > 0){
						alert("<msg:txt mid='alertSabunCheck' mdef='해당 사번은 이미 사용중입니다.'/>");
						if( sheet1.GetCellValue(Row, "sStatus") == "I" ) sheet1.SetCellValue(Row, "sabun", "");
						else sheet1.ReturnData(Row);
					}
				}
			}
		}
	}
	*/

	//email 가져오기
	function getEmailFromResno(Row){
			
		var resno = sheet1.GetCellValue(Row,"resNo2");
		var objEmail = ajaxCall('${ctx}/GetDataMap.do?cmd=getEmailFromResNo', "&schResNo="+resno, false);
	
		if (objEmail.DATA != null) {
			var contAddress = objEmail.DATA.contAddress;
			sheet1.SetCellValue(Row, "chkReEmp" ,"Y") ;
			sheet1.SetCellValue(Row, "mailAddr" ,contAddress) ;
		}
	}
	
	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction1("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
				sheet1.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}


	function showDetailPop(shtRow) {
		var param = [];
		param["receiveNo"] = sheet1.GetCellValue(shtRow,"receiveNo");

		if(sheet1.GetCellValue(shtRow,"sStatus") == "I"
				|| sheet1.GetCellValue(shtRow,"apprYn") == "N"){ 
//				|| (sheet1.GetCellValue(shtRow,"prePostYn2") != "Y" && sheet1.GetCellValue(shtRow,"ordYn") != "Y")) {
			if(!isPopup()) {return;}

			gPRow = shtRow;
			pGubun = "recBasicInfoRegPopA";

	        var win = openPopup("/RecBasicInfoReg.do?cmd=viewRecBasicInfoRegPop&authPg=A", param, "1000","500");
		}
		// 채용기본사항승인 사용안함
		/*	
		else if(sheet1.GetCellValue(shtRow,"apprYn") == "A"){
			if(!isPopup()) {return;}

			gPRow = shtRow;
			pGubun = "recBasicInfoRegPopA";

	        var win = openPopup("/RecBasicInfoReg.do?cmd=viewRecBasicInfoRegPop&authPg=A", param, "1000","500");
			
		}
		*/
		else {
		
			if(!isPopup()) {return;}

			pGubun = "recBasicInfoRegPopR";
	        var win = openPopup("/RecBasicInfoReg.do?cmd=viewRecBasicInfoRegPop&authPg=R", param, "1000","500");
		}
	}

	//업로드 팝업
	function showUploadPop() {
		/*
		if($("#searchProcessNo").val() == "" ){
			alert("발령번호를 먼저 선택후 수행하세요.");
			return;
		}
		*/

		if(!isPopup()) {return;}

		var param = [];

		param["processNo"] = $("#searchProcessNo").val();
		param["processNm"] = $("#searchProcessTitle").val();

		pGubun = "recBasicInfoRegUploadPop";
        //var win = openPopup("/RecBasicInfoReg.do?cmd=viewRecBasicInfoRegUploadPop&authPg=A", param, "900","700");
        let layerModal = new window.top.document.LayerModal({
            id : 'recBasicInfoRegUploadLayer'
          , url : '/RecBasicInfoReg.do?cmd=viewRecBasicInfoRegUploadLayer&authPg=A'
          , parameters : ""
          , width : 900
          , height : 700
          , title : '채용(인사기본사항) 업로드'
          , trigger :[
              {
                    name : 'recBasicInfoRegUploadTrigger'
                  , callback : function(result){
                      getReturnValue(result);
                  }
              }
           ]
      });
      layerModal.show();
	}

	//합격자정보IF 팝업
	function showBasicInfoIf() {
		/*
		if($("#searchProcessNo").val() == "" ){
			alert("발령번호를 먼저 선택후 수행하세요.");
			return;
		}
		*/

		if(!isPopup()) {return;}

		pGubun = "recBasicInfoRegIfPop";
        var win = openPopup("/RecBasicInfoReg.do?cmd=viewRecBasicInfoRegIfPop&authPg=A", "", "900","700");
	}
	
	//재입사 발령 팝업
	function showRejoinOrd() {
		/*
		if($("#searchProcessNo").val() == "" ){
			alert("발령번호를 먼저 선택후 수행하세요.");
			return;
		}
		*/

		if(!isPopup()) {return;}

		pGubun = "recBasicInfoRegRejoinOrdPop";
        //var win = openPopup("/RecBasicInfoReg.do?cmd=recBasicInfoRegRejoinOrdPop&authPg=A", "", "1024","700");
		let layerModal = new window.top.document.LayerModal({
            id : 'recBasicInfoRegRejoinOrdLayer'
          , url : '/RecBasicInfoReg.do?cmd=viewRecBasicInfoRegRejoinOrdLayer&authPg=A'
          , parameters : ""
          , width : 1024
          , height : 700
          , title : '재입사 발령'
          , trigger :[
              {
                    name : 'recBasicInfoRegRejoinOrdTrigger'
                  , callback : function(result){
                	  getReturnValue(result);
                  }
              }
           ]
      });
      layerModal.show();
	}
	
	//채용합격자정보 발령 팝업
	function showRegIf() {

		if(!isPopup()) {return;}

		pGubun = "recBasicInfoRegIfPop";
       // var win = openPopup("/RecBasicInfoReg.do?cmd=viewRecBasicInfoRegIfPop&authPg=A", "", "1024","700");
	    let layerModal = new window.top.document.LayerModal({
              id : 'recBasicInfoRegIfLayer'
            , url : '/RecBasicInfoReg.do?cmd=viewRecBasicInfoRegIfLayer&authPg=A'
            , parameters : ""
            , width : 1024
            , height : 700
            , title : '합격자정보I/F'
            , trigger :[
                {
                      name : 'recBasicInfoRegIfTrigger'
                    , callback : function(result){
                        getReturnValue(result);
                    }
                }
             ]
        });
        layerModal.show();
	}
	
	//사간전입 발령 팝업
	function showEnterOrd() {
		/*
		if($("#searchProcessNo").val() == "" ){
			alert("발령번호를 먼저 선택후 수행하세요.");
			return;
		}
		*/

		if(!isPopup()) {return;}

		pGubun = "recBasicInfoRegEnterOrdPop";
        //var win = openPopup("/RecBasicInfoReg.do?cmd=recBasicInfoRegEnterOrdPop&authPg=A", "", "1024","700");
        let layerModal = new window.top.document.LayerModal({
            id : 'recBasicInfoRegEnterOrdLayer'
          , url : '/RecBasicInfoReg.do?cmd=viewRecBasicInfoRegEnterOrdLayer&authPg=A'
          , parameters : ""
          , width : 1024
          , height : 700
          , title : '사간전입 발령'
          , trigger :[
              {
                    name : 'recBasicInfoRegEnterOrdTrigger'
                  , callback : function(result){
                      getReturnValue(result);
                  }
              }
           ]
      });
      layerModal.show();
	}

	// 발령번호 선택 팝업
	function showProcessPop() {
		if(!isPopup()) {return;}

		pGubun = "searchAppmtConfirmPopup";

		//openPopup("/Popup.do?cmd=viewAppmtProcessNoMgrPopup&authPg=R", "", "1000","600");
        let layerModal = new window.top.document.LayerModal({
            id : 'appmtConfirmLayer'
          , url : '/Popup.do?cmd=viewAppmtProcessNoMgrLayer&authPg=R'
          , parameters : ""
          , width : 1000
          , height : 600
          , title : '발령번호 검색'
          , trigger :[
              {
                    name : 'appmtConfirmTrigger'
                  , callback : function(result){
                      getReturnValue(result);
                  }
              }
           ]
      });
      layerModal.show();
	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv;

        if(pGubun == "recBasicInfoRegPopA"){
        	for(var i=0 ; i<sheet1.LastCol()+1 ; i++){
				var nm = sheet1.ColSaveName(i);
				if(nm=="sNo")continue;
				if(rv[nm]) sheet1.SetCellValue(gPRow,nm,rv[nm]);
			}
        	sheet1.SetCellValue(gPRow, "resNo2", rv.resNo);
        	pGubun ="";
        } else if(pGubun == "recBasicInfoRegPopR" || pGubun == "recBasicInfoRegUploadPop") {
        	doAction1("Search");
        } else if(pGubun == "searchAppmtConfirmPopup") {
            rv = returnValue;
        	$("#searchProcessNo").val(rv["processNo"]);
        	$("#searchProcessTitle").val(rv["processTitle"]);
        	doAction1("Search");
        } else if(pGubun == "searchAppmtConfirmRowPopup"){
        	sheet1.SetCellValue(gPRow,"processNo",rv["processNo"]);
        } else if(pGubun == "recBasicInfoRegIfPop"){
        
            for (var i = 0; i < returnValue.length; i++) {
               var rv = returnValue[i];
	        	
	           var row = sheet1.DataInsert(0);
	
	   			sheet1.SetCellValue(row,"processNo",$("#searchProcessNo").val());
	   			//sheet1.SetCellValue(row, "seq", rv.recSeq);
	   			sheet1.SetCellValue(row, "applKey", rv.applKey);
	
	   			sheet1.SetCellValue(row, "name", rv.name);
	   			sheet1.SetCellValue(row, "nameCn", rv.nameCn);
	   			sheet1.SetCellValue(row, "nameUs", rv.nameUs);
	   			sheet1.SetCellValue(row, "sexType", rv.sexType);
	   			//sheet1.SetCellValue(row, "lunType", rv.lunType);
	   			sheet1.SetCellValue(row, "lunType", "1");
	   			sheet1.SetCellValue(row, "birYmd", rv.birYmd);
	   			//sheet1.SetCellValue(row, "wedYn", rv.wedYn);
	   			sheet1.SetCellValue(row, "foreignYn", rv.foreignYn);
	   			sheet1.SetCellValue(row, "nationalCd", rv.nationalCd);
	   			sheet1.SetCellValue(row, "mobileNo", rv.hpTel);
	   			sheet1.SetCellValue(row, "psnlEmail", rv.psnlEmail);
	   			sheet1.SetCellValue(row, "hobby", rv.hobby);
	   			sheet1.SetCellValue(row, "specialityNote", rv.specialityNote);
	   			//sheet1.SetCellValue(row, "stfType", rv.stfType);
	   			//sheet1.SetCellValue(row, "empType", rv.empType);
	   			sheet1.SetCellValue(row, "pathCd", rv.pathCd);
	   			sheet1.SetCellValue(row, "recomName", rv.recomName);   			
	
	   			sheet1.SetCellValue(row, "regYmd", "${curSysYyyyMMddHyphen}");
	   			
	   			//sheet1.SetCellValue(row, "gempYmd", rv.gempYmd);
	   			//sheet1.SetCellValue(row, "empYmd", rv.empYmd);
	   			//sheet1.SetCellValue(row, "resNo", rv.resNo);
	   			//sheet1.SetCellValue(row, "resNo2", rv.resNo);
	   			//sheet1.SetCellValue(row, "foreignNo", rv.foreignNo);
	   			
	   			//sheet1.SetCellValue(row, "wedYmd", rv.wedYmd);
	   			//sheet1.SetCellValue(row, "bloodCd", rv.bloodCd);
	   			//sheet1.SetCellValue(row, "relCd", rv.relCd);
	   			//sheet1.SetCellValue(row, "ht", rv.ht);
	   			//sheet1.SetCellValue(row, "wt", rv.wt);
	   			//sheet1.SetCellValue(row, "eyeL", rv.eyeL);
	   			//sheet1.SetCellValue(row, "eyeR", rv.eyeR);
	
	   			//sheet1.SetCellValue(row, "daltonismCd", rv.daltonismCd);
	
	   			//sheet1.SetCellValue(row, "base1Ymd", rv.base1Ymd);
	   			//sheet1.SetCellValue(row, "base2Ymd", rv.base2Ymd);
	   			//sheet1.SetCellValue(row, "base3Ymd", rv.base3Ymd);
	
	   			//sheet1.SetCellValue(row, "base1Yn", rv.base1Yn);
	   			//sheet1.SetCellValue(row, "base2Yn", rv.base2Yn);
	   			//sheet1.SetCellValue(row, "base3Yn", rv.base3Yn);
	
	   			//sheet1.SetCellValue(row, "base1Cd", rv.base1Cd);
	   			//sheet1.SetCellValue(row, "base2Cd", rv.base2Cd);
	   			//sheet1.SetCellValue(row, "base3Cd", rv.base3Cd);
	
	   			//sheet1.SetCellValue(row, "base1Nm", rv.base1Nm);
	   			//sheet1.SetCellValue(row, "base2Nm", rv.base2Nm);
	   			//sheet1.SetCellValue(row, "base3Nm", rv.base3Nm);
	
	   			//sheet1.SetCellValue(row, "careerYyCnt", rv.careerYyCnt);
	   			//sheet1.SetCellValue(row, "careerMmCnt", rv.careerMmCnt);
	
	   			//sheet1.SetCellValue(row, "ordDetailCd", rv.ordDetailCd);
	   			//sheet1.SetCellValue(row, "ordReasonCd", rv.ordReasonCd);
            }
      	} else if(pGubun == "recBasicInfoRegRejoinOrdPop"){

        	for (var i = 0; i < returnValue.length; i++) {
        		var rv = returnValue[i];
        		var row = sheet1.DataInsert(0);

        		//sheet1.SetCellValue(row,"processNo",$("#searchProcessNo").val(),0);
        		
        		//sheet1.SetCellValue(row, "sabun", rv.sabun,0);

       			sheet1.SetCellValue(row, "ordTypeCd", rv.ordTypeCd,0);
       			sheet1.SetCellValue(row, "ordDetailCd", rv.ordDetailCd,0);

       			sheet1.SetCellValue(row, "ordEnterCd", rv.ordEnterCd,0);
       			sheet1.SetCellValue(row, "ordEnterSabun", rv.ordEnterSabun,0);

       			sheet1.SetCellValue(row, "regYmd", rv.regYmd,0);
       			//sheet1.SetCellValue(row, "gempYmd", rv.gempYmd,0);
       			//sheet1.SetCellValue(row, "empYmd", rv.empYmd,0);

       			sheet1.SetCellValue(row, "name", rv.name,0);
       			sheet1.SetCellValue(row, "nameCn", rv.nameCn,0);
       			sheet1.SetCellValue(row, "nameUs", rv.nameUs,0);
       			sheet1.SetCellValue(row, "resNo", rv.resNo,0);
       			sheet1.SetCellValue(row, "resNo2", rv.resNo2,0);
       			sheet1.SetCellValue(row, "sexType", rv.sexType,0);
       			sheet1.SetCellValue(row, "lunType", rv.lunType,0);
       			sheet1.SetCellValue(row, "birYmd", rv.birthYmd,0);
       			
       			sheet1.SetCellValue(row, "ht", rv.ht);
       			sheet1.SetCellValue(row, "wt", rv.wt);
       			sheet1.SetCellValue(row, "eyeL", rv.eyeL);
       			sheet1.SetCellValue(row, "eyeR", rv.eyeR);

       			sheet1.SetCellValue(row, "wedYn", rv.wedYn,0);
       			sheet1.SetCellValue(row, "wedYmd", rv.wedYmd,0);
       			sheet1.SetCellValue(row, "bloodCd", rv.bloodCd,0);
       			sheet1.SetCellValue(row, "relCd", rv.relCd,0);
       			sheet1.SetCellValue(row, "foreignYn", rv.foreignYn,0);
       			sheet1.SetCellValue(row, "nationalCd", rv.nationalCd,0);
       			sheet1.SetCellValue(row, "mobileNo", rv.mobileNo,0);
       			sheet1.SetCellValue(row, "mailAddr", rv.mailAddr,0);
       			sheet1.SetCellValue(row, "hobby", rv.hobby,0);
       			sheet1.SetCellValue(row, "specialityNote", rv.specialityNote,0);

       			sheet1.SetCellValue(row, "stfType", rv.stfType,0);
       			sheet1.SetCellValue(row, "empType", rv.empType,0);
       			sheet1.SetCellValue(row, "pathCd", rv.pathCd,0);
       			sheet1.SetCellValue(row, "recomName", rv.recomName,0);
       			
       			sheet1.SetCellValue(row, "daltonismCd", rv.daltonismCd);

       			sheet1.SetCellValue(row, "base1Ymd", rv.base1Ymd);
       			sheet1.SetCellValue(row, "base2Ymd", rv.base2Ymd);
       			sheet1.SetCellValue(row, "base3Ymd", rv.base3Ymd);

       			sheet1.SetCellValue(row, "base1Yn", rv.base1Yn);
       			sheet1.SetCellValue(row, "base2Yn", rv.base2Yn);
       			sheet1.SetCellValue(row, "base3Yn", rv.base3Yn);

       			sheet1.SetCellValue(row, "base1Cd", rv.base1Cd);
       			sheet1.SetCellValue(row, "base2Cd", rv.base2Cd);
       			sheet1.SetCellValue(row, "base3Cd", rv.base3Cd);

       			sheet1.SetCellValue(row, "base1Nm", rv.base1Nm);
       			sheet1.SetCellValue(row, "base2Nm", rv.base2Nm);
       			sheet1.SetCellValue(row, "base3Nm", rv.base3Nm);

       			sheet1.SetCellValue(row, "careerYyCnt", rv.careerYyCnt);
       			sheet1.SetCellValue(row, "careerMmCnt", rv.careerMmCnt);
			}
      	} else if(pGubun == "recBasicInfoRegEnterOrdPop"){

        	for (var i = 0; i < returnValue.length; i++) {
        		var rv = returnValue[i];
        		var row = sheet1.DataInsert(0);

        		//sheet1.SetCellValue(row,"processNo",$("#searchProcessNo").val(),0);
        		
        		//sheet1.SetCellValue(row, "sabun", rv.sabun,0);

       			sheet1.SetCellValue(row, "ordTypeCd", rv.ordTypeCd,0);
       			sheet1.SetCellValue(row, "ordDetailCd", rv.ordDetailCd,0);

       			sheet1.SetCellValue(row, "ordEnterCd", rv.ordEnterCd,0);
       			sheet1.SetCellValue(row, "ordEnterSabun", rv.ordEnterSabun,0);

       			sheet1.SetCellValue(row, "regYmd", rv.regYmd,0);
       			sheet1.SetCellValue(row, "gempYmd", rv.gempYmd,0);
       			sheet1.SetCellValue(row, "empYmd", rv.empYmd,0);

       			sheet1.SetCellValue(row, "name", rv.name,0);
       			sheet1.SetCellValue(row, "nameCn", rv.nameCn,0);
       			sheet1.SetCellValue(row, "nameUs", rv.nameUs,0);
       			sheet1.SetCellValue(row, "resNo", rv.resNo,0);
       			sheet1.SetCellValue(row, "resNo2", rv.resNo2,0);
       			sheet1.SetCellValue(row, "sexType", rv.sexType,0);
       			sheet1.SetCellValue(row, "lunType", rv.lunType,0);
       			sheet1.SetCellValue(row, "birYmd", rv.birthYmd,0);
       			
       			sheet1.SetCellValue(row, "ht", rv.ht);
       			sheet1.SetCellValue(row, "wt", rv.wt);
       			sheet1.SetCellValue(row, "eyeL", rv.eyeL);
       			sheet1.SetCellValue(row, "eyeR", rv.eyeR);

       			sheet1.SetCellValue(row, "wedYn", rv.wedYn,0);
       			sheet1.SetCellValue(row, "wedYmd", rv.wedYmd,0);
       			sheet1.SetCellValue(row, "bloodCd", rv.bloodCd,0);
       			sheet1.SetCellValue(row, "relCd", rv.relCd,0);
       			sheet1.SetCellValue(row, "foreignYn", rv.foreignYn,0);
       			sheet1.SetCellValue(row, "nationalCd", rv.nationalCd,0);
       			sheet1.SetCellValue(row, "mobileNo", rv.mobileNo,0);
       			sheet1.SetCellValue(row, "mailAddr", rv.mailAddr,0);
       			sheet1.SetCellValue(row, "hobby", rv.hobby,0);
       			sheet1.SetCellValue(row, "specialityNote", rv.specialityNote,0);

       			sheet1.SetCellValue(row, "stfType", rv.stfType,0);
       			sheet1.SetCellValue(row, "empType", rv.empType,0);
       			sheet1.SetCellValue(row, "pathCd", rv.pathCd,0);
       			sheet1.SetCellValue(row, "recomName", rv.recomName,0);
       			
       			sheet1.SetCellValue(row, "daltonismCd", rv.daltonismCd);

       			sheet1.SetCellValue(row, "base1Ymd", rv.base1Ymd);
       			sheet1.SetCellValue(row, "base2Ymd", rv.base2Ymd);
       			sheet1.SetCellValue(row, "base3Ymd", rv.base3Ymd);

       			sheet1.SetCellValue(row, "base1Yn", rv.base1Yn);
       			sheet1.SetCellValue(row, "base2Yn", rv.base2Yn);
       			sheet1.SetCellValue(row, "base3Yn", rv.base3Yn);

       			sheet1.SetCellValue(row, "base1Cd", rv.base1Cd);
       			sheet1.SetCellValue(row, "base2Cd", rv.base2Cd);
       			sheet1.SetCellValue(row, "base3Cd", rv.base3Cd);

       			sheet1.SetCellValue(row, "base1Nm", rv.base1Nm);
       			sheet1.SetCellValue(row, "base2Nm", rv.base2Nm);
       			sheet1.SetCellValue(row, "base3Nm", rv.base3Nm);

       			sheet1.SetCellValue(row, "careerYyCnt", rv.careerYyCnt);
       			sheet1.SetCellValue(row, "careerMmCnt", rv.careerMmCnt);
			}
      	}
	}

	// 엑셀업로드 후 저장 처리
	function sheet1_OnLoadExcel(result) {
		try {
			if(result) {
				for(var i = sheet1.HeaderRows(); i <= sheet1.LastRow(); i++) {
					sheet1.SetCellValue(i, "regYmd", "${curSysYyyyMMddHyphen}");
				}
			} else {
				alert("엑셀파일 로드 중 오류가 발생하였습니다.");
			}

		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
<form id=sendForm name="sendForm" method="post">
	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<th>입력일</th>
			<td>
				<input id="regYmdFrom" name="regYmdFrom" type="text" size="10" class="date2 required" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),-30)%>"/> ~
				<input id="regYmdTo" name="regYmdTo" type="text" size="10" class="date2 required" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),+30)%>"/>
			</td>
			<th>발령번호</th>
			<td>
				<input type="text" id="searchProcessNo" name="searchProcessNo" class="text readonly" style="width:50px;"  readonly />
				<a href="javascript:showProcessPop();" class="button6"><img src="${ctx}/common/images/common/btn_search2.gif"/></a>
				<input type="text" id="searchProcessTitle" name="searchProcessTitle" class="text w150 readonly" readonly />
				<a onclick="javascript:doAction1('ProcessClear');" class="button7"><img src="/common/images/icon/icon_undo.png"></a>
			</td>
			<th>발령연계</th>
			<td>
				<select id="searchOrdYn" name ="searchOrdYn">
					<option value="">전체</option>
					<option value="Y">처리</option>
					<option value="N">미처리</option>
				</select>
			</td>
		</tr>
		<tr >
			<th>성명</th>
			<td>
				<input id="searchName" name="searchName" type="text" class="text"/>
			</td>
			<th>사번확정</th>
			<td>
				<select id="searchSabunYn" name ="searchSabunYn">
					<option value="">전체</option>
					<option value="Y">확정</option>
					<option value="N">미확정</option>
				</select>
			</td>
			<th class="hide">채용공고</th>
			<td class="hide">
				<select id="searchSeqNm" name="searchSeqNm" onchange="javascript:doAction1('Search');"></select>
			</td>
			<td colspan="2">
				<a href="javascript:doAction1('Search');" class="btn dark">조회</a>
			</td>
		</tr>
		</table>
		</div>
	</div>
</form>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt">채용기본사항등록
			 <font color="red">※ 처리순서 : 입력  → 내용기재 후 저장<!-- (승인요청) → 승인 --> → 사번생성/확정  → 발령연계처리</font>
			</li>
			<li class="btn">
				<a href="javascript:showRegIf();" class="basic orange authA">채용합격자 발령</a>
				<a href="javascript:showRejoinOrd();" class="basic blue authA">재입사 발령</a>	
				<a href="javascript:showEnterOrd();" class="basic pink authA">사간전입 발령</a>
				<a href="javascript:doAction1('SabunCre');" class="button authA">사번생성</a>
				<a href="javascript:doAction1('MoveEmpPicture');" class="button authA" id="btn_moveEmpPictrue">채용공고 사진이미지 복사</a>
				<a href="javascript:doAction1('Insert');" class="basic authA">입력</a>
				<a href="javascript:doAction1('Save');" class="basic authA">저장</a>
				<a href="javascript:doAction1('DownTemplate');" class="basic authA">양식다운로드</a>
<%--				<a href="javascript:showUploadPop();" class="basic authA">업로드</a>--%>
				<a href="javascript:doAction1('LoadExcel');" 	class="basic authR">업로드</a>
				<a href="javascript:doAction1('Down2Excel');" class="basic authR">다운로드</a>
			</li>
		</ul>
		</div>
	</div>

	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "kr"); </script>
</div>
</body>
</html>