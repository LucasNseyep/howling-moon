// import { Controller } from "@hotwired/stimulus";

// export default class extends Controller {

//   connect() {

// const section4 = document.querySelector(".section4");
// const reviews = section4.querySelectorAll(".review");

// let globalIndex = 0;
// last = { x: 0, y: 0 };

// const activate = (review, x, y) => {
//   review.style.left = `${x}px`;
//   review.style.top = `${y}px`;

//   review.dataset.status = "active";

//   last = { x, y };
// };

// const distanceFromLast = (x, y) => {
//   return Math.hypot(x - last.x, y - last.y);
// };

// section4.onmousemove = (e) => {
//   if (distanceFromLast(e.clientX, e.clientY) > 300) {
//     const lead = reviews[globalIndex % reviews.length];
//     tail = reviews[(globalIndex - 3) % reviews.length];

//     activate(lead, e.clientX, e.clientY);

//     if (tail) tail.dataset.status = "inactive";

//     globalIndex++;
//   }
// };



    const reviews = document.getElementsByClassName("review");

    let globalIndex = 0;
      last = { x: 0, y: 0};

    const activate = (review, x, y) => {
      review.style.left = `${x}px`;
      review.style.top = `${y}px`;

      review.dataset.status = 'active';

      last = { x, y };
    }

    const distanceFromLast = (x, y) => {
      return Math.hypot(x - last.x, y - last.y);
    }

    window.onmousemove = e => {
      if(distanceFromLast(e.clientX, e.clientY) > 300) {
        const lead = reviews[globalIndex % reviews.length];
              tail = reviews[(globalIndex - 3) % reviews.length];

        activate(lead, e.clientX, e.clientY);

        if(tail) tail.dataset.status = "inactive";

        globalIndex++;
      }
    }


//   }
// }
