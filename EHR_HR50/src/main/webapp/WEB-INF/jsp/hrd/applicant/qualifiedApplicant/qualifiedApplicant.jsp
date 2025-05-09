<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title></title>
    <%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
    <%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
    <%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

    <script type="text/javascript">

        var pGubun;
        var gPRow = "";

        $(function() {

            var initdata = {};
            initdata.Cfg = {SearchMode:smLazyLoad,Page:22, ChildPage:5};
            initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
            initdata.Cols = [

                {Header:"<sht:txt mid='sNo'        mdef='No'           />", Type:"${sNoTy}"    , Hidden:Number("${sNoHdn}") , Width:"${sNoWdt}"  , Align:"Center", ColMerge:0, SaveName:"sNo" },
                {Header:"<sht:txt mid='sDelete V5' mdef='삭제'         />", Type:"${sDelTy}"   , Hidden:Number("${sDelHdn}"),  Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0 },
                {Header:"<sht:txt mid='sStatus'    mdef='상태'         />", Type:"${sSttTy}"   , Hidden:1,  Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
                {Header:"<sht:txt mid='BLANK'      mdef='대분류'       />", Type:"Combo"       , Hidden:0, Width:60 ,  Align:"Left"      , ColMerge:0, SaveName:"workAssignNmLarge"            ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100    },
                {Header:"<sht:txt mid='BLANK'      mdef='중분류'       />", Type:"Combo"       , Hidden:0, Width:65 ,  Align:"Left"      , ColMerge:0, SaveName:"workAssignNmMiddle"           ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100    },
//                {Header:"<sht:txt mid='BLANK'      mdef='단위업무코드' />", Type:"Text"        , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"workAssignCd"                 ,    KeyField:1, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:10     },
//                {Header:"<sht:txt mid='BLANK'      mdef='단위업무'     />", Type:"Popup"       , Hidden:0, Width:90 ,  Align:"Left"      , ColMerge:0, SaveName:"workAssignNm"                 ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100    },
                {Header:"<sht:txt mid='BLANK'      mdef='단위업무'     />", Type:"Combo"       , Hidden:0, Width:90 ,  Align:"Left"      , ColMerge:0, SaveName:"workAssignCd"                 ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100    },
                {Header:"<sht:txt mid='BLANK'      mdef='최소기간'     />", Type:"Combo"       , Hidden:0, Width:55 ,  Align:"Center"    , ColMerge:0, SaveName:"minTerm"                      ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:1      }

            ]; IBS_InitSheet(sheet1, initdata);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

            initdata = {};
            initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
            initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
            initdata.Cols = [

                {Header:"<sht:txt mid='sNo'        mdef='No'           />", Type:"${sNoTy}"    , Hidden:Number("${sNoHdn}") , Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo2" },
                {Header:"<sht:txt mid='sDelete V5' mdef='삭제'         />", Type:"${sDelTy}"   , Hidden:Number("${sDelHdn}"), Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete2", Sort:0 },
                {Header:"<sht:txt mid='sStatus'    mdef='상태'         />", Type:"${sSttTy}"   , Hidden:1, Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus2", Sort:0 },
                {Header:"<sht:txt mid='BLANK'      mdef='구분'         />", Type:"Combo"       , Hidden:0, Width:60 ,  Align:"Center"    , ColMerge:0, SaveName:"gubun"                 ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100    },
                {Header:"<sht:txt mid='BLANK'      mdef='카테고리코드' />", Type:"Text"        , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"categoryCd"            ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10     },
                {Header:"<sht:txt mid='BLANK'      mdef='카테고리명'   />", Type:"Text"        , Hidden:0, Width:80 ,  Align:"Left"      , ColMerge:0, SaveName:"categoryNm"            ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100    },
                {Header:"<sht:txt mid='BLANK'      mdef='지식코드'     />", Type:"Text"        , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"knowledgeCd"           ,    KeyField:1, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:22     },
                {Header:"<sht:txt mid='BLANK'      mdef='지식-스킬'    />", Type:"Text"        , Hidden:0, Width:80 ,  Align:"Left"      , ColMerge:0, SaveName:"knowledgeNm"           ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100    },
                {Header:"<sht:txt mid='BLANK'      mdef='지식구분'     />", Type:"Text"        , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"knowledgeType"         ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:1      },
                {Header:"<sht:txt mid='BLANK'      mdef='BIZ구분'      />", Type:"Text"        , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"techBizType"           ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:1      },
                {Header:"<sht:txt mid='BLANK'      mdef='최소등급'     />", Type:"Combo"       , Hidden:0, Width:50 ,  Align:"Center"    , ColMerge:0, SaveName:"finalGrade"            ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:1      }



            ]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);


            initdata = {};
            initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msAll};
            initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
            initdata.Cols = [

                {Header:"<sht:txt mid='sNo'     mdef='No'  />|<sht:txt mid='sNo'     mdef='No'  />",     Type:"${sNoTy}",  Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },

                {Header:"<sht:txt mid='BLANK' mdef='구분'         />|<sht:txt mid='BLANK' mdef='구분'         />", Type:"Combo"       ,    Hidden:0, Width:50 ,  Align:"Center"    , ColMerge:0, SaveName:"empGbn"                    ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50     },
                {Header:"<sht:txt mid='BLANK' mdef='년도'         />|<sht:txt mid='BLANK' mdef='년도'         />", Type:"Text"        ,    Hidden:1, Width:60 ,  Align:"Center"    , ColMerge:0, SaveName:"activeYyyy"                ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:4      },
                {Header:"<sht:txt mid='BLANK' mdef='반기'         />|<sht:txt mid='BLANK' mdef='반기'         />", Type:"Combo"       ,    Hidden:1, Width:60 ,  Align:"Center"    , ColMerge:0, SaveName:"halfGubunType"             ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:1      },

                {Header:"<sht:txt mid='BLANK' mdef='적임자정보'   />|<sht:txt mid='BLANK' mdef='부서코드'     />", Type:"Text"        ,    Hidden:1, Width:80 ,  Align:"Center"    , ColMerge:0, SaveName:"mainOrgCd"                 ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10     },
                {Header:"<sht:txt mid='BLANK' mdef='적임자정보'   />|<sht:txt mid='BLANK' mdef='부서'         />", Type:"Text"        ,    Hidden:1, Width:80 ,  Align:"Left"      , ColMerge:0, SaveName:"mainOrgNm"                 ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50     },
                {Header:"<sht:txt mid='BLANK' mdef='적임자정보'   />|<sht:txt mid='BLANK' mdef='상위부서'         />", Type:"Text"        ,    Hidden:0, Width:80 ,  Align:"Left"      , ColMerge:0, SaveName:"priorOrgNm"                 ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50     },
                {Header:"<sht:txt mid='BLANK' mdef='적임자정보'   />|<sht:txt mid='BLANK' mdef='팀코드'       />", Type:"Text"        ,    Hidden:1, Width:80 ,  Align:"Center"    , ColMerge:0, SaveName:"orgCd"                     ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10     },
                {Header:"<sht:txt mid='BLANK' mdef='적임자정보'   />|<sht:txt mid='BLANK' mdef='소속'           />", Type:"Text"        ,    Hidden:0, Width:80 ,  Align:"Left"      , ColMerge:0, SaveName:"orgNm"                     ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100    },
                {Header:"<sht:txt mid='BLANK' mdef='적임자정보'   />|<sht:txt mid='BLANK' mdef='사원번호'     />", Type:"Text"        ,    Hidden:1, Width:50 ,  Align:"Left"      , ColMerge:0, SaveName:"sabun"                     ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:13     },
                {Header:"<sht:txt mid='BLANK' mdef='적임자정보'   />|<sht:txt mid='BLANK' mdef='성명'         />", Type:"Text"        ,    Hidden:0, Width:50 ,  Align:"Left"      , ColMerge:0, SaveName:"name"                      ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:100    },

                {Header:"<sht:txt mid='BLANK' mdef='적임자정보'   />|<sht:txt mid='BLANK' mdef='직위코드'     />", Type:"Text"        ,    Hidden:1, Width:80 ,  Align:"Center"    , ColMerge:0, SaveName:"jikweeCd"                  ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10     },
                {Header:"<sht:txt mid='BLANK' mdef='적임자정보'   />|<sht:txt mid='BLANK' mdef='직위'         />", Type:"Text"        ,    Hidden:0, Width:80 ,  Align:"Center"    , ColMerge:0, SaveName:"jikweeNm"                  ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100    },
                {Header:"<sht:txt mid='BLANK' mdef='적임자정보'   />|<sht:txt mid='BLANK' mdef='직급코드'     />", Type:"Text"        ,    Hidden:1, Width:80 ,  Align:"Center"    , ColMerge:0, SaveName:"jikgubCd"                  ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10     },
                {Header:"<sht:txt mid='BLANK' mdef='적임자정보'   />|<sht:txt mid='BLANK' mdef='직급'         />", Type:"Text"        ,    Hidden:0, Width:80 ,  Align:"Center"    , ColMerge:0, SaveName:"jikgubNm"                  ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100    },
                {Header:"<sht:txt mid='BLANK' mdef='적임자정보'   />|<sht:txt mid='BLANK' mdef='사내전화'     />", Type:"Text"        ,    Hidden:0, Width:100,  Align:"Left"      , ColMerge:0, SaveName:"officeTel"                 ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:20     },
                {Header:"<sht:txt mid='BLANK' mdef='적임자정보'   />|<sht:txt mid='BLANK' mdef='핸드폰'       />", Type:"Text"        ,    Hidden:0, Width:100,  Align:"Left"      , ColMerge:0, SaveName:"handPhone"                 ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:20     },
                {Header:"<sht:txt mid='BLANK' mdef='적임자정보'   />|<sht:txt mid='BLANK' mdef='사무분담'     />", Type:"Text"        ,    Hidden:0, Width:200,  Align:"Left"      , ColMerge:0, SaveName:"workAssign"                ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:4000   },
                {Header:"<sht:txt mid='BLANK' mdef='적임자정보'   />|<sht:txt mid='BLANK' mdef='입행일'       />", Type:"Text"        ,    Hidden:1, Width:80 ,  Align:"Left"      , ColMerge:0, SaveName:"empYmd"                    ,    KeyField:0, CalcLogic:"", Format:"Ymd"        ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100    },
                {Header:"<sht:txt mid='BLANK' mdef='적임자정보'   />|<sht:txt mid='BLANK' mdef='나이'         />", Type:"Text"        ,    Hidden:1, Width:50 ,  Align:"Left"      , ColMerge:0, SaveName:"resnoYear"                 ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:20     },
                {Header:"<sht:txt mid='BLANK' mdef='적임자정보'   />|<sht:txt mid='BLANK' mdef='학력'         />", Type:"Text"        ,    Hidden:1, Width:60 ,  Align:"Center"    , ColMerge:0, SaveName:"acaSchNm"                  ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:20     },
                {Header:"<sht:txt mid='BLANK' mdef='적임자정보'   />|<sht:txt mid='BLANK' mdef='학과'         />", Type:"Text"        ,    Hidden:1, Width:100,  Align:"Left"      , ColMerge:0, SaveName:"acamajCd"                  ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100    },
                {Header:"<sht:txt mid='BLANK' mdef='적임자정보'   />|<sht:txt mid='BLANK' mdef='성별'         />", Type:"Text"        ,    Hidden:1, Width:50 ,  Align:"Left"      , ColMerge:0, SaveName:"sexType"                   ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:1      },
                {Header:"<sht:txt mid='BLANK' mdef='적임자정보'   />|<sht:txt mid='BLANK' mdef='희망시기'     />", Type:"Text"        ,    Hidden:1, Width:80 ,  Align:"Center"    , ColMerge:0, SaveName:"moveHopeTime"              ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100    },
                {Header:"<sht:txt mid='BLANK' mdef='적임자정보'   />|<sht:txt mid='BLANK' mdef='1순위'        />", Type:"Text"        ,    Hidden:1, Width:80 ,  Align:"Center"    , ColMerge:0, SaveName:"workAssignCd1"             ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10     },
                {Header:"<sht:txt mid='BLANK' mdef='적임자정보'   />|<sht:txt mid='BLANK' mdef='1순위'        />", Type:"Text"        ,    Hidden:1, Width:200,  Align:"Left"      , ColMerge:0, SaveName:"workAssignNm1"             ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100    },
                {Header:"<sht:txt mid='BLANK' mdef='적임자정보'   />|<sht:txt mid='BLANK' mdef='2순위'        />", Type:"Text"        ,    Hidden:1, Width:80 ,  Align:"Center"    , ColMerge:0, SaveName:"workAssignCd2"             ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10     },
                {Header:"<sht:txt mid='BLANK' mdef='적임자정보'   />|<sht:txt mid='BLANK' mdef='2순위'        />", Type:"Text"        ,    Hidden:1, Width:200,  Align:"Left"      , ColMerge:0, SaveName:"workAssignNm2"             ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100    },
                {Header:"<sht:txt mid='BLANK' mdef='적임자정보'   />|<sht:txt mid='BLANK' mdef='3순위'        />", Type:"Text"        ,    Hidden:1, Width:80 ,  Align:"Center"    , ColMerge:0, SaveName:"workAssignCd3"             ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10     },
                {Header:"<sht:txt mid='BLANK' mdef='적임자정보'   />|<sht:txt mid='BLANK' mdef='3순위'        />", Type:"Text"        ,    Hidden:1, Width:200,  Align:"Left"      , ColMerge:0, SaveName:"workAssignNm3"             ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100    },

                {Header:"<sht:txt mid='BLANK' mdef='개인인사정보' />|<sht:txt mid='BLANK' mdef='개인인사정보' />", Type:"Image"       ,    Hidden:0, Width:60 ,  Align:"Center"    , ColMerge:0, SaveName:"personInfo"              ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:1      },
                {Header:"<sht:txt mid='BLANK' mdef='자기신고서'   />|<sht:txt mid='BLANK' mdef='자기신고서'   />", Type:"Image"       ,    Hidden:1, Width:60 ,  Align:"Center"    , ColMerge:0, SaveName:"selfReport"                ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:1      },
                {Header:"<sht:txt mid='BLANK' mdef='자기평가'     />|<sht:txt mid='BLANK' mdef='자기평가'     />", Type:"Image"       ,    Hidden:1, Width:60 ,  Align:"Center"    , ColMerge:0, SaveName:"selfRating"                  ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:1      },
                {Header:"<sht:txt mid='BLANK' mdef='자기계발계획' />|<sht:txt mid='BLANK' mdef='자기계발계획' />", Type:"Image"       ,    Hidden:1, Width:60 ,  Align:"Center"    , ColMerge:0, SaveName:"selfDevelop"              ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:1      },
                {Header:"<sht:txt mid='BLANK' mdef='적합도 판단'  />|<sht:txt mid='BLANK' mdef='만족도'       />", Type:"Int"         ,    Hidden:0, Width:60 ,  Align:"Right"     , ColMerge:0, SaveName:"satisfactionPoint"         ,    KeyField:0, CalcLogic:"", Format:"Integer"    ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:4000   },
                {Header:"<sht:txt mid='BLANK' mdef='적합도 판단'  />|<sht:txt mid='BLANK' mdef='업무량'       />", Type:"Text"        ,    Hidden:1, Width:60 ,  Align:"Left"      , ColMerge:0, SaveName:"업무량"                    ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:4000   }
                // 위 업무량 컬럼의 SaveName이 제대로 지정되지 않아 히든 처리


            ]; IBS_InitSheet(sheet3, initdata);sheet3.SetEditable("${editable}");sheet3.SetVisible(true);sheet3.SetCountPosition(4);

            fnSetCode();
            sheet3.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
            sheet3.SetImageList(1,"${ctx}/common/images/icon/icon_popup.png");
            sheet3.SetDataLinkMouse("personInfo" , 1);
            sheet3.SetDataLinkMouse("selfReport" , 1);
            sheet3.SetDataLinkMouse("selfRating" , 1);
            sheet3.SetDataLinkMouse("selfDevelop", 1);

            $(window).smartresize(sheetResize); sheetInit();
            //doAction3("Search");
        });

        function fnSetCode() {
            //상하반기
            var halfGubunTypeCd     = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","D00005"), "");
            sheet3.SetColProperty("halfGubunType", 	{ComboText:halfGubunTypeCd[0], ComboCode:halfGubunTypeCd[1]} );

            //$("#searchHalfGubunTypeCd").html(halfGubunTypeCd[2]);              //.val("1");

            //var approvalStatusCd    = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","D00007"), "");
            //sheet1.SetColProperty("approvalStatus", 	{ComboText:approvalStatusCd[0], ComboCode:approvalStatusCd[1]} );

            //var educationYnCd       = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","D00016"), " ");
            //sheet1.SetColProperty("educationYn", 	{ComboText:educationYnCd[0], ComboCode:educationYnCd[1]} );

            var workAssignNmLargeCd = convCode( codeList("${ctx}/QualifiedApplicant.do?cmd=getJobCatCodeList&searchType=G",""), "");
            sheet1.SetColProperty("workAssignNmLarge", 	{ComboText:workAssignNmLargeCd[0], ComboCode:workAssignNmLargeCd[1]} );

            var minTermCd           = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","D00018"), " ");
            sheet1.SetColProperty("minTerm", 	{ComboText:minTermCd[0], ComboCode:minTermCd[1]} );

            //var eduPreYmdCd         = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","D00014"), "");
            //sheet2.SetColProperty("eduPreYmd" , {ComboText:eduPreYmdCd[0], ComboCode:eduPreYmdCd[1]} );

            var gubunCd             = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","D00020"), "");
            sheet2.SetColProperty("gubun" , {ComboText:gubunCd[0], ComboCode:gubunCd[1]} );

            var finalGradeCd        = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","D00022"), "");
            sheet2.SetColProperty("finalGrade" , {ComboText:finalGradeCd[0], ComboCode:finalGradeCd[1]} );

            sheet3.SetColProperty("empGbn",		{ComboText:"|ITG|외주", ComboCode:"|ITG|OUT_EMP"} );
        }

        //Sheet1 Action
        function doAction1(sAction) {
            switch (sAction) {
//                 case "Search":
//                     sheet1.DoSearch( "${ctx}/SelfDevelopmentEduConn.do?cmd=getHopeEducationList", $("#srchFrm").serialize() );
//                     break;
                case "Insert": //입력
                    var Row = sheet1.DataInsert(0);
                    var value = sheet1.GetCellValue(Row,"workAssignNmLarge");
                    console.log("doAction1", "value" , value);
                    setJobCode("M",Row,value);
                    break;
//                 case "Save":
//                     IBS_SaveName(document.srchFrm,sheet1);
//                     sheet1.DoSave( "${ctx}/SelfDevelopmentEduConn.do?cmd=saveEducationYn", $("#srchFrm").serialize());
//                     break;
            }
        }

//         //Sheet2 Action
//         function doAction2(sAction) {
//             switch (sAction) {
//                 case "Search":
//                     var param = "&searchEducation="+sheet1.GetCellValue(sheet1.GetSelectRow(),"education");
//                     sheet2.DoSearch( "${ctx}/SelfDevelopmentEduConn.do?cmd=getHopePersonList", $("#srchFrm").serialize() + param);
//                     break;
//                 case "Down2Excel":
//                     sheet2.Down2Excel();
//                     break;
//             }
//         }


        //Sheet3 Action
        function doAction3(sAction) {
            switch (sAction) {
                case "Search":
                    //var param = "&searchEducation="+sheet1.GetCellValue(sheet1.GetSelectRow(),"education");
                    var saveStr1 = sheet1.GetSaveString(0);
                    var saveStr2 = sheet2.GetSaveString(0);

                    //console.log("saveStr1", saveStr1);
                    //console.log("saveStr2", saveStr2);

                    sheet3.DoSearch( "${ctx}/QualifiedApplicant.do?cmd=getQualifiedApplicantList", $("#srchFrm").serialize() + "&"+saveStr1 + "&"+saveStr2);

                    break;
                case "Down2Excel":
                    sheet2.Down2Excel();
                    break;
            }
        }
        // 조회 후 에러 메시지
        function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
            try { if (Msg != "") { alert(Msg); }
                sheetResize();
            } catch (ex) {
                alert("OnSearchEnd Event Error : " + ex);

            }
        }

        // 셀이 선택 되었을때 발생한다
        function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol,isDelete) {
            try {
                if(OldRow != NewRow) {
                }
            } catch (ex) {
                alert("OnSelectCell Event Error : " + ex);
            }
        }

        // 저장 후 메시지
        function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
            try {
                if (Msg != "") {
                    alert(Msg);
                }

            } catch (ex) {
                alert("OnSaveEnd Event Error " + ex);
            }
        }

        function sheet1_OnChange(Row, Col, Value, OldValue) {
            try{
                if( sheet1.ColSaveName(Col) == "workAssignNmLarge" ) {
                    setJobCode("M", Row,Value);
                }else if( sheet1.ColSaveName(Col) == "workAssignNmMiddle" ) {
                    setJobCode("S", Row,Value);
                }
            } catch(ex) {
                alert("OnChange	Event Error : "	+ ex);
            }
        }

        function setJobCode(setType, Row, Value) {
            var param = "&searchType="+setType+"&searchWorkAssignCd="+Value;
            var colNm = setType == "M" ? "workAssignNmMiddle" : setType == "S" ? "workAssignCd" : "";

            var jobCodeList = convCode( codeList("${ctx}/QualifiedApplicant.do?cmd=getJobCatCodeList"+param,""), "");
            sheet1.InitCellProperty(Row,colNm, 	{Type:"Combo", ComboText:"|"+jobCodeList[0], ComboCode:"|"+jobCodeList[1]} );
        }



        // 조회 후 에러 메시지
        function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
            try{
                if (Msg != ""){
                    alert(Msg);
                }
                sheetResize();
            }catch(ex){
                alert("OnSearchEnd Event Error : " + ex);
            }
        }


        // 조회 후 에러 메시지
        function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
            try{
                if (Msg != ""){
                    alert(Msg);

                    for(var i=sheet3.HeaderRows(); i<=sheet3.LastRow(); i++) {
                        sheet3.SetCellValue(i, "personInfo", "0", {event:false});
                    }

                }
                sheetResize();
            }catch(ex){
                alert("OnSearchEnd Event Error : " + ex);
            }
        }

        function sheet3_OnClick(Row, Col, Value) {
            try{
                if(sheet3.ColSaveName(Col) == "personInfo" ){
                    rdPersonInfoPopup(Row);
                }else if(sheet3.ColSaveName(Col) == "selfReport" ){
                    rdSelfReportPopup(Row);
                }else if(sheet3.ColSaveName(Col) == "selfRating" ){
                    rdSelfRatingPopup(Row);
                }else if(sheet3.ColSaveName(Col) == "selfDevelop" ) {
                    rselfDevelopPopup(Row);
                }
            }catch(ex){alert("OnClick Event Error : " + ex);}

        }



        function rdPersonInfoPopup(Row){
            var w    = 900;
            var h    = 700;
            var url  = "${ctx}/RdPopup.do";
            var args = new Array();

            var rdMrd           = "";
            var rdTitle         = "";
            var rdParam         = "";

            //rdMrd   = "hrm/empcard/PersonInfoCard_${ssnEnterCd}.mrd";
            rdMrd   = "hrm/empcard/PersonInfoCardType2_HR.mrd";
            rdTitle = "인사카드";

            rdParam += "[,('${ssnEnterCd}','" + sheet3.GetCellValue(Row,"sabun") + "')]";  // 1.회사코드 및 사번
            rdParam += "[${baseURL}]";  // 2.이미지 url---3
            rdParam += "[Y]"; //개인정보 마스킹
            rdParam += "[Y]"; //인사기본1
            rdParam += "[Y]"; //인사기본2
            rdParam += "[Y]"; //발령사항
            rdParam += "[Y]"; //교육사항
            rdParam += "[Y]"; // 전체발령체크
            rdParam += "[${ssnEnterCd}]";  // 8.회사코드
            rdParam += "['${ssnSabun}']";  // 9.출력자 사번 어레이
            rdParam += "[${ssnLocaleCd}] ";	// 10.다국어코드

            var imgPath = " " ;
            args["rdTitle"]      = rdTitle ; // rd Popup제목
            args["rdMrd"]        = rdMrd;    // ( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명
            args["rdParam"]      = rdParam;  // rd파라매터
            args["rdParamGubun"] = "rp";     // 파라매터구분(rp/rv)
            args["rdToolBarYn"]  = "Y" ;     // 툴바여부
            args["rdZoomRatio"]  = "100";    // 확대축소비율

            args["rdSaveYn"]  = "Y" ;  // 기능컨트롤_저장
            args["rdPrintYn"] = "Y" ;  // 기능컨트롤_인쇄
            args["rdExcelYn"] = "Y" ;  // 기능컨트롤_엑셀
            args["rdWordYn"]  = "Y" ;  // 기능컨트롤_워드
            args["rdPptYn"]   = "Y" ;  // 기능컨트롤_파워포인트
            args["rdHwpYn"]   = "Y" ;  // 기능컨트롤_한글
            args["rdPdfYn"]   = "Y" ;  // 기능컨트롤_PDF

            var rv = openPopup(url, args, w, h);  // 알디출력을 위한 팝업창
            if(rv!=null && rv["printResultYn"] == "Y"){
            }
        }

        function rdSelfReportPopup(Row){
            var w    = 900;
            var h    = 700;
            var url  = "${ctx}/RdPopup.do";
            var args = new Array();

            var rdMrd           = "";
            var rdTitle         = "";
            var rdParam         = "";

            rdMrd   = "cdp/SelfReport.mrd";
            rdTitle = "자기신고서";

            rdParam += "[${ssnEnterCd}]";
            rdParam += "["+sheet3.GetCellValue(Row,"sabun")+"]";
            rdParam += "["+sheet3.GetCellValue(Row,"activeYyyy")+"]";
            rdParam += "["+sheet3.GetCellValue(Row,"halfGubunType")+"]";
            rdParam += "["+(sheet3.GetCellValue(Row,"halfGubunType") == "1" ? "상반기" : "하반기")+ "]";
            rdParam += "["+sheet3.GetCellValue(Row,"name")+"]";

            var imgPath = " " ;
            args["rdTitle"]      = rdTitle ; // rd Popup제목
            args["rdMrd"]        = rdMrd;    // ( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명
            args["rdParam"]      = rdParam;  // rd파라매터
            args["rdParamGubun"] = "rp";     // 파라매터구분(rp/rv)
            args["rdToolBarYn"]  = "Y" ;     // 툴바여부
            args["rdZoomRatio"]  = "100";    // 확대축소비율

            args["rdSaveYn"]  = "Y" ;  // 기능컨트롤_저장
            args["rdPrintYn"] = "Y" ;  // 기능컨트롤_인쇄
            args["rdExcelYn"] = "Y" ;  // 기능컨트롤_엑셀
            args["rdWordYn"]  = "Y" ;  // 기능컨트롤_워드
            args["rdPptYn"]   = "Y" ;  // 기능컨트롤_파워포인트
            args["rdHwpYn"]   = "Y" ;  // 기능컨트롤_한글
            args["rdPdfYn"]   = "Y" ;  // 기능컨트롤_PDF

            var rv = openPopup(url, args, w, h);  // 알디출력을 위한 팝업창
            if(rv!=null && rv["printResultYn"] == "Y"){
            }
        }

        function rdSelfRatingPopup(Row){
            var w    = 900;
            var h    = 700;
            var url  = "${ctx}/RdPopup.do";
            var args = new Array();

            var rdMrd           = "";
            var rdTitle         = "";
            var rdParam         = "";

            ///rp [HR][5070037][2008][1][하반기]

            rdMrd   = "cdp/SelfRating.mrd";
            rdTitle = "자기평가";

            rdParam += "[${ssnEnterCd}]";
            rdParam += "["+sheet3.GetCellValue(Row,"sabun")+"]";
            rdParam += "["+sheet3.GetCellValue(Row,"activeYyyy")+"]";
            rdParam += "["+sheet3.GetCellValue(Row,"halfGubunType")+"]";
            rdParam += "["+(sheet3.GetCellValue(Row,"halfGubunType") == "1" ? "상반기" : "하반기")+ "]";




            var imgPath = " " ;
            args["rdTitle"]      = rdTitle ; // rd Popup제목
            args["rdMrd"]        = rdMrd;    // ( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명
            args["rdParam"]      = rdParam;  // rd파라매터
            args["rdParamGubun"] = "rp";     // 파라매터구분(rp/rv)
            args["rdToolBarYn"]  = "Y" ;     // 툴바여부
            args["rdZoomRatio"]  = "100";    // 확대축소비율

            args["rdSaveYn"]  = "Y" ;  // 기능컨트롤_저장
            args["rdPrintYn"] = "Y" ;  // 기능컨트롤_인쇄
            args["rdExcelYn"] = "Y" ;  // 기능컨트롤_엑셀
            args["rdWordYn"]  = "Y" ;  // 기능컨트롤_워드
            args["rdPptYn"]   = "Y" ;  // 기능컨트롤_파워포인트
            args["rdHwpYn"]   = "Y" ;  // 기능컨트롤_한글
            args["rdPdfYn"]   = "Y" ;  // 기능컨트롤_PDF

            var rv = openPopup(url, args, w, h);  // 알디출력을 위한 팝업창
            if(rv!=null && rv["printResultYn"] == "Y"){
            }
        }

        function rselfDevelopPopup(Row){
            var w    = 900;
            var h    = 700;
            var url  = "${ctx}/RdPopup.do";
            var args = new Array();

            var rdMrd           = "";
            var rdTitle         = "";
            var rdParam         = "";

            rdMrd   = "cdp/SelfDevelopment.mrd";
            rdTitle = "자기계발계획";

            rdParam += "[${ssnEnterCd}]";
            rdParam += "["+sheet3.GetCellValue(Row,"sabun")+"]";
            rdParam += "["+sheet3.GetCellValue(Row,"activeYyyy")+"]";
            rdParam += "["+sheet3.GetCellValue(Row,"halfGubunType")+"]";
            rdParam += "["+(sheet3.GetCellValue(Row,"halfGubunType") == "1" ? "상반기" : "하반기")+ "]";
            rdParam += "["+sheet3.GetCellValue(Row,"name")+"]";

            var imgPath = " " ;
            args["rdTitle"]      = rdTitle ; // rd Popup제목
            args["rdMrd"]        = rdMrd;    // ( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명
            args["rdParam"]      = rdParam;  // rd파라매터
            args["rdParamGubun"] = "rp";     // 파라매터구분(rp/rv)
            args["rdToolBarYn"]  = "Y" ;     // 툴바여부
            args["rdZoomRatio"]  = "100";    // 확대축소비율

            args["rdSaveYn"]  = "Y" ;  // 기능컨트롤_저장
            args["rdPrintYn"] = "Y" ;  // 기능컨트롤_인쇄
            args["rdExcelYn"] = "Y" ;  // 기능컨트롤_엑셀
            args["rdWordYn"]  = "Y" ;  // 기능컨트롤_워드
            args["rdPptYn"]   = "Y" ;  // 기능컨트롤_파워포인트
            args["rdHwpYn"]   = "Y" ;  // 기능컨트롤_한글
            args["rdPdfYn"]   = "Y" ;  // 기능컨트롤_PDF

            var rv = openPopup(url, args, w, h);  // 알디출력을 위한 팝업창
            if(rv!=null && rv["printResultYn"] == "Y"){
            }
        }

        function showSkillPopup() {
            if(!isPopup()) {return;}
            gPRow = "";
            pGubun = "skillPopup";

            var rst = openPopup("/Popup.do?cmd=skillPopup&authPg=R", "", "780","600");

        }

        function getReturnValue(returnValue) {
            var rv = $.parseJSON('{' + returnValue+ '}');

            if(pGubun == "skillPopup"){
                $('#name').val(rv["name"]);
                $('#sabun').val(rv["sabun"]);

                var codeList = rv["codeList"].split(",");

                if (rv["codeList"].length <= 0) return;
                
                for (var i=0 ; i< codeList.length ; i+= 5) {

                    var Row = sheet2.DataInsert(0);

                    sheet2.SetCellValue(Row, "gubun"      , codeList[i]  );
                    sheet2.SetCellValue(Row, "knowledgeCd", codeList[i+2]);
                    sheet2.SetCellValue(Row, "knowledgeNm", codeList[i+3]);
                    sheet2.SetCellValue(Row, "finalGrade" , codeList[i+1]);
                    sheet2.SetCellValue(Row, "categoryNm" , codeList[i+4]);
                }
            }
            pGubun = "";
        }



    </script>
</head>
<body class="bodywrap">
<div class="wrapper">
    <form id="srchFrm" name="srchFrm" >

        <div class="sheet_search outer">
            <div>
                <table>
                    <tr>
                        <th>선발구분</th>
                        <td>
                            <input type="radio" id="searchChartTypeALL" name="searchChartType" value="ALL" checked  ><label for="searchChartTypeALL">전체</label>
                            <input type="radio" id="searchChartTypeAPP" name="searchChartType" value="APP" ><label for="searchChartTypeAPP">ITG</label>
                            <input type="radio" id="searchChartTypeREG" name="searchChartType" value="REG" ><label for="searchChartTypeREG">외주</label>
                        </td>
                        <td><btn:a href="javascript:doAction3('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/> </td>

                    </tr>
                </table>
            </div>
        </div>
    </form>

    <table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
        <colgroup>
            <col width="40%" />
            <col width="60%" />
        </colgroup>
        <tr>
            <td class="sheet_left">
                <div class="inner">
                    <div class="sheet_title">
                        <ul>
                            <li id="txt" class="txt"><tit:txt mid='BLANK' mdef='업무경험 요건설정'/>&nbsp;</li>
                            <li class="btn">
                                <btn:a href="javascript:doAction1('Insert');" css="basic authA" mid='' mdef="조건추가"/>
                            </li>
                        </ul>
                    </div>
                </div>
                <script type="text/javascript"> createIBSheet("sheet1", "50%", "50%", "${ssnLocaleCd}"); </script>
            </td>

            <td class="sheet_right">
                <div class="inner">
                    <div class="sheet_title">
                        <ul>
                            <li id="txt" class="txt"><tit:txt mid='BLANK' mdef='지식스킬 요건설정'/></li>
                            <li class="btn">
                                <btn:a href="javascript:showSkillPopup();" css="basic authA" mid='' mdef="조건추가"/>
                                
                            </li>
                        </ul>
                    </div>
                </div>
                <script type="text/javascript">createIBSheet("sheet2", "50%", "50%", "${ssnLocaleCd}"); </script>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <div class="inner">
                    <div class="sheet_title">
                        <ul>
                            <li class="txt">적임자정보</li>
                            <li class="btn">
                                <btn:a href="javascript:doAction3('Down2Excel');" css="basic authR" mid='110698' mdef="다운로드"/>
                            </li>
                        </ul>
                    </div>
                </div>
                <script type="text/javascript">createIBSheet("sheet3", "100%", "50%"); </script>
            </td>
        </tr>
    </table>

    </form>
</div>
</body>
</html>
