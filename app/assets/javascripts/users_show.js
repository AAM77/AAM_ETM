/////////////////////////////////
/////////////////////////////////
//// CLASSES / MODEL OBJECTS ////
/////////////////////////////////
/////////////////////////////////


/////////////////////////////////////
// USER MODEL OBJECT & ITs METHODS //
/////////////////////////////////////
class User {
  constructor(object) {
    this.id = object.id
    this.username = object.username
    this.totalPoints = object.total_points
    this.adminnedEvents = object.adminned_events
    this.friendsEvents = object.friends_events
    this.soloTasks = object.solo_tasks
    this.groupTasks = object.group_tasks
    this.friends = object.all_friends
    this.friendshipId = object.friendship_id
    this.currentUserId = object.current_user_id
    this.friendsWithCurrentUser = object.friends_with_current_user
  }
}

///////////////////////////////////////
// FRIEND MODEL OBJECT & ITs METHODS //
///////////////////////////////////////

class Friend {
  constructor(object) {
    this.id = object.id
    this.username = object.username
    this.friends = object.all_friends
    this.friendshipId = object.friendship_id
    this.currentUserId = object.current_user_id
  }
}

// Adds the friended user and an unfriend button to the current user's friends list //
Friend.prototype.addFriendForCurrentUser = function() {
  return (
    `
    <p class="dropdown-item user-${this.id}">
      <a href="/users/${this.id}">${this.username}</a> - <button class="btn-sm btn-danger unfriend-button" data-friend-name="${this.username}" data-friendship-id="${this.friendshipId}" data-user-id="${this.id}" data-current-user="${this.currentUserId}">Unfriend</button>
    </p>
    <div class="dropdown-divider user-${this.id}"></div>
    `
  )
}

// Adds the friended user to the friends list of anyone who is friends with the current user //
Friend.prototype.addFriendForOtherUser = function() {
  return (
    `
    <p class="dropdown-item user-${this.id}">
      <a href="/users/${this.id}">${this.username}</a>
    </p>
    <div class="dropdown-divider user-${this.id}"></div>
    `
  )
}

//////////////////////////////////////
// EVENT MODEL OBJECT & ITs METHODS //
//////////////////////////////////////

class UserEvent {
  constructor(object) {
    this.id = object.id
    this.name = object.name
    this.adminId = object.admin_id
    this.adminUser = object.admin_user
  }
}

// Adds an event to the list of events a user created //
UserEvent.prototype.listCreatedEvent = function() {
  return (
    `
    <li class="list-group-item">
      <a href="/events/${this.id}" >${this.name}</a>
    </li>
    `
  )
}

// Adds a user's friends' events that he/she is participating in //
UserEvent.prototype.listFriendEvent = function() {
  return (
    `
    <li class="list-group-item">
      <a href="/events/${this.id}" >${this.name}</a>,
      by: <a href="/users/${this.adminId}" tasrget="_blank">${this.adminUser}</a>
    </li>
    `
  )
}

/////////////////////////////////////
// TASK MODEL OBJECT & ITs METHODS //
/////////////////////////////////////
class Task {
  constructor(object) {
    this.id = object.id
    this.name = object.name
    this.eventId = object.event_id
    this.adminId = object.admin_id
    this.eventName = object.event_name
    this.adminUser = object.admin_user
  }

  // Adds a task to the list(s) of solo and/or group tasks that the user is participating in //
  listTask() {
    return (
      `
      <li class="list-group-item">
        <a href="/tasks/${this.id}" >${this.name}</a>,
        in Event: <a href="/events/${this.eventId}" >${this.eventName}</a>,
        by: <a href="/users/${this.adminId}" >${this.adminUser}</a>
      </li>
      `
    )
  }
}


////////////////////////
////////////////////////
//// PAGE FUNCTIONS ////
////////////////////////
////////////////////////

function currentUserOrFriendsWithCurrentUser(data) {
  const currentPageUser = data
  const currentUserId = data.current_user_id

  if (currentPageUser.id === currentUserId || currentPageUser.friends_with_current_user) {
    $('.friends-only').show()
  } else {
    $('.friends-only').hide()
    $('#scrollable-friends-list').empty()
    $('#friends-list-button').hide()
  }
}


/////////////////////////////
// DISPLAYS THE PAGE TITLE //
/////////////////////////////
function displayPageTitle(data) {
  const user = new User(data)
  $('#user-homepage-header').text(`${user.username}'s Homepage`)
}

////////////////////////////////////
// DISPLAYS THE POINTS A USER HAS //
////////////////////////////////////
function displayUserPoints(data) {
  const user = new User(data)
  $('#users-total-points').text(`${user.username}'s Points: ${user.totalPoints}`)
}

/////////////////////////////////////////////////
// DISPLAY THE LIST OF EVENTS THE USER CREATED //
/////////////////////////////////////////////////
function displayAdminnedEventsCard(data) {
  const user = new User(data)
  $('#adminned-events-title').append(`Events ${user.username} Created`)
  $('#adminned-events-list').empty()

  user.adminnedEvents.forEach( event => {
    let newEvent = new UserEvent(event)
    let eventHTML = newEvent.listCreatedEvent()
    $('#adminned-events-list').append(eventHTML)
  })
}

//////////////////////////////////////////////////////
// DISPLAY FRIENDS' EVENTS USER IS PARTICIPATING IN //
//////////////////////////////////////////////////////
function displayFriendsEventsCard(data) {
  const user = new User(data)
  $('#friend-events-title').append(`Friends' Events ${user.username} is Participating In`)
  $('#friends-events-list').empty()

  user.friendsEvents.forEach( event => {
    if (event !== null) {
      let friendEvent = new UserEvent(event)
      let eventHTML = friendEvent.listFriendEvent()
      $('#friends-events-list').append(eventHTML);
    }
  })
}

//////////////////////////////////////////////////////////////
// DISPLAYS THE LIST OF SOLO TASKS USER IS PARTICIPATING IN //
//////////////////////////////////////////////////////////////
function displaySoloTasksCard(data) {
  const user = new User(data)
  $('#solo-tasks-title').append(`Solo-Tasks ${user.username} is Participating In`)

  user.soloTasks.forEach( task => {
    let newTask = new Task(task)
    let taskHTML = newTask.listTask()
    $('#solo-tasks-list').append(taskHTML)
  })
}


///////////////////////////////////////////////////////////////
// DISPLAYS THE LIST OF GROUP TASKS USER IS PARTICIPATING IN //
///////////////////////////////////////////////////////////////
function displayGroupTasksCard(data) {
  const user = new User(data)
  $('#group-tasks-title').append(`Group-Tasks ${user.username} is Participating In`)

  user.groupTasks.forEach( task => {
    let newTask = new Task(task)
    let taskHTML = newTask.listTask()
    $('#group-tasks-list').append(taskHTML)
  })
}



////////////////////////////////
// DISPLAYS THE FRIEND BUTTON //
////////////////////////////////
function displayFriendButton(data) {
  const user = new User(data)
  if (user.id !== user.currentUserId) {
    $('#friend-unfriend-button').append(`<button class="btn btn-info" id="add-friend-button" rel="nofollow" data-method="post">Add Friend</button>`)
  }
}

//////////////////////////////////
// DISPLAYS THE UNFRIEND BUTTON //
//////////////////////////////////
function displayUnfriendButton(currentPageUser) {
  if ((currentPageUser)) {
    const friendId = currentPageUser.id
    const friendshipId = currentPageUser.friendshipId
    const currentUser = currentPageUser.currentUserId

    $('#friend-unfriend-button').html(`<button class="btn-sm btn-danger unfriend-button" data-friendship-id="${friendshipId}" data-user-id="${friendId}" data-current-user="${currentUser}">Unfriend</button>`)
  }
}

function populateCurrentUsersFriendsList(currentPageUser) {
  currentPageUser.friends.forEach( friend => {
    let newFriend = new Friend(friend)
    let friendHTML = newFriend.addFriendForCurrentUser()
    $('#scrollable-friends-list').append(friendHTML)
  })
}

function populateOtherUsersFriendsList(currentPageUser) {
  currentPageUser.friends.forEach( friend => {
    let newFriend = new Friend(friend)
    let friendHTML = newFriend.addFriendForOtherUser()
    $('#scrollable-friends-list').append(friendHTML)
  })
}

///////////////////////////////
// DISPLAYS THE FRIENDS LIST //
///////////////////////////////
function displayFriendsList(currentPageUser) {
  $('#friends-list-button').text('Friends List')
  $('#scrollable-friends-list').empty();
  if (currentPageUser.id === currentPageUser.currentUserId) {
    populateCurrentUsersFriendsList(currentPageUser)
  } else if (currentPageUser.friendsWithCurrentUser) {
    populateOtherUsersFriendsList(currentPageUser)
  }
}

// DISPLAYS ELEMENTS DEPENDING ON FRIENDSHIP STATUS WITH THE CURRENT USER //
function determineFriendshipDisplayElements(data) {
  //debugger;
  const currentPageUser = new User(data)
  //debugger;
  if (currentPageUser.id === currentPageUser.currentUserId || currentPageUser.friendsWithCurrentUser) {
    //debugger;
    displayFriendsList(currentPageUser)
    if (currentPageUser.friendsWithCurrentUser) {
      //debugger;
      displayUnfriendButton(currentPageUser)
    }
  } else {
    displayFriendButton(data)
  }
}

// Attaches the appropriate Listeners
function attachFriendshipListener(data) {
  if (data.id === data.current_user_id || data.friends_with_current_user) {
    endFriendshipListener(data)
  } else {
    addFriendshipListener(data)
  }
}

////////////////////////////////////////////////////////
// Removes a user the the current user's friends list //
////////////////////////////////////////////////////////
function removeFromFriendsList(id) {
  $(`.user-${id}`).remove()
}

////////////////////////////////////////////////////////////////////////////////////
// Flashes a warning at the top of a page when the current user unfriends someone //
////////////////////////////////////////////////////////////////////////////////////
function flashWarningMessage(currentPageUsername) {
  $('#flash-success-danger-message').append(`<div class="alert alert-danger">You have unfriended ${currentPageUsername}</div>`)
}

//////////////////////////////////////////////////////////////////////////////////////////////////
// Removes the friends list, the unfriend button, the tasks lists, and the friends' events list //
//////////////////////////////////////////////////////////////////////////////////////////////////
function removeFriendElements() {
  $('#scrollable-friends-list').empty()
  $('#friends-list-button').hide()
  $('.unfriend-button').hide()
  $('.friends-only').hide()
}

/////////////////////////////////////////////////////////////////////
// ENDS / DELETES A FRIENDSHIP WITH THE UNFRIEND BUTTON IS CLICKED //
/////////////////////////////////////////////////////////////////////
function endFriendshipListener(currentPageUserData) {
  //debugger;
  $('.unfriend-button').on('click', function() {
    if (confirm("Are you sure you want to end this friendship?")) {
      //const currentPageUserData = data;
      const friendshipId = parseInt($(this).attr('data-friendship-id'))
      const friendId = $(this).attr('data-user-id')
      const username = $(this).attr('data-friend-name')
      $.ajax({
        url: `/friendships/${friendshipId}`,
        method: 'DELETE'
      })
      .done(function() {
        const currentPageUser = new User(currentPageUserData)
        if (currentPageUser.id === currentPageUser.currentUserId) {
          removeFromFriendsList(friendId)
          flashWarningMessage(username)
        } else {
          removeFriendElements()
          flashWarningMessage(currentPageUser.username)
          displayFriendButton(currentPageUserData)
          addFriendshipListener(currentPageUserData)
        }
      })
    }
  })
}

///////////////////////////////////////////////////////////////////
// Passes the data it receives to the methods it calls inside it //
///////////////////////////////////////////////////////////////////
function passCurrentPageData(data) {
  displayPageTitle(data)
  displayUserPoints(data)
  displayAdminnedEventsCard(data)
  displayFriendsEventsCard(data)
  displaySoloTasksCard(data)
  displayGroupTasksCard(data)
  determineFriendshipDisplayElements(data)
  attachFriendshipListener(data)
  currentUserOrFriendsWithCurrentUser(data)
}

////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////

/////////////////////////////////
//// DOCUMENT.READY Function ////
/////////////////////////////////

$(document).on('turbolinks:load',function() {
  $.get(`${window.location.href}.json`, function(data) {
    passCurrentPageData(data)
  })
})

////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////


////////////////////////
// TESTING ADD FRIEND //
////////////////////////

// What do I need to accomplish this?
// 1. I need a click event listener for the add friend button
      // When Clicked:
        // a. [x] make a POST ajax request to friendships
        // b. [x] provide the current user's id
        // c. [x] provide the potential friend's id
        // d. [x] create the friendship
        // e. remove the 'Add Friend Button'
        // f. add a success flash message at the top of the page
        // g. display all of the .friend-elements
        // h. display the friends list
        // i. display the unfriend button

function addFriendshipListener(data) {
  $('#add-friend-button').on('click', function() {
    if (confirm("Are you sure you want to friend this person?")) {
      const currentPageUserData = data;
      const potentialFriendId = currentPageUserData.id;
      const currentUserId = currentPageUserData.current_user_id;
      $.ajax({
        url: '/friendships',
        method: 'POST',
        data: {
          friend_id: potentialFriendId
        }
      })
      .done(function(postedData) {
        const currPgUsr = new User(postedData.friend)
        $('#add-friend-button').hide()
        $('.friends-only').show()
        determineFriendshipDisplayElements(postedData.friend)
        attachFriendshipListener(postedData.friend)
        $('#friends-list-button').show()
      })
    }
  })
}

// CURRENT ISSUE:
// Friendship gets created, but nothing else happens.
// Need to  do something about the card divs.
