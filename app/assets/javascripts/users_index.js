////////////////////////////////////////////////////////////////////////////////////
// Flashes a warning at the top of a page when the current user unfriends someone //
////////////////////////////////////////////////////////////////////////////////////
function flashSuccessMessage(currentPageUsername) {
  $('#flash-success-danger-message').append(`<div class="alert alert-success">You are now friends with ${currentPageUsername}</div>`)
}

///////////////////////////////////////////////////////////////////////
// A CLICK EVENT HANDLER THAT ASYNCHRONOUSLY CREATES A FRIENDSHIP,   //
// REMOVES THE FRIEND BUTTON, AND  DISPLAYS A FLASH MESSAGE          //
///////////////////////////////////////////////////////////////////////
function indexFriendshipListener() {
  $('.index-add-friend-button').on('click', function() {

    if (confirm("Are you sure you want to friend this person?")) {
      const currentUserId = parseInt($(this).attr('data-crnt-user-id'))
      const friendId = parseInt($(this).attr('data-friend-id'))

      $.ajax({
        url: '/friendships',
        method: 'POST',
        data: {
          user_id: currentUserId,
          friend_id: friendId
        }
      })
      .done(function(friendshipData) {
        $(`#user-${friendId} span`).text('Your Friend')
        flashSuccessMessage(friendshipData.friend.username)
      })
    }
  })
}

$(document).on('turbolinks:load',function() {
  indexFriendshipListener()
})
