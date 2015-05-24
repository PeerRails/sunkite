# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
//= require twitter-text

@example = {
    screen_name: 'perfect_pie',
    name: 'TartesSansFrontières',
    description: 'Welcome to Pieland! PSN ID: pie_perfect_pie; 3DS friend-code: 1607-2031-6706',
    profile_image_url: 'http://pbs.twimg.com/profile_images/561639701547732993/i8YzWTMP_normal.jpeg'
  }

@CorrectUser = ->
  user = $('input#search_form').val()
  $('#panel-errors').text("")
  $('#panel-form').removeClass('panel-default').removeClass('panel-danger').addClass('panel-success')
  FindUser(user).done (res) ->
    if res.error
      $('#errors').html('Error: ' + res.error.rate_limit.status + '<button type="button" class="close" onclick="$(\'#errors\').html(\'\')" aria-label="Close"><span aria-hidden="true">&times;</span></button>')
    else if res == null 
      $('#UserInfo').text('Not Found')
    else
      $('#UserInfo').html(InsertUserData(res))

  return

@InsertUserData = (user) ->
  return '<div class="media">
          <div class="media-left">
            <a href="#">
              <img class="media-object" src="'+user.profile_image_url+'" alt="'+user.name+'">
            </a>
          </div>
          <div class="media-body">
            <h4 class="media-heading">@'+user.screen_name+' '+user.name+'</h4>
            '+user.description+'
            <br/>
            <a href="https://twitter.com/'+user.screen_name+'" target="_blank" class="btn btn-primary" id="twitter-open" data-screenname="'+user.screen_name+'" ><i class="fa fa-twitter"></i> Твиттер</a>
            <button type="button" onclick="OpenGallery()"  class="btn btn-success" id="gallery-open" data-screenname="'+user.screen_name+'"><i class="fa fa-picture-o"></i> Картиночки</button>
            <button type="button" onclick="ClearFields()" class="btn btn-danger" id="twitter-close" data-screenname="'+user.screen_name+'"><i class="fa fa-trash"></i> Очистить</button>
          </div>'

@InitializeTable = ->
  html = '
    <table class="table" id="pictable">

    </table>
  '
  $('#UserGallery').html(html)

@InsertImageData = (image) ->
  console.log image



 @OpenGallery = ->
  screenname = $('#gallery-open').data('screenname')
  $('#gallery-open').addClass('disabled').html('<i class="fa fa-spinner fa-spin"></i>Loading')
  GetImages(screenname).done (data) ->
    if data == null
      $('#UserGallery').html('А картинок-то и нет :с\nПопробуйте попозже')
    else if data.length == 0
      $('#UserGallery').html('А картинок-то и нет :с')
    else
      $.each data, (k, v) ->
        InsertImageData(v)
        return
  
@GetImages = (screenname) ->
  $.get('user/get_images?user='+screenname).done( (data) ->
      return data
    ).fail( ->
      return null
    ).always( ->
      $('#gallery-open').removeClass('disabled').html('<i class="fa fa-picture-o"></i> Картиночки')
    )

@FindUser = (user) ->
  $.get('user/get_user?user='+user).done( (data) ->
    return data
  ).fail( ->
    return null
  ).always( ->
    $('#search_button').removeClass('disabled').text('Go')
    $('#panel-form').removeClass('panel-danger').removeClass('panel-success').toggleClass('panel-default')
  )

@NotFound = ->
  $("input#search_form").parent().addClass("has-error")
  $('#panel-errors').text("Чет неправильный твиттор")
  $('#panel-form').removeClass('panel-default').removeClass('panel-success').toggleClass('panel-danger')
  $('#search_button').removeClass('disabled').text('Go')


@CheckInput = ->
  $('#search_button').addClass('disabled').text('Loading')
  ClearFields
  text = $('input#search_form').val()
  if twttr.txt.isValidUsername(text)
    CorrectUser()
  else if twttr.txt.isValidUsername("@" + text)
    CorrectUser()
  else
    NotFound()

@ClearFields = ->
  $('#errors').text('')
  $('#UserGallery').text('')
  $('#UserInfo').html('<button type="button" onclick="$(\'#UserInfo\').html(InsertUserData(example))" class="btn btn-primary">Жми</button> сюда, чтобы снова увидеть пример')


$(document).ready ->
  $('#UserInfo').html(InsertUserData(example))
  $('#search_button').click ->
    CheckInput()
    return
  $('#search_form').keypress (e) ->
    if e.which == 13 
      e.preventDefault()
      CheckInput()
    return
  return
