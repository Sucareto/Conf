var fn = function () {
    var btn = document.getElementsByClassName("Button VoteButton VoteButton--up is-active")
// 用 class 查找元素
    for (var i = 0; i < btn.length; i++) {
        btn[i].click()	// 点击
    }
}
var interval = setInterval(fn, 1000)	// 每隔 1 秒执行一次
var t=setTimeout("location.reload()",10000);	// 10 秒后刷新页面
