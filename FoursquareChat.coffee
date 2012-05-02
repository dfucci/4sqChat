Rooms = new Meteor.Collection 'Rooms'

if Meteor.is_client
  code = window.location.href.split('=')[1]
  if not code?

  else
    $.get "https://api.foursquare.com/v2/users/self?oauth_token=#{code}", (data)-> 
      user = data.response.user.firstName
      venueName = data.response.user.checkins.items[0].venue.name
      venueid = data.response.user.checkins.items[0].venue.id
      Session.set 'name', user
      Session.set 'venueName', venueName
      Session.set 'venueID', venueid
  #console.log Rooms.find({venueid:'4bc464352a89ef3b652ef688'}).count() 
      vid = Session.get 'venueID'
      venueName = Session.get 'venueName'
      if  Rooms.find({venueid:vid}).count() is 0
        Rooms.insert(name:venueName,venueid:vid, messages:[]) 
  Template.myrooms.roomName = ->
      Session.get 'venueName'
  Template.entry.userName = ->
      Session.get 'name'

  Template.myrooms.messages = ->
      id = Session.get 'venueID'
      room=Rooms.findOne({venueid:id})
      room && room.messages
      # console.log aRoom
      # aRoom && aRoom.messages
  Template.entry.events =
    'keyup #messageBox' : (event)->
      if event.type == "keyup" && event.which == 13 # [ENTER]
        message = $('#messageBox')
        msgObj=
          author: 'Davide'
          content: message.val()
        id = Session.get 'venueID'
        Rooms.update(venueid:id, {$push:{messages: msgObj}})

  Template.login.events =
    'click' : (event)->
      window.location = "https://foursquare.com/oauth2/authenticate?client_id=4IPG12MOGEP2TSK5NEAF05RZMUGPPPFNJXUWN0MBUSFNIJJR&response_type=token&redirect_uri=http://4sqcoffee.meteor.com"

   
