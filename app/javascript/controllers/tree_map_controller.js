import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tree-map"
export default class extends Controller {
  static values = {
    data: Array
  }
  connect() {
    // console.log("Hi from tree-map-controller")
    // const realData = document.getElementById('tree-data').dataset.treeData
    // console.log(realData)
    console.log(this.dataValue)

    let data = this.dataValue


  // buildTree() {
  //   let data = document.getElementById('tree-data').dataset.treeData

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
        return "translate(" + d.y + "," + d.x + ")"; });

      nodeEnter.append("circle")
      .attr("r", 10)
      .style("fill", "#fff");

      nodeEnter.append("text")
      .attr("x", function(d) {
        return d.children || d._children ? -13 : 13; })
      .attr("dy", ".35em")
      .attr("text-anchor", function(d) {
        return d.children || d._children ? "end" : "start"; })
      .text(function(d) { return d.name; })
      .style("fill-opacity", 1);

      // Declare the linksâ€¦
      let link = svg.selectAll("path.link")
      .data(links, function(d) { return d.target.id; });

      // Enter the links.
      link.enter().insert("path", "g")
      .attr("class", "link")
      .attr("d", diagonal);

    }
  }
}
