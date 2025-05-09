<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='103841' mdef='인사기본(노사관리)'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<%-- ibSheet file 업로드용 --%>
<%@ include file="/WEB-INF/jsp/common/include/ibFileUpload.jsp"%>
<script type="text/javascript">

    var gPRow = "";
    var pGubun = "";

    $(function() {
        // 파일 업로드 초기 설정을 위한 함수 호출 initIbFileUpload(form object)
        initIbFileUpload($("#srchFrm"));

        // 파일 목록 변수의 초기화 작업 시점 정의
        // clearBeforeFunc(function object)
        // 	-> 파일 목록 변수의 초기화 작업은 매개 변수로 넘긴 함수가 호출되기 전에 전처리 단계에서 수행
        //		ex. sheet1_OnSearchEnd 를 인자로 넘긴 경우, sheet1_OnSearchEnd 함수 호출 직전 파일 목록 변수 초기화
        //	기본적으로 [sheet]_OnSearchEnd, [sheet]_OnSaveEnd 에는 필수로 적용해 주어야 함.
        sheet1_OnSearchEnd = clearBeforeFunc(sheet1_OnSearchEnd);
        sheet1_OnSaveEnd = clearBeforeFunc(sheet1_OnSaveEnd)

        var initdata1 = {};
        initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:0,Page:22,FrozenCol:5,DataRowMerge:0};
        initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

        initdata1.Cols = [
            {Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
            {Header:"<sht:txt mid='sDelete' mdef='삭제'/>",			Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0 },
            {Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
            {Header:"<sht:txt mid='photoV1' mdef='사진'/>",			Type:"Image",	Hidden:0,  	MinWidth:55, 		Align:"Center", ColMerge:0,		SaveName:"photo",			UpdateEdit:0, ImgMinWidth:50, ImgHeight:60 },
            {Header:"<sht:txt mid='sabun' mdef='사번'/>",         	Type:"Text",        Hidden:0,	Width:70,	Align:"Center", ColMerge:0, SaveName:"sabun",           KeyField:1, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='name' mdef='성명'/>",			Type:"Text",       Hidden:0,	Width:70,	Align:"Center", ColMerge:0, SaveName:"name",            KeyField:1, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:20 },
            {Header:"<sht:txt mid='orgYn' mdef='소속'/>",         	Type:"Text",        Hidden:0,	Width:120,	Align:"Center", ColMerge:0, SaveName:"orgNm",           KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='jikweeYn' mdef='직위'/>",			Type:"Combo",       Hidden:0,	Width:80,	Align:"Center", ColMerge:0, SaveName:"jikweeCd",        KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='statusNm' mdef='재직상태'/>",		Type:"Combo",       Hidden:0,	Width:50,	Align:"Center", ColMerge:0, SaveName:"statusCd",        KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"<sht:txt mid='empYmd' mdef='입사일'/>",			Type:"Date",        Hidden:0,	Width:90,	Align:"Center", ColMerge:0, SaveName:"empYmd",          KeyField:0, Format:"Ymd",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"<sht:txt mid='edateV1' mdef='퇴사일'/>",			Type:"Date",        Hidden:0,	Width:90,	Align:"Center", ColMerge:0, SaveName:"retYmd",          KeyField:0, Format:"Ymd",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"<sht:txt mid='sdateV20' mdef='위촉일'/>",			Type:"Date",        Hidden:0,	Width:100,	Align:"Center", ColMerge:0, SaveName:"sdate",           KeyField:1, Format:"Ymd",   PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='edateV12' mdef='해촉일'/>",			Type:"Date",        Hidden:0,	Width:100,	Align:"Center", ColMerge:0, SaveName:"edate",           KeyField:0, Format:"Ymd",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='nosaJikchakCd' mdef='노사직책'/>",	Type:"Combo",       Hidden:0,	Width:100,	Align:"Center", ColMerge:0, SaveName:"nosaJikchakCd",   KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:8 },
            {Header:"<sht:txt mid='bJikchakNm' mdef='노사직책'/>",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center", ColMerge:0, SaveName:"bJikchakNm",		KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:30 },
            {Header:"<sht:txt mid='bigoV2' mdef='비고'/>",			Type:"Text",        Hidden:0,	Width:150,	Align:"Left",   ColMerge:0, SaveName:"memo",            KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1300 },
            {Header:"<sht:txt mid='btnFile' mdef='첨부파일'/>",			Type:"Html",        Hidden:0,	Width:70,	Align:"Center", ColMerge:0, SaveName:"btnFile",         KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"<sht:txt mid='fileSeq' mdef='첨부번호'/>",			Type:"Text",        Hidden:1,	Width:100,	Align:"Center", ColMerge:0, SaveName:"fileSeq",         KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 }
        ];
        IBS_InitSheet(sheet1, initdata1);
        sheet1.SetEditable("${editable}");
        sheet1.SetVisible(true);
        sheet1.SetCountPosition(4);

        $("#searchFromSdate").datepicker2({startdate:"searchToSdate", onReturn: getStatusCd});
        $("#searchToSdate").datepicker2({enddate:"searchFromSdate", onReturn: getStatusCd});


        // 노사직책
		var userCd1 = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H90012"), "");
		sheet1.SetColProperty("nosaJikchakCd",      {ComboText:"|"+userCd1[0], ComboCode:"|"+userCd1[1]} );
        $("#searchNosaJikchakCd").html(userCd1[2]);
        $("#searchNosaJikchakCd").select2({placeholder:" 선택"});

        getStatusCd();

        $("#searchName, #searchNosaJikchakCd").bind("keyup",function(event){
            if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
        });

        $("#searchStatusCd").change(function(){
            doAction1("Search");
        });


		$("#searchPhotoYn").click(function() {
			doAction1("Search");
		});

		$("#searchPhotoYn").attr('checked', 'checked');
		
        $(window).smartresize(sheetResize); 
        sheetInit();
        
        doAction1("Search");
        
		//자동완성
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue){
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow, "sabun",		rv["sabun"]);
						sheet1.SetCellValue(gPRow, "name",		rv["name"]);
						sheet1.SetCellValue(gPRow, "orgNm",		rv["orgNm"]);
						sheet1.SetCellValue(gPRow, "jikweeCd",	rv["jikweeCd"]);
						sheet1.SetCellValue(gPRow, "statusCd",	rv["statusCd"]);
						sheet1.SetCellValue(gPRow, "empYmd",	rv["empYmd"]);
						sheet1.SetCellValue(gPRow, "base3Cd",	rv["base3Cd"]);
					}
				}
			]
		});		
        
    });

    function getStatusCd() {
        let baseSYmd = $("#searchFromSdate").val();
        let baseEYmd = $("#searchToSdate").val();

        var statusCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10010", baseSYmd, baseEYmd), "");
        $("#searchStatusCd").html(statusCd[2]);
        $("#searchStatusCd").select2({placeholder:" 선택"});
    }

    function getCommonCodeList() {
        let baseSYmd = $("#searchFromSdate").val();
        let baseEYmd = $("#searchToSdate").val();
        // 직위코드(H20030)
        var jikweeCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20030", baseSYmd, baseEYmd), "");
        sheet1.SetColProperty("jikweeCd", {ComboText:"|"+jikweeCd[0], ComboCode:"|"+jikweeCd[1]});

        // 재직상태코드(H10010)
        var statusCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10010", baseSYmd, baseEYmd), "");
        sheet1.SetColProperty("statusCd", {ComboText:"|"+statusCd[0], ComboCode:"|"+statusCd[1]});
    }
    //Sheet0 Action
    function doAction1(sAction) {
        switch (sAction) {
        case "Search":
            clearFileListArr('sheet1'); // 파일 목록 변수의 초기화
            getCommonCodeList();
            $("#multiStatusCd").val(getMultiSelect($("#searchStatusCd").val()));
            $("#multiNosaJikchakCd").val(getMultiSelect($("#searchNosaJikchakCd").val()));
        	sheet1.DoSearch( "${ctx}/PsnalNosaUpload.do?cmd=getPsnalNosaUploadList", $("#srchFrm").serialize() );
            break;
        case "Save":
            if(!dupChk(sheet1,"sabun|sdate", false, true)){break;}
            IBS_SaveName(document.srchFrm,sheet1);
            sheet1.DoSave( "${ctx}/PsnalNosaUpload.do?cmd=savePsnalNosaUpload", $("#srchFrm").serialize());
            break;
        case "Insert":
            var row = sheet1.DataInsert(0);
            sheet1.SetCellValue(row, "btnFile", '<btn:a css="basic" mid='attachFile' mdef="첨부"/>');
            break;
        case "Copy":
            var row = sheet1.DataCopy();
            break;
        case "Clear":
            sheet1.RemoveAll();
            break;
        case "Down2Excel":
//             var downcol = makeHiddenSkipCol(sheet1);
            var param = {DownCols:"sNo|sabun|name|orgNm|jikweeCd|statusCd|empYmd|retYmd|sdate|edate|nosaJikchakCd|memo", SheetDesign:1, Merge:1};
            sheet1.Down2Excel(param);
            break;
        case "LoadExcel":   var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params);
        //파일 첨부 시작
            break;
        case "DownTemplate":
            // 양식다운로드
            var templeteTitle1 = "업로드시 이 행은 삭제 합니다";
            templeteTitle1 += "\n위촉일, 해촉일은 하이픈('-')을 입력하여 주시기 바랍니다.(ex: 2015-12-31)";
            sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"sabun|name|sdate|edate|nosaJikchakCd|memo"
            ,TitleText:templeteTitle1,UserMerge :"0,0,1,6"
            });
            break;
        }
    }


    function sheet1_OnLoadExcel() {

        for(var r = sheet1.HeaderRows(); r<sheet1.LastRow()+sheet1.HeaderRows(); r++){

            sheet1.SetCellValue(r, "btnFile", '<btn:a css="basic" mid='attachFile' mdef="첨부"/>');
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
			}else{
				sheet1.SetAutoRowHeight(0);
				sheet1.SetDataRowHeight(24);
				sheet1.SetColHidden("photo", 1);
			}

            //파일 첨부 시작
            for(var r = sheet1.HeaderRows(); r<sheet1.LastRow()+sheet1.HeaderRows(); r++){
                if("${authPg}" == 'A'){
                    if(sheet1.GetCellValue(r,"fileSeq") == ''){
                        sheet1.SetCellValue(r, "btnFile", '<btn:a css="basic" mid='attachFile' mdef="첨부"/>');
                        sheet1.SetCellValue(r, "sStatus", 'R');
                    }else{
                        sheet1.SetCellValue(r, "btnFile", '<btn:a css="basic" mid='down2excel' mdef="다운로드"/>');
                        sheet1.SetCellValue(r, "sStatus", 'R');
                    }
                }else{
                    if(sheet1.GetCellValue(r,"fileSeq") != ''){
                        sheet1.SetCellValue(r, "btnFile", '<btn:a css="basic" mid='down2excel' mdef="다운로드"/>');
                        sheet1.SetCellValue(r, "sStatus", 'R');
                    }
                }
            }

            sheetResize();
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



    //파일 신청 시작
    function sheet1_OnClick(Row, Col, Value) {
        try{
            if(sheet1.ColSaveName(Col) == "btnFile" && Row >= sheet1.HeaderRows()){

                if(sheet1.GetCellValue(Row,"btnFile") != ""){
                    if(!isPopup()) {return;}

                    gPRow = Row;
                    pGubun = "fileMgrPopup";

                    fileMgrPopup(Row, Col);
                }
            }
        }catch(ex){alert("OnClick Event Error : " + ex);}
    }
    //파일 신청 끝

    function sheet1_OnPopupClick(Row, Col) {
        try{
            var colName = sheet1.ColSaveName(Col);
            if (Row > 0) {
                if(colName == "name") {
                    // 사원검색 팝업
                    empSearchPopup(Row, Col);
                }
            }
        }catch(ex) {alert("OnPopupClick Event Error : " + ex);}
    }


    // 사원검색 팝업
    function empSearchPopup(Row, Col) {
        var w       = 840;
        var h       = 520;
        var url     = "/Popup.do?cmd=employeePopup";
        var args    = new Array();

        gPRow  = Row;
        pGubun = "employeePopup";

        openPopup(url+"&authPg=R", args, w, h);
    }


    //팝업 콜백 함수.
    function getReturnValue(rv) {
        if(pGubun == "employeePopup"){
            sheet1.SetCellValue(gPRow, "sabun", rv["sabun"]);
            sheet1.SetCellValue(gPRow, "name", rv["name"]);

            sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"]);
            sheet1.SetCellValue(gPRow, "jikweeCd", rv["jikweeCd"]);
            sheet1.SetCellValue(gPRow, "empYmd", rv["empYmd"]);
            sheet1.SetCellValue(gPRow, "retYmd", rv["retYmd"]);
        }
    }

    // 파일첨부/다운로드 팝업
    function fileMgrPopup(Row, Col) {
        let layerModal = new window.top.document.LayerModal({
            id : 'fileMgrLayer'
            , url : '/fileuploadJFileUpload.do?cmd=viewIbFileMgrLayer&authPg=${authPg}'
            , parameters : {
                fileSeq : sheet1.GetCellValue(Row,"fileSeq"),
                fileInfo: getFileList(sheet1.GetCellValue(Row,"fileSeq")) // 파일 목록 동기화 처리를 위함
            }
            , width : 740
            , height : 520
            , title : '파일 업로드'
            , trigger :[
                {
                    name : 'fileMgrTrigger'
                    , callback : function(result){
                        addFileList(sheet1, Row, result); // 작업한 파일 목록 업데이트
                        if(result.fileCheck == "exist"){
                            sheet1.SetCellValue(gPRow, "btnFile", '<a class="basic">다운로드</a>');
                            sheet1.SetCellValue(gPRow, "fileSeq", result.fileSeq);
                        }else{
                            sheet1.SetCellValue(gPRow, "btnFile", '<a class="basic">첨부</a>');
                            sheet1.SetCellValue(gPRow, "fileSeq", "");
                        }
                    }
                }
            ]
        });
        layerModal.show();
    }
    // 파일첨부/다운로드 팝업 끝
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
    <form id="srchFrm" name="srchFrm" >
        <div class="sheet_search outer">
            <div>
                <table>
                    <tr>
                       	<th><tit:txt mid='112862' mdef='성명/사번'/></th> 
                        <td> 
                        	<input id="searchName" name ="searchName" type="text" class="text" /> 
                        </td>
                       	<th><tit:txt mid='113235' mdef='가입일'/></th> 
                        <td colspan="2"> 
                        	<input id="searchFromSdate" name ="searchFromSdate" type="text" class="date2" /> ~ <input id="searchToSdate" name ="searchToSdate" type="text" class="date2" /> 
                        </td>
                    </tr>
                    <tr>
                       	<th><tit:txt mid='114198' mdef='재직상태 '/></th>
                        <td> 
                        	<select id="searchStatusCd" name="searchStatusCd" multiple=""> 
                        	</select>
                            <input type="hidden" id="multiStatusCd" name="multiStatusCd" />
                        </td>
                        <th><tit:txt mid='113595' mdef='노사직책 '/></th>
                        <td> 
                        	<select id="searchNosaJikchakCd" name="searchNosaJikchakCd" multiple> </select>
                            <input type="hidden" id="multiNosaJikchakCd" name="multiNosaJikchakCd" />
                        </td>
                        <th><tit:txt mid='112988' mdef='사진포함여부 '/></th> 
                        <td>
                             <input id="searchPhotoYn" name="searchPhotoYn" type="checkbox"  class="checkbox" />
                        </td>
                        <td> 
                        	<btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='search' mdef="조회"/> 
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
                            <li id="txt" class="txt"><tit:txt mid='113237' mdef='노사'/></li>
                            <li class="btn">
                                <btn:a href="javascript:doAction1('Down2Excel')"    css="btn outline-gray authR" mid='download' mdef='다운로드'/>
                                <btn:a href="javascript:doAction1('DownTemplate')"  css="btn outline-gray authA" mid='down2ExcelV1' mdef="양식다운로드"/>
                                <btn:a href="javascript:doAction1('LoadExcel')"     css="btn outline-gray authA" mid='upload' mdef="업로드"/>
                                <btn:a href="javascript:doAction1('Copy')"          css="btn outline-gray authA" mid='copy' mdef="복사"/>
                                <btn:a href="javascript:doAction1('Insert')"        css="btn outline-gray authA" mid='insert' mdef="입력"/>
                                <btn:a href="javascript:doAction1('Save')"          css="btn filled authA" mid='save' mdef="저장"/>
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
