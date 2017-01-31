$(document).ready ->
  # Problem
  $(document).on 'shown.bs.collapse', "#new-problem-textarea", ->
    text_submission('new-problem', 'What is your problem name?', true)
    post_problem_submission($(this))

  $(document).on 'hidden.bs.collapse', "#new-problem-textarea", ->
    text_submission('new-problem', 'Write problem name here', false)

  # Review
  $(document).on 'shown.bs.collapse', "#review-textarea", ->
    text_submission('review', 'What is your ACEIT solution?', true)
    set_input_text('review')

  $(document).on 'hidden.bs.collapse', "#review-textarea", ->
    text_submission('review', 'Use ACEIT to write one final solution', false)

  # Lens Result
  $(document).on 'shown.bs.collapse', "#result-textarea", ->
    text_submission('result', 'What is your expected result?', false)
    set_input_text('result')
    show_next_button()
  $(document).on 'hidden.bs.collapse', "#result-textarea", ->
    text_submission('result', 'What is your expected result?', true)

  # Lens Solution
  $(document).on 'shown.bs.collapse', "#result-textarea", ->
    text_submission('solution', 'What is a solution through this lens?', true)
    set_input_text('solution')
    show_next_button()
  $(document).on 'hidden.bs.collapse', "#result-textarea", ->
    text_submission('solution', 'What is a solution through this lens?', false)

  # Input submission
  $('.input-textarea').focusout ->
    post_lens_submission($(this))

  # Review submission
  $('#review-textarea').focusout ->
    post_lens_submission($(this))

  # Open photo dialog
  $(document).on 'click', '#computer', ->
    $('#image-upload').click()

  # Open camera dialog
  $(document).on 'click', '#camera', ->
    $('#image-upload').attr('capture', 'camera').click()

  # Image upload submit
  $(document).on 'change', '#image-upload', (e) ->
    $('#problem-form').submit()

  # Problem next link
  $(document).on 'click', '#next_link', ->
    if $('#new-problem-input').val().length > 1
      post_problem_submission($('#new-problem-textarea'))
      location.href = "/problems/#{id}/adaptability"

  # aceit links
  $(document).on 'click', '.aceit-link', (e) ->
    e.preventDefault()
    if $('#solution-input').val().length > 1
      post_lens_submission($('#solution-textarea'))
    if $('#result-input').val().length > 1
      post_lens_submission($('#result-textarea'))
    location.href = $(this).attr("href")

text_submission = (id, title, show) ->
  first = show ? 'down' : 'up'
  second = show ? 'up' : 'down'
  $(".fa-chevron-#{first}").removeClass("fa-chevron-#{first}").addClass("fa-chevron-#{second}")
  $("##{id}-head-input").html title
  $('html, body').animate { scrollTop: $("##{id}-head").offset().top }, 500
  if show
    $('#next-bar').show()
    $('#tools-bar').hide()
  else
    $('#next-bar').hide()
    $('#tools-bar').show()

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
      $('#next-bar').show()
      $('#aceit-bar').hide()

