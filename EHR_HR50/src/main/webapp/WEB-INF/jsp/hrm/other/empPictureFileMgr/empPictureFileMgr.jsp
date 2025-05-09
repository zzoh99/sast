<%@page import="com.hr.common.util.fileupload.impl.FileUploadConfig"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%
    String uploadCmd = "uploadPht";
    request.setAttribute("uploadCmd", uploadCmd);

    String uploadType = "pht001";
    request.setAttribute("uploadType", uploadType);
    FileUploadConfig fConfig = new FileUploadConfig(uploadType);
    request.setAttribute("fConfig", fConfig.getPropertyByJSON());
%>
<!DOCTYPE html> <html class="hidden"><head> <title>개인사진등록여부</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript" src="/common/plugin/Fileupload/jquery/jquery.form.js"></script>
<script type="text/javascript" src="/common/plugin/Fileupload/jquery/jquery.fileupload.js"></script>

<link rel="stylesheet" type="text/css" href="/common/plugin/Fileupload/css/jquery_ui_style.css" />
<link rel="stylesheet" type="text/css" href="/common/plugin/Fileupload/css/fileuploader_style.css" />
<script type="text/javascript">
    var gPRow = "";
    var pGubun = "";

    $(function() {
        var initdata1 = {};
        initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msAll};
        initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

        initdata1.Cols = [
            {Header:"No|No",                          Type:"${sNoTy}",    Hidden:1,   Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
            {Header:"삭제|삭제",                      Type:"${sDelTy}",   Hidden:1,   Width:Number("${sDelWdt}"), Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
            {Header:"상태|상태",                      Type:"${sSttTy}",   Hidden:1,   Width:Number("${sSttWdt}"), Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
            {Header:"사진|사진",                      Type:"Image",       Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"photo",       UpdateEdit:0, ImgWidth:40, ImgHeight:60 },
            {Header:"서명|서명",                      Type:"Image",       Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"sign",        UpdateEdit:0, ImgWidth:50, ImgHeight:60 },
            {Header:"소속|소속",                      Type:"Text",        Hidden:0,   Width:150,  Align:"Left",   ColMerge:0, SaveName:"orgNm",       KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"사번|사번",                      Type:"Text",        Hidden:0,   Width:100,  Align:"Center", ColMerge:0, SaveName:"sabun",       KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"성명|성명",                      Type:"Text",        Hidden:0,   Width:100,  Align:"Center", ColMerge:0, SaveName:"name",        KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"직책|직책",                      Type:"Text",        Hidden:0,   Width:100,  Align:"Center", ColMerge:0, SaveName:"jikchakNm",   KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"직급|직급",                      Type:"Text",        Hidden:0,   Width:100,  Align:"Center", ColMerge:0, SaveName:"jikgubNm",    KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"PAYBAND|PAYBAND",              Type:"Text",        Hidden:0,   Width:100,  Align:"Center", ColMerge:0, SaveName:"jikweeNm",    KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"직군|직군",                      Type:"Text",        Hidden:0,   Width:100,  Align:"Center", ColMerge:0, SaveName:"workTypeNm",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"고용구분|고용구분",                Type:"Text",        Hidden:0,   Width:100,  Align:"Center", ColMerge:0, SaveName:"manageNm",    KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"재직구분|재직구분",                Type:"Combo",       Hidden:0,   Width:100,  Align:"Center", ColMerge:0, SaveName:"statusCd",    KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"사진\n등록|사진\n등록",	        Type:"Image",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"fileYn",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100, Cursor:"Pointer" },
            {Header:"서명\n등록여부|서명\n등록여부",  Type:"Image",       Hidden:1,   Width:50,   Align:"Center", ColMerge:0, SaveName:"signYn",      KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100, Cursor:"Pointer" },
            {Header:"사진존재여부",                   Type:"Text",        Hidden:1,   Width:100,  Align:"Center", ColMerge:0, SaveName:"fileYnVal",   KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
        ]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(true);sheet1.SetVisible(true);sheet1.SetCountPosition(4);
        sheet1.SetEditableColorDiff(0); //편집불가 상관없이 기본색상 출력

        sheet1.SetImageList(0,"/common/images/icon/icon_upload.png");
        sheet1.SetImageList(1,"/common/images/icon/icon_upload.png");

        /* 다운로드시 페이지 랜더링(화면에 올림)을 하기 위하여 자동 Row높이설정을 false로 준다. */
        sheet1.SetAutoRowHeight(0);
        sheet1.SetDataRowHeight(60);

        $("#searchPhotoYn").attr('checked', 'checked');

        var statusCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10010"), "");
        sheet1.SetColProperty("statusCd",           {ComboText:"|"+statusCd[0], ComboCode:"|"+statusCd[1]} );

        $("#searchPhotoYn").click(function() {
            doAction1("Search");
        });

        $(window).smartresize(sheetResize); sheetInit();
        doAction1("Search");
    });

    $(function() {

        $("#searchName").bind("keyup",function(event){
            if( event.keyCode == 13){
                doAction1("Search");
            }
        });

        $("#searchOrgNm").bind("keyup",function(event){
            if( event.keyCode == 13){
                doAction1("Search");
            }
        });

        $("#fileYn").bind("change",function(event){
            doAction1("Search");
        });
        $("#signYn").bind("change",function(event){
            doAction1("Search");
        });

    });

    //Sheet1 Action
    function doAction1(sAction) {
        switch (sAction) {
        case "Search":

            /* 사원리스트 조회 전 사진정보부터 이미지 리스트에 셋팅한다. */
            if($("#searchPhotoYn").is(":checked") == true){
            }
            
            sheet1.DoSearch( "${ctx}/EmpPictureRegYn.do?cmd=getEmpPictureRegYnList",$("#uploadForm").serialize() );
            break;
        case "Down2Excel":

            //if($("#searchPhotoYn").is(":checked") == true){
            //  alert("사진이 포함된 상태에서는 다운로드 하실 수 없습니다.") ;
            //  return ;
            //}

            var downcol = makeHiddenSkipCol(sheet1);
            var param  = {DownCols:downcol,SheetDesign:1,Merge:0};
            var d = new Date();
            var fName = "excel_" + d.getTime() + ".xlsx";
            sheet1.Down2Excel($.extend(param, { FileName:fName, SheetDesign:1, Merge:1 })); break;
        }
    }

    // 조회 후 에러 메시지
    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {

        try {
            if (Msg != "") {
                alert(Msg);
            }

            if($("#searchPhotoYn").is(":checked") == true){
                sheet1.SetDataRowHeight(60);
                sheet1.SetColHidden("photo", 0);
                //sheet1.SetColHidden("sign", 0);
                /*
                if(signViewYn == "Y") {
                    sheet1.SetColHidden("sign", 0);
                }
                */
            }else{
                sheet1.SetDataRowHeight(24);
                sheet1.SetColHidden("photo", 1);
                //sheet1.SetColHidden("sign", 1);
                /*
                if(signViewYn == "Y") {
                    sheet1.SetColHidden("sign", 1);
                }
                */
            }

            sheetResize();
        } catch (ex) {
            alert("OnSearchEnd Event Error : " + ex);
        }
    }

    function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {

        var colName = sheet1.ColSaveName(Col);
        var args    = new Array();

        args["sabun"]  = sheet1.GetCellValue(Row, "sabun");
        args["name"]  = sheet1.GetCellValue(Row, "name");

        if(colName == "fileYn" && Row > 1) {

            if(!isPopup()) {return;}

            pGubun = "phtRegPopup";

            url = '/Popup.do?cmd=viewPhtRegLayer';
            phtRegPopup(url, args);

        }
        if(colName == "signYn" && Row > 1) {
            if(!isPopup()) {return;}

            pGubun = "signRegPopup";

            url = '/Popup.do?cmd=viewSignRegLayer';
            signRegPopup(url, args);
        }
    }

    function phtRegPopup(pUrl, param) {

        let layerModal = new window.top.document.LayerModal({
            id : 'phtRegLayer'
            , url : pUrl
            , parameters : param
            , width : 500
            , height : 410
            , title : ' 사진등록'
            , trigger :[
                {
                    name : 'phtRegTrigger'
                    , callback : function(result){
                    }
                }
            ]
        });
        layerModal.show();
    }

    function signRegPopup(pUrl, param) {

        let layerModal = new window.top.document.LayerModal({
            id : 'signRegLayer'
            , url : pUrl
            , parameters : param
            , width : 500
            , height : 650
            , title : '서명등록'
            , trigger :[
                {
                    name : 'signRegTrigger'
                    , callback : function(result){
                    }
                }
            ]
        });
        layerModal.show();
    }

    function search(){
        currentRow = "";
        doAction1("Search");
    }

    //팝업 콜백 함수.
    function getReturnValue(rv) {

        if(pGubun == "phtRegPopup"){
            var chkVal = ajaxCall("${ctx}/ImageExistYn.do", "sabun="+sheet1.GetCellValue(gPRow,"sabun"), false);

            if($("#searchPhotoYn").is(":checked") == true){
                sheet1.SetCellValue(gPRow,"photo",sheet1.GetCellValue(gPRow,"photo")+"&temp="+secureRandom());
            }

            if(chkVal.map.exgstYn == "Y"){
                sheet1.SetCellValue(gPRow, "fileYn",1);
            }else{
                sheet1.SetCellValue(gPRow, "fileYn",0);
            }
        } else if(pGubun == "signRegPopup") {
            var chkVal = ajaxCall("${ctx}/imageSignExistYn.do", "sabun="+sheet1.GetCellValue(gPRow,"sabun"), false);

            if($("#searchPhotoYn").is(":checked") == true){
                sheet1.SetCellValue(gPRow,"sign",sheet1.GetCellValue(gPRow,"sign")+"&temp="+secureRandom());
            }

            if(chkVal.map.exgstYn == "Y"){
                sheet1.SetCellValue(gPRow, "signYn",1);
            }else{
                sheet1.SetCellValue(gPRow, "signYn",0);
            }
        }
    }

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
    <form id="uploadForm" name="uploadForm">
        <input id="fileSeq"    name="fileSeq"    type="hidden" />
        <input id="uploadType" name="uploadType" type="hidden" value="${uploadType}"/>
        <input id="uploadCmd"  name="uploadCmd"  type="hidden" value="${uploadCmd}" />
        <div class="sheet_search outer">
            <div>
            <table>
            <tr>
            	<th>소속</th>
                <td>
                    <input id="searchOrgNm" name="searchOrgNm" type="text" class="text" style="width: 65%"/>
                </td>
                <th>사번/성명</th>
                <td>
                    <input id="searchName" name="searchName" type="text" class="text"/>
                </td>
                <th>사진포함여부 </th>
                <td>  <input id="searchPhotoYn" name="searchPhotoYn" type="checkbox"  class="checkbox" /></td>
                <th>사진등록여부</th>
                <td>
                    <select id="fileYn" name="fileYn">
                        <option value="" selected>전체</option>
                        <option value="1">등록</option>
                        <option value="0">미등록</option>
                    </select>
                </td>
                <%-- 
                <th>서명등록여부</th>
                <td>
                    <select id="signYn" name="signYn">
                        <option value="" selected>전체</option>
                        <option value="1">등록</option>
                        <option value="0">미등록</option>
                    </select>
                </td>
                --%>
                <td>
                    <input id="statusCd" name="statusCd" type="radio" value="RA" checked>퇴직자 제외
                    <input id="statusCd" name="statusCd"  type="radio" value="" >퇴직자 포함
                </td>
                <td>
                    <a href="javascript:doAction1('Search');" class="button">조회</a>
                </td>               
            </tr>
            </table>
            </div>
        </div>
    </form>
    
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt">개인사진등록여부
            <!-- <font color="red">※ 파일명은 사번으로 해야 하며. 파일선택시 자동으로 업로드 됩니다.</font> -->
            </li>
			<li class="btn">
				<btn:a href="javascript:doAction1('Down2Excel')" 	css="basic authR" mid='110698' mdef="다운로드"/>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>