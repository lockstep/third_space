$(document).ready ->
  # Problem
  $('#new-problem-textarea').on 'shown.bs.collapse', ->
    $('.fa-chevron-down').removeClass('fa-chevron-down').addClass 'fa-chevron-up'
    $('#new-problem-head-input').html 'What is your problem name?'
    $('html, body').animate { scrollTop: $('#new-problem-head').offset().top }, 500
    $('#next-bar').show()
    $('#tools-bar').hide()
  $('#new-problem-textarea').on 'hidden.bs.collapse', ->
    $('.fa-chevron-up').removeClass('fa-chevron-up').addClass 'fa-chevron-down'
    $('#new-problem-head-input').html 'Write problem name here'
    $('#next-bar').hide()
    $('#tools-bar').show()
  $('#next_link').click ->
    $('#new_problem').submit()

  # Solution
  $('#solution-textarea').on 'shown.bs.collapse', ->
    $('#solution-head .fa-chevron-down').removeClass('fa-chevron-down').addClass 'fa-chevron-up'
    $('html, body').animate { scrollTop: $('#solution-head').offset().top }, 500
    $('#next-bar').show()
    $('#aceit-bar').hide()
  $('#solution-textarea').on 'hidden.bs.collapse', ->
    $('#solution-head .fa-chevron-up').removeClass('fa-chevron-up').addClass 'fa-chevron-down'
    $('#next-bar').hide()
    $('#aceit-bar').show()

  # Result
  $('#result-textarea').on 'shown.bs.collapse', ->
    $('#result-head .fa-chevron-down').removeClass('fa-chevron-down').addClass 'fa-chevron-up'
    $('html, body').animate { scrollTop: $('#result-head').offset().top }, 500
    $('#next-bar').show()
    $('#aceit-bar').hide()
  $('#result-textarea').on 'hidden.bs.collapse', ->
    $('#result-head .fa-chevron-up').removeClass('fa-chevron-up').addClass 'fa-chevron-down'
    $('#next-bar').hide()
    $('#aceit-bar').show()

  # Input submission
  $('.input-textarea').focusout ->
    type = $(this).attr('id').split('-')[0]
    $.ajax(
      url: '/inputs'
      data: {
        input: {
          problem_id: id
          lens: lens
          input_type: type
          input_text: $(this).find('textarea:first').val()
        }
      }
      method: 'POST'
    )
    console.log($(this))
    console.log($(this).find('textarea:first').val())
