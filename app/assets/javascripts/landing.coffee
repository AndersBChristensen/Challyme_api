# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('#header__icon').click (e) ->
    $('body').toggleClass 'with--sidebar'
    console.debug 'fes'
    e.preventDefault()
    return
  $('#site-cache').click (e) ->
    console.debug(e.target)
    #$('body').removeClass 'with--sidebar'
    return
  return