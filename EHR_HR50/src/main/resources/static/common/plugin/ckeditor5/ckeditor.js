var iframeLoad = false;

function setIframeHeight(frameName) {
    var ifrm = document.getElementById(frameName);
    if (ifrm) {
        ifrm.style.visibility = 'hidden';
        ifrm.style.height = ifrm.contentDocument.body.scrollHeight + "px";
        ifrm.style.visibility = 'visible';
    }
}

function callIframeBody(formName, frameName) {
    var form = $("#" + formName);
    submitCall(form, frameName, "post", "/Editor.do?cmd=viewCkEditor");
}

/**
 * 상세화면 iframe 내 높이 재조정.
 * @param ih
 * @modify 2024.04.23 Det.jsp 내에서 부모의 iframeOnLoad를 호출할 때 아직 화면이 그려지기 전에 iframe의 높이를 지정하는 경우가 있어 0.3초 후 다시 높이를 조정. by kwook
 */
function iframeOnLoad(ih) {
    try {
        setTimeout(function() {
            var ih2 = parseInt((""+ih).split("px").join(""));
            var wrpH = 0;
            $("#authorFrame").contents().find(".wrapper").children().each((idx, ele) => wrpH += $(ele).outerHeight(true));
            if (wrpH > ih2)
                $("#authorFrame").height(wrpH);
            else
                $("#authorFrame").height(ih2);
        }, 300);

        iframeLoad = true;
    } catch(e) {
        $("#authorFrame").height(ih);
        iframeLoad = true;
    }
}

function ckReadySave(frameName){
    try{
        document.getElementById(frameName).contentWindow.setValue();
    }catch(ex) {
        alert("Script Errors Occurred While Saving." + ex);
        return;
    }
}

function ckGetContent(frameName){
    console.log(frameName)
    return document.getElementById(frameName).contentWindow.getValue();
}