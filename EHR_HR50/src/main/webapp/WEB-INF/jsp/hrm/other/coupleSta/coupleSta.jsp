<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var ssnSearchType = "${ssnSearchType}";

    $(function() {

        var initdata = {};
        initdata.Cfg = {SearchMode:smLazyLoad, Page:22, MergeSheet:msHeaderOnly};
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata.Cols = [
            {Header:"No|No",         Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
            {Header:"남편|사진",		Type:"Image",	Hidden:0,   MinWidth:55,   Align:"Center", ColMerge:0, SaveName:"photoH",		UpdateEdit:0, ImgMinWidth:50, ImgHeight:60},            
            {Header:"남편|사번",         Type:"Text",      Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"hSabun",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },            
            {Header:"남편|성명",         Type:"Text", Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"hName",          KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"남편|소속",         Type:"Text",      Hidden:0,  Width:150,   Align:"Center",  ColMerge:0,   SaveName:"hOrgNm",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"남편|직위",         Type:"Text",     Hidden:0,  Width:90,   Align:"Center",  ColMerge:0,   SaveName:"hJikweeNm",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"남편|직책",         Type:"Text",     Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"hJikchakNm",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },            
            {Header:"남편|직급",         Type:"Text",     Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"hJikgubNm",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"남편|재직여부",     Type:"Text",     Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"hJaejikNm",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"남편|결혼일",       Type:"Date",     Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"wedYmd",      KeyField:0,   CalcLogic:"",   Format:"Ymd",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },

            {Header:"부인|사진",		Type:"Image",	Hidden:0,   MinWidth:55,   Align:"Center", ColMerge:0, SaveName:"photoW",		UpdateEdit:0, ImgMinWidth:50, ImgHeight:60 ,  Cursor:"Pointer"},
            {Header:"부인|회사명",         Type:"Text",      Hidden:0,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"wEnterNm",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"부인|사번",         Type:"Text",      Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"wSabun",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
            {Header:"부인|성명",         Type:"Text", Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"wName",          KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"부인|소속",         Type:"Text",      Hidden:0,  Width:150,   Align:"Center",  ColMerge:0,   SaveName:"wOrgNm",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"부인|직위",         Type:"Text",     Hidden:0,  Width:90,   Align:"Center",  ColMerge:0,   SaveName:"wJikweeNm",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"부인|직책",         Type:"Text",     Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"wJikchakNm",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },            
            {Header:"부인|직급",         Type:"Text",     Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"wJikgubNm",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"부인|재직여부",     Type:"Text",     Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"wJaejikNm",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"조회권한",		Type:"Text",		Hidden:1,	Width:45,			Align:"Center",	ColMerge:0,	SaveName:"authYnW", UpdateEdit:0 },
            {Header:"조회권한",		Type:"Text",		Hidden:1,	Width:45,			Align:"Center",	ColMerge:0,	SaveName:"authYnH", UpdateEdit:0 }
			
            ];
        IBS_InitSheet(sheet1, initdata);
        sheet1.SetEditable("${editable}"); sheet1.SetEditableColorDiff(0); //편집불가 상관없이 기본색상 출력
		sheet1.SetVisible(true);sheet1.SetCountPosition(4);
        
		// 키업 조회
        $("#searchSabunName").bind("keyup",function(event){
            if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
        });

        // 사진포함여부
        $("#searchPhotoYn").on("click", function(e) {
			//doAction1("Search");
			
        	if($("#searchPhotoYn").is(":checked") == true) {
        		
				sheet1.SetDataRowHeight(60);
                sheet1.SetColHidden("photoH", 0);
                sheet1.SetColHidden("photoW", 0);
			} else {
				
				sheet1.SetAutoRowHeight(0);
				sheet1.SetDataRowHeight(24);
                sheet1.SetColHidden("photoH", 1);
                sheet1.SetColHidden("photoW", 1);
			}

            sheetResize();
		});
		
		/*
     	// 사진포함 보여주기
		if("${pictureHdn}" == "Y"){
			$("#searchPhotoYn").attr('checked', true);
		}else{
			$("#searchPhotoYn").attr('checked', false);
		}
		*/
		$("#searchPhotoYn").attr('checked', 'checked');
        
        $(window).smartresize(sheetResize); sheetInit();
        doAction1("Search");       

    });

    //Sheet1 Action
    function doAction1(sAction) {
        switch (sAction) {
        case "Search":	
            sheet1.DoSearch( "${ctx}/GetDataList.do?cmd=getCoupleStaList", $("#srchFrm").serialize() ); break;
        case "Clear":       sheet1.RemoveAll(); break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param); break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;	
		break;
        }
    }

    // 조회 후 에러 메시지
    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
    	
        try {
            if (Msg != "") {
                alert(Msg);
            }

			if($("#searchPhotoYn").is(":checked") == true) {
				sheet1.SetDataRowHeight(60);
                sheet1.SetColHidden("photoH", 0);
                sheet1.SetColHidden("photoW", 0);
			} else {
				sheet1.SetAutoRowHeight(0);
				sheet1.SetDataRowHeight(24);
                sheet1.SetColHidden("photoH", 1);
                sheet1.SetColHidden("photoW", 1);
			}

            sheetResize();

        } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
    }
    

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		//팝업
			
		if(sheet1.ColSaveName(Col) == "photoH" || sheet1.ColSaveName(Col) == "hName"){
			var authYnH = sheet1.GetCellValue(Row, "authYnH");
			if(ssnSearchType =="A" ){
				
				if( "${profilePopYn}"=="Y"){
					// 인사기본 팝업 
					var url     = "${ctx}/EisEmployeePopup.do?cmd=viewEmployeeProfilePopup&authPg=R";
		            var args    = new Array();
		            args["sabun"]      = sheet1.GetCellValue(Row, "hSabun");
		            args["enterCd"]    = "${ssnEnterCd}";
		            args["empName"]    = sheet1.GetCellValue(Row, "hName");
		            args["mainMenuCd"] = "240";	            
		            args["menuCd"]     = "112";
		            args["grpCd"]       = "${ssnGrpCd}";
					openPopup(url,args,"1250","780");
					
				}else{
					var sabun  = sheet1.GetCellValue(Row,"hSabun");
					var enterCd ="${ssnEnterCd}";
					goMenu(sabun, enterCd);
				}
			}else if(ssnSearchType == "P"){
				var sabun  = sheet1.GetCellValue(Row,"hSabun");
				profilePopup(sabun);
			}else if(ssnSearchType == "O"){
				
				if(authYnH == "Y"){
					
					if( "${profilePopYn}"=="Y"){
						// 인사기본 팝업 
						var url     = "${ctx}/EisEmployeePopup.do?cmd=viewEmployeeProfilePopup&authPg=R";
			            var args    = new Array();
			            args["sabun"]      = sheet1.GetCellValue(Row, "hSabun");
			            args["enterCd"]    = "${ssnEnterCd}";
			            args["empName"]    = sheet1.GetCellValue(Row, "hName");
			            args["mainMenuCd"] = "240";	            
			            args["menuCd"]     = "112";
			            args["grpCd"]       = "${ssnGrpCd}";
						openPopup(url,args,"1250","780");
						
					}else{
						var sabun  = sheet1.GetCellValue(Row,"hSabun");
						var enterCd ="${ssnEnterCd}";
						goMenu(sabun, enterCd);
					}
				}else{
					var sabun  = sheet1.GetCellValue(Row,"hSabun");
					profilePopup(sabun);
				}
			}else{
				var sabun  = sheet1.GetCellValue(Row,"hSabun");
				profilePopup(sabun);
			}
			
		}
		if(sheet1.ColSaveName(Col) == "photoW" || sheet1.ColSaveName(Col) == "wName"){
			var authYnW = sheet1.GetCellValue(Row, "authYnW");
			if(ssnSearchType =="A" ){
				if( "${profilePopYn}"=="Y"){
					// 인사기본 팝업 
					var url     = "${ctx}/EisEmployeePopup.do?cmd=viewEmployeeProfilePopup&authPg=R";
		            var args    = new Array();
		            args["sabun"]      = sheet1.GetCellValue(Row, "wSabun");
		            args["enterCd"]    = "${ssnEnterCd}";
		            args["empName"]    = sheet1.GetCellValue(Row, "wName");
		            args["mainMenuCd"] = "240";	            
		            args["menuCd"]     = "112";
		            args["grpCd"]       = "${ssnGrpCd}";
					openPopup(url,args,"1250","780");
					
				}else{
					var sabun  = sheet1.GetCellValue(Row,"wSabun");
					var enterCd ="${ssnEnterCd}";
					goMenu(sabun, enterCd);
				}
			}else if(ssnSearchType == "P"){
				
				var sabun  = sheet1.GetCellValue(Row,"wSabun");
				profilePopup(sabun);
				
			}else if(ssnSearchType == "O"){
				/*
				if(authYnW == "Y"){
					if( "${profilePopYn}"=="Y"){
						// 인사기본 팝업 
						var url     = "${ctx}/EisEmployeePopup.do?cmd=viewEmployeeProfilePopup&authPg=R";
			            var args    = new Array();
			            args["sabun"]      = sheet1.GetCellValue(Row, "wSabun");
			            args["enterCd"]    = "${ssnEnterCd}";
			            args["empName"]    = sheet1.GetCellValue(Row, "wName");
			            args["mainMenuCd"] = "240";	            
			            args["menuCd"]     = "112";
			            args["grpCd"]       = "${ssnGrpCd}";
						openPopup(url,args,"1250","780");
						
					}else{
						var sabun  = sheet1.GetCellValue(Row,"wSabun");
						var enterCd ="${ssnEnterCd}";
						goMenu(sabun, enterCd);
					}
				}else{
					var sabun  = sheet1.GetCellValue(Row,"wSabun");
					profilePopup(sabun);	
				}
				*/
			}else{
				var sabun  = sheet1.GetCellValue(Row,"wSabun");
				profilePopup(sabun);
			}
			
		}
	}

	/**
	 * 조직원 프로필 window open event
	 */
	function profilePopup(sabun){
		if(!isPopup()) {return;}
		gPRow = "";
		pGubun = "viewEmpProfile";

  		var w 		= 610;
		var h 		= 350;
		var url 	= "${ctx}/EmpProfilePopup.do?cmd=viewEmpProfile&authPg=${authPg}";
		var args 	= new Array();
		args["sabun"] 		= sabun //sheet1.GetCellValue(Row, "sabun");

		var rv = openPopup(url,args,w,h);

	}

	// 비교대상 화면으로 이동
	function goMenu(sabun, enterCd) {

        //비교대상 정보 쿠키에 담아 관리
        var paramObj = [{"key":"searchSabun", "value":sabun},{"key":"searchEnterCd", "value":enterCd}];

        //var prgCd = "View.do?cmd=viewPsnalBasicInf";
        var prgCd = "PsnalBasicInf.do?cmd=viewPsnalBasicInf";
        var location = "인사관리 > 인사정보 > 인사기본";


        var $form = $('<form></form>');
        $form.appendTo('body');
        var param1 	= $('<input name="prgCd" 	type="hidden" 	value="'+prgCd+'">');
        var param2 	= $('<input name="goMenu" 	type="hidden" 	value="Y">');
        $form.append(param1).append(param2);

    	var prgData = ajaxCall("${ctx}/OrgPersonSta.do?cmd=getCompareEmpOpenPrgMap",$form.serialize(),false);

    	if(prgData.map == null) {
			alert("<msg:txt mid='109611' mdef='권한이 없거나 존재하지 않는 메뉴입니다.'/>");
			return;
		}

    	var lvl 		= prgData.map.lvl;
    	var menuId		= prgData.map.menuId;
		var menuNm 		= prgData.map.menuNm;
		var menuNmPath	= prgData.map.menuNmPath;
		var prgCd 		= prgData.map.prgCd;
		var mainMenuNm 	= prgData.map.mainMenuNm;
		var surl      	= prgData.map.surl;
		parent.openContent(menuNm,prgCd,location,surl,menuId,paramObj);
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
    <form id="srchFrm" name="srchFrm" >
    <!-- 조회조건 -->
        <div class="sheet_search outer">
            <div>
                <table>
                    <tr>
                    	<th>사번/성명</th>
                        <td>
	                        <input id="searchSabunName" name ="searchSabunName" type="text" class="text" />
	                    </td>
	                    <th>재직구분</th>
                        <td>
                            <select id="searchJaejikGubun" name ="searchJaejikGubun" class="box" onchange="javascript:doAction1('Search');">
                            	<option value="" selected>전체</option>
                                <option value="A">전체재직</option>
                                <option value="H" >남편재직</option>
                                <option value="W" >부인재직</option>
                            </select>                         
                        </td>
                        <th><tit:txt mid='112988' mdef='사진포함여부 '/></th>
                        <td>
                            <input id="searchPhotoYn" name="searchPhotoYn" type="checkbox" class="checkbox"/>
                        </td>
                        <td><a href="javascript:doAction1('Search')" id="btnSearch" class="btn dark">조회</a></td>
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
                            <li id="txt" class="txt">사내혼인현황</li>
                            <li class="btn">
                                <a href="javascript:doAction1('Down2Excel')" class="btn outline-gray authR">다운로드</a>
                            </li>
                        </ul>
                    </div>
                </div>
                <script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
            </td>
        </tr>
    </table>
</div>
</body>
</html>