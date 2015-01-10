var calendarInfo = $.parseJSON('[]');
var currentEventIndex = 0;
var eventIntervalID = -1;
var eventTimes = [];
var serverDate = new Date();

$(function() {
	$('nav').css({
		'display': 'block'
	});
	$('.menu').menu();
	$('.menu').css({
		'position': 'absolute'
	});
	$('.menu').hide();
	$('.menu').prev().mouseenter(function () {
		$(this).next().show();
	}).mouseleave(function () {
		$(this).next().hide();
	});
	$('.menu').mouseenter(function () {
		$(this).show();
	}).mouseleave(function () {
		$(this).hide();
	});
	
	$('.event .nextEvent > a').each(function (index) {
		eventTimes[index] = $(this).attr('time');
		$(this).button();
		$(this).click(function () {
			clearInterval(eventIntervalID);
			currentEventIndex = index;
			eventButtonClick();
			eventIntervalID = setInterval(scrollEvent, 5000);
			return false;
		}).mouseout(function ()  {
			if (index == currentEventIndex) {
				eventButtonClick();
			}
		});
		if ($('.event .nextEvent > a').length == 1) {
			$(this).hide();
		}
	});
	
	var now = new Date();
	loadCalendarInfo(now.getFullYear(), (now.getMonth() + 1));
    $.datepicker._updateDatepicker_original = $.datepicker._updateDatepicker;
    $.datepicker._updateDatepicker = function(inst) {
        $.datepicker._updateDatepicker_original(inst);
        var afterShow = this._get(inst, 'afterShow');
        if (afterShow)
            afterShow.apply((inst.input ? inst.input[0] : null));  // trigger custom callback
    }
	var calendarHTML = $('.calendar').html();
	$('.calendar').html('');
	$('.calendar').datepicker({
		showOtherMonths: true,
		selectOtherMonths: true,
		showWeek: true,
		firstDay: 1,
		onChangeMonthYear: loadCalendarInfo,
		beforeShowDay: function (d) {
			var month = (d.getMonth() + 1);
			if (month < 10) month = "0" + month;
			var day = d.getDate();
			if (day < 10) day = "0" + day;
			var date = d.getFullYear() + '-' + month  + '-' + day;
			var info = null;
			$.each(calendarInfo, function (index, value) {
				if (value.Date != date) return;
				info = value.Info;
			});
			if (info == null) {
				return [true, '', ''];
			} else {
				return [info.CanSelect, info.Class, info.Tooltip];
			}
		},
		onSelect: function (d) {
			var date = new Date(d);
			location.href = "/calendar.php?year=" + date.getFullYear() + "&month=" + (date.getMonth() + 1) + "&day=" + date.getDate();
		},
		afterShow : function () {
			$('.calendar td[title]').each(function (index) {
				$(this).attr('title', $(this).attr('title').replace(new RegExp('\\)', 'g'), ')<br />'))
			});
			$('.calendar td[title]').tooltip({
				content: function () {
					return $(this).attr("title");
				},
				track : true
			});
		}
	});
	$('.calendar > div').append(calendarHTML);
	if ($('.calendar .ui-datepicker-today').length > 0) {
		var currentYear = $('.calendar').attr('current-year');
		var currentMonth = $('.calendar').attr('current-month');
		var currentDay = $('.calendar').attr('current-day');
		if (currentYear != $('.calendar .ui-datepicker-today').attr('data-year') &&
			currentMonth != $('.calendar .ui-datepicker-today').attr('data-month') &&
			currentDay != $('.calendar .ui-datepicker-today > a').text()) {
			$('.calendar .ui-datepicker-today').children().removeClass('ui-state-highlight').removeClass('ui-state-active');
			$('.calendar .ui-datepicker-today[data-year="' + currentYear + '"][data-month="' + currentMonth + '"] > a:contains("' + currentDay + '")').addClass('ui-state-highlight').addClass('ui-sate-active');
		}
	}
	serverDate.setTime((parseInt($('.calendar').attr('current-time')) + parseInt($('.calendar').attr('utc-offset')) + (serverDate.getTimezoneOffset() * 60)) * 1000);
	
	$(window).resize(windowResized);
	windowResized();
	
	eventIntervalID = setInterval(scrollEvent, 5000);
	setInterval(tickEventTimes, 1000);
});

function loadCalendarInfo(year, month) {
	month -= 1;
	var firstDay = new Date(year, month, 1);
	var startDate = new Date(firstDay.getTime() - (7 * 24 * 60 * 60 * 1000));
	var endDate = new Date(firstDay.getTime() + (38 * 24 * 60 * 60 * 1000));
	calendarInfo = $.parseJSON($.ajax({
		type: "GET",
		url: '/calendar.php?startDate=' + startDate.getFullYear() + '-' + (startDate.getMonth() + 1) + '-' + startDate.getDate() + '&endDate=' + endDate.getFullYear() + '-' + (endDate.getMonth() + 1) + '-' + endDate.getDate(),
		async: false,
	}).responseText);
}

function scrollEvent() {
	currentEventIndex++;
	if (currentEventIndex >= $('.event .nextEvent > a').length) currentEventIndex = 0;
	eventButtonClick();
}

function eventButtonClick() {
	var a = $('.event .nextEvent > a:nth-child(' + (currentEventIndex + 1) + ')');
	if (!a.hasClass('ui-state-active')) {
		$('.event .nextEvent > a').removeClass('ui-state-active');
		a.addClass('ui-state-active');
	}
	if (!$('article.event').hasClass(a.attr('event'))) {
		$('article.event').removeClass().addClass('event').addClass(a.attr('event'));
	}
	updateEventTimeText();
}

function tickEventTimes() {
	$('.event .nextEvent > a').each(function (index) {
		eventTimes[index]--;
		if (eventTimes[index] < 0) {
			eventTimes[index] = 0;
		}
	});
	eventButtonClick();
	serverDate.setTime(serverDate.getTime() + 1000);
	$('#currentDate').html(ordinal(serverDate.getDate()) + ' ' + $.datepicker.formatDate('MM yy', serverDate));
	$('#currentTime12').html((serverDate.getHours() > 12 ? (serverDate.getHours() - 12) : serverDate.getHours()) + ':' + serverDate.getMinutes() + ' ' + (serverDate.getHours() > 12 ? 'PM' : 'AM'));
	$('#currentTime24').html(serverDate.getHours() + ':' + serverDate.getMinutes() + ':' + serverDate.getSeconds());
}

function updateEventTimeText() {
	var days = Math.floor(eventTimes[currentEventIndex] / 86400);
	var hours = Math.floor((eventTimes[currentEventIndex] - (days * 86400)) / 3600);
	var minutes = Math.floor((eventTimes[currentEventIndex] - (days * 86400) - (hours * 3600)) / 60);
	var seconds = (eventTimes[currentEventIndex] - (days * 86400) - (minutes * 60) - (hours * 3600));
	var time;
	if (days > 0) {
		time = days + "d";
		if (hours > 0) {
			time += hours + "h";
		}
	} else if (hours > 0) {
		time = hours + "h";
		if (minutes > 0) {
			time += "" + minutes;
		}
	} else if (minutes > 0) {
		time = minutes + "m";
		if (seconds > 0) {
			time += "" + seconds;
		}
	} else if (seconds > 0) {
		time = seconds + "s";
	} else {
		time = "ongoing"
	}
	if (time == "ongoing") {
		$('.currentEvent').html('In Progress!');
	} else {
		$('.currentEvent').html('Starting in ' + time);
	}
}

function windowResized() {
	var width = $('body').width();
	var fullMargin = (width - $('.content').width());
	var margin = Math.floor(fullMargin / 2);
	$('.content').css({
		'margin-left': margin + 'px',
		'margin-right': (fullMargin - margin) + 'px'
	});
}

function ordinal(n) {
	var sfx = ["th","st","nd","rd"];
	var val = n%100;
	return n + "<sup>" + (sfx[(val-20)%10] || sfx[val] || sfx[0]) + "</sup>";
}