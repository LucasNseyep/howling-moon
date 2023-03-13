import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tree-map"
export default class extends Controller {
  static values = {
    data: Array
  }
  connect() {

    let data = this.dataValue

    let dataMap = data.reduce(function(map, node) {
      map[node.name] = node;
      return map;
    }, {});

    let treeData = [];
    data.forEach(function(node) {
    // add to parent
      let parent = dataMap[node.parent];
      if (parent) {
        // create child array if it doesn't exist
        (parent.children || (parent.children = []))
        // add node to child array
        .push(node);
      } else {
        // parent is null or missing
        treeData.push(node);
      }
    });

    // ************** Generate the tree diagram  *****************
    let margin = {top: 20, right: 120, bottom: 20, left: 120},
    width = 960 - margin.right - margin.left,
    height = 500 - margin.top - margin.bottom;

    let i = 0;

    var Tooltip = d3.select("#col-tree-map")
      .append("div")
      .style("opacity", 0)
      .attr("class", "tooltip")
      .style("background-color", "#F2F2F2")
      // .style("border", "solid")
      // .style("border-width", "2px")
      .style("border-radius", "20px")
      .style("padding", "20px")
      .style("width", "300px")
      .style("position", "absolute")
      .style("text-align", "center")
      .style("color", "$dark-grey")
      .style("filter", "drop-shadow(0px 1px 4px rgba(0, 0, 0, 0.04))" )
      .style("left", "40px")


    var mouseover = function(d) {
      Tooltip
        .style("opacity", 1)
      d3.select(this)
        .style("stroke", "black")
        .style("opacity", 1)
    }
    var mousemove = function(d) {
      Tooltip
        .html(d.content)
        .style("text-align", "center")
    }

    var mouseleave = function(d) {
      Tooltip
        .style("opacity", 0)
      d3.select(this)
        .style("stroke", "none")
        .style("opacity", 0.8)
    }

    let tree = d3.layout.tree()
    .size([height, width]);

    let diagonal = d3.svg.diagonal()
    .projection(function(d) { return [d.y, d.x]; });

    let svg = d3.select("#col-tree-map").append("svg")
    .attr("width", width + margin.right + margin.left)
    .attr("height", height + margin.top + margin.bottom)
      .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    console.log(treeData[0])

    let root = treeData[0];
    console.log(root)

    update(root);

    function update(source) {

      // Compute the new tree layout.
      let nodes = tree.nodes(root).reverse(),
      links = tree.links(nodes);

      // Normalize for fixed-depth.
      nodes.forEach(function(d) { d.y = d.depth * 180; });

      // Declare the nodesâ€¦
      let node = svg.selectAll("g.node")
      .data(nodes, function(d) { return d.id || (d.id = ++i); });

      // Enter the nodes.
      let nodeEnter = node.enter().append("g")
      .attr("class", "node")
      .attr("transform", function(d) {
        return "translate(" + d.y + "," + d.x + ")"; })
      .on("click", click)
      .on("mouseover", mouseover)
      .on("mousemove", mousemove)
      .on("mouseleave", mouseleave)


      nodeEnter.append("a")
      .attr("xlink:href", function(d) { return d.url; })
        .append("circle")
        .attr("r", 10)
        .style("fill", "#fff")
        .style("fill", function(d) { return d._children ? "lightsteelblue" : "#fff"; })
        .on("click", click)
      ;

      nodeEnter.append("a")
      .attr("xlink:href", function(d) { return d.url; })
      .append("text")
      .attr("class", "clickable")
      .attr("y", 16)
      .attr("x", function (d) { return d.children || d._children ? -10 : 10; })
      .attr("text-anchor", function(d) { return d.children || d._children ? "end" : "start"; })
      .text(function(d) { return d.name; });

      // Declare the linksâ€¦
      let link = svg.selectAll("path.link")
      .data(links, function(d) { return d.target.id; });

      // Enter the links.
      link.enter().insert("path", "g")
      .attr("class", "link")
      .attr("d", diagonal);

      function click(d) {
        if (d.children) {
          d._children = d.children;
          d.children = null;
        } else {
          d.children = d._children;
          d._children = null;
        }
        update(d);
      }
    }
  }
}
