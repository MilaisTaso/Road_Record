$(document).on('turbolinks:load', function(){
  const menuItems = document.querySelectorAll('.nav-tag');
  const contents = document.querySelectorAll('.content');

  menuItems.forEach(clickedItem => {
    clickedItem.addEventListener('click', e => {
      e.preventDefault();

      menuItems.forEach(item => {
        item.classList.remove('active', 'bg-light');
      });
      clickedItem.classList.add('active', 'bg-light');

      contents.forEach(content => {
        content.classList.remove('active');
      });
      document.getElementById(clickedItem.dataset.id).classList.add('active');
    });
  });
});
