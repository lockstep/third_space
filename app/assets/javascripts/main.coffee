$(document).on 'turbolinks:load', ->

  # Lens Solution
  $(document).on 'shown.bs.collapse', "#solution-textarea", ->
    set_input_text('solution')
    show_elements(['solution-textarea', 'next-bar'])
    hide_elements(['tools-bar'])
    $("#solution-icon").removeClass('fa-chevron-down').addClass('fa-close')

  $(document).on 'hidden.bs.collapse', "#solution-textarea", ->
    show_elements(['tools-bar'])
    hide_elements(['solution-textarea', 'next-bar'])
    $("#solution-icon").removeClass('fa-close').addClass('fa-chevron-down')

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
    location.href = $(this).attr("href")

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

show_elements = (elements) ->
  $.each elements, (index, element) =>
    $("##{element}").show()

hide_elements = (elements) ->
  $.each elements, (index, element) =>
    $("##{element}").hide()

