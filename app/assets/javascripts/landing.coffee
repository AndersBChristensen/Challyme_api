# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).ready ->
  (($) ->
    $('#header__icon').click (e) ->
      e.preventDefault()
      $('body').toggleClass 'with--sidebar'
      return
    $('#site-cache').click (e) ->
      $('body').removeClass 'with--sidebar'
      return
    return
  ) jQuery
  return