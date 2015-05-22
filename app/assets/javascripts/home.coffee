# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
//= require twitter-text

@CorrectUser = ->
  $("input#search_form").parent().addClass("has-success").removeClass('has-error')
  $('#panel-errors').text("")
  $('#panel-form').removeClass('panel-default').removeClass('panel-danger').addClass('panel-success')

@FindUser = (user) ->
  return true

@NotFound = ->
  $("input#search_form").parent().addClass("has-error")
  $('#panel-errors').text("Чет неправильный твиттор")
  $('#panel-form').removeClass('panel-default').removeClass('panel-success').toggleClass('panel-danger')


@CheckInput = ->
  $('#search_button').addClass('disabled').text('Loading')
  text = $('input#search_form').val()
  if twttr.txt.isValidUsername(text)
    CorrectUser()
  else if twttr.txt.isValidUsername("@" + text)
    CorrectUser()
  else
    NotFound()
  $('#search_button').removeClass('disabled').text('Go')


$(document).ready ->
  $('#search_button').click ->
    CheckInput()
    return
  $('#search_form').keypress (e) ->
    if e.which == 13 
      e.preventDefault()
      CheckInput()
    return
  return
