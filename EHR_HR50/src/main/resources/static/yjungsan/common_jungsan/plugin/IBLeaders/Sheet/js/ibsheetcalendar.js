
function ShowCalendar(opt1, opt2) {
	var option = false;
	if( opt1["TimeFormat"] == "yyyy-MM" ) option = true;
	
	sheetPopCalendar(opt1["Grid"],0,0,option); 
	
	return false;
}

function getOption() {
	return sheetCalendarOption;
}

var sheetCalendarOption;
var _SheetObj;

function sheetPopCalendarSetCellValue(d){
	_SheetObj.SetCellValue(_SheetObj.GetSelectRow(), _SheetObj.GetSelectCol(),d);
}

function sheetPopCalendar(dateSheet,xplus,yplus,option) {
	_SheetObj = dateSheet;
	
	if( $("#hiddenCalendarInput").length == 0 ) {
		$('<span></span>',{ id:'hiddenCalendarLink'}).appendTo('body');
		$('<input></input>',{ id:'hiddenCalendarInput',type:'hidden'}).appendTo('body');
		$("#hiddenCalendarInput").addClass("calendarInput");

	    $("#hiddenCalendarInput").datepicker2({
            picker: "#hiddenCalendarLink",
			ymonly:option,
			applyrule: getOption,
			//onReturn:function(d){dateSheet.SetCellValue(dateSheet.GetSelectRow(), dateSheet.GetSelectCol(),d);
			onReturn:function(d){ sheetPopCalendarSetCellValue(d);
			}
        });
	}
	sheetCalendarOption = option;
	var value;
	var year;
	var month;
	var day;
	var selectValue = dateSheet.GetCellValue(dateSheet.GetSelectRow(),dateSheet.GetSelectCol());
	if( selectValue.length == 8 && !option ) {
		year = selectValue.substr(0,4);
		month = selectValue.substr(4,2);
		day = selectValue.substr(6,2);
		value = year + "-" + month + "-" + day;
	}
	else if( selectValue.length == 8 && option ) {
		year = selectValue.substr(0,4);
		month = selectValue.substr(4,2);
		value = year + "-" + month;
	}
	else value = "";
	$("#hiddenCalendarInput").val(value);

	$(".ibsheet").mouseup(function() {calendarClose2();});
	$(".GMVScroll>div").scroll(function () {calendarClose2();});
	$(".GMHScrollMid>div").scroll(function () {calendarClose2();});

	var pleft = dateSheet.ColLeft(dateSheet.GetSelectCol());
	var ptop =  dateSheet.RowTop(dateSheet.GetSelectRow()) + dateSheet.GetRowHeight(dateSheet.GetSelectRow()) ;
	//건수정보 표시줄의 높이 만큼.
	if (dateSheet.GetCountPosition() == 1 || dateSheet.GetCountPosition() == 2) ptop +=  13;

	var point = fGetXY( document.getElementById("DIV_"+dateSheet.id));

	var left = point.x + pleft+xplus;
	var top = point.y + ptop+yplus;

	var cWidth = 177;
	var cHeight = 184;
	var dWidth = $(window).width();
	var dHeight = $(window).height();

	if( dWidth < left + cWidth) left = dWidth - cWidth;
	if( dHeight < top + cHeight) top = top-cHeight-18;
	if( top < 0 ) top = 0;
	
    $("#hiddenCalendarLink").click();
	$("#BBIT_DP_CONTAINER").css("left",left+"px");
	$("#BBIT_DP_CONTAINER").css("top",top+"px");
}

//시트에서 달력 닫기
function calendarClose2(dateText) {
	$(".ibsheet").unbind("mouseup");
	$(".GMVScroll>div").unbind("scroll");
	$(".GMHScrollMid>div").unbind("scroll");
	$("#hiddenCalendarLink").attr("isshow","0");
	$("#BBIT_DP_CONTAINER").css("visibility", "hidden");
}