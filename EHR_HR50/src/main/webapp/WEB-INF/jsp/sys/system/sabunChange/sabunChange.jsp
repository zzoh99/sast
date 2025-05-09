<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
        initdata.Cfg = {FrozenCol:4,SearchMode:smLazyLoad,Page:22, MergeSheet:msHeaderOnly}; 
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata.Cols = [
            {Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",                Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
            {Header:"<sht:txt mid='sDelete V1' mdef='삭제|삭제'/>",            Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0 },
            {Header:"<sht:txt mid='sStatus V4' mdef='상태|상태'/>",            Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
            {Header:"<sht:txt mid='proBtn' mdef='작업|작업'/>",            Type:"Html",        Hidden:0,   Width:60,   Align:"Center",   ColMerge:0, SaveName:"proBtn",     KeyField:0, Format:"",           PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='preSabun_V1' mdef='현재사번|현재사번'/>",    Type:"PopupEdit",   Hidden:0,   Width:100,  Align:"Center",   ColMerge:0, SaveName:"preSabun",   KeyField:1, Format:"",           PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='newSabun' mdef='변경사번|변경사번'/>",    Type:"Popup",       Hidden:0,   Width:100,  Align:"Center",   ColMerge:0, SaveName:"newSabun",   KeyField:1, Format:"",           PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='num' mdef='순번|순번'/>",            Type:"Text",        Hidden:1,   Width:100,  Align:"Center",   ColMerge:0, SaveName:"seq",        KeyField:0, Format:"",           PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='workDate' mdef='작업일|작업일'/>",        Type:"Date",        Hidden:0,   Width:90,   Align:"Center",   ColMerge:0, SaveName:"workDate",   KeyField:0, Format:"Ymd",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='completeYn' mdef='작업내역|완료여부'/>",    Type:"Text",        Hidden:0,   Width:60,   Align:"Center",   ColMerge:0, SaveName:"completeYn", KeyField:0, Format:"",           PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='workStTime' mdef='작업내역|시작시간'/>",    Type:"Text",        Hidden:0,   Width:130,  Align:"Center",   ColMerge:0, SaveName:"workStTime", KeyField:0, Format:"YmdHms",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='workEdTime' mdef='작업내역|종료시간'/>",    Type:"Text",        Hidden:0,   Width:130,  Align:"Center",   ColMerge:0, SaveName:"workEdTime", KeyField:0, Format:"YmdHms",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='bigo' mdef='비고|비고'/>",            Type:"Text",        Hidden:0,   Width:200,  Align:"Left",     ColMerge:0, SaveName:"bigo",       KeyField:0, Format:"",           PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1333 },
            {Header:"<sht:txt mid='errMsg' mdef='에러내역|에러내역'/>",    Type:"Text",        Hidden:0,   Width:200,  Align:"Left",     ColMerge:0, SaveName:"errMsg",     KeyField:0, Format:"",           PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1333, Wrap:1 }
        ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
        
        $("#searchCompleteYn").html("<option value=''>전체</option> <option value='Y'>Y</option> <option value='N'>N</option>");
        $("#searchCompleteYn").change(function(){
            doAction1("Search");    
        }); 
        $("#searchWorkDate").datepicker2();
        $("#searchSabun").bind("keyup",function(event){
            if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
        });
        
        $(window).smartresize(sheetResize); sheetInit();
        doAction1("Search");
    });
    
    //Sheet1 Action
    function doAction1(sAction) {
        switch (sAction) {
        case "Search":      sheet1.DoSearch( "${ctx}/SabunChange.do?cmd=getSabunChangeList", $("#srchFrm").serialize() ); break;
        case "Save":        
                            for(var r = sheet1.HeaderRows(); r<sheet1.RowCount()+sheet1.HeaderRows(); r++){
				                if(sheet1.GetCellValue(r,"sStatus") != 'R'){
                                    if(sheet1.GetCellValue(r,"preSabun") == sheet1.GetCellValue(r,"newSabun")){
                                        alert("<msg:txt mid='110354' mdef='현재사번과 변경사번은 동일 할 수 없습니다.'/>");
                                    	return;
                                    }
                                }
                            }
                            
                            IBS_SaveName(document.srchFrm,sheet1);
                            sheet1.DoSave( "${ctx}/SabunChange.do?cmd=saveSabunChange", $("#srchFrm").serialize()); break;
        case "Insert":      var lRow = sheet1.DataInsert(0);
                            sheet1.SelectCell(lRow, "preSabun"); 
                            break;
        case "Copy":        sheet1.DataCopy(); break;
        case "Clear":       sheet1.RemoveAll(); break;
        case "Down2Excel":  
            var downcol = makeHiddenSkipCol(sheet1, ['Html']);
            var param = {DownCols:downcol, SheetDesign:1, Merge:1};
            sheet1.Down2Excel(param); 
        break;
        case "LoadExcel":   var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
        }
    }
    
    // 조회 후 에러 메시지
    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
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
    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try{ 
            if (Msg != ""){ 
                alert(Msg); 
            } 
            
            for(var r = sheet1.HeaderRows(); r<sheet1.RowCount()+sheet1.HeaderRows(); r++){
                if(sheet1.GetCellValue(r,"completeYn") == 'N'){
                    sheet1.SetCellValue(r, "proBtn", '<a class="basic" href="javascript:fn_change_sabun(\''+r+'\')"><tit:txt mid='112620' mdef='변경'/></a>');
                    sheet1.SetCellValue(r, "sStatus","R");
                }
            }
            sheetResize(); 
        }catch(ex){
            alert("OnSearchEnd Event Error : " + ex); 
        }
    }
    
    
    
    
    // 저장 후 메시지
    function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try{ 
            if(Msg != ""){ 
                alert(Msg); 
            } 
            doAction1("Search");
        }catch(ex){ 
            alert("OnSaveEnd Event Error " + ex); 
        }
    }
    
    
    function fn_change_sabun(f_row){
       $("#preSabun").val(sheet1.GetCellValue(f_row,"preSabun"));
       $("#newSabun").val(sheet1.GetCellValue(f_row,"newSabun"));
       $("#pSeq").val(sheet1.GetCellValue(f_row,"seq"));
       
       
       if(confirm("사번변경 작업을 실행 하시겠습니까?")) {
            var result = ajaxCall("${ctx}/SabunChange.do?cmd=prcP_SYS_SABUN_DATA_MODIFY", $("#srchFrm").serialize(), false);

            if (result != null && result["Result"] != null && result["Result"]["Code"] != null) {
                
                if (parseInt(result["Result"]["Code"]) == null) {
                    alert("<msg:txt mid='110073' mdef='사번을 변경 하였습니다.'/>");
                } else if (result["Result"]["Message"] != null) {
                    alert(result["Result"]["Message"]);
                }
            } else {
                alert("<msg:txt mid='109624' mdef='사번변경 중 오류가 발생 했습니다.'/>");
            }
            
            doAction1("Search");
        }
       
    }
    
	//Type이 POPUP인 셀에서 팝업버튼을 눌렀을때 발생하는 이벤트
    function sheet1_OnPopupClick(Row, Col){
        try {
          var colName = sheet1.ColSaveName(Col);
          if(colName == "newSabun") {
              if(!isPopup()) {return;}
			  var title = "<tit:txt mid='113630' mdef='사번중복 조회'/>";
			  var w = 650;
			  var h = 250;
			  var url = "/SabunChange.do?cmd=viewSabunDupCheckLayer";
			  var layerModal = new window.top.document.LayerModal({
				  id : 'sabunDupCheckLayer', 
				  url : url,
				  width : w, 
				  height : h,
				  title : title,
				  trigger: [
					  {
						  name: 'sabunDupCheckLayerTrigger',
						  callback: function(rv) {
							  sheet1.SetCellValue(Row, "newSabun", rv.sabun);
						  }
					  }
				  ]
			  });
			  layerModal.show();
          }else if(colName == "preSabun"){
              if(!isPopup()) {return;}
              var layerModal = new window.top.document.LayerModal({
	      			id : 'employeeLayer', 
	      			url : '/Popup.do?cmd=viewEmployeeLayer&authPg=${authPg}',
	      			width : 840, 
	      			height : 520, 
	      			title : '사원조회', 
	      			trigger :[
	      				{
	      					name : 'employeeTrigger', 
	      					callback : function(result){
	      						sheet1.SetCellValue(Row, "preSabun", result.sabun);
	      					}
	      				}
	      			]
	      	  });
	      	  layerModal.show();
          }
        } catch(ex) { alert("OnPopupClick Event Error : " + ex); }
    }
    
</script>
</head>
<body class="hidden">
<div class="wrapper">
    <form id="srchFrm" name="srchFrm" >
        <input type="hidden" id="preSabun" name="preSabun" />
        <input type="hidden" id="newSabun" name="newSabun" />
        <input type="hidden" id="pSeq"      name="pSeq" />
        <div class="sheet_search outer">
            <div>
                <table>
                    <tr>
                    	<th><tit:txt mid='104470' mdef='사번 '/></th>
                        <td>      <input  id="searchSabun"       name ="searchSabun"      type="text" class="text" /> </td>
                        <th><tit:txt mid='112410' mdef='완료여부 '/></th>
                        <td>  <select id="searchCompleteYn"  name="searchCompleteYn"> </select></td>
                        <th><tit:txt mid='113972' mdef='작업일자 '/></th>
                        <td>  <input  id="searchWorkDate"    name ="searchWorkDate"   type="text" class="date2" /> </td>
                        <td> <btn:a href="javascript:doAction1('Search')" id="btnSearch" css="btn dark" mid='110697' mdef="조회"/> </td>
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
                            <li id="txt" class="txt"><tit:txt mid='112542' mdef='사번변경'/></li>
                            <li class="btn">
                                <a href="javascript:doAction1('Down2Excel')"    class="btn outline-gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
                                <btn:a href="javascript:doAction1('Insert')"        css="btn outline-gray authA" mid='110700' mdef="입력"/>
                                <btn:a href="javascript:doAction1('Save')"          css="btn filled authA" mid='110708' mdef="저장"/>
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
