# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
//= require twitter-text

@example = {
    screen_name: 'perfect_pie',
    name: 'TartesSansFrontières',
    description: 'Welcome to Pieland! PSN ID: pie_perfect_pie; 3DS friend-code: 1607-2031-6706',
    profile_image_url: 'http://pbs.twimg.com/profile_images/561639701547732993/i8YzWTMP_normal.jpeg',
    protected: false,
    following: false
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
      $('#UserInfo').html(InsertUserData(res)).promise().done ->
        if $('#account').data('protected')
              $('#account').addClass('fa-lock')
  return

@InsertUserData = (user) ->
  return '<div class="panel panel-default">
          <div class="media">
          <div class="media-left">
            <a href="#">
              <img class="media-object" src="'+user.profile_image_url+'" alt="'+user.name+'">
            </a>
          </div>
          <div class="media-body">
            <h4 class="media-heading">'+twttr.txt.autoLink('@'+user.screen_name)+' '+user.name+' <i class="fa" id="account" data-screenname="'+user.screen_name+'" data-protected="'+user.protected+'" data-following="'+user.following+'"></i> </h4>
            '+twttr.txt.autoLink(user.description)+'
            <br/>
            <a href="https://twitter.com/'+user.screen_name+'" target="_blank" class="btn btn-primary" id="twitter-open" data-screenname="'+user.screen_name+'" ><i class="fa fa-twitter"></i> Твиттер</a>
            <button type="button" onclick="OpenGallery()"  class="btn btn-success" id="gallery-open" data-screenname="'+user.screen_name+'"><i class="fa fa-picture-o"></i> Картиночки</button>
            <button type="button" onclick="ClearFields(1)" class="btn btn-danger" id="twitter-close" data-screenname="'+user.screen_name+'"><i class="fa fa-trash"></i> Очистить</button>
          </div></div>'

@InsertImageData = (image) ->
  console.log image
  if image.entities.media
    $.each image.entities.media, (k,v) ->
      if v.media_url
        $("#panel-gallery").append('<a href="http://'+v.display_url+'" target="_blank" alt="Открыть в отдельном окне"><img src="'+v.media_url+'" width="'+v.sizes.thumb.w+'" height="'+v.sizes.thumb.h+'"></a>')

@InitializeGallery = ->
    return '<div class="panel panel-default">
      <div class="panel-heading">
        Картиночки @'+$('#account').data('screenname')+'
      </div>
      <div class="panel-body" id="panel-gallery">
      </div>
    </div>'



 @OpenGallery = ->
  if $('#account').data('protected') == true && $('#account').data('following') == false
    $("#UserGallery").html('Аккаунт закрытый и Вы не фолловите аккаунт')
  else
    screenname = $('#gallery-open').data('screenname')
    $("#UserGallery").html(InitializeGallery())
    $('#gallery-open').addClass('disabled').html('<i class="fa fa-spinner fa-spin"></i>  Loading')
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
  $('#search_button').addClass('disabled').html('<i class="fa fa-spinner fa-spin"></i>  Loading')
  ClearFields()
  text = $('input#search_form').val()
  if twttr.txt.isValidUsername(text) || twttr.txt.isValidUsername("@" + text)
    CorrectUser()
  else
    NotFound()

@ClearFields = (opt) ->
  $('#errors').text('')
  $('#UserGallery').text('')
  if opt == 1
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
