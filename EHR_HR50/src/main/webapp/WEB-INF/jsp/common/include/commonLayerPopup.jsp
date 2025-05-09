<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
var commonLayerList = [];

function findLayer(id) {
	return commonLayerList.find(l => l.id == id);
}

async function openLayer(url, arg, width, height, init, rtn, rparam) {
	var id = generateId();
	while(commonLayerList.find(cl => cl.id == id)) { id = generateId(); }
	var modal = '<div id="commonLayer_' + id + '">\n'
			  + '	<div class="modal_background"></div>\n'
			  + '	<div class="modal">\n'
			  + '</div>';
	$('#commonLayerCreateArea').append(modal);

	var commonLayer = { id, url, arg, width, height };
	var commonLayerBody = await ajaxTypeHtml(url, arg);
	var layerId = 'commonLayer_' + id;
	$('#' + layerId + ' .modal').css('width', width + 'px');
	$('#' + layerId + ' .modal').css('height', height + 'px');

	//back-ground click 시 modal close 기능 추가
	$('#' + layerId + ' .modal_background').on('click', function() {
		var lid = $(this).parent().attr('id');
		closeLayer(lid.substring('commonLayer_'.length));
	});

	$('#' + layerId + ' .modal').load(url, arg, () => { if(init) eval(init + '("' + id + '")') });


	//초기화 함수 수행
	// eval(init + '("' + id + '")');
    //if(init) eval(init + '("' + id + '")');
	
	$("#" + layerId).find(".modal, .modal_background").fadeIn(200);
	if (rtn) { commonLayer['rtn'] = rtn; }
	commonLayerList.push(commonLayer);
	
	return id;
}

function closeLayer(id, param) {
	var commonLayerIdx = commonLayerList.findIndex(cl => cl.id == id);
	if (commonLayerIdx == -1) return;

	var commonLayer = commonLayerList[commonLayerIdx];
	if (commonLayer.rtn && typeof commonLayer.rtn == 'function') {
		if (param) commonLayer.rtn(param);
		else commonLayer.rtn('');
	}

	var layerId = 'commonLayer_' + commonLayer.id;
	$('#' + layerId + ' .modal').empty();
	$('#' + layerId).find(".modal, .modal_background").fadeOut(200);
	$('#' + layerId).remove();
	commonLayerList.splice(commonLayerIdx, 1);
}

function generateId() {
	return secureRandom().toString(36).substr(2, 16);
}


</script>
<!-- MODAL AREA -->
<div id="commonLayerCreateArea"></div>