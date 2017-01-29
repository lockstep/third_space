$(document).ready ->
  # Problem
  $(document).on 'shown.bs.collapse', "#new-problem-textarea", ->
    $('.fa-chevron-down').removeClass('fa-chevron-down').addClass 'fa-chevron-up'
    $('#new-problem-head-input').html 'What is your problem name?'
    $('html, body').animate { scrollTop: $('#new-problem-head').offset().top }, 500
    $('#next-bar').show()
    $('#tools-bar').hide()
    post_problem_submission($(this))

  $(document).on 'hidden.bs.collapse', "#new-problem-textarea", ->
    $('.fa-chevron-up').removeClass('fa-chevron-up').addClass 'fa-chevron-down'
    $('#new-problem-head-input').html 'Write problem name here'
    $('#next-bar').hide()
    $('#tools-bar').show()

  # Review
  $(document).on 'shown.bs.collapse', "#review-textarea", ->
    $('.fa-chevron-down').removeClass('fa-chevron-down').addClass 'fa-chevron-up'
    $('#review-head-input').html 'What is your ACEIT solution?'
    $('html, body').animate { scrollTop: $('#review-head').offset().top }, 500
    set_input_text('review')

  $(document).on 'hidden.bs.collapse', "#review-textarea", ->
    $('.fa-chevron-up').removeClass('fa-chevron-up').addClass 'fa-chevron-down'
    $('#review-head-input').html 'Use ACEIT to write one final solution'

  # Input submission
  $('.input-textarea').focusout ->
    post_lens_submission($(this))

  # Review submission
  $('#review-textarea').focusout ->
    post_lens_submission($(this))

  # Open photo dialog
  $('#computer').click ->
    $('#image-upload').click()

  # Open camera dialog
  $('#camera').click ->
    $('#image-upload').attr('capture', 'camera').click()

  $(document).on 'click', '#next_link', ->
    if $('#new-problem-input').val().length > 1
      post_problem_submission($('#new-problem-textarea'))
      location.href = "/problems/#{id}/adaptability"

  $(document).on 'click', '.aceit-link', (e) ->
    e.preventDefault()
    if $('#solution-input').val().length > 1
      post_lens_submission($('#solution-textarea'))
    if $('#result-input').val().length > 1
      post_lens_submission($('#result-textarea'))
    location.href = $(this).attr("href")

  $(document).on 'change', '#image-upload', (e) ->
    $('#problem-form').submit()

  input_textarea('solution')
  input_textarea('result')

post_problem_submission = (el) ->
  name = el.find('textarea:first').val()
  if name.length > 3
    $.ajax(
      url: "/problems/#{id}"
      method: 'PATCH'
      data: {
        problem: {
          id: id
          name: name
        }
      }
    )

post_lens_submission = (el) ->
  $.ajax(
    url: '/inputs'
    method: 'POST'
    data: {
      input: {
        problem_id: id
        lens: lens
        input_type: el.attr('id').split('-')[0]
        input_text: el.find('textarea:first').val()
      }
    }
  )

set_input_text = (input_type) ->
  $.getJSON "/inputs/#{id}/#{lens}/#{input_type}", (input_text) ->
    if input_text
      $("##{input_type}-textarea").find('textarea:first').val(input_text)

show_next_button = ->
  $.getJSON "/inputs/#{id}/count", (input_count) ->
    if input_count == 10
      console.log(input_count)
      $('#next-bar').show()
      $('#aceit-bar').hide()

input_textarea = (input_type) ->
  $(document).on 'shown.bs.collapse', "##{input_type}-textarea", ->
    $("##{input_type}-head .fa-chevron-down").removeClass('fa-chevron-down').addClass 'fa-chevron-up'
    $('html, body').animate { scrollTop: $("##{input_type}-head").offset().top }, 500
    set_input_text(input_type)
    show_next_button()
  $(document).on 'hidden.bs.collapse', "##{input_type}-textarea", ->
    $("##{input_type}-head .fa-chevron-up").removeClass('fa-chevron-up').addClass 'fa-chevron-down'

