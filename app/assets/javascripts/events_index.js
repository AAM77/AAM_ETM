
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
      <a href="/events/${this.id}">${this.name}</a>, by:
      <a href="/events/${this.adminUserId}">${this.adminUsername}</a>
    </li>
    `
  )
}

function getEvents(callback) {
  $.ajax({
    url: '/events.json',
    method: 'GET',
    success: function(data) {
      callback(data)
    }
  })
}

function addEventsToOrderedList(events) {
  $('#all-events ol').empty()
  events.forEach(event => {
    let newEvent = new Event(event)
    let eventHTML = newEvent.insertHTML()
    $('#all-events ol').append(eventHTML)
  })
}

function displayAllEvents() {
  getEvents(addEventsToOrderedList)
  return false;
}

function sortDescending(events) {
  debugger;
  events.sort(function(event1, event2) {
    const eventName1 = event1.name.toUpperCase(); // ignore upper and lowercase
    const eventName2 = event2.name.toUpperCase(); // ignore upper and lowercase

    if (eventName1 < eventName2) {
      return 1;
    }
    if (eventName1 > eventName2) {
      return -1;
    }
    // names must be equal
    return 0;
  })
  addEventsToOrderedList(events)
}

function sortDescendingNames() {
  getEvents(sortDescending)
}

function showAllEventsOnClick() {
  $('#add-all-events').on('click', displayAllEvents);
}

function descendingEventNamesOnClick() {
  $('#sort-events-button').on('click', sortDescendingNames)
}


$(document).on('turbolinks:load',function() {
  showAllEventsOnClick()
  descendingEventNamesOnClick()
});
