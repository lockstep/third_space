$(document).ready ->

  # Cover / fill the image on the screen
  $item = $('.carousel .carousel-item')
  $wHeight = $(window).height()
  $item.eq(0).addClass 'active'
  $item.height $wHeight
  $item.addClass 'full-screen'
  $('.carousel img').each ->
    $src = $(this).attr('src')
    $color = $(this).attr('data-color')
    $(this).parent().css
      'background-image': 'url(' + $src + ')'
      'background-color': $color
    $(this).remove()
  $(window).on 'resize', ->
    $wHeight = $(window).height()
    $item.height $wHeight

  # Stop sliding at last slide
  $('.carousel').carousel
    wrap: false

  # Swipe between carousel pages using jquery-mobile
  $('#welcome-carousel').swiperight ->
    $(this).carousel 'prev'
  $('#welcome-carousel').swipeleft ->
    $(this).carousel 'next'
