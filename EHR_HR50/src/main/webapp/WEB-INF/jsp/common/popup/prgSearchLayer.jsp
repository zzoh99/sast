<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- ajax error -->
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp" %>


<script>
  // var word = $('#mainModalSearchInput').val();
  // if (word.length > 1) {
  //   const p = { searchText: word };
  //   const d = ajaxCall('/SearchMenuLayer.do?cmd=getSearchMenuLayerList', queryStringToJson(p), false).DATA;
  //   var menuHtml = d.length > 0 ? d.reduce((a, c) => {
  //     a += '<div class="result">\n'
  //             + '	<span prgCd="' + c.prgCd + '" mainMenuCd="' + c.mainMenuCd +'" >' + c.searchPath + '</span>\n'
  //             + '</div>\n';
  //     return a;
  //   },''):'<div class="result">검색 결과가 없습니다.</div>';
  //   $('#searchModalMenuResult').html(menuHtml);
  //   getProcessMap();
  //   employeeAction('Search');
  //   mainModalEvent();
  // } else {
  //   alert('검색어는 최소 2글자 이상 입력하여야 합니다.');
  // }
  $(function(){

    function showData(data){
      let parent = document.getElementById('searchModalMenuResult');
      parent.innerHTML = '';
      if(!data || !data.length || data.length === 0){
        let resultWrap = document.createElement('div');
        resultWrap.classList = 'result';
        resultWrap.innerText = '검색 결과가 없습니다.';
        parent.appendChild(resultWrap);
        return;
      }

      for(let i=0; i<data.length; i++){
        let resultWrap = document.createElement('div');
        resultWrap.classList = 'result';
        resultWrap.addEventListener('click', function(e){
          e.stopPropagation();
          const modal = window.top.document.LayerModalUtility.getModal('prgSearchLayer');
          modal.fire('prgSearchTrigger', {
            prgCd : data[i].prgCd
            , mainMenuCd : data[i].mainMenuCd
            , menuNm : data[i].menuNm
          }).hide();
        });
        let result = document.createElement('span');
        result.setAttribute('prgCd', data[i].prgCd);
        result.setAttribute('mainMenuCd', data[i].mainMenuCd);
        result.setAttribute('menuNm', data[i].menuNm);
        result.insertAdjacentHTML('beforeend', data[i].searchPath);
        resultWrap.appendChild(result);
        parent.appendChild(resultWrap);
      }
    }
    function mainModalSearch(){
      const inputValue = $('#mainModalSearchInput').val();
      if(inputValue === '') return;
      const data = ajaxCall('/SearchMenuLayer.do?cmd=getSearchMenuLayerList', queryStringToJson({searchText : inputValue}), false);
      showData(data.DATA);
    }

    $('#mainModalSearchInput').on('keydown', function(e){
      if(e.keyCode !== 13) return;
      mainModalSearch();
    });

    $('#mainModalSearchButton').on('click', function(e){
      mainModalSearch();
    });

    showData();

  });
</script>
<style>
  div.search_modal div.modal_sub_header{
    height:76px;
  }
  div.search_modal div.modal_body{
    min-height:494px;
  }
</style>
<div class="search_modal">
  <div class="modal_sub_header">
    <div class="search">
      <input id="mainModalSearchInput" type="text" class="" placeholder="검색어를 입력해 주세요.">
      <button id="mainModalSearchButton" class="btn filled thin">검색</button>
    </div>
  </div>

  <div class="modal_body">
    <div id="searchModalMenuResult" class="menu_result"></div>
  </div>
</div>
