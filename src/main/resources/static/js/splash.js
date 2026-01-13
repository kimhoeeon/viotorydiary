// 스플래쉬
document.addEventListener('DOMContentLoaded', () => {
    const splash = document.getElementById('splash');
    document.body.classList.add('no-scroll');

    setTimeout(() => {
        splash.style.opacity = '0';

            setTimeout(() => {
            splash.style.display = 'none';

            document.body.classList.remove('no-scroll');
            }, 300);
    }, 2500);
});

document.addEventListener('touchmove', preventScroll, { passive: false });

function preventScroll(e) {
    if (document.body.classList.contains('no-scroll')) {
        e.preventDefault();
    }
}