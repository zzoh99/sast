<script type="text/javascript">

    var comBtnAuthPg = ("${authPg}"=="") ? "R" : "${authPg}";
    $(function() {
        (comBtnAuthPg == "A") ? $(".authA,.authR").removeClass("authA").removeClass("authR") : $(".authR").removeClass("authR");
    });

</script>

