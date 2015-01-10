$(function() {
	$('.field, textarea').focus(function() {
        if(this.title==this.value) {
            this.value = '';
        }
    }).blur(function(){
        if(this.value=='') {
            this.value = this.title;
        }
    });
      
    $('.flexslider').flexslider({
        animation: "fade",
        slideshow: true,
        controlNav: true,
        directionNav: false              
    });  

    $('.games-slider').jcarousel({
    	scroll: 1,
    	auto: 3,
    	wrap: 'both',
    	buttonNextHTML: null,
        buttonPrevHTML: null,
        initCallback: secondarySlider
    });

    $('.games-slider li').hover( function(){
    	$(this).addClass('active');
    }, function() {
    	$(this).removeClass('active');
    });

    $(".games-slider li").click(function(){
      window.location=$(this).find("a").attr("href");
      return false;
    });

    if ($.browser.msie && $.browser.version == 6) {
		DD_belatedPNG.fix('#wrapper, #logo a, .socials a, #search, #navigation, #navigation a, #slider, #slider img, .caption, a.watch-now, #main-top, #main-middle, #main-bottom, a.learn-more, .games-slider, .small-caption, .prev-arrow, .next-arrow, .flex-control-nav a, .shell');
	}
});

function secondarySlider(carousel) {
   $('.next-arrow').bind('click', function() {
        carousel.next();
        return false;
    });

    $('.prev-arrow').bind('click', function() {
        carousel.prev();
        return false;
    });
} 