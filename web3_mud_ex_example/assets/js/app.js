import "../css/app.scss";

import React from "react";
import ReactDOM from "react-dom";

import { App } from "./client";

window.Components = {
  App,
};

/**
 * ReactPhoenix
 *
 * Copied from https://github.com/geolessel/react-phoenix/blob/master/src/react_phoenix.js
 */
class ReactPhoenix {
  static init() {
    const elements = document.querySelectorAll("[data-react-class]");
    Array.prototype.forEach.call(elements, (e) => {
      const targetId = document.getElementById(e.dataset.reactTargetId);
      const targetDiv = targetId ? targetId : e;
      const reactProps = e.dataset.reactProps ? e.dataset.reactProps : "{}";
      const reactElement = React.createElement(eval(e.dataset.reactClass), JSON.parse(reactProps));
      ReactDOM.render(reactElement, targetDiv);
    });
  }
}

document.addEventListener("DOMContentLoaded", () => {
  ReactPhoenix.init();
});
