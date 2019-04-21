///////////
// Class //
///////////

class Event {
  constructor(object) {
    this.id = object.id
    this.name = object.name
    this.adminUserId = object.admin_user.id
    this.adminUsername = object.admin_user.username
  }
}

// Generates the HTML for a list item.
Event.prototype.createEventListItem = function() {
  return (
    `
    <li>
      <a href="/events/${this.id}">${this.name}</a>, by:
      <a href="/users/${this.adminUserId}">${this.adminUsername}</a>
    </li>
    `
  )
}

// accepts a callback and passes data to it
function getEvents(callback) {
  $.ajax({
    url: '/events.json',
    method: 'GET',
    success: function(data) {
      callback(data)
    }
  })
}

// Accepts events as a parameter
// Empties the events div and adds the new (passed) events to it
function addEventsToList(events) {
  $('#all-events ol').empty()
  events.forEach(event => {
    let newEvent = new Event(event)
    let eventHTML = newEvent.createEventListItem()
    $('#all-events ol').append(eventHTML)
  })
}

// Displays the events in ascending order
function displayAllEvents() {
  getEvents(addEventsToList)
  return false;
}

// Accepts events as a parameter and sorts them in ascending order
function sortAscending(events) {
  events.sort(function(event1, event2) {
    const eventName1 = event1.name.toUpperCase(); // ignore upper and lowercase
    const eventName2 = event2.name.toUpperCase(); // ignore upper and lowercase

    if (eventName1 > eventName2) {
      return 1;
    }
    if (eventName1 < eventName2) {
      return -1;
    }
    return 0;
  })
  addEventsToList(events)
}

// Accepts events as a parameter and sorts them in descending order
function sortDescending(events) {
  events.sort(function(event1, event2) {
    const eventName1 = event1.name.toUpperCase(); // ignore case
    const eventName2 = event2.name.toUpperCase(); // ignore case

    if (eventName1 < eventName2) {
      return 1;
    }
    if (eventName1 > eventName2) {
      return -1;
    }
    return 0;
  })
  addEventsToList(events)
}

// Gets the events, passes them to the sorter,
// sorts them, and adds them to the events div
function sortAscendingEventNames() {
  getEvents(sortAscending);
}

// Gets the events, passes them to the sorter,
// sorts them, and adds them to the events div
function sortDescendingEventNames() {
  getEvents(sortDescending)
}

// Displays the events in ascending order when the 'All Events' button is clicked
function sortAscendingEventNamesOnClick() {
  $('#sort-events-ascending').on('click', sortAscendingEventNames);
}

// Displays the events in descending order when the 'Title Descending' button is clicked
function sortDescendingEventNamesOnClick() {
  $('#sort-events-descending').on('click', sortDescendingEventNames)
}


$(function() {
  if ($(".events.index").length > 0) {
    displayAllEvents()
    sortAscendingEventNamesOnClick()
    sortDescendingEventNamesOnClick()
  }
});
