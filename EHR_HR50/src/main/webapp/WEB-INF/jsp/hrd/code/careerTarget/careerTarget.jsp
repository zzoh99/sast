<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
    <%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
    <%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
    <%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
    <script type="text/javascript">
        var gPRow = "";
        var pGubun = "";

        $(function() {
            var initdata = {};
            initdata.Cfg = {FrozenCol:6,SearchMode:smLazyLoad,Page:22,MergeSheet:msAll};
            initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
            initdata.Cols = [
                {Header:"<sht:txt mid='sNo'         mdef='No'          />",				Type:"${sNoTy}"  , Hidden:Number("${sNoHdn}") , Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
                {Header:"<sht:txt mid='sDelete V5'  mdef='삭제'        />",				Type:"${sDelTy}" , Hidden:Number("${sDelHdn}"), Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0 },
                {Header:"<sht:txt mid='sStatus'     mdef='상태'        />",				Type:"${sSttTy}" , Hidden:Number("${sSttHdn}"), Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
                {Header:"<sht:txt mid='careerTargetType'       	mdef='인재유형'    />",	Type:"Combo"     , Hidden:0, Width:100,  Align:"Left"  , ColMerge:1, SaveName:"careerTargetType"  , KeyField:1, CalcLogic:"", Format:""   ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:1 },
                {Header:"<sht:txt mid='careerTargetCd'       	mdef='경력목표코드'/>",		Type:"Text"      , Hidden:1, Width:0  ,  Align:"Left"  , ColMerge:0, SaveName:"careerTargetCd"    , KeyField:1, CalcLogic:"", Format:""   ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:22 },
                {Header:"<sht:txt mid='careerTargetNm'       	mdef='경력목표'    />",	Type:"Text"      , Hidden:0, Width:160,  Align:"Left"  , ColMerge:0, SaveName:"careerTargetNm"    , KeyField:1, CalcLogic:"", Format:""   ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100 },
                {Header:"<sht:txt mid='careerTargetDetail'      mdef='세부내역'    />",	Type:"Image"     , Hidden:0, Width:30 ,  Align:"Center", ColMerge:0, SaveName:"careerTargetDetail", KeyField:0, CalcLogic:"", Format:""   ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:22 },
                {Header:"<sht:txt mid='careerPathDetail'       	mdef='경력경로'    />",	Type:"Image"     , Hidden:0, Width:30 ,  Align:"Center", ColMerge:0, SaveName:"careerPathDetail"  , KeyField:0, CalcLogic:"", Format:""   ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:22 },
                {Header:"<sht:txt mid='careerMapDetail'       	mdef='Career\nMap'    />",	Type:"Image"     , Hidden:0, Width:30 ,  Align:"Center", ColMerge:0, SaveName:"careerMapDetail"  , KeyField:0, CalcLogic:"", Format:""   ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:22 },
                {Header:"<sht:txt mid='startYmd'                mdef='시작일'   />",		Type:"Date"      , Hidden:0, Width:80 ,  Align:"Center", ColMerge:0, SaveName:"startYmd",   EndDateCol: "endYmd",       KeyField:0, CalcLogic:"", Format:"Ymd"    ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:10 },
                {Header:"<sht:txt mid='endYmd'                  mdef='종료일'   />",		Type:"Date"      , Hidden:0, Width:80 ,  Align:"Center", ColMerge:0, SaveName:"endYmd"  ,   StartDateCol: "startYmd",   KeyField:0, CalcLogic:"", Format:"Ymd"    ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:10 },
                {Header:"<sht:txt mid='useYn'       			mdef='사용여부'    />",	Type:"Combo"     , Hidden:0, Width:55 ,  Align:"Center", ColMerge:0, SaveName:"useYn"             , KeyField:0, CalcLogic:"", Format:""   ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:1 },
                {Header:"<sht:txt mid='careerTargetDesc'       	mdef='목표개요'    />",	Type:"Text"      , Hidden:0, Width:295,  Align:"Left"  , ColMerge:0, SaveName:"careerTargetDesc"  , KeyField:0, CalcLogic:"", Format:""   ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:4000 },
                {Header:"<sht:txt mid='regYmd'       			mdef='등록일'      />",	Type:"Text"      , Hidden:1, Width:0  ,  Align:"Left"  , ColMerge:0, SaveName:"regYmd"            , KeyField:0, CalcLogic:"", Format:"Ymd",  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:10 },
                {Header:"<sht:txt mid='g1StepDesc'       		mdef='G1단계설명'  />",	Type:"Text"      , Hidden:1, Width:0  ,  Align:"Left"  , ColMerge:0, SaveName:"g1StepDesc"        , KeyField:0, CalcLogic:"", Format:""   ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:4000 },
                {Header:"<sht:txt mid='g1NeedDesc'       		mdef='G1필요설명'  />",	Type:"Text"      , Hidden:1, Width:0  ,  Align:"Left"  , ColMerge:0, SaveName:"g1NeedDesc"        , KeyField:0, CalcLogic:"", Format:""   ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:4000 },
                {Header:"<sht:txt mid='g2StepDesc'       		mdef='G2단계설명'  />",	Type:"Text"      , Hidden:1, Width:0  ,  Align:"Left"  , ColMerge:0, SaveName:"g2StepDesc"        , KeyField:0, CalcLogic:"", Format:""   ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:4000 },
                {Header:"<sht:txt mid='g2NeedDesc'       		mdef='G2필요설명'  />",	Type:"Text"      , Hidden:1, Width:0  ,  Align:"Left"  , ColMerge:0, SaveName:"g2NeedDesc"        , KeyField:0, CalcLogic:"", Format:""   ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:4000 },
                {Header:"<sht:txt mid='g3StepDesc'       		mdef='G3단계설명'  />",	Type:"Text"      , Hidden:1, Width:0  ,  Align:"Left"  , ColMerge:0, SaveName:"g3StepDesc"        , KeyField:0, CalcLogic:"", Format:""   ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:4000 },
                {Header:"<sht:txt mid='g3NeedDesc'       		mdef='G3필요설명'  />",	Type:"Text"      , Hidden:1, Width:0  ,  Align:"Left"  , ColMerge:0, SaveName:"g3NeedDesc"        , KeyField:0, CalcLogic:"", Format:""   ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:4000 },
                {Header:"<sht:txt mid='limitCnt'       			mdef='적정인원'    />",	Type:"Text"      , Hidden:1, Width:0  ,  Align:"Left"  , ColMerge:0, SaveName:"limitCnt"          , KeyField:0, CalcLogic:"", Format:""   ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:22 },
                {Header:"<sht:txt mid='careerMap'       		mdef='careerMap'   />",	Type:"Text"      , Hidden:1, Width:0  ,  Align:"Left"  , ColMerge:0, SaveName:"careerMap"         , KeyField:0, CalcLogic:"", Format:""   ,  PointCount:0, UpdateEdit:1, InsertEdit:1 }


            ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");


            sheet1.SetColProperty("useYn",          {ComboText:"Y|N", ComboCode:"Y|N"} );

            $("#searchCareerTargetType, #searchCareerTargetNm").bind("keyup",function(event){
                if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
            });

            sheet1.SetDataLinkMouse("careerTargetDetail", 1);
            sheet1.SetDataLinkMouse("careerPathDetail"  , 1);
            sheet1.SetDataLinkMouse("careerMapDetail"  , 1);

            $(window).smartresize(sheetResize); sheetInit();

            fnSetCode()

            doAction1("Search");
        });



        function fnSetCode() {
            /*
                    var gntCd        = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getCpnGntCdList2&gntGubunCd=Not40"), "<tit:txt mid='103895' mdef='전체'/>");
		sheet1.SetColProperty("gntCd", 			{ComboText:gntCd[0], ComboCode:gntCd[1]} );
		$("#gntCd").html(gntCd[2]);

		var workType     = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10050"), "");
		var jikgubCd     = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20010"), "<tit:txt mid='103895' mdef='전체'/>");
		var statusCd     = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10010"), "<tit:txt mid='103895' mdef='전체'/>");

		sheet1.SetColProperty("applStatusCd", 	{ComboText:applStatusCd[0], ComboCode:applStatusCd[1]} );
		sheet1.SetColProperty("gntCd", 			{ComboText:gntCd[0], ComboCode:gntCd[1]} );
		sheet1.SetColProperty("updateYn", 		{ComboText:"||수정", ComboCode:"|N|Y"} );

		$("#applStatusCd").html(applStatusCd[2]);
		$("#jikgubCd").html(jikgubCd[2]);
		$("#gntCd").html(gntCd[2]);
		$("#statusCd").html(statusCd[2]);

		var nationalCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20290"), "");	//소재국가
		var bankCdList 		= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H30001"), "");	//은행구분

		sheet1.SetColProperty("nationalCd",	{ComboText:"|"+nationalCdList[0], ComboCode:"|"+nationalCdList[1]} );	//소재국가
		sheet1.SetColProperty("bankCd",		{ComboText:"|"+bankCdList[0], ComboCode:"|"+bankCdList[1]} );	//은행구분

*/

            var careerTargetTypeCd     = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","D00001"), "<tit:txt mid='103895' mdef='전체'/>");
            sheet1.SetColProperty("careerTargetType", 	{ComboText:careerTargetTypeCd[0], ComboCode:careerTargetTypeCd[1]} );
            $("#searchCareerTargetType").html(careerTargetTypeCd[2]);
        }




        /**
         * Sheet 각종 처리
         */
        function doAction1(sAction) {
            switch (sAction) {
                case "Search": //조회

                    sheet1.DoSearch("${ctx}/CareerTarget.do?cmd=getCareerTargetList", $("#srchFrm").serialize());
                    break;
                case "Save": //저장

                    IBS_SaveName(document.srchFrm, sheet1);
                    sheet1.DoSave("${ctx}/CareerTarget.do?cmd=saveCareerTarget", $("#srchFrm").serialize());
                    break;

                case "Insert": //입력

                    var Row = sheet1.DataInsert(0);

                    sheet1.SetCellValue(Row, "careerTargetCd",getColMaxValue(sheet1, "careerTargetCd"));

                    careerTargetDetailPopup(Row);
                    //sheet1.SetCellValue(Row, "nationalCd", "001");
                    //eduInstiMgrPopup(Row);
                    break;

                case "Copy": //행복사

                    var Row = sheet1.DataCopy();
                    sheet1.SetCellValue(Row, "careerTargetCd",getColMaxValue(sheet1, "careerTargetCd"));
                    eduInstiMgrPopup(Row);

                    break;

                case "Clear": //Clear

                    sheet1.RemoveAll();
                    break;

                case "Down2Excel": //엑셀내려받기

                    sheet1.Down2Excel({ DownCols : makeHiddenSkipCol(sheet1), SheetDesign : 1, Merge : 1 });
                    break;

                case "LoadExcel": //엑셀업로드

                    var params = { Mode : "HeaderMatch", WorkSheetNo : 1 };
                    sheet1.LoadExcel(params);
                    break;

            }
        }

        function sheet1_OnSearchEnd(Code, ErrMsg, StCode, StMsg) {
            try {
                if (ErrMsg != "") {
                    alert(ErrMsg);
                }
                //setSheetSize(this);
            } catch (ex) {
                alert("OnSearchEnd Event Error : " + ex);
            }
        }

        function sheet1_OnResize(lWidth, lHeight) {
            try {
                //높이 또는 너비가 변경된 경우 각 컬럼의 너비를 새로 맞춘다.
                //setSheetSize(this);
            } catch (ex) {
                alert("OnResize Event Error : " + ex);
            }
        }

        function sheet1_OnSaveEnd(Code, ErrMsg, StCode, StMsg) {
            try {
                if (ErrMsg != "") {
                    alert(ErrMsg);
                }

                if (Code > 0) {
                    doAction1("Search");
                }

            } catch (ex) {
                alert("OnSaveEnd Event Error : " + ex);
            }
        }

        function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
            try {
                selectSheet = sheet1;
            } catch (ex) {
                alert("OnSelectCell Event Error : " + ex);
            }
        }

        function sheet1_OnClick(Row, Col, Value) {
            try {

                if (Row > 0 && sheet1.ColSaveName(Col) == "careerTargetDetail") {
                    careerTargetDetailPopup(Row);
                }

                if (Row > 0 && sheet1.ColSaveName(Col) == "careerPathDetail") {
                    careerPathDetailPopup(Row);
                }

                if (Row > 0 && sheet1.ColSaveName(Col) == "careerMapDetail") {
                    careerMapDetailPopup(Row);
                }

            } catch (ex) {
                alert("OnClick Event Error : " + ex);
            }
        }

        function sheet1_OnPopupClick(Row, Col) {
            try {
                if (sheet1.ColSaveName(Col) == "zip") {
                    if (!isPopup()) {
                        return;
                    }

                    gPRow = Row;
                    pGubun = "ZipCodePopup";
                    openPopup("/ZipCodePopup.do?cmd=viewZipCodePopup&authPg=${authPg}", "", "740", "620");

                }
            } catch (ex) {
                alert("OnPopupClick Event Error : " + ex);
            }
        }

        function sheet1_OnValidation(Row, Col, Value) {
            try {
            } catch (ex) {
                alert("OnValidation Event Error : " + ex);
            }
        }

        /**
         * 상세내역 window open event
         */
        function careerTargetDetailPopup(Row) {
            if (!isPopup()) {
                return;
            }

            let w = 860;
            let h = 400;
            let url = "${ctx}/CareerTarget.do?cmd=viewCareerTargetDetailLayer&authPg=${authPg}";

            const p = {
                careerTargetType : sheet1.GetCellValue(Row, "careerTargetType"),
                useYn : sheet1.GetCellValue(Row, "useYn"),
                careerTargetNm : sheet1.GetCellValue(Row, "careerTargetNm"),
                careerTargetDesc : sheet1.GetCellValue(Row, "careerTargetDesc"),
                g1StepDesc : sheet1.GetCellValue(Row, "g1StepDesc"),
                g1NeedDesc : sheet1.GetCellValue(Row, "g1NeedDesc"),
                g2StepDesc : sheet1.GetCellValue(Row, "g2StepDesc"),
                g2NeedDesc : sheet1.GetCellValue(Row, "g2NeedDesc"),
                g3StepDesc : sheet1.GetCellValue(Row, "g3StepDesc"),
                g3NeedDesc : sheet1.GetCellValue(Row, "g3NeedDesc"),
                limitCnt : sheet1.GetCellValue(Row, "limitCnt")
            };

            gPRow = Row;
            pGubun = "careerTargetDetailPopup";

            // openPopup(url, args, w, h);

            const careerTargetDetailLayer = new window.top.document.LayerModal({
                id : 'careerTargetDetailLayer' //식별자ID
                , url : url
                , parameters : p
                , width : w
                , height : h
                , title : '경력목표 세부내역'
                , trigger :[
                    {
                        name : 'careerTargetDetailLayerTrigger'
                        , callback : function(result){
                            getReturnValue(result);
                        }
                    }
                ]
            });
            careerTargetDetailLayer.show();
        }


        function careerPathDetailPopup(Row) {
            if (!isPopup()) {
                return;
            }

            let w = 900;
            let h = 1000;
            let url = "${ctx}/CareerTarget.do?cmd=viewCareerPathDetailLayer&authPg=${authPg}";

            gPRow = Row;
            pGubun = "careerPathDetailPopup";

            const p = {
                careerTargetCd : sheet1.GetCellValue(Row, "careerTargetCd"),
                careerTargetNm : sheet1.GetCellValue(Row, "careerTargetNm")
            };

            // openPopup(url, args, w, h);

            const careerPathDetailLayer = new window.top.document.LayerModal({
                id : 'careerPathDetailLayer' //식별자ID
                , url : url
                , parameters : p
                , width : w
                , height : h
                , title : '경력목표 세부내역'
                , trigger :[
                    {
                        name : 'careerPathDetailLayerTrigger'
                        , callback : function(result){
                            getReturnValue(result);
                        }
                    }
                ]
            });
            careerPathDetailLayer.show();
        }

        function careerMapDetailPopup(Row) {

            if (!isPopup()) {
                return;
            }

            let w = 900;
            let h = 700;
            let url = "${ctx}/CareerTarget.do?cmd=viewCareerMapDetailLayer&authPg=${authPg}";

            gPRow = Row;
            pGubun = "careerMapDetailLayer";

            const p = {
                careerTargetCd : sheet1.GetCellValue(Row, "careerTargetCd"),
                careerMap : sheet1.GetCellValue(Row, "careerMap"),
                readYn : "N"
            };

            const careerMapDetailLayer = new window.top.document.LayerModal({
                id : 'careerMapDetailLayer' //식별자ID
                , url : url
                , parameters : p
                , width : w
                , height : h
                , title : '경력목표 세부내역'
                , trigger :[
                    {
                        name : 'careerMapDetailLayerTrigger'
                        , callback : function(result){
                            doAction1("Search");
                        }
                    }
                ]
            });
            careerMapDetailLayer.show();

        }

/*

        function eduInstiMgrPopup(Row) {
            if (!isPopup()) {
                return;
            }

            var w = 860;
            var h = 620;
            var url = "${ctx}/EduInstiMgr.do?cmd=viewEduInstiMgrPopup&authPg=${authPg}";
            var args = new Array();

            args["eduOrgCd"] = sheet1.GetCellValue(Row, "eduOrgCd");
            args["eduOrgNm"] = sheet1.GetCellValue(Row, "eduOrgNm");
            args["nationalCd"] = sheet1.GetCellValue(Row, "nationalCd");
            args["zip"] = sheet1.GetCellValue(Row, "zip");
            args["curAddr1"] = sheet1.GetCellValue(Row, "curAddr1");
            args["curAddr2"] = sheet1.GetCellValue(Row, "curAddr2");
            args["bigo"] = sheet1.GetCellValue(Row, "bigo");
            args["chargeName"] = sheet1.GetCellValue(Row, "chargeName");
            args["orgNm"] = sheet1.GetCellValue(Row, "orgNm");
            args["jikweeNm"] = sheet1.GetCellValue(Row, "jikweeNm");
            args["telNo"] = sheet1.GetCellValue(Row, "telNo");
            args["telHp"] = sheet1.GetCellValue(Row, "telHp");
            args["faxNo"] = sheet1.GetCellValue(Row, "faxNo");
            args["email"] = sheet1.GetCellValue(Row, "email");
            args["companyNum"] = sheet1.GetCellValue(Row, "companyNum");
            args["companyHead"] = sheet1.GetCellValue(Row, "companyHead");
            args["businessPart"] = sheet1.GetCellValue(Row, "businessPart");
            args["businessType"] = sheet1.GetCellValue(Row, "businessType");
            args["bankNum"] = sheet1.GetCellValue(Row, "bankNum");
            args["bankCd"] = sheet1.GetCellValue(Row, "bankCd");
            //args["fileSeq"] 		 =   sheet1.GetCellValue(Row, "fileSeq" );

            gPRow = Row;
            pGubun = "eduInstiMgrPopup";

            openPopup(url, args, w, h);
        }
 */

        //팝업 콜백 함수.
        function getReturnValue(returnValue) {


            if (pGubun == "careerTargetDetailPopup") {

                sheet1.SetCellValue(gPRow, "careerTargetType", returnValue.careerTargetType);
                sheet1.SetCellValue(gPRow, "useYn"           , returnValue.useYn);
                sheet1.SetCellValue(gPRow, "careerTargetNm"  , returnValue.careerTargetNm);
                sheet1.SetCellValue(gPRow, "careerTargetDesc", returnValue.careerTargetDesc);
                sheet1.SetCellValue(gPRow, "g1StepDesc"      , returnValue.g1StepDesc);
                sheet1.SetCellValue(gPRow, "g1NeedDesc"      , returnValue.g1NeedDesc);
                sheet1.SetCellValue(gPRow, "g2StepDesc"      , returnValue.g2StepDesc);
                sheet1.SetCellValue(gPRow, "g2NeedDesc"      , returnValue.g2NeedDesc);
                sheet1.SetCellValue(gPRow, "g3StepDesc"      , returnValue.g3StepDesc);
                sheet1.SetCellValue(gPRow, "g3NeedDesc"      , returnValue.g3NeedDesc);
                sheet1.SetCellValue(gPRow, "limitCnt"        , returnValue.limitCnt);

            } else if (pGubun == "eduInstiMgrPopup") {

                sheet1.SetCellValue(gPRow, "eduOrgCd"   , returnValue.eduOrgCd);
                sheet1.SetCellValue(gPRow, "eduOrgNm"   , returnValue.eduOrgNm);
                sheet1.SetCellValue(gPRow, "nationalCd" , returnValue.nationalCd);
                sheet1.SetCellValue(gPRow, "zip"        , returnValue.zip);
                sheet1.SetCellValue(gPRow, "curAddr1"   , returnValue.curAddr1);
                sheet1.SetCellValue(gPRow, "curAddr2"   , returnValue.curAddr2);
                sheet1.SetCellValue(gPRow, "bigo"       , returnValue.bigo);
                sheet1.SetCellValue(gPRow, "chargeName" , returnValue.chargeName);
                sheet1.SetCellValue(gPRow, "orgNm"      , returnValue.orgNm);
                sheet1.SetCellValue(gPRow, "jikweeNm"   , returnValue.jikweeNm);
                sheet1.SetCellValue(gPRow, "telNo"      , returnValue.telNo);
                sheet1.SetCellValue(gPRow, "telHp"      , returnValue.telHp);
                sheet1.SetCellValue(gPRow, "faxNo"      , returnValue.faxNo);
                sheet1.SetCellValue(gPRow, "email"      , returnValue.email);
                sheet1.SetCellValue(gPRow, "companyNum" , returnValue.companyNum);
                sheet1.SetCellValue(gPRow, "companyHead", returnValue.companyHead);
                sheet1.SetCellValue(gPRow, "businessPart", returnValue.businessPart);
                sheet1.SetCellValue(gPRow, "businessType", returnValue.businessType);
                sheet1.SetCellValue(gPRow, "bankNum"     , returnValue.bankNum);
                sheet1.SetCellValue(gPRow, "bankCd"     , returnValue.bankCd);
                //sheet1.SetCellValue(gPRow, "fileSeq" 			,  rv["fileSeq"]	) ;
            }
        }
    </script>
</head>
<body class="hidden">
<div class="wrapper">
    <form id="srchFrm" name="srchFrm" >
        <div class="sheet_search outer">
            <div>
                <table>
                    <tr>
                    	<th>인재유형</th>
                        <td> 
                            <select id="searchCareerTargetType" name="searchCareerTargetType">
                            </select>
                        </td>
                        <th>경력목표</th>
                        <td>  <input id="searchCareerTargetNm" name ="searchCareerTargetNm" type="text" class="text w100" /> </td>
                        <td><btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/> </td>
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
                            <li id="txt" class="txt">경력경로관리</li>
                            <li class="btn">
                                <btn:a href="javascript:doAction1('Insert')" css="basic authA" mid='110700' mdef="입력"/>
                                <btn:a href="javascript:doAction1('Copy')" 	css="basic authA" mid='110696' mdef="복사"/>
                                <btn:a href="javascript:doAction1('Save')" 	css="basic authA" mid='110708' mdef="저장"/>
                                <btn:a href="javascript:doAction1('Down2Excel')" 	css="basic authR" mid='110698' mdef="다운로드"/>
                            </li>
                        </ul>
                    </div>
                </div>
                <script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
            </td>
        </tr>
    </table>
</div>
</body>
</html>
