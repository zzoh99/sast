<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!-- SunEditor -->
<link href="${ctx}/common/plugin/suneditor/suneditor-2.45.1.min.css" rel="stylesheet">
<script src="${ctx}/common/plugin/suneditor/suneditor-2.45.1.min.js"></script>
<script src="${ctx}/common/plugin/suneditor/suneditor-2.45.1.ko.js"></script>
<script src="${ctx}/common/plugin/suneditor/js/SunEditorEvent.js"></script>

    <div id="help_edit_modal">
      <div class="modal_background"> </div>
      <div class="modal max_wide edit_modal">
        <div class="modal_header"><span>도움말 작성</span><i class="mdi-ico modal_close_btn" >close</i></div>
        <div class="modal_sub_header">
          <input id="title" class="sub_title" placeholder="제목을 입력하세요."></input>
        </div>
        <div class="modal_body">
          <!-- 개발 시 참조 : 에디터 영역입니다. -->
<!--           <div class="editor"> -->
			<form id="help_editor" name="help_editor">
				<%@ include file="/WEB-INF/jsp/common/plugin/SunEditor/include_editor.jsp"%>
			</form>
<!--           </div> -->
          <%@ include file="/WEB-INF/jsp/common/popup/uploadProcessMapMgrForm.jsp"%>
        </div>
        <div class="modal_footer">
          <button id="modal_cancel_btn" class="btn outline_gray" onclick="modalScript.cancelHelp()">취소</button>
          <button id="modal_submit_btn" class="btn filled" onclick="modalScript.saveHelp()">저장</button>
        </div>
      </div>
    </div>
        
<script type="text/javascript">
  var modalScript = {
    modalOpts: null, // 전달받은 modalOpts (생성시 전달한 값 + target 등 추가된 opts 이다.)
    modal: null,
    procSeq:null,
    helpTxtTitle:"",
    helpTxtContent:"",
    fileSeq:"",
    authPg:"",
    init: function (obj) {
      this.modalOpts = obj;
      this.modal = this.modalOpts.target;
      this.procSeq=obj["params"]["procSeq"];
      this.helpTxtTitle=obj["params"]["helpTxtTitle"];
      this.helpTxtContent=obj["params"]["helpTxtContent"];
      this.fileSeq=obj["params"]["fileSeq"];
      this.authPg=obj["params"]["authPg"];
   
		//Editor.modify({
		//	"content": ""+ obj["params"]["helpTxtContent"]
		//});
        upLoadInit(this.fileSeq);
        SunEditor.init();
        SunEditor.modify(obj["params"]["helpTxtContent"]);

     $("#help_edit_modal .sub_title").val(obj["params"]["helpTxtTitle"]);
    },
    saveHelp:function (){
    	if(saveHelp()){
    		this.fileSeq=$("#uploadForm>#fileSeq").val();
    		this.modalOpts.rtnValue={procSeq:this.procSeq,helpTxtTitle:this.helpTxtTitle,helpTxtContent:this.helpTxtContent,fileSeq:this.fileSeq}
    		$("i.modal_close_btn").trigger("click");
    		alert("도움말이 임시저장 되었습니다. 프로세스맵을 저장 시 저장완료됩니다.")
    	}
    },
    cancelHelp:function(){
    	if(confirm("작성 중인 내용을 사라집니다. 도움말 작성을 취소하시겠습니까?")){
    		$("i.modal_close_btn").trigger("click");
    	};
    }
  };
</script>
<script src="/common/plugin/Editor/js/editor_loader_for_modal.js?environment=production" type="text/javascript" charset="utf-8"></script>
<link rel="stylesheet" href="/common/plugin/Editor/css/editor.css" type="text/css" charset="utf-8"/>
<script type="text/javascript">
	var config = {
		txHost: '', /* 런타임 시 리소스들을 로딩할 때 필요한 부분으로, 경로가 변경되면 이 부분 수정이 필요. ex) http://xxx.xxx.com */
		txPath: '', /* 런타임 시 리소스들을 로딩할 때 필요한 부분으로, 경로가 변경되면 이 부분 수정이 필요. ex) /xxx/xxx/ */
		txService: 'sample', /* 수정필요없음. */
		txProject: 'sample', /* 수정필요없음. 프로젝트가 여러개일 경우만 수정한다. */
		initializedId: "", /* 대부분의 경우에 빈문자열 */
		wrapper: "tx_trex_container", /* 에디터를 둘러싸고 있는 레이어 이름(에디터 컨테이너) */
		form: 'help_editor'+"", /* 등록하기 위한 Form 이름 */
		txIconPath: "/common/plugin/Editor/images/icon/editor/", /*에디터에 사용되는 이미지 디렉터리, 필요에 따라 수정한다. */
		txDecoPath: "/common/plugin/Editor/images/deco/contents/", /*본문에 사용되는 이미지 디렉터리, 서비스에서 사용할 때는 완성된 컨텐츠로 배포되기 위해 절대경로로 수정한다. */
		canvas: {
	        minHeight: 100,
	        maxHeight:  500,
	        autoSize: true,
            exitEditor:{
                /*
                desc:'빠져 나오시려면 shift+b를 누르세요.',
                hotKey: {
                    shiftKey:true,
                    keyCode:66
                },
                nextElement: document.getElementsByTagName('button')[0]
                */
            },
			styles: {
				color: "#123456", /* 기본 글자색 */
				fontFamily: "굴림", /* 기본 글자체 */
				fontSize: "10pt", /* 기본 글자크기 */
				backgroundColor: "#fff", /*기본 배경색 */
				lineHeight: "1.5", /*기본 줄간격 */
				padding: "8px" /* 위지윅 영역의 여백 */
			},
			showGuideArea: false
		},
		events: {
			preventUnload: false
		},
		sidebar: {
			attachbox: {
				show: false,
				confirmForDeleteAll: true
			}
		},
		size: {
			//contentWidth: 700 /* 지정된 본문영역의 넓이가 있을 경우에 설정 */
		}
	};

	/*EditorJSLoader.ready(function(Editor) {

	    Trex.module("auto canvas height resize",
	            function(editor, toolbar, sidebar, canvas, config){

	                var _config = config.canvas;
	                if(!_config.autoSize)
	                    return;
	                var beforeHeight = 0;

	            	var delta = 100;
	            	var timer = null;

	            	$( window ).on( 'resize', function( ) {
	            	    clearTimeout( timer );
	            	    timer = setTimeout( _resizeDone, delta );
	            	} );

	            	function _resizeDone() {
	            		var  cHeight = ("${editor.minusHeight}" =="" ? "100" :  "${editor.minusHeight}");
	            		var _panel = canvas.getCurrentPanel();
	            		var _h = $(window).height();
	            		var _height = Math.max(Math.max(parseInt(_h, 10), _config.minHeight), _config.maxHeight);
	            	    _height = (_height-cHeight-100).toPx() ;
	            		_panel.setPanelHeight(_height);
	            	}
	            }
	    );


		function resizeEditor() {
			var minusHeight = "${editor.minusHeight}";
			if(minusHeight !="") {
				var baseHeight = $(window).height()- minusHeight -100;
			}else{
				baseHeight = 250;
			}
			return baseHeight;
		};

		var editor = new Editor(config);

		Editor.getCanvas().setCanvasSize({
			height:resizeEditor()
		});

	});*/

</script>

<!-- Sample: Saving Contents -->
<script type="text/javascript">

	function saveHelp() {
		if($("#title").val()=="" ){
			alert('제목을 입력하세요');
			return false;
		}

		//var content = Editor.getContent();
        var content = SunEditor.getContent();

		if(!content ||
            (SunEditor.stripTags(content).trim() == "" ||
            SunEditor.stripTags(content).trim()== "&nbsp;"||
            SunEditor.stripTags(content).trim() == "<p><br></p>"||
            SunEditor.stripTags(content).trim() == "<p>&nbsp;</p>") && !content.includes("<img")) {
			alert('내용을 입력하세요');
			return false;
		}
		
        modalScript.helpTxtTitle=$("#title").val();
        modalScript.helpTxtContent= SunEditor.getContent();
                //Editor.getContent();
                
        return true;
	}

</script>