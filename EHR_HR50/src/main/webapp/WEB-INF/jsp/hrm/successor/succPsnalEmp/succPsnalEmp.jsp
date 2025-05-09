<%@page import="com.hr.common.util.fileupload.impl.FileUploadConfig"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='104507' mdef='개인사진관리'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!-- <script src="http://malsup.github.com/jquery.form.js"></script>  -->
<script src="/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript" src="/common/plugin/Fileupload/jquery/jquery.form.js"></script>
<script type="text/javascript" src="/common/plugin/Fileupload/jquery/jquery.fileupload.js"></script>
<script src="/assets/js/utility-script.js?ver=7"></script>
<!-- Custom Theme Style -->
<link href="${ ctx }/common/css/cmpEmp/custom.min.css" rel="stylesheet">
<link href="${ ctx }/common/css/cmpEmp/isu_dashboard.css" rel="stylesheet">	

<link rel="stylesheet" type="text/css" href="/common/plugin/Fileupload/css/jquery_ui_style.css" />
<link rel="stylesheet" type="text/css" href="/common/plugin/Fileupload/css/fileuploader_style.css" />

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	var signViewYnData;
	var signViewYn = "status";
	

	$(function() {
		signViewYnData = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&searchStdCd=HRI_SIGN_VIEW_YN", "queryId=getSystemStdData",false).codeList, "");
		if(signViewYnData[0] != "") {
			if( signViewYnData[0] == "Y" ) {
				signViewYn = "0";
			} else if( signViewYnData[0] == "N" ) {
				signViewYn = "1";
			}
		}
		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,MergeSheet:0,Page:22,FrozenCol:0,DataRowMerge:0};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata2.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",	Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:50,			Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:0,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='appEnterCdV1' mdef='회사'/>",    Type:"Text",       Hidden:1,   Width:80,   Align:"Center", ColMerge:0, SaveName:"enterCd",     KeyField:0, UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='photoV1' mdef='사진'/>",			Type:"Image",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"photo", 		UpdateEdit:0, ImgWidth:40, ImgHeight:60 },
			{Header:"<sht:txt mid='signV1' mdef='서명'/>",			Type:"Image",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sign", 		UpdateEdit:0, ImgWidth:50, ImgHeight:60 },
			{Header:"회사코드",	Type:"Text",      Hidden:1,  Width:100,  Align:"Center",  	ColMerge:0,   SaveName:"enterCd",       KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='appOrgCdV5' mdef='소속코드'/>",	Type:"Text",      Hidden:1,  Width:100,  Align:"Center",  	ColMerge:0,   SaveName:"orgCd",       KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"년도",	Type:"Text",      Hidden:1,  Width:100,  Align:"Center",  	ColMerge:0,   SaveName:"yy",       KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",		Type:"Text",      Hidden:0,  Width:90,  Align:"Center",  	ColMerge:0,   SaveName:"orgNm",       KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",      Hidden:0,  Width:70,   Align:"Center",  	ColMerge:0,   SaveName:"sabun",       KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",		Type:"Text",      Hidden:0,  Width:70,   Align:"Center",  	ColMerge:0,   SaveName:"name",        KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",		    	Type:"Text",      Hidden:Number("${aliasHdn}"),  Width:70,   Align:"Center",  	ColMerge:0,   SaveName:"alias",        KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='jikchakCdV2' mdef='직책코드'/>",	Type:"Text",      Hidden:1,  Width:70,   Align:"Center",  	ColMerge:0,   SaveName:"jikchakCd",    KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",		Type:"Text",      Hidden:0,  Width:70,   Align:"Center",  	ColMerge:0,   SaveName:"jikchakNm",    KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='jikweeCdV2' mdef='직위코드'/>",	Type:"Text",      Hidden:1,  Width:70,   Align:"Center",  	ColMerge:0,   SaveName:"jikweeCd",    KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",		Type:"Text",      Hidden:Number("${jwHdn}"),  Width:70,   Align:"Center",  	ColMerge:0,   SaveName:"jikweeNm",    KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='jikgubCdV2' mdef='직급코드'/>",	Type:"Text",      Hidden:1,  Width:70,   Align:"Center",  	ColMerge:0,   SaveName:"jikgubCd",    KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",		Type:"Text",      Hidden:Number("${jgHdn}"),  Width:50,   Align:"Center",  	ColMerge:0,   SaveName:"jikgubNm",    KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"승계기준",		Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"succCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"직무체류기간", Type:"Text",   Hidden:0,   Width:80,  Align:"Center", ColMerge:0, SaveName:"careerCnt",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"인사카드",                 Type:"Image",       Hidden:0,   Width:65,   Align:"Center", ColMerge:0, SaveName:"btnEmpCard",      KeyField:0, Format:"",          PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100, Cursor:"Pointer" },
			{Header:"Talent Profile",			Type:"Image",		Hidden:0,	Width:65,	Align:"Center",	ColMerge:0,	SaveName:"btnPrt",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100, Cursor:"Pointer" },
			{Header:"의견",		Type:"Text",      Hidden:0,  Width:140,   Align:"Center",  	ColMerge:0,   SaveName:"note",    KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
	        {Header:"<sht:txt mid='btnFile'    mdef='첨부파일'/>",       Type:"Html",       Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"btnFile",     KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"<sht:txt mid='fileSeq'    mdef='첨부번호'/>",       Type:"Text",       Hidden:1,   Width:100,  Align:"Center", ColMerge:0, SaveName:"fileSeq",     KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"<sht:txt mid='statusCdV5' mdef='재직상태'/>",		Type:"Combo",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"statusCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='fileYnV1' mdef='사진\n등록'/>",	Type:"Image",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"fileYn",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100, Cursor:"Pointer" },
			{Header:"<sht:txt mid='signYnV1' mdef='서명\n등록'/>",	Type:"Image",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"signYn",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100, Cursor:"Pointer" },
			{Header:"<sht:txt mid='rk' mdef='rk'/>",                Type:"Text",    Hidden:1,   Width:0,   Align:"Center", ColMerge:0, SaveName:"rk",          KeyField:0, UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable(true);sheet2.SetVisible(true);sheet2.SetCountPosition(4);
		
		sheet2.SetEditableColorDiff(0); //편집불가 상관없이 기본색상 출력
	
	    sheet2.SetImageList(0,"/common/images/icon/icon_upload.png");
	    sheet2.SetImageList(1,"/common/images/icon/icon_popup.png");
	    sheet2.SetImageList(2,"/common/images/icon/icon_info.png");
	      
		/* 다운로드시 페이지 랜더링(화면에 올림)을 하기 위하여 자동 Row높이설정을 false로 준다. */
		sheet2.SetAutoRowHeight(0);
		sheet2.SetDataRowHeight(60);

		var statusCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10010"), "");
		sheet2.SetColProperty("statusCd", 			{ComboText:"|"+statusCd[0], ComboCode:"|"+statusCd[1]} );
		
		sheet2.SetColProperty("succCd", 			{ComboText:"|즉시대체 가능|1~2년내 대체가능", ComboCode:"|1|2"} );

		$("#statusCd").change(function() {
			doAction2("Search");
		});

		$(window).smartresize(sheetResize); sheetInit();
		//doAction1("Search");
		
		setEmpPage();
	});

	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			sheet2.DoSearch( "${ctx}/SuccPsnalEmp.do?cmd=getSuccPsnalEmpUserList",$("#mySheetForm").serialize() );

			break;
		case "Save":		
			IBS_SaveName(document.mySheetForm,sheet2);
			sheet2.DoSave( "${ctx}/SuccPsnalEmp.do?cmd=saveSuccPsnalEmpUserList", $("#mySheetForm").serialize() ); 
			break ;
		
		case "Down2Excel":

			//if($("#searchPhotoYn").is(":checked") == true){
			//	alert("<msg:txt mid='errorNotPhotoDown' mdef='사진이 포함된 상태에서는 다운로드 하실 수 없습니다.'/>") ;
			//	return ;
			//}

			var downcol = makeHiddenSkipCol(sheet2);
			//var param  = {DownCols:downcol,SheetDesign:1,Merge:0};
			var param  = {DownCols:downcol,SheetDesign:1,Merge:0,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet2.Down2Excel(param); break;
		}
	}
	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			sheetResize();
			
	         for(var i = 0; i < sheet2.RowCount(); i++) {
                var row = i+1;
                var comboItemCd = " ";
                var comboItemNm = " ";

                //파일 첨부 시작
                for(var r = sheet2.HeaderRows(); r<sheet2.RowCount()+sheet2.HeaderRows(); r++){
                    if(sheet2.GetCellValue(r,"fileSeq") == ''){
                        sheet2.SetCellValue(r, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
                        sheet2.SetCellValue(r, "sStatus", 'R');
                    }else{
                        sheet2.SetCellValue(r, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
                        sheet2.SetCellValue(r, "sStatus", 'R');
                    }
               }
           
	       }

		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			doAction2("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function sheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {

		var colName = sheet2.ColSaveName(Col);
        var args    = new Array();


        args["sabun"]  = sheet2.GetCellValue(Row, "sabun");
        args["name"]  = sheet2.GetCellValue(Row, "name");

        if(colName == "fileYn" && Row > 0) {
			if(!isPopup()) {return;}

        	gPRow = Row;
        	pGubun = "phtRegPopup";

            var win = openPopup("/Popup.do?cmd=phtRegPopup", args, "700","400");
        }
        if(colName == "signYn" && Row > 0) {
			if(!isPopup()) {return;}

        	gPRow = Row;
        	pGubun = "signRegPopup";

            var win = openPopup("/Popup.do?cmd=signRegPopup", args, "700","400");
        }
        if(colName == "btnPrt" && Row > 0) {
			if(!isPopup()) {return;}

        	gPRow = Row;
        	pGubun = "rdPopup";

            rdPopup(Row);
        }
        if(colName == "btnEmpCard" && Row > 0) {
            if(!isPopup()) {return;}

            gPRow = Row;
            //pGubun = "rdPopup";

            showRdEmpCard(Row);
        }
        if(sheet2.ColSaveName(Col) == "btnFile" && Row >= sheet2.HeaderRows()){
            var param = [];
            param["fileSeq"] = sheet2.GetCellValue(Row,"fileSeq");
            if(sheet2.GetCellValue(Row,"btnFile") != ""){
                if(!isPopup()) {return;}

                gPRow = Row;
                pGubun = "fileMgrPopup1";

                var authPgTemp="${authPg}";
                //var win = openPopup("/fileuploadJFileUpload.do?cmd=fileMgrPopup&authPg="+authPgTemp+"&uploadType=lang", param, "740","620");
                fileMgrPopup1(Row, Col);

            }

        }
	}
	
    // 파일첨부/다운로드 팝입
    function fileMgrPopup1(Row, Col) {

        let layerModal = new window.top.document.LayerModal({
              id : 'fileMgrLayer'
            , url : 'fileuploadJFileUpload.do?cmd=viewFileMgrLayer&authPg=${authPg}'
            , parameters : {
                fileSeq : sheet2.GetCellValue(Row,"fileSeq")
              }
            , width : 740
            , height : 420
            , title : '파일 업로드'
            , trigger :[
                {
                      name : 'fileMgrTrigger'
                    , callback : function(result){
                        if(result.fileCheck == "exist"){
                            sheet2.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
                            sheet2.SetCellValue(gPRow, "fileSeq", result.fileSeq);
                        }else{
                            sheet2.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
                            sheet2.SetCellValue(gPRow, "fileSeq", "");
                        }
                    }
                }
            ]
        });
        layerModal.show();
    }
    //파일 신청 끝

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

        if(pGubun == "phtRegPopup"){
            var chkVal = ajaxCall("${ctx}/ImageExistYn.do", "sabun="+sheet2.GetCellValue(gPRow,"sabun"), false);

            if($("#searchPhotoYn").is(":checked") == true){
				sheet2.SetCellValue(gPRow,"photo",sheet2.GetCellValue(gPRow,"photo")+"&temp="+secureRandom());
            }

            if(chkVal.map.exgstYn == "Y"){
            	sheet2.SetCellValue(gPRow, "fileYn",1);
            }else{
            	sheet2.SetCellValue(gPRow, "fileYn",0);
            }
        } else if(pGubun == "signRegPopup") {
            var chkVal = ajaxCall("${ctx}/imageSignExistYn.do", "sabun="+sheet2.GetCellValue(gPRow,"sabun"), false);

            if($("#searchPhotoYn").is(":checked") == true){
            	sheet2.SetCellValue(gPRow,"sign",sheet2.GetCellValue(gPRow,"sign")+"&temp="+secureRandom());
            }

            if(chkVal.map.exgstYn == "Y"){
            	sheet2.SetCellValue(gPRow, "signYn",1);
            }else{
            	sheet2.SetCellValue(gPRow, "signYn",0);
            }
        } else if(pGubun == "compareEmpPopup"){
			arrSabun = new Array();
			for (var i=0; i < Object.keys(rv).length; i++) {
				if(rv[i] != null || rv[i] != ""){
					arrSabun[i] = rv[i];
				}
			}
			
			insertPopData(arrSabun);
		}
	}
	
	function empComparePopup(){
		if(!isPopup()) {return;}

		var w 		= 1200; 
		var h 		= 650;
		var url 	= "${ctx}/CompareEmp.do?cmd=viewCompareEmpPopup&authPg=${authPg}";
		var args 	= new Array();
		
		pGubun = "compareEmpPopup";
		
		openPopup(url,args,w,h);
	}

	function insertPopData(arrSabun){

		for(var i = 0; i < arrSabun.length; i++){
			var data = ajaxCall("${ctx}/SuccPsnalEmp.do?cmd=getSuccEmpMap", "sabun=" + arrSabun[i], false);
			var row = sheet2.DataInsert(0);
			var item = data.DATA;
			
			var now  = new Date();
			sheet2.SetCellValue(row, "sabun", item.sabun);
			sheet2.SetCellValue(row, "yy",  now.getFullYear());
			sheet2.SetCellValue(row, "orgCd", $("#srchOrgCd").val());
			sheet2.SetCellValue(row, "orgNm", item.orgNm);
			sheet2.SetCellValue(row, "name", item.name);
			sheet2.SetCellValue(row, "jikweeNm", item.jikweeNm);
			sheet2.SetCellValue(row, "jikchakNm", item.jikchakNm);
			
		}
	}
	
	/**
	 * 출력 window open event
	 * 레포트 공통에 맞춘 개발 코드 템플릿
	 * by JSG
	 */
	function rdPopup(Row){
		if(!isPopup()) {return;}

		var enterCdSabun = "";
		var searchSabun = "";
		enterCdSabun += ",('" + sheet2.GetCellValue(Row,"enterCd") +"','" + sheet2.GetCellValue(Row,"sabun") + "')";
		searchSabun  += "," + sheet2.GetCellValue(Row,"sabun");
		
		if( enterCdSabun == "" ){
			alert("<msg:txt mid='109876' mdef='대상자를 선택하세요'/>");
			return;
		}
		
		var rdMrd    = "hrm/empcard/SuccessorCard.mrd";
		
		var rdTitle = "";
		var rdParam = "";

		rdTitle = "<tit:txt mid='empCard' mdef='Talent Profile'/>";

		rdParam += "["+ enterCdSabun +"] "; //회사코드, 사번
		rdParam += "[${baseURL}] ";//이미지위치---3
		rdParam += "[Y] "; //개인정보 마스킹
		rdParam += "[${ssnEnterCd}] ";
		rdParam += "[ '${ssnSabun}' ] ";//rdParam  += "["+searchSabun+"]"; // 사번list->세션사번으로 변경(2016.04.14)
		rdParam += "[${ssnLocaleCd}] ";	// 10.다국어코드
		rdParam += "['"+ searchSabun +"'] "; //사번
		
		var w		= 900;
		var h		= 1000;
		var url		= "${ctx}/RdPopup.do";
		var args	= new Array();

		args["rdTitle"] = rdTitle ;	//rd Popup제목
		args["rdMrd"] =  rdMrd;		//( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명
		args["rdParam"] = rdParam;	//rd파라매터
		args["rdParamGubun"] = "rp";//파라매터구분(rp/rv)
		args["rdToolBarYn"] = "Y" ;	//툴바여부
		args["rdZoomRatio"] = "100";//확대축소비율

		args["rdSaveYn"]	= "Y" ;//기능컨트롤_저장
		args["rdPrintYn"]	= "Y" ;//기능컨트롤_인쇄
		args["rdExcelYn"]	= "Y" ;//기능컨트롤_엑셀
		args["rdWordYn"]	= "Y" ;//기능컨트롤_워드
		args["rdPptYn"]		= "Y" ;//기능컨트롤_파워포인트
		args["rdHwpYn"]		= "Y" ;//기능컨트롤_한글
		args["rdPdfYn"]		= "Y" ;//기능컨트롤_PDF

		pGubun = "rdPopup";

		var win = openPopup(url,args,w,h);//알디출력을 위한 팝업창
	}
	
	//인사헤더에서 이름 변경 시
    function setEmpPage() {
    	$("#searchSabun").val($("#searchUserId").val());
    	doAction2("Search");
    }
	
    /**
     * 레포트 열기
     */
    function showRdEmpCard(Row){

    	/*
        let checkedRowsCount = sheet2.CheckedRows('chk');
        if(checkedRowsCount === 0){
            alert('<msg:txt mid="109876" mdef="대상자를 선택하세요" />');
            return;
        }
        */
        let searchEnterCdSabunStr = '';
        let searchSabunStr = '';
        let rkList = [];
        /*
        let checkedRows = sheet2.FindCheckedRow('chk');
        $(checkedRows.split("|")).each(function(index,value){
            searchEnterCdSabunStr += ',(\'' + sheet2.GetCellValue(value, 'enterCd') + '\',\'' + sheet2.GetCellValue(value, 'sabun') + '\')';
            searchSabunStr += ',' + sheet2.GetCellValue(value, 'sabun');
            rkList[index] = sheet2.GetCellValue(value, 'rk');
        });
        */
        
        searchEnterCdSabunStr += ',(\'' + sheet2.GetCellValue(Row, 'enterCd') + '\',\'' + sheet2.GetCellValue(Row, 'sabun') + '\')';
        searchSabunStr += ',' + sheet2.GetCellValue(Row, 'sabun');
        rkList[0] = sheet2.GetCellValue(Row, 'rk');
        
        let itemType = '2';
        let itemTypeClass = '.viewType1';
        $(".rdViewType2").each(function(index){
            if(!$(this).is(":checked")) return;
            if($(this).val() === '3'){//전체
                itemType = '1';
                itemTypeClass = '.viewType3';
            }else{//요약
                itemType = '2';
                itemTypeClass = '.viewType1';
            }
        });

        let parameters = Utils.encase(searchEnterCdSabunStr) + ' ';
        parameters += Utils.encase('${imageBaseUrl}') + ' ';//image base url
        parameters += Utils.encase(('${authPg}' === 'A') ? 'N' : 'Y') + ' ';//마스킹 여부
        parameters += Utils.encase('Y') + ' ';//hrbasic1
        parameters += Utils.encase('Y') + ' ';//hrbasic2
        parameters += Utils.encase('Y') + ' ';//발령사항
        parameters += Utils.encase('Y') + ' ';//교육사항
        parameters += Utils.encase((itemType === '1') ? 'Y' : '') + ' ';//전체발령표시여부
        parameters += Utils.encase('${ssnEnterCd}') + ' ';
        parameters += Utils.encase(' \'' + '${ssnSabun}' + '\' ') + ' ';
        parameters += Utils.encase('${ssnLocaleCd}') + ' ';
        parameters += Utils.encase('\'' + searchSabunStr + '\'') + ' ';
        parameters += Utils.encase(($(".rdViewType6", itemTypeClass).is(":checked")) ? 'Y' : 'N') + ' ';//평가
        parameters += Utils.encase(($(".rdViewType", itemTypeClass).is(":checked")) ? 'Y' : 'N') + ' ';//타부서발령여부
        parameters += Utils.encase(($(".rdViewType3", itemTypeClass).is(":checked")) ? 'Y' : 'N') + ' ';//연락처
        parameters += Utils.encase(($(".rdViewType4", itemTypeClass).is(":checked")) ? 'Y' : 'N') + ' ';//병역
        parameters += Utils.encase(($(".rdViewType5", itemTypeClass).is(":checked")) ? 'Y' : 'N') + ' ';//학력
        parameters += Utils.encase(($(".rdViewType7", itemTypeClass).is(":checked")) ? 'Y' : 'N') + ' ';//경력
        parameters += Utils.encase(($(".rdViewType8", itemTypeClass).is(":checked")) ? 'Y' : 'N') + ' ';//포상
        parameters += Utils.encase(($(".rdViewType9", itemTypeClass).is(":checked")) ? 'Y' : 'N') + ' ';//징계
        parameters += Utils.encase(($(".rdViewType10", itemTypeClass).is(":checked")) ? 'Y' : 'N') + ' ';//자격
        parameters += Utils.encase(($(".rdViewType11", itemTypeClass).is(":checked")) ? 'Y' : 'N') + ' ';//어학
        parameters += Utils.encase(($(".rdViewType12", itemTypeClass).is(":checked")) ? 'Y' : 'N') + ' ';//가족
        parameters += Utils.encase(($(".rdViewType13", itemTypeClass).is(":checked")) ? 'Y' : 'N') + ' ';//발령
        parameters += Utils.encase((itemType === '1' && $(".rdViewType14", itemTypeClass).is(":checked")) ? 'Y' : 'N') + ' ';//경력
        
        //showRdLayer 암호화로 인해 새로 파라미터 받기 
        let param = null;
        
        var maskingYn = ('${authPg}' === 'A') ? 'N' : 'Y';
        var hrAppt    =    'Y';
        var rdViewType6  = 'Y';
        var rdViewType   = 'Y';
        var rdViewType3  = 'Y';
        var rdViewType4  = 'Y';
        var rdViewType5  = 'Y';
        var rdViewType7  = 'Y';
        var rdViewType8  = 'Y';
        var rdViewType9  = 'Y';
        var rdViewType10 = 'Y';
        var rdViewType11 = 'Y';
        var rdViewType12 = 'Y';
        var rdViewType13 = 'Y';
        var rdViewType14 = 'Y';
        
        
        //암호화 할 데이터 생성
        const data = {
                  rk : rkList
                , maskingYn : maskingYn
                , hrAppt : hrAppt 
                , rdViewType6  : rdViewType6 
                , rdViewType   : rdViewType  
                , rdViewType3  : rdViewType3 
                , rdViewType4  : rdViewType4 
                , rdViewType5  : rdViewType5 
                , rdViewType7  : rdViewType7 
                , rdViewType8  : rdViewType8 
                , rdViewType9  : rdViewType9 
                , rdViewType10 : rdViewType10
                , rdViewType11 : rdViewType11
                , rdViewType12 : rdViewType12
                , rdViewType13 : rdViewType13
                , rdViewType14 : rdViewType14
        };
        window.top.showRdLayer('/SuccPsnalEmp.do?cmd=getEncryptRd', data, null, "인사카드");
        
        /*
        const result = ajaxTypeJson('/EmpCardPrt2.do?cmd=getEncryptRd', data, false);
        console.log(result.DATA.path); 
        console.log(result.DATA.encryptParameter);
        */
    }
</script>

</head>
<body class="bodywrap">
<div class="wrapper">
<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>
<form id="mySheetForm" name="mySheetForm" >
<input type="hidden" id="srchOrgCd" name="srchOrgCd">
<input type="hidden" id="searchSabun" name="searchSabun" value=""/>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<tr>
		<td class="sheet_right">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt">후보자</li>
					<li class="btn">
					    
						<!--<btn:a href="javascript:empComparePopup();"	css="basic authR" mid='' mdef="임직원 선택"/>-->
						<btn:a href="javascript:doAction2('Search')" 	css="basic authR" mid='110697' mdef="조회"/>
						<btn:a href="javascript:doAction2('Save')"  css="basic authA" mid='110708' mdef="저장"/>
						<a href="javascript:doAction2('Down2Excel')" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
					</li>
				</ul>
				</div>
			</div>

			<script type="text/javascript"> createIBSheet("sheet2", "70%", "100%", "${ssnLocaleCd}"); </script>
		</td>
		
	</tr>
	</table>
</form>
</div>
</body>
</html>
