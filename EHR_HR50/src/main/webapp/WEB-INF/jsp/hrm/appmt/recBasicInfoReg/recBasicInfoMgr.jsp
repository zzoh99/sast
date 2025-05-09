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
			{Header:"삭제",				Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"상태",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

   			{Header:"세부\n내역",			Type:"Image",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"ibsImage1",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"일련\n번호",			Type:"Text",		Hidden:1,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"receiveNo",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"선택",				Type:"CheckBox",	Hidden:0,	Width:55,	Align:"Center",	ColMerge:0,	SaveName:"chkYn",		KeyField:0,	Format:"",		CalcLogic:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1 , TrueValue:"Y", FalseValue:"N"},
			{Header:"승인/반려\n여부",		Type:"Combo",		Hidden:0,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"apprYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:10 },

			{Header:"입력일",				Type:"Date",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"regYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"발령",				Type:"Combo",		Hidden:0,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"ordTypeCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"발령상세",			Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"ordDetailCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"발령세부사유",			Type:"Combo",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ordReasonCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:10 },
			{Header:"사번",				Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"성명",				Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"주민등록번호",			Type:"Text",		Hidden:1,	Width:110,	Align:"Center",	ColMerge:0,	SaveName:"resNo",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:200 },
			{Header:"주민등록번호",			Type:"Text",		Hidden:0,	Width:110,	Align:"Center",	ColMerge:0,	SaveName:"resNo2",		KeyField:0,	Format:"IdNo",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"성별",				Type:"Combo",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sexType",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"그룹입사일",			Type:"Date",		Hidden:Number("${gempYmdHdn}"),	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"gempYmd",		KeyField:1,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"입사일",				Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"empYmd",		KeyField:1,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		
			{Header:"수습종료일",			Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"traYmd",	    KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"성명(한자)",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"nameCn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"성명(영문)",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"nameUs",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"음양구분",			Type:"Combo",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"lunType",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"생년월일",			Type:"Date",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"birYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"외국인\n여부",		Type:"Combo",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"foreignYn",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"국적",				Type:"Combo",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"nationalCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"결혼여부",			Type:"Combo",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"wedYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"결혼일자",			Type:"Date",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"wedYmd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"시력(좌)",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"eyeL",		KeyField:0,	Format:"NullFloat",		PointCount:1,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"시력(우)",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"eyeR",		KeyField:0,	Format:"NullFloat",		PointCount:1,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"색신",				Type:"Combo",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"daltonismCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"신장",				Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ht",			KeyField:0,	Format:"NullFloat",		PointCount:2,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"체중",				Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"wt",			KeyField:0,	Format:"NullFloat",		PointCount:2,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"혈액형",				Type:"Combo",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"bloodCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"종교",				Type:"Combo",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"relCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"이메일",				Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"mailAddr",    KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"휴대폰번호",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"mobileNo",    KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"취미",				Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"hobby",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000 },
			{Header:"특기",				Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"specialityNote",KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000 },
			{Header:"채용구분",			Type:"Combo",		Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"stfType",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"채용경로",			Type:"Combo",		Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"empType",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"입사경로",			Type:"Combo",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"pathCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"입사추천자",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"recomName",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			
			{Header:"인정직위",			Type:"Combo",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"base1Cd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"인정직위\n(년차)",		Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"careerYyCnt",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"인정직위\n(개월)",		Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"careerMmCnt",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"발령번호",			Type:"Popup",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"processNo",   KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000 },

		

			{Header:"사번생성룰\n구분",		Type:"Combo",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabunType",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"사번\n생성/확정",		Type:"CheckBox",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabunYn",	    KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"사번\n확정",			Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabunYn2",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1},
			{Header:"발령연계\n처리",		Type:"CheckBox",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"prePostYn",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"발령연계\n처리",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"prePostYn2",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1},
			
			
			{Header:"발령확정\n여부",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"ordYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"발령확정\n여부",		Type:"Image",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"ibsImage4",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },

			{Header:"발령일",				Type:"Date",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ordYmd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"발령seq",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"applySeq",    KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"조회여부",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"visualYn",    KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"채용순번",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"seq",    KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"지원자번호",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"applKey",    KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"채용공고명",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"seqNm",    KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000 },

			{Header:"전출회사",			Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"ordEnterCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"전출사번",			Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"ordEnterSabun",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			
			
			{Header:"applTime",			Type:"Date",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"applTime",		KeyField:0,	Format:"YmdHms",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:130 },
			{Header:"apprSabun",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"apprSabun",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:130 },
			{Header:"apprTime",			Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"apprTime",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:130 },
			{Header:"승인/반려사유",		Type:"Text",		Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"reason",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:200 },
			
			{Header:"외국인등록번호",		Type:"Text",		Hidden:1,	Width:110,	Align:"Center",	ColMerge:0,	SaveName:"foreignNo",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:200 },
			
			
			{Header:"<sht:txt mid='base1Ymd' mdef='기준일1'/>",		Type:"Date",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base1Ymd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='base2Ymd' mdef='기준일2'/>",		Type:"Date",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base2Ymd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='base3Ymd' mdef='기준일3'/>",		Type:"Date",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base3Ymd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='base1Yn' mdef='기준여부1'/>",		Type:"CheckBox",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base1Yn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100,	FalseValue:"N", TrueValue:"Y" },
			{Header:"<sht:txt mid='base2Yn' mdef='기준여부2'/>",		Type:"CheckBox",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base2Yn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100,	FalseValue:"N", TrueValue:"Y" },
			{Header:"<sht:txt mid='base3Yn' mdef='기준여부3'/>",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base3Yn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='base2Cd' mdef='기준코드2'/>",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base2Cd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='base3Cd' mdef='기준코드3'/>",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base3Cd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='base1Nm' mdef='기준설명1'/>",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base1Nm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='base2Nm' mdef='기준설명2'/>",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base2Nm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='base3Nm' mdef='기준설명3'/>",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base3Nm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }

		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(true);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetImageList(0,"/common/images/icon/icon_x.png");
 		sheet1.SetImageList(1,"/common/images/icon/icon_x.png");
		sheet1.SetImageList(1,"/common/images/icon/icon_o.png");
		sheet1.SetImageList(3,"/common/images/icon/icon_info.png");
		sheet1.SetDataLinkMouse("ibsImage1", 1);

		var ordTypeCd = stfConvCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdTypeList&inOrdType=10,",false).codeList, "");//입사 발령형태
		var ordDetailCd = stfConvCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdDetailCdList&inOrdType=10,",false).codeList, "");//입사 발령상세
		var sabunType = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10160"), " ");	//사번생성룰
		var ordReasonCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&note1=A", "H40110"), " ");

		sheet1.SetColProperty("ordTypeCd",		{ComboText:ordTypeCd[0], ComboCode:ordTypeCd[1]} );	
		sheet1.SetColProperty("ordDetailCd",	{ComboText:ordDetailCd[0], ComboCode:ordDetailCd[1]} );
		sheet1.SetColProperty("ordReasonCd",	{ComboText:"|"+ordReasonCd[0], ComboCode:"|"+ordReasonCd[1]} );
		sheet1.SetColProperty("sabunType", 		{ComboText:sabunType[0], ComboCode:sabunType[1]} );

		var lunType = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H00030"), " ");	//음양구분
		var sexType = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H00010"), " ");	//성별
		var bloodCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20460"), " ");	//혈액형
		var nationalCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20290"), " ");	//국적
		var relCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20350"), "");	//종교
		var stfType = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","F10001"), " ");	//채용구분
		var empType = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","F10003"), " ");	//채용경로
		var pathCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","F65010"), " ");	//입사경로
		var daltonismCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20337"), " ");	//색맹여부
		var base1Cd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20030"), " ");	//경력인정직위코드(H20030)

		sheet1.SetColProperty("lunType", 		{ComboText:"|"+lunType[0], ComboCode:"|"+lunType[1]} );
		sheet1.SetColProperty("sexType", 		{ComboText:"|"+sexType[0], ComboCode:"|"+sexType[1]} );
		sheet1.SetColProperty("bloodCd", 		{ComboText:"|"+bloodCd[0], ComboCode:"|"+bloodCd[1]} );
		sheet1.SetColProperty("wedYn", 			{ComboText:"|기혼|미혼|이혼", ComboCode:"|Y|N|3"} );
		sheet1.SetColProperty("foreignYn", 		{ComboText:"N|Y", ComboCode:"N|Y"} );
		sheet1.SetColProperty("nationalCd", 	{ComboText:nationalCd[0], ComboCode:nationalCd[1]} );
		sheet1.SetColProperty("relCd", 			{ComboText:"|"+relCd[0], ComboCode:"|"+relCd[1]} );
		sheet1.SetColProperty("stfType", 		{ComboText:"|"+stfType[0], ComboCode:"|"+stfType[1]} );
		sheet1.SetColProperty("empType", 		{ComboText:"|"+empType[0], ComboCode:"|"+empType[1]} );
		sheet1.SetColProperty("pathCd", 		{ComboText:"|"+pathCd[0], ComboCode:"|"+pathCd[1]} );
		sheet1.SetColProperty("daltonismCd", 	{ComboText:"|"+daltonismCd[0], ComboCode:"|"+daltonismCd[1]} );
		sheet1.SetColProperty("base1Cd",		{ComboText:"|"+base1Cd[0], ComboCode:"|"+base1Cd[1]} );
		sheet1.SetColProperty("apprYn", 		{ComboText:"승인요청|승인|반려", ComboCode:"A|Y|N"} );
		

		var seqNm = stfConvCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getSeqNmList",false).codeList, "채용공고 제외 조회");//입사 발령
		$("#searchSeqNm").html(seqNm[2]);
		
		$(window).smartresize(sheetResize); sheetInit();
		
		 $("#searchApprYn").val("A");
		doAction1("Search");
	});

	$(function() {

        $("#searchName").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search"); $(this).focus();
			}
		});
        
        $("#searchApprYn").change(function(){
				doAction1("Search"); 
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
			IBS_SaveName(document.sendForm,sheet1);
			var paramStr = setAppmtParamSet(POST_ITEMS,sheet1, null ,$("#sendForm"));
			sheet1.DoSave( "${ctx}/RecBasicInfoReg.do?cmd=saveRecBasicInfoRegNew", $("#sendForm").serialize()+paramStr+"&ordGubun=");

			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExtendParam:"&secType=RSNO&secParam=resNo2" };
			var d = new Date();
			var fName = "excel_" + d.getTime() + ".xlsx";
			sheet1.Down2Excel($.extend(param, { FileName:fName, SheetDesign:1, Merge:1 }));

			break;
		 case "SelYes": 
				for(var i = 1; i < sheet1.RowCount()+1; i++) {

					if(sheet1.GetCellValue(i, "chkYn") == "Y") {
						sheet1.SetCellValue(i, "apprYn" ,"Y");
					}
				}
				break;
		 case "SelNo": 
				for(var i = 1; i < sheet1.RowCount()+1; i++) {

					if(sheet1.GetCellValue(i, "chkYn") == "Y") {
						sheet1.SetCellValue(i, "apprYn" ,"N");
					}
				}
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

			if(sheet1.RowCount() > 0) {
				for(var i = 1; i < sheet1.RowCount()+1; i++) {
					
					sheet1.SetRowEditable(i,false);

					if(sheet1.GetCellValue(i, "prePostYn") == "Y" || sheet1.GetCellValue(i, "ordYn") == "Y" || sheet1.GetCellValue(i, "sabunYn") == "Y") {

						sheet1.SetRowEditable(i,false);
					
					}else{
						
						sheet1.SetCellEditable(i,"chkYn", true);
						sheet1.SetCellEditable(i,"sDelete", true);
						sheet1.SetCellEditable(i,"reason", true);
						sheet1.SetCellEditable(i,"apprYn", true);
						
						
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

		    if( sheet1.ColSaveName(Col) == "ibsImage1"  && Row >= sheet1.HeaderRows()) {
		    	if(sheet1.GetCellValue(Row,"sStatus") == "I" || sheet1.GetCellValue(Row,"sStatus") == "U" ) {
		    		alert("저장후 확인할 수 있습니다.");
		    	} else {
			    	showDetailPop(Row);
		    	}
		    }			
			
			
		    if(sheet1.ColSaveName(Col) == "sDelete") {
		        if(sheet1.GetCellValue(Row,"sabunYn") == "Y" || sheet1.GetCellValue(Row, "prePostYn") == "Y" || sheet1.GetCellValue(Row, "ordYn") == "Y") {
		            alert("[사번확정, 발령연계처리,발령확정]인건은 삭제할 수 없습니다.");


		        }
		    }

		} catch (ex) {
			alert("OnClick Event Error : " + ex);
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
				|| (sheet1.GetCellValue(shtRow,"prePostYn2") != "Y" && sheet1.GetCellValue(shtRow,"ordYn") != "Y")) {
			if(!isPopup()) {return;}

			gPRow = shtRow;
			pGubun = "recBasicInfoRegPopR";

	        var win = openPopup("/RecBasicInfoReg.do?cmd=viewRecBasicInfoRegPop&authPg=R", param, "1000","500");
		} else {
			if(!isPopup()) {return;}

			pGubun = "recBasicInfoRegPopR";
	        var win = openPopup("/RecBasicInfoReg.do?cmd=viewRecBasicInfoRegPop&authPg=R", param, "1000","500");
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
			<td colspan="2">
				<input id="regYmdFrom" name="regYmdFrom" type="text" size="10" class="date2 required" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),-30)%>"/> ~
				<input id="regYmdTo" name="regYmdTo" type="text" size="10" class="date2 required" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),+30)%>"/>
			</td>
			<th>성명</th>
			<td>
				<input id="searchName" name="searchName" type="text" class="text"/>
			</td>
			<th>승인/반려여부</th>
			<td>
				<select id="searchApprYn" name ="searchApprYn">
					<option value="">전체</option>
					<option value="A">승인요청</option>
					<option value="Y">승인</option>
					<option value="N">반려</option>
				</select>
			</td>
		 
			</td>
				<td>
				<a href="javascript:doAction1('Search');" class="button">조회</a>
			</td>
		</tr>
		</tr>
		</table>
		</div>
	</div>
</form>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt">채용기본사항승인</li>
			<li class="btn">

				<a href="javascript:doAction1('SelYes');" class="basic authA">선택승인</a>
				 <a href="javascript:doAction1('SelNo');" class="basic authA">선택반려</a>
				<a href="javascript:doAction1('Save');" class="basic authA">저장</a>
				<a href="javascript:doAction1('Down2Excel');" class="basic authR">다운로드</a>
			</li>
		</ul>
		</div>
	</div>

	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "kr"); </script>
</div>
</body>
</html>