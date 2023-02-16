$(document).on("turbolinks:load", function () {
  const swiperWrapper = $('.swiper-wrapper');
  const swiper = new Swiper('.swiper', {
    loop:true,
    pagination: {
      el: '.swiper-pagination',
    },
    navigation: {
      nextEl: '.swiper-button-next',
      prevEl: '.swiper-button-prev',
    }
  });

  $("#course_course_images").on("change", function (e) {
    swiperWrapper.empty();
    $('.swiper').css({
      width: '700px',
      height: '400px'
    });
    let files = e.target.files;
    let d = new $.Deferred().resolve();
    $.each(files, function (i, file) {
      d = d.then(function () {
        previewImage(file)
      });
    });
  });

  const previewImage = function(file) {
    let img = $('<img/>');
    img.css({
      height: "400px",
      width: "700px"
    });

    let swiperSlide = $('<div class="swiper-slide"></div>');
    let reader = new FileReader();
    reader.readAsDataURL(file);
    reader.onload = function(e) {
      img.attr('src', reader.result);
      swiperSlide.append(img);
      swiperWrapper.append(swiperSlide);
    }
  }
});
