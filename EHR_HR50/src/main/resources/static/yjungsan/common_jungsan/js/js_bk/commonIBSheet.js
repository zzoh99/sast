// Sheet 중복체크[jquery 형태로 변경해야함]
/*
function comCheckPrimaryKey(obj, keyvalue, delchk, firchk) {
	var duprows1 = obj.ColValueDupRows(keyvalue, delchk, firchk) + " ";
	if (duprows1 != "") {
		var t = [];
		var a = duprows1.split("|");
		if (a[1] != "") {
			t = a[1].split(",");
			for (j = 0; j < t.length; j++) {
				obj.SetRowBackColor(t[j], "#FF7F50");
			}
		} else {
			var j = 0;
		}
		if (j > 0) {
			alert("중복된 값이 존재 합니다.");
			return false;
		}
	} else {
		return true;
	}
}
*/
/*=======================================================================*
 * 시트 가로 사이즈 구하기
 * 2011.07.21 KSJ
 *======================================================================*/
function getWidth(obj) {
	var _w = 0;
	for( var i = 0 ; i <= obj.LastCol() ; i++ ) {
		if( !obj.GetColHidden(i) ) _w += obj.GetColWidth(i);
	}
	return _w;
}


/*=======================================================================*
 * 시트의 고정 사이즈 카운트 구하기
 * 2011.07.21 KSJ
 *======================================================================*/
function getCount(obj) {
	var _cnt = 0;
	var _w = 0;
	var _option = true;
	for( var i = 0 ; i <= obj.LastCol() ; i++ ) {
		if( obj.GetColHidden(i) == 0 ) {
		  //alert("===width : "+obj.GetColWidth(i)+", i : "+i);
			_w += obj.GetColWidth(i);
			if( _option && obj.GetColWidth(i) == 45) _cnt++;
			else _option = false;
		}
	}
	return [_cnt, _w];
}

/*=======================================================================*
 * 시트가 화면에 100% 맞도록 리사이징
 * 2011.07.21 KSJ
 *======================================================================*/
function fitWidth(obj, count) {
	try{
		var scrollWidth = 0;
		var content_height = 0;
		$("#DIV_"+obj.id).find(".GMBodyMid table").each(function() {
			content_height += $(this).height();
		});
		
		if( $("#DIV_"+obj.id).find(".GMBodyMid").height() + 1 < content_height ) scrollWidth = 18;
		var cnt = count;
		var objID = document.getElementById("DIV_"+obj.id);
		//alert( "w : " + $("#DIV_"+obj.id).parent().width() );
		var space = 0;
		//if( $(".popup_main").length > 0 ) space = 40;
		var width1 = ($("#DIV_"+obj.id).parent().width() - scrollWidth) - space;  // sheet 사이즈
		//var width1 = (document.body.clientWidth - scrollWidth) / $("#DIV_"+obj.id).attr("sheetcount") - space;  // sheet 사이즈
		//var width1 = ($("#DIV_"+obj.id).parent().width() - scrollWidth) / $("#DIV_"+obj.id).attr("sheetcount");  // sheet 사이즈
		
		var width2 = width1 - cnt * 45;     // sheet 사이즈 에서 고정 td를 뺀 길이
		var width3 = getWidth( obj );       // 실제 sheet 내부 테이블 길이
		width3 -= cnt * 45;
		
		var str = "";
		var value = 0;
		var gap = 0;
		
		var _final = 0;
		for( var i = 0 ; i <= obj.LastCol() ; i++ ) {
			if( !obj.GetColHidden(i) ) {
				_final = i;
			}
		}
		
		
		// 화면 사이즈에 맞게 늘린다.
		for( var i = 0 ; i <= obj.LastCol() ; i++ ) {
			if( !obj.GetColHidden(i) ) {
				if( i == _final ) {
					gap = width1 - value - 1;
					obj.SetColWidth(i,gap);	
				}
				else if( --cnt < 0 ) {
					str += Math.floor( (obj.GetColWidth(i) * width2) / width3 ) + "\n";
					value += Math.floor( (obj.GetColWidth(i) * width2) / width3 );
					obj.SetColWidth(i,Math.floor( (obj.GetColWidth(i) * width2) / width3 ));					
				}
				else {
					str += 45 + "\n";
					value += 45;
					obj.SetColWidth(i,45);
				}
			}
		}
	}catch (e) {
		//alert(e);
	}
}

/*=======================================================================*
 * 시트 원래 사이즈로 복귀
 * 2013.03.28 KSJ
 *======================================================================*/
function sheetSizeRestore(obj) {
	for( var i = 0 ; i <= obj.LastCol() ; i++ ) {
		if( !obj.GetColHidden(i) ) {
			obj.SetColWidth(i,sheetColumnWidth[obj.id][i]);
		}
	}
}

/*=======================================================================*
 * 시트 통합 리사이즈 함수
 * 2011.07.21 KSJ
 *======================================================================*/
var sheetWidth = {};
var sheetColumnWidth = {};
var sheetCount = {};
function setSheetSize( obj, count, init) {
	try{
		if( obj.GetVisible() == 0 ) obj.SetVisible(1);
		var objID = document.getElementById("DIV_"+obj.id);
		if( objID.clientWidth == 0 ) return;

		if( sheetWidth[obj.id] == undefined || sheetWidth[obj.id] == 0 ) {
			var ary = getCount( obj );
			if( count == undefined ) sheetCount[obj.id] = ary[0];
			else sheetCount[obj.id] = count;
			sheetWidth[obj.id] = ary[1];
			
			sheetColumnWidth[obj.id] = [];
			for( var i = 0 ; i <= obj.LastCol() ; i++ ) {
				sheetColumnWidth[obj.id][i] = obj.GetColWidth(i);
			}
		}
		
		// $(".sheet_left .GMMainTable").css("marginRight","10px");
		
		//alert("A : " + $(".ibsheet").width() + " : " + $(".GMMainTable").width() );
		//objID.clientWidth < sheetWidth[obj.id] ? obj.FitSize(false, false) : fitWidth(obj, sheetCount[obj.id]);
		objID.clientWidth < sheetWidth[obj.id] ? sheetSizeRestore(obj) : fitWidth(obj, sheetCount[obj.id]);
	}catch (e) {
		alert(e);
	}
}

function clearSheetSize( obj ) {
	sheetCount[obj.id] = null;
	sheetWidth[obj.id] = null;
}


/************************************************************************************

 getColMaxValue(mySheet, Col)			: 컬럼중 값이 가장 큰 값을 구함

*************************************************************************************/

function getColMaxValue(mySheet, Col) {
	var maxValue = 0;

	for( i=1 ; i <= mySheet.RowCount(); i++) {
		if( maxValue < parseInt(mySheet.GetCellValue(i, Col)) ) {
			maxValue = parseInt(mySheet.GetCellValue(i, Col));
		}
	}

	maxValue = maxValue + 1;
	return maxValue;
}


//SkipCol 
function makeSkipCol(sobj,cols){
	var lc = sobj.LastCol();
	var colsArr = cols.split("|");

	var rtnStr = "";
	for(var i=0;i<=lc;i++){

		if($.inArray( i +"",colsArr)== -1){
			rtnStr += "|"+ i;
		}
	}
	return rtnStr.substring(1);
}

//HiddenSkipCol 
function makeHiddenSkipCol(sobj){
	var lc = sobj.LastCol();
	var colsArr = new Array();
	for(var i=0;i<=lc;i++){
		if(1==sobj.GetColHidden(i) || sobj.GetCellProperty(0, i, "Type")== "Status" || sobj.GetCellProperty(0, i, "Type")== "DelCheck"){
			colsArr.push(i);
	}
	}

	var rtnStr = "";
	for(var i=0;i<=lc;i++){
		//alert(i +"==>>>>"+ colsArr +"==>>"+$.inArray(i, colsArr));
		if($.inArray(i,colsArr)== -1){
			rtnStr += "|"+ i;
		}
	}
	return rtnStr.substring(1);
}

/************************************************************************************
 checkDateCtl2(message, message2, sCtl, eCtl)
	:  TextField에 시작일자와 종료일자 크기를 체크
	message : 시작일자와 종료일자 앞에 붙일 메시지
	sCtl    : 시작일 칼럼명
	eCtl    : 종료일 칼럼명
*************************************************************************************/
function checkDateCtl2( message, message2, sCtl, eCtl){
	if( sCtl.value != "" && eCtl.value != "" ) {
		if( sCtl.value  > eCtl.value ) {
			alert(message+"일자가 "+message2+"일자보다 큽니다.");
			eCtl.value = "";
			eCtl.focus();
			return false;
		}
	}
	return true;
}

/************************************************************************************

checkNMDate(mySheet, row, col, message, sColNm, eColNm)
		    :  컬럼에 시작일자와 종료일자 크기를 체크
	mySheet : 시트 Object
	row     : 선택된 행
	col     : 선택된 칼럼
	message : 시작일자와 종료일자 앞에 붙일 메시지
	sColNm  : 시작일 칼럼명
	eColNm  : 종료일 칼럼명
*************************************************************************************/
function checkNMDate(mySheet, row, col, message, sColNm, eColNm){

	if( (mySheet.ColSaveName(col) == sColNm  || mySheet.ColSaveName(col) == eColNm ) && mySheet.GetCellValue(row, eColNm ) != "" ) {
		if( mySheet.GetCellValue(row, sColNm)  > mySheet.GetCellValue(row, eColNm) ) {			
			alert(message+"시작일자가 "+message+"종료일자보다 큽니다.");
			mySheet.SetCellValue(row, eColNm, "");
			mySheet.SelectCell(row, eColNm);			
			return;
		}
	}
}

/************************************************************************************
checkNMDate2(mySheet, row, col, message, sColNm, eColNm)
		    :  컬럼에 시작일자와 종료일자 크기를 체크
	mySheet : 시트 Object
	row     : 선택된 행
	col     : 선택된 칼럼
	message : 시작일자와 종료일자 앞에 붙일 메시지
	sColNm  : 시작일 칼럼명
	eColNm  : 종료일 칼럼명
*************************************************************************************/
function checkNMDate2(mySheet, row, col, message1, message2, sColNm, eColNm){
	if( (mySheet.ColSaveName(col) == sColNm  || mySheet.ColSaveName(col) == eColNm ) && mySheet.GetCellValue(row, eColNm ) != "" ) {
		if( mySheet.GetCellValue(row, sColNm)  > mySheet.GetCellValue(row, eColNm) ) {
			alert(message1+"일자가 "+message2+"일자보다 큽니다.");
			mySheet.SetCellValue(row, eColNm, "");
			mySheet.SelectCell(row, eColNm);
			return;
		}
	}
}
