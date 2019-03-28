
function display_users() {
  $.ajax({
    url: `/users.json`,
    method: 'GET'
  })
  .done(function(users) {
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
  display_users();
});
