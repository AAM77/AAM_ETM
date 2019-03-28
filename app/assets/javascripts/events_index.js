// <div id="all_events">
//   <ol>
//     <% @events.each do |event| %>
//       <li>
//         <%= link_to event.name, event_path(event) %>, by:
//         <%= link_to User.find(event.admin_id).username, user_path(event.admin_id) %>
//       </li>
//     <% end %>
//   </ol>
// </div>

class Event {
  constructor(object) {
    this.id = object.id
    this.name = object.name
    this.adminUserId = object.admin_user.id
    this.adminUsername = object.admin_user.username
  }
}

Event.prototype.insertHTML = function() {
  return (
    `
    <li>
      <a href="/events/${this.id}" target="_blank">${this.name}</a>, by:
      <a href="/events/${this.adminUserId}" target="_blank">${this.adminUsername}</a>
    </li>
    `
  )
}

function displayAllEvents() {
  let eventsList = ''
  $.ajax({
    url: '/events.json',
    method: 'GET'
  })
  .done(function(events) {
    events.forEach(event => {
      let newEvent = new Event(event)
      let eventHTML = newEvent.insertHTML()
      eventsList += eventHTML
    })
    $('#all-events ol').empty().append(eventsList);
  })
}

function clickShowAllEvents() {
  $('#dd-all-events').on('click', displayAllEvents())
  return false;
}

$(function() {
  clickShowAllEvents()
});
