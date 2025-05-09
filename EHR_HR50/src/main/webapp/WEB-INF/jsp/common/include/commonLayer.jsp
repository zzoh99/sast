<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<header>
    <style>
        #inputTitle {
            display: none;
            line-height: 19px;
            border: solid 1px #e3e3e3;
            width: 50%;
            text-align: left;
            padding: 3px 10px;
            border-radius: 8px;
            height: 35px;
            font-family: NotoSansKr, OpenSans;
        }
        .layer-modal-header .icons {
            display: flex;
            margin-left: auto;
        }
        .layer-modal-header .icons a{
            display: flex;
            align-items: center;
        }
    </style>
    <script type="text/javascript">
        let orgClassName;

        /**
         * 레이어 팝업 내 IBSheet 생성 이벤트
         *
         * @param obj IBSheet 의 부모 div Element
         * @param sheetid IBSheet id
         * @param width 폭
         * @param height 높이.
           <br/>px 로 작성할 경우 고정 높이로 설정되며,
           <br/>% 로 작성할 경우 화면 상 표현이 가능한 범위(modal_body 높이에서 outer, inner 클래스들의 높이를 제외)의 %로 높이를 계산한다.
         * @param locale 다국어코드
         */
        function createIBSheet3(obj, sheetid, width, height, locale){
            obj.className = "ibsheet";
            obj.setAttribute("data-shtid", sheetid);
            obj.setAttribute("data-realheight", height);

            let h;
            if( height.indexOf("%") > -1 ) {
                obj.setAttribute("data-fixed", "false");
                h = '300px';
            } else {
                obj.setAttribute("data-fixed", "true");
                h = height;
            }

            createIBSheet2(obj, sheetid, width, h, locale);
        }

        function closeCommonLayer( id ) {
        	const modal = window.top.document.LayerModalUtility.getModal(id);
        	modal.hide();
        }

        ;(function(window, $){
            function generateId() {
                return secureRandom().toString(36).substr(2, 16);
            }
            window.top.document.LayerModal = LayerModal;
            window.top.document.LayerModalUtility = new LayerModalUtility();
            //external scope 에서 modal 을 호출하기 위한 유틸리티
            function LayerModalUtility(){
                this.modalList = {};
            }
            //modal 을 추가한다
            LayerModalUtility.prototype.addModal = function(modal){
                this.modalList[modal.id] = modal;
            };
            //modal 을 삭제한다
            LayerModalUtility.prototype.removeModal = function(id){
                delete this.modalList[id];
            }
            //modal 을 검색한다
            LayerModalUtility.prototype.getModal = function(id){
                return this.modalList[id];
            };
            function LayerModal(options){
                this.id         = options.id || generateId();//ID
                this.width      = options.width || 300;//가로 크기
                this.height     = options.height || 200;//세로 크기
                this.modalWrap  = null;
                this.background = null;//background
                this.modal      = null;
                this.parent     = window.document.getElementById('layerModalWrap');
                this.contentWrap    = null;
                this.content    = '';//modal 내용
                this.contentUrl = options.url || '';
                this.html       = options.html || '';
                this.parameters = options.parameters || {};
                this.triggerList = [];
                if(options.trigger){
                    this.addTrigger(options.trigger);
                }
                this.callback   = options.callback || null;
                this.isShow     = false;
                this.title      = options.title || '';
                this.destroyCallback    = null;
                this.top       = options.top || '';
                this.left       = options.left || '';
                this.init();
            }

            //modal 초기화
            LayerModal.prototype.init = function(){
                const _this = this;
                this.modalWrap = window.document.createElement('div');
                this.modalWrap.setAttribute('id', 'modal-' + this.id);
                this.background = window.document.createElement('div');
                this.background.className = 'modal_background';
                this.background.style.display = 'block';
                this.background.addEventListener('click', function(e){
                    _this.hide();
                });

                this.modal = window.document.createElement('div');
                this.modal.className = 'modal modal-size';

                if (this.contentUrl.includes('viewApprovalMgrResultLayer')
                    || this.contentUrl.includes('viewApprovalMgrLayer')) {
                    let param = {
                        searchApplCd: this.parameters.searchApplCd
                    };

                    let modalWidth = 'xl';
                    let modalHeight = 'xl';

                    const data = ajaxCall( "AppCodeMgr.do?cmd=getAppCodeMgrModalSize", param,false);
                    if ( data != null && data.DATA != null ) {
                        modalWidth = data.DATA.modalWidth == ''? 'xl' : data.DATA.modalWidth;
                        modalHeight = data.DATA.modalHeight == ''? 'xl' : data.DATA.modalHeight;
                    }

                    this.modal.className += ' width-' + modalWidth;
                    this.modal.className += ' height-' + modalHeight;
                } else {
                    this.modal.style.width = this.width + 'px';
                    this.modal.style.height = this.height + 'px';
                }
                this.modal.style.display = 'flex';
                this.modal.style.flexDirection = 'column';
                $(this.modal).resizable();

                if(this.top !== '') {
                    this.modal.style.top = this.top;
                }

                if(this.left !== '') {
                    this.modal.style.left = this.left;
                }

                if(this.title !== ''){
                    let header = window.document.createElement('div');
                    header.className = 'layer-modal-header';
                    header.style.width = '100%';
                    //header.innerText = this.title;
                    let title = window.document.createElement('span');
                    title.className = 'layer-modal-title';
                    title.innerText = this.title;
                    let title2 = window.document.createElement('input');
                    title2.id = 'inputTitle';
                    title2.value = this.title;
                    let icons = window.document.createElement('div');
                    icons.className='icons';
                    let fullA = window.document.createElement('a');
                    fullA.href = '#';
                    let full =  window.document.createElement('i');
                    full.id = 'full_id';
                    full.className = 'mdi-ico ui-controlgroup';
                    full.innerText = 'fullscreen';
                    full.addEventListener('click', function(e){
                        _this.makeFull();
                    });
                    fullA.appendChild(full);

                    let miniA = window.document.createElement('a');
                    miniA.href = '#';
                    let mini = window.document.createElement('i');
                    mini.id = 'mini_id';
                    mini.className = 'mdi-ico ui-controlgroup';
                    mini.innerText = 'fullscreen_exit';
                    mini.style.display='none'
                    mini.addEventListener('click', function(e){
                        _this.makeMini();
                    });
                    miniA.appendChild(mini);

                    let closeA = window.document.createElement('a');
                    closeA.href = '#';
                    closeA.id = 'closeIcon';
                    let close = window.document.createElement('i');
                    close.className = 'mdi-ico ui-controlgroup';
                    close.innerText = 'close';
                    close.addEventListener('click', function(e){
                        _this.hide();
                    });
                    closeA.appendChild(close);

                    header.appendChild(title);
                    header.appendChild(title2);
                    header.appendChild(icons);
                    icons.appendChild(fullA);
                    icons.appendChild(miniA);
                    icons.appendChild(closeA);
                    this.modal.appendChild(header);
                }

                this.contentWrap = window.document.createElement('div');
                // this.contentWrap.style.height = 'calc(100% - 48px)';
                this.contentWrap.style.overflowY = 'scroll';
                this.contentWrap.style.position = 'relative';
                this.contentWrap.style.flex = '1';
                this.contentWrap.style.alignSelf = 'stretch';
                this.contentWrap.className = 'layer-content';
                let loader = window.document.createElement('div');
                loader.className = 'loader';
                this.contentWrap.appendChild(loader);
                this.modal.appendChild(this.contentWrap);
                this.modalWrap.appendChild(this.background);
                this.modalWrap.appendChild(this.modal);

                window.top.document.LayerModalUtility.addModal(this);

                this.changeContent();
            };
            //modal 보이기
            LayerModal.prototype.show = function(){
                if(this.isShow) return;
                this.parent.appendChild(this.modalWrap);
                this.parent.className = 'active';
                this.isShow = true;
                $("#closeIcon").focus();
            };
            //modal 숨기기
            LayerModal.prototype.hide = function(){
				//해당 레이어에 있는 sheet의 메모리/이벤트를 해제
				var sheets = $(this.modalWrap).find('.GMMainTable');
				var sheetIds = [];
				sheets.each(function() { sheetIds.push($(this).prop('id').replace('-table', '')); });
				sheetIds.forEach(sheetId => { if (window[sheetId]) window[sheetId].DisposeSheet(1); });
                this.parent.removeChild(this.modalWrap);
				//현재 더 이상 layer가 존재하지 않을 경우 active를 제거하도록 수정한다.
				if (!this.parent.hasChildNodes()) {
					this.parent.className = '';
				}
                window.top.document.LayerModalUtility.removeModal(this.id);
                if(this.destroyCallback && typeof this.destroyCallback === 'function') this.destroyCallback();
                this.isShow = false;
            };
            //modal 내용의 script 를 정렬한다
            LayerModal.prototype.dynamicScript = function(data){
                let scriptElements = [];
                let otherElements = [];
                const elements = $(data);
                for(let i=0; i<elements.length; i++){
                    if(elements[i].tagName === 'SCRIPT' && elements[i].src === ''){
                        let script = window.document.createElement('script');
                        let scriptStr = window.document.createTextNode(elements[i].innerText);
                        script.appendChild(scriptStr);

                        scriptElements.push(script);
                    }else{
                        this.contentWrap.appendChild(elements[i]);
                    }
                }
                for(let i=0; i<scriptElements.length; i++){
                    this.contentWrap.appendChild(scriptElements[i]);
                }
            };
            //modal 내용을 변경한다
            LayerModal.prototype.changeContent = function(){
                const _this = this;
                //html 이 있으면 바로 적용. 없으면 url 로 내용 받아오기
                if(_this.html !== ''){
                    $(_this.contentWrap).html(_this.html);
                    return;
                }

                $.ajax({
                    url : _this.contentUrl
                    , type : 'POST'
                    // , headers : {
                    //     'Content-Type' : 'application/json'
                    // }
                    , dataType : 'html'
                    , async: true
                    , data : _this.parameters
                    , success: function(data) {
                        _this.content = data;
                        $(_this.contentWrap).html(data);

                        // authPg 값으로 class 제어
                        setTimeout(function(){
                            // URLSearchParams 객체를 사용하여 쿼리 문자열 파싱
                            var queryString = _this.contentUrl.split('?')[1];
                            var params = new URLSearchParams(queryString);

                            // authPg 파라미터 값 가져오기
                            var authPg = '';

                            if(params.has('authPg'))
                                authPg = params.get('authPg');
                            else
                                authPg = _this.parameters.authPg;

                            var comBtnAuthPg = (authPg === '' || typeof authPg == 'undefined') ? "R" : authPg;
                            (comBtnAuthPg === 'A') ? $(".authA,.authR").removeClass("authA").removeClass("authR"):$(".authR").removeClass("authR");
                        }, 50);
                    }
                    , error: function(jqXHR, ajaxSettings, thrownError) {
                        ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
                    }
                });
            };
            //modal 에서 trigger 처리 할 이벤트 목록을 추가한다
            LayerModal.prototype.addTrigger = function(trigger){
                if(trigger.length){
                    for(let i=0; i<trigger.length; i++){
                        this.triggerList.push(trigger[i]);
                    }
                }else{
                    this.triggerList.push(trigger);
                }
            };
            //trigger 검색
            LayerModal.prototype.getTrigger = function(name){
                for(let i=0; i<this.triggerList.length; i++){
                    if(this.triggerList[i].name === name) return this.triggerList[i];
                }
            };
            //trigger callback 을 실행한다
            LayerModal.prototype.fire = function(name, data){
                const trigger = this.getTrigger(name);
                if(trigger && trigger.callback) trigger.callback(data);
                return this;
            };
            //hide 되는 시점에 호출할 callback 을 부여한다
            LayerModal.prototype.destroy = function(callback){
                this.destroyCallback = callback;
            };

            LayerModal.prototype.makeFull = function(){

                if(this.modal.className.includes('width-')) {
                    orgClassName = this.modal.className;
                    this.modal.className = 'modal modal-size';
                }
                this.modal.style.maxHeight = '100vh';
                this.modal.style.width = '100%';
                this.modal.style.height = '100%';

				//모달 maxheight = 모달의 전체 사이즈 - 헤더 - 푸터
                var modalMaxHeight = $('.modal-size').height() - $('.layer-modal-header').outerHeight() - $('.modal_footer').outerHeight();

                $('.modal_body').css('max-height', modalMaxHeight);
                $('.modal_body').css('height', '100%');
                $('#modal-'+$(this)[0].id).find('#full_id').hide();
                $('#modal-'+$(this)[0].id).find('#mini_id').show();

                if (typeof sheetResize === "function") {
                    sheetResize();
                }
            };

            LayerModal.prototype.makeMini = function(){
                let maxHeight;
                let height;

                if(orgClassName != undefined && orgClassName != '') {
                    this.modal.className = orgClassName;
                    $(this.modal).css('width', '');
                    $(this.modal).css('height', '');
                    if(orgClassName.includes('height-full')) {
                        this.modal.style.maxHeight = '100vh';
                        maxHeight = 'calc(100vh - 150px)';
                        height = '100%';
                    }

                }else {
                    this.modal.style.width = this.width+'px';
                    this.modal.style.height = this.height+'px';
                    this.modal.style.maxHeight = 'calc(100vh - 100px)';
                    maxHeight = 'calc(100vh - 100px)';
                    height = 'calc(100% - 65px)';
                }

                $('.modal_body').css('max-height', maxHeight);
                $('.modal_body').css('height', height);
                $('#full_id').show();
                $('#mini_id').hide();

                if (typeof sheetResize === "function") {
                    sheetResize();
                }
            };

        })(window, jQuery);

        // Safari 감지해서 전용 클래스 추가
        if (/^((?!chrome|android).)*safari/i.test(navigator.userAgent)) {
            document.documentElement.classList.add('is-safari');
        }

        // Safari에서 모달 중앙 정렬
        function centerModalForSafari() {
            if (!document.documentElement.classList.contains('is-safari')) return;

            const modal = document.querySelector('.modal');
            if (!modal) return;

            const winW = window.innerWidth;
            const winH = window.innerHeight;
            const modalW = modal.offsetWidth;
            const modalH = modal.offsetHeight;

            modal.style.position = 'fixed';
            modal.style.left = `${(winW - modalW) / 2}px`;
            modal.style.top = `${(winH - modalH) / 2}px`;
        }

        window.addEventListener('load', centerModalForSafari);
        window.addEventListener('resize', centerModalForSafari);
    </script>
</header>
<body>
<!-- MODAL AREA -->
<div id="layerModalWrap"></div>
</body>
</html>