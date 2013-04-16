/**
*
* Tabs.jquery.js
* Leedy
*
*/

!function ($) {
  $.fn.tabs = function () {
    $this = $(this);
    $this.find(".tabs-nav a").click(function(){
      if ($(this).hasClass('active')) {
        return false;
      }; 
      $this.find(".tabs-content > div").slideUp().filter($(this).attr("href")).slideDown();
      $(this).siblings('.active').removeClass('active');
      $(this).addClass('active');
      return false;
    });
    return $this;
  };
  $(document).ready(function() {
    // TODO: 增加 url 中 hash 的跳转
    $('[data-toggle="tabs"]').tabs().find(".tabs-content > div").hide().first().show();
  });
}(window.jQuery);

