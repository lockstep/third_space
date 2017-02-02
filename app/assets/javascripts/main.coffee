$(document).ready ->

  # Problem
  $(document).on 'shown.bs.collapse', "#new-problem-textarea", ->
    text_submission('new-problem', 'What is your problem name?', true)
    post_problem_submission($(this))

  $(document).on 'hidden.bs.collapse', "#new-problem-textarea", ->
    text_submission('new-problem', 'Write problem name here', false)

  # Lens Result
  $(document).on 'shown.bs.collapse', "#result-textarea", ->
    text_submission('result', 'What is your expected result?', true)
    set_input_text('result')
    show_next_button()
  $(document).on 'hidden.bs.collapse', "#result-textarea", ->
    text_submission('result', 'What is your expected result?', false)

  # Lens Solution
  $(document).on 'shown.bs.collapse', "#solution-textarea", ->
    text_submission('solution', 'What is a solution through this lens?', true)
    set_input_text('solution')
    show_next_button()
  $(document).on 'hidden.bs.collapse', "#solution-textarea", ->
    text_submission('solution', 'What is a solution through this lens?', false)

  # Input submission
  $('.input-textarea').focusout ->
    post_lens_submission($(this))

  # Open photo/camera dialog
  $('.image-icon').css('cursor','pointer') #iOS fix
  $(document).on 'click', '.image-icon', ->
    $('#image-upload').click()

  # Image upload submit
  $(document).on 'change', '#image-upload', (e) ->
    $('#problem-form').submit()

  # Problem next link
  $(document).on 'click', '#next_link', ->
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
  if show
    klass1 = 'fa-chevron-down'
    klass2 = 'fa-close'
    $('#next-bar').show()
    $('#tools-bar').hide()
  else
    klass1 = 'fa-close'
    klass2 = 'fa-chevron-down'
    $('#next-bar').hide()
    $('#tools-bar').show()
  $("##{id}-icon").removeClass(klass1).addClass(klass2)
  $("##{id}-head-input").html title
  $('html, body').animate { scrollTop: $("##{id}-head").offset().top }, 500

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
  #$.getJSON "/inputs/#{id}/count", (input_count) ->
  #  if input_count == 10
  $('#next-bar').show()
  $('#tools-bar').hide()

