<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden">
<head>
    <%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
    <%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
    <%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

    <script type="text/javascript">
        $(function() {

            /* Tab */

            $("#tabs").tabs();
            $("#tabsIndex").val('0');

            var initdata3 = {};
            initdata3.Cfg = {SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
            initdata3.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
            initdata3.Cols = [
                {Header:"<sht:txt mid='sNo'        mdef='No'  />|<sht:txt mid='sNo'        mdef='No'  />",     Type:"${sNoTy}",  Hidden:Number("${sNoHdn}") ,  Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
                {Header:"<sht:txt mid='sStatus'    mdef='상태'/>|<sht:txt mid='sStatus'    mdef='상태'/>",     Type:"${sSttTy}", Hidden:Number("${sSttHdn}"),  Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
                {Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>|<sht:txt mid='sDelete V5' mdef='삭제'/>",     Type:"${sDelTy}", Hidden:Number("${sDelHdn}"),  Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0 },
                {Header:"<sht:txt mid='BLANK'   mdef='구분코드'              />|<sht:txt mid='BLANK'   mdef='구분코드'    />", Type:"Text"    ,    Hidden:1, Width:0  ,  Align:"Center", ColMerge:0, SaveName:"gubunCode"    ,    KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10 },
                {Header:"<sht:txt mid='BLANK'   mdef='구분'                  />|<sht:txt mid='BLANK'   mdef='구분'        />", Type:"Text"    ,    Hidden:0, Width:80 ,  Align:"Center", ColMerge:0, SaveName:"gubun"        ,    KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
                {Header:"<sht:txt mid='BLANK'   mdef='코드'                  />|<sht:txt mid='BLANK'   mdef='코드'        />", Type:"Text"    ,    Hidden:1, Width:0  ,  Align:"Center", ColMerge:0, SaveName:"code"         ,    KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:10 },
                {Header:"<sht:txt mid='BLANK'   mdef='지식/스킬'             />|<sht:txt mid='BLANK'   mdef='지식/스킬'   />", Type:"Text"    ,    Hidden:0, Width:100,  Align:"Left"  , ColMerge:0, SaveName:"codeNm"       ,    KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
                {Header:"<sht:txt mid='BLANK'   mdef='지식/스킬 요구수준비교'/>|<sht:txt mid='BLANK'   mdef='본인수준'    />", Type:"Combo"   ,    Hidden:0, Width:50 ,  Align:"Center", ColMerge:0, SaveName:"selfGrade"    ,    KeyField:0, CalcLogic:"", Format:"NullInteger",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10 },
                {Header:"<sht:txt mid='BLANK'   mdef='지식/스킬 요구수준비교'/>|<sht:txt mid='BLANK'   mdef='現업무'      />", Type:"Combo"   ,    Hidden:0, Width:40 ,  Align:"Center", ColMerge:0, SaveName:"workGrade"    ,    KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:1 },
                {Header:"<sht:txt mid='BLANK'   mdef='지식/스킬 요구수준비교'/>|<sht:txt mid='BLANK'   mdef='희망업무1'   />", Type:"Combo"   ,    Hidden:0, Width:60 ,  Align:"Center", ColMerge:0, SaveName:"hope1Grade"   ,    KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:1 },
                {Header:"<sht:txt mid='BLANK'   mdef='지식/스킬 요구수준비교'/>|<sht:txt mid='BLANK'   mdef='희망업무2'   />", Type:"Combo"   ,    Hidden:0, Width:60 ,  Align:"Center", ColMerge:0, SaveName:"hope2Grade"   ,    KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:1 },
                {Header:"<sht:txt mid='BLANK'   mdef='지식/스킬 요구수준비교'/>|<sht:txt mid='BLANK'   mdef='희망업무3'   />", Type:"Combo"   ,    Hidden:0, Width:60 ,  Align:"Center", ColMerge:0, SaveName:"hope3Grade"   ,    KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:4000 },
                {Header:"<sht:txt mid='BLANK'   mdef='실행년도'              />|<sht:txt mid='BLANK'   mdef='실행년도'    />", Type:"Text"    ,    Hidden:1, Width:0  ,  Align:"Center", ColMerge:0, SaveName:"activeYyyy"   ,    KeyField:1, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:4 },
                {Header:"<sht:txt mid='BLANK'   mdef='반기구분'              />|<sht:txt mid='BLANK'   mdef='반기구분'    />", Type:"Text"    ,    Hidden:1, Width:0  ,  Align:"Center", ColMerge:0, SaveName:"halfGubunType",    KeyField:1, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:1 },
                {Header:"<sht:txt mid='BLANK'   mdef='사번'                  />|<sht:txt mid='BLANK'   mdef='사번'        />", Type:"Text"    ,    Hidden:1, Width:0  ,  Align:"Center", ColMerge:0, SaveName:"sabun"        ,    KeyField:1, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:13 },
                {Header:"<sht:txt mid='BLANK'   mdef='TRM코드'               />|<sht:txt mid='BLANK'   mdef='TRM코드'     />", Type:"Text"    ,    Hidden:1, Width:0  ,  Align:"Center", ColMerge:0, SaveName:"trmCd"        ,    KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10 },
                {Header:"<sht:txt mid='BLANK'   mdef='교육코드'              />|<sht:txt mid='BLANK'   mdef='교육코드'    />", Type:"Text"    ,    Hidden:1, Width:0  ,  Align:"Center", ColMerge:0, SaveName:"education"    ,    KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
                {Header:"<sht:txt mid='BLANK'   mdef='자기계발계획'          />|<sht:txt mid='BLANK'   mdef='희망교육과정'/>", Type:"Text"    ,    Hidden:0, Width:210,  Align:"Left"  , ColMerge:0, SaveName:"educationnm"  ,    KeyField:1, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10 },
                {Header:"<sht:txt mid='BLANK'   mdef='자기계발계획'          />|<sht:txt mid='BLANK'   mdef='교육시간'    />", Type:"Text"    ,    Hidden:0, Width:60 ,  Align:"Center", ColMerge:0, SaveName:"time"         ,    KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10 },
                {Header:"<sht:txt mid='BLANK'   mdef='자기계발계획'          />|<sht:txt mid='BLANK'   mdef='희망월'      />", Type:"Combo"   ,    Hidden:0, Width:40 ,  Align:"Center", ColMerge:0, SaveName:"eduPreYmd"    ,    KeyField:0, CalcLogic:"", Format:"Ymd",  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:10 },
                {Header:"<sht:txt mid='BLANK'   mdef='점수'                  />|<sht:txt mid='BLANK'   mdef='점수'        />", Type:"Text"    ,    Hidden:1, Width:0  ,  Align:"Center", ColMerge:0, SaveName:"point"        ,    KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100 },
                {Header:"<sht:txt mid='BLANK'   mdef='번호'                  />|<sht:txt mid='BLANK'   mdef='번호'        />", Type:"Text"    ,    Hidden:1, Width:0  ,  Align:"Center", ColMerge:0, SaveName:"num"          ,    KeyField:1, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:4 },
                {Header:"<sht:txt mid='BLANK'   mdef='구분'                  />|<sht:txt mid='BLANK'   mdef='구분'        />", Type:"Text"    ,    Hidden:1, Width:0  ,  Align:"Center", ColMerge:0, SaveName:"itemGubun"    ,    KeyField:1, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:4 },
                {Header:"<sht:txt mid='BLANK'   mdef='팀장확인'              />|<sht:txt mid='BLANK'   mdef='팀장확인'    />", Type:"CheckBox",    Hidden:0, Width:30 ,  Align:"Center", ColMerge:0, SaveName:"confirmStatus",    KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:4 },
            ];

            IBS_InitSheet(sheet3, initdata3);

            sheet3.SetCountPosition(0);
            sheet3.SetEditable(true);
            sheet3.SetVisible(true);

            var initdata4 = {};
            initdata4.Cfg = {SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
            initdata4.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
            initdata4.Cols = [
                {Header:"<sht:txt mid='sNo'        mdef='No'              />",  Type:"${sNoTy}", Hidden:0, Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
                {Header:"<sht:txt mid='sStatus'    mdef='상태'            />",  Type:"${sSttTy}",Hidden:1, Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
                {Header:"<sht:txt mid='sDelete V5' mdef='삭제'            />",  Type:"${sDelTy}",Hidden:1, Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0 },
                {Header:"<sht:txt mid='BLANK'      mdef='발령구분'        />",  Type:"Text" ,    Hidden:1, Width:0  ,  Align:"Center", ColMerge:0, SaveName:"approvalType",    KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
                {Header:"<sht:txt mid='BLANK'      mdef='수행여부'        />",  Type:"Text" ,    Hidden:1, Width:0  ,  Align:"Center", ColMerge:0, SaveName:"exeYn"             ,    KeyField:0, CalcLogic:"", Format:""   ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
                {Header:"<sht:txt mid='BLANK'      mdef='사원번호'        />",  Type:"Text" ,    Hidden:1, Width:0  ,  Align:"Left"  , ColMerge:0, SaveName:"sabun"             ,    KeyField:1, CalcLogic:"", Format:""   ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
                {Header:"<sht:txt mid='BLANK'      mdef='사무분담코드'    />",  Type:"Text" ,    Hidden:1, Width:0  ,  Align:"Left"  , ColMerge:0, SaveName:"workAssignCd"      ,    KeyField:1, CalcLogic:"", Format:""   ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
                {Header:"<sht:txt mid='BLANK'      mdef='사무분담일련번호'/>",  Type:"Text" ,    Hidden:1, Width:0  ,  Align:"Left"  , ColMerge:0, SaveName:"approvalSeq"       ,    KeyField:0, CalcLogic:"", Format:""   ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
                {Header:"<sht:txt mid='BLANK'      mdef='대분류코드'      />",  Type:"Text" ,    Hidden:1, Width:0  ,  Align:"Left"  , ColMerge:0, SaveName:"workAssignCdLarge" ,    KeyField:0, CalcLogic:"", Format:""   ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
                {Header:"<sht:txt mid='BLANK'      mdef='대분류'          />",  Type:"Text" ,    Hidden:0, Width:100,  Align:"Center", ColMerge:0, SaveName:"workAssignNmLarge" ,    KeyField:0, CalcLogic:"", Format:""   ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
                {Header:"<sht:txt mid='BLANK'      mdef='중분류코드'      />",  Type:"Text" ,    Hidden:1, Width:0  ,  Align:"Left"  , ColMerge:0, SaveName:"workAssignCdMiddle",    KeyField:0, CalcLogic:"", Format:""   ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
                {Header:"<sht:txt mid='BLANK'      mdef='중분류'          />",  Type:"Text" ,    Hidden:0, Width:100,  Align:"Center", ColMerge:0, SaveName:"workAssignNmMiddle",    KeyField:0, CalcLogic:"", Format:""   ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
                {Header:"<sht:txt mid='BLANK'      mdef='사무분담'        />",  Type:"Text" ,    Hidden:0, Width:150,  Align:"Left"  , ColMerge:0, SaveName:"workAssignNm"      ,    KeyField:0, CalcLogic:"", Format:""   ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
                {Header:"<sht:txt mid='BLANK'      mdef='부사무분담'      />",  Type:"Text" ,    Hidden:0, Width:250,  Align:"Left"  , ColMerge:0, SaveName:"detailNm"          ,    KeyField:0, CalcLogic:"", Format:""   ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
                {Header:"<sht:txt mid='BLANK'      mdef='수행시작일'      />",  Type:"Text" ,    Hidden:1, Width:0  ,  Align:"Center", ColMerge:0, SaveName:"stYmd"             ,    KeyField:0, CalcLogic:"", Format:"Ymd",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
                {Header:"<sht:txt mid='BLANK'      mdef='수행종료일'      />",  Type:"Text" ,    Hidden:1, Width:0  ,  Align:"Center", ColMerge:0, SaveName:"edYmd"             ,    KeyField:0, CalcLogic:"", Format:"Ymd",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
                {Header:"<sht:txt mid='BLANK'      mdef='수행기간'        />",  Type:"Text" ,    Hidden:1, Width:0  ,  Align:"Center", ColMerge:0, SaveName:"roleTerm"          ,    KeyField:0, CalcLogic:"", Format:""   ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100 },
                {Header:"<sht:txt mid='BLANK'      mdef='요청일'          />",  Type:"Text" ,    Hidden:1, Width:0  ,  Align:"Center", ColMerge:0, SaveName:"approvalReqYmd"    ,    KeyField:0, CalcLogic:"", Format:"Ymd",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
                {Header:"<sht:txt mid='BLANK'      mdef='요청사유'        />",  Type:"Text" ,    Hidden:1, Width:0  ,  Align:"Left"  , ColMerge:0, SaveName:"approvalReqMemo"   ,    KeyField:0, CalcLogic:"", Format:""   ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
                {Header:"<sht:txt mid='BLANK'      mdef='발령상태'        />",  Type:"Text" ,    Hidden:1, Width:0  ,  Align:"Center", ColMerge:0, SaveName:"approvalStatus"    ,    KeyField:0, CalcLogic:"", Format:""   ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
                {Header:"<sht:txt mid='BLANK'      mdef='발령부서코드'    />",  Type:"Text" ,    Hidden:1, Width:0  ,  Align:"Left"  , ColMerge:0, SaveName:"approvalMainOrgCd" ,    KeyField:0, CalcLogic:"", Format:""   ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
                {Header:"<sht:txt mid='BLANK'      mdef='발령부서'        />",  Type:"Text" ,    Hidden:1, Width:0  ,  Align:"Center", ColMerge:0, SaveName:"approvalMainOrgNm" ,    KeyField:0, CalcLogic:"", Format:""   ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
                {Header:"<sht:txt mid='BLANK'      mdef='발령팀코드'      />",  Type:"Text" ,    Hidden:1, Width:0  ,  Align:"Left"  , ColMerge:0, SaveName:"approvalOrgCd"     ,    KeyField:0, CalcLogic:"", Format:""   ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
                {Header:"<sht:txt mid='BLANK'      mdef='발령팀'          />",  Type:"Text" ,    Hidden:1, Width:0  ,  Align:"Center", ColMerge:0, SaveName:"approvalOrgNm"     ,    KeyField:0, CalcLogic:"", Format:""   ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
                {Header:"<sht:txt mid='BLANK'      mdef='승인자사번'      />",  Type:"Text" ,    Hidden:1, Width:0  ,  Align:"Left"  , ColMerge:0, SaveName:"approvalEmpNo"     ,    KeyField:0, CalcLogic:"", Format:""   ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
                {Header:"<sht:txt mid='BLANK'      mdef='승인자'          />",  Type:"Text" ,    Hidden:1, Width:0  ,  Align:"Center", ColMerge:0, SaveName:"approvalEmpName"   ,    KeyField:0, CalcLogic:"", Format:""   ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
                {Header:"<sht:txt mid='BLANK'      mdef='승인일'          />",  Type:"Text" ,    Hidden:1, Width:0  ,  Align:"Center", ColMerge:0, SaveName:"approvalYmd"       ,    KeyField:0, CalcLogic:"", Format:"Ymd",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
                {Header:"<sht:txt mid='BLANK'      mdef='승인반려사유'    />",  Type:"Text" ,    Hidden:1, Width:0  ,  Align:"Left"  , ColMerge:0, SaveName:"approvalReturnMemo",    KeyField:0, CalcLogic:"", Format:""   ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
                {Header:"<sht:txt mid='BLANK'      mdef='명령자사번'      />",  Type:"Text" ,    Hidden:1, Width:0  ,  Align:"Left"  , ColMerge:0, SaveName:"orderEmpNo"        ,    KeyField:0, CalcLogic:"", Format:""   ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
                {Header:"<sht:txt mid='BLANK'      mdef='명령자'          />",  Type:"Text" ,    Hidden:1, Width:0  ,  Align:"Center", ColMerge:0, SaveName:"orderEmpName"      ,    KeyField:0, CalcLogic:"", Format:""   ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
                {Header:"<sht:txt mid='BLANK'      mdef='명령일'          />",  Type:"Text" ,    Hidden:1, Width:0  ,  Align:"Center", ColMerge:0, SaveName:"orderYmd"          ,    KeyField:0, CalcLogic:"", Format:"Ymd",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
                {Header:"<sht:txt mid='BLANK'      mdef='명령반려사유'    />",  Type:"Text" ,    Hidden:1, Width:0  ,  Align:"Left"  , ColMerge:0, SaveName:"orderReturnMemo"   ,    KeyField:0, CalcLogic:"", Format:""   ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
                {Header:"<sht:txt mid='BLANK'      mdef='기술서'          />",  Type:"Image",    Hidden:0, Width:50 ,  Align:"Center", ColMerge:0, SaveName:"workNote"          ,    KeyField:0, CalcLogic:"", Format:""   ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
            ];

            IBS_InitSheet(sheet4, initdata4);

            sheet4.SetCountPosition(0);
            sheet4.SetEditable(true);
            sheet4.SetVisible(true);

            sheet4.SetImageList(0,"/common/images/icon/icon_info.png");
            sheet4.SetDataLinkMouse("workNote", 1);

            // ----------------

            var initdata5 = {};
            initdata5.Cfg = {SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
            initdata5.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
            initdata5.Cols = [
                {Header:"<sht:txt mid='sNo'     mdef='No'/>"  ,     Type:"${sNoTy}",  Hidden:Number("${sNoHdn}") , Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
                {Header:"<sht:txt mid='sStatus' mdef='상태'/>",     Type:"${sSttTy}", Hidden:Number("${sSttHdn}"), Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
                {Header:"<sht:txt mid='BLANK' mdef='활동년도'            />", Type:"Text"   , Hidden:0, Width:40 ,  Align:"Center"    , ColMerge:0, SaveName:"activeYyyy"            , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:4      },
                {Header:"<sht:txt mid='BLANK' mdef='반기구분'            />", Type:"Combo"  , Hidden:0, Width:50 ,  Align:"Center"    , ColMerge:0, SaveName:"halfGubunType"         , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:1      },
                {Header:"<sht:txt mid='BLANK' mdef='사원번호'            />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"sabun"                 , KeyField:1, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:13     },
                {Header:"<sht:txt mid='BLANK' mdef='경력목표코드'        />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"careerTargetCd"        , KeyField:1, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:22     },
                {Header:"<sht:txt mid='BLANK' mdef='이동희망업무[1순위]' />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"workAssignCd1"         , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:10     },
                {Header:"<sht:txt mid='BLANK' mdef='이동희망업무[2순위]' />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"workAssignCd2"         , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:10     },
                {Header:"<sht:txt mid='BLANK' mdef='이동희망업무[3순위]' />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"workAssignCd3"         , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:10     },
                {Header:"<sht:txt mid='BLANK' mdef='이동희망시기'        />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"moveHopeTime"          , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:10     },
                {Header:"<sht:txt mid='BLANK' mdef='이동희망사유'        />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"moveHopeCd"            , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:22     },
                {Header:"<sht:txt mid='BLANK' mdef='이동희망세부사유'    />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"moveHopeDesc"          , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:4000   },
                {Header:"<sht:txt mid='BLANK' mdef='비상대체자'          />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"mainOrgCd1"            , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:10     },
                {Header:"<sht:txt mid='BLANK' mdef='선정사유'            />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"mainOrgCd2"            , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:10     },
                {Header:"<sht:txt mid='BLANK' mdef='후임자[1순위]'       />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"mainOrgCd3"            , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:10     },
                {Header:"<sht:txt mid='BLANK' mdef='선정사유[1순위]]'    />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"mainOrgNm1"            , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:50     },
                {Header:"<sht:txt mid='BLANK' mdef='후임자[2순위]'       />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"mainOrgNm2"            , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:50     },
                {Header:"<sht:txt mid='BLANK' mdef='선정사유[2순위]'     />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"mainOrgNm3"            , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:50     },
                {Header:"<sht:txt mid='BLANK' mdef='후임자[3순위]'       />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"mainOrgCdMoveHopeTime" , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:10     },
                {Header:"<sht:txt mid='BLANK' mdef='선정사유[3순위]'     />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"mainOrgCdMoveHopeCd"   , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:22     },
                {Header:"<sht:txt mid='BLANK' mdef='발령요청일'          />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"mainOrgCdMoveHopeDesc" , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:4000   },
                {Header:"<sht:txt mid='BLANK' mdef='발령상태'            />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"transferEmpNo"         , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:13     },
                {Header:"<sht:txt mid='BLANK' mdef='승인부서코드'        />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"transferDesc"          , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:4000   },
                {Header:"<sht:txt mid='BLANK' mdef='승인부서'            />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"successorEmpNo1"       , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:13     },
                {Header:"<sht:txt mid='BLANK' mdef='승인팀코드'          />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"successorDesc1"        , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:4000   },
                {Header:"<sht:txt mid='BLANK' mdef='승인팀'              />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"successorEmpNo2"       , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:13     },
                {Header:"<sht:txt mid='BLANK' mdef='승인자사번'          />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"successorDesc2"        , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:4000   },
                {Header:"<sht:txt mid='BLANK' mdef='승인자성명'          />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"successorEmpNo3"       , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:13     },
                {Header:"<sht:txt mid='BLANK' mdef='승인일'              />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"successorDesc3"        , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:4000   },
                {Header:"<sht:txt mid='BLANK' mdef='승인일'              />", Type:"Text"   , Hidden:0, Width:80 ,  Align:"Center"    , ColMerge:0, SaveName:"approvalReqYmd"        , KeyField:0, CalcLogic:"", Format:"Ymd"        ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:10      },
                {Header:"<sht:txt mid='BLANK' mdef='승인일'              />", Type:"Combo"  , Hidden:0, Width:80 ,  Align:"Center"    , ColMerge:0, SaveName:"approvalStatus"        , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:1      },
                {Header:"<sht:txt mid='BLANK' mdef='승인일'              />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"approvalMainOrgCd"     , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:10     },
                {Header:"<sht:txt mid='BLANK' mdef='승인일'              />", Type:"Text"   , Hidden:0, Width:80 ,  Align:"Center"    , ColMerge:0, SaveName:"approvalMainOrgNm"     , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50     },
                {Header:"<sht:txt mid='BLANK' mdef='승인일'              />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"approvalOrgCd"         , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:10     },
                {Header:"<sht:txt mid='BLANK' mdef='승인일'              />", Type:"Text"   , Hidden:0, Width:80 ,  Align:"Center"    , ColMerge:0, SaveName:"approvalOrgNm"         , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10     },
                {Header:"<sht:txt mid='BLANK' mdef='승인일'              />", Type:"Text"   , Hidden:0, Width:70 ,  Align:"Center"    , ColMerge:0, SaveName:"approvalEmpNo"         , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:13     },
                {Header:"<sht:txt mid='BLANK' mdef='승인일'              />", Type:"Text"   , Hidden:0, Width:70 ,  Align:"Center"    , ColMerge:0, SaveName:"approvalEmpName"       , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:20     },
                {Header:"<sht:txt mid='BLANK' mdef='승인일'              />", Type:"Text"   , Hidden:0, Width:80 ,  Align:"Center"    , ColMerge:0, SaveName:"approvalYmd"           , KeyField:0, CalcLogic:"", Format:"Ymd"        ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:10      },
                {Header:"<sht:txt mid='BLANK' mdef='승인일'              />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"careerTargetNm"        , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100    },
                {Header:"<sht:txt mid='BLANK' mdef='승인일'              />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"careerTargetType"      , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:1      },
                {Header:"<sht:txt mid='BLANK' mdef='승인일'              />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"careerTargetDesc"      , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:4000   },
                {Header:"<sht:txt mid='BLANK' mdef='승인일'              />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"workAssignNmLarge1"    , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100    },
                {Header:"<sht:txt mid='BLANK' mdef='승인일'              />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"workAssignNmMiddle1"   , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100    },
                {Header:"<sht:txt mid='BLANK' mdef='승인일'              />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"workAssignNm1"         , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100    },
                {Header:"<sht:txt mid='BLANK' mdef='승인일'              />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"workAssignNmLarge2"    , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100    },
                {Header:"<sht:txt mid='BLANK' mdef='승인일'              />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"workAssignNmMiddle2"   , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100    },
                {Header:"<sht:txt mid='BLANK' mdef='승인일'              />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"workAssignNm2"         , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100    },
                {Header:"<sht:txt mid='BLANK' mdef='승인일'              />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"workAssignNmLarge3"    , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100    },
                {Header:"<sht:txt mid='BLANK' mdef='승인일'              />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"workAssignNmMiddle3"   , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100    },
                {Header:"<sht:txt mid='BLANK' mdef='승인일'              />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"workAssignNm3"         , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100    },
                {Header:"<sht:txt mid='BLANK' mdef='승인일'              />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"workAssignAppCnt1"     , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100    },
                {Header:"<sht:txt mid='BLANK' mdef='승인일'              />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"workAssignCurCnt1"     , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100    },
                {Header:"<sht:txt mid='BLANK' mdef='승인일'              />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"workAssignWrkExp1"     , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100    },
                {Header:"<sht:txt mid='BLANK' mdef='승인일'              />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"workAssignAppCnt2"     , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100    },
                {Header:"<sht:txt mid='BLANK' mdef='승인일'              />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"workAssignCurCnt2"     , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100    },
                {Header:"<sht:txt mid='BLANK' mdef='승인일'              />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"workAssignWrkExp2"     , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100    },
                {Header:"<sht:txt mid='BLANK' mdef='승인일'              />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"workAssignAppCnt3"     , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100    },
                {Header:"<sht:txt mid='BLANK' mdef='승인일'              />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"workAssignCurCnt3"     , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100    },
                {Header:"<sht:txt mid='BLANK' mdef='승인일'              />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"workAssignWrkExp3"     , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100    },
                {Header:"<sht:txt mid='BLANK' mdef='승인일'              />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"mainOrgAppCnt1"        , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100    },
                {Header:"<sht:txt mid='BLANK' mdef='승인일'              />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"mainOrgAppCnt2"        , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100    },
                {Header:"<sht:txt mid='BLANK' mdef='승인일'              />", Type:"Text"   , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"mainOrgAppCnt3"        , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100    },

            ];

            IBS_InitSheet(sheet5, initdata5);

            sheet5.SetCountPosition(0);
            sheet5.SetEditable(true);
            sheet5.SetVisible(true);

            $(window).smartresize(sheetResize); sheetInit();

            //fnSetCode();

            //doAction1("Search");


            parent.doAction1("Search");
        });

        function doAction(prm){

            //$('#id', parent.document)
            alert("fdsfds");
            doAction3("Search");
            doAction4("Search");
            doAction5("Search");


        }



        function fnSetCode() {
            //상하반기
            var halfGubunTypeCd     = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","D00005"), "");
            sheet1.SetColProperty("halfGubunType", 	{ComboText:halfGubunTypeCd[0], ComboCode:halfGubunTypeCd[1]} );

            var approvalStatusCd     = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","D00007"), "");
            sheet1.SetColProperty("approvalStatus", 	{ComboText:approvalStatusCd[0], ComboCode:approvalStatusCd[1]} );




        }



        function doAction3(sAction) {
            switch (sAction) {
                case "Search":
                    var nSelectRow = sheet1.GetSelectRow();
                    var param = "searchYyyy="+sheet1.GetCellValue(nSelectRow,"activeYyyy")+"&searchHalfGubunType="+sheet1.GetCellValue(nSelectRow,"halfGubunType")+"&searchSabun="+sheet1.GetCellValue(nSelectRow,"sabun");
                    sheet3.DoSearch( "${ctx}/SelfDevelopmentApp.do?cmd=getSelfSkillAndDevPlanList",param );
                    break;
                case "Save":
                    IBS_SaveName(document.srchFrm,sheet3);

                    sheet3.DoSave( "${ctx}/SelfDevelopmentApp.do?cmd=saveVacationAppEx", $("#srchFrm").serialize()); break;
                case "Down2Excel":
                    var downcol = makeHiddenSkipCol(sheet3);
                    var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
                    sheet3.Down2Excel(param);
                    break;
            }
        }

        function doAction4(sAction) {
            switch (sAction) {
                case "Search":
                    var nSelectRow = sheet1.GetSelectRow();
                    var param = "searchWorkAssignCd=&searchExeYn=Y"+"&searchSabun="+sheet1.GetCellValue(nSelectRow,"sabun");
                    sheet4.DoSearch( "${ctx}/SelfDevelopmentApp.do?cmd=getWorkAssignList",param );
                    break;
                case "Save":
                    IBS_SaveName(document.srchFrm,sheet4);
                    sheet4.DoSave( "${ctx}/SelfDevelopmentApp.do?cmd=saveVacationAppEx", $("#srchFrm").serialize()); break;
                case "Down2Excel":
                    var downcol = makeHiddenSkipCol(sheet4);
                    var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
                    sheet4.Down2Excel(param);
                    break;
            }
        }

        function doAction5(sAction) {
            switch (sAction) {
                case "Search":
                    var nSelectRow = sheet1.GetSelectRow();
                    var param = "searchYyyy="+sheet1.GetCellValue(nSelectRow,"activeYyyy")+"&searchHalfGubunType="+sheet1.GetCellValue(nSelectRow,"halfGubunType")+"&searchSabun="+sheet1.GetCellValue(nSelectRow,"sabun");
                    sheet5.DoSearch( "${ctx}/SelfDevelopmentApp.do?cmd=getSelfReportMoveHopeList",param );
                    break;
                case "Save":
                    IBS_SaveName(document.srchFrm,sheet5);
                    sheet5.DoSave( "${ctx}/SelfDevelopmentApp.do?cmd=saveVacationAppEx", $("#srchFrm").serialize()); break;
                case "Down2Excel":
                    var downcol = makeHiddenSkipCol(sheet5);
                    var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
                    sheet5.Down2Excel(param);
                    break;
            }
        }



        // 조회 후 에러 메시지
        function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
            try {
                if (Msg != "") {
                    alert(Msg);
                }

                if( sheet1.RowCount() != 0 ) {
                    var nSelectRow = sheet1.GetSelectRow()
                    $("#ApprovalReqMemo"   ).html(sheet1.GetCellValue(nSelectRow, "approvalReqMemo"   ));
                    $("#ApprovalReturnMemo").html(sheet1.GetCellValue(nSelectRow, "approvalReturnMemo"));

                    doAction3('Search');
                    doAction4('Search');
                    doAction5('Search');

                    setAuth(nSelectRow);
                }

                sheetResize();

            } catch (ex) {
                alert("OnSearchEnd Event Error : " + ex);
            }
        }

        function setAuth(nRow){

            try {

                var approvalStatus = sheet1.GetCellValue(nRow, "approvalStatus");

                // 팀장승인 상태이면 삭제 불가
                if (approvalStatus == "3" ) {

                    //sheet3.SetEditable(false);

                    $("#ApprovalReqMemo").attr("readonly",true).addClass("readonly");
                    $("#ApprovalReqMemo").removeClass("required");
                    $("#ApprovalReturnMemo").attr("readonly",true).addClass("readonly");
                    $("#ApprovalReturnMemo").removeClass("required");

                }else{
                    sheet3.SetEditable(true);

    /*                if (approvalStatus == "1") {

                    }*/
                }

            }catch (ex) {
                console.log(ex);
            }

        }

        //Tab 선택 시
        function moveTab(tabIdx){
            // 0: KPI, 1:역량, 2:평가의견
            switch(tabIdx){
                case 0: //KPI
                    $("#spanGrade1").show();  //KPI점수
                    $("#spanGrade2").hide();
                    $("#spanGrade3").hide();
                    $("#btnCompDic").hide(); //역량사전
                    break;
                case 1://역량
                    $("#spanGrade1").hide();
                    $("#spanGrade2").show(); //역량점수
                    $("#spanGrade3").hide();
                    $("#btnCompDic").show(); //역량사전

                    setTimeout(function(){setSheetSize(sheet3);}, 50);
                    break;
                case 2://평가의견
                    $("#spanGrade1").hide();
                    $("#spanGrade2").hide();
                    $("#spanGrade3").show(); //KPI점수 + 역량점수
                    $("#btnCompDic").hide(); //역량사전
                    break;
            }
        }





        function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
            try {
                // 팀장승인 상태이면 삭제 불가
                if (sheet1.GetCellValue(sheet1.GetSelectRow(), "approvalStatus") == "3" ) {
                    sheet3.SetEditable(false);
                }
            } catch (ex) {
                alert("OnSearchEnd Event Error : " + ex);
            }
        }

        function sheet5_OnSearchEnd(Code, Msg, StCode, StMsg) {
            try {

                if( sheet5.RowCount() != 0 ) {
                    $("#span_careerTargetNm").html(sheet5.GetCellValue(sheet5.GetSelectRow(), "careerTargetNm"));

                    $("#workAssignNm1Large" ).html(sheet5.GetCellValue(sheet5.GetSelectRow(), "workAssignNmLarge1"));
                    $("#workAssignNm1Middle").html(sheet5.GetCellValue(sheet5.GetSelectRow(), "workAssignNmMiddle1"));
                    $("#workAssignNm1"      ).html(sheet5.GetCellValue(sheet5.GetSelectRow(), "workAssignNm1"));

                    $("#workAssignNm2Large" ).html(sheet5.GetCellValue(sheet5.GetSelectRow(), "workAssignNmLarge2"));
                    $("#workAssignNm2Middle").html(sheet5.GetCellValue(sheet5.GetSelectRow(), "workAssignNmMiddle2"));
                    $("#workAssignNm2"      ).html(sheet5.GetCellValue(sheet5.GetSelectRow(), "workAssignNm2"));

                    $("#workAssignNm3Large" ).html(sheet5.GetCellValue(sheet5.GetSelectRow(), "workAssignNmLarge3"));
                    $("#workAssignNm3Middle").html(sheet5.GetCellValue(sheet5.GetSelectRow(), "workAssignNmMiddle3"));
                    $("#workAssignNm3"      ).html(sheet5.GetCellValue(sheet5.GetSelectRow(), "workAssignNm3"));
                }
            } catch (ex) {
                alert("OnSearchEnd Event Error : " + ex);
            }
        }


    </script>
</head>
<body class="bodywrap">
<form id="srchFrm" name="srchFrm">
    <input type="hidden" id="tabsIndex" name="tabsIndex" value="" />
</form>
<div class="wrapper">

    <div class="innertab inner" style="height:100%;">
        <div id="tabs" class="tab">
            <ul class="tab_bottom mb-8">
                <li><a href="#tabs-1" onClick="$('#tabsIndex').val('0');moveTab(0);" id="tabKpi"><tit:txt mid='BLANK' mdef='경력목표 및 이동희망업무'/></a></li>
                <li><a href="#tabs-2" onClick="$('#tabsIndex').val('1');moveTab(1);" id="tabCompetency"><tit:txt mid='BLANK' mdef='자기계발계획'/></a></li>
                <li><a href="#tabs-3" onClick="$('#tabsIndex').val('2');moveTab(2);" id="tabRemark"><tit:txt mid='BLANK' mdef='본인 및 팀장의견'/></a></li>

                <li class="ml-auto">
                    <a style="display:none;"></a>
                    <a href="javascript:doAction('GoList')"			class=" authA" id="btnList"><tit:txt mid='112846' mdef='리스트'/></a>
                    <!--
					<a href="javascript:doAction('Coaching')"		class="button authA" id="btnCoaching"><tit:txt mid='114657' mdef='코칭'/></a>
					-->
                    <!-- <a href="javascript:doAction('Info')"			class=" authA" id="btnInfo"><tit:txt mid='112497' mdef='인사정보'/></a> -->
                    <a href="javascript:doAction('CompDic')"		class=" authA" id="btnCompDic"><tit:txt mid='competencyMgr' mdef='역량사전'/></a>
                    <!-- <a href="javascript:doAction('AttFile')"		class=" authA" id="btnAttFile"><tit:txt mid='104241' mdef='첨부'/></a> -->
                    <!-- <a href="javascript:doAction('ChkReturn')"		class=" authA" id="btnReturn"><tit:txt mid='103917' mdef='반려'/></a> -->
                    <a href="javascript:doAction('ChkApp')"			class=" authA" id="btnApp"><tit:txt mid='114380' mdef='평가완료'/></a>
                    <a href="javascript:doAction1('Save')"			class="basic authA" id="btnSave"><tit:txt mid='104476' mdef='저장'/></a>
                    <a href="javascript:doAction('Down2Excel')"		class="basic authR" id="btnDown2Excel"><tit:txt mid='download' mdef='다운로드'/></a>
                    <!-- <a href="javascript:doAction('Print')"			class="basic authR" id="btnPrint"><tit:txt mid='103799' mdef='출력'/></a> -->
                </li>
            </ul>

            <div id="tabs-1" style="height:100%">
                <div  class='layout_tabs'>
                    <table border="0" cellspacing="0" cellpadding="0" class="sheet_main">

                        <colgroup>
                            <col width="50%" />
                            <col width="50%" />
                        </colgroup>

                        <tr>
                            <td class="sheet_left">
                                <div class="inner">
                                    <div class="sheet_title">
                                        <ul>
                                            <li id="txt" class="txt"><tit:txt mid='BLANK' mdef='자기신고'/></li>
                                        </ul>
                                        <br/>


                                        <table cellpadding="0" cellspacing="0" class="table">

                                            <tr>
                                                <th colspan="2" align="center" width="140">경력목표</th>
                                                <td colspan="3">&nbsp;<span id="span_careerTargetNm"></span></td>
                                            </tr>


                                            <tr>
                                                <th width="70" align="center" rowspan="4">이동희망<br>단위업무</th>
                                                <th width="70">&nbsp;</th>
                                                <th width="170" align="center"  >대분류</th>
                                                <th width="170" align="center"  >중분류</th>
                                                <th width="170" align="center"  >단위업무</th>
                                            </tr>
                                            <tr>
                                                <th width="70"   align="center"  >1순위</th>
                                                <td width="170"  align="center"  >&nbsp;<span id="workAssignNm1Large"></span></td>
                                                <td width="170"  align="center"  >&nbsp;<span id="workAssignNm1Middle"></span></td>
                                                <td width="170"  align="center"  >&nbsp;<span id="workAssignNm1"></span></td>
                                            </tr>
                                            <tr>
                                                <th width="70"   align="center"  >2순위</th>
                                                <td width="170"  align="center"  >&nbsp;<span id="workAssignNm2Large"></span></td>
                                                <td width="170"  align="center"  >&nbsp;<span id="workAssignNm2Middle"></span></td>
                                                <td width="170"  align="center"  >&nbsp;<span id="workAssignNm2"></span></td>
                                            </tr>
                                            <tr>
                                                <th width="70" 	 align="center"  >3순위</th>
                                                <td width="170"  align="center"  >&nbsp;<span id="workAssignNm3Large"></span></td>
                                                <td width="170"  align="center"  >&nbsp;<span id="workAssignNm3Middle"></span></td>
                                                <td width="170"  align="center"  >&nbsp;<span id="workAssignNm3"></span></td>
                                            </tr>
                                        </table>
                                        <div class="hide">
                                            <script type="text/javascript">createIBSheet("sheet5", "100%", "100%", "${ssnLocaleCd}"); </script>
                                        </div>


                                    </div>
                                </div>
                            </td>

                            <td class="sheet_right">
                                <div class="inner">
                                    <div class="sheet_title">
                                        <ul>
                                            <li id="txt" class="txt"><tit:txt mid='BLANK' mdef='현사무분담'/></li>
                                        </ul>
                                    </div>
                                </div>
                                <script type="text/javascript">createIBSheet("sheet4", "100%", "100%", "${ssnLocaleCd}"); </script>
                            </td>
                        </tr>

                    </table>

                </div>


            </div>
            <div id="tabs-2">
                <div  class='layout_tabs'>
                    <div class="inner">
                        <div class="sheet_title">
                            <ul>
                                <li id="txt" class="txt"><tit:txt mid='BLANK' mdef='자기계발계획 '/></li>
                            </ul>
                        </div>
                    </div>
                    <script type="text/javascript">createIBSheet("sheet3", "100%", "100%", "${ssnLocaleCd}"); </script>
                </div>
            </div>

            <div id="tabs-3">
                <div  class='layout_tabs'>

                    <br/>


                    <table border="0" cellspacing="0" cellpadding="0" class="table outer">
                        <tbody>
                        <colgroup>
                            <col width="50%"/>
                            <col width="50%"/>
                        </colgroup>
                        <tr>
                            <th class="center"><tit:txt mid='BLANK' mdef='자기계발계획 의견'/></th>
                            <th class="center"><tit:txt mid='BLANK' mdef='팀장 승인/반려 의견'/></th>
                        </tr>
                        <tr>
                            <td class="kpiCt">
                                <textarea id="ApprovalReqMemo" name="ApprovalReqMemo"  style="width:100%; height:100px;" readonly="true"></textarea>
                            </td>
                            <td>
                                <textarea id="ApprovalReturnMemo" name="ApprovalReturnMemo" style="width:100%; height:100px;" readonly="true"></textarea>
                            </td>
                        </tr>
                        </tbody>
                    </table>

                </div>
            </div>


        </div>
    </div>


</div>
</body>
</html>
