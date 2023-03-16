// import { Controller } from "@hotwired/stimulus";

// export default class extends Controller {

  // connect() {

    $(function() {
      $('.scroll-down').click (function() {
        $('html, body').animate({scrollTop: $('section.section2').offset().top }, 'slow');
        return false;
      });
    });


//   }
// }
