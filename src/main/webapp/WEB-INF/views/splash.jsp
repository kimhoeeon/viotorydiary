<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover" />
    <meta name="format-detection" content="telephone=no,email=no,address=no" />
    <meta name="apple-mobile-web-app-capable" content="yes" />

    <link rel="icon" href="/favicon.ico" />
    <link rel="shortcut icon" href="/favicon.ico" />
    <link rel="manifest" href="/site.webmanifest" />

    <link rel="stylesheet" href="/css/reset.css">
    <link rel="stylesheet" href="/css/font.css">
    <link rel="stylesheet" href="/css/base.css">
    <link rel="stylesheet" href="/css/style.css">

    <title>승요일기</title>

    <script src="https://cdn.jsdelivr.net/npm/@nolraunsoft/appify-sdk@latest/dist/appify-sdk.min.js"></script>
</head>
<body>

    <div class="splash" id="splash">
        <img src="/img/logo.svg" alt="로고" class="splash-logo">
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js"></script>
    <script src="/js/app_interface.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const splash = document.getElementById('splash');
            document.body.classList.add('no-scroll');

            setTimeout(() => {
                splash.style.opacity = '0';

                setTimeout(() => {
                    splash.style.display = 'none';
                    document.body.classList.remove('no-scroll');

                    // 애니메이션이 끝나면 로그인 페이지로 이동
                    location.href = '/member/login';
                }, 300);
            }, 2500); // 2.5초 후 실행
        });

        document.addEventListener('touchmove', function(e) {
            if (document.body.classList.contains('no-scroll')) {
                e.preventDefault();
            }
        }, { passive: false });
    </script>

</body>
</html>