$(document).ready(function(){
	// $('a[href*="wordpress"]').remove();
	// $('img[src*="wordpress"]').remove();
	
	$("h3.newstitle").prepend("<span>+</span>");

	$("h3.newstitle").click(function() {
		//$(".content").slideUp();
		if ($(this).siblings(".content").is(":hidden")) {			
			$(this).siblings(".content").slideDown();
			$(this).find("span").html("-");
		} else {
			$(this).siblings(".content").slideUp();
			$(this).find("span").html("+");
		}
	});
	
	$("#homenewslist").quickPager({pageSize:5, pagerLocation: 'before'});
	$("#newslist").quickPager({pageSize:10, pagerLocation: 'before'});
	$(".simplePagerNav").before("<b>Page:</b> ");
	
	$("#thumbs a").fancybox({
		'transitionIn'		: 'elastic',
		'transitionOut'		: 'elastic',
		'titlePosition'  	: 'over',
		'titleFormat'       : function(title, currentArray, currentIndex, currentOpts) {
		    return '<span id="fancybox-title-over">Image ' +  (currentIndex + 1) + ' / ' + currentArray.length + ' ' + title + '</span>';
		}
	});
	
	$(".findlink").click(function() {
		if ($.trim($("#findname").val()) != "") {
			$('#maincontent').removeHighlight();
			$('#maincontent').highlight($("#findname").val());
			$("#searchResults").html("Found " + $(".killer .highlight").length + " EKs and " + $(".corpse .highlight").length + " Deaths.");					
			// $('html, body').animate({
				// scrollTop: $(".highlight").offset().top
			// }, 500);			
		}
	});
	
	$(".findlinkassists").click(function() {
		if ($.trim($("#findname").val()) != "") {
			$('#maincontent').removeHighlight();
			$('#maincontent').highlight($("#findname").val());					
			$('html, body').animate({
				scrollTop: $(".highlight").offset().top
			}, 500);			
		}
	});
	
	$('#eksubmit').click(function() {
		$("#monthname").val($("#monthselect option:selected").text())
	});
	
	$('#captcha').simpleCaptcha({
		numImages: 5,
		introText: '<p>Are you human? Then pick out the <strong class="captchaText"></strong>!</p>',
		scriptPath: '/simpleCaptcha.php'
	});
	
	$("#uploadsubmit").click(function() {
		$(this).hide();
		$("#uploadmessage").html("<img src=\"/images/loading.gif\" alt=\"Working...\" />");
		$("#uploadform").ajaxForm({
			success: function(responseText) {
				if (responseText == "<head></head><body>Your screenshot was submitted for approval!</body>") {
					$("#uploadmessage").html(responseText);
					$("#uploadform").clearForm();
					$("#uploadform #file").replaceWith("<input type='file' name='image' id='file' />");
					$("#uploadsubmit").show();
				} else {
					$("#uploadmessage").html(responseText);
					$("#uploadsubmit").show();
				}
			}
		});
	});
	
	$(".remove").click(function() {
		//$(this).hide();
		//$("#uploadmessage").html("<img src=\"/images/loading.gif\" alt=\"Working...\" />");
		var character = $(this).attr("title");
		var guild = $(this).attr("rel");
		var answer = confirm("Are you sure you want to remove " + character + " from the guild? Is " + character + " logged out of the game?")
		if (answer){
			$.ajax({
				type: "POST",
				url: "/ajax/removemember.php",
				data: { CharName : character, GuildName : guild },
				dataType: "json",
				success: function(data){
					if (data.error === false) {
						$(".remove[title=" + character + "]").parent().parent().hide();
					}
					alert(data.msg);
				}
			});
		}
	});
	
	$(".promote").live('click', function() {
		//$(this).hide();
		//$("#uploadmessage").html("<img src=\"/images/loading.gif\" alt=\"Working...\" />");
		var character = $(this).attr("title");
		var type = "promote";
		var answer = confirm("Is " + character + " logged out of the game?")
		if (answer){
			$.ajax({
				type: "POST",
				url: "/ajax/promotemember.php",
				data: { CharName : character, Type : type },
				dataType: "json",
				success: function(data){
					if (data.error === false) {
						$(".promote[title=" + character + "]").replaceWith("<a class='demote' title='" + character + "'>Demote</a>");
						if ($('.demote').length == 2) {
							$('.promote').hide();
						}
					}
					alert(data.msg);
				}
			});
		}
	});
	
	$(".demote").live('click', function() {
		//$(this).hide();
		//$("#uploadmessage").html("<img src=\"/images/loading.gif\" alt=\"Working...\" />");
		var character = $(this).attr("title");
		var type = "demote";
		var answer = confirm("Is " + character + " logged out of the game?")
		if (answer){
			$.ajax({
				type: "POST",
				url: "/ajax/promotemember.php",
				data: { CharName : character, Type : type },
				dataType: "json",
				success: function(data){
					if (data.error === false) {
						$(".demote[title=" + character + "]").replaceWith("<a class='promote' title='" + character + "'>Promote</a>");
						if ($('.demote').length < 2) {
							$('.promote').show();
						}
					}
					alert(data.msg);
				}
			});
		}
	});
	
	$(".getmembers").fancybox({
		ajax : {
		    type	: "GET",
			cache   : false
		}
	});
});