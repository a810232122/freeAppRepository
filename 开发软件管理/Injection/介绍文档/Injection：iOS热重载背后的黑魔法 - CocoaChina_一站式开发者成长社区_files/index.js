var swiper = new Swiper('.swiper-container', {
    spaceBetween: 30,
    centeredSlides: true,
    loop: true,
    autoplay: {
        delay: 2500,
        disableOnInteraction: false,
    },
    pagination: {
        el: '.swiper-pagination',
        clickable: true,
    },
    navigation: {
        nextEl: '.swiper-button-next',
        prevEl: '.swiper-button-prev',
    },
});

window.url = 'http://api-dev.cjfan.net/cocoachina/';
var page_num = 1;
var listType = '';
var pageTotal = 0;
window.onscroll = () => {
    var scrolltop = document.documentElement.scrollTop || document.body.scrollTop;
    if (window.scrollY > 300) {
        $('#top_btn').css("display", "block");
    } else {
        $('#top_btn').css("display", "none");
    }
    if (scrolltop > 300) {
        $('#top_btn').css("display", "block");
    } else {
        $('#top_btn').css("display", "none");
    }
};

// getHotArchiveList('week_hot');
// fetchList('', 1);
const onChangeHotArticleType = (type) => {

    if (type == 'week_hot') {
        $('#month_hot').removeClass('active');
        $('#week_hot').addClass('active');
        $('.week_hot').show();
        $('.month_hot').hide();
        // getHotArchiveList('week_hot')
    } else if (type == 'mouth_hot') {
        $(btn[0]).removeClass('active');
        $(btn[1]).addClass('active');
        $('.mouth_hot').show();
    } else if (type == 'month_hot') {
        $('#week_hot').removeClass('active');
        $('#month_hot').addClass('active');
        $('.month_hot').show();
        $('.week_hot').hide();
        // getHotArchiveList('mouth_hot')
    } else if (type == "week_hot_bbs") {
        $('#month_hot_bbs').removeClass('active');
        $('#week_hot_bbs').addClass('active');
        $('.month_hot_bbs').hide();
        $('.week_hot_bbs').show();
    } else if (type == "month_hot_bbs") {
        $('#week_hot_bbs').removeClass('active');
        $('#month_hot_bbs').addClass('active');
        $('.week_hot_bbs').hide();
        $('.month_hot_bbs').show();
    }

};



$('.more-list').click(() => {
    $('.link ul').css("overflow", "visible")
    $('.more-list').hide()
    $('.normal-list').show()
    var height = $('.link').height() + 'px';
    $('.links-box').css('height', height);
})
$('.normal-list').click(() => {
    $('.link ul').css("overflow", "hidden")
    $('.more-list').show()
    $('.normal-list').hide()
    $('.links-box').css('height', '45px');
})
// 切换文章类型
$('#nav li').click((e) => {
    var me = $(e.target)
    var id = me.attr('data-id');
    if (id == listType) {
        return
    } else {
        listType = id
    }
    var s = me.siblings();
    me.siblings().removeClass('active');
    me.addClass('active');
    //fetchList(listType, 1);
});


// 获取更多列表
function onClickMore() {
    $('.more.btn').css('display', 'none');
    $('.more.more-loading').css('display', 'block');
    //fetchList(listType, +page_num + 1);
}
