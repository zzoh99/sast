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
    	
		$("#searchYm").datepicker2({ymonly:true});
		$("#searchYm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		
        var initdata = {};
        initdata.Cfg = {FrozenCol:4,SearchMode:smLazyLoad,Page:100};
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata.Cols = [
            {Header:"No",         				Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
            {Header:"사진",						Type:"Image",       Hidden:0, Width:50,  Align:"Center", ColMerge:0, SaveName:"photo",       UpdateEdit:0, ImgWidth:50, ImgHeight:60 },
            {Header:"사번",         				Type:"Text",      Hidden:0,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"sabun",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },            
            {Header:"성명",         				Type:"Text", 		Hidden:0,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"name",          KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },            
            {Header:"생년월일",         			Type:"Text",      Hidden:0,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"birYmd",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"적용제외 사유",         		Type:"Text",      Hidden:0,  Width:140,   Align:"Center",  ColMerge:0,   SaveName:"outReason",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"임금지급기초일수\n(또는 시간)",     Type:"Int",    Hidden:0,  Width:150,   Align:"Center",  ColMerge:0,   SaveName:"cnt",      		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"입사/복직",         			Type:"Text",      Hidden:0,  Width:140,   Align:"Center",  ColMerge:0,   SaveName:"empHuYmd",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"퇴사/휴직",         			Type:"Text",      Hidden:0,  Width:140,   Align:"Center",  ColMerge:0,   SaveName:"retBokYmd",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"임금",         				Type:"Text",      Hidden:0,  Width:140,   Align:"Center",  ColMerge:0,   SaveName:"imgum",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"비고",         				Type:"Text",      Hidden:0,  Width:140,   Align:"Left",  ColMerge:0,   SaveName:"bigo",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"조회권한",		Type:"Text",		Hidden:1,	Width:45,			Align:"Center",	ColMerge:0,	SaveName:"authYn", UpdateEdit:0 }
            ];
        IBS_InitSheet(sheet1, initdata);
        sheet1.SetEditable("${editable}"); sheet1.SetEditableColorDiff(0); //편집불가 상관없이 기본색상 출력
		sheet1.SetVisible(true);sheet1.SetCountPosition(4);
        
		// 키업 조회
        $("#searchSabunName").bind("keyup",function(event){
            if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
        });
        $("#searchWorkCnt").bind("keyup",function(event){
            if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
        });

        $("#searchPhotoYn").click(function() {
			//doAction1("Search");
			if($("#searchPhotoYn").is(":checked") == true) {
				sheet1.SetDataRowHeight(60);
				sheet1.SetColHidden("photo", 0);
			} else {
				sheet1.SetAutoRowHeight(0);
				sheet1.SetDataRowHeight(24);
				sheet1.SetColHidden("photo", 1);
				
			}
			
			sheetResize();
		});

        /*
		if("${pictureHdn}" == "Y"){
			$("#searchPhotoYn").attr('checked', true);
		}else{
			$("#searchPhotoYn").attr('checked', false);
		}
		*/
		$("#searchPhotoYn").attr('checked', 'checked');
		/*
		$("#checkExcept1, #checkExcept2, #checkExcept3").on("click", function(e) {
			doAction1("Search");
		});		
        */
        $(window).smartresize(sheetResize); sheetInit();
        doAction1("Search");
    });

    //Sheet1 Action
    function doAction1(sAction) {
        switch (sAction) {
        case "Search":
        
			if($("#searchYm").val() == "") {
				alert("적용년월을 입력하여 주십시오.");
				return;
			}
			if($("#searchWorkCnt").val() == "") {
				alert("임금지급기초일수를 입력하여 주십시오.");
				return;
            }
			/*
			if($("#checkExcept1").is(":checked") == true){
				$("#except1").val("Y");
			}else{
				$("#except1").val("");
			}	
			
			if($("#checkExcept2").is(":checked") == true){
				$("#except2").val("Y");
			}else{
				$("#except2").val("");
			}	
			
			if($("#checkExcept3").is(":checked") == true){
				$("#except3").val("Y");
			}else{
				$("#except3").val("");
			}				
			*/
            sheet1.DoSearch( "${ctx}/GetDataList.do?cmd=getAllExepEmpLstList", $("#sendForm").serialize() ); break;
        case "Clear":       sheet1.RemoveAll(); break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param); break;	
		break;
        }
    }

    // 입력시 조건 체크
	function checkList(){
		var ch = true;
		var exit = false;
		if(exit){return false;}
			// 화면의 개별 입력 부분 필수값 체크
		$(".required").each(function(index){
			if($(this).val() == null || $(this).val() == ""){
				alert($(this).parent().prepend().find("span:first-child").text()+"은(는) 필수값입니다.");
				$(this).focus();
				ch =  false;
				return false;
			}
		});
		return ch;
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

            sheetResize();

        } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
    }
    
    
    function sheet1_OnClick(Row, Col, Value) {
        try{

        	if(sheet1.ColSaveName(Col) == "photo" || sheet1.ColSaveName(Col) == "name"){
    			
        		var authYn = sheet1.GetCellValue(Row, "authYn");
    			if(ssnSearchType =="A" ){
    				if( "${profilePopYn}"=="Y"){
    					
    					// 인사기본 팝업 
    					var url     = "${ctx}/EisEmployeePopup.do?cmd=viewEmployeeProfilePopup&authPg=R";
    		            var args    = new Array();
    		            args["sabun"]      = sheet1.GetCellValue(Row, "sabun");
    		            args["enterCd"]    = "${ssnEnterCd}";
    		            args["empName"]    = sheet1.GetCellValue(Row, "name");
    		            args["mainMenuCd"] = "240";	            
    		            args["menuCd"]     = "112";
    		            args["grpCd"]       = "${ssnGrpCd}";
    					openPopup(url,args,"1250","780");
    					
    				}else{
    					var sabun  = sheet1.GetCellValue(Row,"sabun")
    					var enterCd =$("#groupEnterCd").val();
    					goMenu(sabun, enterCd);
    				}
    			}else if(ssnSearchType == "P"){
    				profilePopup(Row);
    			}else if(ssnSearchType == "O"){
    				/*
    				if(authYn == "Y"){
    					if( "${profilePopYn}"=="Y"){
    						// 인사기본 팝업 
    						var url     = "${ctx}/EisEmployeePopup.do?cmd=viewEmployeeProfilePopup&authPg=R";
    			            var args    = new Array();
    			            args["sabun"]      = sheet1.GetCellValue(Row, "sabun");
    			            args["enterCd"]    = "${ssnEnterCd}";
    			            args["empName"]    = sheet1.GetCellValue(Row, "name");
    			            args["mainMenuCd"] = "240";	            
    			            args["menuCd"]     = "112";
    			            args["grpCd"]       = "${ssnGrpCd}";
    						openPopup(url,args,"1250","780");
    						
    					}else{
    						var sabun  = sheet1.GetCellValue(Row,"sabun")
    						var enterCd =$("#groupEnterCd").val();
    						goMenu(sabun, enterCd);
    					}
    				}else{
    					profilePopup(Row);
    				}
    				*/
    			}else{
    				profilePopup(Row);
    			}
    			
    			
    		}
        }catch(ex){alert("OnClick Event Error : " + ex);}
    }

    function getMultiSelectValue( value ) {
    	if( value == null || value == "" ) return "";
    	if (value.indexOf("m") == -1) return value+","; // 선택된 값이 한개일 경우 Dao에서 배열로 바뀌지 않아서 오류남 콤마 추가
        //return "'"+String(value).split(",").join("','")+"'";
		return value;
    }
    
    
    /**
	 * 조직원 프로필 window open event
	 */
	function profilePopup(Row){
		if(!isPopup()) {return;}
		gPRow = "";
		pGubun = "viewEmpProfile";

  		var w 		= 610;
		var h 		= 350;
		var url 	= "${ctx}/EmpProfilePopup.do?cmd=viewEmpProfile&authPg=${authPg}";
		var args 	= new Array();
		args["sabun"] 		= sheet1.GetCellValue(Row, "sabun");

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
    <form id="sendForm" name="sendForm" >
    <!-- 
		<input type="hidden" id="except1" name="except1"/>
		<input type="hidden" id="except2" name="except2"/>
		<input type="hidden" id="except3" name="except3"/>	    
     -->
    <!-- 조회조건 -->
    <div class="sheet_search outer">
            <div>
                <table>
                    <tr>
                    	<th>적용년월</th>
                        <td>
							<input id="searchYm" name ="searchYm" class="date2" type="text" value="${curSysYyyyMMHyphen}" />
						</td>
						<th>임금지급기초일수</th>
						<td>
							<input id="searchWorkCnt" name ="searchWorkCnt" type="text" class="text w20" style="padding:0 1px;" value="16" />일 미만
						</td>
						<th>사번/성명</th>
                        <td>
	                        <input id="searchSabunName" name ="searchSabunName" type="text" class="text" />
	                    </td>
                     	<td>
	                     	<input name="searchGubun" type="radio" value="C" class="searchGubun" checked style="vertical-align: middle;"/> 달력기준
							<input name="searchGubun" type="radio" value="B" class="searchGubun" style="vertical-align: middle;"/> 영업일수기준
                        </td>
						<th><tit:txt mid='112988' mdef='사진포함여부 '/></th>
                        <td>
							<input id="searchPhotoYn" name="searchPhotoYn" type="checkbox"  class="checkbox" />
						</td>
						<td><a href="javascript:doAction1('Search')" id="btnSearch" class="btn dark">조회</a></td>
						<!-- 
						<td>
							<span>제외 :
							<input id="checkExcept1" name="checkExcept1" type="checkbox"  class="checkbox" />&nbsp;휴직자
							<input id="checkExcept2" name="checkExcept2" type="checkbox"  class="checkbox" />&nbsp;등기임원
							<input id="checkExcept3" name="checkExcept3" type="checkbox"  class="checkbox" />&nbsp;인턴		
							</span>
						</td>
						 -->	                        
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
                            <li id="txt" class="txt">상시적용제외근로자명부</li>
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