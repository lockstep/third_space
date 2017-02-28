var isTipClicked = localStorage.getItem("isTipClicked");

function createSlider(container_class, pagination_class) {
  var swiper = new Swiper(container_class, {
    pagination: pagination_class,
    paginationClickable: true
  });
}

function stopShakingTip(comparation) {
  if(comparation) {
    $(".tip__icon").removeClass("shake");
  }
}
