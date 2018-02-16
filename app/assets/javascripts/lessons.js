var LESSON = {
  init: function(){
    // important objects
    LESSON._date = $('#datepicker');
    LESSON._slot = $('#lesson_lesson_time_slot');
    LESSON._duration = $('#lesson_duration');
    LESSON._durations = {
      'one': $('#lesson_duration option:eq(1)'),
      'two': $('#lesson_duration option:eq(2)'),
      'three': $('#lesson_duration option:eq(3)'),
      'six': $('#lesson_duration option:eq(4)')
    };
    LESSON._startTime = $('#timepicker');
    LESSON._actualStartTime = $('#start-timepicker');
    LESSON._actualEndTime = $('#end-timepicker');

    // set datepicker
    LESSON.setDatepicker();

    // set and toggle duration enablement
    LESSON.toggleDuration();
    LESSON._slot.change(LESSON.toggleDuration);

    // set and toggle start_time enablement
    LESSON.toggleStartTime();
    LESSON._duration.change(LESSON.toggleStartTime);

    // configure and update timepickers
    LESSON.setTimepickers();
    LESSON._slot.change(LESSON.updateRequesterTimepicker);
    LESSON._duration.change(LESSON.updateRequesterTimepicker);
    LESSON._actualStartTime.change(LESSON.updateInstructorTimepickers);
  },

  // setDatepicker: function() { LESSON._date.datepicker({ minDate: '2016-12-16', dateFormat: 'yy-mm-dd' }); },
  setDatepicker: function() { LESSON._date.datepicker({ minDate: 0, maxDate: '2017-12-31', dateFormat: 'yy-mm-dd' }); },

  // var TODAYS_DATE = new Date().getDate();
  // var LAUNCH_DATE = new Date('2016','11','16').getDate();
  // if ((launch - today) > 0 ){
  //   setDatepicker: function() { LESSON._date.datepicker({ minDate: '2016-12-16', dateFormat: 'yy-mm-dd' }); }
  // } else {
  //   setDatepicker: function() { LESSON._date.datepicker({ minDate: 0, dateFormat: 'yy-mm-dd' }); }
  // }

  toggleDuration: function() {
    if (LESSON.slotValid()) {
      LESSON.enable(LESSON._duration);
      LESSON.configureDuration();
    } else {
      LESSON.clearAndDisable(LESSON._duration);
      LESSON.clearAndDisable(LESSON._startTime);
    }
  },

  toggleStartTime: function() {
    if (LESSON.slotValid() && LESSON.durationValid()) { LESSON.enable(LESSON._startTime);
    } else { LESSON.clearAndDisable(LESSON._startTime); }
  },

  setTimepickers: function() {
    LESSON._startTime.timepicker({ 'step': 30 });
    LESSON.configureRequesterTimepicker();
    LESSON.configureConfirmTimepickers();
  },

  updateRequesterTimepicker: function() { LESSON.configureRequesterTimepicker(true); },

  updateInstructorTimepickers: function() { LESSON.configureConfirmTimepickers(); },

  // private methods

  slotValid: function() {
    var slot = LESSON._slot.val();
    return (slot === 'Morning' || slot === 'Afternoon' || slot === 'Full Day');
  },

  durationValid: function() {
    var duration = LESSON._duration.val();
    return (duration === '2' || duration === '3' || duration === '6');
  },

  enable: function(object) { object.prop('disabled', false); },

  disable: function(object) { object.prop('disabled', true); },

  setValue: function(object, value) { object.val(value); },

  clearAndDisable: function(object) {
    LESSON.setValue(object, null);
    LESSON.disable(object);
  },

  configureDuration: function() {
    var slot = LESSON._slot.val();
    var duration = LESSON._duration.val();
    LESSON.setDurationValue(slot, duration);
    LESSON.setDurationOptions(slot);
  },

  setDurationValue: function(slot, duration) {
    if (slot === 'Full Day') { LESSON.setValue(LESSON._duration, 6);
    } else if (duration === '6') { LESSON.setValue(LESSON._duration, null); }
  },

  setDurationOptions: function(slot) {
    if (slot === 'Full Day') { LESSON.configureDurationOptions('disable', 'enable');
    } else { LESSON.configureDurationOptions('enable', 'disable'); }
  },

  configureDurationOptions: function(slotStatus, fullDayStatus) {
    LESSON[slotStatus](LESSON._durations.two);
    LESSON[slotStatus](LESSON._durations.three);
    LESSON[fullDayStatus](LESSON._durations.six);
  },

  configureRequesterTimepicker: function(u) {
    var updating = typeof u !== 'undefined' ? u : false;

    if (LESSON.slotValid() && LESSON.durationValid()) {
      LESSON.setMinAndMaxTime();
      LESSON.checkStartTime(updating);
      LESSON.updateMinAndMaxTime();
    }
  },

  setMinAndMaxTime: function() {
    var slot = LESSON._slot.val();
    var duration = LESSON._duration.val();
    LESSON.setMinTime(slot);
    LESSON.setMaxTime(slot, duration);
  },

  setMinTime: function(slot) { LESSON.minTime = (slot === 'Afternoon' ? '1:00pm' : '9:00am'); },

  setMaxTime: function(slot, duration) {
    var cases = {
      "Morning|2": '10:30am',
      "Morning|3": '9:30am',
      "Afternoon|2": '2:00pm',
      "Afternoon|3": '1:00pm',
      'Full Day|6': '9:30am'
    };

    LESSON.maxTime = cases[slot + "|" + duration];
  },

  checkStartTime: function(updating) {
    if (LESSON.minTime === LESSON.maxTime) {
      if (updating) { LESSON.setValue(LESSON._startTime, LESSON.minTime); }
      LESSON.maxTime = '1:01pm';
    } else if (updating) { LESSON._startTime.val(null); }
  },

  updateMinAndMaxTime: function() {
    LESSON._startTime.timepicker('option', 'minTime', LESSON.minTime);
    LESSON._startTime.timepicker('option', 'maxTime', LESSON.maxTime);
  },

  configureConfirmTimepickers: function() {
    LESSON.initializeConfirmTimepickers();
    LESSON.updateActualEndTimepicker();
  },

  initializeConfirmTimepickers: function() {
    LESSON._actualStartTime.timepicker({ 'minTime': '9:00am', 'maxTime': '1:00pm', 'step': 60 });
    LESSON._actualEndTime.timepicker({ 'minTime': '10:00am', 'maxTime': '4:00pm', 'step': 60 });
    LESSON.disable(LESSON._actualEndTime);
  },

  updateActualEndTimepicker: function() {
    var actualStartTime = LESSON._actualStartTime.val();
    if (actualStartTime !== null) {
      LESSON._actualEndTime.timepicker('option', 'minTime', actualStartTime);
      LESSON.enable(LESSON._actualEndTime);
    }
  }
};

$(function() { LESSON.init(); });
$(window).bind('page:change', function() { LESSON.init(); });
// pre-load first student form



$(document).ready(function(){
  if($('.remove-student').length <=1){
    $('#add-student-button').click();
    // console.log("loaded first student.");
  };
  if($('#preSeasonModalButton').length > 0){
    $('#preSeasonModalButton').click();
    console.log("triggered preSeasonModal");
  }
  calculatePriceListener();
  // calculateTotalListener();
  toggleElementListener();
  abilityLevelWarningListener();
});

var abilityLevelWarningListener = function(){
  $('#add-student-button').click(function(e){
    $('#ability-level-warning').removeClass('hidden');
    console.log("removed hidden status of ability warning line.");
  });
}

var calculatePriceListener = function() {
  var hourlyRate = 75;
  $('.lesson-length-input').change(function(e){
    e.preventDefault();
    console.log("listening for changes to lesson_length");
    var lesson_length = $('.lesson-length-input').val();
      console.log("the input value is:" + lesson_length);
    var lesson_price = lesson_length*hourlyRate;
      console.log("the lesson price is:" +lesson_price);
    $('#donation-amount').html(lesson_price);
  });
  $('.lesson-slot-input').change(function(e){
    console.log("detected slot change.");
    if ( $('.lesson-slot-input').val() == 'Full Day'){
    console.log("the lesson slot is now full day.");
    var lesson_price = 6*hourlyRate;
    console.log("lesson price is: "+lesson_price)
    $('#donation-amount').html(lesson_price);
    };
  });
}

// Abandoned this approach for now
var calculateTotalListener = function() {
  console.log("totalListener is listening...");
  $('tip-amount-input').change(function(e){
    e.preventDefault();
    console.log("listening for changes to the tip");
    var tip_amount = $('tip-amount-input').val();
    var base_amount = $('base-amount-input').val();
      console.log("the tip amount is:" + tip_amount);
    var total_amount = base_amount + tip_amount;
      console.log("the lesson price is:" +total_amount);
    $('#transaction_final_amount').html(total_amount);
  });
}

var toggleElementListener = function(){
  $('#toggle-completed-lessons').click(function(e){
    e.preventDefault();
    $('#completed-lessons').toggleClass('hidden');
    console.log("lessons revealed, buttons switched.");
  });
   $('#toggle-upcoming-lessons').click(function(e){
    e.preventDefault();
    $('#upcoming-lessons').toggleClass('hidden');
    console.log("lessons revealed, buttons switched.");
  });
    $('#toggle-available-lessons').click(function(e){
    e.preventDefault();
    $('#available-lessons').toggleClass('hidden');
    console.log("lessons revealed, buttons switched.");
  });
    $('#toggle-filter-options').click(function(e){
    e.preventDefault();
    $('#secondary-search-filters').toggleClass('hidden-unless-desktop');
    console.log("filters revealed.");
  });
    $('#toggle-more-info').click(function(e){
    e.preventDefault();
    $('#more-info').toggleClass('hidden');
    console.log("info revealed.");
  });
}

$(function(){
  $("#search_date").datepicker();
})