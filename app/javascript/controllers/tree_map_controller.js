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

    let treeDataArray = [];
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
        treeDataArray.push(node);
      }
    });

    console.log(treeDataArray)

    let treeData = treeDataArray[0]

    // ************** Generate the tree diagram  *****************
    var totalNodes = 0;
    var maxLabelLength = 0;
    // variables for drag/drop
    var selectedNode = null;
    var draggingNode = null;
    // panning variables
    var panSpeed = 200;
    var panBoundary = 20; // Within 20px from edges will pan when dragging.
    // Misc. variables
    var i = 0;
    var duration = 750;
    var root;

  	// new node initial values
  	var newNodeBase = "New";
  	var newNodeValue = 5;
  	var nodeNoMax = 10000;
  	var newNodeValue = 5;
  	var newNodeStatus = "In";
  	var newNodeType = "Medium";
  	var newLinkWidth = 15;

    console.log(treeData)

    // size of the diagram
    var viewerWidth = $(window).width();
    var viewerHeight = $(window).height();

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


    var tree = d3.layout.tree()
        .size([viewerHeight, viewerWidth]);

    // define a d3 diagonal projection for use by the node paths later on.
    var diagonal = d3.svg.diagonal()
        .projection(function(d) {
            return [d.y, d.x];
        });

    // A recursive helper function for performing some setup by walking through all nodes

    function visit(parent, visitFn, childrenFn) {
        if (!parent) return;

        visitFn(parent);

        var children = childrenFn(parent);
        if (children) {
            var count = children.length;
            for (var i = 0; i < count; i++) {
                visit(children[i], visitFn, childrenFn);
            }
        }
    }

    // Call visit function to establish maxLabelLength
    visit(treeData, function(d) {
        totalNodes++;
        maxLabelLength = Math.max(d.name.length, maxLabelLength);

    }, function(d) {
        return d.children && d.children.length > 0 ? d.children : null;
    });


    // sort the tree according to the node names

    function sortTree() {
        tree.sort(function(a, b) {
            return b.name.toLowerCase() < a.name.toLowerCase() ? 1 : -1;
        });
    }
    // Sort the tree initially incase the JSON isn't in a sorted order.
    sortTree();

    // TODO: Pan function, can be better implemented.

    function pan(domNode, direction) {
        var speed = panSpeed;
        if (panTimer) {
            clearTimeout(panTimer);
            translateCoords = d3.transform(svgGroup.attr("transform"));
            if (direction == 'left' || direction == 'right') {
                translateX = direction == 'left' ? translateCoords.translate[0] + speed : translateCoords.translate[0] - speed;
                translateY = translateCoords.translate[1];
            } else if (direction == 'up' || direction == 'down') {
                translateX = translateCoords.translate[0];
                translateY = direction == 'up' ? translateCoords.translate[1] + speed : translateCoords.translate[1] - speed;
            }
            scaleX = translateCoords.scale[0];
            scaleY = translateCoords.scale[1];
            scale = zoomListener.scale();
            svgGroup.transition().attr("transform", "translate(" + translateX + "," + translateY + ")scale(" + scale + ")");
            d3.select(domNode).select('g.node').attr("transform", "translate(" + translateX + "," + translateY + ")");
            zoomListener.scale(zoomListener.scale());
            zoomListener.translate([translateX, translateY]);
            panTimer = setTimeout(function() {
                pan(domNode, speed, direction);
            }, 50);
        }
    }

    // Define the zoom function for the zoomable tree

    function zoom() {
        svgGroup.attr("transform", "translate(" + d3.event.translate + ")scale(" + d3.event.scale + ")");
    }


    // define the zoomListener which calls the zoom function on the "zoom" event constrained within the scaleExtents
    var zoomListener = d3.behavior.zoom().scaleExtent([0.1, 3]).on("zoom", zoom);

    // function initiateDrag(d, domNode) {
    //     draggingNode = d;
    //     d3.select(domNode).select('.ghostCircle').attr('pointer-events', 'none');
    //     d3.selectAll('.ghostCircle').attr('class', 'ghostCircle show');
    //     d3.select(domNode).attr('class', 'node activeDrag');

    //     svgGroup.selectAll("g.node").sort(function(a, b) { // select the parent and sort the path's
    //         if (a.id != draggingNode.id) return 1; // a is not the hovered element, send "a" to the back
    //         else return -1; // a is the hovered element, bring "a" to the front
    //     });
    //     // if nodes has children, remove the links and nodes
    //     if (nodes.length > 1) {
    //         // remove link paths
    //         links = tree.links(nodes);
    //         nodePaths = svgGroup.selectAll("path.link")
    //             .data(links, function(d) {
    //                 return d.target.id;
    //             }).remove();
    //         // remove child nodes
    //         nodesExit = svgGroup.selectAll("g.node")
    //             .data(nodes, function(d) {
    //                 return d.id;
    //             }).filter(function(d, i) {
    //                 if (d.id == draggingNode.id) {
    //                     return false;
    //                 }
    //                 return true;
    //             }).remove();
    //     }

    //     // remove parent link
    //     parentLink = tree.links(tree.nodes(draggingNode.parent));
    //     svgGroup.selectAll('path.link').filter(function(d, i) {
    //         if (d.target.id == draggingNode.id) {
    //             return true;
    //         }
    //         return false;
    //     }).remove();

    //     dragStarted = null;
    // }

    // define the baseSvg, attaching a class for styling and the zoomListener
    var baseSvg = d3.select("#col-tree-map").append("svg")
        .attr("width", viewerWidth)
        .attr("height", viewerHeight)
        .attr("class", "overlay")
        .call(zoomListener);


    // Define the drag listeners for drag/drop behaviour of nodes.
    let dragListener = d3.behavior.drag()
        .on("dragstart", function(d) {
            if (d == root) {
                return;
            }
            dragStarted = true;
            nodes = tree.nodes(d);
            d3.event.sourceEvent.stopPropagation();
            // it's important that we suppress the mouseover event on the node being dragged. Otherwise it will absorb the mouseover event and the underlying node will not detect it d3.select(this).attr('pointer-events', 'none');
        })
        .on("drag", function(d) {
            if (d == root) {
                return;
            }
            if (dragStarted) {
                domNode = this;
                initiateDrag(d, domNode);
            }

            // get coords of mouseEvent relative to svg container to allow for panning
            relCoords = d3.mouse($('svg').get(0));
            if (relCoords[0] < panBoundary) {
                panTimer = true;
                pan(this, 'left');
            } else if (relCoords[0] > ($('svg').width() - panBoundary)) {

                panTimer = true;
                pan(this, 'right');
            } else if (relCoords[1] < panBoundary) {
                panTimer = true;
                pan(this, 'up');
            } else if (relCoords[1] > ($('svg').height() - panBoundary)) {
                panTimer = true;
                pan(this, 'down');
            } else {
                try {
                    clearTimeout(panTimer);
                } catch (e) {

                }
            }

            d.x0 += d3.event.dy;
            d.y0 += d3.event.dx;
            var node = d3.select(this);
            node.attr("transform", "translate(" + d.y0 + "," + d.x0 + ")");
            updateTempConnector();
        }).on("dragend", function(d) {
            if (d == root) {
                return;
            }
            domNode = this;
            if (selectedNode) {
                // now remove the element from the parent, and insert it into the new elements children
                var index = draggingNode.parent.children.indexOf(draggingNode);
                if (index > -1) {
                    draggingNode.parent.children.splice(index, 1);
                }
                if (typeof selectedNode.children !== 'undefined' || typeof selectedNode._children !== 'undefined') {
                    if (typeof selectedNode.children !== 'undefined') {
                        selectedNode.children.push(draggingNode);
                    } else {
                        selectedNode._children.push(draggingNode);
                    }
                } else {
                    selectedNode.children = [];
                    selectedNode.children.push(draggingNode);
                }
                // Make sure that the node being added to is expanded so user can see added node is correctly moved
                expand(selectedNode);
                sortTree();
                endDrag();
            } else {
                endDrag();
            }
        });

    function endDrag() {
        selectedNode = null;
        d3.selectAll('.ghostCircle').attr('class', 'ghostCircle');
        d3.select(domNode).attr('class', 'node');
        // now restore the mouseover event or we won't be able to drag a 2nd time
        d3.select(domNode).select('.ghostCircle').attr('pointer-events', '');
        updateTempConnector();
        if (draggingNode !== null) {
            update(root);
            centerNode(draggingNode);
            draggingNode = null;
        }
    }

    // Helper functions for collapsing and expanding nodes.

    function collapse(d) {
        if (d.children) {
            d._children = d.children;
            d._children.forEach(collapse);
            d.children = null;
        }
    }

    function expand(d) {
        if (d._children) {
            d.children = d._children;
            d.children.forEach(expand);
            d._children = null;
        }
    }

    var overCircle = function(d) {
        selectedNode = d;
        updateTempConnector();
    };
    var outCircle = function(d) {
        selectedNode = null;
        updateTempConnector();
    };

    // Function to update the temporary connector indicating dragging affiliation
    var updateTempConnector = function() {
        var data = [];
        if (draggingNode !== null && selectedNode !== null) {
            // have to flip the source coordinates since we did this for the existing connectors on the original tree
            data = [{
                source: {
                    x: selectedNode.y0,
                    y: selectedNode.x0
                },
                target: {
                    x: draggingNode.y0,
                    y: draggingNode.x0
                }
            }];
        }
        var link = svgGroup.selectAll(".templink").data(data);

        link.enter().append("path")
            .attr("class", "templink")
            .attr("d", d3.svg.diagonal())
            .attr('pointer-events', 'none');

        link.attr("d", d3.svg.diagonal());

        link.exit().remove();
    };

    // Function to center node when clicked/dropped so node doesn't get lost when collapsing/moving with large amount of children.

    function centerNode(source) {
        let scale = zoomListener.scale();
        let x = -source.y0;
        let y = -source.x0;
        x = x * scale + viewerWidth / 2;
        y = y * scale + viewerHeight / 2;
        d3.select('g').transition()
            .duration(duration)
            .attr("transform", "translate(" + x + "," + y + ")scale(" + scale + ")");
        zoomListener.scale(scale);
        zoomListener.translate([x, y]);
    }

   // Define a context (popup) menu
  var menu = [{
    title: "Rename",
    action: function(elm, d, i) {
      var result = prompt('Change the name of the node', d.name);
      if (result) {
        temp = d.name;
        d.name = result;
        update(root);
        centerNode(d);
      }
console.log('Renamed node name "' + temp + '" to "' + result + '"');
    }
  }, {
    title: 'Add a node',
    action: function(elm, d, i) {
      newNodeName = newNodeBase + parseInt(Math.round(10000*Math.random()));
      var newNode = {"name": newNodeName,
        "nodeNo": nodeNoMax,
        "value": newNodeValue,
        "status": newNodeStatus,
        "type": newNodeType,
        "mainRoot": root.name,
        "nodeBefore": d.name,
        "linkWidth": 15,
        "children": []
//        "parent":d
      };

/*
      if (!d.children && !d._children)
        {
//            d3.json("http://xxxx:2222/getChildNodes", function(error,response) {
//          d.children.forEach(function(child){
            if (!tree.nodes(d)[0]._children){
              tree.nodes(d)[0]._children = [];
            }
            d.children[0].x = d.x0;
            d.children[0].y = d.y0;
            tree.nodes(d)[0]._children.push(newNode);
//          });
          if (d.children) {
            d._children = d.children;
            d.children = null;
          }
          else {
            d.children = d._children;
            d._children = null;
          }
          update(d);
//            });
        }
      if (d.children) {
        d._children = d.children;
        d.children = null;
      }
      else {
        d.children = d._children;
        d._children = null;
      }
*/


//Last working?
      var currentNode = tree.nodes(d);
//      var currentNode = _.where(d.parent.children, {name: d.name});
      //var myJSONObject = {"name": "new Node","children": []};
console.log("currentNode=");
console.log(currentNode);

//  if (currentNode.children) curentNode.children.push(newNode); else currentNode.children = [newNode];
//  nodes.push(newNode);
//*
      if (currentNode[0]._children!=null) {
//window.alert("currentNode[0]._children!=null");
        currentNode[0]._children.push(newNode);
console.log("_children != null");
console.log(currentNode[0]._children);
        d.children = d._children;
        d._children = null;
      }
      else if (currentNode[0].children!=null && currentNode[0]._children!=null) {
//window.alert("currentNode[0]._children!=null && currentNode[0]._children!=null");
       currentNode[0].children.push(newNode);
console.log("(_)children != null");
console.log(currentNode[0].children);
      }
      else {
//window.alert("else");
        currentNode[0].children=[]; // erases previous children!
        currentNode[0].children.push(newNode);
        currentNode[0].children.x = d.x0;
        currentNode[0].children.y = d.y0;
console.log("children == null");
console.log(currentNode[0].children);
      };

      update(root);
      expand(currentNode);
      sortTree();

/*/
//console.log("Current node added children: " + currentNode[0].children[0].name);

/*
// other way tested, not working
      // repeating the code from moving the dragged node to other parent node ?
        var selectedNode = tree.nodes(d);
        if (typeof selectedNode.children !== 'undefined' || typeof selectedNode._children !== 'undefined') {
          if (typeof selectedNode.children !== 'undefined') {
            selectedNode.children.push(newNode);
          } else {
            selectedNode._children.push(newNode);
          }
        } else {
          selectedNode.children = [];
          selectedNode.children.push(newNode);
        }

        // Make sure that the node being added to is expanded so user can see added node is correctly moved
//        tree.links(selectedNode).push(selectedNode[selectedNode.length-1]);

//      bar1data = [[0,0],[0,0],[0,0]];
//      tree.links(currentNode).push(currentNode[currentNode.length-1]);
      update(root);
      expand(currentNode);
      sortTree();
*/
console.log('Inserted a new node to "' + d.name + '" with a node name "' + newNode.name + '"');
    }
  }, {
    title: 'Delete a node',
    action: function(elm, d, i) {
      delName = d.name;
      if (d.parent && d.parent.children){ // cannot delete a root
        var nodeToDelete = _.where(d.parent.children, {name: delName});
        if (nodeToDelete) {
          if (nodeToDelete[0].children!=null || nodeToDelete[0]._children!=null) {
            if (confirm('Deleting this node will delete all its children too! Proceed?')) {
              d.parent.children = _.without(d.parent.children, nodeToDelete[0]);
console.log('Deleted parent node "' + delName + '"');
              update(root);
            }
            else {
//console.log('Cancelled deleting the node "' + delName + '"');
            }
          }
          else {
            d.parent.children = _.without(d.parent.children, nodeToDelete[0]);
console.log('Deleted end node "' + delName + '"');
          }
        }
      }
//      bar1data = [[0,0],[0,0],[0,0]];
      update(root);
    }
  }];

    // Toggle children function

    function toggleChildren(d) {
        if (d.children) {
            d._children = d.children;
            d.children = null;
        } else if (d._children) {
            d.children = d._children;
            d._children = null;
        }
        return d;
    }

    // Toggle children on click.

    function click(d) {
        if (d3.event.defaultPrevented) return; // click suppressed
        d = toggleChildren(d);
        update(d);
        centerNode(d);
    }

    function update(source) {
        // Compute the new height, function counts total children of root node and sets tree height accordingly.
        // This prevents the layout looking squashed when new nodes are made visible or looking sparse when nodes are removed
        // This makes the layout more consistent.
        var levelWidth = [1];
        var childCount = function(level, n) {

            if (n.children && n.children.length > 0) {
                if (levelWidth.length <= level + 1) levelWidth.push(0);

                levelWidth[level + 1] += n.children.length;
                n.children.forEach(function(d) {
                    childCount(level + 1, d);
                });
            }
        };
        childCount(0, root);
        var newHeight = d3.max(levelWidth) * 25; // 25 pixels per line
        tree = tree.size([newHeight, viewerWidth]);

        // Compute the new tree layout.
        var nodes = tree.nodes(root).reverse(),
            links = tree.links(nodes);

        // Set widths between levels based on maxLabelLength.
        nodes.forEach(function(d) {
            d.y = (d.depth * (maxLabelLength * 10)); //maxLabelLength * 10px
            // alternatively to keep a fixed scale one can set a fixed depth per level
            // Normalize for fixed-depth by commenting out below line
            // d.y = (d.depth * 500); //500px per level.
        });

        // Update the nodes…
        let node = svgGroup.selectAll("g.node")
            .data(nodes, function(d) {
                return d.id || (d.id = ++i);
            });

        // Enter any new nodes at the parent's previous position.
        var nodeEnter = node.enter().append("g")
            .call(dragListener)
            .attr("class", "node")
            .attr("transform", function(d) {
                return "translate(" + source.y0 + "," + source.x0 + ")";
            })
            .on('click', click)
            .on("mouseover", mouseover)
            .on("mousemove", mousemove)
            .on("mouseleave", mouseleave);

          nodeEnter.append("circle")
              .attr('class', 'nodeCircle')
              .attr("r", 0)
              .style("fill", function(d) {
                  return d._children ? "lightsteelblue" : "#fff";
              })
            // .on('contextmenu', d3.contextMenu(menu));
	      // adding popup dialogue for changing/adding/deleting nodes to circles


        nodeEnter.append("a")
            .attr("xlink:href", function(d) { return d.url; })
            .attr("class", "clickable")
            .append("text")
            .attr("x", function(d) {
                return d.children || d._children ? -10 : 10;
            })
            .attr("dy", ".35em")
            .attr('class', 'nodeText')
            .attr("text-anchor", function(d) {
                return d.children || d._children ? "end" : "start";
            })
            .text(function(d) {
                return d.name;
            })
            .style("fill-opacity", 0)
            .attr("xlink:href", function(d) { return d.url; })
            // .on('contextmenu', d3.contextMenu(menu));
      // adding popup dialogue for changing/adding/deleting nodes for text captions too


        // phantom node to give us mouseover in a radius around it
        nodeEnter.append("circle")
            .attr('class', 'ghostCircle')
            .attr("r", 30)
            .attr("opacity", 0.2) // change this to zero to hide the target area
        .style("fill", "red")
            .attr('pointer-events', 'mouseover')
            .on("mouseover", function(node) {
                overCircle(node);
            })
            .on("mouseout", function(node) {
                outCircle(node);
            });

        // Update the text to reflect whether node has children or not.
        node.select('text')
            .attr("x", function(d) {
                return d.children || d._children ? -10 : 10;
            })
            .attr("text-anchor", function(d) {
                return d.children || d._children ? "end" : "start";
            })
            .text(function(d) {
                return d.name;
            });

        // Change the circle fill depending on whether it has children and is collapsed
        node.select("circle.nodeCircle")
            .attr("r", 4.5)
            .style("fill", function(d) {
                return d._children ? "lightsteelblue" : "#fff";
            });

        // Transition nodes to their new position.
        var nodeUpdate = node.transition()
            .duration(duration)
            .attr("transform", function(d) {
                return "translate(" + d.y + "," + d.x + ")";
            });

        // Fade the text in
        nodeUpdate.select("text")
            .style("fill-opacity", 1);

        // Transition exiting nodes to the parent's new position.
        var nodeExit = node.exit().transition()
            .duration(duration)
            .attr("transform", function(d) {
                return "translate(" + source.y + "," + source.x + ")";
            })
            .remove();

        nodeExit.select("circle")
            .attr("r", 0);

        nodeExit.select("text")
            .style("fill-opacity", 0);

        // Update the links…
        var link = svgGroup.selectAll("path.link")
            .data(links, function(d) {
                return d.target.id;
            });

        // Enter any new links at the parent's previous position.
        link.enter().insert("path", "g")
            .attr("class", "link")
            .attr("d", function(d) {
                var o = {
                    x: source.x0,
                    y: source.y0
                };
                return diagonal({
                    source: o,
                    target: o
                });
            });

        // Transition links to their new position.
        link.transition()
            .duration(duration)
            .attr("d", diagonal);

        // Transition exiting nodes to the parent's new position.
        link.exit().transition()
            .duration(duration)
            .attr("d", function(d) {
                var o = {
                    x: source.x,
                    y: source.y
                };
                return diagonal({
                    source: o,
                    target: o
                });
            })
            .remove();

        // Stash the old positions for transition.
        nodes.forEach(function(d) {
            d.x0 = d.x;
            d.y0 = d.y;
        });
    }

    // Append a group which holds all nodes and which the zoom Listener can act upon.
    var svgGroup = baseSvg.append("g");

    // Define the root
    root = treeData;
    root.x0 = viewerHeight / 2;
    root.y0 = 0;

    console.log(root)

    // Layout the tree initially and center on the root node.
    update(root);
    centerNode(root);
  }
}
