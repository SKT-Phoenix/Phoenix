//-----button for iframe-----//
// 화면에 버튼 추가
var button = document.createElement('div'); 
button.id = 'floating_button';
button.classList.add('small');
button.classList.add('normal');
// if this window is a popup, no need to add button
// 이 창이 팝업이면 버튼을 추가할 필요가 없습니다.
if (!opener) {
    document.body.appendChild(button);
}


//-----iframe for iframe.html-----//
var iframe = document.createElement('iframe');              // iframe 요소 생성
iframe.id = 'ssummary_iframe';
iframe.src = chrome.runtime.getURL('html/iframe.html');     // iframe 요소에 iframe.html을 추가
iframe.scrolling = 'no';                                    // 스크롤 없애기(사이즈 자동 resize)//
// css
iframe.style.display = 'none';                              // iframe 숨기기 => floatting button을 클릭해야 iframe 나타남
iframe.style.width = '300px';
iframe.style.height = '180px';
iframe.style.boxShadow = 'rgb(150 150 150) 4px 4px 4px 0px';    // iframe 그림자 
document.body.appendChild(iframe);                          // iframe 요소를 body에 추가


//-----big/small when mouseover-----//
// 마우스 오버시 크기 변경
button.onmouseover = function(event) {
    event.target.classList.add('big');
    button.classList.remove('small');
};
button.onmouseleave = function(event) {
    button.classList.remove('big');
    event.target.classList.add('small');
};


//-----button draggable-----//
// 버튼 이동 가능하게 하기
button.onmousedown = function(event) {
    var x1 = event.clientX;
    var y1 = event.clientY;
    var x = x1 - button.offsetLeft;
    var y = y1 - button.offsetTop;

    var mousemove = function(event) {
        // drag text disabled
        event.preventDefault();

        let x2 = event.clientX - x;
        let y2 = event.clientY - y;

        // stop going beyond the window
        x2 = Math.min(Math.max(x2, 0), window.window.innerWidth - button.offsetWidth);
        y2 = Math.min(Math.max(y2, 0), window.window.innerHeight - button.offsetHeight);
        button.style.left = x2 + 'px';
        button.style.top = y2 + 'px';

        // iframe follow button position
        let iframeWidth = 250;
        let iframeHeight = 170;
        if (x2 > window.window.innerWidth - iframeWidth) {
            iframe.style.left = x2 - iframeWidth + 'px';
        }
        else {
            iframe.style.left = x2 + 20 + 'px';
        }
        if (y2 > window.window.innerHeight - iframeHeight) {
            iframe.style.top = y2 - iframeHeight + 'px';
        }
        else {
            iframe.style.top = y2 + 20 + 'px';
        }
    }
    var mouseup = function(event) {
        let dx = Math.abs(event.clientX - x1);
        let dy = Math.abs(event.clientY - y1);
        
        // if click and not drag
        if (dx < 2 && dy < 2) {
            iframe.style.display = 'block';
            button.classList.add('clicked');
            button.classList.remove('normal');
        }

        document.removeEventListener('mousemove', mousemove);
        document.removeEventListener('mouseup', mouseup);
    }
    document.addEventListener('mousemove', mousemove);
    document.addEventListener('mouseup', mouseup);
};


//-----close when click out of iframe-----//
// iframe 밖을 클릭하면 iframe 숨기기
window.onclick = function(event) {
    if (event.target !== button) {
        // remove iframe if it is exist (iframe이 있는 경우 제거)
        if (iframe.parentNode) {
            iframe.style.display = 'none';
            button.classList.remove('clicked');
            button.classList.add('normal');
        }
    }
};


//-----get on_off from storage-----//
// 플로팅버튼 ON/OFF 상태 가져오기
chrome.storage.sync.get(function (data) {
    document.getElementById('floating_button').style.display = data.on_off ? 'block' : 'none';
});