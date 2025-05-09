<style>
    .toast {
        position: fixed;
        top:10%;
        left: 50%;
        z-index: 999;
        visibility: hidden;
        min-width: 250px;
        padding: 16px;
        margin-left: -125px;
        border-radius: 12px;
        background-color: rgba(0,0,0,0.7);
        text-align: center;
        font-size: 16px;
        color: #fff;
    }
    .toast.show {
        visibility: visible;
        animation: fadein 0.5s, fadeout 0.5s 2.5s;
    }
    @keyframes fadein {
        from {top: 0; opacity: 0;}
        to {top: 10%; opacity: 1;}
    }
    @keyframes fadeout {
        from {top: 10%; opacity: 1;}
        to {top: 0; opacity: 0;}
    }
</style>

<div id="notification-toast-div" class="toast">
    <script>
        function showToast(message) {
            const toast = $("#notification-toast-div");
            toast.text(message);
            toast.addClass("show");
            setTimeout(function () {
                toast.removeClass("show");
            }, 3000);
        }

        /* 알림 토스트 창 사용시 아래 주석 해제하여 사용 */
        // var eventSource = new EventSource('/notification/subscribe');
        //
        // eventSource.addEventListener('notification', event => {
        //     //console.log(event.data)
        //     showToast(event.data);
        // });
    </script>
</div>