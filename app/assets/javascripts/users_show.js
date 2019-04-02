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

class User {
  constructor(object) {
    this.id = object.id
    this.username = object.username
    this.total_points = object.total_points
    this.adminned_events = object.events
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

Friend.prototype.addFriendForCurrentUser = function() {
  return (
    `
    <p class="dropdown-item user-${this.id}">
      <a href="/users/${this.id}" target="_blank">${this.username}</a> - <button class="btn-sm btn-danger unfriend-button" data-friendship-id="${this.friendship_id}" data-user-id="${this.id}">Unfriend</button>
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


UserEvent.prototype.listItemLink = function() {
  return (
    `
    <li class="list-group-item">
      <a href="/events/${this.id}" target="_blank">${this.name}</a>
    </li>
    `
  )
}

Task.prototype.listItemLink = function() {

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

function displayPageTitle() {
  $.get(`${window.location.href}.json`, function(data) {
    const user = new User(data)
    $('#user-homepage-header').append(`${user.username}'s Homepage`)
  })
}

function displayUserPoints() {
  $.get(`${window.location.href}.json`, function(data) {
    const user = new User(data)
    $('#users-total-points').append(`${user.username}'s Points: ${user.total_points}`)
  })
}

function displayAdminnedEventsCard() {
  $.get(`${window.location.href}.json`, function(data) {
    const user = new User(data)
    $('#adminned-events-title').append(`Events ${user.username} Created`)
    $('#adminned-events-list').empty()

    user.adminned_events.forEach( event => {
      let newEvent = new UserEvent(event)
      let eventHTML = newEvent.listItemLink()
      $('#adminned-events-list').append(eventHTML)
    })
  })
}

function displayFriendsEventsCard() {
  $.get(`${window.location.href}.json`, function(data) {
    const user = new User(data)
    $('#friend-events-title').append(`Friends' Events ${user.username} is Participating In`)
  })
}

function displaySoloTasksCard() {
  $.get(`${window.location.href}.json`, function(data) {
    const user = new User(data)
    $('#solo-tasks-title').append(`Solo-Tasks ${user.username} is Participating In`)

    user.solo_tasks.forEach( task => {
      let newTask = new Task(task)
      let taskHTML = newTask.listItemLink()
      $('#solo-tasks-list').append(taskHTML)
    })
  })
}

function displayGroupTasksCard() {
  $.get(`${window.location.href}.json`, function(data) {
    const user = new User(data)
    $('#group-tasks-title').append(`Group-Tasks ${user.username} is Participating In`)

    user.group_tasks.forEach( task => {
      let newTask = new Task(task)
      let taskHTML = newTask.listItemLink()
      $('#group-tasks-list').append(taskHTML)
    })
  })
}

function displayFriendsList() {
  $.get(`${window.location.href}.json`, function(data) {
    const user = new User(data)
    $('#friends-list-button').append('Friends List')

    if (user.id === user.current_user_id) {
      user.friends.forEach( friend => {
        let newFriend = new Friend(friend)
        let friendHTML = newFriend.addFriendForCurrentUser()
        $('#scrollable-friends-list').append(friendHTML)
      })
    } else {

      if (isFriend()) {
        user.friends.forEach( friend => {
          let newFriend = new Friend(friend)
          let friendHTML = newFriend.addFriendForOtherUser()
          $('#scrollable-friends-list').append(friendHTML)
        })
        displayUnfriendButton()
      }
    }
    endFriendshipListener()
  })
}

function isFriend() {
  let userFriend;
  $.get(`${window.location.href}.json`, function(data) {
    const user = new User(data)
    userFriend = user.friends.filter(function(friend, key) {
      return friend.id === user.current_user_id
    })[0];
  })
    return userFriend
}

function displayUnfriendButton() {
  const userFriend = isFriend()

  if ((userFriend)) {
    const friendId = userFriend.id
    const friendshipId = userFriend.friendship_id.id
    $('#friend-unfriend-button').append(`<button class="btn-sm btn-danger unfriend-button" data-friendship-id="${friendshipId}" data-user-id="${friendId}">Unfriend</button>`)
  }
}

function endFriendshipListener() {
  $('.unfriend-button').on('click', function() {
    if (confirm("Are you sure you want to end this friendship?")) {
      friendship_id = parseInt($(this).attr('data-friendship-id'))
      user_id = $(this).attr('data-user-id')
      $.ajax({
        url: `/friendships/${friendship_id}`,
        method: 'DELETE'
      })
      .done(function() {
        $(`.user-${user_id}`).remove()
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
