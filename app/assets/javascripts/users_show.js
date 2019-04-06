// // <% users_incomplete_solo_tasks.each do |solo_task| %>
// //   <li class="list-group-item">
// //     <%= task_participating_in solo_task, @user %>
// //   </li>
// // <% end %>


// // <% users_incomplete_group_tasks.each do |group_task| %>
// //   <li class="list-group-item">
// //     <%= task_participating_in group_task, @user %>
// //   </li>
// // <% end %>

// // friendships POST   /friendships(.:format)        friendships#create
// // friendship DELETE /friendships/:id               friendships#destroy

/////////////
// CLASSES //
/////////////

class User {
  constructor(object) {
    this.id = object.id
    this.username = object.username
    this.total_points = object.total_points
    this.adminned_events = object.events
    this.friends_events = object.friends_events
    this.solo_tasks = object.solo_tasks
    this.group_tasks = object.group_tasks
    this.friends = object.all_friends
    this.all_friendships = object.all_friendships
    this.current_user_id = object.crnt_user['id']
  }
}

class Friend {
  constructor(object) {
    this.id = object.id
    this.username = object.username
    this.events = object.events
    this.friendship_id = object.friendship_id.id
    this.current_user_id = object.current_user_id
  }
}

class UserEvent {
  constructor(object) {
    this.id = object.id
    this.name = object.name
    this.admin_id = object.admin_id
    this.admin_user = object.admin_user
  }
}

class Task {
  constructor(object) {
    this.id = object.id
    this.name = object.name
    this.event_id = object.event_id
    this.admin_id = object.admin_id
    this.event_name = object.event_name
    this.admin_user = object.admin_user
  }
}

///////////////////
// CLASS METHODS //
///////////////////
Friend.prototype.addFriendForCurrentUser = function() {
  return (
    `
    <p class="dropdown-item user-${this.id}">
      <a href="/users/${this.id}" target="_blank">${this.username}</a> - <button class="btn-sm btn-danger unfriend-button" data-friendship-id="${this.friendship_id}" data-user-id="${this.id}" data-current-user="${this.current_user_id}">Unfriend</button>
    </p>
    <div class="dropdown-divider user-${this.id}"></div>
    `
  )
}

Friend.prototype.displayUnfriendButton = function() {
  return (
    `<button class="btn-sm btn-danger unfriend-button" data-friendship-id="${this.friendship_id}" data-user-id="${this.id}">Unfriend</button>`
  )
}

Friend.prototype.addFriendForOtherUser = function() {
  return (
    `
    <p class="dropdown-item user-${this.id}">
      <a href="/users/${this.id}" target="_blank">${this.username}</a>
    </p>
    <div class="dropdown-divider user-${this.id}"></div>
    `
  )
}

UserEvent.prototype.listCreatedEvent = function() {
  return (
    `
    <li class="list-group-item">
      <a href="/events/${this.id}" target="_blank">${this.name}</a>
    </li>
    `
  )
}

UserEvent.prototype.listFriendEvent = function() {
  return (
    `
    <li class="list-group-item">
      <a href="/events/${this.id}" target="_blank">${this.name}</a>,
      by: <a href="/users/${this.admin_id}" tasrget="_blank">${this.admin_user}</a>
    </li>
    `
  )
}

Task.prototype.listTask = function() {

  return (
    `
    <li class="list-group-item">
      <a href="/tasks/${this.id}" target="_blank">${this.name}</a>,
      in Event: <a href="/events/${this.event_id}" target="_blank">${this.event_name}</a>,
      by: <a href="/users/${this.admin_id}" target="_blank">${this.admin_user}</a>
    </li>
    `
  )
}

/////////////////////////////
// DISPLAYS THE PAGE TITLE //
/////////////////////////////
function displayPageTitle() {
  $.get(`${window.location.href}.json`, function(data) {
    const user = new User(data)
    $('#user-homepage-header').append(`${user.username}'s Homepage`)
  })
}


////////////////////////////////////
// DISPLAYS THE POINTS A USER HAS //
////////////////////////////////////
function displayUserPoints() {
  $.get(`${window.location.href}.json`, function(data) {
    const user = new User(data)
    $('#users-total-points').append(`${user.username}'s Points: ${user.total_points}`)
  })
}


/////////////////////////////////////////////////
// DISPLAY THE LIST OF EVENTS THE USER CREATED //
/////////////////////////////////////////////////
function displayAdminnedEventsCard() {
  $.get(`${window.location.href}.json`, function(data) {
    const user = new User(data)
    $('#adminned-events-title').append(`Events ${user.username} Created`)
    $('#adminned-events-list').empty()

    user.adminned_events.forEach( event => {
      let newEvent = new UserEvent(event)
      let eventHTML = newEvent.listCreatedEvent()
      $('#adminned-events-list').append(eventHTML)
    })
  })
}

//////////////////////////////////////////////////////
// DISPLAY FRIENDS' EVENTS USER IS PARTICIPATING IN //
//////////////////////////////////////////////////////
function displayFriendsEventsCard() {
  $.get(`${window.location.href}.json`, function(data) {
    const user = new User(data)
    $('#friend-events-title').append(`Friends' Events ${user.username} is Participating In`)
    $('#friends-events-list').empty()

    user.friends_events.forEach( event => {
      let friendEvent = new UserEvent(event)
      let eventHTML = friendEvent.listFriendEvent()
      $('#friends-events-list').append(eventHTML);
    })
  })
}


//////////////////////////////////////////////////////////////
// DISPLAYS THE LIST OF SOLO TASKS USER IS PARTICIPATING IN //
//////////////////////////////////////////////////////////////
function displaySoloTasksCard() {
  $.get(`${window.location.href}.json`, function(data) {
    const user = new User(data)
    $('#solo-tasks-title').append(`Solo-Tasks ${user.username} is Participating In`)

    user.solo_tasks.forEach( task => {
      let newTask = new Task(task)
      let taskHTML = newTask.listTask()
      $('#solo-tasks-list').append(taskHTML)
    })
  })
}

///////////////////////////////////////////////////////////////
// DISPLAYS THE LIST OF GROUP TASKS USER IS PARTICIPATING IN //
///////////////////////////////////////////////////////////////
function displayGroupTasksCard() {
  $.get(`${window.location.href}.json`, function(data) {
    const user = new User(data)
    $('#group-tasks-title').append(`Group-Tasks ${user.username} is Participating In`)

    user.group_tasks.forEach( task => {
      let newTask = new Task(task)
      let taskHTML = newTask.listTask()
      $('#group-tasks-list').append(taskHTML)
    })
  })
}

///////////////////////////////
// DISPLAYS THE FRIENDS LIST //
///////////////////////////////
function displayFriendsList() {
  $.get(`${window.location.href}.json`, function(data) {
    const user = new User(data)
    $('#friends-list-button').append('Friends List')

    // add friend to the dropdown friends list
    if (user.id === user.current_user_id) {
      user.friends.forEach( friend => {
        let newFriend = new Friend(friend)
        let friendHTML = newFriend.addFriendForCurrentUser()
        $('#scrollable-friends-list').append(friendHTML)
      })
    } else {

      const user = new User(data)
      userFriend = user.friends.filter(function(friend, key) {
        return friend.id === user.current_user_id
      })[0];

      if (userFriend) {
        user.friends.forEach( friend => {
          let newFriend = new Friend(friend)
          let friendHTML = newFriend.addFriendForOtherUser()
          $('#scrollable-friends-list').append(friendHTML)
        })
        displayUnfriendButton(userFriend)
      } else {
        displayFriendButton()
      }
    }
    endFriendshipListener()
  })
}

//////////////////////////////////
// DISPLAYS THE UNFRIEND BUTTON //
//////////////////////////////////
function displayUnfriendButton(userFriend) {
  if ((userFriend)) {
    const friendId = userFriend.id
    const friendshipId = userFriend.friendship_id.id
    const currentUser = userFriend.current_user_id
    $('#friend-unfriend-button').append(`<button class="btn-sm btn-danger unfriend-button" data-friendship-id="${friendshipId}" data-user-id="${friendId}" data-current-user="${currentUser}">Unfriend</button>`)
  }
}

////////////////////////////////
// DISPLAYS THE FRIEND BUTTON //
////////////////////////////////

function displayFriendButton(user) {
  $.get(`${window.location.href}.json`, function(data) {
    const user = new User(data)
    if (user.id !== user.current_user_id) {
      $('#friend-unfriend-button').append(`<a class="btn btn-info" rel="nofollow" data-method="post" href="/friendships?friend_id=${user.id}">Add Friend</a>`)
    }
  })
}

/////////////////////////////////////////////////////////////////////
// ENDS / DELETES A FRIENDSHIP WITH THE UNFRIEND BUTTON IS CLICKED //
/////////////////////////////////////////////////////////////////////
function endFriendshipListener() {
  $('.unfriend-button').on('click', function() {
    if (confirm("Are you sure you want to end this friendship?")) {
      friendship_id = parseInt($(this).attr('data-friendship-id'))
      user_id = $(this).attr('data-user-id')
      current_user_id = $(this).attr('data-current-user')
      $.ajax({
        url: `/friendships/${friendship_id}`,
        method: 'DELETE'
      })
      .done(function() {
        if (user_id === current_user_id) {
          $(`.user-${user_id}`).remove()
        } else {
          $('.friends-only').remove()
          $('#friends-list-button').remove()
          $('.unfriend-button').remove()
        }
      });
    }
  })
}

// DOCUMENT.READY Function
$(function() {
  displayPageTitle();
  displayUserPoints()
  displayAdminnedEventsCard()
  displayFriendsEventsCard()
  displaySoloTasksCard()
  displayGroupTasksCard()
  displayFriendsList()
  displayUnfriendButton()
})
