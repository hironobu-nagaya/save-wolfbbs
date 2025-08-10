'use strict';

$(document).ready(function() {
  history.pushState(null, null, null);
  var $mains = $('html > body > main');
  var $selectMode = $('#select-mode');
  var $selectDays = $('#select-day > a');
  $selectDays.click(function() {
    var $thisSelectDay = $(this);
    if ($thisSelectDay.hasClass('selected')) {
      return;
    }
    var day = $thisSelectDay.attr('id').substring(11);
    if ($('#day-' + day).hasClass('order')) {
      $selectMode.hide();
    } else {
      $selectMode.show();
    }
    $selectDays.removeClass('selected');
    $thisSelectDay.addClass('selected');
    $mains.hide();
    $('#day-' + day).show();
    pushState();
    window.scrollTo(0, 0);
  });

  var $nextDays = $('html > body > main > a');
  $nextDays.click(function() {
    $('#select-day-' + (parseInt($(this).parent().attr('id').substring(4), 10) + 1)).trigger('click');
  });

  var $selectModes = $('#select-mode > a');
  $selectModes.click(function() {
    var $thisSelectMode = $(this);
    if ($thisSelectMode.hasClass('selected')) {
      return;
    }
    $selectModes.removeClass('selected');
    $thisSelectMode.addClass('selected');
    pushState();
  });

  var $allArticles = $("html > body > main article");
  var $privateArticles = $allArticles.filter('article.private');
  var $wolfArticles = $allArticles.filter('article.wolf');
  var $graveArticles = $allArticles.filter('article.grave');

  $('#select-public').click(function() {
    $privateArticles.hide();
    $wolfArticles.hide();
    $graveArticles.hide();
  });

  $('#select-wolf').click(function() {
    $privateArticles.hide();
    $graveArticles.hide();
    $wolfArticles.show();
  });

  $('#select-grave').click(function() {
    $privateArticles.hide();
    $wolfArticles.hide();
    $graveArticles.show();
  });

  $('#select-all').click(function() {
    $privateArticles.show();
    $wolfArticles.show();
    $graveArticles.show();
  });

  toggleArticles(getParam('mode'));
  var day = getParam('day');
  if (!day) {
    day = 0;
  }
  var $selectDayByParam = $('#select-day-' + day);
  if ($selectDayByParam.length === 0) {
    $selectDayByParam = $('#select-day-' + $('main.order').attr('id').substring(4));
  }
  $selectDayByParam.trigger('click');

  window.addEventListener('popstate', function(e) {
    var day = getParam('day');
    if (!day) {
      day = 0;
    }
    var $main = $('#day-' + day);
    if ($main.length === 0) {
      $main = $('main.order');
      day = $main.attr('id').substring(4);
    }
    $mains.hide();
    $main.show();
    if ($main.hasClass('order')) {
      $selectMode.hide();
    } else {
      $selectMode.show();
    }
    $selectDays.removeClass('selected');
    $('#select-day-' + day).addClass('selected');

    var mode = getParam('mode');
    if (mode !== 'public' && mode !== 'private' && mode !== 'grave') {
      mode = 'all';
    }
    $selectModes.removeClass('selected');
    $('#select-' + mode).addClass('selected');
    toggleArticles(mode);
　});

  $('a[id^="time-reference-"]').hover(function() {
    var $thisAnchor = $(this);
    var timeReferenceNumber = $thisAnchor.attr('id').substring(15);
    var $referenced = $('#time-referenced-' + timeReferenceNumber);
    if ($referenced.length > 0) {
      $referenced.fadeIn();
      return;
    }
    var thisAnchorClass = $thisAnchor.attr('class');
    var day = thisAnchorClass.substring(5, thisAnchorClass.indexOf('d'));
    $referenced = $('<div id="time-referenced-' + timeReferenceNumber + '"></div>');
    $referenced.append($('main#day-' + day + ' > article.' + thisAnchorClass).clone()).find('*').attr('id', null);
    $thisAnchor.parents('article').after($referenced);
  }, function() {
    $('#time-referenced-' + $(this).attr('id').substring(15)).fadeOut();
  });

  $('a[id^="message-reference-"]').hover(function() {
    var $thisAnchor = $(this);
    var messageReferenceNumber = $thisAnchor.attr('id').substring(18);
    var $referenced = $('#message-referenced-' + messageReferenceNumber);
    if ($referenced.length > 0) {
      $referenced.fadeIn();
      return;
    }
    $referenced = $('<div id="message-referenced-' + messageReferenceNumber + '"></div>');
    $referenced.append($('main > article.' + $thisAnchor.attr('class')).clone()).find('*').attr('id', null);
    $thisAnchor.parents('article').after($referenced);
  }, function() {
    $('#message-referenced-' + $(this).attr('id').substring(18)).fadeOut();
  });

  function toggleArticles(mode) {
    switch(mode) {
      case 'public':
        $privateArticles.hide();
        $wolfArticles.hide();
        $graveArticles.hide();
        break;
      case 'wolf':
        $privateArticles.hide();
        $graveArticles.hide();
        $wolfArticles.show();
        break;
      case 'grave':
        $privateArticles.hide();
        $wolfArticles.hide();
        $graveArticles.show();
        break;
      default:
        $privateArticles.show();
        $wolfArticles.show();
        $graveArticles.show();
        break;
    }
  }

  function pushState() {
    history.pushState(null, null, '?day=' + $('#select-day > a.selected').attr('id').substring(11) + '&mode=' + $('#select-mode > a.selected').attr('id').substring(7));
  }

  function getParam(name) {
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)");
    var results = regex.exec(window.location.href);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
  }
});

