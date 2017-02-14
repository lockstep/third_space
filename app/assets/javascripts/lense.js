var hide_elements, show_elements;
show_elements = function(elements) {
  return $.each(elements, (function(_this) {
    return function(index, element) {
      return $("#" + element).show();
    };
  })(this));
};
hide_elements = function(elements) {
  return $.each(elements, (function(_this) {
    return function(index, element) {
      return $("#" + element).hide();
    };
  })(this));
};

$(document).on('shown.bs.collapse', "#solution-textarea", function() {
  hide_elements(['navbar-bottom']);
  show_elements(['next-bar']);
  return $("#solution-icon").removeClass('fa-chevron-down').addClass('fa-close');
});

$(document).on('hidden.bs.collapse', "#solution-textarea", function() {
  show_elements(['navbar-bottom']);
  hide_elements(['next-bar']);
  return $("#solution-icon").removeClass('fa-close').addClass('fa-chevron-down');
});
