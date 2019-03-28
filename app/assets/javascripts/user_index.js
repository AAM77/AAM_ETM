// #############################################################
// # Displays a friend link                                    #
// # links to the create action in the friendships controller  #
// #############################################################
// def add_friend_link(user)
//   if user != current_user
//     link_to "Add Friend", friendships_path(friend_id: user), method: :post, class: yield
//   end
// end
//
// #############################################################
// # Displays an unfriend link                                 #
// # links to the destroy action in the friendships controller #
// #############################################################
// def unfriend_link(friendship)
//   (link_to "Unfriend", friendship_path(friendship), method: :delete,
//   data: { confirm: "Are you sure you want to unfriend this person?" }, class: yield)
// end
// #########################################
// # Links to Users and allows to unfriend #
// #########################################
//
// def link_to_user(user)
//   (link_to user.username, user_path(user)) + (user == current_user ? "" : " || ") +
//   (friends?(user) ? "Your Friend" : add_friend_link(user) { "" })
// end

function add_friend_link() {
  $.ajax({
    url: `/users.json`,
    method: 'GET'
  })
  .done(function(data) {

  })
}



function display_users() {
  $.ajax({
    url: `/users.json`,
    method: 'GET'
  })
  .done(function(data) {
    const users = data['users']
    $('#users').append('<ol></ol>')

    users.forEach( user => {
      $('#users ol').append(
        `
        <li>
          <a href="/users/${user['id']}" target="_blank">${user['username']}</a>
        </li>
        `
      );
    })
  })
}


// DOCUMENT.READY FUNCTION
$(function() {
  add_friend_link();
  display_users();
});
