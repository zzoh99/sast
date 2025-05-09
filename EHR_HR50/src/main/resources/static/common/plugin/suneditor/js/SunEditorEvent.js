function SunEditor() {}

SunEditor.editor = null;

SunEditor.modify = function(content) {
    $(".sun-editor-editable").html(content);
}

SunEditor.readySave = function() {
    $("#sunEditorContentArea").val(this.editor.getContents());
}

SunEditor.save = function(f) {
    this.readySave();
    f.submit();
}

SunEditor.getContent = function() {
    return $(".sun-editor-editable").html();
}

SunEditor.getUnescapedContent = function() {
    return unescapeXss(this.editor.getContents());
}

SunEditor.stripTags = function(text) {
    return text.replace(/<\/?[^>]+>/gi, '');
}

SunEditor.init = function(opt) {

    if(typeof editor == 'undefined') {
        var plugins = 'suneditor/src/plugins';
        var option = {
            lang: SUNEDITOR_LANG['ko'],
            font: [
                'Arial', 'Comic Sans MS', 'Courier New', 'Impact',
                'Georgia','tahoma', 'Trebuchet MS', 'Verdana', 'NanumGothic', 'Malgun Gothic', 'Dotum', 'NotoSansKr', 'OpenSans', 'Pretendard'
            ],
            height : '250px',
            plugins: [plugins],
            buttonList: [
                ['undo', 'redo', 'removeFormat' ],
                ['font', 'fontSize', 'formatBlock'],
                ['paragraphStyle', 'blockquote'],
                ['bold', 'underline', 'italic', 'strike', 'subscript', 'superscript'],
                ['fontColor', 'hiliteColor', 'textStyle'],
                ['outdent', 'indent'],
                ['align', 'horizontalRule', 'list', 'lineHeight'],
                ['table', 'link', 'image', 'video', 'audio'],
                ['fullScreen', 'showBlocks', 'codeView'],
                ['preview', 'print', 'save'],
            ],
            attributesWhitelist: {
                'all': '*'
            }
        };
        if(typeof opt != 'undefined' && opt !== '') {
            $.extend(option, opt);
        }

        const editor = SUNEDITOR.create((document.getElementById('sunEditorContent') || 'sunEditorContent'), option);
        editor.setDefaultStyle('font-family: NotoSansKr; font-size: 10px;');

        this.editor = editor;
    }
}