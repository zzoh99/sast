<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head></head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='jobScheme' mdef='직무분류표 조회'/></title>
<script type="text/javascript">
    var arg = null;
    $(function() {
        const modal = window.top.document.LayerModalUtility.getModal('jobSchemeLayer');
        arg = {  searchJobType: modal.parameters.searchJobType };

        var detailHidden = modal.parameters.detailHidden != null ? modal.parameters.detailHidden : 0;

        createIBSheet3(document.getElementById('jobSchemeLayerSht-wrap'), "jobSchemeLayerSht", "100%", "100%", "${ssnLocaleCd}");
        //배열 선언
        var initdata = {};
        //SetConfig
        initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:6, DataRowMerge:0, ChildPage:5, AutoFitColWidth:'init|search|resize|rowtransaction'};
        //HeaderMode
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        //InitColumns + Header Title
        initdata.Cols = [
                {Header:"<sht:txt mid='sNo' mdef='No'/>",         Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
                {Header:"<sht:txt mid='detailV5' mdef='직무\n기술서'/>",    Type:"Image",     Hidden:detailHidden,  Width:50,   Align:"Center",      ColMerge:0,   SaveName:"detail",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10,    Cursor:"Pointer" },
                {Header:"<sht:txt mid='priorJobCd' mdef='직무상위코드'/>",        Type:"Text",      Hidden:1,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"priorJobCd",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
                {Header:"<sht:txt mid='jobCdV1' mdef='직무코드'/>",        Type:"Text",      Hidden:1,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"jobCd",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
                {Header:"<sht:txt mid='jobNmV2' mdef='직무명'/>",            Type:"Text",      Hidden:0,  Width:250,  Align:"Left",        ColMerge:0,   SaveName:"jobNm",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100,    TreeCol:1,  LevelSaveName:"sLevel" },
                {Header:"<sht:txt mid='jobEngNm' mdef='직무명(영문)'/>",     Type:"Text",      Hidden:1,  Width:0,       Align:"Left",        ColMerge:0,   SaveName:"jobEngNm",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                {Header:"<sht:txt mid='jobType' mdef='직무형태'/>",        Type:"Combo",     Hidden:0,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"jobType",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
                {Header:"<sht:txt mid='memoV12' mdef='개요'/>",            Type:"Text",      Hidden:1,  Width:0,       Align:"Left",        ColMerge:0,   SaveName:"memo",          KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4000 },
                {Header:"<sht:txt mid='jobDefine' mdef='직무정의'/>",        Type:"Text",      Hidden:1,  Width:0,    Align:"Left",        ColMerge:0,   SaveName:"jobDefine",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4000 },
                {Header:"<sht:txt mid='eduSYmd' mdef='시작일'/>",            Type:"Date",      Hidden:0,  Width:100,  Align:"Center",      ColMerge:0,   SaveName:"sdate",         KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
                {Header:"<sht:txt mid='eYmdV1' mdef='종료일'/>",         Type:"Date",      Hidden:0,  Width:100,  Align:"Center",      ColMerge:0,   SaveName:"edate",         KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
                {Header:"<sht:txt mid='jikgubReq' mdef='직급요건'/>",          Type:"Combo",     Hidden:1,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"jikgubReq",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
                {Header:"<sht:txt mid='academyReq' mdef='학력요건'/>",         Type:"Combo",     Hidden:1,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"academyReq",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
                {Header:"<sht:txt mid='majorReq' mdef='전공요건'/>",         Type:"Text",      Hidden:1,  Width:0,    Align:"Left",        ColMerge:0,   SaveName:"majorReq",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                {Header:"<sht:txt mid='careerReq' mdef='경력요건'/>",          Type:"Combo",     Hidden:1,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"careerReq",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
                {Header:"<sht:txt mid='otherJobReq' mdef='경력요건(타직무)'/>", Type:"Text",      Hidden:1,  Width:0,    Align:"Left",        ColMerge:0,   SaveName:"otherJobReq",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                {Header:"<sht:txt mid='armyMemo' mdef='비고'/>",              Type:"Text",      Hidden:1,  Width:0,    Align:"Left",        ColMerge:0,   SaveName:"note",          KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4000 },
                {Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",             Type:"Int",        Hidden:1,  Width:0,    Align:"Center",      ColMerge:0,   SaveName:"seq",             KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:3 }
        ];
        IBS_InitSheet(jobSchemeLayerSht, initdata);
        jobSchemeLayerSht.SetVisible(true);
        jobSchemeLayerSht.SetCountPosition(4);
        jobSchemeLayerSht.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

        // sheet 높이 계산
        var sheetHeight = $(".modal_body").height() - $("#jobSchemeLayerShtForm").height() - $(".sheet_title").height() - 2;
        jobSchemeLayerSht.SetSheetHeight(sheetHeight);

        var jobType     = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W30010"), "");    //직무형태
        var jikgubReq     = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W30019"), "");    //직급요건
        var academyReq     = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W30018"), "");    //학력요건
        var careerReq     = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W30020"), "");    //경력요건


        jobSchemeLayerSht.SetColProperty("jobType",             {ComboText:jobType[0], ComboCode:jobType[1]} );    //직무형태
        $("#searchJobType").html(jobType[2]);
        jobSchemeLayerSht.SetColProperty("jikgubReq",             {ComboText:"|"+jikgubReq[0], ComboCode:"|"+jikgubReq[1]} );    //직급요건
        jobSchemeLayerSht.SetColProperty("academyReq",         {ComboText:"|"+academyReq[0], ComboCode:"|"+academyReq[1]} );    //학력요건
        jobSchemeLayerSht.SetColProperty("careerReq",             {ComboText:"|"+careerReq[0], ComboCode:"|"+careerReq[1]} );    //경력요건

        $(window).smartresize(sheetResize);
        sheetInit();
        $("#searchSdate").datepicker2();

        $("#searchSdate,#searchJobNm").bind("keyup",function(event){
            if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
        });
        $("#searchJobType").bind("change", function() {
            doAction1("Search");
        });

        if( arg.searchJobType != null && arg.searchJobType != "" ) {
            $("#searchJobType").val(arg.searchJobType);
        } else {
            $("#searchJobType").val(parent.$("#searchJobType2").val());
        }

        // 트리레벨 정의
        $("#btnPlus").click(function() {
            jobSchemeLayerSht.ShowTreeLevel(-1);
        });
        $("#btnStep1").click(function()    {
            jobSchemeLayerSht.ShowTreeLevel(0, 1);
        });
        $("#btnStep2").click(function()    {
            jobSchemeLayerSht.ShowTreeLevel(1,2);
        });
        $("#btnStep3").click(function()    {
            jobSchemeLayerSht.ShowTreeLevel(-1);
        });

        $("#findJob").bind("keyup",function(event){
            if( event.keyCode == 13){ findJob(); }
        });

        doAction("Search");
    });

    /*Sheet Action*/
    function doAction(sAction) {
        switch (sAction) {
        case "Search":         //조회

            jobSchemeLayerSht.DoSearch( "${ctx}/Popup.do?cmd=getJobSchemePopupList", $("#jobSchemeLayerShtForm").serialize() );
            break;
        }
    }

    //     조회 후 에러 메시지
    function jobSchemeLayerSht_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try {
            if(Msg != "") alert(Msg);
            jobSchemeLayerSht.SetRowEditable(1, false);
            sheetResize();
            findJob();
        } catch (ex) {
            alert("OnSearchEnd Event Error : " + ex);
        }
    }

    function jobSchemeLayerSht_OnDblClick(Row, Col){
        if( Row == 1 ) {
            alert("<msg:txt mid='110122' mdef='직무분류표는 선택할 수 없습니다.'/>");
            return;
        }

        const modal = window.top.document.LayerModalUtility.getModal('jobSchemeLayer');
        modal.fire('jobSchemeTrigger', {
        	priorJobCd : jobSchemeLayerSht.GetCellValue(Row, "priorJobCd")
            , jobCd : jobSchemeLayerSht.GetCellValue(Row, "jobCd")
            , jobNm : jobSchemeLayerSht.GetCellValue(Row, "jobNm")
        }).hide();
    }

    function jobSchemeLayerSht_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
        try{
            if( Row == 1 ) {
                alert("<msg:txt mid='110122' mdef='직무분류표는 선택할 수 없습니다.'/>");
                return;
            }
            if(Row > 0 && jobSchemeLayerSht.ColSaveName(Col) == "detail"){
                jobMgrPopup(Row);
            }
          }catch(ex){alert("OnClick Event Error : " + ex);}
    }

    /**
     * 직무기술서 팝업
     */
    function jobMgrPopup(Row){
        if(!isPopup()) {return;}

        var w 		= 960;
        var h 		= 720;
        var url = "/Popup.do?cmd=viewJobMgrLayer&authPg=R";
        var p = {
            jobCd : jobSchemeLayerSht.GetCellValue(Row, "jobCd")
        };

        var jobMgrLayer = new window.top.document.LayerModal({
            id: 'jobMgrLayer',
            url: url,
            parameters: p,
            width: w,
            height: h,
            title: '직무기술서',
            trigger: [
                {
                    name: 'jobMgrLayerTrigger',
                    callback: function(rv) {
                    }
                }
            ]
        });

        jobMgrLayer.show();
    }

    function findJob(){
        if($("#findJob").val() == "") return;
        var Row = 0;
        if (jobSchemeLayerSht.GetSelectRow() < jobSchemeLayerSht.LastRow()) {
            Row = jobSchemeLayerSht.FindText("jobNm", $("#findJob").val(), jobSchemeLayerSht.GetSelectRow()+1, 2,false);
        } else {
            Row = -1;
        }
        jobSchemeLayerSht.SelectCell(Row,"jobNm");
        $("#findJob").focus();
    }
</script>
</head>
<body class="bodywrap">
    <div class="wrapper modal_layer">
        <div class="modal_body">
            <form id="jobSchemeLayerShtForm" name="jobSchemeLayerShtForm" tabindex="1">
          <!-- <input type="hidden" id="searchJobType2" name="searchJobType2" value="" /> -->
                <div class="sheet_search outer">
                  <div>
                  <table>
	                  <tr>
	                      <th><tit:txt mid='104352' mdef='기준일자'/></th>
	                      <td>
	                              <input type="text" id="searchSdate" name="searchSdate" class="date2" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>"/>
	                      </td>
	                      <th>직무형태  </th>
	                      <td>
	                           <select id="searchJobType" name ="searchJobType" ></select>
	                      </td>
	                      <th><tit:txt mid='112031' mdef='직무명'/></th>
	                      <td>
	                             <input id="searchJobNm" name ="searchJobNm" type="text" class="text" />
	                         </td>
	                      <td>
	                          <btn:a href="javascript:doAction('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/>
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
                              <li id="txt" class="txt">직무분류표 조회&nbsp;
                                  <div class="util">
                                  <ul>
                                      <li    id="btnPlus"></li>
                                      <li    id="btnStep1"></li>
                                      <li    id="btnStep2"></li>
                                      <li    id="btnStep3"></li>
                                  </ul>
                                  </div>
                              </li>
                      </ul>
                      </div>
                  </div>
                    <div id="jobSchemeLayerSht-wrap"></div>
                  </td>
              </tr>
          </table>
        </div>

         <div class="modal_footer">
            <btn:a href="javascript:closeCommonLayer('jobSchemeLayer');" css="btn filled" mid='110881' mdef="닫기"/>
         </div>
    </div>
</body>
</html>

